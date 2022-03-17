Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E6C4DC44B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiCQKxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiCQKxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:53:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781CE1DF879
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647514344; x=1679050344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uLVjnkQpMYMH5sVtLIWii4Wk+04FMMXXNwLR+WOEX/w=;
  b=yD2jSxAOU+G78Y91LprYqKV/moCzSgemYJIX1Kae1LIDE8muwhuj23U8
   z/DKcTOuPQCnmeegxcSkiPp02rA1BXh2iFqKfbYM+nXD0voF0Wntq0TlM
   +aejlWuda415DMOy75KgilTU9LklgAgJC4bvn4c+P7y+nmEb4Tm20JLqw
   jK/jnPk8w9sMt+KIQkg2Y4m2UVmiqoq+EnY+qIpYNcupwxnoCT8Ls9iOH
   gmBawLlFw4+7XtdHbCl61o/gKPH9W2XFwCJi3++70libVJFIwnNRAxmyp
   ZFMBp+1lmdsGIWJ6oXeNwamBHew6J+do8odYz3Ys1ck2gRWUJRbJLPw47
   A==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="152327691"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:52:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:52:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 03:52:23 -0700
Date:   Thu, 17 Mar 2022 16:22:17 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 3/5] net: lan743x: Add support for OTP
Message-ID: <20220317105217.bkrv3j5er7fbtfec@microsemi.com>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-4-Raju.Lakkaraju@microchip.com>
 <YjD6oGrwjgCdmUDj@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YjD6oGrwjgCdmUDj@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

The 03/15/2022 21:44, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +static int lan743x_hs_otp_cmd_cmplt_chk(struct lan743x_adapter *adapter)
> > +{
> > +     unsigned long start_time = jiffies;
> > +     u32 val;
> > +
> > +     do {
> > +             val = lan743x_csr_read(adapter, HS_OTP_STATUS);
> > +             if (!(val & OTP_STATUS_BUSY_))
> > +                     break;
> > +
> > +             usleep_range(80, 100);
> > +     } while (!time_after(jiffies, start_time + HZ));
> > +
> > +     if (val & OTP_STATUS_BUSY_) {
> > +             netif_warn(adapter, drv, adapter->netdev,
> > +                        "Timeout on HS_OTP_STATUS completion\n");
> > +             return -ETIMEDOUT;
> > +     }
> 
> iopoll.h
> 

Accepted. Fix in V1 patches

> > +static int lan743x_hs_otp_read(struct lan743x_adapter *adapter, u32 offset,
> > +                            u32 length, u8 *data)
> > +{
> > +     int ret;
> > +     int i;
> > +
> > +     if (offset + length > MAX_OTP_SIZE)
> > +             return -EINVAL;
> 
> The core does this.
> 

Accepted. Fix in V1 patches

> > +static int lan743x_hs_otp_write(struct lan743x_adapter *adapter, u32 offset,
> > +                             u32 length, u8 *data)
> > +{
> > +     int ret;
> > +     int i;
> > +
> > +     if (offset + length > MAX_OTP_SIZE)
> > +             return -EINVAL;
> 
> The core does this.
> 

Accepted. Fix in V1 patches

>     Andrew

-- 

Thanks,
Raju

