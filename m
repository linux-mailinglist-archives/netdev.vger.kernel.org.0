Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65D06F0121
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbjD0G7E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Apr 2023 02:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0G7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:59:03 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FBB30EE
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:59:00 -0700 (PDT)
X-QQ-mid: Yeas3t1682578581t014t60229
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 9163638353225091263
To:     "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc:     <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
        <andriy.shevchenko@linux.intel.com>,
        <mika.westerberg@linux.intel.com>, <jsd@semihalf.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com> <20230426071434.452717-3-jiawenwu@trustnetic.com> <ZElCHGho-szyySGC@surfacebook> <013a01d978ae$182104c0$48630e40$@trustnetic.com> <CAHp75Vdnm1bykoX5Dh9nen7jB5bGfLELw0PvXBcqs1PXTf31rA@mail.gmail.com>
In-Reply-To: <CAHp75Vdnm1bykoX5Dh9nen7jB5bGfLELw0PvXBcqs1PXTf31rA@mail.gmail.com>
Subject: RE: [RFC PATCH net-next v5 2/9] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Thu, 27 Apr 2023 14:56:19 +0800
Message-ID: <015301d978d5$5e74f270$1b5ed750$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQImNz20YbZMzc6JsoYnjpKQN5RngQGupjOHAxyjlVQB6RzklAJXgiIQrlzYyRA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, April 27, 2023 1:57 PM, Andy Shevchenko wrote:
> On Thu, Apr 27, 2023 at 5:15 AM Jiawen Wu <jiawenwu@trustnetic.com> wrote:
> > On Wednesday, April 26, 2023 11:45 PM, andy.shevchenko@gmail.com wrote:
> > > Wed, Apr 26, 2023 at 03:14:27PM +0800, Jiawen Wu kirjoitti:
> 
> ...
> 
> > > > +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> > > > +{
> > > > +   struct platform_device *pdev = to_platform_device(dev->dev);
> > > > +   struct resource *r;
> > > > +
> > > > +   r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +   if (!r)
> > > > +           return -ENODEV;
> > > > +
> > > > +   dev->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> > > > +
> > > > +   return PTR_ERR_OR_ZERO(dev->base);
> > > > +}
> > >
> > > Redundant. See below.
> 
> ...
> 
> > > >     case MODEL_BAIKAL_BT1:
> > > >             ret = bt1_i2c_request_regs(dev);
> > > >             break;
> > > > +   case MODEL_WANGXUN_SP:
> > > > +           ret = txgbe_i2c_request_regs(dev);
> > >
> > > How is it different to...
> > >
> > > > +           break;
> > > >     default:
> > > >             dev->base = devm_platform_ioremap_resource(pdev, 0);
> > >
> > > ...this one?
> >
> > devm_platform_ioremap_resource() has one more devm_request_mem_region()
> > operation than devm_ioremap(). By my test, this memory cannot be re-requested,
> > only re-mapped.
> 
> Yeah, which makes a point that the mother driver requests a region
> that doesn't belong to it. You need to split that properly in the
> mother driver and avoid requesting it there. Is it feasible? If not,
> why?

The I2C region belongs to the middle part of the total region. It was not considered to
split because the mother driver implement I2C bus master driver itself in the previous
patch. But is it suitable for splitting? After splitting, I get two virtual address, and each
time I read/write to a register, I have to determine which region it belongs to...Right?

> 
> ...
> 
> > > >     dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
> > >
> > > > +   if (!dev->flags)
> > >
> > > No need to check this. Just define priorities (I would go with above to be
> > > higher priority).
> > >
> > > > +           device_property_read_u32(&pdev->dev, "i2c-dw-flags", &dev->flags);
> > >
> > > Needs to be added to the Device Tree bindings I believe.
> > >
> > > But wait, don't we have other ways to detect your hardware at probe time and
> > > initialize flags respectively?
> >
> > I2C is connected to our NIC chip with no PCI ID, so I register a platform device for it.
> > Please see the 4/9 patch. Software nodes are used to pass the device structure but
> > no DT and ACPI. I haven't found another way to initialize flags yet, other than the
> > platform data used in the previous patch (it seems to be an obsolete way).
> 
> You can share a common data structure between the mother driver and
> her children. In that case you may access it via
> `dev_get_drvdata(pdev.dev->parent)` call.
> 

I'd like to try it.

> OTOH, the property, if only Linux (kernel) specific for internal
> usage, should be named accordingly, or be prepared to have one in
> Device Tree / ACPI / etc. Examples: USB dwc3 driver (see "linux,"
> ones), or intel-lpss-pci.c/intel-lpss-acpi.c (see the SPI type).
> 
> --
> With Best Regards,
> Andy Shevchenko
> 

