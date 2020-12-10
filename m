Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B71C2D51F4
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbgLJDnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:43:40 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9422 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgLJDn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:43:28 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs08x4tKQz7C9x;
        Thu, 10 Dec 2020 11:42:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 11:42:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: add support for hw tc offload of tc flower
Date:   Thu, 10 Dec 2020 11:42:09 +0800
Message-ID: <1607571732-24219-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Some new device supports forwarding packet to queues of specified
TC when flow director rule hit. So add support to configure flow
director rule by tc flower. To avoid rule conflict, add a new flow
director mode HCLGE_FD_TC_FLOWER_ACTIVE, and only one mode can be
active at the same time.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  11 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  70 ++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 313 ++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  16 +-
 4 files changed, 397 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a7ff9c7..a7daf6d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -459,6 +459,12 @@ struct hnae3_ae_dev {
  *   Configure the default MAC for specified VF
  * get_module_eeprom
  *   Get the optical module eeprom info.
+ * add_cls_flower
+ *   Add clsflower rule
+ * del_cls_flower
+ *   Delete clsflower rule
+ * cls_flower_active
+ *   Check if any cls flower rule exist
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -636,6 +642,11 @@ struct hnae3_ae_ops {
 	int (*get_module_eeprom)(struct hnae3_handle *handle, u32 offset,
 				 u32 len, u8 *data);
 	bool (*get_cmdq_stat)(struct hnae3_handle *handle);
+	int (*add_cls_flower)(struct hnae3_handle *handle,
+			      struct flow_cls_offload *cls_flower, int tc);
+	int (*del_cls_flower)(struct hnae3_handle *handle,
+			      struct flow_cls_offload *cls_flower);
+	bool (*cls_flower_active)(struct hnae3_handle *handle);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d6dd4bc..405e490 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1668,6 +1668,13 @@ static int hns3_nic_set_features(struct net_device *netdev,
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
+	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	    h->ae_algo->ops->cls_flower_active(h)) {
+		netdev_err(netdev,
+			   "there are offloaded TC filters active, cannot disable HW TC offload");
+		return -EINVAL;
+	}
+
 	netdev->features = features;
 	return 0;
 }
@@ -1818,13 +1825,67 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 		kinfo->dcb_ops->setup_tc(h, mqprio_qopt) : -EOPNOTSUPP;
 }
 
+static int hns3_setup_tc_cls_flower(struct hns3_nic_priv *priv,
+				    struct flow_cls_offload *flow)
+{
+	int tc = tc_classid_to_hwtc(priv->netdev, flow->classid);
+	struct hnae3_handle *h = hns3_get_handle(priv->netdev);
+
+	switch (flow->command) {
+	case FLOW_CLS_REPLACE:
+		if (h->ae_algo->ops->add_cls_flower)
+			return h->ae_algo->ops->add_cls_flower(h, flow, tc);
+		break;
+	case FLOW_CLS_DESTROY:
+		if (h->ae_algo->ops->del_cls_flower)
+			return h->ae_algo->ops->del_cls_flower(h, flow);
+		break;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int hns3_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+				  void *cb_priv)
+{
+	struct hns3_nic_priv *priv = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(priv->netdev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return hns3_setup_tc_cls_flower(priv, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(hns3_block_cb_list);
+
 static int hns3_nic_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			     void *type_data)
 {
-	if (type != TC_SETUP_QDISC_MQPRIO)
+	struct hns3_nic_priv *priv = netdev_priv(dev);
+	int ret;
+
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		ret = hns3_setup_tc(dev, type_data);
+		break;
+	case TC_SETUP_BLOCK:
+		ret = flow_block_cb_setup_simple(type_data,
+						 &hns3_block_cb_list,
+						 hns3_setup_tc_block_cb,
+						 priv, priv, true);
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
-	return hns3_setup_tc(dev, type_data);
+	return ret;
 }
 
 static int hns3_vlan_rx_add_vid(struct net_device *netdev,
@@ -2421,6 +2482,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
+
+	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps)) {
+		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev->features |= NETIF_F_HW_TC;
+	}
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0b6102e..455ee6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5376,9 +5376,9 @@ static int hclge_config_action(struct hclge_dev *hdev, u8 stage,
 	} else if (rule->action == HCLGE_FD_ACTION_SELECT_TC) {
 		ad_data.override_tc = true;
 		ad_data.queue_id =
-			kinfo->tc_info.tqp_offset[rule->tc];
+			kinfo->tc_info.tqp_offset[rule->cls_flower.tc];
 		ad_data.tc_size =
-			ilog2(kinfo->tc_info.tqp_count[rule->tc]);
+			ilog2(kinfo->tc_info.tqp_count[rule->cls_flower.tc]);
 	} else {
 		ad_data.forward_to_direct_queue = true;
 		ad_data.queue_id = rule->queue_id;
@@ -5896,6 +5896,14 @@ static int hclge_fd_config_rule(struct hclge_dev *hdev,
 	return ret;
 }
 
+static bool hclge_is_cls_flower_active(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	return hdev->fd_active_type == HCLGE_FD_TC_FLOWER_ACTIVE;
+}
+
 static int hclge_add_fd_entry(struct hnae3_handle *handle,
 			      struct ethtool_rxnfc *cmd)
 {
@@ -5920,6 +5928,12 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 		return -EOPNOTSUPP;
 	}
 
+	if (hclge_is_cls_flower_active(handle)) {
+		dev_err(&hdev->pdev->dev,
+			"please delete all exist cls flower rules first\n");
+		return -EINVAL;
+	}
+
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
 	ret = hclge_fd_check_spec(hdev, fs, &unused);
@@ -6001,7 +6015,8 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		return -EINVAL;
 
-	if (!hclge_fd_rule_exist(hdev, fs->location)) {
+	if (hclge_is_cls_flower_active(handle) || !hdev->hclge_fd_rule_num ||
+	    !hclge_fd_rule_exist(hdev, fs->location)) {
 		dev_err(&hdev->pdev->dev,
 			"Delete fail, rule %u is inexistent\n", fs->location);
 		return -ENOENT;
@@ -6101,7 +6116,7 @@ static int hclge_get_fd_rule_cnt(struct hnae3_handle *handle,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_dev_fd_supported(hdev) || hclge_is_cls_flower_active(handle))
 		return -EOPNOTSUPP;
 
 	cmd->rule_cnt = hdev->hclge_fd_rule_num;
@@ -6444,7 +6459,8 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	 * arfs should not work
 	 */
 	spin_lock_bh(&hdev->fd_rule_lock);
-	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
+	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE ||
+	    hdev->fd_active_type != HCLGE_FD_RULE_NONE) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -EOPNOTSUPP;
 	}
@@ -6472,7 +6488,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 
 		set_bit(bit_id, hdev->fd_bmap);
 		rule->location = bit_id;
-		rule->flow_id = flow_id;
+		rule->arfs.flow_id = flow_id;
 		rule->queue_id = queue_id;
 		hclge_fd_build_arfs_rule(&new_tuples, rule);
 		ret = hclge_fd_config_rule(hdev, rule);
@@ -6516,7 +6532,7 @@ static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
 	}
 	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
 		if (rps_may_expire_flow(handle->netdev, rule->queue_id,
-					rule->flow_id, rule->location)) {
+					rule->arfs.flow_id, rule->location)) {
 			hlist_del_init(&rule->rule_node);
 			hlist_add_head(&rule->rule_node, &del_list);
 			hdev->hclge_fd_rule_num--;
@@ -6545,6 +6561,286 @@ static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
 #endif
 }
 
+static void hclge_get_cls_key_basic(const struct flow_rule *flow,
+				    struct hclge_fd_rule *rule)
+{
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_BASIC)) {
+		struct flow_match_basic match;
+		u16 ethtype_key, ethtype_mask;
+
+		flow_rule_match_basic(flow, &match);
+		ethtype_key = ntohs(match.key->n_proto);
+		ethtype_mask = ntohs(match.mask->n_proto);
+
+		if (ethtype_key == ETH_P_ALL) {
+			ethtype_key = 0;
+			ethtype_mask = 0;
+		}
+		rule->tuples.ether_proto = ethtype_key;
+		rule->tuples_mask.ether_proto = ethtype_mask;
+		rule->tuples.ip_proto = match.key->ip_proto;
+		rule->tuples_mask.ip_proto = match.mask->ip_proto;
+	} else {
+		rule->unused_tuple |= BIT(INNER_IP_PROTO);
+		rule->unused_tuple |= BIT(INNER_ETH_TYPE);
+	}
+}
+
+static void hclge_get_cls_key_mac(const struct flow_rule *flow,
+				  struct hclge_fd_rule *rule)
+{
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(flow, &match);
+		ether_addr_copy(rule->tuples.dst_mac, match.key->dst);
+		ether_addr_copy(rule->tuples_mask.dst_mac, match.mask->dst);
+		ether_addr_copy(rule->tuples.src_mac, match.key->src);
+		ether_addr_copy(rule->tuples_mask.src_mac, match.mask->src);
+	} else {
+		rule->unused_tuple |= BIT(INNER_DST_MAC);
+		rule->unused_tuple |= BIT(INNER_SRC_MAC);
+	}
+}
+
+static void hclge_get_cls_key_vlan(const struct flow_rule *flow,
+				   struct hclge_fd_rule *rule)
+{
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(flow, &match);
+		rule->tuples.vlan_tag1 = match.key->vlan_id |
+				(match.key->vlan_priority << VLAN_PRIO_SHIFT);
+		rule->tuples_mask.vlan_tag1 = match.mask->vlan_id |
+				(match.mask->vlan_priority << VLAN_PRIO_SHIFT);
+	} else {
+		rule->unused_tuple |= BIT(INNER_VLAN_TAG_FST);
+	}
+}
+
+static void hclge_get_cls_key_ip(const struct flow_rule *flow,
+				 struct hclge_fd_rule *rule)
+{
+	u16 addr_type = 0;
+
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(flow, &match);
+		addr_type = match.key->addr_type;
+	}
+
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(flow, &match);
+		rule->tuples.src_ip[IPV4_INDEX] = be32_to_cpu(match.key->src);
+		rule->tuples_mask.src_ip[IPV4_INDEX] =
+						be32_to_cpu(match.mask->src);
+		rule->tuples.dst_ip[IPV4_INDEX] = be32_to_cpu(match.key->dst);
+		rule->tuples_mask.dst_ip[IPV4_INDEX] =
+						be32_to_cpu(match.mask->dst);
+	} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(flow, &match);
+		be32_to_cpu_array(rule->tuples.src_ip, match.key->src.s6_addr32,
+				  IPV6_SIZE);
+		be32_to_cpu_array(rule->tuples_mask.src_ip,
+				  match.mask->src.s6_addr32, IPV6_SIZE);
+		be32_to_cpu_array(rule->tuples.dst_ip, match.key->dst.s6_addr32,
+				  IPV6_SIZE);
+		be32_to_cpu_array(rule->tuples_mask.dst_ip,
+				  match.mask->dst.s6_addr32, IPV6_SIZE);
+	} else {
+		rule->unused_tuple |= BIT(INNER_SRC_IP);
+		rule->unused_tuple |= BIT(INNER_DST_IP);
+	}
+}
+
+static void hclge_get_cls_key_port(const struct flow_rule *flow,
+				   struct hclge_fd_rule *rule)
+{
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(flow, &match);
+
+		rule->tuples.src_port = be16_to_cpu(match.key->src);
+		rule->tuples_mask.src_port = be16_to_cpu(match.mask->src);
+		rule->tuples.dst_port = be16_to_cpu(match.key->dst);
+		rule->tuples_mask.dst_port = be16_to_cpu(match.mask->dst);
+	} else {
+		rule->unused_tuple |= BIT(INNER_SRC_PORT);
+		rule->unused_tuple |= BIT(INNER_DST_PORT);
+	}
+}
+
+static int hclge_parse_cls_flower(struct hclge_dev *hdev,
+				  struct flow_cls_offload *cls_flower,
+				  struct hclge_fd_rule *rule)
+{
+	struct flow_rule *flow = flow_cls_offload_flow_rule(cls_flower);
+	struct flow_dissector *dissector = flow->match.dissector;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS))) {
+		dev_err(&hdev->pdev->dev, "unsupported key set: %#x\n",
+			dissector->used_keys);
+		return -EOPNOTSUPP;
+	}
+
+	hclge_get_cls_key_basic(flow, rule);
+	hclge_get_cls_key_mac(flow, rule);
+	hclge_get_cls_key_vlan(flow, rule);
+	hclge_get_cls_key_ip(flow, rule);
+	hclge_get_cls_key_port(flow, rule);
+
+	return 0;
+}
+
+static int hclge_check_cls_flower(struct hclge_dev *hdev,
+				  struct flow_cls_offload *cls_flower, int tc)
+{
+	u32 prio = cls_flower->common.prio;
+
+	if (tc < 0 || tc > hdev->tc_max) {
+		dev_err(&hdev->pdev->dev, "invalid traffic class\n");
+		return -EINVAL;
+	}
+
+	if (prio == 0 ||
+	    prio > hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]) {
+		dev_err(&hdev->pdev->dev,
+			"prio %u should be in range[1, %u]\n",
+			prio, hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]);
+		return -EINVAL;
+	}
+
+	if (test_bit(prio - 1, hdev->fd_bmap)) {
+		dev_err(&hdev->pdev->dev, "prio %u is already used\n", prio);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int hclge_add_cls_flower(struct hnae3_handle *handle,
+				struct flow_cls_offload *cls_flower,
+				int tc)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_fd_rule *rule;
+	int ret;
+
+	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
+		dev_err(&hdev->pdev->dev,
+			"please remove all exist fd rules via ethtool first\n");
+		return -EINVAL;
+	}
+
+	ret = hclge_check_cls_flower(hdev, cls_flower, tc);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to check cls flower params, ret = %d\n", ret);
+		return ret;
+	}
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	ret = hclge_parse_cls_flower(hdev, cls_flower, rule);
+	if (ret)
+		goto err;
+
+	rule->action = HCLGE_FD_ACTION_SELECT_TC;
+	rule->cls_flower.tc = tc;
+	rule->location = cls_flower->common.prio - 1;
+	rule->vf_id = 0;
+	rule->cls_flower.cookie = cls_flower->cookie;
+	rule->rule_type = HCLGE_FD_TC_FLOWER_ACTIVE;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	hclge_clear_arfs_rules(handle);
+
+	ret = hclge_fd_config_rule(hdev, rule);
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to add cls flower rule, ret = %d\n", ret);
+		goto err;
+	}
+
+	return 0;
+err:
+	kfree(rule);
+	return ret;
+}
+
+static struct hclge_fd_rule *hclge_find_cls_flower(struct hclge_dev *hdev,
+						   unsigned long cookie)
+{
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (rule->cls_flower.cookie == cookie)
+			return rule;
+	}
+
+	return NULL;
+}
+
+static int hclge_del_cls_flower(struct hnae3_handle *handle,
+				struct flow_cls_offload *cls_flower)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_fd_rule *rule;
+	int ret;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+
+	rule = hclge_find_cls_flower(hdev, cls_flower->cookie);
+	if (!rule) {
+		spin_unlock_bh(&hdev->fd_rule_lock);
+		return -EINVAL;
+	}
+
+	ret = hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true, rule->location,
+				   NULL, false);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to delete cls flower rule %u, ret = %d\n",
+			rule->location, ret);
+		spin_unlock_bh(&hdev->fd_rule_lock);
+		return ret;
+	}
+
+	ret = hclge_fd_update_rule_list(hdev, NULL, rule->location, false);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to delete cls flower rule %u in list, ret = %d\n",
+			rule->location, ret);
+		spin_unlock_bh(&hdev->fd_rule_lock);
+		return ret;
+	}
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	return 0;
+}
+
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -11542,6 +11838,9 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_vf_mac = hclge_set_vf_mac,
 	.get_module_eeprom = hclge_get_module_eeprom,
 	.get_cmdq_stat = hclge_get_cmdq_stat,
+	.add_cls_flower = hclge_add_cls_flower,
+	.del_cls_flower = hclge_del_cls_flower,
+	.cls_flower_active = hclge_is_cls_flower_active,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index a481064..008005e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -564,6 +564,7 @@ enum HCLGE_FD_ACTIVE_RULE_TYPE {
 	HCLGE_FD_RULE_NONE,
 	HCLGE_FD_ARFS_ACTIVE,
 	HCLGE_FD_EP_ACTIVE,
+	HCLGE_FD_TC_FLOWER_ACTIVE,
 };
 
 enum HCLGE_FD_PACKET_TYPE {
@@ -619,13 +620,20 @@ struct hclge_fd_rule {
 	struct hclge_fd_rule_tuples tuples_mask;
 	u32 unused_tuple;
 	u32 flow_type;
-	u8 action;
-	u8 tc;
-	u16 vf_id;
+	union {
+		struct {
+			unsigned long cookie;
+			u8 tc;
+		} cls_flower;
+		struct {
+			u16 flow_id; /* only used for arfs */
+		} arfs;
+	};
 	u16 queue_id;
+	u16 vf_id;
 	u16 location;
-	u16 flow_id;	/* only used for arfs */
 	enum HCLGE_FD_ACTIVE_RULE_TYPE rule_type;
+	u8 action;
 };
 
 struct hclge_fd_ad_data {
-- 
2.7.4

