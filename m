Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B83B2DA25B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503646AbgLNVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503643AbgLNVJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 16:09:15 -0500
Date:   Mon, 14 Dec 2020 13:08:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607980115;
        bh=oJ27S4rXf3axNcP3I2hRPI6vvzuXz2pgxoYgd3q43CE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=rxoyujSyScMV6kejxAqO2iQfCAr8Kygj+g7tlUqAtjcWj/LenSSQHYoHArSyc3Gbn
         MVdUkWwHyvbhP49G42xAU7vkrGzbJ09HPdEV5VYilMH3RBJJ3ewpTIzx9ORfPytXsf
         +oP7SFcEC4uv0JtLcVHMjhuWmjywKFVxMbc5ozl49ZRYMpWzcIyrpsch6z0myA+i8S
         7D4P1X3NeAeNkITvD9O/clGyWBReX3Isb9WvdyZvCxSxH8ctuwj7NoSNW/umI0eNiK
         6eujU3cdvFddrZNNrWxStOS6zQ8pphrTnSxEDv6GgOV2yUQek4v9jVyxv5xTqiOiig
         wTzVKyzH1xY2Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [PATCH] net: korina: remove busy skb free
Message-ID: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
References: <20201213172052.12433-1-vincent.stehle@laposte.net>
        <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 11:03:12 +0100 Julian Wiedmann wrote:
> > diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> > index bf48f0ded9c7d..9d84191de6824 100644
> > --- a/drivers/net/ethernet/korina.c
> > +++ b/drivers/net/ethernet/korina.c
> > @@ -216,7 +216,6 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
> >  			netif_stop_queue(dev);
> >  		else {
> >  			dev->stats.tx_dropped++;
> > -			dev_kfree_skb_any(skb);
> >  			spin_unlock_irqrestore(&lp->lock, flags);
> >  
> >  			return NETDEV_TX_BUSY;
> >   
> 
> As this skb is returned to the stack (and not dropped), the tx_dropped
> statistics increment looks bogus too.

Since this is clearly an ugly use after free, and nobody complained we
can assume that the driver correctly stops its TX queue ahead of time.
So perhaps we can change the return value to NETDEV_TX_OK instead.
