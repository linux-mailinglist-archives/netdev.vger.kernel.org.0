Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832BD196D15
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgC2Lry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:47:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36464 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgC2Lrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TG31+02/fMNgeHN1yRLGK1mOd+xzI1S+WfhasmHsNjs=; b=t95wITIB00ihExQJ1sb4Ne2Z7
        0NUtlRWOYGX7eD1Ae4m7Y64rB7Vn5AfoI9sCQrnnQOOcuAUqmoklOp3+DfPX0Hsj5hxL8jt3OInKe
        fhg47U7tXQY4C3fE2UQGOENyy6yXXpgmSKEz8IaYoUJaYUvuTggjoAfi4ogQS/21iO131pmkS6F3a
        EtORneNZ0LiUUYcUilr09cP8DOIilXO5bZX5b/1rVyxxXhlze6hpTDXoZRQsnmHQ8eckb1ZrD9Ety
        E6q9xKAtP25OGfJS8mWwmeDaylkoc4edEc6npwNg5IMyXq04wyBCQ6+ASwKRRtoa1An4FexL8mukb
        S+uZYvTmw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38762)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIWPo-0004nC-Mt; Sun, 29 Mar 2020 12:47:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIWPl-0006Bx-BS; Sun, 29 Mar 2020 12:47:41 +0100
Date:   Sun, 29 Mar 2020 12:47:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phylink: add separate pcs operations
 structure
Message-ID: <20200329114741.GZ25745@shell.armlinux.org.uk>
References: <20200326151458.GC25745@shell.armlinux.org.uk>
 <E1jHUEd-0007UX-Pm@rmk-PC.armlinux.org.uk>
 <DB8PR04MB6828E4768064062D959BF4EDE0CF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6828E4768064062D959BF4EDE0CF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:49:02PM +0000, Ioana Ciornei wrote:
> > Subject: [PATCH net-next 2/2] net: phylink: add separate pcs operations
> > structure
> > 
> > Add a separate set of PCS operations, which MAC drivers can use to couple
> > phylink with their associated MAC PCS layer.  The PCS operations include:
> > 
> > - pcs_get_state() - reads the link up/down, resolved speed, duplex
> >    and pause from the PCS.
> > - pcs_config() - configures the PCS for the specified mode, PHY
> >    interface type, and setting the advertisement.
> > - pcs_an_restart() - restarts 802.3 in-band negotiation with the
> >    link partner
> > - pcs_link_up() - informs the PCS that link has come up, and the
> >    parameters of the link. Link parameters are used to program the
> >    PCS for fixed speed and non-inband modes.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Are the old mac ops going to be removed at some point (after the drivers
> have been converted to the PCS operations)?
> I am referring to mac_pcs_get_state() and mac_an_restart().

If (and only if) it's possible to convert mvneta and mvpp2 sanely.
Splitting the PCS makes total sense, but we have to cope with hardware
where there is no clear demarcation between the PCS and MAC.  DSA also
has issues, because it's written as a layered driver, which does not
lend itself to easy gradual conversion of DSA drivers.

> Also, what are the rules for what should and shouldn't be done in the
> new pcs_config() method?

The pcs_config() method should set the PCS according to the interface
mode (state->interface) and the advertisement (state->advertising).
Nothing else should be used. I suppose I should pass those explicitly
rather than the whole state structure to prevent any mis-use.

> Maybe a documentation entry for this would help.

Yep.

> >  drivers/net/phy/phylink.c | 76 +++++++++++++++++++++++++++------------
> >  include/linux/phylink.h   | 11 ++++++
> >  2 files changed, 65 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c index
> > a34a3be92dba..abe2cc168f93 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -41,6 +41,7 @@ struct phylink {
> >  	/* private: */
> >  	struct net_device *netdev;
> >  	const struct phylink_mac_ops *mac_ops;
> > +	const struct phylink_pcs_ops *pcs_ops;
> >  	struct phylink_config *config;
> >  	struct device *dev;
> >  	unsigned int old_link_state:1;
> > @@ -425,11 +426,31 @@ static void phylink_mac_config_up(struct phylink *pl,
> >  		phylink_mac_config(pl, state);
> >  }
> > 
> > -static void phylink_mac_an_restart(struct phylink *pl)
> > +static void phylink_mac_pcs_an_restart(struct phylink *pl)
> >  {
> >  	if (pl->link_config.an_enabled &&
> > -	    phy_interface_mode_is_8023z(pl->link_config.interface))
> > -		pl->mac_ops->mac_an_restart(pl->config);
> > +	    phy_interface_mode_is_8023z(pl->link_config.interface)) {
> > +		if (pl->pcs_ops)
> > +			pl->pcs_ops->pcs_an_restart(pl->config);
> > +		else
> > +			pl->mac_ops->mac_an_restart(pl->config);
> > +	}
> > +}
> > +
> > +static void phylink_pcs_config(struct phylink *pl, bool force_restart,
> > +			       const struct phylink_link_state *state) {
> > +	bool restart = force_restart;
> > +
> > +	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
> > +						   pl->cur_link_an_mode,
> > +						   state))
> > +		restart = true;
> > +
> > +	phylink_mac_config(pl, state);
> > +
> > +	if (restart)
> > +		phylink_mac_pcs_an_restart(pl);
> >  }
> > 
> >  static void phylink_mac_pcs_get_state(struct phylink *pl, @@ -445,7 +466,10
> > @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
> >  	state->an_complete = 0;
> >  	state->link = 1;
> > 
> > -	pl->mac_ops->mac_pcs_get_state(pl->config, state);
> > +	if (pl->pcs_ops)
> > +		pl->pcs_ops->pcs_get_state(pl->config, state);
> > +	else
> > +		pl->mac_ops->mac_pcs_get_state(pl->config, state);
> >  }
> > 
> >  /* The fixed state is... fixed except for the link state, @@ -463,7 +487,7 @@
> > static void phylink_get_fixed_state(struct phylink *pl,
> >  	phylink_resolve_flow(state);
> >  }
> > 
> > -static void phylink_mac_initial_config(struct phylink *pl)
> > +static void phylink_mac_initial_config(struct phylink *pl, bool
> > +force_restart)
> >  {
> >  	struct phylink_link_state link_state;
> > 
> > @@ -489,7 +513,7 @@ static void phylink_mac_initial_config(struct phylink *pl)
> >  	link_state.link = false;
> > 
> >  	phylink_apply_manual_flow(pl, &link_state);
> > -	phylink_mac_config(pl, &link_state);
> > +	phylink_pcs_config(pl, force_restart, &link_state);
> >  }
> > 
> >  static const char *phylink_pause_to_str(int pause) @@ -506,12 +530,18 @@
> > static const char *phylink_pause_to_str(int pause)
> >  	}
> >  }
> > 
> > -static void phylink_mac_link_up(struct phylink *pl,
> > -				struct phylink_link_state link_state)
> > +static void phylink_link_up(struct phylink *pl,
> > +			    struct phylink_link_state link_state)
> >  {
> >  	struct net_device *ndev = pl->netdev;
> > 
> >  	pl->cur_interface = link_state.interface;
> > +
> > +	if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
> > +		pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
> > +					 pl->cur_interface,
> > +					 link_state.speed, link_state.duplex);
> > +
> >  	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
> >  				 pl->cur_link_an_mode, pl->cur_interface,
> >  				 link_state.speed, link_state.duplex, @@ -528,7
> > +558,7 @@ static void phylink_mac_link_up(struct phylink *pl,
> >  		     phylink_pause_to_str(link_state.pause));
> >  }
> > 
> > -static void phylink_mac_link_down(struct phylink *pl)
> > +static void phylink_link_down(struct phylink *pl)
> >  {
> >  	struct net_device *ndev = pl->netdev;
> > 
> > @@ -597,9 +627,9 @@ static void phylink_resolve(struct work_struct *w)
> >  	if (link_changed) {
> >  		pl->old_link_state = link_state.link;
> >  		if (!link_state.link)
> > -			phylink_mac_link_down(pl);
> > +			phylink_link_down(pl);
> >  		else
> > -			phylink_mac_link_up(pl, link_state);
> > +			phylink_link_up(pl, link_state);
> >  	}
> >  	if (!link_state.link && pl->mac_link_dropped) {
> >  		pl->mac_link_dropped = false;
> > @@ -746,6 +776,12 @@ struct phylink *phylink_create(struct phylink_config
> > *config,  }  EXPORT_SYMBOL_GPL(phylink_create);
> > 
> > +void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops
> > +*ops) {
> > +	pl->pcs_ops = ops;
> > +}
> > +EXPORT_SYMBOL_GPL(phylink_add_pcs);
> > +
> >  /**
> >   * phylink_destroy() - cleanup and destroy the phylink instance
> >   * @pl: a pointer to a &struct phylink returned from phylink_create() @@ -
> > 1082,14 +1118,12 @@ void phylink_start(struct phylink *pl)
> >  	/* Apply the link configuration to the MAC when starting. This allows
> >  	 * a fixed-link to start with the correct parameters, and also
> >  	 * ensures that we set the appropriate advertisement for Serdes links.
> > -	 */
> > -	phylink_mac_initial_config(pl);
> > -
> > -	/* Restart autonegotiation if using 802.3z to ensure that the link
> > +	 *
> > +	 * Restart autonegotiation if using 802.3z to ensure that the link
> >  	 * parameters are properly negotiated.  This is necessary for DSA
> >  	 * switches using 802.3z negotiation to ensure they see our modes.
> >  	 */
> > -	phylink_mac_an_restart(pl);
> > +	phylink_mac_initial_config(pl, true);
> > 
> >  	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
> >  	phylink_run_resolve(pl);
> > @@ -1386,8 +1420,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
> >  			 * advertisement; the only thing we have is the pause
> >  			 * modes which can only come from a PHY.
> >  			 */
> > -			phylink_mac_config(pl, &pl->link_config);
> > -			phylink_mac_an_restart(pl);
> > +			phylink_pcs_config(pl, true, &pl->link_config);
> >  		}
> >  		mutex_unlock(&pl->state_mutex);
> >  	}
> > @@ -1415,7 +1448,7 @@ int phylink_ethtool_nway_reset(struct phylink *pl)
> > 
> >  	if (pl->phydev)
> >  		ret = phy_restart_aneg(pl->phydev);
> > -	phylink_mac_an_restart(pl);
> > +	phylink_mac_pcs_an_restart(pl);
> > 
> >  	return ret;
> >  }
> > @@ -1494,8 +1527,7 @@ int phylink_ethtool_set_pauseparam(struct phylink
> > *pl,
> >  				   pause->tx_pause);
> >  	} else if (!test_bit(PHYLINK_DISABLE_STOPPED,
> >  			     &pl->phylink_disable_state)) {
> > -		phylink_mac_config(pl, &pl->link_config);
> > -		phylink_mac_an_restart(pl);
> > +		phylink_pcs_config(pl, true, &pl->link_config);
> >  	}
> >  	mutex_unlock(&pl->state_mutex);
> > 
> > @@ -1901,7 +1933,7 @@ static int phylink_sfp_config(struct phylink *pl, u8
> > mode,
> > 
> >  	if (changed && !test_bit(PHYLINK_DISABLE_STOPPED,
> >  				 &pl->phylink_disable_state))
> > -		phylink_mac_initial_config(pl);
> > +		phylink_mac_initial_config(pl, false);
> > 
> >  	return ret;
> >  }
> > diff --git a/include/linux/phylink.h b/include/linux/phylink.h index
> > 8fa6df3b881b..dc27dd341ebd 100644
> > --- a/include/linux/phylink.h
> > +++ b/include/linux/phylink.h
> > @@ -97,6 +97,16 @@ struct phylink_mac_ops {
> >  			    bool tx_pause, bool rx_pause);
> >  };
> > 
> > +struct phylink_pcs_ops {
> > +	void (*pcs_get_state)(struct phylink_config *config,
> > +			      struct phylink_link_state *state);
> > +	int (*pcs_config)(struct phylink_config *config, unsigned int mode,
> > +			  const struct phylink_link_state *state);
> > +	void (*pcs_an_restart)(struct phylink_config *config);
> > +	void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
> > +			    phy_interface_t interface, int speed, int duplex); };
> > +
> >  #if 0 /* For kernel-doc purposes only. */
> >  /**
> >   * validate - Validate and update the link configuration @@ -273,6 +283,7 @@
> > void mac_link_up(struct phylink_config *config, struct phy_device *phy,  struct
> > phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
> >  			       phy_interface_t iface,
> >  			       const struct phylink_mac_ops *ops);
> > +void phylink_add_pcs(struct phylink *, const struct phylink_pcs_ops
> > +*ops);
> >  void phylink_destroy(struct phylink *);
> > 
> >  int phylink_connect_phy(struct phylink *, struct phy_device *);
> > --
> > 2.20.1
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
