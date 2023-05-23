Return-Path: <netdev+bounces-4449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F6470CF43
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAC271C20C13
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 00:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0057AED1;
	Tue, 23 May 2023 00:29:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF51859
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:29:32 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B924205
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684801733; x=1716337733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nu9+GVkgMUdaistyii879n2K24mfpXqMB/ySBDC2mtc=;
  b=NZqGIgojtv6eu5ByzIVvG//qSxelpIneTmabqKeVqCb7dZaMJyed2I2p
   MQS7QrslTrNo4k2hYRxZ7Ilq3jFPA3QBUxWH0BHbT4FgBQzJEsNSR6py4
   yylnKBb20cLXkcGA4cWMJgfUU8Klu+8mJGtWQj4BPp8XL5V/fiPBip3d7
   Ca2/PDfgkNT0MrWFGNPsbxw8wW84LzvArq2v8zYwmxER/i1fQWTIuLomh
   mVMmnVnLL/zofrjPmFRC58ATymkF+dsXZ5t6JwLaqhASmCso6jyeTFoIv
   C2PcDDdd+JxpA+Pj+SKOPDYXGow8YZ3tvEIO5jaHEz0r2Gk8SNTFcdKrq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="337670721"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337670721"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:26:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827885501"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="827885501"
Received: from unknown (HELO AMR-CMP1.ger.corp.intel.com) ([10.166.80.24])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 17:26:03 -0700
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
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [PATCH iwl-next v6 06/15] idpf: continue expanding init task
Date: Mon, 22 May 2023 17:22:43 -0700
Message-Id: <20230523002252.26124-7-pavan.kumar.linga@intel.com>
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
	SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the virtchnl support to request the packet types. Parse the responses
received from CP and based on the protocol headers, populate the packet
type structure with necessary information. Initialize the MAC address
and add the virtchnl support to add and del MAC address.

Co-developed-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
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
 drivers/net/ethernet/intel/idpf/idpf.h        |  28 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 184 ++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 104 ++++
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 483 ++++++++++++++++++
 4 files changed, 794 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 08e647102262..04bc352d610f 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -22,6 +22,7 @@ struct idpf_vport_max_q;
 
 /* Default Mailbox settings */
 #define IDPF_DFLT_MBX_BUF_SIZE		SZ_4K
+#define IDPF_NUM_FILTERS_PER_MSG	20
 #define IDPF_NUM_DFLT_MBX_Q		2	/* includes both TX and RX */
 #define IDPF_DFLT_MBX_Q_LEN		64
 #define IDPF_DFLT_MBX_ID		-1
@@ -38,6 +39,13 @@ struct idpf_vport_max_q;
 #define IDPF_VIRTCHNL_VERSION_MAJOR VIRTCHNL2_VERSION_MAJOR_2
 #define IDPF_VIRTCHNL_VERSION_MINOR VIRTCHNL2_VERSION_MINOR_0
 
+struct idpf_mac_filter {
+	struct list_head list;
+	u8 macaddr[ETH_ALEN];
+	bool remove;		/* filter needs to be removed */
+	bool add;		/* filter needs to be added */
+};
+
 enum idpf_state {
 	__IDPF_STARTUP,
 	__IDPF_VER_CHECK,
@@ -143,6 +151,12 @@ struct idpf_dev_ops {
 	STATE(IDPF_VC_ALLOC_VECTORS_ERR)	\
 	STATE(IDPF_VC_DEALLOC_VECTORS)		\
 	STATE(IDPF_VC_DEALLOC_VECTORS_ERR)	\
+	STATE(IDPF_VC_ADD_MAC_ADDR)		\
+	STATE(IDPF_VC_ADD_MAC_ADDR_ERR)		\
+	STATE(IDPF_VC_DEL_MAC_ADDR)		\
+	STATE(IDPF_VC_DEL_MAC_ADDR_ERR)		\
+	STATE(IDPF_VC_GET_PTYPE_INFO)		\
+	STATE(IDPF_VC_GET_PTYPE_INFO_ERR)	\
 	STATE(IDPF_VC_NBITS)
 
 #define IDPF_GEN_ENUM(ENUM) ENUM,
@@ -158,10 +172,15 @@ extern const char * const idpf_vport_vc_state_str[];
  * enum idpf_vport_flags - vport flags
  * @IDPF_VPORT_VC_MSG_PENDING: Virtchnl message buffer received needs to be
  *			       processed
+ * @IDPF_VPORT_ADD_MAC_REQ: Asynchronous add ether address in flight
+ * @IDPF_VPORT_DEL_MAC_REQ: Asynchronous delete ether address in flight
  * @IDPF_VPORT_FLAGS_NBITS: Must be last
  */
 enum idpf_vport_flags {
 	IDPF_VPORT_VC_MSG_PENDING,
+	/* Asynchronous add/del ether address in flight */
+	IDPF_VPORT_ADD_MAC_REQ,
+	IDPF_VPORT_DEL_MAC_REQ,
 	IDPF_VPORT_FLAGS_NBITS,
 };
 
@@ -194,6 +213,7 @@ struct idpf_vport {
 	u32 bufq_size[IDPF_MAX_BUFQS_PER_RXQ_GRP];
 	int num_rxq_grp;
 	u32 rxq_model;
+	struct idpf_rx_ptype_decoded rx_ptype_lkup[IDPF_RX_MAX_PTYPE];
 
 	struct idpf_adapter *adapter;
 	struct net_device *netdev;
@@ -202,6 +222,7 @@ struct idpf_vport {
 	u32 vport_id;
 	u16 idx;		/* software index in adapter vports struct */
 	bool default_vport;
+	bool base_rxd;
 
 	u16 max_mtu;
 	u8 default_mac_addr[ETH_ALEN];
@@ -216,6 +237,9 @@ struct idpf_vport {
 	 * the driver is in a namespace in a system that is being shutdown
 	 */
 	struct mutex stop_mutex;
+
+	/* lock to protect mac filters */
+	spinlock_t mac_filter_list_lock;
 };
 
 /* User defined configuration values for each vport */
@@ -224,6 +248,7 @@ struct idpf_vport_user_config_data {
 	u32 num_req_rx_qs; /* user requested RX queues through ethtool */
 	u32 num_req_txq_desc; /* user requested TX queue descriptors through ethtool */
 	u32 num_req_rxq_desc; /* user requested RX queue descriptors through ethtool */
+	struct list_head mac_filter_list;
 };
 
 /**
@@ -478,6 +503,7 @@ void idpf_vc_core_deinit(struct idpf_adapter *adapter);
 int idpf_intr_req(struct idpf_adapter *adapter);
 void idpf_intr_rel(struct idpf_adapter *adapter);
 int idpf_send_destroy_vport_msg(struct idpf_vport *vport);
+int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport);
 int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter);
 int idpf_send_alloc_vectors_msg(struct idpf_adapter *adapter, u16 num_vectors);
 void idpf_deinit_task(struct idpf_adapter *adapter);
@@ -492,9 +518,11 @@ int idpf_vport_alloc_max_qs(struct idpf_adapter *adapter,
 			    struct idpf_vport_max_q *max_q);
 void idpf_vport_dealloc_max_qs(struct idpf_adapter *adapter,
 			       struct idpf_vport_max_q *max_q);
+int idpf_add_del_mac_filters(struct idpf_vport *vport, bool add, bool async);
 void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q);
 u32 idpf_get_vport_id(struct idpf_vport *vport);
 int idpf_send_create_vport_msg(struct idpf_adapter *adapter,
 			       struct idpf_vport_max_q *max_q);
+int idpf_check_supported_desc_ids(struct idpf_vport *vport);
 
 #endif /* !_IDPF_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 84a39889b13b..f00dc0d77d42 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -293,6 +293,154 @@ int idpf_intr_req(struct idpf_adapter *adapter)
 	return err;
 }
 
+/**
+ * idpf_find_mac_filter - Search filter list for specific mac filter
+ * @vport: main vport structure
+ * @macaddr: the MAC address
+ *
+ * Returns ptr to the filter object or NULL. Must be called while holding the
+ * mac_filter_list_lock.
+ **/
+static struct idpf_mac_filter *idpf_find_mac_filter(struct idpf_vport *vport,
+						    const u8 *macaddr)
+{
+	struct idpf_vport_user_config_data *config_data;
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_mac_filter *f;
+
+	if (!macaddr)
+		return NULL;
+
+	config_data = &adapter->vport_config[vport->idx]->user_config;
+
+	list_for_each_entry(f, &config_data->mac_filter_list, list) {
+		if (ether_addr_equal(macaddr, f->macaddr))
+			return f;
+	}
+
+	return NULL;
+}
+
+/**
+ * __idpf_add_mac_filter - Add mac filter helper function
+ * @vport: main vport struct
+ * @macaddr: address to add
+ *
+ * Takes mac_filter_list_lock spinlock to add new filter to list.
+ */
+static int __idpf_add_mac_filter(struct idpf_vport *vport, const u8 *macaddr)
+{
+	struct idpf_vport_config *vport_config;
+	struct idpf_mac_filter *f = NULL;
+
+	vport_config = vport->adapter->vport_config[vport->idx];
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	f = idpf_find_mac_filter(vport, macaddr);
+	if (f) {
+		f->remove = false;
+		spin_unlock_bh(&vport->mac_filter_list_lock);
+
+		return 0;
+	}
+
+	f = kzalloc(sizeof(*f), GFP_ATOMIC);
+	if (!f) {
+		spin_unlock_bh(&vport->mac_filter_list_lock);
+
+		return -ENOMEM;
+	}
+
+	ether_addr_copy(f->macaddr, macaddr);
+	list_add_tail(&f->list, &vport_config->user_config.mac_filter_list);
+	f->add = true;
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	return 0;
+}
+
+/**
+ * idpf_add_mac_filter - Add a mac filter to the filter list
+ * @vport: main vport structure
+ * @macaddr: the MAC address
+ * @async: Don't wait for return message
+ *
+ * Returns 0 on success or error on failure. If interface is up, we'll also
+ * send the virtchnl message to tell hardware about the filter.
+ **/
+static int idpf_add_mac_filter(struct idpf_vport *vport,
+			       const u8 *macaddr, bool async)
+{
+	int err;
+
+	err = __idpf_add_mac_filter(vport, macaddr);
+	if (err)
+		return err;
+
+	if (vport->state == __IDPF_VPORT_UP)
+		err = idpf_add_del_mac_filters(vport, true, async);
+
+	return err;
+}
+
+/**
+ * idpf_deinit_mac_addr - deinitialize mac address for vport
+ * @vport: main vport structure
+ */
+static void idpf_deinit_mac_addr(struct idpf_vport *vport)
+{
+	struct idpf_mac_filter *f;
+
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	f = idpf_find_mac_filter(vport, vport->default_mac_addr);
+	if (f) {
+		list_del(&f->list);
+		kfree(f);
+	}
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+}
+
+/**
+ * idpf_init_mac_addr - initialize mac address for vport
+ * @vport: main vport structure
+ * @netdev: pointer to netdev struct associated with this vport
+ */
+static int idpf_init_mac_addr(struct idpf_vport *vport,
+			      struct net_device *netdev)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	int err;
+
+	if (is_valid_ether_addr(vport->default_mac_addr)) {
+		eth_hw_addr_set(netdev, vport->default_mac_addr);
+		ether_addr_copy(netdev->perm_addr, vport->default_mac_addr);
+
+		return idpf_add_mac_filter(vport, vport->default_mac_addr, false);
+	}
+
+	if (!idpf_is_cap_ena(vport->adapter, IDPF_OTHER_CAPS,
+			     VIRTCHNL2_CAP_MACFILTER)) {
+		dev_err(&adapter->pdev->dev,
+			"MAC address is not provided and capability is not set\n");
+
+		return -EINVAL;
+	}
+
+	eth_hw_addr_random(netdev);
+	err = idpf_add_mac_filter(vport, netdev->dev_addr, false);
+	if (err)
+		return err;
+
+	dev_info(&adapter->pdev->dev, "Invalid MAC address %pM, using random %pM\n",
+		 vport->default_mac_addr, netdev->dev_addr);
+	ether_addr_copy(vport->default_mac_addr, netdev->dev_addr);
+
+	return 0;
+}
+
 /**
  * idpf_cfg_netdev - Allocate, configure and register a netdev
  * @vport: main vport structure
@@ -308,6 +456,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	struct idpf_netdev_priv *np;
 	struct net_device *netdev;
 	u16 idx = vport->idx;
+	int err;
 
 	vport_config = adapter->vport_config[idx];
 
@@ -320,7 +469,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 		np->vport = vport;
 		vport->netdev = netdev;
 
-		return 0;
+		return idpf_init_mac_addr(vport, netdev);
 	}
 
 	netdev = alloc_etherdev_mqs(sizeof(struct idpf_netdev_priv),
@@ -333,6 +482,14 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	np = netdev_priv(netdev);
 	np->vport = vport;
 
+	err = idpf_init_mac_addr(vport, netdev);
+	if (err) {
+		free_netdev(vport->netdev);
+		vport->netdev = NULL;
+
+		return err;
+	}
+
 	/* setup watchdog timeout value to be 5 second */
 	netdev->watchdog_timeo = 5 * HZ;
 
@@ -495,15 +652,15 @@ static void idpf_vport_dealloc(struct idpf_vport *vport)
 	struct idpf_adapter *adapter = vport->adapter;
 	unsigned int i = vport->idx;
 
+	idpf_deinit_mac_addr(vport);
+
 	if (!test_bit(IDPF_HR_RESET_IN_PROG, adapter->flags))
 		idpf_decfg_netdev(vport);
 
 	if (adapter->netdevs[i]) {
-		struct idpf_netdev_priv *np;
+		struct idpf_netdev_priv *np = netdev_priv(adapter->netdevs[i]);
 
-		np = netdev_priv(adapter->netdevs[i]);
-		if (np)
-			np->vport = NULL;
+		np->vport = NULL;
 	}
 
 	idpf_vport_rel(vport);
@@ -612,6 +769,7 @@ void idpf_service_task(struct work_struct *work)
  */
 void idpf_init_task(struct work_struct *work)
 {
+	struct idpf_vport_config *vport_config;
 	struct idpf_vport_max_q max_q;
 	struct idpf_adapter *adapter;
 	u16 num_default_vports = 0;
@@ -656,12 +814,26 @@ void idpf_init_task(struct work_struct *work)
 	mutex_unlock(&adapter->sw_mutex);
 
 	index = vport->idx;
+	vport_config = adapter->vport_config[index];
 
 	init_waitqueue_head(&vport->vchnl_wq);
 
+	spin_lock_init(&vport->mac_filter_list_lock);
+	INIT_LIST_HEAD(&vport_config->user_config.mac_filter_list);
+
+	err = idpf_check_supported_desc_ids(vport);
+	if (err) {
+		dev_err(&pdev->dev, "failed to get required descriptor ids\n");
+		goto cfg_netdev_err;
+	}
+
 	if (idpf_cfg_netdev(vport))
 		goto cfg_netdev_err;
 
+	err = idpf_send_get_rx_ptype_msg(vport);
+	if (err)
+		goto handle_err;
+
 	mutex_lock(&adapter->sw_mutex);
 
 	/* Spawn and return 'idpf_init_task' work queue until all the
@@ -693,6 +865,8 @@ void idpf_init_task(struct work_struct *work)
 
 	return;
 
+handle_err:
+	idpf_decfg_netdev(vport);
 cfg_netdev_err:
 	idpf_vport_rel(vport);
 	adapter->vports[index] = NULL;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 7c962c3c6be5..3d5b9c17de39 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -9,6 +9,10 @@
 
 #define IDPF_MIN_TXQ_COMPLQ_DESC		256
 
+#define MIN_SUPPORT_TXDID (\
+	VIRTCHNL2_TXDID_FLEX_FLOW_SCHED |\
+	VIRTCHNL2_TXDID_FLEX_TSO_CTX)
+
 #define IDPF_DFLT_SINGLEQ_TX_Q_GROUPS		1
 #define IDPF_DFLT_SINGLEQ_RX_Q_GROUPS		1
 #define IDPF_DFLT_SINGLEQ_TXQ_PER_GROUP		4
@@ -51,8 +55,108 @@
 #define IDPF_PACKET_HDR_PAD	\
 	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
 
+#define IDPF_GET_PTYPE_SIZE(p) struct_size((p), proto_id, (p)->proto_id_count)
+
+#define IDPF_TUN_IP_GRE (\
+	IDPF_PTYPE_TUNNEL_IP |\
+	IDPF_PTYPE_TUNNEL_IP_GRENAT)
+
+#define IDPF_TUN_IP_GRE_MAC (\
+	IDPF_TUN_IP_GRE |\
+	IDPF_PTYPE_TUNNEL_IP_GRENAT_MAC)
+
+#define IDPF_RX_MAX_PTYPE	1024
+#define IDPF_RX_MAX_BASE_PTYPE	256
+#define IDPF_INVALID_PTYPE_ID	0xFFFF
 #define IDPF_INT_NAME_STR_LEN   (IFNAMSIZ + 16)
 
+/* Packet type non-ip values */
+enum idpf_rx_ptype_l2 {
+	IDPF_RX_PTYPE_L2_RESERVED	= 0,
+	IDPF_RX_PTYPE_L2_MAC_PAY2	= 1,
+	IDPF_RX_PTYPE_L2_TIMESYNC_PAY2	= 2,
+	IDPF_RX_PTYPE_L2_FIP_PAY2	= 3,
+	IDPF_RX_PTYPE_L2_OUI_PAY2	= 4,
+	IDPF_RX_PTYPE_L2_MACCNTRL_PAY2	= 5,
+	IDPF_RX_PTYPE_L2_LLDP_PAY2	= 6,
+	IDPF_RX_PTYPE_L2_ECP_PAY2	= 7,
+	IDPF_RX_PTYPE_L2_EVB_PAY2	= 8,
+	IDPF_RX_PTYPE_L2_QCN_PAY2	= 9,
+	IDPF_RX_PTYPE_L2_EAPOL_PAY2	= 10,
+	IDPF_RX_PTYPE_L2_ARP		= 11,
+};
+
+enum idpf_rx_ptype_outer_ip {
+	IDPF_RX_PTYPE_OUTER_L2	= 0,
+	IDPF_RX_PTYPE_OUTER_IP	= 1,
+};
+
+enum idpf_rx_ptype_outer_ip_ver {
+	IDPF_RX_PTYPE_OUTER_NONE	= 0,
+	IDPF_RX_PTYPE_OUTER_IPV4	= 1,
+	IDPF_RX_PTYPE_OUTER_IPV6	= 2,
+};
+
+enum idpf_rx_ptype_outer_fragmented {
+	IDPF_RX_PTYPE_NOT_FRAG	= 0,
+	IDPF_RX_PTYPE_FRAG	= 1,
+};
+
+enum idpf_rx_ptype_tunnel_type {
+	IDPF_RX_PTYPE_TUNNEL_NONE		= 0,
+	IDPF_RX_PTYPE_TUNNEL_IP_IP		= 1,
+	IDPF_RX_PTYPE_TUNNEL_IP_GRENAT		= 2,
+	IDPF_RX_PTYPE_TUNNEL_IP_GRENAT_MAC	= 3,
+	IDPF_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN	= 4,
+};
+
+enum idpf_rx_ptype_tunnel_end_prot {
+	IDPF_RX_PTYPE_TUNNEL_END_NONE	= 0,
+	IDPF_RX_PTYPE_TUNNEL_END_IPV4	= 1,
+	IDPF_RX_PTYPE_TUNNEL_END_IPV6	= 2,
+};
+
+enum idpf_rx_ptype_inner_prot {
+	IDPF_RX_PTYPE_INNER_PROT_NONE		= 0,
+	IDPF_RX_PTYPE_INNER_PROT_UDP		= 1,
+	IDPF_RX_PTYPE_INNER_PROT_TCP		= 2,
+	IDPF_RX_PTYPE_INNER_PROT_SCTP		= 3,
+	IDPF_RX_PTYPE_INNER_PROT_ICMP		= 4,
+	IDPF_RX_PTYPE_INNER_PROT_TIMESYNC	= 5,
+};
+
+enum idpf_rx_ptype_payload_layer {
+	IDPF_RX_PTYPE_PAYLOAD_LAYER_NONE	= 0,
+	IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY2	= 1,
+	IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY3	= 2,
+	IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY4	= 3,
+};
+
+enum idpf_tunnel_state {
+	IDPF_PTYPE_TUNNEL_IP                    = BIT(0),
+	IDPF_PTYPE_TUNNEL_IP_GRENAT             = BIT(1),
+	IDPF_PTYPE_TUNNEL_IP_GRENAT_MAC         = BIT(2),
+};
+
+struct idpf_ptype_state {
+	bool outer_ip;
+	bool outer_frag;
+	u8 tunnel_state;
+};
+
+struct idpf_rx_ptype_decoded {
+	u32 ptype:10;
+	u32 known:1;
+	u32 outer_ip:1;
+	u32 outer_ip_ver:2;
+	u32 outer_frag:1;
+	u32 tunnel_type:3;
+	u32 tunnel_end_prot:2;
+	u32 tunnel_end_frag:1;
+	u32 inner_prot:4;
+	u32 payload_layer:3;
+};
+
 struct idpf_intr_reg {
 	void __iomem *dyn_ctl;
 	u32 dyn_ctl_intena_m;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index d5d31901831b..436b29bf450d 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -161,10 +161,15 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_CREATE_VPORT:
 	case VIRTCHNL2_OP_ALLOC_VECTORS:
 	case VIRTCHNL2_OP_DEALLOC_VECTORS:
+	case VIRTCHNL2_OP_GET_PTYPE_INFO:
 		goto free_vc_msg;
 	case VIRTCHNL2_OP_DESTROY_VPORT:
 		v_id = le32_to_cpu(((struct virtchnl2_vport *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_ADD_MAC_ADDR:
+	case VIRTCHNL2_OP_DEL_MAC_ADDR:
+		v_id = le32_to_cpu(((struct virtchnl2_mac_addr_list *)vc_msg)->vport_id);
+		break;
 	default:
 		no_op = true;
 		break;
@@ -423,6 +428,51 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_DEALLOC_VECTORS,
 					   IDPF_VC_DEALLOC_VECTORS_ERR);
 			break;
+		case VIRTCHNL2_OP_GET_PTYPE_INFO:
+			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
+					   IDPF_VC_GET_PTYPE_INFO,
+					   IDPF_VC_GET_PTYPE_INFO_ERR);
+			break;
+		case VIRTCHNL2_OP_ADD_MAC_ADDR:
+			if (test_and_clear_bit(IDPF_VPORT_ADD_MAC_REQ,
+					       vport->flags)) {
+				/* Message was sent asynchronously. We don't
+				 * normally print errors here, instead
+				 * prefer to handle errors in the function
+				 * calling wait_for_event. However, if
+				 * asynchronous, the context in which the
+				 * message was sent is lost. We can't really do
+				 * anything about at it this point, but we
+				 * should at a minimum indicate that it looks
+				 * like something went wrong. Also don't bother
+				 * setting ERR bit or waking vchnl_wq since no
+				 * one will be waiting to read the async
+				 * message.
+				 */
+				if (ctlq_msg.cookie.mbx.chnl_retval)
+					dev_err(&adapter->pdev->dev, "Failed to add MAC address: %d\n",
+						ctlq_msg.cookie.mbx.chnl_retval);
+				break;
+			}
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_ADD_MAC_ADDR,
+					   IDPF_VC_ADD_MAC_ADDR_ERR);
+			break;
+		case VIRTCHNL2_OP_DEL_MAC_ADDR:
+			if (test_and_clear_bit(IDPF_VPORT_DEL_MAC_REQ,
+					       vport->flags)) {
+				/* Message was sent asynchronously like the
+				 * VIRTCHNL2_OP_ADD_MAC_ADDR
+				 */
+				if (ctlq_msg.cookie.mbx.chnl_retval)
+					dev_err(&adapter->pdev->dev, "Failed to delete MAC address: %d\n",
+						ctlq_msg.cookie.mbx.chnl_retval);
+				break;
+			}
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_DEL_MAC_ADDR,
+					   IDPF_VC_DEL_MAC_ADDR_ERR);
+			break;
 		default:
 			dev_warn(&adapter->pdev->dev,
 				 "Unhandled virtchnl response %d\n",
@@ -873,6 +923,45 @@ int idpf_send_create_vport_msg(struct idpf_adapter *adapter,
 	return 0;
 }
 
+/**
+ * idpf_check_supported_desc_ids - Verify we have required descriptor support
+ * @vport: virtual port structure
+ *
+ * Return 0 on success, error on failure
+ */
+int idpf_check_supported_desc_ids(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_create_vport *vport_msg;
+	u64 rx_desc_ids, tx_desc_ids;
+
+	vport_msg = (struct virtchnl2_create_vport *)
+				adapter->vport_params_recvd[vport->idx];
+
+	rx_desc_ids = le64_to_cpu(vport_msg->rx_desc_ids);
+	tx_desc_ids = le64_to_cpu(vport_msg->tx_desc_ids);
+
+	if (vport->rxq_model == VIRTCHNL2_QUEUE_MODEL_SPLIT) {
+		if (!(rx_desc_ids & VIRTCHNL2_RXDID_2_FLEX_SPLITQ_M)) {
+			dev_info(&adapter->pdev->dev, "Minimum RX descriptor support not provided, using the default\n");
+			vport_msg->rx_desc_ids = cpu_to_le64(VIRTCHNL2_RXDID_2_FLEX_SPLITQ_M);
+		}
+	} else {
+		if (!(rx_desc_ids & VIRTCHNL2_RXDID_2_FLEX_SQ_NIC_M))
+			vport->base_rxd = true;
+	}
+
+	if (vport->txq_model != VIRTCHNL2_QUEUE_MODEL_SPLIT)
+		return 0;
+
+	if ((tx_desc_ids & MIN_SUPPORT_TXDID) != MIN_SUPPORT_TXDID) {
+		dev_info(&adapter->pdev->dev, "Minimum TX descriptor support not provided, using the default\n");
+		vport_msg->tx_desc_ids = cpu_to_le64(MIN_SUPPORT_TXDID);
+	}
+
+	return 0;
+}
+
 /**
  * idpf_send_destroy_vport_msg - Send virtchnl destroy vport message
  * @vport: virtual port data structure
@@ -990,6 +1079,264 @@ int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter)
 	return 0;
 }
 
+/**
+ * idpf_fill_ptype_lookup - Fill L3 specific fields in ptype lookup table
+ * @ptype: ptype lookup table
+ * @pstate: state machine for ptype lookup table
+ * @ipv4: ipv4 or ipv6
+ * @frag: fragmentation allowed
+ *
+ */
+static void idpf_fill_ptype_lookup(struct idpf_rx_ptype_decoded *ptype,
+				   struct idpf_ptype_state *pstate,
+				   bool ipv4, bool frag)
+{
+	if (!pstate->outer_ip || !pstate->outer_frag) {
+		ptype->outer_ip = IDPF_RX_PTYPE_OUTER_IP;
+		pstate->outer_ip = true;
+
+		if (ipv4)
+			ptype->outer_ip_ver = IDPF_RX_PTYPE_OUTER_IPV4;
+		else
+			ptype->outer_ip_ver = IDPF_RX_PTYPE_OUTER_IPV6;
+
+		if (frag) {
+			ptype->outer_frag = IDPF_RX_PTYPE_FRAG;
+			pstate->outer_frag = true;
+		}
+	} else {
+		ptype->tunnel_type = IDPF_RX_PTYPE_TUNNEL_IP_IP;
+		pstate->tunnel_state = IDPF_PTYPE_TUNNEL_IP;
+
+		if (ipv4)
+			ptype->tunnel_end_prot =
+					IDPF_RX_PTYPE_TUNNEL_END_IPV4;
+		else
+			ptype->tunnel_end_prot =
+					IDPF_RX_PTYPE_TUNNEL_END_IPV6;
+
+		if (frag)
+			ptype->tunnel_end_frag = IDPF_RX_PTYPE_FRAG;
+	}
+}
+
+/**
+ * idpf_send_get_rx_ptype_msg - Send virtchnl for ptype info
+ * @vport: virtual port data structure
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport)
+{
+	struct idpf_rx_ptype_decoded *ptype_lkup = vport->rx_ptype_lkup;
+	struct virtchnl2_get_ptype_info *get_ptype_info, *ptype_info;
+	int max_ptype, ptypes_recvd = 0, len, ptype_offset;
+	struct idpf_adapter *adapter = vport->adapter;
+	int err = 0, i, j, k = 0;
+
+	if (idpf_is_queue_model_split(vport->rxq_model))
+		max_ptype = IDPF_RX_MAX_PTYPE;
+	else
+		max_ptype = IDPF_RX_MAX_BASE_PTYPE;
+
+	memset(vport->rx_ptype_lkup, 0, sizeof(vport->rx_ptype_lkup));
+
+	len = sizeof(struct virtchnl2_get_ptype_info);
+	get_ptype_info = kzalloc(len, GFP_KERNEL);
+	if (!get_ptype_info)
+		return -ENOMEM;
+
+	get_ptype_info->start_ptype_id = 0;
+	get_ptype_info->num_ptypes = cpu_to_le16(max_ptype);
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_GET_PTYPE_INFO,
+			       len, (u8 *)get_ptype_info);
+	if (err)
+		goto get_ptype_rel;
+
+	while (ptypes_recvd < max_ptype) {
+		err = idpf_wait_for_event(adapter, NULL, IDPF_VC_GET_PTYPE_INFO,
+					  IDPF_VC_GET_PTYPE_INFO_ERR);
+		if (err)
+			goto get_ptype_rel;
+
+		len = IDPF_DFLT_MBX_BUF_SIZE;
+		ptype_info = kmemdup(adapter->vc_msg, len, GFP_KERNEL);
+		if (!ptype_info) {
+			err = -ENOMEM;
+			goto clear_vc_flag;
+		}
+
+		ptypes_recvd += le16_to_cpu(ptype_info->num_ptypes);
+		if (ptypes_recvd > max_ptype) {
+			err = -EINVAL;
+			goto ptype_rel;
+		}
+
+		ptype_offset = sizeof(struct virtchnl2_get_ptype_info);
+
+		for (i = 0; i < le16_to_cpu(ptype_info->num_ptypes); i++) {
+			struct idpf_ptype_state pstate = { };
+			struct virtchnl2_ptype *ptype;
+			u16 id;
+
+			ptype = (struct virtchnl2_ptype *)
+					((u8 *)ptype_info + ptype_offset);
+
+			ptype_offset += IDPF_GET_PTYPE_SIZE(ptype);
+			if (ptype_offset > len) {
+				err = -EINVAL;
+				goto ptype_rel;
+			}
+
+			/* 0xFFFF indicates end of ptypes */
+			if (le16_to_cpu(ptype->ptype_id_10) ==
+							IDPF_INVALID_PTYPE_ID) {
+				err = 0;
+				goto ptype_rel;
+			}
+
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				k = le16_to_cpu(ptype->ptype_id_10);
+			else
+				k = ptype->ptype_id_8;
+
+			if (ptype->proto_id_count)
+				ptype_lkup[k].known = 1;
+
+			for (j = 0; j < ptype->proto_id_count; j++) {
+				id = le16_to_cpu(ptype->proto_id[j]);
+				switch (id) {
+				case VIRTCHNL2_PROTO_HDR_GRE:
+					if (pstate.tunnel_state ==
+							IDPF_PTYPE_TUNNEL_IP) {
+						ptype_lkup[k].tunnel_type =
+						IDPF_RX_PTYPE_TUNNEL_IP_GRENAT;
+						pstate.tunnel_state |=
+						IDPF_PTYPE_TUNNEL_IP_GRENAT;
+					}
+					break;
+				case VIRTCHNL2_PROTO_HDR_MAC:
+					ptype_lkup[k].outer_ip =
+						IDPF_RX_PTYPE_OUTER_L2;
+					if (pstate.tunnel_state ==
+							IDPF_TUN_IP_GRE) {
+						ptype_lkup[k].tunnel_type =
+						IDPF_RX_PTYPE_TUNNEL_IP_GRENAT_MAC;
+						pstate.tunnel_state |=
+						IDPF_PTYPE_TUNNEL_IP_GRENAT_MAC;
+					}
+					break;
+				case VIRTCHNL2_PROTO_HDR_IPV4:
+					idpf_fill_ptype_lookup(&ptype_lkup[k],
+							       &pstate, true,
+							       false);
+					break;
+				case VIRTCHNL2_PROTO_HDR_IPV6:
+					idpf_fill_ptype_lookup(&ptype_lkup[k],
+							       &pstate, false,
+							       false);
+					break;
+				case VIRTCHNL2_PROTO_HDR_IPV4_FRAG:
+					idpf_fill_ptype_lookup(&ptype_lkup[k],
+							       &pstate, true,
+							       true);
+					break;
+				case VIRTCHNL2_PROTO_HDR_IPV6_FRAG:
+					idpf_fill_ptype_lookup(&ptype_lkup[k],
+							       &pstate, false,
+							       true);
+					break;
+				case VIRTCHNL2_PROTO_HDR_UDP:
+					ptype_lkup[k].inner_prot =
+					IDPF_RX_PTYPE_INNER_PROT_UDP;
+					break;
+				case VIRTCHNL2_PROTO_HDR_TCP:
+					ptype_lkup[k].inner_prot =
+					IDPF_RX_PTYPE_INNER_PROT_TCP;
+					break;
+				case VIRTCHNL2_PROTO_HDR_SCTP:
+					ptype_lkup[k].inner_prot =
+					IDPF_RX_PTYPE_INNER_PROT_SCTP;
+					break;
+				case VIRTCHNL2_PROTO_HDR_ICMP:
+					ptype_lkup[k].inner_prot =
+					IDPF_RX_PTYPE_INNER_PROT_ICMP;
+					break;
+				case VIRTCHNL2_PROTO_HDR_PAY:
+					ptype_lkup[k].payload_layer =
+						IDPF_RX_PTYPE_PAYLOAD_LAYER_PAY2;
+					break;
+				case VIRTCHNL2_PROTO_HDR_ICMPV6:
+				case VIRTCHNL2_PROTO_HDR_IPV6_EH:
+				case VIRTCHNL2_PROTO_HDR_PRE_MAC:
+				case VIRTCHNL2_PROTO_HDR_POST_MAC:
+				case VIRTCHNL2_PROTO_HDR_ETHERTYPE:
+				case VIRTCHNL2_PROTO_HDR_SVLAN:
+				case VIRTCHNL2_PROTO_HDR_CVLAN:
+				case VIRTCHNL2_PROTO_HDR_MPLS:
+				case VIRTCHNL2_PROTO_HDR_MMPLS:
+				case VIRTCHNL2_PROTO_HDR_PTP:
+				case VIRTCHNL2_PROTO_HDR_CTRL:
+				case VIRTCHNL2_PROTO_HDR_LLDP:
+				case VIRTCHNL2_PROTO_HDR_ARP:
+				case VIRTCHNL2_PROTO_HDR_ECP:
+				case VIRTCHNL2_PROTO_HDR_EAPOL:
+				case VIRTCHNL2_PROTO_HDR_PPPOD:
+				case VIRTCHNL2_PROTO_HDR_PPPOE:
+				case VIRTCHNL2_PROTO_HDR_IGMP:
+				case VIRTCHNL2_PROTO_HDR_AH:
+				case VIRTCHNL2_PROTO_HDR_ESP:
+				case VIRTCHNL2_PROTO_HDR_IKE:
+				case VIRTCHNL2_PROTO_HDR_NATT_KEEP:
+				case VIRTCHNL2_PROTO_HDR_L2TPV2:
+				case VIRTCHNL2_PROTO_HDR_L2TPV2_CONTROL:
+				case VIRTCHNL2_PROTO_HDR_L2TPV3:
+				case VIRTCHNL2_PROTO_HDR_GTP:
+				case VIRTCHNL2_PROTO_HDR_GTP_EH:
+				case VIRTCHNL2_PROTO_HDR_GTPCV2:
+				case VIRTCHNL2_PROTO_HDR_GTPC_TEID:
+				case VIRTCHNL2_PROTO_HDR_GTPU:
+				case VIRTCHNL2_PROTO_HDR_GTPU_UL:
+				case VIRTCHNL2_PROTO_HDR_GTPU_DL:
+				case VIRTCHNL2_PROTO_HDR_ECPRI:
+				case VIRTCHNL2_PROTO_HDR_VRRP:
+				case VIRTCHNL2_PROTO_HDR_OSPF:
+				case VIRTCHNL2_PROTO_HDR_TUN:
+				case VIRTCHNL2_PROTO_HDR_NVGRE:
+				case VIRTCHNL2_PROTO_HDR_VXLAN:
+				case VIRTCHNL2_PROTO_HDR_VXLAN_GPE:
+				case VIRTCHNL2_PROTO_HDR_GENEVE:
+				case VIRTCHNL2_PROTO_HDR_NSH:
+				case VIRTCHNL2_PROTO_HDR_QUIC:
+				case VIRTCHNL2_PROTO_HDR_PFCP:
+				case VIRTCHNL2_PROTO_HDR_PFCP_NODE:
+				case VIRTCHNL2_PROTO_HDR_PFCP_SESSION:
+				case VIRTCHNL2_PROTO_HDR_RTP:
+				case VIRTCHNL2_PROTO_HDR_NO_PROTO:
+					continue;
+				default:
+					break;
+				}
+			}
+		}
+		clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+		kfree(ptype_info);
+	}
+	kfree(get_ptype_info);
+
+	return 0;
+
+ptype_rel:
+	kfree(ptype_info);
+clear_vc_flag:
+	clear_bit(IDPF_VC_MSG_PENDING, adapter->flags);
+get_ptype_rel:
+	kfree(get_ptype_info);
+
+	return err;
+}
+
 /**
  * idpf_find_ctlq - Given a type and id, find ctlq info
  * @hw: hardware struct
@@ -1437,3 +1784,139 @@ u32 idpf_get_vport_id(struct idpf_vport *vport)
 
 	return le32_to_cpu(vport_msg->vport_id);
 }
+
+/**
+ * idpf_add_del_mac_filters - Add/del mac filters
+ * @vport: virtual port data structure
+ * @add: Add or delete flag
+ * @async: Don't wait for return message
+ *
+ * Returns 0 on success, error on failure.
+ **/
+int idpf_add_del_mac_filters(struct idpf_vport *vport, bool add, bool async)
+{
+	struct idpf_vport_user_config_data *user_config;
+	struct virtchnl2_mac_addr_list *ma_list = NULL;
+	struct idpf_adapter *adapter = vport->adapter;
+	struct pci_dev *pdev = adapter->pdev;
+	enum idpf_vport_vc_state vc, vc_err;
+	struct virtchnl2_mac_addr *mac_addr;
+	struct idpf_mac_filter *f, *tmp;
+	u32 num_msgs, total_filters = 0;
+	enum idpf_vport_flags mac_flag;
+	int i = 0, k = 0, err = 0;
+	u32 vop;
+
+	user_config = &adapter->vport_config[vport->idx]->user_config;
+	spin_lock_bh(&vport->mac_filter_list_lock);
+
+	/* Find the number of newly added filters */
+	list_for_each_entry(f, &user_config->mac_filter_list, list) {
+		if (add && f->add)
+			total_filters++;
+		else if (!add && f->remove)
+			total_filters++;
+	}
+
+	if (!total_filters) {
+		spin_unlock_bh(&vport->mac_filter_list_lock);
+
+		return 0;
+	}
+
+	/* Fill all the new filters into virtchannel message */
+	mac_addr = kcalloc(total_filters, sizeof(struct virtchnl2_mac_addr),
+			   GFP_ATOMIC);
+	if (!mac_addr) {
+		err = -ENOMEM;
+		spin_unlock_bh(&vport->mac_filter_list_lock);
+		goto error;
+	}
+
+	list_for_each_entry_safe(f, tmp, &user_config->mac_filter_list, list) {
+		if (add && f->add) {
+			ether_addr_copy(mac_addr[i].addr, f->macaddr);
+			i++;
+			f->add = false;
+			if (i == total_filters)
+				break;
+		}
+		if (!add && f->remove) {
+			ether_addr_copy(mac_addr[i].addr, f->macaddr);
+			i++;
+			f->remove = false;
+			if (i == total_filters)
+				break;
+		}
+	}
+
+	spin_unlock_bh(&vport->mac_filter_list_lock);
+
+	if (add) {
+		vop = VIRTCHNL2_OP_ADD_MAC_ADDR;
+		vc = IDPF_VC_ADD_MAC_ADDR;
+		vc_err = IDPF_VC_ADD_MAC_ADDR_ERR;
+		mac_flag = IDPF_VPORT_ADD_MAC_REQ;
+	} else {
+		vop = VIRTCHNL2_OP_DEL_MAC_ADDR;
+		vc = IDPF_VC_DEL_MAC_ADDR;
+		vc_err = IDPF_VC_DEL_MAC_ADDR_ERR;
+		mac_flag = IDPF_VPORT_DEL_MAC_REQ;
+	}
+
+	/* Chunk up the filters into multiple messages to avoid
+	 * sending a control queue message buffer that is too large
+	 */
+	num_msgs = DIV_ROUND_UP(total_filters, IDPF_NUM_FILTERS_PER_MSG);
+
+	for (i = 0, k = 0; i < num_msgs; i++) {
+		u32 entries_size, buf_size, num_entries;
+
+		num_entries = min_t(u32, total_filters, IDPF_NUM_FILTERS_PER_MSG);
+		entries_size = sizeof(struct virtchnl2_mac_addr) * num_entries;
+		buf_size = struct_size(ma_list, mac_addr_list, num_entries);
+
+		if (!ma_list || num_entries != IDPF_NUM_FILTERS_PER_MSG) {
+			kfree(ma_list);
+			ma_list = kzalloc(buf_size, GFP_ATOMIC);
+			if (!ma_list) {
+				err = -ENOMEM;
+				goto list_prep_error;
+			}
+		} else {
+			memset(ma_list, 0, buf_size);
+		}
+
+		ma_list->vport_id = cpu_to_le32(vport->vport_id);
+		ma_list->num_mac_addr = cpu_to_le16(num_entries);
+		memcpy(ma_list->mac_addr_list, &mac_addr[k], entries_size);
+
+		if (async)
+			set_bit(mac_flag, vport->flags);
+
+		err = idpf_send_mb_msg(adapter, vop, buf_size, (u8 *)ma_list);
+		if (err)
+			goto mbx_error;
+
+		if (!async) {
+			err = idpf_wait_for_event(adapter, vport, vc, vc_err);
+			if (err)
+				goto mbx_error;
+		}
+
+		k += num_entries;
+		total_filters -= num_entries;
+
+		clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+	}
+
+mbx_error:
+	kfree(ma_list);
+list_prep_error:
+	kfree(mac_addr);
+error:
+	if (err)
+		dev_err(&pdev->dev, "Failed to add or del mac filters %d", err);
+
+	return err;
+}
-- 
2.37.3


