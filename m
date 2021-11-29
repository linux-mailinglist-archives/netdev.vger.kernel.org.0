Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B95C460FED
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 09:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbhK2IYh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Nov 2021 03:24:37 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:48481 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbhK2IWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 03:22:36 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2AD24FF802;
        Mon, 29 Nov 2021 08:19:15 +0000 (UTC)
Date:   Mon, 29 Nov 2021 09:19:02 +0100
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
Subject: Re: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Message-ID: <20211129091902.0112eb17@fixe.home>
In-Reply-To: <20211127145805.75qh2vim7c5m5hjd@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-5-clement.leger@bootlin.com>
 <20211127145805.75qh2vim7c5m5hjd@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, 27 Nov 2021 14:58:06 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Fri, Nov 26, 2021 at 06:27:39PM +0100, Clément Léger wrote:
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
> > by the driver.
> > 
> > Co-developed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > ---  
> 
> I need to ask, was there any change in performance, in one direction or
> the other, between the ring and list based implementations?

Unfortunately, nothing really noticeable... Last numbers I gave you
were made with this version.

> 
> >  drivers/net/ethernet/mscc/Makefile         |   1 +
> >  drivers/net/ethernet/mscc/ocelot.c         |  43 +-
> >  drivers/net/ethernet/mscc/ocelot.h         |   1 +
> >  drivers/net/ethernet/mscc/ocelot_fdma.c    | 713 +++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_fdma.h    |  96 +++
> >  drivers/net/ethernet/mscc/ocelot_net.c     |  18 +-
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c |  13 +
> >  include/soc/mscc/ocelot.h                  |   4 +
> >  8 files changed, 869 insertions(+), 20 deletions(-)
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h
> > 
> > diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
> > index 722c27694b21..d76a9b78b6ca 100644
> > --- a/drivers/net/ethernet/mscc/Makefile
> > +++ b/drivers/net/ethernet/mscc/Makefile
> > @@ -11,5 +11,6 @@ mscc_ocelot_switch_lib-y := \
> >  mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
> >  obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
> >  mscc_ocelot-y := \
> > +	ocelot_fdma.o \
> >  	ocelot_vsc7514.o \
> >  	ocelot_net.o
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index 1f7c9ff18ac5..4b2460d232c2 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -966,14 +966,37 @@ static int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp, u32 *xfh)
> >  	return 0;
> >  }
> >  
> > -int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> > +void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
> > +			     u64 timestamp)
> >  {
> >  	struct skb_shared_hwtstamps *shhwtstamps;
> >  	u64 tod_in_ns, full_ts_in_ns;
> > +	struct timespec64 ts;
> > +
> > +	if (!ocelot->ptp)
> > +		return;
> > +
> > +	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
> > +
> > +	tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
> > +	if ((tod_in_ns & 0xffffffff) < timestamp)
> > +		full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
> > +				timestamp;
> > +	else
> > +		full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
> > +				timestamp;
> > +
> > +	shhwtstamps = skb_hwtstamps(skb);
> > +	memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
> > +	shhwtstamps->hwtstamp = full_ts_in_ns;
> > +}
> > +EXPORT_SYMBOL(ocelot_ptp_rx_timestamp);  
> 
> This split can very well be a separate patch, it's distracting.

Acked.

> 
> > +
> > +int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> > +{
> >  	u64 timestamp, src_port, len;
> >  	u32 xfh[OCELOT_TAG_LEN / 4];
> >  	struct net_device *dev;
> > -	struct timespec64 ts;
> >  	struct sk_buff *skb;
> >  	int sz, buf_len;
> >  	u32 val, *buf;
> > @@ -1029,21 +1052,7 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
> >  		*buf = val;
> >  	}
> >  
> > -	if (ocelot->ptp) {
> > -		ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
> > -
> > -		tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
> > -		if ((tod_in_ns & 0xffffffff) < timestamp)
> > -			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
> > -					timestamp;
> > -		else
> > -			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
> > -					timestamp;
> > -
> > -		shhwtstamps = skb_hwtstamps(skb);
> > -		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
> > -		shhwtstamps->hwtstamp = full_ts_in_ns;
> > -	}
> > +	ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);
> >  
> >  	/* Everything we see on an interface that is in the HW bridge
> >  	 * has already been forwarded.
> > diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> > index e43da09b8f91..f1a7b403e221 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.h
> > +++ b/drivers/net/ethernet/mscc/ocelot.h
> > @@ -9,6 +9,7 @@
> >  #define _MSCC_OCELOT_H_
> >  
> >  #include <linux/bitops.h>
> > +#include <linux/dsa/ocelot.h>
> >  #include <linux/etherdevice.h>
> >  #include <linux/if_vlan.h>
> >  #include <linux/net_tstamp.h>
> > diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
> > new file mode 100644
> > index 000000000000..e42c2c3ad273
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
> > @@ -0,0 +1,713 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > +/*
> > + * Microsemi SoCs FDMA driver
> > + *
> > + * Copyright (c) 2021 Microchip
> > + */
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/dmapool.h>
> > +#include <linux/dsa/ocelot.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/skbuff.h>
> > +
> > +#include "ocelot_fdma.h"
> > +#include "ocelot_qs.h"
> > +
> > +#define MSCC_FDMA_DCB_LLP(x)			((x) * 4 + 0x0)
> > +#define MSCC_FDMA_DCB_LLP_PREV(x)		((x) * 4 + 0xA0)
> > +
> > +#define MSCC_FDMA_DCB_STAT_BLOCKO(x)		(((x) << 20) & GENMASK(31, 20))
> > +#define MSCC_FDMA_DCB_STAT_BLOCKO_M		GENMASK(31, 20)
> > +#define MSCC_FDMA_DCB_STAT_BLOCKO_X(x)		(((x) & GENMASK(31, 20)) >> 20)
> > +#define MSCC_FDMA_DCB_STAT_PD			BIT(19)
> > +#define MSCC_FDMA_DCB_STAT_ABORT		BIT(18)
> > +#define MSCC_FDMA_DCB_STAT_EOF			BIT(17)
> > +#define MSCC_FDMA_DCB_STAT_SOF			BIT(16)
> > +#define MSCC_FDMA_DCB_STAT_BLOCKL_M		GENMASK(15, 0)
> > +#define MSCC_FDMA_DCB_STAT_BLOCKL(x)		((x) & GENMASK(15, 0))
> > +
> > +#define MSCC_FDMA_CH_SAFE			0xcc
> > +
> > +#define MSCC_FDMA_CH_ACTIVATE			0xd0
> > +
> > +#define MSCC_FDMA_CH_DISABLE			0xd4
> > +
> > +#define MSCC_FDMA_EVT_ERR			0x164
> > +
> > +#define MSCC_FDMA_EVT_ERR_CODE			0x168
> > +
> > +#define MSCC_FDMA_INTR_LLP			0x16c
> > +
> > +#define MSCC_FDMA_INTR_LLP_ENA			0x170
> > +
> > +#define MSCC_FDMA_INTR_FRM			0x174
> > +
> > +#define MSCC_FDMA_INTR_FRM_ENA			0x178
> > +
> > +#define MSCC_FDMA_INTR_ENA			0x184
> > +
> > +#define MSCC_FDMA_INTR_IDENT			0x188
> > +
> > +#define MSCC_FDMA_INJ_CHAN			2
> > +#define MSCC_FDMA_XTR_CHAN			0
> > +
> > +#define OCELOT_FDMA_RX_MTU			ETH_DATA_LEN
> > +#define OCELOT_FDMA_WEIGHT			32  
> 
> I guess you've reduced to half of NAPI_POLL_WEIGHT because the NET_RX
> softirq is consuming too much CPU time with the default value? I don't
> know if this is the productive thing to do with a very slow CPU that is
> swamped with traffic, since you're practically leaving yourself exposed
> to more interrupts, can somebody please chime in?

Yes, indeed. 

> 
> > +#define OCELOT_FDMA_RX_REFILL_COUNT		(OCELOT_FDMA_MAX_DCB / 2)  
> 
> Unused. I suppose you wanted to refill more than once per NAPI poll
> cycle (as you currently do in ocelot_fdma_rx_restart) but you didn't get
> around to it? I think you should still do that, don't leave the RX ring
> running dry.

Exactly, that's what I wanted to do originally but to refill the RX,
the RX channel must be disabled... which means it will probably drop
packet in the meantime if FIFOs are full. Not sure it will bring any
improvement.

> 
> > +
> > +#define OCELOT_FDMA_CH_SAFE_TIMEOUT_MS		100
> > +
> > +#define OCELOT_FDMA_RX_EXTRA_SIZE \
> > +				(OCELOT_TAG_LEN + ETH_FCS_LEN + ETH_HLEN)  
> 
> Could all these macros belong to ocelot_fdma.h?

Yes.

> 
> > +
> > +static int ocelot_fdma_rx_buf_size(int mtu)
> > +{
> > +	return ALIGN(mtu + OCELOT_FDMA_RX_EXTRA_SIZE, 4);
> > +}
> > +
> > +static void ocelot_fdma_writel(struct ocelot_fdma *fdma, u32 reg, u32 data)
> > +{
> > +	writel(data, fdma->base + reg);
> > +}  
> 
> Regmap is too slow for you, you're using direct I/O accessors now?

This was in the original patch I had, and I don't think it was intended
for performances. I will switch to regmap and check if it is noticeable
at all but I really don't think so as there are a few register read
only in rx path.

> 
> > +
> > +static u32 ocelot_fdma_readl(struct ocelot_fdma *fdma, u32 reg)
> > +{
> > +	return readl(fdma->base + reg);
> > +}
> > +
> > +static unsigned int ocelot_fdma_idx_incr(unsigned int idx)  
> 
> Minor comment, but "inc" and "dec" are much more popular abbreviations.
> Although the way in which you use them is not quite the same way in
> which other drivers use them (something called "inc" would take a
> reference on the number and actually increment it). So maybe "next" and
> "prev"?

Agreed, next and prev makes more sense.

> 
> > +{
> > +	idx++;
> > +	if (idx == OCELOT_FDMA_MAX_DCB)
> > +		idx = 0;
> > +
> > +	return idx;
> > +}
> > +
> > +static unsigned int ocelot_fdma_idx_decr(unsigned int idx)
> > +{
> > +	if (idx == 0)
> > +		idx = OCELOT_FDMA_MAX_DCB - 1;
> > +	else
> > +		idx--;
> > +
> > +	return idx;
> > +}
> > +
> > +static int ocelot_fdma_tx_free_count(struct ocelot_fdma *fdma)
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->inj;
> > +
> > +	if (ring->tail >= ring->head)
> > +		return OCELOT_FDMA_MAX_DCB - (ring->tail - ring->head) - 1;
> > +	else
> > +		return ring->head - ring->tail - 1;
> > +}
> > +
> > +static bool ocelot_fdma_ring_empty(struct ocelot_fdma_ring *ring)
> > +{
> > +	return ring->head == ring->tail;
> > +}
> > +
> > +static void ocelot_fdma_activate_chan(struct ocelot_fdma *fdma,
> > +				      struct ocelot_fdma_dcb *dcb, int chan)
> > +{
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_DCB_LLP(chan), dcb->hw_dma);
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
> > +}
> > +
> > +static int ocelot_fdma_wait_chan_safe(struct ocelot_fdma *fdma, int chan)
> > +{
> > +	unsigned long timeout;
> > +	u32 safe;
> > +
> > +	timeout = jiffies + msecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_MS);
> > +	do {
> > +		safe = ocelot_fdma_readl(fdma, MSCC_FDMA_CH_SAFE);
> > +		if (safe & BIT(chan))
> > +			return 0;  
> 
> Pretty busy loop, and your timeout is 100 ms. Kinda nasty stuff for the
> latency of your system.

Ok, I will try to relax that a bit.

> 
> > +	} while (time_after(jiffies, timeout));
> > +
> > +	return -ETIMEDOUT;
> > +}
> > +
> > +static int ocelot_fdma_stop_channel(struct ocelot_fdma *fdma, int chan)
> > +{
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_CH_DISABLE, BIT(chan));
> > +
> > +	return ocelot_fdma_wait_chan_safe(fdma, chan);  
> 
> Maybe for the extraction channel it would make sense to have an async
> stop, meaning that you ask it to stop, then process the frames you've
> got so far, and wait until the channel has completely stopped only when
> you need to refill?

That's an idea I could dig up yes. I haven't actually measured how much
tilme is spent busy looping.

> 
> > +}
> > +
> > +static bool ocelot_fdma_dcb_set_data(struct ocelot_fdma *fdma,
> > +				     struct ocelot_fdma_dcb *dcb,
> > +				     struct sk_buff *skb,
> > +				     size_t size, enum dma_data_direction dir)
> > +{
> > +	struct ocelot_fdma_dcb_hw_v2 *hw = dcb->hw;
> > +	u32 offset;
> > +
> > +	dcb->skb = skb;
> > +	dcb->mapped_size = size;
> > +	dcb->mapping = dma_map_single(fdma->dev, skb->data, size, dir);
> > +	if (unlikely(dma_mapping_error(fdma->dev, dcb->mapping)))
> > +		return false;
> > +
> > +	offset = dcb->mapping & 0x3;
> > +
> > +	hw->llp = 0;
> > +	hw->datap = ALIGN_DOWN(dcb->mapping, 4);
> > +	hw->datal = ALIGN_DOWN(size, 4);
> > +	hw->stat = MSCC_FDMA_DCB_STAT_BLOCKO(offset);
> > +
> > +	return true;
> > +}
> > +
> > +static bool ocelot_fdma_rx_set_skb(struct ocelot_fdma *fdma,
> > +				   struct ocelot_fdma_dcb *dcb,
> > +				   struct sk_buff *skb, size_t size)
> > +{
> > +	return ocelot_fdma_dcb_set_data(fdma, dcb, skb, size,
> > +					DMA_FROM_DEVICE);
> > +}
> > +
> > +static bool ocelot_fdma_tx_dcb_set_skb(struct ocelot_fdma *fdma,
> > +				       struct ocelot_fdma_dcb *dcb,
> > +				       struct sk_buff *skb)
> > +{
> > +	if (!ocelot_fdma_dcb_set_data(fdma, dcb, skb, skb->len,
> > +				      DMA_TO_DEVICE))
> > +		return false;
> > +
> > +	dcb->hw->stat |= MSCC_FDMA_DCB_STAT_BLOCKL(skb->len);
> > +	dcb->hw->stat |= MSCC_FDMA_DCB_STAT_SOF | MSCC_FDMA_DCB_STAT_EOF;
> > +
> > +	return true;
> > +}
> > +
> > +static void ocelot_fdma_rx_restart(struct ocelot_fdma *fdma)
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->xtr;
> > +	struct ocelot_fdma_dcb *dcb, *last_dcb;
> > +	unsigned int idx;
> > +	int ret;
> > +	u32 llp;
> > +
> > +	/* Check if the FDMA hits the DCB with LLP == NULL */
> > +	llp = ocelot_fdma_readl(fdma, MSCC_FDMA_DCB_LLP(MSCC_FDMA_XTR_CHAN));
> > +	if (llp)
> > +		return;  
> 
> I'm not sure why you're letting the hardware grind to a halt first,
> before refilling? I think since the CPU is the bottleneck anyway, you
> can stop the extraction channel at any time you want to refill.
> A constant stream of less data might be better than a bursty one.
> Or maybe I'm misunderstanding some of the details of the hardware.

Indeed, I can stop the extraction channel but that does not seems a
good idea to stop the channel in a steady state. At least that's what I
thought since it will make the receive "window" non predictable. Not
sure how well it will play with various protocol but I will try
implementing the refill we talked previously (ie when there an
available threshold is reached).

> 
> > +
> > +	ret = ocelot_fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
> > +	if (ret) {
> > +		dev_warn(fdma->dev, "Unable to stop RX channel\n");  
> 
> Rate limit these prints maybe.

Ok.

> 
> > +		return;
> > +	}
> > +
> > +	/* Chain the tail with the next DCB */
> > +	dcb = &ring->dcbs[ring->tail];
> > +	idx = ocelot_fdma_idx_incr(ring->tail);
> > +	dcb->hw->llp = ring->dcbs[idx].hw_dma;
> > +	dcb = &ring->dcbs[idx];
> > +
> > +	/* Place a NULL terminator in last DCB added (head - 1) */
> > +	idx = ocelot_fdma_idx_decr(ring->head);
> > +	last_dcb = &ring->dcbs[idx];
> > +	last_dcb->hw->llp = 0;
> > +	ring->tail = idx;
> > +
> > +	/* Finally reactivate the channel */
> > +	ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_XTR_CHAN);
> > +}
> > +
> > +static bool ocelot_fdma_rx_get(struct ocelot_fdma *fdma, int budget)
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->xtr;
> > +	struct ocelot_fdma_dcb *dcb, *next_dcb;
> > +	struct ocelot *ocelot = fdma->ocelot;
> > +	struct net_device *ndev;
> > +	struct sk_buff *skb;
> > +	bool valid = true;
> > +	u64 timestamp;
> > +	u64 src_port;
> > +	void *xfh;
> > +	u32 stat;
> > +
> > +	/* We should not go past the tail */
> > +	if (ring->head == ring->tail)
> > +		return false;
> > +
> > +	dcb = &ring->dcbs[ring->head];
> > +	stat = dcb->hw->stat;
> > +	if (MSCC_FDMA_DCB_STAT_BLOCKL(stat) == 0)
> > +		return false;
> > +
> > +	ring->head = ocelot_fdma_idx_incr(ring->head);
> > +
> > +	if (stat & MSCC_FDMA_DCB_STAT_ABORT || stat & MSCC_FDMA_DCB_STAT_PD)
> > +		valid = false;
> > +
> > +	if (!(stat & MSCC_FDMA_DCB_STAT_SOF) ||
> > +	    !(stat & MSCC_FDMA_DCB_STAT_EOF))
> > +		valid = false;
> > +
> > +	dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
> > +			 DMA_FROM_DEVICE);
> > +
> > +	skb = dcb->skb;
> > +
> > +	if (unlikely(!valid)) {
> > +		dev_warn(fdma->dev, "Invalid packet\n");  
> 
> Rate limit please, and try to show something which might be relevant to
> why it is not valid.

Ok.

> 
> > +		goto refill;
> > +	}
> > +
> > +	xfh = skb->data;
> > +	ocelot_xfh_get_src_port(xfh, &src_port);
> > +
> > +	if (WARN_ON(src_port >= ocelot->num_phys_ports))
> > +		goto refill;
> > +
> > +	ndev = ocelot_port_to_netdev(ocelot, src_port);
> > +	if (unlikely(!ndev))
> > +		goto refill;
> > +
> > +	skb_put(skb, MSCC_FDMA_DCB_STAT_BLOCKL(stat) - ETH_FCS_LEN);
> > +	skb_pull(skb, OCELOT_TAG_LEN);
> > +
> > +	skb->dev = ndev;
> > +	skb->protocol = eth_type_trans(skb, skb->dev);
> > +	skb->dev->stats.rx_bytes += skb->len;
> > +	skb->dev->stats.rx_packets++;
> > +
> > +	ocelot_ptp_rx_timestamp(ocelot, skb, timestamp);  
> 
> You forgot to extract the "timestamp" from the XFH, and are providing
> junk from the kernel stack memory. Please make sure to test PTP.
> 
> > +
> > +	if (!skb_defer_rx_timestamp(skb))
> > +		netif_receive_skb(skb);
> > +
> > +	skb = napi_alloc_skb(&fdma->napi, fdma->rx_buf_size);
> > +	if (!skb)
> > +		return false;  
> 
> See my comment below, on the ocelot_fdma_rx_skb_alloc() function, on why
> I think you are making sub-optimal use of the ring concept.
> 
> > +
> > +refill:
> > +	if (!ocelot_fdma_rx_set_skb(fdma, dcb, skb, fdma->rx_buf_size))
> > +		return false;
> > +
> > +	/* Chain the next DCB */
> > +	next_dcb = &ring->dcbs[ring->head];
> > +	dcb->hw->llp = next_dcb->hw_dma;
> > +
> > +	return true;
> > +}
> > +
> > +static void ocelot_fdma_tx_cleanup(struct ocelot_fdma *fdma, int budget)
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->inj;
> > +	unsigned int tmp_head, new_null_llp_idx;
> > +	struct ocelot_fdma_dcb *dcb;
> > +	bool end_of_list = false;
> > +	int ret;
> > +
> > +	spin_lock_bh(&fdma->xmit_lock);
> > +
> > +	/* Purge the TX packets that have been sent up to the NULL llp or the
> > +	 * end of done list.
> > +	 */
> > +	while (!ocelot_fdma_ring_empty(&fdma->inj)) {  
> 
> s/&fdma->inj/ring/
> 
> > +		dcb = &ring->dcbs[ring->head];
> > +		if (!(dcb->hw->stat & MSCC_FDMA_DCB_STAT_PD))
> > +			break;
> > +
> > +		tmp_head = ring->head;  
> 
> Unused.
> 
> > +		ring->head = ocelot_fdma_idx_incr(ring->head);
> > +
> > +		dma_unmap_single(fdma->dev, dcb->mapping, dcb->mapped_size,
> > +				 DMA_TO_DEVICE);
> > +		napi_consume_skb(dcb->skb, budget);
> > +
> > +		/* If we hit the NULL LLP, stop, we might need to reload FDMA */
> > +		if (dcb->hw->llp == 0) {
> > +			end_of_list = true;
> > +			break;
> > +		}
> > +	}
> > +
> > +	/* If there is still some DCBs to be processed by the FDMA or if the
> > +	 * pending list is empty, there is no need to restart the FDMA.
> > +	 */  
> 
> I don't understand why you restart the injection channel from the TX
> confirmation interrupt. It raised the interrupt to tell you that it hit
> a NULL LLP because there's nothing left to send. If you restart it now and
> no other transmission has happened in the meantime, won't it stop again?

Actually, it is only restarted if there is some pending packets to
send. With this hardware, packets can't be added while the FDMA is
running and it must be stopped everytime we want to add a packet to the
list. To avoid that, in the TX path, if the FDMA is stopped, we set the
llp of the packet to NULL and start the chan. However, if the FDMA TX
channel is running, we don't stop it, we simply add the next packets to
the ring. However, the FDMA will stop on the previous NULL LLP. So when
we hit a LLP, we might not be at the end of the list. This is why the
next check verifies if we hit a NULL LLP and if there is still some
packet to send. 

> 
> > +	if (!end_of_list || ocelot_fdma_ring_empty(&fdma->inj))  
> 
> s/&fdma->inj/ring/
> 
> > +		goto out_unlock;
> > +
> > +	ret = ocelot_fdma_wait_chan_safe(fdma, MSCC_FDMA_INJ_CHAN);
> > +	if (ret) {
> > +		dev_warn(fdma->dev, "Failed to wait for TX channel to stop\n");
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* Set NULL LLP */
> > +	new_null_llp_idx = ocelot_fdma_idx_decr(ring->tail);
> > +	dcb = &ring->dcbs[new_null_llp_idx];
> > +	dcb->hw->llp = 0;
> > +
> > +	dcb = &ring->dcbs[ring->head];
> > +	ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);  
> 
> 	if (unlikely(netif_queue_stopped(dev)) &&
> 	    ocelot_fdma_tx_free_count(fdma))
> 		netif_wake_queue(dev);
> 
> This can then be tweaked for when you add support for scatter/gather xmit.

Acked. Note that this will loop an all netdev since the FDMA channels
are shared for all ports. BTW, I think this code should be called
before restarting the channel (ie after cleaning up the TX ring above).

> 
> > +
> > +out_unlock:
> > +	spin_unlock_bh(&fdma->xmit_lock);
> > +}
> > +
> > +static int ocelot_fdma_napi_poll(struct napi_struct *napi, int budget)
> > +{
> > +	struct ocelot_fdma *fdma = container_of(napi, struct ocelot_fdma, napi);
> > +	int work_done = 0;
> > +
> > +	ocelot_fdma_tx_cleanup(fdma, budget);
> > +
> > +	while (work_done < budget) {
> > +		if (!ocelot_fdma_rx_get(fdma, budget))
> > +			break;
> > +
> > +		work_done++;
> > +	}
> > +
> > +	ocelot_fdma_rx_restart(fdma);
> > +
> > +	if (work_done < budget) {
> > +		napi_complete_done(&fdma->napi, work_done);
> > +		ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
> > +				   BIT(MSCC_FDMA_INJ_CHAN) |
> > +				   BIT(MSCC_FDMA_XTR_CHAN));
> > +	}
> > +
> > +	return work_done;
> > +}
> > +
> > +static irqreturn_t ocelot_fdma_interrupt(int irq, void *dev_id)
> > +{
> > +	u32 ident, llp, frm, err, err_code;
> > +	struct ocelot_fdma *fdma = dev_id;
> > +
> > +	ident = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_IDENT);
> > +	frm = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_FRM);
> > +	llp = ocelot_fdma_readl(fdma, MSCC_FDMA_INTR_LLP);
> > +
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP, llp & ident);
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM, frm & ident);
> > +	if (frm || llp) {
> > +		ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
> > +		napi_schedule(&fdma->napi);
> > +	}
> > +
> > +	err = ocelot_fdma_readl(fdma, MSCC_FDMA_EVT_ERR);
> > +	if (unlikely(err)) {
> > +		err_code = ocelot_fdma_readl(fdma, MSCC_FDMA_EVT_ERR_CODE);
> > +		dev_err_ratelimited(fdma->dev,
> > +				    "Error ! chans mask: %#x, code: %#x\n",
> > +				    err, err_code);
> > +
> > +		ocelot_fdma_writel(fdma, MSCC_FDMA_EVT_ERR, err);
> > +		ocelot_fdma_writel(fdma, MSCC_FDMA_EVT_ERR_CODE, err_code);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static void ocelot_fdma_send_skb(struct ocelot_fdma *fdma, struct sk_buff *skb)
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->inj;
> > +	struct ocelot_fdma_dcb *dcb, *next;
> > +
> > +	dcb = &ring->dcbs[ring->tail];
> > +	if (!ocelot_fdma_tx_dcb_set_skb(fdma, dcb, skb)) {
> > +		dev_kfree_skb_any(skb);
> > +		return;
> > +	}
> > +
> > +	if (ocelot_fdma_ring_empty(&fdma->inj)) {  
> 
> s/&fdma->inj/ring/
> 
> > +		ocelot_fdma_activate_chan(fdma, dcb, MSCC_FDMA_INJ_CHAN);
> > +	} else {
> > +		next = &ring->dcbs[ocelot_fdma_idx_incr(ring->tail)];
> > +		dcb->hw->llp = next->hw_dma;
> > +	}
> > +
> > +	ring->tail = ocelot_fdma_idx_incr(ring->tail);  
> 
> You still have locking between TX and TX conf, that's too bad. Why is
> that, I wonder? Because TX conf (ocelot_fdma_tx_cleanup) updates
> ring->head and TX (ocelot_fdma_send_skb) updates ring->tail. Could it be
> because you're updating the ring->tail _after_ you've activated the
> injection channel, therefore exposing you to a race with the completion
> interrupt which reads ring->tail?

Since the FDMA is shared between multiple netdevs, I think the TX
locking might be needed only in xmit when checking if there is space
to send a packet.
I think it can indeed be left out in the TX cleanup path.

> 
> > +
> > +	skb_tx_timestamp(skb);
> > +}
> > +
> > +static int ocelot_fdma_prepare_skb(struct ocelot_fdma *fdma, int port,
> > +				   u32 rew_op, struct sk_buff *skb,
> > +				   struct net_device *dev)
> > +{
> > +	int needed_headroom = max_t(int, OCELOT_TAG_LEN - skb_headroom(skb), 0);
> > +	int needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
> > +	struct ocelot_port *ocelot_port = fdma->ocelot->ports[port];
> > +	void *ifh;
> > +	int err;
> > +
> > +	if (unlikely(needed_headroom || needed_tailroom ||
> > +		     skb_header_cloned(skb))) {
> > +		err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
> > +				       GFP_ATOMIC);
> > +		if (unlikely(err)) {
> > +			dev_kfree_skb_any(skb);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	err = skb_linearize(skb);
> > +	if (err) {
> > +		net_err_ratelimited("%s: skb_linearize error (%d)!\n",
> > +				    dev->name, err);
> > +		dev_kfree_skb_any(skb);
> > +		return 1;
> > +	}
> > +
> > +	ifh = skb_push(skb, OCELOT_TAG_LEN);
> > +	skb_put(skb, ETH_FCS_LEN);
> > +	ocelot_ifh_port_set(ifh, ocelot_port, rew_op, skb_vlan_tag_get(skb));
> > +
> > +	return 0;
> > +}
> > +
> > +int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew_op,
> > +			     struct sk_buff *skb, struct net_device *dev)
> > +{
> > +	int ret = NETDEV_TX_OK;
> > +
> > +	spin_lock(&fdma->xmit_lock);
> > +
> > +	if (ocelot_fdma_tx_free_count(fdma) == 0) {
> > +		ret = NETDEV_TX_BUSY;  
> 
> netif_stop_queue(dev);
> 
> > +		goto out;
> > +	}
> > +
> > +	if (ocelot_fdma_prepare_skb(fdma, port, rew_op, skb, dev))
> > +		goto out;
> > +
> > +	ocelot_fdma_send_skb(fdma, skb);
> > +
> > +out:
> > +	spin_unlock(&fdma->xmit_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static void ocelot_fdma_ring_free(struct ocelot_fdma *fdma,
> > +				  struct ocelot_fdma_ring *ring)
> > +{
> > +	dmam_free_coherent(fdma->dev, OCELOT_DCBS_HW_ALLOC_SIZE, ring->hw_dcbs,
> > +			   ring->hw_dcbs_dma);
> > +}
> > +
> > +static int ocelot_fdma_ring_alloc(struct ocelot_fdma *fdma,
> > +				  struct ocelot_fdma_ring *ring)
> > +{
> > +	struct ocelot_fdma_dcb_hw_v2 *hw_dcbs;
> > +	struct ocelot_fdma_dcb *dcb;
> > +	dma_addr_t hw_dcbs_dma;
> > +	unsigned int adjust;
> > +	int i;
> > +
> > +	/* Create a pool of consistent memory blocks for hardware descriptors */
> > +	ring->hw_dcbs = dmam_alloc_coherent(fdma->dev,
> > +					    OCELOT_DCBS_HW_ALLOC_SIZE,
> > +					    &ring->hw_dcbs_dma, GFP_KERNEL);
> > +	if (!ring->hw_dcbs)
> > +		return -ENOMEM;
> > +
> > +	/* DCBs must be aligned on a 32bit boundary */
> > +	hw_dcbs = ring->hw_dcbs;
> > +	hw_dcbs_dma = ring->hw_dcbs_dma;
> > +	if (!IS_ALIGNED(hw_dcbs_dma, 4)) {
> > +		adjust = hw_dcbs_dma & 0x3;
> > +		hw_dcbs_dma = ALIGN(hw_dcbs_dma, 4);
> > +		hw_dcbs = (void *)hw_dcbs + adjust;
> > +	}
> > +
> > +	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
> > +		dcb = &ring->dcbs[i];
> > +		dcb->hw = &hw_dcbs[i];
> > +		dcb->hw_dma = hw_dcbs_dma +
> > +			     i * sizeof(struct ocelot_fdma_dcb_hw_v2);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ocelot_fdma_rx_skb_alloc(struct ocelot_fdma *fdma)
> > +{
> > +	struct ocelot_fdma_dcb *dcb, *prev_dcb = NULL;
> > +	struct ocelot_fdma_ring *ring = &fdma->xtr;
> > +	struct sk_buff *skb;
> > +	int i;
> > +
> > +	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
> > +		dcb = &ring->dcbs[i];
> > +		skb = napi_alloc_skb(&fdma->napi, fdma->rx_buf_size);  
> 
> I have to tell you, skb allocation at probe time is something I haven't
> seen before, I'll have to defer to somebody else for a second opinion.
> I understand that you keep the sk_buff structure closely tied to the DCB
> structure, whereas normally you'd see only DCB structures in the RX ring.
> 
> And napi_alloc_skb? This isn't NAPI context.
> 
> The whole idea (as far as I understand it!) with a receive ring is that
> hardware produces data on one side of it, and software consumes from
> that side too and in the same direction, just lags behind a little bit.
> Software must also provide buffers at the opposite end, in which
> hardware will put the produced data, so that the pipeline never runs
> out. You'll notice that it is standard amongst ring based drivers to
> name your ring->head as ring->next_to_clean, and your ring->tail as
> ring->next_to_use (actually not quite: your hardware doesn't really
> provide producer and consumer indices, and the way in which you update
> the ring->tail past the NULL LLP pointer is a bit different from the way
> in which drivers use ring->next_to_use and more like ring->next_to_alloc,
> but more on that later). I think people reviewing your code will instantly
> know what it's about if you name and structure things in this way,
> perhaps the lack of consumer and producer indices is merely an
> irrelevant detail.
> 
> As long as the ring size is large enough in order to give software some
> time to react, you can reach a state of equilibrium where you don't need
> to allocate or DMA map any new buffer, you can just recycle the ones you
> already have. To use buffer recycling, you need to replace alloc_skb()
> with functions such as build_skb(), which builds an sk_buff structure
> around a pre-existing buffer.
> 
> One simple way to achieve this is the page flipping technique. There may
> be others and you don't have to use this one. The principle is as
> follows: you allocate and DMA map buffers double the size you need
> (PAGE_SIZE is a common choice, divided by two you get about 2K of data
> per buffer, for frames larger than that you should do scatter/gather)
> and you populate an RX DCB with just one half of that page, the other
> half is unused for now. You repeat this process until you've filled up
> the RX ring with sufficient DCB entries, and all of this happens at
> initialization time.
> 
> Then, when you process a frame from the RX DCB ring (in the NAPI poll
> function), you construct a skb around that page half, and before giving
> it to the network stack, you speculatively attempt to reuse the other
> half of the page by putting it back into the RX DCB ring, at the
> opposite end compared to where you're consuming the other half from.
> Ring-based drivers use a separate ring->next_to_alloc variable for this.
> DCB elements ranging from ring->next_to_use and up to ring->next_to_alloc
> are simply halves of pages that have been processed by your NAPI, and
> are ready to be committed to hardware when you need to refill (in your
> case update the LLP pointer).
> 
> So each page could have up to two users (references), and you need to be
> very careful how you deal with concurrency with the stack. As Claudiu
> explained in great detail to me when I was first studying this
> mechanism, the driver is the producer of these RX pages and the network
> stack is the consumer. And since the network stack will eventually call
> kfree_skb() after it's done, which ultimately results into a put_page(),
> you need to counteract that action and ensure that if you want to recycle
> the other half of the page, the page's refcount never reaches zero.
> 
> As a result, if you deem the other page half as good for recycling, you
> need to bump the reference count of the page from 1 to 2. This will make
> it safe for you to refill the DCB ring with that other half.
> 
> Of course, the other half of the page might not be available for
> recycling, this is why the technique is speculative. If the stack hasn't
> yet called kfree_skb() on the other half, the page reference count will
> be 2 at the time you're cleaning the buffer, and bad luck, you can no
> longer reuse this page, so the driver needs to take its hands off of it.
> 
> If you look at driver implementations of the half page flip heuristic,
> you'll see that "taking your hands off the page" means simply to DMA
> unmap the entire page. This might surprise you, after all, the reference
> count of the page is 2, you might think that the page will leak if you
> don't decrement one of the references on it, or something. But if you
> think about it, the reference count is 2 because one half has an skb
> built at an earlier time around it, which is still in the network stack
> there somewhere pending a kfree_skb(), and the other half is the buffer
> you're cleaning right now. This half is practically promised to the
> network stack, you'll create an skb around this half too, and the stack
> will kfree it too, and the refcount of the page will thus drop to zero.
> 
> Of course, when you need to refill the RX ring with, say, 32 buffers,
> you might find that (ring->next_to_alloc - ring->next_to_use) mod ring size
> is less than 32 (otherwise said, the buffer reuse technique couldn't
> provide enough buffers). So you need to alloc and DMA map new pages from
> ring->next_to_alloc up to 32 (but this is still in contrast with your
> current implementation which always calls napi_alloc_skb 32 times).
> Nonetheless, in my experience, the technique works very well in real
> life situations and is a very good way to reduce the pressure on the
> memory allocator and avoid costly DMA mapping and unmapping per packet.
> Since you've already went through the trouble of making this a
> ring-based driver, I believe you should try to implement a buffer reuse
> technique too, especially for this particular case of a very slow
> processor.

Ok, I see the idea, thanks for the in-depth explanation.

> 
> > +		if (!skb)
> > +			goto skb_alloc_failed;
> > +
> > +		ocelot_fdma_rx_set_skb(fdma, dcb, skb, fdma->rx_buf_size);
> > +
> > +		if (prev_dcb)
> > +			prev_dcb->hw->llp = dcb->hw_dma;
> > +
> > +		prev_dcb = dcb;
> > +	}
> > +
> > +	ring->head = 0;
> > +	ring->tail = OCELOT_FDMA_MAX_DCB - 1;
> > +
> > +	return 0;
> > +
> > +skb_alloc_failed:
> > +	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
> > +		dcb = &ring->dcbs[i];
> > +		if (!dcb->skb)
> > +			break;
> > +
> > +		dev_kfree_skb_any(dcb->skb);
> > +	}
> > +
> > +	return -ENOMEM;
> > +}
> > +
> > +static int ocelot_fdma_rx_init(struct ocelot_fdma *fdma)
> > +{
> > +	int ret;
> > +
> > +	fdma->rx_buf_size = ocelot_fdma_rx_buf_size(OCELOT_FDMA_RX_MTU);
> > +
> > +	ret = ocelot_fdma_rx_skb_alloc(fdma);
> > +	if (ret) {
> > +		netif_napi_del(&fdma->napi);
> > +		return ret;
> > +	}
> > +
> > +	napi_enable(&fdma->napi);
> > +
> > +	ocelot_fdma_activate_chan(fdma, &fdma->xtr.dcbs[0],
> > +				  MSCC_FDMA_XTR_CHAN);
> > +
> > +	return 0;
> > +}
> > +
> > +void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_device *dev)
> > +{
> > +	dev->needed_headroom = OCELOT_TAG_LEN;
> > +	dev->needed_tailroom = ETH_FCS_LEN;  
> 
> The needed_headroom is in no way specific to FDMA, right? Why aren't you
> doing it for manual register-based injection too? (in a separate patch ofc)

Actually, If I switch to page based ring, This won't be useful anymore
because the header will be written directly in the page and not anymore
directly in the skb header.

> 
> > +
> > +	if (fdma->ndev)
> > +		return;
> > +
> > +	fdma->ndev = dev;
> > +	netif_napi_add(dev, &fdma->napi, ocelot_fdma_napi_poll,
> > +		       OCELOT_FDMA_WEIGHT);  
> 
> I understand that NAPI is per netdev but you have a single interrupt so
> you need to share the NAPI instance for all ports. That is fine.
> But danger ahead, see this:
> 
> mscc_ocelot_init_ports() does:
> 
> 		err = ocelot_probe_port(ocelot, port, target, portnp);
> 		if (err) {
> 			ocelot_port_devlink_teardown(ocelot, port);
> 			continue;
> 		}
> 
> aka it skips over ports that failed to probe.
> And ocelot_probe_port does:
> 
> 	if (ocelot->fdma)
> 		ocelot_fdma_netdev_init(ocelot->fdma, dev);
> 
> 	err = register_netdev(dev);
> 	if (err) {
> 		dev_err(ocelot->dev, "register_netdev failed\n");
> 		goto out;
> 	}
> 
> So if register_netdev() fails, you will have a dangling, freed pointer
> inside fdma->ndev. That is not good, as far as I can tell. Try to make
> the probing of your first port fail at register_netdev() time, to see
> what I mean.

Ok, I will look at that.

> 
> > +}
> > +
> > +void ocelot_fdma_netdev_deinit(struct ocelot_fdma *fdma, struct net_device *dev)
> > +{
> > +	if (dev == fdma->ndev)
> > +		netif_napi_del(&fdma->napi);
> > +}
> > +
> > +struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
> > +				     struct ocelot *ocelot)
> > +{
> > +	struct ocelot_fdma *fdma;
> > +	void __iomem *base;
> > +	int ret;
> > +
> > +	base = devm_platform_ioremap_resource_byname(pdev, "fdma");
> > +	if (IS_ERR_OR_NULL(base))
> > +		return NULL;
> > +
> > +	fdma = devm_kzalloc(&pdev->dev, sizeof(*fdma), GFP_KERNEL);
> > +	if (!fdma)
> > +		goto err_release_resource;
> > +
> > +	fdma->ocelot = ocelot;
> > +	fdma->base = base;
> > +	fdma->dev = &pdev->dev;
> > +	fdma->dev->coherent_dma_mask = DMA_BIT_MASK(32);
> > +
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
> > +
> > +	fdma->irq = platform_get_irq_byname(pdev, "fdma");
> > +	ret = devm_request_irq(&pdev->dev, fdma->irq, ocelot_fdma_interrupt, 0,
> > +			       dev_name(&pdev->dev), fdma);
> > +	if (ret)
> > +		goto err_free_fdma;
> > +
> > +	ret = ocelot_fdma_ring_alloc(fdma, &fdma->inj);
> > +	if (ret)
> > +		goto err_free_irq;
> > +
> > +	ret = ocelot_fdma_ring_alloc(fdma, &fdma->xtr);
> > +	if (ret)
> > +		goto free_inj_ring;
> > +
> > +	return fdma;
> > +
> > +free_inj_ring:
> > +	ocelot_fdma_ring_free(fdma, &fdma->inj);
> > +err_free_irq:
> > +	devm_free_irq(&pdev->dev, fdma->irq, fdma);
> > +err_free_fdma:
> > +	devm_kfree(&pdev->dev, fdma);
> > +err_release_resource:
> > +	devm_iounmap(&pdev->dev, base);
> > +
> > +	return NULL;
> > +}
> > +
> > +int ocelot_fdma_start(struct ocelot_fdma *fdma)
> > +{
> > +	struct ocelot *ocelot = fdma->ocelot;
> > +	int ret;
> > +
> > +	ret = ocelot_fdma_rx_init(fdma);
> > +	if (ret)
> > +		return -EINVAL;
> > +
> > +	/* Reconfigure for extraction and injection using DMA */
> > +	ocelot_write_rix(ocelot, QS_INJ_GRP_CFG_MODE(2), QS_INJ_GRP_CFG, 0);
> > +	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(0), QS_INJ_CTRL, 0);
> > +
> > +	ocelot_write_rix(ocelot, QS_XTR_GRP_CFG_MODE(2), QS_XTR_GRP_CFG, 0);
> > +
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP, 0xffffffff);
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM, 0xffffffff);
> > +
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_LLP_ENA,
> > +			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_FRM_ENA, BIT(MSCC_FDMA_XTR_CHAN));
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA,
> > +			   BIT(MSCC_FDMA_INJ_CHAN) | BIT(MSCC_FDMA_XTR_CHAN));
> > +
> > +	return 0;
> > +}
> > +
> > +int ocelot_fdma_stop(struct ocelot_fdma *fdma)  
> 
> This should return void.
> 
> > +{
> > +	struct ocelot_fdma_ring *ring = &fdma->xtr;
> > +	struct ocelot_fdma_dcb *dcb;
> > +	int i;
> > +
> > +	ocelot_fdma_writel(fdma, MSCC_FDMA_INTR_ENA, 0);
> > +
> > +	ocelot_fdma_stop_channel(fdma, MSCC_FDMA_XTR_CHAN);
> > +	ocelot_fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
> > +
> > +	/* Free the SKB hold in the extraction ring */
> > +	for (i = 0; i < OCELOT_FDMA_MAX_DCB; i++) {
> > +		dcb = &ring->dcbs[i];
> > +		dev_kfree_skb_any(dcb->skb);
> > +	}
> > +
> > +	napi_synchronize(&fdma->napi);
> > +	napi_disable(&fdma->napi);
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethernet/mscc/ocelot_fdma.h
> > new file mode 100644
> > index 000000000000..b6f1dda0e0c7
> > --- /dev/null
> > +++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
> > @@ -0,0 +1,96 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/*
> > + * Microsemi SoCs FDMA driver
> > + *
> > + * Copyright (c) 2021 Microchip
> > + */
> > +#ifndef _MSCC_OCELOT_FDMA_H_
> > +#define _MSCC_OCELOT_FDMA_H_
> > +
> > +#include "ocelot.h"
> > +
> > +#define OCELOT_FDMA_MAX_DCB		128
> > +/* +4 allows for word alignment after allocation */
> > +#define OCELOT_DCBS_HW_ALLOC_SIZE	(OCELOT_FDMA_MAX_DCB * \
> > +					 sizeof(struct ocelot_fdma_dcb_hw_v2) + \
> > +					 4)
> > +
> > +struct ocelot_fdma_dcb_hw_v2 {
> > +	u32 llp;
> > +	u32 datap;
> > +	u32 datal;
> > +	u32 stat;
> > +};  
> 
> Could you declare this using __attribute((packed)) to show that you're
> mapping it over hardware?

Ok.

> 
> > +
> > +/**
> > + * struct ocelot_fdma_dcb - Software DCBs description
> > + *
> > + * @hw: hardware DCB used by hardware(coherent memory)
> > + * @hw_dma: DMA address of the DCB
> > + * @skb: skb associated with the DCB
> > + * @mapping: Address of the skb data mapping
> > + * @mapped_size: Mapped size
> > + */
> > +struct ocelot_fdma_dcb {
> > +	struct ocelot_fdma_dcb_hw_v2	*hw;
> > +	dma_addr_t			hw_dma;
> > +	struct sk_buff			*skb;
> > +	dma_addr_t			mapping;
> > +	size_t				mapped_size;
> > +};
> > +
> > +/**
> > + * struct ocelot_fdma_ring - "Ring" description of DCBs
> > + *
> > + * @hw_dcbs: Hardware DCBs allocated for the ring
> > + * @hw_dcbs_dma: DMA address of the DCBs
> > + * @dcbs: List of software DCBs
> > + * @head: pointer to first available DCB
> > + * @tail: pointer to last available DCB
> > + */
> > +struct ocelot_fdma_ring {
> > +	struct ocelot_fdma_dcb_hw_v2	*hw_dcbs;
> > +	dma_addr_t			hw_dcbs_dma;
> > +	struct ocelot_fdma_dcb		dcbs[OCELOT_FDMA_MAX_DCB];
> > +	unsigned int			head;
> > +	unsigned int			tail;
> > +};
> > +
> > +/**
> > + * struct ocelot_fdma - FMDA struct  
> 
> s/FMDA/FDMA/
> 
> > + *
> > + * @ocelot: Pointer to ocelot struct
> > + * @base: base address of FDMA registers
> > + * @irq: FDMA interrupt
> > + * @dev: Ocelot device
> > + * @napi: napi handle
> > + * @rx_buf_size: Size of RX buffer
> > + * @inj: Injection ring
> > + * @xtr: Extraction ring
> > + * @xmit_lock: Xmit lock
> > + *
> > + */
> > +struct ocelot_fdma {
> > +	struct ocelot			*ocelot;  
> 
> To me, this structure organization in which "struct ocelot_fdma *" is
> passed as argument to all FDMA functions, instead of "struct ocelot *",
> is strange, and leads to oddities such as this backpointer right here.
> Do it in whichever way you want, I'm just pointing this out.

Ok, I'll probably pass a ocelot pointer for all of them to be more
coherent.

> 
> > +	void __iomem			*base;
> > +	int				irq;
> > +	struct device			*dev;
> > +	struct napi_struct		napi;
> > +	struct net_device		*ndev;
> > +	size_t				rx_buf_size;
> > +	struct ocelot_fdma_ring		inj;
> > +	struct ocelot_fdma_ring		xtr;
> > +	spinlock_t			xmit_lock;
> > +};
> > +
> > +struct ocelot_fdma *ocelot_fdma_init(struct platform_device *pdev,
> > +				     struct ocelot *ocelot);
> > +int ocelot_fdma_start(struct ocelot_fdma *fdma);
> > +int ocelot_fdma_stop(struct ocelot_fdma *fdma);
> > +int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew_op,
> > +			     struct sk_buff *skb, struct net_device *dev);
> > +void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct net_device *dev);
> > +void ocelot_fdma_netdev_deinit(struct ocelot_fdma *fdma,
> > +			       struct net_device *dev);
> > +
> > +#endif
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index b589ae95e29b..9dcaf421da12 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -15,6 +15,7 @@
> >  #include <net/pkt_cls.h>
> >  #include "ocelot.h"
> >  #include "ocelot_vcap.h"
> > +#include "ocelot_fdma.h"
> >  
> >  #define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
> >  
> > @@ -457,7 +458,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >  	int port = priv->chip_port;
> >  	u32 rew_op = 0;
> >  
> > -	if (!ocelot_can_inject(ocelot, 0))
> > +	if (!ocelot->fdma && !ocelot_can_inject(ocelot, 0))
> >  		return NETDEV_TX_BUSY;
> >  
> >  	/* Check if timestamping is needed */
> > @@ -475,9 +476,13 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
> >  		rew_op = ocelot_ptp_rew_op(skb);
> >  	}
> >  
> > -	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
> > +	if (ocelot->fdma) {
> > +		ocelot_fdma_inject_frame(ocelot->fdma, port, rew_op, skb, dev);
> > +	} else {
> > +		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);  
> 
> I can't help but think how painful it is that with a CPU as slow as
> yours, insult over injury, you also need to check for each packet
> whether the device tree had defined the "fdma" region or not, because
> you practically keep two traffic I/O implementations due to that sole
> reason. I think for the ocelot switchdev driver, which is strictly for
> MIPS CPUs embedded within the device, it should be fine to introduce a
> static key here (search for static_branch_likely in the kernel).

I thinked about it *but* did not wanted to add a key since it would be
global. However, we could consider that there is always only one
instance of the driver and indeed a static key is an option.
Unfortunately, I'm not sure this will yield any noticeable performance
improvement.

> 
> >  
> > -	kfree_skb(skb);
> > +		consume_skb(skb);
> > +	}
> >  
> >  	return NETDEV_TX_OK;
> >  }
> > @@ -1717,6 +1722,9 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
> >  	if (err)
> >  		goto out;
> >  
> > +	if (ocelot->fdma)
> > +		ocelot_fdma_netdev_init(ocelot->fdma, dev);
> > +
> >  	err = register_netdev(dev);
> >  	if (err) {
> >  		dev_err(ocelot->dev, "register_netdev failed\n");
> > @@ -1737,9 +1745,13 @@ void ocelot_release_port(struct ocelot_port *ocelot_port)
> >  	struct ocelot_port_private *priv = container_of(ocelot_port,
> >  						struct ocelot_port_private,
> >  						port);
> > +	struct ocelot_fdma *fdma = ocelot_port->ocelot->fdma;
> >  
> >  	unregister_netdev(priv->dev);
> >  
> > +	if (fdma)
> > +		ocelot_fdma_netdev_deinit(fdma, priv->dev);
> > +
> >  	if (priv->phylink) {
> >  		rtnl_lock();
> >  		phylink_disconnect_phy(priv->phylink);
> > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > index 38103b0255b0..fa68eb23a333 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > @@ -18,6 +18,7 @@
> >  
> >  #include <soc/mscc/ocelot_vcap.h>
> >  #include <soc/mscc/ocelot_hsio.h>
> > +#include "ocelot_fdma.h"
> >  #include "ocelot.h"
> >  
> >  static const u32 ocelot_ana_regmap[] = {
> > @@ -1080,6 +1081,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  		ocelot->targets[io_target[i].id] = target;
> >  	}
> >  
> > +	ocelot->fdma = ocelot_fdma_init(pdev, ocelot);
> > +	if (IS_ERR(ocelot->fdma))
> > +		ocelot->fdma = NULL;
> > +
> >  	hsio = syscon_regmap_lookup_by_compatible("mscc,ocelot-hsio");
> >  	if (IS_ERR(hsio)) {
> >  		dev_err(&pdev->dev, "missing hsio syscon\n");
> > @@ -1139,6 +1144,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >  	if (err)
> >  		goto out_ocelot_devlink_unregister;
> >  
> > +	if (ocelot->fdma) {
> > +		err = ocelot_fdma_start(ocelot->fdma);
> > +		if (err)
> > +			goto out_ocelot_release_ports;
> > +	}
> > +
> >  	err = ocelot_devlink_sb_register(ocelot);
> >  	if (err)
> >  		goto out_ocelot_release_ports;
> > @@ -1179,6 +1190,8 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
> >  {
> >  	struct ocelot *ocelot = platform_get_drvdata(pdev);
> >  
> > +	if (ocelot->fdma)
> > +		ocelot_fdma_stop(ocelot->fdma);
> >  	devlink_unregister(ocelot->devlink);
> >  	ocelot_deinit_timestamp(ocelot);
> >  	ocelot_devlink_sb_unregister(ocelot);
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index b3381c90ff3e..351ab385ab98 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -695,6 +695,8 @@ struct ocelot {
> >  	/* Protects the PTP clock */
> >  	spinlock_t			ptp_clock_lock;
> >  	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
> > +
> > +	struct ocelot_fdma		*fdma;
> >  };
> >  
> >  struct ocelot_policer {
> > @@ -761,6 +763,8 @@ void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32 rew_op,
> >  			 u32 vlan_tag);
> >  int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
> >  void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
> > +void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
> > +			     u64 timestamp);
> >  
> >  /* Hardware initialization */
> >  int ocelot_regfields_init(struct ocelot *ocelot,
> > -- 
> > 2.33.1
>   

Thanks for the review.

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
