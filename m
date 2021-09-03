Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226B7400405
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhICRWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:22:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhICRWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 13:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=yXfaRWVvHoCmdJzLZVNuqDaV0Ec4KTad1XigEwbGnGY=; b=cA
        HeJeE3AU4CZHkK4ITo0fPb4nKcouTJuSQuLCGCKwdnpgDOaSHIrEESj0J40KSgek0Ghz7P/2LO5vO
        f7wr4qRbAaeLI2BiPGHtc9KjK2FfM0sBuAwcR//Z1GLK/LTIvpO0/CJM7InjKm4jf2zI1bME6Yel2
        WwaZdJv/YLln5Cw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mMCsR-0059kK-Gy; Fri, 03 Sep 2021 19:21:19 +0200
Date:   Fri, 3 Sep 2021 19:21:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <YTJZj/Js+nmDTG0y@lunn.ch>
References: <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210903162253.5utsa45zy6h4v76t@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:22:53PM +0300, Vladimir Oltean wrote:
> [ trimming the CC list, I'm sure most people don't care, if they do,
>   they can watch the mailing list ]
> 
> On Thu, Sep 02, 2021 at 09:29:05PM +0100, Russell King (Oracle) wrote:
> > On Thu, Sep 02, 2021 at 11:21:24PM +0300, Vladimir Oltean wrote:
> > > On Thu, Sep 02, 2021 at 09:03:01PM +0100, Russell King (Oracle) wrote:
> > > > # systemctl list-dependencies networking.service
> > > > networking.service
> > > >   ├─ifupdown-pre.service
> > > >   ├─system.slice
> > > >   └─network.target
> > > > # systemctl list-dependencies ifupdown-pre.service
> > > > ifupdown-pre.service
> > > >   ├─system.slice
> > > >   └─systemd-udevd.service
> > > > 
> > > > Looking in the service files for a better idea:
> > > > 
> > > > networking.service:
> > > > Requires=ifupdown-pre.service
> > > > Wants=network.target
> > > > After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
> > > > Before=network.target shutdown.target network-online.target
> > > > 
> > > > ifupdown-pre.service:
> > > > Wants=systemd-udevd.service
> > > > After=systemd-udev-trigger.service
> > > > Before=network.target
> > > > 
> > > > So, the dependency you mention is already present. As is a dependency
> > > > on udev. The problem is udev does all the automatic module loading
> > > > asynchronously and in a multithreaded way.
> > > > 
> > > > I don't think there's a way to make systemd wait for all module loads
> > > > to complete.
> > > 
> > > So ifupdown-pre.service has a call to "udevadm settle". This "watches
> > > the udev event queue, and exits if all current events are handled",
> > > according to the man page. But which current events? ifupdown-pre.service
> > > does not have the dependency on systemd-modules-load.service, just
> > > networking.service does. So maybe ifupdown-pre.service does not wait for
> > > DSA to finish initializing, then it tells networking.service that all is ok.
> > 
> > ifupdown-pre.service does have a call to udevadm settle, and that
> > does get called from what I can tell.
> > 
> > systemd-modules-load.service is an entire red herring. The only
> > module listed in the various modules-load.d directories is "tun"
> > for openvpn (which isn't currently being used.)
> > 
> > As I've already told you (and you seem to have ignored), DSA gets
> > loaded by udev, not by systemd-modules-load.service.
> > systemd-modules-load.service is irrelevant to my situation.
> > 
> > I think there's a problem with "and exits if all current events are
> > handled" - does that mean it's fired off a modprobe process which
> > is in progress, or does that mean that the modprobe process has
> > completed.
> > 
> > Given that we can see that ifup is being run while the DSA module is
> > still in the middle of probing, the latter interpretation can not be
> > true - unless systemd is ignoring the dependencies. Or just in
> > general, systemd being systemd (I have very little faith in systemd
> > behaving as it should.)
> 
> So I've set a fresh installation of Debian Buster on my Turris MOX,
> which has 3 mv88e6xxx switches, and I've put the mv88e6xxx driver inside
> the rootfs as a module to be loaded by udev based on modaliases just
> like you've said.  Additionally, the PHY driver is also a module.
> The kernel is built straight from the v5.13 tag, absolutely no changes.
> 
> Literally the only changes I've done to this system are:
> 1. install bridge-utils
> 2. create this file, it is sourced by /etc/network/interfaces:
> root@debian:~# cat /etc/network/interfaces.d/bridge
> auto br0
> iface br0 inet manual
>         bridge_ports lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8 lan9 lan10 lan11 lan12 lan13 lan14 lan15 lan16 lan17 lan18 lan19 lan20 lan21 lan22 lan23 lan24 sfp
>         bridge_maxwait 0

Hi Russell

Do you have

auto brdsl

in your /etc/network/interfaces?

Looking at /lib/udev/bridge-network-interface it seems it will only do
hotplug of interfaces if auto is set on the bridge interface. Without
auto, it only does coldplug. So late appearing switch ports won't get
added.

      Andrew
