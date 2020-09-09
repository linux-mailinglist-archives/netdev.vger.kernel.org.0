Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB82631D0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgIIQ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:27:41 -0400
Received: from lists.nic.cz ([217.31.204.67]:34602 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731047AbgIIQ0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:26:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 8AA9E140A42;
        Wed,  9 Sep 2020 18:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668754; bh=Byqhpkt88AGMr7fbJQ6x5kqirnMwwK568K6GogkECRY=;
        h=From:To:Date;
        b=kJ2MEVTPZ3gj1RWjziMeqw89exEkd7fW7wELHVUdD53018wV1xLWpTAS0Od/BbWxU
         KVslhDJqPz+EA5luY2kIRBT+d0pqLy3WX0mS8+gzeT3wQmspUK0xXkZCn9fr6pe2kE
         xU1DsH4OFKUSc303J/M0KnafEFih6wYzLjDVUCyU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next + leds v2 0/7] PLEASE REVIEW: Add support for LEDs on Marvell PHYs
Date:   Wed,  9 Sep 2020 18:25:45 +0200
Message-Id: <20200909162552.11032-1-marek.behun@nic.cz>
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

Hello Andrew and Pavel,

please review these patches adding support for HW controlled LEDs.
The main difference from previous version is that the API is now generalized
and lives in drivers/leds, so that part needs to be reviewed (and maybe even
applied) by Pavel.

As discussed previously between you two, I made it so that the devicename
part of the LED is now in the form `ethernet-phy%i` when the LED is probed
for an ethernet PHY. Userspace utility wanting to control LEDs for a specific
network interface can access them via /sys/class/net/eth0/phydev/leds:

  mox ~ # ls /sys/class/net/eth0/phydev/leds
  ethernet-phy0:green:status  ethernet-phy0:yellow:activity

  mox ~ # ls /sys/class/net/eth0/phydev/leds/ethernet-phy0:green:status
  brightness  device  hw_mode  max_brightness  power  subsystem  trigger  uevent

  mox ~ # cat /sys/class/net/eth0/phydev/leds/ethernet-phy0:green:status/trigger
  none [dev-hw-mode] timer oneshot heartbeat default-on mmc0 mmc1

  mox ~ # cat /sys/class/net/eth0/phydev/leds/ethernet-phy0:green:status/hw_mode
  link link/act [1Gbps/100Mbps/10Mbps] act blink-act tx copper 1Gbps blink

Thank you.

Marek

PS: After this series is applied, we can update some device trees of various
devices which use the `marvell,reg-init` property to initialize LEDs into
specific modes so that instead of using `marvell,reg-init` they can register
LEDs via this subsystem. The `marvell,reg-init` property does not comply with
the idea that the device tree should only describe how devices are connected
to each other on the board. Maybe this property could then be proclaimed as
legacy and a warning could be printed if it is used.

Changes since v1:
- the HW controlled LEDs API is now generalized (so not only for ethernet
  PHYs), and lives in drivers/leds/leds-hw-controlled.c.
  I did this because I am thinking forward for when I'll be adding support
  for LEDs connected to Marvell ethernet switches (mv88e6xxx driver).
  The LEDs there should be described as descendants of the `port` nodes, not
  `phy` nodes, because:
    - some ports don't have PHYs and yet can have LEDs
    - some ports have SERDES PHYs which are currently not described in any
      way in device-tree
    - some LEDs can be made to blink on activity/other event on multiple
      ports at once
- hence the private LED trigger was renamed from `phydev-hw-mode` to
  `dev-hw-mode`
- the `led-open-drain` DT property was renamed to `led-tristate` property,
  because I learned that the two things mean something different and in
  Marvell PHYs the polarity on off state can be put into tristate mode, not
  open drain mode
- the devicename part of PHY LEDs is now in the format `ethernet-phy%i`,
  instead of `phy%i`
- the code adding `phyindex` member to struct phy_device is now in separate
  patch
- YAML device-tree binding schema for HW controlled LEDs now lives in it's
  own file and the ethernet-phy.yaml file now contains a reference to the
  this schema
- added a patch adding nodes for PHY controlled LEDs for Turris MOX' device
  tree

Changes since RFC v4:
- added device-tree binding documentation.
- the OF code now checks for linux,default-hw-mode property so that
  default HW mode can be set in device tree (like linux,default-trigger)
  (this was suggested by Andrew)
- the OF code also checks for enable-active-high and led-open-drain
  properties, and the marvell PHY driver now understands uses these
  settings when initializing the LEDs
- the LED operations were moved to their own struct phy_device_led_ops
- a new member was added into struct phy_device: phyindex. This is an
  incrementing integer, new for each registered phy_device. This is used
  for a simple naming scheme for the devicename part of a LED, as was
  suggested in a discussion by Andrew and Pavel. A PHY controlled LED
  now has a name in form:
    phy%i:color:function
  When a PHY is attached to a netdevice, userspace can control available
  PHY controlled LEDs via /sys/class/net/<ifname>/phydev/leds/
- legacy LED configuration in Marvell PHY driver (in function
  marvell_config_led) now writes only to registers which do not
  correspond to any registered LED

Changes since RFC v3:
- addressed some of Andrew's suggestions
- phy_hw_led_mode.c renamed to phy_led.c
- the DT reading code is now also generic, moved to phy_led.c and called
  from phy_probe
- the function registering the phydev-hw-mode trigger is now called from
  phy_device.c function phy_init before registering genphy drivers
- PHY LED functionality now depends on CONFIG_LEDS_TRIGGERS

Changes since RFC v2:
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

Marek Behún (7):
  dt-bindings: leds: document binding for HW controlled LEDs
  leds: add generic API for LEDs that can be controlled by hardware
  net: phy: add simple incrementing phyindex member to phy_device struct
  dt-bindings: net: ethernet-phy: add description for PHY LEDs
  net: phy: add support for LEDs controlled by ethernet PHY chips
  net: phy: marvell: add support for LEDs controlled by Marvell PHYs
  arm64: dts: armada-3720-turris-mox: add nodes for ethernet PHY LEDs

 .../sysfs-class-led-trigger-dev-hw-mode       |   8 +
 .../leds/linux,hw-controlled-leds.yaml        |  99 ++++++
 .../devicetree/bindings/net/ethernet-phy.yaml |   8 +
 .../dts/marvell/armada-3720-turris-mox.dts    |  23 ++
 drivers/leds/Kconfig                          |  10 +
 drivers/leds/Makefile                         |   1 +
 drivers/leds/leds-hw-controlled.c             | 227 +++++++++++++
 drivers/net/phy/marvell.c                     | 314 +++++++++++++++++-
 drivers/net/phy/phy_device.c                  | 106 ++++++
 include/linux/leds-hw-controlled.h            |  74 +++++
 include/linux/phy.h                           |   7 +
 11 files changed, 875 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-trigger-dev-hw-mode
 create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
 create mode 100644 drivers/leds/leds-hw-controlled.c
 create mode 100644 include/linux/leds-hw-controlled.h

-- 
2.26.2

