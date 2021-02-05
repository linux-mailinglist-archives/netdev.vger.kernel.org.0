Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0D3106D5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBEIfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:35:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12432 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhBEIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vQ6VX3zjHQ6;
        Fri,  5 Feb 2021 16:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, GuoJia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 3/6] net: hns3: optimize the code when update the tc info
Date:   Fri, 5 Feb 2021 16:32:46 +0800
Message-ID: <1612513969-9278-4-git-send-email-tanhuazhong@huawei.com>
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

From: GuoJia Liao <liaoguojia@huawei.com>

When update the TC info for NIC, there are some differences
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
index 4b89f36..9e0d7e1 100644
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
index a9c67e3..a10a17c 100644
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

