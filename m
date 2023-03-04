Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029B56AA745
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCDB2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCDB2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:28:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8B84B825;
        Fri,  3 Mar 2023 17:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C763B81A0F;
        Sat,  4 Mar 2023 01:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E5C433D2;
        Sat,  4 Mar 2023 01:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677893328;
        bh=ny6HjtYAUY+JHwTfupvSdYzhfWsHYhOu/qimYuTSYzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=huPAwxAThcBdwy/Qi0SHw1EW/gM9NEPEdeFTRyBENYeRF2Xp8oWxurflOzuKd1rO0
         8nG/kMKTxspzXfNFLdQ42BO6mcnVVgrXiYBmRHufm5OQk0wlCYyUKkpWLiF76jPkd+
         1XIT2/8XtZ/LFmEswFOSNabts5AsGz7r13F8Tbf7XorcIaG/OTfODgLgFwnf6Y+T9q
         X+so7Zm4Fq7jzVB6vykzVWQxbaKA0lycGp9RG2iTqmUchHq7vy9oIGLQ33DQ4gXZlM
         AgQ4INV/SI7Gz+khtwtXBQLSD8Hnh8QSwHxA3nk+yhl4o/R7M8LOIK+zje7zp6ig1H
         zi/L4eAaRM0Wg==
Date:   Fri, 3 Mar 2023 17:28:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        David Bauer <mail@david-bauer.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viorel Suman <viorel.suman@nxp.com>,
        Wei Fang <wei.fang@nxp.com>
Subject: Re: [PATCH RESEND v2 1/2] net: phy: at803x: fix the wol setting
 functions
Message-ID: <20230303172847.202fa96e@kernel.org>
In-Reply-To: <20230301030126.18494-1-leoyang.li@nxp.com>
References: <20230301030126.18494-1-leoyang.li@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 21:01:25 -0600 Li Yang wrote:
> In 7beecaf7d507 ("net: phy: at803x: improve the WOL feature"), it seems
> not correct to use a wol_en bit in a 1588 Control Register which is only
> available on AR8031/AR8033(share the same phy_id) to determine if WoL is
> enabled.  Change it back to use AT803X_INTR_ENABLE_WOL for determining
> the WoL status which is applicable on all chips supporting wol. Also
> update the at803x_set_wol() function to only update the 1588 register on
> chips having it.  After this change, disabling wol at probe from
> d7cd5e06c9dd ("net: phy: at803x: disable WOL at probe") is no longer
> needed.  So that part is removed.
> 
> Fixes: 7beecaf7d507b ("net: phy: at803x: improve the WOL feature")

Given the fixes tag Luo Jie <luoj@codeaurora.org> should be CCed.

> Signed-off-by: Li Yang <leoyang.li@nxp.com>
> Reviewed-by: Viorel Suman <viorel.suman@nxp.com>
> Reviewed-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/phy/at803x.c | 40 ++++++++++++++++------------------------
>  1 file changed, 16 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 22f4458274aa..2102279b3964 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -461,21 +461,25 @@ static int at803x_set_wol(struct phy_device *phydev,
>  			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
>  				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
>  
> -		/* Enable WOL function */
> -		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> -				0, AT803X_WOL_EN);
> -		if (ret)
> -			return ret;
> +		/* Enable WOL function for 1588 */
> +		if (phydev->drv->phy_id == ATH8031_PHY_ID) {
> +			ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,

This line is now too long, unless there is a good reason please stick
to the 80 char maximum.

> +					0, AT803X_WOL_EN);

while at it please fix the alignment, the continuation line should start
under phydev (checkpatch will tell you)

> +			if (ret)
> +				return ret;
> +		}
>  		/* Enable WOL interrupt */
>  		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
>  		if (ret)
>  			return ret;
>  	} else {
> -		/* Disable WoL function */
> -		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> -				AT803X_WOL_EN, 0);
> -		if (ret)
> -			return ret;
> +		/* Disable WoL function for 1588 */
> +		if (phydev->drv->phy_id == ATH8031_PHY_ID) {
> +			ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> +					AT803X_WOL_EN, 0);

same comments as above

> +			if (ret)
> +				return ret;
> +		}
>  		/* Disable WOL interrupt */
>  		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
>  		if (ret)
> @@ -510,11 +514,8 @@ static void at803x_get_wol(struct phy_device *phydev,
>  	wol->supported = WAKE_MAGIC;
>  	wol->wolopts = 0;
>  
> -	value = phy_read_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL);
> -	if (value < 0)
> -		return;
> -
> -	if (value & AT803X_WOL_EN)
> +	value = phy_read(phydev, AT803X_INTR_ENABLE);

Does phy_read() never fail? Why remove the error checking?

> +	if (value & AT803X_INTR_ENABLE_WOL)
>  		wol->wolopts |= WAKE_MAGIC;
>  }
>  

