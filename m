Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A944059884D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344031AbiHRQEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245462AbiHRQEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:04:48 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F157D43321;
        Thu, 18 Aug 2022 09:04:44 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc17b.ko.seznam.cz (email-smtpc17b.ko.seznam.cz [10.53.18.19])
        id 081a9684ecb645ba09c737ea;
        Thu, 18 Aug 2022 18:03:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1660838628; bh=l4izIYveon3swGZsVW6a4txzcsFgvxecVRqPxonk/8s=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
        b=Ndx+GZef0W0zshtUnW4vZm4O/eVsLFCwKDtWYr7v/MQHB3fpHZTIvKQXE4Ecu5rzl
         ByxCYHHL25lDMKfwhR4ggPA9zjNWGGXMXoXuFsDB/hTc63sQfL6j+L+Wol/nCYwdel
         GAlj9Hmvm1AjU5IL2DGP9QyZoUJnd8OupR0asoMA=
Received: from hopium (2a02:8308:900d:2400:42a0:4fb5:48e:75cc [2a02:8308:900d:2400:42a0:4fb5:48e:75cc])
        by email-relay22.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 18 Aug 2022 18:03:46 +0200 (CEST)  
Date:   Thu, 18 Aug 2022 18:03:44 +0200
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
Message-ID: <20220818160344.GA297252@hopium>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
 <20220803000903.GB4457@hopium>
 <20220803085303.2u4l5l6wmualq33v@pengutronix.de>
 <20220817231434.GA157998@hopium>
 <20220818092435.hchmowfaolxe2tlq@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818092435.hchmowfaolxe2tlq@pengutronix.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:24:35AM +0200, Marc Kleine-Budde wrote:
> On 18.08.2022 01:14:34, Matej Vasilevski wrote:
> > Hello Marc,
> > 
> > I have two questions before I send the next patch version, please
> > bear with me.
> > 
> > On Wed, Aug 03, 2022 at 10:53:03AM +0200, Marc Kleine-Budde wrote:
> > 
> > [...]
> > 
> > > > > > +	if (priv->timestamp_possible) {
> > > > > > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq,
> > > > > > +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > > > > > +		priv->work_delay_jiffies =
> > > > > > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> > > > > > +		if (priv->work_delay_jiffies == 0)
> > > > > > +			priv->timestamp_possible = false;
> > > > > 
> > > > > You'll get a higher precision if you take the mask into account, at
> > > > > least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
> > > > > 
> > > > >         maxsec = min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask / timestamp_freq);
> > > > > 	
> > > > >         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq, NSEC_PER_SEC,  maxsec);
> > > > >         work_delay_in_ns = clocks_calc_max_nsecs(&priv->cc.mult, &priv->cc.shift, 0, &priv->cc.mask, NULL);
> > > > > 
> > > > > You can use clocks_calc_max_nsecs() to calculate the work delay.
> > > > 
> > > > This is a good point, thanks. I'll incorporate it into the patch.
> > > 
> > > And do this calculation after a clk_prepare_enable(), see other mail to
> > > Pavel
> > > | https://lore.kernel.org/all/20220803083718.7bh2edmsorwuv4vu@pengutronix.de/
> > 
> > 
> > 1) I can't use clocks_calc_max_nsecs(), because it isn't exported
> > symbol (and I get modpost error during linking). Is that simply an
> > oversight on your end or I'm doing something incorrectly?
> 
> Oh, I haven't checked if clocks_calc_max_nsecs() is exported. You can
> either create a patch to export it, or "open code" its functionality. I
> think this should be more or less equivalent:
> 
> | work_delay_in_ns = clocksource_cyc2ns(mask, mult, shift) >> 1;

I'm afraid creating a patch for the export would open another can of worms. I'll
take a barebones version of the function: only the _cyc2ns(), and the max_cycles
computation to avoid overflows for 64-bit mask. It should fit in 3 rows of code.

> > I've also listed all the exported symbols from /kernel/time, and nothing
> > really stood out to me as super useful for this patch. So I would
> > continue using ctucan_calculate_work_delay().
> > 
> > 2) Instead of using clk_prepare_enable() manually in probe, I've added
> > the prepare_enable and disable_unprepare(ts_clk) calls into pm_runtime
> > suspend and resume callbacks. And I call clk_get_rate(ts_clk) only after
> > the pm_runtime_enable() and pm_runtime_get_sync() are called.
> 
> Use pm_runtime_resume_and_get(), see:
> 
> | https://elixir.bootlin.com/linux/v5.19/source/include/linux/pm_runtime.h#L419
> 
> > This
> > seemed nicer to me, because the core clock prepare/unprepare will go
> > into the pm_runtime callbacks too.
> 
> Sound good. If you rely on the runtime PM, please add a "depends on PM"
> to the Kconfig. If you want/need to support configurations without
> runtime PM, you have to do some extra work:

Yes, I'll have to add PM to Kconfig. Currently the driver defines suspend
and resume sleep callbacks, but PM isn't in KConfig.

I would support only runtime PM, but Pavel Pisa knows more and might disagree.
In such case this write up will be very helpful, thank you.

> | https://elixir.bootlin.com/linux/v5.19/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c#L1860
> 
> In the mcp251xfd driver without runtime PM I enable the clocks and VDD
> during probe() and keep them running until remove(). The idea is:
> 
> 1) call clock_prepare_enable() manually
> 2) call pm_runtime_get_noresume(), which equal to
>    pm_runtime_resume_and_get() but doesn't call the resume function
> 3) pm_runtime_enable()
> 4) pm_runtime_put()
>    will call suspend with runtime PM enabled,
>    will do nothing otherwise
> 
> Then use pm_runtime_resume_and_get() during open() and pm_runtime_put()
> during stop(). Use both between accessing regs in do_get_berr_counter().
> 
> During remove it's a bit simpler:
> 
> | https://elixir.bootlin.com/linux/v5.19/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c#L1932
> 
> > Is that a correct approach, or should I really use the clk_prepare_enable()
> > and clk_disable_unprepare() "manually" in ctucan_common_probe()/ctucan_timestamp_stop()?
> > 
> > On my Zynq board I don't see the ctucan_resume() callback executed during probe
> > (after pm_runtime_enable() and pm_runtime_get_sync() are called in _probe()),
> 
> Is this a kernel without CONFIG_PM?

Fortunately the kernel was configured with CONFIG_PM. But I didn't have
runtime_suspend and runtime_resume callbacks defined, only the "system
sleep" suspend and resume (I wasn't aware of the difference).
After I defined some runtime suspend/resume callbacks, they were executed
as expected. 

> 
> > but in theory it seems like the correct approach. Xilinx_can driver does this too.
> > Other drivers (e.g. flexcan, mpc251xfd, rcar) call clk_get_rate() right after
> > devm_clk_get() in probe, but maybe the situation there is different, I don't
> > know too much about clocks and pm_runtime yet.
> 
> The API says the clock must be enabled during clk_get_rate() (but that's
> not enforced). And another problem is that the clock rate might change,
> but let's ignore the clock rate change problem for now.
> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

Thanks, regards
Matej
