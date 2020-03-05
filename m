Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338B617A69C
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCENpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:45:40 -0500
Received: from lists.nic.cz ([217.31.204.67]:43160 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCENpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 08:45:40 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 08:45:39 EST
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id BE801141A93;
        Thu,  5 Mar 2020 14:38:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1583415531; bh=y15riXJR+DrsdwVlJxdS/SkxKUiC5pZ9UVOEQ78qD+k=;
        h=Date:From:To;
        b=iATxvOSjFfe5jxvs8hkEgBDU+5LYrv7Dt1cxrk2vusDnRZmMGW5GRqRtRu2tZauK5
         54U18C1ldqZWJjIGLnMYwAdamh3fWGqz1v9KfInN3zTsI/LoAAf/DcQlBWxwhH77Qr
         5SQJEXIlvtoC3ReaMiN0RAyH7RgSvx/Ed5M+2fE0=
Date:   Thu, 5 Mar 2020 14:38:47 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 06/10] net: dsa: mv88e6xxx: extend phylink to
 Serdes PHYs
Message-ID: <20200305143847.6507e32b@nic.cz>
In-Reply-To: <E1j9ppf-00072N-L9@rmk-PC.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
        <E1j9ppf-00072N-L9@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Mar 2020 12:42:31 +0000
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> +int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
> +				 u8 lane, int speed, int duplex)
> +{
> +	u16 val, bmcr;
> +	int err;
> +
> +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				    MV88E6390_SGMII_BMCR, &val);
> +	if (err)
> +		return err;
> +
> +	bmcr = val & ~(BMCR_SPEED100 | BMCR_FULLDPLX | BMCR_SPEED1000);
> +	switch (speed) {
> +	case SPEED_2500:
> +	case SPEED_1000:
> +		bmcr |= BMCR_SPEED1000;
>  		break;
> -	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> -		mode = PHY_INTERFACE_MODE_1000BASEX;
> +	case SPEED_100:
> +		bmcr |= BMCR_SPEED100;
>  		break;
> -	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> -		mode = PHY_INTERFACE_MODE_2500BASEX;
> +	case SPEED_10:
>  		break;
> -	default:
> -		mode = PHY_INTERFACE_MODE_NA;
>  	}
>  
> -	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex,
> -				       PAUSE_OFF, mode);
> -	if (err)
> -		dev_err(chip->dev, "can't propagate PHY settings to MAC: %d\n",
> -			err);
> -	else
> -		dsa_port_phylink_mac_change(ds, port, link == LINK_FORCED_UP);
> +	if (duplex == DUPLEX_FULL)
> +		bmcr |= BMCR_FULLDPLX;
> +
> +	if (bmcr == val)
> +		return 0;
> +
> +	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				      MV88E6390_SGMII_BMCR, bmcr);
> +}

Hi,

some time ago I wondered if it would make sense to separate the
SERDES PHY code into a separate phy driver to reside in
drivers/net/phy/marvell-serdes.c or something like that. Are there
compatible PHYs which aren't integrated into a switch?

Marek
