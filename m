Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4766430BE7C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhBBMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:43:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12109 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbhBBMmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:42:07 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk3kpSz162jl;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        GuoJia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: optimize the code when update the tc info
Date:   Tue, 2 Feb 2021 20:39:49 +0800
Message-ID: <1612269593-18691-4-git-send-email-tanhuazhong@huawei.com>
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

From: GuoJia Liao <liaoguojia@huawei.com>

When update the TC info for NIC, there some differences
between PF and VF. Currently, four "vport->vport_id" are
used to distinguish PF or VF. So merge them into one to
improve readability and maintainability of code.

Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c   | 15 ++++++++++-----
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a8aa388..fcf1bca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -55,8 +55,6 @@
 
 #define HCLGE_LINK_STATUS_MS	10
 
-#define HCLGE_VF_VPORT_START_NUM	1
-
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 2bb1dd4..e615ebf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -17,6 +17,8 @@
 
 #define HCLGE_MAX_PF_NUM		8
 
+#define HCLGE_VF_VPORT_START_NUM	1
+
 #define HCLGE_RD_FIRST_STATS_NUM        2
 #define HCLGE_RD_OTHER_STATS_NUM        4
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 216ab1e..906d98e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -640,13 +640,18 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	/* TC configuration is shared by PF/VF in one port, only allow
 	 * one tc for VF for simplicity. VF's vport_id is non zero.
 	 */
-	kinfo->tc_info.num_tc = vport->vport_id ? 1 :
+	if (vport->vport_id) {
+		kinfo->tc_info.num_tc = 1;
+		vport->qs_offset = HNAE3_MAX_TC +
+				   vport->vport_id - HCLGE_VF_VPORT_START_NUM;
+		vport_max_rss_size = hdev->vf_rss_size_max;
+	} else {
+		kinfo->tc_info.num_tc =
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
-	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
-				(vport->vport_id ? (vport->vport_id - 1) : 0);
+		vport->qs_offset = 0;
+		vport_max_rss_size = hdev->pf_rss_size_max;
+	}
 
-	vport_max_rss_size = vport->vport_id ? hdev->vf_rss_size_max :
-				hdev->pf_rss_size_max;
 	max_rss_size = min_t(u16, vport_max_rss_size,
 			     hclge_vport_get_max_rss_size(vport));
 
-- 
2.7.4

