Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DCD279F39
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgI0HQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:16:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730412AbgI0HPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7B6AE5537E4206FB9A06;
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
Subject: [PATCH net-next 04/10] net: hns3: use capability flag to indicate FEC
Date:   Sun, 27 Sep 2020 15:12:42 +0800
Message-ID: <1601190768-50075-5-git-send-email-tanhuazhong@huawei.com>
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

Currently, the revision of the pci device is used to identify
whether FEC is supported, which is not good for maintainability
and compatibility. So use a capability flag to do that.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c      | 6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c  | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e5835ee..7a6a17d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -63,6 +63,7 @@
 #define HNAE3_ROCE_CLIENT_INITED_B		0x5
 #define HNAE3_DEV_SUPPORT_FD_B			0x6
 #define HNAE3_DEV_SUPPORT_GRO_B			0x7
+#define HNAE3_DEV_SUPPORT_FEC_B			0x9
 
 #define HNAE3_DEV_SUPPORT_ROCE_DCB_BITS (BIT(HNAE3_DEV_SUPPORT_DCB_B) |\
 		BIT(HNAE3_DEV_SUPPORT_ROCE_B))
@@ -79,6 +80,9 @@
 #define hnae3_dev_gro_supported(hdev) \
 	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B)
 
+#define hnae3_dev_fec_supported(hdev) \
+	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B)
+
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
 #define ring_ptr_move_bw(ring, p) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 96b4d97..c57ec5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1363,11 +1363,12 @@ static int hns3_get_fecparam(struct net_device *netdev,
 			     struct ethtool_fecparam *fec)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	u8 fec_ability;
 	u8 fec_mode;
 
-	if (handle->pdev->revision == 0x20)
+	if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B))
 		return -EOPNOTSUPP;
 
 	if (!ops->get_fec)
@@ -1385,10 +1386,11 @@ static int hns3_set_fecparam(struct net_device *netdev,
 			     struct ethtool_fecparam *fec)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	u32 fec_mode;
 
-	if (handle->pdev->revision == 0x20)
+	if (!hnae3_get_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B))
 		return -EOPNOTSUPP;
 
 	if (!ops->set_fec)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 9f6b1a6..127f693 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -355,6 +355,7 @@ hclge_cmd_query_version_and_capability(struct hclge_dev *hdev)
 	    ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
 		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FEC_B, 1);
 	}
 
 	return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cc6d347..871632a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1157,7 +1157,7 @@ static void hclge_parse_fiber_link_mode(struct hclge_dev *hdev,
 	hclge_convert_setting_sr(mac, speed_ability);
 	hclge_convert_setting_lr(mac, speed_ability);
 	hclge_convert_setting_cr(mac, speed_ability);
-	if (hdev->pdev->revision >= 0x21)
+	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, mac->supported);
@@ -1171,7 +1171,7 @@ static void hclge_parse_backplane_link_mode(struct hclge_dev *hdev,
 	struct hclge_mac *mac = &hdev->hw.mac;
 
 	hclge_convert_setting_kr(mac, speed_ability);
-	if (hdev->pdev->revision >= 0x21)
+	if (hnae3_dev_fec_supported(hdev))
 		hclge_convert_setting_fec(mac);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Backplane_BIT, mac->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, mac->supported);
-- 
2.7.4

