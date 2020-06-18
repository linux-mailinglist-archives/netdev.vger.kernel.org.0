Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B641FEAB5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFRFN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:13:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:27995 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgFRFNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:13:52 -0400
IronPort-SDR: lMgpXku3ws1/q3WGTcYyj54+Tbvn3Z0h98azsDgDy4cBDPGrHAtLb0VPMKqFIJUNDCFc9mTKRP
 e8SXb5bHxRZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="207694695"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="207694695"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:49 -0700
IronPort-SDR: c76nsd7gz+1i95ut1js4zFxqce5gBN8a3gBx/l8dmYGxJ34KF3QvJxrXI2eyThhC1ObBNU8oJ5
 /0RahtFOhRSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495575"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] iecm: Add framework set of header files
Date:   Wed, 17 Jun 2020 22:13:31 -0700
Message-Id: <20200618051344.516587-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Introduces the framework of data for the driver common
module.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/net/intel/iecm.h              | 432 ++++++++++++++++++++
 include/linux/net/intel/iecm_alloc.h        |  29 ++
 include/linux/net/intel/iecm_controlq.h     |  95 +++++
 include/linux/net/intel/iecm_controlq_api.h | 221 ++++++++++
 include/linux/net/intel/iecm_osdep.h        |  24 ++
 include/linux/net/intel/iecm_type.h         |  47 +++
 6 files changed, 848 insertions(+)
 create mode 100644 include/linux/net/intel/iecm.h
 create mode 100644 include/linux/net/intel/iecm_alloc.h
 create mode 100644 include/linux/net/intel/iecm_controlq.h
 create mode 100644 include/linux/net/intel/iecm_controlq_api.h
 create mode 100644 include/linux/net/intel/iecm_osdep.h
 create mode 100644 include/linux/net/intel/iecm_type.h

diff --git a/include/linux/net/intel/iecm.h b/include/linux/net/intel/iecm.h
new file mode 100644
index 000000000000..0a0c4b928622
--- /dev/null
+++ b/include/linux/net/intel/iecm.h
@@ -0,0 +1,432 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Intel Corporation */
+
+#ifndef _IECM_H_
+#define _IECM_H_
+
+#include <linux/aer.h>
+#include <linux/bitmap.h>
+#include <linux/compiler.h>
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/interrupt.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/pkt_sched.h>
+#include <linux/rtnetlink.h>
+#include <linux/sctp.h>
+#include <linux/skbuff.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <net/tcp.h>
+#include <net/ipv6.h>
+#include <net/ip6_checksum.h>
+#include <linux/prefetch.h>
+#include <net/pkt_sched.h>
+
+#include <net/gre.h>
+#include <net/udp_tunnel.h>
+#include <linux/avf/virtchnl.h>
+
+#include <linux/net/intel/iecm_osdep.h>
+#include <linux/net/intel/iecm_controlq_api.h>
+#include <linux/net/intel/iecm_lan_txrx.h>
+
+#include <linux/net/intel/iecm_txrx.h>
+#include <linux/net/intel/iecm_type.h>
+
+extern const char iecm_drv_ver[];
+extern char iecm_drv_name[];
+
+#define IECM_BAR0	0
+#define IECM_NO_FREE_SLOT	0xffff
+
+/* Default Mailbox settings */
+#define IECM_DFLT_MBX_BUF_SIZE	(1 * 1024)
+#define IECM_NUM_QCTX_PER_MSG	3
+#define IECM_DFLT_MBX_Q_LEN	64
+#define IECM_DFLT_MBX_ID	-1
+/* maximum number of times to try before resetting mailbox */
+#define IECM_MB_MAX_ERR	20
+
+#define IECM_MAX_NUM_VPORTS	1
+
+/* default message levels */
+#define IECM_DFLT_NETIF_M (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
+
+/* Forward declaration */
+struct iecm_adapter;
+
+enum iecm_state {
+	__IECM_STARTUP,
+	__IECM_VER_CHECK,
+	__IECM_GET_RES,
+	__IECM_GET_CAPS,
+	__IECM_GET_DFLT_VPORT_PARAMS,
+	__IECM_INIT_SW,
+	__IECM_DOWN,
+	__IECM_UP,
+	__IECM_REMOVE,
+	__IECM_STATE_LAST /* this member MUST be last */
+};
+
+enum iecm_flags {
+	/* Soft reset causes */
+	__IECM_SR_Q_CHANGE, /* Soft reset to do queue change */
+	__IECM_SR_Q_DESC_CHANGE,
+	__IECM_SR_Q_SCH_CHANGE, /* Scheduling mode change in queue context */
+	__IECM_SR_MTU_CHANGE,
+	__IECM_SR_TC_CHANGE,
+	/* Hard reset causes */
+	__IECM_HR_FUNC_RESET, /* Hard reset when txrx timeout */
+	__IECM_HR_CORE_RESET, /* when reset event is received on virtchannel */
+	__IECM_HR_DRV_LOAD, /* Set on driver load for a clean HW */
+	/* Generic bits to share a message */
+	__IECM_DEL_QUEUES,
+	__IECM_UP_REQUESTED, /* Set if open to be called explicitly by driver */
+	/* Mailbox interrupt event */
+	__IECM_MB_INTR_MODE,
+	__IECM_MB_INTR_TRIGGER,
+	/* must be last */
+	__IECM_FLAGS_NBITS,
+};
+
+struct iecm_netdev_priv {
+	struct iecm_vport *vport;
+};
+
+struct iecm_reset_reg {
+	u32 rstat;
+	u32 rstat_m;
+};
+
+/* product specific register API */
+struct iecm_reg_ops {
+	void (*ctlq_reg_init)(struct iecm_ctlq_create_info *cq);
+	void (*vportq_reg_init)(struct iecm_vport *vport);
+	void (*intr_reg_init)(struct iecm_vport *vport);
+	void (*mb_intr_reg_init)(struct iecm_adapter *adapter);
+	void (*reset_reg_init)(struct iecm_reset_reg *reset_reg);
+	void (*trigger_reset)(struct iecm_adapter *adapter,
+			      enum iecm_flags trig_cause);
+};
+
+struct iecm_virtchnl_ops {
+	int (*core_init)(struct iecm_adapter *adapter, int *vport_id);
+	void (*vport_init)(struct iecm_vport *vport, int vport_id);
+	enum iecm_status (*vport_queue_ids_init)(struct iecm_vport *vport);
+	enum iecm_status (*get_caps)(struct iecm_adapter *adapter);
+	enum iecm_status (*config_queues)(struct iecm_vport *vport);
+	enum iecm_status (*enable_queues)(struct iecm_vport *vport);
+	enum iecm_status (*disable_queues)(struct iecm_vport *vport);
+	enum iecm_status (*irq_map_unmap)(struct iecm_vport *vport, bool map);
+	enum iecm_status (*enable_vport)(struct iecm_vport *vport);
+	enum iecm_status (*disable_vport)(struct iecm_vport *vport);
+	enum iecm_status (*destroy_vport)(struct iecm_vport *vport);
+	enum iecm_status (*get_ptype)(struct iecm_vport *vport);
+	enum iecm_status (*get_set_rss_lut)(struct iecm_vport *vport, bool get);
+	enum iecm_status (*get_set_rss_hash)(struct iecm_vport *vport,
+					     bool get);
+	enum iecm_status (*adjust_qs)(struct iecm_vport *vport);
+	enum iecm_status (*recv_mbx_msg)(struct iecm_adapter *adapter,
+					 void *msg, int msg_size,
+					 struct iecm_ctlq_msg *ctlq_msg,
+					 bool *work_done);
+	enum iecm_status (*alloc_vectors)(struct iecm_adapter *adapter,
+					  u16 num_vectors);
+	enum iecm_status (*dealloc_vectors)(struct iecm_adapter *adapter);
+	bool (*is_cap_ena)(struct iecm_adapter *adapter, u64 flag);
+};
+
+struct iecm_dev_ops {
+	void (*reg_ops_init)(struct iecm_adapter *adapter);
+	void (*vc_ops_init)(struct iecm_adapter *adapter);
+	void (*crc_enable)(u64 *td_cmd);
+	struct iecm_reg_ops reg_ops;
+	struct iecm_virtchnl_ops vc_ops;
+};
+
+/* vport specific data structure */
+
+enum  iecm_vport_vc_state {
+	IECM_VC_ENA_VPORT,
+	IECM_VC_ENA_VPORT_ERR,
+	IECM_VC_DIS_VPORT,
+	IECM_VC_DIS_VPORT_ERR,
+	IECM_VC_DESTROY_VPORT,
+	IECM_VC_DESTROY_VPORT_ERR,
+	IECM_VC_CONFIG_TXQ,
+	IECM_VC_CONFIG_TXQ_ERR,
+	IECM_VC_CONFIG_RXQ,
+	IECM_VC_CONFIG_RXQ_ERR,
+	IECM_VC_CONFIG_Q,
+	IECM_VC_CONFIG_Q_ERR,
+	IECM_VC_ENA_QUEUES,
+	IECM_VC_ENA_QUEUES_ERR,
+	IECM_VC_DIS_QUEUES,
+	IECM_VC_DIS_QUEUES_ERR,
+	IECM_VC_MAP_IRQ,
+	IECM_VC_MAP_IRQ_ERR,
+	IECM_VC_UNMAP_IRQ,
+	IECM_VC_UNMAP_IRQ_ERR,
+	IECM_VC_ADD_QUEUES,
+	IECM_VC_ADD_QUEUES_ERR,
+	IECM_VC_DEL_QUEUES,
+	IECM_VC_DEL_QUEUES_ERR,
+	IECM_VC_ALLOC_VECTORS,
+	IECM_VC_ALLOC_VECTORS_ERR,
+	IECM_VC_DEALLOC_VECTORS,
+	IECM_VC_DEALLOC_VECTORS_ERR,
+	IECM_VC_CREATE_VFS,
+	IECM_VC_CREATE_VFS_ERR,
+	IECM_VC_DESTROY_VFS,
+	IECM_VC_DESTROY_VFS_ERR,
+	IECM_VC_GET_RSS_HASH,
+	IECM_VC_GET_RSS_HASH_ERR,
+	IECM_VC_SET_RSS_HASH,
+	IECM_VC_SET_RSS_HASH_ERR,
+	IECM_VC_GET_RSS_LUT,
+	IECM_VC_GET_RSS_LUT_ERR,
+	IECM_VC_SET_RSS_LUT,
+	IECM_VC_SET_RSS_LUT_ERR,
+	IECM_VC_GET_RSS_KEY,
+	IECM_VC_GET_RSS_KEY_ERR,
+	IECM_VC_CONFIG_RSS_KEY,
+	IECM_VC_CONFIG_RSS_KEY_ERR,
+	IECM_VC_GET_STATS,
+	IECM_VC_GET_STATS_ERR,
+	IECM_VC_NBITS
+};
+
+enum iecm_vport_flags {
+	__IECM_VPORT_SW_MARKER,
+	__IECM_VPORT_FLAGS_NBITS,
+};
+
+struct iecm_vport {
+	/* TX */
+	unsigned int num_txq;
+	unsigned int num_complq;
+	/* It makes more sense for descriptor count to be part of only iecm
+	 * queue structure. But when user changes the count via ethtool, driver
+	 * has to store that value somewhere other than queue structure as the
+	 * queues will be freed and allocated again.
+	 */
+	unsigned int txq_desc_count;
+	unsigned int complq_desc_count;
+	unsigned int compln_clean_budget;
+	unsigned int num_txq_grp;
+	struct iecm_txq_group *txq_grps;
+	enum virtchnl_queue_model txq_model;
+	/* Used only in hotpath to get to the right queue very fast */
+	struct iecm_queue **txqs;
+	wait_queue_head_t sw_marker_wq;
+	DECLARE_BITMAP(flags, __IECM_VPORT_FLAGS_NBITS);
+
+	/* RX */
+	unsigned int num_rxq;
+	unsigned int num_bufq;
+	unsigned int rxq_desc_count;
+	unsigned int bufq_desc_count;
+	unsigned int num_rxq_grp;
+	struct iecm_rxq_group *rxq_grps;
+	enum virtchnl_queue_model rxq_model;
+	struct iecm_rx_ptype_decoded rx_ptype_lkup[IECM_RX_MAX_PTYPE];
+
+	struct iecm_adapter *adapter;
+	struct net_device *netdev;
+	u16 vport_type;
+	u16 vport_id;
+	u16 idx;		 /* software index in adapter vports struct */
+	struct rtnl_link_stats64 netstats;
+
+	/* handler for hard interrupt */
+	irqreturn_t (*irq_q_handler)(int irq, void *data);
+	struct iecm_q_vector *q_vectors;	/* q vector array */
+	u16 num_q_vectors;
+	u16 q_vector_base;
+	u16 max_mtu;
+	u8 default_mac_addr[ETH_ALEN];
+	u16 qset_handle;
+	/* Duplicated in queue structure for performance reasons */
+	enum iecm_rx_hsplit rx_hsplit_en;
+};
+
+/* User defined configuration values */
+struct iecm_user_config_data {
+	u32 num_req_qs; /* user requested queues through ethtool */
+	u32 num_req_txq_desc;
+	u32 num_req_rxq_desc;
+	void *req_qs_chunks;
+};
+
+struct iecm_rss_data {
+	u64 rss_hash;
+	u16 rss_key_size;
+	u8 *rss_key;
+	u16 rss_lut_size;
+	u8 *rss_lut;
+};
+
+struct iecm_adapter {
+	struct pci_dev *pdev;
+
+	u32 tx_timeout_count;
+	u32 msg_enable;
+	enum iecm_state state;
+	DECLARE_BITMAP(flags, __IECM_FLAGS_NBITS);
+	struct mutex reset_lock; /* lock to protect reset flows */
+	struct iecm_reset_reg reset_reg;
+	struct iecm_hw hw;
+
+	u16 num_req_msix;
+	u16 num_msix_entries;
+	struct msix_entry *msix_entries;
+	struct virtchnl_alloc_vectors *req_vec_chunks;
+	struct iecm_q_vector mb_vector;
+	/* handler for hard interrupt for mailbox*/
+	irqreturn_t (*irq_mb_handler)(int irq, void *data);
+
+	/* vport structs */
+	struct iecm_vport **vports;	/* vports created by the driver */
+	u16 num_alloc_vport;
+	u16 next_vport;		/* Next free slot in pf->vport[] - 0-based! */
+	struct mutex sw_mutex;	/* lock to protect vport alloc flow */
+
+	struct delayed_work init_task; /* delayed init task */
+	struct workqueue_struct *init_wq;
+	u32 mb_wait_count;
+	struct delayed_work serv_task; /* delayed service task */
+	struct workqueue_struct *serv_wq;
+	struct delayed_work stats_task; /* delayed statistics task */
+	struct workqueue_struct *stats_wq;
+	struct delayed_work vc_event_task; /* delayed virtchannel event task */
+	struct workqueue_struct *vc_event_wq;
+	/* Store the resources data received from control plane */
+	void **vport_params_reqd;
+	void **vport_params_recvd;
+	/* User set parameters */
+	struct iecm_user_config_data config_data;
+	void *caps;
+	wait_queue_head_t vchnl_wq;
+	DECLARE_BITMAP(vc_state, IECM_VC_NBITS);
+	struct mutex vc_msg_lock;	/* lock to protect vc_msg flow */
+	char vc_msg[IECM_DFLT_MBX_BUF_SIZE];
+	struct iecm_rss_data rss_data;
+	struct iecm_dev_ops dev_ops;
+	enum virtchnl_link_speed link_speed;
+	bool link_up;
+};
+
+/**
+ * iecm_is_queue_model_split - check if queue model is split
+ * @q_model: queue model single or split
+ *
+ * Returns true if queue model is split else false
+ */
+static inline int iecm_is_queue_model_split(enum virtchnl_queue_model q_model)
+{
+	return (q_model == VIRTCHNL_QUEUE_MODEL_SPLIT);
+}
+
+/**
+ * iecm_is_cap_ena - Determine if HW capability is supported
+ * @adapter: private data struct
+ * @flag: Feature flag to check
+ */
+static inline bool iecm_is_cap_ena(struct iecm_adapter *adapter, u64 flag)
+{
+	return adapter->dev_ops.vc_ops.is_cap_ena(adapter, flag);
+}
+
+/**
+ * iecm_is_feature_ena - Determine if a particular feature is enabled
+ * @vport: vport to check
+ * @feature: netdev flag to check
+ *
+ * Returns true or false if a particular feature is enabled.
+ */
+static inline bool iecm_is_feature_ena(struct iecm_vport *vport,
+				       netdev_features_t feature)
+{
+	return vport->netdev->features & feature;
+}
+
+/**
+ * iecm_rx_offset - Return expected offset into page to access data
+ * @rx_q: queue we are requesting offset of
+ *
+ * Returns the offset value for queue into the data buffer.
+ */
+static inline unsigned int
+iecm_rx_offset(struct iecm_queue __maybe_unused *rx_q)
+{
+	return 0;
+}
+
+int iecm_probe(struct pci_dev *pdev,
+	       const struct pci_device_id __always_unused *ent,
+	       struct iecm_adapter *adapter);
+void iecm_remove(struct pci_dev *pdev);
+void iecm_shutdown(struct pci_dev *pdev);
+enum iecm_status iecm_vport_adjust_qs(struct iecm_vport *vport);
+enum iecm_status
+iecm_ctlq_reg_init(struct iecm_ctlq_create_info *cq, int num_q);
+enum iecm_status iecm_init_dflt_mbx(struct iecm_adapter *adapter);
+void iecm_deinit_dflt_mbx(struct iecm_adapter *adapter);
+void iecm_vc_ops_init(struct iecm_adapter *adapter);
+int iecm_vc_core_init(struct iecm_adapter *adapter, int *vport_id);
+enum iecm_status
+iecm_wait_for_event(struct iecm_adapter *adapter,
+		    enum iecm_vport_vc_state state,
+		    enum iecm_vport_vc_state err_check);
+enum iecm_status iecm_send_get_caps_msg(struct iecm_adapter *adapter);
+enum iecm_status iecm_send_delete_queues_msg(struct iecm_vport *vport);
+enum iecm_status
+iecm_send_add_queues_msg(struct iecm_vport *vport, u16 num_tx_q,
+			 u16 num_complq, u16 num_rx_q, u16 num_rx_bufq);
+enum iecm_status iecm_initiate_soft_reset(struct iecm_vport *vport,
+					  enum iecm_flags reset_cause);
+enum iecm_status iecm_send_config_tx_queues_msg(struct iecm_vport *vport);
+enum iecm_status iecm_send_config_rx_queues_msg(struct iecm_vport *vport);
+enum iecm_status iecm_send_enable_vport_msg(struct iecm_vport *vport);
+enum iecm_status iecm_send_disable_vport_msg(struct iecm_vport *vport);
+enum iecm_status iecm_send_destroy_vport_msg(struct iecm_vport *vport);
+enum iecm_status iecm_send_get_rx_ptype_msg(struct iecm_vport *vport);
+enum iecm_status
+iecm_send_get_set_rss_key_msg(struct iecm_vport *vport, bool get);
+enum iecm_status
+iecm_send_get_set_rss_lut_msg(struct iecm_vport *vport, bool get);
+enum iecm_status
+iecm_send_get_set_rss_hash_msg(struct iecm_vport *vport, bool get);
+int iecm_vport_params_buf_alloc(struct iecm_adapter *adapter);
+void iecm_vport_params_buf_rel(struct iecm_adapter *adapter);
+struct iecm_vport *iecm_netdev_to_vport(struct net_device *netdev);
+struct iecm_adapter *iecm_netdev_to_adapter(struct net_device *netdev);
+enum iecm_status iecm_send_get_stats_msg(struct iecm_vport *vport);
+int iecm_vport_get_vec_ids(u16 *vecids, int num_vecids,
+			   struct virtchnl_vector_chunks *chunks);
+enum iecm_status
+iecm_recv_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
+		 void *msg, int msg_size);
+enum iecm_status
+iecm_send_mb_msg(struct iecm_adapter *adapter, enum virtchnl_ops op,
+		 u16 msg_size, u8 *msg);
+void iecm_set_ethtool_ops(struct net_device *netdev);
+void iecm_vport_set_hsplit(struct iecm_vport *vport, struct bpf_prog *prog);
+#endif /* !_IECM_H_ */
diff --git a/include/linux/net/intel/iecm_alloc.h b/include/linux/net/intel/iecm_alloc.h
new file mode 100644
index 000000000000..fd13bf085663
--- /dev/null
+++ b/include/linux/net/intel/iecm_alloc.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_ALLOC_H_
+#define _IECM_ALLOC_H_
+
+/* Memory types */
+enum iecm_memset_type {
+	IECM_NONDMA_MEM = 0,
+	IECM_DMA_MEM
+};
+
+/* Memcpy types */
+enum iecm_memcpy_type {
+	IECM_NONDMA_TO_NONDMA = 0,
+	IECM_NONDMA_TO_DMA,
+	IECM_DMA_TO_DMA,
+	IECM_DMA_TO_NONDMA
+};
+
+struct iecm_hw;
+struct iecm_dma_mem;
+
+/* prototype for functions used for dynamic memory allocation */
+void *iecm_alloc_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem,
+			 u64 size);
+void iecm_free_dma_mem(struct iecm_hw *hw, struct iecm_dma_mem *mem);
+
+#endif /* _IECM_ALLOC_H_ */
diff --git a/include/linux/net/intel/iecm_controlq.h b/include/linux/net/intel/iecm_controlq.h
new file mode 100644
index 000000000000..4cba637042cd
--- /dev/null
+++ b/include/linux/net/intel/iecm_controlq.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_CONTROLQ_H_
+#define _IECM_CONTROLQ_H_
+
+#include <linux/net/intel/iecm_controlq_api.h>
+
+/* Maximum buffer lengths for all control queue types */
+#define IECM_CTLQ_MAX_RING_SIZE	1024
+#define IECM_CTLQ_MAX_BUF_LEN	4096
+
+#define IECM_CTLQ_DESC(R, i) \
+	(&(((struct iecm_ctlq_desc *)((R)->desc_ring.va))[i]))
+
+#define IECM_CTLQ_DESC_UNUSED(R) \
+	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->ring_size) + \
+	      (R)->next_to_clean - (R)->next_to_use - 1)
+
+/* Data type manipulation macros. */
+#define IECM_HI_DWORD(x)	((u32)((((x) >> 16) >> 16) & 0xFFFFFFFF))
+#define IECM_LO_DWORD(x)	((u32)((x) & 0xFFFFFFFF))
+#define IECM_HI_WORD(x)		((u16)(((x) >> 16) & 0xFFFF))
+#define IECM_LO_WORD(x)		((u16)((x) & 0xFFFF))
+
+/* Control Queue default settings */
+#define IECM_CTRL_SQ_CMD_TIMEOUT	250  /* msecs */
+
+struct iecm_ctlq_desc {
+	__le16	flags;
+	__le16	opcode;
+	__le16	datalen;	/* 0 for direct commands */
+	union {
+		__le16 ret_val;
+		__le16 pfid_vfid;
+#define IECM_CTLQ_DESC_VF_ID_S	0
+#define IECM_CTLQ_DESC_VF_ID_M	(0x3FF << IECM_CTLQ_DESC_VF_ID_S)
+#define IECM_CTLQ_DESC_PF_ID_S	10
+#define IECM_CTLQ_DESC_PF_ID_M	(0x3F << IECM_CTLQ_DESC_PF_ID_S)
+	};
+	__le32 cookie_high;
+	__le32 cookie_low;
+	union {
+		struct {
+			__le32 param0;
+			__le32 param1;
+			__le32 param2;
+			__le32 param3;
+		} direct;
+		struct {
+			__le32 param0;
+			__le32 param1;
+			__le32 addr_high;
+			__le32 addr_low;
+		} indirect;
+		u8 raw[16];
+	} params;
+};
+
+/* Flags sub-structure
+ * |0  |1  |2  |3  |4  |5  |6  |7  |8  |9  |10 |11 |12 |13 |14 |15 |
+ * |DD |CMP|ERR|  * RSV *  |FTYPE  | *RSV* |RD |VFC|BUF|  * RSV *  |
+ */
+/* command flags and offsets */
+#define IECM_CTLQ_FLAG_DD_S	0
+#define IECM_CTLQ_FLAG_CMP_S	1
+#define IECM_CTLQ_FLAG_ERR_S	2
+#define IECM_CTLQ_FLAG_FTYPE_S	6
+#define IECM_CTLQ_FLAG_RD_S	10
+#define IECM_CTLQ_FLAG_VFC_S	11
+#define IECM_CTLQ_FLAG_BUF_S	12
+
+#define IECM_CTLQ_FLAG_DD	BIT(IECM_CTLQ_FLAG_DD_S)	/* 0x1 */
+#define IECM_CTLQ_FLAG_CMP	BIT(IECM_CTLQ_FLAG_CMP_S)	/* 0x2 */
+#define IECM_CTLQ_FLAG_ERR	BIT(IECM_CTLQ_FLAG_ERR_S)	/* 0x4 */
+#define IECM_CTLQ_FLAG_FTYPE_VM	BIT(IECM_CTLQ_FLAG_FTYPE_S)	/* 0x40 */
+#define IECM_CTLQ_FLAG_FTYPE_PF	BIT(IECM_CTLQ_FLAG_FTYPE_S + 1)	/* 0x80 */
+#define IECM_CTLQ_FLAG_RD	BIT(IECM_CTLQ_FLAG_RD_S)	/* 0x400 */
+#define IECM_CTLQ_FLAG_VFC	BIT(IECM_CTLQ_FLAG_VFC_S)	/* 0x800 */
+#define IECM_CTLQ_FLAG_BUF	BIT(IECM_CTLQ_FLAG_BUF_S)	/* 0x1000 */
+
+struct iecm_mbxq_desc {
+	u8 pad[8];		/* CTLQ flags/opcode/len/retval fields */
+	u32 chnl_opcode;	/* avoid confusion with desc->opcode */
+	u32 chnl_retval;	/* ditto for desc->retval */
+	u32 pf_vf_id;		/* used by CP when sending to PF */
+};
+
+enum iecm_status
+iecm_ctlq_alloc_ring_res(struct iecm_hw *hw,
+			 struct iecm_ctlq_info *cq);
+
+void iecm_ctlq_dealloc_ring_res(struct iecm_hw *hw, struct iecm_ctlq_info *cq);
+
+#endif /* _IECM_CONTROLQ_H_ */
diff --git a/include/linux/net/intel/iecm_controlq_api.h b/include/linux/net/intel/iecm_controlq_api.h
new file mode 100644
index 000000000000..3992abefb479
--- /dev/null
+++ b/include/linux/net/intel/iecm_controlq_api.h
@@ -0,0 +1,221 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_CONTROLQ_API_H_
+#define _IECM_CONTROLQ_API_H_
+
+/* Error Codes */
+enum iecm_status {
+	IECM_SUCCESS				= 0,
+
+	/* Reserve range -1..-49 for generic codes */
+	IECM_ERR_PARAM				= -1,
+	IECM_ERR_NOT_IMPL			= -2,
+	IECM_ERR_NOT_READY			= -3,
+	IECM_ERR_BAD_PTR			= -5,
+	IECM_ERR_INVAL_SIZE			= -6,
+	IECM_ERR_DEVICE_NOT_SUPPORTED		= -8,
+	IECM_ERR_FW_API_VER			= -9,
+	IECM_ERR_NO_MEMORY			= -10,
+	IECM_ERR_CFG				= -11,
+	IECM_ERR_OUT_OF_RANGE			= -12,
+	IECM_ERR_ALREADY_EXISTS			= -13,
+	IECM_ERR_DOES_NOT_EXIST			= -14,
+	IECM_ERR_IN_USE				= -15,
+	IECM_ERR_MAX_LIMIT			= -16,
+	IECM_ERR_RESET_ONGOING			= -17,
+
+	/* Reserve range -100..-109 for CRQ/CSQ specific error codes */
+	IECM_ERR_CTLQ_ERROR			= -100,
+	IECM_ERR_CTLQ_TIMEOUT			= -101,
+	IECM_ERR_CTLQ_FULL			= -102,
+	IECM_ERR_CTLQ_NO_WORK			= -103,
+	IECM_ERR_CTLQ_EMPTY			= -104,
+};
+
+enum iecm_ctlq_err {
+	IECM_CTLQ_RC_OK		= 0,  /* Success */
+	IECM_CTLQ_RC_EPERM	= 1,  /* Operation not permitted */
+	IECM_CTLQ_RC_ENOENT	= 2,  /* No such element */
+	IECM_CTLQ_RC_ESRCH	= 3,  /* Bad opcode */
+	IECM_CTLQ_RC_EINTR	= 4,  /* Operation interrupted */
+	IECM_CTLQ_RC_EIO	= 5,  /* I/O error */
+	IECM_CTLQ_RC_ENXIO	= 6,  /* No such resource */
+	IECM_CTLQ_RC_E2BIG	= 7,  /* Arg too long */
+	IECM_CTLQ_RC_EAGAIN	= 8,  /* Try again */
+	IECM_CTLQ_RC_ENOMEM	= 9,  /* Out of memory */
+	IECM_CTLQ_RC_EACCES	= 10, /* Permission denied */
+	IECM_CTLQ_RC_EFAULT	= 11, /* Bad address */
+	IECM_CTLQ_RC_EBUSY	= 12, /* Device or resource busy */
+	IECM_CTLQ_RC_EEXIST	= 13, /* object already exists */
+	IECM_CTLQ_RC_EINVAL	= 14, /* Invalid argument */
+	IECM_CTLQ_RC_ENOTTY	= 15, /* Not a typewriter */
+	IECM_CTLQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
+	IECM_CTLQ_RC_ENOSYS	= 17, /* Function not implemented */
+	IECM_CTLQ_RC_ERANGE	= 18, /* Parameter out of range */
+	IECM_CTLQ_RC_EFLUSHED	= 19, /* Cmd flushed due to prev cmd error */
+	IECM_CTLQ_RC_BAD_ADDR	= 20, /* Descriptor contains a bad pointer */
+	IECM_CTLQ_RC_EMODE	= 21, /* Op not allowed in current dev mode */
+	IECM_CTLQ_RC_EFBIG	= 22, /* File too big */
+	IECM_CTLQ_RC_ENOSEC	= 24, /* Missing security manifest */
+	IECM_CTLQ_RC_EBADSIG	= 25, /* Bad RSA signature */
+	IECM_CTLQ_RC_ESVN	= 26, /* SVN number prohibits this package */
+	IECM_CTLQ_RC_EBADMAN	= 27, /* Manifest hash mismatch */
+	IECM_CTLQ_RC_EBADBUF	= 28, /* Buffer hash mismatches manifest */
+};
+
+/* Used for queue init, response and events */
+enum iecm_ctlq_type {
+	IECM_CTLQ_TYPE_MAILBOX_TX	= 0,
+	IECM_CTLQ_TYPE_MAILBOX_RX	= 1,
+	IECM_CTLQ_TYPE_CONFIG_TX	= 2,
+	IECM_CTLQ_TYPE_CONFIG_RX	= 3,
+	IECM_CTLQ_TYPE_EVENT_RX		= 4,
+	IECM_CTLQ_TYPE_RDMA_TX		= 5,
+	IECM_CTLQ_TYPE_RDMA_RX		= 6,
+	IECM_CTLQ_TYPE_RDMA_COMPL	= 7
+};
+
+/* Generic Control Queue Structures */
+
+struct iecm_ctlq_reg {
+	/* used for queue tracking */
+	u32 head;
+	u32 tail;
+	/* Below applies only to default mb (if present) */
+	u32 len;
+	u32 bah;
+	u32 bal;
+	u32 len_mask;
+	u32 len_ena_mask;
+	u32 head_mask;
+};
+
+/* Generic queue msg structure */
+struct iecm_ctlq_msg {
+	u16 vmvf_type; /* represents the source of the message on recv */
+#define IECM_VMVF_TYPE_VF 0
+#define IECM_VMVF_TYPE_VM 1
+#define IECM_VMVF_TYPE_PF 2
+	u16 opcode;
+	u16 data_len;	/* data_len = 0 when no payload is attached */
+	union {
+		u16 func_id;	/* when sending a message */
+		u16 status;	/* when receiving a message */
+	};
+	union {
+		struct {
+			u32 chnl_retval;
+			u32 chnl_opcode;
+		} mbx;
+	} cookie;
+	union {
+#define IECM_DIRECT_CTX_SIZE	16
+#define IECM_INDIRECT_CTX_SIZE	8
+		/* 16 bytes of context can be provided or 8 bytes of context
+		 * plus the address of a DMA buffer
+		 */
+		u8 direct[IECM_DIRECT_CTX_SIZE];
+		struct {
+			u8 context[IECM_INDIRECT_CTX_SIZE];
+			struct iecm_dma_mem *payload;
+		} indirect;
+	} ctx;
+};
+
+/* Generic queue info structures */
+/* MB, CONFIG and EVENT q do not have extended info */
+struct iecm_ctlq_create_info {
+	enum iecm_ctlq_type type;
+	/* absolute queue offset passed as input
+	 * -1 for default mailbox if present
+	 */
+	int id;
+	u16 len; /* Queue length passed as input */
+	u16 buf_size; /* buffer size passed as input */
+	u64 base_address; /* output, HPA of the Queue start  */
+	struct iecm_ctlq_reg reg; /* registers accessed by ctlqs */
+
+	int ext_info_size;
+	void *ext_info; /* Specific to q type */
+};
+
+/* Control Queue information */
+struct iecm_ctlq_info {
+	struct list_head cq_list;
+
+	enum iecm_ctlq_type cq_type;
+	int q_id;
+	struct mutex cq_lock;		/* queue lock */
+
+	/* used for interrupt processing */
+	u16 next_to_use;
+	u16 next_to_clean;
+
+	/* starting descriptor to post buffers to after recev */
+	u16 next_to_post;
+	struct iecm_dma_mem desc_ring;	/* descriptor ring memory */
+
+	union {
+		struct iecm_dma_mem **rx_buff;
+		struct iecm_ctlq_msg **tx_msg;
+	} bi;
+
+	u16 buf_size;			/* queue buffer size */
+	u16 ring_size;			/* Number of descriptors */
+	struct iecm_ctlq_reg reg;	/* registers accessed by ctlqs */
+};
+
+/* PF/VF mailbox commands */
+enum iecm_mbx_opc {
+	iecm_mbq_opc_send_msg_to_cp		= 0x0801,
+	iecm_mbq_opc_send_msg_to_vf		= 0x0802,
+	iecm_mbq_opc_send_msg_to_pf		= 0x0803,
+};
+
+/* API supported for control queue management */
+
+/* Will init all required q including default mb.  "q_info" is an array of
+ * create_info structs equal to the number of control queues to be created.
+ */
+enum iecm_status iecm_ctlq_init(struct iecm_hw *hw, u8 num_q,
+				struct iecm_ctlq_create_info *q_info);
+
+/* Allocate and initialize a single control queue, which will be added to the
+ * control queue list; returns a handle to the created control queue
+ */
+enum iecm_status iecm_ctlq_add(struct iecm_hw *hw,
+			       struct iecm_ctlq_create_info *qinfo,
+			       struct iecm_ctlq_info **cq);
+/* Deinitialize and deallocate a single control queue */
+void iecm_ctlq_remove(struct iecm_hw *hw,
+		      struct iecm_ctlq_info *cq);
+
+/* Sends messages to HW and will also free the buffer*/
+enum iecm_status iecm_ctlq_send(struct iecm_hw *hw,
+				struct iecm_ctlq_info *cq,
+				u16 num_q_msg,
+				struct iecm_ctlq_msg q_msg[]);
+
+/* Receives messages and called by interrupt handler/polling
+ * initiated by app/process. Also caller is supposed to free the buffers
+ */
+enum iecm_status iecm_ctlq_recv(struct iecm_hw *hw,
+				struct iecm_ctlq_info *cq,
+				u16 *num_q_msg, struct iecm_ctlq_msg *q_msg);
+/* Reclaims send descriptors on HW write back */
+enum iecm_status iecm_ctlq_clean_sq(struct iecm_hw *hw,
+				    struct iecm_ctlq_info *cq,
+				    u16 *clean_count,
+				    struct iecm_ctlq_msg *msg_status[]);
+
+/* Indicate RX buffers are done being processed */
+enum iecm_status iecm_ctlq_post_rx_buffs(struct iecm_hw *hw,
+					 struct iecm_ctlq_info *cq,
+					 u16 *buff_count,
+					 struct iecm_dma_mem **buffs);
+
+/* Will destroy all q including the default mb */
+enum iecm_status iecm_ctlq_deinit(struct iecm_hw *hw);
+
+#endif /* _IECM_CONTROLQ_API_H_ */
diff --git a/include/linux/net/intel/iecm_osdep.h b/include/linux/net/intel/iecm_osdep.h
new file mode 100644
index 000000000000..59f64f66b9f0
--- /dev/null
+++ b/include/linux/net/intel/iecm_osdep.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_OSDEP_H_
+#define _IECM_OSDEP_H_
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/net/intel/iecm_alloc.h>
+
+#define wr32(a, reg, value)	writel((value), (u8 *)((a)->hw_addr + (reg)))
+#define rd32(a, reg)		readl((u8 *)(a)->hw_addr + (reg))
+#define wr64(a, reg, value)	writeq((value), (u8 *)((a)->hw_addr + (reg)))
+#define rd64(a, reg)		readq((u8 *)(a)->hw_addr + (reg))
+
+struct iecm_dma_mem {
+	void *va;
+	dma_addr_t pa;
+	size_t size;
+};
+
+#define iecm_wmb() wmb() /* memory barrier */
+#endif /* _IECM_OSDEP_H_ */
diff --git a/include/linux/net/intel/iecm_type.h b/include/linux/net/intel/iecm_type.h
new file mode 100644
index 000000000000..5a599285b548
--- /dev/null
+++ b/include/linux/net/intel/iecm_type.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_TYPE_H_
+#define _IECM_TYPE_H_
+
+#include <linux/if_ether.h>
+#include <linux/net/intel/iecm_osdep.h>
+#include <linux/net/intel/iecm_alloc.h>
+#include <linux/net/intel/iecm_controlq.h>
+
+#define MAKEMASK(m, s)	((m) << (s))
+
+/* Bus parameters */
+struct iecm_bus_info {
+	u16 func;
+	u16 device;
+	u16 bus_id;
+};
+
+/* Define the APF hardware struct to replace other control structs as needed
+ * Align to ctlq_hw_info
+ */
+struct iecm_hw {
+	u8 *hw_addr;
+	u64 hw_addr_len;
+	void *back;
+
+	/* control queue - send and receive */
+	struct iecm_ctlq_info *asq;
+	struct iecm_ctlq_info *arq;
+
+	/* subsystem structs */
+	struct iecm_bus_info bus;
+
+	/* pci info */
+	u16 device_id;
+	u16 vendor_id;
+	u16 subsystem_device_id;
+	u16 subsystem_vendor_id;
+	u8 revision_id;
+	bool adapter_stopped;
+
+	struct list_head cq_list_head;
+};
+
+#endif /* _IECM_TYPE_H_ */
-- 
2.26.2

