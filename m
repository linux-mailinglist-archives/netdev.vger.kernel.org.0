Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C304A4C93B6
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbiCATAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbiCATAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508913EBE
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161170; x=1677697170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XnjelveC1s/dR129VmzNEDx2oDcBCyTTdqIxOmetN8c=;
  b=YFhhFyzptRQ9vyZYrvafBcK04Vw3HJGMvRTCcOWWB9iR1tS+8EAa51Ns
   SrUwIL0wmwoXfmizbeF/W97hkgo5vSMK1k5acQlVIOPFudxHrZvosCSnk
   f6x4i3ku2QZfygYC4uGKT1sMoJVUbjmsWUmQl+3eqeSBdx9ScPj1iwFjp
   gX1rXKz5W1UNHIJxYK9SCsiwQhkM5Eo+yydT9NEoW6cdXynGfAm2B7mNC
   dwBKhFLRV+E4snNKGG/wK8e+yBeKn3Y2KPaldl62lboHxMVL7Ff6xJeW7
   UQPCcKCRwDEUXKrpDv7kItHQ4M4Mil30BVPur9i8e1/gVdo3G1/z5fWKr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042325"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042325"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908270"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 5/7] iavf: stop leaking iavf_status as "errno" values
Date:   Tue,  1 Mar 2022 10:59:37 -0800
Message-Id: <20220301185939.3005116-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Several functions in the iAVF core files take status values of the enum
iavf_status and convert them into integer values. This leads to
confusion as functions return both Linux errno values and status codes
intermixed. Reporting status codes as if they were "errno" values can
lead to confusion when reviewing error logs. Additionally, it can lead
to unexpected behavior if a return value is not interpreted properly.

Fix this by introducing iavf_status_to_errno, a switch that explicitly
converts from the status codes into an appropriate error value. Also
introduce a virtchnl_status_to_errno function for the one case where we
were returning both virtchnl status codes and iavf_status codes in the
same function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 173 +++++++++++++++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  18 +-
 3 files changed, 157 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 16cd06feed31..25c986034319 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -44,6 +44,9 @@
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 #define PFX "iavf: "
 
+int iavf_status_to_errno(enum iavf_status status);
+int virtchnl_status_to_errno(enum virtchnl_status_code v_status);
+
 /* VSI state flags shared with common code */
 enum iavf_vsi_state_t {
 	__IAVF_VSI_DOWN,
@@ -525,7 +528,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter);
 void iavf_del_vlans(struct iavf_adapter *adapter);
 void iavf_set_promiscuous(struct iavf_adapter *adapter, int flags);
 void iavf_request_stats(struct iavf_adapter *adapter);
-void iavf_request_reset(struct iavf_adapter *adapter);
+int iavf_request_reset(struct iavf_adapter *adapter);
 void iavf_get_hena(struct iavf_adapter *adapter);
 void iavf_set_hena(struct iavf_adapter *adapter);
 void iavf_set_rss_key(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 25796d07d1e1..2d355a7383a4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -51,6 +51,113 @@ MODULE_LICENSE("GPL v2");
 static const struct net_device_ops iavf_netdev_ops;
 struct workqueue_struct *iavf_wq;
 
+int iavf_status_to_errno(enum iavf_status status)
+{
+	switch (status) {
+	case IAVF_SUCCESS:
+		return 0;
+	case IAVF_ERR_PARAM:
+	case IAVF_ERR_MAC_TYPE:
+	case IAVF_ERR_INVALID_MAC_ADDR:
+	case IAVF_ERR_INVALID_LINK_SETTINGS:
+	case IAVF_ERR_INVALID_PD_ID:
+	case IAVF_ERR_INVALID_QP_ID:
+	case IAVF_ERR_INVALID_CQ_ID:
+	case IAVF_ERR_INVALID_CEQ_ID:
+	case IAVF_ERR_INVALID_AEQ_ID:
+	case IAVF_ERR_INVALID_SIZE:
+	case IAVF_ERR_INVALID_ARP_INDEX:
+	case IAVF_ERR_INVALID_FPM_FUNC_ID:
+	case IAVF_ERR_QP_INVALID_MSG_SIZE:
+	case IAVF_ERR_INVALID_FRAG_COUNT:
+	case IAVF_ERR_INVALID_ALIGNMENT:
+	case IAVF_ERR_INVALID_PUSH_PAGE_INDEX:
+	case IAVF_ERR_INVALID_IMM_DATA_SIZE:
+	case IAVF_ERR_INVALID_VF_ID:
+	case IAVF_ERR_INVALID_HMCFN_ID:
+	case IAVF_ERR_INVALID_PBLE_INDEX:
+	case IAVF_ERR_INVALID_SD_INDEX:
+	case IAVF_ERR_INVALID_PAGE_DESC_INDEX:
+	case IAVF_ERR_INVALID_SD_TYPE:
+	case IAVF_ERR_INVALID_HMC_OBJ_INDEX:
+	case IAVF_ERR_INVALID_HMC_OBJ_COUNT:
+	case IAVF_ERR_INVALID_SRQ_ARM_LIMIT:
+		return -EINVAL;
+	case IAVF_ERR_NVM:
+	case IAVF_ERR_NVM_CHECKSUM:
+	case IAVF_ERR_PHY:
+	case IAVF_ERR_CONFIG:
+	case IAVF_ERR_UNKNOWN_PHY:
+	case IAVF_ERR_LINK_SETUP:
+	case IAVF_ERR_ADAPTER_STOPPED:
+	case IAVF_ERR_MASTER_REQUESTS_PENDING:
+	case IAVF_ERR_AUTONEG_NOT_COMPLETE:
+	case IAVF_ERR_RESET_FAILED:
+	case IAVF_ERR_BAD_PTR:
+	case IAVF_ERR_SWFW_SYNC:
+	case IAVF_ERR_QP_TOOMANY_WRS_POSTED:
+	case IAVF_ERR_QUEUE_EMPTY:
+	case IAVF_ERR_FLUSHED_QUEUE:
+	case IAVF_ERR_OPCODE_MISMATCH:
+	case IAVF_ERR_CQP_COMPL_ERROR:
+	case IAVF_ERR_BACKING_PAGE_ERROR:
+	case IAVF_ERR_NO_PBLCHUNKS_AVAILABLE:
+	case IAVF_ERR_MEMCPY_FAILED:
+	case IAVF_ERR_SRQ_ENABLED:
+	case IAVF_ERR_ADMIN_QUEUE_ERROR:
+	case IAVF_ERR_ADMIN_QUEUE_FULL:
+	case IAVF_ERR_BAD_IWARP_CQE:
+	case IAVF_ERR_NVM_BLANK_MODE:
+	case IAVF_ERR_PE_DOORBELL_NOT_ENABLED:
+	case IAVF_ERR_DIAG_TEST_FAILED:
+	case IAVF_ERR_FIRMWARE_API_VERSION:
+	case IAVF_ERR_ADMIN_QUEUE_CRITICAL_ERROR:
+		return -EIO;
+	case IAVF_ERR_DEVICE_NOT_SUPPORTED:
+		return -ENODEV;
+	case IAVF_ERR_NO_AVAILABLE_VSI:
+	case IAVF_ERR_RING_FULL:
+		return -ENOSPC;
+	case IAVF_ERR_NO_MEMORY:
+		return -ENOMEM;
+	case IAVF_ERR_TIMEOUT:
+	case IAVF_ERR_ADMIN_QUEUE_TIMEOUT:
+		return -ETIMEDOUT;
+	case IAVF_ERR_NOT_IMPLEMENTED:
+	case IAVF_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case IAVF_ERR_ADMIN_QUEUE_NO_WORK:
+		return -EALREADY;
+	case IAVF_ERR_NOT_READY:
+		return -EBUSY;
+	case IAVF_ERR_BUF_TOO_SHORT:
+		return -EMSGSIZE;
+	}
+
+	return -EIO;
+}
+
+int virtchnl_status_to_errno(enum virtchnl_status_code v_status)
+{
+	switch (v_status) {
+	case VIRTCHNL_STATUS_SUCCESS:
+		return 0;
+	case VIRTCHNL_STATUS_ERR_PARAM:
+	case VIRTCHNL_STATUS_ERR_INVALID_VF_ID:
+		return -EINVAL;
+	case VIRTCHNL_STATUS_ERR_NO_MEMORY:
+		return -ENOMEM;
+	case VIRTCHNL_STATUS_ERR_OPCODE_MISMATCH:
+	case VIRTCHNL_STATUS_ERR_CQP_COMPL_ERROR:
+	case VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR:
+		return -EIO;
+	case VIRTCHNL_STATUS_ERR_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	}
+
+	return -EIO;
+}
+
 /**
  * iavf_pdev_to_adapter - go from pci_dev to adapter
  * @pdev: pci_dev pointer
@@ -1427,7 +1534,7 @@ static int iavf_config_rss_aq(struct iavf_adapter *adapter)
 	struct iavf_aqc_get_set_rss_key_data *rss_key =
 		(struct iavf_aqc_get_set_rss_key_data *)adapter->rss_key;
 	struct iavf_hw *hw = &adapter->hw;
-	int ret = 0;
+	enum iavf_status status;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
@@ -1436,24 +1543,25 @@ static int iavf_config_rss_aq(struct iavf_adapter *adapter)
 		return -EBUSY;
 	}
 
-	ret = iavf_aq_set_rss_key(hw, adapter->vsi.id, rss_key);
-	if (ret) {
+	status = iavf_aq_set_rss_key(hw, adapter->vsi.id, rss_key);
+	if (status) {
 		dev_err(&adapter->pdev->dev, "Cannot set RSS key, err %s aq_err %s\n",
-			iavf_stat_str(hw, ret),
+			iavf_stat_str(hw, status),
 			iavf_aq_str(hw, hw->aq.asq_last_status));
-		return ret;
+		return iavf_status_to_errno(status);
 
 	}
 
-	ret = iavf_aq_set_rss_lut(hw, adapter->vsi.id, false,
-				  adapter->rss_lut, adapter->rss_lut_size);
-	if (ret) {
+	status = iavf_aq_set_rss_lut(hw, adapter->vsi.id, false,
+				     adapter->rss_lut, adapter->rss_lut_size);
+	if (status) {
 		dev_err(&adapter->pdev->dev, "Cannot set RSS lut, err %s aq_err %s\n",
-			iavf_stat_str(hw, ret),
+			iavf_stat_str(hw, status),
 			iavf_aq_str(hw, hw->aq.asq_last_status));
+		return iavf_status_to_errno(status);
 	}
 
-	return ret;
+	return 0;
 
 }
 
@@ -2007,23 +2115,24 @@ static void iavf_startup(struct iavf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
-	int err;
+	enum iavf_status status;
+	int ret;
 
 	WARN_ON(adapter->state != __IAVF_STARTUP);
 
 	/* driver loaded, probe complete */
 	adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
-	err = iavf_set_mac_type(hw);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to set MAC type (%d)\n", err);
+	status = iavf_set_mac_type(hw);
+	if (status) {
+		dev_err(&pdev->dev, "Failed to set MAC type (%d)\n", status);
 		goto err;
 	}
 
-	err = iavf_check_reset_complete(hw);
-	if (err) {
+	ret = iavf_check_reset_complete(hw);
+	if (ret) {
 		dev_info(&pdev->dev, "Device is still in reset (%d), retrying\n",
-			 err);
+			 ret);
 		goto err;
 	}
 	hw->aq.num_arq_entries = IAVF_AQ_LEN;
@@ -2031,14 +2140,15 @@ static void iavf_startup(struct iavf_adapter *adapter)
 	hw->aq.arq_buf_size = IAVF_MAX_AQ_BUF_SIZE;
 	hw->aq.asq_buf_size = IAVF_MAX_AQ_BUF_SIZE;
 
-	err = iavf_init_adminq(hw);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to init Admin Queue (%d)\n", err);
+	status = iavf_init_adminq(hw);
+	if (status) {
+		dev_err(&pdev->dev, "Failed to init Admin Queue (%d)\n",
+			status);
 		goto err;
 	}
-	err = iavf_send_api_ver(adapter);
-	if (err) {
-		dev_err(&pdev->dev, "Unable to send to PF (%d)\n", err);
+	ret = iavf_send_api_ver(adapter);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to send to PF (%d)\n", ret);
 		iavf_shutdown_adminq(hw);
 		goto err;
 	}
@@ -2074,7 +2184,7 @@ static void iavf_init_version_check(struct iavf_adapter *adapter)
 	/* aq msg sent, awaiting reply */
 	err = iavf_verify_api_ver(adapter);
 	if (err) {
-		if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK)
+		if (err == -EALREADY)
 			err = iavf_send_api_ver(adapter);
 		else
 			dev_err(&pdev->dev, "Unsupported PF API version %d.%d, expected %d.%d\n",
@@ -2175,11 +2285,11 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 		}
 	}
 	err = iavf_get_vf_config(adapter);
-	if (err == IAVF_ERR_ADMIN_QUEUE_NO_WORK) {
+	if (err == -EALREADY) {
 		err = iavf_send_vf_config_msg(adapter);
 		goto err_alloc;
-	} else if (err == IAVF_ERR_PARAM) {
-		/* We only get ERR_PARAM if the device is in a very bad
+	} else if (err == -EINVAL) {
+		/* We only get -EINVAL if the device is in a very bad
 		 * state or if we've been disabled for previous bad
 		 * behavior. Either way, we're done now.
 		 */
@@ -2648,6 +2758,7 @@ static void iavf_reset_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	struct iavf_mac_filter *f, *ftmp;
 	struct iavf_cloud_filter *cf;
+	enum iavf_status status;
 	u32 reg_val;
 	int i = 0, err;
 	bool running;
@@ -2749,10 +2860,12 @@ static void iavf_reset_task(struct work_struct *work)
 	/* kill and reinit the admin queue */
 	iavf_shutdown_adminq(hw);
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-	err = iavf_init_adminq(hw);
-	if (err)
+	status = iavf_init_adminq(hw);
+	if (status) {
 		dev_info(&adapter->pdev->dev, "Failed to init adminq: %d\n",
-			 err);
+			 status);
+		goto reset_err;
+	}
 	adapter->aq_required = 0;
 
 	if (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 8d53228046a5..995c5055bc12 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -22,17 +22,17 @@ static int iavf_send_pf_msg(struct iavf_adapter *adapter,
 			    enum virtchnl_ops op, u8 *msg, u16 len)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	enum iavf_status err;
+	enum iavf_status status;
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		return 0; /* nothing to see here, move along */
 
-	err = iavf_aq_send_msg_to_pf(hw, op, 0, msg, len, NULL);
-	if (err)
-		dev_dbg(&adapter->pdev->dev, "Unable to send opcode %d to PF, err %s, aq_err %s\n",
-			op, iavf_stat_str(hw, err),
+	status = iavf_aq_send_msg_to_pf(hw, op, 0, msg, len, NULL);
+	if (status)
+		dev_dbg(&adapter->pdev->dev, "Unable to send opcode %d to PF, status %s, aq_err %s\n",
+			op, iavf_stat_str(hw, status),
 			iavf_aq_str(hw, hw->aq.asq_last_status));
-	return err;
+	return iavf_status_to_errno(status);
 }
 
 /**
@@ -1843,11 +1843,13 @@ void iavf_del_adv_rss_cfg(struct iavf_adapter *adapter)
  *
  * Request that the PF reset this VF. No response is expected.
  **/
-void iavf_request_reset(struct iavf_adapter *adapter)
+int iavf_request_reset(struct iavf_adapter *adapter)
 {
+	int err;
 	/* Don't check CURRENT_OP - this is always higher priority */
-	iavf_send_pf_msg(adapter, VIRTCHNL_OP_RESET_VF, NULL, 0);
+	err = iavf_send_pf_msg(adapter, VIRTCHNL_OP_RESET_VF, NULL, 0);
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+	return err;
 }
 
 /**
-- 
2.31.1

