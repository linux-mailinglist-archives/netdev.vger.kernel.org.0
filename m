Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16E13198C0
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBLDZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:25:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12534 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhBLDZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:25:08 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJhs5JmDzMXGy;
        Fri, 12 Feb 2021 11:22:37 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:24:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 13/13] net: hns3: refactor out hclge_rm_vport_all_mac_table()
Date:   Fri, 12 Feb 2021 11:24:17 +0800
Message-ID: <20210212032417.13076-5-tanhuazhong@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

hclge_rm_vport_all_mac_table() is bloated, so split it into
separate functions for readability and maintainability.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 67 ++++++++++++-------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 47a7115fdb5d..34b744df6709 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8353,36 +8353,18 @@ static void hclge_sync_mac_table(struct hclge_dev *hdev)
 	}
 }
 
-void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
-				  enum HCLGE_MAC_ADDR_TYPE mac_type)
+static void hclge_build_del_list(struct list_head *list,
+				 bool is_del_list,
+				 struct list_head *tmp_del_list)
 {
-	int (*unsync)(struct hclge_vport *vport, const unsigned char *addr);
 	struct hclge_mac_node *mac_cfg, *tmp;
-	struct hclge_dev *hdev = vport->back;
-	struct list_head tmp_del_list, *list;
-	int ret;
-
-	if (mac_type == HCLGE_MAC_ADDR_UC) {
-		list = &vport->uc_mac_list;
-		unsync = hclge_rm_uc_addr_common;
-	} else {
-		list = &vport->mc_mac_list;
-		unsync = hclge_rm_mc_addr_common;
-	}
-
-	INIT_LIST_HEAD(&tmp_del_list);
-
-	if (!is_del_list)
-		set_bit(vport->vport_id, hdev->vport_config_block);
-
-	spin_lock_bh(&vport->mac_list_lock);
 
 	list_for_each_entry_safe(mac_cfg, tmp, list, node) {
 		switch (mac_cfg->state) {
 		case HCLGE_MAC_TO_DEL:
 		case HCLGE_MAC_ACTIVE:
 			list_del(&mac_cfg->node);
-			list_add_tail(&mac_cfg->node, &tmp_del_list);
+			list_add_tail(&mac_cfg->node, tmp_del_list);
 			break;
 		case HCLGE_MAC_TO_ADD:
 			if (is_del_list) {
@@ -8392,10 +8374,18 @@ void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 			break;
 		}
 	}
+}
 
-	spin_unlock_bh(&vport->mac_list_lock);
+static void hclge_unsync_del_list(struct hclge_vport *vport,
+				  int (*unsync)(struct hclge_vport *vport,
+						const unsigned char *addr),
+				  bool is_del_list,
+				  struct list_head *tmp_del_list)
+{
+	struct hclge_mac_node *mac_cfg, *tmp;
+	int ret;
 
-	list_for_each_entry_safe(mac_cfg, tmp, &tmp_del_list, node) {
+	list_for_each_entry_safe(mac_cfg, tmp, tmp_del_list, node) {
 		ret = unsync(vport, mac_cfg->mac_addr);
 		if (!ret || ret == -ENOENT) {
 			/* clear all mac addr from hardware, but remain these
@@ -8413,6 +8403,35 @@ void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 			mac_cfg->state = HCLGE_MAC_TO_DEL;
 		}
 	}
+}
+
+void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
+				  enum HCLGE_MAC_ADDR_TYPE mac_type)
+{
+	int (*unsync)(struct hclge_vport *vport, const unsigned char *addr);
+	struct hclge_dev *hdev = vport->back;
+	struct list_head tmp_del_list, *list;
+
+	if (mac_type == HCLGE_MAC_ADDR_UC) {
+		list = &vport->uc_mac_list;
+		unsync = hclge_rm_uc_addr_common;
+	} else {
+		list = &vport->mc_mac_list;
+		unsync = hclge_rm_mc_addr_common;
+	}
+
+	INIT_LIST_HEAD(&tmp_del_list);
+
+	if (!is_del_list)
+		set_bit(vport->vport_id, hdev->vport_config_block);
+
+	spin_lock_bh(&vport->mac_list_lock);
+
+	hclge_build_del_list(list, is_del_list, &tmp_del_list);
+
+	spin_unlock_bh(&vport->mac_list_lock);
+
+	hclge_unsync_del_list(vport, unsync, is_del_list, &tmp_del_list);
 
 	spin_lock_bh(&vport->mac_list_lock);
 
-- 
2.25.1

