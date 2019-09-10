Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6AAE63D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfIJJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:01:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55626 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728341AbfIJJBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 05:01:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A38FE77727358FEB736F;
        Tue, 10 Sep 2019 17:01:07 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 10 Sep 2019 17:00:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: add ethtool_ops.set_channels support for HNS3 VF driver
Date:   Tue, 10 Sep 2019 16:58:22 +0800
Message-ID: <1568105908-60983-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
References: <1568105908-60983-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

This patch adds ethtool_ops.set_channels support for HNS3 VF driver,
and updates related TQP information and RSS information, to support
modification of VF TQP number, and uses current rss_size instead of
max_rss_size to initialize RSS.

Also, fixes a format error in hclgevf_get_rss().

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 87 ++++++++++++++++++++--
 2 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index aa692b1..f5a681d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1397,6 +1397,7 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.set_rxfh = hns3_set_rss,
 	.get_link_ksettings = hns3_get_link_ksettings,
 	.get_channels = hns3_get_channels,
+	.set_channels = hns3_set_channels,
 	.get_coalesce = hns3_get_coalesce,
 	.set_coalesce = hns3_set_coalesce,
 	.get_regs_len = hns3_get_regs_len,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 594cae8..d77dcc2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -743,7 +743,7 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 }
 
 static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
-			   const  u8 *key, const  u8 hfunc)
+			   const u8 *key, const u8 hfunc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
@@ -2060,9 +2060,10 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
 static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	int i, ret;
+	int ret;
+	u32 i;
 
-	rss_cfg->rss_size = hdev->rss_size_max;
+	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
 
 	if (hdev->pdev->revision >= 0x21) {
 		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
@@ -2099,13 +2100,13 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 
 	/* Initialize RSS indirect table */
 	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
-		rss_cfg->rss_indirection_tbl[i] = i % hdev->rss_size_max;
+		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
 
 	ret = hclgevf_set_rss_indir_table(hdev);
 	if (ret)
 		return ret;
 
-	return hclgevf_set_rss_tc_mode(hdev, hdev->rss_size_max);
+	return hclgevf_set_rss_tc_mode(hdev, rss_cfg->rss_size);
 }
 
 static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
@@ -2835,6 +2836,81 @@ static void hclgevf_get_tqps_and_rss_info(struct hnae3_handle *handle,
 	*max_rss_size = hdev->rss_size_max;
 }
 
+static void hclgevf_update_rss_size(struct hnae3_handle *handle,
+				    u32 new_tqps_num)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	u16 max_rss_size;
+
+	kinfo->req_rss_size = new_tqps_num;
+
+	max_rss_size = min_t(u16, hdev->rss_size_max,
+			     hdev->num_tqps / kinfo->num_tc);
+
+	/* Set to user value, no larger than max_rss_size. */
+	if (kinfo->req_rss_size != kinfo->rss_size && kinfo->req_rss_size &&
+	    kinfo->req_rss_size <= max_rss_size) {
+		dev_info(&hdev->pdev->dev, "rss changes from %u to %u\n",
+			 kinfo->rss_size, kinfo->req_rss_size);
+		kinfo->rss_size = kinfo->req_rss_size;
+	} else if (kinfo->rss_size > max_rss_size ||
+		   (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size)) {
+		/* Set to the maximum specification value (max_rss_size). */
+		dev_info(&hdev->pdev->dev, "rss changes from %u to %u\n",
+			 kinfo->rss_size, max_rss_size);
+		kinfo->rss_size = max_rss_size;
+	}
+
+	kinfo->num_tqps = kinfo->num_tc * kinfo->rss_size;
+}
+
+static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
+				bool rxfh_configured)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	u16 cur_rss_size = kinfo->rss_size;
+	u16 cur_tqps = kinfo->num_tqps;
+	u32 *rss_indir;
+	unsigned int i;
+	int ret;
+
+	hclgevf_update_rss_size(handle, new_tqps_num);
+
+	ret = hclgevf_set_rss_tc_mode(hdev, kinfo->rss_size);
+	if (ret)
+		return ret;
+
+	/* RSS indirection table has been configuared by user */
+	if (rxfh_configured)
+		goto out;
+
+	/* Reinitializes the rss indirect table according to the new RSS size */
+	rss_indir = kcalloc(HCLGEVF_RSS_IND_TBL_SIZE, sizeof(u32), GFP_KERNEL);
+	if (!rss_indir)
+		return -ENOMEM;
+
+	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+		rss_indir[i] = i % kinfo->rss_size;
+
+	ret = hclgevf_set_rss(handle, rss_indir, NULL, 0);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "set rss indir table fail, ret=%d\n",
+			ret);
+
+	kfree(rss_indir);
+
+out:
+	if (!ret)
+		dev_info(&hdev->pdev->dev,
+			 "Channels changed, rss_size from %u to %u, tqps from %u to %u",
+			 cur_rss_size, kinfo->rss_size,
+			 cur_tqps, kinfo->rss_size * kinfo->num_tc);
+
+	return ret;
+}
+
 static int hclgevf_get_status(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
@@ -3042,6 +3118,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.enable_hw_strip_rxvtag = hclgevf_en_hw_strip_rxvtag,
 	.reset_event = hclgevf_reset_event,
 	.set_default_reset_request = hclgevf_set_def_reset_request,
+	.set_channels = hclgevf_set_channels,
 	.get_channels = hclgevf_get_channels,
 	.get_tqps_and_rss_info = hclgevf_get_tqps_and_rss_info,
 	.get_regs_len = hclgevf_get_regs_len,
-- 
2.7.4

