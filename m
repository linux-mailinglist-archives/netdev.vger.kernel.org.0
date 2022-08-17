Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A817C597A14
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiHQXPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 19:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiHQXPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 19:15:34 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFB7A7218;
        Wed, 17 Aug 2022 16:15:30 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc23b.ko.seznam.cz (email-smtpc23b.ko.seznam.cz [10.53.18.31])
        id 306424bfd4c8f78131b985d1;
        Thu, 18 Aug 2022 01:14:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1660778078; bh=W4K12dXu6Dj+lHw287pM6t3/vwebMnGfZdWhnEcBocg=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
        b=daTXKi/tiB/8ZwuXLED4H75rgIRoJuMVXaSmYn1r77lbkWDtrXXxS6niKRqtCMBeF
         p9DYqI2Z8Q7GrYOar6H+G72WPISmPb/pTT9aVn0++6/9zV5Fswav+06rynMpmiP6ZI
         KCmSJzVAlcurqw3K3P1Ws50VzflmGFZHpxqDWfXs=
Received: from hopium (2a02:8308:900d:2400:42a0:4fb5:48e:75cc [2a02:8308:900d:2400:42a0:4fb5:48e:75cc])
        by email-relay10.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 18 Aug 2022 01:14:36 +0200 (CEST)  
Date:   Thu, 18 Aug 2022 01:14:34 +0200
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
Message-ID: <20220817231434.GA157998@hopium>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
 <20220803000903.GB4457@hopium>
 <20220803085303.2u4l5l6wmualq33v@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803085303.2u4l5l6wmualq33v@pengutronix.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

I have two questions before I send the next patch version, please
bear with me.

On Wed, Aug 03, 2022 at 10:53:03AM +0200, Marc Kleine-Budde wrote:

[...]

> > > > +	if (priv->timestamp_possible) {
> > > > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq,
> > > > +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > > > +		priv->work_delay_jiffies =
> > > > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> > > > +		if (priv->work_delay_jiffies == 0)
> > > > +			priv->timestamp_possible = false;
> > > 
> > > You'll get a higher precision if you take the mask into account, at
> > > least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
> > > 
> > >         maxsec = min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask / timestamp_freq);
> > > 	
> > >         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq, NSEC_PER_SEC,  maxsec);
> > >         work_delay_in_ns = clocks_calc_max_nsecs(&priv->cc.mult, &priv->cc.shift, 0, &priv->cc.mask, NULL);
> > > 
> > > You can use clocks_calc_max_nsecs() to calculate the work delay.
> > 
> > This is a good point, thanks. I'll incorporate it into the patch.
> 
> And do this calculation after a clk_prepare_enable(), see other mail to
> Pavel
> | https://lore.kernel.org/all/20220803083718.7bh2edmsorwuv4vu@pengutronix.de/


1) I can't use clocks_calc_max_nsecs(), because it isn't exported
symbol (and I get modpost error during linking). Is that simply an
oversight on your end or I'm doing something incorrectly?

I've also listed all the exported symbols from /kernel/time, and nothing
really stood out to me as super useful for this patch. So I would
continue using ctucan_calculate_work_delay().

2) Instead of using clk_prepare_enable() manually in probe, I've added
the prepare_enable and disable_unprepare(ts_clk) calls into pm_runtime
suspend and resume callbacks. And I call clk_get_rate(ts_clk) only after
the pm_runtime_enable() and pm_runtime_get_sync() are called. This
seemed nicer to me, because the core clock prepare/unprepare will go
into the pm_runtime callbacks too.

Is that a correct approach, or should I really use the clk_prepare_enable()
and clk_disable_unprepare() "manually" in ctucan_common_probe()/ctucan_timestamp_stop()?

On my Zynq board I don't see the ctucan_resume() callback executed during probe
(after pm_runtime_enable() and pm_runtime_get_sync() are called in _probe()),
but in theory it seems like the correct approach. Xilinx_can driver does this too.
Other drivers (e.g. flexcan, mpc251xfd, rcar) call clk_get_rate() right after
devm_clk_get() in probe, but maybe the situation there is different, I don't
know too much about clocks and pm_runtime yet.

Thanks and best regards,
Matej
