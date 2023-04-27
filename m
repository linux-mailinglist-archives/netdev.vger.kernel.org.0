Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328D56EFF4A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbjD0CRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242947AbjD0CQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:16:58 -0400
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE3740F7
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:16:54 -0700 (PDT)
X-QQ-mid: Yeas51t1682561712t600t50125
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 10333517096435060835
To:     <andy.shevchenko@gmail.com>
Cc:     <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
        <andriy.shevchenko@linux.intel.com>,
        <mika.westerberg@linux.intel.com>, <jsd@semihalf.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com> <20230426071434.452717-3-jiawenwu@trustnetic.com> <ZElCHGho-szyySGC@surfacebook>
In-Reply-To: <ZElCHGho-szyySGC@surfacebook>
Subject: RE: [RFC PATCH net-next v5 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Thu, 27 Apr 2023 10:15:10 +0800
Message-ID: <013a01d978ae$182104c0$48630e40$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQImNz20YbZMzc6JsoYnjpKQN5RngQGupjOHAxyjlVSufoxyQA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, April 26, 2023 11:45 PM, andy.shevchenko@gmail.com wrote:
> Wed, Apr 26, 2023 at 03:14:27PM +0800, Jiawen Wu kirjoitti:
> > Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> > with SFP.
> >
> > Introduce the property "i2c-dw-flags" to match device data for software
> > node case. Since IO resource was mapped on the ethernet driver, add a model
> > quirk to get resource from platform info.
> >
> > The exists IP limitations are dealt as workarounds:
> > - IP does not support interrupt mode, it works on polling mode.
> > - Additionally set FIFO depth address the chip issue.
> 
> Thanks for an update, my comments below.
> 
> ...
> 
> >  		goto done_nolock;
> >  	}
> >
> > +	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
> > +		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
> > +		goto done_nolock;
> > +	}
> 
> 	switch (dev->flags & MODEL_MASK) {
> 	case AMD:
> 		...
> 	case WANGXUN:
> 		...
> 	default:
> 		break;
> 	}
> 
> ...
> 
> > +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> > +{
> > +	struct platform_device *pdev = to_platform_device(dev->dev);
> > +	struct resource *r;
> > +
> > +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!r)
> > +		return -ENODEV;
> > +
> > +	dev->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> > +
> > +	return PTR_ERR_OR_ZERO(dev->base);
> > +}
> 
> Redundant. See below.
> 
> ...
> 
> >  	case MODEL_BAIKAL_BT1:
> >  		ret = bt1_i2c_request_regs(dev);
> >  		break;
> > +	case MODEL_WANGXUN_SP:
> > +		ret = txgbe_i2c_request_regs(dev);
> 
> How is it different to...
> 
> > +		break;
> >  	default:
> >  		dev->base = devm_platform_ioremap_resource(pdev, 0);
> 
> ...this one?
> 

devm_platform_ioremap_resource() has one more devm_request_mem_region()
operation than devm_ioremap(). By my test, this memory cannot be re-requested,
only re-mapped.

> ...
> 
> >  	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
> 
> > +	if (!dev->flags)
> 
> No need to check this. Just define priorities (I would go with above to be
> higher priority).
> 
> > +		device_property_read_u32(&pdev->dev, "i2c-dw-flags", &dev->flags);
> 
> Needs to be added to the Device Tree bindings I believe.
> 
> But wait, don't we have other ways to detect your hardware at probe time and
> initialize flags respectively?
> 

I2C is connected to our NIC chip with no PCI ID, so I register a platform device for it.
Please see the 4/9 patch. Software nodes are used to pass the device structure but
no DT and ACPI. I haven't found another way to initialize flags yet, other than the
platform data used in the previous patch (it seems to be an obsolete way).

> --
> With Best Regards,
> Andy Shevchenko
> 
> 
> 

