Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3427EAC7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgI3OTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:19:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgI3OTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 10:19:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNcwn-00GuTu-6Z; Wed, 30 Sep 2020 16:19:09 +0200
Date:   Wed, 30 Sep 2020 16:19:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        ayal@nvidia.com, danieller@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930141909.GJ3996795@lunn.ch>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
 <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't think so. Doing:
> > 
> > # ethtool -s eth0 autoneg
> > 
> > Is a pretty established behavior to enable all the supported advertise
> > bits.

I would disagree. phylib will return -EINVAL for this.

int phy_ethtool_ksettings_set(struct phy_device *phydev,
                              const struct ethtool_link_ksettings *cmd)
{
        __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
        u8 autoneg = cmd->base.autoneg;
        u8 duplex = cmd->base.duplex;
        u32 speed = cmd->base.speed;

...
        linkmode_copy(advertising, cmd->link_modes.advertising);

...

        if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
                return -EINVAL;

You have to pass a list of modes you want it to advertise. If you are
using phylink and not a copper PHY, and autoneg, that means you are
using in-band signalling. The same is imposed:

        /* If autonegotiation is enabled, we must have an advertisement */
        if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
                return -EINVAL;

We have consistent behaviour whenever Linux is controlling the PHY
because the core is imposing that behaviour. It would be nice if
drivers ignoring the PHY core where consistent with this.

	Andrew
