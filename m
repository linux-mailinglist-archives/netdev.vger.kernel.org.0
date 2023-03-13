Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073196B8073
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjCMS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCMSZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C777FD59
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731924; x=1710267924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D5QKPhVVSIL2DjCBHkGEFh+b5OVMAsA7jpADZCCOXqU=;
  b=JfDD5LRd2/dCu5uIGvX0RjVLj9Ms2rxS1GbYX8hVncqth3SudqwCBNcG
   K1/HMRGp81Td1QLBgBlT4OGn8FjZCsjyWj1oTHMtWBrs+GeBx8mC9KGlp
   4kNKdpHSp8VJowF/UkbEjlkqXcM5a60ySXFBsgH+nWXT4tdEMtMtf5pfM
   SJj7DZ+yUHwAnjQH2vD/7hSv/9F9FiNrQqDUxh9EdJhfi/91Brmm4In1x
   AAVXOh18B+2VN8iOFUu+MTn3cVIlR4hhXwjRu7p4luU3+jlLlhmihqfHK
   cUYHvTLAOkj5oBsLLHPrvm3Q6ZQjGcZi6F+cBR0R0HT/o+MW2eChnDews
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772422"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772422"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809129"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809129"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 13/14] ice: move ice_is_malicious_vf() to ice_virtchnl.c
Date:   Mon, 13 Mar 2023 11:21:22 -0700
Message-Id: <20230313182123.483057-14-anthony.l.nguyen@intel.com>
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

The ice_is_malicious_vf() function is currently implemented in ice_sriov.c
This function is not Single Root specific, and a future change is going to
refactor the ice_vc_process_vf_msg() function to call this instead of
calling it before ice_vc_process_vf_msg() in the main loop of
__ice_clean_ctrlq.

To make that change easier to review, first move this function into
ice_virtchnl.c but leave the call in __ice_clean_ctrlq() alone.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 45 -------------------
 drivers/net/ethernet/intel/ice/ice_sriov.h    | 11 -----
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 45 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl.h | 11 +++++
 4 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index f0daeda236de..6fa62c3cedb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1777,48 +1777,3 @@ void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
 		}
 	}
 }
-
-/**
- * ice_is_malicious_vf - helper function to detect a malicious VF
- * @pf: ptr to struct ice_pf
- * @event: pointer to the AQ event
- * @mbxdata: data about the state of the mailbox
- */
-bool
-ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    struct ice_mbx_data *mbxdata)
-{
-	s16 vf_id = le16_to_cpu(event->desc.retval);
-	struct device *dev = ice_pf_to_dev(pf);
-	bool report_malvf = false;
-	struct ice_vf *vf;
-	int status;
-
-	vf = ice_get_vf_by_id(pf, vf_id);
-	if (!vf)
-		return false;
-
-	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
-		goto out_put_vf;
-
-	/* check to see if we have a newly malicious VF */
-	status = ice_mbx_vf_state_handler(&pf->hw, mbxdata, &vf->mbx_info,
-					  &report_malvf);
-	if (status)
-		dev_warn_ratelimited(dev, "Unable to check status of mailbox overflow for VF %u MAC %pM, status %d\n",
-				     vf->vf_id, vf->dev_lan_addr, status);
-
-	if (report_malvf) {
-		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-		u8 zero_addr[ETH_ALEN] = {};
-
-		dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-			 vf->dev_lan_addr,
-			 pf_vsi ? pf_vsi->netdev->dev_addr : zero_addr);
-	}
-
-out_put_vf:
-	ice_put_vf(vf);
-
-	return vf->mbx_info.malicious;
-}
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 8fa61d954fae..346cb2666f3a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -34,9 +34,6 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi);
 
 void ice_free_vfs(struct ice_pf *pf);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
-bool
-ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
-		    struct ice_mbx_data *mbxdata);
 
 int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
@@ -72,14 +69,6 @@ static inline void ice_print_vfs_mdd_events(struct ice_pf *pf) { }
 static inline void ice_print_vf_rx_mdd_event(struct ice_vf *vf) { }
 static inline void ice_restore_all_vfs_msi_state(struct pci_dev *pdev) { }
 
-static inline bool
-ice_is_malicious_vf(struct ice_pf __always_unused *pf,
-		    struct ice_rq_event_info __always_unused *event,
-		    struct ice_mbx_data *mbxdata)
-{
-	return false;
-}
-
 static inline int
 ice_sriov_configure(struct pci_dev __always_unused *pdev,
 		    int __always_unused num_vfs)
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index e24e3f5017ca..e0c573d9d1b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3833,6 +3833,51 @@ void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
 	vf->virtchnl_ops = &ice_virtchnl_repr_ops;
 }
 
+/**
+ * ice_is_malicious_vf - helper function to detect a malicious VF
+ * @pf: ptr to struct ice_pf
+ * @event: pointer to the AQ event
+ * @mbxdata: data about the state of the mailbox
+ */
+bool
+ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
+		    struct ice_mbx_data *mbxdata)
+{
+	s16 vf_id = le16_to_cpu(event->desc.retval);
+	struct device *dev = ice_pf_to_dev(pf);
+	bool report_malvf = false;
+	struct ice_vf *vf;
+	int status;
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return false;
+
+	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
+		goto out_put_vf;
+
+	/* check to see if we have a newly malicious VF */
+	status = ice_mbx_vf_state_handler(&pf->hw, mbxdata, &vf->mbx_info,
+					  &report_malvf);
+	if (status)
+		dev_warn_ratelimited(dev, "Unable to check status of mailbox overflow for VF %u MAC %pM, status %d\n",
+				     vf->vf_id, vf->dev_lan_addr, status);
+
+	if (report_malvf) {
+		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
+		u8 zero_addr[ETH_ALEN] = {};
+
+		dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
+			 vf->dev_lan_addr,
+			 pf_vsi ? pf_vsi->netdev->dev_addr : zero_addr);
+	}
+
+out_put_vf:
+	ice_put_vf(vf);
+
+	return vf->mbx_info.malicious;
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index 6d5af29c855e..648a383fad85 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -63,6 +63,9 @@ int
 ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 		      enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
+bool
+ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
+		    struct ice_mbx_data *mbxdata);
 void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 #else /* CONFIG_PCI_IOV */
 static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
@@ -83,6 +86,14 @@ static inline bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 	return false;
 }
 
+static inline bool
+ice_is_malicious_vf(struct ice_pf __always_unused *pf,
+		    struct ice_rq_event_info __always_unused *event,
+		    struct ice_mbx_data *mbxdata)
+{
+	return false;
+}
+
 static inline void
 ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 {
-- 
2.38.1

