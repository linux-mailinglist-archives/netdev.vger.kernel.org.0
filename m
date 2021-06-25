Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679453B4905
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFYS5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:14426 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhFYS5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:57:04 -0400
IronPort-SDR: R/jDU5R+ltXQML7XBNINeYxssWjBcb++bqZxpn8YUPnuICKupitcSnmtS54aPQUCW0Rv7iax84
 xvBB8XLhzH3w==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229326797"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="229326797"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 11:54:43 -0700
IronPort-SDR: 0VgAamWpAHK2I9/fQ7kVjyvcWqyNrMfKD5dzV/4mW88pjEzrNUukcVIHKDBNIcBajQRCMYMiLk
 n4K1FnbsZrnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="491655922"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2021 11:54:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Ben Shelton <benjamin.h.shelton@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/5] ice: add tracepoints
Date:   Fri, 25 Jun 2021 11:57:29 -0700
Message-Id: <20210625185733.1848704-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

This patch is modeled after one by Scott Peterson for i40e.

Add tracepoints to the driver, via a new file ice_trace.h and some new
trace calls added in interesting places in the driver. Add some tracing
for DIMLIB to help debug interrupt moderation problems.

Performance should not be affected, and this can be very useful
for debugging and adding new trace events to paths in the future.

Note eBPF programs can attach to these events, as well as perf
can count them since we're attaching to the events subsystem
in the kernel.

Co-developed-by: Ben Shelton <benjamin.h.shelton@intel.com>
Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
NOTE: checkpatch will complain about this patch due to the macros
defining the new trace functionality being formatted for readability.

 drivers/net/ethernet/intel/ice/ice_main.c  |   8 +
 drivers/net/ethernet/intel/ice/ice_trace.h | 232 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c  |   9 +
 3 files changed, 249 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_trace.h

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5c3ea504770a..b72ab9e97e79 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -13,6 +13,12 @@
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
 #include "ice_devlink.h"
+/* Including ice_trace.h with CREATE_TRACE_POINTS defined will generate the
+ * ice tracepoint functions. This must be done exactly once across the
+ * ice driver.
+ */
+#define CREATE_TRACE_POINTS
+#include "ice_trace.h"
 
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -5477,6 +5483,7 @@ static void ice_tx_dim_work(struct work_struct *work)
 	itr = tx_profile[dim->profile_ix].itr;
 	intrl = tx_profile[dim->profile_ix].intrl;
 
+	ice_trace(tx_dim_work, q_vector, dim);
 	ice_write_itr(rc, itr);
 	ice_write_intrl(q_vector, intrl);
 
@@ -5501,6 +5508,7 @@ static void ice_rx_dim_work(struct work_struct *work)
 	itr = rx_profile[dim->profile_ix].itr;
 	intrl = rx_profile[dim->profile_ix].intrl;
 
+	ice_trace(rx_dim_work, q_vector, dim);
 	ice_write_itr(rc, itr);
 	ice_write_intrl(q_vector, intrl);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
new file mode 100644
index 000000000000..9bc0b8fdfc77
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -0,0 +1,232 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 Intel Corporation. */
+
+/* Modeled on trace-events-sample.h */
+
+/* The trace subsystem name for ice will be "ice".
+ *
+ * This file is named ice_trace.h.
+ *
+ * Since this include file's name is different from the trace
+ * subsystem name, we'll have to define TRACE_INCLUDE_FILE at the end
+ * of this file.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ice
+
+/* See trace-events-sample.h for a detailed description of why this
+ * guard clause is different from most normal include files.
+ */
+#if !defined(_ICE_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _ICE_TRACE_H_
+
+#include <linux/tracepoint.h>
+
+/* ice_trace() macro enables shared code to refer to trace points
+ * like:
+ *
+ * trace_ice_example(args...)
+ *
+ * ... as:
+ *
+ * ice_trace(example, args...)
+ *
+ * ... to resolve to the PF version of the tracepoint without
+ * ifdefs, and to allow tracepoints to be disabled entirely at build
+ * time.
+ *
+ * Trace point should always be referred to in the driver via this
+ * macro.
+ *
+ * Similarly, ice_trace_enabled(trace_name) wraps references to
+ * trace_ice_<trace_name>_enabled() functions.
+ * @trace_name: name of tracepoint
+ */
+#define _ICE_TRACE_NAME(trace_name) (trace_##ice##_##trace_name)
+#define ICE_TRACE_NAME(trace_name) _ICE_TRACE_NAME(trace_name)
+
+#define ice_trace(trace_name, args...) ICE_TRACE_NAME(trace_name)(args)
+
+#define ice_trace_enabled(trace_name) ICE_TRACE_NAME(trace_name##_enabled)()
+
+/* This is for events common to PF. Corresponding versions will be named
+ * trace_ice_*. The ice_trace() macro above will select the right trace point
+ * name for the driver.
+ */
+
+/* Begin tracepoints */
+
+/* Global tracepoints */
+
+/* Events related to DIM, q_vectors and ring containers */
+DECLARE_EVENT_CLASS(ice_rx_dim_template,
+		    TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
+		    TP_ARGS(q_vector, dim),
+		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
+				     __field(struct dim *, dim)
+				     __string(devname, q_vector->rx.ring->netdev->name)),
+
+		    TP_fast_assign(__entry->q_vector = q_vector;
+				   __entry->dim = dim;
+				   __assign_str(devname, q_vector->rx.ring->netdev->name);),
+
+		    TP_printk("netdev: %s Rx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
+			      __get_str(devname),
+			      __entry->q_vector->rx.ring->q_index,
+			      __entry->dim->state,
+			      __entry->dim->profile_ix,
+			      __entry->dim->tune_state,
+			      __entry->dim->steps_right,
+			      __entry->dim->steps_left,
+			      __entry->dim->tired)
+);
+
+DEFINE_EVENT(ice_rx_dim_template, ice_rx_dim_work,
+	     TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
+	     TP_ARGS(q_vector, dim)
+);
+
+DECLARE_EVENT_CLASS(ice_tx_dim_template,
+		    TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
+		    TP_ARGS(q_vector, dim),
+		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
+				     __field(struct dim *, dim)
+				     __string(devname, q_vector->tx.ring->netdev->name)),
+
+		    TP_fast_assign(__entry->q_vector = q_vector;
+				   __entry->dim = dim;
+				   __assign_str(devname, q_vector->tx.ring->netdev->name);),
+
+		    TP_printk("netdev: %s Tx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
+			      __get_str(devname),
+			      __entry->q_vector->tx.ring->q_index,
+			      __entry->dim->state,
+			      __entry->dim->profile_ix,
+			      __entry->dim->tune_state,
+			      __entry->dim->steps_right,
+			      __entry->dim->steps_left,
+			      __entry->dim->tired)
+);
+
+DEFINE_EVENT(ice_tx_dim_template, ice_tx_dim_work,
+	     TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
+	     TP_ARGS(q_vector, dim)
+);
+
+/* Events related to a vsi & ring */
+DECLARE_EVENT_CLASS(ice_tx_template,
+		    TP_PROTO(struct ice_ring *ring, struct ice_tx_desc *desc,
+			     struct ice_tx_buf *buf),
+
+		    TP_ARGS(ring, desc, buf),
+		    TP_STRUCT__entry(__field(void *, ring)
+				     __field(void *, desc)
+				     __field(void *, buf)
+				     __string(devname, ring->netdev->name)),
+
+		    TP_fast_assign(__entry->ring = ring;
+				   __entry->desc = desc;
+				   __entry->buf = buf;
+				   __assign_str(devname, ring->netdev->name);),
+
+		    TP_printk("netdev: %s ring: %pK desc: %pK buf %pK", __get_str(devname),
+			      __entry->ring, __entry->desc, __entry->buf)
+);
+
+#define DEFINE_TX_TEMPLATE_OP_EVENT(name) \
+DEFINE_EVENT(ice_tx_template, name, \
+	     TP_PROTO(struct ice_ring *ring, \
+		      struct ice_tx_desc *desc, \
+		      struct ice_tx_buf *buf), \
+	     TP_ARGS(ring, desc, buf))
+
+DEFINE_TX_TEMPLATE_OP_EVENT(ice_clean_tx_irq);
+DEFINE_TX_TEMPLATE_OP_EVENT(ice_clean_tx_irq_unmap);
+DEFINE_TX_TEMPLATE_OP_EVENT(ice_clean_tx_irq_unmap_eop);
+
+DECLARE_EVENT_CLASS(ice_rx_template,
+		    TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc),
+
+		    TP_ARGS(ring, desc),
+
+		    TP_STRUCT__entry(__field(void *, ring)
+				     __field(void *, desc)
+				     __string(devname, ring->netdev->name)),
+
+		    TP_fast_assign(__entry->ring = ring;
+				   __entry->desc = desc;
+				   __assign_str(devname, ring->netdev->name);),
+
+		    TP_printk("netdev: %s ring: %pK desc: %pK", __get_str(devname),
+			      __entry->ring, __entry->desc)
+);
+DEFINE_EVENT(ice_rx_template, ice_clean_rx_irq,
+	     TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc),
+	     TP_ARGS(ring, desc)
+);
+
+DECLARE_EVENT_CLASS(ice_rx_indicate_template,
+		    TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc,
+			     struct sk_buff *skb),
+
+		    TP_ARGS(ring, desc, skb),
+
+		    TP_STRUCT__entry(__field(void *, ring)
+				     __field(void *, desc)
+				     __field(void *, skb)
+				     __string(devname, ring->netdev->name)),
+
+		    TP_fast_assign(__entry->ring = ring;
+				   __entry->desc = desc;
+				   __entry->skb = skb;
+				   __assign_str(devname, ring->netdev->name);),
+
+		    TP_printk("netdev: %s ring: %pK desc: %pK skb %pK", __get_str(devname),
+			      __entry->ring, __entry->desc, __entry->skb)
+);
+
+DEFINE_EVENT(ice_rx_indicate_template, ice_clean_rx_irq_indicate,
+	     TP_PROTO(struct ice_ring *ring, union ice_32b_rx_flex_desc *desc,
+		      struct sk_buff *skb),
+	     TP_ARGS(ring, desc, skb)
+);
+
+DECLARE_EVENT_CLASS(ice_xmit_template,
+		    TP_PROTO(struct ice_ring *ring, struct sk_buff *skb),
+
+		    TP_ARGS(ring, skb),
+
+		    TP_STRUCT__entry(__field(void *, ring)
+				     __field(void *, skb)
+				     __string(devname, ring->netdev->name)),
+
+		    TP_fast_assign(__entry->ring = ring;
+				   __entry->skb = skb;
+				   __assign_str(devname, ring->netdev->name);),
+
+		    TP_printk("netdev: %s skb: %pK ring: %pK", __get_str(devname),
+			      __entry->skb, __entry->ring)
+);
+
+#define DEFINE_XMIT_TEMPLATE_OP_EVENT(name) \
+DEFINE_EVENT(ice_xmit_template, name, \
+	     TP_PROTO(struct ice_ring *ring, struct sk_buff *skb), \
+	     TP_ARGS(ring, skb))
+
+DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring);
+DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring_drop);
+
+/* End tracepoints */
+
+#endif /* _ICE_TRACE_H_ */
+/* This must be outside ifdef _ICE_TRACE_H */
+
+/* This trace include file is not located in the .../include/trace
+ * with the kernel tracepoint definitions, because we're a loadable
+ * module.
+ */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE ../../drivers/net/ethernet/intel/ice/ice_trace
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e9e9edb32c6f..a63d5916ebb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -10,6 +10,7 @@
 #include "ice_txrx_lib.h"
 #include "ice_lib.h"
 #include "ice.h"
+#include "ice_trace.h"
 #include "ice_dcb_lib.h"
 #include "ice_xsk.h"
 
@@ -224,6 +225,7 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 
 		smp_rmb();	/* prevent any other reads prior to eop_desc */
 
+		ice_trace(clean_tx_irq, tx_ring, tx_desc, tx_buf);
 		/* if the descriptor isn't done, no work yet to do */
 		if (!(eop_desc->cmd_type_offset_bsz &
 		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
@@ -254,6 +256,7 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 
 		/* unmap remaining buffers */
 		while (tx_desc != eop_desc) {
+			ice_trace(clean_tx_irq_unmap, tx_ring, tx_desc, tx_buf);
 			tx_buf++;
 			tx_desc++;
 			i++;
@@ -272,6 +275,7 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 				dma_unmap_len_set(tx_buf, len, 0);
 			}
 		}
+		ice_trace(clean_tx_irq_unmap_eop, tx_ring, tx_desc, tx_buf);
 
 		/* move us one more past the eop_desc for start of next pkt */
 		tx_buf++;
@@ -1102,6 +1106,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
+		ice_trace(clean_rx_irq, rx_ring, rx_desc);
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
 			struct ice_vsi *ctrl_vsi = rx_ring->vsi;
 
@@ -1207,6 +1212,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 		ice_process_skb_fields(rx_ring, rx_desc, skb, rx_ptype);
 
+		ice_trace(clean_rx_irq_indicate, rx_ring, rx_desc, skb);
 		/* send completed skb up the stack */
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 		skb = NULL;
@@ -2188,6 +2194,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	unsigned int count;
 	int tso, csum;
 
+	ice_trace(xmit_frame_ring, tx_ring, skb);
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2262,6 +2270,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	return NETDEV_TX_OK;
 
 out_drop:
+	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
-- 
2.26.2

