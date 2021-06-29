Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFA3B74C3
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhF2PBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:01:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhF2PBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 11:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HEcsTCVg6+kwx1n3BhXwX1d9BEiVWSf6P93gu6Ugbsc=; b=5iLPhUiyIu5AwUpSFK99Ah7J5v
        wpZ67NmlQUy0hWlHUkCax2+HzNZy/3u2bfTNR7fQ5Saf9HiGCw3jrVjeqQodE+DSOENgPFDndK9Bh
        WWMp3zVTzWxpTW6euWx1SnGaI1/MIRzpQxNx3ph1g5AqwBVtKM5+V0iW2ZwzLZ4N7a9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lyFC3-00BYQO-7O; Tue, 29 Jun 2021 16:58:31 +0200
Date:   Tue, 29 Jun 2021 16:58:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v4 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YNs1F7pgNzDlm/mD@lunn.ch>
References: <20210628142946.16319-1-lxu@maxlinear.com>
 <20210628142946.16319-2-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628142946.16319-2-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gpy_config_aneg(struct phy_device *phydev)
> +{
> +	bool changed = false;
> +	u32 adv;
> +	int ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		/* Configure half duplex with genphy_setup_forced,
> +		 * because genphy_c45_pma_setup_forced does not support.
> +		 */
> +		return phydev->duplex != DUPLEX_FULL
> +			? genphy_setup_forced(phydev)
> +			: genphy_c45_pma_setup_forced(phydev);
> +	}
> +
> +	ret = genphy_c45_an_config_aneg(phydev);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	adv = linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
> +	ret = phy_modify_changed(phydev, MII_CTRL1000,
> +				 ADVERTISE_1000FULL | ADVERTISE_1000HALF,
> +				 adv);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	ret = genphy_c45_check_and_restart_aneg(phydev, changed);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
> +	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
> +		return 0;
> +
> +	/* No need to trigger re-ANEG if SGMII link speed is 2.5G
> +	 * or SGMII ANEG is disabled.
> +	 */

Is this correct. Are you using SGMII at 2.5G, or should this comment
be 2500BaseX?

Otherwise, this looks good now.

   Andrew
