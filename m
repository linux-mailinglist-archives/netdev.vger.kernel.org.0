Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683B613B126
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgANRlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:41:51 -0500
Received: from foss.arm.com ([217.140.110.172]:55684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANRlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 12:41:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D5301396;
        Tue, 14 Jan 2020 09:41:48 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C8493F68E;
        Tue, 14 Jan 2020 09:41:47 -0800 (PST)
Date:   Tue, 14 Jan 2020 17:41:44 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
Message-ID: <20200114174144.6e8c6387@donnerap.cambridge.arm.com>
In-Reply-To: <CH2PR02MB70006450DBDCEC27CA76503AC7340@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
        <20200110115415.75683-13-andre.przywara@arm.com>
        <CH2PR02MB70006450DBDCEC27CA76503AC7340@CH2PR02MB7000.namprd02.prod.outlook.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 17:03:41 +0000
Radhey Shyam Pandey <radheys@xilinx.com> wrote:

Hi,

> > -----Original Message-----
> > From: Andre Przywara <andre.przywara@arm.com>
> > Sent: Friday, January 10, 2020 5:24 PM
> > To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> > <radheys@xilinx.com>
> > Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> > <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH 12/14] net: axienet: Autodetect 64-bit DMA capability
> > 
> > When newer revisions of the Axienet IP are configured for a 64-bit bus,  
> I assume in design axidma address width is set to 64-bits. 

So I wrote "64-bit bus" here, but really meant: "address bus wider than 32 bits". In our case it's set to 40 bits, because that's how wide the other busses in the system are.
And we have memory from 2GB to 4GB, and from 34GB till 40GB, but not in-between (VExpress/Juno memory layout).

> If not, please provide an overview of the design connections.

The exact parameter name from PG021 is: "Address Width (32-64) / c_addr_width".

> > we *need* to write to the MSB part of the an address registers,
> > otherwise the IP won't recognise this as a DMA start condition.
> > This is even true when the actual DMA address comes from the lower 4 GB.
> > 
> > To autodetect this configuration, at probe time we write all 1's to such  
> Is reading address width axidma IP user parameter(c_addr_width) from
> the design not sufficient to detect configured bus width?

What do you mean by that? Reading from where? Is there a way to access those parameters from a running system?

Cheers,
Andre.

> > an MSB register, and see if any bits stick. If this is configured for a
> > 32-bit bus, those MSB registers are RES0, so reading back 0 indicates
> > that no MSB writes are necessary.
> > On the other hands reading anything other than 0 indicated the need to
> > write the MSB registers, so we set the respective flag.
> > 
> > For now this leaves the actual DMA mask at 32-bit, as we can't reliably
> > detect the actually wired number of address lines beyond 32.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  1 +
> >  .../net/ethernet/xilinx/xilinx_axienet_main.c | 27 +++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > index 4aea4c23d3bb..4feaaa02819c 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> > @@ -161,6 +161,7 @@
> >  #define XAE_FCC_OFFSET		0x0000040C /* Flow Control
> > Configuration */
> >  #define XAE_EMMC_OFFSET		0x00000410 /* EMAC mode
> > configuration */
> >  #define XAE_PHYC_OFFSET		0x00000414 /* RGMII/SGMII
> > configuration */
> > +#define XAE_ID_OFFSET		0x000004F8 /* Identification register
> > */
> >  #define XAE_MDIO_MC_OFFSET	0x00000500 /* MII Management
> > Config */
> >  #define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management
> > Control */
> >  #define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write
> > Data */
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > index 133f088d797e..f7f593df0c11 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > @@ -151,6 +151,9 @@ static void axienet_dma_out_addr(struct axienet_local
> > *lp, off_t reg,
> >  				 dma_addr_t addr)
> >  {
> >  	axienet_dma_out32(lp, reg, lower_32_bits(addr));
> > +
> > +	if (lp->features & XAE_FEATURE_DMA_64BIT)
> > +		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
> >  }
> > 
> >  static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
> > @@ -1934,6 +1937,30 @@ static int axienet_probe(struct platform_device
> > *pdev)
> >  		goto free_netdev;
> >  	}
> > 
> > +	/*
> > +	 * Autodetect the need for 64-bit DMA pointers.
> > +	 * When the IP is configured for a bus width bigger than 32 bits,
> > +	 * writing the MSB registers is mandatory, even if they are all 0.
> > +	 * We can detect this case by writing all 1's to one such register
> > +	 * and see if that sticks: when the IP is configured for 32 bits
> > +	 * only, those registers are RES0.
> > +	 * Those MSB registers were introduced in IP v7.1, which we check first.
> > +	 */
> > +	if ((axienet_ior(lp, XAE_ID_OFFSET) >> 24) >= 0x9) {
> > +		void __iomem *desc = lp->dma_regs +
> > XAXIDMA_TX_CDESC_OFFSET + 4;
> > +
> > +		iowrite32(0x0, desc);
> > +		if (ioread32(desc) == 0) {	/* sanity check */
> > +			iowrite32(0xffffffff, desc);
> > +			if (ioread32(desc) > 0) {
> > +				lp->features |= XAE_FEATURE_DMA_64BIT;
> > +				dev_info(&pdev->dev,
> > +					 "autodetected 64-bit DMA range\n");
> > +			}
> > +			iowrite32(0x0, desc);
> > +		}
> > +	}
> > +
> >  	/* Check for Ethernet core IRQ (optional) */
> >  	if (lp->eth_irq <= 0)
> >  		dev_info(&pdev->dev, "Ethernet core IRQ not defined\n");
> > --
> > 2.17.1  
> 

