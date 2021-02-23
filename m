Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD562322350
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 01:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhBWAy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 19:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBWAy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 19:54:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A75464DFD;
        Tue, 23 Feb 2021 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614041628;
        bh=eYASCVkvsEAQNvqw4jJT3tnUEiTvi9USzV7hr/jnoyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SNkQVjsTmPELEhcOvP5mTB2lHQpwsmouJEmgBfk5eGTfrAFYzkw/ILO91YqEhLdLB
         AnefUk8qPGwgy6l6YhdhQ43iQ8pthSC+OZl6znfY4HifomNQP19aPsmsYWJxsYl9Pf
         aGKJilSBX6/dMWYcH6UFdToU3CjvKQBREsqqtD0yJ41EJrj19GEj/I7YfyTLLlfNK9
         XBL4NwPjpqscLP9pzvnImk3N2R6FOWt+CeQnryqHlj0nYRZSp24wrM05BxqikPB1gK
         itf4pl3Aj7uLpG/fuNlayId8weBRkObvLGoV6Se81SvwP1hNzfFLuXtJZVTjlXHT5g
         kuEv1mrX+7yHA==
Date:   Mon, 22 Feb 2021 16:53:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tap: remove redundant assignments
Message-ID: <20210222165344.533bc87e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222145748.10496-1-tangbin@cmss.chinamobile.com>
References: <20210222145748.10496-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 22:57:48 +0800 Tang Bin wrote:
> In the function tap_get_user, the assignment of 'err' at both places
> is redundant, so remove one.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/tap.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 1f4bdd944..3e9c72738 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -625,7 +625,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  	struct tap_dev *tap;
>  	unsigned long total_len = iov_iter_count(from);
>  	unsigned long len = total_len;
> -	int err;
> +	int err = -EINVAL;
>  	struct virtio_net_hdr vnet_hdr = { 0 };
>  	int vnet_hdr_len = 0;
>  	int copylen = 0;
> @@ -636,7 +636,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  	if (q->flags & IFF_VNET_HDR) {
>  		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
>  
> -		err = -EINVAL;
>  		if (len < vnet_hdr_len)
>  			goto err;
>  		len -= vnet_hdr_len;
> @@ -657,7 +656,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>  			goto err;
>  	}
>  
> -	err = -EINVAL;
>  	if (unlikely(len < ETH_HLEN))
>  		goto err;
>  

Assigning err close to the gotos makes the code more robust and easier
to read. No applying this, sorry.
