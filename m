Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34335A0923
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiHYGuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiHYGt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:49:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB98BC8E;
        Wed, 24 Aug 2022 23:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661410197; x=1692946197;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xLuE/B27u6eRSGn7Ft71FXRlPAdU68aHCYLKp0Orpvc=;
  b=Xp1eGcmFxAWM24LwlkVsjrXmflpDxDfHInZr1BmtscIV93uL14B/nUHc
   WBpQ71b18tqWiTHSGteEdvo43LBeFomdIpKdPUmW/MYUCCkuGfzIo/U6j
   9YxXqnbs0J1LoiM+YYG+T3HRCDNQxXHy/d8jd0ffbsQw2EDiyCiiWROKP
   XxEBW2jz2mQXbu2P1IaOcm0WxxuhLqRNNCEKvAbIoFHgB6SpUKrM3VjJr
   DQxE1lJ4sWCIYyaYgn/xxsEdj4UFUuji1dSH+rOTNAP/lvTBGNrwhqWZf
   +Q7rxhF9UQDpjdZyhdHJSgxSvCdUrPclU6/O4aQ1f2Bbk99graiH24w3F
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="187978584"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2022 23:49:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 24 Aug 2022 23:49:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 24 Aug 2022 23:49:56 -0700
Date:   Thu, 25 Aug 2022 08:54:11 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net] net: phy: micrel: Make the GPIO to be non-exclusive
Message-ID: <20220825065411.wjmuh2xyfh4xuk6b@soft-dev3-1.localhost>
References: <20220824192827.437095-1-horatiu.vultur@microchip.com>
 <YwaAZAXcXhGmu7r9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YwaAZAXcXhGmu7r9@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/24/2022 21:47, Andrew Lunn wrote:

Hi Andrew,

> 
> On Wed, Aug 24, 2022 at 09:28:27PM +0200, Horatiu Vultur wrote:
> > The same GPIO line can be shared by multiple phys for the coma mode pin.
> > If that is the case then, all the other phys that share the same line
> > will failed to be probed because the access to the gpio line is not
> > non-exclusive.
> > Fix this by making access to the gpio line to be nonexclusive using flag
> > GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> > probed.
> >
> > Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/phy/micrel.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index e78d0bf69bc3..ea72ff64ad33 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -2878,7 +2878,8 @@ static int lan8814_release_coma_mode(struct phy_device *phydev)
> >       struct gpio_desc *gpiod;
> >
> >       gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
> > -                                     GPIOD_OUT_HIGH_OPEN_DRAIN);
> > +                                     GPIOD_OUT_HIGH_OPEN_DRAIN |
> > +                                     GPIOD_FLAGS_BIT_NONEXCLUSIVE);
> 
> I would suggest putting a comment here. You are assuming the driver
> never gains a lan8814_take_coma_mode() when the PHY is put into
> suspend, since it sounds like that will put all PHYs on the shared
> GPIO into coma mode.

That is correct.
I will add a comment in the next version.

> 
>      Andrew

-- 
/Horatiu
