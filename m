Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2123FB739
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbhH3Ntf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:49:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231669AbhH3Nte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 09:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gwsqDIyUPGoW35EKdagrZcdQpj/fqCOhxMvG1ube/jk=; b=cKMkwGcCNLqgTbwlr9esjk0K28
        LhkM4Kq2MjEwpjdn2rBqOR4vgX4FnAyUPA59As4dYi/oeFL5fqf3irksvK6QHcLdG5yNBSoFvrGSy
        gOUsNSWf+hUwkvSMQjg2me/UZr4qSHrYOqObL7PASft69NfVH3/IqqzajDPGfXmiPDMg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mKheO-004ZIE-9J; Mon, 30 Aug 2021 15:48:36 +0200
Date:   Mon, 30 Aug 2021 15:48:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v1 2/3] net: phy: add qca8081 ethernet phy driver
Message-ID: <YSzhtF8g42Ccv2h0@lunn.ch>
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830110733.8964-3-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 07:07:32PM +0800, Luo Jie wrote:
> qca8081 is a single port ethernet phy chip that supports
> 10/100/1000/2500 Mbps mode.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/at803x.c | 389 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 338 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index ecae26f11aa4..2b3563ae152f 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -33,10 +33,10 @@
>  #define AT803X_SFC_DISABLE_JABBER		BIT(0)
>  
>  #define AT803X_SPECIFIC_STATUS			0x11
> -#define AT803X_SS_SPEED_MASK			(3 << 14)
> -#define AT803X_SS_SPEED_1000			(2 << 14)
> -#define AT803X_SS_SPEED_100			(1 << 14)
> -#define AT803X_SS_SPEED_10			(0 << 14)
> +#define AT803X_SS_SPEED_MASK			GENMASK(15, 14)
> +#define AT803X_SS_SPEED_1000			2
> +#define AT803X_SS_SPEED_100			1
> +#define AT803X_SS_SPEED_10			0

This looks like an improvement, and nothing to do with qca8081. Please
make it an separate patch.

>  #define AT803X_SS_DUPLEX			BIT(13)
>  #define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
>  #define AT803X_SS_MDIX				BIT(6)
> @@ -158,6 +158,8 @@
>  #define QCA8337_PHY_ID				0x004dd036
>  #define QCA8K_PHY_ID_MASK			0xffffffff
>  
> +#define QCA8081_PHY_ID				0x004dd101
> +

Maybe keep all the PHY_ID together?

>  #define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
>  
>  #define AT803X_PAGE_FIBER			0
> @@ -167,7 +169,73 @@
>  #define AT803X_KEEP_PLL_ENABLED			BIT(0)
>  #define AT803X_DISABLE_SMARTEEE			BIT(1)
>  
> @@ -711,11 +779,18 @@ static void at803x_remove(struct phy_device *phydev)
>  
>  static int at803x_get_features(struct phy_device *phydev)
>  {
> -	int err;
> +	int val;

Why? The driver pretty consistently uses err for return values which
are errors.

>  
> -	err = genphy_read_abilities(phydev);
> -	if (err)
> -		return err;
> +	val = genphy_read_abilities(phydev);
> +	if (val)
> +		return val;
> +
> +	if (at803x_match_phy_id(phydev, QCA8081_PHY_ID)) {
> +		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);

You don't check if val indicates if there was an error.

> +
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
> +				val & MDIO_PMA_NG_EXTABLE_2_5GBT);
> +	}
>  
>  	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
>  		return 0;
> @@ -935,44 +1010,44 @@ static void at803x_link_change_notify(struct phy_device *phydev)
>  	}
>  }
>  
> -static int at803x_read_status(struct phy_device *phydev)
> +static int at803x_read_specific_status(struct phy_device *phydev)
>  {
> -	int ss, err, old_link = phydev->link;
> -
> -	/* Update the link, but return if there was an error */
> -	err = genphy_update_link(phydev);
> -	if (err)
> -		return err;
> -
> -	/* why bother the PHY if nothing can have changed */
> -	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
> -		return 0;
> +	int val;
>  
> -	phydev->speed = SPEED_UNKNOWN;
> -	phydev->duplex = DUPLEX_UNKNOWN;
> -	phydev->pause = 0;
> -	phydev->asym_pause = 0;
> +	val = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
> +	if (val < 0)
> +		return val;
>  
> -	err = genphy_read_lpa(phydev);
> -	if (err < 0)
> -		return err;
> +	switch (FIELD_GET(AT803X_SFC_MDI_CROSSOVER_MODE_M, val)) {
> +	case AT803X_SFC_MANUAL_MDI:
> +		phydev->mdix_ctrl = ETH_TP_MDI;
> +		break;
> +	case AT803X_SFC_MANUAL_MDIX:
> +		phydev->mdix_ctrl = ETH_TP_MDI_X;
> +		break;
> +	case AT803X_SFC_AUTOMATIC_CROSSOVER:
> +		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +		break;
> +	}
>  
>  	/* Read the AT8035 PHY-Specific Status register, which indicates the
>  	 * speed and duplex that the PHY is actually using, irrespective of
>  	 * whether we are in autoneg mode or not.
>  	 */
> -	ss = phy_read(phydev, AT803X_SPECIFIC_STATUS);
> -	if (ss < 0)
> -		return ss;
> +	val = phy_read(phydev, AT803X_SPECIFIC_STATUS);
> +	if (val < 0)
> +		return val;

What was actually wrong with ss?

Is this another case of just copying code from your other driver,
rather than cleanly extending the existing driver?

There are two many changes here all at once. Please break this patch
up. You are aiming for lots of small patches which are obviously
correct. Part of being obviously correct is having a good commit
message, and that gets much easier when a patch is small.

	 Andrew

