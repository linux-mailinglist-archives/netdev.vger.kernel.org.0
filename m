Return-Path: <netdev+bounces-3624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E68A7081BC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 676AB1C2104F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178BA23C73;
	Thu, 18 May 2023 12:49:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC5B23C67
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:48:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531EAC9;
	Thu, 18 May 2023 05:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=cySFAh0aYuQ0BuYGb6opRZ3asbMe8+yAKXpa7mS2iS0=; b=uyDXyyAi/lUd8mr98dvyu53n40
	7HCejGP7ecw5aLyPIZ0rfauT0zJj1EdnhMrUSmPVBKOhufklwe7H8J2HCkM8a486Jl7biijALZ8Pw
	ub+nL4sXGiSUpP+kRnvG+yPNhLzdGLL3isGsdiGJOO03jYvPw2H0dkAiOmxXI27zMoXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzd3b-00DEBk-1q; Thu, 18 May 2023 14:48:35 +0200
Date: Thu, 18 May 2023 14:48:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andy Shevchenko' <andy.shevchenko@gmail.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
 <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
 <025b01d9897e$d8894660$899bd320$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025b01d9897e$d8894660$899bd320$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > I _think_ you are mixing upstream IRQs and downstream IRQs.
> > 
> > Interrupts are arranged in trees. The CPU itself only has one or two
> > interrupts. e.g. for ARM you have FIQ and IRQ. When the CPU gets an
> > interrupt, you look in the interrupt controller to see what external
> > or internal interrupt triggered the CPU interrupt. And that interrupt
> > controller might indicate the interrupt came from another interrupt
> > controller. Hence the tree structure. And each node in the tree is
> > considered an interrupt domain.
> > 
> > A GPIO controller can also be an interrupt controller. It has an
> > upstream interrupt, going to the controller above it. And it has
> > downstream interrupts, the GPIO lines coming into it which can cause
> > an interrupt. And the GPIO interrupt controller is a domain.
> > 
> > So what exactly does gpio_regmap_config.irq_domain mean? Is it the
> > domain of the upstream interrupt controller? Is it an empty domain
> > structure to be used by the GPIO interrupt controller? It is very
> > unlikely to have anything to do with the SFP devices below it.
> 
> Sorry, since I don't know much about interrupt,  it is difficult to understand
> regmap-irq in a short time. There are many questions about regmap-irq.
> 
> When I want to add an IRQ chip for regmap, for the further irq_domain,
> I need to pass a parameter of IRQ, and this IRQ will be requested with handler:
> regmap_irq_thread(). Which IRQ does it mean?

That is your upstream IRQ, the interrupt indicating one of your GPIO
lines has changed state.

> In the previous code of using
> devm_gpiochip_add_data(), I set the MSI-X interrupt as gpio-irq's parent, but
> it was used to set chained handler only. Should the parent be this IRQ? I found
> the error with irq_free_descs and irq_domain_remove when I remove txgbe.ko.

Do you have one MSI-X dedicated for GPIOs. Or is it your general MAC
interrupt, and you need to read an interrupt controller register to
determine it was GPIOs which triggered the interrupt?

If you are getting errors when removing the driver it means you are
missing some level of undoing what us done in probe. Are you sure
regmap_del_irq_chip() is being called on unload?

> As you said, the interrupt of each tree node has its domain. Can I understand
> that there are two layer in the interrupt tree for MSI-X and GPIOs, and requesting
> them separately is not conflicting? Although I thought so, but after I implement
> gpio-regmap, SFP driver even could not find gpio_desc. Maybe I missed something
> on registering gpio-regmap...

That is probably some sort of naming issue. You might want to add some
prints in swnode_find_gpio() and gpiochip_find() to see what it is
looking for vs what the name actually is.

	Andrew

