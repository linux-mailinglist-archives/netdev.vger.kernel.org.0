Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10672B2BE1
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfINP3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:29:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbfINP3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 11:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ojBtSZjsLQbmE+E60gjqm/aDpVR0C0zx5ST6PykWXH8=; b=q3htXlUCCr0pyzUWgTSbCKiIPI
        nOwZ3G0D9EuCotyJ/Uohl5r9NLl4xoDoucSXYQZxDOJiOky+RBMi/y3+/a5sg3UQ9ithjt/j8fmWD
        9ME9gkkdjwMaM/Ewh2UjmD8A8hu9skyYEevaqKF5cQuhw7Gz/Pl91DDpaizzvu22GG1s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i99zP-0008Dt-I0; Sat, 14 Sep 2019 17:29:31 +0200
Date:   Sat, 14 Sep 2019 17:29:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz
Subject: Re: [PATCH v4 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Message-ID: <20190914152931.GK27922@lunn.ch>
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
 <20190912162812.402-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912162812.402-3-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 07:28:12PM +0300, Alexandru Ardelean wrote:

> +static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
> +{
> +	u16 val;
> +
> +	if (tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
> +		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
> +				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
> +
> +	val = ADIN1300_NRG_PD_EN;
> +
> +	switch (tx_interval) {
> +	case 1000: /* 1 second */
> +		/* fallthrough */
> +	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
> +		val |= ADIN1300_NRG_PD_TX_EN;
> +		/* fallthrough */
> +	case ETHTOOL_PHY_EDPD_NO_TX:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return phy_modify(phydev, ADIN1300_PHY_CTRL_STATUS2,
> +			  (ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN),
> +			  val);
> +}
> +

>  
> +	rc = adin_set_edpd(phydev, 1);
> +	if (rc < 0)
> +		return rc;

Hi Alexandru

Shouldn't this be adin_set_edpd(phydev, 1000);

	Andrew
