Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C81C279D36
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgI0Ap0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgI0ApZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 20:45:25 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCF2C0613CE;
        Sat, 26 Sep 2020 17:45:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id BA6FA1407BC;
        Sun, 27 Sep 2020 02:45:22 +0200 (CEST)
Date:   Sun, 27 Sep 2020 02:45:22 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, linux-leds@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200927024522.06df813f@nic.cz>
In-Reply-To: <20200927002935.GA3889809@lunn.ch>
References: <20200927004025.33c6cfce@nic.cz>
        <20200927002935.GA3889809@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Sep 2020 02:29:35 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Sep 27, 2020 at 12:40:25AM +0200, Marek Behun wrote:
> > Hi,
> > 
> > linux-leds is trying to create a consistent naming mechanism for LEDs
> > The schema is:
> >   device:color:function
> > for example
> >   system:green:power
> >   keyboard0:green:capslock
> > 
> > But we are not there yet.
> > 
> > LEDs are often dedicated to specific function by manufacturers, for
> > example there can be an icon or a text next to the LED on the case of a
> > router, indicating that the LED should blink on activity on a specific
> > ethernet port.
> > 
> > This can be specified in device tree via the trigger-sources property.
> > 
> > We therefore want to select the device part of the LED name to
> > correspond to the device it should trigger to according to the
> > manufacturer.
> > 
> > What I am wondering is how should we select a name for the device part
> > of the LED for network devices, when network namespaces are enabled.
> > 
> > a) We could just use the interface name (eth0:yellow:activity). The
> >    problem is what should happen when the interface is renamed, or
> >    moved to another network namespace.
> >    Pavel doesn't want to complicate the LED subsystem with LED device
> >    renaming, nor, I think, with namespace mechanism. I, for my part, am
> >    not opposed to LED renaming, but do not know what should happen when
> >    the interface is moved to another namespace.
> > 
> > b) We could use the device name, as in struct device *. But these names
> >    are often too long and may contain characters that we do not want in
> >    LED name (':', or '/', for example).
> > 
> > c) We could create a new naming mechanism, something like
> >    device_pretty_name(dev), which some classes may implement somehow.
> > 
> > What are your ideas about this problem?  
> 
> I lost track of where these file will appear. I was surprised with the
> location in the first proposal
> 
> Looking at one of my systems we have:
> 
> ls -l /sys/class/net/eth0/
> total 0
> -r--r--r-- 1 root root 4096 Sep 26 14:34 addr_assign_type
> -r--r--r-- 1 root root 4096 Sep 26 14:34 address
> -r--r--r-- 1 root root 4096 Sep 26 19:06 addr_len
> -r--r--r-- 1 root root 4096 Sep 26 19:06 broadcast
> ...
> phydev -> ../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00
> ...
> 
> Will the LED class directory appear as a subdirectory of
> /sys/class/net/eth0/, or a subdirectory of
> ../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00 or in
> /sys/class/leds?
> 
> If they are in /sys/class/led, the name needs to be globally
> unique. That rules out using the interface name, which is not globally
> unique, it is only netns unique.
> 
> If they are inside /sys/class/net/eth0, we don't need to worry about
> the name, we know which interface they belong to simply from the
> parent directory. We can then use "phy:yellow:activity".
> 
> The same applies for
> "../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00". The user
> can follow the symlink from /sys/class/net/eth0 to the phy directory
> to find the LEDs for a PHY.
> 
>    Andrew

Andrew,

the directory is always, for every device in kernel, in /sys/devices
somewhere, in hierarchy corresponding to dev->parent pointers.
Everything else is via symlink.

/sys/class/net/eth0 is a symlink to something in /sys/devices somewhere.

/sys/class/net/eth0/phydev is a symlink to phydev in /sys/devices
somewhere.

If the phydev has children devices of class "leds", then its directory
will contian "leds" subdirectory, and this "leds" subdirectory will
contain subdirectories corresponding to each LED registered under the
phydev.

So I will have
  /sys/class/net/eth0/phydev/leds/eth0:green:activity
                 |        |
                 symlink  |
                          |
                        symlink

and I will also have
  /sys/class/leds/eth0:green:activity
                  |
                  symlink

For every X in /sys/class/*/X, X is symlink to something in
/sys/devices.

Even bridge devices are symlinks:

kabel@thinkpad ~ $ ls -l /sys/class/net/br0
lrwxrwxrwx 1 root root 0 Sep 20 14:41 /sys/class/net/br0 -> ../../devices/virtual/net/br0

Marek
