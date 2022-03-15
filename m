Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077DD4D9213
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiCOBNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbiCOBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5CD46B05
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306698; x=1678842698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1seUNlXtRwg+alYnGwU0zNdTt9DJGURrbEiKgRI2Kk0=;
  b=OevmIkGqMyfDBbR+ZQeKY7yBPaS0EXSVTQiZCQ8Yx6yzeNSJadd8JGlb
   o8bEtJrH3BGrDxuHtAWrjjHuoNCvjVowKiB0AufaFYpUssowkRitIzJx+
   5h4CFgfFtDaLK7lM7jLD2QtXFGeHOqCXnngXDX+OwYqS0I+/E8QH+4rWb
   t1MJxLdCdA06505s1lnftiK2nm4kQRcmzz3XCLFXASCAukDUAkF5PG/Iu
   I7OCRhwYuJEWYDH1t5z9XLpxHj6OglfgOKakR3s4HR77B2FIf1vp9XYMx
   AOzAJJ/6O/Wwb+DiA9yDuS+xrQU0O7NpfcHOWYUMzFLqpMryWCBMQoXQ8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256375080"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256375080"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222886"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next v2 04/11] ice: convert vf->vc_ops to a const pointer
Date:   Mon, 14 Mar 2022 18:11:48 -0700
Message-Id: <20220315011155.2166817-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The vc_ops structure is used to allow different handlers for virtchnl
commands when the driver is in representor mode. The current
implementation uses a copy of the ops table in each VF, and modifies
this copy dynamically.

The usual practice in kernel code is to store the ops table in a
constant structure and point to different versions. This has a number of
advantages:

  1. Reduced memory usage. Each VF merely points to the correct table,
     so they're able to re-use the same constant lookup table in memory.
  2. Consistency. It becomes more difficult to accidentally update or
     edit only one op call. Instead, the code switches to the correct
     able by a single pointer write. In general this is atomic, either
     the pointer is updated or its not.
  3. Code Layout. The VF structure can store a pointer to the table
     without needing to have the full structure definition defined prior
     to the VF structure definition. This will aid in future refactoring
     of code by allowing the VF pointer to be kept in ice_vf_lib.h while
     the virtchnl ops table can be maintained in ice_virtchnl.h

There is one major downside in the case of the vc_ops structure. Most of
the operations in the table are the same between the two current
implementations. This can appear to lead to duplication since each
implementation must now fill in the complete table. It could make
spotting the differences in the representor mode more challenging.
Unfortunately, methods to make this less error prone either add
complexity overhead (macros using CPP token concatenation) or don't work
on all compilers we support (constant initializer from another constant
structure).

The cost of maintaining two structures does not out weigh the benefits
of the constant table model.

While we're making these changes, go ahead and rename the structure and
implementations with "virtchnl" instead of "vc_vf_". This will more
closely align with the planned file renaming, and avoid similar names when
we later introduce a "vf ops" table for separating Scalable IOV and
Single Root IOV implementations.

Leave the accessor/assignment functions in order to avoid issues with
compiling with options disabled. The interface makes it easier to handle
when CONFIG_PCI_IOV is disabled in the kernel.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_repr.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c | 61 +++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_sriov.h | 13 +++--
 3 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index e0be27657569..848f2adea563 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -339,7 +339,7 @@ static int ice_repr_add(struct ice_vf *vf)
 
 	devlink_port_type_eth_set(&vf->devlink_port, repr->netdev);
 
-	ice_vc_change_ops_to_repr(&vf->vc_ops);
+	ice_virtchnl_set_repr_ops(vf);
 
 	return 0;
 
@@ -384,7 +384,7 @@ static void ice_repr_rem(struct ice_vf *vf)
 	kfree(vf->repr);
 	vf->repr = NULL;
 
-	ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+	ice_virtchnl_set_dflt_ops(vf);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 45fe36db076a..8578317ceb8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -2023,7 +2023,7 @@ static int ice_create_vf_entries(struct ice_pf *pf, u16 num_vfs)
 		ice_vf_ctrl_invalidate_vsi(vf);
 		ice_vf_fdir_init(vf);
 
-		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+		ice_virtchnl_set_dflt_ops(vf);
 
 		mutex_init(&vf->cfg_lock);
 
@@ -5672,7 +5672,7 @@ static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2, v_ret, NULL, 0);
 }
 
-static struct ice_vc_vf_ops ice_vc_vf_dflt_ops = {
+static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
 	.get_ver_msg = ice_vc_get_ver_msg,
 	.get_vf_res_msg = ice_vc_get_vf_res_msg,
 	.reset_vf = ice_vc_reset_vf_msg,
@@ -5703,9 +5703,13 @@ static struct ice_vc_vf_ops ice_vc_vf_dflt_ops = {
 	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
 };
 
-void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops)
+/**
+ * ice_virtchnl_set_dflt_ops - Switch to default virtchnl ops
+ * @vf: the VF to switch ops
+ */
+void ice_virtchnl_set_dflt_ops(struct ice_vf *vf)
 {
-	*ops = ice_vc_vf_dflt_ops;
+	vf->virtchnl_ops = &ice_virtchnl_dflt_ops;
 }
 
 /**
@@ -5838,15 +5842,44 @@ ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
 				     NULL, 0);
 }
 
-void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops)
+static const struct ice_virtchnl_ops ice_virtchnl_repr_ops = {
+	.get_ver_msg = ice_vc_get_ver_msg,
+	.get_vf_res_msg = ice_vc_get_vf_res_msg,
+	.reset_vf = ice_vc_reset_vf_msg,
+	.add_mac_addr_msg = ice_vc_repr_add_mac,
+	.del_mac_addr_msg = ice_vc_repr_del_mac,
+	.cfg_qs_msg = ice_vc_cfg_qs_msg,
+	.ena_qs_msg = ice_vc_ena_qs_msg,
+	.dis_qs_msg = ice_vc_dis_qs_msg,
+	.request_qs_msg = ice_vc_request_qs_msg,
+	.cfg_irq_map_msg = ice_vc_cfg_irq_map_msg,
+	.config_rss_key = ice_vc_config_rss_key,
+	.config_rss_lut = ice_vc_config_rss_lut,
+	.get_stats_msg = ice_vc_get_stats_msg,
+	.cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode,
+	.add_vlan_msg = ice_vc_repr_add_vlan,
+	.remove_vlan_msg = ice_vc_repr_del_vlan,
+	.ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping,
+	.dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping,
+	.handle_rss_cfg_msg = ice_vc_handle_rss_cfg,
+	.add_fdir_fltr_msg = ice_vc_add_fdir_fltr,
+	.del_fdir_fltr_msg = ice_vc_del_fdir_fltr,
+	.get_offload_vlan_v2_caps = ice_vc_get_offload_vlan_v2_caps,
+	.add_vlan_v2_msg = ice_vc_add_vlan_v2_msg,
+	.remove_vlan_v2_msg = ice_vc_remove_vlan_v2_msg,
+	.ena_vlan_stripping_v2_msg = ice_vc_ena_vlan_stripping_v2_msg,
+	.dis_vlan_stripping_v2_msg = ice_vc_dis_vlan_stripping_v2_msg,
+	.ena_vlan_insertion_v2_msg = ice_vc_ena_vlan_insertion_v2_msg,
+	.dis_vlan_insertion_v2_msg = ice_vc_dis_vlan_insertion_v2_msg,
+};
+
+/**
+ * ice_virtchnl_set_repr_ops - Switch to representor virtchnl ops
+ * @vf: the VF to switch ops
+ */
+void ice_virtchnl_set_repr_ops(struct ice_vf *vf)
 {
-	ops->add_mac_addr_msg = ice_vc_repr_add_mac;
-	ops->del_mac_addr_msg = ice_vc_repr_del_mac;
-	ops->add_vlan_msg = ice_vc_repr_add_vlan;
-	ops->remove_vlan_msg = ice_vc_repr_del_vlan;
-	ops->ena_vlan_stripping = ice_vc_repr_ena_vlan_stripping;
-	ops->dis_vlan_stripping = ice_vc_repr_dis_vlan_stripping;
-	ops->cfg_promiscuous_mode_msg = ice_vc_repr_cfg_promiscuous_mode;
+	vf->virtchnl_ops = &ice_virtchnl_repr_ops;
 }
 
 /**
@@ -5861,8 +5894,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 {
 	u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
 	s16 vf_id = le16_to_cpu(event->desc.retval);
+	const struct ice_virtchnl_ops *ops;
 	u16 msglen = event->msg_len;
-	struct ice_vc_vf_ops *ops;
 	u8 *msg = event->msg_buf;
 	struct ice_vf *vf = NULL;
 	struct device *dev;
@@ -5883,7 +5916,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		goto error_handler;
 	}
 
-	ops = &vf->vc_ops;
+	ops = vf->virtchnl_ops;
 
 	/* Perform basic checks on the msg */
 	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index a5ef3c46953a..b6951d718592 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -113,7 +113,7 @@ struct ice_mdd_vf_events {
 
 struct ice_vf;
 
-struct ice_vc_vf_ops {
+struct ice_virtchnl_ops {
 	int (*get_ver_msg)(struct ice_vf *vf, u8 *msg);
 	int (*get_vf_res_msg)(struct ice_vf *vf, u8 *msg);
 	void (*reset_vf)(struct ice_vf *vf);
@@ -206,8 +206,7 @@ struct ice_vf {
 	DECLARE_BITMAP(opcodes_allowlist, VIRTCHNL_OP_MAX);
 
 	struct ice_repr *repr;
-
-	struct ice_vc_vf_ops vc_ops;
+	const struct ice_virtchnl_ops *virtchnl_ops;
 
 	/* devlink port data */
 	struct devlink_port devlink_port;
@@ -230,8 +229,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_vc_notify_link_state(struct ice_pf *pf);
 void ice_vc_notify_reset(struct ice_pf *pf);
 void ice_vc_notify_vf_link_state(struct ice_vf *vf);
-void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops);
-void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops);
+void ice_virtchnl_set_repr_ops(struct ice_vf *vf);
+void ice_virtchnl_set_dflt_ops(struct ice_vf *vf);
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
@@ -303,8 +302,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event) {
 static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
 static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
 static inline void ice_vc_notify_vf_link_state(struct ice_vf *vf) { }
-static inline void ice_vc_change_ops_to_repr(struct ice_vc_vf_ops *ops) { }
-static inline void ice_vc_set_dflt_vf_ops(struct ice_vc_vf_ops *ops) { }
+static inline void ice_virtchnl_set_repr_ops(struct ice_vf *vf) { }
+static inline void ice_virtchnl_set_dflt_ops(struct ice_vf *vf) { }
 static inline void ice_set_vf_state_qs_dis(struct ice_vf *vf) { }
 static inline
 void ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event) { }
-- 
2.31.1

