Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153C9588029
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiHBQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbiHBQVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:21:10 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF8214D3D;
        Tue,  2 Aug 2022 09:21:06 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 174F230B294D;
        Tue,  2 Aug 2022 18:20:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=wnQBP
        TDb4HYMYFowmu4bACTl1LbtIBTkNCHjSM9zEbQ=; b=LIP1o1TAgFDR2XHJTeS0f
        s5KioYpR0uVH0P/3N6zkXQq6JeVrjKFF7sXvK/+apA+vYMionIG+XiRIjs25Gkha
        0YsIOAW63qkf7uCK9ar1opHcNn0BrUsZxtnlctrknQoQiQusuMKH/pcamaHkd4V1
        IH9ntMrR0FcHut1QnZcFWQcSBpBT5FRijmJSPtKInuYGaluDFhUbGAo85cGnlYqk
        OIAsSE22Ndv2reK8U0Kl9OU5q6jRtgTjiKCzhL34+wCfLdUi+8xoVB4bdWQ0DvKJ
        6a0Dz0x8yh3LYs9036IbPrBVeTVyZePLFbyMW5NJeTsdLWNHLC9iKzRTREiiTrR5
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id CBBF430ADE43;
        Tue,  2 Aug 2022 18:20:32 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 272GKWEJ032244;
        Tue, 2 Aug 2022 18:20:32 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 272GKWQh032243;
        Tue, 2 Aug 2022 18:20:32 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Tue, 2 Aug 2022 18:20:17 +0200
User-Agent: KMail/1.9.10
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
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
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <20220801184656.702930-2-matej.vasilevski@seznam.cz> <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
In-Reply-To: <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202208021820.17878.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

thanks for feedback.

On Tuesday 02 of August 2022 11:29:07 Marc Kleine-Budde wrote:
> On 01.08.2022 20:46:54, Matej Vasilevski wrote:
> > This patch adds support for retrieving hardware timestamps to RX and
> > error CAN frames. It uses timecounter and cyclecounter structures,
> > because the timestamping counter width depends on the IP core integration
> > (it might not always be 64-bit).
> > For platform devices, you should specify "ts_clk" clock in device tree.
> > For PCI devices, the timestamping frequency is assumed to be the same
> > as bus frequency.
> >
> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > ---
> >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> >  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
> >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 +++++++++++++++++-
> >  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
> >  4 files changed, 315 insertions(+), 8 deletions(-)
> >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
...
> > +	if (ts_high2 != ts_high)
> > +		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> > +
> > +	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> > +}
> > +
> >  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF,
> > ctucan_read32(priv, CTUCANFD_STATUS))) #define CTU_CAN_FD_ENABLED(priv)
> > (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
>
> please make these static inline bool functions.

We put that to TODO list. But I prefer to prepare separate followup
patch later.

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

I am not sure about which possible problem do you think.
But ctucan_read_timestamp_counter() is fully reentrant
and has no side effect on the core. So there is no
problem.

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

yes we need that for compatability with older devicetree builds
and I even consider even to keep option of simple DTS with single
clock without specific name even for future.

> >  		if (IS_ERR(priv->can_clk)) {
> >  			dev_err(dev, "Device clock not found.\n");
> >  			ret = PTR_ERR(priv->can_clk);
> > @@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void
> > __iomem *addr, int irq, unsigne
> >
> >  	priv->can.clock.freq = can_clk_rate;
> >
> > +	priv->timestamp_enabled = false;
> > +	priv->timestamp_possible = true;
> > +	priv->timestamp_clk = NULL;
>
> priv is allocated and initialized with 0

My personal low weight/priority opinion is to have this
visualized, reminded in the code. But I understand that
this add some unnecessary instructions...

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

Yes, I have noticed that we miss clk_prepare_enable() in the
ctucan_probe_common() and clk_disable_unprepare() in ctucan_platform_remove().
The need for clock running should be released in ctucan_suspend()
and regained in ctucan_resume(). I see that the most CAN drivers
use there clk_disable_unprepare/clk_prepare_enable but I am not
sure, if this is right. Ma be plain clk_disable/clk_enable should
be used for suspend and resume because as I understand, the clock
frequency can be recomputed and reset during clk_prepare which
would require to recompute bitrate. Do you have some advice
what is a right option there?

Actual omission is no problem on our systems, be the clock are used
in whole FPGA system with AXI connection and has to running already
and we use same for timestamping.

I would prefer to allow timestamping patch as it is without clock enable
and then correct clock enable, disable by another patch for both ts and core
clocks. 

> > +	} else {
> > +		/* PCI device: assume tstamp freq is equal to bus clk rate */
> > +		timestamp_freq = can_clk_rate;
> > +	}
> > +
> > +	/* Obtain timestamping counter bit size */
> > +	timestamp_bit_size = (ctucan_read32(priv, CTUCANFD_ERR_CAPT) &
> > REG_ERR_CAPT_TS_BITS) >> 24; +	timestamp_bit_size += 1;	/* the register
> > value was bit_size - 1 */
>
> Please move the +1 into the else of the following if() which results in:
> | if (timestamp_bit_size)
>
> which is IMHO easier to read.

OK

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

We have timestamping included in all previous and actual FPGA
designs so we can assume it unconditional for version 2.
It is missing in QEMU emulation for now but result is that registers
are read as zero. So you get incorrect timestamps but no fatal
error occurs. I plan to update QEMU to provide at least some
timestamp approximation values but that has low priority for now.

> > +	if (priv->timestamp_possible) {
> > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> > timestamp_freq, +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > +		priv->work_delay_jiffies =
> > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> > +		if (priv->work_delay_jiffies == 0)
> > +			priv->timestamp_possible = false;
>
> You'll get a higher precision if you take the mask into account, at
> least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
>
>         maxsec = min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask /
> timestamp_freq);
>
>         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> timestamp_freq, NSEC_PER_SEC,  maxsec); work_delay_in_ns =
> clocks_calc_max_nsecs(&priv->cc.mult, &priv->cc.shift, 0, &priv->cc.mask,
> NULL);
>
> You can use clocks_calc_max_nsecs() to calculate the work delay.
>
> regards,
> Marc

Thanks the review and support,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

