Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059A958850B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 02:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiHCAKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 20:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiHCAJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 20:09:59 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A544E1C923;
        Tue,  2 Aug 2022 17:09:56 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc11a.ng.seznam.cz (email-smtpc11a.ng.seznam.cz [10.23.11.75])
        id 2121fdefc58d2ed120fc5c81;
        Wed, 03 Aug 2022 02:09:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659485348; bh=HA5Y825VMGVOuI5TVggtLeVYVZP87fWzRW0FTaC3iHs=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-szn-frgn:X-szn-frgc;
        b=Z9lQBxirEtpZdUPE25mgzljMup9yWnMJn2dD2m850vYsPw0CBj4kr9MB9EDx4D29e
         uLJ2oc7Sy5XDP1o93zOszHD6sqTqhWrsH3n0nTARdGyZyIxRzKrDUvtKewSM+M7e70
         VD9EkZbafR2KXn6QQOwzBBlYIrTrm0etnyjlmIBA=
Received: from hopium (2a02:8308:900d:2400:7ae4:b662:61f6:6059 [2a02:8308:900d:2400:7ae4:b662:61f6:6059])
        by email-relay6.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Wed, 03 Aug 2022 02:09:04 +0200 (CEST)  
Date:   Wed, 3 Aug 2022 02:09:03 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220803000903.GB4457@hopium>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
X-szn-frgn: <93e1d620-ba65-4265-bfa1-2b05c0e6005a>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for your review. I see I forgot to put dt bindings as the first
commit, I've reordered it locally so I won't forget again.

On Tue, Aug 02, 2022 at 11:29:07AM +0200, Marc Kleine-Budde wrote:
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucanfd/ctucanfd.h
> > index 0e9904f6a05d..43d9c73ce244 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd.h
> > +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> > @@ -23,6 +23,10 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/can/dev.h>
> >  #include <linux/list.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/workqueue.h>
> > +
> > +#define CTUCANFD_MAX_WORK_DELAY_SEC 86400U	/* one day == 24 * 3600 seconds */
> 
> For higher precision we can limit this to 3600s, as the sched_clock does
> it
> :
> | https://elixir.bootlin.com/linux/v5.19/source/kernel/time/sched_clock.c#L169

Sure, the one day limit was rather arbitrary, I wanted to keep the load
on the system minimal.

> >  enum ctu_can_fd_can_registers;
> >  
> > @@ -51,6 +55,15 @@ struct ctucan_priv {
> >  	u32 rxfrm_first_word;
> >  
> >  	struct list_head peers_on_pdev;
> > +
> > +	struct cyclecounter cc;
> > +	struct timecounter tc;
> > +	struct delayed_work timestamp;
> > +
> > +	struct clk *timestamp_clk;
> > +	u32 work_delay_jiffies;
> 
> schedule_delayed_work() takes an "unsigned long" not a u32.
> 

Ok I'll cast the u32 to unsigned long, as 'long' is guaranteed to be at
least 32 bits.

> > @@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv *priv, enum ctu_can_fd_can_r
> >  	priv->write_reg(priv, buf_base + offset, val);
> >  }
> >  
> > +static u64 concatenate_two_u32(u32 high, u32 low)
> 
> static inline?
> 

Sure, inline seems reasonable here.

> > +{
> > +	return ((u64)high << 32) | ((u64)low);
> > +}
> > +
> > @@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *c
> >  	if (unlikely(len > wc * 4))
> >  		len = wc * 4;
> >  
> > -	/* Timestamp - Read and throw away */
> > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	/* Timestamp */
> > +	tstamp_low = ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	tstamp_high = ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	*timestamp = concatenate_two_u32(tstamp_high, tstamp_low) & priv->cc.mask;
> >  
> >  	/* Data */
> >  	for (i = 0; i < len; i += 4) {
> > @@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
> >  	struct net_device_stats *stats = &ndev->stats;
> >  	struct canfd_frame *cf;
> >  	struct sk_buff *skb;
> > +	u64 timestamp;
> >  	u32 ffw;
> >  
> >  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> > @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
> >  		return 0;
> >  	}
> >  
> > -	ctucan_read_rx_frame(priv, cf, ffw);
> > +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> > +	if (priv->timestamp_enabled)
> > +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> 
> Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counter()
> happen concurrently? AFAICS they are all called from ctucan_rx_poll(),
> right?

Yes, I see no problem when two ctucan_read_timestamp_counter run
concurrently, same goes for two ctucan_skb_set_timestamp and 
ctucan_skb_set_timestamp concurrently with
ctucan_read_timestamp_counter.
The _counter() function only reads from the core's registers and returns
a new timestamp. The _set_timestamp() only writes to the skb, but the
skb will be allocated new in every _rx_poll() call.

The only concurrency issue I can remotely see is when the periodic worker
updates timecounter->cycle_last, right when the value is used in
timecounter_cyc2time (from _set_timestamp()). But I don't think this is
worth using some synchronization primitive.

> 
> >  
> >  	stats->rx_bytes += cf->len;
> >  	stats->rx_packets++;

> > @@ -1263,6 +1306,9 @@ static int ctucan_close(struct net_device *ndev)
> >  	ctucan_chip_stop(ndev);
> >  	free_irq(ndev->irq, ndev);
> >  	close_candev(ndev);
> > +	if (priv->timestamp_possible)
> > +		ctucan_timestamp_stop(priv);
> > +
> 
> Nitpick: Don't add an extra newline here.
> 

Ok, I've deleted the extra newline (one is still here below btw - seems
to me you're pointing out that the code isn't in one continuous block;
double newline wouldn't be a nitpick for me).

> >  
> >  	pm_runtime_put(priv->dev);
> >  
> > @@ -1345,6 +1493,8 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >  	struct ctucan_priv *priv;
> >  	struct net_device *ndev;
> >  	int ret;
> > +	u32 timestamp_freq = 0;
> > +	u32 timestamp_bit_size = 0;
> 
> Nitpick: please move the u32 between the struct and the int.

Ack.

> 
> >  
> >  	/* Create a CAN device instance */
> >  	ndev = alloc_candev(sizeof(struct ctucan_priv), ntxbufs);
> > @@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >  
> >  	/* Getting the can_clk info */
> >  	if (!can_clk_rate) {
> > -		priv->can_clk = devm_clk_get(dev, NULL);
> > +		priv->can_clk = devm_clk_get_optional(dev, "core-clk");
> > +		if (!priv->can_clk)
> > +			priv->can_clk = devm_clk_get(dev, NULL);
> 
> Please add a comment here, that the NULL clock is for compatibility with
> older DTs.

Even in this patch the clock-names isn't a required property in the DT.
But I can add a comment explaining the situation.

> 
> >  		if (IS_ERR(priv->can_clk)) {
> >  			dev_err(dev, "Device clock not found.\n");
> >  			ret = PTR_ERR(priv->can_clk);
> > @@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >  
> >  	priv->can.clock.freq = can_clk_rate;
> >  
> > +	priv->timestamp_enabled = false;
> > +	priv->timestamp_possible = true;
> > +	priv->timestamp_clk = NULL;
> 
> priv is allocated and initialized with 0

Ok, false and NULL deleted.

> 
> > +
> > +	/* Obtain timestamping frequency */
> > +	if (pm_enable_call) {
> > +		/* Plaftorm device: get tstamp clock from device tree */
> > +		priv->timestamp_clk = devm_clk_get(dev, "ts-clk");
> > +		if (IS_ERR(priv->timestamp_clk)) {
> > +			/* Take the core clock frequency instead */
> > +			timestamp_freq = can_clk_rate;
> > +		} else {
> > +			timestamp_freq = clk_get_rate(priv->timestamp_clk);
> > +		}
> 
> Who prepares/enabled the timestamp clock? clk_get_rate() is only valid if
> the clock is enabled. I know, we violate this for the CAN clock. :/
> > +	} else {
> > +		/* PCI device: assume tstamp freq is equal to bus clk rate */
> > +		timestamp_freq = can_clk_rate;
> > +	}
> > +
> > +	/* Obtain timestamping counter bit size */
> > +	timestamp_bit_size = (ctucan_read32(priv, CTUCANFD_ERR_CAPT) & REG_ERR_CAPT_TS_BITS) >> 24;
> > +	timestamp_bit_size += 1;	/* the register value was bit_size - 1 */
> 
> Please move the +1 into the else of the following if() which results in:
> 
> | if (timestamp_bit_size)
> 
> which is IMHO easier to read.

Sure I'll move it (into the 'if' branch).

> > +
> > +	/* For 2.x versions of the IP core, we will assume 64-bit counter
> > +	 * if there was a 0 in the register.
> > +	 */
> > +	if (timestamp_bit_size == 1) {
> > +		u32 version_reg = ctucan_read32(priv, CTUCANFD_DEVICE_ID);
> > +		u32 major = (version_reg & REG_DEVICE_ID_VER_MAJOR) >> 24;
> > +
> > +		if (major == 2)
> > +			timestamp_bit_size = 64;
> > +		else
> > +			priv->timestamp_possible = false;
> > +	}
> > +
> > +	/* Setup conversion constants and work delay */
> > +	priv->cc.read = ctucan_read_timestamp_cc_wrapper;
> > +	priv->cc.mask = CYCLECOUNTER_MASK(timestamp_bit_size);
> 
> Does the driver use these 2 if timestamping is not possible?

Cc.mask is always used in ctucan_read_rx_frame(), cc.read isn't used
when timestamps aren't possible. I can move cc.read inside the 'if' for
maximal efficiency.

> 
> > +	if (priv->timestamp_possible) {
> > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq,
> > +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > +		priv->work_delay_jiffies =
> > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> > +		if (priv->work_delay_jiffies == 0)
> > +			priv->timestamp_possible = false;
> 
> You'll get a higher precision if you take the mask into account, at
> least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
> 
>         maxsec = min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask / timestamp_freq);
> 	
>         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq, NSEC_PER_SEC,  maxsec);
>         work_delay_in_ns = clocks_calc_max_nsecs(&priv->cc.mult, &priv->cc.shift, 0, &priv->cc.mask, NULL);
> 
> You can use clocks_calc_max_nsecs() to calculate the work delay.

This is a good point, thanks. I'll incorporate it into the patch.


Best regards,
Matej

> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


