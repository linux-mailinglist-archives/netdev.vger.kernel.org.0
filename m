Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907B72AA2D5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 07:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgKGGbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 01:31:07 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7419 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbgKGGbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 01:31:06 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CSnSz2Tycz73Mj;
        Sat,  7 Nov 2020 14:30:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 7 Nov 2020 14:30:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/11] net: hns3: add ethtool priv-flag for DIM
Date:   Sat, 7 Nov 2020 14:31:16 +0800
Message-ID: <1604730681-32559-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a control private flag in ethtool for enable/disable
DIM feature.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  7 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 71 ++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f9d4d23..18b3e43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -716,6 +716,11 @@ struct hnae3_roce_private_info {
 #define HNAE3_UPE		(HNAE3_USER_UPE | HNAE3_OVERFLOW_UPE)
 #define HNAE3_MPE		(HNAE3_USER_MPE | HNAE3_OVERFLOW_MPE)
 
+enum hnae3_pflag {
+	HNAE3_PFLAG_DIM_ENABLE,
+	HNAE3_PFLAG_MAX
+};
+
 struct hnae3_handle {
 	struct hnae3_client *client;
 	struct pci_dev *pdev;
@@ -738,6 +743,8 @@ struct hnae3_handle {
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
+
+	unsigned long priv_flags;
 };
 
 #define hnae3_set_field(origin, mask, shift, val) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9e895b9..a567557 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4246,6 +4246,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
+	handle->priv_flags |= BIT(HNAE3_PFLAG_DIM_ENABLE);
 
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 30ffaaf..427b72c 100644
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
@@ -59,6 +64,8 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 	HNS3_TQP_STAT("non_reuse_pg", non_reuse_pg),
 };
 
+#define HNS3_PRIV_FLAGS_LEN ARRAY_SIZE(hns3_priv_flags)
+
 #define HNS3_RXQ_STATS_COUNT ARRAY_SIZE(hns3_rxq_stats)
 
 #define HNS3_TQP_STATS_COUNT (HNS3_TXQ_STATS_COUNT + HNS3_RXQ_STATS_COUNT)
@@ -394,6 +401,26 @@ static void hns3_self_test(struct net_device *ndev,
 	netif_dbg(h, drv, ndev, "self test end\n");
 }
 
+static void hns3_update_state(struct net_device *netdev,
+			      enum hns3_nic_state state, bool enable)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+
+	if (enable)
+		set_bit(state, &priv->state);
+	else
+		clear_bit(state, &priv->state);
+}
+
+static void hns3_update_dim_state(struct net_device *netdev, bool enable)
+{
+	hns3_update_state(netdev, HNS3_NIC_STATE_DIM_ENABLE, enable);
+}
+
+static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
+	{ "dim_enable",		hns3_update_dim_state },
+};
+
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
@@ -410,6 +437,9 @@ static int hns3_get_sset_count(struct net_device *netdev, int stringset)
 	case ETH_SS_TEST:
 		return ops->get_sset_count(h, stringset);
 
+	case ETH_SS_PRIV_FLAGS:
+		return HNAE3_PFLAG_MAX;
+
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -463,6 +493,7 @@ static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
 	char *buff = (char *)data;
+	int i;
 
 	if (!ops->get_strings)
 		return;
@@ -475,6 +506,13 @@ static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
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
@@ -1516,6 +1554,35 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 	return ops->get_module_eeprom(handle, ee->offset, ee->len, data);
 }
 
+static u32 hns3_get_priv_flags(struct net_device *netdev)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+
+	return handle->priv_flags;
+}
+
+static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	u32 changed = pflags ^ handle->priv_flags;
+	u32 i;
+
+	for (i = 0; i < HNAE3_PFLAG_MAX; i++) {
+		if (changed & BIT(i)) {
+			bool enable = !(handle->priv_flags & BIT(i));
+
+			if (enable)
+				handle->priv_flags |= BIT(i);
+			else
+				handle->priv_flags &= ~BIT(i);
+
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
@@ -1546,6 +1613,8 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.get_link = hns3_get_link,
 	.get_msglevel = hns3_get_msglevel,
 	.set_msglevel = hns3_set_msglevel,
+	.get_priv_flags = hns3_get_priv_flags,
+	.set_priv_flags = hns3_set_priv_flags,
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
@@ -1582,6 +1651,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_fecparam = hns3_set_fecparam,
 	.get_module_info = hns3_get_module_info,
 	.get_module_eeprom = hns3_get_module_eeprom,
+	.get_priv_flags = hns3_get_priv_flags,
+	.set_priv_flags = hns3_set_priv_flags,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
-- 
2.7.4

