Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA074592E1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbhKVQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:22:56 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:42236
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232643AbhKVQW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:22:56 -0500
Received: from HP-EliteBook-840-G7.. (1-171-213-156.dynamic-ip.hinet.net [1.171.213.156])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 369393F253;
        Mon, 22 Nov 2021 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637597988;
        bh=HR/yG6ZBU+cgsjsaVvJ14k2uEqFROk/uwUfNZrlo4L4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hNZgWsnFYbgc+sPnHPYae3afDVXQS2PtAv5U3yebZ1C7y8Ax7hqtZrotSumH89U53
         91ewS/TAEHvz9LT9WbahLfIGogPxPPGLxnIwoo1xmdJjnb2x6ONdXRpqng3rG9a96Y
         tD62bmbn//vpmWledXhvOme8xbuGGyxqzEO6Kd311qlXZ3Kl92hrdc+Id1KSLCmuuf
         5upwbxUAnpD2OonQ/tV0tkgiDLgaFAy7/7V499LJs0j0H9MnEf1sH/cGmdAAy95x0R
         YDaH+Jb8nS9KyARVx6vPu+APAyAIUY35EBAnFsKrgurrdo13b2arYGB8J6aoodOAeA
         HSrwl7115pvDw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     sasha.neftin@intel.com, acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Revert "e1000e: Add handshake with the CSME to support S0ix"
Date:   Tue, 23 Nov 2021 00:19:27 +0800
Message-Id: <20211122161927.874291-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122161927.874291-1-kai.heng.feng@canonical.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3e55d231716ea361b1520b801c6778c4c48de102.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.h |   2 -
 drivers/net/ethernet/intel/e1000e/netdev.c  | 328 +++++++++-----------
 2 files changed, 154 insertions(+), 176 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 1dfa1d28dae64..8f2a8f4ce0ee4 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -47,8 +47,6 @@
 #define E1000_SHRAH_PCH_LPT(_i)		(0x0540C + ((_i) * 8))
 
 #define E1000_H2ME		0x05B50	/* Host to ME */
-#define E1000_H2ME_START_DPG	0x00000001	/* indicate the ME of DPG */
-#define E1000_H2ME_EXIT_DPG	0x00000002	/* indicate the ME exit DPG */
 #define E1000_H2ME_ULP		0x00000800	/* ULP Indication Bit */
 #define E1000_H2ME_ENFORCE_SETTINGS	0x00001000	/* Enforce Settings */
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 242314809e59c..52c91c52b971b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6345,105 +6345,43 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
-		/* Request ME configure the device for S0ix */
-		mac_data = er32(H2ME);
-		mac_data |= E1000_H2ME_START_DPG;
-		mac_data &= ~E1000_H2ME_EXIT_DPG;
-		ew32(H2ME, mac_data);
-	} else {
-		/* Request driver configure the device to S0ix */
-		/* Disable the periodic inband message,
-		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
-		 */
-		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-		phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
-		phy_data |= BIT(10);
-		e1e_wphy(hw, HV_PM_CTRL, phy_data);
-
-		/* Make sure we don't exit K1 every time a new packet arrives
-		 * 772_29[5] = 1 CS_Mode_Stay_In_K1
-		 */
-		e1e_rphy(hw, I217_CGFREG, &phy_data);
-		phy_data |= BIT(5);
-		e1e_wphy(hw, I217_CGFREG, phy_data);
-
-		/* Change the MAC/PHY interface to SMBus
-		 * Force the SMBus in PHY page769_23[0] = 1
-		 * Force the SMBus in MAC CTRL_EXT[11] = 1
-		 */
-		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-		phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
-		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-		mac_data = er32(CTRL_EXT);
-		mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
-		ew32(CTRL_EXT, mac_data);
-
-		/* DFT control: PHY bit: page769_20[0] = 1
-		 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
-		 */
-		e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
-		phy_data |= BIT(0);
-		e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
-
-		mac_data = er32(EXTCNF_CTRL);
-		mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
-		ew32(EXTCNF_CTRL, mac_data);
-
-		/* Enable the Dynamic Power Gating in the MAC */
-		mac_data = er32(FEXTNVM7);
-		mac_data |= BIT(22);
-		ew32(FEXTNVM7, mac_data);
-
-		/* Disable disconnected cable conditioning for Power Gating */
-		mac_data = er32(DPGFR);
-		mac_data |= BIT(2);
-		ew32(DPGFR, mac_data);
-
-		/* Don't wake from dynamic Power Gating with clock request */
-		mac_data = er32(FEXTNVM12);
-		mac_data |= BIT(12);
-		ew32(FEXTNVM12, mac_data);
-
-		/* Ungate PGCB clock */
-		mac_data = er32(FEXTNVM9);
-		mac_data &= ~BIT(28);
-		ew32(FEXTNVM9, mac_data);
-
-		/* Enable K1 off to enable mPHY Power Gating */
-		mac_data = er32(FEXTNVM6);
-		mac_data |= BIT(31);
-		ew32(FEXTNVM6, mac_data);
-
-		/* Enable mPHY power gating for any link and speed */
-		mac_data = er32(FEXTNVM8);
-		mac_data |= BIT(9);
-		ew32(FEXTNVM8, mac_data);
-
-		/* Enable the Dynamic Clock Gating in the DMA and MAC */
-		mac_data = er32(CTRL_EXT);
-		mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
-		ew32(CTRL_EXT, mac_data);
-
-		/* No MAC DPG gating SLP_S0 in modern standby
-		 * Switch the logic of the lanphypc to use PMC counter
-		 */
-		mac_data = er32(FEXTNVM5);
-		mac_data |= BIT(7);
-		ew32(FEXTNVM5, mac_data);
-	}
+	/* Disable the periodic inband message,
+	 * don't request PCIe clock in K1 page770_17[10:9] = 10b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= ~HV_PM_CTRL_K1_CLK_REQ;
+	phy_data |= BIT(10);
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
 
-	/* Disable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data |= BIT(31);
-	mac_data &= ~BIT(0);
-	ew32(FEXTNVM7, mac_data);
+	/* Make sure we don't exit K1 every time a new packet arrives
+	 * 772_29[5] = 1 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data |= BIT(5);
+	e1e_wphy(hw, I217_CGFREG, phy_data);
 
-	/* Dynamic Power Gating Enable */
+	/* Change the MAC/PHY interface to SMBus
+	 * Force the SMBus in PHY page769_23[0] = 1
+	 * Force the SMBus in MAC CTRL_EXT[11] = 1
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data |= CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
 	mac_data = er32(CTRL_EXT);
-	mac_data |= BIT(3);
+	mac_data |= E1000_CTRL_EXT_FORCE_SMBUS;
 	ew32(CTRL_EXT, mac_data);
 
+	/* DFT control: PHY bit: page769_20[0] = 1
+	 * Gate PPW via EXTCNF_CTRL - set 0x0F00[7] = 1
+	 */
+	e1e_rphy(hw, I82579_DFT_CTRL, &phy_data);
+	phy_data |= BIT(0);
+	e1e_wphy(hw, I82579_DFT_CTRL, phy_data);
+
+	mac_data = er32(EXTCNF_CTRL);
+	mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
+	ew32(EXTCNF_CTRL, mac_data);
+
 	/* Check MAC Tx/Rx packet buffer pointers.
 	 * Reset MAC Tx/Rx packet buffer pointers to suppress any
 	 * pending traffic indication that would prevent power gating.
@@ -6478,6 +6416,59 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	mac_data = er32(RDFPC);
 	if (mac_data)
 		ew32(RDFPC, 0);
+
+	/* Enable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(22);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(31);
+	mac_data &= ~BIT(0);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Dynamic Power Gating Enable */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= BIT(3);
+	ew32(CTRL_EXT, mac_data);
+
+	/* Disable disconnected cable conditioning for Power Gating */
+	mac_data = er32(DPGFR);
+	mac_data |= BIT(2);
+	ew32(DPGFR, mac_data);
+
+	/* Don't wake from dynamic Power Gating with clock request */
+	mac_data = er32(FEXTNVM12);
+	mac_data |= BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data &= ~BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Enable K1 off to enable mPHY Power Gating */
+	mac_data = er32(FEXTNVM6);
+	mac_data |= BIT(31);
+	ew32(FEXTNVM6, mac_data);
+
+	/* Enable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data |= BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* Enable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
+	ew32(CTRL_EXT, mac_data);
+
+	/* No MAC DPG gating SLP_S0 in modern standby
+	 * Switch the logic of the lanphypc to use PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data |= BIT(7);
+	ew32(FEXTNVM5, mac_data);
 }
 
 static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
@@ -6486,98 +6477,87 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
-		/* Request ME unconfigure the device from S0ix */
-		mac_data = er32(H2ME);
-		mac_data &= ~E1000_H2ME_START_DPG;
-		mac_data |= E1000_H2ME_EXIT_DPG;
-		ew32(H2ME, mac_data);
-	} else {
-		/* Request driver unconfigure the device from S0ix */
-
-		/* Disable the Dynamic Power Gating in the MAC */
-		mac_data = er32(FEXTNVM7);
-		mac_data &= 0xFFBFFFFF;
-		ew32(FEXTNVM7, mac_data);
-
-		/* Disable mPHY power gating for any link and speed */
-		mac_data = er32(FEXTNVM8);
-		mac_data &= ~BIT(9);
-		ew32(FEXTNVM8, mac_data);
-
-		/* Disable K1 off */
-		mac_data = er32(FEXTNVM6);
-		mac_data &= ~BIT(31);
-		ew32(FEXTNVM6, mac_data);
-
-		/* Disable Ungate PGCB clock */
-		mac_data = er32(FEXTNVM9);
-		mac_data |= BIT(28);
-		ew32(FEXTNVM9, mac_data);
-
-		/* Cancel not waking from dynamic
-		 * Power Gating with clock request
-		 */
-		mac_data = er32(FEXTNVM12);
-		mac_data &= ~BIT(12);
-		ew32(FEXTNVM12, mac_data);
+	/* Disable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data &= 0xFFBFFFFF;
+	ew32(FEXTNVM7, mac_data);
 
-		/* Cancel disable disconnected cable conditioning
-		 * for Power Gating
-		 */
-		mac_data = er32(DPGFR);
-		mac_data &= ~BIT(2);
-		ew32(DPGFR, mac_data);
+	/* Enable the time synchronization clock */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(0);
+	ew32(FEXTNVM7, mac_data);
 
-		/* Disable the Dynamic Clock Gating in the DMA and MAC */
-		mac_data = er32(CTRL_EXT);
-		mac_data &= 0xFFF7FFFF;
-		ew32(CTRL_EXT, mac_data);
+	/* Disable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data &= ~BIT(9);
+	ew32(FEXTNVM8, mac_data);
 
-		/* Revert the lanphypc logic to use the internal Gbe counter
-		 * and not the PMC counter
-		 */
-		mac_data = er32(FEXTNVM5);
-		mac_data &= 0xFFFFFF7F;
-		ew32(FEXTNVM5, mac_data);
+	/* Disable K1 off */
+	mac_data = er32(FEXTNVM6);
+	mac_data &= ~BIT(31);
+	ew32(FEXTNVM6, mac_data);
 
-		/* Enable the periodic inband message,
-		 * Request PCIe clock in K1 page770_17[10:9] =01b
-		 */
-		e1e_rphy(hw, HV_PM_CTRL, &phy_data);
-		phy_data &= 0xFBFF;
-		phy_data |= HV_PM_CTRL_K1_CLK_REQ;
-		e1e_wphy(hw, HV_PM_CTRL, phy_data);
+	/* Disable Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data |= BIT(28);
+	ew32(FEXTNVM9, mac_data);
 
-		/* Return back configuration
-		 * 772_29[5] = 0 CS_Mode_Stay_In_K1
-		 */
-		e1e_rphy(hw, I217_CGFREG, &phy_data);
-		phy_data &= 0xFFDF;
-		e1e_wphy(hw, I217_CGFREG, phy_data);
+	/* Cancel not waking from dynamic
+	 * Power Gating with clock request
+	 */
+	mac_data = er32(FEXTNVM12);
+	mac_data &= ~BIT(12);
+	ew32(FEXTNVM12, mac_data);
 
-		/* Change the MAC/PHY interface to Kumeran
-		 * Unforce the SMBus in PHY page769_23[0] = 0
-		 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
-		 */
-		e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
-		phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
-		e1e_wphy(hw, CV_SMB_CTRL, phy_data);
-		mac_data = er32(CTRL_EXT);
-		mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
-		ew32(CTRL_EXT, mac_data);
-	}
+	/* Cancel disable disconnected cable conditioning
+	 * for Power Gating
+	 */
+	mac_data = er32(DPGFR);
+	mac_data &= ~BIT(2);
+	ew32(DPGFR, mac_data);
 
 	/* Disable Dynamic Power Gating */
 	mac_data = er32(CTRL_EXT);
 	mac_data &= 0xFFFFFFF7;
 	ew32(CTRL_EXT, mac_data);
 
-	/* Enable the time synchronization clock */
-	mac_data = er32(FEXTNVM7);
-	mac_data &= ~BIT(31);
-	mac_data |= BIT(0);
-	ew32(FEXTNVM7, mac_data);
+	/* Disable the Dynamic Clock Gating in the DMA and MAC */
+	mac_data = er32(CTRL_EXT);
+	mac_data &= 0xFFF7FFFF;
+	ew32(CTRL_EXT, mac_data);
+
+	/* Revert the lanphypc logic to use the internal Gbe counter
+	 * and not the PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data &= 0xFFFFFF7F;
+	ew32(FEXTNVM5, mac_data);
+
+	/* Enable the periodic inband message,
+	 * Request PCIe clock in K1 page770_17[10:9] =01b
+	 */
+	e1e_rphy(hw, HV_PM_CTRL, &phy_data);
+	phy_data &= 0xFBFF;
+	phy_data |= HV_PM_CTRL_K1_CLK_REQ;
+	e1e_wphy(hw, HV_PM_CTRL, phy_data);
+
+	/* Return back configuration
+	 * 772_29[5] = 0 CS_Mode_Stay_In_K1
+	 */
+	e1e_rphy(hw, I217_CGFREG, &phy_data);
+	phy_data &= 0xFFDF;
+	e1e_wphy(hw, I217_CGFREG, phy_data);
+
+	/* Change the MAC/PHY interface to Kumeran
+	 * Unforce the SMBus in PHY page769_23[0] = 0
+	 * Unforce the SMBus in MAC CTRL_EXT[11] = 0
+	 */
+	e1e_rphy(hw, CV_SMB_CTRL, &phy_data);
+	phy_data &= ~CV_SMB_CTRL_FORCE_SMBUS;
+	e1e_wphy(hw, CV_SMB_CTRL, phy_data);
+	mac_data = er32(CTRL_EXT);
+	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_data);
 }
 
 static int e1000e_pm_freeze(struct device *dev)
-- 
2.32.0

