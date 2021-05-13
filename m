Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB8637F6FC
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhEMLpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhEMLow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:44:52 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6CEC061761;
        Thu, 13 May 2021 04:43:42 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lh9kb-0007HF-Hj; Thu, 13 May 2021 14:43:33 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v2 5/5] atl1c: improve link detection reliability on Mikrotik 10/25G NIC
Date:   Thu, 13 May 2021 14:43:26 +0300
Message-Id: <20210513114326.699663-6-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513114326.699663-1-gatis@mikrotik.com>
References: <20210513114326.699663-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mikrotik 10/25G NIC emulates the MDIO accesses, but the emulation is
not 100% reliable - the MDIO ops occasionally can timeout.

This adds a reliable way of detecting link on Mikrotik 10/25G NIC.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c | 26 ++++++++++++++-----
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  1 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 18 +++++--------
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
index ddb9442416cd..7dff20350865 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -636,6 +636,23 @@ int atl1c_phy_init(struct atl1c_hw *hw)
 	return 0;
 }
 
+bool atl1c_get_link_status(struct atl1c_hw *hw)
+{
+	u16 phy_data;
+
+	if (hw->nic_type == athr_mt) {
+		u32 spd;
+
+		AT_READ_REG(hw, REG_MT_SPEED, &spd);
+		return !!spd;
+	}
+
+	/* MII_BMSR must be read twice */
+	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
+	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
+	return !!(phy_data & BMSR_LSTATUS);
+}
+
 /*
  * Detects the current speed and duplex settings of the hardware.
  *
@@ -695,15 +712,12 @@ int atl1c_phy_to_ps_link(struct atl1c_hw *hw)
 	int ret = 0;
 	u16 autoneg_advertised = ADVERTISED_10baseT_Half;
 	u16 save_autoneg_advertised;
-	u16 phy_data;
 	u16 mii_lpa_data;
 	u16 speed = SPEED_0;
 	u16 duplex = FULL_DUPLEX;
 	int i;
 
-	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-	if (phy_data & BMSR_LSTATUS) {
+	if (atl1c_get_link_status(hw)) {
 		atl1c_read_phy_reg(hw, MII_LPA, &mii_lpa_data);
 		if (mii_lpa_data & LPA_10FULL)
 			autoneg_advertised = ADVERTISED_10baseT_Full;
@@ -726,9 +740,7 @@ int atl1c_phy_to_ps_link(struct atl1c_hw *hw)
 		if (mii_lpa_data) {
 			for (i = 0; i < AT_SUSPEND_LINK_TIMEOUT; i++) {
 				mdelay(100);
-				atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-				atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-				if (phy_data & BMSR_LSTATUS) {
+				if (atl1c_get_link_status(hw)) {
 					if (atl1c_get_speed_and_duplex(hw, &speed,
 									&duplex) != 0)
 						dev_dbg(&pdev->dev,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index 73cbc049a63e..c263b326cec5 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -26,6 +26,7 @@ void atl1c_phy_disable(struct atl1c_hw *hw);
 void atl1c_hw_set_mac_addr(struct atl1c_hw *hw, u8 *mac_addr);
 int atl1c_phy_reset(struct atl1c_hw *hw);
 int atl1c_read_mac_addr(struct atl1c_hw *hw);
+bool atl1c_get_link_status(struct atl1c_hw *hw);
 int atl1c_get_speed_and_duplex(struct atl1c_hw *hw, u16 *speed, u16 *duplex);
 u32 atl1c_hash_mc_addr(struct atl1c_hw *hw, u8 *mc_addr);
 void atl1c_hash_set(struct atl1c_hw *hw, u32 hash_value);
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 9693da5028cf..740127a6a21d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -232,15 +232,14 @@ static void atl1c_check_link_status(struct atl1c_adapter *adapter)
 	struct pci_dev    *pdev   = adapter->pdev;
 	int err;
 	unsigned long flags;
-	u16 speed, duplex, phy_data;
+	u16 speed, duplex;
+	bool link;
 
 	spin_lock_irqsave(&adapter->mdio_lock, flags);
-	/* MII_BMSR must read twise */
-	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
-	atl1c_read_phy_reg(hw, MII_BMSR, &phy_data);
+	link = atl1c_get_link_status(hw);
 	spin_unlock_irqrestore(&adapter->mdio_lock, flags);
 
-	if ((phy_data & BMSR_LSTATUS) == 0) {
+	if (!link) {
 		/* link down */
 		netif_carrier_off(netdev);
 		hw->hibernate = true;
@@ -284,16 +283,13 @@ static void atl1c_link_chg_event(struct atl1c_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev    *pdev   = adapter->pdev;
-	u16 phy_data;
-	u16 link_up;
+	bool link;
 
 	spin_lock(&adapter->mdio_lock);
-	atl1c_read_phy_reg(&adapter->hw, MII_BMSR, &phy_data);
-	atl1c_read_phy_reg(&adapter->hw, MII_BMSR, &phy_data);
+	link = atl1c_get_link_status(&adapter->hw);
 	spin_unlock(&adapter->mdio_lock);
-	link_up = phy_data & BMSR_LSTATUS;
 	/* notify upper layer link down ASAP */
-	if (!link_up) {
+	if (!link) {
 		if (netif_carrier_ok(netdev)) {
 			/* old link state: Up */
 			netif_carrier_off(netdev);
-- 
2.31.1

