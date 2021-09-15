Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F540CEFD
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 23:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhIOVsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 17:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhIOVsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 17:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 821D5610E8;
        Wed, 15 Sep 2021 21:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631742437;
        bh=AImZg3cFJi8lrrxRbS17WV7+rLbY0cszOVAybcJUWSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AQ8XswHJxzRd8/fiIH6sqVT2xDxH14CIs9j7B8uZPEaOxqWBfqIKTx1gQQebUcvkr
         2QqMdKUKg930TjBwMhLSK+FI8V2RHwPvd6ZzkzHjjcPGFyAEMHrZYFuf3Mf7aeyKsK
         ZT6gwKUiKxYlgvpef2S1GVBKl6BoYRK2idvCZigStodofDL5HCQgabPp/UgL105kwu
         fww09oq2j6Q4VhsHobbE5Du07kbyOLgfGjhLkeTYSr9JULpIubUOg1gG8ir1zhJxoo
         uNOgQacTW0oU0rQ+NeTzy2oNT7UDhEO7sITChvwEYqf0FDdGkgObrlSCzh/QW7yW8F
         oGjAkVXAeumTg==
Date:   Wed, 15 Sep 2021 14:47:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: phy: bcm7xxx: Add EPHY entry for 72165
Message-ID: <20210915144716.12998b33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210914224042.418365-1-f.fainelli@gmail.com>
References: <20210914224042.418365-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 15:40:41 -0700 Florian Fainelli wrote:
> 72165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
> create a new macro and set of functions for this different process type.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/phy/bcm7xxx.c | 200 ++++++++++++++++++++++++++++++++++++++
>  include/linux/brcmphy.h   |   1 +
>  2 files changed, 201 insertions(+)
> 
> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
> index e79297a4bae8..f6912a77a378 100644
> --- a/drivers/net/phy/bcm7xxx.c
> +++ b/drivers/net/phy/bcm7xxx.c
> @@ -398,6 +398,189 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
>  	return bcm7xxx_28nm_ephy_apd_enable(phydev);
>  }
>  
> +static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
> +{
> +	int tmp, rcalcode, rcalnewcodelp, rcalnewcode11, rcalnewcode11d2;
> +
> +	/* Reset PHY */
> +	tmp = genphy_soft_reset(phydev);
> +	if (tmp)
> +		return tmp;
> +
> +	/* Reset AFE and PLL */
> +	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0006);
> +	/* Clear reset */
> +	bcm_phy_write_exp_sel(phydev, 0x0003, 0x0000);
> +
> +	/* Write PLL/AFE control register to select 54MHz crystal */
> +	bcm_phy_write_misc(phydev, 0x0030, 0x0001, 0x0000);
> +	bcm_phy_write_misc(phydev, 0x0031, 0x0000, 0x044a);
> +
> +	/* Change Ka,Kp,Ki to pdiv=1 */
> +	bcm_phy_write_misc(phydev, 0x0033, 0x0002, 0x71a1);
> +	/* Configuration override */
> +	bcm_phy_write_misc(phydev, 0x0033, 0x0001, 0x8000);
> +
> +	/* Change PLL_NDIV and PLL_NUDGE */
> +	bcm_phy_write_misc(phydev, 0x0031, 0x0001, 0x2f68);
> +	bcm_phy_write_misc(phydev, 0x0031, 0x0002, 0x0000);
> +
> +	/* Reference frequency is 54Mhz, config_mode[15:14] = 3 (low
> +	 * phase) */

Checkpatch points out:

WARNING: Block comments use a trailing */ on a separate line
#55: FILE: drivers/net/phy/bcm7xxx.c:429:
+	 * phase) */

> +	/* Drop LSB */
> +	rcalnewcode11d2 = (rcalnewcode11 & 0xfffe) / 2;
> +	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0001);
> +	/* Clear bits [11:5] */
> +	tmp &= ~0xfe0;
> +	/* set txcfg_ch0<5>=1 (enable + set local rcal) */
> +	tmp |= 0x0020 | (rcalnewcode11d2 * 64);
> +	bcm_phy_write_misc(phydev, 0x003d, 0x0001, tmp);
> +	bcm_phy_write_misc(phydev, 0x003d, 0x0002, tmp);
> +
> +	tmp = bcm_phy_read_misc(phydev, 0x003d, 0x0000);
> +	/* set txcfg<45:44>=11 (enable Rextra + invert fullscaledetect)
> +	 */
> +	tmp &= ~0x3000;
> +	tmp |= 0x3000;

Clearing then setting the same bits looks a little strange. Especially
since from the comment it sounds like these are two separate bits, not
a bitfield which is cleared and set as a whole. Anyway, up to you, just
jumped out when I was looking thru to see if the use of signed tmp may
cause any trouble...

> +	bcm_phy_write_misc(phydev, 0x003d, 0x0000, tmp);
> +
> +	return 0;
> +}
