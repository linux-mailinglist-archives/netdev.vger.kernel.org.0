Return-Path: <netdev+bounces-4451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC4A70CF45
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED4F91C20AC3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 00:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8F5111F;
	Tue, 23 May 2023 00:29:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5623C10E9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:29:52 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D890B4225
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684801768; x=1716337768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LTG8qO4P8Z6C+Q45G6UOF7NiidSU23NKmPcBtcnmNj0=;
  b=StRYcvtVZvucgew2fqVrZRqOHcDwa6hkMuY6n9ZK3B4X0JKP23wjn/j/
   tYR9ZU2Bbo1xPrKOvIpUOB/UWVy8+IkDQf7D24kLNClx3xJx/Nl29FpOu
   mhljCFUVAaPdash270caLvGfUrhoECMAAx0KkFDhNjAkwIIlEEZhA4qZQ
   sz8A30QlKWvyiE6+FsY8D0fiCqT39LCH9nDNTsPqBPFnplOKci9v2IscB
   58s2TxCCG0V/S33ZmCcLomqHHsc0T5Zh2qDDBpmVEa3yR4HKerFW/Pu8K
   3q6z46n0mq3B0Exbv3gNfqzSIuJXzaW0Wb+G01JHRjTA5eBK2n+GSooX5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="337670699"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337670699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:26:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827885494"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="827885494"
Received: from unknown (HELO AMR-CMP1.ger.corp.intel.com) ([10.166.80.24])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 17:26:02 -0700
From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: shannon.nelson@amd.com,
	simon.horman@corigine.com,
	leon@kernel.org,
	decot@google.com,
	willemb@google.com,
	stephen@networkplumber.org,
	mst@redhat.com,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Alan Brady <alan.brady@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [PATCH iwl-next v6 04/15] idpf: add core init and interrupt request
Date: Mon, 22 May 2023 17:22:41 -0700
Message-Id: <20230523002252.26124-5-pavan.kumar.linga@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As the mailbox is setup, add the necessary send and receive
mailbox message framework to support the virtchnl communication
between the driver and device Control Plane (CP).

Add the core initialization. To start with, driver confirms the
virtchnl version with the CP. Once that is done, it requests
and gets the required capabilities and resources needed such as
max vectors, queues etc.

Based on the vector information received in 'VIRTCHNL2_OP_GET_CAPS',
request the stack to allocate the required vectors. Finally add
the interrupt handling mechanism for the mailbox queue and enable
the interrupt.

Note: Checkpatch issues a warning about IDPF_FOREACH_VPORT_VC_STATE and
IDPF_GEN_STRING being complex macros and should be enclosed in parentheses
but it's not the case. They are never used as a statement and instead only
used to define the enum and array.

Co-developed-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/intel/idpf/idpf.h        | 138 ++-
 drivers/net/ethernet/intel/idpf/idpf_dev.c    |  17 +
 .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  43 +
 .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  38 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 347 +++++++-
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  16 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  26 +
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  22 +-
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 807 ++++++++++++++++++
 9 files changed, 1451 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.h

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 1f218fef9566..477bf83a0812 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -11,6 +11,8 @@ struct idpf_adapter;
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 
+#include "virtchnl2.h"
+#include "idpf_txrx.h"
 #include "idpf_controlq.h"
 
 /* Default Mailbox settings */
@@ -18,12 +20,24 @@ struct idpf_adapter;
 #define IDPF_NUM_DFLT_MBX_Q		2	/* includes both TX and RX */
 #define IDPF_DFLT_MBX_Q_LEN		64
 #define IDPF_DFLT_MBX_ID		-1
+/* maximum number of times to try before resetting mailbox */
+#define IDPF_MB_MAX_ERR			20
+#define IDPF_WAIT_FOR_EVENT_TIMEO_MIN	2000
+#define IDPF_WAIT_FOR_EVENT_TIMEO	60000
+
+#define IDPF_MAX_WAIT			500
 
 /* available message levels */
 #define IDPF_AVAIL_NETIF_M (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
 
+#define IDPF_VIRTCHNL_VERSION_MAJOR VIRTCHNL2_VERSION_MAJOR_2
+#define IDPF_VIRTCHNL_VERSION_MINOR VIRTCHNL2_VERSION_MINOR_0
+
 enum idpf_state {
 	__IDPF_STARTUP,
+	__IDPF_VER_CHECK,
+	__IDPF_GET_CAPS,
+	__IDPF_INIT_SW,
 	__IDPF_STATE_LAST /* this member MUST be last */
 };
 
@@ -34,6 +48,12 @@ enum idpf_state {
  * @IDPF_HR_DRV_LOAD: Set on driver load for a clean HW
  * @IDPF_HR_RESET_IN_PROG: Reset in progress
  * @IDPF_REMOVE_IN_PROG: Driver remove in progress
+ * @IDPF_REL_RES_IN_PROG: Resources release in progress
+ * @IDPF_MB_INTR_MODE: Mailbox in interrupt mode
+ * @IDPF_MB_INTR_TRIGGER: Mailbox interrupt event
+ * @IDPF_VC_MSG_PENDING: Virtchnl message buffer received needs to be processed
+ * @IDPF_CANCEL_SERVICE_TASK: Do not schedule service task if bit is set
+ * @IDPF_REMOVE_IN_PROG: Driver remove in progress
  * @IDPF_FLAGS_NBITS: Must be last
  */
 enum idpf_flags {
@@ -41,6 +61,11 @@ enum idpf_flags {
 	IDPF_HR_CORE_RESET,
 	IDPF_HR_DRV_LOAD,
 	IDPF_HR_RESET_IN_PROG,
+	IDPF_REL_RES_IN_PROG,
+	IDPF_MB_INTR_MODE,
+	IDPF_MB_INTR_TRIGGER,
+	IDPF_VC_MSG_PENDING,
+	IDPF_CANCEL_SERVICE_TASK,
 	IDPF_REMOVE_IN_PROG,
 	IDPF_FLAGS_NBITS,
 };
@@ -55,6 +80,7 @@ struct idpf_reset_reg {
 /* product specific register API */
 struct idpf_reg_ops {
 	void (*ctlq_reg_init)(struct idpf_ctlq_create_info *cq);
+	void (*mb_intr_reg_init)(struct idpf_adapter *adapter);
 	void (*reset_reg_init)(struct idpf_adapter *adapter);
 	void (*trigger_reset)(struct idpf_adapter *adapter,
 			      enum idpf_flags trig_cause);
@@ -64,22 +90,104 @@ struct idpf_dev_ops {
 	struct idpf_reg_ops reg_ops;
 };
 
+/* These macros allow us to generate an enum and a matching char * array of
+ * stringified enums that are always in sync. Checkpatch issues a bogus warning
+ * about this being a complex macro; but it's wrong, these are never used as a
+ * statement and instead only used to define the enum and array.
+ */
+#define IDPF_FOREACH_VPORT_VC_STATE(STATE)	\
+	STATE(IDPF_VC_ALLOC_VECTORS)		\
+	STATE(IDPF_VC_ALLOC_VECTORS_ERR)	\
+	STATE(IDPF_VC_DEALLOC_VECTORS)		\
+	STATE(IDPF_VC_DEALLOC_VECTORS_ERR)	\
+	STATE(IDPF_VC_NBITS)
+
+#define IDPF_GEN_ENUM(ENUM) ENUM,
+#define IDPF_GEN_STRING(STRING) #STRING,
+
+enum idpf_vport_vc_state {
+	IDPF_FOREACH_VPORT_VC_STATE(IDPF_GEN_ENUM)
+};
+
+extern const char * const idpf_vport_vc_state_str[];
+
+struct idpf_vport {
+	u32 vport_id;
+};
+
+/* Stack to maintain vector indexes used for 'vector distribution' algorithm */
+struct idpf_vector_lifo {
+	/* Vector stack maintains all the relative vector indexes at the
+	 * *adapter* level. This stack is divided into 2 parts, first one is
+	 * called as 'default pool' and other one is called 'free pool'.
+	 * Vector distribution algorithm gives priority to default vports in
+	 * a way that at least IDPF_MIN_Q_VEC vectors are allocated per
+	 * default vport and the relative vector indexes for those are
+	 * maintained in default pool. Free pool contains all the unallocated
+	 * vector indexes which can be allocated on-demand basis.
+	 * Mailbox vector index is maintained in the default pool of the stack.
+	 */
+	u16 top;	/* Points to stack top i.e. next available vector index */
+	u16 base;	/* Always points to start of the 'free pool' */
+	u16 size;	/* Total size of the vector stack */
+	u16 *vec_idx;	/* Array to store all the vector indexes */
+};
+
 struct idpf_adapter {
 	struct pci_dev *pdev;
+	u32 virt_ver_maj;
+	u32 virt_ver_min;
+
 	u32 msg_enable;
+	u32 mb_wait_count;
 	enum idpf_state state;
 	DECLARE_BITMAP(flags, IDPF_FLAGS_NBITS);
 	struct idpf_reset_reg reset_reg;
 	struct idpf_hw hw;
-
+	u16 num_req_msix;
+	u16 num_avail_msix;
+	u16 num_msix_entries;
+	struct msix_entry *msix_entries;
+	struct virtchnl2_alloc_vectors *req_vec_chunks;
+	struct idpf_q_vector mb_vector;
+	/* Stack to store the msix vector indexes */
+	struct idpf_vector_lifo vector_stack;
+	/* handler for hard interrupt for mailbox*/
+	irqreturn_t (*irq_mb_handler)(int irq, void *data);
+
+	struct delayed_work serv_task; /* delayed service task */
+	struct workqueue_struct *serv_wq;
 	struct delayed_work vc_event_task; /* delayed virtchannel event task */
 	struct workqueue_struct *vc_event_wq;
+	struct virtchnl2_get_capabilities caps;
 
+	wait_queue_head_t vchnl_wq;
+	DECLARE_BITMAP(vc_state, IDPF_VC_NBITS);
+	char vc_msg[IDPF_DFLT_MBX_BUF_SIZE];
 	struct idpf_dev_ops dev_ops;
 
 	struct mutex reset_lock;	/* lock to protect reset flows */
+	struct mutex vector_lock;	/* lock to protect vector distribution */
 };
 
+/**
+ * idpf_get_reserved_vecs - Get reserved vectors
+ * @adapter: private data struct
+ */
+static inline u16 idpf_get_reserved_vecs(struct idpf_adapter *adapter)
+{
+	return le16_to_cpu(adapter->caps.num_allocated_vectors);
+}
+
+/**
+ * idpf_get_default_vports - Get default number of vports
+ * @adapter: private data struct
+ */
+static inline u16 idpf_get_default_vports(struct idpf_adapter *adapter)
+{
+	return le16_to_cpu(adapter->caps.default_num_vports);
+}
+
 /**
  * idpf_get_reg_addr - Get BAR0 register address
  * @adapter: private data struct
@@ -108,10 +216,38 @@ static inline bool idpf_is_reset_detected(struct idpf_adapter *adapter)
 		 adapter->hw.arq->reg.len_mask);
 }
 
+/**
+ * idpf_is_reset_in_prog - check if reset is in progress
+ * @adapter: driver specific private structure
+ *
+ * Returns true if hard reset is in progress, false otherwise
+ */
+static inline bool idpf_is_reset_in_prog(struct idpf_adapter *adapter)
+{
+	return (test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags) ||
+		test_bit(IDPF_HR_FUNC_RESET, adapter->flags) ||
+		test_bit(IDPF_HR_CORE_RESET, adapter->flags) ||
+		test_bit(IDPF_HR_DRV_LOAD, adapter->flags));
+}
+
+void idpf_service_task(struct work_struct *work);
 void idpf_vc_event_task(struct work_struct *work);
 void idpf_dev_ops_init(struct idpf_adapter *adapter);
 void idpf_vf_dev_ops_init(struct idpf_adapter *adapter);
 int idpf_init_dflt_mbx(struct idpf_adapter *adapter);
 void idpf_deinit_dflt_mbx(struct idpf_adapter *adapter);
+int idpf_vc_core_init(struct idpf_adapter *adapter);
+void idpf_vc_core_deinit(struct idpf_adapter *adapter);
+int idpf_intr_req(struct idpf_adapter *adapter);
+void idpf_intr_rel(struct idpf_adapter *adapter);
+int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter);
+int idpf_send_alloc_vectors_msg(struct idpf_adapter *adapter, u16 num_vectors);
+int idpf_get_vec_ids(struct idpf_adapter *adapter,
+		     u16 *vecids, int num_vecids,
+		     struct virtchnl2_vector_chunks *chunks);
+int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
+		     void *msg, int msg_size);
+int idpf_send_mb_msg(struct idpf_adapter *adapter, u32 op,
+		     u16 msg_size, u8 *msg);
 
 #endif /* !_IDPF_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_dev.c b/drivers/net/ethernet/intel/idpf/idpf_dev.c
index 7c0c8a14aba9..11cc33eb0b44 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_dev.c
@@ -44,6 +44,22 @@ static void idpf_ctlq_reg_init(struct idpf_ctlq_create_info *cq)
 	}
 }
 
+/**
+ * idpf_mb_intr_reg_init - Initialize mailbox interrupt register
+ * @adapter: adapter structure
+ */
+static void idpf_mb_intr_reg_init(struct idpf_adapter *adapter)
+{
+	struct idpf_intr_reg *intr = &adapter->mb_vector.intr_reg;
+	u32 dyn_ctl = le32_to_cpu(adapter->caps.mailbox_dyn_ctl);
+
+	intr->dyn_ctl = idpf_get_reg_addr(adapter, dyn_ctl);
+	intr->dyn_ctl_intena_m = PF_GLINT_DYN_CTL_INTENA_M;
+	intr->dyn_ctl_itridx_m = PF_GLINT_DYN_CTL_ITR_INDX_M;
+	intr->icr_ena = idpf_get_reg_addr(adapter, PF_INT_DIR_OICR_ENA);
+	intr->icr_ena_ctlq_m = PF_INT_DIR_OICR_ENA_M;
+}
+
 /**
  * idpf_reset_reg_init - Initialize reset registers
  * @adapter: Driver specific private structure
@@ -75,6 +91,7 @@ static void idpf_trigger_reset(struct idpf_adapter *adapter,
 static void idpf_reg_ops_init(struct idpf_adapter *adapter)
 {
 	adapter->dev_ops.reg_ops.ctlq_reg_init = idpf_ctlq_reg_init;
+	adapter->dev_ops.reg_ops.mb_intr_reg_init = idpf_mb_intr_reg_init;
 	adapter->dev_ops.reg_ops.reset_reg_init = idpf_reset_reg_init;
 	adapter->dev_ops.reg_ops.trigger_reset = idpf_trigger_reset;
 }
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h b/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
index 9cc9610990b4..a832319f535c 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
@@ -53,6 +53,49 @@
 #define PF_FW_ATQH_ATQH_M		GENMASK(9, 0)
 #define PF_FW_ATQT			(PF_FW_BASE + 0x24)
 
+/* Interrupts */
+#define PF_GLINT_BASE			0x08900000
+#define PF_GLINT_DYN_CTL(_INT)		(PF_GLINT_BASE + ((_INT) * 0x1000))
+#define PF_GLINT_DYN_CTL_INTENA_S	0
+#define PF_GLINT_DYN_CTL_INTENA_M	BIT(PF_GLINT_DYN_CTL_INTENA_S)
+#define PF_GLINT_DYN_CTL_CLEARPBA_S	1
+#define PF_GLINT_DYN_CTL_CLEARPBA_M	BIT(PF_GLINT_DYN_CTL_CLEARPBA_S)
+#define PF_GLINT_DYN_CTL_SWINT_TRIG_S	2
+#define PF_GLINT_DYN_CTL_SWINT_TRIG_M	BIT(PF_GLINT_DYN_CTL_SWINT_TRIG_S)
+#define PF_GLINT_DYN_CTL_ITR_INDX_S	3
+#define PF_GLINT_DYN_CTL_ITR_INDX_M	GENMASK(4, 3)
+#define PF_GLINT_DYN_CTL_INTERVAL_S	5
+#define PF_GLINT_DYN_CTL_INTERVAL_M	BIT(PF_GLINT_DYN_CTL_INTERVAL_S)
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_S	24
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_M BIT(PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_S)
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_S	25
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_M	BIT(PF_GLINT_DYN_CTL_SW_ITR_INDX_S)
+#define PF_GLINT_DYN_CTL_WB_ON_ITR_S	30
+#define PF_GLINT_DYN_CTL_WB_ON_ITR_M	BIT(PF_GLINT_DYN_CTL_WB_ON_ITR_S)
+#define PF_GLINT_DYN_CTL_INTENA_MSK_S	31
+#define PF_GLINT_DYN_CTL_INTENA_MSK_M	BIT(PF_GLINT_DYN_CTL_INTENA_MSK_S)
+
+/* Generic registers */
+#define PF_INT_DIR_OICR_ENA		0x08406000
+#define PF_INT_DIR_OICR_ENA_S		0
+#define PF_INT_DIR_OICR_ENA_M		GENMASK(31, 0)
+#define PF_INT_DIR_OICR			0x08406004
+#define PF_INT_DIR_OICR_TSYN_EVNT	0
+#define PF_INT_DIR_OICR_PHY_TS_0	BIT(1)
+#define PF_INT_DIR_OICR_PHY_TS_1	BIT(2)
+#define PF_INT_DIR_OICR_CAUSE		0x08406008
+#define PF_INT_DIR_OICR_CAUSE_CAUSE_S	0
+#define PF_INT_DIR_OICR_CAUSE_CAUSE_M	GENMASK(31, 0)
+#define PF_INT_PBA_CLEAR		0x0840600C
+
+#define PF_FUNC_RID			0x08406010
+#define PF_FUNC_RID_FUNCTION_NUMBER_S	0
+#define PF_FUNC_RID_FUNCTION_NUMBER_M	GENMASK(2, 0)
+#define PF_FUNC_RID_DEVICE_NUMBER_S	3
+#define PF_FUNC_RID_DEVICE_NUMBER_M	GENMASK(7, 3)
+#define PF_FUNC_RID_BUS_NUMBER_S	8
+#define PF_FUNC_RID_BUS_NUMBER_M	GENMASK(15, 8)
+
 /* Reset registers */
 #define PFGEN_RTRIG			0x08407000
 #define PFGEN_RTRIG_CORER_S		0
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h b/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
index 8040bedea2fd..d1bff18e2a7d 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
@@ -62,4 +62,42 @@
 #define VF_QRXB_TAIL_BASE		0x00060000
 #define VF_QRXB_TAIL(_QRX)		(VF_QRXB_TAIL_BASE + ((_QRX) * 4))
 
+/* Interrupts */
+#define VF_INT_DYN_CTL0			0x00005C00
+#define VF_INT_DYN_CTL0_INTENA_S	0
+#define VF_INT_DYN_CTL0_INTENA_M	BIT(VF_INT_DYN_CTL0_INTENA_S)
+#define VF_INT_DYN_CTL0_ITR_INDX_S	3
+#define VF_INT_DYN_CTL0_ITR_INDX_M	GENMASK(4, 3)
+#define VF_INT_DYN_CTLN(_INT)		(0x00003800 + ((_INT) * 4))
+#define VF_INT_DYN_CTLN_EXT(_INT)	(0x00070000 + ((_INT) * 4))
+#define VF_INT_DYN_CTLN_INTENA_S	0
+#define VF_INT_DYN_CTLN_INTENA_M	BIT(VF_INT_DYN_CTLN_INTENA_S)
+#define VF_INT_DYN_CTLN_CLEARPBA_S	1
+#define VF_INT_DYN_CTLN_CLEARPBA_M	BIT(VF_INT_DYN_CTLN_CLEARPBA_S)
+#define VF_INT_DYN_CTLN_SWINT_TRIG_S	2
+#define VF_INT_DYN_CTLN_SWINT_TRIG_M	BIT(VF_INT_DYN_CTLN_SWINT_TRIG_S)
+#define VF_INT_DYN_CTLN_ITR_INDX_S	3
+#define VF_INT_DYN_CTLN_ITR_INDX_M	GENMASK(4, 3)
+#define VF_INT_DYN_CTLN_INTERVAL_S	5
+#define VF_INT_DYN_CTLN_INTERVAL_M	BIT(VF_INT_DYN_CTLN_INTERVAL_S)
+#define VF_INT_DYN_CTLN_SW_ITR_INDX_ENA_S 24
+#define VF_INT_DYN_CTLN_SW_ITR_INDX_ENA_M BIT(VF_INT_DYN_CTLN_SW_ITR_INDX_ENA_S)
+#define VF_INT_DYN_CTLN_SW_ITR_INDX_S	25
+#define VF_INT_DYN_CTLN_SW_ITR_INDX_M	BIT(VF_INT_DYN_CTLN_SW_ITR_INDX_S)
+#define VF_INT_DYN_CTLN_WB_ON_ITR_S	30
+#define VF_INT_DYN_CTLN_WB_ON_ITR_M	BIT(VF_INT_DYN_CTLN_WB_ON_ITR_S)
+#define VF_INT_DYN_CTLN_INTENA_MSK_S	31
+#define VF_INT_DYN_CTLN_INTENA_MSK_M	BIT(VF_INT_DYN_CTLN_INTENA_MSK_S)
+
+#define VF_INT_ICR0_ENA1		0x00005000
+#define VF_INT_ICR0_ENA1_ADMINQ_S	30
+#define VF_INT_ICR0_ENA1_ADMINQ_M	BIT(VF_INT_ICR0_ENA1_ADMINQ_S)
+#define VF_INT_ICR0_ENA1_RSVD_S		31
+#define VF_INT_ICR01			0x00004800
+#define VF_QF_HENA(_i)			(0x0000C400 + ((_i) * 4))
+#define VF_QF_HENA_MAX_INDX		1
+#define VF_QF_HKEY(_i)			(0x0000CC00 + ((_i) * 4))
+#define VF_QF_HKEY_MAX_INDX		12
+#define VF_QF_HLUT(_i)			(0x0000D000 + ((_i) * 4))
+#define VF_QF_HLUT_MAX_INDX		15
 #endif
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 40ceef5f4d65..29eb50a0ce12 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -3,6 +3,333 @@
 
 #include "idpf.h"
 
+const char * const idpf_vport_vc_state_str[] = {
+	IDPF_FOREACH_VPORT_VC_STATE(IDPF_GEN_STRING)
+};
+
+/**
+ * idpf_init_vector_stack - Fill the MSIX vector stack with vector index
+ * @adapter: private data struct
+ *
+ * Return 0 on success, error on failure
+ */
+static int idpf_init_vector_stack(struct idpf_adapter *adapter)
+{
+	struct idpf_vector_lifo *stack;
+	u16 min_vec;
+	u32 i;
+
+	mutex_lock(&adapter->vector_lock);
+	min_vec = adapter->num_msix_entries - adapter->num_avail_msix;
+	stack = &adapter->vector_stack;
+	stack->size = adapter->num_msix_entries;
+	/* set the base and top to point at start of the 'free pool' to
+	 * distribute the unused vectors on-demand basis
+	 */
+	stack->base = min_vec;
+	stack->top = min_vec;
+
+	stack->vec_idx = kcalloc(stack->size, sizeof(u16), GFP_KERNEL);
+	if (!stack->vec_idx) {
+		mutex_unlock(&adapter->vector_lock);
+
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < stack->size; i++)
+		stack->vec_idx[i] = i;
+
+	mutex_unlock(&adapter->vector_lock);
+
+	return 0;
+}
+
+/**
+ * idpf_deinit_vector_stack - zero out the MSIX vector stack
+ * @adapter: private data struct
+ */
+static void idpf_deinit_vector_stack(struct idpf_adapter *adapter)
+{
+	struct idpf_vector_lifo *stack;
+
+	mutex_lock(&adapter->vector_lock);
+	stack = &adapter->vector_stack;
+	kfree(stack->vec_idx);
+	stack->vec_idx = NULL;
+	mutex_unlock(&adapter->vector_lock);
+}
+
+/**
+ * idpf_mb_intr_rel_irq - Free the IRQ association with the OS
+ * @adapter: adapter structure
+ */
+static void idpf_mb_intr_rel_irq(struct idpf_adapter *adapter)
+{
+	free_irq(adapter->msix_entries[0].vector, adapter);
+}
+
+/**
+ * idpf_intr_rel - Release interrupt capabilities and free memory
+ * @adapter: adapter to disable interrupts on
+ */
+void idpf_intr_rel(struct idpf_adapter *adapter)
+{
+	int err;
+
+	if (!adapter->msix_entries)
+		return;
+
+	clear_bit(IDPF_MB_INTR_MODE, adapter->flags);
+	clear_bit(IDPF_MB_INTR_TRIGGER, adapter->flags);
+
+	idpf_mb_intr_rel_irq(adapter);
+	pci_free_irq_vectors(adapter->pdev);
+
+	err = idpf_send_dealloc_vectors_msg(adapter);
+	if (err)
+		dev_err(&adapter->pdev->dev,
+			"Failed to deallocate vectors: %d\n", err);
+
+	idpf_deinit_vector_stack(adapter);
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+}
+
+/**
+ * idpf_mb_intr_clean - Interrupt handler for the mailbox
+ * @irq: interrupt number
+ * @data: pointer to the adapter structure
+ */
+static irqreturn_t idpf_mb_intr_clean(int __always_unused irq, void *data)
+{
+	struct idpf_adapter *adapter = (struct idpf_adapter *)data;
+
+	set_bit(IDPF_MB_INTR_TRIGGER, adapter->flags);
+	mod_delayed_work(adapter->serv_wq, &adapter->serv_task,
+			 msecs_to_jiffies(0));
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * idpf_mb_irq_enable - Enable MSIX interrupt for the mailbox
+ * @adapter: adapter to get the hardware address for register write
+ */
+static void idpf_mb_irq_enable(struct idpf_adapter *adapter)
+{
+	struct idpf_intr_reg *intr = &adapter->mb_vector.intr_reg;
+	u32 val;
+
+	val = intr->dyn_ctl_intena_m | intr->dyn_ctl_itridx_m;
+	writel(val, intr->dyn_ctl);
+	writel(intr->icr_ena_ctlq_m, intr->icr_ena);
+}
+
+/**
+ * idpf_mb_intr_req_irq - Request irq for the mailbox interrupt
+ * @adapter: adapter structure to pass to the mailbox irq handler
+ */
+static int idpf_mb_intr_req_irq(struct idpf_adapter *adapter)
+{
+	struct idpf_q_vector *mb_vector = &adapter->mb_vector;
+	int irq_num, mb_vidx = 0, err;
+
+	irq_num = adapter->msix_entries[mb_vidx].vector;
+	snprintf(mb_vector->name, sizeof(mb_vector->name) - 1,
+		 "%s-%s-%d", dev_driver_string(&adapter->pdev->dev),
+		 "Mailbox", mb_vidx);
+	err = request_irq(irq_num, adapter->irq_mb_handler, 0,
+			  mb_vector->name, adapter);
+	if (err) {
+		dev_err(&adapter->pdev->dev,
+			"IRQ request for mailbox failed, error: %d\n", err);
+
+		return err;
+	}
+
+	set_bit(IDPF_MB_INTR_MODE, adapter->flags);
+
+	return 0;
+}
+
+/**
+ * idpf_set_mb_vec_id - Set vector index for mailbox
+ * @adapter: adapter structure to access the vector chunks
+ *
+ * The first vector id in the requested vector chunks from the CP is for
+ * the mailbox
+ */
+static void idpf_set_mb_vec_id(struct idpf_adapter *adapter)
+{
+	if (adapter->req_vec_chunks)
+		adapter->mb_vector.v_idx =
+			le16_to_cpu(adapter->caps.mailbox_vector_id);
+	else
+		adapter->mb_vector.v_idx = 0;
+}
+
+/**
+ * idpf_mb_intr_init - Initialize the mailbox interrupt
+ * @adapter: adapter structure to store the mailbox vector
+ */
+static int idpf_mb_intr_init(struct idpf_adapter *adapter)
+{
+	adapter->dev_ops.reg_ops.mb_intr_reg_init(adapter);
+	adapter->irq_mb_handler = idpf_mb_intr_clean;
+
+	return idpf_mb_intr_req_irq(adapter);
+}
+
+/**
+ * idpf_intr_req - Request interrupt capabilities
+ * @adapter: adapter to enable interrupts on
+ *
+ * Returns 0 on success, negative on failure
+ */
+int idpf_intr_req(struct idpf_adapter *adapter)
+{
+	u16 default_vports = idpf_get_default_vports(adapter);
+	int num_q_vecs, total_vecs, num_vec_ids;
+	int min_vectors, v_actual, err = 0;
+	unsigned int vector;
+	u16 *vecids;
+
+	total_vecs = idpf_get_reserved_vecs(adapter);
+	num_q_vecs = total_vecs - IDPF_MBX_Q_VEC;
+
+	err = idpf_send_alloc_vectors_msg(adapter, num_q_vecs);
+	if (err) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to allocate %d vectors: %d\n", num_q_vecs, err);
+
+		return -EAGAIN;
+	}
+
+	min_vectors = IDPF_MBX_Q_VEC + IDPF_MIN_Q_VEC * default_vports;
+	v_actual = pci_alloc_irq_vectors(adapter->pdev, min_vectors,
+					 total_vecs, PCI_IRQ_MSIX);
+	if (v_actual < min_vectors) {
+		dev_err(&adapter->pdev->dev, "Failed to allocate MSIX vectors: %d\n",
+			v_actual);
+		err = -EAGAIN;
+		goto send_dealloc_vecs;
+	}
+
+	adapter->msix_entries = kcalloc(v_actual, sizeof(struct msix_entry),
+					GFP_KERNEL);
+
+	if (!adapter->msix_entries) {
+		err = -ENOMEM;
+		goto free_irq;
+	}
+
+	idpf_set_mb_vec_id(adapter);
+
+	vecids = kcalloc(total_vecs, sizeof(u16), GFP_KERNEL);
+	if (!vecids) {
+		err = -ENOMEM;
+		goto free_msix;
+	}
+
+	if (adapter->req_vec_chunks) {
+		struct virtchnl2_vector_chunks *vchunks;
+		struct virtchnl2_alloc_vectors *ac;
+
+		ac = adapter->req_vec_chunks;
+		vchunks = &ac->vchunks;
+
+		num_vec_ids = idpf_get_vec_ids(adapter, vecids, total_vecs,
+					       vchunks);
+		if (num_vec_ids < v_actual) {
+			err = -EINVAL;
+			goto free_vecids;
+		}
+	} else {
+		int i;
+
+		for (i = 0; i < v_actual; i++)
+			vecids[i] = i;
+	}
+
+	for (vector = 0; vector < v_actual; vector++) {
+		adapter->msix_entries[vector].entry = vecids[vector];
+		adapter->msix_entries[vector].vector =
+			pci_irq_vector(adapter->pdev, vector);
+	}
+
+	adapter->num_req_msix = total_vecs;
+	adapter->num_msix_entries = v_actual;
+	/* 'num_avail_msix' is used to distribute excess vectors to the vports
+	 * after considering the minimum vectors required per each default
+	 * vport
+	 */
+	adapter->num_avail_msix = v_actual - min_vectors;
+
+	/* Fill MSIX vector lifo stack with vector indexes */
+	err = idpf_init_vector_stack(adapter);
+	if (err)
+		goto free_vecids;
+
+	err = idpf_mb_intr_init(adapter);
+	if (err)
+		goto deinit_vec_stack;
+	idpf_mb_irq_enable(adapter);
+	kfree(vecids);
+
+	return err;
+
+deinit_vec_stack:
+	idpf_deinit_vector_stack(adapter);
+free_vecids:
+	kfree(vecids);
+free_msix:
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+free_irq:
+	pci_free_irq_vectors(adapter->pdev);
+send_dealloc_vecs:
+	idpf_send_dealloc_vectors_msg(adapter);
+
+	return err;
+}
+
+/**
+ * idpf_service_task - Delayed task for handling mailbox responses
+ * @work: work_struct handle to our data
+ *
+ */
+void idpf_service_task(struct work_struct *work)
+{
+	struct idpf_adapter *adapter;
+
+	adapter = container_of(work, struct idpf_adapter, serv_task.work);
+
+	if (test_bit(IDPF_MB_INTR_MODE, adapter->flags)) {
+		if (test_and_clear_bit(IDPF_MB_INTR_TRIGGER,
+				       adapter->flags)) {
+			idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_UNKNOWN,
+					 NULL, 0);
+			idpf_mb_irq_enable(adapter);
+		}
+	} else {
+		idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_UNKNOWN, NULL, 0);
+	}
+
+	if (idpf_is_reset_detected(adapter) &&
+	    !idpf_is_reset_in_prog(adapter) &&
+	    !test_bit(IDPF_REMOVE_IN_PROG, adapter->flags)) {
+		dev_info(&adapter->pdev->dev, "HW reset detected\n");
+		set_bit(IDPF_HR_FUNC_RESET, adapter->flags);
+		queue_delayed_work(adapter->vc_event_wq,
+				   &adapter->vc_event_task,
+				   msecs_to_jiffies(10));
+	}
+
+	if (!test_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags))
+		queue_delayed_work(adapter->serv_wq, &adapter->serv_task,
+				   msecs_to_jiffies(300));
+}
+
 /**
  * idpf_check_reset_complete - check that reset is complete
  * @hw: pointer to hw struct
@@ -61,9 +388,12 @@ static int idpf_init_hard_reset(struct idpf_adapter *adapter)
 	} else if (test_and_clear_bit(IDPF_HR_FUNC_RESET, adapter->flags)) {
 		bool is_reset = idpf_is_reset_detected(adapter);
 
+		idpf_vc_core_deinit(adapter);
 		if (!is_reset)
 			reg_ops->trigger_reset(adapter, IDPF_HR_FUNC_RESET);
 		idpf_deinit_dflt_mbx(adapter);
+	} else if (test_and_clear_bit(IDPF_HR_CORE_RESET, adapter->flags)) {
+		idpf_vc_core_deinit(adapter);
 	} else {
 		dev_err(dev, "Unhandled hard reset cause\n");
 		err = -EBADRQC;
@@ -80,9 +410,24 @@ static int idpf_init_hard_reset(struct idpf_adapter *adapter)
 
 	/* Reset is complete and so start building the driver resources again */
 	err = idpf_init_dflt_mbx(adapter);
-	if (err)
+	if (err) {
 		dev_err(dev, "Failed to initialize default mailbox: %d\n", err);
+		goto handle_err;
+	}
+
+	/* Initialize the state machine, also allocate memory and request
+	 * resources
+	 */
+	err = idpf_vc_core_init(adapter);
+	if (err)
+		goto init_err;
+
+	mutex_unlock(&adapter->reset_lock);
+
+	return 0;
 
+init_err:
+	idpf_deinit_dflt_mbx(adapter);
 handle_err:
 	mutex_unlock(&adapter->reset_lock);
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index d17487453419..5cdab3b66491 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -25,12 +25,14 @@ static void idpf_remove(struct pci_dev *pdev)
 	 * end up in bad state.
 	 */
 	cancel_delayed_work_sync(&adapter->vc_event_task);
+	idpf_vc_core_deinit(adapter);
 	/* Be a good citizen and leave the device clean on exit */
 	adapter->dev_ops.reg_ops.trigger_reset(adapter, IDPF_HR_FUNC_RESET);
 	idpf_deinit_dflt_mbx(adapter);
 
 	destroy_workqueue(adapter->vc_event_wq);
 	mutex_destroy(&adapter->reset_lock);
+	mutex_destroy(&adapter->vector_lock);
 
 	pci_disable_pcie_error_reporting(pdev);
 	pci_set_drvdata(pdev, NULL);
@@ -127,6 +129,15 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 	pci_set_drvdata(pdev, adapter);
 
+	adapter->serv_wq = alloc_workqueue("%s-%s-service", 0, 0,
+					   dev_driver_string(dev),
+					   dev_name(dev));
+	if (!adapter->serv_wq) {
+		dev_err(dev, "Failed to allocate service workqueue\n");
+		err = -ENOMEM;
+		goto err_mbx_wq_alloc;
+	}
+
 	adapter->vc_event_wq = alloc_workqueue("%s-%s-vc_event", 0, 0,
 					       dev_driver_string(dev),
 					       dev_name(dev));
@@ -147,7 +158,10 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	mutex_init(&adapter->reset_lock);
+	mutex_init(&adapter->vector_lock);
+	init_waitqueue_head(&adapter->vchnl_wq);
 
+	INIT_DELAYED_WORK(&adapter->serv_task, idpf_service_task);
 	INIT_DELAYED_WORK(&adapter->vc_event_task, idpf_vc_event_task);
 
 	adapter->dev_ops.reg_ops.reset_reg_init(adapter);
@@ -160,6 +174,8 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_cfg_hw:
 	destroy_workqueue(adapter->vc_event_wq);
 err_vc_event_wq_alloc:
+	destroy_workqueue(adapter->serv_wq);
+err_mbx_wq_alloc:
 	pci_disable_pcie_error_reporting(pdev);
 err_free:
 	kfree(adapter);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
new file mode 100644
index 000000000000..32f312dbf22b
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2023 Intel Corporation */
+
+#ifndef _IDPF_TXRX_H_
+#define _IDPF_TXRX_H_
+
+/* Default vector sharing */
+#define IDPF_MBX_Q_VEC		1
+#define IDPF_MIN_Q_VEC		1
+
+#define IDPF_INT_NAME_STR_LEN   (IFNAMSIZ + 16)
+
+struct idpf_intr_reg {
+	void __iomem *dyn_ctl;
+	u32 dyn_ctl_intena_m;
+	u32 dyn_ctl_itridx_m;
+	void __iomem *icr_ena;
+	u32 icr_ena_ctlq_m;
+};
+
+struct idpf_q_vector {
+	u16 v_idx;		/* index in the vport->q_vector array */
+	struct idpf_intr_reg intr_reg;
+	char name[IDPF_INT_NAME_STR_LEN];
+};
+#endif /* !_IDPF_TXRX_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
index facf525e8e44..cfaddeff5742 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
@@ -44,6 +44,22 @@ static void idpf_vf_ctlq_reg_init(struct idpf_ctlq_create_info *cq)
 	}
 }
 
+/**
+ * idpf_vf_mb_intr_reg_init - Initialize the mailbox register
+ * @adapter: adapter structure
+ */
+static void idpf_vf_mb_intr_reg_init(struct idpf_adapter *adapter)
+{
+	struct idpf_intr_reg *intr = &adapter->mb_vector.intr_reg;
+	u32 dyn_ctl = le32_to_cpu(adapter->caps.mailbox_dyn_ctl);
+
+	intr->dyn_ctl = idpf_get_reg_addr(adapter, dyn_ctl);
+	intr->dyn_ctl_intena_m = VF_INT_DYN_CTL0_INTENA_M;
+	intr->dyn_ctl_itridx_m = VF_INT_DYN_CTL0_ITR_INDX_M;
+	intr->icr_ena = idpf_get_reg_addr(adapter, VF_INT_ICR0_ENA1);
+	intr->icr_ena_ctlq_m = VF_INT_ICR0_ENA1_ADMINQ_M;
+}
+
 /**
  * idpf_vf_reset_reg_init - Initialize reset registers
  * @adapter: Driver specific private structure
@@ -62,7 +78,10 @@ static void idpf_vf_reset_reg_init(struct idpf_adapter *adapter)
 static void idpf_vf_trigger_reset(struct idpf_adapter *adapter,
 				  enum idpf_flags trig_cause)
 {
-	/* stub */
+	/* Do not send VIRTCHNL2_OP_RESET_VF message on driver unload */
+	if (trig_cause == IDPF_HR_FUNC_RESET &&
+	    !test_bit(IDPF_REMOVE_IN_PROG, adapter->flags))
+		idpf_send_mb_msg(adapter, VIRTCHNL2_OP_RESET_VF, 0, NULL);
 }
 
 /**
@@ -72,6 +91,7 @@ static void idpf_vf_trigger_reset(struct idpf_adapter *adapter,
 static void idpf_vf_reg_ops_init(struct idpf_adapter *adapter)
 {
 	adapter->dev_ops.reg_ops.ctlq_reg_init = idpf_vf_ctlq_reg_init;
+	adapter->dev_ops.reg_ops.mb_intr_reg_init = idpf_vf_mb_intr_reg_init;
 	adapter->dev_ops.reg_ops.reset_reg_init = idpf_vf_reset_reg_init;
 	adapter->dev_ops.reg_ops.trigger_reset = idpf_vf_trigger_reset;
 }
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 33b88cec9c69..98204a52cfcd 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -46,6 +46,634 @@ static int idpf_mb_clean(struct idpf_adapter *adapter)
 	return err;
 }
 
+/**
+ * idpf_send_mb_msg - Send message over mailbox
+ * @adapter: Driver specific private structure
+ * @op: virtchnl opcode
+ * @msg_size: size of the payload
+ * @msg: pointer to buffer holding the payload
+ *
+ * Will prepare the control queue message and initiates the send api
+ *
+ * Returns 0 on success, negative on failure
+ */
+int idpf_send_mb_msg(struct idpf_adapter *adapter, u32 op,
+		     u16 msg_size, u8 *msg)
+{
+	struct idpf_ctlq_msg *ctlq_msg;
+	struct idpf_dma_mem *dma_mem;
+	int err;
+
+	/* If we are here and a reset is detected nothing much can be
+	 * done. This thread should silently abort and expected to
+	 * be corrected with a new run either by user or driver
+	 * flows after reset
+	 */
+	if (idpf_is_reset_detected(adapter))
+		return 0;
+
+	err = idpf_mb_clean(adapter);
+	if (err)
+		return err;
+
+	ctlq_msg = kzalloc(sizeof(*ctlq_msg), GFP_ATOMIC);
+	if (!ctlq_msg)
+		return -ENOMEM;
+
+	dma_mem = kzalloc(sizeof(*dma_mem), GFP_ATOMIC);
+	if (!dma_mem) {
+		err = -ENOMEM;
+		goto dma_mem_error;
+	}
+
+	ctlq_msg->opcode = idpf_mbq_opc_send_msg_to_cp;
+	ctlq_msg->func_id = 0;
+	ctlq_msg->data_len = msg_size;
+	ctlq_msg->cookie.mbx.chnl_opcode = op;
+	ctlq_msg->cookie.mbx.chnl_retval = 0;
+	dma_mem->size = IDPF_DFLT_MBX_BUF_SIZE;
+	dma_mem->va = dma_alloc_coherent(&adapter->pdev->dev, dma_mem->size,
+					 &dma_mem->pa, GFP_ATOMIC);
+	if (!dma_mem->va) {
+		err = -ENOMEM;
+		goto dma_alloc_error;
+	}
+	memcpy(dma_mem->va, msg, msg_size);
+	ctlq_msg->ctx.indirect.payload = dma_mem;
+
+	err = idpf_ctlq_send(&adapter->hw, adapter->hw.asq, 1, ctlq_msg);
+	if (err)
+		goto send_error;
+
+	return 0;
+
+send_error:
+	dma_free_coherent(&adapter->pdev->dev, dma_mem->size, dma_mem->va,
+			  dma_mem->pa);
+dma_alloc_error:
+	kfree(dma_mem);
+dma_mem_error:
+	kfree(ctlq_msg);
+
+	return err;
+}
+
+/**
+ * idpf_set_msg_pending_bit - Wait for clear and set msg pending
+ * @adapter: driver specific private structure
+ * @vport: virtual port structure
+ *
+ * If clear sets msg pending bit, otherwise waits for it to clear before
+ * setting it again. Returns 0 on success, negative on failure.
+ */
+static int idpf_set_msg_pending_bit(struct idpf_adapter *adapter,
+				    struct idpf_vport *vport)
+{
+	unsigned int retries = 100;
+
+	/* If msg pending bit already set, there's a message waiting to be
+	 * parsed and we must wait for it to be cleared before copying a new
+	 * message into the vc_msg buffer or else we'll stomp all over the
+	 * previous message.
+	 */
+	while (retries) {
+		if (!test_and_set_bit(IDPF_VC_MSG_PENDING, adapter->flags))
+			break;
+		msleep(20);
+		retries--;
+	}
+
+	return retries ? 0 : -ETIMEDOUT;
+}
+
+/**
+ * idpf_set_msg_pending - Wait for msg pending bit and copy msg to buf
+ * @adapter: driver specific private structure
+ * @vport: virtual port structure
+ * @ctlq_msg: msg to copy from
+ * @err_enum: err bit to set on error
+ *
+ * Copies payload from ctlq_msg into vc_msg buf in adapter and sets msg pending
+ * bit. Returns 0 on success, negative on failure.
+ */
+static int idpf_set_msg_pending(struct idpf_adapter *adapter,
+				struct idpf_vport *vport,
+				struct idpf_ctlq_msg *ctlq_msg,
+				enum idpf_vport_vc_state err_enum)
+{
+	if (ctlq_msg->cookie.mbx.chnl_retval) {
+		set_bit(err_enum, adapter->vc_state);
+
+		return -EINVAL;
+	}
+
+	if (idpf_set_msg_pending_bit(adapter, vport)) {
+		set_bit(err_enum, adapter->vc_state);
+		dev_err(&adapter->pdev->dev, "Timed out setting msg pending\n");
+
+		return -ETIMEDOUT;
+	}
+
+	memcpy(adapter->vc_msg, ctlq_msg->ctx.indirect.payload->va,
+	       min_t(int, ctlq_msg->ctx.indirect.payload->size,
+		     IDPF_DFLT_MBX_BUF_SIZE));
+
+	return 0;
+}
+
+/**
+ * idpf_recv_vchnl_op - helper function with common logic when handling the
+ * reception of VIRTCHNL OPs.
+ * @adapter: driver specific private structure
+ * @vport: virtual port structure
+ * @ctlq_msg: msg to copy from
+ * @state: state bit used on timeout check
+ * @err_state: err bit to set on error
+ */
+static void idpf_recv_vchnl_op(struct idpf_adapter *adapter,
+			       struct idpf_vport *vport,
+			       struct idpf_ctlq_msg *ctlq_msg,
+			       enum idpf_vport_vc_state state,
+			       enum idpf_vport_vc_state err_state)
+{
+	wait_queue_head_t *vchnl_wq = &adapter->vchnl_wq;
+	int err;
+
+	err = idpf_set_msg_pending(adapter, vport, ctlq_msg, err_state);
+	if (wq_has_sleeper(vchnl_wq)) {
+		/* sleeper is present and we got the pending bit */
+		set_bit(state, adapter->vc_state);
+
+		wake_up(vchnl_wq);
+	} else {
+		if (!err) {
+			/* We got the pending bit, but release it if we cannot
+			 * find a thread waiting for the message.
+			 */
+			dev_warn(&adapter->pdev->dev, "opcode %d received without waiting thread\n",
+				 ctlq_msg->cookie.mbx.chnl_opcode);
+			clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+		} else {
+			/* Clear the errors since there is no sleeper to pass them on */
+			clear_bit(err_state, adapter->vc_state);
+		}
+	}
+}
+
+/**
+ * idpf_recv_mb_msg - Receive message over mailbox
+ * @adapter: Driver specific private structure
+ * @op: virtchannel operation code
+ * @msg: Received message holding buffer
+ * @msg_size: message size
+ *
+ * Will receive control queue message and posts the receive buffer. Returns 0
+ * on success and negative on failure.
+ */
+int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
+		     void *msg, int msg_size)
+{
+	struct idpf_ctlq_msg ctlq_msg;
+	struct idpf_dma_mem *dma_mem;
+	bool work_done = false;
+	int num_retry = 2000;
+	u16 num_q_msg;
+	int err;
+
+	while (1) {
+		int payload_size = 0;
+
+		/* Try to get one message */
+		num_q_msg = 1;
+		dma_mem = NULL;
+		err = idpf_ctlq_recv(adapter->hw.arq, &num_q_msg, &ctlq_msg);
+		/* If no message then decide if we have to retry based on
+		 * opcode
+		 */
+		if (err || !num_q_msg) {
+			/* Increasing num_retry to consider the delayed
+			 * responses because of large number of VF's mailbox
+			 * messages. If the mailbox message is received from
+			 * the other side, we come out of the sleep cycle
+			 * immediately else we wait for more time.
+			 */
+			if (!op || !num_retry--)
+				break;
+			if (test_bit(IDPF_REL_RES_IN_PROG, adapter->flags)) {
+				err = -EIO;
+				break;
+			}
+			msleep(20);
+			continue;
+		}
+
+		/* If we are here a message is received. Check if we are looking
+		 * for a specific message based on opcode. If it is different
+		 * ignore and post buffers
+		 */
+		if (op && ctlq_msg.cookie.mbx.chnl_opcode != op)
+			goto post_buffs;
+
+		if (ctlq_msg.data_len)
+			payload_size = ctlq_msg.ctx.indirect.payload->size;
+
+		/* All conditions are met. Either a message requested is
+		 * received or we received a message to be processed
+		 */
+		switch (ctlq_msg.cookie.mbx.chnl_opcode) {
+		case VIRTCHNL2_OP_VERSION:
+		case VIRTCHNL2_OP_GET_CAPS:
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				dev_err(&adapter->pdev->dev, "Failure initializing, vc op: %u retval: %u\n",
+					ctlq_msg.cookie.mbx.chnl_opcode,
+					ctlq_msg.cookie.mbx.chnl_retval);
+				err = -EBADMSG;
+			} else if (msg) {
+				memcpy(msg, ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int, payload_size, msg_size));
+			}
+			work_done = true;
+			break;
+		case VIRTCHNL2_OP_ALLOC_VECTORS:
+			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
+					   IDPF_VC_ALLOC_VECTORS,
+					   IDPF_VC_ALLOC_VECTORS_ERR);
+			break;
+		case VIRTCHNL2_OP_DEALLOC_VECTORS:
+			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
+					   IDPF_VC_DEALLOC_VECTORS,
+					   IDPF_VC_DEALLOC_VECTORS_ERR);
+			break;
+		default:
+			dev_warn(&adapter->pdev->dev,
+				 "Unhandled virtchnl response %d\n",
+				 ctlq_msg.cookie.mbx.chnl_opcode);
+			break;
+		}
+
+post_buffs:
+		if (ctlq_msg.data_len)
+			dma_mem = ctlq_msg.ctx.indirect.payload;
+		else
+			num_q_msg = 0;
+
+		err = idpf_ctlq_post_rx_buffs(&adapter->hw, adapter->hw.arq,
+					      &num_q_msg, &dma_mem);
+		/* If post failed clear the only buffer we supplied */
+		if (err && dma_mem)
+			dma_free_coherent(&adapter->pdev->dev, dma_mem->size,
+					  dma_mem->va, dma_mem->pa);
+
+		/* Applies only if we are looking for a specific opcode */
+		if (work_done)
+			break;
+	}
+
+	return err;
+}
+
+/**
+ * __idpf_wait_for_event - wrapper function for wait on virtchannel response
+ * @adapter: Driver private data structure
+ * @vport: virtual port structure
+ * @state: check on state upon timeout
+ * @err_check: check if this specific error bit is set
+ * @timeout: Max time to wait
+ *
+ * Checks if state is set upon expiry of timeout.  Returns 0 on success,
+ * negative on failure.
+ */
+static int __idpf_wait_for_event(struct idpf_adapter *adapter,
+				 struct idpf_vport *vport,
+				 enum idpf_vport_vc_state state,
+				 enum idpf_vport_vc_state err_check,
+				 int timeout)
+{
+	int time_to_wait, num_waits;
+	wait_queue_head_t *vchnl_wq;
+	unsigned long *vc_state;
+
+	time_to_wait = ((timeout <= IDPF_MAX_WAIT) ? timeout : IDPF_MAX_WAIT);
+	num_waits = ((timeout <= IDPF_MAX_WAIT) ? 1 : timeout / IDPF_MAX_WAIT);
+
+	vchnl_wq = &adapter->vchnl_wq;
+	vc_state = adapter->vc_state;
+
+	while (num_waits) {
+		int event;
+
+		/* If we are here and a reset is detected do not wait but
+		 * return. Reset timing is out of drivers control. So
+		 * while we are cleaning resources as part of reset if the
+		 * underlying HW mailbox is gone, wait on mailbox messages
+		 * is not meaningful
+		 */
+		if (idpf_is_reset_detected(adapter))
+			return 0;
+
+		event = wait_event_timeout(*vchnl_wq,
+					   test_and_clear_bit(state, vc_state),
+					   msecs_to_jiffies(time_to_wait));
+		if (event) {
+			if (test_and_clear_bit(err_check, vc_state)) {
+				dev_err(&adapter->pdev->dev, "VC response error %s\n",
+					idpf_vport_vc_state_str[err_check]);
+
+				return -EINVAL;
+			}
+
+			return 0;
+		}
+		num_waits--;
+	}
+
+	/* Timeout occurred */
+	dev_err(&adapter->pdev->dev, "VC timeout, state = %s\n",
+		idpf_vport_vc_state_str[state]);
+
+	return -ETIMEDOUT;
+}
+
+/**
+ * idpf_min_wait_for_event - wait for virtchannel response
+ * @adapter: Driver private data structure
+ * @vport: virtual port structure
+ * @state: check on state upon timeout
+ * @err_check: check if this specific error bit is set
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int idpf_min_wait_for_event(struct idpf_adapter *adapter,
+				   struct idpf_vport *vport,
+				   enum idpf_vport_vc_state state,
+				   enum idpf_vport_vc_state err_check)
+{
+	return __idpf_wait_for_event(adapter, vport, state, err_check,
+				     IDPF_WAIT_FOR_EVENT_TIMEO_MIN);
+}
+
+/**
+ * idpf_wait_for_event - wait for virtchannel response
+ * @adapter: Driver private data structure
+ * @vport: virtual port structure
+ * @state: check on state upon timeout after 500ms
+ * @err_check: check if this specific error bit is set
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int idpf_wait_for_event(struct idpf_adapter *adapter,
+			       struct idpf_vport *vport,
+			       enum idpf_vport_vc_state state,
+			       enum idpf_vport_vc_state err_check)
+{
+	/* Increasing the timeout in __IDPF_INIT_SW flow to consider large
+	 * number of VF's mailbox message responses. When a message is received
+	 * on mailbox, this thread is woken up by the idpf_recv_mb_msg before the
+	 * timeout expires. Only in the error case i.e. if no message is
+	 * received on mailbox, we wait for the complete timeout which is
+	 * less likely to happen.
+	 */
+	return __idpf_wait_for_event(adapter, vport, state, err_check,
+				     IDPF_WAIT_FOR_EVENT_TIMEO);
+}
+
+/**
+ * idpf_send_ver_msg - send virtchnl version message
+ * @adapter: Driver specific private structure
+ *
+ * Send virtchnl version message.  Returns 0 on success, negative on failure.
+ */
+static int idpf_send_ver_msg(struct idpf_adapter *adapter)
+{
+	struct virtchnl2_version_info vvi;
+
+	if (adapter->virt_ver_maj) {
+		vvi.major = cpu_to_le32(adapter->virt_ver_maj);
+		vvi.minor = cpu_to_le32(adapter->virt_ver_min);
+	} else {
+		vvi.major = cpu_to_le32(IDPF_VIRTCHNL_VERSION_MAJOR);
+		vvi.minor = cpu_to_le32(IDPF_VIRTCHNL_VERSION_MINOR);
+	}
+
+	return idpf_send_mb_msg(adapter, VIRTCHNL2_OP_VERSION, sizeof(vvi),
+				(u8 *)&vvi);
+}
+
+/**
+ * idpf_recv_ver_msg - Receive virtchnl version message
+ * @adapter: Driver specific private structure
+ *
+ * Receive virtchnl version message. Returns 0 on success, -EAGAIN if we need
+ * to send version message again, otherwise negative on failure.
+ */
+static int idpf_recv_ver_msg(struct idpf_adapter *adapter)
+{
+	struct virtchnl2_version_info vvi;
+	u32 major, minor;
+	int err;
+
+	err = idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_VERSION, &vvi, sizeof(vvi));
+	if (err)
+		return err;
+
+	major = le32_to_cpu(vvi.major);
+	minor = le32_to_cpu(vvi.minor);
+
+	if (major > IDPF_VIRTCHNL_VERSION_MAJOR) {
+		dev_warn(&adapter->pdev->dev,
+			 "Virtchnl major version (%d) greater than supported\n", major);
+
+		return -EINVAL;
+	}
+
+	if (major == IDPF_VIRTCHNL_VERSION_MAJOR &&
+	    minor > IDPF_VIRTCHNL_VERSION_MINOR)
+		dev_warn(&adapter->pdev->dev, "Virtchnl minor version (%d) didn't match\n", minor);
+
+	/* If we have a mismatch, resend version to update receiver on what
+	 * version we will use.
+	 */
+	if (!adapter->virt_ver_maj &&
+	    major != IDPF_VIRTCHNL_VERSION_MAJOR &&
+	    minor != IDPF_VIRTCHNL_VERSION_MINOR)
+		err = -EAGAIN;
+
+	adapter->virt_ver_maj = major;
+	adapter->virt_ver_min = minor;
+
+	return err;
+}
+
+/**
+ * idpf_send_get_caps_msg - Send virtchnl get capabilities message
+ * @adapter: Driver specific private structure
+ *
+ * Send virtchl get capabilities message. Returns 0 on success, negative on
+ * failure.
+ */
+static int idpf_send_get_caps_msg(struct idpf_adapter *adapter)
+{
+	struct virtchnl2_get_capabilities caps = { };
+
+	caps.csum_caps =
+		cpu_to_le32(VIRTCHNL2_CAP_TX_CSUM_L3_IPV4	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_TCP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_UDP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_SCTP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_TCP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_UDP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_SCTP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L3_IPV4	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_TCP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_UDP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_SCTP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_TCP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_UDP	|
+			    VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_SCTP	|
+			    VIRTCHNL2_CAP_TX_CSUM_L3_SINGLE_TUNNEL |
+			    VIRTCHNL2_CAP_RX_CSUM_L3_SINGLE_TUNNEL |
+			    VIRTCHNL2_CAP_TX_CSUM_L4_SINGLE_TUNNEL |
+			    VIRTCHNL2_CAP_RX_CSUM_L4_SINGLE_TUNNEL |
+			    VIRTCHNL2_CAP_RX_CSUM_GENERIC);
+
+	caps.seg_caps =
+		cpu_to_le32(VIRTCHNL2_CAP_SEG_IPV4_TCP		|
+			    VIRTCHNL2_CAP_SEG_IPV4_UDP		|
+			    VIRTCHNL2_CAP_SEG_IPV4_SCTP		|
+			    VIRTCHNL2_CAP_SEG_IPV6_TCP		|
+			    VIRTCHNL2_CAP_SEG_IPV6_UDP		|
+			    VIRTCHNL2_CAP_SEG_IPV6_SCTP		|
+			    VIRTCHNL2_CAP_SEG_TX_SINGLE_TUNNEL);
+
+	caps.rss_caps =
+		cpu_to_le64(VIRTCHNL2_CAP_RSS_IPV4_TCP		|
+			    VIRTCHNL2_CAP_RSS_IPV4_UDP		|
+			    VIRTCHNL2_CAP_RSS_IPV4_SCTP		|
+			    VIRTCHNL2_CAP_RSS_IPV4_OTHER	|
+			    VIRTCHNL2_CAP_RSS_IPV6_TCP		|
+			    VIRTCHNL2_CAP_RSS_IPV6_UDP		|
+			    VIRTCHNL2_CAP_RSS_IPV6_SCTP		|
+			    VIRTCHNL2_CAP_RSS_IPV6_OTHER);
+
+	caps.hsplit_caps =
+		cpu_to_le32(VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V4	|
+			    VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V6);
+
+	caps.rsc_caps =
+		cpu_to_le32(VIRTCHNL2_CAP_RSC_IPV4_TCP		|
+			    VIRTCHNL2_CAP_RSC_IPV6_TCP);
+
+	caps.other_caps =
+		cpu_to_le64(VIRTCHNL2_CAP_SRIOV			|
+			    VIRTCHNL2_CAP_MACFILTER		|
+			    VIRTCHNL2_CAP_SPLITQ_QSCHED		|
+			    VIRTCHNL2_CAP_PROMISC		|
+			    VIRTCHNL2_CAP_LOOPBACK);
+
+	return idpf_send_mb_msg(adapter, VIRTCHNL2_OP_GET_CAPS, sizeof(caps),
+				(u8 *)&caps);
+}
+
+/**
+ * idpf_recv_get_caps_msg - Receive virtchnl get capabilities message
+ * @adapter: Driver specific private structure
+ *
+ * Receive virtchnl get capabilities message. Returns 0 on success, negative on
+ * failure.
+ */
+static int idpf_recv_get_caps_msg(struct idpf_adapter *adapter)
+{
+	return idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_GET_CAPS, &adapter->caps,
+				sizeof(struct virtchnl2_get_capabilities));
+}
+
+/**
+ * idpf_send_alloc_vectors_msg - Send virtchnl alloc vectors message
+ * @adapter: Driver specific private structure
+ * @num_vectors: number of vectors to be allocated
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_alloc_vectors_msg(struct idpf_adapter *adapter, u16 num_vectors)
+{
+	struct virtchnl2_alloc_vectors *alloc_vec, *rcvd_vec;
+	struct virtchnl2_alloc_vectors ac = { };
+	u16 num_vchunks;
+	int size, err;
+
+	ac.num_vectors = cpu_to_le16(num_vectors);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_ALLOC_VECTORS,
+			       sizeof(ac), (u8 *)&ac);
+	if (err)
+		return err;
+
+	err = idpf_wait_for_event(adapter, NULL, IDPF_VC_ALLOC_VECTORS,
+				  IDPF_VC_ALLOC_VECTORS_ERR);
+	if (err)
+		return err;
+
+	rcvd_vec = (struct virtchnl2_alloc_vectors *)adapter->vc_msg;
+	num_vchunks = le16_to_cpu(rcvd_vec->vchunks.num_vchunks);
+
+	size = struct_size(rcvd_vec, vchunks.vchunks, num_vchunks);
+	if (size > sizeof(adapter->vc_msg)) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	kfree(adapter->req_vec_chunks);
+	adapter->req_vec_chunks = NULL;
+	adapter->req_vec_chunks = kmemdup(adapter->vc_msg, size, GFP_KERNEL);
+	if (!adapter->req_vec_chunks) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	alloc_vec = adapter->req_vec_chunks;
+	if (le16_to_cpu(alloc_vec->num_vectors) < num_vectors) {
+		kfree(adapter->req_vec_chunks);
+		adapter->req_vec_chunks = NULL;
+		err = -EINVAL;
+	}
+
+error:
+	clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+
+	return err;
+}
+
+/**
+ * idpf_send_dealloc_vectors_msg - Send virtchnl de allocate vectors message
+ * @adapter: Driver specific private structure
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter)
+{
+	struct virtchnl2_alloc_vectors *ac = adapter->req_vec_chunks;
+	struct virtchnl2_vector_chunks *vcs = &ac->vchunks;
+	int buf_size, err;
+
+	buf_size = struct_size(vcs, vchunks, le16_to_cpu(vcs->num_vchunks));
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_DEALLOC_VECTORS, buf_size,
+			       (u8 *)vcs);
+	if (err)
+		return err;
+
+	err = idpf_min_wait_for_event(adapter, NULL, IDPF_VC_DEALLOC_VECTORS,
+				      IDPF_VC_DEALLOC_VECTORS_ERR);
+	if (err)
+		return err;
+
+	kfree(adapter->req_vec_chunks);
+	adapter->req_vec_chunks = NULL;
+	clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+
+	return 0;
+}
+
 /**
  * idpf_find_ctlq - Given a type and id, find ctlq info
  * @hw: hardware struct
@@ -126,3 +754,182 @@ void idpf_deinit_dflt_mbx(struct idpf_adapter *adapter)
 	adapter->hw.arq = NULL;
 	adapter->hw.asq = NULL;
 }
+
+/**
+ * idpf_vc_core_init - Initialize state machine and get driver specific
+ * resources
+ * @adapter: Driver specific private structure
+ *
+ * This function will initialize the state machine and request all necessary
+ * resources required by the device driver. Once the state machine is
+ * initialized, allocate memory to store vport specific information and also
+ * requests required interrupts.
+ *
+ * Returns 0 on success, -EAGAIN function will get called again,
+ * otherwise negative on failure.
+ */
+int idpf_vc_core_init(struct idpf_adapter *adapter)
+{
+	int task_delay = 30;
+	int err = 0;
+
+	while (adapter->state != __IDPF_INIT_SW) {
+		switch (adapter->state) {
+		case __IDPF_STARTUP:
+			if (idpf_send_ver_msg(adapter))
+				goto init_failed;
+			adapter->state = __IDPF_VER_CHECK;
+			goto restart;
+		case __IDPF_VER_CHECK:
+			err = idpf_recv_ver_msg(adapter);
+			if (err == -EIO) {
+				return err;
+			} else if (err == -EAGAIN) {
+				adapter->state = __IDPF_STARTUP;
+				goto restart;
+			} else if (err) {
+				goto init_failed;
+			}
+			if (idpf_send_get_caps_msg(adapter))
+				goto init_failed;
+			adapter->state = __IDPF_GET_CAPS;
+			goto restart;
+		case __IDPF_GET_CAPS:
+			if (idpf_recv_get_caps_msg(adapter))
+				goto init_failed;
+			adapter->state = __IDPF_INIT_SW;
+			break;
+		default:
+			dev_err(&adapter->pdev->dev, "Device is in bad state: %d\n",
+				adapter->state);
+			goto init_failed;
+		}
+		break;
+restart:
+		/* Give enough time before proceeding further with
+		 * state machine
+		 */
+		msleep(task_delay);
+	}
+
+	/* Start the service task before requesting vectors. This will ensure
+	 * vector information response from mailbox is handled
+	 */
+	queue_delayed_work(adapter->serv_wq, &adapter->serv_task,
+			   msecs_to_jiffies(5 * (adapter->pdev->devfn & 0x07)));
+
+	err = idpf_intr_req(adapter);
+	if (err) {
+		dev_err(&adapter->pdev->dev, "failed to enable interrupt vectors: %d\n",
+			err);
+		goto err_intr_req;
+	}
+
+	goto no_err;
+
+err_intr_req:
+	set_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);
+	cancel_delayed_work_sync(&adapter->serv_task);
+	clear_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);
+no_err:
+	return err;
+
+init_failed:
+	/* Don't retry if we're trying to go down, just bail. */
+	if (test_bit(IDPF_REL_RES_IN_PROG, adapter->flags) ||
+	    test_bit(IDPF_REMOVE_IN_PROG, adapter->flags))
+		return err;
+
+	if (++adapter->mb_wait_count > IDPF_MB_MAX_ERR) {
+		dev_err(&adapter->pdev->dev, "Failed to establish mailbox communications with hardware\n");
+
+		return -EFAULT;
+	}
+	/* If it reached here, it is possible that mailbox queue initialization
+	 * register writes might not have taken effect. Retry to initialize
+	 * the mailbox again
+	 */
+	adapter->state = __IDPF_STARTUP;
+	idpf_deinit_dflt_mbx(adapter);
+	set_bit(IDPF_HR_DRV_LOAD, adapter->flags);
+	queue_delayed_work(adapter->vc_event_wq, &adapter->vc_event_task,
+			   msecs_to_jiffies(task_delay));
+
+	return -EAGAIN;
+}
+
+/**
+ * idpf_vc_core_deinit - Device deinit routine
+ * @adapter: Driver specific private structure
+ *
+ */
+void idpf_vc_core_deinit(struct idpf_adapter *adapter)
+{
+	int i;
+
+	set_bit(IDPF_REL_RES_IN_PROG, adapter->flags);
+
+	idpf_intr_rel(adapter);
+	/* Set all bits as we dont know on which vc_state the vhnl_wq is
+	 * waiting on and wakeup the virtchnl workqueue even if it is waiting
+	 * for the response as we are going down
+	 */
+	for (i = 0; i < IDPF_VC_NBITS; i++)
+		set_bit(i, adapter->vc_state);
+	wake_up(&adapter->vchnl_wq);
+
+	/* Required to indicate periodic task not to schedule again */
+	set_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);
+	cancel_delayed_work_sync(&adapter->serv_task);
+	clear_bit(IDPF_CANCEL_SERVICE_TASK, adapter->flags);
+	/* Clear all the bits */
+	for (i = 0; i < IDPF_VC_NBITS; i++)
+		clear_bit(i, adapter->vc_state);
+
+	clear_bit(IDPF_REL_RES_IN_PROG, adapter->flags);
+}
+
+/**
+ * idpf_get_vec_ids - Initialize vector id from Mailbox parameters
+ * @adapter: adapter structure to get the mailbox vector id
+ * @vecids: Array of vector ids
+ * @num_vecids: number of vector ids
+ * @chunks: vector ids received over mailbox
+ *
+ * Will initialize the mailbox vector id which is received from the
+ * get capabilities and data queue vector ids with ids received as
+ * mailbox parameters.
+ * Returns number of ids filled
+ */
+int idpf_get_vec_ids(struct idpf_adapter *adapter,
+		     u16 *vecids, int num_vecids,
+		     struct virtchnl2_vector_chunks *chunks)
+{
+	u16 num_chunks = le16_to_cpu(chunks->num_vchunks);
+	int num_vecid_filled = 0;
+	int i, j;
+
+	vecids[num_vecid_filled] = adapter->mb_vector.v_idx;
+	num_vecid_filled++;
+
+	for (j = 0; j < num_chunks; j++) {
+		struct virtchnl2_vector_chunk *chunk;
+		u16 start_vecid, num_vec;
+
+		chunk = &chunks->vchunks[j];
+		num_vec = le16_to_cpu(chunk->num_vectors);
+		start_vecid = le16_to_cpu(chunk->start_vector_id);
+
+		for (i = 0; i < num_vec; i++) {
+			if ((num_vecid_filled + i) < num_vecids) {
+				vecids[num_vecid_filled + i] = start_vecid;
+				start_vecid++;
+			} else {
+				break;
+			}
+		}
+		num_vecid_filled = num_vecid_filled + i;
+	}
+
+	return num_vecid_filled;
+}
-- 
2.37.3


