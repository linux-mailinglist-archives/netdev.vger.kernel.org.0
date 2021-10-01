Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C241EBF3
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353652AbhJALcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhJALco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D430361A8B;
        Fri,  1 Oct 2021 11:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633087860;
        bh=UUfgjmNnIaOorGRnXAAQNArA0PVP/iZMbNdl/f8qZ1U=;
        h=Date:From:To:Cc:Subject:From;
        b=j0ixoeRiZyjLgnDCCU4qEp5S1hRrE5KipwyTE9UaOedn6JNzooA4SZ84I0Iy04WRd
         8wpCW8vnIuodqxbpjlvnjMLT6DxTc3gpMy7YlyfIpaRkGbkKqiuMoaG0S9WWE0ypm6
         Sj5nh4wupTP/kZrTzeen1dCznz0rJg5TuZUoplabaByqVeJBnMMQhpJ+do0VkMvmOJ
         TRS2y57WaHpqa3rMRDuvV/CL5w+hhPlA3kxkdWS3batrWm0878Q2MvxQR+2C8JVmHC
         zPAF8Lh6jvyXJMbmKXV91+T2+RMLiaE2JMNoHjyFsU9lcDvftub7s8gRUWqMnODn0e
         EyydpvoFEwGQQ==
Date:   Fri, 1 Oct 2021 13:30:57 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: devicename part of LEDs under ethernet MAC / PHY
Message-ID: <20211001133057.5287f150@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel, Andrew,

previously we discussed devicename part of LEDs connected under
ethernet MACs and/or ethrenet PHYs.

I would like to finally settle this, but there is one more thing that
may be problematic.

To remind the current proposal, discussed in previous e-mails:

- for LEDs under an ethernet PHY, the devicename part of the LED should
  be "ethphyN", with N an auto-incrementing number for each struct
  phy_device
- for LEDs under an ethernet MAC, it should be similar: "ethmacN"

- the numbers in ethmac and ethphy are unrelated and cannot be related

- Andrew proposed that the numbering should start at non-zero number,
  for example at 42, to prevent people from thinking that the numbers
  are related to numbers in network interface names (ethN).
  A system with interfaces
    eth0
    eth1
  and LEDs
    ethphy0:green:link
    ethphy1:green:link
  may make user think that the ethphy0 LED does correspond to eth0
  interface, which is not necessarily true.
  Instead if LEDs are
    ethphy42:green:link
    ethphy43:green:link 
  the probability of confusing the user into relating them to network
  interfaces by these numbers is lower.

Anyway, the issue with these naming is that it is not stable. Upgrading
the kernel, enabling drivers and so on can change these names between
reboots. Also for LEDs on USB ethernet adapters, removing the USB and
plugging it again would change the name, although the device path does
not change if the adapter is re-plugged into the same port.

To finally settle this then, I would like to ask your opinion on
whether this naming of LEDs should be stable.

Note that this names are visible to userspace as symlinks
/sys/class/leds directory. If they are unstable, it is not that big an
issue, because mostly these LEDs should be accessed via
/sys/class/net/<interface>/device/leds for eth MAC LEDs and via
/sys/class/net/<interface>/phydev/leds for eth PHY LEDs.

If we wanted to make these names stable, we would need to do something
like
  ethphy-BUS-ID
for example
  ethphy-usb3,2
  ethmac-pci0,19,0
  ethphy-mdio0,1
or
  ethmac-DEVICE_PATH (with '/'s and ':'s replaced with ',' or something)
for example
  ethphy-platform,soc,soc,internal-regs,f10f0000.usb3,usb3,3-0,1:0

The first scheme is nicer but would need some additional code for each
bus.
The second scheme is simpler to implement, but the naming is hideous -
the whole point of devicename part of LEDs was (in my understanding) to
be a nice name, like "mmc0".

Marek
