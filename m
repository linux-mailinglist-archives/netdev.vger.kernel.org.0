Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7631F4E63C7
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350353AbiCXNB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350343AbiCXNB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:01:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B3C90249;
        Thu, 24 Mar 2022 06:00:22 -0700 (PDT)
Received: from kwepemi100015.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KPQLL3GKDzcbb5;
        Thu, 24 Mar 2022 21:00:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100015.china.huawei.com (7.221.188.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 3/4] net: hns3: add vlan list lock to protect vlan list
Date:   Thu, 24 Mar 2022 20:54:49 +0800
Message-ID: <20220324125450.56417-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324125450.56417-1-huangguangbin2@huawei.com>
References: <20220324125450.56417-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

When adding port base VLAN, vf VLAN need to remove from HW and modify
the vlan state in vf VLAN list as false. If the periodicity task is
freeing the same node, it may cause "use after free" error.
This patch adds a vlan list lock to protect the vlan list.

Fixes: c6075b193462 ("net: hns3: Record VF vlan tables")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 38 +++++++++++++++++--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 +
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d4fe92b22fb9..9655a7d2c200 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9809,19 +9809,28 @@ static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 				       bool writen_to_tbl)
 {
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
 
-	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node)
-		if (vlan->vlan_id == vlan_id)
+	mutex_lock(&hdev->vport_lock);
+
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+		if (vlan->vlan_id == vlan_id) {
+			mutex_unlock(&hdev->vport_lock);
 			return;
+		}
+	}
 
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
-	if (!vlan)
+	if (!vlan) {
+		mutex_unlock(&hdev->vport_lock);
 		return;
+	}
 
 	vlan->hd_tbl_status = writen_to_tbl;
 	vlan->vlan_id = vlan_id;
 
 	list_add_tail(&vlan->node, &vport->vlan_list);
+	mutex_unlock(&hdev->vport_lock);
 }
 
 static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
@@ -9830,6 +9839,8 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (!vlan->hd_tbl_status) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -9839,12 +9850,16 @@ static int hclge_add_vport_all_vlan_table(struct hclge_vport *vport)
 				dev_err(&hdev->pdev->dev,
 					"restore vport vlan list failed, ret=%d\n",
 					ret);
+
+				mutex_unlock(&hdev->vport_lock);
 				return ret;
 			}
 		}
 		vlan->hd_tbl_status = true;
 	}
 
+	mutex_unlock(&hdev->vport_lock);
+
 	return 0;
 }
 
@@ -9854,6 +9869,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->vlan_id == vlan_id) {
 			if (is_write_tbl && vlan->hd_tbl_status)
@@ -9868,6 +9885,8 @@ static void hclge_rm_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 			break;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
@@ -9875,6 +9894,8 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 	struct hclge_vport_vlan_cfg *vlan, *tmp;
 	struct hclge_dev *hdev = vport->back;
 
+	mutex_lock(&hdev->vport_lock);
+
 	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 		if (vlan->hd_tbl_status)
 			hclge_set_vlan_filter_hw(hdev,
@@ -9890,6 +9911,7 @@ void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list)
 		}
 	}
 	clear_bit(vport->vport_id, hdev->vf_vlan_full);
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
@@ -9898,6 +9920,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	struct hclge_vport *vport;
 	int i;
 
+	mutex_lock(&hdev->vport_lock);
+
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
@@ -9905,6 +9929,8 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 			kfree(vlan);
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev)
@@ -9944,6 +9970,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 	int ret;
 
+	mutex_lock(&hdev->vport_lock);
+
 	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
 			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
@@ -9954,6 +9982,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
 			vlan->hd_tbl_status = true;
 		}
 	}
+
+	mutex_unlock(&hdev->vport_lock);
 }
 
 /* For global reset and imp reset, hardware will clear the mac table,
@@ -11854,8 +11884,8 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_misc_irq_uninit(hdev);
 	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
-	mutex_destroy(&hdev->vport_lock);
 	hclge_uninit_vport_vlan_table(hdev);
+	mutex_destroy(&hdev->vport_lock);
 	ae_dev->priv = NULL;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 31fef46b93b3..63197257dd4e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1025,6 +1025,7 @@ struct hclge_vport {
 	spinlock_t mac_list_lock; /* protect mac address need to add/detele */
 	struct list_head uc_mac_list;   /* Store VF unicast table */
 	struct list_head mc_mac_list;   /* Store VF multicast table */
+
 	struct list_head vlan_list;     /* Store VF vlan table */
 };
 
-- 
2.33.0

