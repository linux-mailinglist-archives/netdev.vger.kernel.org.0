Return-Path: <netdev+bounces-3258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B7D706416
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1FB31C20E16
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED2011184;
	Wed, 17 May 2023 09:27:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC15249
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:27:18 +0000 (UTC)
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4F510F5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:27:15 -0700 (PDT)
X-QQ-mid:Yeas43t1684315520t373t35437
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [115.200.228.151])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 8844894636701214289
To: "'Jarkko Nikula'" <jarkko.nikula@linux.intel.com>,
	<andy.shevchenko@gmail.com>
Cc: <netdev@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>,
	"'Piotr Raczynski'" <piotr.raczynski@intel.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-3-jiawenwu@trustnetic.com> <ZGH6TmeiR0icT6Tc@surfacebook> <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
In-Reply-To: <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
Subject: RE: [PATCH net-next v8 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date: Wed, 17 May 2023 17:25:19 +0800
Message-ID: <018c01d988a1$7f97fe80$7ec7fb80$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgKu1PaqAbSfKI4Bi4y3m68Cpizw
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wednesday, May 17, 2023 4:49 PM, Jarkko Nikula wrote:
> On 5/15/23 12:24, andy.shevchenko@gmail.com wrote:
> > Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:
> >> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> >> with SFP.
> >>
> >> Introduce the property "snps,i2c-platform" to match device data for Wangxun
> >> in software node case. Since IO resource was mapped on the ethernet driver,
> >> add a model quirk to get regmap from parent device.
> >>
> >> The exists IP limitations are dealt as workarounds:
> >> - IP does not support interrupt mode, it works on polling mode.
> >> - Additionally set FIFO depth address the chip issue.
> >
> > ...
> >
> >>   	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
> >> +	if (device_property_present(&pdev->dev, "snps,i2c-platform"))
> >> +		dev->flags |= MODEL_WANGXUN_SP;
> >
> > What I meant here is to use device_property_present() _iff_ you have decided to
> > go with the _vendor-specific_ property name.
> >
> > Otherwise it should be handled differently, i.e. with reading the actual value
> > of that property. Hence it should correspond the model enum, which you need to
> > declare in the Device Tree bindings before use.
> >
> > So, either
> >
> > 	if (device_property_present(&pdev->dev, "wx,..."))
> > 		dev->flags |= MODEL_WANGXUN_SP;
> >
> > or
> >
> > 	if ((dev->flags & MODEL_MASK) == MODEL_NONE) {
> > 	// you now have to distinguish that there is no model set in driver data
> > 		u32 model;
> >
> > 		ret = device_property_read_u32(dev, "snps,i2c-platform");
> > 		if (ret) {
> > 			...handle error...
> > 		}
> > 		dev->flags |= model
> >
> I'm not a device tree expert but I wonder would it be possible somehow
> combine this and compatible properties in dw_i2c_of_match[]? They set
> model flag for MODEL_MSCC_OCELOT and MODEL_BAIKAL_BT1.

Maybe the table could be changed to match device property, instead of relying
on DT only. Or device_get_match_data() could be also implemented in
software node case?

> 
> Then I'm thinking is "snps,i2c-platform" descriptive enough name for a
> model and does it confuse with "snps,designware-i2c" compatible property?

I'd like to change the name back to "wx,i2c-snps-model" for the specific one.



