Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4254F4A9735
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 10:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiBDJ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 04:56:25 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:60478 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbiBDJ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 04:56:24 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id E0A508030867;
        Fri,  4 Feb 2022 12:56:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru E0A508030867
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1643968583;
        bh=40LQjWECz2P7IV5SSGPbM6aWS8cMWRc2EdHMJbUlsOM=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=NdL7WHD2p0o+ecb9fpTGVq7DITa/mnWc9Z9E5h9D3fYKIwMTuxk9mF4zLulBx4T4H
         WZlJHyvARUs6FhAIeCn/l9cYaifSG7eKUCnQbGZHX9+Lm97Mk1bzZI2cJNpfju4MQ+
         D/+Eqeg6JuFcZV3Qc+iaw0aBqtnJAuvpJHijV0Vs=
Received: from mobilestation (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 4 Feb 2022 12:56:12 +0300
Date:   Fri, 4 Feb 2022 12:56:21 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     "=?utf-8?B?0J/QsNGA0YXQvtC80LXQvdC60L4g0J/QsNCy0LXQuyDQmtC40YDQuNC70Ls=?=
        =?utf-8?B?0L7QstC40Yc=?=" <Pavel.Parkhomenko@baikalelectronics.ru>
CC:     "michael@stapelberg.de" <michael@stapelberg.de>,
        "afleming@gmail.com" <afleming@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "=?utf-8?B?0JzQsNC70LDRhdC+0LIg0JDQu9C10LrRgdC10Lkg0JLQsNC70LXRgNGM0LU=?=
        =?utf-8?B?0LLQuNGH?=" <Alexey.Malahov@baikalelectronics.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Message-ID: <20220204095621.bcchrzupmtor3jbq@mobilestation>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc: Heiner, Russel, David, Jakub

-Sergey

On Fri, Feb 04, 2022 at 08:29:11AM +0300, Пархоменко Павел Кириллович wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply
> it's being done on the PHY side will consequently cause the traffic loss.
> We discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.
> 
> Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
>  drivers/net/phy/marvell.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4fcfca4e1702..a4f685927a64 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -551,9 +551,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct
> phy_device *phydev)
>  	else
>  		mscr = 0;
>  
> -	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> -				MII_88E1121_PHY_MSCR_REG,
> -				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
> +	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
> +					MII_88E1121_PHY_MSCR_REG,
> +					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
>  }
>  
>  static int m88e1121_config_aneg(struct phy_device *phydev)
> @@ -567,11 +567,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
>  			return err;
>  	}
>  
> +	changed = err;
> +
>  	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
>  	if (err < 0)
>  		return err;
>  
> -	changed = err;
> +	changed |= err;
>  
>  	err = genphy_config_aneg(phydev);
>  	if (err < 0)
> -- 
> 2.34.1
> 
> 
