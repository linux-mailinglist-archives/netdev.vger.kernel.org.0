Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022F23450DF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhCVUci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:5513 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhCVUbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:25 -0400
IronPort-SDR: jpXXJ/pTEDg6qDmc9cxtcj29lxsAau02nm3JcJERpxoViGzm2cOK5/mIS7ak5YlW/MjRBem8oq
 zzimgdRyuqxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438224"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438224"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:19 -0700
IronPort-SDR: hUdi5XiTnGNUzNujgZltMI3OeanQAKjyxIT4Oo1G6RFq4dQfNUqUqtocwTnWfoz0ArV0ac3z8V
 7OScVsl++P2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810625"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        qi.z.zhang@intel.com, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 15/18] iavf: Support IPv4 Flow Director filters
Date:   Mon, 22 Mar 2021 13:32:41 -0700
Message-Id: <20210322203244.2525310-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Support the addition and deletion of IPv4 filters.

Supported fields are: src-ip, dst-ip, src-port, dst-port and l4proto
Supported flow-types are: tcp4, udp4, sctp4, ip4, ah4, esp4

Example usage:
ethtool -N ens787f0v0 flow-type tcp4 src-ip 192.168.0.20 \
  dst-ip 192.168.0.21 tos 4 src-port 22 dst-port 23 action 8

L2TPv3 over IP with 'Session ID' 17:
ethtool -N ens787f0v0 flow-type ip4 l4proto 115 l4data 17 action 3

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/Makefile      |   2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 404 +++++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   | 428 ++++++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |  40 ++
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   8 +
 5 files changed, 881 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.c

diff --git a/drivers/net/ethernet/intel/iavf/Makefile b/drivers/net/ethernet/intel/iavf/Makefile
index c997063ed728..121e194ee734 100644
--- a/drivers/net/ethernet/intel/iavf/Makefile
+++ b/drivers/net/ethernet/intel/iavf/Makefile
@@ -11,5 +11,5 @@ subdir-ccflags-y += -I$(src)
 
 obj-$(CONFIG_IAVF) += iavf.o
 
-iavf-objs := iavf_main.o iavf_ethtool.o iavf_virtchnl.o \
+iavf-objs := iavf_main.o iavf_ethtool.o iavf_virtchnl.o iavf_fdir.o \
 	     iavf_txrx.o iavf_common.o iavf_adminq.o iavf_client.o
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index c93567f4d0f7..edd864f3b717 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -827,6 +827,396 @@ static int iavf_set_per_queue_coalesce(struct net_device *netdev, u32 queue,
 	return __iavf_set_coalesce(netdev, ec, queue);
 }
 
+/**
+ * iavf_fltr_to_ethtool_flow - convert filter type values to ethtool
+ * flow type values
+ * @flow: filter type to be converted
+ *
+ * Returns the corresponding ethtool flow type.
+ */
+static int iavf_fltr_to_ethtool_flow(enum iavf_fdir_flow_type flow)
+{
+	switch (flow) {
+	case IAVF_FDIR_FLOW_IPV4_TCP:
+		return TCP_V4_FLOW;
+	case IAVF_FDIR_FLOW_IPV4_UDP:
+		return UDP_V4_FLOW;
+	case IAVF_FDIR_FLOW_IPV4_SCTP:
+		return SCTP_V4_FLOW;
+	case IAVF_FDIR_FLOW_IPV4_AH:
+		return AH_V4_FLOW;
+	case IAVF_FDIR_FLOW_IPV4_ESP:
+		return ESP_V4_FLOW;
+	case IAVF_FDIR_FLOW_IPV4_OTHER:
+		return IPV4_USER_FLOW;
+	default:
+		/* 0 is undefined ethtool flow */
+		return 0;
+	}
+}
+
+/**
+ * iavf_ethtool_flow_to_fltr - convert ethtool flow type to filter enum
+ * @eth: Ethtool flow type to be converted
+ *
+ * Returns flow enum
+ */
+static enum iavf_fdir_flow_type iavf_ethtool_flow_to_fltr(int eth)
+{
+	switch (eth) {
+	case TCP_V4_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_TCP;
+	case UDP_V4_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_UDP;
+	case SCTP_V4_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_SCTP;
+	case AH_V4_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_AH;
+	case ESP_V4_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_ESP;
+	case IPV4_USER_FLOW:
+		return IAVF_FDIR_FLOW_IPV4_OTHER;
+	default:
+		return IAVF_FDIR_FLOW_NONE;
+	}
+}
+
+/**
+ * iavf_get_ethtool_fdir_entry - fill ethtool structure with Flow Director filter data
+ * @adapter: the VF adapter structure that contains filter list
+ * @cmd: ethtool command data structure to receive the filter data
+ *
+ * Returns 0 as expected for success by ethtool
+ */
+static int
+iavf_get_ethtool_fdir_entry(struct iavf_adapter *adapter,
+			    struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct iavf_fdir_fltr *rule = NULL;
+	int ret = 0;
+
+	if (!FDIR_FLTR_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+
+	rule = iavf_find_fdir_fltr_by_loc(adapter, fsp->location);
+	if (!rule) {
+		ret = -EINVAL;
+		goto release_lock;
+	}
+
+	fsp->flow_type = iavf_fltr_to_ethtool_flow(rule->flow_type);
+
+	memset(&fsp->m_u, 0, sizeof(fsp->m_u));
+	memset(&fsp->m_ext, 0, sizeof(fsp->m_ext));
+
+	switch (fsp->flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		fsp->h_u.tcp_ip4_spec.ip4src = rule->ip_data.v4_addrs.src_ip;
+		fsp->h_u.tcp_ip4_spec.ip4dst = rule->ip_data.v4_addrs.dst_ip;
+		fsp->h_u.tcp_ip4_spec.psrc = rule->ip_data.src_port;
+		fsp->h_u.tcp_ip4_spec.pdst = rule->ip_data.dst_port;
+		fsp->h_u.tcp_ip4_spec.tos = rule->ip_data.tos;
+		fsp->m_u.tcp_ip4_spec.ip4src = rule->ip_mask.v4_addrs.src_ip;
+		fsp->m_u.tcp_ip4_spec.ip4dst = rule->ip_mask.v4_addrs.dst_ip;
+		fsp->m_u.tcp_ip4_spec.psrc = rule->ip_mask.src_port;
+		fsp->m_u.tcp_ip4_spec.pdst = rule->ip_mask.dst_port;
+		fsp->m_u.tcp_ip4_spec.tos = rule->ip_mask.tos;
+		break;
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+		fsp->h_u.ah_ip4_spec.ip4src = rule->ip_data.v4_addrs.src_ip;
+		fsp->h_u.ah_ip4_spec.ip4dst = rule->ip_data.v4_addrs.dst_ip;
+		fsp->h_u.ah_ip4_spec.spi = rule->ip_data.spi;
+		fsp->h_u.ah_ip4_spec.tos = rule->ip_data.tos;
+		fsp->m_u.ah_ip4_spec.ip4src = rule->ip_mask.v4_addrs.src_ip;
+		fsp->m_u.ah_ip4_spec.ip4dst = rule->ip_mask.v4_addrs.dst_ip;
+		fsp->m_u.ah_ip4_spec.spi = rule->ip_mask.spi;
+		fsp->m_u.ah_ip4_spec.tos = rule->ip_mask.tos;
+		break;
+	case IPV4_USER_FLOW:
+		fsp->h_u.usr_ip4_spec.ip4src = rule->ip_data.v4_addrs.src_ip;
+		fsp->h_u.usr_ip4_spec.ip4dst = rule->ip_data.v4_addrs.dst_ip;
+		fsp->h_u.usr_ip4_spec.l4_4_bytes = rule->ip_data.l4_header;
+		fsp->h_u.usr_ip4_spec.tos = rule->ip_data.tos;
+		fsp->h_u.usr_ip4_spec.ip_ver = ETH_RX_NFC_IP4;
+		fsp->h_u.usr_ip4_spec.proto = rule->ip_data.proto;
+		fsp->m_u.usr_ip4_spec.ip4src = rule->ip_mask.v4_addrs.src_ip;
+		fsp->m_u.usr_ip4_spec.ip4dst = rule->ip_mask.v4_addrs.dst_ip;
+		fsp->m_u.usr_ip4_spec.l4_4_bytes = rule->ip_mask.l4_header;
+		fsp->m_u.usr_ip4_spec.tos = rule->ip_mask.tos;
+		fsp->m_u.usr_ip4_spec.ip_ver = 0xFF;
+		fsp->m_u.usr_ip4_spec.proto = rule->ip_mask.proto;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (rule->action == VIRTCHNL_ACTION_DROP)
+		fsp->ring_cookie = RX_CLS_FLOW_DISC;
+	else
+		fsp->ring_cookie = rule->q_index;
+
+release_lock:
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+	return ret;
+}
+
+/**
+ * iavf_get_fdir_fltr_ids - fill buffer with filter IDs of active filters
+ * @adapter: the VF adapter structure containing the filter list
+ * @cmd: ethtool command data structure
+ * @rule_locs: ethtool array passed in from OS to receive filter IDs
+ *
+ * Returns 0 as expected for success by ethtool
+ */
+static int
+iavf_get_fdir_fltr_ids(struct iavf_adapter *adapter, struct ethtool_rxnfc *cmd,
+		       u32 *rule_locs)
+{
+	struct iavf_fdir_fltr *fltr;
+	unsigned int cnt = 0;
+	int val = 0;
+
+	if (!FDIR_FLTR_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	cmd->data = IAVF_MAX_FDIR_FILTERS;
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+
+	list_for_each_entry(fltr, &adapter->fdir_list_head, list) {
+		if (cnt == cmd->rule_cnt) {
+			val = -EMSGSIZE;
+			goto release_lock;
+		}
+		rule_locs[cnt] = fltr->loc;
+		cnt++;
+	}
+
+release_lock:
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+	if (!val)
+		cmd->rule_cnt = cnt;
+
+	return val;
+}
+
+/**
+ * iavf_add_fdir_fltr_info - Set the input set for Flow Director filter
+ * @adapter: pointer to the VF adapter structure
+ * @fsp: pointer to ethtool Rx flow specification
+ * @fltr: filter structure
+ */
+static int
+iavf_add_fdir_fltr_info(struct iavf_adapter *adapter, struct ethtool_rx_flow_spec *fsp,
+			struct iavf_fdir_fltr *fltr)
+{
+	u32 flow_type, q_index = 0;
+	enum virtchnl_action act;
+
+	if (fsp->ring_cookie == RX_CLS_FLOW_DISC) {
+		act = VIRTCHNL_ACTION_DROP;
+	} else {
+		q_index = fsp->ring_cookie;
+		if (q_index >= adapter->num_active_queues)
+			return -EINVAL;
+
+		act = VIRTCHNL_ACTION_QUEUE;
+	}
+
+	fltr->action = act;
+	fltr->loc = fsp->location;
+	fltr->q_index = q_index;
+
+	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
+	fltr->flow_type = iavf_ethtool_flow_to_fltr(flow_type);
+
+	switch (flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		fltr->ip_data.v4_addrs.src_ip = fsp->h_u.tcp_ip4_spec.ip4src;
+		fltr->ip_data.v4_addrs.dst_ip = fsp->h_u.tcp_ip4_spec.ip4dst;
+		fltr->ip_data.src_port = fsp->h_u.tcp_ip4_spec.psrc;
+		fltr->ip_data.dst_port = fsp->h_u.tcp_ip4_spec.pdst;
+		fltr->ip_data.tos = fsp->h_u.tcp_ip4_spec.tos;
+		fltr->ip_mask.v4_addrs.src_ip = fsp->m_u.tcp_ip4_spec.ip4src;
+		fltr->ip_mask.v4_addrs.dst_ip = fsp->m_u.tcp_ip4_spec.ip4dst;
+		fltr->ip_mask.src_port = fsp->m_u.tcp_ip4_spec.psrc;
+		fltr->ip_mask.dst_port = fsp->m_u.tcp_ip4_spec.pdst;
+		fltr->ip_mask.tos = fsp->m_u.tcp_ip4_spec.tos;
+		break;
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+		fltr->ip_data.v4_addrs.src_ip = fsp->h_u.ah_ip4_spec.ip4src;
+		fltr->ip_data.v4_addrs.dst_ip = fsp->h_u.ah_ip4_spec.ip4dst;
+		fltr->ip_data.spi = fsp->h_u.ah_ip4_spec.spi;
+		fltr->ip_data.tos = fsp->h_u.ah_ip4_spec.tos;
+		fltr->ip_mask.v4_addrs.src_ip = fsp->m_u.ah_ip4_spec.ip4src;
+		fltr->ip_mask.v4_addrs.dst_ip = fsp->m_u.ah_ip4_spec.ip4dst;
+		fltr->ip_mask.spi = fsp->m_u.ah_ip4_spec.spi;
+		fltr->ip_mask.tos = fsp->m_u.ah_ip4_spec.tos;
+		break;
+	case IPV4_USER_FLOW:
+		fltr->ip_data.v4_addrs.src_ip = fsp->h_u.usr_ip4_spec.ip4src;
+		fltr->ip_data.v4_addrs.dst_ip = fsp->h_u.usr_ip4_spec.ip4dst;
+		fltr->ip_data.l4_header = fsp->h_u.usr_ip4_spec.l4_4_bytes;
+		fltr->ip_data.tos = fsp->h_u.usr_ip4_spec.tos;
+		fltr->ip_data.proto = fsp->h_u.usr_ip4_spec.proto;
+		fltr->ip_mask.v4_addrs.src_ip = fsp->m_u.usr_ip4_spec.ip4src;
+		fltr->ip_mask.v4_addrs.dst_ip = fsp->m_u.usr_ip4_spec.ip4dst;
+		fltr->ip_mask.l4_header = fsp->m_u.usr_ip4_spec.l4_4_bytes;
+		fltr->ip_mask.tos = fsp->m_u.usr_ip4_spec.tos;
+		fltr->ip_mask.proto = fsp->m_u.usr_ip4_spec.proto;
+		break;
+	default:
+		/* not doing un-parsed flow types */
+		return -EINVAL;
+	}
+
+	if (iavf_fdir_is_dup_fltr(adapter, fltr))
+		return -EEXIST;
+
+	return iavf_fill_fdir_add_msg(adapter, fltr);
+}
+
+/**
+ * iavf_add_fdir_ethtool - add Flow Director filter
+ * @adapter: pointer to the VF adapter structure
+ * @cmd: command to add Flow Director filter
+ *
+ * Returns 0 on success and negative values for failure
+ */
+static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp = &cmd->fs;
+	struct iavf_fdir_fltr *fltr;
+	int count = 50;
+	int err;
+
+	if (!FDIR_FLTR_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	if (fsp->flow_type & FLOW_MAC_EXT)
+		return -EINVAL;
+
+	if (adapter->fdir_active_fltr >= IAVF_MAX_FDIR_FILTERS) {
+		dev_err(&adapter->pdev->dev,
+			"Unable to add Flow Director filter because VF reached the limit of max allowed filters (%u)\n",
+			IAVF_MAX_FDIR_FILTERS);
+		return -ENOSPC;
+	}
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	if (iavf_find_fdir_fltr_by_loc(adapter, fsp->location)) {
+		dev_err(&adapter->pdev->dev, "Failed to add Flow Director filter, it already exists\n");
+		spin_unlock_bh(&adapter->fdir_fltr_lock);
+		return -EEXIST;
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	fltr = kzalloc(sizeof(*fltr), GFP_KERNEL);
+	if (!fltr)
+		return -ENOMEM;
+
+	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
+				&adapter->crit_section)) {
+		if (--count == 0) {
+			kfree(fltr);
+			return -EINVAL;
+		}
+		udelay(1);
+	}
+
+	err = iavf_add_fdir_fltr_info(adapter, fsp, fltr);
+	if (err)
+		goto ret;
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	iavf_fdir_list_add_fltr(adapter, fltr);
+	adapter->fdir_active_fltr++;
+	fltr->state = IAVF_FDIR_FLTR_ADD_REQUEST;
+	adapter->aq_required |= IAVF_FLAG_AQ_ADD_FDIR_FILTER;
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+
+ret:
+	if (err && fltr)
+		kfree(fltr);
+
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	return err;
+}
+
+/**
+ * iavf_del_fdir_ethtool - delete Flow Director filter
+ * @adapter: pointer to the VF adapter structure
+ * @cmd: command to delete Flow Director filter
+ *
+ * Returns 0 on success and negative values for failure
+ */
+static int iavf_del_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct iavf_fdir_fltr *fltr = NULL;
+	int err = 0;
+
+	if (!FDIR_FLTR_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	fltr = iavf_find_fdir_fltr_by_loc(adapter, fsp->location);
+	if (fltr) {
+		if (fltr->state == IAVF_FDIR_FLTR_ACTIVE) {
+			fltr->state = IAVF_FDIR_FLTR_DEL_REQUEST;
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
+		} else {
+			err = -EBUSY;
+		}
+	} else if (adapter->fdir_active_fltr) {
+		err = -EINVAL;
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	if (fltr && fltr->state == IAVF_FDIR_FLTR_DEL_REQUEST)
+		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+
+	return err;
+}
+
+/**
+ * iavf_set_rxnfc - command to set Rx flow rules.
+ * @netdev: network interface device structure
+ * @cmd: ethtool rxnfc command
+ *
+ * Returns 0 for success and negative values for errors
+ */
+static int iavf_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
+{
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		ret = iavf_add_fdir_ethtool(adapter, cmd);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		ret = iavf_del_fdir_ethtool(adapter, cmd);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 /**
  * iavf_get_rxnfc - command to get RX flow classification rules
  * @netdev: network interface device structure
@@ -846,6 +1236,19 @@ static int iavf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		cmd->data = adapter->num_active_queues;
 		ret = 0;
 		break;
+	case ETHTOOL_GRXCLSRLCNT:
+		if (!FDIR_FLTR_SUPPORT(adapter))
+			break;
+		cmd->rule_cnt = adapter->fdir_active_fltr;
+		cmd->data = IAVF_MAX_FDIR_FILTERS;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		ret = iavf_get_ethtool_fdir_entry(adapter, cmd);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		ret = iavf_get_fdir_fltr_ids(adapter, cmd, (u32 *)rule_locs);
+		break;
 	case ETHTOOL_GRXFH:
 		netdev_info(netdev,
 			    "RSS hash info is not available to vf, use pf.\n");
@@ -1025,6 +1428,7 @@ static const struct ethtool_ops iavf_ethtool_ops = {
 	.set_coalesce		= iavf_set_coalesce,
 	.get_per_queue_coalesce = iavf_get_per_queue_coalesce,
 	.set_per_queue_coalesce = iavf_set_per_queue_coalesce,
+	.set_rxnfc		= iavf_set_rxnfc,
 	.get_rxnfc		= iavf_get_rxnfc,
 	.get_rxfh_indir_size	= iavf_get_rxfh_indir_size,
 	.get_rxfh		= iavf_get_rxfh,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
new file mode 100644
index 000000000000..69de6a45f5f0
--- /dev/null
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -0,0 +1,428 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Intel Corporation. */
+
+/* flow director ethtool support for iavf */
+
+#include "iavf.h"
+
+/**
+ * iavf_fill_fdir_ip4_hdr - fill the IPv4 protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the IPv4 protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_ip4_hdr(struct iavf_fdir_fltr *fltr,
+		       struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct iphdr *iph = (struct iphdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, IPV4);
+
+	if (fltr->ip_mask.tos == U8_MAX) {
+		iph->tos = fltr->ip_data.tos;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, DSCP);
+	}
+
+	if (fltr->ip_mask.proto == U8_MAX) {
+		iph->protocol = fltr->ip_data.proto;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, PROT);
+	}
+
+	if (fltr->ip_mask.v4_addrs.src_ip == htonl(U32_MAX)) {
+		iph->saddr = fltr->ip_data.v4_addrs.src_ip;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, SRC);
+	}
+
+	if (fltr->ip_mask.v4_addrs.dst_ip == htonl(U32_MAX)) {
+		iph->daddr = fltr->ip_data.v4_addrs.dst_ip;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, DST);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_tcp_hdr - fill the TCP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the TCP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_tcp_hdr(struct iavf_fdir_fltr *fltr,
+		       struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct tcphdr *tcph = (struct tcphdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, TCP);
+
+	if (fltr->ip_mask.src_port == htons(U16_MAX)) {
+		tcph->source = fltr->ip_data.src_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, TCP, SRC_PORT);
+	}
+
+	if (fltr->ip_mask.dst_port == htons(U16_MAX)) {
+		tcph->dest = fltr->ip_data.dst_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, TCP, DST_PORT);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_udp_hdr - fill the UDP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the UDP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_udp_hdr(struct iavf_fdir_fltr *fltr,
+		       struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct udphdr *udph = (struct udphdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, UDP);
+
+	if (fltr->ip_mask.src_port == htons(U16_MAX)) {
+		udph->source = fltr->ip_data.src_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, UDP, SRC_PORT);
+	}
+
+	if (fltr->ip_mask.dst_port == htons(U16_MAX)) {
+		udph->dest = fltr->ip_data.dst_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, UDP, DST_PORT);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_sctp_hdr - fill the SCTP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the SCTP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_sctp_hdr(struct iavf_fdir_fltr *fltr,
+			struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct sctphdr *sctph = (struct sctphdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, SCTP);
+
+	if (fltr->ip_mask.src_port == htons(U16_MAX)) {
+		sctph->source = fltr->ip_data.src_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, SCTP, SRC_PORT);
+	}
+
+	if (fltr->ip_mask.dst_port == htons(U16_MAX)) {
+		sctph->dest = fltr->ip_data.dst_port;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, SCTP, DST_PORT);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_ah_hdr - fill the AH protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the AH protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_ah_hdr(struct iavf_fdir_fltr *fltr,
+		      struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct ip_auth_hdr *ah = (struct ip_auth_hdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, AH);
+
+	if (fltr->ip_mask.spi == htonl(U32_MAX)) {
+		ah->spi = fltr->ip_data.spi;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, AH, SPI);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_esp_hdr - fill the ESP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the ESP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_esp_hdr(struct iavf_fdir_fltr *fltr,
+		       struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct ip_esp_hdr *esph = (struct ip_esp_hdr *)hdr->buffer;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, ESP);
+
+	if (fltr->ip_mask.spi == htonl(U32_MAX)) {
+		esph->spi = fltr->ip_data.spi;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, ESP, SPI);
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_l4_hdr - fill the L4 protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the L4 protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_l4_hdr(struct iavf_fdir_fltr *fltr,
+		      struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr;
+	__be32 *l4_4_data;
+
+	if (!fltr->ip_mask.proto) /* IPv4/IPv6 header only */
+		return 0;
+
+	hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	l4_4_data = (__be32 *)hdr->buffer;
+
+	/* L2TPv3 over IP with 'Session ID' */
+	if (fltr->ip_data.proto == 115 && fltr->ip_mask.l4_header == htonl(U32_MAX)) {
+		VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, L2TPV3);
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, L2TPV3, SESS_ID);
+
+		*l4_4_data = fltr->ip_data.l4_header;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_eth_hdr - fill the Ethernet protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the Ethernet protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_eth_hdr(struct iavf_fdir_fltr *fltr,
+		       struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, ETH);
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_add_msg - fill the Flow Director filter into virtchnl message
+ * @adapter: pointer to the VF adapter structure
+ * @fltr: Flow Director filter data structure
+ *
+ * Returns 0 if the add Flow Director virtchnl message is filled successfully
+ */
+int iavf_fill_fdir_add_msg(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr)
+{
+	struct virtchnl_fdir_add *vc_msg = &fltr->vc_add_msg;
+	struct virtchnl_proto_hdrs *proto_hdrs;
+	int err;
+
+	proto_hdrs = &vc_msg->rule_cfg.proto_hdrs;
+
+	err = iavf_fill_fdir_eth_hdr(fltr, proto_hdrs); /* L2 always exists */
+	if (err)
+		return err;
+
+	switch (fltr->flow_type) {
+	case IAVF_FDIR_FLOW_IPV4_TCP:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_tcp_hdr(fltr, proto_hdrs);
+		break;
+	case IAVF_FDIR_FLOW_IPV4_UDP:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_udp_hdr(fltr, proto_hdrs);
+		break;
+	case IAVF_FDIR_FLOW_IPV4_SCTP:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_sctp_hdr(fltr, proto_hdrs);
+		break;
+	case IAVF_FDIR_FLOW_IPV4_AH:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_ah_hdr(fltr, proto_hdrs);
+		break;
+	case IAVF_FDIR_FLOW_IPV4_ESP:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_esp_hdr(fltr, proto_hdrs);
+		break;
+	case IAVF_FDIR_FLOW_IPV4_OTHER:
+		err = iavf_fill_fdir_ip4_hdr(fltr, proto_hdrs) |
+		      iavf_fill_fdir_l4_hdr(fltr, proto_hdrs);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	if (err)
+		return err;
+
+	vc_msg->vsi_id = adapter->vsi.id;
+	vc_msg->rule_cfg.action_set.count = 1;
+	vc_msg->rule_cfg.action_set.actions[0].type = fltr->action;
+	vc_msg->rule_cfg.action_set.actions[0].act_conf.queue.index = fltr->q_index;
+
+	return 0;
+}
+
+/**
+ * iavf_fdir_flow_proto_name - get the flow protocol name
+ * @flow_type: Flow Director filter flow type
+ **/
+static const char *iavf_fdir_flow_proto_name(enum iavf_fdir_flow_type flow_type)
+{
+	switch (flow_type) {
+	case IAVF_FDIR_FLOW_IPV4_TCP:
+		return "TCP";
+	case IAVF_FDIR_FLOW_IPV4_UDP:
+		return "UDP";
+	case IAVF_FDIR_FLOW_IPV4_SCTP:
+		return "SCTP";
+	case IAVF_FDIR_FLOW_IPV4_AH:
+		return "AH";
+	case IAVF_FDIR_FLOW_IPV4_ESP:
+		return "ESP";
+	case IAVF_FDIR_FLOW_IPV4_OTHER:
+		return "Other";
+	default:
+		return NULL;
+	}
+}
+
+/**
+ * iavf_print_fdir_fltr
+ * @adapter: adapter structure
+ * @fltr: Flow Director filter to print
+ *
+ * Print the Flow Director filter
+ **/
+void iavf_print_fdir_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr)
+{
+	const char *proto = iavf_fdir_flow_proto_name(fltr->flow_type);
+
+	if (!proto)
+		return;
+
+	switch (fltr->flow_type) {
+	case IAVF_FDIR_FLOW_IPV4_TCP:
+	case IAVF_FDIR_FLOW_IPV4_UDP:
+	case IAVF_FDIR_FLOW_IPV4_SCTP:
+		dev_info(&adapter->pdev->dev, "Rule ID: %u dst_ip: %pI4 src_ip %pI4 %s: dst_port %hu src_port %hu\n",
+			 fltr->loc,
+			 &fltr->ip_data.v4_addrs.dst_ip,
+			 &fltr->ip_data.v4_addrs.src_ip,
+			 proto,
+			 ntohs(fltr->ip_data.dst_port),
+			 ntohs(fltr->ip_data.src_port));
+		break;
+	case IAVF_FDIR_FLOW_IPV4_AH:
+	case IAVF_FDIR_FLOW_IPV4_ESP:
+		dev_info(&adapter->pdev->dev, "Rule ID: %u dst_ip: %pI4 src_ip %pI4 %s: SPI %u\n",
+			 fltr->loc,
+			 &fltr->ip_data.v4_addrs.dst_ip,
+			 &fltr->ip_data.v4_addrs.src_ip,
+			 proto,
+			 ntohl(fltr->ip_data.spi));
+		break;
+	case IAVF_FDIR_FLOW_IPV4_OTHER:
+		dev_info(&adapter->pdev->dev, "Rule ID: %u dst_ip: %pI4 src_ip %pI4 proto: %u L4_bytes: 0x%x\n",
+			 fltr->loc,
+			 &fltr->ip_data.v4_addrs.dst_ip,
+			 &fltr->ip_data.v4_addrs.src_ip,
+			 fltr->ip_data.proto,
+			 ntohl(fltr->ip_data.l4_header));
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * iavf_fdir_is_dup_fltr - test if filter is already in list
+ * @adapter: pointer to the VF adapter structure
+ * @fltr: Flow Director filter data structure
+ *
+ * Returns true if the filter is found in the list
+ */
+bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr)
+{
+	struct iavf_fdir_fltr *tmp;
+	bool ret = false;
+
+	list_for_each_entry(tmp, &adapter->fdir_list_head, list) {
+		if (tmp->flow_type != fltr->flow_type)
+			continue;
+
+		if (!memcmp(&tmp->ip_data, &fltr->ip_data,
+			    sizeof(fltr->ip_data))) {
+			ret = true;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * iavf_find_fdir_fltr_by_loc - find filter with location
+ * @adapter: pointer to the VF adapter structure
+ * @loc: location to find.
+ *
+ * Returns pointer to Flow Director filter if found or null
+ */
+struct iavf_fdir_fltr *iavf_find_fdir_fltr_by_loc(struct iavf_adapter *adapter, u32 loc)
+{
+	struct iavf_fdir_fltr *rule;
+
+	list_for_each_entry(rule, &adapter->fdir_list_head, list)
+		if (rule->loc == loc)
+			return rule;
+
+	return NULL;
+}
+
+/**
+ * iavf_fdir_list_add_fltr - add a new node to the flow director filter list
+ * @adapter: pointer to the VF adapter structure
+ * @fltr: filter node to add to structure
+ */
+void iavf_fdir_list_add_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr)
+{
+	struct iavf_fdir_fltr *rule, *parent = NULL;
+
+	list_for_each_entry(rule, &adapter->fdir_list_head, list) {
+		if (rule->loc >= fltr->loc)
+			break;
+		parent = rule;
+	}
+
+	if (parent)
+		list_add(&fltr->list, &parent->list);
+	else
+		list_add(&fltr->list, &adapter->fdir_list_head);
+}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.h b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
index 4e6494b14016..bce913c2541d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
@@ -15,13 +15,53 @@ enum iavf_fdir_fltr_state_t {
 	IAVF_FDIR_FLTR_ACTIVE,		/* Filter is active */
 };
 
+enum iavf_fdir_flow_type {
+	/* NONE - used for undef/error */
+	IAVF_FDIR_FLOW_NONE = 0,
+	IAVF_FDIR_FLOW_IPV4_TCP,
+	IAVF_FDIR_FLOW_IPV4_UDP,
+	IAVF_FDIR_FLOW_IPV4_SCTP,
+	IAVF_FDIR_FLOW_IPV4_AH,
+	IAVF_FDIR_FLOW_IPV4_ESP,
+	IAVF_FDIR_FLOW_IPV4_OTHER,
+	/* MAX - this must be last and add anything new just above it */
+	IAVF_FDIR_FLOW_PTYPE_MAX,
+};
+
+struct iavf_ipv4_addrs {
+	__be32 src_ip;
+	__be32 dst_ip;
+};
+
+struct iavf_fdir_ip {
+	union {
+		struct iavf_ipv4_addrs v4_addrs;
+	};
+	__be16 src_port;
+	__be16 dst_port;
+	__be32 l4_header;	/* first 4 bytes of the layer 4 header */
+	__be32 spi;		/* security parameter index for AH/ESP */
+	union {
+		u8 tos;
+	};
+	u8 proto;
+};
 /* bookkeeping of Flow Director filters */
 struct iavf_fdir_fltr {
 	enum iavf_fdir_fltr_state_t state;
 	struct list_head list;
 
+	enum iavf_fdir_flow_type flow_type;
+
+	struct iavf_fdir_ip ip_data;
+	struct iavf_fdir_ip ip_mask;
+
+	enum virtchnl_action action;
 	u32 flow_id;
 
+	u32 loc;	/* Rule location inside the flow table */
+	u32 q_index;
+
 	struct virtchnl_fdir_add vc_add_msg;
 };
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 9b8a5b700cff..43a4d4ef415f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1464,6 +1464,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 					dev_info(&adapter->pdev->dev, "Failed to add Flow Director filter, error %s\n",
 						 iavf_stat_str(&adapter->hw,
 							       v_retval));
+					iavf_print_fdir_fltr(adapter, fdir);
 					if (msglen)
 						dev_err(&adapter->pdev->dev,
 							"%s\n", msg);
@@ -1486,6 +1487,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 					dev_info(&adapter->pdev->dev, "Failed to del Flow Director filter, error %s\n",
 						 iavf_stat_str(&adapter->hw,
 							       v_retval));
+					iavf_print_fdir_fltr(adapter, fdir);
 				}
 			}
 			spin_unlock_bh(&adapter->fdir_fltr_lock);
@@ -1638,11 +1640,14 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 					 list) {
 			if (fdir->state == IAVF_FDIR_FLTR_ADD_PENDING) {
 				if (add_fltr->status == VIRTCHNL_FDIR_SUCCESS) {
+					dev_info(&adapter->pdev->dev, "Flow Director filter with location %u is added\n",
+						 fdir->loc);
 					fdir->state = IAVF_FDIR_FLTR_ACTIVE;
 					fdir->flow_id = add_fltr->flow_id;
 				} else {
 					dev_info(&adapter->pdev->dev, "Failed to add Flow Director filter with status: %d\n",
 						 add_fltr->status);
+					iavf_print_fdir_fltr(adapter, fdir);
 					list_del(&fdir->list);
 					kfree(fdir);
 					adapter->fdir_active_fltr--;
@@ -1661,6 +1666,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 					 list) {
 			if (fdir->state == IAVF_FDIR_FLTR_DEL_PENDING) {
 				if (del_fltr->status == VIRTCHNL_FDIR_SUCCESS) {
+					dev_info(&adapter->pdev->dev, "Flow Director filter with location %u is deleted\n",
+						 fdir->loc);
 					list_del(&fdir->list);
 					kfree(fdir);
 					adapter->fdir_active_fltr--;
@@ -1668,6 +1675,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 					fdir->state = IAVF_FDIR_FLTR_ACTIVE;
 					dev_info(&adapter->pdev->dev, "Failed to delete Flow Director filter with status: %d\n",
 						 del_fltr->status);
+					iavf_print_fdir_fltr(adapter, fdir);
 				}
 			}
 		}
-- 
2.26.2

