Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E3E6B8072
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCMS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjCMSZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:26 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323E97F00D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731923; x=1710267923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=46Kgob49wnfXtbKGcniJ3FXl565axVdxOAKetEm4frk=;
  b=Q/HOz8WWLZzSNbORV6EUmfsdvzVVzapiDOdFlniX6/0u9xRlkzeqr/4E
   KaRmxwpbQixt6SJ17xMFx0AJaluWKAeanCPvFVZeVTppKcY/ZRftk7OSp
   Z32jkFXGS8V6n1vSGDk8MN4yt89sUztwUQSBf+hUyT3tG9v5057vZMtSg
   HifqjnZj9KQgDNs6aKPnY9xg4497l+Y+YWtYZJcQKWHR1zA7a4/dkkv3Q
   z6qKk2LhvzbJxYp+LYkVJT3/VuEKjDgFXQO7VNEZRpNSwMAuWAe1tZv/P
   e4S7mwVNTLCN2Q/jIRAUgccb+w6LN92IRyQedj4wQ0hAidAgWy6jBlEu3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772405"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772405"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809112"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809112"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 11/14] ice: pass mbxdata to ice_is_malicious_vf()
Date:   Mon, 13 Mar 2023 11:21:20 -0700
Message-Id: <20230313182123.483057-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_is_malicious_vf() function takes information about the current
state of the mailbox during a single interrupt. This information includes
the number of messages processed so far, as well as the number of pending
messages not yet processed.

A future refactor is going to make ice_vc_process_vf_msg() call
ice_is_malicious_vf() instead of having it called separately in ice_main.c
This change will require passing all the necessary arguments into
ice_vc_process_vf_msg().

To make this simpler, have the main loop fill in the struct ice_mbx_data
and pass that rather than passing in the num_msg_proc and num_msg_pending.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c  | 10 +++++++++-
 drivers/net/ethernet/intel/ice/ice_sriov.c | 14 +++-----------
 drivers/net/ethernet/intel/ice/ice_sriov.h |  5 ++---
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 615a731d7afe..a7e7a186009e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1393,6 +1393,8 @@ static void ice_aq_cancel_waiting_tasks(struct ice_pf *pf)
 	wake_up(&pf->aq_wait_queue);
 }
 
+#define ICE_MBX_OVERFLOW_WATERMARK 64
+
 /**
  * __ice_clean_ctrlq - helper function to clean controlq rings
  * @pf: ptr to struct ice_pf
@@ -1483,6 +1485,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		return 0;
 
 	do {
+		struct ice_mbx_data data = {};
 		u16 opcode;
 		int ret;
 
@@ -1509,7 +1512,12 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			ice_vf_lan_overflow_event(pf, &event);
 			break;
 		case ice_mbx_opc_send_msg_to_pf:
-			if (!ice_is_malicious_vf(pf, &event, i, pending))
+			data.num_msg_proc = i;
+			data.num_pending_arq = pending;
+			data.max_num_msgs_mbx = hw->mailboxq.num_rq_entries;
+			data.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
+
+			if (!ice_is_malicious_vf(pf, &event, &data))
 				ice_vc_process_vf_msg(pf, &event);
 			break;
 		case ice_aqc_opc_fw_logging:
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 938be486721e..5ae923ea979c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1782,16 +1782,14 @@ void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
  * ice_is_malicious_vf - helper function to detect a malicious VF
  * @pf: ptr to struct ice_pf
  * @event: pointer to the AQ event
- * @num_msg_proc: the number of messages processed so far
- * @num_msg_pending: the number of messages peinding in admin queue
+ * @mbxdata: data about the state of the mailbox
  */
 bool
 ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    u16 num_msg_proc, u16 num_msg_pending)
+		    struct ice_mbx_data *mbxdata)
 {
 	s16 vf_id = le16_to_cpu(event->desc.retval);
 	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_mbx_data mbxdata;
 	bool report_malvf = false;
 	struct ice_vf *vf;
 	int status;
@@ -1803,14 +1801,8 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
 		goto out_put_vf;
 
-	mbxdata.num_msg_proc = num_msg_proc;
-	mbxdata.num_pending_arq = num_msg_pending;
-	mbxdata.max_num_msgs_mbx = pf->hw.mailboxq.num_rq_entries;
-#define ICE_MBX_OVERFLOW_WATERMARK 64
-	mbxdata.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
-
 	/* check to see if we have a newly malicious VF */
-	status = ice_mbx_vf_state_handler(&pf->hw, &mbxdata, &vf->mbx_info,
+	status = ice_mbx_vf_state_handler(&pf->hw, mbxdata, &vf->mbx_info,
 					  &report_malvf);
 	if (status)
 		goto out_put_vf;
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 1082b0691a3f..8fa61d954fae 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -36,7 +36,7 @@ void ice_free_vfs(struct ice_pf *pf);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
 bool
 ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    u16 num_msg_proc, u16 num_msg_pending);
+		    struct ice_mbx_data *mbxdata);
 
 int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
@@ -75,8 +75,7 @@ static inline void ice_restore_all_vfs_msi_state(struct pci_dev *pdev) { }
 static inline bool
 ice_is_malicious_vf(struct ice_pf __always_unused *pf,
 		    struct ice_rq_event_info __always_unused *event,
-		    u16 __always_unused num_msg_proc,
-		    u16 __always_unused num_msg_pending)
+		    struct ice_mbx_data *mbxdata)
 {
 	return false;
 }
-- 
2.38.1

