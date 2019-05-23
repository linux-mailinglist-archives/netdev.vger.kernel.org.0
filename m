Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629C228CD2
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfEWWD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:03:27 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48156 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfEWWD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 18:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HQh4P1qtBdimC5UIRuS8cdTFGvH0ynzH0b+jAgn8+NM=; b=bcCefu4N4kZnh+ffWGjprdSIE
        nTMgdXw/SaB0bYfX1ru0w4E/vbXbUrlrceRuSIy3YqSrmcsS/vlSLHTWreMQWl8BZrSMsJxgYTvxT
        eage6hI3mKGSZ8PJobG+wv+4aVl9PmokdZkBLumXfkTfEsrPlgA83ueAPqpW6UWDLehhIuwsp9QxF
        sLfrwzXW0woQcj4VAK0vepkcifxehCPccldWQtw0ebWKVQ2dfWp+8bzdLZXouEeWhR0CYlrKVMsg0
        ZQeoeZZBNrKjxa+JIQcGB3D62BCaIeDbzwCf3Y2dqfOrZN9atCQr0wMm5xu3EwA6XlpxlfFP89aCJ
        arcAf8etg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52612)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hTvnz-0008NP-Op; Thu, 23 May 2019 23:03:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hTvnx-0007uf-7D; Thu, 23 May 2019 23:03:17 +0100
Date:   Thu, 23 May 2019 23:03:17 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: Move the phylink driver calls
 into port.c
Message-ID: <20190523220317.g4k7b3k3edcaxod5@shell.armlinux.org.uk>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-8-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523011958.14944-8-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:20:41AM +0000, Ioana Ciornei wrote:
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index ed8ba9daa3ba..d0f955e8b731 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -422,6 +422,102 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
>  	return phydev;
>  }
>  
> +void dsa_port_phylink_validate(struct dsa_port *dp,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_validate)
> +		return;

No, really not acceptable.  If there's no phylink_validate function,
then simply returning is going to produce what I'd term "unpredictable"
results.  This callback will be called with various modes in
"supported", and if you simply return without any modification,
you're basically saying that you support _anything_ that the supported
mask throws at you.

> +
> +	ds->ops->phylink_validate(ds, dp->index, supported, state);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_validate);
> +
> +int dsa_port_phylink_mac_link_state(struct dsa_port *dp,
> +				    struct phylink_link_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	/* Only called for SGMII and 802.3z */
> +	if (!ds->ops->phylink_mac_link_state)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_mac_link_state);
> +
> +void dsa_port_phylink_mac_config(struct dsa_port *dp,
> +				 unsigned int mode,
> +				 const struct phylink_link_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_mac_config)
> +		return;

If you don't implement this, what's the point?

> +
> +	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_mac_config);
> +
> +void dsa_port_phylink_mac_an_restart(struct dsa_port *dp)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_mac_an_restart)
> +		return;
> +
> +	ds->ops->phylink_mac_an_restart(ds, dp->index);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_mac_an_restart);
> +
> +void dsa_port_phylink_mac_link_down(struct dsa_port *dp,
> +				    unsigned int mode,
> +				    phy_interface_t interface,
> +				    struct phy_device *phydev)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_mac_link_down) {
> +		if (ds->ops->adjust_link && phydev)
> +			ds->ops->adjust_link(ds, dp->index, phydev);
> +		return;
> +	}
> +
> +	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_mac_link_down);
> +
> +void dsa_port_phylink_mac_link_up(struct dsa_port *dp,
> +				  unsigned int mode,
> +				  phy_interface_t interface,
> +				  struct phy_device *phydev)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->phylink_mac_link_up) {
> +		if (ds->ops->adjust_link && phydev)
> +			ds->ops->adjust_link(ds, dp->index, phydev);
> +		return;
> +	}
> +
> +	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_mac_link_up);
> +
> +void dsa_port_phylink_fixed_state(struct dsa_port *dp,
> +				  struct phylink_link_state *state)
> +{
> +	struct dsa_switch *ds = dp->ds;
> +
> +	/* No need to check that this operation is valid, the callback would
> +	 * not be called if it was not.
> +	 */
> +	ds->ops->phylink_fixed_state(ds, dp->index, state);
> +}
> +EXPORT_SYMBOL(dsa_port_phylink_fixed_state);
> +
>  static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
>  {
>  	struct dsa_switch *ds = dp->ds;
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 9892ca1f6859..308066da8a0f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1169,25 +1169,16 @@ static void dsa_slave_phylink_validate(struct net_device *dev,
>  				       struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
> -
> -	if (!ds->ops->phylink_validate)
> -		return;

Ah, this is where it came from - but still wrong for the reasons I
stated above, though it makes it not a bug you're introducing, but
one that pre-exists.

>  
> -	ds->ops->phylink_validate(ds, dp->index, supported, state);
> +	dsa_port_phylink_validate(dp, supported, state);
>  }
>  
>  static int dsa_slave_phylink_mac_link_state(struct net_device *dev,
>  					    struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
> -
> -	/* Only called for SGMII and 802.3z */
> -	if (!ds->ops->phylink_mac_link_state)
> -		return -EOPNOTSUPP;
>  
> -	return ds->ops->phylink_mac_link_state(ds, dp->index, state);
> +	return dsa_port_phylink_mac_link_state(dp, state);
>  }
>  
>  static void dsa_slave_phylink_mac_config(struct net_device *dev,
> @@ -1195,23 +1186,15 @@ static void dsa_slave_phylink_mac_config(struct net_device *dev,
>  					 const struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
> -
> -	if (!ds->ops->phylink_mac_config)
> -		return;
>  
> -	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
> +	dsa_port_phylink_mac_config(dp, mode, state);
>  }
>  
>  static void dsa_slave_phylink_mac_an_restart(struct net_device *dev)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
> -
> -	if (!ds->ops->phylink_mac_an_restart)
> -		return;
>  
> -	ds->ops->phylink_mac_an_restart(ds, dp->index);
> +	dsa_port_phylink_mac_an_restart(dp);
>  }
>  
>  static void dsa_slave_phylink_mac_link_down(struct net_device *dev,
> @@ -1219,15 +1202,8 @@ static void dsa_slave_phylink_mac_link_down(struct net_device *dev,
>  					    phy_interface_t interface)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
> -
> -	if (!ds->ops->phylink_mac_link_down) {
> -		if (ds->ops->adjust_link && dev->phydev)
> -			ds->ops->adjust_link(ds, dp->index, dev->phydev);
> -		return;
> -	}
>  
> -	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
> +	dsa_port_phylink_mac_link_down(dp, mode, interface, dev->phydev);
>  }
>  
>  static void dsa_slave_phylink_mac_link_up(struct net_device *dev,
> @@ -1236,15 +1212,8 @@ static void dsa_slave_phylink_mac_link_up(struct net_device *dev,
>  					  struct phy_device *phydev)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
>  
> -	if (!ds->ops->phylink_mac_link_up) {
> -		if (ds->ops->adjust_link && dev->phydev)
> -			ds->ops->adjust_link(ds, dp->index, dev->phydev);
> -		return;
> -	}
> -
> -	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
> +	dsa_port_phylink_mac_link_up(dp, mode, interface, phydev);
>  }
>  
>  static const struct phylink_mac_ops dsa_slave_phylink_mac_ops = {
> @@ -1268,12 +1237,8 @@ static void dsa_slave_phylink_fixed_state(struct net_device *dev,
>  					  struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	struct dsa_switch *ds = dp->ds;
>  
> -	/* No need to check that this operation is valid, the callback would
> -	 * not be called if it was not.
> -	 */
> -	ds->ops->phylink_fixed_state(ds, dp->index, state);
> +	dsa_port_phylink_fixed_state(dp, state);
>  }
>  
>  /* slave device setup *******************************************************/
> -- 
> 2.21.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
