Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DC65B6D0B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiIMMSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiIMMSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:18:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7EAE0EC;
        Tue, 13 Sep 2022 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663071520; x=1694607520;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RbOTHa0oab0x7q8xNIhJEDOAprgx4UxPU54rnf2GoxU=;
  b=2T1RUyOurtMbbXsCfo4H4JnCizwZSkz9QdbUqL6tg5wogU/RlDVrPlbs
   32+/jE32/aQ6IowRM797m23fqnW60OU3nHnJMk35sbehNn66r3ptC6gMe
   IRBVJep1CjDkzZtB77Uz0MoTkT9BQLCf78Dk4aiFHn8V/gLX1bM51Cuj1
   loQxTIpAhasRm/YZ+pzlkKu36amzVefG5kH3xzY4d9IkAF/s5/BwYDB3k
   N+SF2GXLVVHM2tBrMXMyK+PUbZv86ROpEZeZe73MRuDrHP82jqUm7Nd80
   cKQx6rdA42XF+26VOJprhsqrt7JOm5kQStPTZFi5FzpaA2PASg+2ppd3k
   A==;
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="176905062"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 05:18:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 05:18:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 13 Sep 2022 05:18:39 -0700
Date:   Tue, 13 Sep 2022 14:23:01 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add interrupts support for
 LAN8804 PHY
Message-ID: <20220913122301.362ap6zghpdpluci@soft-dev3-1.localhost>
References: <20220912195650.466518-1-horatiu.vultur@microchip.com>
 <20220913081814.212548-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220913081814.212548-1-michael@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/13/2022 10:18, Michael Walle wrote:
> 
> > Add support for interrupts for LAN8804 PHY.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/phy/micrel.c | 55 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index 7b8c5c8d013e..98e9bc101d96 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -2676,6 +2676,59 @@ static int lan8804_config_init(struct phy_device *phydev)
> >       return 0;
> >  }
> >
> > +static irqreturn_t lan8804_handle_interrupt(struct phy_device *phydev)
> > +{
> > +     int status;
> > +
> > +     status = phy_read(phydev, LAN8814_INTS);
> > +     if (status < 0) {
> > +             phy_error(phydev);
> > +             return IRQ_NONE;
> > +     }
> > +
> > +     if (status > 0)
> > +             phy_trigger_machine(phydev);
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +#define LAN8804_OUTPUT_CONTROL                       25
> > +#define LAN8804_OUTPUT_CONTROL_INTR_BUFFER   BIT(14)
> > +#define LAN8804_CONTROL                              31
> > +#define LAN8804_CONTROL_INTR_POLARITY                BIT(14)
> > +
> > +static int lan8804_config_intr(struct phy_device *phydev)
> > +{
> > +     int err;
> > +
> > +     /* Change interrupt polarity */
> > +     phy_write(phydev, LAN8804_CONTROL, LAN8804_CONTROL_INTR_POLARITY);
> 
> I assume you change the polarity to high active? Could you add a note?
> The LAN966x nor the LAN8804 datasheet describe this bit. You might also add
> a note, that this is an internal PHY and you cannot change the polarity on
> the GIC. Which begs the question, is this really only an internal PHY or
> can you actually buy it as a dedicated one. Then you'd change the polarity
> in a really unusual way.

That is correct, as you described it, I change the polarity to high.
From what I know, you can't buy a dedicated PHY.
I will add these notes in the next version.

> 
> 
> > +
> > +     /* Change interrupt buffer type */
> 
> To what? Push-pull?

Yes, I have changed it to push-pull.
I will add a node in the next version.

> 
> -michael
> 
> > +     phy_write(phydev, LAN8804_OUTPUT_CONTROL,
> > +               LAN8804_OUTPUT_CONTROL_INTR_BUFFER);
> > +

-- 
/Horatiu
