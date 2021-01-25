Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2C304ADF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbhAZE4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:56:15 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:38350 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbhAYKYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 05:24:49 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 1436D82100;
        Mon, 25 Jan 2021 13:24:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611570260; bh=OIH8jJvJj4R+44q6v+7DHOVKderUN4HFIOEk+xnmAO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9czO7zOFEKQUIArb/pVy2Px03p232ZckGiAWzPcBQXEeuf5dUwbp+Q+lSMPtj1UK
         7LzVJ0//OEsLOmAkQ03nEB0jE14UVhjziBwqv4Wn40oTy1Dvue0wP4+yOM/C8dZgjk
         NLcOjy7LArtgb4xrwBaEnxWc56Wrx65t0+zdfN8RZLzQ49wGmvwuHLKzYvTrU0KOFb
         luU2yM1wkV/VWla+DQ+KfD/r06hrGjw7mOSZA4ZpXlhV0MWYD0qwnXSWySNRYdxegL
         yqlvG9CCKUM/FHxmNZxSYhZ8404MLNqf1tOPWFirA30rbMrIMKhvVuaIH83Ej9oC/X
         VqeaXk1++Abhg==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
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
Date:   Mon, 25 Jan 2021 13:23:25 +0300
Message-ID: <2014021.cZaaFtpcjn@metabook>
In-Reply-To: <YAtebdG1Q0dxxkdC@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su> <21783568.4JFRnjC3Rk@metabook> <YAtebdG1Q0dxxkdC@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 2:23:25 AM MSK Andrew Lunn wrote:
> > > > @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
> > > > lan743x_adapter *adapter)>
> > > > 
> > > >  	struct net_device *netdev = adapter->netdev;
> > > >  	
> > > >  	phy_stop(netdev->phydev);
> > > > 
> > > > -	phy_disconnect(netdev->phydev);
> > > > -	netdev->phydev = NULL;
> > > > +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> > > > +		lan743x_virtual_phy_disconnect(netdev->phydev);
> > > > +	else
> > > > +		phy_disconnect(netdev->phydev);
> > > 
> > > phy_disconnect() should work. You might want to call
> 
> There are drivers which call phy_disconnect() on a fixed_link. e.g.
> 
> https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78xx.c#
> L3555.
> 
> It could be your missing call to fixed_phy_unregister() is leaving
> behind bad state.
> 
fixed_phy_unregister() were inside of lan743x_virtual_phy_disconnect()

> > It was to make ethtool show full set of supported speeds and MII only in
> > supported ports (without TP and the no any ports in the bare card).
> 
> But fixed link does not support the full set of speed. It is fixed. It
> supports only one speed it is configured with.  And by setting it
> wrongly, you are going to allow the user to do odd things, like use
> ethtool force the link speed to a speed which is not actually
> supported.
when writing virtual phy i have used "Microchip AN2948 Configuration Registers
of LAN743x" document and the lan743x is designed only for LAN7430 either
LAN7431 as it pointed in the document and in lan743x_pcidev_tbl. which both
support speeds 10/100/1000 Mbps.


-- 
                                Regards,
                                    Sergej.




