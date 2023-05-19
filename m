Return-Path: <netdev+bounces-3850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1990270922B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3569281BC2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026205692;
	Fri, 19 May 2023 08:52:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EAA3D388
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:52:13 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A71999
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:51:52 -0700 (PDT)
X-QQ-mid:Yeas44t1684486295t994t19459
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [115.200.228.151])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 15870682443863642730
To: "'Michael Walle'" <michael@walle.cc>
Cc: <netdev@vger.kernel.org>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook> <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com> <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch> <025b01d9897e$d8894660$899bd320$@trustnetic.com> <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch> <02ad01d98a2b$4cd080e0$e67182a0$@trustnetic.com>
In-Reply-To: <02ad01d98a2b$4cd080e0$e67182a0$@trustnetic.com>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Fri, 19 May 2023 16:51:35 +0800
Message-ID: <02b601d98a2f$1dcde8b0$5969ba10$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgMH5FTyAkITzAABJU2Y7wJ7xjhgAYjDQqsBr+FHUgDJ87o1AYTHtNcCNJs0Q66wBPtg
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Forgot to Cc: Michael Walle

On Friday, May 19, 2023 4:24 PM, Jiawen Wu wrote:
> On Thursday, May 18, 2023 8:49 PM, Andrew Lunn wrote:
> > > > I _think_ you are mixing upstream IRQs and downstream IRQs.
> > > >
> > > > Interrupts are arranged in trees. The CPU itself only has one or two
> > > > interrupts. e.g. for ARM you have FIQ and IRQ. When the CPU gets an
> > > > interrupt, you look in the interrupt controller to see what external
> > > > or internal interrupt triggered the CPU interrupt. And that interrupt
> > > > controller might indicate the interrupt came from another interrupt
> > > > controller. Hence the tree structure. And each node in the tree is
> > > > considered an interrupt domain.
> > > >
> > > > A GPIO controller can also be an interrupt controller. It has an
> > > > upstream interrupt, going to the controller above it. And it has
> > > > downstream interrupts, the GPIO lines coming into it which can cause
> > > > an interrupt. And the GPIO interrupt controller is a domain.
> > > >
> > > > So what exactly does gpio_regmap_config.irq_domain mean? Is it the
> > > > domain of the upstream interrupt controller? Is it an empty domain
> > > > structure to be used by the GPIO interrupt controller? It is very
> > > > unlikely to have anything to do with the SFP devices below it.
> > >
> > > Sorry, since I don't know much about interrupt,  it is difficult to understand
> > > regmap-irq in a short time. There are many questions about regmap-irq.
> > >
> > > When I want to add an IRQ chip for regmap, for the further irq_domain,
> > > I need to pass a parameter of IRQ, and this IRQ will be requested with handler:
> > > regmap_irq_thread(). Which IRQ does it mean?
> >
> > That is your upstream IRQ, the interrupt indicating one of your GPIO
> > lines has changed state.
> >
> > > In the previous code of using
> > > devm_gpiochip_add_data(), I set the MSI-X interrupt as gpio-irq's parent, but
> > > it was used to set chained handler only. Should the parent be this IRQ? I found
> > > the error with irq_free_descs and irq_domain_remove when I remove txgbe.ko.
> >
> > Do you have one MSI-X dedicated for GPIOs. Or is it your general MAC
> > interrupt, and you need to read an interrupt controller register to
> > determine it was GPIOs which triggered the interrupt?
> >
> > If you are getting errors when removing the driver it means you are
> > missing some level of undoing what us done in probe. Are you sure
> > regmap_del_irq_chip() is being called on unload?
> >
> > > As you said, the interrupt of each tree node has its domain. Can I understand
> > > that there are two layer in the interrupt tree for MSI-X and GPIOs, and requesting
> > > them separately is not conflicting? Although I thought so, but after I implement
> > > gpio-regmap, SFP driver even could not find gpio_desc. Maybe I missed something
> > > on registering gpio-regmap...
> >
> > That is probably some sort of naming issue. You might want to add some
> > prints in swnode_find_gpio() and gpiochip_find() to see what it is
> > looking for vs what the name actually is.
> 
> It's true for the problem of name, but there is another problem. SFP driver has
> successfully got gpio_desc, then it failed to get gpio_irq from gpio_desc (with error
> return -517). I traced the function gpiod_to_irq():
> 
> 	gc = desc->gdev->chip;
> 	offset = gpio_chip_hwgpio(desc);
> 	if (gc->to_irq) {
> 		int retirq = gc->to_irq(gc, offset);
> 
> 		/* Zero means NO_IRQ */
> 		if (!retirq)
> 			return -ENXIO;
> 
> 		return retirq;
> 	}
> 
> 'gc->to_irq = gpiochip_to_irq' was set in [4]gpiochip_irqchip_add_domain().
> So:
> 
> 	static int gpiochip_to_irq(struct gpio_chip *gc, unsigned int offset)
> 	{
> 		struct irq_domain *domain = gc->irq.domain;
> 
> 	#ifdef CONFIG_GPIOLIB_IRQCHIP
> 		/*
> 		 * Avoid race condition with other code, which tries to lookup
> 		 * an IRQ before the irqchip has been properly registered,
> 		 * i.e. while gpiochip is still being brought up.
> 		 */
> 		if (!gc->irq.initialized)
> 			return -EPROBE_DEFER;
> 	#endif
> 
> gc->irq.initialized is set to true at the end of [3]gpiochip_add_irqchip() only.
> Firstly, it checks if irqchip is NULL:
> 
> 	static int gpiochip_add_irqchip(struct gpio_chip *gc,
> 					struct lock_class_key *lock_key,
> 					struct lock_class_key *request_key)
> 	{
> 		struct fwnode_handle *fwnode = dev_fwnode(&gc->gpiodev->dev);
> 		struct irq_chip *irqchip = gc->irq.chip;
> 		unsigned int type;
> 		unsigned int i;
> 
> 		if (!irqchip)
> 			return 0;
> 
> The result shows that it was NULL, so gc->irq.initialized = false.
> Above all, return irq = -EPROBE_DEFER.
> 
> So let's sort the function calls. In chronological order, [1] calls [2], [2] calls
> [3], then [1] calls [4]. The irq_chip was added to irq_domain->host_data->irq_chip
> before [1]. But I don't find where to convert gpio_chip->irq.domain->host_data->irq_chip
> to gpio_chip->irq.chip, it seems like it should happen after [4] ? But if it wants to use
> 'gc->to_irq' successfully, it should happen before [3]?
> 
> [1] gpio_regmap_register()
> [2] gpiochip_add_data()
> [3] gpiochip_add_irqchip()
> [4] gpiochip_irqchip_add_domain()
> 
> I'm sorry that I described the problem in a confusing way, apologize if I missed
> some code that caused this confusion.
 


