Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E183B0537
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFVMym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:54:42 -0400
Received: from foss.arm.com ([217.140.110.172]:48762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhFVMyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:54:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED46EED1;
        Tue, 22 Jun 2021 05:52:25 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B086E3F694;
        Tue, 22 Jun 2021 05:52:24 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
Subject: [PATCH] r8169: Avoid duplicate sysfs entry creation error
Date:   Tue, 22 Jun 2021 13:52:06 +0100
Message-Id: <20210622125206.1437-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>

When registering the MDIO bus for a r8169 device, we use the PCI B/D/F
specifier as a (seemingly) unique device identifier.
However the very same BDF number can be used on another PCI segment,
which makes the driver fail probing:

[ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
[ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
....…
[ 27.684858] libphy: mii_bus r8169-700 failed to register
[ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22

Add the segment number to the device name to make it more unique.

This fixes operation on an ARM N1SDP board, where two boards might be
connected together to form an SMP system, and all on-board devices show
up twice, just on different PCI segments.

Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
[Andre: expand commit message]
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2c89cde7da1e..209dee295ce2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5086,7 +5086,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
-	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
+		 pdev->bus->domain_nr, pci_dev_id(pdev));
 
 	new_bus->read = r8169_mdio_read_reg;
 	new_bus->write = r8169_mdio_write_reg;
-- 
2.17.5

