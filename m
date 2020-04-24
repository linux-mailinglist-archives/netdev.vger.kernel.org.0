Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B081E1B6B45
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDXCY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2888 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbgDXCY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:28 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B29F8FC5FC49E73D391A;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:18 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/8] net: hns3: use mutex vport_lock instead of mutex umv_lock
Date:   Fri, 24 Apr 2020 10:23:12 +0800
Message-ID: <1587694993-25183-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the driver use mutex umv_lock to protect the variable
vport->share_umv_size. And there is already a mutex vport_lock
being defined in the driver, which is designed to protect the
resource of vport. So we can use vport_lock instead of umv_lock.

Furthermore, there is a time window for protect share_umv_size
between checking UMV space and doing MAC configuration in the
lin function hclge_add_uc_addr_common(). It should be extended.

This patch uses mutex vport_lock intead of spin lock umv_lock to
protect share_umv_size, and adjusts the mutex's range.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 31 +++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 -
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 71ff0fa..177ef5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7250,7 +7250,6 @@ static int hclge_init_umv_space(struct hclge_dev *hdev)
 			 "failed to alloc umv space, want %u, get %u\n",
 			 hdev->wanted_umv_size, allocated_size);
 
-	mutex_init(&hdev->umv_mutex);
 	hdev->max_umv_size = allocated_size;
 	hdev->priv_umv_size = hdev->max_umv_size / (hdev->num_alloc_vport + 1);
 	hdev->share_umv_size = hdev->priv_umv_size +
@@ -7269,21 +7268,25 @@ static void hclge_reset_umv_space(struct hclge_dev *hdev)
 		vport->used_umv_num = 0;
 	}
 
-	mutex_lock(&hdev->umv_mutex);
+	mutex_lock(&hdev->vport_lock);
 	hdev->share_umv_size = hdev->priv_umv_size +
 			hdev->max_umv_size % (hdev->num_alloc_vport + 1);
-	mutex_unlock(&hdev->umv_mutex);
+	mutex_unlock(&hdev->vport_lock);
 }
 
-static bool hclge_is_umv_space_full(struct hclge_vport *vport)
+static bool hclge_is_umv_space_full(struct hclge_vport *vport, bool need_lock)
 {
 	struct hclge_dev *hdev = vport->back;
 	bool is_full;
 
-	mutex_lock(&hdev->umv_mutex);
+	if (need_lock)
+		mutex_lock(&hdev->vport_lock);
+
 	is_full = (vport->used_umv_num >= hdev->priv_umv_size &&
 		   hdev->share_umv_size == 0);
-	mutex_unlock(&hdev->umv_mutex);
+
+	if (need_lock)
+		mutex_unlock(&hdev->vport_lock);
 
 	return is_full;
 }
@@ -7292,7 +7295,6 @@ static void hclge_update_umv_space(struct hclge_vport *vport, bool is_free)
 {
 	struct hclge_dev *hdev = vport->back;
 
-	mutex_lock(&hdev->umv_mutex);
 	if (is_free) {
 		if (vport->used_umv_num > hdev->priv_umv_size)
 			hdev->share_umv_size++;
@@ -7305,7 +7307,6 @@ static void hclge_update_umv_space(struct hclge_vport *vport, bool is_free)
 			hdev->share_umv_size--;
 		vport->used_umv_num++;
 	}
-	mutex_unlock(&hdev->umv_mutex);
 }
 
 static struct hclge_mac_node *hclge_find_mac_node(struct list_head *list,
@@ -7446,12 +7447,15 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	 */
 	ret = hclge_lookup_mac_vlan_tbl(vport, &req, &desc, false);
 	if (ret == -ENOENT) {
-		if (!hclge_is_umv_space_full(vport)) {
+		mutex_lock(&hdev->vport_lock);
+		if (!hclge_is_umv_space_full(vport, false)) {
 			ret = hclge_add_mac_vlan_tbl(vport, &req, NULL);
 			if (!ret)
 				hclge_update_umv_space(vport, false);
+			mutex_unlock(&hdev->vport_lock);
 			return ret;
 		}
+		mutex_unlock(&hdev->vport_lock);
 
 		if (!(vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE))
 			dev_err(&hdev->pdev->dev, "UC MAC table full(%u)\n",
@@ -7503,10 +7507,13 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
 	hclge_prepare_mac_addr(&req, addr, false);
 	ret = hclge_remove_mac_vlan_tbl(vport, &req);
-	if (!ret)
+	if (!ret) {
+		mutex_lock(&hdev->vport_lock);
 		hclge_update_umv_space(vport, true);
-	else if (ret == -ENOENT)
+		mutex_unlock(&hdev->vport_lock);
+	} else if (ret == -ENOENT) {
 		ret = 0;
+	}
 
 	return ret;
 }
@@ -10163,7 +10170,7 @@ static int hclge_set_vf_spoofchk(struct hnae3_handle *handle, int vf,
 		dev_warn(&hdev->pdev->dev,
 			 "vf %d vlan table is full, enable spoof check may cause its packet send fail\n",
 			 vf);
-	else if (enable && hclge_is_umv_space_full(vport))
+	else if (enable && hclge_is_umv_space_full(vport, true))
 		dev_warn(&hdev->pdev->dev,
 			 "vf %d mac table is full, enable spoof check may cause its packet send fail\n",
 			 vf);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 85180f4..8e69651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -831,7 +831,6 @@ struct hclge_dev {
 	u16 priv_umv_size;
 	/* unicast mac vlan space shared by PF and its VFs */
 	u16 share_umv_size;
-	struct mutex umv_mutex; /* protect share_umv_size */
 
 	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
 		      HCLGE_MAC_TNL_LOG_SIZE);
-- 
2.7.4

