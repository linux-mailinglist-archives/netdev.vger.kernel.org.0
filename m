Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3332C779
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfE1NK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:10:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38370 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfE1NK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gu5yE52cHj04ki+SFCnVLd2kgARn6EazU2ZaxtQJQPo=; b=jfy4tz8S2quBVv3Kyd9jgVt7e
        oHuPEdN4uGpd72Eok0dEtv5e3c6J94lF0ZH0bDOLP/GeLo5Nxw8OS55XFUD/ws7HiH564SBeiZORE
        yXYYJwB+fC1a2vpouyRZdRu2ZWIzmFcImm18pm2Zm9lX21GlPo0zCiCqlRmWqcRP0ppXnvLi/Cz35
        w3VOIpGjglsQwcep7csxQ7wOfr3SahmsooLZ8ufHbKYRaZpeh5+MdDtyHIEh87MDK1d+Ft3h451Yy
        X05Lmn21pZl5RY1OaD5XLaOo0ihdZXQAVt8JvQ+s334ddd0WbHKoAgRBJbU7UYY5mGaxAUXuKDURP
        I5Ux9gtyQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52678)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVbsR-0005vp-AZ; Tue, 28 May 2019 14:10:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVbsO-0003e0-Ve; Tue, 28 May 2019 14:10:49 +0100
Date:   Tue, 28 May 2019 14:10:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: export phy_queue_state_machine
Message-ID: <20190528131048.w5wywchf7hffoyzx@shell.armlinux.org.uk>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <ce95f8fa-29b2-53d0-6f69-72f9196aa7cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce95f8fa-29b2-53d0-6f69-72f9196aa7cb@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:28:04PM +0200, Heiner Kallweit wrote:
> We face the issue that link change interrupt and link status may be
> reported by different layers. As a result the link change interrupt

I'd describe this as "different PHY layers" to make it clear that we're
talking about the different blocks (eg, PMA vs PCS) in the PHY.

> may occur before the link status changes.
> Export phy_queue_state_machine to allow PHY drivers to specify a
> delay between link status change interrupt and link status check.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>

It should be noted that on its own, this change isn't useful, as
there's no way for a driver to use it without the following patch.

Other than that...

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/phy/phy.c | 8 +++++---
>  include/linux/phy.h   | 2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e88854292..20955836c 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -29,6 +29,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/atomic.h>
>  
> +#define PHY_STATE_TIME	HZ
> +
>  #define PHY_STATE_STR(_state)			\
>  	case PHY_##_state:			\
>  		return __stringify(_state);	\
> @@ -478,12 +480,12 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>  }
>  EXPORT_SYMBOL(phy_mii_ioctl);
>  
> -static void phy_queue_state_machine(struct phy_device *phydev,
> -				    unsigned int secs)
> +void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies)
>  {
>  	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
> -			 secs * HZ);
> +			 jiffies);
>  }
> +EXPORT_SYMBOL(phy_queue_state_machine);
>  
>  static void phy_trigger_machine(struct phy_device *phydev)
>  {
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 7180b1d1e..b133d59f3 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -188,7 +188,6 @@ static inline const char *phy_modes(phy_interface_t interface)
>  
>  
>  #define PHY_INIT_TIMEOUT	100000
> -#define PHY_STATE_TIME		1
>  #define PHY_FORCE_TIMEOUT	10
>  
>  #define PHY_MAX_ADDR	32
> @@ -1137,6 +1136,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
>  int phy_drivers_register(struct phy_driver *new_driver, int n,
>  			 struct module *owner);
>  void phy_state_machine(struct work_struct *work);
> +void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies);
>  void phy_mac_interrupt(struct phy_device *phydev);
>  void phy_start_machine(struct phy_device *phydev);
>  void phy_stop_machine(struct phy_device *phydev);
> -- 
> 2.21.0
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
