Return-Path: <netdev+bounces-2125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC097005FD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FEA11C20F57
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B0BBA56;
	Fri, 12 May 2023 10:49:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C304863AF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:49:04 +0000 (UTC)
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B521612EB2
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:48:32 -0700 (PDT)
X-QQ-mid:Yeas52t1683888384t286t23713
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 14702659080937180453
To: "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-7-jiawenwu@trustnetic.com> <ZF4Hri1yzpeq4X3T@shell.armlinux.org.uk>
In-Reply-To: <ZF4Hri1yzpeq4X3T@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Date: Fri, 12 May 2023 18:46:23 +0800
Message-ID: <000201d984be$fe86f390$fb94dab0$@trustnetic.com>
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
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQGeWQPmAvQUsH+uKU/xEA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
> > +{
> > +	struct wx *wx = gpiochip_get_data(chip);
> > +	struct txgbe *txgbe = wx->priv;
> > +	int val;
> > +
> > +	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> > +
> > +	txgbe->gpio_orig &= ~BIT(offset);
> > +	txgbe->gpio_orig |= val;
> 
> You seem to be using this as a way to implement triggering interrupts on
> both levels. Reading the GPIO value using the GPIO functions should not
> change the interrupt state, so this is wrong.

Yes, I just found the correct way to deal with it.

> > +static int txgbe_gpio_direction_out(struct gpio_chip *chip, unsigned int offset,
> > +				    int val)
> > +{
> > +	struct wx *wx = gpiochip_get_data(chip);
> > +	u32 mask;
> > +
> > +	mask = BIT(offset) | BIT(offset - 1);
> > +	if (val)
> > +		wr32m(wx, WX_GPIO_DR, mask, mask);
> > +	else
> > +		wr32m(wx, WX_GPIO_DR, mask, 0);
> 
> Why are you writing two neighbouring bits here? If GPIO 0 is requested
> to change, offset will be zero, and BIT(-1) is probably not what you
> want.
> 
> Moreover, if requesting a change to GPIO 3, BIT(offset - 1) will also
> hit GPIO 2.
> 
> Maybe there's a "* 2" missing here?
> 
> If this code is in fact correct, it needs a comment to explain what's
> going on here.

GPIO lines description:
	/* GPIO 0: tx fault
	 * GPIO 1: tx disable
	 * GPIO 2: sfp module absent
	 * GPIO 3: rx signal lost
	 * GPIO 4: rate select 1, 1G(0) 10G(1)
	 * GPIO 5: rate select 0, 1G(0) 10G(1)
	 */
The previous consideration was processing GPIO 0&1, 4&5. The output
lines are 1/4/5. Under the persistent misconfiguration of flash, GPIO 0 is
treated as the output signal to enable/disable TX laser, together with
GPIO 1. And GPIO 4 seems not be used by SFP driver, to change module
rate, also this driver does not implement rate switching either.

In my understanding, the input GPIO does not call this function, so I put
no  condition there. But in general, with all GPIO being used correctly,
removing these odd codes should work as well. I'll fix it and test it again.

> > +static int txgbe_gpio_set_type(struct irq_data *d, unsigned int type)
> > +{
> > +	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> > +	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> > +	struct wx *wx = gpiochip_get_data(gc);
> > +	u32 level, polarity;
> > +
> > +	level = rd32(wx, WX_GPIO_INTTYPE_LEVEL);
> > +	polarity = rd32(wx, WX_GPIO_POLARITY);
> > +
> > +	switch (type) {
> > +	case IRQ_TYPE_EDGE_BOTH:
> > +		level |= BIT(hwirq);
> > +		break;
> > +	case IRQ_TYPE_EDGE_RISING:
> > +		level |= BIT(hwirq);
> > +		polarity |= BIT(hwirq);
> > +		break;
> > +	case IRQ_TYPE_EDGE_FALLING:
> > +		level |= BIT(hwirq);
> 
> Are you sure you've got this correct. "level" gets set when edge cases
> are requested and cleared when level cases are requested. It seems that
> the register really selects edge-mode if the bit is set? Is it described
> in the documentation as "not level" ?

Yes, the WX_GPIO_INTTYPE_LEVEL register shows that 0 for level-sensitive,
1 for edge-sensitive.

> 
> > +		polarity &= ~BIT(hwirq);
> > +		break;
> > +	case IRQ_TYPE_LEVEL_HIGH:
> > +		level &= ~BIT(hwirq);
> > +		polarity |= BIT(hwirq);
> > +		break;
> > +	case IRQ_TYPE_LEVEL_LOW:
> > +		level &= ~BIT(hwirq);
> > +		polarity &= ~BIT(hwirq);
> > +		break;
> > +	}
> > +
> > +	if (type & IRQ_TYPE_LEVEL_MASK)
> > +		irq_set_handler_locked(d, handle_level_irq);
> > +	else if (type & IRQ_TYPE_EDGE_BOTH)
> > +		irq_set_handler_locked(d, handle_edge_irq);
> 
> So what handler do we end up with if a GPIO is initially requested for
> a level IRQ, released, and then requested for an edge IRQ?

Sorry I don't know much about it, who controls the IRQ type? In fact,
edge IRQ always be requested in my test, and the type is EDGE_BOTH.

> 
> Secondly, a more general comment. You are using the masks here, and we
> can see from the above that there is a pattern to the setting of level
> and polarity. Also, IMHO there's a simpler way to do this:
> 
> 	u32 level, polarity, mask, val;
> 
> 	mask = BIT(hwirq);
> 
> 	if (type & IRQ_TYPE_LEVEL_MASK) {
> 		level = 0;
> 		irq_set_handler_locked(d, handle_level_irq);
> 	} else {
> 		level = mask;
> 		/* fixme: irq_set_handler_locked(handle_edge_irq); ? */
> 	}
> 
> 	if (type == IRQ_TYPE_EDGE_RISING || type == IRQ_TYPE_LEVEL_HIGH)
> 		polarity = mask;
> 	else
> 		polarity = 0;
> 
> 	/* fixme: what does this register do, and why is it configured
> 	 * here?
> 	 */
> 	wr32m(wx, WX_GPIO_INTEN, mask, mask);

It enables corresponding GPIO interrupt.

> 
> 	wr32m(wx, WX_GPIO_INTTYPE_LEVEL, mask, level);
> 	if (type != IRQ_TYPE_EDGE_BOTH)
> 		wr32m(wx, WX_GPIO_POLARITY, mask, polarity);
> 
> Now, as for both-edge interrupts, this needs further thought. As I say
> above, using the _get method to update the internal interrupt state
> won't be reliable.
> 
> If the hardware has no way to trigger on both edges, then it's going to
> take some additional complexity to make this work. Firstly, you need to
> record which interrupts are using both-edges in the driver, so you know
> which need extra work in the interrupt handler.
> 
> Secondly, you still need to configure the polarity as best you can to
> pick up the first change in state here. That means reading the current
> GPIO state, and configuring the GPIO polarity correctly here. It's
> going to be racy with the hardware, so the closer together you can get
> the GPIO state-to-polarity-set the better in terms of the size of the
> race window.

Thanks for the detailed advice. Hardware can trigger the interrupts on both
edges, just set polarity.

> 
> > +static void txgbe_irq_handler(struct irq_desc *desc)
> > +{
> > +	struct irq_chip *chip = irq_desc_get_chip(desc);
> > +	struct wx *wx = irq_desc_get_handler_data(desc);
> > +	struct txgbe *txgbe = wx->priv;
> > +	irq_hw_number_t hwirq;
> > +	unsigned long gpioirq;
> > +	struct gpio_chip *gc;
> > +	u32 gpio;
> > +
> > +	chained_irq_enter(chip, desc);
> > +
> > +	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
> 
> Does reading INTSTATUS clear down any of the pending status bits?

No, it's read only. Interrupt status bits will be cleared in txgbe_gpio_irq_ack().

> 
> > +
> > +	/* workaround for hysteretic gpio interrupts */
> > +	gpio = rd32(wx, WX_GPIO_EXT);
> > +	if (!gpioirq)
> > +		gpioirq = txgbe->gpio_orig ^ gpio;
> 
> This doesn't solve the both-edge case, because this will only get
> evaluated if some other GPIO also happens to raise an interrupt.
> 
> For any GPIOs should have both-edge applied, you need to read the
> current state of the GPIO and program the polarity appropriately,
> then re-read the GPIO to see if it changed state during that race
> and handle that as best that can be.
> 
> The problem is that making both-edge work reliably on hardware that
> doesn't support both-edge will always be rather racy.

Thanks again, I learned a lot.

> 
> > +
> > +	gc = txgbe->gpio;
> > +	for_each_set_bit(hwirq, &gpioirq, gc->ngpio)
> > +		generic_handle_domain_irq(gc->irq.domain, hwirq);
> > +
> > +	chained_irq_exit(chip, desc);
> > +
> > +	/* unmask interrupt */
> > +	if (netif_running(wx->netdev))
> > +		wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
> 
> Why does this depend on whether the network interface is running, and
> why is it done at the end of the interrupt handler? Maybe this needs a
> better comment in the code explaining what it's actually doing?

This register should be written after handling interrupts, otherwise the next
Interrupt may not come, by hardware design. And should we handle the
interrupts when interface is not running? I didn't think it should do, so I made
it conditional.



