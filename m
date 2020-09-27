Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB4279D2C
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgI0A3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:29:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgI0A3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:29:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMKZL-00GKmw-0e; Sun, 27 Sep 2020 02:29:35 +0200
Date:   Sun, 27 Sep 2020 02:29:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev <netdev@vger.kernel.org>, linux-leds@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200927002935.GA3889809@lunn.ch>
References: <20200927004025.33c6cfce@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927004025.33c6cfce@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 12:40:25AM +0200, Marek Behun wrote:
> Hi,
> 
> linux-leds is trying to create a consistent naming mechanism for LEDs
> The schema is:
>   device:color:function
> for example
>   system:green:power
>   keyboard0:green:capslock
> 
> But we are not there yet.
> 
> LEDs are often dedicated to specific function by manufacturers, for
> example there can be an icon or a text next to the LED on the case of a
> router, indicating that the LED should blink on activity on a specific
> ethernet port.
> 
> This can be specified in device tree via the trigger-sources property.
> 
> We therefore want to select the device part of the LED name to
> correspond to the device it should trigger to according to the
> manufacturer.
> 
> What I am wondering is how should we select a name for the device part
> of the LED for network devices, when network namespaces are enabled.
> 
> a) We could just use the interface name (eth0:yellow:activity). The
>    problem is what should happen when the interface is renamed, or
>    moved to another network namespace.
>    Pavel doesn't want to complicate the LED subsystem with LED device
>    renaming, nor, I think, with namespace mechanism. I, for my part, am
>    not opposed to LED renaming, but do not know what should happen when
>    the interface is moved to another namespace.
> 
> b) We could use the device name, as in struct device *. But these names
>    are often too long and may contain characters that we do not want in
>    LED name (':', or '/', for example).
> 
> c) We could create a new naming mechanism, something like
>    device_pretty_name(dev), which some classes may implement somehow.
> 
> What are your ideas about this problem?

I lost track of where these file will appear. I was surprised with the
location in the first proposal

Looking at one of my systems we have:

ls -l /sys/class/net/eth0/
total 0
-r--r--r-- 1 root root 4096 Sep 26 14:34 addr_assign_type
-r--r--r-- 1 root root 4096 Sep 26 14:34 address
-r--r--r-- 1 root root 4096 Sep 26 19:06 addr_len
-r--r--r-- 1 root root 4096 Sep 26 19:06 broadcast
...
phydev -> ../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00
...

Will the LED class directory appear as a subdirectory of
/sys/class/net/eth0/, or a subdirectory of
../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00 or in
/sys/class/leds?

If they are in /sys/class/led, the name needs to be globally
unique. That rules out using the interface name, which is not globally
unique, it is only netns unique.

If they are inside /sys/class/net/eth0, we don't need to worry about
the name, we know which interface they belong to simply from the
parent directory. We can then use "phy:yellow:activity".

The same applies for
"../../mdio_bus/400d0000.ethernet-1/400d0000.ethernet-1:00". The user
can follow the symlink from /sys/class/net/eth0 to the phy directory
to find the LEDs for a PHY.

   Andrew
