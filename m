Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C4D519FEF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349982AbiEDMwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349759AbiEDMwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:52:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A09C35DE6;
        Wed,  4 May 2022 05:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G93hoWAPSx2gLrCey5jzHvD7tboB7igd9XdDDKC0XOc=; b=dLbUb9vPSlvjkgncUmlNID8eiE
        i96aCAHEy+tXMqpVzPbNp+W5UwFi4geobZUMi5AqYY8WIVj8pCAt9AbW+HWsFM8dy9YGAHMD58b05
        zH5ycR+77iQFUvCpydzLzmsayDlAHI2GjJ7VsZWgIqSTBSIobbzZEjA1k2jsIA2rMkTU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmEQY-001DBD-AY; Wed, 04 May 2022 14:48:22 +0200
Date:   Wed, 4 May 2022 14:48:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <YnJ2Fvux5ZE9zqyT@lunn.ch>
References: <20220504110655.1470008-1-o.rempel@pengutronix.de>
 <20220504110655.1470008-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504110655.1470008-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 01:06:55PM +0200, Oleksij Rempel wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> This driver was tested with NXP SJA1105, STMMAC and ASIX AX88772B USB Ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thanks for the re-write. This looks a lot better.

> +		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L);
> +		if (ret < 0)
> +			return ret;
> +
> +		cfg = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M);
> +		if (cfg < 0)
> +			return cfg;
> +
> +		if (ret & MDIO_AN_T1_ADV_L_FORCE_MS) {
> +			if (cfg & MDIO_AN_T1_ADV_M_MST)
> +				phydev->master_slave_get =
> +					MASTER_SLAVE_CFG_MASTER_FORCE;
> +			else
> +				phydev->master_slave_get =
> +					MASTER_SLAVE_CFG_SLAVE_FORCE;
> +		} else {
> +			if (cfg & MDIO_AN_T1_ADV_M_MST)
> +				phydev->master_slave_get =
> +					MASTER_SLAVE_CFG_MASTER_PREFERRED;
> +			else
> +				phydev->master_slave_get =
> +					MASTER_SLAVE_CFG_SLAVE_PREFERRED;
> +		}

Is this identical to genphy_c45_baset1_read_status()? I don't think
there are any odd vendor registers here. So i suggest exporting it and
making use of it.

> +static int dp83td510_config_master_slave(struct phy_device *phydev)
> +{
> +	int ctl = 0;
> +
> +	switch (phydev->master_slave_set) {
> +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> +		ctl = MDIO_PMA_PMD_BT1_CTRL_CFG_MST;
> +		break;
> +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> +		break;
> +	case MASTER_SLAVE_CFG_UNKNOWN:
> +	case MASTER_SLAVE_CFG_UNSUPPORTED:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL,
> +			     MDIO_PMA_PMD_BT1_CTRL_CFG_MST, ctl);

Is this identical to what is in genphy_c45_pma_setup_forced()? If so,
i would pull that code out into a helper and make use of it.


Thanks
	Andrew
