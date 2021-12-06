Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7535B469261
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 10:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbhLFJck convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Dec 2021 04:32:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40299 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbhLFJck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 04:32:40 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 99C556000A;
        Mon,  6 Dec 2021 09:29:07 +0000 (UTC)
Date:   Mon, 6 Dec 2021 10:28:46 +0100
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
Subject: Re: [PATCH net-next v4 4/4] net: ocelot: add FDMA support
Message-ID: <20211206102846.40e4cbb9@fixe.home>
In-Reply-To: <20211204134342.7mhznmfh3x36nlxj@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
        <20211203171916.378735-5-clement.leger@bootlin.com>
        <20211204134342.7mhznmfh3x36nlxj@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, 4 Dec 2021 13:43:43 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Fri, Dec 03, 2021 at 06:19:16PM +0100, Clément Léger wrote:
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
> Doesn't look too bad. Did the page reuse make any difference to the
> throughput, or is the interaction with the FDMA extraction channel where
> the bottleneck is?

With a standard MTU, the results did not improved a lot... TCP RX add a
small improvement (~4MBit/s) but that is the only one.
Here are the new results with the FDMA:

TCP TX: 48.2 Mbits/sec
TCP RX: 60.9 Mbits/sec
UDP TX: 28.8 Mbits/sec
UDP RX: 18.8 Mbits/sec

In jumbo mode (9000 bytes frames), there is improvements:

TCP TX: 74.4 Mbits/sec
TCP RX: 109 Mbits/sec
UDP TX: 105 Mbits/sec
UDP RX: 51.6 Mbits/sec

> 
> > +	next_idx = ocelot_fdma_idx_next(tx_ring->next_to_use,
> > +					OCELOT_FDMA_TX_RING_SIZE);
> > +	/* If the FDMA TX chan is empty, then enqueue the DCB directly */
> > +	if (ocelot_fdma_tx_ring_empty(fdma)) {
> > +		dma = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, tx_ring->next_to_use);
> > +		ocelot_fdma_activate_chan(fdma, dma, MSCC_FDMA_INJ_CHAN);
> > +	} else {
> > +		/* Chain the DCBs */
> > +		dcb->llp = ocelot_fdma_idx_dma(tx_ring->dcbs_dma, next_idx);
> > +	}
> > +
> > +	tx_ring->next_to_use = next_idx;
> > +
> > +	skb_tx_timestamp(skb);  
> 
> Isn't it problematic to update tx_ring->next_to_use and skb_tx_timestamp
> after you've actually called ocelot_fdma_activate_chan()? This will race
> with ocelot_fdma_tx_cleanup().

Indeed, the timestamping should be done before sending it.

> 
> > +}
> > +void ocelot_fdma_init(struct platform_device *pdev, struct ocelot *ocelot)
> > +{
> > +	struct device *dev = ocelot->dev;
> > +	struct ocelot_fdma *fdma;
> > +	void __iomem *regs;
> > +	int ret;
> > +
> > +	regs = devm_platform_ioremap_resource_byname(pdev, "fdma");
> > +	if (IS_ERR_OR_NULL(regs))
> > +		return;  
> 
> Shouldn't this be an optional io_target inside mscc_ocelot_probe, like
> all the others are?

Yes, I could use that.

> > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > index 38103b0255b0..d737c680b424 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -18,6 +18,7 @@
> >  
> >  #include <soc/mscc/ocelot_vcap.h>
> >  #include <soc/mscc/ocelot_hsio.h>
> > +#include "ocelot_fdma.h"
> >  #include "ocelot.h"
> >    
> 
> Please rebase all your submissions to the current net-next/master, the
> following has been introduced here in the meantime, making this patch
> fail to apply:
> 
> #define VSC7514_VCAP_POLICER_BASE			128
> #define VSC7514_VCAP_POLICER_MAX			191
> 

Ok.

> >  static const u32 ocelot_ana_regmap[] = {
> > @@ -1080,6 +1081,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  		ocelot->targets[io_target[i].id] = target;
> >  	}
> >  
> > +	ocelot_fdma_init(pdev, ocelot);
> > +
> >  	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
> >  	if (IS_ERR(hsio)) {
> >  		dev_err(&pdev->dev, "missing hsio syscon\n");
> > @@ -1139,6 +1142,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  	if (err)
> >  		goto out_ocelot_devlink_unregister;
> >  
> > +	if (ocelot->fdma)
> > +		ocelot_fdma_start(ocelot);
> > +
> >  	err = ocelot_devlink_sb_register(ocelot);
> >  	if (err)
> >  		goto out_ocelot_release_ports;
> > @@ -1179,6 +1185,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
> >  {
> >  	struct ocelot *ocelot = platform_get_drvdata(pdev);
> >  
> > +	if (ocelot->fdma)
> > +		ocelot_fdma_deinit(ocelot);
> >  	devlink_unregister(ocelot->devlink);
> >  	ocelot_deinit_timestamp(ocelot);
> >  	ocelot_devlink_sb_unregister(ocelot);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 11c99fcfd341..2667a203e10f 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -692,6 +692,12 @@ struct ocelot {
> >  	/* Protects the PTP clock */
> >  	spinlock_t			ptp_clock_lock;
> >  	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
> > +
> > +	struct ocelot_fdma		*fdma;
> > +	/* Napi context used by FDMA. Needs to be in ocelot to avoid using a
> > +	 * backpointer in ocelot_fdma
> > +	 */
> > +	struct napi_struct		napi;  
> 
> Can it at least be dynamically allocated, and kept as a pointer here?

If it is dynamically allocated, then container_of can't be used anymore
in the napi poll function. I could move it back in struct fdma but
then, I would need a backpointer to ocelot in the fdma struct.
Or I could use napi->dev and access the ocelot_port_private to then get
the ocelot pointer but I have not seen much driver using the napi->dev
field. Tell me what you would like.

> 
> >  };
> >  
> >  struct ocelot_policer {
> > -- 
> > 2.34.1
>   



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
