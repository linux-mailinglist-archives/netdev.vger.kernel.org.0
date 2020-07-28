Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920FD230D03
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgG1PFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:05:35 -0400
Received: from mail.nic.cz ([217.31.204.67]:44782 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbgG1PFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:05:35 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 5265013FCD6;
        Tue, 28 Jul 2020 17:05:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1595948732; bh=kzVqBbIS6DtL5EmGEiQ33EnuCsVpzAnrrTPvwFA1C0s=;
        h=From:To:Date;
        b=AiEK8xKa6LXajRuPNS6B7WOy58rfYdRs6AN1IbJjU+qr/1D4u4el2lyMEYQdrc48u
         WhjpUhaEVF+3qX8ReFywkIBNmQuXPf6LgU90rxlZlvoLbO1+RyTWAlgsTtQCzN/jcy
         wG5KKhOeOltVEy/V9XTRiFv7TyAK5nDKPaBWY3dE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on Marvell PHYs
Date:   Tue, 28 Jul 2020 17:05:28 +0200
Message-Id: <20200728150530.28827-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this is v4 of my RFC adding support for LEDs connected to Marvell PHYs.

Please note that if you want to test this, you still need to first apply
the patch adding the LED private triggers support from Pavel's tree.
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds.git/commit/?h=for-next&id=93690cdf3060c61dfce813121d0bfc055e7fa30d

What I still don't like about this is that the LEDs created by the code
don't properly support device names. LEDs should have name in format
"device:color:function", for example "eth0:green:activity".

The code currently looks for attached netdev for a given PHY, but
at the time this happens there is no netdev attached, so the LEDs gets
names without the device part (ie ":green:activity").

This can be addressed in next version by renaming the LED when a netdev
is attached to the PHY, but first a API for LED device renaming needs to
be proposed. I am going to try to do that. This would also solve the
same problem when userspace renames an interface.

And no, I don't want phydev name there.

Changes since v3:
- addressed some of Andrew's suggestions
- phy_hw_led_mode.c renamed to phy_led.c
- the DT reading code is now also generic, moved to phy_led.c and called
  from phy_probe
- the function registering the phydev-hw-mode trigger is now called from
  phy_device.c function phy_init before registering genphy drivers
- PHY LED functionality now depends on CONFIG_LEDS_TRIGGERS

Changes since v2:
- to share code with other drivers which may want to also offer PHY HW
  control of LEDs some of the code was refactored and now resides in
  phy_hw_led_mode.c. This code is compiled in when config option
  LED_TRIGGER_PHY_HW is enabled. Drivers wanting to offer PHY HW control
  of LEDs should depend on this option.
- the "hw-control" trigger is renamed to "phydev-hw-mode" and is
  registered by the code in phy_hw_led_mode.c
- the "hw_control" sysfs file is renamed to "hw_mode"
- struct phy_driver is extended by three methods to support PHY HW LED
  control
- I renamed the various HW control modes offeret by Marvell PHYs to
  conform to other Linux mode names, for example the "1000/100/10/else"
  mode was renamed to "1Gbps/100Mbps/10Mbps", or "recv/else" was renamed
  to "rx" (this is the name of the mode in netdev trigger).

Marek


Marek Behún (2):
  net: phy: add API for LEDs controlled by PHY HW
  net: phy: marvell: add support for PHY LEDs via LED class

 drivers/net/phy/Kconfig      |   4 +
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/marvell.c    | 287 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |  25 ++-
 drivers/net/phy/phy_led.c    | 176 +++++++++++++++++++++
 include/linux/phy.h          |  51 +++++++
 6 files changed, 537 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/phy/phy_led.c

-- 
2.26.2

