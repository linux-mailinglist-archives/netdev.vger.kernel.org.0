Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44F45898FC
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbiHDIIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239425AbiHDIIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:08:38 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF161DA4;
        Thu,  4 Aug 2022 01:08:36 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 46CD130B2954;
        Thu,  4 Aug 2022 10:08:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=AZz/N
        ENWs9CRJqf3LgglxOqTbQNjfSDjSrFDAj9pjfQ=; b=narV3dWmXYN1Dxr6ATrb0
        bYSsF6izLWaxkK+b4zu1HXzPqPLKMe9t3V2uvK0xFWrafY0Yy56B9V8S3KwER0Tu
        rbdElwnzdyzSFCG/YXwCadr3AnFJc3s/OhU+qlkO+qNT40VEDzs8aU3DqxX0yFyj
        QDZLJvGoEt8/pS0Fq2hrgZfk2o3zuawaMCX+nlNekxmZnzDAEj1bhfWM2JyCWdPf
        hfzDDypKgHrULv1j0q7M4QL7dlAQ337wg2bjUVka7LV2p9q0E518FrkBvjIvdhYz
        S/SoDELzivdbL1Ma+KLYCZSmfYcWI9jgv8+F27JWQkPu3naSKCabebDVg3bwNSfB
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id F1B0830B294D;
        Thu,  4 Aug 2022 10:08:32 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 27488WBI012865;
        Thu, 4 Aug 2022 10:08:32 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 27488W5p012864;
        Thu, 4 Aug 2022 10:08:32 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Thu, 4 Aug 2022 10:08:15 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <202208021820.17878.pisa@cmp.felk.cvut.cz> <20220803083718.7bh2edmsorwuv4vu@pengutronix.de>
In-Reply-To: <20220803083718.7bh2edmsorwuv4vu@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202208041008.15122.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Wednesday 03 of August 2022 10:37:18 Marc Kleine-Budde wrote:
> On 02.08.2022 18:20:17, Pavel Pisa wrote:
> > Hello Marc,
> >
> > thanks for feedback.
> >
> > On Tuesday 02 of August 2022 11:29:07 Marc Kleine-Budde wrote:
> > > On 01.08.2022 20:46:54, Matej Vasilevski wrote:
> > > > This patch adds support for retrieving hardware timestamps to RX and
> > > > error CAN frames. It uses timecounter and cyclecounter structures,
> > > > because the timestamping counter width depends on the IP core
> > > > integration (it might not always be 64-bit).
> > > > For platform devices, you should specify "ts_clk" clock in device
> > > > tree. For PCI devices, the timestamping frequency is assumed to be
> > > > the same as bus frequency.
> > > >
> > > > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > > > ---
> > > >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> > > >  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
> > > >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 214
> > > > +++++++++++++++++- drivers/net/can/ctucanfd/ctucanfd_timestamp.c | 
> > > > 87 +++++++ 4 files changed, 315 insertions(+), 8 deletions(-)
> > > >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> >
> > ...
> >
> > > > +	if (ts_high2 != ts_high)
> > > > +		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> > > > +
> > > > +	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> > > > +}
> > > > +
> > > >  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF,
> > > > ctucan_read32(priv, CTUCANFD_STATUS))) #define
> > > > CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA,
> > > > ctucan_read32(priv, CTUCANFD_MODE)))
> > >
> > > please make these static inline bool functions.
> >
> > We put that to TODO list. But I prefer to prepare separate followup
> > patch later.
>
> ACK. I noticed later that these were not modified by this patch. Sorry
> for the noise

OK

> > > > @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
> > > >  		return 0;
> > > >  	}
> > > >
> > > > -	ctucan_read_rx_frame(priv, cf, ffw);
> > > > +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> > > > +	if (priv->timestamp_enabled)
> > > > +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> > >
> > > Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counter()
> > > happen concurrently? AFAICS they are all called from ctucan_rx_poll(),
> > > right?
> >
> > I am not sure about which possible problem do you think.
> > But ctucan_read_timestamp_counter() is fully reentrant
> > and has no side effect on the core. So there is no
> > problem.
>
> ctucan_read_timestamp_counter() is reentrant, but on 32 bit systems the
> update of tc->cycle_last isn't.
>
> [...]

Good catch, so we probably should use atomic there or we need to add
spinlock, but I think that atomic is optimal solution there.

> > > > +
> > > > +	/* Obtain timestamping frequency */
> > > > +	if (pm_enable_call) {
> > > > +		/* Plaftorm device: get tstamp clock from device tree */
> > > > +		priv->timestamp_clk = devm_clk_get(dev, "ts-clk");
> > > > +		if (IS_ERR(priv->timestamp_clk)) {
> > > > +			/* Take the core clock frequency instead */
> > > > +			timestamp_freq = can_clk_rate;
> > > > +		} else {
> > > > +			timestamp_freq = clk_get_rate(priv->timestamp_clk);
> > > > +		}
> > >
> > > Who prepares/enabled the timestamp clock? clk_get_rate() is only valid
> > > if the clock is enabled. I know, we violate this for the CAN clock. :/
> >
> > Yes, I have noticed that we miss clk_prepare_enable() in the
> > ctucan_probe_common() and clk_disable_unprepare() in
> > ctucan_platform_remove().
>
> Oh, I missed the fact that the CAN clock is not enabled at all. That
> should be fixed, too, in a separate patch.
>
> So let's focus on the ts_clk here. On DT systems if there's no ts-clk,
> you can assign the normal clk pointer to the priv->timestamp_clk, too.
> Move the calculation of mult, shift and the delays into
> ctucan_timestamp_init(). If ctucan_timestamp_init is not NULL, add a
> clk_prepare_enable() and clk_get_rate(), otherwise use the can_clk_rate.
> Add the corresponding clk_disable_unprepare() to ctucan_timestamp_stop().

OK

> > The need for clock running should be released in ctucan_suspend()
> > and regained in ctucan_resume(). I see that the most CAN drivers
> > use there clk_disable_unprepare/clk_prepare_enable but I am not
> > sure, if this is right. Ma be plain clk_disable/clk_enable should
> > be used for suspend and resume because as I understand, the clock
> > frequency can be recomputed and reset during clk_prepare which
> > would require to recompute bitrate. Do you have some advice
> > what is a right option there?
>
> For the CAN clock, add a prepare_enable to ndo_open, corresponding
> function to ndo_stop. Or better, add these time runtime_pm.

Hmm, there is problem that we have single clock for whole design,
so if we try to touch AXI/APB slave registers without clock setup
then system blocks. So I think that we need to prepare and enable
clocks in probe to allow registers access later. We need it at least
for core bus endian probe and version validation/quirks. May it be
we can disable clocks and reenable them in open.... But it is
a little risky play and needs to ensure that no other path
in the closed driver can attempt to access registers.

Due to use of AXI bridges and other peripherals in Zynq Programmable
Logic (FPGA) we keep forcibly clock enabled. In the fact, this
should be solved some way on level of APB (now renamed in Zynq DST
to AXI) bus mapping. 

> Has system suspend/resume been tested? I think the IP core might be
> powered off during system suspend, so the driver has to restore the
> state of the chip. The easiest would be to run through
> chip_start()/chip_stop().

Hmm, if we do not reconfigure FPGA then it keeps state and if we
lose configuration then whole cycle with DTS overlay is required.
So basically for runtime power down wee need to unload overlay
which removes driver instances and then reload  overlay and instances
again... If you speak about suspend to disk, then I do not expect
to run this way on any platform bus based system in near future.
With PCIe card on PC it is possible... So it is other area to invest
work in future...

> For the possible change of clock rate between probe and ifup, we should
> add a CAN driver framework wide function to re-calculate the bitrates
> with the current clock rate after the prepare_enable.

ACK

> BTW: In an early version of the stm32mp1 device tree some graphics clock
> and the CAN clock shared the same parent clock. The configuration of the
> display (which happened after the probe of the CAN driver ) caused a
> different rate in the CAN clock, resulting in broken bit timings.

So in the fact each CAN device should listen to the clock rate
change notifier...

> > Actual omission is no problem on our systems, be the clock are used
> > in whole FPGA system with AXI connection and has to running already
> > and we use same for timestamping.
> >
> > I would prefer to allow timestamping patch as it is without clock enable
> > and then correct clock enable, disable by another patch for both ts and
> > core clocks.
>
> NACK - if the time stamping clock is added, please with proper handling.
> The core clock can be fixed in a later patch.

OK, how is it with your timing plans. I have already stated to Matej 
Vasilevski that slip of the patch sending after 5.19 release means
that we would not fit in 5.20 probably. If it is so and you, then I
expect that postpone of discussions, replies and thoughts about our
work after 5.20 preparation calms down is preferred on your side.
We focus on preparation of proper series for early 5.21/6.0 cycle.

Thanks for your time

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


