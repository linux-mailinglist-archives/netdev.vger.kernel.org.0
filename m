Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1FE3CFF64
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhGTPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 11:44:54 -0400
Received: from foss.arm.com ([217.140.110.172]:34212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234561AbhGTPhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 11:37:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F09631B;
        Tue, 20 Jul 2021 09:18:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023673F694;
        Tue, 20 Jul 2021 09:18:13 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
Subject: [PATCH net v3] r8169: Avoid duplicate sysfs entry creation error
Date:   Tue, 20 Jul 2021 17:17:40 +0100
Message-Id: <20210720161740.5214-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>

When registering the MDIO bus for a r8169 device, we use the PCI
bus/device specifier as a (seemingly) unique device identifier.
However the very same BDF number can be used on another PCI segment,
which makes the driver fail probing:

[ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
[ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
....
[ 27.684858] libphy: mii_bus r8169-700 failed to register
[ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22

Add the segment number to the device name to make it more unique.

This fixes operation on ARM N1SDP boards, with two boards connected
together to form an SMP system, and all on-board devices showing up
twice, just on different PCI segments. A similar issue would occur on
large systems with many PCI slots and multiple RTL8169 NICs.

Fixes: f1e911d5d0dfd ("r8169: add basic phylib support")
Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
[Andre: expand commit message, use pci_domain_nr()]
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Compile-tested on ARM, arm64, ppc64, sparc64, mips64, hppa, x86-64,
i386. Tested on an AMD system with an on-board RTL8111 chip.

Changes v2 ... v3:
- Resent with Fixes tag and proper net: annotation

Changes v1 ... v2:
- use pci_domain_nr() wrapper to fix compilation on various arches

 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f744557c33a3..c7af5bc3b8af 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5084,7 +5084,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
-	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
+		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
 	new_bus->read = r8169_mdio_read_reg;
 	new_bus->write = r8169_mdio_write_reg;
-- 
2.17.6

