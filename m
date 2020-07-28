Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCC230F3B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgG1Q2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731263AbgG1Q2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D75852074F;
        Tue, 28 Jul 2020 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595953713;
        bh=+aUAj1trONw//4CVYwoXpROBrl8LUAigyM3ds6guz3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aQUilzvUM7jk8786jxsRei8OebvXIsXnAllq63fH/igkKSriOOm6iB2Show6xdiPu
         p9H75/pZOOlynDz7hjqzUzr0Rgb4l19q+RhZJmiEqi2F6UxmJELLKQgK1jrT8897TM
         NX/YS1zlrZ76irPAJwJCxKvZplxkFDrK+LMWdgpQ=
Date:   Tue, 28 Jul 2020 18:28:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 11/21] core/skbuff: add page recycling logic for
 netgpu pages
Message-ID: <20200728162825.GC4181352@kroah.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-12-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727224444.2987641-12-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:44:34PM -0700, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> netgpu pages will always have a refcount of at least one (held by
> the netgpu module).  If the skb is marked as containing netgpu ZC
> pages, recycle them back to netgpu.

What???

> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/core/skbuff.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1422b99b7090..50dbb7ce1965 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -591,6 +591,27 @@ static void skb_free_head(struct sk_buff *skb)
>  		kfree(head);
>  }
>  
> +#if IS_ENABLED(CONFIG_NETGPU)
> +static void skb_netgpu_unref(struct skb_shared_info *shinfo)
> +{
> +	struct netgpu_ifq *ifq = shinfo->destructor_arg;
> +	struct page *page;
> +	int i;
> +
> +	/* pages attached for skbs for TX shouldn't come here, since
> +	 * the skb is not marked as "zc_netgpu". (only RX skbs have this).
> +	 * dummy page does come here, but always has elevated refc.
> +	 *
> +	 * Undelivered zc skb's will arrive at this point.
> +	 */
> +	for (i = 0; i < shinfo->nr_frags; i++) {
> +		page = skb_frag_page(&shinfo->frags[i]);
> +		if (page && page_ref_dec_return(page) <= 2)
> +			netgpu_put_page(ifq, page, false);
> +	}
> +}
> +#endif

Becides the basic "no #if in C files" issue here, why is this correct?

> +
>  static void skb_release_data(struct sk_buff *skb)
>  {
>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
> @@ -601,8 +622,15 @@ static void skb_release_data(struct sk_buff *skb)
>  			      &shinfo->dataref))
>  		return;
>  
> -	for (i = 0; i < shinfo->nr_frags; i++)
> -		__skb_frag_unref(&shinfo->frags[i]);
> +#if IS_ENABLED(CONFIG_NETGPU)
> +	if (skb->zc_netgpu && shinfo->nr_frags) {
> +		skb_netgpu_unref(shinfo);
> +	} else
> +#endif
> +	{
> +		for (i = 0; i < shinfo->nr_frags; i++)
> +			__skb_frag_unref(&shinfo->frags[i]);
> +	}

Again, no #if in C code.  But even then, this feels really really wrong.

greg k-h
