Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845B946BF5B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbhLGPfG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Dec 2021 10:35:06 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:40869 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhLGPfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:35:05 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 191CCFF802;
        Tue,  7 Dec 2021 15:31:30 +0000 (UTC)
Date:   Tue, 7 Dec 2021 16:31:08 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Message-ID: <20211207163108.3a264f81@fixe.home>
In-Reply-To: <20211207152347.hnlhja52qeolq7pt@skbuf>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
        <20211207090853.308328-5-clement.leger@bootlin.com>
        <20211207135200.qvjaw6vkazfcmuvk@skbuf>
        <20211207161624.39565296@fixe.home>
        <20211207152347.hnlhja52qeolq7pt@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 7 Dec 2021 15:23:48 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Tue, Dec 07, 2021 at 04:16:24PM +0100, Clément Léger wrote:
> > Le Tue, 7 Dec 2021 13:52:01 +0000,
> > Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :
> >   
> > > On Tue, Dec 07, 2021 at 10:08:53AM +0100, Clément Léger wrote:  
> > > > Ethernet frames can be extracted or injected autonomously to or from
> > > > the device’s DDR3/DDR3L memory and/or PCIe memory space. Linked list
> > > > data structures in memory are used for injecting or extracting Ethernet
> > > > frames. The FDMA generates interrupts when frame extraction or
> > > > injection is done and when the linked lists need updating.
> > > >
> > > > The FDMA is shared between all the ethernet ports of the switch and
> > > > uses a linked list of descriptors (DCB) to inject and extract packets.
> > > > Before adding descriptors, the FDMA channels must be stopped. It would
> > > > be inefficient to do that each time a descriptor would be added so the
> > > > channels are restarted only once they stopped.
> > > >
> > > > Both channels uses ring-like structure to feed the DCBs to the FDMA.
> > > > head and tail are never touched by hardware and are completely handled
> > > > by the driver. On top of that, page recycling has been added and is
> > > > mostly taken from gianfar driver.
> > > >
> > > > Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > > > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > > > ---    
> > >   
> > > > +static void ocelot_fdma_send_skb(struct ocelot *ocelot,
> > > > +				 struct ocelot_fdma *fdma, struct sk_buff *skb)
> > > > +{
> > > > +	struct ocelot_fdma_tx_ring *tx_ring = &fdma->tx_ring;
> > > > +	struct ocelot_fdma_tx_buf *tx_buf;
> > > > +	struct ocelot_fdma_dcb *dcb;
> > > > +	dma_addr_t dma;
> > > > +	u16 next_idx;
> > > > +
> > > > +	dcb = &tx_ring->dcbs[tx_ring->next_to_use];
> > > > +	tx_buf = &tx_ring->bufs[tx_ring->next_to_use];
> > > > +	if (!ocelot_fdma_tx_dcb_set_skb(ocelot, tx_buf, dcb, skb)) {
> > > > +		dev_kfree_skb_any(skb);
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	next_idx = ocelot_fdma_idx_next(tx_ring->next_to_use,
> > > > +					OCELOT_FDMA_TX_RING_SIZE);
> > > > +	/* If the FDMA TX chan is empty, then enqueue the DCB directly */
> > > > +	if (ocelot_fdma_tx_ring_empty(fdma)) {
> > > > +		dma = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, tx_ring->next_to_use);
> > > > +		ocelot_fdma_activate_chan(ocelot, dma, MSCC_FDMA_INJ_CHAN);
> > > > +	} else {
> > > > +		/* Chain the DCBs */
> > > > +		dcb->llp = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, next_idx);
> > > > +	}
> > > > +	skb_tx_timestamp(skb);
> > > > +
> > > > +	tx_ring->next_to_use = next_idx;    
> > > 
> > > You've decided against moving these before ocelot_fdma_activate_chan?
> > > The skb may be freed by ocelot_fdma_tx_cleanup() before
> > > skb_tx_timestamp() has a chance to run, is this not true?  
> > 
> > Since tx_ring->next_to_use is updated after calling skb_tx_timestamp,
> > fdma_tx_cleanup will not free it. However, I'm not sure if the
> > timestamping should be done before being sent by the hardware (ie, does
> > the timestamping function modifies the SKB inplace). If not, then the
> > current code is ok. By looking at ocelot_port_inject_frame, the
> > timestamping is done after sending the frame.  
> 
> It looks like we may need Richard for an expert opinon.
> Documentation/networking/timestamping.rst only says:
> 
> | Driver should call skb_tx_timestamp() as close to passing sk_buff to hardware
> | as possible.
> 
> not whether it must be done before or it can be done after too;
> but my intuition says that is also needs to be strictly _before_ the
> hardware xmit, otherwise it also races with the hardware TX timestamping
> path and that may lead to issues of its own (the logic whether to
> deliver a software and/or a hardware timestamp to the socket is not
> trivial at all).

Ok, I will move it before sending since it since it is cleaner anyway.
And probably submit a fix for the register-based injection path later.

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
