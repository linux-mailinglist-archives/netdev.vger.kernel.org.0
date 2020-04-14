Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DCB1A8A1A
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504356AbgDNSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:47:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504345AbgDNSrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 14:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A+16RsUAoG6H5ATYewhMP3VwxAkjRbky3by/uPVeOJo=; b=EhxXmYmGRQ/YFlwIqvWkLmsVxt
        oez1sRYED1s89KnExZpDgXWR2Ad8MDyJ7WBgpkg06PQH+ucWErCTXE8x/jGpddpptcJimWtIIuyp7
        QQHEGwo3Vm2rc1XJjZKw10Nz4Z/6hcCU8M+Ot4MQOia65MoR6DRNYcppY9EyDBOy9cXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOQax-002i33-Lk; Tue, 14 Apr 2020 20:47:39 +0200
Date:   Tue, 14 Apr 2020 20:47:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: marvell10g: report firmware version
Message-ID: <20200414184739.GD637127@lunn.ch>
References: <20200414182935.GY25745@shell.armlinux.org.uk>
 <E1jOQK7-0001WH-KM@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jOQK7-0001WH-KM@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 07:30:15PM +0100, Russell King wrote:
> Report the firmware version when probing the PHY to allow issues
> attributable to firmware to be diagnosed.
> 
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/marvell10g.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 7621badae64d..ee60417cdc55 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -33,6 +33,8 @@
>  #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
>  
>  enum {
> +	MV_PMA_FW_VER0		= 0xc011,
> +	MV_PMA_FW_VER1		= 0xc012,
>  	MV_PMA_BOOT		= 0xc050,
>  	MV_PMA_BOOT_FATAL	= BIT(0),
>  
> @@ -83,6 +85,8 @@ enum {
>  };
>  
>  struct mv3310_priv {
> +	u32 firmware_ver;
> +
>  	struct device *hwmon_dev;
>  	char *hwmon_name;
>  };
> @@ -355,6 +359,23 @@ static int mv3310_probe(struct phy_device *phydev)
>  
>  	dev_set_drvdata(&phydev->mdio.dev, priv);
>  
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER0);
> +	if (ret < 0)
> +		return ret;
> +
> +	priv->firmware_ver = ret << 16;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER1);
> +	if (ret < 0)
> +		return ret;
> +
> +	priv->firmware_ver |= ret;
> +
> +	dev_info(&phydev->mdio.dev,
> +		 "Firmware version %u.%u.%u.%u\n",
> +		 priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
> +		 (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
> +

Hi Russell

Did you consider using phydev_info()? Or is it too early, and you
don't get a sensible name?

      Andrew
