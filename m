Return-Path: <netdev+bounces-2042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA627000B3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C899281927
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6804E63AD;
	Fri, 12 May 2023 06:40:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1E61119
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:40:18 +0000 (UTC)
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B25CDC6F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:40:07 -0700 (PDT)
X-QQ-mid:Yeas54t1683873496t612t58675
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 15562655820059693255
To: "'Andrew Lunn'" <andrew@lunn.ch>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-7-jiawenwu@trustnetic.com> <ab8852ce-72e8-4d5b-8c88-772a6c9f1485@lunn.ch>
In-Reply-To: <ab8852ce-72e8-4d5b-8c88-772a6c9f1485@lunn.ch>
Subject: RE: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Date: Fri, 12 May 2023 14:38:15 +0800
Message-ID: <019201d9849c$54e88730$feb99590$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQGeWQPmAvTOeO2uKNBTkA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	T_SPF_HELO_TEMPERROR,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thursday, May 11, 2023 8:32 PM, Andrew Lunn wrote:
> > +static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int
> > +offset) {
> > +	struct wx *wx = gpiochip_get_data(chip);
> > +	struct txgbe *txgbe = wx->priv;
> > +	int val;
> > +
> > +	val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
> > +
> > +	txgbe->gpio_orig &= ~BIT(offset);
> > +	txgbe->gpio_orig |= val;
> > +
> > +	return !!(val & BIT(offset));
> > +}
> 
> > +static void txgbe_irq_handler(struct irq_desc *desc) {
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
> > +
> > +	/* workaround for hysteretic gpio interrupts */
> > +	gpio = rd32(wx, WX_GPIO_EXT);
> > +	if (!gpioirq)
> > +		gpioirq = txgbe->gpio_orig ^ gpio;
> 
> Please could you expand on the comment. Are you saying that
> WX_GPIO_INTSTATUS sometimes does not contain the GPIO which caused the
> interrupt? If so, you then compare the last gpio_get with the current value and
> assume that is what caused the interrupt?

Yes. Sometime there is a lag in WX_GPIO_INTSTATUS. When the GPIO interrupt
cause,  the GPIO state has been back to its previous state. So I added this
workaround to save some...but only if there are other interrupts at the same
time, i.e. txgbe_irq_handler() called.

But I will remove it in the next version, because I find a more accurate solution.

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
> Is that a hardware requirement, that interrupts only work when the interface is
> running? Interrupts are not normally conditional like this, at least when the SoC
> provides the GPIO controller.

Should we handle the interrupts when interface is not running?



