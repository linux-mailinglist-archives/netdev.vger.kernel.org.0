Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCF2B2438
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgKMTCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:02:53 -0500
Received: from mailout09.rmx.de ([94.199.88.74]:58866 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMTCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:02:53 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4CXnsf5Fn8zblG3;
        Fri, 13 Nov 2020 20:02:46 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CXnsL0K9Zz2TTM6;
        Fri, 13 Nov 2020 20:02:30 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.24) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 13 Nov
 2020 19:58:44 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 09/11] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Fri, 13 Nov 2020 19:57:32 +0100
Message-ID: <4328015.hLoEoa8eMr@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201113024020.ixzrpjxjfwme3wur@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-10-ceggers@arri.de> <20201113024020.ixzrpjxjfwme3wur@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.24]
X-RMX-ID: 20201113-200236-4CXnsL0K9Zz2TTM6-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 03:40:20 CET, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 04:35:35PM +0100, Christian Eggers wrote:
[...]
> > @@ -103,6 +108,10 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info
> > *ptp, s64 delta)> 
> >  	if (ret)
> >  	
> >  		goto error_return;
> > 
> > +	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
> 
> I believe that spin_lock_irqsave is unnecessary, since there is no code
> that runs in hardirq context.
I'll check this again. Originally I had only a mutex for everything, but later
it turned out that for ptp_clock_time a spinlock is required. Maybe this has
changed since starting of my work on the driver.

> 
> > +	dev->ptp_clock_time = timespec64_add(dev->ptp_clock_time, delta64);
> > +	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
> > +

[...]

> Could we make this line shorter?
...
> Additionally, you exceed the 80 characters limit.
...
> Also, you exceeded 80 characters by quite a bit.
...
> In networking we still have the 80-characters rule, please follow it.
Can this be added to the netdev-FAQ (just below the section about 
"comment style convention")?

> > +static void ksz9477_ptp_ports_deinit(struct ksz_device *dev)
> > +{
> > +	int port;
> > +
> > +	for (port = dev->port_cnt - 1; port >= 0; --port)
> 
> Nice, but also probably not worth the effort?
What do you mean. Shall I used forward direction?

> 
> > +		ksz9477_ptp_port_deinit(dev, port);
> > +}
> 

[...]

> > +bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port, struct
> > sk_buff *clone, +			       unsigned int type)
> > +{
> > +	struct ksz_device *dev = ds->priv;
> > +	struct ksz_port *prt = &dev->ports[port];
> > +	struct ptp_header *hdr;
> > +
> > +	/* KSZ9563 supports PTPv2 only */
> > +	if (!(type & PTP_CLASS_V2))
> > +		return false;
> 
> It should be sufficient that you specified this in the
> config->rx_filters from ksz9477_set_hwtstamp_config? I'm not even sure
> who uses PTP v1 anyway.
> 
> > +
> > +	/* Should already been tested in dsa_skb_tx_timestamp()? */
> > +	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
> > +		return false;
> 
> Yeah, should have...
> What do you think about this one though:
> https://lore.kernel.org/netdev/20201104015834.mcn2eoibxf6j3ksw@skbuf/
I am not an expert for performance stuff. But for me it looks obvious that
cheaper checks should be performed first. What about also moving checking
for ops->port_txtstamp above ptp_classify_raw()?

Is there any reason why this isn't already applied?

> 
> > +
> > +	hdr = ksz9477_ptp_should_tstamp(prt, clone, type);
> > +	if (!hdr)
> > +		return false;
> > +
> > +	if (test_and_set_bit_lock(KSZ_HWTSTAMP_TX_XDELAY_IN_PROGRESS,
> > +				  &prt->tstamp_state))
> > +		return false;  /* free cloned skb */
> > +
> > +	prt->tstamp_tx_xdelay_skb = clone;
> 
> Who do you think will guarantee you that a second timestampable packet
> may not come in before the TX timestamp interrupt for the first one has
> fired?
> 
> Either the hardware supports matching a TX timestamp to a PTP event
> message (by sequenceId or whatnot),
it doesn't

> case in which you need more complex
> logic in the IRQ handler, or the hardware can take a single TX timestamp
> at a time, 
yes

> case in which you'll need an skb_queue and a process context
> to wait for the TX timestamp of the previous PTP message before calling
> dsa_enqueue_skb for the next PTP event message. There are already
> implementations of both models in DSA that you can look at.
In the past I got sometimes a "timeout waiting for hw timestamp" (or similar)
message from ptp4l. I am not sure whether this is still the case, but this may
explain this type of problems.

> 
> > +
> > +	return true;  /* keep cloned skb */
> > +}
> 

[...]

> > diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> > index 4820dbcedfa2..c16eb9eae19c 100644
> > --- a/net/dsa/tag_ksz.c
> > +++ b/net/dsa/tag_ksz.c

[...]

> > 
> > +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
> > +/* Time stamp tag is only inserted if PTP is enabled in hardware. */
> > +static void ksz9477_xmit_timestamp(struct sk_buff *skb)
> > +{
> > +	/* We send always 0 in the tail tag.  For PDelay_Resp, the ingress
> > +	 * time stamp of the PDelay_Req message has already been subtracted from
> > +	 * the correction field on rx.
> > +	 */
> > +	put_unaligned_be32(0, skb_put(skb, KSZ9477_PTP_TAG_LEN));
> > +}
> 
> On TX you don't need the "PTP time stamp" field at all, can't you
> disable it?

No :-( 

From the data sheet, section 4.4.9:

"In the host-to-switch direction, the 4-byte timestamp field is always present when PTP is enabled, as shown in Figure 4-
6. This is true for all packets sent by the host, including IBA packets. The host uses this field to insert the receive time-
stamp from PTP Pdelay_Req messages into the Pdelay_Resp messages. For all other traffic and PTP message types,
the host should populate the timestamp field with zeros."

> 
> > +
> > +ktime_t ksz9477_tstamp_to_clock(struct ksz_device *ksz, ktime_t tstamp)
> > +{
> > +	struct timespec64 ts = ktime_to_timespec64(tstamp);
> > +	struct timespec64 ptp_clock_time;
> > +	struct timespec64 diff;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ksz->ptp_clock_lock, flags);
> > +	ptp_clock_time = ksz->ptp_clock_time;
> > +	spin_unlock_irqrestore(&ksz->ptp_clock_lock, flags);
> > +
> > +	/* calculate full time from partial time stamp */
> > +	ts.tv_sec = (ptp_clock_time.tv_sec & ~3) | ts.tv_sec;
> > +
> > +	/* find nearest possible point in time */
> > +	diff = timespec64_sub(ts, ptp_clock_time);
> > +	if (diff.tv_sec > 2)
> > +		ts.tv_sec -= 4;
> > +	else if (diff.tv_sec < -2)
> > +		ts.tv_sec += 4;
> > +
> > +	return timespec64_to_ktime(ts);
> > +}
> > +EXPORT_SYMBOL(ksz9477_tstamp_to_clock);
> 
> It should be noted that I tried to find fault with this simplistic
> implementation, where you just reconstruct the partial timestamp with
> whatever PTP time you've got laying around, but I couldn't (or at least
> I couldn't prove it).
> 
> In principle there should be a problem when the current PTP time wraps
> around before you get the chance to reconstruct the partial timestamp.
> That one you can detect by ensuring that the partial timestamp is larger
> than the lower bits of the current PTP time. But that imposes the
> restriction that the current PTP time must be collected after the
> partial timestamp was taken by the MAC. And that means that PTP
> timestamping must be done in process context, because it's accessing
> SPI/I2C. Which means a very convoluted implementation, a nightmare
> frankly.
> 
> The way you seem to be avoiding this, while still detecting the
> wraparound case, is that you're just patching in the partial timestamp
> into the "current" (i.e. at most 1 second old) PTP time, and then you
> take a look at how well it fits. If the diff is larger than half the
> wraparound interval, and positive (like: the "current" PTP time was
> collected by the driver after the MAC took the partial timestamp), then
> the current PTP time is too far ahead and must have wrapped around. If
> the diff is large but negative (like: the partial timestamp, which is in
> the "current" PTP time's future, has wrapped around), then the "current"
> PTP time needs to be manually boosted.
> 
> This all seems to work because you have a somewhat workable budget of 4
> seconds wraparound time. I am not sure that reading the PTP time once
> per second is desirable under all circumstances if avoidable, and
> there's also an even bigger assumption, which is that the PTP worker
> will in fact get scheduled with a delay no larger than 2 seconds. I
> suppose that is an academic only concern though.
> 
> So good for you that you can use a function so simple for timestamp
> reconstruction. 
You already told me that another hardware has much less budget than 4 seconds.
How is timestamp reconstruction done there? Is there any code which I should
reuse?

> By the way, what about the name ksz9477_tstamp_reconstruct?
it's ok.

> I don't exactly understand where does the "tstamp_to_clock" name come
> from.
Invented by me. The function "converts" a time stamp into the "clock" time. 
But "reconstruct" fits better than "convert".

> 
> > +
> > +static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
> > +				  struct net_device *dev, unsigned int port)
> > +{
> > +	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
> > +	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
> > +	enum ksz9477_ptp_event_messages msg_type;
> > +	struct dsa_switch *ds = dev->dsa_ptr->ds;
> > +	struct ksz_device *ksz = ds->priv;
> > +	struct ksz_port *prt = &ksz->ports[port];
> > +	struct ptp_header *ptp_hdr;
> > +	unsigned int ptp_type;
> > +	ktime_t tstamp;
> > +
> > +	/* convert time stamp and write to skb */
> > +	tstamp = ksz9477_decode_tstamp(get_unaligned_be32(tstamp_raw),
> > +				       -prt->tstamp_rx_latency_ns);
> > +	memset(hwtstamps, 0, sizeof(*hwtstamps));
> > +	hwtstamps->hwtstamp = ksz9477_tstamp_to_clock(ksz, tstamp);
> > +
> > +	/* For PDelay_Req messages, user space (ptp4l) expects that the hardware
> > +	 * subtracts the ingress time stamp from the correction field.  The
> > +	 * separate hw time stamp from the sk_buff struct will not be used in
> > +	 * this case.
> > +	 */
> > +	if (skb_headroom(skb) < ETH_HLEN)
> > +		return;
> 
> And what does the comment have to do with the code?
The comment if for the whole remaining part of the function, not for the single line.
>
> > +
> > +	__skb_push(skb, ETH_HLEN);
> > +	ptp_type = ptp_classify_raw(skb);
> > +	__skb_pull(skb, ETH_HLEN);
> > +
> > +	if (ptp_type == PTP_CLASS_NONE)
> > +		return;
> > +
> > +	ptp_hdr = ptp_parse_header(skb, ptp_type);
> > +	if (!ptp_hdr)
> > +		return;
> > +
> > +	msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
> > +	if (msg_type != PTP_Event_Message_Pdelay_Req)
> > +		return;
> 
> Would you be so generous to also modify ptp_get_msgtype to return this
> enum of yours? There is also some opportunity for reuse with
> drivers/ptp/ptp_ines.c.
no problem.

> > +
> > +	/* Only subtract partial time stamp from the correction field.  When the
> > +	 * hardware adds the egress time stamp to the correction field of the
> > +	 * PDelay_Resp message on tx, also only the partial time stamp will be
> > +	 * added.
> > +	 */
> > +	ptp_onestep_p2p_move_t2_to_correction(skb, ptp_type, ptp_hdr, tstamp);
> > +}
> > +#else   /* IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP) */
> > +static void ksz9477_xmit_timestamp(struct sk_buff *skb __maybe_unused)
> > +{
> > +}
> > +
> > +static void ksz9477_rcv_timestamp(struct sk_buff *skb __maybe_unused, u8
> > *tag __maybe_unused, +				  struct net_device *dev __maybe_unused,
> > +				  unsigned int port __maybe_unused)
> 
> Where did you see __maybe_unused being utilized in this way? And what's
> so "maybe" about it? They are absolutely unused, and the compiler should
> not complain. Please remove these variable attributes.
ok, __always_unused would fit.

I added the attributes due to Documentation/process/4.Coding.rst:

"Code submitted for review should, as a rule, not produce any compiler
warnings." [...] "Note that not all compiler warnings are enabled by default.  Build the
kernel with "make EXTRA_CFLAGS=-W" to get the full set."

I assumed that reducing the number of warnings raised by "-W" should be reduced
as a long term goal. Is this wrong.

Side note: Documentation/kbuild/makefiles.rst declares usage of EXTRA_CFLAGS as
deprecated.

[...]
> 
> Long and exhausting patch... Could you split it up into a patch for the
> control path and another one for the data path?
I am not sure whether the result will exactly look as you expect, but I'll try.

Thanks a lot for the fast and comprehensive review! As soon as I get your
answer regarding patch 3/11 (split ksz_common.h), I will perform the changes.

Have a nice weekend
Christian



