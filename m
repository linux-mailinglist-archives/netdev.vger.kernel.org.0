Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD10F3450DC
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhCVUcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:5512 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhCVUbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:23 -0400
IronPort-SDR: XhVn/qUCdXqhI9D5BAAlAduTIAudhxnC0ELqbtYTq0i5VPL945RDi2x4r5ILVc/WSkBuraIW7K
 8VQhK1iyV8WA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438222"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438222"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: UhV/+1nPjAMnnotJA4UmCYQnjWff5mn/zieXOVhAAZng9Hvjd4bUZduPoy675X3jGDgy0MKGiA
 KTGszWuhHrCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810618"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, Yahui Cao <yahui.cao@intel.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 13/18] ice: Check FDIR program status for AVF
Date:   Mon, 22 Mar 2021 13:32:39 -0700
Message-Id: <20210322203244.2525310-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

Enable returning FDIR completion status by checking the
ctrl_vsi Rx queue descriptor value.

To enable returning FDIR completion status from ctrl_vsi Rx queue,
COMP_Queue and COMP_Report of FDIR filter programming descriptor
needs to be properly configured. After program request sent to ctrl_vsi
Tx queue, ctrl_vsi Rx queue interrupt will be triggered and
completion status will be returned.

Driver will first issue request in ice_vc_fdir_add_fltr(), then
pass FDIR context to the background task in interrupt service routine
ice_vc_fdir_irq_handler() and finally deal with them in
ice_flush_fdir_ctx(). ice_flush_fdir_ctx() will check the descriptor's
value, fdir context, and then send back virtual channel message to VF
by calling ice_vc_add_fdir_fltr_post(). An additional timer will be
setup in case of hardware interrupt timeout.

Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  20 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   5 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 493 +++++++++++++++++-
 .../ethernet/intel/ice/ice_virtchnl_fdir.h    |  33 +-
 7 files changed, 541 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7b45f2ab4036..9bf346133cbd 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -231,6 +231,7 @@ enum ice_state {
 	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
 	__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 	__ICE_PHY_INIT_COMPLETE,
+	__ICE_FD_VF_FLUSH_CTX,		/* set at FD Rx IRQ or timeout */
 	__ICE_STATE_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index a778e373eff1..67b5b9b9d009 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -384,6 +384,9 @@
 #define VSIQF_FD_CNT(_VSI)			(0x00464000 + ((_VSI) * 4))
 #define VSIQF_FD_CNT_FD_GCNT_S			0
 #define VSIQF_FD_CNT_FD_GCNT_M			ICE_M(0x3FFF, 0)
+#define VSIQF_FD_CNT_FD_BCNT_S			16
+#define VSIQF_FD_CNT_FD_BCNT_M			ICE_M(0x3FFF, 16)
+#define VSIQF_FD_SIZE(_VSI)			(0x00462000 + ((_VSI) * 4))
 #define VSIQF_HKEY_MAX_INDEX			12
 #define VSIQF_HLUT_MAX_INDEX			15
 #define PFPM_APM				0x000B8080
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index b30c22358c0a..21329ed3087e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -140,6 +140,26 @@ struct ice_fltr_desc {
 			(0xFFFFFFFFULL << ICE_FXD_FLTR_QW1_FDID_S)
 #define ICE_FXD_FLTR_QW1_FDID_ZERO	0x0ULL
 
+/* definition for FD filter programming status descriptor WB format */
+#define ICE_FXD_FLTR_WB_QW1_DD_S	0
+#define ICE_FXD_FLTR_WB_QW1_DD_M	(0x1ULL << ICE_FXD_FLTR_WB_QW1_DD_S)
+#define ICE_FXD_FLTR_WB_QW1_DD_YES	0x1ULL
+
+#define ICE_FXD_FLTR_WB_QW1_PROG_ID_S	1
+#define ICE_FXD_FLTR_WB_QW1_PROG_ID_M	\
+				(0x3ULL << ICE_FXD_FLTR_WB_QW1_PROG_ID_S)
+#define ICE_FXD_FLTR_WB_QW1_PROG_ADD	0x0ULL
+#define ICE_FXD_FLTR_WB_QW1_PROG_DEL	0x1ULL
+
+#define ICE_FXD_FLTR_WB_QW1_FAIL_S	4
+#define ICE_FXD_FLTR_WB_QW1_FAIL_M	(0x1ULL << ICE_FXD_FLTR_WB_QW1_FAIL_S)
+#define ICE_FXD_FLTR_WB_QW1_FAIL_YES	0x1ULL
+
+#define ICE_FXD_FLTR_WB_QW1_FAIL_PROF_S	5
+#define ICE_FXD_FLTR_WB_QW1_FAIL_PROF_M	\
+				(0x1ULL << ICE_FXD_FLTR_WB_QW1_FAIL_PROF_S)
+#define ICE_FXD_FLTR_WB_QW1_FAIL_PROF_YES	0x1ULL
+
 struct ice_rx_ptype_decoded {
 	u32 ptype:10;
 	u32 known:1;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9cb5e653b38d..eb895e6db077 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2071,6 +2071,7 @@ static void ice_service_task(struct work_struct *work)
 	ice_process_vflr_event(pf);
 	ice_clean_mailboxq_subtask(pf);
 	ice_sync_arfs_fltrs(pf);
+	ice_flush_fdir_ctx(pf);
 	/* Clear __ICE_SERVICE_SCHED flag to allow scheduling next event */
 	ice_service_task_complete(pf);
 
@@ -2082,6 +2083,7 @@ static void ice_service_task(struct work_struct *work)
 	    test_bit(__ICE_MDD_EVENT_PENDING, pf->state) ||
 	    test_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
 	    test_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state) ||
+	    test_bit(__ICE_FD_VF_FLUSH_CTX, pf->state) ||
 	    test_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state))
 		mod_timer(&pf->serv_tmr, jiffies);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b7dc25da1202..6d87dd9d456e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1115,6 +1115,11 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		dma_rmb();
 
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
+			struct ice_vsi *ctrl_vsi = rx_ring->vsi;
+
+			if (rx_desc->wb.rxdid == FDIR_DESC_RXDID &&
+			    ctrl_vsi->vf_id != ICE_INVAL_VFID)
+				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
 			ice_put_rx_buf(rx_ring, NULL, 0);
 			cleaned_count++;
 			continue;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index f49947d3df37..1f4ba38b1599 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -44,6 +44,7 @@ struct virtchnl_fdir_fltr_conf {
 	struct ice_fdir_fltr input;
 	enum ice_fdir_tunnel_type ttype;
 	u64 inset_flag;
+	u32 flow_id;
 };
 
 static enum virtchnl_proto_hdr_type vc_pattern_ether[] = {
@@ -1483,7 +1484,7 @@ static int ice_vc_fdir_write_fltr(struct ice_vf *vf,
 	}
 
 	input->dest_vsi = vsi->idx;
-	input->comp_report = ICE_FXD_FLTR_QW0_COMP_REPORT_SW_FAIL;
+	input->comp_report = ICE_FXD_FLTR_QW0_COMP_REPORT_SW;
 
 	ctrl_vsi = pf->vsi[vf->ctrl_vsi_idx];
 	if (!ctrl_vsi) {
@@ -1515,6 +1516,454 @@ static int ice_vc_fdir_write_fltr(struct ice_vf *vf,
 	return ret;
 }
 
+/**
+ * ice_vf_fdir_timer - FDIR program waiting timer interrupt handler
+ * @t: pointer to timer_list
+ */
+static void ice_vf_fdir_timer(struct timer_list *t)
+{
+	struct ice_vf_fdir_ctx *ctx_irq = from_timer(ctx_irq, t, rx_tmr);
+	struct ice_vf_fdir_ctx *ctx_done;
+	struct ice_vf_fdir *fdir;
+	unsigned long flags;
+	struct ice_vf *vf;
+	struct ice_pf *pf;
+
+	fdir = container_of(ctx_irq, struct ice_vf_fdir, ctx_irq);
+	vf = container_of(fdir, struct ice_vf, fdir);
+	ctx_done = &fdir->ctx_done;
+	pf = vf->pf;
+	spin_lock_irqsave(&fdir->ctx_lock, flags);
+	if (!(ctx_irq->flags & ICE_VF_FDIR_CTX_VALID)) {
+		spin_unlock_irqrestore(&fdir->ctx_lock, flags);
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	ctx_irq->flags &= ~ICE_VF_FDIR_CTX_VALID;
+
+	ctx_done->flags |= ICE_VF_FDIR_CTX_VALID;
+	ctx_done->conf = ctx_irq->conf;
+	ctx_done->stat = ICE_FDIR_CTX_TIMEOUT;
+	ctx_done->v_opcode = ctx_irq->v_opcode;
+	spin_unlock_irqrestore(&fdir->ctx_lock, flags);
+
+	set_bit(__ICE_FD_VF_FLUSH_CTX, pf->state);
+	ice_service_task_schedule(pf);
+}
+
+/**
+ * ice_vc_fdir_irq_handler - ctrl_vsi Rx queue interrupt handler
+ * @ctrl_vsi: pointer to a VF's CTRL VSI
+ * @rx_desc: pointer to FDIR Rx queue descriptor
+ */
+void
+ice_vc_fdir_irq_handler(struct ice_vsi *ctrl_vsi,
+			union ice_32b_rx_flex_desc *rx_desc)
+{
+	struct ice_pf *pf = ctrl_vsi->back;
+	struct ice_vf_fdir_ctx *ctx_done;
+	struct ice_vf_fdir_ctx *ctx_irq;
+	struct ice_vf_fdir *fdir;
+	unsigned long flags;
+	struct device *dev;
+	struct ice_vf *vf;
+	int ret;
+
+	vf = &pf->vf[ctrl_vsi->vf_id];
+
+	fdir = &vf->fdir;
+	ctx_done = &fdir->ctx_done;
+	ctx_irq = &fdir->ctx_irq;
+	dev = ice_pf_to_dev(pf);
+	spin_lock_irqsave(&fdir->ctx_lock, flags);
+	if (!(ctx_irq->flags & ICE_VF_FDIR_CTX_VALID)) {
+		spin_unlock_irqrestore(&fdir->ctx_lock, flags);
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	ctx_irq->flags &= ~ICE_VF_FDIR_CTX_VALID;
+
+	ctx_done->flags |= ICE_VF_FDIR_CTX_VALID;
+	ctx_done->conf = ctx_irq->conf;
+	ctx_done->stat = ICE_FDIR_CTX_IRQ;
+	ctx_done->v_opcode = ctx_irq->v_opcode;
+	memcpy(&ctx_done->rx_desc, rx_desc, sizeof(*rx_desc));
+	spin_unlock_irqrestore(&fdir->ctx_lock, flags);
+
+	ret = del_timer(&ctx_irq->rx_tmr);
+	if (!ret)
+		dev_err(dev, "VF %d: Unexpected inactive timer!\n", vf->vf_id);
+
+	set_bit(__ICE_FD_VF_FLUSH_CTX, pf->state);
+	ice_service_task_schedule(pf);
+}
+
+/**
+ * ice_vf_fdir_dump_info - dump FDIR information for diagnosis
+ * @vf: pointer to the VF info
+ */
+static void ice_vf_fdir_dump_info(struct ice_vf *vf)
+{
+	struct ice_vsi *vf_vsi;
+	u32 fd_size, fd_cnt;
+	struct device *dev;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	u16 vsi_num;
+
+	pf = vf->pf;
+	hw = &pf->hw;
+	dev = ice_pf_to_dev(pf);
+	vf_vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi_num = ice_get_hw_vsi_num(hw, vf_vsi->idx);
+
+	fd_size = rd32(hw, VSIQF_FD_SIZE(vsi_num));
+	fd_cnt = rd32(hw, VSIQF_FD_CNT(vsi_num));
+	dev_dbg(dev, "VF %d: space allocated: guar:0x%x, be:0x%x, space consumed: guar:0x%x, be:0x%x",
+		vf->vf_id,
+		(fd_size & VSIQF_FD_CNT_FD_GCNT_M) >> VSIQF_FD_CNT_FD_GCNT_S,
+		(fd_size & VSIQF_FD_CNT_FD_BCNT_M) >> VSIQF_FD_CNT_FD_BCNT_S,
+		(fd_cnt & VSIQF_FD_CNT_FD_GCNT_M) >> VSIQF_FD_CNT_FD_GCNT_S,
+		(fd_cnt & VSIQF_FD_CNT_FD_BCNT_M) >> VSIQF_FD_CNT_FD_BCNT_S);
+}
+
+/**
+ * ice_vf_verify_rx_desc - verify received FDIR programming status descriptor
+ * @vf: pointer to the VF info
+ * @ctx: FDIR context info for post processing
+ * @status: virtchnl FDIR program status
+ *
+ * Return: 0 on success, and other on error.
+ */
+static int
+ice_vf_verify_rx_desc(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
+		      enum virtchnl_fdir_prgm_status *status)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u32 stat_err, error, prog_id;
+	int ret;
+
+	stat_err = le16_to_cpu(ctx->rx_desc.wb.status_error0);
+	if (((stat_err & ICE_FXD_FLTR_WB_QW1_DD_M) >>
+	    ICE_FXD_FLTR_WB_QW1_DD_S) != ICE_FXD_FLTR_WB_QW1_DD_YES) {
+		*status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
+		dev_err(dev, "VF %d: Desc Done not set\n", vf->vf_id);
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	prog_id = (stat_err & ICE_FXD_FLTR_WB_QW1_PROG_ID_M) >>
+		ICE_FXD_FLTR_WB_QW1_PROG_ID_S;
+	if (prog_id == ICE_FXD_FLTR_WB_QW1_PROG_ADD &&
+	    ctx->v_opcode != VIRTCHNL_OP_ADD_FDIR_FILTER) {
+		dev_err(dev, "VF %d: Desc show add, but ctx not",
+			vf->vf_id);
+		*status = VIRTCHNL_FDIR_FAILURE_RULE_INVALID;
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	if (prog_id == ICE_FXD_FLTR_WB_QW1_PROG_DEL &&
+	    ctx->v_opcode != VIRTCHNL_OP_DEL_FDIR_FILTER) {
+		dev_err(dev, "VF %d: Desc show del, but ctx not",
+			vf->vf_id);
+		*status = VIRTCHNL_FDIR_FAILURE_RULE_INVALID;
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	error = (stat_err & ICE_FXD_FLTR_WB_QW1_FAIL_M) >>
+		ICE_FXD_FLTR_WB_QW1_FAIL_S;
+	if (error == ICE_FXD_FLTR_WB_QW1_FAIL_YES) {
+		if (prog_id == ICE_FXD_FLTR_WB_QW1_PROG_ADD) {
+			dev_err(dev, "VF %d, Failed to add FDIR rule due to no space in the table",
+				vf->vf_id);
+			*status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
+		} else {
+			dev_err(dev, "VF %d, Failed to remove FDIR rule, attempt to remove non-existent entry",
+				vf->vf_id);
+			*status = VIRTCHNL_FDIR_FAILURE_RULE_NONEXIST;
+		}
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	error = (stat_err & ICE_FXD_FLTR_WB_QW1_FAIL_PROF_M) >>
+		ICE_FXD_FLTR_WB_QW1_FAIL_PROF_S;
+	if (error == ICE_FXD_FLTR_WB_QW1_FAIL_PROF_YES) {
+		dev_err(dev, "VF %d: Profile matching error", vf->vf_id);
+		*status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	*status = VIRTCHNL_FDIR_SUCCESS;
+
+	return 0;
+
+err_exit:
+	ice_vf_fdir_dump_info(vf);
+	return ret;
+}
+
+/**
+ * ice_vc_add_fdir_fltr_post
+ * @vf: pointer to the VF structure
+ * @ctx: FDIR context info for post processing
+ * @status: virtchnl FDIR program status
+ * @success: true implies success, false implies failure
+ *
+ * Post process for flow director add command. If success, then do post process
+ * and send back success msg by virtchnl. Otherwise, do context reversion and
+ * send back failure msg by virtchnl.
+ *
+ * Return: 0 on success, and other on error.
+ */
+static int
+ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
+			  enum virtchnl_fdir_prgm_status status,
+			  bool success)
+{
+	struct virtchnl_fdir_fltr_conf *conf = ctx->conf;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	enum virtchnl_status_code v_ret;
+	struct virtchnl_fdir_add *resp;
+	int ret, len, is_tun;
+
+	v_ret = VIRTCHNL_STATUS_SUCCESS;
+	len = sizeof(*resp);
+	resp = kzalloc(len, GFP_KERNEL);
+	if (!resp) {
+		len = 0;
+		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		dev_dbg(dev, "VF %d: Alloc resp buf fail", vf->vf_id);
+		goto err_exit;
+	}
+
+	if (!success)
+		goto err_exit;
+
+	is_tun = 0;
+	resp->status = status;
+	resp->flow_id = conf->flow_id;
+	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
+
+	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
+				    (u8 *)resp, len);
+	kfree(resp);
+
+	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
+		vf->vf_id, conf->flow_id,
+		(ctx->v_opcode == VIRTCHNL_OP_ADD_FDIR_FILTER) ?
+		"add" : "del");
+	return ret;
+
+err_exit:
+	if (resp)
+		resp->status = status;
+	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
+	devm_kfree(dev, conf);
+
+	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
+				    (u8 *)resp, len);
+	kfree(resp);
+	return ret;
+}
+
+/**
+ * ice_vc_del_fdir_fltr_post
+ * @vf: pointer to the VF structure
+ * @ctx: FDIR context info for post processing
+ * @status: virtchnl FDIR program status
+ * @success: true implies success, false implies failure
+ *
+ * Post process for flow director del command. If success, then do post process
+ * and send back success msg by virtchnl. Otherwise, do context reversion and
+ * send back failure msg by virtchnl.
+ *
+ * Return: 0 on success, and other on error.
+ */
+static int
+ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
+			  enum virtchnl_fdir_prgm_status status,
+			  bool success)
+{
+	struct virtchnl_fdir_fltr_conf *conf = ctx->conf;
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	enum virtchnl_status_code v_ret;
+	struct virtchnl_fdir_del *resp;
+	int ret, len, is_tun;
+
+	v_ret = VIRTCHNL_STATUS_SUCCESS;
+	len = sizeof(*resp);
+	resp = kzalloc(len, GFP_KERNEL);
+	if (!resp) {
+		len = 0;
+		v_ret = VIRTCHNL_STATUS_ERR_NO_MEMORY;
+		dev_dbg(dev, "VF %d: Alloc resp buf fail", vf->vf_id);
+		goto err_exit;
+	}
+
+	if (!success)
+		goto err_exit;
+
+	is_tun = 0;
+	resp->status = status;
+	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
+	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
+
+	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
+				    (u8 *)resp, len);
+	kfree(resp);
+
+	dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
+		vf->vf_id, conf->flow_id,
+		(ctx->v_opcode == VIRTCHNL_OP_ADD_FDIR_FILTER) ?
+		"add" : "del");
+	devm_kfree(dev, conf);
+	return ret;
+
+err_exit:
+	if (resp)
+		resp->status = status;
+	if (success)
+		devm_kfree(dev, conf);
+
+	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
+				    (u8 *)resp, len);
+	kfree(resp);
+	return ret;
+}
+
+/**
+ * ice_flush_fdir_ctx
+ * @pf: pointer to the PF structure
+ *
+ * Flush all the pending event on ctx_done list and process them.
+ */
+void ice_flush_fdir_ctx(struct ice_pf *pf)
+{
+	int i;
+
+	if (!test_and_clear_bit(__ICE_FD_VF_FLUSH_CTX, pf->state))
+		return;
+
+	ice_for_each_vf(pf, i) {
+		struct device *dev = ice_pf_to_dev(pf);
+		enum virtchnl_fdir_prgm_status status;
+		struct ice_vf *vf = &pf->vf[i];
+		struct ice_vf_fdir_ctx *ctx;
+		unsigned long flags;
+		int ret;
+
+		if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+			continue;
+
+		if (vf->ctrl_vsi_idx == ICE_NO_VSI)
+			continue;
+
+		ctx = &vf->fdir.ctx_done;
+		spin_lock_irqsave(&vf->fdir.ctx_lock, flags);
+		if (!(ctx->flags & ICE_VF_FDIR_CTX_VALID)) {
+			spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+
+		WARN_ON(ctx->stat == ICE_FDIR_CTX_READY);
+		if (ctx->stat == ICE_FDIR_CTX_TIMEOUT) {
+			status = VIRTCHNL_FDIR_FAILURE_RULE_TIMEOUT;
+			dev_err(dev, "VF %d: ctrl_vsi irq timeout\n",
+				vf->vf_id);
+			goto err_exit;
+		}
+
+		ret = ice_vf_verify_rx_desc(vf, ctx, &status);
+		if (ret)
+			goto err_exit;
+
+		if (ctx->v_opcode == VIRTCHNL_OP_ADD_FDIR_FILTER)
+			ice_vc_add_fdir_fltr_post(vf, ctx, status, true);
+		else if (ctx->v_opcode == VIRTCHNL_OP_DEL_FDIR_FILTER)
+			ice_vc_del_fdir_fltr_post(vf, ctx, status, true);
+		else
+			dev_err(dev, "VF %d: Unsupported opcode\n", vf->vf_id);
+
+		spin_lock_irqsave(&vf->fdir.ctx_lock, flags);
+		ctx->flags &= ~ICE_VF_FDIR_CTX_VALID;
+		spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+		continue;
+err_exit:
+		if (ctx->v_opcode == VIRTCHNL_OP_ADD_FDIR_FILTER)
+			ice_vc_add_fdir_fltr_post(vf, ctx, status, false);
+		else if (ctx->v_opcode == VIRTCHNL_OP_DEL_FDIR_FILTER)
+			ice_vc_del_fdir_fltr_post(vf, ctx, status, false);
+		else
+			dev_err(dev, "VF %d: Unsupported opcode\n", vf->vf_id);
+
+		spin_lock_irqsave(&vf->fdir.ctx_lock, flags);
+		ctx->flags &= ~ICE_VF_FDIR_CTX_VALID;
+		spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+	}
+}
+
+/**
+ * ice_vc_fdir_set_irq_ctx - set FDIR context info for later IRQ handler
+ * @vf: pointer to the VF structure
+ * @conf: FDIR configuration for each filter
+ * @v_opcode: virtual channel operation code
+ *
+ * Return: 0 on success, and other on error.
+ */
+static int
+ice_vc_fdir_set_irq_ctx(struct ice_vf *vf, struct virtchnl_fdir_fltr_conf *conf,
+			enum virtchnl_ops v_opcode)
+{
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	struct ice_vf_fdir_ctx *ctx;
+	unsigned long flags;
+
+	ctx = &vf->fdir.ctx_irq;
+	spin_lock_irqsave(&vf->fdir.ctx_lock, flags);
+	if ((vf->fdir.ctx_irq.flags & ICE_VF_FDIR_CTX_VALID) ||
+	    (vf->fdir.ctx_done.flags & ICE_VF_FDIR_CTX_VALID)) {
+		spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+		dev_dbg(dev, "VF %d: Last request is still in progress\n",
+			vf->vf_id);
+		return -EBUSY;
+	}
+	ctx->flags |= ICE_VF_FDIR_CTX_VALID;
+	spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+
+	ctx->conf = conf;
+	ctx->v_opcode = v_opcode;
+	ctx->stat = ICE_FDIR_CTX_READY;
+	timer_setup(&ctx->rx_tmr, ice_vf_fdir_timer, 0);
+
+	mod_timer(&ctx->rx_tmr, round_jiffies(msecs_to_jiffies(10) + jiffies));
+
+	return 0;
+}
+
+/**
+ * ice_vc_fdir_clear_irq_ctx - clear FDIR context info for IRQ handler
+ * @vf: pointer to the VF structure
+ *
+ * Return: 0 on success, and other on error.
+ */
+static void ice_vc_fdir_clear_irq_ctx(struct ice_vf *vf)
+{
+	struct ice_vf_fdir_ctx *ctx = &vf->fdir.ctx_irq;
+	unsigned long flags;
+
+	del_timer(&ctx->rx_tmr);
+	spin_lock_irqsave(&vf->fdir.ctx_lock, flags);
+	ctx->flags &= ~ICE_VF_FDIR_CTX_VALID;
+	spin_unlock_irqrestore(&vf->fdir.ctx_lock, flags);
+}
+
 /**
  * ice_vc_add_fdir_fltr - add a FDIR filter for VF by the msg buffer
  * @vf: pointer to the VF info
@@ -1601,7 +2050,7 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		goto err_free_conf;
 	}
 
-	ret = ice_vc_fdir_insert_entry(vf, conf, &stat->flow_id);
+	ret = ice_vc_fdir_insert_entry(vf, conf, &conf->flow_id);
 	if (ret) {
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
@@ -1609,6 +2058,14 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		goto err_free_conf;
 	}
 
+	ret = ice_vc_fdir_set_irq_ctx(vf, conf, VIRTCHNL_OP_ADD_FDIR_FILTER);
+	if (ret) {
+		v_ret = VIRTCHNL_STATUS_SUCCESS;
+		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
+		dev_dbg(dev, "VF %d: set FDIR context failed\n", vf->vf_id);
+		goto err_free_conf;
+	}
+
 	ret = ice_vc_fdir_write_fltr(vf, conf, true, is_tun);
 	if (ret) {
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
@@ -1618,18 +2075,13 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		goto err_rem_entry;
 	}
 
-	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
-
-	v_ret = VIRTCHNL_STATUS_SUCCESS;
-	stat->status = VIRTCHNL_FDIR_SUCCESS;
 exit:
-	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER, v_ret,
-				    (u8 *)stat, len);
 	kfree(stat);
 	return ret;
 
 err_rem_entry:
-	ice_vc_fdir_remove_entry(vf, conf, stat->flow_id);
+	ice_vc_fdir_clear_irq_ctx(vf);
+	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 err_free_conf:
 	devm_kfree(dev, conf);
 err_exit:
@@ -1693,22 +2145,29 @@ int ice_vc_del_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		goto err_exit;
 	}
 
+	ret = ice_vc_fdir_set_irq_ctx(vf, conf, VIRTCHNL_OP_DEL_FDIR_FILTER);
+	if (ret) {
+		v_ret = VIRTCHNL_STATUS_SUCCESS;
+		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
+		dev_dbg(dev, "VF %d: set FDIR context failed\n", vf->vf_id);
+		goto err_exit;
+	}
+
 	ret = ice_vc_fdir_write_fltr(vf, conf, false, is_tun);
 	if (ret) {
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_err(dev, "VF %d: writing FDIR rule failed, ret:%d\n",
 			vf->vf_id, ret);
-		goto err_exit;
+		goto err_del_tmr;
 	}
 
-	ice_vc_fdir_remove_entry(vf, conf, fltr->flow_id);
-	devm_kfree(dev, conf);
-	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
+	kfree(stat);
 
-	v_ret = VIRTCHNL_STATUS_SUCCESS;
-	stat->status = VIRTCHNL_FDIR_SUCCESS;
+	return ret;
 
+err_del_tmr:
+	ice_vc_fdir_clear_irq_ctx(vf);
 err_exit:
 	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_FDIR_FILTER, v_ret,
 				    (u8 *)stat, len);
@@ -1726,6 +2185,10 @@ void ice_vf_fdir_init(struct ice_vf *vf)
 
 	idr_init(&fdir->fdir_rule_idr);
 	INIT_LIST_HEAD(&fdir->fdir_rule_list);
+
+	spin_lock_init(&fdir->ctx_lock);
+	fdir->ctx_irq.flags = 0;
+	fdir->ctx_done.flags = 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
index 2a2e0e598559..f4e629f4c09b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
@@ -5,6 +5,24 @@
 #define _ICE_VIRTCHNL_FDIR_H_
 
 struct ice_vf;
+struct ice_pf;
+
+enum ice_fdir_ctx_stat {
+	ICE_FDIR_CTX_READY,
+	ICE_FDIR_CTX_IRQ,
+	ICE_FDIR_CTX_TIMEOUT,
+};
+
+struct ice_vf_fdir_ctx {
+	struct timer_list rx_tmr;
+	enum virtchnl_ops v_opcode;
+	enum ice_fdir_ctx_stat stat;
+	union ice_32b_rx_flex_desc rx_desc;
+#define ICE_VF_FDIR_CTX_VALID		BIT(0)
+	u32 flags;
+
+	void *conf;
+};
 
 /* VF FDIR information structure */
 struct ice_vf_fdir {
@@ -14,11 +32,24 @@ struct ice_vf_fdir {
 
 	struct idr fdir_rule_idr;
 	struct list_head fdir_rule_list;
+
+	spinlock_t ctx_lock; /* protects FDIR context info */
+	struct ice_vf_fdir_ctx ctx_irq;
+	struct ice_vf_fdir_ctx ctx_done;
 };
 
+#ifdef CONFIG_PCI_IOV
 int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg);
 int ice_vc_del_fdir_fltr(struct ice_vf *vf, u8 *msg);
 void ice_vf_fdir_init(struct ice_vf *vf);
 void ice_vf_fdir_exit(struct ice_vf *vf);
-
+void
+ice_vc_fdir_irq_handler(struct ice_vsi *ctrl_vsi,
+			union ice_32b_rx_flex_desc *rx_desc);
+void ice_flush_fdir_ctx(struct ice_pf *pf);
+#else
+static inline void
+ice_vc_fdir_irq_handler(struct ice_vsi *ctrl_vsi, union ice_32b_rx_flex_desc *rx_desc) { }
+static inline void ice_flush_fdir_ctx(struct ice_pf *pf) { }
+#endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VIRTCHNL_FDIR_H_ */
-- 
2.26.2

