Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA272CD556
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgLCMTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:19:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9097 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730285AbgLCMTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:19:39 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cmvxp1jCMzLysV;
        Thu,  3 Dec 2020 20:18:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 20:18:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: add priv flags support to switch limit promisc mode
Date:   Thu, 3 Dec 2020 20:18:55 +0800
Message-ID: <1606997936-22166-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the tx unicast promisc is always enabled when promisc
mode on. If tx unicast promisc on, a function will receive all
unicast packet from other functions belong to the same port.
Adds a ethtool private flags to control whether enable tx
unicast promisc. Then the function is able to filter the
unknown unicast packets from other function.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  8 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 87 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  7 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  7 ++
 7 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 1ffe8fa..fb5e884 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -110,6 +110,7 @@ struct hclge_vf_to_pf_msg {
 			u8 en_bc;
 			u8 en_uc;
 			u8 en_mc;
+			u8 en_limit_promisc;
 		};
 		struct {
 			u8 vector_id;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 78b4886..f30d81e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -719,6 +719,11 @@ struct hnae3_roce_private_info {
 #define HNAE3_UPE		(HNAE3_USER_UPE | HNAE3_OVERFLOW_UPE)
 #define HNAE3_MPE		(HNAE3_USER_MPE | HNAE3_OVERFLOW_MPE)
 
+enum hnae3_pflag {
+	HNAE3_PFLAG_LIMIT_PROMISC_ENABLE,
+	HNAE3_PFLAG_MAX
+};
+
 struct hnae3_handle {
 	struct hnae3_client *client;
 	struct pci_dev *pdev;
@@ -741,6 +746,9 @@ struct hnae3_handle {
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
+
+	unsigned long supported_pflags;
+	unsigned long priv_flags;
 };
 
 #define hnae3_set_field(origin, mask, shift, val) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1798c0a..9873fc4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4226,6 +4226,10 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		set_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE,
+			&handle->supported_pflags);
+
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 3cca3c1..34531c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -18,6 +18,11 @@ struct hns3_sfp_type {
 	u8 ext_type;
 };
 
+struct hns3_pflag_desc {
+	char name[ETH_GSTRING_LEN];
+	void (*handler)(struct net_device *netdev, bool enable);
+};
+
 /* tqp related stats */
 #define HNS3_TQP_STAT(_string, _member)	{			\
 	.stats_string = _string,				\
@@ -60,6 +65,8 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 	HNS3_TQP_STAT("non_reuse_pg", non_reuse_pg),
 };
 
+#define HNS3_PRIV_FLAGS_LEN ARRAY_SIZE(hns3_priv_flags)
+
 #define HNS3_RXQ_STATS_COUNT ARRAY_SIZE(hns3_rxq_stats)
 
 #define HNS3_TQP_STATS_COUNT (HNS3_TXQ_STATS_COUNT + HNS3_RXQ_STATS_COUNT)
@@ -395,6 +402,24 @@ static void hns3_self_test(struct net_device *ndev,
 	netif_dbg(h, drv, ndev, "self test end\n");
 }
 
+static void hns3_update_limit_promisc_mode(struct net_device *netdev,
+					   bool enable)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	if (enable)
+		set_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags);
+	else
+		clear_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE,
+			  &handle->priv_flags);
+
+	hns3_request_update_promisc_mode(handle);
+}
+
+static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
+	{ "limit_promisc",	hns3_update_limit_promisc_mode }
+};
+
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -411,6 +436,9 @@ static int hns3_get_sset_count(struct net_device *netdev, int stringset)
 	case ETH_SS_TEST:
 		return ops->get_sset_count(h, stringset);
 
+	case ETH_SS_PRIV_FLAGS:
+		return HNAE3_PFLAG_MAX;
+
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -464,6 +492,7 @@ static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
 	char *buff = (char *)data;
+	int i;
 
 	if (!ops->get_strings)
 		return;
@@ -476,6 +505,13 @@ static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	case ETH_SS_TEST:
 		ops->get_strings(h, stringset, data);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		for (i = 0; i < HNS3_PRIV_FLAGS_LEN; i++) {
+			snprintf(buff, ETH_GSTRING_LEN, "%s",
+				 hns3_priv_flags[i].name);
+			buff += ETH_GSTRING_LEN;
+		}
+		break;
 	default:
 		break;
 	}
@@ -1517,6 +1553,53 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 	return ops->get_module_eeprom(handle, ee->offset, ee->len, data);
 }
 
+static u32 hns3_get_priv_flags(struct net_device *netdev)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	return handle->priv_flags;
+}
+
+static int hns3_check_priv_flags(struct hnae3_handle *h, u32 changed)
+{
+	u32 i;
+
+	for (i = 0; i < HNAE3_PFLAG_MAX; i++)
+		if ((changed & BIT(i)) && !test_bit(i, &h->supported_pflags)) {
+			netdev_err(h->netdev, "%s is unsupported\n",
+				   hns3_priv_flags[i].name);
+			return -EOPNOTSUPP;
+		}
+
+	return 0;
+}
+
+static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	u32 changed = pflags ^ handle->priv_flags;
+	int ret;
+	u32 i;
+
+	ret = hns3_check_priv_flags(handle, changed);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < HNAE3_PFLAG_MAX; i++) {
+		if (changed & BIT(i)) {
+			bool enable = !(handle->priv_flags & BIT(i));
+
+			if (enable)
+				handle->priv_flags |= BIT(i);
+			else
+				handle->priv_flags &= ~BIT(i);
+			hns3_priv_flags[i].handler(netdev, enable);
+		}
+	}
+
+	return 0;
+}
+
 #define HNS3_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_USECS |		\
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
@@ -1547,6 +1630,8 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.get_link = hns3_get_link,
 	.get_msglevel = hns3_get_msglevel,
 	.set_msglevel = hns3_set_msglevel,
+	.get_priv_flags = hns3_get_priv_flags,
+	.set_priv_flags = hns3_set_priv_flags,
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
@@ -1583,6 +1668,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_fecparam = hns3_set_fecparam,
 	.get_module_info = hns3_get_module_info,
 	.get_module_eeprom = hns3_get_module_eeprom,
+	.get_priv_flags = hns3_get_priv_flags,
+	.set_priv_flags = hns3_set_priv_flags,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f4859ad..7d511df 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4829,8 +4829,11 @@ static int hclge_unmap_ring_frm_vector(struct hnae3_handle *handle, int vector,
 static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev, u8 vf_id,
 				      bool en_uc, bool en_mc, bool en_bc)
 {
+	struct hclge_vport *vport = &hdev->vport[vf_id];
+	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_promisc_cfg_cmd *req;
 	struct hclge_desc desc;
+	bool uc_tx_en = en_uc;
 	u8 promisc_cfg = 0;
 	int ret;
 
@@ -4839,10 +4842,13 @@ static int hclge_cmd_set_promisc_mode(struct hclge_dev *hdev, u8 vf_id,
 	req = (struct hclge_promisc_cfg_cmd *)desc.data;
 	req->vf_id = vf_id;
 
+	if (test_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags))
+		uc_tx_en = false;
+
 	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_UC_RX_EN, en_uc ? 1 : 0);
 	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_MC_RX_EN, en_mc ? 1 : 0);
 	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_BC_RX_EN, en_bc ? 1 : 0);
-	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_UC_TX_EN, en_uc ? 1 : 0);
+	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_UC_TX_EN, uc_tx_en ? 1 : 0);
 	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_MC_TX_EN, en_mc ? 1 : 0);
 	hnae3_set_bit(promisc_cfg, HCLGE_PROMISC_BC_TX_EN, en_bc ? 1 : 0);
 	req->extend_promisc = promisc_cfg;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 3ab6db2..aa67c37 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -224,6 +224,7 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *req)
 {
+	struct hnae3_handle *handle = &vport->nic;
 	bool en_bc = req->msg.en_bc ? true : false;
 	bool en_uc = req->msg.en_uc ? true : false;
 	bool en_mc = req->msg.en_mc ? true : false;
@@ -234,6 +235,12 @@ static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 		en_mc = false;
 	}
 
+	if (req->msg.en_limit_promisc)
+		set_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags);
+	else
+		clear_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE,
+			  &handle->priv_flags);
+
 	ret = hclge_set_vport_promisc_mode(vport, en_uc, en_mc, en_bc);
 
 	vport->vf_info.promisc_enable = (en_uc || en_mc) ? 1 : 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5b2f9a5..7c0267b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -14,6 +14,9 @@
 #define HCLGEVF_RESET_MAX_FAIL_CNT	5
 
 static int hclgevf_reset_hdev(struct hclgevf_dev *hdev);
+static void hclgevf_task_schedule(struct hclgevf_dev *hdev,
+				  unsigned long delay);
+
 static struct hnae3_ae_algo ae_algovf;
 
 static struct workqueue_struct *hclgevf_wq;
@@ -1146,6 +1149,7 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 					bool en_uc_pmc, bool en_mc_pmc,
 					bool en_bc_pmc)
 {
+	struct hnae3_handle *handle = &hdev->nic;
 	struct hclge_vf_to_pf_msg send_msg;
 	int ret;
 
@@ -1154,6 +1158,8 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
 	send_msg.en_bc = en_bc_pmc ? 1 : 0;
 	send_msg.en_uc = en_uc_pmc ? 1 : 0;
 	send_msg.en_mc = en_mc_pmc ? 1 : 0;
+	send_msg.en_limit_promisc =
+	test_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags) ? 1 : 0;
 
 	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 	if (ret)
@@ -1180,6 +1186,7 @@ static void hclgevf_request_update_promisc_mode(struct hnae3_handle *handle)
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
 	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
+	hclgevf_task_schedule(hdev, 0);
 }
 
 static void hclgevf_sync_promisc_mode(struct hclgevf_dev *hdev)
-- 
2.7.4

