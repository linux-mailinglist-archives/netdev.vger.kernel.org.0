Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850312638DE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIIWLz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 18:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIWLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 18:11:54 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67598C061573;
        Wed,  9 Sep 2020 15:11:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 97B13140A5E;
        Thu, 10 Sep 2020 00:11:52 +0200 (CEST)
Date:   Thu, 10 Sep 2020 00:11:52 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next + leds v2 0/7] PLEASE REVIEW: Add support for
 LEDs on Marvell PHYs
Message-ID: <20200910001152.34de9a2d@nic.cz>
In-Reply-To: <20200909214259.GL3290129@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909214259.GL3290129@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 23:42:59 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Sep 09, 2020 at 06:25:45PM +0200, Marek Behún wrote:
> > Hello Andrew and Pavel,
> > 
> > please review these patches adding support for HW controlled LEDs.
> > The main difference from previous version is that the API is now generalized
> > and lives in drivers/leds, so that part needs to be reviewed (and maybe even
> > applied) by Pavel.
> > 
> > As discussed previously between you two, I made it so that the devicename
> > part of the LED is now in the form `ethernet-phy%i` when the LED is probed
> > for an ethernet PHY. Userspace utility wanting to control LEDs for a specific
> > network interface can access them via /sys/class/net/eth0/phydev/leds:
> > 
> >   mox ~ # ls /sys/class/net/eth0/phydev/leds  
> 
> It is nice they are directly in /sys/class/net/eth0/phydev. Do they
> also appear in /sys/class/led?

They are in /sys/class/net/eth0/phydev/leds by default, because they
are children of the PHY device and are of `leds` class, and the PHY
subsystem creates a symlink `phydev` when PHY is attached to the
interface.
They are in /sys/class/leds/ as symlinks, because AFAIK everything in
/sys/class/<CLASS>/ is a symlink...

> Have you played with network namespaces? What happens with
> 
> ip netns add ns1
> 
> ip link set eth0 netns ns1
> 
>    Andrew

If you move eth0 to other network namespace, naturally the
/sys/class/net/eth0 symlink will disappear, as will the directory it
pointed to.

The symlink phydev does will disappear from /sys/class/net/eth0/
directory after eth0 is moved to ns1, and is lost. It does not return
even if eth0 is moved back to root namespace.

The LED will of course stay in ns1 and also in root namespace, as will
the phydev the LED is a child to. But they are no longer accessible via
/sys/class/net/eth0, instead you can access the LEDs either via
/sys/class/leds or /sys/class/mdio_bus/<MDIO_BUS>/<PHY>/leds, or
without symlinks via /sys/devices/ tree.

Marek
