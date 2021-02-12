Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3B13198BE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhBLDZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:25:17 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhBLDZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:25:04 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DcJjC6Tbzz7jqq;
        Fri, 12 Feb 2021 11:22:55 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:24:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 12/13] net: hns3: refactor out hclgevf_set_rss_tuple()
Date:   Fri, 12 Feb 2021 11:24:16 +0800
Message-ID: <20210212032417.13076-4-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032417.13076-1-tanhuazhong@huawei.com>
References: <20210212032417.13076-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make it more readable and maintainable, split
hclgevf_set_rss_tuple() into two parts.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 47 +++++++++++++------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index c4ac2b9771e8..700e068764c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -873,25 +873,13 @@ static u8 hclgevf_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
 	return hash_sets;
 }
 
-static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
-				 struct ethtool_rxnfc *nfc)
+static int hclgevf_init_rss_tuple_cmd(struct hnae3_handle *handle,
+				      struct ethtool_rxnfc *nfc,
+				      struct hclgevf_rss_input_tuple_cmd *req)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	struct hclgevf_rss_input_tuple_cmd *req;
-	struct hclgevf_desc desc;
 	u8 tuple_sets;
-	int ret;
-
-	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
-		return -EOPNOTSUPP;
-
-	if (nfc->data &
-	    ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3))
-		return -EINVAL;
-
-	req = (struct hclgevf_rss_input_tuple_cmd *)desc.data;
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
 
 	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
 	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
@@ -936,6 +924,35 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
+				 struct ethtool_rxnfc *nfc)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclgevf_rss_input_tuple_cmd *req;
+	struct hclgevf_desc desc;
+	int ret;
+
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
+		return -EOPNOTSUPP;
+
+	if (nfc->data &
+	    ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3))
+		return -EINVAL;
+
+	req = (struct hclgevf_rss_input_tuple_cmd *)desc.data;
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
+
+	ret = hclgevf_init_rss_tuple_cmd(handle, nfc, req);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to init rss tuple cmd, ret = %d\n", ret);
+		return ret;
+	}
+
 	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-- 
2.25.1

