Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A26B2970C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391136AbfEXLVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:21:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17562 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391043AbfEXLVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 07:21:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B236FCA74D6C17B030E7;
        Fri, 24 May 2019 19:21:20 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 24 May 2019 19:21:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: add aRFS support for PF
Date:   Fri, 24 May 2019 19:19:47 +0800
Message-ID: <1558696788-12944-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
References: <1558696788-12944-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

This patch adds aRFS support for PF. The aRFS rules are also
stored in the hardware flow director table, Use the existing
filter management functions to insert TCPv4/UDPv4/TCPv6/UDPv6
flow director filters. To avoid rule conflict, once user adds
flow director rules with ethtool, the aRFS will be disabled,
and clear exist aRFS rules. Once all user configure rules were
removed, aRFS can work again.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  31 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 200 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +
 4 files changed, 238 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ad21b0e..a18645e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -343,6 +343,8 @@ struct hnae3_ae_dev {
  *   Enable/disable hardware strip vlan tag of packets received
  * set_gro_en
  *   Enable/disable HW GRO
+ * add_arfs_entry
+ *   Check the 5-tuples of flow, and create flow director rule
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -492,6 +494,8 @@ struct hnae3_ae_ops {
 				struct ethtool_rxnfc *cmd, u32 *rule_locs);
 	int (*restore_fd_rules)(struct hnae3_handle *handle);
 	void (*enable_fd)(struct hnae3_handle *handle, bool enable);
+	int (*add_arfs_entry)(struct hnae3_handle *handle, u16 queue_id,
+			      u16 flow_id, struct flow_keys *fkeys);
 	int (*dbg_run_cmd)(struct hnae3_handle *handle, char *cmd_buf);
 	pci_ers_result_t (*handle_hw_ras_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b2be424..5e12705 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1743,6 +1743,32 @@ static void hns3_nic_net_timeout(struct net_device *ndev)
 		h->ae_algo->ops->reset_event(h->pdev, h);
 }
 
+#ifdef CONFIG_RFS_ACCEL
+static int hns3_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
+			      u16 rxq_index, u32 flow_id)
+{
+	struct hnae3_handle *h = hns3_get_handle(dev);
+	struct flow_keys fkeys;
+
+	if (!h->ae_algo->ops->add_arfs_entry)
+		return -EOPNOTSUPP;
+
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
+	if (!skb_flow_dissect_flow_keys(skb, &fkeys, 0))
+		return -EPROTONOSUPPORT;
+
+	if ((fkeys.basic.n_proto != htons(ETH_P_IP) &&
+	     fkeys.basic.n_proto != htons(ETH_P_IPV6)) ||
+	    (fkeys.basic.ip_proto != IPPROTO_TCP &&
+	     fkeys.basic.ip_proto != IPPROTO_UDP))
+		return -EPROTONOSUPPORT;
+
+	return h->ae_algo->ops->add_arfs_entry(h, rxq_index, flow_id, &fkeys);
+}
+#endif
+
 static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_open		= hns3_nic_net_open,
 	.ndo_stop		= hns3_nic_net_stop,
@@ -1758,6 +1784,10 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= hns3_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= hns3_vlan_rx_kill_vid,
 	.ndo_set_vf_vlan	= hns3_ndo_set_vf_vlan,
+#ifdef CONFIG_RFS_ACCEL
+	.ndo_rx_flow_steer	= hns3_rx_flow_steer,
+#endif
+
 };
 
 bool hns3_is_phys_func(struct pci_dev *pdev)
@@ -2849,6 +2879,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 		return ret;
 	}
 
+	skb_record_rx_queue(skb, ring->tqp->tqp_index);
 	*out_skb = skb;
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 58a6a4d..3ef5d09d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -35,6 +35,8 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev);
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle);
 static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 			       u16 *allocated_size, bool is_alloc);
+static void hclge_rfs_filter_expire(struct hclge_dev *hdev);
+static void hclge_clear_arfs_rules(struct hnae3_handle *handle);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -2647,6 +2649,7 @@ static void hclge_service_timer(struct timer_list *t)
 
 	mod_timer(&hdev->service_timer, jiffies + HZ);
 	hdev->hw_stats.stats_timer++;
+	hdev->fd_arfs_expire_timer++;
 	hclge_task_schedule(hdev);
 }
 
@@ -3523,6 +3526,10 @@ static void hclge_service_task(struct work_struct *work)
 	hclge_update_port_info(hdev);
 	hclge_update_link_status(hdev);
 	hclge_update_vport_alive(hdev);
+	if (hdev->fd_arfs_expire_timer >= HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL) {
+		hclge_rfs_filter_expire(hdev);
+		hdev->fd_arfs_expire_timer = 0;
+	}
 	hclge_service_complete(hdev);
 }
 
@@ -5230,6 +5237,11 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	rule->action = action;
 	rule->rule_type = HCLGE_FD_EP_ACTIVE;
 
+	/* to avoid rule conflict, when user configure rule by ethtool,
+	 * we need to clear all arfs rules
+	 */
+	hclge_clear_arfs_rules(handle);
+
 	spin_lock_bh(&hdev->fd_rule_lock);
 	ret = hclge_fd_config_rule(hdev, rule);
 
@@ -5600,6 +5612,191 @@ static int hclge_get_all_rules(struct hnae3_handle *handle,
 	return 0;
 }
 
+static void hclge_fd_get_flow_tuples(const struct flow_keys *fkeys,
+				     struct hclge_fd_rule_tuples *tuples)
+{
+	tuples->ether_proto = be16_to_cpu(fkeys->basic.n_proto);
+	tuples->ip_proto = fkeys->basic.ip_proto;
+	tuples->dst_port = be16_to_cpu(fkeys->ports.dst);
+
+	if (fkeys->basic.n_proto == htons(ETH_P_IP)) {
+		tuples->src_ip[3] = be32_to_cpu(fkeys->addrs.v4addrs.src);
+		tuples->dst_ip[3] = be32_to_cpu(fkeys->addrs.v4addrs.dst);
+	} else {
+		memcpy(tuples->src_ip,
+		       fkeys->addrs.v6addrs.src.in6_u.u6_addr32,
+		       sizeof(tuples->src_ip));
+		memcpy(tuples->dst_ip,
+		       fkeys->addrs.v6addrs.dst.in6_u.u6_addr32,
+		       sizeof(tuples->dst_ip));
+	}
+}
+
+/* traverse all rules, check whether an existed rule has the same tuples */
+static struct hclge_fd_rule *
+hclge_fd_search_flow_keys(struct hclge_dev *hdev,
+			  const struct hclge_fd_rule_tuples *tuples)
+{
+	struct hclge_fd_rule *rule = NULL;
+	struct hlist_node *node;
+
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (!memcmp(tuples, &rule->tuples, sizeof(*tuples)))
+			return rule;
+	}
+
+	return NULL;
+}
+
+static void hclge_fd_build_arfs_rule(const struct hclge_fd_rule_tuples *tuples,
+				     struct hclge_fd_rule *rule)
+{
+	rule->unused_tuple = BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
+			     BIT(INNER_VLAN_TAG_FST) | BIT(INNER_IP_TOS) |
+			     BIT(INNER_SRC_PORT);
+	rule->action = 0;
+	rule->vf_id = 0;
+	rule->rule_type = HCLGE_FD_ARFS_ACTIVE;
+	if (tuples->ether_proto == ETH_P_IP) {
+		if (tuples->ip_proto == IPPROTO_TCP)
+			rule->flow_type = TCP_V4_FLOW;
+		else
+			rule->flow_type = UDP_V4_FLOW;
+	} else {
+		if (tuples->ip_proto == IPPROTO_TCP)
+			rule->flow_type = TCP_V6_FLOW;
+		else
+			rule->flow_type = UDP_V6_FLOW;
+	}
+	memcpy(&rule->tuples, tuples, sizeof(rule->tuples));
+	memset(&rule->tuples_mask, 0xFF, sizeof(rule->tuples_mask));
+}
+
+static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
+				      u16 flow_id, struct flow_keys *fkeys)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_fd_rule_tuples new_tuples;
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_fd_rule *rule;
+	u16 tmp_queue_id;
+	u16 bit_id;
+	int ret;
+
+	if (!hnae3_dev_fd_supported(hdev))
+		return -EOPNOTSUPP;
+
+	memset(&new_tuples, 0, sizeof(new_tuples));
+	hclge_fd_get_flow_tuples(fkeys, &new_tuples);
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+
+	/* when there is already fd rule existed add by user,
+	 * arfs should not work
+	 */
+	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE) {
+		spin_unlock_bh(&hdev->fd_rule_lock);
+
+		return -EOPNOTSUPP;
+	}
+
+	/* check is there flow director filter existed for this flow,
+	 * if not, create a new filter for it;
+	 * if filter exist with different queue id, modify the filter;
+	 * if filter exist with same queue id, do nothing
+	 */
+	rule = hclge_fd_search_flow_keys(hdev, &new_tuples);
+	if (!rule) {
+		bit_id = find_first_zero_bit(hdev->fd_bmap, MAX_FD_FILTER_NUM);
+		if (bit_id >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1]) {
+			spin_unlock_bh(&hdev->fd_rule_lock);
+
+			return -ENOSPC;
+		}
+
+		rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+		if (!rule) {
+			spin_unlock_bh(&hdev->fd_rule_lock);
+
+			return -ENOMEM;
+		}
+
+		set_bit(bit_id, hdev->fd_bmap);
+		rule->location = bit_id;
+		rule->flow_id = flow_id;
+		rule->queue_id = queue_id;
+		hclge_fd_build_arfs_rule(&new_tuples, rule);
+		ret = hclge_fd_config_rule(hdev, rule);
+
+		spin_unlock_bh(&hdev->fd_rule_lock);
+
+		if (ret)
+			return ret;
+
+		return rule->location;
+	}
+
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	if (rule->queue_id == queue_id)
+		return rule->location;
+
+	tmp_queue_id = rule->queue_id;
+	rule->queue_id = queue_id;
+	ret = hclge_config_action(hdev, HCLGE_FD_STAGE_1, rule);
+	if (ret) {
+		rule->queue_id = tmp_queue_id;
+		return ret;
+	}
+
+	return rule->location;
+#endif
+}
+
+static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
+	struct hclge_fd_rule *rule;
+	struct hlist_node *node;
+	HLIST_HEAD(del_list);
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE) {
+		spin_unlock_bh(&hdev->fd_rule_lock);
+		return;
+	}
+	hlist_for_each_entry_safe(rule, node, &hdev->fd_rule_list, rule_node) {
+		if (rps_may_expire_flow(handle->netdev, rule->queue_id,
+					rule->flow_id, rule->location)) {
+			hlist_del_init(&rule->rule_node);
+			hlist_add_head(&rule->rule_node, &del_list);
+			hdev->hclge_fd_rule_num--;
+			clear_bit(rule->location, hdev->fd_bmap);
+		}
+	}
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	hlist_for_each_entry_safe(rule, node, &del_list, rule_node) {
+		hclge_fd_tcam_config(hdev, HCLGE_FD_STAGE_1, true,
+				     rule->location, NULL, false);
+		kfree(rule);
+	}
+#endif
+}
+
+static void hclge_clear_arfs_rules(struct hnae3_handle *handle)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (hdev->fd_active_type == HCLGE_FD_ARFS_ACTIVE)
+		hclge_del_all_fd_entries(handle, true);
+#endif
+}
+
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -5904,6 +6101,8 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 
+	hclge_clear_arfs_rules(handle);
+
 	/* If it is not PF reset, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
 	 */
@@ -8975,6 +9174,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_fd_all_rules = hclge_get_all_rules,
 	.restore_fd_rules = hclge_restore_fd_entries,
 	.enable_fd = hclge_enable_fd,
+	.add_arfs_entry = hclge_add_fd_entry_by_arfs,
 	.dbg_run_cmd = hclge_dbg_run_cmd,
 	.handle_hw_ras_error = hclge_handle_hw_ras_error,
 	.get_hw_reset_stat = hclge_get_hw_reset_stat,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2976bad..c770390 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -580,6 +580,7 @@ static const struct key_info tuple_key_info[] = {
 
 /* assigned by firmware, the real filter number for each pf may be less */
 #define MAX_FD_FILTER_NUM	4096
+#define HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL	5
 
 enum HCLGE_FD_ACTIVE_RULE_TYPE {
 	HCLGE_FD_RULE_NONE,
@@ -639,6 +640,7 @@ struct hclge_fd_rule {
 	u16 vf_id;
 	u16 queue_id;
 	u16 location;
+	u16 flow_id;	/* only used for arfs */
 	enum HCLGE_FD_ACTIVE_RULE_TYPE rule_type;
 };
 
@@ -821,6 +823,7 @@ struct hclge_dev {
 	struct hlist_head fd_rule_list;
 	spinlock_t fd_rule_lock; /* protect fd_rule_list and fd_bmap */
 	u16 hclge_fd_rule_num;
+	u16 fd_arfs_expire_timer;
 	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
-- 
2.7.4

