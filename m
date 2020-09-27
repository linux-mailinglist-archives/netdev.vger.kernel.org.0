Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B08279F3B
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgI0HQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:16:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14245 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730350AbgI0HPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 71C10995B5E124CD4260;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/10] net: hns3: use capabilities queried from firmware
Date:   Sun, 27 Sep 2020 15:12:43 +0800
Message-ID: <1601190768-50075-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

In order to improve code maintainability and compatibility, the
capabilities of new features are queried from firmware.

The member flag in struct hnae3_ae_dev indicates not only
capabilities, but some initialized status. As capabilities bits
queried from firmware is too many, it is better to use new member
to indicate them. So adds member capabs in struce hnae3_ae_dev.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        | 61 +++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 37 ++++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 14 +++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 34 ++++++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 14 +++++
 6 files changed, 145 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 7a6a17d..32f0cce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -61,9 +61,6 @@
 #define HNAE3_KNIC_CLIENT_INITED_B		0x3
 #define HNAE3_UNIC_CLIENT_INITED_B		0x4
 #define HNAE3_ROCE_CLIENT_INITED_B		0x5
-#define HNAE3_DEV_SUPPORT_FD_B			0x6
-#define HNAE3_DEV_SUPPORT_GRO_B			0x7
-#define HNAE3_DEV_SUPPORT_FEC_B			0x9
 
 #define HNAE3_DEV_SUPPORT_ROCE_DCB_BITS (BIT(HNAE3_DEV_SUPPORT_DCB_B) |\
 		BIT(HNAE3_DEV_SUPPORT_ROCE_B))
@@ -74,14 +71,64 @@
 #define hnae3_dev_dcb_supported(hdev) \
 	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_DCB_B)
 
+enum HNAE3_DEV_CAP_BITS {
+	HNAE3_DEV_SUPPORT_FD_B,
+	HNAE3_DEV_SUPPORT_GRO_B,
+	HNAE3_DEV_SUPPORT_FEC_B,
+	HNAE3_DEV_SUPPORT_UDP_GSO_B,
+	HNAE3_DEV_SUPPORT_QB_B,
+	HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B,
+	HNAE3_DEV_SUPPORT_PTP_B,
+	HNAE3_DEV_SUPPORT_INT_QL_B,
+	HNAE3_DEV_SUPPORT_SIMPLE_BD_B,
+	HNAE3_DEV_SUPPORT_TX_PUSH_B,
+	HNAE3_DEV_SUPPORT_PHY_IMP_B,
+	HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B,
+	HNAE3_DEV_SUPPORT_HW_PAD_B,
+	HNAE3_DEV_SUPPORT_STASH_B,
+};
+
 #define hnae3_dev_fd_supported(hdev) \
-	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B)
+	test_bit(HNAE3_DEV_SUPPORT_FD_B, (hdev)->ae_dev->caps)
 
 #define hnae3_dev_gro_supported(hdev) \
-	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B)
+	test_bit(HNAE3_DEV_SUPPORT_GRO_B, (hdev)->ae_dev->caps)
 
 #define hnae3_dev_fec_supported(hdev) \
-	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B)
+	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_udp_gso_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_qb_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_QB_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_fd_forward_tc_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_ptp_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_PTP_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_int_ql_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_simple_bd_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_SIMPLE_BD_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_tx_push_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_phy_imp_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_tqp_txrx_indep_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_hw_pad_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_HW_PAD_B, (hdev)->ae_dev->caps)
+
+#define hnae3_dev_stash_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_STASH_B, (hdev)->ae_dev->caps)
 
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
@@ -240,6 +287,7 @@ struct hnae3_client {
 	struct list_head node;
 };
 
+#define HNAE3_DEV_CAPS_MAX_NUM	96
 struct hnae3_ae_dev {
 	struct pci_dev *pdev;
 	const struct hnae3_ae_ops *ops;
@@ -247,6 +295,7 @@ struct hnae3_ae_dev {
 	u32 flag;
 	unsigned long hw_err_reset_req;
 	u32 dev_version;
+	unsigned long caps[BITS_TO_LONGS(HNAE3_DEV_CAPS_MAX_NUM)];
 	void *priv;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c57ec5e..bf3504d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1368,7 +1368,7 @@ static int hns3_get_fecparam(struct net_device *netdev,
 	u8 fec_ability;
 	u8 fec_mode;
 
-	if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B))
+	if (!test_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps))
 		return -EOPNOTSUPP;
 
 	if (!ops->get_fec)
@@ -1390,7 +1390,7 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	u32 fec_mode;
 
-	if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B))
+	if (!test_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps))
 		return -EOPNOTSUPP;
 
 	if (!ops->set_fec)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 127f693..e6321dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -330,6 +330,33 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	return retval;
 }
 
+static void hclge_set_default_capability(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
+	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
+	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
+	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+}
+
+static void hclge_parse_capability(struct hclge_dev *hdev,
+				   struct hclge_query_version_cmd *cmd)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	u32 caps;
+
+	caps = __le32_to_cpu(cmd->caps[0]);
+
+	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_GSO_B))
+		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_PTP_B))
+		set_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_INT_QL_B))
+		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_TQP_TXRX_INDEP_B))
+		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
+}
+
 static enum hclge_cmd_status
 hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 {
@@ -351,12 +378,10 @@ hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 					 HNAE3_PCI_REVISION_BIT_SIZE;
 	ae_dev->dev_version |= hdev->pdev->revision;
 
-	if (!resp->caps[0] &&
-	    ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B, 1);
-	}
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+		hclge_set_default_capability(hdev);
+
+	hclge_parse_capability(hdev, resp);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 1252e88..3489c75 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -362,6 +362,20 @@ struct hclge_rx_priv_buff_cmd {
 	u8 rsv[6];
 };
 
+enum HCLGE_CAP_BITS {
+	HCLGE_CAP_UDP_GSO_B,
+	HCLGE_CAP_QB_B,
+	HCLGE_CAP_FD_FORWARD_TC_B,
+	HCLGE_CAP_PTP_B,
+	HCLGE_CAP_INT_QL_B,
+	HCLGE_CAP_SIMPLE_BD_B,
+	HCLGE_CAP_TX_PUSH_B,
+	HCLGE_CAP_PHY_IMP_B,
+	HCLGE_CAP_TQP_TXRX_INDEP_B,
+	HCLGE_CAP_HW_PAD_B,
+	HCLGE_CAP_STASH_B,
+};
+
 #define HCLGE_QUERY_CAP_LENGTH		3
 struct hclge_query_version_cmd {
 	__le32 firmware;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 3a1f7b5..66866c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -313,6 +313,31 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 	return status;
 }
 
+static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+
+	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
+	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
+	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
+}
+
+static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
+				     struct hclgevf_query_version_cmd *cmd)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	u32 caps;
+
+	caps = __le32_to_cpu(cmd->caps[0]);
+
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_GSO_B))
+		set_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_INT_QL_B))
+		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_TQP_TXRX_INDEP_B))
+		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
+}
+
 static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -333,11 +358,10 @@ static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 				 HNAE3_PCI_REVISION_BIT_SIZE;
 	ae_dev->dev_version |= hdev->pdev->revision;
 
-	if (!resp->caps[0] &&
-	    ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
-		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
-	}
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+		hclgevf_set_default_capability(hdev);
+
+	hclgevf_parse_capability(hdev, resp);
 
 	return status;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 52e7651..326f3cb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -141,6 +141,20 @@ struct hclgevf_ctrl_vector_chain {
 	u8 resv;
 };
 
+enum HCLGEVF_CAP_BITS {
+	HCLGEVF_CAP_UDP_GSO_B,
+	HCLGEVF_CAP_QB_B,
+	HCLGEVF_CAP_FD_FORWARD_TC_B,
+	HCLGEVF_CAP_PTP_B,
+	HCLGEVF_CAP_INT_QL_B,
+	HCLGEVF_CAP_SIMPLE_BD_B,
+	HCLGEVF_CAP_TX_PUSH_B,
+	HCLGEVF_CAP_PHY_IMP_B,
+	HCLGEVF_CAP_TQP_TXRX_INDEP_B,
+	HCLGEVF_CAP_HW_PAD_B,
+	HCLGEVF_CAP_STASH_B,
+};
+
 #define HCLGEVF_QUERY_CAP_LENGTH		3
 struct hclgevf_query_version_cmd {
 	__le32 firmware;
-- 
2.7.4

