Return-Path: <netdev+bounces-2041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67BEC7000AB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 659771C2112A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1A1A52;
	Fri, 12 May 2023 06:38:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84164A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:38:38 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7E7A25A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:38:23 -0700 (PDT)
X-QQ-mid:Yeas43t1683873339t509t50168
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 2312037741241892163
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
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-7-jiawenwu@trustnetic.com> <f9e0da51-6c55-4768-aa27-437bb7f19888@lunn.ch>
In-Reply-To: <f9e0da51-6c55-4768-aa27-437bb7f19888@lunn.ch>
Subject: RE: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Date: Fri, 12 May 2023 14:35:38 +0800
Message-ID: <019101d9849b$f7354100$e59fc300$@trustnetic.com>
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
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQGeWQPmAmBpj4muLbgJ8A==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thursday, May 11, 2023 8:39 PM, Andrew Lunn wrote:
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
> 
> You have two configuration bits, level and polarity, yet handle 5 different types?
> 
> > +	wr32m(wx, WX_GPIO_INTEN, BIT(hwirq), BIT(hwirq));
> > +	wr32(wx, WX_GPIO_INTTYPE_LEVEL, level);
> > +	if (type != IRQ_TYPE_EDGE_BOTH)
> > +		wr32(wx, WX_GPIO_POLARITY, polarity);
> 
> If we are interested in both edges, then polarity is meaningless. So i can
> understand not writing it. But how does the hardware know polarity should not
> be used?

I will add toggle trigger to set polarity in both edges, to solve the hysteretic
interrupts problem that has been bothering me.



