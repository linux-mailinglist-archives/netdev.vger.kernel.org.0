Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2523A174822
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 17:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgB2Qpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 11:45:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45700 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgB2Qpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 11:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dYvqr7PGEb9BcOmrQ8eKzeKgjbq/O6op4uxMiLRpI78=; b=U70bY8R3yB/19MtmGjVTpe2Mb
        BhHeTOCNeaxhPEO2Y0ouMepkCxjmdOS5b3xU2ItLCEVYPBQ7OZpanTpDd8Z755+2qZHJKjpedeOt3
        y+LPYMjxut4/+ZX3zU2/RV/+IJE0n94oxqwJrM9tYVi22Du85vVzQSPIVGik4Y+qnjZckKhXv+fkv
        cxXjjDebGKTzysavXfGTDCJZaIbA6iqM7nrlvB4b7J2tbrrffkip1yojT3wn211E9gXFRTAwTTmqg
        yFahXCdiinQwSRhUFxyOviPi+kxERj5/hZYV7YGOwzJYDXQHKR7MihGWX/f+yPMh0Dk8pz/5vlCWZ
        lk7yxoEpQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:46920)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j85FG-0002Y9-Cy; Sat, 29 Feb 2020 16:45:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j85FD-00037W-3P; Sat, 29 Feb 2020 16:45:39 +0000
Date:   Sat, 29 Feb 2020 16:45:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix phylink_start()/phylink_stop() calls
Message-ID: <20200229164538.GB25745@shell.armlinux.org.uk>
References: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
 <20200229154215.GD6305@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229154215.GD6305@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 04:42:15PM +0100, Andrew Lunn wrote:
> > -int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
> > +int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy)
> >  {
> >  	struct dsa_switch *ds = dp->ds;
> >  	int port = dp->index;
> >  	int err;
> >  
> > +	if (dp->pl)
> > +		phylink_start(dp->pl);
> > +
> >  	if (ds->ops->port_enable) {
> >  		err = ds->ops->port_enable(ds, port, phy);
> >  		if (err)
> > @@ -81,7 +84,18 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
> >  	return 0;
> >  }
> 
> Hi Russell
> 
> I'm wondering about the order here. You are starting phylink before
> the port is actually enabled in the hardware. Could phylink_start()
> result in synchronous calls into the MAC to configure the port?

Yes, that's possible.

> If the port is disabled, maybe that configuration will not stick?

No idea...

> The current code in dsa_slave_open() first enables the port, then
> calls phylink_start(). So maybe we should keep the ordering the same?

However, dsa_port_setup() does it in the reverse order, so it was a
bit of guess work which is right.  So, if the port needs to be enabled
first, then the dsa_port_setup() path for DSA and CPU ports is wrong.

It's not clear what dsa_port_enable() actually does, and should a port
be enabled before its interface mode and link parameters have been
set?

> > +void dsa_port_disable_locked(struct dsa_port *dp)
> >  {
> >  	struct dsa_switch *ds = dp->ds;
> >  	int port = dp->index;
> > @@ -91,6 +105,16 @@ void dsa_port_disable(struct dsa_port *dp)
> >  
> >  	if (ds->ops->port_disable)
> >  		ds->ops->port_disable(ds, port);
> > +
> > +	if (dp->pl)
> > +		phylink_stop(dp->pl);
> > +}
> 
> The current code first stops phylink, then disables the port...

It depends what order is the correct one, which depends on what
port_disable() does vs phylink_stop(), and whether the network
queues should be stopped before or after port_disable().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
