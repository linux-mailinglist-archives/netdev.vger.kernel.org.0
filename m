Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978E369C64A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjBTIKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBTIKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:10:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EFC11663;
        Mon, 20 Feb 2023 00:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676880634; x=1708416634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fjLIAnEfOgyxdmIHH26/MTZQPh2JWjPetMED/MguDaw=;
  b=dzPUwV5H/Q6J9wo0XcsnxEmi0G4XlXuiKhxfcG3FsVbbfzxmTFT2dqk1
   4X+miiXQuz38HDSrBIBtUA8kC+DrRJkH4wQUIaInb/a59hyOQdpZpZxlY
   mcJqBC87bED6YPkN5eEbfAWls22m404FGx6USRJMsFzJEuPbb/AH+ftX7
   jInVC/xy/HDcGlJKgfwQvohYOwvCpH5f1lpQuy0AgVOBIg+DesQI1JfAT
   oBJMt48p6R6aWge01Oue4OyD0EJDYq1u4TS0sJYXGnQOR5Wvu5u0SsuRj
   db2sdNuGQ2zFbYgAVZzECs9YBkCkIQqCAORLLQwxK5YTFjY2DFhpDiBUK
   w==;
X-IronPort-AV: E=Sophos;i="5.97,311,1669100400"; 
   d="scan'208";a="201390784"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2023 01:10:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 01:10:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Mon, 20 Feb 2023 01:10:31 -0700
Date:   Mon, 20 Feb 2023 09:10:30 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v2] net: phy: micrel: Add support for
 PTP_PF_PEROUT for lan8841
Message-ID: <20230220081030.5bgi5aj4zmeux5bc@soft-dev3-1>
References: <20230218123038.2761383-1-horatiu.vultur@microchip.com>
 <Y/LE1SzlpKcWHAti@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y/LE1SzlpKcWHAti@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/20/2023 01:54, Andrew Lunn wrote:

Hi Andrew,

> 
> > +static int lan8841_ptp_set_target(struct kszphy_ptp_priv *ptp_priv, u8 event,
> > +                               s64 sec, u32 nsec)
> > +{
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     int ret;
> > +
> > +     ret = phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_SEC_HI(event),
> > +                         upper_16_bits(sec));
> > +     ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_SEC_LO(event),
> > +                          lower_16_bits(sec));
> > +     ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_NS_HI(event) & 0x3fff,
> > +                          upper_16_bits(nsec));
> > +     ret |= phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_TARGET_NS_LO(event),
> > +                          lower_16_bits(nsec));
> 
> ORing together error codes generally does not work. MDIO transactions
> can sometimes give ETIMEDOUT, or EINVAL. Combine those and i think you
> get ENOKEY, which is going to be interesting to track down.

Good observation. You are right, it would be ENOKEY.
I will fix this in the next version. I will submit the new version once
the net-next gets open again.

> 
>     Andrew

-- 
/Horatiu
