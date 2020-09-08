Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F50726075E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIHADP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:03:15 -0400
Received: from lists.nic.cz ([217.31.204.67]:51548 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgIHADE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:03:04 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id 14FA413FE1D;
        Tue,  8 Sep 2020 02:03:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599523381; bh=5uc6QNheLhW6rBuFDbnXLsqtJ1gV72KMTLNYptWDCq0=;
        h=From:To:Date;
        b=At+7dKwR0KZj9znd1QgFPjoaPTcq4G5psHRbgfDBvsbePOPWLnFFGbr4EVwEv39pZ
         lOz0w95BpvY73W1dfWOtUd1SbCnjiX5CDldN5RGSGDEjKJp539o0FyHLPLooLa4UOY
         dNFzJdcbg8+blHwfl9kSQjliVGYV90lYYHTeJJZQ=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v1 0/3] Add support for LEDs on Marvell PHYs
Date:   Tue,  8 Sep 2020 02:02:57 +0200
Message-Id: <20200908000300.6982-1-marek.behun@nic.cz>
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

after 4 RFC versions I am now sending these patches for real.

The code applies on net-next.

Changes since RFC v4:
- added device-tree binding documentation 
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

Marek Behún (3):
  dt-bindings: net: ethernet-phy: add description for PHY LEDs
  net: phy: add API for LEDs controlled by ethernet PHY chips
  net: phy: marvell: add support for LEDs controlled by Marvell PHYs

 .../devicetree/bindings/net/ethernet-phy.yaml |  31 ++
 drivers/net/phy/Kconfig                       |   4 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/marvell.c                     | 309 +++++++++++++++++-
 drivers/net/phy/phy_device.c                  |  28 +-
 drivers/net/phy/phy_led.c                     | 224 +++++++++++++
 include/linux/phy.h                           |  91 ++++++
 7 files changed, 679 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/phy/phy_led.c

-- 
2.26.2

