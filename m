Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8502A1B2792
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgDUNWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:22:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgDUNWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 09:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pr4kIV86i6RdLSOisndnN6QWmF5U0YqdmzY97zBHn5I=; b=07BmbEZ0oCBYzeImk4f/P8sUlY
        DFTMgAyyYmPPwdWD/Pn1vKGq/mVBup8ufn0J3/KdRQz97HzW9PgvmBP2Z5pdiGcQ5IWTm3wA4zyro
        m/zSBToaTmq/VfcdPRX19rhv5oartrf+dlIKNgaLwtt9mKE3XbCpcBldUx3kqRpN6tqA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQsr8-0041ll-Dh; Tue, 21 Apr 2020 15:22:30 +0200
Date:   Tue, 21 Apr 2020 15:22:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v2 2/2] net: phy: marvell10g: hwmon support for 2110
Message-ID: <20200421132230.GB937199@lunn.ch>
References: <efeacbb6b1f2fc4581e675f9f7a37a75bb898b51.1587466575.git.baruch@tkos.co.il>
 <78041607522313c5224832c205586d58a170361c.1587466575.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78041607522313c5224832c205586d58a170361c.1587466575.git.baruch@tkos.co.il>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:56:15PM +0300, Baruch Siach wrote:
> Read the temperature sensor register from the correct location for the
> 88E2110 PHY. There is no enable/disable bit, so leave
> mv3310_hwmon_config() for 88X3310 only.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: Fix indentation (Andrew Lunn)
> ---
>  drivers/net/phy/marvell10g.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 69530a84450f..b6115537eb66 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -66,6 +66,8 @@ enum {
>  	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
>  	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
>  
> +	MV_PCS_TEMP		= 0x8042,
> +
>  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
>  	 * registers appear to set themselves to the 0x800X when AN is
>  	 * restarted, but status registers appear readable from either.
> @@ -104,6 +106,14 @@ static umode_t mv3310_hwmon_is_visible(const void *data,
>  	return 0;
>  }
>  
> +static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
> +{
> +	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
> +		return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
> +	else /* MARVELL_PHY_ID_88E2110 */
> +		return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
> +}
> +

Hi Baruch

Given the discussion about splitting the driver up a bit, could you
add

mv2110_hwmon_read_temp_reg()

And maybe a wrapper

mvxx10_hwmon_read_temp_reg() which does the call into the correct
version? Not that i particularly like that prefix.

Do we have enough differences yet it is worth adding a structure of
function pointers for family member? But i would save that for
net-next, where as you are aiming for net with these patches.

	 Andrew
