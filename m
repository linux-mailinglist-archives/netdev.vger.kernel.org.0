Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D0C3E5BBE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbhHJNc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:32:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13262 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbhHJNcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:32:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GkYlj43XKz1CTJm;
        Tue, 10 Aug 2021 21:32:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 21:32:31 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 10 Aug 2021 21:32:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next] net: hns3: add support for triggering reset by ethtool
Date:   Tue, 10 Aug 2021 21:28:48 +0800
Message-ID: <1628602128-15640-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, four reset types are supported for the HNS3 ethernet
driver: IMP reset, global reset, function reset, and FLR. Only
FLR can now be triggered by the user. To restore the device when
an exception occurs, add support for triggering reset by ethtool.

Run the "ethtool --reset DEVNAME mgmt | all | dedicated" to
trigger the IMP | global | function reset manually.

In addition, VF can only trigger function reset.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  5 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 56 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  6 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 4 files changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 27809d68d6ed..b0e696b08b8b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -596,6 +596,11 @@ struct hns3_hw_error_info {
 	const char *msg;
 };
 
+struct hns3_reset_type_map {
+	enum ethtool_reset_flags rst_flags;
+	enum hnae3_reset_type rst_type;
+};
+
 static inline int ring_space(struct hns3_enet_ring *ring)
 {
 	/* This smp_load_acquire() pairs with smp_store_release() in
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..c8f09b07185e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -953,6 +953,60 @@ static int hns3_get_rxnfc(struct net_device *netdev,
 	}
 }
 
+static const struct hns3_reset_type_map hns3_reset_type[] = {
+	{ETH_RESET_MGMT, HNAE3_IMP_RESET},
+	{ETH_RESET_ALL, HNAE3_GLOBAL_RESET},
+	{ETH_RESET_DEDICATED, HNAE3_FUNC_RESET},
+};
+
+static const struct hns3_reset_type_map hns3vf_reset_type[] = {
+	{ETH_RESET_DEDICATED, HNAE3_VF_FUNC_RESET},
+};
+
+static int hns3_set_reset(struct net_device *netdev, u32 *flags)
+{
+	enum hnae3_reset_type rst_type = HNAE3_NONE_RESET;
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
+	const struct hns3_reset_type_map *rst_type_map;
+	u32 i, size;
+
+	if (ops->ae_dev_resetting && ops->ae_dev_resetting(h))
+		return -EBUSY;
+
+	if (!ops->set_default_reset_request || !ops->reset_event)
+		return -EOPNOTSUPP;
+
+	if (h->flags & HNAE3_SUPPORT_VF) {
+		rst_type_map = hns3vf_reset_type;
+		size = ARRAY_SIZE(hns3vf_reset_type);
+	} else {
+		rst_type_map = hns3_reset_type;
+		size = ARRAY_SIZE(hns3_reset_type);
+	}
+
+	for (i = 0; i < size; i++) {
+		if (rst_type_map[i].rst_flags == *flags) {
+			rst_type = rst_type_map[i].rst_type;
+			break;
+		}
+	}
+
+	if (rst_type == HNAE3_NONE_RESET ||
+	    (rst_type == HNAE3_IMP_RESET &&
+	     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2))
+		return -EOPNOTSUPP;
+
+	netdev_info(netdev, "Setting reset type %d\n", rst_type);
+
+	ops->set_default_reset_request(ae_dev, rst_type);
+
+	ops->reset_event(h->pdev, h);
+
+	return 0;
+}
+
 static void hns3_change_all_ring_bd_num(struct hns3_nic_priv *priv,
 					u32 tx_desc_num, u32 rx_desc_num)
 {
@@ -1699,6 +1753,7 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.set_priv_flags = hns3_set_priv_flags,
 	.get_tunable = hns3_get_tunable,
 	.set_tunable = hns3_set_tunable,
+	.reset = hns3_set_reset,
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
@@ -1740,6 +1795,7 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.get_ts_info = hns3_get_ts_info,
 	.get_tunable = hns3_get_tunable,
 	.set_tunable = hns3_set_tunable,
+	.reset = hns3_set_reset,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f15d76ec0068..9fd15287986f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3789,6 +3789,12 @@ static void hclge_do_reset(struct hclge_dev *hdev)
 	}
 
 	switch (hdev->reset_type) {
+	case HNAE3_IMP_RESET:
+		dev_info(&pdev->dev, "IMP reset requested\n");
+		val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
+		hnae3_set_bit(val, HCLGE_TRIGGER_IMP_RESET_B, 1);
+		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, val);
+		break;
 	case HNAE3_GLOBAL_RESET:
 		dev_info(&pdev->dev, "global reset requested\n");
 		val = hclge_read_dev(&hdev->hw, HCLGE_GLOBAL_RESET_REG);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index cc31b12904ad..ada5c68f2851 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -194,6 +194,7 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_IMP_CMDQ_ERR_B	4U
 #define HCLGE_VECTOR0_IMP_RD_POISON_B	5U
 #define HCLGE_VECTOR0_ALL_MSIX_ERR_B	6U
+#define HCLGE_TRIGGER_IMP_RESET_B	7U
 
 #define HCLGE_MAC_DEFAULT_FRAME \
 	(ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN + ETH_DATA_LEN)
-- 
2.8.1

