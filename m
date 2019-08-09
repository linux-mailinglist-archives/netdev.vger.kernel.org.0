Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976F78712B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 06:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405327AbfHIE6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 00:58:21 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42518 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfHIE6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 00:58:20 -0400
Received: by mail-ed1-f66.google.com with SMTP id m44so75441edd.9;
        Thu, 08 Aug 2019 21:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PL2Jgogtu2k8AmJ64fpJ0vvQA/W8ih7TKpBd6icTw2s=;
        b=MnbyPliF/prJwVrPi1bszEW3vRY2JUMf+dPQuB512WXoIF0Qjg+SE7lPmbqXjXVMmj
         GbevF0QPY1QjOsQi3cH9/RxwZNufkoDAfLTPd/gMxnuBgXuuSbsoLZKQAK/tEbl/HuJ6
         VtJ786VFw8Ob0J0lXuXvBeccbRrVGJFmpF1JeU/3ij1JXdKfTDYqpNq3vuCx4kZHVWXX
         prtPlf5tbLJqcf3zt7OXp1aD+adv5sp8RbKD/8fWSqa0nzu/ImneIs2ABqczUMJYhmv5
         leuB7YDLfoW2Izly7js43LS5EC32n/Pz9ZBZRwFBzgQvyWpGJAiaumcoAFq3VlWjwoGV
         tSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PL2Jgogtu2k8AmJ64fpJ0vvQA/W8ih7TKpBd6icTw2s=;
        b=NoB0rxgQn517BXuSVJ6yfJyc+/PR9a0DxtwF97QliodVRyPoQNOmerozqqn45lrh08
         4AiOGuO0iZuH/7+CKXS0cTDTJFCAy5PaSjJRaDcJpwqWYpSIbS9L6NdC1aAhvyU1hFDs
         NB1qMOwzXk738yTosR+oI1ltjPF+FdANRHONd1qgqpsYVt28mcfT3R0rZ9YaCEIycq9s
         mNmsY75PdJV3CSp097H0epWdjK/YcBfpsXpsz/nh+6XVfha19Fv9Zsp0SnMxR1RedpQQ
         huFWlxo++thKRp3q6n9K9Tm6seKR7sGyXDADEmjEyVslfwUUQCCjNnMyOGxmy5yUYbuH
         7v9w==
X-Gm-Message-State: APjAAAVbOnB1suvsz4O+Nr2SNcZRjv5FD6GC+gNXi6DDRzqSr/cgTsLg
        d/dsU2fM8+ex5UZP6DGd/KOoWX/r7CIEK1mqVs4=
X-Google-Smtp-Source: APXvYqwH04PsVqfE9KvzA0Gw8n1mS7s0MRG2Nz7x4iM36NXmjbLzIqcU0Um5dNC6c9T0vcvI8ba9/Ir9VJEIBOVnCXc=
X-Received: by 2002:a05:6402:1351:: with SMTP id y17mr19480461edw.18.1565326697822;
 Thu, 08 Aug 2019 21:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190808234816.4189789-1-taoren@fb.com>
In-Reply-To: <20190808234816.4189789-1-taoren@fb.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 9 Aug 2019 07:58:06 +0300
Message-ID: <CA+h21hpcmpXZZrN6NYwAMhqrOKK2oGq27iiRiDBFT-zAvvZfWA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/3] net: phy: add support for clause 37 auto-negotiation
To:     Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, openbmc@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 at 02:48, Tao Ren <taoren@fb.com> wrote:
>
> From: Heiner Kallweit <hkallweit1@gmail.com>
>
> This patch adds support for clause 37 1000Base-X auto-negotiation.
> It's compile-tested only as I don't have fiber equipment.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---

This needs your signed-off-by as well.

>  drivers/net/phy/phy_device.c | 139 +++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          |   5 ++
>  2 files changed, 144 insertions(+)
>
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 252a712d1b2b..7c5315302937 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1617,6 +1617,40 @@ static int genphy_config_advert(struct phy_device *phydev)
>         return changed;
>  }
>
> +/**
> + * genphy_c37_config_advert - sanitize and advertise auto-negotiation parameters
> + * @phydev: target phy_device struct
> + *
> + * Description: Writes MII_ADVERTISE with the appropriate values,
> + *   after sanitizing the values to make sure we only advertise
> + *   what is supported.  Returns < 0 on error, 0 if the PHY's advertisement
> + *   hasn't changed, and > 0 if it has changed. This function is intended
> + *   for Clause 37 1000Base-X mode.
> + */
> +static int genphy_c37_config_advert(struct phy_device *phydev)
> +{
> +       u16 adv = 0;
> +
> +       /* Only allow advertising what this PHY supports */
> +       linkmode_and(phydev->advertising, phydev->advertising,
> +                    phydev->supported);
> +
> +       if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> +                             phydev->advertising))
> +               adv |= ADVERTISE_1000XFULL;
> +       if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +                             phydev->advertising))
> +               adv |= ADVERTISE_1000XPAUSE;
> +       if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +                             phydev->advertising))
> +               adv |= ADVERTISE_1000XPSE_ASYM;
> +
> +       return phy_modify_changed(phydev, MII_ADVERTISE,
> +                                 ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
> +                                 ADVERTISE_1000XHALF | ADVERTISE_1000XPSE_ASYM,
> +                                 adv);
> +}
> +
>  /**
>   * genphy_config_eee_advert - disable unwanted eee mode advertisement
>   * @phydev: target phy_device struct
> @@ -1726,6 +1760,54 @@ int genphy_config_aneg(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_config_aneg);
>
> +/**
> + * genphy_c37_config_aneg - restart auto-negotiation or write BMCR
> + * @phydev: target phy_device struct
> + *
> + * Description: If auto-negotiation is enabled, we configure the
> + *   advertising, and then restart auto-negotiation.  If it is not
> + *   enabled, then we write the BMCR. This function is intended
> + *   for use with Clause 37 1000Base-X mode.
> + */
> +int genphy_c37_config_aneg(struct phy_device *phydev)
> +{
> +       int err, changed;
> +
> +       if (AUTONEG_ENABLE != phydev->autoneg)
> +               return genphy_setup_forced(phydev);
> +
> +       err = phy_modify(phydev, MII_BMCR, BMCR_SPEED1000 | BMCR_SPEED100,
> +                        BMCR_SPEED1000);
> +       if (err)
> +               return err;
> +
> +       changed = genphy_c37_config_advert(phydev);
> +       if (changed < 0) /* error */
> +               return changed;
> +
> +       if (!changed) {
> +               /* Advertisement hasn't changed, but maybe aneg was never on to
> +                * begin with?  Or maybe phy was isolated?
> +                */
> +               int ctl = phy_read(phydev, MII_BMCR);
> +
> +               if (ctl < 0)
> +                       return ctl;
> +
> +               if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
> +                       changed = 1; /* do restart aneg */
> +       }
> +
> +       /* Only restart aneg if we are advertising something different
> +        * than we were before.
> +        */
> +       if (changed > 0)
> +               return genphy_restart_aneg(phydev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(genphy_c37_config_aneg);
> +
>  /**
>   * genphy_aneg_done - return auto-negotiation status
>   * @phydev: target phy_device struct
> @@ -1864,6 +1946,63 @@ int genphy_read_status(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_read_status);
>
> +/**
> + * genphy_c37_read_status - check the link status and update current link state
> + * @phydev: target phy_device struct
> + *
> + * Description: Check the link, then figure out the current state
> + *   by comparing what we advertise with what the link partner
> + *   advertises. This function is for Clause 37 1000Base-X mode.
> + */
> +int genphy_c37_read_status(struct phy_device *phydev)
> +{
> +       int lpa, err, old_link = phydev->link;
> +
> +       /* Update the link, but return if there was an error */
> +       err = genphy_update_link(phydev);
> +       if (err)
> +               return err;
> +
> +       /* why bother the PHY if nothing can have changed */
> +       if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
> +               return 0;
> +
> +       phydev->duplex = DUPLEX_UNKNOWN;
> +       phydev->pause = 0;
> +       phydev->asym_pause = 0;
> +
> +       if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +               lpa = phy_read(phydev, MII_LPA);
> +               if (lpa < 0)
> +                       return lpa;
> +
> +               linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +                                phydev->lp_advertising, lpa & LPA_LPACK);
> +               linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
> +                                phydev->lp_advertising, lpa & LPA_1000XFULL);
> +               linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +                                phydev->lp_advertising, lpa & LPA_1000XPAUSE);
> +               linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +                                phydev->lp_advertising,
> +                                lpa & LPA_1000XPAUSE_ASYM);
> +
> +               phy_resolve_aneg_linkmode(phydev);
> +       } else if (phydev->autoneg == AUTONEG_DISABLE) {
> +               int bmcr = phy_read(phydev, MII_BMCR);
> +
> +               if (bmcr < 0)
> +                       return bmcr;
> +
> +               if (bmcr & BMCR_FULLDPLX)
> +                       phydev->duplex = DUPLEX_FULL;
> +               else
> +                       phydev->duplex = DUPLEX_HALF;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(genphy_c37_read_status);
> +
>  /**
>   * genphy_soft_reset - software reset the PHY via BMCR_RESET bit
>   * @phydev: target phy_device struct
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 462b90b73f93..81a2921512ee 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1077,6 +1077,11 @@ int genphy_suspend(struct phy_device *phydev);
>  int genphy_resume(struct phy_device *phydev);
>  int genphy_loopback(struct phy_device *phydev, bool enable);
>  int genphy_soft_reset(struct phy_device *phydev);
> +
> +/* Clause 37 */
> +int genphy_c37_config_aneg(struct phy_device *phydev);
> +int genphy_c37_read_status(struct phy_device *phydev);
> +
>  static inline int genphy_no_soft_reset(struct phy_device *phydev)
>  {
>         return 0;
> --
> 2.17.1
>
