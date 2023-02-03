Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C6689DE3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbjBCPRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbjBCPQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:16:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBDD46168;
        Fri,  3 Feb 2023 07:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675437278; x=1706973278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b4vBTbmzxUT19QoY3y9Ftpa1SC5B9to40xdYtchCZas=;
  b=a6o8T7VqHCoL8mO2I9RkgLwPOuKpvmEh56ujGHc5XXRDR+0FyN5QtDhf
   dkqBPehU6Y4GlOxl7YwqtFwshtKZ3uLQz+D8lyemycPuIkH0Hpa48cFoq
   s5nmdGJKuoBioR8VfrD9zJsIXW6KCkZB5QYLdVisrqCuckeTuRcvw9gMl
   G0uBWMeaLp2IOzJubKguTxq9pxpURCE9wmPflyacpv0+F1ysWQfNq+jed
   gWtAV6y3aRw5N3ADPKJZ8EmZWsrSJyFRqWtV8ayfZTbHch3CrdbVkIano
   PY0feX6KOzaP1jIZKGdC8SlXzro5PpEn5hHapimEGz+Bck58eSSqs8aYJ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="199233833"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 08:11:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 08:11:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 3 Feb 2023 08:10:59 -0700
Date:   Fri, 3 Feb 2023 16:10:59 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michael@walle.cc>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <20230203151059.k5aa6zihibgsedcw@soft-dev3-1>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <0f81d14d-50cb-b807-b103-8fa066d0769c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <0f81d14d-50cb-b807-b103-8fa066d0769c@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/03/2023 14:55, Heiner Kallweit wrote:

Hi Heiner,

> 
> On 03.02.2023 13:25, Horatiu Vultur wrote:

...

> > +
> > +#define LAN8841_OUTPUT_CTRL                  25
> > +#define LAN8841_OUTPUT_CTRL_INT_BUFFER               BIT(14)
> > +#define LAN8841_CTRL                         31
> > +#define LAN8841_CTRL_INTR_POLARITY           BIT(14)
> > +static int lan8841_config_intr(struct phy_device *phydev)
> > +{
> > +     struct irq_data *irq_data;
> > +     int temp = 0;
> > +
> > +     irq_data = irq_get_irq_data(phydev->irq);
> > +     if (!irq_data)
> > +             return 0;
> > +
> > +     if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> > +             /* Change polarity of the interrupt */
> 
> Why this a little bit esoteric logic? Can't you set the interrupt
> to level-low in the chip (like most other ones), and then define
> the polarity the usual way e.g. in DT?

To set the interrupt to level-low it needs to be set to open-drain and
in that case I can't use the polarity register, because doesn't have any
effect on the interrupt. So I can't set the interrupt to level low and
then use the polarity to select if it is high or low.
That is the reason why I have these checks.

> 
> > +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER);
> > +             phy_modify(phydev, LAN8841_CTRL,
> > +                        LAN8841_CTRL_INTR_POLARITY,
> > +                        LAN8841_CTRL_INTR_POLARITY);
> > +     } else {
> > +             /* It is enough to set INT buffer to open-drain because then
> > +              * the interrupt will be active low.
> > +              */
> > +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> > +                        LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> > +     }
> > +
> > +     /* enable / disable interrupts */
> > +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> > +             temp = LAN8814_INT_LINK;
> > +
> > +     return phy_write(phydev, LAN8814_INTC, temp);
> > +}
> > +
> > +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> > +{
> > +     int irq_status;
> > +
> > +     irq_status = phy_read(phydev, LAN8814_INTS);
> > +     if (irq_status < 0) {
> > +             phy_error(phydev);
> > +             return IRQ_NONE;
> > +     }
> > +
> > +     if (irq_status & LAN8814_INT_LINK) {
> > +             phy_trigger_machine(phydev);
> > +             return IRQ_HANDLED;
> > +     }
> > +
> > +     return IRQ_NONE;
> > +}
> > +

-- 
/Horatiu
