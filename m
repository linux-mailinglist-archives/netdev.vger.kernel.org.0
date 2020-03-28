Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0F196412
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgC1HK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:10:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35080 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgC1HK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 03:10:58 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 80EF058DE3AC0FEF6455;
        Sat, 28 Mar 2020 15:10:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Mar 2020 15:10:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/4] net: hns3: fix RSS config lost after VF reset.
Date:   Sat, 28 Mar 2020 15:09:57 +0800
Message-ID: <1585379398-36224-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
References: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

Currently, VF's RSS configuration would be set to default
after VF reset, the the user's one will loss.

To fix it, this patch separates hclgevf_rss_init_hw() into
two parts, one sets up the default RSS configuration and
just be called when driver loading, one configures the hardware
and be called by driver loading or reset.

Fixes: d97b30721301 ("net: hns3: Add RSS tuples support for VF")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 52 ++++++++++++----------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3c58f0b..768240f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2124,50 +2124,51 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
 	return ret;
 }
 
-static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
+static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	int ret;
+	struct hclgevf_rss_tuple_cfg *tuple_sets;
 	u32 i;
 
+	rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
 	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
-
+	tuple_sets = &rss_cfg->rss_tuple_sets;
 	if (hdev->pdev->revision >= 0x21) {
 		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
 		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
 		       HCLGEVF_RSS_KEY_SIZE);
 
+		tuple_sets->ipv4_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv4_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv4_sctp_en = HCLGEVF_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv4_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv6_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv6_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv6_sctp_en = HCLGEVF_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv6_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+	}
+
+	/* Initialize RSS indirect table */
+	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
+}
+
+static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
+{
+	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	int ret;
+
+	if (hdev->pdev->revision >= 0x21) {
 		ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->hash_algo,
 					       rss_cfg->rss_hash_key);
 		if (ret)
 			return ret;
 
-		rss_cfg->rss_tuple_sets.ipv4_tcp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		rss_cfg->rss_tuple_sets.ipv4_udp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		rss_cfg->rss_tuple_sets.ipv4_sctp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_SCTP;
-		rss_cfg->rss_tuple_sets.ipv4_fragment_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		rss_cfg->rss_tuple_sets.ipv6_tcp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		rss_cfg->rss_tuple_sets.ipv6_udp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		rss_cfg->rss_tuple_sets.ipv6_sctp_en =
-					HCLGEVF_RSS_INPUT_TUPLE_SCTP;
-		rss_cfg->rss_tuple_sets.ipv6_fragment_en =
-					HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-
 		ret = hclgevf_set_rss_input_tuple(hdev, rss_cfg);
 		if (ret)
 			return ret;
 	}
 
-	/* Initialize RSS indirect table */
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
-		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
-
 	ret = hclgevf_set_rss_indir_table(hdev);
 	if (ret)
 		return ret;
@@ -2764,6 +2765,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 
 	/* Initialize RSS for this VF */
+	hclgevf_rss_init_cfg(hdev);
 	ret = hclgevf_rss_init_hw(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -2936,6 +2938,8 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
 		rss_indir[i] = i % kinfo->rss_size;
 
+	hdev->rss_cfg.rss_size = kinfo->rss_size;
+
 	ret = hclgevf_set_rss(handle, rss_indir, NULL, 0);
 	if (ret)
 		dev_err(&hdev->pdev->dev, "set rss indir table fail, ret=%d\n",
-- 
2.7.4

