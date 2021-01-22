Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA73B301154
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhAWAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:00:50 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:44190 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbhAVX7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:59:37 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id C058382100;
        Sat, 23 Jan 2021 02:59:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611359944; bh=g6BvVahX0EV1gqwZyMX/H/ev/xf2JWjDorAxoSJhcnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsnKEMH5XFcIgO4Li/k0bPVcBUcLUGtJ1uhOCtVTIbVWeIk/km8Fn2vXkpYLsan65
         SKOUT4Jmp9z2XNidRWHowWMJ2JviY02DhO0w+Wyxeo4b7oKrH+V40chLnU41ljeK7f
         RtloBuOJebPGcdRnppohkEX1Zrqm8EuabScqvSqyIBjYeeadmd9EMVogrgi5+7al0N
         uuxa/FpuehAanKOFNyExwT9IOzuUjTsv2MB74Sa8IzNZe7qPXwoh9cURe+CxKq0ers
         9HhYPyJqYvFUR8mSAJfE7UBLQwanq1xGrOIKM49syWM6GTl0jCB17bM5Q3BuJ9h5Or
         Kh0TnI8JKabug==
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
Date:   Sat, 23 Jan 2021 02:58:12 +0300
Message-ID: <3174210.ndmClRx9B8@metabook>
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
lan743x_virtual_phy_disconnect removes sysfs-links and calls 
fixed_phy_unregister()
and the reason was phydev in sysfs.

> > It was to make ethtool show full set of supported speeds and MII only in
> > supported ports (without TP and the no any ports in the bare card).
> 
> But fixed link does not support the full set of speed. It is fixed. It
> supports only one speed it is configured with.
That's why I "re-implemented the fixed PHY driver" as Florian said.
The goal of virtual phy was to make an illusion of real device working in
loopback mode. So I could use ethtool and ioctl's to switch speed of device.

> And by setting it
> wrongly, you are going to allow the user to do odd things, like use
> ethtool force the link speed to a speed which is not actually
> supported.
I have lan743x only and in loopback mode it allows to use speeds 
10/100/1000MBps
in full-duplex mode only. But the highest speed I have achived was something 
near
752Mbps...
And I can switch speed on the fly, without reloading the module.

May by I should limit the list of acceptable devices?

> 
>     Andrew




