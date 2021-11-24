Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE045D11E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344691AbhKXX2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344629AbhKXX2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 18:28:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4D2C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 15:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wnx7xxSfdnh0nHwsubd6pLSvp5hoagJ5YNKSsCpqbVs=; b=cwZYc2N0Lre91chA5cFBQHWbg3
        TKPXPzoZxOWuaSeL7uI5JzFKVKab+qCMWnNmOHbxFns4m1htd30PkHidEHstJfrpgxo2X7CSMddYd
        APz0QqXRPr1ZQEds0tAp/80pEzIBDqeSKLYqkdDyMLr/wJMY2ax/liAhoIqevlTXoQPACg1pZ7Wjt
        vq2p0XTT6Een5pgI8+HBR9XDEZVd22cdQHMRe0+64ND66r7GT/iLtazD9T7bpvy2yn3H+4Dob7afy
        3ic2xetvXtHrA4SdRopQMd12Jcl4+4U5O1yFawrbdG4aGRjV1s28tf6JijHKTH7d4MzYS6oNH2WKs
        cJm0Nq6Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55880)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mq1de-0001Jo-L9; Wed, 24 Nov 2021 23:25:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mq1dd-0001bp-Su; Wed, 24 Nov 2021 23:25:17 +0000
Date:   Wed, 24 Nov 2021 23:25:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 01/12] net: dsa: consolidate phylink creation
Message-ID: <YZ7J3fGZmGMX8lYg@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRY-00D8Kw-6S@rmk-PC.armlinux.org.uk>
 <20211124181156.5g3z2inlaai5lcvd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124181156.5g3z2inlaai5lcvd@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 06:11:57PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 05:52:28PM +0000, Russell King (Oracle) wrote:
> > The code in port.c and slave.c creating the phylink instance is very
> > similar - let's consolidate this into a single function.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  net/dsa/dsa_priv.h |  2 +-
> >  net/dsa/port.c     | 44 ++++++++++++++++++++++++++++----------------
> >  net/dsa/slave.c    | 19 +++----------------
> >  3 files changed, 32 insertions(+), 33 deletions(-)
> > 
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index a5c9bc7b66c6..3fb2c37c9b88 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -258,13 +258,13 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
> >  			       const struct switchdev_obj_ring_role_mrp *mrp);
> >  int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
> >  			       const struct switchdev_obj_ring_role_mrp *mrp);
> > +int dsa_port_phylink_create(struct dsa_port *dp);
> >  int dsa_port_link_register_of(struct dsa_port *dp);
> >  void dsa_port_link_unregister_of(struct dsa_port *dp);
> >  int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
> >  void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
> >  int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
> >  void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
> > -extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
> >  
> >  static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
> >  						 const struct net_device *dev)
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index f6f12ad2b525..eaa66114924b 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -1072,7 +1072,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> >  				     speed, duplex, tx_pause, rx_pause);
> >  }
> >  
> > -const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> > +static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> >  	.validate = dsa_port_phylink_validate,
> >  	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
> >  	.mac_config = dsa_port_phylink_mac_config,
> > @@ -1081,6 +1081,30 @@ const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> >  	.mac_link_up = dsa_port_phylink_mac_link_up,
> >  };
> >  
> > +int dsa_port_phylink_create(struct dsa_port *dp)
> > +{
> > +	struct dsa_switch *ds = dp->ds;
> > +	phy_interface_t mode;
> > +	int err;
> > +
> > +	err = of_get_phy_mode(dp->dn, &mode);
> > +	if (err)
> > +		mode = PHY_INTERFACE_MODE_NA;
> > +
> > +	if (ds->ops->phylink_get_interfaces)
> > +		ds->ops->phylink_get_interfaces(ds, dp->index,
> > +					dp->pl_config.supported_interfaces);
> 
> Can you please save dp->pl_config to a struct phylink_config *config
> temporary variable, and pass that here and to phylink_create() while
> preserving the alignment of that argument to the open brace? Thanks.

There is no point; first, this is how the original code was formatted
that is moved here, and second, this code is deleted in patch 3.
Making it a local variable, and then deleting it in patch 3 is pointless
churn.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
