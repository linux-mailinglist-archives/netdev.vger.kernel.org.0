Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4346F1B6B44
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDXCY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:24:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2884 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbgDXCY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:24:26 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9A446E8C2F3173AF175F;
        Fri, 24 Apr 2020 10:24:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 24 Apr 2020 10:24:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: refine for unicast MAC VLAN space management
Date:   Fri, 24 Apr 2020 10:23:06 +0800
Message-ID: <1587694993-25183-2-git-send-email-tanhuazhong@huawei.com>
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

Currently, firmware helps manage the unicast MAC VLAN table
space for each PF. PF just needs to tell firmware its wanted
space when initializing, and unnecessary to free it when
un-intializing. So this patch removes the umv space free handle,
and removes the forward statement of hclge_set_umv_space()
by defining hclge_init_umv_space() after it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 72 ++++++++--------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0618f22..ccf269a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -62,8 +62,6 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
 static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev);
 static bool hclge_get_hw_reset_stat(struct hnae3_handle *handle);
-static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
-			       u16 *allocated_size, bool is_alloc);
 static void hclge_rfs_filter_expire(struct hclge_dev *hdev);
 static void hclge_clear_arfs_rules(struct hnae3_handle *handle);
 static enum hnae3_reset_type hclge_get_reset_level(struct hnae3_ae_dev *ae_dev,
@@ -7196,50 +7194,6 @@ static int hclge_add_mac_vlan_tbl(struct hclge_vport *vport,
 	return cfg_status;
 }
 
-static int hclge_init_umv_space(struct hclge_dev *hdev)
-{
-	u16 allocated_size = 0;
-	int ret;
-
-	ret = hclge_set_umv_space(hdev, hdev->wanted_umv_size, &allocated_size,
-				  true);
-	if (ret)
-		return ret;
-
-	if (allocated_size < hdev->wanted_umv_size)
-		dev_warn(&hdev->pdev->dev,
-			 "Alloc umv space failed, want %u, get %u\n",
-			 hdev->wanted_umv_size, allocated_size);
-
-	mutex_init(&hdev->umv_mutex);
-	hdev->max_umv_size = allocated_size;
-	/* divide max_umv_size by (hdev->num_req_vfs + 2), in order to
-	 * preserve some unicast mac vlan table entries shared by pf
-	 * and its vfs.
-	 */
-	hdev->priv_umv_size = hdev->max_umv_size / (hdev->num_req_vfs + 2);
-	hdev->share_umv_size = hdev->priv_umv_size +
-			hdev->max_umv_size % (hdev->num_req_vfs + 2);
-
-	return 0;
-}
-
-static int hclge_uninit_umv_space(struct hclge_dev *hdev)
-{
-	int ret;
-
-	if (hdev->max_umv_size > 0) {
-		ret = hclge_set_umv_space(hdev, hdev->max_umv_size, NULL,
-					  false);
-		if (ret)
-			return ret;
-		hdev->max_umv_size = 0;
-	}
-	mutex_destroy(&hdev->umv_mutex);
-
-	return 0;
-}
-
 static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 			       u16 *allocated_size, bool is_alloc)
 {
@@ -7268,6 +7222,30 @@ static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 	return 0;
 }
 
+static int hclge_init_umv_space(struct hclge_dev *hdev)
+{
+	u16 allocated_size = 0;
+	int ret;
+
+	ret = hclge_set_umv_space(hdev, hdev->wanted_umv_size, &allocated_size,
+				  true);
+	if (ret)
+		return ret;
+
+	if (allocated_size < hdev->wanted_umv_size)
+		dev_warn(&hdev->pdev->dev,
+			 "failed to alloc umv space, want %u, get %u\n",
+			 hdev->wanted_umv_size, allocated_size);
+
+	mutex_init(&hdev->umv_mutex);
+	hdev->max_umv_size = allocated_size;
+	hdev->priv_umv_size = hdev->max_umv_size / (hdev->num_alloc_vport + 1);
+	hdev->share_umv_size = hdev->priv_umv_size +
+			hdev->max_umv_size % (hdev->num_alloc_vport + 1);
+
+	return 0;
+}
+
 static void hclge_reset_umv_space(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport;
@@ -10041,8 +10019,6 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (mac->phydev)
 		mdiobus_unregister(mac->mdio_bus);
 
-	hclge_uninit_umv_space(hdev);
-
 	/* Disable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, false);
 	synchronize_irq(hdev->misc_vector.vector_irq);
-- 
2.7.4

