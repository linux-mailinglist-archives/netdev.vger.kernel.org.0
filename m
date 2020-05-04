Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB091C3B42
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEDN3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:29:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:33040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgEDN3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 16598AD2C;
        Mon,  4 May 2020 13:29:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E7EB7604EE; Mon,  4 May 2020 15:29:47 +0200 (CEST)
Date:   Mon, 4 May 2020 15:29:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200504132947.GB8237@lion.mk-sys.cz>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
 <20200504091044.GA8237@lion.mk-sys.cz>
 <20200504101029.zt3eu7jsywdiq4tu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504101029.zt3eu7jsywdiq4tu@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 12:10:29PM +0200, Oleksij Rempel wrote:
> > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > index ac2784192472f..42dda9d2082ee 100644
> > > --- a/drivers/net/phy/phy_device.c
> > > +++ b/drivers/net/phy/phy_device.c
> > > @@ -1768,6 +1768,90 @@ int genphy_setup_forced(struct phy_device *phydev)
> > >  }
> > >  EXPORT_SYMBOL(genphy_setup_forced);
> > >  
> > > +static int genphy_setup_master_slave(struct phy_device *phydev)
> > > +{
> > > +	u16 ctl = 0;
> > > +
> > > +	if (!phydev->is_gigabit_capable)
> > > +		return 0;
> > 
> > Why did you revert to silently ignoring requests in this case?
> 
> genphy_setup_forced() is called by __genphy_config_aneg() and this can
> be called by a PHY driver after configuring master slave mode locally by
> PHY driver. See tja11xx patch. Same can be potentially done in the phy/realtek.c
> driver.
> 
> Currently my imagination is not caffeanized enough to
> provide a better solution. Do you have ideas?

If we have the check in ethnl_update_linkmodes(), we shouldn't really
get here so I believe we can leave this part as it is.

> > >  static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> > >  				  struct ethtool_link_ksettings *ksettings,
> > >  				  bool *mod)
> > >  {
> > >  	struct ethtool_link_settings *lsettings = &ksettings->base;
> > >  	bool req_speed, req_duplex;
> > > +	const struct nlattr *master_slave_cfg;
> > >  	int ret;
> > >  
> > > +	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
> > > +	if (master_slave_cfg) {
> > > +		u8 cfg = nla_get_u8(master_slave_cfg);
> > > +		if (!ethnl_validate_master_slave_cfg(cfg)) {
> > > +			GENL_SET_ERR_MSG(info, "LINKMODES_MASTER_SLAVE_CFG contains not valid value");
> > > +			return -EOPNOTSUPP;
> > > +		}
> > > +	}
> > 
> > Please set also the "bad attribute" in extack, it may help
> > non-interactive clients.
> > 
> > Also, it would be nice to report error if client wants to set master/slave but
> > driver does not support it. How about this?
> > 
> > 	if (master_slave_cfg) {
> > 		u8 cfg = nla_get_u8(master_slave_cfg);
> > 
> > 		if (lsettings->master_slave_cfg == MASTER_SLAVE_CFG_UNSUPPORTED) {
> > 			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
> > 					    "master/slave configuration not supported by device");
> > 			return -EOPNOTSUPP;
> > 		}
> > 		if (!ethnl_validate_master_slave_cfg(cfg)) {
> > 			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
> > 					    "master/slave value is invalid");
> > 			return -EOPNOTSUPP;
> > 		}
> > 	}
> > 
> 
> looks good. thx!
> 
> > 
> > Do you plan to allow handling master/slave also via ioctl()?
> 
> no.
> 
> > If yes, we should
> > also add the sanity checks to ioctl code path. If not, we should prevent
> > passing non-zero values from userspace to driver.
> 
> What is the best place to add this sanity check?

If there is no plan to allow handling master/slave via ioctl, the best
option would IMHO be zeroing both fields in ethtool_get_link_ksettings()
right before the call to store_link_ksettings_for_user() and either
zeroing master_slave_cfg in ethtool_set_link_ksettings() after the call
load_link_ksettings_from_user(), or checking that it's zero (i.e. that
userspace left it untouched).

Michal
