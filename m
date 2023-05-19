Return-Path: <netdev+bounces-3964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF5A709D84
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E99F1C212E8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B62125C8;
	Fri, 19 May 2023 17:06:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93642111B9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:06:31 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC825E73
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684515977; x=1716051977;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HRsEYRqLrbNXXBQ0VJmXdi3bDGRnTFIyXJ0aFsLYcXU=;
  b=NAfOJFEyB3bSZn/1zeI0ub1oM2iD99UB5UC4O7ZiVW4MSGHRKun3a+JP
   3IglTxLMDisGVgVQxuAWZ6Nwu88FVt6KxY023F90zUE2EgWF+F3qMrUxV
   6tpn19iTwqMGnR6KNxE/TJNKzMVugPRpqE+PR7bUEVavPbT2sTEJSZJhv
   oOHhMOp/rlUdKkJQk3WR1JEGiDARcA6hmMlb3cSK+6aUEG8PQGPBLD4mK
   5HBxdy8exjNkoK0sNp3qkLoCn8M30hNqj58GefdYpcUrwy9AKHBveewqB
   FiZ3bATC+2x7dqk63wc83gVcWKexfQ/k1Mh8O3pTtfTpPzGJfhG8lp4BB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="418123754"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="418123754"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="696779251"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="696779251"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 19 May 2023 10:05:53 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Radoslaw Tyl <radoslawx.tyl@intel.com>,
	anthony.l.nguyen@intel.com,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next] i40e: add PHY debug register dump
Date: Fri, 19 May 2023 10:02:08 -0700
Message-Id: <20230519170208.2820484-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Implement ethtool register dump for some PHY registers in order to
assist field debugging of link issues.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  3 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 72 ++++++++++++++-----
 .../net/ethernet/intel/i40e/i40e_register.h   |  8 +++
 3 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 6e310a539467..876d25cc5670 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -93,6 +93,9 @@
 #define I40E_OEM_SNAP_SHIFT		16
 #define I40E_OEM_RELEASE_MASK		0x0000ffff
 
+/* default value when register dump is fail */
+#define I40E_READ_REG_INVALID		0xaabbccdd
+
 #define I40E_RX_DESC(R, i)	\
 	(&(((union i40e_rx_desc *)((R)->desc))[i]))
 #define I40E_TX_DESC(R, i)	\
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index afc4fa8c66af..694de948cb14 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -426,6 +426,19 @@ static const char i40e_gstrings_test[][ETH_GSTRING_LEN] = {
 
 #define I40E_TEST_LEN (sizeof(i40e_gstrings_test) / ETH_GSTRING_LEN)
 
+static const struct i40e_diag_reg_test_info i40e_phy_regs_list[] = {
+	/* offset               mask         elements   stride */
+	{I40E_PRTMAC_PCS_LINK_CTRL,		0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_LINK_STATUS1(0),	0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_LINK_STATUS2,		0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_XGMII_FIFO_STATUS,	0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_AN_LP_STATUS,		0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_KR_STATUS,		0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_FEC_KR_STATUS1,	0xFFFFFFFF, 1, 4},
+	{I40E_PRTMAC_PCS_FEC_KR_STATUS2,	0xFFFFFFFF, 1, 4},
+	{ 0 }
+};
+
 struct i40e_priv_flags {
 	char flag_string[ETH_GSTRING_LEN];
 	u64 flag;
@@ -1814,38 +1827,61 @@ static int i40e_get_regs_len(struct net_device *netdev)
 	for (i = 0; i40e_reg_list[i].offset != 0; i++)
 		reg_count += i40e_reg_list[i].elements;
 
+	for (i = 0; i40e_phy_regs_list[i].offset != 0; i++)
+		reg_count += i40e_phy_regs_list[i].elements;
+
 	return reg_count * sizeof(u32);
 }
 
-static void i40e_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
-			  void *p)
+static void i40e_read_regs(struct net_device *netdev,
+			   const struct i40e_diag_reg_test_info *i40e_regs_list,
+			   void *p, u32 *ri)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 	u32 *reg_buf = p;
-	unsigned int i, j, ri;
+	unsigned int i, j;
 	u32 reg;
+	u32 val;
+
+	/* loop through the regs table for what to print */
+	for (i = 0; i40e_regs_list[i].offset != 0; i++) {
+		for (j = 0; j < i40e_regs_list[i].elements; j++) {
+			reg = i40e_regs_list[i].offset
+				+ (j * i40e_regs_list[i].stride);
+
+			/* check the range on registers */
+			if (reg <= (pf->ioremap_len - sizeof(u32)))
+				val = rd32(hw, reg);
+			else
+				val = I40E_READ_REG_INVALID;
+
+			netdev_dbg(netdev, "reg[%02u] 0x%08X %08X\n",
+				   *ri, reg, val);
+			reg_buf[(*ri)++] = val;
+		}
+	}
+}
+
+static void i40e_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
+			  void *p)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_hw *hw = &np->vsi->back->hw;
+	u32 ri = 0;
 
 	/* Tell ethtool which driver-version-specific regs output we have.
 	 *
-	 * At some point, if we have ethtool doing special formatting of
-	 * this data, it will rely on this version number to know how to
-	 * interpret things.  Hence, this needs to be updated if/when the
-	 * diags register table is changed.
+	 * At some point, if we will have ethtool able to parse binary stream
+	 * output, it will rely on this version number, basing on encoded
+	 * MAC type, Revision ID and Device ID of tested PHY.
 	 */
-	regs->version = 1;
-
-	/* loop through the diags reg table for what to print */
-	ri = 0;
-	for (i = 0; i40e_reg_list[i].offset != 0; i++) {
-		for (j = 0; j < i40e_reg_list[i].elements; j++) {
-			reg = i40e_reg_list[i].offset
-				+ (j * i40e_reg_list[i].stride);
-			reg_buf[ri++] = rd32(hw, reg);
-		}
-	}
+	regs->version = hw->mac.type << 24 | hw->revision_id << 16 |
+			hw->device_id;
 
+	i40e_read_regs(netdev, i40e_reg_list, p, &ri);
+	i40e_read_regs(netdev, i40e_phy_regs_list, p, &ri);
 }
 
 static int i40e_get_eeprom(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 7339003aa17c..7bfed10d5ab4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -522,6 +522,14 @@
 #define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_SHIFT 0
 #define I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_MASK I40E_MASK(0xFFFF, \
 	I40E_PRTMAC_HSEC_CTL_TX_PAUSE_REFRESH_TIMER_SHIFT)
+#define I40E_PRTMAC_PCS_LINK_STATUS1(_i) (0x0008C200 + ((_i) * 4))
+#define I40E_PRTMAC_PCS_LINK_STATUS2 0x0008C220
+#define I40E_PRTMAC_PCS_LINK_CTRL 0x0008C260
+#define I40E_PRTMAC_PCS_XGMII_FIFO_STATUS 0x0008C320
+#define I40E_PRTMAC_PCS_AN_LP_STATUS 0x0008C680
+#define I40E_PRTMAC_PCS_KR_STATUS 0x0008CA00
+#define I40E_PRTMAC_PCS_FEC_KR_STATUS1 0x0008CC20
+#define I40E_PRTMAC_PCS_FEC_KR_STATUS2 0x0008CC40
 #define I40E_GLNVM_FLA 0x000B6108 /* Reset: POR */
 #define I40E_GLNVM_FLA_LOCKED_SHIFT 6
 #define I40E_GLNVM_FLA_LOCKED_MASK I40E_MASK(0x1, I40E_GLNVM_FLA_LOCKED_SHIFT)
-- 
2.38.1


