Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80897BAE3
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 09:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGaHqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 03:46:13 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:39835 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGaHqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 03:46:13 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A5410FF803;
        Wed, 31 Jul 2019 07:46:09 +0000 (UTC)
Date:   Wed, 31 Jul 2019 09:46:09 +0200
From:   "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next v4 6/6] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190731074609.GA3579@kwain>
References: <20190725142707.9313-1-antoine.tenart@bootlin.com>
 <20190725142707.9313-7-antoine.tenart@bootlin.com>
 <2b70e0fbebf1875c51272f3005271a9aec68f00f.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b70e0fbebf1875c51272f3005271a9aec68f00f.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Saeed,

On Fri, Jul 26, 2019 at 08:52:10PM +0000, Saeed Mahameed wrote:
> On Thu, 2019-07-25 at 16:27 +0200, Antoine Tenart wrote:
> >  
> >  	dev->stats.tx_packets++;
> >  	dev->stats.tx_bytes += skb->len;
> > -	dev_kfree_skb_any(skb);
> > +
> > +	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP &&
> > +	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> > +		struct ocelot_skb *oskb =
> > +			kzalloc(sizeof(struct ocelot_skb), GFP_ATOMIC);
> > +
> 
> Device drivers normally pre allocate descriptor info ring array to
> avoid dynamic atomic allocations of private data on data path.

This depends on drivers. It's a good thing to do but I don't think it's
required here for a first version, we can improve this later.

> > +		oskb->skb = skb;
> > +		oskb->id = port->ts_id % 4;
> > +		port->ts_id++;
> 
> missing skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS; ?
> see 3.1 Hardware Timestamping Implementation: Device Drivers
> https://www.kernel.org/doc/Documentation/networking/timestamping.txt

Right, I'll add this.

> > +void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64
> > *ts)
> > +{
> > +	unsigned long flags;
> > +	u32 val;
> > +
> > +	spin_lock_irqsave(&ocelot->ptp_clock_lock, flags);
> > +
> > +	/* Read current PTP time to get seconds */
> > +	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, TOD_ACC_PIN);
> > +
> > +	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK |
> > PTP_PIN_CFG_DOM);
> > +	val |= PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_SAVE);
> > +	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, TOD_ACC_PIN);
> > +	ts->tv_sec = ocelot_read_rix(ocelot, PTP_PIN_TOD_SEC_LSB,
> > TOD_ACC_PIN);
> > +
> > +	/* Read packet HW timestamp from FIFO */
> > +	val = ocelot_read(ocelot, SYS_PTP_TXSTAMP);
> > +	ts->tv_nsec = SYS_PTP_TXSTAMP_PTP_TXSTAMP(val);
> > +
> > +	/* Sec has incremented since the ts was registered */
> > +	if ((ts->tv_sec & 0x1) != !!(val &
> > SYS_PTP_TXSTAMP_PTP_TXSTAMP_SEC))
> > +		ts->tv_sec--;
> > +
> > +	spin_unlock_irqrestore(&ocelot->ptp_clock_lock, flags);
> > +}
> > +EXPORT_SYMBOL(ocelot_get_hwtimestamp);
> > +
> 
> Why EXPORT_SYMBOL? this is the last patch and it is touching one
> driver.

Because the function is used in ocelot_board.c, which can be part of
another module (the mscc/ driver provides 2 modules). You can find
other examples of this in this driver.

> > @@ -98,7 +100,11 @@ static irqreturn_t ocelot_xtr_irq_handler(int
> > irq, void *arg)
> >  		int sz, len, buf_len;
> >  		u32 ifh[4];
> >  		u32 val;
> > -		struct frame_info info;
> > +		struct frame_info info = {};
> > +		struct timespec64 ts;
> > +		struct skb_shared_hwtstamps *shhwtstamps;
> > +		u64 tod_in_ns;
> > +		u64 full_ts_in_ns;
> 
> reverse xmas tree.

OK.

> > @@ -145,6 +151,22 @@ static irqreturn_t ocelot_xtr_irq_handler(int
> > irq, void *arg)
> >  			break;
> >  		}
> >  
> > +		if (ocelot->ptp) {
> > +			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
> > +
> > +			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
> > +			if ((tod_in_ns & 0xffffffff) < info.timestamp)
> > +				full_ts_in_ns = (((tod_in_ns >> 32) -
> > 1) << 32) |
> > +						info.timestamp;
> > +			else
> > +				full_ts_in_ns = (tod_in_ns &
> > GENMASK_ULL(63, 32)) |
> > +						info.timestamp;
> > +
> > +			shhwtstamps = skb_hwtstamps(skb);
> > +			memset(shhwtstamps, 0, sizeof(struct
> > skb_shared_hwtstamps));
> > +			shhwtstamps->hwtstamp = full_ts_in_ns;
> 
> the right way to set the timestamp is by calling: 
> skb_tstamp_tx(skb, &tstamp);

I'll fix this.

> > +static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
> > +{
> > +	int budget = OCELOT_PTP_QUEUE_SZ;
> > +	struct ocelot *ocelot = arg;
> > +
> > +	do {
> > +		struct skb_shared_hwtstamps shhwtstamps;
> > +		struct list_head *pos, *tmp;
> > +		struct sk_buff *skb = NULL;
> > +		struct ocelot_skb *entry;
> > +		struct ocelot_port *port;
> > +		struct timespec64 ts;
> > +		u32 val, id, txport;
> > +
> > +		/* Prevent from infinite loop */
> > +		if (unlikely(!--budget))
> > +			break;
> 
> when budget gets to 1 you break, while you still have 1 to go :)
> 
> I assume OCELOT_PTP_QUEUE_SZ > 0, just make this the loop condition and
> avoid infinite loops by design.

That's right, I'll fix it :)

> >  static int mscc_ocelot_probe(struct platform_device *pdev)
> >  {
> > -	int err, irq;
> >  	unsigned int i;
> > +	int err, irq_xtr, irq_ptp_rdy;
> >  	struct device_node *np = pdev->dev.of_node;
> >  	struct device_node *ports, *portnp;
> >  	struct ocelot *ocelot;
> 
> reverse xmas tree

Well, the xmas tree isn't there before my addition. Do you want me to
rework the whole variable definitions in this function (which is
completely unrelated to this patch)?

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
