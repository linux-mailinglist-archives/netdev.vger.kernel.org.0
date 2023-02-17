Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F336C69AEEC
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjBQPEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjBQPEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:04:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275E37290F;
        Fri, 17 Feb 2023 07:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676646210; x=1708182210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wtxl7CPmXcYLAphYYqsDsm/MtnhSA723kVbm6Vj5udE=;
  b=UQ58f6U5fLWSfnsdbHXUVz8Z7FAy+zGLQVGz+xYKqG4pTQTsHYQ7DpJx
   H2asM2GY8lVu89nSY0BKpIbBopW7N2IDh2lpMDhCPCBzvNY+G/p6zMlNZ
   Py5FQQ2uON4WI7C+iTu9qvOC04qlKYz4tnK+BK51YOU4BDGZ4Mk25Wmu/
   0eiBAlciT8U/osMK0nfPGNisszqS4VF0ZvLS731tEIEpRbJSj6xLRfCMk
   iBbSzHs6fIhd+2GNcYnEVnY8gj5VHXFoPzDNzz9lMDTaaHOJyeiHJkbQl
   5AZ/r79uXZ1Bnowc23s3b5tYJbqhEjqIgrhfkpV9YVU7OtJAfhw5xYiD+
   A==;
X-IronPort-AV: E=Sophos;i="5.97,306,1669100400"; 
   d="scan'208";a="212525979"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 08:02:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 08:02:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 17 Feb 2023 08:02:08 -0700
Date:   Fri, 17 Feb 2023 16:02:07 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
Message-ID: <20230217150207.6eb7fabg3t2dgh4j@soft-dev3-1>
References: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
 <Y++BXkdXO8oysQ8M@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y++BXkdXO8oysQ8M@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/17/2023 13:30, Russell King (Oracle) wrote:

Hi Russel,

> 
> On Fri, Feb 17, 2023 at 08:52:13AM +0100, Horatiu Vultur wrote:
> > +static void lan8841_ptp_perout_off(struct kszphy_ptp_priv *ptp_priv, int pin)
> > +{
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     u16 tmp;
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_EN) & LAN8841_PTP_GPIO_MASK;
> > +     tmp &= ~BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_EN, tmp);
> 
> Problem 1: doesn't check the return value of phy_read_mmd(), so a
> spurious error results in an error code written back to the register.
> 
> Issue 2: please use phy_modify_mmd() and definitions for the MMD. It
> probably also makes sense to cache the mask. Thus, this whole thing
> becomes:
> 
>         u16 mask = ~(LAN8841_PTP_GPIO_MASK | BIT(pin));
> 
>         phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_EN, mask, 0);
>         phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_DIR, mask, 0);
>         phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_BUF, mask, 0);

Thanks for the review.
I will look at phy_modify_mmd and the other helper functions and try to
use them in the other perout functions.

> 
> although I'm not sure why you need to mask off bits 15:11.

It is not necessary, only that those bits are marked as reserved.

> 
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DIR) & LAN8841_PTP_GPIO_MASK;
> > +     tmp &= ~BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_DIR, tmp);
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_BUF) & LAN8841_PTP_GPIO_MASK;
> > +     tmp &= ~BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_BUF, tmp);
> > +}
> > +
> > +static void lan8841_ptp_perout_on(struct kszphy_ptp_priv *ptp_priv, int pin)
> > +{
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     u16 tmp;
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_EN) & LAN8841_PTP_GPIO_MASK;
> > +     tmp |= BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_EN, tmp);
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DIR) & LAN8841_PTP_GPIO_MASK;
> > +     tmp |= BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_DIR, tmp);
> > +
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_BUF) & LAN8841_PTP_GPIO_MASK;
> > +     tmp |= BIT(pin);
> > +     phy_write_mmd(phydev, 2, LAN8841_GPIO_BUF, tmp);
> 
> Similar as above.
> 
> > +static void lan8841_ptp_remove_event(struct kszphy_ptp_priv *ptp_priv, int pin,
> > +                                  u8 event)
> > +{
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     u8 offset;
> > +     u16 tmp;
> > +
> > +     /* Not remove pin from the event. GPIO_DATA_SEL1 contains the GPIO
> > +      * pins 0-4 while GPIO_DATA_SEL2 contains GPIO pins 5-9, therefore
> > +      * depending on the pin, it requires to read a different register
> > +      */
> > +     if (pin < 5) {
> > +             tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL1);
> > +             offset = pin;
> > +     } else {
> > +             tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL2);
> > +             offset = pin - 5;
> > +     }
> > +     tmp &= ~(LAN8841_GPIO_DATA_SEL_GPIO_DATA_SEL_EVENT_MASK << (3 * offset));
> > +     if (pin < 5)
> > +             phy_write_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL1, tmp);
> > +     else
> > +             phy_write_mmd(phydev, 2, LAN8841_GPIO_DATA_SEL2, tmp);
> 
> This could be much simpler using phy_modify_mmd().
> 
> > +
> > +     /* Disable the event */
> > +     tmp = phy_read_mmd(phydev, 2, LAN8841_PTP_GENERAL_CONFIG);
> > +     if (event == LAN8841_EVENT_A) {
> > +             tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_POL_A;
> > +             tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_A_MASK;
> > +     } else {
> > +             tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_POL_A;
> > +             tmp &= ~LAN8841_PTP_GENERAL_CONFIG_LTC_EVENT_A_MASK;
> > +     }
> > +     phy_write_mmd(phydev, 2, LAN8841_PTP_GENERAL_CONFIG, tmp);
> 
> Ditto... and the theme seems to continue throughout the rest of this
> patch.
> 
> > +static int lan8841_ptp_perout(struct ptp_clock_info *ptp,
> > +                           struct ptp_clock_request *rq, int on)
> > +{
> > +     struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> > +                                                     ptp_clock_info);
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     struct timespec64 ts_on, ts_period;
> > +     s64 on_nsec, period_nsec;
> > +     int pulse_width;
> > +     int pin;
> > +
> > +     if (rq->perout.flags & ~PTP_PEROUT_DUTY_CYCLE)
> > +             return -EOPNOTSUPP;
> > +
> > +     pin = ptp_find_pin(ptp_priv->ptp_clock, PTP_PF_PEROUT, rq->perout.index);
> > +     if (pin == -1 || pin >= LAN8841_PTP_GPIO_NUM)
> > +             return -EINVAL;
> > +
> > +     if (!on) {
> > +             lan8841_ptp_perout_off(ptp_priv, pin);
> > +             lan8841_ptp_remove_event(ptp_priv, LAN8841_EVENT_A, pin);
> > +             return 0;
> > +     }
> > +
> > +     ts_on.tv_sec = rq->perout.on.sec;
> > +     ts_on.tv_nsec = rq->perout.on.nsec;
> > +     on_nsec = timespec64_to_ns(&ts_on);
> > +
> > +     ts_period.tv_sec = rq->perout.period.sec;
> > +     ts_period.tv_nsec = rq->perout.period.nsec;
> > +     period_nsec = timespec64_to_ns(&ts_period);
> > +
> > +     if (period_nsec < 200) {
> > +             phydev_warn(phydev,
> > +                         "perout period too small, minimum is 200 nsec\n");
> 
> I'm not sure using the kernel log to print such things is a good idea,
> especially without rate limiting.

I think it would be nice to have these warnings as it would be nice to
know why it fails. I will use pr_warn_ratelimited in the next version.

> 
> > @@ -3874,7 +4220,24 @@ static int lan8841_probe(struct phy_device *phydev)
> >       priv = phydev->priv;
> >       ptp_priv = &priv->ptp_priv;
> >
> > +     ptp_priv->pin_config = devm_kmalloc_array(&phydev->mdio.dev,
> > +                                               LAN8841_PTP_GPIO_NUM,
> > +                                               sizeof(*ptp_priv->pin_config),
> > +                                               GFP_KERNEL);
> 
> devm_kcalloc() to avoid the memset() below?

Good point. I will do that.

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
