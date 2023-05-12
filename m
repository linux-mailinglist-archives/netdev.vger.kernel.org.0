Return-Path: <netdev+bounces-2073-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC5070032A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD94C2818EF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598B5A934;
	Fri, 12 May 2023 08:59:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD902597
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:59:47 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6211FFF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:59:44 -0700 (PDT)
X-QQ-mid:Yeas3t1683881853t174t45976
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 2705097927430388980
To: <andy.shevchenko@gmail.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-7-jiawenwu@trustnetic.com> <ZF1T62BnVFgR33w0@surfacebook>
In-Reply-To: <ZF1T62BnVFgR33w0@surfacebook>
Subject: RE: [PATCH net-next v7 6/9] net: txgbe: Support GPIO to SFP socket
Date: Fri, 12 May 2023 16:57:32 +0800
Message-ID: <000001d984af$c9bc89e0$5d359da0$@trustnetic.com>
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
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQGeWQPmAYIr88uuNK3a0A==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
> > +
> > +	wr32m(wx, WX_GPIO_DDR, BIT(offset), BIT(offset));
> 
> Can you explain, what prevents to have this flow to be interleaved by other API
> calls, like ->direction_in()? Didn't you missed proper locking schema?

It's true, I should add spinlock for writing GPIO registers.

> 
> > +	return 0;
> > +}
> 
> ...
> 
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
> > +		polarity &= ~BIT(hwirq);
> 
> This...
> 
> > +		break;
> > +	case IRQ_TYPE_LEVEL_HIGH:
> > +		level &= ~BIT(hwirq);
> 
> ...and this can be done outside of the switch-case. Then you simply set certain
> bits where it's needed.
> 
> > +		polarity |= BIT(hwirq);
> > +		break;
> > +	case IRQ_TYPE_LEVEL_LOW:
> > +		level &= ~BIT(hwirq);
> > +		polarity &= ~BIT(hwirq);
> > +		break;
> 
> default?

Do you mean that treat IRQ_TYPE_LEVEL_LOW as default case, clear level and
polarity firstly, then set the bits in other needed case? 



