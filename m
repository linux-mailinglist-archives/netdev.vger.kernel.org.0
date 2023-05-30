Return-Path: <netdev+bounces-6630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1FBB717213
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 904B5280A82
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A2140773;
	Tue, 30 May 2023 23:49:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A55240763
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:49:49 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D696100;
	Tue, 30 May 2023 16:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685490584; x=1717026584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PQpT+42L1ZI/3akpxhYTkkgzzVjZxvZNSBDVwsNy/KA=;
  b=NIcGTVLHkW5IgD6dUyLmBoHKj7IrdpD9U1EesZZCZQwaZEXzHJqU4RPY
   BPl8lZ9U7/dgpCWfMaCnU0JQssWR4yD2R86snQWQDBzifzIDP7f0aAbSO
   HGriUjtX+NyrU2uJw64grT/fJE+x/CAbDRXK5p+yA5NYUUzowYDYqky9e
   G6Sg7cHY4zKoAruCRay2is97H9jV6uphTLpsdQMz6RxUWzxPT9l3NoqM1
   nmAsBP17NuFLE/tRUQ9ozeFG11et7NU4Lp4es16RoGaxPXi+3FejvU/Zd
   N4ZAyFybiMbhwFtJQml4UY84S5MFYHnuv2F6UYeLmqWws55w/+2R/zmvj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="334700341"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="334700341"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="709822160"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="709822160"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2023 16:49:37 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Joshua Hay <joshua.a.hay@intel.com>,
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
	linux-doc@vger.kernel.org,
	Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>
Subject: [PATCH net-next 15/15] idpf: configure SRIOV and add other ndo_ops
Date: Tue, 30 May 2023 16:45:01 -0700
Message-Id: <20230530234501.2680230-16-anthony.l.nguyen@intel.com>
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
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Joshua Hay <joshua.a.hay@intel.com>

Add PCI callback to configure SRIOV and add the necessary support
to initialize the requested number of VFs by sending the virtchnl
message to the device Control Plane.

Add other ndo ops supported by the driver such as features_check,
set_rx_mode, validate_addr, set_mac_address, change_mtu, get_stats64,
set_features, and tx_timeout. Initialize the statistics task which
requests the queue related statistics to the CP. Add loopback
and promiscuous mode support and the respective virtchnl messages.

Finally, add documentation and build support for the driver.

Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../device_drivers/ethernet/index.rst         |   1 +
 .../device_drivers/ethernet/intel/idpf.rst    | 160 +++++
 drivers/net/ethernet/intel/Kconfig            |  10 +
 drivers/net/ethernet/intel/Makefile           |   1 +
 drivers/net/ethernet/intel/idpf/idpf.h        |  40 ++
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 642 +++++++++++++++++-
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  17 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   |  26 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   2 +
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 193 ++++++
 10 files changed, 1089 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/idpf.rst

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 417ca514a4d0..5a7e377ae2b7 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -30,6 +30,7 @@ Contents:
    intel/e1000
    intel/e1000e
    intel/fm10k
+   intel/idpf
    intel/igb
    intel/igbvf
    intel/ixgbe
diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
new file mode 100644
index 000000000000..adb16e2abd21
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
@@ -0,0 +1,160 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+==========================================================================
+idpf Linux* Base Driver for the Intel(R) Infrastructure Data Path Function
+==========================================================================
+
+Intel idpf Linux driver.
+Copyright(C) 2023 Intel Corporation.
+
+.. contents::
+
+The idpf driver serves as both the Physical Function (PF) and Virtual Function
+(VF) driver for the Intel(R) Infrastructure Data Path Function.
+
+Driver information can be obtained using ethtool, lspci, and ip.
+
+For questions related to hardware requirements, refer to the documentation
+supplied with your Intel adapter. All hardware requirements listed apply to use
+with Linux.
+
+
+Identifying Your Adapter
+========================
+For information on how to identify your adapter, and for the latest Intel
+network drivers, refer to the Intel Support website:
+http://www.intel.com/support
+
+
+Additional Features and Configurations
+======================================
+
+ethtool
+-------
+The driver utilizes the ethtool interface for driver configuration and
+diagnostics, as well as displaying statistical information. The latest ethtool
+version is required for this functionality. If you don't have one yet, you can
+obtain it at:
+https://kernel.org/pub/software/network/ethtool/
+
+
+Viewing Link Messages
+---------------------
+Link messages will not be displayed to the console if the distribution is
+restricting system messages. In order to see network driver link messages on
+your console, set dmesg to eight by entering the following::
+
+  # dmesg -n 8
+
+.. note::
+   This setting is not saved across reboots.
+
+
+Jumbo Frames
+------------
+Jumbo Frames support is enabled by changing the Maximum Transmission Unit (MTU)
+to a value larger than the default value of 1500.
+
+Use the ip command to increase the MTU size. For example, enter the following
+where <ethX> is the interface number::
+
+  # ip link set mtu 9000 dev <ethX>
+  # ip link set up dev <ethX>
+
+.. note::
+   The maximum MTU setting for jumbo frames is 9706. This corresponds to the
+   maximum jumbo frame size of 9728 bytes.
+
+.. note::
+   This driver will attempt to use multiple page sized buffers to receive
+   each jumbo packet. This should help to avoid buffer starvation issues when
+   allocating receive packets.
+
+.. note::
+   Packet loss may have a greater impact on throughput when you use jumbo
+   frames. If you observe a drop in performance after enabling jumbo frames,
+   enabling flow control may mitigate the issue.
+
+
+Performance Optimization
+========================
+Driver defaults are meant to fit a wide variety of workloads, but if further
+optimization is required, we recommend experimenting with the following
+settings.
+
+
+Interrupt Rate Limiting
+-----------------------
+This driver supports an adaptive interrupt throttle rate (ITR) mechanism that
+is tuned for general workloads. The user can customize the interrupt rate
+control for specific workloads, via ethtool, adjusting the number of
+microseconds between interrupts.
+
+To set the interrupt rate manually, you must disable adaptive mode::
+
+  # ethtool -C <ethX> adaptive-rx off adaptive-tx off
+
+For lower CPU utilization:
+ - Disable adaptive ITR and lower Rx and Tx interrupts. The examples below
+   affect every queue of the specified interface.
+
+ - Setting rx-usecs and tx-usecs to 80 will limit interrupts to about
+   12,500 interrupts per second per queue::
+
+     # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 80
+     tx-usecs 80
+
+For reduced latency:
+ - Disable adaptive ITR and ITR by setting rx-usecs and tx-usecs to 0
+   using ethtool::
+
+     # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 0
+     tx-usecs 0
+
+Per-queue interrupt rate settings:
+ - The following examples are for queues 1 and 3, but you can adjust other
+   queues.
+
+ - To disable Rx adaptive ITR and set static Rx ITR to 10 microseconds or
+   about 100,000 interrupts/second, for queues 1 and 3::
+
+     # ethtool --per-queue <ethX> queue_mask 0xa --coalesce adaptive-rx off
+     rx-usecs 10
+
+ - To show the current coalesce settings for queues 1 and 3::
+
+     # ethtool --per-queue <ethX> queue_mask 0xa --show-coalesce
+
+
+
+Virtualized Environments
+------------------------
+In addition to the other suggestions in this section, the following may be
+helpful to optimize performance in VMs.
+
+ - Using the appropriate mechanism (vcpupin) in the VM, pin the CPUs to
+   individual LCPUs, making sure to use a set of CPUs included in the
+   device's local_cpulist: /sys/class/net/<ethX>/device/local_cpulist.
+
+ - Configure as many Rx/Tx queues in the VM as available. (See the idpf driver
+   documentation for the number of queues supported.) For example::
+
+     # ethtool -L <virt_interface> rx <max> tx <max>
+
+
+Support
+=======
+For general information, go to the Intel support website at:
+http://www.intel.com/support/
+
+If an issue is identified with the released source code on a supported kernel
+with a supported adapter, email the specific information related to the issue
+to intel-wired-lan@lists.osuosl.org.
+
+
+Trademarks
+==========
+Intel is a trademark or registered trademark of Intel Corporation or its
+subsidiaries in the United States and/or other countries.
+
+* Other names and brands may be claimed as the property of others.
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 9bc0a9519899..33299d6afdb9 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -355,5 +355,15 @@ config IGC
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called igc.
+config IDPF
+	tristate "Intel(R) Infrastructure Data Path Function Support"
+	depends on PCI_MSI
+	select DIMLIB
+	help
+	  This driver supports Intel(R) Infrastructure Data Path Function
+	  devices.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called idpf.
 
 endif # NET_VENDOR_INTEL
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index d80d04132073..dacb481ee5b1 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_I40E) += i40e/
 obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
+obj-$(CONFIG_IDPF) += idpf/
diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index cf9a7e317419..1952b0fa14c3 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -78,6 +78,7 @@ enum idpf_state {
  * @IDPF_REQ_RX_SPLITQ: Request Rx split queue model when creating vport
  * @IDPF_VC_MSG_PENDING: Virtchnl message buffer received needs to be processed
  * @IDPF_CANCEL_SERVICE_TASK: Do not schedule service task if bit is set
+ * @IDPF_CANCEL_STATS_TASK: Do not schedule stats task if bit is set
  * @IDPF_REMOVE_IN_PROG: Driver remove in progress
  * @IDPF_FLAGS_NBITS: Must be last
  */
@@ -93,6 +94,7 @@ enum idpf_flags {
 	IDPF_REQ_RX_SPLITQ,
 	IDPF_VC_MSG_PENDING,
 	IDPF_CANCEL_SERVICE_TASK,
+	IDPF_CANCEL_STATS_TASK,
 	IDPF_REMOVE_IN_PROG,
 	IDPF_FLAGS_NBITS,
 };
@@ -182,6 +184,8 @@ struct idpf_dev_ops {
 	STATE(IDPF_VC_ALLOC_VECTORS_ERR)	\
 	STATE(IDPF_VC_DEALLOC_VECTORS)		\
 	STATE(IDPF_VC_DEALLOC_VECTORS_ERR)	\
+	STATE(IDPF_VC_SET_SRIOV_VFS)		\
+	STATE(IDPF_VC_SET_SRIOV_VFS_ERR)	\
 	STATE(IDPF_VC_GET_RSS_LUT)		\
 	STATE(IDPF_VC_GET_RSS_LUT_ERR)		\
 	STATE(IDPF_VC_SET_RSS_LUT)		\
@@ -190,12 +194,16 @@ struct idpf_dev_ops {
 	STATE(IDPF_VC_GET_RSS_KEY_ERR)		\
 	STATE(IDPF_VC_SET_RSS_KEY)		\
 	STATE(IDPF_VC_SET_RSS_KEY_ERR)		\
+	STATE(IDPF_VC_GET_STATS)		\
+	STATE(IDPF_VC_GET_STATS_ERR)		\
 	STATE(IDPF_VC_ADD_MAC_ADDR)		\
 	STATE(IDPF_VC_ADD_MAC_ADDR_ERR)		\
 	STATE(IDPF_VC_DEL_MAC_ADDR)		\
 	STATE(IDPF_VC_DEL_MAC_ADDR_ERR)		\
 	STATE(IDPF_VC_GET_PTYPE_INFO)		\
 	STATE(IDPF_VC_GET_PTYPE_INFO_ERR)	\
+	STATE(IDPF_VC_LOOPBACK_STATE)		\
+	STATE(IDPF_VC_LOOPBACK_STATE_ERR)	\
 	STATE(IDPF_VC_NBITS)
 
 #define IDPF_GEN_ENUM(ENUM) ENUM,
@@ -211,6 +219,9 @@ extern const char * const idpf_vport_vc_state_str[];
  * enum idpf_vport_flags - vport flags
  * @IDPF_SR_Q_CHANGE: Soft reset queue change
  * @IDPF_SR_Q_DESC_CHANGE: Soft reset descriptor change
+ * @IDPF_SR_Q_SCH_CHANGE: Scheduling mode change in queue context
+ * @IDPF_SR_MTU_CHANGE: Soft reset MTU change
+ * @IDPF_SR_RSC_CHANGE: Soft reset RSC change
  * @IDPF_SR_HSPLIT_CHANGE: Soft reset header split change
  * @IDPF_VPORT_DEL_QUEUES: To send delete queues message
  * @IDPF_VPORT_VC_MSG_PENDING: Virtchnl message buffer received needs to be
@@ -224,6 +235,9 @@ extern const char * const idpf_vport_vc_state_str[];
 enum idpf_vport_flags {
 	IDPF_SR_Q_CHANGE,
 	IDPF_SR_Q_DESC_CHANGE,
+	IDPF_SR_Q_SCH_CHANGE, /* Scheduling mode change in queue context */
+	IDPF_SR_MTU_CHANGE,
+	IDPF_SR_RSC_CHANGE,
 	IDPF_SR_HSPLIT_CHANGE,
 	IDPF_VPORT_DEL_QUEUES,
 	IDPF_VPORT_VC_MSG_PENDING,
@@ -302,6 +316,7 @@ struct idpf_vport {
 #define IDPF_DIM_PROFILE_SLOTS  5
 	u16 rx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
 	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
+	struct rtnl_link_stats64 netstats;
 	struct idpf_port_stats port_stats;
 
 	bool link_up;
@@ -326,6 +341,13 @@ struct idpf_vport {
 	spinlock_t mac_filter_list_lock;
 };
 
+enum idpf_user_flags {
+	__IDPF_PROMISC_UC = 32,
+	__IDPF_PROMISC_MC,
+
+	__IDPF_USER_FLAGS_NBITS,
+};
+
 struct idpf_rss_data {
 	u16 rss_key_size;
 	u8 *rss_key;
@@ -341,6 +363,7 @@ struct idpf_vport_user_config_data {
 	u32 num_req_rx_qs; /* user requested RX queues through ethtool */
 	u32 num_req_txq_desc; /* user requested TX queue descriptors through ethtool */
 	u32 num_req_rxq_desc; /* user requested RX queue descriptors through ethtool */
+	DECLARE_BITMAP(user_flags, __IDPF_USER_FLAGS_NBITS);
 	struct list_head mac_filter_list;
 };
 
@@ -428,6 +451,7 @@ struct idpf_adapter {
 	irqreturn_t (*irq_mb_handler)(int irq, void *data);
 
 	/* vport structs */
+	u32 tx_timeout_count;
 	struct idpf_avail_queue_info avail_queues;
 	/* array to store vports created by the driver */
 	struct idpf_vport **vports;
@@ -451,6 +475,8 @@ struct idpf_adapter {
 	struct workqueue_struct *serv_wq;
 	struct delayed_work vc_event_task; /* delayed virtchannel event task */
 	struct workqueue_struct *vc_event_wq;
+	struct delayed_work stats_task; /* delayed statistics task */
+	struct workqueue_struct *stats_wq;
 	struct virtchnl2_get_capabilities caps;
 
 	wait_queue_head_t vchnl_wq;
@@ -647,6 +673,16 @@ static inline bool idpf_is_feature_ena(const struct idpf_vport *vport,
 	return vport->netdev->features & feature;
 }
 
+/**
+ * idpf_get_max_tx_hdr_size -- get the size of tx header
+ * @adapter: Driver specific private structure
+ */
+static inline u16 idpf_get_max_tx_hdr_size(struct idpf_adapter *adapter)
+{
+	return le16_to_cpu(adapter->caps.max_tx_hdr_size);
+}
+
+void idpf_statistics_task(struct work_struct *work);
 void idpf_init_task(struct work_struct *work);
 void idpf_service_task(struct work_struct *work);
 void idpf_vc_event_task(struct work_struct *work);
@@ -661,6 +697,7 @@ int idpf_intr_req(struct idpf_adapter *adapter);
 void idpf_intr_rel(struct idpf_adapter *adapter);
 int idpf_get_reg_intr_vecs(struct idpf_vport *vport,
 			   struct idpf_vec_regs *reg_vals);
+u16 idpf_get_max_tx_hdr_size(struct idpf_adapter *adapter);
 int idpf_send_delete_queues_msg(struct idpf_vport *vport);
 int idpf_send_add_queues_msg(const struct idpf_vport *vport, u16 num_tx_q,
 			     u16 num_complq, u16 num_rx_q, u16 num_rx_bufq);
@@ -670,6 +707,7 @@ int idpf_send_enable_vport_msg(struct idpf_vport *vport);
 int idpf_send_disable_vport_msg(struct idpf_vport *vport);
 int idpf_send_destroy_vport_msg(struct idpf_vport *vport);
 int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport);
+int idpf_send_ena_dis_loopback_msg(struct idpf_vport *vport);
 int idpf_send_get_set_rss_key_msg(struct idpf_vport *vport, bool get);
 int idpf_send_get_set_rss_lut_msg(struct idpf_vport *vport, bool get);
 int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter);
@@ -679,6 +717,7 @@ int idpf_req_rel_vector_indexes(struct idpf_adapter *adapter,
 				u16 *q_vector_idxs,
 				struct idpf_vector_info *vec_info);
 int idpf_vport_alloc_vec_indexes(struct idpf_vport *vport);
+int idpf_send_get_stats_msg(struct idpf_vport *vport);
 int idpf_get_vec_ids(struct idpf_adapter *adapter,
 		     u16 *vecids, int num_vecids,
 		     struct virtchnl2_vector_chunks *chunks);
@@ -692,6 +731,7 @@ int idpf_vport_alloc_max_qs(struct idpf_adapter *adapter,
 void idpf_vport_dealloc_max_qs(struct idpf_adapter *adapter,
 			       struct idpf_vport_max_q *max_q);
 int idpf_add_del_mac_filters(struct idpf_vport *vport, bool add, bool async);
+int idpf_set_promiscuous(struct idpf_vport *vport);
 int idpf_send_disable_queues_msg(struct idpf_vport *vport);
 void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q);
 u32 idpf_get_vport_id(struct idpf_vport *vport);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 8a649af977bc..ef973c3a7265 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -458,6 +458,70 @@ static struct idpf_mac_filter *idpf_find_mac_filter(struct idpf_vport *vport,
 	return NULL;
 }
 
+/**
+ * __idpf_del_mac_filter - Delete a MAC filter from the filter list
+ * @vport: main vport structure
+ * @macaddr: the MAC address
+ *
+ * Returns 0 on success, error value on failure
+ **/
+static int __idpf_del_mac_filter(struct idpf_vport *vport, const u8 *macaddr)
+{
+	struct idpf_mac_filter *f;
+
+	if (!macaddr)
+		return -EINVAL;
+
+	spin_lock_bh(&vport->mac_filter_list_lock);
+	f = idpf_find_mac_filter(vport, macaddr);
+	if (f) {
+		list_del(&f->list);
+		kfree(f);
+	}
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	return 0;
+}
+
+/**
+ * idpf_del_mac_filter - Delete a MAC filter from the filter list
+ * @vport: main vport structure
+ * @macaddr: the MAC address
+ * @async: Don't wait for return message
+ *
+ * Removes filter from list and if interface is up, tells hardware about the
+ * removed filter.
+ **/
+static int idpf_del_mac_filter(struct idpf_vport *vport, const u8 *macaddr,
+			       bool async)
+{
+	struct idpf_mac_filter *f;
+
+	if (!macaddr)
+		return -EINVAL;
+
+	spin_lock_bh(&vport->mac_filter_list_lock);
+	f = idpf_find_mac_filter(vport, macaddr);
+	if (f) {
+		f->remove = true;
+	} else {
+		spin_unlock_bh(&vport->mac_filter_list_lock);
+
+		return -EINVAL;
+	}
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	if (vport->state == __IDPF_VPORT_UP) {
+		int err;
+
+		err = idpf_add_del_mac_filters(vport, false, async);
+		if (err)
+			return err;
+	}
+
+	return  __idpf_del_mac_filter(vport, macaddr);
+}
+
 /**
  * __idpf_add_mac_filter - Add mac filter helper function
  * @vport: main vport struct
@@ -521,6 +585,74 @@ static int idpf_add_mac_filter(struct idpf_vport *vport,
 	return err;
 }
 
+/**
+ * idpf_del_all_mac_filters - Delete all MAC filters in list
+ * @vport: main vport struct
+ *
+ * Takes mac_filter_list_lock spinlock.  Deletes all filters
+ */
+static void idpf_del_all_mac_filters(struct idpf_vport *vport)
+{
+	struct idpf_vport_user_config_data *user_config;
+	struct idpf_mac_filter *f, *ftmp;
+
+	user_config = &vport->adapter->vport_config[vport->idx]->user_config;
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	list_for_each_entry_safe(f, ftmp, &user_config->mac_filter_list, list) {
+		list_del(&f->list);
+		kfree(f);
+	}
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+}
+
+/**
+ * idpf_restore_mac_filters - Re-add all MAC filters in list
+ * @vport: main vport struct
+ *
+ * Takes mac_filter_list_lock spinlock.  Sets add field to true for filters to
+ * resync filters back to HW.
+ */
+static void idpf_restore_mac_filters(struct idpf_vport *vport)
+{
+	struct idpf_vport_user_config_data *user_config;
+	struct idpf_mac_filter *f;
+
+	user_config = &vport->adapter->vport_config[vport->idx]->user_config;
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	list_for_each_entry(f, &user_config->mac_filter_list, list)
+		f->add = true;
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	idpf_add_del_mac_filters(vport, true, false);
+}
+
+/**
+ * idpf_remove_mac_filters - Remove all MAC filters in list
+ * @vport: main vport struct
+ *
+ * Takes mac_filter_list_lock spinlock.  Sets remove field to true for filters to
+ * remove filters in  HW.
+ */
+static void idpf_remove_mac_filters(struct idpf_vport *vport)
+{
+	struct idpf_vport_user_config_data *user_config;
+	struct idpf_mac_filter *f;
+
+	user_config = &vport->adapter->vport_config[vport->idx]->user_config;
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	list_for_each_entry(f, &user_config->mac_filter_list, list)
+		f->remove = true;
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	idpf_add_del_mac_filters(vport, false, false);
+}
+
 /**
  * idpf_deinit_mac_addr - deinitialize mac address for vport
  * @vport: main vport structure
@@ -725,6 +857,18 @@ static int idpf_get_free_slot(struct idpf_adapter *adapter)
 	return IDPF_NO_FREE_SLOT;
 }
 
+/**
+ * idpf_remove_features - Turn off feature configs
+ * @vport: virtual port structure
+ */
+static void idpf_remove_features(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+
+	if (idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_MACFILTER))
+		idpf_remove_mac_filters(vport);
+}
+
 /**
  * idpf_vport_stop - Disable a vport
  * @vport: vport to disable
@@ -742,13 +886,16 @@ static void idpf_vport_stop(struct idpf_vport *vport)
 	idpf_send_disable_vport_msg(vport);
 	idpf_send_disable_queues_msg(vport);
 	idpf_send_map_unmap_queue_vector_msg(vport, false);
-	/* Normally we ask for queues in create_vport, but if we're changing
-	 * number of requested queues we do a delete then add instead of
-	 * deleting and reallocating the vport.
+	/* Normally we ask for queues in create_vport, but if the number of
+	 * initially requested queues have changed, for example via ethtool
+	 * set channels, we do delete queues and then add the queues back
+	 * instead of deleting and reallocating the vport.
 	 */
 	if (test_and_clear_bit(IDPF_VPORT_DEL_QUEUES, vport->flags))
 		idpf_send_delete_queues_msg(vport);
 
+	idpf_remove_features(vport);
+
 	vport->link_up = false;
 	idpf_vport_intr_deinit(vport);
 	idpf_vport_intr_rel(vport);
@@ -828,6 +975,7 @@ static void idpf_vport_rel(struct idpf_vport *vport)
 		set_bit(i, vport->vc_state);
 	wake_up(&vport->vchnl_wq);
 	mutex_destroy(&vport->stop_mutex);
+	mutex_destroy(&vport->soft_reset_lock);
 	/* Clear all the bits */
 	for (i = 0; i < IDPF_VC_NBITS; i++)
 		clear_bit(i, vport->vc_state);
@@ -853,6 +1001,10 @@ static void idpf_vport_rel(struct idpf_vport *vport)
 	adapter->vport_params_recvd[idx] = NULL;
 	kfree(adapter->vport_params_reqd[idx]);
 	adapter->vport_params_reqd[idx] = NULL;
+	if (adapter->vport_config[idx]) {
+		kfree(adapter->vport_config[idx]->req_qs_chunks);
+		adapter->vport_config[idx]->req_qs_chunks = NULL;
+	}
 	kfree(vport);
 	adapter->num_alloc_vports--;
 }
@@ -873,6 +1025,8 @@ static void idpf_vport_dealloc(struct idpf_vport *vport)
 
 	if (!test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags))
 		idpf_decfg_netdev(vport);
+	if (test_bit(IDPF_REMOVE_IN_PROG, adapter->flags))
+		idpf_del_all_mac_filters(vport);
 
 	if (adapter->netdevs[i]) {
 		struct idpf_netdev_priv *np = netdev_priv(adapter->netdevs[i]);
@@ -962,6 +1116,45 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 	return vport;
 }
 
+/**
+ * idpf_get_stats64 - get statistics for network device structure
+ * @netdev: network interface device structure
+ * @stats: main device statistics structure
+ */
+static void idpf_get_stats64(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return;
+
+	*stats = vport->netstats;
+}
+
+/**
+ * idpf_statistics_task - Delayed task to get statistics over mailbox
+ * @work: work_struct handle to our data
+ */
+void idpf_statistics_task(struct work_struct *work)
+{
+	struct idpf_adapter *adapter;
+	int i;
+
+	adapter = container_of(work, struct idpf_adapter, stats_task.work);
+
+	for (i = 0; i < adapter->max_vports; i++) {
+		struct idpf_vport *vport = adapter->vports[i];
+
+		if (vport && !test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags))
+			idpf_send_get_stats_msg(vport);
+	}
+
+	if (!test_bit(IDPF_CANCEL_STATS_TASK, adapter->flags))
+		queue_delayed_work(adapter->stats_wq, &adapter->stats_task,
+				   msecs_to_jiffies(10000));
+}
+
 /**
  * idpf_service_task - Delayed task for handling mailbox responses
  * @work: work_struct handle to our data
@@ -999,6 +1192,18 @@ void idpf_service_task(struct work_struct *work)
 				   msecs_to_jiffies(300));
 }
 
+/**
+ * idpf_restore_features - Restore feature configs
+ * @vport: virtual port structure
+ */
+static void idpf_restore_features(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+
+	if (idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_MACFILTER))
+		idpf_restore_mac_filters(vport);
+}
+
 /**
  * idpf_set_real_num_queues - set number of queues for netdev
  * @vport: virtual port structure
@@ -1163,6 +1368,8 @@ static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
 		goto disable_queues;
 	}
 
+	idpf_restore_features(vport);
+
 	vport_config = adapter->vport_config[vport->idx];
 	if (vport_config->user_config.rss_data.rss_lut)
 		err = idpf_config_rss(vport);
@@ -1263,6 +1470,7 @@ void idpf_init_task(struct work_struct *work)
 
 	init_waitqueue_head(&vport->sw_marker_wq);
 	init_waitqueue_head(&vport->vchnl_wq);
+	mutex_init(&vport->soft_reset_lock);
 
 	spin_lock_init(&vport->mac_filter_list_lock);
 	INIT_LIST_HEAD(&vport_config->user_config.mac_filter_list);
@@ -1313,6 +1521,9 @@ void idpf_init_task(struct work_struct *work)
 	 * unconditionally here in case we were in reset and the link was down.
 	 */
 	clear_bit(IDPF_HR_RESET_IN_PROG, vport->adapter->flags);
+	/* Start the statistics task now */
+	queue_delayed_work(adapter->stats_wq, &adapter->stats_task,
+			   msecs_to_jiffies(10 * (pdev->devfn & 0x07)));
 
 	return;
 
@@ -1330,6 +1541,70 @@ void idpf_init_task(struct work_struct *work)
 	}
 }
 
+/**
+ * idpf_sriov_ena - Enable or change number of VFs
+ * @adapter: private data struct
+ * @num_vfs: number of VFs to allocate
+ */
+static int idpf_sriov_ena(struct idpf_adapter *adapter, int num_vfs)
+{
+	struct device *dev = &adapter->pdev->dev;
+	int err;
+
+	err = idpf_send_set_sriov_vfs_msg(adapter, num_vfs);
+	if (err) {
+		dev_err(dev, "Failed to allocate VFs: %d\n", err);
+
+		return err;
+	}
+
+	err = pci_enable_sriov(adapter->pdev, num_vfs);
+	if (err) {
+		idpf_send_set_sriov_vfs_msg(adapter, 0);
+		dev_err(dev, "Failed to enable SR-IOV: %d\n", err);
+
+		return err;
+	}
+
+	adapter->num_vfs = num_vfs;
+
+	return num_vfs;
+}
+
+/**
+ * idpf_sriov_configure - Configure the requested VFs
+ * @pdev: pointer to a pci_dev structure
+ * @num_vfs: number of vfs to allocate
+ *
+ * Enable or change the number of VFs. Called when the user updates the number
+ * of VFs in sysfs.
+ **/
+int idpf_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct idpf_adapter *adapter = pci_get_drvdata(pdev);
+
+	if (!idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_SRIOV)) {
+		dev_info(&pdev->dev, "SR-IOV is not supported on this device\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (num_vfs)
+		return idpf_sriov_ena(adapter, num_vfs);
+
+	if (pci_vfs_assigned(pdev)) {
+		dev_warn(&pdev->dev, "Unable to free VFs because some are assigned to VMs\n");
+
+		return -EBUSY;
+	}
+
+	pci_disable_sriov(adapter->pdev);
+	idpf_send_set_sriov_vfs_msg(adapter, 0);
+	adapter->num_vfs = 0;
+
+	return 0;
+}
+
 /**
  * idpf_deinit_task - Device deinit routine
  * @adapter: Driver specific private structure
@@ -1349,6 +1624,11 @@ void idpf_deinit_task(struct idpf_adapter *adapter)
 	if (!adapter->vports)
 		return;
 
+	/* Required to indicate periodic task not to schedule again */
+	set_bit(IDPF_CANCEL_STATS_TASK, adapter->flags);
+	cancel_delayed_work_sync(&adapter->stats_task);
+	clear_bit(IDPF_CANCEL_STATS_TASK, adapter->flags);
+
 	for (i = 0; i < adapter->max_vports; i++) {
 		if (adapter->vports[i])
 			idpf_vport_dealloc(adapter->vports[i]);
@@ -1553,6 +1833,9 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 		/* Update queue parameters before allocating resources */
 		idpf_vport_calc_num_q_desc(new_vport);
 		break;
+	case IDPF_SR_Q_SCH_CHANGE:
+	case IDPF_SR_MTU_CHANGE:
+	case IDPF_SR_RSC_CHANGE:
 	case IDPF_SR_HSPLIT_CHANGE:
 		break;
 	default:
@@ -1649,6 +1932,214 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 	return err;
 }
 
+/**
+ * idpf_addr_sync - Callback for dev_(mc|uc)_sync to add address
+ * @netdev: the netdevice
+ * @addr: address to add
+ *
+ * Called by __dev_(mc|uc)_sync when an address needs to be added. We call
+ * __dev_(uc|mc)_sync from .set_rx_mode. Kernel takes addr_list_lock spinlock
+ * meaning we cannot sleep in this context. Due to this, we have to add the
+ * filter and send the virtchnl message asynchronously without waiting for the
+ * response from the other side. We won't know whether or not the operation
+ * actually succeeded until we get the message back.  Returns 0 on success,
+ * negative on failure.
+ */
+static int idpf_addr_sync(struct net_device *netdev, const u8 *addr)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	return idpf_add_mac_filter(vport, addr, true);
+}
+
+/**
+ * idpf_addr_unsync - Callback for dev_(mc|uc)_sync to remove address
+ * @netdev: the netdevice
+ * @addr: address to add
+ *
+ * Called by __dev_(mc|uc)_sync when an address needs to be added. We call
+ * __dev_(uc|mc)_sync from .set_rx_mode. Kernel takes addr_list_lock spinlock
+ * meaning we cannot sleep in this context. Due to this we have to delete the
+ * filter and send the virtchnl message asynchronously without waiting for the
+ * return from the other side.  We won't know whether or not the operation
+ * actually succeeded until we get the message back. Returns 0 on success,
+ * negative on failure.
+ */
+static int idpf_addr_unsync(struct net_device *netdev, const u8 *addr)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	/* Under some circumstances, we might receive a request to delete
+	 * our own device address from our uc list. Because we store the
+	 * device address in the VSI's MAC filter list, we need to ignore
+	 * such requests and not delete our device address from this list.
+	 */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
+	idpf_del_mac_filter(vport, addr, true);
+
+	return 0;
+}
+
+/**
+ * idpf_set_rx_mode - NDO callback to set the netdev filters
+ * @netdev: network interface device structure
+ *
+ * Stack takes addr_list_lock spinlock before calling our .set_rx_mode.  We
+ * cannot sleep in this context.
+ */
+static void idpf_set_rx_mode(struct net_device *netdev)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_vport_user_config_data *config_data;
+	struct idpf_adapter *adapter;
+	bool changed = false;
+	struct device *dev;
+	int err;
+
+	if (!vport)
+		return;
+
+	adapter = vport->adapter;
+	dev = &adapter->pdev->dev;
+
+	if (idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_MACFILTER)) {
+		__dev_uc_sync(netdev, idpf_addr_sync, idpf_addr_unsync);
+		__dev_mc_sync(netdev, idpf_addr_sync, idpf_addr_unsync);
+	}
+
+	if (!idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_PROMISC))
+		return;
+
+	config_data = &adapter->vport_config[vport->idx]->user_config;
+	/* IFF_PROMISC enables both unicast and multicast promiscuous,
+	 * while IFF_ALLMULTI only enables multicast such that:
+	 *
+	 * promisc  + allmulti		= unicast | multicast
+	 * promisc  + !allmulti		= unicast | multicast
+	 * !promisc + allmulti		= multicast
+	 */
+	if ((netdev->flags & IFF_PROMISC) &&
+	    !test_and_set_bit(__IDPF_PROMISC_UC, config_data->user_flags)) {
+		changed = true;
+		dev_info(&adapter->pdev->dev, "Entering promiscuous mode\n");
+		if (!test_and_set_bit(__IDPF_PROMISC_MC, adapter->flags))
+			dev_info(dev, "Entering multicast promiscuous mode\n");
+	}
+
+	if (!(netdev->flags & IFF_PROMISC) &&
+	    test_and_clear_bit(__IDPF_PROMISC_UC, config_data->user_flags)) {
+		changed = true;
+		dev_info(dev, "Leaving promiscuous mode\n");
+	}
+
+	if (netdev->flags & IFF_ALLMULTI &&
+	    !test_and_set_bit(__IDPF_PROMISC_MC, config_data->user_flags)) {
+		changed = true;
+		dev_info(dev, "Entering multicast promiscuous mode\n");
+	}
+
+	if (!(netdev->flags & (IFF_ALLMULTI | IFF_PROMISC)) &&
+	    test_and_clear_bit(__IDPF_PROMISC_MC, config_data->user_flags)) {
+		changed = true;
+		dev_info(dev, "Leaving multicast promiscuous mode\n");
+	}
+
+	if (!changed)
+		return;
+
+	err = idpf_set_promiscuous(vport);
+	if (err)
+		dev_err(dev, "Failed to set promiscuous mode: %d\n", err);
+}
+
+/**
+ * idpf_vport_manage_rss_lut - disable/enable RSS
+ * @vport: the vport being changed
+ *
+ * In the event of disable request for RSS, this function will zero out RSS
+ * LUT, while in the event of enable request for RSS, it will reconfigure RSS
+ * LUT with the default LUT configuration.
+ */
+static int idpf_vport_manage_rss_lut(struct idpf_vport *vport)
+{
+	bool ena = idpf_is_feature_ena(vport, NETIF_F_RXHASH);
+	struct idpf_rss_data *rss_data;
+	u16 idx = vport->idx;
+	int lut_size;
+
+	rss_data = &vport->adapter->vport_config[idx]->user_config.rss_data;
+	lut_size = rss_data->rss_lut_size * sizeof(u32);
+
+	if (ena) {
+		/* This will contain the default or user configured LUT */
+		memcpy(rss_data->rss_lut, rss_data->cached_lut, lut_size);
+	} else {
+		/* Save a copy of the current LUT to be restored later if
+		 * requested.
+		 */
+		memcpy(rss_data->cached_lut, rss_data->rss_lut, lut_size);
+
+		/* Zero out the current LUT to disable */
+		memset(rss_data->rss_lut, 0, lut_size);
+	}
+
+	return idpf_config_rss(vport);
+}
+
+/**
+ * idpf_set_features - set the netdev feature flags
+ * @netdev: ptr to the netdev being adjusted
+ * @features: the feature set that the stack is suggesting
+ */
+static int idpf_set_features(struct net_device *netdev,
+			     netdev_features_t features)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	netdev_features_t changed = netdev->features ^ features;
+	struct idpf_adapter *adapter;
+	int err;
+
+	if (!vport)
+		return -EINVAL;
+
+	adapter = vport->adapter;
+
+	if (idpf_is_reset_in_prog(adapter)) {
+		dev_err(&adapter->pdev->dev, "Device is resetting, changing netdev features temporarily unavailable.\n");
+
+		return -EBUSY;
+	}
+
+	if (changed & NETIF_F_RXHASH) {
+		netdev->features ^= NETIF_F_RXHASH;
+		err = idpf_vport_manage_rss_lut(vport);
+		if (err)
+			return err;
+	}
+
+	if (changed & NETIF_F_GRO_HW) {
+		netdev->features ^= NETIF_F_GRO_HW;
+		err = idpf_initiate_soft_reset(vport, IDPF_SR_RSC_CHANGE);
+		if (err)
+			return err;
+	}
+
+	if (changed & NETIF_F_LOOPBACK) {
+		netdev->features ^= NETIF_F_LOOPBACK;
+		err = idpf_send_ena_dis_loopback_msg(vport);
+	}
+
+	return 0;
+}
+
 /**
  * idpf_open - Called when a network interface becomes active
  * @netdev: network interface device structure
@@ -1671,6 +2162,135 @@ static int idpf_open(struct net_device *netdev)
 	return idpf_vport_open(vport, true);
 }
 
+/**
+ * idpf_change_mtu - NDO callback to change the MTU
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int idpf_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct idpf_vport *vport =  idpf_netdev_to_vport(netdev);
+
+	if (!vport)
+		return -EINVAL;
+
+	netdev->mtu = new_mtu;
+
+	return idpf_initiate_soft_reset(vport, IDPF_SR_MTU_CHANGE);
+}
+
+/**
+ * idpf_features_check - Validate packet conforms to limits
+ * @skb: skb buffer
+ * @netdev: This port's netdev
+ * @features: Offload features that the stack believes apply
+ */
+static netdev_features_t idpf_features_check(struct sk_buff *skb,
+					     struct net_device *netdev,
+					     netdev_features_t features)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_adapter *adapter = vport->adapter;
+	size_t len;
+
+	/* No point in doing any of this if neither checksum nor GSO are
+	 * being requested for this frame.  We can rule out both by just
+	 * checking for CHECKSUM_PARTIAL
+	 */
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return features;
+
+	/* We cannot support GSO if the MSS is going to be less than
+	 * 88 bytes. If it is then we need to drop support for GSO.
+	 */
+	if (skb_is_gso(skb) &&
+	    (skb_shinfo(skb)->gso_size < IDPF_TX_TSO_MIN_MSS))
+		features &= ~NETIF_F_GSO_MASK;
+
+	/* Ensure MACLEN is <= 126 bytes (63 words) and not an odd size */
+	len = skb_network_offset(skb);
+	if (unlikely(len & ~(126)))
+		goto unsupported;
+
+	len = skb_network_header_len(skb);
+	if (unlikely(len > idpf_get_max_tx_hdr_size(adapter)))
+		goto unsupported;
+
+	if (!skb->encapsulation)
+		return features;
+
+	/* L4TUNLEN can support 127 words */
+	len = skb_inner_network_header(skb) - skb_transport_header(skb);
+	if (unlikely(len & ~(127 * 2)))
+		goto unsupported;
+
+	/* IPLEN can support at most 127 dwords */
+	len = skb_inner_network_header_len(skb);
+	if (unlikely(len > idpf_get_max_tx_hdr_size(adapter)))
+		goto unsupported;
+
+	/* No need to validate L4LEN as TCP is the only protocol with a
+	 * a flexible value and we support all possible values supported
+	 * by TCP, which is at most 15 dwords
+	 */
+
+	return features;
+
+unsupported:
+	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+}
+
+/**
+ * idpf_set_mac - NDO callback to set port mac address
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int idpf_set_mac(struct net_device *netdev, void *p)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct sockaddr *addr = p;
+	int err;
+
+	if (!vport)
+		return -EINVAL;
+
+	if (!idpf_is_cap_ena(vport->adapter, IDPF_OTHER_CAPS,
+			     VIRTCHNL2_CAP_MACFILTER)) {
+		dev_info(&vport->adapter->pdev->dev, "Setting MAC address is not supported\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (!is_valid_ether_addr(addr->sa_data)) {
+		dev_info(&vport->adapter->pdev->dev, "Invalid MAC address: %pM\n",
+			 addr->sa_data);
+
+		return -EADDRNOTAVAIL;
+	}
+
+	if (ether_addr_equal(netdev->dev_addr, addr->sa_data))
+		return 0;
+
+	err = idpf_add_mac_filter(vport, addr->sa_data, false);
+	if (err) {
+		__idpf_del_mac_filter(vport, addr->sa_data);
+
+		return err;
+	}
+
+	if (is_valid_ether_addr(vport->default_mac_addr))
+		idpf_del_mac_filter(vport, vport->default_mac_addr, false);
+
+	ether_addr_copy(vport->default_mac_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
+
+	return 0;
+}
+
 /**
  * idpf_alloc_dma_mem - Allocate dma memory
  * @hw: pointer to hw struct
@@ -1709,10 +2329,26 @@ static const struct net_device_ops idpf_netdev_ops_splitq = {
 	.ndo_open = idpf_open,
 	.ndo_stop = idpf_stop,
 	.ndo_start_xmit = idpf_tx_splitq_start,
+	.ndo_features_check = idpf_features_check,
+	.ndo_set_rx_mode = idpf_set_rx_mode,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_set_mac_address = idpf_set_mac,
+	.ndo_change_mtu = idpf_change_mtu,
+	.ndo_get_stats64 = idpf_get_stats64,
+	.ndo_set_features = idpf_set_features,
+	.ndo_tx_timeout = idpf_tx_timeout,
 };
 
 static const struct net_device_ops idpf_netdev_ops_singleq = {
 	.ndo_open = idpf_open,
 	.ndo_stop = idpf_stop,
 	.ndo_start_xmit = idpf_tx_singleq_start,
+	.ndo_features_check = idpf_features_check,
+	.ndo_set_rx_mode = idpf_set_rx_mode,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_set_mac_address = idpf_set_mac,
+	.ndo_change_mtu = idpf_change_mtu,
+	.ndo_get_stats64 = idpf_get_stats64,
+	.ndo_set_features = idpf_set_features,
+	.ndo_tx_timeout = idpf_tx_timeout,
 };
diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index 22c8d49fa613..16cb161bd806 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -26,6 +26,9 @@ static void idpf_remove(struct pci_dev *pdev)
 	 * end up in bad state.
 	 */
 	cancel_delayed_work_sync(&adapter->vc_event_task);
+	if (adapter->num_vfs)
+		idpf_sriov_configure(pdev, 0);
+
 	idpf_vc_core_deinit(adapter);
 	/* Be a good citizen and leave the device clean on exit */
 	adapter->dev_ops.reg_ops.trigger_reset(adapter, IDPF_HR_FUNC_RESET);
@@ -51,6 +54,7 @@ static void idpf_remove(struct pci_dev *pdev)
 destroy_wqs:
 	destroy_workqueue(adapter->serv_wq);
 	destroy_workqueue(adapter->vc_event_wq);
+	destroy_workqueue(adapter->stats_wq);
 	destroy_workqueue(adapter->init_wq);
 
 	for (i = 0; i < adapter->max_vports; i++) {
@@ -184,6 +188,15 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_mbx_wq_alloc;
 	}
 
+	adapter->stats_wq = alloc_workqueue("%s-%s-stats", 0, 0,
+					    dev_driver_string(dev),
+					    dev_name(dev));
+	if (!adapter->stats_wq) {
+		dev_err(dev, "Failed to allocate workqueue\n");
+		err = -ENOMEM;
+		goto err_stats_wq_alloc;
+	}
+
 	adapter->vc_event_wq = alloc_workqueue("%s-%s-vc_event", 0, 0,
 					       dev_driver_string(dev),
 					       dev_name(dev));
@@ -209,6 +222,7 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mutex_init(&adapter->queue_lock);
 	init_waitqueue_head(&adapter->vchnl_wq);
 
+	INIT_DELAYED_WORK(&adapter->stats_task, idpf_statistics_task);
 	INIT_DELAYED_WORK(&adapter->serv_task, idpf_service_task);
 	INIT_DELAYED_WORK(&adapter->init_task, idpf_init_task);
 	INIT_DELAYED_WORK(&adapter->vc_event_task, idpf_vc_event_task);
@@ -225,6 +239,8 @@ static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_vc_event_wq_alloc:
 	destroy_workqueue(adapter->serv_wq);
 err_mbx_wq_alloc:
+	destroy_workqueue(adapter->stats_wq);
+err_stats_wq_alloc:
 	destroy_workqueue(adapter->init_wq);
 err_wq_alloc:
 	pci_disable_pcie_error_reporting(pdev);
@@ -246,6 +262,7 @@ static struct pci_driver idpf_driver = {
 	.name			= KBUILD_MODNAME,
 	.id_table		= idpf_pci_tbl,
 	.probe			= idpf_probe,
+	.sriov_configure	= idpf_sriov_configure,
 	.remove			= idpf_remove,
 	.shutdown		= idpf_shutdown,
 };
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 2501616506f3..454a058b6935 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -33,6 +33,32 @@ static struct idpf_tx_stash *idpf_buf_lifo_pop(struct idpf_buf_lifo *stack)
 	return stack->bufs[--stack->top];
 }
 
+/**
+ * idpf_tx_timeout - Respond to a Tx Hang
+ * @netdev: network interface device structure
+ * @txqueue: TX queue
+ */
+void idpf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+{
+	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
+	struct idpf_adapter *adapter;
+
+	if (!vport)
+		return;
+
+	adapter = vport->adapter;
+	adapter->tx_timeout_count++;
+
+	netdev_err(netdev, "Detected Tx timeout: Count %d, Queue %d\n",
+		   adapter->tx_timeout_count, txqueue);
+	if (!idpf_is_reset_in_prog(adapter)) {
+		set_bit(IDPF_HR_FUNC_RESET, adapter->flags);
+		queue_delayed_work(adapter->vc_event_wq,
+				   &adapter->vc_event_task,
+				   msecs_to_jiffies(10));
+	}
+}
+
 /**
  * idpf_tx_buf_rel - Release a Tx buffer
  * @tx_q: the queue that owns the buffer
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 9cc43941b8a2..a1ed9a740711 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -99,6 +99,7 @@ do {								\
 #define IDPF_HDR_BUF_SIZE			256
 #define IDPF_PACKET_HDR_PAD	\
 	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
+#define IDPF_TX_TSO_MIN_MSS			88
 
 /* Minimum number of descriptors between 2 descriptors with the RE bit set;
  * only relevant in flow scheduling mode
@@ -831,6 +832,7 @@ unsigned int idpf_tx_desc_count_required(struct idpf_queue *txq,
 bool idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs,
 			unsigned int count);
 int idpf_tx_maybe_stop_common(struct idpf_queue *tx_q, unsigned int size);
+void idpf_tx_timeout(struct net_device *netdev, unsigned int txqueue);
 netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
 				 struct net_device *netdev);
 netdev_tx_t idpf_tx_singleq_start(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index f31f933bfdb2..4ceec8b13cda 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -201,6 +201,7 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_VERSION:
 	case VIRTCHNL2_OP_GET_CAPS:
 	case VIRTCHNL2_OP_CREATE_VPORT:
+	case VIRTCHNL2_OP_SET_SRIOV_VFS:
 	case VIRTCHNL2_OP_ALLOC_VECTORS:
 	case VIRTCHNL2_OP_DEALLOC_VECTORS:
 	case VIRTCHNL2_OP_GET_PTYPE_INFO:
@@ -228,6 +229,9 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_UNMAP_QUEUE_VECTOR:
 		v_id = le32_to_cpu(((struct virtchnl2_queue_vector_maps *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_GET_STATS:
+		v_id = le32_to_cpu(((struct virtchnl2_vport_stats *)vc_msg)->vport_id);
+		break;
 	case VIRTCHNL2_OP_GET_RSS_LUT:
 	case VIRTCHNL2_OP_SET_RSS_LUT:
 		v_id = le32_to_cpu(((struct virtchnl2_rss_lut *)vc_msg)->vport_id);
@@ -239,6 +243,12 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_EVENT:
 		v_id = le32_to_cpu(((struct virtchnl2_event *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_LOOPBACK:
+		v_id = le32_to_cpu(((struct virtchnl2_loopback *)vc_msg)->vport_id);
+		break;
+	case VIRTCHNL2_OP_CONFIG_PROMISCUOUS_MODE:
+		v_id = le32_to_cpu(((struct virtchnl2_promisc_info *)vc_msg)->vport_id);
+		break;
 	case VIRTCHNL2_OP_ADD_MAC_ADDR:
 	case VIRTCHNL2_OP_DEL_MAC_ADDR:
 		v_id = le32_to_cpu(((struct virtchnl2_mac_addr_list *)vc_msg)->vport_id);
@@ -541,6 +551,11 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_UNMAP_IRQ,
 					   IDPF_VC_UNMAP_IRQ_ERR);
 			break;
+		case VIRTCHNL2_OP_GET_STATS:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_GET_STATS,
+					   IDPF_VC_GET_STATS_ERR);
+			break;
 		case VIRTCHNL2_OP_GET_RSS_LUT:
 			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
 					   IDPF_VC_GET_RSS_LUT,
@@ -561,6 +576,11 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_SET_RSS_KEY,
 					   IDPF_VC_SET_RSS_KEY_ERR);
 			break;
+		case VIRTCHNL2_OP_SET_SRIOV_VFS:
+			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
+					   IDPF_VC_SET_SRIOV_VFS,
+					   IDPF_VC_SET_SRIOV_VFS_ERR);
+			break;
 		case VIRTCHNL2_OP_ALLOC_VECTORS:
 			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
 					   IDPF_VC_ALLOC_VECTORS,
@@ -576,6 +596,24 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_GET_PTYPE_INFO,
 					   IDPF_VC_GET_PTYPE_INFO_ERR);
 			break;
+		case VIRTCHNL2_OP_LOOPBACK:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_LOOPBACK_STATE,
+					   IDPF_VC_LOOPBACK_STATE_ERR);
+			break;
+		case VIRTCHNL2_OP_CONFIG_PROMISCUOUS_MODE:
+			/* This message can only be sent asynchronously. As
+			 * such we'll have lost the context in which it was
+			 * called and thus can only really report if it looks
+			 * like an error occurred. Don't bother setting ERR bit
+			 * or waking chnl_wq since no work queue will be waiting
+			 * to read the message.
+			 */
+			if (ctlq_msg.cookie.mbx.chnl_retval) {
+				dev_err(&adapter->pdev->dev, "Failed to set promiscuous mode: %d\n",
+					ctlq_msg.cookie.mbx.chnl_retval);
+			}
+			break;
 		case VIRTCHNL2_OP_ADD_MAC_ADDR:
 			if (test_and_clear_bit(IDPF_VPORT_ADD_MAC_REQ,
 					       vport->flags)) {
@@ -2353,6 +2391,100 @@ int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter)
 	return 0;
 }
 
+/**
+ * idpf_get_max_vfs - Get max number of vfs supported
+ * @adapter: Driver specific private structure
+ *
+ * Returns max number of VFs
+ */
+static int idpf_get_max_vfs(struct idpf_adapter *adapter)
+{
+	return le16_to_cpu(adapter->caps.max_sriov_vfs);
+}
+
+/**
+ * idpf_send_set_sriov_vfs_msg - Send virtchnl set sriov vfs message
+ * @adapter: Driver specific private structure
+ * @num_vfs: number of virtual functions to be created
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_set_sriov_vfs_msg(struct idpf_adapter *adapter, u16 num_vfs)
+{
+	struct virtchnl2_sriov_vfs_info svi = { };
+	int err;
+
+	svi.num_vfs = cpu_to_le16(num_vfs);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_SET_SRIOV_VFS,
+			       sizeof(svi), (u8 *)&svi);
+	if (err)
+		return err;
+
+	err = idpf_wait_for_event(adapter, NULL, IDPF_VC_SET_SRIOV_VFS,
+				  IDPF_VC_SET_SRIOV_VFS_ERR);
+	if (err)
+		return err;
+
+	clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+
+	return 0;
+}
+
+/**
+ * idpf_send_get_stats_msg - Send virtchnl get statistics message
+ * @vport: vport to get stats for
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_get_stats_msg(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_vport_stats stats_msg = { };
+	struct virtchnl2_vport_stats *stats;
+	int err = 0;
+
+	/* Don't send get_stats message if the link is down */
+	if (vport->state <= __IDPF_VPORT_DOWN)
+		return err;
+
+	stats_msg.vport_id = cpu_to_le32(vport->vport_id);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_GET_STATS,
+			       sizeof(struct virtchnl2_vport_stats),
+			       (u8 *)&stats_msg);
+	if (err)
+		return err;
+
+	err = idpf_wait_for_event(adapter, vport, IDPF_VC_GET_STATS,
+				  IDPF_VC_GET_STATS_ERR);
+	if (err)
+		return err;
+
+	stats = (struct virtchnl2_vport_stats *)vport->vc_msg;
+
+	vport->netstats.rx_packets = le64_to_cpu(stats->rx_unicast) +
+				     le64_to_cpu(stats->rx_multicast) +
+				     le64_to_cpu(stats->rx_broadcast);
+	vport->netstats.rx_bytes = le64_to_cpu(stats->rx_bytes);
+	vport->netstats.rx_dropped = le64_to_cpu(stats->rx_discards);
+	vport->netstats.rx_over_errors = le64_to_cpu(stats->rx_overflow_drop);
+	vport->netstats.rx_length_errors = le64_to_cpu(stats->rx_invalid_frame_length);
+
+	vport->netstats.tx_packets = le64_to_cpu(stats->tx_unicast) +
+				     le64_to_cpu(stats->tx_multicast) +
+				     le64_to_cpu(stats->tx_broadcast);
+	vport->netstats.tx_bytes = le64_to_cpu(stats->tx_bytes);
+	vport->netstats.tx_errors = le64_to_cpu(stats->tx_errors);
+	vport->netstats.tx_dropped = le64_to_cpu(stats->tx_discards);
+
+	vport->port_stats.vport_stats = *stats;
+
+	clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+
+	return 0;
+}
+
 /**
  * idpf_send_get_set_rss_lut_msg - Send virtchnl get or set rss lut message
  * @vport: virtual port data structure
@@ -2763,6 +2895,34 @@ int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport)
 	return err;
 }
 
+/**
+ * idpf_send_ena_dis_loopback_msg - Send virtchnl enable/disable loopback message
+ * @vport: virtual port data structure
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_ena_dis_loopback_msg(struct idpf_vport *vport)
+{
+	struct virtchnl2_loopback loopback;
+	int err = 0;
+
+	loopback.vport_id = cpu_to_le32(vport->vport_id);
+	loopback.enable = idpf_is_feature_ena(vport, NETIF_F_LOOPBACK);
+
+	err = idpf_send_mb_msg(vport->adapter, VIRTCHNL2_OP_LOOPBACK,
+			       sizeof(loopback), (u8 *)&loopback);
+	if (err)
+		return err;
+
+	err = idpf_wait_for_event(vport->adapter, vport,
+				  IDPF_VC_LOOPBACK_STATE,
+				  IDPF_VC_LOOPBACK_STATE_ERR);
+	if (!err)
+		clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+
+	return err;
+}
+
 /**
  * idpf_find_ctlq - Given a type and id, find ctlq info
  * @hw: hardware struct
@@ -2961,6 +3121,7 @@ int idpf_vc_core_init(struct idpf_adapter *adapter)
 		msleep(task_delay);
 	}
 
+	pci_sriov_set_totalvfs(adapter->pdev, idpf_get_max_vfs(adapter));
 	num_max_vports = idpf_get_max_vports(adapter);
 	adapter->max_vports = num_max_vports;
 	adapter->vports = kcalloc(num_max_vports, sizeof(*adapter->vports),
@@ -3630,3 +3791,35 @@ int idpf_add_del_mac_filters(struct idpf_vport *vport, bool add, bool async)
 
 	return err;
 }
+
+/**
+ * idpf_set_promiscuous - set promiscuous and send message to mailbox
+ * @vport: virtual port structure
+ *
+ * Request to enable promiscuous mode for the vport. Message is sent
+ * asynchronously and won't wait for response.  Returns 0 on success, negative
+ * on failure;
+ */
+int idpf_set_promiscuous(struct idpf_vport *vport)
+{
+	struct idpf_vport_user_config_data *config_data;
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_promisc_info vpi;
+	u16 flags = 0;
+	int err = 0;
+
+	config_data = &adapter->vport_config[vport->idx]->user_config;
+	if (test_bit(__IDPF_PROMISC_UC, config_data->user_flags))
+		flags |= VIRTCHNL2_UNICAST_PROMISC;
+	if (test_bit(__IDPF_PROMISC_MC, config_data->user_flags))
+		flags |= VIRTCHNL2_MULTICAST_PROMISC;
+
+	vpi.vport_id = cpu_to_le32(vport->vport_id);
+	vpi.flags = cpu_to_le16(flags);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_CONFIG_PROMISCUOUS_MODE,
+			       sizeof(struct virtchnl2_promisc_info),
+			       (u8 *)&vpi);
+
+	return err;
+}
-- 
2.38.1


