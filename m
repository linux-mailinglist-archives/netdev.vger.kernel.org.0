Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CB332A34D
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382071AbhCBIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:23 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13405 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835934AbhCBG2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:28:15 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL2SCfzjTLq;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 8/9] net: hns3: add support for queue bonding mode of flow director
Date:   Tue, 2 Mar 2021 14:27:54 +0800
Message-ID: <1614666475-13059-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
References: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For device version V3, it supports queue bonding, which can
identify the tuple information of TCP stream, and create flow
director rules automatically, in order to keep the tx and rx
packets are in the same queue pair. The driver set FD_ADD
field of TX BD for TCP SYN packet, and set FD_DEL filed for
TCP FIN or RST packet. The hardware create or remove a fd rule
according to the TX BD, and it also support to age-out a rule
if not hit for a long time.

The queue bonding mode is default to be disabled, and can be
enabled/disabled with ethtool priv-flags command.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   7 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  81 +++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  14 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  13 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   7 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 119 ++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +
 9 files changed, 241 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f2eec5c..9145272 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -466,6 +466,10 @@ struct hnae3_ae_dev {
  *   Check if any cls flower rule exist
  * dbg_read_cmd
  *   Execute debugfs read command.
+ * request_flush_qb_config
+ *   Request to update queue bonding configuration
+ * query_fd_qb_state
+ *   Query whether hw queue bonding enabled
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -647,6 +651,8 @@ struct hnae3_ae_ops {
 	int (*del_cls_flower)(struct hnae3_handle *handle,
 			      struct flow_cls_offload *cls_flower);
 	bool (*cls_flower_active)(struct hnae3_handle *handle);
+	void (*request_flush_qb_config)(struct hnae3_handle *handle);
+	bool (*query_fd_qb_state)(struct hnae3_handle *handle);
 };
 
 struct hnae3_dcb_ops {
@@ -735,6 +741,7 @@ struct hnae3_roce_private_info {
 
 enum hnae3_pflag {
 	HNAE3_PFLAG_LIMIT_PROMISC,
+	HNAE3_PFLAG_FD_QB_ENABLE,
 	HNAE3_PFLAG_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index dd11c57..e97da2a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -243,8 +243,8 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(TX)vlan_tag: %u\n",
 		 le16_to_cpu(tx_desc->tx.outer_vlan_tag));
 	dev_info(dev, "(TX)tv: %u\n", le16_to_cpu(tx_desc->tx.tv));
-	dev_info(dev, "(TX)paylen_ol4cs: %u\n",
-		 le32_to_cpu(tx_desc->tx.paylen_ol4cs));
+	dev_info(dev, "(TX)paylen_fdop_ol4cs: %u\n",
+		 le32_to_cpu(tx_desc->tx.paylen_fdop_ol4cs));
 	dev_info(dev, "(TX)vld_ra_ri: %u\n",
 		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
 	dev_info(dev, "(TX)mss_hw_csum: %u\n", mss_hw_csum);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 44b775e..76dcf82 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1061,6 +1061,73 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 	return 0;
 }
 
+static bool hns3_query_fd_qb_state(struct hnae3_handle *handle)
+{
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!test_bit(HNAE3_PFLAG_FD_QB_ENABLE, &handle->priv_flags))
+		return false;
+
+	if (!ops->query_fd_qb_state)
+		return false;
+
+	return ops->query_fd_qb_state(handle);
+}
+
+/* fd_op is the field of tx bd indicates hw whether to add or delete
+ * a qb rule or do nothing.
+ */
+static u8 hns3_fd_qb_handle(struct hns3_enet_ring *ring, struct sk_buff *skb)
+{
+	struct hnae3_handle *handle = ring->tqp->handle;
+	union l4_hdr_info l4;
+	union l3_hdr_info l3;
+	u8 l4_proto_tmp = 0;
+	__be16 frag_off;
+	u8 ip_version;
+	u8 fd_op = 0;
+
+	if (!hns3_query_fd_qb_state(handle))
+		return 0;
+
+	if (skb->encapsulation) {
+		ip_version = inner_ip_hdr(skb)->version;
+		l3.hdr = skb_inner_network_header(skb);
+		l4.hdr = skb_inner_transport_header(skb);
+	} else {
+		ip_version = ip_hdr(skb)->version;
+		l3.hdr = skb_network_header(skb);
+		l4.hdr = skb_transport_header(skb);
+	}
+
+	if (ip_version == IP_VERSION_IPV6) {
+		unsigned char *exthdr;
+
+		exthdr = l3.hdr + sizeof(*l3.v6);
+		l4_proto_tmp = l3.v6->nexthdr;
+		if (l4.hdr != exthdr)
+			ipv6_skip_exthdr(skb, exthdr - skb->data,
+					 &l4_proto_tmp, &frag_off);
+	} else if (ip_version == IP_VERSION_IPV4) {
+		l4_proto_tmp = l3.v4->protocol;
+	}
+
+	if (l4_proto_tmp != IPPROTO_TCP)
+		return 0;
+
+	ring->fd_qb_tx_sample++;
+	if (l4.tcp->fin || l4.tcp->rst) {
+		hnae3_set_bit(fd_op, HNS3_TXD_FD_DEL_B, 1);
+		ring->fd_qb_tx_sample = 0;
+	} else if (l4.tcp->syn ||
+		   ring->fd_qb_tx_sample >= HNS3_FD_QB_FORCE_CNT_MAX) {
+		hnae3_set_bit(fd_op, HNS3_TXD_FD_ADD_B, 1);
+		ring->fd_qb_tx_sample = 0;
+	}
+
+	return fd_op;
+}
+
 /* check if the hardware is capable of checksum offloading */
 static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
 {
@@ -1080,12 +1147,13 @@ static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
 static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb, struct hns3_desc *desc)
 {
+	u32 paylen_fdop_ol4cs = skb->len;
 	u32 ol_type_vlan_len_msec = 0;
-	u32 paylen_ol4cs = skb->len;
 	u32 type_cs_vlan_tso = 0;
 	u16 mss_hw_csum = 0;
 	u16 inner_vtag = 0;
 	u16 out_vtag = 0;
+	u8 fd_op;
 	int ret;
 
 	ret = hns3_handle_vtags(ring, skb);
@@ -1141,7 +1209,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			return ret;
 		}
 
-		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
+		ret = hns3_set_tso(skb, &paylen_fdop_ol4cs, &mss_hw_csum,
 				   &type_cs_vlan_tso);
 		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
@@ -1152,11 +1220,15 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 	}
 
 out_hw_tx_csum:
+	fd_op = hns3_fd_qb_handle(ring, skb);
+	hnae3_set_field(paylen_fdop_ol4cs, HNS3_TXD_FD_OP_M,
+			HNS3_TXD_FD_OP_S, fd_op);
+
 	/* Set txbd */
 	desc->tx.ol_type_vlan_len_msec =
 		cpu_to_le32(ol_type_vlan_len_msec);
 	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(type_cs_vlan_tso);
-	desc->tx.paylen_ol4cs = cpu_to_le32(paylen_ol4cs);
+	desc->tx.paylen_fdop_ol4cs = cpu_to_le32(paylen_fdop_ol4cs);
 	desc->tx.mss_hw_csum = cpu_to_le16(mss_hw_csum);
 	desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
 	desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
@@ -4282,6 +4354,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
 
+	if (test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps))
+		set_bit(HNAE3_PFLAG_FD_QB_ENABLE, &handle->supported_pflags);
+
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index d069b04..7dddd5c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -171,6 +171,11 @@ enum hns3_nic_state {
 #define HNS3_TXD_DECTTL_S			12
 #define HNS3_TXD_DECTTL_M			(0xf << HNS3_TXD_DECTTL_S)
 
+#define HNS3_TXD_FD_ADD_B			1
+#define HNS3_TXD_FD_DEL_B			0
+#define HNS3_TXD_FD_OP_M			GENMASK(21, 20)
+#define HNS3_TXD_FD_OP_S			20
+
 #define HNS3_TXD_OL4CS_B			22
 
 #define HNS3_TXD_MSS_S				0
@@ -201,6 +206,8 @@ enum hns3_nic_state {
 
 #define HNS3_RING_EN_B				0
 
+#define HNS3_FD_QB_FORCE_CNT_MAX		20
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
@@ -265,7 +272,7 @@ struct __packed hns3_desc {
 			};
 		};
 
-			__le32 paylen_ol4cs;
+			__le32 paylen_fdop_ol4cs;
 			__le16 bdtp_fe_sc_vld_ra_ri;
 			__le16 mss_hw_csum;
 		} tx;
@@ -361,6 +368,9 @@ enum hns3_pkt_ol4type {
 	HNS3_OL4_TYPE_UNKNOWN
 };
 
+#define IP_VERSION_IPV4		0x4
+#define IP_VERSION_IPV6		0x6
+
 struct ring_stats {
 	u64 sw_err_cnt;
 	u64 seg_pkt_cnt;
@@ -423,7 +433,7 @@ struct hns3_enet_ring {
 	void *va; /* first buffer address for current packet */
 
 	u32 flag;          /* ring attribute */
-
+	u32 fd_qb_tx_sample;
 	int pending_buf;
 	struct sk_buff *skb;
 	struct sk_buff *tail_skb;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index adcec4e..f382dfa3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -415,8 +415,19 @@ static void hns3_update_limit_promisc_mode(struct net_device *netdev,
 	hns3_request_update_promisc_mode(handle);
 }
 
+static void hns3_update_fd_qb_state(struct net_device *netdev, bool enable)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	if (!handle->ae_algo->ops->request_flush_qb_config)
+		return;
+
+	handle->ae_algo->ops->request_flush_qb_config(handle);
+}
+
 static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
-	{ "limit_promisc",	hns3_update_limit_promisc_mode }
+	{ "limit_promisc",	hns3_update_limit_promisc_mode },
+	{ "qb_enable",		hns3_update_fd_qb_state },
 };
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 1bd0ddf..a03f901 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -378,6 +378,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_FD_FORWARD_TC_B))
 		set_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_QB_B))
+		set_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 03eca23..0c54d95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -244,6 +244,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_FD_TCAM_OP		= 0x1203,
 	HCLGE_OPC_FD_AD_OP		= 0x1204,
 	HCLGE_OPC_FD_USER_DEF_OP	= 0x1207,
+	HCLGE_OPC_FD_QB_CTRL		= 0x1210,
 
 	/* MDIO command */
 	HCLGE_OPC_MDIO_CONFIG		= 0x1900,
@@ -1076,6 +1077,12 @@ struct hclge_fd_ad_config_cmd {
 	u8 rsv2[8];
 };
 
+struct hclge_fd_qb_cfg_cmd {
+	u8 en;
+	u8 vf_id;
+	u8 rsv[22];
+};
+
 #define HCLGE_FD_USER_DEF_OFT_S		0
 #define HCLGE_FD_USER_DEF_OFT_M		GENMASK(14, 0)
 #define HCLGE_FD_USER_DEF_EN_B		15
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 15998fc..ee5881d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4109,6 +4109,95 @@ static void hclge_update_vport_alive(struct hclge_dev *hdev)
 	}
 }
 
+static int hclge_set_fd_qb(struct hclge_dev *hdev, u8 vf_id, bool enable)
+{
+	struct hclge_fd_qb_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_FD_QB_CTRL, false);
+	req = (struct hclge_fd_qb_cfg_cmd *)desc.data;
+	req->en = enable;
+	req->vf_id = vf_id;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to %s qb config for vport %u, ret = %d.\n",
+			enable ? "enable" : "disable", vf_id, ret);
+	return ret;
+}
+
+static int hclge_sync_pf_qb_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport = &hdev->vport[0];
+	struct hnae3_handle *handle = &vport->nic;
+	bool request_enable = true;
+	int ret;
+
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state))
+		return 0;
+
+	spin_lock_bh(&hdev->fd_rule_lock);
+	if (hdev->fd_active_type == HCLGE_FD_EP_ACTIVE ||
+	    hdev->fd_active_type == HCLGE_FD_TC_FLOWER_ACTIVE ||
+	    !test_bit(HNAE3_PFLAG_FD_QB_ENABLE, &handle->priv_flags))
+		request_enable = false;
+
+	if (request_enable ==
+		test_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state)) {
+		spin_unlock_bh(&hdev->fd_rule_lock);
+		return 0;
+	}
+
+	if (request_enable)
+		hclge_clear_arfs_rules(hdev);
+
+	ret = hclge_set_fd_qb(hdev, vport->vport_id, request_enable);
+	if (!ret) {
+		if (request_enable) {
+			set_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
+			hdev->fd_active_type = HCLGE_FD_QB_ACTIVE;
+		} else {
+			clear_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
+			hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+		}
+	} else {
+		set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+	}
+	spin_unlock_bh(&hdev->fd_rule_lock);
+
+	return ret;
+}
+
+static int hclge_disable_fd_qb_mode(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	int ret;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps) ||
+	    !test_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state))
+		return 0;
+
+	ret = hclge_set_fd_qb(hdev, 0, false);
+	if (ret)
+		return ret;
+
+	clear_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
+
+	return 0;
+}
+
+static void hclge_sync_fd_qb_mode(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps))
+		return;
+
+	hclge_sync_pf_qb_mode(hdev);
+}
+
 static void hclge_periodic_service_task(struct hclge_dev *hdev)
 {
 	unsigned long delta = round_jiffies_relative(HZ);
@@ -4122,6 +4211,7 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 	hclge_update_link_status(hdev);
 	hclge_sync_mac_table(hdev);
 	hclge_sync_promisc_mode(hdev);
+	hclge_sync_fd_qb_mode(hdev);
 	hclge_sync_fd_table(hdev);
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
@@ -5024,10 +5114,29 @@ static void hclge_request_update_promisc_mode(struct hnae3_handle *handle)
 	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
 }
 
+static bool hclge_query_fd_qb_state(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	return test_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
+}
+
+static void hclge_flush_qb_config(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+
+	set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+}
+
 static void hclge_sync_fd_state(struct hclge_dev *hdev)
 {
-	if (hlist_empty(&hdev->fd_rule_list))
+	struct hclge_vport *vport = &hdev->vport[0];
+
+	if (hlist_empty(&hdev->fd_rule_list)) {
 		hdev->fd_active_type = HCLGE_FD_RULE_NONE;
+		set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+	}
 }
 
 static void hclge_update_fd_rule_node(struct hclge_dev *hdev,
@@ -6317,6 +6426,10 @@ static int hclge_add_fd_entry_common(struct hclge_dev *hdev,
 {
 	int ret;
 
+	ret = hclge_disable_fd_qb_mode(hdev);
+	if (ret)
+		return ret;
+
 	spin_lock_bh(&hdev->fd_rule_lock);
 
 	if (hdev->fd_active_type != rule->rule_type &&
@@ -7943,6 +8056,7 @@ int hclge_vport_start(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
 	vport->last_active_jiffies = jiffies;
 
 	if (test_bit(vport->vport_id, hdev->vport_config_block)) {
@@ -9924,6 +10038,7 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 	hclge_restore_vport_vlan_table(vport);
 	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
 	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
+	clear_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
 	hclge_restore_fd_entries(handle);
 }
 
@@ -12371,6 +12486,8 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.put_vector = hclge_put_vector,
 	.set_promisc_mode = hclge_set_promisc_mode,
 	.request_update_promisc_mode = hclge_request_update_promisc_mode,
+	.request_flush_qb_config = hclge_flush_qb_config,
+	.query_fd_qb_state = hclge_query_fd_qb_state,
 	.set_loopback = hclge_set_loopback,
 	.start = hclge_ae_start,
 	.stop = hclge_ae_stop,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2d1f7f8..9b3907a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -226,6 +226,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_FD_TBL_CHANGED,
 	HCLGE_STATE_FD_CLEAR_ALL,
 	HCLGE_STATE_FD_USER_DEF_CHANGED,
+	HCLGE_STATE_HW_QB_ENABLE,
 	HCLGE_STATE_MAX
 };
 
@@ -590,6 +591,7 @@ enum HCLGE_FD_ACTIVE_RULE_TYPE {
 	HCLGE_FD_ARFS_ACTIVE,
 	HCLGE_FD_EP_ACTIVE,
 	HCLGE_FD_TC_FLOWER_ACTIVE,
+	HCLGE_FD_QB_ACTIVE,
 };
 
 enum HCLGE_FD_PACKET_TYPE {
@@ -951,6 +953,7 @@ struct hclge_rss_tuple_cfg {
 enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_ALIVE,
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
+	HCLGE_VPORT_STATE_QB_CHANGE,
 	HCLGE_VPORT_STATE_MAX
 };
 
-- 
2.7.4

