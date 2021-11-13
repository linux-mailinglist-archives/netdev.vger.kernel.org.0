Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0D44F3F5
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 16:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhKMPhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 10:37:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhKMPhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Nov 2021 10:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m/VPwTzIcUamU0kbv8QB/cFesCTqMC4F5Df7zmeye+c=; b=4GsTtK0PrJ2WsG7s8nD9R4R+c3
        kPZsNka/L9w891OWL8XZWifwMQduur258iy+J19u2XtAOL7Vz4XeHbViFMKWaOnFFaVNvzWj5968Z
        YAgLyDYs+/bPL9Z0KTHzOlLUYIwvFhar1tnnP5sBwXxtvbfRwtHf+8HvSF4ctfqsl5YI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mlv3K-00DLR0-6P; Sat, 13 Nov 2021 16:34:50 +0100
Date:   Sat, 13 Nov 2021 16:34:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Denis Kirjanov <dkirjanov@suse.de>, Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YY/bGkVEKLS75sU0@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <cba74b41-7159-60e5-ec1f-007b27e72b22@suse.de>
 <07c59ab058a746c694b1c3a746525009@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c59ab058a746c694b1c3a746525009@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +//define MAC interrupt status bit
> > please embrace all comments with /* */
> 
> Do you mean to modify comment, for example,
> 
> //define MAC interrupt status bit
> 
> to 
> 
> /* define MAC interrupt status bit */

Yes. The Kernel is written in C, so C style comments are preferred
over C++ comments, even if later versions of the C standard allow C++
style comments.

You should also read the netdev FAQ, which makes some specific
comments about how multi-line comments should be formatted.

> Yes, I'll add error check in next patch as shown below:
> 
> 		rx_skbinfo[j].mapping = dma_map_single(&comm->pdev->dev, skb->data,
> 						       comm->rx_desc_buff_size,
> 						       DMA_FROM_DEVICE);
> 		if (dma_mapping_error(&comm->pdev->dev, rx_skbinfo[j].mapping))
> 			goto mem_alloc_fail;

If it is clear how to fix the code, just do it. No need to tell us
what you are going to do, we will see the change when reviewing the
next version.

> > > +/* Transmit a packet (called by the kernel) */
> > > +static int ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> > > +{
> > > +	struct sp_mac *mac = netdev_priv(ndev);
> > > +	struct sp_common *comm = mac->comm;
> > > +	u32 tx_pos;
> > > +	u32 cmd1;
> > > +	u32 cmd2;
> > > +	struct mac_desc *txdesc;
> > > +	struct skb_info *skbinfo;
> > > +	unsigned long flags;
> > > +
> > > +	if (unlikely(comm->tx_desc_full == 1)) {
> > > +		// No TX descriptors left. Wait for tx interrupt.
> > > +		netdev_info(ndev, "TX descriptor queue full when xmit!\n");
> > > +		return NETDEV_TX_BUSY;
> > Do you really have to return NETDEV_TX_BUSY?
> 
> (tx_desc_full == 1) means there is no TX descriptor left in ring buffer.
> So there is no way to do new transmit. Return 'busy' directly.
> I am not sure if this is a correct process or not.
> Could you please teach is there any other way to take care of this case?
> Drop directly?
 
There are a few hundred examples to follow, other MAC drivers. What do
they do when out of TX buffers? Find the most common pattern, and
follow it.

You should also thinking about the netdev_info(). Do you really want
to spam the kernel log? Say you are connected to a 10/Half link, and
the application is trying to send UDP at 100Mbps, Won't you see a lot
of these messages? change it to _debug(), or rate limit it.

> static void ethernet_tx_timeout(struct net_device *ndev, unsigned int txqueue)
> {
> 	struct sp_mac *mac = netdev_priv(ndev);
> 	struct net_device *ndev2;
> 	unsigned long flags;
> 
> 	netdev_err(ndev, "TX timed out!\n");
> 	ndev->stats.tx_errors++;
> 
> 	spin_lock_irqsave(&mac->comm->tx_lock, flags);
> 	netif_stop_queue(ndev);
> 	ndev2 = mac->next_ndev;
> 	if (ndev2)
> 		netif_stop_queue(ndev2);
> 
> 	hal_mac_stop(mac);
> 	hal_mac_init(mac);
> 	hal_mac_start(mac);
> 
> 	// Accept TX packets again.
> 	netif_trans_update(ndev);
> 	netif_wake_queue(ndev);
> 	if (ndev2) {
> 		netif_trans_update(ndev2);
> 		netif_wake_queue(ndev2);
> 	}
> 
> 	spin_unlock_irqrestore(&mac->comm->tx_lock, flags);
> }
> 
> Is that ok?

This ndev2 stuff is not nice. You probably need a cleaner abstract of
two netdev's sharing one TX and RX ring. See if there are any other
switchdev drivers with a similar structure you can copy. Maybe
cpsw_new.c? But be careful with that driver. cpsw is a bit of a mess
due to an incorrect initial design with respect to its L2 switch. A
lot of my initial comments are to stop you making the same mistakes.

    Andrew
