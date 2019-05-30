Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E352FCF9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfE3OM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:12:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfE3OM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+H86mRokP/tfN99hKLpy0hFhxWu5/m0TZIPQ9gaX55s=; b=Ox81I2ND1JgW9utJ4zVhQoj8LA
        9YZXin3hsONeLPSMHCRu6+XBGvsMHIWIzJ8jd2wDuTFClr1FWTLiRwK+k8KdrOZa79plPfoqe0ph7
        ubTaLocpruZfiZ6pR8g4UwKIJNnd4EpDanKlHaWAsgdl8KwL2wZ+vxkEWaGrtLSc4cf4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWLn2-0007Ai-ES; Thu, 30 May 2019 16:12:20 +0200
Date:   Thu, 30 May 2019 16:12:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190530141220.GG18059@lunn.ch>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
 <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
 <20190528161139.GQ18059@lunn.ch>
 <20190528162356.xjq53h4z7edvr3gl@shell.armlinux.org.uk>
 <20190529110315.uw4a24avp4czhcru@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529110315.uw4a24avp4czhcru@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here's the fuller patch for what I'm suggesting:
> 
>  drivers/net/phy/marvell10g.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 754cde873dde..86333d98b384 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -60,6 +60,8 @@ enum {
>  };
>  
>  struct mv3310_priv {
> +	bool firmware_failed;
> +
>  	struct device *hwmon_dev;
>  	char *hwmon_name;
>  };
> @@ -214,6 +216,10 @@ static int mv3310_probe(struct phy_device *phydev)
>  	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
>  		return -ENODEV;
>  
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
>  	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
>  	if (ret < 0)
>  		return ret;
> @@ -221,13 +227,9 @@ static int mv3310_probe(struct phy_device *phydev)
>  	if (ret & MV_PMA_BOOT_FATAL) {
>  		dev_warn(&phydev->mdio.dev,
>  			 "PHY failed to boot firmware, status=%04x\n", ret);
> -		return -ENODEV;
> +		priv->firmware_failed = true;
>  	}
>  
> -	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> -	if (!priv)
> -		return -ENOMEM;
> -
>  	dev_set_drvdata(&phydev->mdio.dev, priv);
>  
>  	ret = mv3310_hwmon_probe(phydev);
> @@ -247,6 +249,19 @@ static int mv3310_resume(struct phy_device *phydev)
>  	return mv3310_hwmon_config(phydev, true);
>  }
>  
> +static void mv3310_link_change_notify(struct phy_device *phydev)
> +{
> +	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> +	enum phy_state state = phydev->state;
> +
> +	if (priv->firmware_failed &&
> +	    (state == PHY_UP || state == PHY_RESUMING)) {
> +		dev_warn(&phydev->mdio.dev,
> +			 "PHY firmware failure: link forced down");
> +		phydev->state = state = PHY_HALTED;
> +	}
> +}

Hi Russell

This looks good.

     Andrew
