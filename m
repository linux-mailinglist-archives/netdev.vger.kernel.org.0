Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076DC24B07D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHTHwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:52:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726723AbgHTHwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 03:52:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597909957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UofsnEJINhsLZveMoOdeZsh1+kYmfm7tCHhdeFiL1Kg=;
        b=cLxHqEj+KniKboG+2ZjdEHgOo4z3n4crEjR2D/y9r9HQoM2uYuEGCHoLYeMVgg7OO8FmQC
        xjN7xv+1w5DogRmLANDcIU1yVqIPX1ryERSGBx9rkpcW8BGk+z04SxJNQ4LzP+TTNDmoLT
        GJzHzsIUDaQv+D75ttGkM4RP0Tdpw/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-oGjafM6mPxyBZsJ-RQGhJQ-1; Thu, 20 Aug 2020 03:52:35 -0400
X-MC-Unique: oGjafM6mPxyBZsJ-RQGhJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E9D186A56F;
        Thu, 20 Aug 2020 07:52:34 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F7285DA30;
        Thu, 20 Aug 2020 07:52:23 +0000 (UTC)
Date:   Thu, 20 Aug 2020 09:52:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next 4/6] xdp: add multi-buff support to
 xdp_return_{buff/frame}
Message-ID: <20200820095222.711ccfa7@carbon>
In-Reply-To: <7ff49193140f3cb5341732612c72bcc2c5fb3372.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
        <7ff49193140f3cb5341732612c72bcc2c5fb3372.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 15:13:49 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 884f140fc3be..006b24b5d276 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -370,19 +370,55 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
>  
>  void xdp_return_frame(struct xdp_frame *xdpf)
>  {
> +	struct skb_shared_info *sinfo;
> +	int i;
> +
>  	__xdp_return(xdpf->data, &xdpf->mem, false);

There is a use-after-free race here.  The xdpf->data contains the
shared_info (xdp_get_shared_info_from_frame(xdpf)). Thus you cannot
free/return the page and use this data area below.

> +	if (!xdpf->mb)
> +		return;
> +
> +	sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	for (i = 0; i < sinfo->nr_frags; i++) {
> +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdpf->mem, false);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame);
>  
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  {
> +	struct skb_shared_info *sinfo;
> +	int i;
> +
>  	__xdp_return(xdpf->data, &xdpf->mem, true);

Same issue.

> +	if (!xdpf->mb)
> +		return;
> +
> +	sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	for (i = 0; i < sinfo->nr_frags; i++) {
> +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdpf->mem, true);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
> +	struct skb_shared_info *sinfo;
> +	int i;
> +
>  	__xdp_return(xdp->data, &xdp->rxq->mem, true);

Same issue.

> +	if (!xdp->mb)
> +		return;
> +
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +	for (i = 0; i < sinfo->nr_frags; i++) {
> +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> +
> +		__xdp_return(page_address(page), &xdp->rxq->mem, true);
> +	}
>  }



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

