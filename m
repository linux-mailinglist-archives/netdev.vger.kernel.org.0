Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF93D125BC5
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLSG62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:58:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51088 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726704AbfLSG5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:48 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB4F6FF9E85E5EDE86D4;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/8] net: hns3: remove useless mutex vport_cfg_mutex in the struct hclge_dev
Date:   Thu, 19 Dec 2019 14:57:41 +0800
Message-ID: <1576738667-37960-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutex vport_cfg_mutex has been used to protect uc_mac_list,
mc_mac_list and vlan_list from being modified by unloading
or reset task at the same time. But now unloading will
set up HCLGE_STATE_REMOVING flag and call cancel_work_sync to
break down this race condition, so this mutex is unnecessary.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 ---------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  | 2 --
 3 files changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4e7a078..76b4418 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7534,7 +7534,6 @@ void hclge_uninit_vport_mac_table(struct hclge_dev *hdev)
 	struct hclge_vport *vport;
 	int i;
 
-	mutex_lock(&hdev->vport_cfg_mutex);
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		list_for_each_entry_safe(mac, tmp, &vport->uc_mac_list, node) {
@@ -7547,7 +7546,6 @@ void hclge_uninit_vport_mac_table(struct hclge_dev *hdev)
 			kfree(mac);
 		}
 	}
-	mutex_unlock(&hdev->vport_cfg_mutex);
 }
 
 static int hclge_get_mac_ethertype_cmd_status(struct hclge_dev *hdev,
@@ -8308,7 +8306,6 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	struct hclge_vport *vport;
 	int i;
 
-	mutex_lock(&hdev->vport_cfg_mutex);
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
@@ -8316,7 +8313,6 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 			kfree(vlan);
 		}
 	}
-	mutex_unlock(&hdev->vport_cfg_mutex);
 }
 
 static void hclge_restore_vlan_table(struct hnae3_handle *handle)
@@ -8328,7 +8324,6 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 	u16 state, vlan_id;
 	int i;
 
-	mutex_lock(&hdev->vport_cfg_mutex);
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
 		vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
@@ -8354,8 +8349,6 @@ static void hclge_restore_vlan_table(struct hnae3_handle *handle)
 				break;
 		}
 	}
-
-	mutex_unlock(&hdev->vport_cfg_mutex);
 }
 
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
@@ -9390,7 +9383,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hdev->mps = ETH_FRAME_LEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 
 	mutex_init(&hdev->vport_lock);
-	mutex_init(&hdev->vport_cfg_mutex);
 	spin_lock_init(&hdev->fd_rule_lock);
 
 	ret = hclge_pci_init(hdev);
@@ -9943,7 +9935,6 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	mutex_destroy(&hdev->vport_lock);
 	hclge_uninit_vport_mac_table(hdev);
 	hclge_uninit_vport_vlan_table(hdev);
-	mutex_destroy(&hdev->vport_cfg_mutex);
 	ae_dev->priv = NULL;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3a91397..4e5cfda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -821,8 +821,6 @@ struct hclge_dev {
 	u16 share_umv_size;
 	struct mutex umv_mutex; /* protect share_umv_size */
 
-	struct mutex vport_cfg_mutex;   /* Protect stored vf table */
-
 	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
 		      HCLGE_MAC_TNL_LOG_SIZE);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index a79d151..f905dd3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -797,13 +797,11 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			hclge_get_link_mode(vport, req);
 			break;
 		case HCLGE_MBX_GET_VF_FLR_STATUS:
-			mutex_lock(&hdev->vport_cfg_mutex);
 			hclge_rm_vport_all_mac_table(vport, true,
 						     HCLGE_MAC_ADDR_UC);
 			hclge_rm_vport_all_mac_table(vport, true,
 						     HCLGE_MAC_ADDR_MC);
 			hclge_rm_vport_all_vlan_table(vport, true);
-			mutex_unlock(&hdev->vport_cfg_mutex);
 			break;
 		case HCLGE_MBX_GET_MEDIA_TYPE:
 			ret = hclge_get_vf_media_type(vport, req);
-- 
2.7.4

