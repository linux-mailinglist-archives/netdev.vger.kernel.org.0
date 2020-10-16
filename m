Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63D290E18
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410982AbgJPXUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407447AbgJPXUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 19:20:16 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425E120878;
        Fri, 16 Oct 2020 23:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602890415;
        bh=649c6RlozZsvm4+vvYsGe08W5GdQKZZI6fD6317ADYc=;
        h=From:To:Cc:Subject:Date:From;
        b=CcWKRbGtmbiINQmkFzVutB55pIMUUvMFUXXql7cJ/w2xMrqL3WbJLOYLYGgaIh8+l
         74y4TqIzxv5ooQBvOURH8WQMZjtizdSPimxFZznxlxhRnhpywMCIp1w80eE+OckeJQ
         tJVcXW9jhxo2GHv2jIzmm6uYaSgS9fJ1nyqlS9gE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, ian.kumlien@gmail.com,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ixgbe: fix probing of multi-port devices with one MDIO
Date:   Fri, 16 Oct 2020 16:20:06 -0700
Message-Id: <20201016232006.3352947-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ian reports that after upgrade from v5.8.14 to v5.9 only one
of his 4 ixgbe netdevs appear in the system.

Quoting the comment on ixgbe_x550em_a_has_mii():
 * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
 * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
 * but we only want to register one MDIO bus.

This matches the symptoms, since the return value from
ixgbe_mii_bus_init() is no longer ignored we need to handle
the higher ports of x550em without an error.

Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 23 ++++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index f77fa3e4fdd1..fc389eecdd2b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -901,15 +901,13 @@ static bool ixgbe_x550em_a_has_mii(struct ixgbe_hw *hw)
  **/
 s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 {
+	s32 (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	s32 (*read)(struct mii_bus *bus, int addr, int regnum);
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct device *dev = &adapter->netdev->dev;
 	struct mii_bus *bus;
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
-
 	switch (hw->device_id) {
 	/* C3000 SoCs */
 	case IXGBE_DEV_ID_X550EM_A_KR:
@@ -922,16 +920,23 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	case IXGBE_DEV_ID_X550EM_A_1G_T:
 	case IXGBE_DEV_ID_X550EM_A_1G_T_L:
 		if (!ixgbe_x550em_a_has_mii(hw))
-			return -ENODEV;
-		bus->read = &ixgbe_x550em_a_mii_bus_read;
-		bus->write = &ixgbe_x550em_a_mii_bus_write;
+			return 0;
+		read = &ixgbe_x550em_a_mii_bus_read;
+		write = &ixgbe_x550em_a_mii_bus_write;
 		break;
 	default:
-		bus->read = &ixgbe_mii_bus_read;
-		bus->write = &ixgbe_mii_bus_write;
+		read = &ixgbe_mii_bus_read;
+		write = &ixgbe_mii_bus_write;
 		break;
 	}
 
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
+		return -ENOMEM;
+
+	bus->read = read;
+	bus->write = write;
+
 	/* Use the position of the device in the PCI hierarchy as the id */
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mdio-%s", ixgbe_driver_name,
 		 pci_name(pdev));
-- 
2.26.2

