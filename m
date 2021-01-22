Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EF3010F3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbhAVXYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:24:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55426 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbhAVXYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:24:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l35m1-002A7o-C0; Sat, 23 Jan 2021 00:23:25 +0100
Date:   Sat, 23 Jan 2021 00:23:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Message-ID: <YAtebdG1Q0dxxkdC@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su>
 <YAtMw5Yk1QYp28rJ@lunn.ch>
 <21783568.4JFRnjC3Rk@metabook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21783568.4JFRnjC3Rk@metabook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
> > > lan743x_adapter *adapter)> 
> > >  	struct net_device *netdev = adapter->netdev;
> > >  	
> > >  	phy_stop(netdev->phydev);
> > > 
> > > -	phy_disconnect(netdev->phydev);
> > > -	netdev->phydev = NULL;
> > > +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> > > +		lan743x_virtual_phy_disconnect(netdev->phydev);
> > > +	else
> > > +		phy_disconnect(netdev->phydev);
> > 
> > phy_disconnect() should work. You might want to call

There are drivers which call phy_disconnect() on a fixed_link. e.g.

https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78xx.c#L3555.

It could be your missing call to fixed_phy_unregister() is leaving
behind bad state.

> It was to make ethtool show full set of supported speeds and MII only in
> supported ports (without TP and the no any ports in the bare card).

But fixed link does not support the full set of speed. It is fixed. It
supports only one speed it is configured with.  And by setting it
wrongly, you are going to allow the user to do odd things, like use
ethtool force the link speed to a speed which is not actually
supported.

    Andrew
