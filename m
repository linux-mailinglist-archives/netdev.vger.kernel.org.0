Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC83D6E9115
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbjDTKyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjDTKxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:53:54 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F279751;
        Thu, 20 Apr 2023 03:51:22 -0700 (PDT)
X-QQ-mid: Yeas43t1681987787t800t23682
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 2097433834087169050
To:     "'Jarkko Nikula'" <jarkko.nikula@linux.intel.com>
Cc:     <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <olteanv@gmail.com>, <mengyuanlou@net-swift.com>,
        <netdev@vger.kernel.org>, <linux@armlinux.org.uk>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-3-jiawenwu@trustnetic.com> <fd5652bd-5b85-0f7d-3690-21eb1a0010b3@linux.intel.com>
In-Reply-To: <fd5652bd-5b85-0f7d-3690-21eb1a0010b3@linux.intel.com>
Subject: RE: [PATCH net-next v3 2/8] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Thu, 20 Apr 2023 18:49:43 +0800
Message-ID: <03f001d97375$d0d1ab70$72750250$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQILBR3gZkFBC9g1wrfKT5ke1rRywwLGjwA7AVhX+x6ur+k8sA==
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

> > --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> 
> > +static void dw_i2c_get_plat_data(struct dw_i2c_dev *dev)
> > +{
> > +	struct platform_device *pdev = to_platform_device(dev->dev);
> > +	struct dw_i2c_platform_data *pdata;
> > +
> > +	pdata = dev_get_platdata(&pdev->dev);
> > +	if (!pdata)
> > +		return;
> > +
> > +	dev->flags |= pdata->flags;
> > +	dev->base = pdata->base;
> > +
> > +	if (pdata->ss_hcnt && pdata->ss_lcnt) {
> > +		dev->ss_hcnt = pdata->ss_hcnt;
> > +		dev->ss_lcnt = pdata->ss_lcnt;
> > +	} else {
> > +		dev->ss_hcnt = 6;
> > +		dev->ss_lcnt = 8;
> > +	}
> > +
> > +	if (pdata->fs_hcnt && pdata->fs_lcnt) {
> > +		dev->fs_hcnt = pdata->fs_hcnt;
> > +		dev->fs_lcnt = pdata->fs_lcnt;
> > +	} else {
> > +		dev->fs_hcnt = 6;
> > +		dev->fs_lcnt = 8;
> > +	}
> > +}
> > +
> >   static const struct dmi_system_id dw_i2c_hwmon_class_dmi[] = {
> >   	{
> >   		.ident = "Qtechnology QT5222",
> > @@ -282,6 +314,8 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
> >   	dev->irq = irq;
> >   	platform_set_drvdata(pdev, dev);
> >
> > +	dw_i2c_get_plat_data(dev);
> > +
> Instead of this added code would it be possible to use generic timing
> parameters which can come either from firmware or code? Those are
> handled already here by the call to i2c_parse_fw_timings().
> 
> Then drivers/i2c/busses/i2c-designware-master.c:
> i2c_dw_set_timings_master() takes care of calculating Designware
> specific hcnt/lcnt timing parameters from those generic values.
> 

I am confused about why fs_hcnt/fs_lcnt must be set when I use the
standard mode?


