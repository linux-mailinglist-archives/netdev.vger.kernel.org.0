Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0C542D27
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiFHKXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiFHKWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:22:48 -0400
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7FA1D30D1;
        Wed,  8 Jun 2022 03:11:34 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2ef5380669cso203561677b3.9;
        Wed, 08 Jun 2022 03:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZYWirrqs8JIjAPK13ryUJnxtd3dCk+qeVPdqOOf69cA=;
        b=oyEsXC4UqWQ2Wu+tsfKoRPVrrp6rztZRZ+6Bo/WlBCR8JBLhJhEgVaBB+LQmVzHi0j
         VXLc9ArN8tLUNovaaPklBwhELeayH+09FN2U/TzQ++7+MZMmodPkONzR5h23x3GvzTO4
         Htt1u7yVP1eUDroWFmuyW2d5hg5sEayFPS1w/7ZOAvoyqKbVmG5a8Mr3M+0TPv/pEsUk
         IMqv1hSSEDCRSesfpxhY6YYVLV+2LYSfHg8Akxkzun1Zy/4jJnnQOZaSQQPSB6mjHdoV
         IlFdL1QQTFAi652tAqYtaaHK5Joj0Q64DBSeZT+A3LB02SlQkZgtSuKOJoz8si2FzreW
         vGxw==
X-Gm-Message-State: AOAM531Wx/HeJqZANcn+dVPiTrCq7FEhq/SUqGPiUr1mvqQR7gQD2lzT
        Gyx/fqeN38AY9w1ZkXeyq3bI+j2m98p/3CjIUXk=
X-Google-Smtp-Source: ABdhPJyY3yg/lUDbJa9jBFK3lftQ7MB3mk9lvArj1zK1sIRuyYn/uNirEBfql1JOdyR97DXwp/UUnh5+/T5wENqfDd8=
X-Received: by 2002:a81:1b97:0:b0:2db:640f:49d8 with SMTP id
 b145-20020a811b97000000b002db640f49d8mr35793043ywb.326.1654683087271; Wed, 08
 Jun 2022 03:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1654680790.git.lukas@wunner.de> <78ad73b93adb59edfa2d68e44a9fcfea65e98131.1654680790.git.lukas@wunner.de>
In-Reply-To: <78ad73b93adb59edfa2d68e44a9fcfea65e98131.1654680790.git.lukas@wunner.de>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 8 Jun 2022 12:11:15 +0200
Message-ID: <CAJZ5v0h62BasPSKYctUcqb3gt0xbHEDeh=j5D8Y1yrsF0ro-zA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/1] net: phy: Don't trigger state machine while in suspend
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        netdev <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:57 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
> but subsequent interrupts may retrigger it:
>
> They may have been left enabled to facilitate wakeup and are not
> quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
> hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
> as well as between dpm_resume_noirq() and mdio_bus_phy_resume().
>
> Retriggering the phy_state_machine() through an interrupt is not only
> undesirable for the reason given in mdio_bus_phy_suspend() (freezing it
> midway with phydev->lock held), but also because the PHY may be
> inaccessible after it's suspended:  Accesses to USB-attached PHYs are
> blocked once usb_suspend_both() clears the can_submit flag and PHYs on
> PCI network cards may become inaccessible upon suspend as well.
>
> Amend phy_interrupt() to avoid triggering the state machine if the PHY
> is suspended.  Signal wakeup instead if the attached net_device or its
> parent has been configured as a wakeup source.  (Those conditions are
> identical to mdio_bus_phy_may_suspend().)  Postpone handling of the
> interrupt until the PHY has resumed.
>
> Before stopping the phy_state_machine() in mdio_bus_phy_suspend(),
> wait for a concurrent phy_interrupt() to run to completion.  That is
> necessary because phy_interrupt() may have checked the PHY's suspend
> status before the system sleep transition commenced and it may thus
> retrigger the state machine after it was stopped.
>
> Likewise, after re-enabling interrupt handling in mdio_bus_phy_resume(),
> wait for a concurrent phy_interrupt() to complete to ensure that
> interrupts which it postponed are properly rerun.
>
> Link: https://lore.kernel.org/netdev/a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com/
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Looks reasonable to me.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/net/phy/phy.c        | 23 +++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
>  include/linux/phy.h          |  6 ++++++
>  3 files changed, 52 insertions(+)
>
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index ef62f357b76d..8d3ee3a6495b 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -31,6 +31,7 @@
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
>  #include <linux/atomic.h>
> +#include <linux/suspend.h>
>  #include <net/netlink.h>
>  #include <net/genetlink.h>
>  #include <net/sock.h>
> @@ -976,6 +977,28 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>         struct phy_driver *drv = phydev->drv;
>         irqreturn_t ret;
>
> +       /* Wakeup interrupts may occur during a system sleep transition.
> +        * Postpone handling until the PHY has resumed.
> +        */
> +       if (IS_ENABLED(CONFIG_PM_SLEEP) && phydev->irq_suspended) {
> +               struct net_device *netdev = phydev->attached_dev;
> +
> +               if (netdev) {
> +                       struct device *parent = netdev->dev.parent;
> +
> +                       if (netdev->wol_enabled)
> +                               pm_system_wakeup();
> +                       else if (device_may_wakeup(&netdev->dev))
> +                               pm_wakeup_dev_event(&netdev->dev, 0, true);
> +                       else if (parent && device_may_wakeup(parent))
> +                               pm_wakeup_dev_event(parent, 0, true);
> +               }
> +
> +               phydev->irq_rerun = 1;
> +               disable_irq_nosync(irq);
> +               return IRQ_HANDLED;
> +       }
> +
>         mutex_lock(&phydev->lock);
>         ret = drv->handle_interrupt(phydev);
>         mutex_unlock(&phydev->lock);
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 431a8719c635..46acddd865a7 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -278,6 +278,15 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
>         if (phydev->mac_managed_pm)
>                 return 0;
>
> +       /* Wakeup interrupts may occur during the system sleep transition when
> +        * the PHY is inaccessible. Set flag to postpone handling until the PHY
> +        * has resumed. Wait for concurrent interrupt handler to complete.
> +        */
> +       if (phy_interrupt_is_valid(phydev)) {
> +               phydev->irq_suspended = 1;
> +               synchronize_irq(phydev->irq);
> +       }
> +
>         /* We must stop the state machine manually, otherwise it stops out of
>          * control, possibly with the phydev->lock held. Upon resume, netdev
>          * may call phy routines that try to grab the same lock, and that may
> @@ -315,6 +324,20 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>         if (ret < 0)
>                 return ret;
>  no_resume:
> +       if (phy_interrupt_is_valid(phydev)) {
> +               phydev->irq_suspended = 0;
> +               synchronize_irq(phydev->irq);
> +
> +               /* Rerun interrupts which were postponed by phy_interrupt()
> +                * because they occurred during the system sleep transition.
> +                */
> +               if (phydev->irq_rerun) {
> +                       phydev->irq_rerun = 0;
> +                       enable_irq(phydev->irq);
> +                       irq_wake_thread(phydev->irq, phydev);
> +               }
> +       }
> +
>         if (phydev->attached_dev && phydev->adjust_link)
>                 phy_start_machine(phydev);
>
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 508f1149665b..b09f7d36cff2 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -572,6 +572,10 @@ struct macsec_ops;
>   * @mdix_ctrl: User setting of crossover
>   * @pma_extable: Cached value of PMA/PMD Extended Abilities Register
>   * @interrupts: Flag interrupts have been enabled
> + * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
> + *                 handling shall be postponed until PHY has resumed
> + * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
> + *             requiring a rerun of the interrupt handler after resume
>   * @interface: enum phy_interface_t value
>   * @skb: Netlink message for cable diagnostics
>   * @nest: Netlink nest used for cable diagnostics
> @@ -626,6 +630,8 @@ struct phy_device {
>
>         /* Interrupts are enabled */
>         unsigned interrupts:1;
> +       unsigned irq_suspended:1;
> +       unsigned irq_rerun:1;
>
>         enum phy_state state;
>
> --
> 2.35.2
>
