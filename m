Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F47640C6D3
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbhION5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15423 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhION5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H8hV02DsrzQvgw;
        Wed, 15 Sep 2021 21:52:08 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 1/6] net: hns3: fix change RSS 'hfunc' ineffective issue
Date:   Wed, 15 Sep 2021 21:52:06 +0800
Message-ID: <20210915135211.9129-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

When user change rss 'hfunc' without set rss 'hkey' by ethtool
-X command, the driver will ignore the 'hfunc' for the hkey is
NULL. It's unreasonable. So fix it.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Fixes: 374ad291762a ("net: hns3: Add RSS general configuration support for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 45 ++++++++++------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 52 ++++++++++++-------
 2 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f1e46ba799f9..36c8741445e8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4741,6 +4741,24 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 	return 0;
 }
 
+static int hclge_parse_rss_hfunc(struct hclge_vport *vport, const u8 hfunc,
+				 u8 *hash_algo)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		*hash_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
+		return 0;
+	case ETH_RSS_HASH_XOR:
+		*hash_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
+		return 0;
+	case ETH_RSS_HASH_NO_CHANGE:
+		*hash_algo = vport->rss_algo;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			 const  u8 *key, const  u8 hfunc)
 {
@@ -4750,30 +4768,27 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	u8 hash_algo;
 	int ret, i;
 
+	ret = hclge_parse_rss_hfunc(vport, hfunc, &hash_algo);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "invalid hfunc type %u\n", hfunc);
+		return ret;
+	}
+
 	/* Set the RSS Hash Key if specififed by the user */
 	if (key) {
-		switch (hfunc) {
-		case ETH_RSS_HASH_TOP:
-			hash_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
-			break;
-		case ETH_RSS_HASH_XOR:
-			hash_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
-			break;
-		case ETH_RSS_HASH_NO_CHANGE:
-			hash_algo = vport->rss_algo;
-			break;
-		default:
-			return -EINVAL;
-		}
-
 		ret = hclge_set_rss_algo_key(hdev, hash_algo, key);
 		if (ret)
 			return ret;
 
 		/* Update the shadow RSS key with user specified qids */
 		memcpy(vport->rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
-		vport->rss_algo = hash_algo;
+	} else {
+		ret = hclge_set_rss_algo_key(hdev, hash_algo,
+					     vport->rss_hash_key);
+		if (ret)
+			return ret;
 	}
+	vport->rss_algo = hash_algo;
 
 	/* Update the shadow RSS table with user specified qids */
 	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index a69e892277b3..5fdac8685f95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -816,40 +816,56 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 	return 0;
 }
 
+static int hclgevf_parse_rss_hfunc(struct hclgevf_dev *hdev, const u8 hfunc,
+				   u8 *hash_algo)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		*hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
+		return 0;
+	case ETH_RSS_HASH_XOR:
+		*hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
+		return 0;
+	case ETH_RSS_HASH_NO_CHANGE:
+		*hash_algo = hdev->rss_cfg.hash_algo;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			   const u8 *key, const u8 hfunc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	u8 hash_algo;
 	int ret, i;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		ret = hclgevf_parse_rss_hfunc(hdev, hfunc, &hash_algo);
+		if (ret)
+			return ret;
+
 		/* Set the RSS Hash Key if specififed by the user */
 		if (key) {
-			switch (hfunc) {
-			case ETH_RSS_HASH_TOP:
-				rss_cfg->hash_algo =
-					HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
-				break;
-			case ETH_RSS_HASH_XOR:
-				rss_cfg->hash_algo =
-					HCLGEVF_RSS_HASH_ALGO_SIMPLE;
-				break;
-			case ETH_RSS_HASH_NO_CHANGE:
-				break;
-			default:
-				return -EINVAL;
-			}
-
-			ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->hash_algo,
-						       key);
-			if (ret)
+			ret = hclgevf_set_rss_algo_key(hdev, hash_algo, key);
+			if (ret) {
+				dev_err(&hdev->pdev->dev,
+					"invalid hfunc type %u\n", hfunc);
 				return ret;
+			}
 
 			/* Update the shadow RSS key with user specified qids */
 			memcpy(rss_cfg->rss_hash_key, key,
 			       HCLGEVF_RSS_KEY_SIZE);
+		} else {
+			ret = hclgevf_set_rss_algo_key(hdev, hash_algo,
+						       rss_cfg->rss_hash_key);
+			if (ret)
+				return ret;
 		}
+		rss_cfg->hash_algo = hash_algo;
 	}
 
 	/* update the shadow RSS table with user specified qids */
-- 
2.33.0

