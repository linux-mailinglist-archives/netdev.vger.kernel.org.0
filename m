Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA47A31604C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhBJHrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:47:41 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13336 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhBJHpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:45:40 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBZ03j22z7jR4;
        Wed, 10 Feb 2021 15:42:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 13/13] net: hns3: refactor out hclge_rm_vport_all_mac_table()
Date:   Wed, 10 Feb 2021 15:43:25 +0800
Message-ID: <1612943005-59416-14-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
References: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
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
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 67 ++++++++++++++--------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9156c00..28d90dc 100644
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
2.7.4

