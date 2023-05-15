Return-Path: <netdev+bounces-2567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B682702864
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E498A281156
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D86BE61;
	Mon, 15 May 2023 09:25:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2629C8831
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:25:39 +0000 (UTC)
Received: from fgw23-7.mail.saunalahti.fi (fgw23-7.mail.saunalahti.fi [62.142.5.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354152729
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:25:15 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTP
	id 4bbf4fb4-f302-11ed-b972-005056bdfda7;
	Mon, 15 May 2023 12:24:32 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Mon, 15 May 2023 12:24:30 +0300
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v8 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZGH6TmeiR0icT6Tc@surfacebook>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-3-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515063200.301026-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Introduce the property "snps,i2c-platform" to match device data for Wangxun
> in software node case. Since IO resource was mapped on the ethernet driver,
> add a model quirk to get regmap from parent device.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.

...

>  	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
> +	if (device_property_present(&pdev->dev, "snps,i2c-platform"))
> +		dev->flags |= MODEL_WANGXUN_SP;

What I meant here is to use device_property_present() _iff_ you have decided to
go with the _vendor-specific_ property name.

Otherwise it should be handled differently, i.e. with reading the actual value
of that property. Hence it should correspond the model enum, which you need to
declare in the Device Tree bindings before use.

So, either

	if (device_property_present(&pdev->dev, "wx,..."))
		dev->flags |= MODEL_WANGXUN_SP;

or

	if ((dev->flags & MODEL_MASK) == MODEL_NONE) {
	// you now have to distinguish that there is no model set in driver data
		u32 model;

		ret = device_property_read_u32(dev, "snps,i2c-platform");
		if (ret) {
			...handle error...
		}
		dev->flags |= model

-- 
With Best Regards,
Andy Shevchenko



