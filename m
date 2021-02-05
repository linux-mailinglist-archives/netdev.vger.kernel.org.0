Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530503106CF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhBEIfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:35:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12433 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhBEIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vQ5zTHzjHHj;
        Fri,  5 Feb 2021 16:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 4/6] net: hns3: add support for obtaining the maximum frame size
Date:   Fri, 5 Feb 2021 16:32:47 +0800
Message-ID: <1612513969-9278-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
References: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Since the newer hardware may supports different frame size,
so add support to obtain the capability from the firmware
instead of the fixed value.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c        | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h           | 5 ++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h    | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h  | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 ++
 9 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ba94b3c..ed41414 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -284,6 +284,7 @@ struct hnae3_dev_specs {
 	u16 int_ql_max; /* max value of interrupt coalesce based on INT_QL */
 	u16 max_int_gl; /* max value of interrupt coalesce based on INT_GL */
 	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
+	u16 max_frm_size;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index c595875..4f7922a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -389,6 +389,7 @@ static void hns3_dbg_dev_specs(struct hnae3_handle *h)
 		 kinfo->tc_info.num_tc);
 	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
 	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
+	dev_info(priv->dev, "MAX frame size: %u\n", dev_specs->max_frm_size);
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f39f5b1..cf16d5f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4281,8 +4281,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	hns3_dbg_init(handle);
 
-	/* MTU range: (ETH_MIN_MTU(kernel default) - 9702) */
-	netdev->max_mtu = HNS3_MAX_MTU;
+	netdev->max_mtu = HNS3_MAX_MTU(ae_dev->dev_specs.max_frm_size);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 0a7b606..d70af1d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -56,9 +56,8 @@ enum hns3_nic_state {
 #define HNS3_RING_MIN_PENDING			72
 #define HNS3_RING_BD_MULTIPLE			8
 /* max frame size of mac */
-#define HNS3_MAC_MAX_FRAME			9728
-#define HNS3_MAX_MTU \
-	(HNS3_MAC_MAX_FRAME - (ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN))
+#define HNS3_MAX_MTU(max_frm_size) \
+	((max_frm_size) - (ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN))
 
 #define HNS3_BD_SIZE_512_TYPE			0
 #define HNS3_BD_SIZE_1024_TYPE			1
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 9ceb059..2ad05d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1131,7 +1131,8 @@ struct hclge_dev_specs_0_cmd {
 #define HCLGE_DEF_MAX_INT_GL		0x1FE0U
 
 struct hclge_dev_specs_1_cmd {
-	__le32 rsv0;
+	__le16 max_frm_size;
+	__le16 rsv0;
 	__le16 max_int_gl;
 	u8 rsv1[18];
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9e0d7e1..1e1b9eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1371,6 +1371,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
+	ae_dev->dev_specs.max_frm_size = HCLGE_MAC_MAX_FRAME;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1390,6 +1391,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
+	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
@@ -1406,6 +1408,8 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	if (!dev_specs->max_int_gl)
 		dev_specs->max_int_gl = HCLGE_DEF_MAX_INT_GL;
+	if (!dev_specs->max_frm_size)
+		dev_specs->max_frm_size = HCLGE_MAC_MAX_FRAME;
 }
 
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
@@ -9673,7 +9677,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
 	/* HW supprt 2 layer vlan */
 	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
-	    max_frm_size > HCLGE_MAC_MAX_FRAME)
+	    max_frm_size > hdev->ae_dev->dev_specs.max_frm_size)
 		return -EINVAL;
 
 	max_frm_size = max(max_frm_size, HCLGE_MAC_DEFAULT_FRAME);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index d591b33..ac2864a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -296,7 +296,8 @@ struct hclgevf_dev_specs_0_cmd {
 #define HCLGEVF_DEF_MAX_INT_GL		0x1FE0U
 
 struct hclgevf_dev_specs_1_cmd {
-	__le32 rsv0;
+	__le16 max_frm_size;
+	__le16 rsv0;
 	__le16 max_int_gl;
 	u8 rsv1[18];
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1bc86be..cdb1131 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3058,6 +3058,7 @@ static void hclgevf_set_default_dev_specs(struct hclgevf_dev *hdev)
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
 	ae_dev->dev_specs.rss_key_size = HCLGEVF_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
+	ae_dev->dev_specs.max_frm_size = HCLGEVF_MAC_MAX_FRAME;
 }
 
 static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
@@ -3076,6 +3077,7 @@ static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
 	ae_dev->dev_specs.int_ql_max = le16_to_cpu(req0->int_ql_max);
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
+	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
 }
 
 static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
@@ -3090,6 +3092,8 @@ static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
 		dev_specs->rss_key_size = HCLGEVF_RSS_KEY_SIZE;
 	if (!dev_specs->max_int_gl)
 		dev_specs->max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
+	if (!dev_specs->max_frm_size)
+		dev_specs->max_frm_size = HCLGEVF_MAC_MAX_FRAME;
 }
 
 static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 6147bd7..8c27ecd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -124,6 +124,8 @@
 #define HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
 	(HCLGEVF_D_IP_BIT | HCLGEVF_S_IP_BIT | HCLGEVF_V_TAG_BIT)
 
+#define HCLGEVF_MAC_MAX_FRAME		9728
+
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
 
 enum hclgevf_evt_cause {
-- 
2.7.4

