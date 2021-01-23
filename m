Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E24F3011D3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbhAWBCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:02:47 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:50914 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbhAWBCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:02:23 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id B837982100;
        Sat, 23 Jan 2021 04:01:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611363713; bh=myjVRTj0hYQ3C1Pas3KTHSpLIBYbubJF7/c2yKRmhgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ek7+aYHo6WCklcG1f1doU+ihHWS7uxV+2GDEhfKPu0qFsIPUQHiaCCODChfuTMHdW
         DL/LDl9HmTUIbo3ur/WaVOImDm8+Nl2ASS8pcuf4+MzcUulycV/n51QMWzhCq/TfG6
         AHxKoj0OUx5qgtvr0XGtqDZPzE3S6A7fzUI8MeAbfnz0Vv+N6fyZkQItR7ji1aYEt5
         7OMPwTXdcrOLgvbGe+a3XmpLiitfrNDj0siVtg6Z8DJ1KLLE5wFqRxruzPcwxZMAzz
         CLNnEKMcjpqerxEq29/ENiQ0L1I76EH8NDgQGC0PZ1o7vzWkob9U2ntmNxwz61pmJS
         wBe8u9HYOj65Q==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
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
Date:   Sat, 23 Jan 2021 04:01:01 +0300
Message-ID: <4496952.bab7Homqhv@metabook>
In-Reply-To: <5306ffe6-112c-83c9-826a-9bacd661691b@gmail.com>
References: <20210122214247.6536-1-sbauer@blackbox.su> <3174210.ndmClRx9B8@metabook> <5306ffe6-112c-83c9-826a-9bacd661691b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 3:01:47 AM MSK Florian Fainelli wrote:
> On 1/22/2021 3:58 PM, Sergej Bauer wrote:
> > On Saturday, January 23, 2021 2:23:25 AM MSK Andrew Lunn wrote:
> >>>>> @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
> >>>>> lan743x_adapter *adapter)>
> >>>>> 
> >>>>>  	struct net_device *netdev = adapter->netdev;
> >>>>>  	
> >>>>>  	phy_stop(netdev->phydev);
> >>>>> 
> >>>>> -	phy_disconnect(netdev->phydev);
> >>>>> -	netdev->phydev = NULL;
> >>>>> +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> >>>>> +		lan743x_virtual_phy_disconnect(netdev->phydev);
> >>>>> +	else
> >>>>> +		phy_disconnect(netdev->phydev);
> >>>> 
> >>>> phy_disconnect() should work. You might want to call
> >> 
> >> There are drivers which call phy_disconnect() on a fixed_link. e.g.
> >> 
> >> https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78xx
> >> .c# L3555.
> >> 
> >> 
> >> It could be your missing call to fixed_phy_unregister() is leaving
> >> behind bad state.
> > 
> > lan743x_virtual_phy_disconnect removes sysfs-links and calls
> > fixed_phy_unregister()
> > and the reason was phydev in sysfs.
> > 
> >>> It was to make ethtool show full set of supported speeds and MII only in
> >>> supported ports (without TP and the no any ports in the bare card).
> >> 
> >> But fixed link does not support the full set of speed. It is fixed. It
> >> supports only one speed it is configured with.
> > 
> > That's why I "re-implemented the fixed PHY driver" as Florian said.
> > The goal of virtual phy was to make an illusion of real device working in
> > loopback mode. So I could use ethtool and ioctl's to switch speed of
> > device.> 
> >> And by setting it
> >> wrongly, you are going to allow the user to do odd things, like use
> >> ethtool force the link speed to a speed which is not actually
> >> supported.
> > 
> > I have lan743x only and in loopback mode it allows to use speeds
> > 10/100/1000MBps
> > in full-duplex mode only. But the highest speed I have achived was
> > something near
> > 752Mbps...
> > And I can switch speed on the fly, without reloading the module.
> > 
> > May by I should limit the list of acceptable devices?
> 
> It is not clear what your use case is so maybe start with explaining it
> and we can help you define something that may be acceptable for upstream
> inclusion.
it migth be helpful for developers work on userspace networking tools with
PHY-less lan743x (the interface even could not be brought up)
of course, there nothing much to do without TP port but the difference is
representative.

sbauer@metamini ~$ sudo ethtool eth7
Settings for eth7:
Cannot get device settings: No such device
        Supports Wake-on: pumbag
        Wake-on: d
        Current message level: 0x00000137 (311)
                               drv probe link ifdown ifup tx_queued
        Link detected: no
sbauer@metamini ~$ sudo ifup eth7
sbauer@metamini ~$ sudo ethtool eth7
Settings for eth7:
        Supported ports: [ MII ]
        Supported link modes:   10baseT/Full 
                                100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Full 
                                100baseT/Full 
                                1000baseT/Full 
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pumbag
        Wake-on: d
        Current message level: 0x00000137 (311)
                               drv probe link ifdown ifup tx_queued
        Link detected: yes
sbauer@metamini ~$ sudo mii-tool -vv eth7
Using SIOCGMIIPHY=0x8947
eth7: negotiated 1000baseT-FD, link ok
  registers for MII PHY 0: 
    5140 512d 7431 0011 4140 4140 000d 0000
    0000 0200 7800 0000 0000 0000 0000 2000
    0000 0000 0000 0000 0000 0000 0000 0000
    0000 0000 0000 0000 0000 0000 0000 0000
  product info: vendor 1d:0c:40, model 1 rev 1
  basic mode:   loopback, autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 10baseT-FD
  advertising:  1000baseT-FD 100baseTx-FD 10baseT-FD
  link partner: 1000baseT-FD 100baseTx-FD 10baseT-FD

							   Regards,
							       Sergej.



