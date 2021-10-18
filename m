Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F59443292A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhJRVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:40:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233899AbhJRVkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WgZVH2o58S2b3z+JLYDkc0nTLqWy8/84Xlffw5Y2nuQ=; b=TEKI4v8zBXvSqIsZ0q6cWiLB1H
        ci08Ty4rj4zxQ29sKpqLyv/lIe2V5NZpJZMLiqJGy+nuMu3dUm3GU0jGeL5SuRqMbWVTaSxbDnkMw
        1mHkEiYJIsnGZu4SVfJ+T/wZ986bl0Y0X/T/9DAQCViWH+JVTeJgoEXD+MitjWQycmQE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcaKO-00B0ml-NW; Mon, 18 Oct 2021 23:37:52 +0200
Date:   Mon, 18 Oct 2021 23:37:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 08/13] net: phy: add qca8081 config_aneg
Message-ID: <YW3pMD7PD2M3lD3o@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-9-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-9-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:28AM +0800, Luo Jie wrote:
> Reuse at803x phy driver config_aneg excepting
> adding 2500M auto-negotiation.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/at803x.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 0c22ef735230..c124d3fe40fb 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -1084,7 +1084,30 @@ static int at803x_config_aneg(struct phy_device *phydev)
>  			return ret;
>  	}
>  
> -	return genphy_config_aneg(phydev);
> +	/* Do not restart auto-negotiation by setting ret to 0 defautly,
> +	 * when calling __genphy_config_aneg later.
> +	 */
> +	ret = 0;
> +
> +	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
> +		int phy_ctrl = 0;
> +
> +		/* The reg MII_BMCR also needs to be configured for force mode, the
> +		 * genphy_config_aneg is also needed.
> +		 */
> +		if (phydev->autoneg == AUTONEG_DISABLE)
> +			genphy_c45_pma_setup_forced(phydev);
> +
> +		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->advertising))
> +			phy_ctrl = MDIO_AN_10GBT_CTRL_ADV2_5G;
> +
> +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
> +				MDIO_AN_10GBT_CTRL_ADV2_5G, phy_ctrl);

Does the PHY also have MDIO_MMD_AN, MDIO_AN_ADVERTISE ? I'm wondering
if you can use genphy_c45_an_config_aneg()

   Andrew
