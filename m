Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB8F465FB3
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbhLBIoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:16 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29080 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345788AbhLBIoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:10 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J4Tqb3PwQz1DJrX;
        Thu,  2 Dec 2021 16:38:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 8/9] net: hns3: refactor function hclge_set_channels()
Date:   Thu, 2 Dec 2021 16:36:02 +0800
Message-ID: <20211202083603.25176-9-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently  hclge_set_channels() is a bit long. Refactor it by extracting
sub process to improve the readability.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 46 +++++++++++--------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 996ba57b8155..7d3a4dc793c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12347,19 +12347,42 @@ static void hclge_get_tqps_and_rss_info(struct hnae3_handle *handle,
 	*max_rss_size = hdev->pf_rss_size_max;
 }
 
+static int hclge_set_rss_tc_mode_cfg(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
+	struct hclge_dev *hdev = vport->back;
+	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
+	u16 tc_valid[HCLGE_MAX_TC_NUM];
+	u16 roundup_size;
+	unsigned int i;
+
+	roundup_size = roundup_pow_of_two(vport->nic.kinfo.rss_size);
+	roundup_size = ilog2(roundup_size);
+	/* Set the RSS TC mode according to the new RSS size */
+	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
+		tc_valid[i] = 0;
+
+		if (!(hdev->hw_tc_map & BIT(i)))
+			continue;
+
+		tc_valid[i] = 1;
+		tc_size[i] = roundup_size;
+		tc_offset[i] = vport->nic.kinfo.rss_size * i;
+	}
+
+	return hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+}
+
 static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 			      bool rxfh_configured)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
-	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
 	struct hclge_dev *hdev = vport->back;
-	u16 tc_size[HCLGE_MAX_TC_NUM] = {0};
 	u16 cur_rss_size = kinfo->rss_size;
 	u16 cur_tqps = kinfo->num_tqps;
-	u16 tc_valid[HCLGE_MAX_TC_NUM];
-	u16 roundup_size;
 	u32 *rss_indir;
 	unsigned int i;
 	int ret;
@@ -12372,20 +12395,7 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 		return ret;
 	}
 
-	roundup_size = roundup_pow_of_two(kinfo->rss_size);
-	roundup_size = ilog2(roundup_size);
-	/* Set the RSS TC mode according to the new RSS size */
-	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
-		tc_valid[i] = 0;
-
-		if (!(hdev->hw_tc_map & BIT(i)))
-			continue;
-
-		tc_valid[i] = 1;
-		tc_size[i] = roundup_size;
-		tc_offset[i] = kinfo->rss_size * i;
-	}
-	ret = hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+	ret = hclge_set_rss_tc_mode_cfg(handle);
 	if (ret)
 		return ret;
 
-- 
2.33.0

