Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE06C6EC3BA
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 04:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjDXCj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 22:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDXCjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 22:39:54 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E22C2126;
        Sun, 23 Apr 2023 19:39:47 -0700 (PDT)
X-QQ-mid: Yeas48t1682303951t332t51241
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 9289920782831295537
To:     "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        <jarkko.nikula@linux.intel.com>
Cc:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <olteanv@gmail.com>,
        <hkallweit1@gmail.com>, <linux-i2c@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com> <20230422045621.360918-3-jiawenwu@trustnetic.com> <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
In-Reply-To: <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
Subject: RE: [PATCH net-next v4 2/8] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Mon, 24 Apr 2023 10:39:10 +0800
Message-ID: <003801d97655$f2dc4580$d894d080$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLYcl6q9PfLE2IPpEOvRSb72esQRAIu4J5yAbvC5R+tHG5FAA==
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

> > +++ b/include/linux/platform_data/i2c-dw.h
> 
> No way we need this in a new code.
> 
> > +struct dw_i2c_platform_data {
> > +	void __iomem *base;
> 
> You should use regmap.
> 
> > +	unsigned int flags;
> > +	unsigned int ss_hcnt;
> > +	unsigned int ss_lcnt;
> > +	unsigned int fs_hcnt;
> > +	unsigned int fs_lcnt;
> 
> No, use device properties.
> 
> > +};
> 
> --
> With Best Regards,
> Andy Shevchenko
> 

Is it acceptable to add such a function into dw_i2c_plat_probe()?
Otherwise I really can't find a way to get these parameters without DT and ACPI.

+static void i2c_dw_parse_property(struct dw_i2c_dev *dev)
+{
+       if (!is_software_node(dev_fwnode(dev->dev)))
+               return;
+
+       if (!dev->flags)
+               device_property_read_u32(dev->dev, "dw-i2c-flags", &dev->flags);
+
+       device_property_read_u16(dev->dev, "i2c-ss-scl-hcnt", &dev->ss_hcnt);
+       device_property_read_u16(dev->dev, "i2c-ss-scl-lcnt", &dev->ss_lcnt);
+       device_property_read_u16(dev->dev, "i2c-fs-scl-hcnt", &dev->fs_hcnt);
+       device_property_read_u16(dev->dev, "i2c-fs-scl-lcnt", &dev->fs_lcnt);
+
+       if (!dev->ss_hcnt || !dev->ss_lcnt) {
+               dev->ss_hcnt = 6;
+               dev->ss_lcnt = 8;
+       }
+       if (!dev->fs_hcnt || !dev->fs_lcnt) {
+               dev->fs_hcnt = 6;
+               dev->fs_lcnt = 8;
+       }
+}



