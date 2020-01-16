Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52B913ED87
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405056AbgAPSDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:03:35 -0500
Received: from foss.arm.com ([217.140.110.172]:56900 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393641AbgAPSDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 13:03:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF3BD31B;
        Thu, 16 Jan 2020 10:03:33 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE2C73F534;
        Thu, 16 Jan 2020 10:03:32 -0800 (PST)
Date:   Thu, 16 Jan 2020 18:03:26 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
Message-ID: <20200116180326.47c93ce2@donnerap.cambridge.arm.com>
In-Reply-To: <CH2PR02MB70008D24DA7D1426E8A71013C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
        <20200110115415.75683-4-andre.przywara@arm.com>
        <CH2PR02MB7000F64AB27D352E00DC77A7C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
        <20200110154328.6676215f@donnerap.cambridge.arm.com>
        <CH2PR02MB70008D24DA7D1426E8A71013C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 17:05:45 +0000
Radhey Shyam Pandey <radheys@xilinx.com> wrote:

Hi,

> > -----Original Message-----
> > From: Andre Przywara <andre.przywara@arm.com>
> > Sent: Friday, January 10, 2020 9:13 PM
> > To: Radhey Shyam Pandey <radheys@xilinx.com>
> > Cc: David S . Miller <davem@davemloft.net>; Michal Simek
> > <michals@xilinx.com>; Robert Hancock <hancock@sedsystems.ca>;
> > netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
> > 
> > On Fri, 10 Jan 2020 15:14:46 +0000
> > Radhey Shyam Pandey <radheys@xilinx.com> wrote:
> > 
> > Hi Radhey,
> > 
> > thanks for having a look!
> >   
> > > > -----Original Message-----
> > > > From: Andre Przywara <andre.przywara@arm.com>
> > > > Sent: Friday, January 10, 2020 5:24 PM
> > > > To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> > > > <radheys@xilinx.com>
> > > > Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> > > > <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> > > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > > > Subject: [PATCH 03/14] net: axienet: Fix DMA descriptor cleanup path
> > > >
> > > > When axienet_dma_bd_init() bails out during the initialisation process,
> > > > it might do so with parts of the structure already allocated and
> > > > initialised, while other parts have not been touched yet. Before
> > > > returning in this case, we call axienet_dma_bd_release(), which does not
> > > > take care of this corner case.
> > > > This is most obvious by the first loop happily dereferencing
> > > > lp->rx_bd_v, which we actually check to be non NULL *afterwards*.
> > > >
> > > > Make sure we only unmap or free already allocated structures, by:
> > > > - directly returning with -ENOMEM if nothing has been allocated at all
> > > > - checking for lp->rx_bd_v to be non-NULL *before* using it
> > > > - only unmapping allocated DMA RX regions
> > > >
> > > > This avoids NULL pointer dereferences when initialisation fails.
> > > >
> > > > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > > > ---
> > > >  .../net/ethernet/xilinx/xilinx_axienet_main.c | 43 ++++++++++++-------
> > > >  1 file changed, 28 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > > b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > > index 97482cf093ce..7e90044cf2d9 100644
> > > > --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > > > @@ -160,24 +160,37 @@ static void axienet_dma_bd_release(struct
> > > > net_device *ndev)
> > > >  	int i;
> > > >  	struct axienet_local *lp = netdev_priv(ndev);
> > > >
> > > > +	/* If we end up here, tx_bd_v must have been DMA allocated. */
> > > > +	dma_free_coherent(ndev->dev.parent,
> > > > +			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> > > > +			  lp->tx_bd_v,
> > > > +			  lp->tx_bd_p);
> > > > +
> > > > +	if (!lp->rx_bd_v)
> > > > +		return;
> > > > +
> > > >  	for (i = 0; i < lp->rx_bd_num; i++) {
> > > > -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> > > > -				 lp->max_frm_size, DMA_FROM_DEVICE);
> > > > +		/* A NULL skb means this descriptor has not been initialised
> > > > +		 * at all.
> > > > +		 */
> > > > +		if (!lp->rx_bd_v[i].skb)
> > > > +			break;
> > > > +
> > > >  		dev_kfree_skb(lp->rx_bd_v[i].skb);
> > > > -	}
> > > >
> > > > -	if (lp->rx_bd_v) {
> > > > -		dma_free_coherent(ndev->dev.parent,
> > > > -				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> > > > -				  lp->rx_bd_v,
> > > > -				  lp->rx_bd_p);
> > > > -	}
> > > > -	if (lp->tx_bd_v) {
> > > > -		dma_free_coherent(ndev->dev.parent,
> > > > -				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> > > > -				  lp->tx_bd_v,
> > > > -				  lp->tx_bd_p);
> > > > +		/* For each descriptor, we programmed cntrl with the (non-
> > > > zero)
> > > > +		 * descriptor size, after it had been successfully allocated.
> > > > +		 * So a non-zero value in there means we need to unmap it.
> > > > +		 */  
> > >  
> > > > +		if (lp->rx_bd_v[i].cntrl)  
> > >
> > > I think it should ok to unmap w/o any check?  
> > 
> > Do you mean because .phys would be 0 if not initialised? AFAIK 0 can be a
> > valid DMA address, so there is no special check for that, and unmapping
> > DMA address 0 will probably go wrong at some point. So it's unlike
> > kfree(NULL).  
> 
> I mean if skb allocation is successful in _dma_bd_init then in release path
> we can assume .phys is always a valid address and skip rx_bd_v[i].cntrl
> check.

I don't think we can assume this. If the skb allocation succeeded, but then the dma_map_single failed (which we check with dma_mapping_error()), we would end up with a valid skb, but an uninitialised phys DMA address in the registers. That's why I set .cntrl only after having checked the dma_map_single() result.

Or am I missing something?

Cheers,
Andre
 
> > > > +			dma_unmap_single(ndev->dev.parent, lp-  
> > > > >rx_bd_v[i].phys,  
> > > > +					 lp->max_frm_size,
> > > > DMA_FROM_DEVICE);
> > > >  	}
> > > > +
> > > > +	dma_free_coherent(ndev->dev.parent,
> > > > +			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> > > > +			  lp->rx_bd_v,
> > > > +			  lp->rx_bd_p);
> > > >  }
> > > >
> > > >  /**
> > > > @@ -207,7 +220,7 @@ static int axienet_dma_bd_init(struct net_device
> > > > *ndev)
> > > >  					 sizeof(*lp->tx_bd_v) * lp-  
> > > > >tx_bd_num,  
> > > >  					 &lp->tx_bd_p, GFP_KERNEL);
> > > >  	if (!lp->tx_bd_v)
> > > > -		goto out;
> > > > +		return -ENOMEM;
> > > >
> > > >  	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
> > > >  					 sizeof(*lp->rx_bd_v) * lp-  
> > > > >rx_bd_num,  
> > > > --
> > > > 2.17.1  
> > >  
> 

