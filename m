Return-Path: <netdev+bounces-6629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF32717212
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5297281428
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FF340766;
	Tue, 30 May 2023 23:49:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD7340763
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:49:46 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6545D9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685490580; x=1717026580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E3a5QfkZXXpZ5C71EqV9LiY7VKwrSTv7x27rYfeCmUE=;
  b=Vha7PMFTg8On/cQlzKwC191LlCW4rHYGkpH2Ou+KxQnlCNWe3rRmIl54
   vSU3APMojH7Mr7HGli1EpuYfj5ZH7/y/+0oJ1/sRquyOGgH001YXlWyxf
   QOAIlG0VcD26k4eHEf4PJzhBthB9JSP1Fc4ZiqU90eQESCmTkOk4WPb++
   BLKPjz3OddQZKurmWZblo8NZ54eHT/z8hqNLuW44pOsOm0KTTKAnKNUNS
   mEd+mfPpxqX8pNaW9VaFeJ+2Bpek437A5gwfwyE00Y5zoibHufhWqggRY
   AzMGRl4v2FqHzkXGotyAtjNn1/J1OqAIh1c+lliYttE86bLWK3uupUsRX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="334700305"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="334700305"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="709822149"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="709822149"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2023 16:49:36 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Alan Brady <alan.brady@intel.com>,
	anthony.l.nguyen@intel.com,
	pavan.kumar.linga@intel.com,
	emil.s.tantilov@intel.com,
	jesse.brandeburg@intel.com,
	sridhar.samudrala@intel.com,
	shiraz.saleem@intel.com,
	sindhu.devale@intel.com,
	willemb@google.com,
	decot@google.com,
	andrew@lunn.ch,
	leon@kernel.org,
	mst@redhat.com,
	simon.horman@corigine.com,
	shannon.nelson@amd.com,
	stephen@networkplumber.org,
	Alice Michael <alice.michael@intel.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>
Subject: [PATCH net-next 14/15] idpf: add ethtool callbacks
Date: Tue, 30 May 2023 16:45:00 -0700
Message-Id: <20230530234501.2680230-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alan Brady <alan.brady@intel.com>

Initialize all the ethtool ops that are supported by the driver and
add the necessary support for the ethtool callbacks. Also add
asynchronous link notification virtchnl support where the device
Control Plane sends the link status and link speed as an
asynchronous event message. Driver report the link speed on
ethtool .idpf_get_link_ksettings query.

Introduce soft reset function which is used by some of the ethtool
callbacks such as .set_channels, .set_ringparam etc. to change the
existing queue configuration. It deletes the existing queues by sending
delete queues virtchnl message to the CP and calls the 'vport_stop' flow
which disables the queues, vport etc. New set of queues are requested to
the CP and reconfigure the queue context by calling the 'vport_open'
flow. Soft reset flow also adjusts the number of vectors associated to a
vport if .set_channels is called.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/idpf/Makefile      |    1 +
 drivers/net/ethernet/intel/idpf/idpf.h        |   42 +-
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 1331 +++++++++++++++++
 drivers/net/ethernet/intel/idpf/idpf_lib.c    |  158 ++
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   |    3 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   14 +
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   |  248 ++-
 7 files changed, 1792 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_ethtool.c

diff --git a/drivers/net/ethernet/intel/idpf/Makefile b/drivers/net/ethernet/intel/idpf/Makefile
index c5584eb27742..bc842a0980a0 100644
--- a/drivers/net/ethernet/intel/idpf/Makefile
+++ b/drivers/net/ethernet/intel/idpf/Makefile
@@ -9,6 +9,7 @@ idpf-y := \
 	idpf_controlq.o		\
 	idpf_controlq_setup.o	\
 	idpf_dev.o		\
+	idpf_ethtool.o		\
 	idpf_lib.o		\
 	idpf_main.o		\
 	idpf_singleq_txrx.o	\
diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 5eadbaf2061b..cf9a7e317419 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -15,6 +15,7 @@ struct idpf_vport_max_q;
 #include <linux/pci.h>
 #include <linux/bitfield.h>
 #include <linux/sctp.h>
+#include <linux/ethtool.h>
 #include <net/gro.h>
 #include <linux/dim.h>
 
@@ -173,6 +174,10 @@ struct idpf_dev_ops {
 	STATE(IDPF_VC_MAP_IRQ_ERR)		\
 	STATE(IDPF_VC_UNMAP_IRQ)		\
 	STATE(IDPF_VC_UNMAP_IRQ_ERR)		\
+	STATE(IDPF_VC_ADD_QUEUES)		\
+	STATE(IDPF_VC_ADD_QUEUES_ERR)		\
+	STATE(IDPF_VC_DEL_QUEUES)		\
+	STATE(IDPF_VC_DEL_QUEUES_ERR)		\
 	STATE(IDPF_VC_ALLOC_VECTORS)		\
 	STATE(IDPF_VC_ALLOC_VECTORS_ERR)	\
 	STATE(IDPF_VC_DEALLOC_VECTORS)		\
@@ -204,6 +209,10 @@ extern const char * const idpf_vport_vc_state_str[];
 
 /**
  * enum idpf_vport_flags - vport flags
+ * @IDPF_SR_Q_CHANGE: Soft reset queue change
+ * @IDPF_SR_Q_DESC_CHANGE: Soft reset descriptor change
+ * @IDPF_SR_HSPLIT_CHANGE: Soft reset header split change
+ * @IDPF_VPORT_DEL_QUEUES: To send delete queues message
  * @IDPF_VPORT_VC_MSG_PENDING: Virtchnl message buffer received needs to be
  *			       processed
  * @IDPF_VPORT_SW_MARKER: Indicate TX pipe drain software marker packets
@@ -213,15 +222,30 @@ extern const char * const idpf_vport_vc_state_str[];
  * @IDPF_VPORT_FLAGS_NBITS: Must be last
  */
 enum idpf_vport_flags {
+	IDPF_SR_Q_CHANGE,
+	IDPF_SR_Q_DESC_CHANGE,
+	IDPF_SR_HSPLIT_CHANGE,
+	IDPF_VPORT_DEL_QUEUES,
 	IDPF_VPORT_VC_MSG_PENDING,
-	/* Indicate TX pipe drain software marker packets processing is done */
 	IDPF_VPORT_SW_MARKER,
-	/* Asynchronous add/del ether address in flight */
 	IDPF_VPORT_ADD_MAC_REQ,
 	IDPF_VPORT_DEL_MAC_REQ,
 	IDPF_VPORT_FLAGS_NBITS,
 };
 
+struct idpf_port_stats {
+	struct u64_stats_sync stats_sync;
+	u64_stats_t rx_hw_csum_err;
+	u64_stats_t rx_hsplit;
+	u64_stats_t rx_hsplit_hbo;
+	u64_stats_t rx_bad_descs;
+	u64_stats_t tx_linearize;
+	u64_stats_t tx_busy;
+	u64_stats_t tx_drops;
+	u64_stats_t tx_dma_map_errs;
+	struct virtchnl2_vport_stats vport_stats;
+};
+
 enum idpf_vport_state {
 	__IDPF_VPORT_DOWN,
 	__IDPF_VPORT_UP,
@@ -278,8 +302,10 @@ struct idpf_vport {
 #define IDPF_DIM_PROFILE_SLOTS  5
 	u16 rx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
 	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
+	struct idpf_port_stats port_stats;
 
 	bool link_up;
+	u32 link_speed_mbps;
 
 	char vc_msg[IDPF_DFLT_MBX_BUF_SIZE];
 	DECLARE_BITMAP(vc_state, IDPF_VC_NBITS);
@@ -293,6 +319,8 @@ struct idpf_vport {
 	 * the driver is in a namespace in a system that is being shutdown
 	 */
 	struct mutex stop_mutex;
+	/* lock to protect soft reset flow */
+	struct mutex soft_reset_lock;
 
 	/* lock to protect mac filters */
 	spinlock_t mac_filter_list_lock;
@@ -624,6 +652,7 @@ void idpf_service_task(struct work_struct *work);
 void idpf_vc_event_task(struct work_struct *work);
 void idpf_dev_ops_init(struct idpf_adapter *adapter);
 void idpf_vf_dev_ops_init(struct idpf_adapter *adapter);
+int idpf_vport_adjust_qs(struct idpf_vport *vport);
 int idpf_init_dflt_mbx(struct idpf_adapter *adapter);
 void idpf_deinit_dflt_mbx(struct idpf_adapter *adapter);
 int idpf_vc_core_init(struct idpf_adapter *adapter);
@@ -632,6 +661,11 @@ int idpf_intr_req(struct idpf_adapter *adapter);
 void idpf_intr_rel(struct idpf_adapter *adapter);
 int idpf_get_reg_intr_vecs(struct idpf_vport *vport,
 			   struct idpf_vec_regs *reg_vals);
+int idpf_send_delete_queues_msg(struct idpf_vport *vport);
+int idpf_send_add_queues_msg(const struct idpf_vport *vport, u16 num_tx_q,
+			     u16 num_complq, u16 num_rx_q, u16 num_rx_bufq);
+int idpf_initiate_soft_reset(struct idpf_vport *vport,
+			     enum idpf_vport_flags reset_cause);
 int idpf_send_enable_vport_msg(struct idpf_vport *vport);
 int idpf_send_disable_vport_msg(struct idpf_vport *vport);
 int idpf_send_destroy_vport_msg(struct idpf_vport *vport);
@@ -644,6 +678,7 @@ void idpf_deinit_task(struct idpf_adapter *adapter);
 int idpf_req_rel_vector_indexes(struct idpf_adapter *adapter,
 				u16 *q_vector_idxs,
 				struct idpf_vector_info *vec_info);
+int idpf_vport_alloc_vec_indexes(struct idpf_vport *vport);
 int idpf_get_vec_ids(struct idpf_adapter *adapter,
 		     u16 *vecids, int num_vecids,
 		     struct virtchnl2_vector_chunks *chunks);
@@ -651,6 +686,7 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 		     void *msg, int msg_size);
 int idpf_send_mb_msg(struct idpf_adapter *adapter, u32 op,
 		     u16 msg_size, u8 *msg);
+void idpf_set_ethtool_ops(struct net_device *netdev);
 int idpf_vport_alloc_max_qs(struct idpf_adapter *adapter,
 			    struct idpf_vport_max_q *max_q);
 void idpf_vport_dealloc_max_qs(struct idpf_adapter *adapter,
@@ -666,6 +702,8 @@ int idpf_send_enable_queues_msg(struct idpf_vport *vport);
 int idpf_send_create_vport_msg(struct idpf_adapter *adapter,
 			       struct idpf_vport_max_q *max_q);
 int idpf_check_supported_desc_ids(struct idpf_vport *vport);
+void idpf_vport_intr_write_itr(struct idpf_q_vector *q_vector,
+			       u16 itr, bool tx);
 int idpf_send_map_unmap_queue_vector_msg(struct idpf_vport *vport, bool map);
 int idpf_send_set_sriov_vfs_msg(struct idpf_adapter *adapter, u16 num_vfs);
 int idpf_sriov_configure(struct pci_dev *pdev, int num_vfs);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
new file mode 100644
index 000000000000..da6cf24d4223
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -0,0 +1,1331 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2023 Intel Corporation */
+
+#include "idpf.h"
+
+/**
+ * idpf_get_rxnfc - command to get RX flow classification rules
+ * @netdev: network interface device structure
+ * @cmd: ethtool rxnfc command
+ * @rule_locs: pointer to store rule locations
+ *
+ * Returns Success if the command is supported.
+ */
+static int idpf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
+			  u32 __always_unused *rule_locs)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = vport->num_rxq;
+
+		return 0;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+/**
+ * idpf_get_rxfh_key_size - get the RSS hash key size
+ * @netdev: network interface device structure
+ *
+ * Returns the key size on success, error value on failure.
+ */
+static u32 idpf_get_rxfh_key_size(struct net_device *netdev)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_user_config_data *user_config;
+
+	if (!vport)
+		return -EINVAL;
+
+	if (!idpf_is_cap_ena_all(vport->adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS)) {
+		dev_err(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	user_config = &vport->adapter->vport_config[vport->idx]->user_config;
+
+	return user_config->rss_data.rss_key_size;
+}
+
+/**
+ * idpf_get_rxfh_indir_size - get the rx flow hash indirection table size
+ * @netdev: network interface device structure
+ *
+ * Returns the table size on success, error value on failure.
+ */
+static u32 idpf_get_rxfh_indir_size(struct net_device *netdev)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_user_config_data *user_config;
+
+	if (!vport)
+		return -EINVAL;
+
+	if (!idpf_is_cap_ena_all(vport->adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS)) {
+		dev_err(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	user_config = &vport->adapter->vport_config[vport->idx]->user_config;
+
+	return user_config->rss_data.rss_lut_size;
+}
+
+/**
+ * idpf_get_rxfh - get the rx flow hash indirection table
+ * @netdev: network interface device structure
+ * @indir: indirection table
+ * @key: hash key
+ * @hfunc: hash function in use
+ *
+ * Reads the indirection table directly from the hardware. Always returns 0.
+ */
+static int idpf_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+			 u8 *hfunc)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_rss_data *rss_data;
+	struct idpf_adapter *adapter;
+	u16 i;
+
+	if (!vport)
+		return -EINVAL;
+
+	adapter = vport->adapter;
+
+	if (!idpf_is_cap_ena_all(adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS)) {
+		dev_err(&vport->adapter->pdev->dev, "RSS is not supported on this device\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+	if (vport->state != __IDPF_VPORT_UP)
+		return 0;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	if (key)
+		memcpy(key, rss_data->rss_key, rss_data->rss_key_size);
+
+	if (indir) {
+		for (i = 0; i < rss_data->rss_lut_size; i++)
+			indir[i] = rss_data->rss_lut[i];
+	}
+
+	return 0;
+}
+
+/**
+ * idpf_set_rxfh - set the rx flow hash indirection table
+ * @netdev: network interface device structure
+ * @indir: indirection table
+ * @key: hash key
+ * @hfunc: hash function to use
+ *
+ * Returns -EINVAL if the table specifies an invalid queue id, otherwise
+ * returns 0 after programming the table.
+ */
+static int idpf_set_rxfh(struct net_device *netdev, const u32 *indir,
+			 const u8 *key, const u8 hfunc)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_rss_data *rss_data;
+	struct idpf_adapter *adapter;
+	u16 lut;
+
+	if (!vport)
+		return -EINVAL;
+
+	adapter = vport->adapter;
+
+	if (!idpf_is_cap_ena_all(adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS)) {
+		dev_err(&adapter->pdev->dev, "RSS is not supported on this device\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+	if (vport->state != __IDPF_VPORT_UP)
+		return 0;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (key)
+		memcpy(rss_data->rss_key, key, rss_data->rss_key_size);
+
+	if (indir) {
+		for (lut = 0; lut < rss_data->rss_lut_size; lut++)
+			rss_data->rss_lut[lut] = indir[lut];
+	}
+
+	return idpf_config_rss(vport);
+}
+
+/**
+ * idpf_get_channels: get the number of channels supported by the device
+ * @netdev: network interface device structure
+ * @ch: channel information structure
+ *
+ * Report maximum of TX and RX. Report one extra channel to match our MailBox
+ * Queue.
+ */
+static void idpf_get_channels(struct net_device *netdev,
+			      struct ethtool_channels *ch)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_config *vport_config;
+	unsigned int combined;
+	int num_txq, num_rxq;
+	u16 idx;
+
+	if (!vport)
+		return;
+
+	idx = vport->idx;
+	vport_config = vport->adapter->vport_config[idx];
+
+	num_txq = vport_config->user_config.num_req_tx_qs;
+	num_rxq = vport_config->user_config.num_req_rx_qs;
+
+	combined = min(num_txq, num_rxq);
+
+	/* Report maximum channels */
+	ch->max_combined = min_t(u16, vport_config->max_q.max_txq,
+				 vport_config->max_q.max_rxq);
+	ch->max_rx = vport_config->max_q.max_rxq;
+	ch->max_tx = vport_config->max_q.max_txq;
+
+	ch->max_other = IDPF_MAX_MBXQ;
+	ch->other_count = IDPF_MAX_MBXQ;
+
+	ch->combined_count = combined;
+	ch->rx_count = num_rxq - combined;
+	ch->tx_count = num_txq - combined;
+}
+
+/**
+ * idpf_set_channels: set the new channel count
+ * @netdev: network interface device structure
+ * @ch: channel information structure
+ *
+ * Negotiate a new number of channels with CP. Returns 0 on success, negative
+ * on failure.
+ */
+static int idpf_set_channels(struct net_device *netdev,
+			     struct ethtool_channels *ch)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_config *vport_config;
+	int combined, num_txq, num_rxq, err;
+	unsigned int num_req_tx_q;
+	unsigned int num_req_rx_q;
+	struct device *dev;
+	u16 idx;
+
+	if (!vport)
+		return -EINVAL;
+
+	idx = vport->idx;
+	vport_config = vport->adapter->vport_config[idx];
+
+	num_txq = vport_config->user_config.num_req_tx_qs;
+	num_rxq = vport_config->user_config.num_req_rx_qs;
+
+	combined = min(num_txq, num_rxq);
+
+	/* these checks are for cases where user didn't specify a particular
+	 * value on cmd line but we get non-zero value anyway via
+	 * get_channels(); look at ethtool.c in ethtool repository (the user
+	 * space part), particularly, do_schannels() routine
+	 */
+	if (ch->combined_count == combined)
+		ch->combined_count = 0;
+	if (ch->combined_count && ch->rx_count == num_rxq - combined)
+		ch->rx_count = 0;
+	if (ch->combined_count && ch->tx_count == num_txq - combined)
+		ch->tx_count = 0;
+
+	dev = &vport->adapter->pdev->dev;
+	if (!(ch->combined_count || (ch->rx_count && ch->tx_count))) {
+		dev_err(dev, "Please specify at least 1 Rx and 1 Tx channel\n");
+
+		return -EINVAL;
+	}
+
+	num_req_tx_q = ch->combined_count + ch->tx_count;
+	num_req_rx_q = ch->combined_count + ch->rx_count;
+
+	dev = &vport->adapter->pdev->dev;
+	/* It's possible to specify number of queues that exceeds max in a way
+	 * that stack won't catch for us, this should catch that.
+	 */
+	if (num_req_tx_q > vport_config->max_q.max_txq) {
+		dev_info(dev, "Maximum TX queues is %d\n",
+			 vport_config->max_q.max_txq);
+
+		return -EINVAL;
+	}
+	if (num_req_rx_q > vport_config->max_q.max_rxq) {
+		dev_info(dev, "Maximum RX queues is %d\n",
+			 vport_config->max_q.max_rxq);
+
+		return -EINVAL;
+	}
+
+	if (num_req_tx_q == num_txq && num_req_rx_q == num_rxq)
+		return 0;
+
+	vport_config->user_config.num_req_tx_qs = num_req_tx_q;
+	vport_config->user_config.num_req_rx_qs = num_req_rx_q;
+
+	err = idpf_initiate_soft_reset(vport, IDPF_SR_Q_CHANGE);
+	if (err) {
+		/* roll back queue change */
+		vport_config->user_config.num_req_tx_qs = num_txq;
+		vport_config->user_config.num_req_rx_qs = num_rxq;
+	}
+
+	return err;
+}
+
+/**
+ * idpf_get_ringparam - Get ring parameters
+ * @netdev: network interface device structure
+ * @ring: ethtool ringparam structure
+ * @kring: unused
+ * @ext_ack: unused
+ *
+ * Returns current ring parameters. TX and RX rings are reported separately,
+ * but the number of rings is not reported.
+ */
+static void idpf_get_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kring,
+			       struct netlink_ext_ack *ext_ack)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return;
+
+	ring->rx_max_pending = IDPF_MAX_RXQ_DESC;
+	ring->tx_max_pending = IDPF_MAX_TXQ_DESC;
+	ring->rx_pending = vport->rxq_desc_count;
+	ring->tx_pending = vport->txq_desc_count;
+}
+
+/**
+ * idpf_set_ringparam - Set ring parameters
+ * @netdev: network interface device structure
+ * @ring: ethtool ringparam structure
+ * @kring: unused
+ * @ext_ack: unused
+ *
+ * Sets ring parameters. TX and RX rings are controlled separately, but the
+ * number of rings is not specified, so all rings get the same settings.
+ */
+static int idpf_set_ringparam(struct net_device *netdev,
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kring,
+			      struct netlink_ext_ack *ext_ack)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_user_config_data *config_data;
+	u32 new_rx_count, new_tx_count;
+	u16 idx;
+	int i;
+
+	if (!vport)
+		return -EINVAL;
+
+	idx = vport->idx;
+
+	if (ring->tx_pending > IDPF_MAX_TXQ_DESC ||
+	    ring->tx_pending < IDPF_MIN_TXQ_DESC) {
+		netdev_err(netdev, "Descriptors requested (Tx: %u) out of range [%d-%d] (increment %d)\n",
+			   ring->tx_pending,
+			   IDPF_MIN_TXQ_DESC, IDPF_MAX_TXQ_DESC,
+			   IDPF_REQ_DESC_MULTIPLE);
+
+		return -EINVAL;
+	}
+
+	if (ring->rx_pending > IDPF_MAX_RXQ_DESC ||
+	    ring->rx_pending < IDPF_MIN_RXQ_DESC) {
+		netdev_err(netdev, "Descriptors requested (Rx: %u) out of range [%d-%d] (increment %d)\n",
+			   ring->rx_pending,
+			   IDPF_MIN_RXQ_DESC, IDPF_MAX_RXQ_DESC,
+			   IDPF_REQ_RXQ_DESC_MULTIPLE);
+
+		return -EINVAL;
+	}
+
+	new_rx_count = ALIGN(ring->rx_pending, IDPF_REQ_RXQ_DESC_MULTIPLE);
+	if (new_rx_count != ring->rx_pending)
+		netdev_info(netdev, "Requested Rx descriptor count rounded up to %u\n",
+			    new_rx_count);
+
+	new_tx_count = ALIGN(ring->tx_pending, IDPF_REQ_DESC_MULTIPLE);
+	if (new_tx_count != ring->tx_pending)
+		netdev_info(netdev, "Requested Tx descriptor count rounded up to %u\n",
+			    new_tx_count);
+
+	if (new_tx_count == vport->txq_desc_count &&
+	    new_rx_count == vport->rxq_desc_count)
+		return 0;
+
+	config_data = &vport->adapter->vport_config[idx]->user_config;
+	config_data->num_req_txq_desc = new_tx_count;
+	config_data->num_req_rxq_desc = new_rx_count;
+
+	/* Since we adjusted the RX completion queue count, the RX buffer queue
+	 * descriptor count needs to be adjusted as well
+	 */
+	for (i = 0; i < vport->num_bufqs_per_qgrp; i++)
+		vport->bufq_desc_count[i] =
+			IDPF_RX_BUFQ_DESC_COUNT(new_rx_count,
+						vport->num_bufqs_per_qgrp);
+
+	return idpf_initiate_soft_reset(vport, IDPF_SR_Q_DESC_CHANGE);
+}
+
+/**
+ * struct idpf_stats - definition for an ethtool statistic
+ * @stat_string: statistic name to display in ethtool -S output
+ * @sizeof_stat: the sizeof() the stat, must be no greater than sizeof(u64)
+ * @stat_offset: offsetof() the stat from a base pointer
+ *
+ * This structure defines a statistic to be added to the ethtool stats buffer.
+ * It defines a statistic as offset from a common base pointer. Stats should
+ * be defined in constant arrays using the IDPF_STAT macro, with every element
+ * of the array using the same _type for calculating the sizeof_stat and
+ * stat_offset.
+ *
+ * The @sizeof_stat is expected to be sizeof(u8), sizeof(u16), sizeof(u32) or
+ * sizeof(u64). Other sizes are not expected and will produce a WARN_ONCE from
+ * the idpf_add_ethtool_stat() helper function.
+ *
+ * The @stat_string is interpreted as a format string, allowing formatted
+ * values to be inserted while looping over multiple structures for a given
+ * statistics array. Thus, every statistic string in an array should have the
+ * same type and number of format specifiers, to be formatted by variadic
+ * arguments to the idpf_add_stat_string() helper function.
+ */
+struct idpf_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int sizeof_stat;
+	int stat_offset;
+};
+
+/* Helper macro to define an idpf_stat structure with proper size and type.
+ * Use this when defining constant statistics arrays. Note that @_type expects
+ * only a type name and is used multiple times.
+ */
+#define IDPF_STAT(_type, _name, _stat) { \
+	.stat_string = _name, \
+	.sizeof_stat = sizeof_field(_type, _stat), \
+	.stat_offset = offsetof(_type, _stat) \
+}
+
+/* Helper macro for defining some statistics related to queues */
+#define IDPF_QUEUE_STAT(_name, _stat) \
+	IDPF_STAT(struct idpf_queue, _name, _stat)
+
+/* Stats associated with a Tx queue */
+static const struct idpf_stats idpf_gstrings_tx_queue_stats[] = {
+	IDPF_QUEUE_STAT("pkts", q_stats.tx.packets),
+	IDPF_QUEUE_STAT("bytes", q_stats.tx.bytes),
+	IDPF_QUEUE_STAT("lso_pkts", q_stats.tx.lso_pkts),
+};
+
+/* Stats associated with an Rx queue */
+static const struct idpf_stats idpf_gstrings_rx_queue_stats[] = {
+	IDPF_QUEUE_STAT("pkts", q_stats.rx.packets),
+	IDPF_QUEUE_STAT("bytes", q_stats.rx.bytes),
+	IDPF_QUEUE_STAT("rx_gro_hw_pkts", q_stats.rx.rsc_pkts),
+};
+
+#define IDPF_TX_QUEUE_STATS_LEN		ARRAY_SIZE(idpf_gstrings_tx_queue_stats)
+#define IDPF_RX_QUEUE_STATS_LEN		ARRAY_SIZE(idpf_gstrings_rx_queue_stats)
+
+#define IDPF_PORT_STAT(_name, _stat) \
+	IDPF_STAT(struct idpf_vport,  _name, _stat)
+
+static const struct idpf_stats idpf_gstrings_port_stats[] = {
+	IDPF_PORT_STAT("rx-csum_errors", port_stats.rx_hw_csum_err),
+	IDPF_PORT_STAT("rx-hsplit", port_stats.rx_hsplit),
+	IDPF_PORT_STAT("rx-hsplit_hbo", port_stats.rx_hsplit_hbo),
+	IDPF_PORT_STAT("rx-bad_descs", port_stats.rx_bad_descs),
+	IDPF_PORT_STAT("rx-length_errors", port_stats.vport_stats.rx_invalid_frame_length),
+	IDPF_PORT_STAT("tx-skb_drops", port_stats.tx_drops),
+	IDPF_PORT_STAT("tx-dma_map_errs", port_stats.tx_dma_map_errs),
+	IDPF_PORT_STAT("tx-linearized_pkts", port_stats.tx_linearize),
+	IDPF_PORT_STAT("tx-busy_events", port_stats.tx_busy),
+	IDPF_PORT_STAT("rx_bytes", port_stats.vport_stats.rx_bytes),
+	IDPF_PORT_STAT("rx-unicast_pkts", port_stats.vport_stats.rx_unicast),
+	IDPF_PORT_STAT("rx-multicast_pkts", port_stats.vport_stats.rx_multicast),
+	IDPF_PORT_STAT("rx-broadcast_pkts", port_stats.vport_stats.rx_broadcast),
+	IDPF_PORT_STAT("rx-unknown_protocol", port_stats.vport_stats.rx_unknown_protocol),
+	IDPF_PORT_STAT("tx_bytes", port_stats.vport_stats.tx_bytes),
+	IDPF_PORT_STAT("tx-unicast_pkts", port_stats.vport_stats.tx_unicast),
+	IDPF_PORT_STAT("tx-multicast_pkts", port_stats.vport_stats.tx_multicast),
+	IDPF_PORT_STAT("tx-broadcast_pkts", port_stats.vport_stats.tx_broadcast),
+	IDPF_PORT_STAT("tx_errors", port_stats.vport_stats.tx_errors),
+};
+
+#define IDPF_PORT_STATS_LEN ARRAY_SIZE(idpf_gstrings_port_stats)
+
+/**
+ * __idpf_add_qstat_strings - copy stat strings into ethtool buffer
+ * @p: ethtool supplied buffer
+ * @stats: stat definitions array
+ * @size: size of the stats array
+ * @type: stat type
+ * @idx: stat index
+ *
+ * Format and copy the strings described by stats into the buffer pointed at
+ * by p.
+ */
+static void __idpf_add_qstat_strings(u8 **p, const struct idpf_stats *stats,
+				     const unsigned int size, const char *type,
+				     unsigned int idx)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		snprintf((char *)*p, ETH_GSTRING_LEN,
+			 "%2s_q-%u_%.17s", type, idx, stats[i].stat_string);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+/**
+ * idpf_add_qstat_strings - Copy queue stat strings into ethtool buffer
+ * @p: ethtool supplied buffer
+ * @stats: stat definitions array
+ * @type: stat type
+ * @idx: stat idx
+ *
+ * Format and copy the strings described by the const static stats value into
+ * the buffer pointed at by p.
+ *
+ * The parameter @stats is evaluated twice, so parameters with side effects
+ * should be avoided. Additionally, stats must be an array such that
+ * ARRAY_SIZE can be called on it.
+ */
+#define idpf_add_qstat_strings(p, stats, type, idx) \
+	__idpf_add_qstat_strings(p, stats, ARRAY_SIZE(stats), type, idx)
+
+/**
+ * idpf_add_port_stat_strings - Copy port stat strings into ethtool buffer
+ * @p: ethtool buffer
+ * @stats: struct to copy from
+ */
+static void idpf_add_port_stat_strings(u8 **p, const struct idpf_stats *stats)
+{
+	const unsigned int size = IDPF_PORT_STATS_LEN;
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		snprintf((char *)*p, ETH_GSTRING_LEN, "%.32s",
+			 stats[i].stat_string);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+/**
+ * idpf_get_stat_strings - Get stat strings
+ * @netdev: network interface device structure
+ * @data: buffer for string data
+ *
+ * Builds the statistics string table
+ */
+static void idpf_get_stat_strings(struct net_device *netdev, u8 *data)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_config *vport_config;
+	unsigned int i;
+
+	if (!vport)
+		return;
+
+	idpf_add_port_stat_strings(&data, idpf_gstrings_port_stats);
+
+	vport_config = vport->adapter->vport_config[vport->idx];
+	/* It's critical that we always report a constant number of strings and
+	 * that the strings are reported in the same order regardless of how
+	 * many queues are actually in use.
+	 */
+	for (i = 0; i < vport_config->max_q.max_txq; i++)
+		idpf_add_qstat_strings(&data, idpf_gstrings_tx_queue_stats,
+				       "tx", i);
+	for (i = 0; i < vport_config->max_q.max_rxq; i++)
+		idpf_add_qstat_strings(&data, idpf_gstrings_rx_queue_stats,
+				       "rx", i);
+}
+
+/**
+ * idpf_get_strings - Get string set
+ * @netdev: network interface device structure
+ * @sset: id of string set
+ * @data: buffer for string data
+ *
+ * Builds string tables for various string sets
+ */
+static void idpf_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		idpf_get_stat_strings(netdev, data);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * idpf_get_sset_count - Get length of string set
+ * @netdev: network interface device structure
+ * @sset: id of string set
+ *
+ * Reports size of various string tables.
+ */
+static int idpf_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_config *vport_config;
+	u16 max_txq, max_rxq;
+
+	if (sset != ETH_SS_STATS)
+		return -EINVAL;
+
+	if (!vport)
+		return -EINVAL;
+
+	vport_config = vport->adapter->vport_config[vport->idx];
+	/* This size reported back here *must* be constant throughout the
+	 * lifecycle of the netdevice, i.e. we must report the maximum length
+	 * even for queues that don't technically exist.  This is due to the
+	 * fact that this userspace API uses three separate ioctl calls to get
+	 * stats data but has no way to communicate back to userspace when that
+	 * size has changed, which can typically happen as a result of changing
+	 * number of queues. If the number/order of stats change in the middle
+	 * of this call chain it will lead to userspace crashing/accessing bad
+	 * data through buffer under/overflow.
+	 */
+	max_txq = vport_config->max_q.max_txq;
+	max_rxq = vport_config->max_q.max_rxq;
+
+	return IDPF_PORT_STATS_LEN + (IDPF_TX_QUEUE_STATS_LEN * max_txq) +
+	       (IDPF_RX_QUEUE_STATS_LEN * max_rxq);
+}
+
+/**
+ * idpf_add_one_ethtool_stat - copy the stat into the supplied buffer
+ * @data: location to store the stat value
+ * @pstat: old stat pointer to copy from
+ * @stat: the stat definition
+ *
+ * Copies the stat data defined by the pointer and stat structure pair into
+ * the memory supplied as data. If the pointer is null, data will be zero'd.
+ */
+static void idpf_add_one_ethtool_stat(u64 *data, void *pstat,
+				      const struct idpf_stats *stat)
+{
+	char *p;
+
+	if (!pstat) {
+		/* Ensure that the ethtool data buffer is zero'd for any stats
+		 * which don't have a valid pointer.
+		 */
+		*data = 0;
+		return;
+	}
+
+	p = (char *)pstat + stat->stat_offset;
+	switch (stat->sizeof_stat) {
+	case sizeof(u64):
+		*data = *((u64 *)p);
+		break;
+	case sizeof(u32):
+		*data = *((u32 *)p);
+		break;
+	case sizeof(u16):
+		*data = *((u16 *)p);
+		break;
+	case sizeof(u8):
+		*data = *((u8 *)p);
+		break;
+	default:
+		WARN_ONCE(1, "unexpected stat size for %s",
+			  stat->stat_string);
+		*data = 0;
+	}
+}
+
+/**
+ * idpf_add_queue_stats - copy queue statistics into supplied buffer
+ * @data: ethtool stats buffer
+ * @q: the queue to copy
+ *
+ * Queue statistics must be copied while protected by u64_stats_fetch_begin,
+ * so we can't directly use idpf_add_ethtool_stats. Assumes that queue stats
+ * are defined in idpf_gstrings_queue_stats. If the queue pointer is null,
+ * zero out the queue stat values and update the data pointer. Otherwise
+ * safely copy the stats from the queue into the supplied buffer and update
+ * the data pointer when finished.
+ *
+ * This function expects to be called while under rcu_read_lock().
+ */
+static void idpf_add_queue_stats(u64 **data, struct idpf_queue *q)
+{
+	const struct idpf_stats *stats;
+	unsigned int start;
+	unsigned int size;
+	unsigned int i;
+
+	if (q->q_type == VIRTCHNL2_QUEUE_TYPE_RX) {
+		size = IDPF_RX_QUEUE_STATS_LEN;
+		stats = idpf_gstrings_rx_queue_stats;
+	} else {
+		size = IDPF_TX_QUEUE_STATS_LEN;
+		stats = idpf_gstrings_tx_queue_stats;
+	}
+
+	/* To avoid invalid statistics values, ensure that we keep retrying
+	 * the copy until we get a consistent value according to
+	 * u64_stats_fetch_retry.
+	 */
+	do {
+		start = u64_stats_fetch_begin(&q->stats_sync);
+		for (i = 0; i < size; i++)
+			idpf_add_one_ethtool_stat(&(*data)[i], q, &stats[i]);
+	} while (u64_stats_fetch_retry(&q->stats_sync, start));
+
+	/* Once we successfully copy the stats in, update the data pointer */
+	*data += size;
+}
+
+/**
+ * idpf_add_empty_queue_stats - Add stats for a non-existent queue
+ * @data: pointer to data buffer
+ * @qtype: type of data queue
+ *
+ * We must report a constant length of stats back to userspace regardless of
+ * how many queues are actually in use because stats collection happens over
+ * three separate ioctls and there's no way to notify userspace the size
+ * changed between those calls. This adds empty to data to the stats since we
+ * don't have a real queue to refer to for this stats slot.
+ */
+static void idpf_add_empty_queue_stats(u64 **data, u16 qtype)
+{
+	unsigned int i;
+	int stats_len;
+
+	if (qtype == VIRTCHNL2_QUEUE_TYPE_RX)
+		stats_len = IDPF_RX_QUEUE_STATS_LEN;
+	else
+		stats_len = IDPF_TX_QUEUE_STATS_LEN;
+
+	for (i = 0; i < stats_len; i++)
+		(*data)[i] = 0;
+	*data += stats_len;
+}
+
+/**
+ * idpf_add_port_stats - Copy port stats into ethtool buffer
+ * @vport: virtual port struct
+ * @data: ethtool buffer to copy into
+ */
+static void idpf_add_port_stats(struct idpf_vport *vport, u64 **data)
+{
+	unsigned int size = IDPF_PORT_STATS_LEN;
+	unsigned int start;
+	unsigned int i;
+
+	do {
+		start = u64_stats_fetch_begin(&vport->port_stats.stats_sync);
+		for (i = 0; i < size; i++)
+			idpf_add_one_ethtool_stat(&(*data)[i], vport,
+						  &idpf_gstrings_port_stats[i]);
+	} while (u64_stats_fetch_retry(&vport->port_stats.stats_sync, start));
+
+	*data += size;
+}
+
+/**
+ * idpf_collect_queue_stats - accumulate various per queue stats
+ * into port level stats
+ * @vport: pointer to vport struct
+ **/
+static void idpf_collect_queue_stats(struct idpf_vport *vport)
+{
+	struct idpf_port_stats *pstats = &vport->port_stats;
+	int i, j;
+
+	/* zero out port stats since they're actually tracked in per
+	 * queue stats; this is only for reporting
+	 */
+	u64_stats_update_begin(&pstats->stats_sync);
+	u64_stats_set(&pstats->rx_hw_csum_err, 0);
+	u64_stats_set(&pstats->rx_hsplit, 0);
+	u64_stats_set(&pstats->rx_hsplit_hbo, 0);
+	u64_stats_set(&pstats->rx_bad_descs, 0);
+	u64_stats_set(&pstats->tx_linearize, 0);
+	u64_stats_set(&pstats->tx_busy, 0);
+	u64_stats_set(&pstats->tx_drops, 0);
+	u64_stats_set(&pstats->tx_dma_map_errs, 0);
+	u64_stats_update_end(&pstats->stats_sync);
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rxq_grp = &vport->rxq_grps[i];
+		int num_rxq;
+
+		if (idpf_is_queue_model_split(vport->rxq_model))
+			num_rxq = rxq_grp->splitq.num_rxq_sets;
+		else
+			num_rxq = rxq_grp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			u64 hw_csum_err, hsplit, hsplit_hbo, bad_descs;
+			struct idpf_rx_queue_stats *stats;
+			struct idpf_queue *rxq;
+			unsigned int start;
+
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				rxq = &rxq_grp->splitq.rxq_sets[j]->rxq;
+			else
+				rxq = rxq_grp->singleq.rxqs[j];
+
+			if (!rxq)
+				continue;
+
+			do {
+				start = u64_stats_fetch_begin(&rxq->stats_sync);
+
+				stats = &rxq->q_stats.rx;
+				hw_csum_err = u64_stats_read(&stats->hw_csum_err);
+				hsplit = u64_stats_read(&stats->hsplit_pkts);
+				hsplit_hbo = u64_stats_read(&stats->hsplit_buf_ovf);
+				bad_descs = u64_stats_read(&stats->bad_descs);
+			} while (u64_stats_fetch_retry(&rxq->stats_sync, start));
+
+			u64_stats_update_begin(&pstats->stats_sync);
+			u64_stats_add(&pstats->rx_hw_csum_err, hw_csum_err);
+			u64_stats_add(&pstats->rx_hsplit, hsplit);
+			u64_stats_add(&pstats->rx_hsplit_hbo, hsplit_hbo);
+			u64_stats_add(&pstats->rx_bad_descs, bad_descs);
+			u64_stats_update_end(&pstats->stats_sync);
+		}
+	}
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct idpf_txq_group *txq_grp = &vport->txq_grps[i];
+
+		for (j = 0; j < txq_grp->num_txq; j++) {
+			u64 linearize, qbusy, skb_drops, dma_map_errs;
+			struct idpf_queue *txq = txq_grp->txqs[j];
+			struct idpf_tx_queue_stats *stats;
+			unsigned int start;
+
+			if (!txq)
+				continue;
+
+			do {
+				start = u64_stats_fetch_begin(&txq->stats_sync);
+
+				stats = &txq->q_stats.tx;
+				linearize = u64_stats_read(&stats->linearize);
+				qbusy = u64_stats_read(&stats->q_busy);
+				skb_drops = u64_stats_read(&stats->skb_drops);
+				dma_map_errs = u64_stats_read(&stats->dma_map_errs);
+			} while (u64_stats_fetch_retry(&txq->stats_sync, start));
+
+			u64_stats_update_begin(&pstats->stats_sync);
+			u64_stats_add(&pstats->tx_linearize, linearize);
+			u64_stats_add(&pstats->tx_busy, qbusy);
+			u64_stats_add(&pstats->tx_drops, skb_drops);
+			u64_stats_add(&pstats->tx_dma_map_errs, dma_map_errs);
+			u64_stats_update_end(&pstats->stats_sync);
+		}
+	}
+}
+
+/**
+ * idpf_get_ethtool_stats - report device statistics
+ * @netdev: network interface device structure
+ * @stats: ethtool statistics structure
+ * @data: pointer to data buffer
+ *
+ * All statistics are added to the data buffer as an array of u64.
+ */
+static void idpf_get_ethtool_stats(struct net_device *netdev,
+				   struct ethtool_stats __always_unused *stats,
+				   u64 *data)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_config *vport_config;
+	unsigned int total = 0;
+	unsigned int i, j;
+	u16 qtype;
+
+	if (!vport || vport->state != __IDPF_VPORT_UP)
+		return;
+
+	rcu_read_lock();
+
+	idpf_collect_queue_stats(vport);
+	idpf_add_port_stats(vport, &data);
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct idpf_txq_group *txq_grp = &vport->txq_grps[i];
+
+		qtype = VIRTCHNL2_QUEUE_TYPE_TX;
+
+		for (j = 0; j < txq_grp->num_txq; j++, total++) {
+			struct idpf_queue *txq = txq_grp->txqs[j];
+
+			if (!txq)
+				idpf_add_empty_queue_stats(&data, qtype);
+			else
+				idpf_add_queue_stats(&data, txq);
+		}
+	}
+
+	vport_config = vport->adapter->vport_config[vport->idx];
+	/* It is critical we provide a constant number of stats back to
+	 * userspace regardless of how many queues are actually in use because
+	 * there is no way to inform userspace the size has changed between
+	 * ioctl calls. This will fill in any missing stats with zero.
+	 */
+	for (; total < vport_config->max_q.max_txq; total++)
+		idpf_add_empty_queue_stats(&data, VIRTCHNL2_QUEUE_TYPE_TX);
+	total = 0;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rxq_grp = &vport->rxq_grps[i];
+		int num_rxq;
+
+		qtype = VIRTCHNL2_QUEUE_TYPE_RX;
+
+		if (idpf_is_queue_model_split(vport->rxq_model))
+			num_rxq = rxq_grp->splitq.num_rxq_sets;
+		else
+			num_rxq = rxq_grp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, total++) {
+			struct idpf_queue *rxq;
+
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				rxq = &rxq_grp->splitq.rxq_sets[j]->rxq;
+			else
+				rxq = rxq_grp->singleq.rxqs[j];
+			if (!rxq)
+				idpf_add_empty_queue_stats(&data, qtype);
+			else
+				idpf_add_queue_stats(&data, rxq);
+		}
+	}
+
+	for (; total < vport_config->max_q.max_rxq; total++)
+		idpf_add_empty_queue_stats(&data, VIRTCHNL2_QUEUE_TYPE_RX);
+
+	rcu_read_unlock();
+}
+
+/**
+ * idpf_find_rxq - find rxq from q index
+ * @vport: virtual port associated to queue
+ * @q_num: q index used to find queue
+ *
+ * returns pointer to rx queue
+ */
+static struct idpf_queue *idpf_find_rxq(struct idpf_vport *vport, int q_num)
+{
+	int q_grp, q_idx;
+
+	if (!idpf_is_queue_model_split(vport->rxq_model))
+		return vport->rxq_grps->singleq.rxqs[q_num];
+
+	q_grp = q_num / IDPF_DFLT_SPLITQ_RXQ_PER_GROUP;
+	q_idx = q_num % IDPF_DFLT_SPLITQ_RXQ_PER_GROUP;
+
+	return &vport->rxq_grps[q_grp].splitq.rxq_sets[q_idx]->rxq;
+}
+
+/**
+ * idpf_find_txq - find txq from q index
+ * @vport: virtual port associated to queue
+ * @q_num: q index used to find queue
+ *
+ * returns pointer to tx queue
+ */
+static struct idpf_queue *idpf_find_txq(struct idpf_vport *vport, int q_num)
+{
+	int q_grp;
+
+	if (!idpf_is_queue_model_split(vport->txq_model))
+		return vport->txqs[q_num];
+
+	q_grp = q_num / IDPF_DFLT_SPLITQ_TXQ_PER_GROUP;
+
+	return vport->txq_grps[q_grp].complq;
+}
+
+/**
+ * __idpf_get_q_coalesce - get ITR values for specific queue
+ * @ec: ethtool structure to fill with driver's coalesce settings
+ * @q: quuee of Rx or Tx
+ */
+static void __idpf_get_q_coalesce(struct ethtool_coalesce *ec,
+				  struct idpf_queue *q)
+{
+	if (q->q_type == VIRTCHNL2_QUEUE_TYPE_RX) {
+		ec->use_adaptive_rx_coalesce =
+				IDPF_ITR_IS_DYNAMIC(q->q_vector->rx_intr_mode);
+		ec->rx_coalesce_usecs = q->q_vector->rx_itr_value;
+	} else {
+		ec->use_adaptive_tx_coalesce =
+				IDPF_ITR_IS_DYNAMIC(q->q_vector->tx_intr_mode);
+		ec->tx_coalesce_usecs = q->q_vector->tx_itr_value;
+	}
+}
+
+/**
+ * idpf_get_q_coalesce - get ITR values for specific queue
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int idpf_get_q_coalesce(struct net_device *netdev,
+			       struct ethtool_coalesce *ec,
+			       u32 q_num)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	if (vport->state != __IDPF_VPORT_UP)
+		return 0;
+
+	if (q_num >= vport->num_rxq && q_num >= vport->num_txq)
+		return -EINVAL;
+
+	if (q_num < vport->num_rxq)
+		__idpf_get_q_coalesce(ec, idpf_find_rxq(vport, q_num));
+
+	if (q_num < vport->num_txq)
+		__idpf_get_q_coalesce(ec, idpf_find_txq(vport, q_num));
+
+	return 0;
+}
+
+/**
+ * idpf_get_coalesce - get ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to be filled
+ * @kec: unused
+ * @extack: unused
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int idpf_get_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kec,
+			     struct netlink_ext_ack *extack)
+{
+	/* Return coalesce based on queue number zero */
+	return idpf_get_q_coalesce(netdev, ec, 0);
+}
+
+/**
+ * idpf_get_per_q_coalesce - get ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @q_num: queue for which the itr values has to retrieved
+ * @ec: coalesce settings to be filled
+ *
+ * Return 0 on success, and negative on failure
+ */
+
+static int idpf_get_per_q_coalesce(struct net_device *netdev, u32 q_num,
+				   struct ethtool_coalesce *ec)
+{
+	return idpf_get_q_coalesce(netdev, ec, q_num);
+}
+
+/**
+ * __idpf_set_q_coalesce - set ITR values for specific queue
+ * @ec: ethtool structure from user to update ITR settings
+ * @q: queue for which itr values has to be set
+ * @is_rxq: is queue type rx
+ *
+ * Returns 0 on success, negative otherwise.
+ */
+static int __idpf_set_q_coalesce(struct ethtool_coalesce *ec,
+				 struct idpf_queue *q, bool is_rxq)
+{
+	u32 use_adaptive_coalesce, coalesce_usecs;
+	struct idpf_q_vector *qv = q->q_vector;
+	bool is_dim_ena = false;
+	u16 itr_val;
+
+	if (is_rxq) {
+		is_dim_ena = IDPF_ITR_IS_DYNAMIC(qv->rx_intr_mode);
+		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
+		coalesce_usecs = ec->rx_coalesce_usecs;
+		itr_val = qv->rx_itr_value;
+	} else {
+		is_dim_ena = IDPF_ITR_IS_DYNAMIC(qv->tx_intr_mode);
+		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
+		coalesce_usecs = ec->tx_coalesce_usecs;
+		itr_val = qv->tx_itr_value;
+	}
+	if (coalesce_usecs != itr_val && use_adaptive_coalesce) {
+		netdev_err(q->vport->netdev, "Cannot set coalesce usecs if adaptive enabled\n");
+
+		return -EINVAL;
+	}
+
+	if (is_dim_ena && use_adaptive_coalesce)
+		return 0;
+
+	if (coalesce_usecs > IDPF_ITR_MAX) {
+		netdev_err(q->vport->netdev,
+			   "Invalid value, %d-usecs range is 0-%d\n",
+			   coalesce_usecs, IDPF_ITR_MAX);
+
+		return -EINVAL;
+	}
+
+	if (coalesce_usecs % 2) {
+		coalesce_usecs--;
+		netdev_info(q->vport->netdev,
+			    "HW only supports even ITR values, ITR rounded to %d\n",
+			    coalesce_usecs);
+	}
+
+	if (is_rxq) {
+		qv->rx_itr_value = coalesce_usecs;
+		if (use_adaptive_coalesce) {
+			qv->rx_intr_mode = IDPF_ITR_DYNAMIC;
+		} else {
+			qv->rx_intr_mode = !IDPF_ITR_DYNAMIC;
+			idpf_vport_intr_write_itr(qv, qv->rx_itr_value,
+						  false);
+		}
+	} else {
+		qv->tx_itr_value = coalesce_usecs;
+		if (use_adaptive_coalesce) {
+			qv->tx_intr_mode = IDPF_ITR_DYNAMIC;
+		} else {
+			qv->tx_intr_mode = !IDPF_ITR_DYNAMIC;
+			idpf_vport_intr_write_itr(qv, qv->tx_itr_value, true);
+		}
+	}
+
+	/* Update of static/dynamic itr will be taken care when interrupt is
+	 * fired
+	 */
+	return 0;
+}
+
+/**
+ * idpf_set_q_coalesce - set ITR values for specific queue
+ * @vport: vport associated to the queue that need updating
+ * @ec: coalesce settings to program the device with
+ * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
+ * @is_rxq: is queue type rx
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int idpf_set_q_coalesce(struct idpf_vport *vport,
+			       struct ethtool_coalesce *ec,
+			       int q_num, bool is_rxq)
+{
+	struct idpf_queue *q;
+
+	q = is_rxq ? idpf_find_rxq(vport, q_num) : idpf_find_txq(vport, q_num);
+
+	if (q && __idpf_set_q_coalesce(ec, q, is_rxq))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * idpf_set_coalesce - set ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: coalesce settings to program the device with
+ * @kec: unused
+ * @extack: unused
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int idpf_set_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kec,
+			     struct netlink_ext_ack *extack)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	int i, err;
+
+	if (!vport)
+		return -EINVAL;
+
+	if (vport->state != __IDPF_VPORT_UP)
+		return 0;
+
+	for (i = 0; i < vport->num_txq; i++) {
+		err = idpf_set_q_coalesce(vport, ec, i, false);
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < vport->num_rxq; i++) {
+		err = idpf_set_q_coalesce(vport, ec, i, true);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * idpf_set_per_q_coalesce - set ITR values as requested by user
+ * @netdev: pointer to the netdev associated with this query
+ * @q_num: queue for which the itr values has to be set
+ * @ec: coalesce settings to program the device with
+ *
+ * Return 0 on success, and negative on failure
+ */
+static int idpf_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
+				   struct ethtool_coalesce *ec)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	int err;
+
+	if (!vport)
+		return -EINVAL;
+
+	err = idpf_set_q_coalesce(vport, ec, q_num, false);
+	if (err)
+		return err;
+
+	return idpf_set_q_coalesce(vport, ec, q_num, true);
+}
+
+/**
+ * idpf_get_msglevel - Get debug message level
+ * @netdev: network interface device structure
+ *
+ * Returns current debug message level.
+ */
+static u32 idpf_get_msglevel(struct net_device *netdev)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return 0;
+
+	return vport->adapter->msg_enable;
+}
+
+/**
+ * idpf_set_msglevel - Set debug message level
+ * @netdev: network interface device structure
+ * @data: message level
+ *
+ * Set current debug message level. Higher values cause the driver to
+ * be noisier.
+ */
+static void idpf_set_msglevel(struct net_device *netdev, u32 data)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return;
+
+	vport->adapter->msg_enable = data;
+}
+
+/**
+ * idpf_get_link_ksettings - Get Link Speed and Duplex settings
+ * @netdev: network interface device structure
+ * @cmd: ethtool command
+ *
+ * Reports speed/duplex settings.
+ **/
+static int idpf_get_link_ksettings(struct net_device *netdev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	cmd->base.autoneg = AUTONEG_DISABLE;
+	cmd->base.port = PORT_NONE;
+	if (vport->link_up) {
+		cmd->base.duplex = DUPLEX_FULL;
+		cmd->base.speed = vport->link_speed_mbps;
+	} else {
+		cmd->base.duplex = DUPLEX_UNKNOWN;
+		cmd->base.speed = SPEED_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static const struct ethtool_ops idpf_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
+	.get_msglevel		= idpf_get_msglevel,
+	.set_msglevel		= idpf_set_msglevel,
+	.get_link		= ethtool_op_get_link,
+	.get_coalesce		= idpf_get_coalesce,
+	.set_coalesce		= idpf_set_coalesce,
+	.get_per_queue_coalesce = idpf_get_per_q_coalesce,
+	.set_per_queue_coalesce = idpf_set_per_q_coalesce,
+	.get_ethtool_stats	= idpf_get_ethtool_stats,
+	.get_strings		= idpf_get_strings,
+	.get_sset_count		= idpf_get_sset_count,
+	.get_channels		= idpf_get_channels,
+	.get_rxnfc		= idpf_get_rxnfc,
+	.get_rxfh_key_size	= idpf_get_rxfh_key_size,
+	.get_rxfh_indir_size	= idpf_get_rxfh_indir_size,
+	.get_rxfh		= idpf_get_rxfh,
+	.set_rxfh		= idpf_set_rxfh,
+	.set_channels		= idpf_set_channels,
+	.get_ringparam		= idpf_get_ringparam,
+	.set_ringparam		= idpf_set_ringparam,
+	.get_link_ksettings	= idpf_get_link_ksettings,
+};
+
+/**
+ * idpf_set_ethtool_ops - Initialize ethtool ops struct
+ * @netdev: network interface device structure
+ *
+ * Sets ethtool ops struct in our netdev so that ethtool can call
+ * our functions.
+ */
+void idpf_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &idpf_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index a7a3fc0e4d4d..8a649af977bc 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -692,6 +692,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	netdev->features |= dflt_features;
 	netdev->hw_features |= dflt_features | offloads;
 	netdev->hw_enc_features |= dflt_features | offloads;
+	idpf_set_ethtool_ops(netdev);
 	SET_NETDEV_DEV(netdev, &adapter->pdev->dev);
 
 	/* carrier off on init to avoid Tx hangs */
@@ -741,6 +742,12 @@ static void idpf_vport_stop(struct idpf_vport *vport)
 	idpf_send_disable_vport_msg(vport);
 	idpf_send_disable_queues_msg(vport);
 	idpf_send_map_unmap_queue_vector_msg(vport, false);
+	/* Normally we ask for queues in create_vport, but if we're changing
+	 * number of requested queues we do a delete then add instead of
+	 * deleting and reallocating the vport.
+	 */
+	if (test_and_clear_bit(IDPF_VPORT_DEL_QUEUES, vport->flags))
+		idpf_send_delete_queues_msg(vport);
 
 	vport->link_up = false;
 	idpf_vport_intr_deinit(vport);
@@ -1491,6 +1498,157 @@ void idpf_vc_event_task(struct work_struct *work)
 	}
 }
 
+/**
+ * idpf_initiate_soft_reset - Initiate a software reset
+ * @vport: virtual port data struct
+ * @reset_cause: reason for the soft reset
+ *
+ * Soft reset only reallocs vport queue resources. Returns 0 on success,
+ * negative on failure.
+ */
+int idpf_initiate_soft_reset(struct idpf_vport *vport,
+			     enum idpf_vport_flags reset_cause)
+{
+	enum idpf_vport_state current_state = vport->state;
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_vport *new_vport;
+	int err, i;
+
+	/* make sure we do not end up in initiating multiple resets */
+	mutex_lock(&vport->soft_reset_lock);
+
+	/* If the system is low on memory, we can end up in bad state if we
+	 * free all the memory for queue resources and try to allocate them
+	 * again. Instead, we can pre-allocate the new resources before doing
+	 * anything and bailing if the alloc fails.
+	 *
+	 * Make a clone of the existing vport to mimic its current configuration,
+	 * then modify the new structure with any requested changes. Once the
+	 * allocation of the new resources is done, stop the existing vport and
+	 * copy the configuration to the main vport. If an error occurred, the
+	 * existing vport will be untouched.
+	 *
+	 */
+	new_vport = kzalloc(sizeof(*vport), GFP_KERNEL);
+	if (!new_vport) {
+		mutex_unlock(&vport->soft_reset_lock);
+
+		return -ENOMEM;
+	}
+	/* This purposely avoids copying the end of the struct because it
+	 * contains wait_queues and mutexes and other stuff we don't want to
+	 * mess with. Nothing below should use those variables from new_vport
+	 * and should instead always refer to them in vport if they need to.
+	 */
+	memcpy(new_vport, vport, offsetof(struct idpf_vport, state));
+
+	/* Adjust resource parameters prior to reallocating resources */
+	switch (reset_cause) {
+	case IDPF_SR_Q_CHANGE:
+		err = idpf_vport_adjust_qs(new_vport);
+		if (err)
+			goto free_vport;
+		break;
+	case IDPF_SR_Q_DESC_CHANGE:
+		/* Update queue parameters before allocating resources */
+		idpf_vport_calc_num_q_desc(new_vport);
+		break;
+	case IDPF_SR_HSPLIT_CHANGE:
+		break;
+	default:
+		dev_err(&adapter->pdev->dev, "Unhandled soft reset cause\n");
+		err = -EINVAL;
+		goto free_vport;
+	}
+
+	err = idpf_vport_queues_alloc(new_vport);
+	if (err)
+		goto free_vport;
+	if (current_state <= __IDPF_VPORT_DOWN) {
+		idpf_send_delete_queues_msg(vport);
+	} else {
+		set_bit(IDPF_VPORT_DEL_QUEUES, vport->flags);
+		idpf_vport_stop(vport);
+	}
+
+	idpf_deinit_rss(vport);
+	/* We're passing in vport here because we need its wait_queue
+	 * to send a message and it should be getting all the vport
+	 * config data out of the adapter but we need to be careful not
+	 * to add code to add_queues to change the vport config within
+	 * vport itself as it will be wiped with a memcpy later.
+	 */
+	err = idpf_send_add_queues_msg(vport, new_vport->num_txq,
+				       new_vport->num_complq,
+				       new_vport->num_rxq,
+				       new_vport->num_bufq);
+	if (err)
+		goto err_reset;
+
+	/* Same comment as above regarding avoiding copying the wait_queues and
+	 * mutexes applies here. We do not want to mess with those if possible.
+	 */
+	memcpy(vport, new_vport, offsetof(struct idpf_vport, state));
+
+	/* Since idpf_vport_queues_alloc was called with new_port, the queue
+	 * back pointers are currently pointing to the local new_vport. Reset
+	 * the backpointers to the original vport here
+	 */
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		struct idpf_txq_group *tx_qgrp = &vport->txq_grps[i];
+		int j;
+
+		tx_qgrp->vport = vport;
+		for (j = 0; j < tx_qgrp->num_txq; j++)
+			tx_qgrp->txqs[j]->vport = vport;
+
+		if (idpf_is_queue_model_split(vport->txq_model))
+			tx_qgrp->complq->vport = vport;
+	}
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		struct idpf_queue *q;
+		int j, num_rxq;
+
+		rx_qgrp->vport = vport;
+		for (j = 0; j < vport->num_bufqs_per_qgrp; j++)
+			rx_qgrp->splitq.bufq_sets[j].bufq.vport = vport;
+
+		if (idpf_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				q = &rx_qgrp->splitq.rxq_sets[j]->rxq;
+			else
+				q = rx_qgrp->singleq.rxqs[j];
+			q->vport = vport;
+		}
+	}
+
+	kfree(new_vport);
+
+	if (reset_cause == IDPF_SR_Q_CHANGE)
+		idpf_vport_alloc_vec_indexes(vport);
+
+	if (current_state == __IDPF_VPORT_UP)
+		err = idpf_vport_open(vport, false);
+	mutex_unlock(&vport->soft_reset_lock);
+
+	return err;
+
+err_reset:
+	idpf_vport_queues_rel(new_vport);
+free_vport:
+	kfree(new_vport);
+	mutex_unlock(&vport->soft_reset_lock);
+
+	return err;
+}
+
 /**
  * idpf_open - Called when a network interface becomes active
  * @netdev: network interface device structure
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 365658313ba9..2501616506f3 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3979,8 +3979,7 @@ static int idpf_vport_intr_req_irq(struct idpf_vport *vport, char *basename)
  * @itr: Interrupt throttling rate
  * @tx: Tx or Rx ITR
  */
-static void idpf_vport_intr_write_itr(struct idpf_q_vector *q_vector,
-				      u16 itr, bool tx)
+void idpf_vport_intr_write_itr(struct idpf_q_vector *q_vector, u16 itr, bool tx)
 {
 	struct idpf_intr_reg *intr_reg;
 
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 9c9f343ee0e9..9cc43941b8a2 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -9,13 +9,26 @@
 #define IDPF_LARGE_MAX_Q			256
 #define IDPF_MAX_Q				16
 #define IDPF_MIN_Q				2
+/* Mailbox Queue */
+#define IDPF_MAX_MBXQ				1
 
+#define IDPF_MIN_TXQ_DESC			64
+#define IDPF_MIN_RXQ_DESC			64
 #define IDPF_MIN_TXQ_COMPLQ_DESC		256
 #define IDPF_MAX_QIDS				256
 
+/* Number of descriptors in a queue should be a multiple of 32. RX queue
+ * descriptors alone should be a multiple of IDPF_REQ_RXQ_DESC_MULTIPLE
+ * to achieve BufQ descriptors aligned to 32
+ */
+#define IDPF_REQ_DESC_MULTIPLE			32
+#define IDPF_REQ_RXQ_DESC_MULTIPLE (IDPF_MAX_BUFQS_PER_RXQ_GRP * 32)
 #define IDPF_MIN_TX_DESC_NEEDED (MAX_SKB_FRAGS + 6)
 #define IDPF_TX_WAKE_THRESH ((u16)IDPF_MIN_TX_DESC_NEEDED * 2)
 
+#define IDPF_MAX_DESCS				8160
+#define IDPF_MAX_TXQ_DESC ALIGN_DOWN(IDPF_MAX_DESCS, IDPF_REQ_DESC_MULTIPLE)
+#define IDPF_MAX_RXQ_DESC ALIGN_DOWN(IDPF_MAX_DESCS, IDPF_REQ_RXQ_DESC_MULTIPLE)
 #define MIN_SUPPORT_TXDID (\
 	VIRTCHNL2_TXDID_FLEX_FLOW_SCHED |\
 	VIRTCHNL2_TXDID_FLEX_TSO_CTX)
@@ -499,6 +512,7 @@ union idpf_queue_stats {
 };
 
 #define IDPF_ITR_DYNAMIC	1
+#define IDPF_ITR_MAX		0x1FE0
 #define IDPF_ITR_20K		0x0032
 #define IDPF_ITR_GRAN_S		1	/* Assume ITR granularity is 2us */
 #define IDPF_ITR_MASK		0x1FFE  /* ITR register value alignment mask */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 142252e23952..f31f933bfdb2 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -3,6 +3,48 @@
 
 #include "idpf.h"
 
+/**
+ * idpf_recv_event_msg - Receive virtchnl event message
+ * @vport: virtual port structure
+ *
+ * Receive virtchnl event message
+ */
+static void idpf_recv_event_msg(struct idpf_vport *vport)
+{
+	struct virtchnl2_event *v2e = NULL;
+	bool link_status;
+	u32 event;
+
+	v2e = (struct virtchnl2_event *)vport->vc_msg;
+	event = le32_to_cpu(v2e->event);
+
+	switch (event) {
+	case VIRTCHNL2_EVENT_LINK_CHANGE:
+		vport->link_speed_mbps = le32_to_cpu(v2e->link_speed);
+		link_status = v2e->link_status;
+
+		if (vport->link_up == link_status)
+			break;
+
+		vport->link_up = link_status;
+		if (vport->state == __IDPF_VPORT_UP) {
+			if (vport->link_up) {
+				netif_carrier_on(vport->netdev);
+				netif_tx_start_all_queues(vport->netdev);
+			} else {
+				netif_tx_stop_all_queues(vport->netdev);
+				netif_carrier_off(vport->netdev);
+			}
+		}
+		break;
+	default:
+		dev_err(&vport->adapter->pdev->dev,
+			"Unknown event %d from PF\n", event);
+		break;
+	}
+	clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+}
+
 /**
  * idpf_mb_clean - Reclaim the send mailbox queue entries
  * @adapter: Driver specific private structure
@@ -176,8 +218,12 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 		break;
 	case VIRTCHNL2_OP_ENABLE_QUEUES:
 	case VIRTCHNL2_OP_DISABLE_QUEUES:
+	case VIRTCHNL2_OP_DEL_QUEUES:
 		v_id = le32_to_cpu(((struct virtchnl2_del_ena_dis_queues *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_ADD_QUEUES:
+		v_id = le32_to_cpu(((struct virtchnl2_add_queues *)vc_msg)->vport_id);
+		break;
 	case VIRTCHNL2_OP_MAP_QUEUE_VECTOR:
 	case VIRTCHNL2_OP_UNMAP_QUEUE_VECTOR:
 		v_id = le32_to_cpu(((struct virtchnl2_queue_vector_maps *)vc_msg)->vport_id);
@@ -190,6 +236,9 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_SET_RSS_KEY:
 		v_id = le32_to_cpu(((struct virtchnl2_rss_key *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_EVENT:
+		v_id = le32_to_cpu(((struct virtchnl2_event *)vc_msg)->vport_id);
+		break;
 	case VIRTCHNL2_OP_ADD_MAC_ADDR:
 	case VIRTCHNL2_OP_DEL_MAC_ADDR:
 		v_id = le32_to_cpu(((struct virtchnl2_mac_addr_list *)vc_msg)->vport_id);
@@ -472,6 +521,16 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_DIS_QUEUES,
 					   IDPF_VC_DIS_QUEUES_ERR);
 			break;
+		case VIRTCHNL2_OP_ADD_QUEUES:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_ADD_QUEUES,
+					   IDPF_VC_ADD_QUEUES_ERR);
+			break;
+		case VIRTCHNL2_OP_DEL_QUEUES:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_DEL_QUEUES,
+					   IDPF_VC_DEL_QUEUES_ERR);
+			break;
 		case VIRTCHNL2_OP_MAP_QUEUE_VECTOR:
 			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
 					   IDPF_VC_MAP_IRQ,
@@ -557,6 +616,17 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_DEL_MAC_ADDR,
 					   IDPF_VC_DEL_MAC_ADDR_ERR);
 			break;
+		case VIRTCHNL2_OP_EVENT:
+			if (idpf_set_msg_pending_bit(adapter, vport)) {
+				dev_err(&adapter->pdev->dev, "Timed out setting msg pending\n");
+			} else {
+				memcpy(vport->vc_msg,
+				       ctlq_msg.ctx.indirect.payload->va,
+				       min_t(int, payload_size,
+					     IDPF_DFLT_MBX_BUF_SIZE));
+				idpf_recv_event_msg(vport);
+			}
+			break;
 		default:
 			dev_warn(&adapter->pdev->dev,
 				 "Unhandled virtchnl response %d\n",
@@ -2025,6 +2095,88 @@ int idpf_send_disable_queues_msg(struct idpf_vport *vport)
 	return idpf_wait_for_marker_event(vport);
 }
 
+/**
+ * idpf_convert_reg_to_queue_chunks - Copy queue chunk information to the right
+ * structure
+ * @dchunks: Destination chunks to store data to
+ * @schunks: Source chunks to copy data from
+ * @num_chunks: number of chunks to copy
+ */
+static void idpf_convert_reg_to_queue_chunks(struct virtchnl2_queue_chunk *dchunks,
+					     struct virtchnl2_queue_reg_chunk *schunks,
+					     u16 num_chunks)
+{
+	u16 i;
+
+	for (i = 0; i < num_chunks; i++) {
+		dchunks[i].type = schunks[i].type;
+		dchunks[i].start_queue_id = schunks[i].start_queue_id;
+		dchunks[i].num_queues = schunks[i].num_queues;
+	}
+}
+
+/**
+ * idpf_send_delete_queues_msg - send delete queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send delete queues virtchnl message. Return 0 on success, negative on
+ * failure.
+ */
+int idpf_send_delete_queues_msg(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_create_vport *vport_params;
+	struct virtchnl2_queue_reg_chunks *chunks;
+	struct virtchnl2_del_ena_dis_queues *eq;
+	struct idpf_vport_config *vport_config;
+	u16 vport_idx = vport->idx;
+	int buf_size, err;
+	u16 num_chunks;
+
+	vport_config = adapter->vport_config[vport_idx];
+	if (vport_config->req_qs_chunks) {
+		struct virtchnl2_add_queues *vc_aq =
+			(struct virtchnl2_add_queues *)vport_config->req_qs_chunks;
+		chunks = &vc_aq->chunks;
+	} else {
+		vport_params = (struct virtchnl2_create_vport *)
+				adapter->vport_params_recvd[vport_idx];
+		chunks = &vport_params->chunks;
+	}
+
+	num_chunks = le16_to_cpu(chunks->num_chunks);
+	buf_size = struct_size(eq, chunks.chunks, num_chunks);
+
+	eq = kzalloc(buf_size, GFP_KERNEL);
+	if (!eq)
+		return -ENOMEM;
+
+	eq->vport_id = cpu_to_le32(vport->vport_id);
+	eq->chunks.num_chunks = cpu_to_le16(num_chunks);
+
+	idpf_convert_reg_to_queue_chunks(eq->chunks.chunks, chunks->chunks,
+					 num_chunks);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_DEL_QUEUES,
+			       buf_size, (u8 *)eq);
+	if (err)
+		goto error;
+
+	err = idpf_min_wait_for_event(adapter, vport, IDPF_VC_DEL_QUEUES,
+				      IDPF_VC_DEL_QUEUES_ERR);
+	if (err)
+		goto error;
+
+	clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+
+	return 0;
+
+error:
+	kfree(eq);
+
+	return err;
+}
+
 /**
  * idpf_send_config_queues_msg - Send config queues virtchnl message
  * @vport: Virtual port private data structure
@@ -2043,6 +2195,77 @@ int idpf_send_config_queues_msg(struct idpf_vport *vport)
 	return idpf_send_config_rx_queues_msg(vport);
 }
 
+/**
+ * idpf_send_add_queues_msg - Send virtchnl add queues message
+ * @vport: Virtual port private data structure
+ * @num_tx_q: number of transmit queues
+ * @num_complq: number of transmit completion queues
+ * @num_rx_q: number of receive queues
+ * @num_rx_bufq: number of receive buffer queues
+ *
+ * Returns 0 on success, negative on failure. vport _MUST_ be const here as
+ * we should not change any fields within vport itself in this function.
+ */
+int idpf_send_add_queues_msg(const struct idpf_vport *vport, u16 num_tx_q,
+			     u16 num_complq, u16 num_rx_q, u16 num_rx_bufq)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_vport_config *vport_config;
+	struct virtchnl2_add_queues aq = { };
+	struct virtchnl2_add_queues *vc_msg;
+	u16 vport_idx = vport->idx;
+	int size, err;
+
+	vport_config = adapter->vport_config[vport_idx];
+
+	aq.vport_id = cpu_to_le32(vport->vport_id);
+	aq.num_tx_q = cpu_to_le16(num_tx_q);
+	aq.num_tx_complq = cpu_to_le16(num_complq);
+	aq.num_rx_q = cpu_to_le16(num_rx_q);
+	aq.num_rx_bufq = cpu_to_le16(num_rx_bufq);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_ADD_QUEUES,
+			       sizeof(struct virtchnl2_add_queues), (u8 *)&aq);
+	if (err)
+		return err;
+
+	/* We want vport to be const to prevent incidental code changes making
+	 * changes to the vport config. We're making a special exception here
+	 * to discard const to use the virtchnl.
+	 */
+	err = idpf_wait_for_event(adapter, (struct idpf_vport *)vport,
+				  IDPF_VC_ADD_QUEUES, IDPF_VC_ADD_QUEUES_ERR);
+	if (err)
+		return err;
+
+	kfree(vport_config->req_qs_chunks);
+	vport_config->req_qs_chunks = NULL;
+
+	vc_msg = (struct virtchnl2_add_queues *)vport->vc_msg;
+	/* compare vc_msg num queues with vport num queues */
+	if (le16_to_cpu(vc_msg->num_tx_q) != num_tx_q ||
+	    le16_to_cpu(vc_msg->num_rx_q) != num_rx_q ||
+	    le16_to_cpu(vc_msg->num_tx_complq) != num_complq ||
+	    le16_to_cpu(vc_msg->num_rx_bufq) != num_rx_bufq) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	size = struct_size(vc_msg, chunks.chunks,
+			   le16_to_cpu(vc_msg->chunks.num_chunks));
+	vport_config->req_qs_chunks = kmemdup(vc_msg, size, GFP_KERNEL);
+	if (!vport_config->req_qs_chunks) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+error:
+	clear_bit(IDPF_VPORT_VC_MSG_PENDING,
+		  ((struct idpf_vport *)vport)->flags);
+
+	return err;
+}
+
 /**
  * idpf_send_alloc_vectors_msg - Send virtchnl alloc vectors message
  * @adapter: Driver specific private structure
@@ -2866,7 +3089,7 @@ void idpf_vc_core_deinit(struct idpf_adapter *adapter)
  *
  * Return 0 on success, error on failure
  */
-static int idpf_vport_alloc_vec_indexes(struct idpf_vport *vport)
+int idpf_vport_alloc_vec_indexes(struct idpf_vport *vport)
 {
 	struct idpf_vector_info vec_info;
 	int num_alloc_vecs;
@@ -3200,6 +3423,29 @@ int idpf_vport_queue_ids_init(struct idpf_vport *vport)
 	return err;
 }
 
+/**
+ * idpf_vport_adjust_qs - Adjust to new requested queues
+ * @vport: virtual port data struct
+ *
+ * Renegotiate queues.  Returns 0 on success, negative on failure.
+ */
+int idpf_vport_adjust_qs(struct idpf_vport *vport)
+{
+	struct virtchnl2_create_vport vport_msg;
+	int err = 0;
+
+	vport_msg.txq_model = cpu_to_le16(vport->txq_model);
+	vport_msg.rxq_model = cpu_to_le16(vport->rxq_model);
+	err = idpf_vport_calc_total_qs(vport->adapter, vport->idx, &vport_msg, NULL);
+	if (err)
+		return err;
+
+	idpf_vport_init_num_qs(vport, &vport_msg);
+	idpf_vport_calc_num_q_groups(vport);
+
+	return 0;
+}
+
 /**
  * idpf_is_capability_ena - Default implementation of capability checking
  * @adapter: Private data struct
-- 
2.38.1


