Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897033685E8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbhDVRaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:60041 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238259AbhDVRaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:12 -0400
IronPort-SDR: nv2cX9sjvxfpe1VKsqMv4TVrWNmcgMAoDTOgAXOet5RG/yBAOg14T438jMTRdAOKa8Ojsy8/S+
 +6LXQZVvgq+g==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991477"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991477"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: plxZRb751o3yuZxHzND6z71jZ9THOlqBgvm4sejPxFwIqIlzD5XZQN+4O3trt4pcVU584Am6Z4
 8oJN5cMletQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286262"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vignesh Sridhar <vignesh.sridhar@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Yashaswini Raghuram Prathivadi Bhayankaram 
        <yashaswini.raghuram.prathivadi.bhayankaram@intel.com>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 01/12] ice: warn about potentially malicious VFs
Date:   Thu, 22 Apr 2021 10:31:19 -0700
Message-Id: <20210422173130.1143082-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Sridhar <vignesh.sridhar@intel.com>

Attempt to detect malicious VFs and, if suspected, log the information but
keep going to allow the user to take any desired actions.

Potentially malicious VFs are identified by checking if the VFs are
transmitting too many messages via the PF-VF mailbox which could cause an
overflow of this channel resulting in denial of service. This is done by
creating a snapshot or static capture of the mailbox buffer which can be
traversed and in which the messages sent by VFs are tracked.

Co-developed-by: Yashaswini Raghuram Prathivadi Bhayankaram <yashaswini.raghuram.prathivadi.bhayankaram@intel.com>
Signed-off-by: Yashaswini Raghuram Prathivadi Bhayankaram <yashaswini.raghuram.prathivadi.bhayankaram@intel.com>
Co-developed-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Co-developed-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 400 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  20 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  75 ++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  94 +++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  12 +
 7 files changed, 605 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7ae10fd87265..e35db3ff583b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -426,6 +426,7 @@ struct ice_pf {
 	u16 num_msix_per_vf;
 	/* used to ratelimit the MDD event logging */
 	unsigned long last_printed_mdd_jiffies;
+	DECLARE_BITMAP(malvfs, ICE_MAX_VF_COUNT);
 	DECLARE_BITMAP(state, ICE_STATE_NBITS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
 	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6dbaa9099fdf..4ee85a217c6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1193,6 +1193,10 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 	case ICE_CTL_Q_MAILBOX:
 		cq = &hw->mailboxq;
 		qtype = "Mailbox";
+		/* we are going to try to detect a malicious VF, so set the
+		 * state to begin detection
+		 */
+		hw->mbx_snapshot.mbx_buf.state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
 		break;
 	default:
 		dev_warn(dev, "Unknown control queue type 0x%x\n", q_type);
@@ -1274,7 +1278,8 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			ice_vf_lan_overflow_event(pf, &event);
 			break;
 		case ice_mbx_opc_send_msg_to_pf:
-			ice_vc_process_vf_msg(pf, &event);
+			if (!ice_is_malicious_vf(pf, &event, i, pending))
+				ice_vc_process_vf_msg(pf, &event);
 			break;
 		case ice_aqc_opc_fw_logging:
 			ice_output_fw_log(hw, &event.desc, event.msg_buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 554f567476f3..aa11d07793d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -2,7 +2,6 @@
 /* Copyright (c) 2018, Intel Corporation. */
 
 #include "ice_common.h"
-#include "ice_adminq_cmd.h"
 #include "ice_sriov.h"
 
 /**
@@ -132,3 +131,402 @@ u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed)
 
 	return speed;
 }
+
+/* The mailbox overflow detection algorithm helps to check if there
+ * is a possibility of a malicious VF transmitting too many MBX messages to the
+ * PF.
+ * 1. The mailbox snapshot structure, ice_mbx_snapshot, is initialized during
+ * driver initialization in ice_init_hw() using ice_mbx_init_snapshot().
+ * The struct ice_mbx_snapshot helps to track and traverse a static window of
+ * messages within the mailbox queue while looking for a malicious VF.
+ *
+ * 2. When the caller starts processing its mailbox queue in response to an
+ * interrupt, the structure ice_mbx_snapshot is expected to be cleared before
+ * the algorithm can be run for the first time for that interrupt. This can be
+ * done via ice_mbx_reset_snapshot().
+ *
+ * 3. For every message read by the caller from the MBX Queue, the caller must
+ * call the detection algorithm's entry function ice_mbx_vf_state_handler().
+ * Before every call to ice_mbx_vf_state_handler() the struct ice_mbx_data is
+ * filled as it is required to be passed to the algorithm.
+ *
+ * 4. Every time a message is read from the MBX queue, a VFId is received which
+ * is passed to the state handler. The boolean output is_malvf of the state
+ * handler ice_mbx_vf_state_handler() serves as an indicator to the caller
+ * whether this VF is malicious or not.
+ *
+ * 5. When a VF is identified to be malicious, the caller can send a message
+ * to the system administrator. The caller can invoke ice_mbx_report_malvf()
+ * to help determine if a malicious VF is to be reported or not. This function
+ * requires the caller to maintain a global bitmap to track all malicious VFs
+ * and pass that to ice_mbx_report_malvf() along with the VFID which was identified
+ * to be malicious by ice_mbx_vf_state_handler().
+ *
+ * 6. The global bitmap maintained by PF can be cleared completely if PF is in
+ * reset or the bit corresponding to a VF can be cleared if that VF is in reset.
+ * When a VF is shut down and brought back up, we assume that the new VF
+ * brought up is not malicious and hence report it if found malicious.
+ *
+ * 7. The function ice_mbx_reset_snapshot() is called to reset the information
+ * in ice_mbx_snapshot for every new mailbox interrupt handled.
+ *
+ * 8. The memory allocated for variables in ice_mbx_snapshot is de-allocated
+ * when driver is unloaded.
+ */
+#define ICE_RQ_DATA_MASK(rq_data) ((rq_data) & PF_MBX_ARQH_ARQH_M)
+/* Using the highest value for an unsigned 16-bit value 0xFFFF to indicate that
+ * the max messages check must be ignored in the algorithm
+ */
+#define ICE_IGNORE_MAX_MSG_CNT	0xFFFF
+
+/**
+ * ice_mbx_traverse - Pass through mailbox snapshot
+ * @hw: pointer to the HW struct
+ * @new_state: new algorithm state
+ *
+ * Traversing the mailbox static snapshot without checking
+ * for malicious VFs.
+ */
+static void
+ice_mbx_traverse(struct ice_hw *hw,
+		 enum ice_mbx_snapshot_state *new_state)
+{
+	struct ice_mbx_snap_buffer_data *snap_buf;
+	u32 num_iterations;
+
+	snap_buf = &hw->mbx_snapshot.mbx_buf;
+
+	/* As mailbox buffer is circular, applying a mask
+	 * on the incremented iteration count.
+	 */
+	num_iterations = ICE_RQ_DATA_MASK(++snap_buf->num_iterations);
+
+	/* Checking either of the below conditions to exit snapshot traversal:
+	 * Condition-1: If the number of iterations in the mailbox is equal to
+	 * the mailbox head which would indicate that we have reached the end
+	 * of the static snapshot.
+	 * Condition-2: If the maximum messages serviced in the mailbox for a
+	 * given interrupt is the highest possible value then there is no need
+	 * to check if the number of messages processed is equal to it. If not
+	 * check if the number of messages processed is greater than or equal
+	 * to the maximum number of mailbox entries serviced in current work item.
+	 */
+	if (num_iterations == snap_buf->head ||
+	    (snap_buf->max_num_msgs_mbx < ICE_IGNORE_MAX_MSG_CNT &&
+	     ++snap_buf->num_msg_proc >= snap_buf->max_num_msgs_mbx))
+		*new_state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
+}
+
+/**
+ * ice_mbx_detect_malvf - Detect malicious VF in snapshot
+ * @hw: pointer to the HW struct
+ * @vf_id: relative virtual function ID
+ * @new_state: new algorithm state
+ * @is_malvf: boolean output to indicate if VF is malicious
+ *
+ * This function tracks the number of asynchronous messages
+ * sent per VF and marks the VF as malicious if it exceeds
+ * the permissible number of messages to send.
+ */
+static enum ice_status
+ice_mbx_detect_malvf(struct ice_hw *hw, u16 vf_id,
+		     enum ice_mbx_snapshot_state *new_state,
+		     bool *is_malvf)
+{
+	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
+
+	if (vf_id >= snap->mbx_vf.vfcntr_len)
+		return ICE_ERR_OUT_OF_RANGE;
+
+	/* increment the message count in the VF array */
+	snap->mbx_vf.vf_cntr[vf_id]++;
+
+	if (snap->mbx_vf.vf_cntr[vf_id] >= ICE_ASYNC_VF_MSG_THRESHOLD)
+		*is_malvf = true;
+
+	/* continue to iterate through the mailbox snapshot */
+	ice_mbx_traverse(hw, new_state);
+
+	return 0;
+}
+
+/**
+ * ice_mbx_reset_snapshot - Reset mailbox snapshot structure
+ * @snap: pointer to mailbox snapshot structure in the ice_hw struct
+ *
+ * Reset the mailbox snapshot structure and clear VF counter array.
+ */
+static void ice_mbx_reset_snapshot(struct ice_mbx_snapshot *snap)
+{
+	u32 vfcntr_len;
+
+	if (!snap || !snap->mbx_vf.vf_cntr)
+		return;
+
+	/* Clear VF counters. */
+	vfcntr_len = snap->mbx_vf.vfcntr_len;
+	if (vfcntr_len)
+		memset(snap->mbx_vf.vf_cntr, 0,
+		       (vfcntr_len * sizeof(*snap->mbx_vf.vf_cntr)));
+
+	/* Reset mailbox snapshot for a new capture. */
+	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
+	snap->mbx_buf.state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
+}
+
+/**
+ * ice_mbx_vf_state_handler - Handle states of the overflow algorithm
+ * @hw: pointer to the HW struct
+ * @mbx_data: pointer to structure containing mailbox data
+ * @vf_id: relative virtual function (VF) ID
+ * @is_malvf: boolean output to indicate if VF is malicious
+ *
+ * The function serves as an entry point for the malicious VF
+ * detection algorithm by handling the different states and state
+ * transitions of the algorithm:
+ * New snapshot: This state is entered when creating a new static
+ * snapshot. The data from any previous mailbox snapshot is
+ * cleared and a new capture of the mailbox head and tail is
+ * logged. This will be the new static snapshot to detect
+ * asynchronous messages sent by VFs. On capturing the snapshot
+ * and depending on whether the number of pending messages in that
+ * snapshot exceed the watermark value, the state machine enters
+ * traverse or detect states.
+ * Traverse: If pending message count is below watermark then iterate
+ * through the snapshot without any action on VF.
+ * Detect: If pending message count exceeds watermark traverse
+ * the static snapshot and look for a malicious VF.
+ */
+enum ice_status
+ice_mbx_vf_state_handler(struct ice_hw *hw,
+			 struct ice_mbx_data *mbx_data, u16 vf_id,
+			 bool *is_malvf)
+{
+	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
+	struct ice_mbx_snap_buffer_data *snap_buf;
+	struct ice_ctl_q_info *cq = &hw->mailboxq;
+	enum ice_mbx_snapshot_state new_state;
+	enum ice_status status = 0;
+
+	if (!is_malvf || !mbx_data)
+		return ICE_ERR_BAD_PTR;
+
+	/* When entering the mailbox state machine assume that the VF
+	 * is not malicious until detected.
+	 */
+	*is_malvf = false;
+
+	 /* Checking if max messages allowed to be processed while servicing current
+	  * interrupt is not less than the defined AVF message threshold.
+	  */
+	if (mbx_data->max_num_msgs_mbx <= ICE_ASYNC_VF_MSG_THRESHOLD)
+		return ICE_ERR_INVAL_SIZE;
+
+	/* The watermark value should not be lesser than the threshold limit
+	 * set for the number of asynchronous messages a VF can send to mailbox
+	 * nor should it be greater than the maximum number of messages in the
+	 * mailbox serviced in current interrupt.
+	 */
+	if (mbx_data->async_watermark_val < ICE_ASYNC_VF_MSG_THRESHOLD ||
+	    mbx_data->async_watermark_val > mbx_data->max_num_msgs_mbx)
+		return ICE_ERR_PARAM;
+
+	new_state = ICE_MAL_VF_DETECT_STATE_INVALID;
+	snap_buf = &snap->mbx_buf;
+
+	switch (snap_buf->state) {
+	case ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT:
+		/* Clear any previously held data in mailbox snapshot structure. */
+		ice_mbx_reset_snapshot(snap);
+
+		/* Collect the pending ARQ count, number of messages processed and
+		 * the maximum number of messages allowed to be processed from the
+		 * Mailbox for current interrupt.
+		 */
+		snap_buf->num_pending_arq = mbx_data->num_pending_arq;
+		snap_buf->num_msg_proc = mbx_data->num_msg_proc;
+		snap_buf->max_num_msgs_mbx = mbx_data->max_num_msgs_mbx;
+
+		/* Capture a new static snapshot of the mailbox by logging the
+		 * head and tail of snapshot and set num_iterations to the tail
+		 * value to mark the start of the iteration through the snapshot.
+		 */
+		snap_buf->head = ICE_RQ_DATA_MASK(cq->rq.next_to_clean +
+						  mbx_data->num_pending_arq);
+		snap_buf->tail = ICE_RQ_DATA_MASK(cq->rq.next_to_clean - 1);
+		snap_buf->num_iterations = snap_buf->tail;
+
+		/* Pending ARQ messages returned by ice_clean_rq_elem
+		 * is the difference between the head and tail of the
+		 * mailbox queue. Comparing this value against the watermark
+		 * helps to check if we potentially have malicious VFs.
+		 */
+		if (snap_buf->num_pending_arq >=
+		    mbx_data->async_watermark_val) {
+			new_state = ICE_MAL_VF_DETECT_STATE_DETECT;
+			status = ice_mbx_detect_malvf(hw, vf_id, &new_state, is_malvf);
+		} else {
+			new_state = ICE_MAL_VF_DETECT_STATE_TRAVERSE;
+			ice_mbx_traverse(hw, &new_state);
+		}
+		break;
+
+	case ICE_MAL_VF_DETECT_STATE_TRAVERSE:
+		new_state = ICE_MAL_VF_DETECT_STATE_TRAVERSE;
+		ice_mbx_traverse(hw, &new_state);
+		break;
+
+	case ICE_MAL_VF_DETECT_STATE_DETECT:
+		new_state = ICE_MAL_VF_DETECT_STATE_DETECT;
+		status = ice_mbx_detect_malvf(hw, vf_id, &new_state, is_malvf);
+		break;
+
+	default:
+		new_state = ICE_MAL_VF_DETECT_STATE_INVALID;
+		status = ICE_ERR_CFG;
+	}
+
+	snap_buf->state = new_state;
+
+	return status;
+}
+
+/**
+ * ice_mbx_report_malvf - Track and note malicious VF
+ * @hw: pointer to the HW struct
+ * @all_malvfs: all malicious VFs tracked by PF
+ * @bitmap_len: length of bitmap in bits
+ * @vf_id: relative virtual function ID of the malicious VF
+ * @report_malvf: boolean to indicate if malicious VF must be reported
+ *
+ * This function will update a bitmap that keeps track of the malicious
+ * VFs attached to the PF. A malicious VF must be reported only once if
+ * discovered between VF resets or loading so the function checks
+ * the input vf_id against the bitmap to verify if the VF has been
+ * detected in any previous mailbox iterations.
+ */
+enum ice_status
+ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
+		     u16 bitmap_len, u16 vf_id, bool *report_malvf)
+{
+	if (!all_malvfs || !report_malvf)
+		return ICE_ERR_PARAM;
+
+	*report_malvf = false;
+
+	if (bitmap_len < hw->mbx_snapshot.mbx_vf.vfcntr_len)
+		return ICE_ERR_INVAL_SIZE;
+
+	if (vf_id >= bitmap_len)
+		return ICE_ERR_OUT_OF_RANGE;
+
+	/* If the vf_id is found in the bitmap set bit and boolean to true */
+	if (!test_and_set_bit(vf_id, all_malvfs))
+		*report_malvf = true;
+
+	return 0;
+}
+
+/**
+ * ice_mbx_clear_malvf - Clear VF bitmap and counter for VF ID
+ * @snap: pointer to the mailbox snapshot structure
+ * @all_malvfs: all malicious VFs tracked by PF
+ * @bitmap_len: length of bitmap in bits
+ * @vf_id: relative virtual function ID of the malicious VF
+ *
+ * In case of a VF reset, this function can be called to clear
+ * the bit corresponding to the VF ID in the bitmap tracking all
+ * malicious VFs attached to the PF. The function also clears the
+ * VF counter array at the index of the VF ID. This is to ensure
+ * that the new VF loaded is not considered malicious before going
+ * through the overflow detection algorithm.
+ */
+enum ice_status
+ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
+		    u16 bitmap_len, u16 vf_id)
+{
+	if (!snap || !all_malvfs)
+		return ICE_ERR_PARAM;
+
+	if (bitmap_len < snap->mbx_vf.vfcntr_len)
+		return ICE_ERR_INVAL_SIZE;
+
+	/* Ensure VF ID value is not larger than bitmap or VF counter length */
+	if (vf_id >= bitmap_len || vf_id >= snap->mbx_vf.vfcntr_len)
+		return ICE_ERR_OUT_OF_RANGE;
+
+	/* Clear VF ID bit in the bitmap tracking malicious VFs attached to PF */
+	clear_bit(vf_id, all_malvfs);
+
+	/* Clear the VF counter in the mailbox snapshot structure for that VF ID.
+	 * This is to ensure that if a VF is unloaded and a new one brought back
+	 * up with the same VF ID for a snapshot currently in traversal or detect
+	 * state the counter for that VF ID does not increment on top of existing
+	 * values in the mailbox overflow detection algorithm.
+	 */
+	snap->mbx_vf.vf_cntr[vf_id] = 0;
+
+	return 0;
+}
+
+/**
+ * ice_mbx_init_snapshot - Initialize mailbox snapshot structure
+ * @hw: pointer to the hardware structure
+ * @vf_count: number of VFs allocated on a PF
+ *
+ * Clear the mailbox snapshot structure and allocate memory
+ * for the VF counter array based on the number of VFs allocated
+ * on that PF.
+ *
+ * Assumption: This function will assume ice_get_caps() has already been
+ * called to ensure that the vf_count can be compared against the number
+ * of VFs supported as defined in the functional capabilities of the device.
+ */
+enum ice_status ice_mbx_init_snapshot(struct ice_hw *hw, u16 vf_count)
+{
+	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
+
+	/* Ensure that the number of VFs allocated is non-zero and
+	 * is not greater than the number of supported VFs defined in
+	 * the functional capabilities of the PF.
+	 */
+	if (!vf_count || vf_count > hw->func_caps.num_allocd_vfs)
+		return ICE_ERR_INVAL_SIZE;
+
+	snap->mbx_vf.vf_cntr = devm_kcalloc(ice_hw_to_dev(hw), vf_count,
+					    sizeof(*snap->mbx_vf.vf_cntr),
+					    GFP_KERNEL);
+	if (!snap->mbx_vf.vf_cntr)
+		return ICE_ERR_NO_MEMORY;
+
+	/* Setting the VF counter length to the number of allocated
+	 * VFs for given PF's functional capabilities.
+	 */
+	snap->mbx_vf.vfcntr_len = vf_count;
+
+	/* Clear mbx_buf in the mailbox snaphot structure and setting the
+	 * mailbox snapshot state to a new capture.
+	 */
+	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
+	snap->mbx_buf.state = ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT;
+
+	return 0;
+}
+
+/**
+ * ice_mbx_deinit_snapshot - Free mailbox snapshot structure
+ * @hw: pointer to the hardware structure
+ *
+ * Clear the mailbox snapshot structure and free the VF counter array.
+ */
+void ice_mbx_deinit_snapshot(struct ice_hw *hw)
+{
+	struct ice_mbx_snapshot *snap = &hw->mbx_snapshot;
+
+	/* Free VF counter array and reset VF counter length */
+	devm_kfree(ice_hw_to_dev(hw), snap->mbx_vf.vf_cntr);
+	snap->mbx_vf.vfcntr_len = 0;
+
+	/* Clear mbx_buf in the mailbox snaphot structure */
+	memset(&snap->mbx_buf, 0, sizeof(snap->mbx_buf));
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 3d78a0795138..161dc55d9e9c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -4,7 +4,14 @@
 #ifndef _ICE_SRIOV_H_
 #define _ICE_SRIOV_H_
 
-#include "ice_common.h"
+#include "ice_type.h"
+#include "ice_controlq.h"
+
+/* Defining the mailbox message threshold as 63 asynchronous
+ * pending messages. Normal VF functionality does not require
+ * sending more than 63 asynchronous pending message.
+ */
+#define ICE_ASYNC_VF_MSG_THRESHOLD	63
 
 #ifdef CONFIG_PCI_IOV
 enum ice_status
@@ -12,6 +19,17 @@ ice_aq_send_msg_to_vf(struct ice_hw *hw, u16 vfid, u32 v_opcode, u32 v_retval,
 		      u8 *msg, u16 msglen, struct ice_sq_cd *cd);
 
 u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed);
+enum ice_status
+ice_mbx_vf_state_handler(struct ice_hw *hw, struct ice_mbx_data *mbx_data,
+			 u16 vf_id, bool *is_mal_vf);
+enum ice_status
+ice_mbx_clear_malvf(struct ice_mbx_snapshot *snap, unsigned long *all_malvfs,
+		    u16 bitmap_len, u16 vf_id);
+enum ice_status ice_mbx_init_snapshot(struct ice_hw *hw, u16 vf_count);
+void ice_mbx_deinit_snapshot(struct ice_hw *hw);
+enum ice_status
+ice_mbx_report_malvf(struct ice_hw *hw, unsigned long *all_malvfs,
+		     u16 bitmap_len, u16 vf_id, bool *report_malvf);
 #else /* CONFIG_PCI_IOV */
 static inline enum ice_status
 ice_aq_send_msg_to_vf(struct ice_hw __always_unused *hw,
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 9b80962ff92f..4474dd6a7ba1 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -630,6 +630,80 @@ struct ice_fw_log_cfg {
 	struct ice_fw_log_evnt evnts[ICE_AQC_FW_LOG_ID_MAX];
 };
 
+/* Enum defining the different states of the mailbox snapshot in the
+ * PF-VF mailbox overflow detection algorithm. The snapshot can be in
+ * states:
+ * 1. ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT - generate a new static snapshot
+ * within the mailbox buffer.
+ * 2. ICE_MAL_VF_DETECT_STATE_TRAVERSE - iterate through the mailbox snaphot
+ * 3. ICE_MAL_VF_DETECT_STATE_DETECT - track the messages sent per VF via the
+ * mailbox and mark any VFs sending more messages than the threshold limit set.
+ * 4. ICE_MAL_VF_DETECT_STATE_INVALID - Invalid mailbox state set to 0xFFFFFFFF.
+ */
+enum ice_mbx_snapshot_state {
+	ICE_MAL_VF_DETECT_STATE_NEW_SNAPSHOT = 0,
+	ICE_MAL_VF_DETECT_STATE_TRAVERSE,
+	ICE_MAL_VF_DETECT_STATE_DETECT,
+	ICE_MAL_VF_DETECT_STATE_INVALID = 0xFFFFFFFF,
+};
+
+/* Structure to hold information of the static snapshot and the mailbox
+ * buffer data used to generate and track the snapshot.
+ * 1. state: the state of the mailbox snapshot in the malicious VF
+ * detection state handler ice_mbx_vf_state_handler()
+ * 2. head: head of the mailbox snapshot in a circular mailbox buffer
+ * 3. tail: tail of the mailbox snapshot in a circular mailbox buffer
+ * 4. num_iterations: number of messages traversed in circular mailbox buffer
+ * 5. num_msg_proc: number of messages processed in mailbox
+ * 6. num_pending_arq: number of pending asynchronous messages
+ * 7. max_num_msgs_mbx: maximum messages in mailbox for currently
+ * serviced work item or interrupt.
+ */
+struct ice_mbx_snap_buffer_data {
+	enum ice_mbx_snapshot_state state;
+	u32 head;
+	u32 tail;
+	u32 num_iterations;
+	u16 num_msg_proc;
+	u16 num_pending_arq;
+	u16 max_num_msgs_mbx;
+};
+
+/* Structure to track messages sent by VFs on mailbox:
+ * 1. vf_cntr: a counter array of VFs to track the number of
+ * asynchronous messages sent by each VF
+ * 2. vfcntr_len: number of entries in VF counter array
+ */
+struct ice_mbx_vf_counter {
+	u32 *vf_cntr;
+	u32 vfcntr_len;
+};
+
+/* Structure to hold data relevant to the captured static snapshot
+ * of the PF-VF mailbox.
+ */
+struct ice_mbx_snapshot {
+	struct ice_mbx_snap_buffer_data mbx_buf;
+	struct ice_mbx_vf_counter mbx_vf;
+};
+
+/* Structure to hold data to be used for capturing or updating a
+ * static snapshot.
+ * 1. num_msg_proc: number of messages processed in mailbox
+ * 2. num_pending_arq: number of pending asynchronous messages
+ * 3. max_num_msgs_mbx: maximum messages in mailbox for currently
+ * serviced work item or interrupt.
+ * 4. async_watermark_val: An upper threshold set by caller to determine
+ * if the pending arq count is large enough to assume that there is
+ * the possibility of a mailicious VF.
+ */
+struct ice_mbx_data {
+	u16 num_msg_proc;
+	u16 num_pending_arq;
+	u16 max_num_msgs_mbx;
+	u16 async_watermark_val;
+};
+
 /* Port hardware description */
 struct ice_hw {
 	u8 __iomem *hw_addr;
@@ -761,6 +835,7 @@ struct ice_hw {
 	DECLARE_BITMAP(fdir_perfect_fltr, ICE_FLTR_PTYPE_MAX);
 	struct mutex rss_locks;	/* protect RSS configuration */
 	struct list_head rss_list_head;
+	struct ice_mbx_snapshot mbx_snapshot;
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e38d4adc5b8d..a3ed4b84bba6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -424,6 +424,14 @@ void ice_free_vfs(struct ice_pf *pf)
 			wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
 		}
 	}
+
+	/* clear malicious info if the VFs are getting released */
+	for (i = 0; i < tmp; i++)
+		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs,
+					ICE_MAX_VF_COUNT, i))
+			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
+				i);
+
 	clear_bit(ICE_VF_DIS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
@@ -1257,6 +1265,11 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	if (!pf->num_alloc_vfs)
 		return false;
 
+	/* clear all malicious info if the VFs are getting reset */
+	ice_for_each_vf(pf, i)
+		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs, ICE_MAX_VF_COUNT, i))
+			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n", i);
+
 	/* If VFs have been disabled, there is no need to reset */
 	if (test_and_set_bit(ICE_VF_DIS, pf->state))
 		return false;
@@ -1437,6 +1450,10 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	ice_vf_rebuild_vsi_with_release(vf);
 	ice_vf_post_vsi_rebuild(vf);
 
+	/* if the VF has been reset allow it to come up again */
+	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs, ICE_MAX_VF_COUNT, vf->vf_id))
+		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n", i);
+
 	return true;
 }
 
@@ -1769,6 +1786,7 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	struct device *dev = ice_pf_to_dev(pf);
+	enum ice_status status;
 	int err;
 
 	err = ice_check_sriov_allowed(pf);
@@ -1777,6 +1795,7 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 	if (!num_vfs) {
 		if (!pci_vfs_assigned(pdev)) {
+			ice_mbx_deinit_snapshot(&pf->hw);
 			ice_free_vfs(pf);
 			if (pf->lag)
 				ice_enable_lag(pf->lag);
@@ -1787,9 +1806,15 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 		return -EBUSY;
 	}
 
+	status = ice_mbx_init_snapshot(&pf->hw, num_vfs);
+	if (status)
+		return ice_status_to_errno(status);
+
 	err = ice_pci_sriov_ena(pf, num_vfs);
-	if (err)
+	if (err) {
+		ice_mbx_deinit_snapshot(&pf->hw);
 		return err;
+	}
 
 	if (pf->lag)
 		ice_disable_lag(pf->lag);
@@ -4255,3 +4280,70 @@ void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
 		}
 	}
 }
+
+/**
+ * ice_is_malicious_vf - helper function to detect a malicious VF
+ * @pf: ptr to struct ice_pf
+ * @event: pointer to the AQ event
+ * @num_msg_proc: the number of messages processed so far
+ * @num_msg_pending: the number of messages peinding in admin queue
+ */
+bool
+ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
+		    u16 num_msg_proc, u16 num_msg_pending)
+{
+	s16 vf_id = le16_to_cpu(event->desc.retval);
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_mbx_data mbxdata;
+	enum ice_status status;
+	bool malvf = false;
+	struct ice_vf *vf;
+
+	if (ice_validate_vf_id(pf, vf_id))
+		return false;
+
+	vf = &pf->vf[vf_id];
+	/* Check if VF is disabled. */
+	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
+		return false;
+
+	mbxdata.num_msg_proc = num_msg_proc;
+	mbxdata.num_pending_arq = num_msg_pending;
+	mbxdata.max_num_msgs_mbx = pf->hw.mailboxq.num_rq_entries;
+#define ICE_MBX_OVERFLOW_WATERMARK 64
+	mbxdata.async_watermark_val = ICE_MBX_OVERFLOW_WATERMARK;
+
+	/* check to see if we have a malicious VF */
+	status = ice_mbx_vf_state_handler(&pf->hw, &mbxdata, vf_id, &malvf);
+	if (status)
+		return false;
+
+	if (malvf) {
+		bool report_vf = false;
+
+		/* if the VF is malicious and we haven't let the user
+		 * know about it, then let them know now
+		 */
+		status = ice_mbx_report_malvf(&pf->hw, pf->malvfs,
+					      ICE_MAX_VF_COUNT, vf_id,
+					      &report_vf);
+		if (status)
+			dev_dbg(dev, "Error reporting malicious VF\n");
+
+		if (report_vf) {
+			struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
+
+			if (pf_vsi)
+				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
+					 &vf->dflt_lan_addr.addr[0],
+					 pf_vsi->netdev->dev_addr);
+		}
+
+		return true;
+	}
+
+	/* if there was an error in detection or the VF is not malicious then
+	 * return false
+	 */
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 46abc5388fc7..bcc2890c930a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -119,6 +119,9 @@ void ice_vc_notify_reset(struct ice_pf *pf);
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
 void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
+bool
+ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
+		    u16 num_msg_proc, u16 num_msg_pending);
 
 int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
@@ -158,6 +161,15 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
 #define ice_print_vf_rx_mdd_event(vf) do {} while (0)
 #define ice_restore_all_vfs_msi_state(pdev) do {} while (0)
 
+static inline bool
+ice_is_malicious_vf(struct ice_pf __always_unused *pf,
+		    struct ice_rq_event_info __always_unused *event,
+		    u16 __always_unused num_msg_proc,
+		    u16 __always_unused num_msg_pending)
+{
+	return false;
+}
+
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
 		  bool __always_unused is_vflr)
-- 
2.26.2

