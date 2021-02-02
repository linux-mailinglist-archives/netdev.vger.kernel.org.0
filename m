Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669A130BE7B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhBBMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:43:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12108 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhBBMmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:42:07 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk3ybvz162k0;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: add support for obtaining the maximum frame length
Date:   Tue, 2 Feb 2021 20:39:50 +0800
Message-ID: <1612269593-18691-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
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
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f4c8d72..f27504e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -284,6 +284,7 @@ struct hnae3_dev_specs {
 	u16 int_ql_max; /* max value of interrupt coalesce based on INT_QL */
 	u16 max_int_gl; /* max value of interrupt coalesce based on INT_GL */
 	u8 max_non_tso_bd_num; /* max BD number of one non-TSO packet */
+	u16 max_pkt_len;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 9ceb059..0c8ac68 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1131,7 +1131,8 @@ struct hclge_dev_specs_0_cmd {
 #define HCLGE_DEF_MAX_INT_GL		0x1FE0U
 
 struct hclge_dev_specs_1_cmd {
-	__le32 rsv0;
+	__le16 max_pkt_len;
+	__le16 rsv0;
 	__le16 max_int_gl;
 	u8 rsv1[18];
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fcf1bca..dd205c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1371,6 +1371,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
+	ae_dev->dev_specs.max_pkt_len = HCLGE_MAC_MAX_FRAME;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1390,6 +1391,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.rss_key_size = le16_to_cpu(req0->rss_key_size);
 	ae_dev->dev_specs.max_tm_rate = le32_to_cpu(req0->max_tm_rate);
 	ae_dev->dev_specs.max_int_gl = le16_to_cpu(req1->max_int_gl);
+	ae_dev->dev_specs.max_pkt_len = le16_to_cpu(req1->max_pkt_len);
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
@@ -1406,6 +1408,8 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	if (!dev_specs->max_int_gl)
 		dev_specs->max_int_gl = HCLGE_DEF_MAX_INT_GL;
+	if (!dev_specs->max_pkt_len)
+		dev_specs->max_pkt_len = HCLGE_MAC_MAX_FRAME;
 }
 
 static int hclge_query_dev_specs(struct hclge_dev *hdev)
@@ -9659,7 +9663,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
 	/* HW supprt 2 layer vlan */
 	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
-	    max_frm_size > HCLGE_MAC_MAX_FRAME)
+	    max_frm_size > hdev->ae_dev->dev_specs.max_pkt_len)
 		return -EINVAL;
 
 	max_frm_size = max(max_frm_size, HCLGE_MAC_DEFAULT_FRAME);
-- 
2.7.4

