Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55FE97F0A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfHUPhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:37:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729352AbfHUPht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 11:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xuBrmteC5AYtTtwM4c0/q/0f+0lPdxUwwmCp9CFt+9M=; b=YrdLKKCmA4/6woR3hIeUZHQxq7
        kyE3TevbpdsOOEaHwfN3v/P2QzgOWi+s2iyYsmtn3yJXTV5uXeyRJtD6BUl15Ynmx8hn6dR7hhAk2
        uYrBeJ4z+3i/a/ErtyLSAWa1fGUZt/20xbTlp4bpIFhakXjUli92V032szvaxkYMRAFo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0Sg8-0005rs-Ug; Wed, 21 Aug 2019 17:37:40 +0200
Date:   Wed, 21 Aug 2019 17:37:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Hartmann <marco.hartmann@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH v2 net] Add genphy_c45_config_aneg() function to phy-c45.c
Message-ID: <20190821153740.GB22091@lunn.ch>
References: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:00:46AM +0000, Marco Hartmann wrote:
> Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from calling
> genphy_config_aneg") introduced a check that aborts phy_config_aneg()
> if the phy is a C45 phy.
> This causes phy_state_machine() to call phy_error() so that the phy
> ends up in PHY_HALTED state.
> 
> Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
> (analogous to the C22 case) so that the state machine can run
> correctly.
> 
> genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
> in drivers/net/phy/marvell10g.c, excluding vendor specific
> configurations for 1000BaseT.

> +/**
> + * genphy_c45_config_aneg - restart auto-negotiation or forced setup
> + * @phydev: target phy_device struct
> + *
> + * Description: If auto-negotiation is enabled, we configure the
> + *   advertising, and then restart auto-negotiation.  If it is not
> + *   enabled, then we force a configuration.
> + */
> +int genphy_c45_config_aneg(struct phy_device *phydev)
> +{
> +	bool changed = false;
> +	int ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		return genphy_c45_pma_setup_forced(phydev);
> +
> +	ret = genphy_c45_an_config_aneg(phydev);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	return genphy_c45_check_and_restart_aneg(phydev, changed);
> +}
> +EXPORT_SYMBOL_GPL(genphy_c45_config_aneg);

The vendor parts for 1000BaseT makes this interesting. Do we expect to
see an C45 PHYs which don't support 1000BaseT? I think that
unlikely. So all C45 PHYs are going to implement their own config_aneg
callback so they can set their vendor registers for 1000BaseT.

> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index f3adea9ef400..74c4e15ebe52 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -507,7 +507,7 @@ static int phy_config_aneg(struct phy_device *phydev)
>  	 * allowed to call genphy_config_aneg()
>  	 */
>  	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
> -		return -EOPNOTSUPP;
> +		return genphy_c45_config_aneg(phydev);
>  
>  	return genphy_config_aneg(phydev);

So here we should be calling the driver config_aneg function. It can
then call genphy_c45_config_aneg(phydev) to do the generic parts.

Heiner, what do you think?

	Andrew
