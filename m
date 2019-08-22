Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773DB9A125
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403966AbfHVUat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:30:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:17468 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391204AbfHVUan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:30:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 13:30:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="169907290"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 13:30:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/13] i40e: allow reset in recovery mode
Date:   Thu, 22 Aug 2019 13:30:37 -0700
Message-Id: <20190822203039.15668-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
References: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Driver waits after issuing a reset. When a reset takes too long a driver
gives up. Implemented by invoking PF reset in a loop. After defined
number of unsuccessful PF reset trials it returns error.
Without this patch PF reset fails when NIC is in recovery mode.

So make i40e_set_mac_type() public. i40e driver requires i40e_set_mac_type()
to be public. It is required for recovery mode handling. Without this patch
recovery mode could not be detected in i40e_probe().

Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 67 +++++++++++++++++--
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  2 +
 3 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 7af1b7477140..de996a80013e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -13,7 +13,7 @@
  * This function sets the mac type of the adapter based on the
  * vendor ID and device ID stored in the hw structure.
  **/
-static i40e_status i40e_set_mac_type(struct i40e_hw *hw)
+i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 {
 	i40e_status status = 0;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8d6b9515b595..fdf43d87e983 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14564,6 +14564,51 @@ static bool i40e_check_recovery_mode(struct i40e_pf *pf)
 	return false;
 }
 
+/**
+ * i40e_pf_loop_reset - perform reset in a loop.
+ * @pf: board private structure
+ *
+ * This function is useful when a NIC is about to enter recovery mode.
+ * When a NIC's internal data structures are corrupted the NIC's
+ * firmware is going to enter recovery mode.
+ * Right after a POR it takes about 7 minutes for firmware to enter
+ * recovery mode. Until that time a NIC is in some kind of intermediate
+ * state. After that time period the NIC almost surely enters
+ * recovery mode. The only way for a driver to detect intermediate
+ * state is to issue a series of pf-resets and check a return value.
+ * If a PF reset returns success then the firmware could be in recovery
+ * mode so the caller of this code needs to check for recovery mode
+ * if this function returns success. There is a little chance that
+ * firmware will hang in intermediate state forever.
+ * Since waiting 7 minutes is quite a lot of time this function waits
+ * 10 seconds and then gives up by returning an error.
+ *
+ * Return 0 on success, negative on failure.
+ **/
+static i40e_status i40e_pf_loop_reset(struct i40e_pf *pf)
+{
+	const unsigned short MAX_CNT = 1000;
+	const unsigned short MSECS = 10;
+	struct i40e_hw *hw = &pf->hw;
+	i40e_status ret;
+	int cnt;
+
+	for (cnt = 0; cnt < MAX_CNT; ++cnt) {
+		ret = i40e_pf_reset(hw);
+		if (!ret)
+			break;
+		msleep(MSECS);
+	}
+
+	if (cnt == MAX_CNT) {
+		dev_info(&pf->pdev->dev, "PF reset failed: %d\n", ret);
+		return ret;
+	}
+
+	pf->pfr_count++;
+	return ret;
+}
+
 /**
  * i40e_init_recovery_mode - initialize subsystems needed in recovery mode
  * @pf: board private structure
@@ -14792,14 +14837,22 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Reset here to make sure all is clean and to define PF 'n' */
 	i40e_clear_hw(hw);
-	if (!i40e_check_recovery_mode(pf)) {
-		err = i40e_pf_reset(hw);
-		if (err) {
-			dev_info(&pdev->dev, "Initial pf_reset failed: %d\n", err);
-			goto err_pf_reset;
-		}
-		pf->pfr_count++;
+
+	err = i40e_set_mac_type(hw);
+	if (err) {
+		dev_warn(&pdev->dev, "unidentified MAC or BLANK NVM: %d\n",
+			 err);
+		goto err_pf_reset;
 	}
+
+	err = i40e_pf_loop_reset(pf);
+	if (err) {
+		dev_info(&pdev->dev, "Initial pf_reset failed: %d\n", err);
+		goto err_pf_reset;
+	}
+
+	i40e_check_recovery_mode(pf);
+
 	hw->aq.num_arq_entries = I40E_AQ_LEN;
 	hw->aq.num_asq_entries = I40E_AQ_LEN;
 	hw->aq.arq_buf_size = I40E_MAX_AQ_BUF_SIZE;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index eac88bcc6c06..9c810d54df1c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -326,6 +326,8 @@ void i40e_nvmupd_check_wait_event(struct i40e_hw *hw, u16 opcode,
 void i40e_nvmupd_clear_wait_state(struct i40e_hw *hw);
 void i40e_set_pci_config_data(struct i40e_hw *hw, u16 link_status);
 
+i40e_status i40e_set_mac_type(struct i40e_hw *hw);
+
 extern struct i40e_rx_ptype_decoded i40e_ptype_lookup[];
 
 static inline struct i40e_rx_ptype_decoded decode_rx_desc_ptype(u8 ptype)
-- 
2.21.0

