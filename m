Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F323F8664
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhHZL0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14422 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242014AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwL622S17zbdBt;
        Thu, 26 Aug 2021 19:22:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 6/7] net: hns3: fix GRO configuration error after reset
Date:   Thu, 26 Aug 2021 19:22:00 +0800
Message-ID: <1629976921-43438-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The GRO configuration is enabled by default after reset. This
is incorrect and should be restored to the user-configured value.
So this restoration is added during reset initialization.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 18 +++++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   |  1 +
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 19 ++++++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h |  2 ++
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1d0fa966e55a..03ae122f1c9a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1550,6 +1550,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->tm_info.hw_pfc_map = 0;
 	hdev->wanted_umv_size = cfg.umv_space;
 	hdev->tx_spare_buf_size = cfg.tx_spare_buf_size;
+	hdev->gro_en = true;
 	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
@@ -1618,7 +1619,7 @@ static int hclge_config_tso(struct hclge_dev *hdev, u16 tso_mss_min,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_config_gro(struct hclge_dev *hdev, bool en)
+static int hclge_config_gro(struct hclge_dev *hdev)
 {
 	struct hclge_cfg_gro_status_cmd *req;
 	struct hclge_desc desc;
@@ -1630,7 +1631,7 @@ static int hclge_config_gro(struct hclge_dev *hdev, bool en)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG, false);
 	req = (struct hclge_cfg_gro_status_cmd *)desc.data;
 
-	req->gro_en = en ? 1 : 0;
+	req->gro_en = hdev->gro_en ? 1 : 0;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
@@ -11586,7 +11587,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
-	ret = hclge_config_gro(hdev, true);
+	ret = hclge_config_gro(hdev);
 	if (ret)
 		goto err_mdiobus_unreg;
 
@@ -11967,7 +11968,7 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
-	ret = hclge_config_gro(hdev, true);
+	ret = hclge_config_gro(hdev);
 	if (ret)
 		return ret;
 
@@ -12701,8 +12702,15 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	bool gro_en_old = hdev->gro_en;
+	int ret;
+
+	hdev->gro_en = enable;
+	ret = hclge_config_gro(hdev);
+	if (ret)
+		hdev->gro_en = gro_en_old;
 
-	return hclge_config_gro(hdev, enable);
+	return ret;
 }
 
 static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3d3352491dba..e446b839a371 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -927,6 +927,7 @@ struct hclge_dev {
 	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
+	bool gro_en;
 
 	u16 wanted_umv_size;
 	/* max available unicast mac vlan space */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index f25580366879..938654778979 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2487,6 +2487,8 @@ static int hclgevf_configure(struct hclgevf_dev *hdev)
 {
 	int ret;
 
+	hdev->gro_en = true;
+
 	ret = hclgevf_get_basic_info(hdev);
 	if (ret)
 		return ret;
@@ -2549,7 +2551,7 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 	return 0;
 }
 
-static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
+static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_cfg_gro_status_cmd *req;
 	struct hclgevf_desc desc;
@@ -2562,7 +2564,7 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
 				     false);
 	req = (struct hclgevf_cfg_gro_status_cmd *)desc.data;
 
-	req->gro_en = en ? 1 : 0;
+	req->gro_en = hdev->gro_en ? 1 : 0;
 
 	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
@@ -3308,7 +3310,7 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
-	ret = hclgevf_config_gro(hdev, true);
+	ret = hclgevf_config_gro(hdev);
 	if (ret)
 		return ret;
 
@@ -3389,7 +3391,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		goto err_config;
 
-	ret = hclgevf_config_gro(hdev, true);
+	ret = hclgevf_config_gro(hdev);
 	if (ret)
 		goto err_config;
 
@@ -3638,8 +3640,15 @@ void hclgevf_update_speed_duplex(struct hclgevf_dev *hdev, u32 speed,
 static int hclgevf_gro_en(struct hnae3_handle *handle, bool enable)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	bool gro_en_old = hdev->gro_en;
+	int ret;
 
-	return hclgevf_config_gro(hdev, enable);
+	hdev->gro_en = enable;
+	ret = hclgevf_config_gro(hdev);
+	if (ret)
+		hdev->gro_en = gro_en_old;
+
+	return ret;
 }
 
 static void hclgevf_get_media_type(struct hnae3_handle *handle, u8 *media_type,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index d7d02848d674..e8013be055f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -310,6 +310,8 @@ struct hclgevf_dev {
 	u16 *vector_status;
 	int *vector_irq;
 
+	bool gro_en;
+
 	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 
 	struct hclgevf_mac_table_cfg mac_table;
-- 
2.8.1

