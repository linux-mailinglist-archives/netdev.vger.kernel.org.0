Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E044C263
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhKJNuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:18 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15814 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhKJNuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:15 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hq5kP2ljWz912h;
        Wed, 10 Nov 2021 21:47:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/8] net: hns3: fix failed to add reuse multicast mac addr to hardware when mc mac table is full
Date:   Wed, 10 Nov 2021 21:42:49 +0800
Message-ID: <20211110134256.25025-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when driver is failed to add a new multicast mac address to
hardware due to the multicast mac table is full, it will directly return.
In this case, if the multicast mac list has some reuse addresses after the
new address, those reuse addresses will never be added to hardware.

To fix this problem, if function hclge_add_mc_addr_common() returns
-ENOSPC, hclge_sync_vport_mac_list() should judge whether continue or
stop to add next address.

As function hclge_sync_vport_mac_list() needs parameter mac_type to know
whether is uc or mc, refine this function to add parameter mac_type and
remove parameter sync. So does function hclge_unsync_vport_mac_list().

Fixes: ee4bcd3b7ae4 ("net: hns3: refactor the MAC address configure")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 50 ++++++++++---------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2e41aa2d1df8..eb96bea9e3ce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8949,8 +8949,11 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 
 err_no_space:
 	/* if already overflow, not to print each time */
-	if (!(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE))
+	if (!(vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE)) {
+		vport->overflow_promisc_flags |= HNAE3_OVERFLOW_MPE;
 		dev_err(&hdev->pdev->dev, "mc mac vlan table is full\n");
+	}
+
 	return -ENOSPC;
 }
 
@@ -9006,12 +9009,17 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 
 static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 				      struct list_head *list,
-				      int (*sync)(struct hclge_vport *,
-						  const unsigned char *))
+				      enum HCLGE_MAC_ADDR_TYPE mac_type)
 {
+	int (*sync)(struct hclge_vport *vport, const unsigned char *addr);
 	struct hclge_mac_node *mac_node, *tmp;
 	int ret;
 
+	if (mac_type == HCLGE_MAC_ADDR_UC)
+		sync = hclge_add_uc_addr_common;
+	else
+		sync = hclge_add_mc_addr_common;
+
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		ret = sync(vport, mac_node->mac_addr);
 		if (!ret) {
@@ -9023,8 +9031,13 @@ static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 			/* If one unicast mac address is existing in hardware,
 			 * we need to try whether other unicast mac addresses
 			 * are new addresses that can be added.
+			 * Multicast mac address can be reusable, even though
+			 * there is no space to add new multicast mac address,
+			 * we should check whether other mac addresses are
+			 * existing in hardware for reuse.
 			 */
-			if (ret != -EEXIST)
+			if ((mac_type == HCLGE_MAC_ADDR_UC && ret != -EEXIST) ||
+			    (mac_type == HCLGE_MAC_ADDR_MC && ret != -ENOSPC))
 				break;
 		}
 	}
@@ -9032,12 +9045,17 @@ static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 
 static void hclge_unsync_vport_mac_list(struct hclge_vport *vport,
 					struct list_head *list,
-					int (*unsync)(struct hclge_vport *,
-						      const unsigned char *))
+					enum HCLGE_MAC_ADDR_TYPE mac_type)
 {
+	int (*unsync)(struct hclge_vport *vport, const unsigned char *addr);
 	struct hclge_mac_node *mac_node, *tmp;
 	int ret;
 
+	if (mac_type == HCLGE_MAC_ADDR_UC)
+		unsync = hclge_rm_uc_addr_common;
+	else
+		unsync = hclge_rm_mc_addr_common;
+
 	list_for_each_entry_safe(mac_node, tmp, list, node) {
 		ret = unsync(vport, mac_node->mac_addr);
 		if (!ret || ret == -ENOENT) {
@@ -9168,17 +9186,8 @@ static void hclge_sync_vport_mac_table(struct hclge_vport *vport,
 	spin_unlock_bh(&vport->mac_list_lock);
 
 	/* delete first, in order to get max mac table space for adding */
-	if (mac_type == HCLGE_MAC_ADDR_UC) {
-		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
-					    hclge_rm_uc_addr_common);
-		hclge_sync_vport_mac_list(vport, &tmp_add_list,
-					  hclge_add_uc_addr_common);
-	} else {
-		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
-					    hclge_rm_mc_addr_common);
-		hclge_sync_vport_mac_list(vport, &tmp_add_list,
-					  hclge_add_mc_addr_common);
-	}
+	hclge_unsync_vport_mac_list(vport, &tmp_del_list, mac_type);
+	hclge_sync_vport_mac_list(vport, &tmp_add_list, mac_type);
 
 	/* if some mac addresses were added/deleted fail, move back to the
 	 * mac_list, and retry at next time.
@@ -9337,12 +9346,7 @@ static void hclge_uninit_vport_mac_list(struct hclge_vport *vport,
 
 	spin_unlock_bh(&vport->mac_list_lock);
 
-	if (mac_type == HCLGE_MAC_ADDR_UC)
-		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
-					    hclge_rm_uc_addr_common);
-	else
-		hclge_unsync_vport_mac_list(vport, &tmp_del_list,
-					    hclge_rm_mc_addr_common);
+	hclge_unsync_vport_mac_list(vport, &tmp_del_list, mac_type);
 
 	if (!list_empty(&tmp_del_list))
 		dev_warn(&hdev->pdev->dev,
-- 
2.33.0

