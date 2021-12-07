Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646DE46BF0C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhLGPUX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Dec 2021 10:20:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46593 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhLGPUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:20:22 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 1536C60002;
        Tue,  7 Dec 2021 15:16:46 +0000 (UTC)
Date:   Tue, 7 Dec 2021 16:16:24 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20211207161624.39565296@fixe.home>
In-Reply-To: <20211207135200.qvjaw6vkazfcmuvk@skbuf>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
        <20211207090853.308328-5-clement.leger@bootlin.com>
        <20211207135200.qvjaw6vkazfcmuvk@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 7 Dec 2021 13:52:01 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Tue, Dec 07, 2021 at 10:08:53AM +0100, Clément Léger wrote:
> > Ethernet frames can be extracted or injected autonomously to or from
> > the device’s DDR3/DDR3L memory and/or PCIe memory space. Linked list
> > data structures in memory are used for injecting or extracting Ethernet
> > frames. The FDMA generates interrupts when frame extraction or
> > injection is done and when the linked lists need updating.
> >
> > The FDMA is shared between all the ethernet ports of the switch and
> > uses a linked list of descriptors (DCB) to inject and extract packets.
> > Before adding descriptors, the FDMA channels must be stopped. It would
> > be inefficient to do that each time a descriptor would be added so the
> > channels are restarted only once they stopped.
> >
> > Both channels uses ring-like structure to feed the DCBs to the FDMA.
> > head and tail are never touched by hardware and are completely handled
> > by the driver. On top of that, page recycling has been added and is
> > mostly taken from gianfar driver.
> >
> > Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > ---  
> 
> > +static void ocelot_fdma_send_skb(struct ocelot *ocelot,
> > +				 struct ocelot_fdma *fdma, struct sk_buff *skb)
> > +{
> > +	struct ocelot_fdma_tx_ring *tx_ring = &fdma->tx_ring;
> > +	struct ocelot_fdma_tx_buf *tx_buf;
> > +	struct ocelot_fdma_dcb *dcb;
> > +	dma_addr_t dma;
> > +	u16 next_idx;
> > +
> > +	dcb = &tx_ring->dcbs[tx_ring->next_to_use];
> > +	tx_buf = &tx_ring->bufs[tx_ring->next_to_use];
> > +	if (!ocelot_fdma_tx_dcb_set_skb(ocelot, tx_buf, dcb, skb)) {
> > +		dev_kfree_skb_any(skb);
> > +		return;
> > +	}
> > +
> > +	next_idx = ocelot_fdma_idx_next(tx_ring->next_to_use,
> > +					OCELOT_FDMA_TX_RING_SIZE);
> > +	/* If the FDMA TX chan is empty, then enqueue the DCB directly */
> > +	if (ocelot_fdma_tx_ring_empty(fdma)) {
> > +		dma = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, tx_ring->next_to_use);
> > +		ocelot_fdma_activate_chan(ocelot, dma, MSCC_FDMA_INJ_CHAN);
> > +	} else {
> > +		/* Chain the DCBs */
> > +		dcb->llp = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, next_idx);
> > +	}
> > +	skb_tx_timestamp(skb);
> > +
> > +	tx_ring->next_to_use = next_idx;  
> 
> You've decided against moving these before ocelot_fdma_activate_chan?
> The skb may be freed by ocelot_fdma_tx_cleanup() before
> skb_tx_timestamp() has a chance to run, is this not true?

Since tx_ring->next_to_use is updated after calling skb_tx_timestamp,
fdma_tx_cleanup will not free it. However, I'm not sure if the
timestamping should be done before being sent by the hardware (ie, does
the timestamping function modifies the SKB inplace). If not, then the
current code is ok. By looking at ocelot_port_inject_frame, the
timestamping is done after sending the frame.

> 
> > +}
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > index cd3eb101f159..bee883a0b5b8 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -18,6 +18,7 @@
> >
> >  #include <soc/mscc/ocelot_vcap.h>
> >  #include <soc/mscc/ocelot_hsio.h>
> > +#include "ocelot_fdma.h"
> >  #include "ocelot.h"
> >
> >  #define VSC7514_VCAP_POLICER_BASE			128
> > @@ -275,6 +276,18 @@ static const u32 ocelot_ptp_regmap[] = {
> >  	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
> >  };
> >
> > +static const u32 ocelot_fdma_regmap[] = {
> > +	REG(PTP_PIN_CFG,				0x000000),
> > +	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
> > +	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
> > +	REG(PTP_PIN_TOD_NSEC,				0x00000c),
> > +	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
> > +	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
> > +	REG(PTP_CFG_MISC,				0x0000a0),
> > +	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
> > +	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
> > +};  
> 
> drivers/net/ethernet/mscc/ocelot_vsc7514.c:279:18: warning: ‘ocelot_fdma_regmap’ defined but not used [-Wunused-const-variable=]
>   279 | static const u32 ocelot_fdma_regmap[] = {
>       |                  ^~~~~~~~~~~~~~~~~~
> 
> Not to mention this isn't even the FDMA regmap.

This is a huge mistake on my side. Sorry.

> 
> > +
> >  static const u32 ocelot_dev_gmii_regmap[] = {
> >  	REG(DEV_CLOCK_CFG,				0x0),
> >  	REG(DEV_PORT_MISC,				0x4),
> > @@ -1048,6 +1061,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  		{ S1, "s1" },
> >  		{ S2, "s2" },
> >  		{ PTP, "ptp", 1 },
> > +		{ FDMA, "fdma", 1 },
> >  	}  



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
