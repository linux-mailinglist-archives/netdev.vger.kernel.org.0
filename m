Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58A1C1F06
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEAUwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:52:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:53472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAUwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 16:52:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 615D0ACB1;
        Fri,  1 May 2020 20:52:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 307A1602E9; Fri,  1 May 2020 22:52:12 +0200 (CEST)
Date:   Fri, 1 May 2020 22:52:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v4 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200501205212.GE8976@lion.mk-sys.cz>
References: <20200501074633.24421-1-o.rempel@pengutronix.de>
 <20200501074633.24421-2-o.rempel@pengutronix.de>
 <20200501155210.GD8976@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501155210.GD8976@lion.mk-sys.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 05:52:10PM +0200, Michal Kubecek wrote:
> On Fri, May 01, 2020 at 09:46:32AM +0200, Oleksij Rempel wrote:
> [...]
> >  static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> >  				  struct ethtool_link_ksettings *ksettings,
> >  				  bool *mod)
> >  {
> >  	struct ethtool_link_settings *lsettings = &ksettings->base;
> >  	bool req_speed, req_duplex;
> > +	const struct nlattr *attr;
> >  	int ret;
> >  
> > +	attr = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
> > +	if (attr) {
> 
> Introducing the variable makes little sense if this is the only place
> where it is used. But if you decide to use it also in the two other
> places working with the attribute, it should probably have more
> descriptive name.
> 
> Michal
> 
> > +		u8 cfg = nla_get_u8(tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]);
> > +		if (!ethnl_validate_master_slave_cfg(cfg))
> > +			return -EOPNOTSUPP;
> > +	}

Also, please set extack error message and bad attribute when the check
fails.

Michal

> > +
> >  	*mod = false;
> >  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
> >  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
> > @@ -311,6 +357,8 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> >  			 mod);
> >  	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
> >  			mod);
> > +	ethnl_update_u8(&lsettings->master_slave_cfg,
> > +			tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG], mod);
> >  
> >  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
> >  	    (req_speed || req_duplex) &&
> > -- 
> > 2.26.2
> > 
