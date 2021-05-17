Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13273831AD
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbhEQOjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:39:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240959AbhEQOgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 10:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+etklaO9vkFUBnNppWvW4wT/pFgZKsFAvZPj7+HIov0=; b=zpD4UKF6csA6gWp48EJrtM/Jcv
        pr7Ed12Me36Es1mhkIPUQI9CBD7Sqd6mSIVYVSGi4JtlVUhHPk+SPqr9NxuKQqsIUg4vi4+ynw3Ix
        AEGn9kD+0a4htguaZTizw+/0CSrCsLhA+setHgH0Fm4heqTWKbybbmOQVAzf+DhTgPj8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lieL2-004ZSU-Np; Mon, 17 May 2021 16:35:20 +0200
Date:   Mon, 17 May 2021 16:35:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Use BUG_ON instead of if condition followed
 by BUG
Message-ID: <YKJ/KPtw5Xcjsea+@lunn.ch>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 09:31:19PM +0800, Xianting Tian wrote:
> BUG_ON() uses unlikely in if(), which can be optimized at compile time.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c921ebf3ae82..212d52204884 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct
> sk_buff *skb)
>  	else
>  		hdr = skb_vnet_hdr(skb);
> 
> -	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,

How fatal is it not being able to get the header from the skb? There
has been push back on the use of BUG() or its variants, since it kills
the machine dead. Would it be possible to turn this into a WARN_ON and
return -EPROTO or something?

       Andrew
