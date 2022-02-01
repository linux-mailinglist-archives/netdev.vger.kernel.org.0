Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8795A4A62A3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241572AbiBARiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:38:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:11148 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241564AbiBARiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643737089; x=1675273089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G6uh2nH726ifbyYSO+XIDAvOvesuvqFGQNoqNQ1J7fQ=;
  b=kf4u17NNfxbyHQDyHLMDQUHgDE1GWwJcBQQLyASMl8PRJgZnWb0Yca5e
   5Zoui5az6z3jTxcxfwIT9/3sLLPz4ChbTVzHlv81Zr1Nhk3ICyJVo9OmJ
   EvWE0q3Yuu9ebakPfsiu0YHh29ipXrFIMuBqv6VWk0QerRea5r5B7ggUo
   n5mDS5trBdgJWm4KKhYu4TVHwpmIiqzFw2Etg343Zl7PZSP5JKqQe2jDD
   gQgyk46qc/dJ4RBpmORCCq5hK0qx9znJr+IUVxcAWtLGRuzD12gEBEXR4
   vD91i77BmIXn4jMJ+9ZbNlWMb+vYE3jHj/o42JYPsDqpofWISV9yoZ1uC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="235141800"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="235141800"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 09:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="482465891"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Feb 2022 09:38:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 1/2] e1000e: Separate ADP board type from TGP
Date:   Tue,  1 Feb 2022 09:37:53 -0800
Message-Id: <20220201173754.580305-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
References: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We have the same LAN controller on different PCH's. Separate ADP board
type from a TGP which will allow for specific fixes to be applied for
ADP platforms.

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h   |  4 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 20 +++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 33 +++++++++++----------
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index c3def0ee7788..8d06c9d8ff8b 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -115,7 +115,8 @@ enum e1000_boards {
 	board_pch_lpt,
 	board_pch_spt,
 	board_pch_cnp,
-	board_pch_tgp
+	board_pch_tgp,
+	board_pch_adp
 };
 
 struct e1000_ps_page {
@@ -502,6 +503,7 @@ extern const struct e1000_info e1000_pch_lpt_info;
 extern const struct e1000_info e1000_pch_spt_info;
 extern const struct e1000_info e1000_pch_cnp_info;
 extern const struct e1000_info e1000_pch_tgp_info;
+extern const struct e1000_info e1000_pch_adp_info;
 extern const struct e1000_info e1000_es2_info;
 
 void e1000e_ptp_init(struct e1000_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 5e4fc9b4e2ad..c908c84b86d2 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -6021,3 +6021,23 @@ const struct e1000_info e1000_pch_tgp_info = {
 	.phy_ops		= &ich8_phy_ops,
 	.nvm_ops		= &spt_nvm_ops,
 };
+
+const struct e1000_info e1000_pch_adp_info = {
+	.mac			= e1000_pch_adp,
+	.flags			= FLAG_IS_ICH
+				  | FLAG_HAS_WOL
+				  | FLAG_HAS_HW_TIMESTAMP
+				  | FLAG_HAS_CTRLEXT_ON_LOAD
+				  | FLAG_HAS_AMT
+				  | FLAG_HAS_FLASH
+				  | FLAG_HAS_JUMBO_FRAMES
+				  | FLAG_APME_IN_WUC,
+	.flags2			= FLAG2_HAS_PHY_STATS
+				  | FLAG2_HAS_EEE,
+	.pba			= 26,
+	.max_hw_frame_size	= 9022,
+	.get_variants		= e1000_get_variants_ich8lan,
+	.mac_ops		= &ich8_mac_ops,
+	.phy_ops		= &ich8_phy_ops,
+	.nvm_ops		= &spt_nvm_ops,
+};
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 635a95927e93..d2de8bc4c3b7 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -52,6 +52,7 @@ static const struct e1000_info *e1000_info_tbl[] = {
 	[board_pch_spt]		= &e1000_pch_spt_info,
 	[board_pch_cnp]		= &e1000_pch_cnp_info,
 	[board_pch_tgp]		= &e1000_pch_tgp_info,
+	[board_pch_adp]		= &e1000_pch_adp_info,
 };
 
 struct e1000_reg_info {
@@ -7898,22 +7899,22 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_tgp },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_tgp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V23), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_LM22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_RPL_I219_V22), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_adp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_adp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
-- 
2.31.1

