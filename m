Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE916B4A9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgBXWyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:10 -0500
Received: from foss.arm.com ([217.140.110.172]:43852 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B713D30E;
        Mon, 24 Feb 2020 14:54:09 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AEC4B3F534;
        Mon, 24 Feb 2020 14:54:09 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v2 0/6] Add ACPI bindings to the genet
Date:   Mon, 24 Feb 2020 16:53:57 -0600
Message-Id: <20200224225403.1650656-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series allows the BCM GENET, as used on the RPi4,
to attach when booted in an ACPI environment. The DSDT entry to
trigger this is seen below. Of note, the first patch adds a
small extension to the mdio layer which allows drivers to find
the mii_bus without firmware assistance. The fifth patch in
the set retrieves the MAC address from the umac registers
rather than carrying it directly in the DSDT. This of course
requires the firmware to pre-program it, so we continue to fall
back on a random one if it appears to be garbage.

v1 -> v2:
     fail on missing phy-mode property
     replace phy-mode internal property read string with
     	     device_get_phy_mode() equivalent
     rework mac address detection logic so that it merges
     	    the acpi/DT case into device_get_mac_address()
	    allowing _DSD mac address properties.
     some commit messages justifying why phy_find_first()
     	    isn't the worst choice for this driver.

+    Device (ETH0)
+    {
+      Name (_HID, "BCM6E4E")
+      Name (_UID, 0)
+      Name (_CCA, 0x0)
+      Method (_STA)
+      {
+        Return (0xf)
+      }
+      Method (_CRS, 0x0, Serialized)
+      {
+        Name (RBUF, ResourceTemplate ()
+        {
+          Memory32Fixed (ReadWrite, 0xFd580000, 0x10000, )
+          Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) { 0xBD }
+          Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) { 0xBE }
+        })
+        Return (RBUF)
+      }
+      Name (_DSD, Package () {
+        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+          Package () {
+          Package () { "phy-mode", "rgmii-rxid" },
+        }
+      })
+    }

Jeremy Linton (6):
  mdio_bus: Add generic mdio_find_bus()
  net: bcmgenet: refactor phy mode configuration
  net: bcmgenet: enable automatic phy discovery
  net: bcmgenet: Initial bcmgenet ACPI support
  net: bcmgenet: Fetch MAC address from the adapter
  net: bcmgenet: reduce severity of missing clock warnings

 .../net/ethernet/broadcom/genet/bcmgenet.c    | 62 +++++++++-----
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 82 ++++++++++++++-----
 drivers/net/phy/mdio_bus.c                    | 17 ++++
 include/linux/phy.h                           |  1 +
 4 files changed, 120 insertions(+), 42 deletions(-)

-- 
2.24.1

