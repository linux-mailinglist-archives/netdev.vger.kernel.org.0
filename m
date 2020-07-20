Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD52261C5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGTOTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTOTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:19:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11370C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 07:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R0cX1z/xTrWfMWmov0FO44nU3oaQffVV9X5WyI3YSvI=; b=KYbCsTzM17ObvjUZsq3bRW4uu
        qpiJg8KxY5xSIOZdLeul6qCNQtVueDeil95jlsbvuiDb70yOkS6+aNDeknFNskwI6hiWOoC4hPQ6G
        bYMTkP/Tnfx735+f/dq947xsoywi0OePzr4b/mUasISge3KKsxoWWKhvolWZKQYTPiaTrYoirgmd7
        xN/JdoC2fRkFjOEIB+7EuMg2L4bSgzQVnxhorx3tphEy1xjvU7I2Rn8V9T4yJY2SkUTfm5voDi7h6
        rbeC+ZFPWGD9GjKmsHczni0DEAWkHgt5FTUv3f2JVUfrId5ZTGDcFld/hWkeszxYF3dVf7L2z8j42
        t/lW/paLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41922)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jxWdE-00037q-UL; Mon, 20 Jul 2020 15:19:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jxWdB-00052k-Vz; Mon, 20 Jul 2020 15:19:02 +0100
Date:   Mon, 20 Jul 2020 15:19:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 11/13] net: phylink: re-implement interface
 configuration with PCS
Message-ID: <20200720141901.GV1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGJ-0006QA-E2@rmk-PC.armlinux.org.uk>
 <VI1PR0402MB387151248ABD93EAA9C2E454E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200720124405.GT1551@shell.armlinux.org.uk>
 <VI1PR0402MB3871F35402449975F73B156BE07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871F35402449975F73B156BE07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 01:02:21PM +0000, Ioana Ciornei wrote:
> On 7/20/20 3:44 PM, Russell King - ARM Linux admin wrote:
> > On Mon, Jul 20, 2020 at 11:40:44AM +0000, Ioana Ciornei wrote:
> >> On 6/30/20 5:29 PM, Russell King wrote:
> >>> With PCS support, how we implement interface reconfiguration is not up
> >>> to the job; we end up reconfiguring the PCS for an interface change
> >>> while the link could potentially be up.  In order to solve this, add
> >>> two additional MAC methods for interface configuration, one to prepare
> >>> for the change, and one to finish the change.
> >>>
> >>> This allows mvneta and mvpp2 to shutdown what they require prior to the
> >>> MAC and PCS configuration calls, and then restart as appropriate.
> >>>
> >>> This impacts ksettings_set(), which now needs to identify whether the
> >>> change is a minor tweak to the advertisement masks or whether the
> >>> interface mode has changed, and call the appropriate function for that
> >>> update.
> >>>
> >>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >>> ---
> >>>    drivers/net/phy/phylink.c | 80 ++++++++++++++++++++++++++-------------
> >>>    include/linux/phylink.h   | 48 +++++++++++++++++++++++
> >>>    2 files changed, 102 insertions(+), 26 deletions(-)
> >>>
> >>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> >>> index 09f4aeef15c7..a31a00fb4974 100644
> >>> --- a/drivers/net/phy/phylink.c
> >>> +++ b/drivers/net/phy/phylink.c
> >>> @@ -433,23 +433,47 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
> >>>    	}
> >>>    }
> >>>    
> >>> -static void phylink_pcs_config(struct phylink *pl, bool force_restart,
> >>> -			       const struct phylink_link_state *state)
> >>> +static void phylink_change_interface(struct phylink *pl, bool restart,
> >>> +				     const struct phylink_link_state *state)
> >>>    {
> >>> -	bool restart = force_restart;
> >>> +	int err;
> >>> +
> >>> +	phylink_dbg(pl, "change interface %s\n", phy_modes(state->interface));
> >>>    
> >>> -	if (pl->pcs_ops && pl->pcs_ops->pcs_config(pl->config,
> >>> -						   pl->cur_link_an_mode,
> >>> -						   state->interface,
> >>> -						   state->advertising,
> >>> -						   !!(pl->link_config.pause &
> >>> -						      MLO_PAUSE_AN)))
> >>> -		restart = true;
> >>> +	if (pl->mac_ops->mac_prepare) {
> >>> +		err = pl->mac_ops->mac_prepare(pl->config, pl->cur_link_an_mode,
> >>> +					       state->interface);
> >>> +		if (err < 0) {
> >>> +			phylink_err(pl, "mac_prepare failed: %pe\n",
> >>> +				    ERR_PTR(err));
> >>> +			return;
> >>> +		}
> >>> +	}
> >>>    
> >>>    	phylink_mac_config(pl, state);
> >>>    
> >>> +	if (pl->pcs_ops) {
> >>> +		err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
> >>> +					      state->interface,
> >>> +					      state->advertising,
> >>> +					      !!(pl->link_config.pause &
> >>> +						 MLO_PAUSE_AN));
> >>> +		if (err < 0)
> >>> +			phylink_err(pl, "pcs_config failed: %pe\n",
> >>> +				    ERR_PTR(err));
> >>> +		if (err > 0)
> >>> +			restart = true;
> >>> +	}
> >>>    	if (restart)
> >>>    		phylink_mac_pcs_an_restart(pl);
> >>> +
> >>> +	if (pl->mac_ops->mac_finish) {
> >>> +		err = pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,
> >>> +					      state->interface);
> >>> +		if (err < 0)
> >>> +			phylink_err(pl, "mac_prepare failed: %pe\n",
> >>> +				    ERR_PTR(err));
> >>> +	}
> >>>    }
> >>>    
> >>>    /*
> >>> @@ -555,7 +579,7 @@ static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
> >>>    	link_state.link = false;
> >>>    
> >>>    	phylink_apply_manual_flow(pl, &link_state);
> >>> -	phylink_pcs_config(pl, force_restart, &link_state);
> >>> +	phylink_change_interface(pl, force_restart, &link_state);
> >>>    }
> >>>    
> >>>    static const char *phylink_pause_to_str(int pause)
> >>> @@ -674,7 +698,7 @@ static void phylink_resolve(struct work_struct *w)
> >>>    				phylink_link_down(pl);
> >>>    				cur_link_state = false;
> >>>    			}
> >>> -			phylink_pcs_config(pl, false, &link_state);
> >>> +			phylink_change_interface(pl, false, &link_state);
> >>>    			pl->link_config.interface = link_state.interface;
> >>>    		} else if (!pl->pcs_ops) {
> >>>    			/* The interface remains unchanged, only the speed,
> >>> @@ -1450,22 +1474,26 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
> >>>    		return -EINVAL;
> >>>    
> >>>    	mutex_lock(&pl->state_mutex);
> >>> -	linkmode_copy(pl->link_config.advertising, config.advertising);
> >>> -	pl->link_config.interface = config.interface;
> >>>    	pl->link_config.speed = config.speed;
> >>>    	pl->link_config.duplex = config.duplex;
> >>> -	pl->link_config.an_enabled = kset->base.autoneg !=
> >>> -				     AUTONEG_DISABLE;
> >>> -
> >>> -	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
> >>> -	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
> >>> -		/* If in 802.3z mode, this updates the advertisement.
> >>> -		 *
> >>> -		 * If we are in SGMII mode without a PHY, there is no
> >>> -		 * advertisement; the only thing we have is the pause
> >>> -		 * modes which can only come from a PHY.
> >>> -		 */
> >>> -		phylink_pcs_config(pl, true, &pl->link_config);
> >>> +	pl->link_config.an_enabled = kset->base.autoneg != AUTONEG_DISABLE;
> >>> +
> >>> +	if (pl->link_config.interface != config.interface) {
> >>
> >>
> >> I cannot seem to understand where in this function config.interface
> >> could become different from pl->link_config.interface.
> >>
> >> Is there something obvious that I am missing?
> > 
> > The validate() method is free to change the interface if required -
> > there's a helper that MACs can use to achieve that for switching
> > between 1000base-X and 2500base-X.  Useful if you have a FC SFP
> > plugged in capable of 2500base-X, but want to communicate with a
> > 1000base-X link partner.
> > 
> 
> Ok, I was not aware of this possibility. Now that I looked, it's even 
> documented in phylink's header file.
> 
> My confusion stems from the fact that I expected this to come from the 
> SFP itself requesting an interface type or the other. So the usage here 
> is to know what is at the other end of the line and configure the 
> appropriate advertisement with ethtool?

SFPs do not specify their host interface - they specify a range of
parameters which describe the media side.  Even then, it is not
unusual for various parameters in the EEPROM to be incorrect.

Also, 2500BASE-X at one end and 1000BASE-X at the other end is not
compatible - you won't even get synchronisation between the two ends,
so there's no possibility for passing any data about capabilities.

The idea is that if you have a module that can support 2500BASE-X and
1000BASE-X (such as a fibrechannel SFP) then, rather than being solidly
tied by the kernel to one or other of the speeds, you can request the
kernel use the other speed via ethtool - and switching between the two
requires changing the phy_interface_t setting.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
