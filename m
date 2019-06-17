Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978EC495E8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfFQXdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:25830 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfFQXdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:23 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jakub Pawlak <jakub.pawlak@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/11] iavf: Move commands processing to the separate function
Date:   Mon, 17 Jun 2019 16:33:31 -0700
Message-Id: <20190617233336.18119-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak@intel.com>

Move the commands processing outside the watchdog_task()
function. This reduce length and complexity of the function
which is mainly designed to process the watchdog state machine.

Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 197 +++++++++++---------
 1 file changed, 105 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8a37b9f604e2..d5f452e4aca8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1546,123 +1546,66 @@ static void iavf_watchdog_timer(struct timer_list *t)
 }
 
 /**
- * iavf_watchdog_task - Periodic call-back task
- * @work: pointer to work_struct
+ * iavf_process_aq_command - process aq_required flags
+ * and sends aq command
+ * @adapter: pointer to iavf adapter structure
+ *
+ * Returns 0 on success
+ * Returns error code if no command was sent
+ * or error code if the command failed.
  **/
-static void iavf_watchdog_task(struct work_struct *work)
+static int iavf_process_aq_command(struct iavf_adapter *adapter)
 {
-	struct iavf_adapter *adapter = container_of(work,
-						      struct iavf_adapter,
-						      watchdog_task);
-	struct iavf_hw *hw = &adapter->hw;
-	u32 reg_val;
-
-	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
-		goto restart_watchdog;
-
-	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) {
-		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
-			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
-		if ((reg_val == VIRTCHNL_VFR_VFACTIVE) ||
-		    (reg_val == VIRTCHNL_VFR_COMPLETED)) {
-			/* A chance for redemption! */
-			dev_err(&adapter->pdev->dev, "Hardware came out of reset. Attempting reinit.\n");
-			adapter->state = __IAVF_STARTUP;
-			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			schedule_delayed_work(&adapter->init_task, 10);
-			clear_bit(__IAVF_IN_CRITICAL_TASK,
-				  &adapter->crit_section);
-			/* Don't reschedule the watchdog, since we've restarted
-			 * the init task. When init_task contacts the PF and
-			 * gets everything set up again, it'll restart the
-			 * watchdog for us. Down, boy. Sit. Stay. Woof.
-			 */
-			return;
-		}
-		adapter->aq_required = 0;
-		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		goto watchdog_done;
-	}
-
-	if ((adapter->state < __IAVF_DOWN) ||
-	    (adapter->flags & IAVF_FLAG_RESET_PENDING))
-		goto watchdog_done;
-
-	/* check for reset */
-	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
-	if (!(adapter->flags & IAVF_FLAG_RESET_PENDING) && !reg_val) {
-		adapter->state = __IAVF_RESETTING;
-		adapter->flags |= IAVF_FLAG_RESET_PENDING;
-		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
-		schedule_work(&adapter->reset_task);
-		adapter->aq_required = 0;
-		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		goto watchdog_done;
-	}
-
-	/* Process admin queue tasks. After init, everything gets done
-	 * here so we don't race on the admin queue.
-	 */
-	if (adapter->current_op) {
-		if (!iavf_asq_done(hw)) {
-			dev_dbg(&adapter->pdev->dev, "Admin queue timeout\n");
-			iavf_send_api_ver(adapter);
-		}
-		goto watchdog_done;
-	}
-	if (adapter->aq_required & IAVF_FLAG_AQ_GET_CONFIG) {
-		iavf_send_vf_config_msg(adapter);
-		goto watchdog_done;
-	}
-
+	if (adapter->aq_required & IAVF_FLAG_AQ_GET_CONFIG)
+		return iavf_send_vf_config_msg(adapter);
 	if (adapter->aq_required & IAVF_FLAG_AQ_DISABLE_QUEUES) {
 		iavf_disable_queues(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_MAP_VECTORS) {
 		iavf_map_queues(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_MAC_FILTER) {
 		iavf_add_ether_addrs(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_VLAN_FILTER) {
 		iavf_add_vlans(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_MAC_FILTER) {
 		iavf_del_ether_addrs(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_VLAN_FILTER) {
 		iavf_del_vlans(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_ENABLE_VLAN_STRIPPING) {
 		iavf_enable_vlan_stripping(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_DISABLE_VLAN_STRIPPING) {
 		iavf_disable_vlan_stripping(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_CONFIGURE_QUEUES) {
 		iavf_configure_queues(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_ENABLE_QUEUES) {
 		iavf_enable_queues(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_CONFIGURE_RSS) {
@@ -1670,68 +1613,138 @@ static void iavf_watchdog_task(struct work_struct *work)
 		 * PF, so we don't have to set current_op as we will
 		 * not get a response through the ARQ.
 		 */
-		iavf_init_rss(adapter);
 		adapter->aq_required &= ~IAVF_FLAG_AQ_CONFIGURE_RSS;
-		goto watchdog_done;
+		return 0;
 	}
 	if (adapter->aq_required & IAVF_FLAG_AQ_GET_HENA) {
 		iavf_get_hena(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 	if (adapter->aq_required & IAVF_FLAG_AQ_SET_HENA) {
 		iavf_set_hena(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 	if (adapter->aq_required & IAVF_FLAG_AQ_SET_RSS_KEY) {
 		iavf_set_rss_key(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 	if (adapter->aq_required & IAVF_FLAG_AQ_SET_RSS_LUT) {
 		iavf_set_rss_lut(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_REQUEST_PROMISC) {
 		iavf_set_promiscuous(adapter, FLAG_VF_UNICAST_PROMISC |
 				       FLAG_VF_MULTICAST_PROMISC);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_REQUEST_ALLMULTI) {
 		iavf_set_promiscuous(adapter, FLAG_VF_MULTICAST_PROMISC);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if ((adapter->aq_required & IAVF_FLAG_AQ_RELEASE_PROMISC) &&
 	    (adapter->aq_required & IAVF_FLAG_AQ_RELEASE_ALLMULTI)) {
 		iavf_set_promiscuous(adapter, 0);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_ENABLE_CHANNELS) {
 		iavf_enable_channels(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_DISABLE_CHANNELS) {
 		iavf_disable_channels(adapter);
-		goto watchdog_done;
+		return 0;
 	}
-
 	if (adapter->aq_required & IAVF_FLAG_AQ_ADD_CLOUD_FILTER) {
 		iavf_add_cloud_filter(adapter);
-		goto watchdog_done;
+		return 0;
 	}
 
 	if (adapter->aq_required & IAVF_FLAG_AQ_DEL_CLOUD_FILTER) {
 		iavf_del_cloud_filter(adapter);
+		return 0;
+	}
+
+	return -EAGAIN;
+}
+
+/**
+ * iavf_watchdog_task - Periodic call-back task
+ * @work: pointer to work_struct
+ **/
+static void iavf_watchdog_task(struct work_struct *work)
+{
+	struct iavf_adapter *adapter = container_of(work,
+						    struct iavf_adapter,
+						    watchdog_task);
+	struct iavf_hw *hw = &adapter->hw;
+	u32 reg_val;
+
+	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
+		goto restart_watchdog;
+
+	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) {
+		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
+			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
+		if (reg_val == VIRTCHNL_VFR_VFACTIVE ||
+		    reg_val == VIRTCHNL_VFR_COMPLETED) {
+			/* A chance for redemption! */
+			dev_err(&adapter->pdev->dev, "Hardware came out of reset. Attemptingreinit.\n");
+			adapter->state = __IAVF_STARTUP;
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
+			schedule_delayed_work(&adapter->init_task, 10);
+			clear_bit(__IAVF_IN_CRITICAL_TASK,
+				  &adapter->crit_section);
+			/* Don't reschedule the watchdog, since we've restarted
+			 * the init task. When init_task contacts the PF and
+			 * gets everything set up again, it'll restart the
+			 * watchdog for us. Down, boy. Sit. Stay. Woof.
+			 */
+			return;
+		}
+		adapter->aq_required = 0;
+		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		goto watchdog_done;
 	}
 
-	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
+	if (adapter->state < __IAVF_DOWN ||
+	    (adapter->flags & IAVF_FLAG_RESET_PENDING))
+		goto watchdog_done;
 
-	if (adapter->state == __IAVF_RUNNING)
+	/* check for reset */
+	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
+	if (!(adapter->flags & IAVF_FLAG_RESET_PENDING) && !reg_val) {
+		adapter->state = __IAVF_RESETTING;
+		adapter->flags |= IAVF_FLAG_RESET_PENDING;
+		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
+		schedule_work(&adapter->reset_task);
+		adapter->aq_required = 0;
+		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		goto watchdog_done;
+	}
+
+	/* Process admin queue tasks. After init, everything gets done
+	 * here so we don't race on the admin queue.
+	 * The check is made against -EAGAIN, as it's the error code that
+	 * would be returned on no op to run. Failures of called functions
+	 * return other values.
+	 */
+	if (adapter->current_op) {
+		if (!iavf_asq_done(hw)) {
+			dev_dbg(&adapter->pdev->dev, "Admin queue timeout\n");
+			iavf_send_api_ver(adapter);
+		}
+	} else if (iavf_process_aq_command(adapter) == -EAGAIN &&
+		   adapter->state == __IAVF_RUNNING) {
 		iavf_request_stats(adapter);
+	}
+
+	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
+
 watchdog_done:
 	if (adapter->state == __IAVF_RUNNING)
 		iavf_detect_recover_hung(&adapter->vsi);
-- 
2.21.0

