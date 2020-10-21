Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157242951E8
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409410AbgJUR7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391484AbgJUR7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 13:59:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B092098B;
        Wed, 21 Oct 2020 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603303175;
        bh=iLacT0QkMnamwhZDWEufR1kZCKUgqHCZEntyFZ4IygE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DCrSlELP4WrzT3T64xUYd5onWfeOSM1ySGLzqgOR+B2ZloGlNpBfQfB3kbQqq84Or
         o7OxJHMuBQBMjt4nXlSasSW47a13dlMSMU86G0LGQgFTj+sC8NFkn9ngdnWI6ulpbW
         XFGdssXLiMt+zYmN5x0GBkQYaLk4cs34HiuZisa4=
Date:   Wed, 21 Oct 2020 10:59:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        james.jurack@ametek.com
Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Message-ID: <20201021105933.2cfa7176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020173605.1173-1-claudiu.manoil@nxp.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201020173605.1173-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 20:36:05 +0300 Claudiu Manoil wrote:
> When PTP timestamping is enabled on Tx, the controller
> inserts the Tx timestamp at the beginning of the frame
> buffer, between SFD and the L2 frame header. This means
> that the skb provided by the stack is required to have
> enough headroom otherwise a new skb needs to be created
> by the driver to accommodate the timestamp inserted by h/w.
> Up until now the driver was relying on the second option,
> using skb_realloc_headroom() to create a new skb to accommodate
> PTP frames. Turns out that this method is not reliable, as
> reallocation of skbs for PTP frames along with the required
> overhead (skb_set_owner_w, consume_skb) is causing random
> crashes in subsequent skb_*() calls, when multiple concurrent
> TCP streams are run at the same time on the same device
> (as seen in James' report).
> Note that these crashes don't occur with a single TCP stream,
> nor with multiple concurrent UDP streams, but only when multiple
> TCP streams are run concurrently with the PTP packet flow
> (doing skb reallocation).
> This patch enforces the first method, by requesting enough
> headroom from the stack to accommodate PTP frames, and so avoiding
> skb_realloc_headroom() & co, and the crashes no longer occur.
> There's no reason not to set needed_headroom to a large enough
> value to accommodate PTP frames, so in this regard this patch
> is a fix.
> 
> Reported-by: James Jurack <james.jurack@ametek.com>
> Fixes: bee9e58c9e98 ("gianfar:don't add FCB length to hard_header_len")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/gianfar.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 41dd3d0f3452..d0842c2c88f3 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -3380,7 +3380,7 @@ static int gfar_probe(struct platform_device *ofdev)
>  
>  	if (dev->features & NETIF_F_IP_CSUM ||
>  	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
> -		dev->needed_headroom = GMAC_FCB_LEN;
> +		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
>  
>  	/* Initializing some of the rx/tx queue level parameters */
>  	for (i = 0; i < priv->num_tx_queues; i++) {

Claudiu, I think this may be papering over the real issue.
needed_headroom is best effort, if you were seeing crashes
the missing checks for skb being the right geometry are still
out there, they just not get hit in the case needed_headroom 
is respected.

So updating needed_headroom is definitely fine, but the cause of
crashes has to be found first.
