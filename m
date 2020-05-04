Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158131C3682
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 12:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgEDKKi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 May 2020 06:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgEDKKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 06:10:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E34EC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 03:10:37 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVY3U-0007Sj-N1; Mon, 04 May 2020 12:10:32 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jVY3R-00029q-Ko; Mon, 04 May 2020 12:10:29 +0200
Date:   Mon, 4 May 2020 12:10:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20200504101029.zt3eu7jsywdiq4tu@pengutronix.de>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
 <20200504091044.GA8237@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200504091044.GA8237@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:42:37 up 171 days,  1:01, 187 users,  load average: 0.16, 0.08,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 11:10:44AM +0200, Michal Kubecek wrote:
> On Mon, May 04, 2020 at 09:12:13AM +0200, Oleksij Rempel wrote:
> > This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> > auto-negotiation support, we needed to be able to configure the
> > MASTER-SLAVE role of the port manually or from an application in user
> > space.
> > 
> > The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> > force MASTER or SLAVE role. See IEEE 802.3-2018:
> > 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> > 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> > 40.5.2 MASTER-SLAVE configuration resolution
> > 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> > 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> > 
> > The MASTER-SLAVE role affects the clock configuration:
> > 
> > -------------------------------------------------------------------------------
> > When the  PHY is configured as MASTER, the PMA Transmit function shall
> > source TX_TCLK from a local clock source. When configured as SLAVE, the
> > PMA Transmit function shall source TX_TCLK from the clock recovered from
> > data stream provided by MASTER.
> > 
> > iMX6Q                     KSZ9031                XXX
> > ------\                /-----------\        /------------\
> >       |                |           |        |            |
> >  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
> >       |<--- 125 MHz ---+-<------/  |        | \          |
> > ------/                \-----------/        \------------/
> >                                                ^
> >                                                 \-TX_TCLK
> > 
> > -------------------------------------------------------------------------------
> > 
> > Since some clock or link related issues are only reproducible in a
> > specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> > to provide generic (not 100BASE-T1 specific) interface to the user space
> > for configuration flexibility and trouble shooting.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index ac2784192472f..42dda9d2082ee 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1768,6 +1768,90 @@ int genphy_setup_forced(struct phy_device *phydev)
> >  }
> >  EXPORT_SYMBOL(genphy_setup_forced);
> >  
> > +static int genphy_setup_master_slave(struct phy_device *phydev)
> > +{
> > +	u16 ctl = 0;
> > +
> > +	if (!phydev->is_gigabit_capable)
> > +		return 0;
> 
> Why did you revert to silently ignoring requests in this case?

genphy_setup_forced() is called by __genphy_config_aneg() and this can
be called by a PHY driver after configuring master slave mode locally by
PHY driver. See tja11xx patch. Same can be potentially done in the phy/realtek.c
driver.

Currently my imagination is not caffeanized enough to
provide a better solution. Do you have ideas?

> On the
> other hand, we might rather want to do a more generic check which would
> handle all drivers not supporting the feature, see below.

> [...]
> > @@ -287,14 +308,37 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
> >  			     __ETHTOOL_LINK_MODE_MASK_NBITS);
> >  }
> >  
> > +static int ethnl_validate_master_slave_cfg(u8 cfg)
> > +{
> > +	switch (cfg) {
> > +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> > +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> > +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> > +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> > +		return 1;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Nitpick: bool would be more appropriate as return value.

ok

> > +
> >  static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> >  				  struct ethtool_link_ksettings *ksettings,
> >  				  bool *mod)
> >  {
> >  	struct ethtool_link_settings *lsettings = &ksettings->base;
> >  	bool req_speed, req_duplex;
> > +	const struct nlattr *master_slave_cfg;
> >  	int ret;
> >  
> > +	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
> > +	if (master_slave_cfg) {
> > +		u8 cfg = nla_get_u8(master_slave_cfg);
> > +		if (!ethnl_validate_master_slave_cfg(cfg)) {
> > +			GENL_SET_ERR_MSG(info, "LINKMODES_MASTER_SLAVE_CFG contains not valid value");
> > +			return -EOPNOTSUPP;
> > +		}
> > +	}
> 
> Please set also the "bad attribute" in extack, it may help
> non-interactive clients.
> 
> Also, it would be nice to report error if client wants to set master/slave but
> driver does not support it. How about this?
> 
> 	if (master_slave_cfg) {
> 		u8 cfg = nla_get_u8(master_slave_cfg);
> 
> 		if (lsettings->master_slave_cfg == MASTER_SLAVE_CFG_UNSUPPORTED) {
> 			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
> 					    "master/slave configuration not supported by device");
> 			return -EOPNOTSUPP;
> 		}
> 		if (!ethnl_validate_master_slave_cfg(cfg)) {
> 			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
> 					    "master/slave value is invalid");
> 			return -EOPNOTSUPP;
> 		}
> 	}
> 

looks good. thx!

> 
> Do you plan to allow handling master/slave also via ioctl()?

no.

> If yes, we should
> also add the sanity checks to ioctl code path. If not, we should prevent
> passing non-zero values from userspace to driver.

What is the best place to add this sanity check?

> Other than this, the patch looks good to me.
> 
> Michal
> 
> >  	*mod = false;
> >  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
> >  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
> > @@ -311,6 +355,7 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> >  			 mod);
> >  	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
> >  			mod);
> > +	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
> >  
> >  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
> >  	    (req_speed || req_duplex) &&
> > -- 
> > 2.26.2
> > 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
