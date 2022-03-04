Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD774CD4EB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiCDNOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiCDNOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:14:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE570106B3E;
        Fri,  4 Mar 2022 05:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pB32wDUZL436jRAa3plkNzIxf0EDPP1psVM4KdlXbSo=; b=35Rj16SwC/t855RzQ+l3mNRNge
        M79/mtVA9+V688ERcQpmxRX6RDBL1naaxDHjf1L+dgIpPwy9nPeMSGrqVH2nJc44sAzxB/CY7YJRB
        GE016xHJNCwSInhA9tUca+h5xvCmxsMYewAgRDujyr5tG8ZUIXGSv+6UaertoQwymo9M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ7kT-009EPO-Jh; Fri, 04 Mar 2022 14:13:33 +0100
Date:   Fri, 4 Mar 2022 14:13:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 6/6] net: phy: added ethtool master-slave
 configuration support
Message-ID: <YiIQfcKccbjtfPJo@lunn.ch>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
 <20220304094401.31375-7-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304094401.31375-7-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan87xx_read_master_slave(struct phy_device *phydev)
> +{
> +	int rc = 0;
> +
> +	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
> +	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
> +
> +	rc = phy_read(phydev, MII_CTRL1000);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (rc & CTL1000_AS_MASTER)
> +		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
> +	else
> +		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
> +
> +	rc = phy_read(phydev, MII_STAT1000);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (rc & LPA_1000MSRES)
> +		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
> +	else
> +		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
> +
> +	return rc;
> +}

It looks like you can just call genphy_read_master_slave()? Or am i
missing some subtle difference?

> +static int lan87xx_config_aneg(struct phy_device *phydev)
> +{
> +	u16 ctl = 0;
> +	int rc;
> +
> +	switch (phydev->master_slave_set) {
> +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> +		ctl |= CTL1000_AS_MASTER;
> +		break;
> +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> +		break;
> +	case MASTER_SLAVE_CFG_UNKNOWN:
> +	case MASTER_SLAVE_CFG_UNSUPPORTED:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	rc = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
> +	if (rc == 1)
> +		rc = genphy_soft_reset(phydev);
> +
> +	return rc;
> +}

Please use genphy_setup_master_slave()

       Andrew
