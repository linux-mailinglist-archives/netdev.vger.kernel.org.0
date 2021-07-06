Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0423BD17C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbhGFLjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237338AbhGFLgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A90461D61;
        Tue,  6 Jul 2021 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570819;
        bh=I+FqOmRyObkijY/msE33fTQdbnQudaAaFYANp9Xw0cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju+S44O8CKqiVS/948b6X2Oj4LyjKV4p28ClVd+ylW6NG2tWlxBzKfeVKh98y4AvR
         LiMnYnkwNKIpOmwOA9AHeXxdN640MB5pbY/iLSdRRbFtM0W3lNnk0UfVCPoTHcp35M
         sqpRwl9fPaGxsi8wOeS689Sib8ZkJaRkoYjhUd0OgumVdz0SZyNMl3CfpW7Gb1V1wx
         FBsjD4J5+TM9uzyt9/O8wfHe3O3o4ro5IgrWCqatFUGhEnsSXCYB/sgeYsc3Z4XM7R
         pgmy+mV5xaeCsy4zAyXz9NuAzAsqnQHx9OJq7fve2eWm2DM92su//qiDmVWeL/5tJd
         zNqXKJEHLK0Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/55] e100: handle eeprom as little endian
Date:   Tue,  6 Jul 2021 07:25:59 -0400
Message-Id: <20210706112638.2065023-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit d4ef55288aa2e1b76033717242728ac98ddc4721 ]

Sparse tool was warning on some implicit conversions from
little endian data read from the EEPROM on the e100 cards.

Fix these by being explicit about the conversions using
le16_to_cpu().

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 78b44d787638..bf64fab38385 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1398,7 +1398,7 @@ static int e100_phy_check_without_mii(struct nic *nic)
 	u8 phy_type;
 	int without_mii;
 
-	phy_type = (nic->eeprom[eeprom_phy_iface] >> 8) & 0x0f;
+	phy_type = (le16_to_cpu(nic->eeprom[eeprom_phy_iface]) >> 8) & 0x0f;
 
 	switch (phy_type) {
 	case NoSuchPhy: /* Non-MII PHY; UNTESTED! */
@@ -1518,7 +1518,7 @@ static int e100_phy_init(struct nic *nic)
 		mdio_write(netdev, nic->mii.phy_id, MII_BMCR, bmcr);
 	} else if ((nic->mac >= mac_82550_D102) || ((nic->flags & ich) &&
 	   (mdio_read(netdev, nic->mii.phy_id, MII_TPISTATUS) & 0x8000) &&
-		(nic->eeprom[eeprom_cnfg_mdix] & eeprom_mdix_enabled))) {
+	   (le16_to_cpu(nic->eeprom[eeprom_cnfg_mdix]) & eeprom_mdix_enabled))) {
 		/* enable/disable MDI/MDI-X auto-switching. */
 		mdio_write(netdev, nic->mii.phy_id, MII_NCONFIG,
 				nic->mii.force_media ? 0 : NCONFIG_AUTO_SWITCH);
@@ -2264,9 +2264,9 @@ static int e100_asf(struct nic *nic)
 {
 	/* ASF can be enabled from eeprom */
 	return (nic->pdev->device >= 0x1050) && (nic->pdev->device <= 0x1057) &&
-	   (nic->eeprom[eeprom_config_asf] & eeprom_asf) &&
-	   !(nic->eeprom[eeprom_config_asf] & eeprom_gcl) &&
-	   ((nic->eeprom[eeprom_smbus_addr] & 0xFF) != 0xFE);
+	   (le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_asf) &&
+	   !(le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_gcl) &&
+	   ((le16_to_cpu(nic->eeprom[eeprom_smbus_addr]) & 0xFF) != 0xFE);
 }
 
 static int e100_up(struct nic *nic)
@@ -2922,7 +2922,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Wol magic packet can be enabled from eeprom */
 	if ((nic->mac >= mac_82558_D101_A4) &&
-	   (nic->eeprom[eeprom_id] & eeprom_id_wol)) {
+	   (le16_to_cpu(nic->eeprom[eeprom_id]) & eeprom_id_wol)) {
 		nic->flags |= wol_magic;
 		device_set_wakeup_enable(&pdev->dev, true);
 	}
-- 
2.30.2

