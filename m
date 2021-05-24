Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A6C38E360
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhEXJce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:32:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3974 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhEXJca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:32:30 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FpX2d5XrBzmZfk;
        Mon, 24 May 2021 17:28:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 17:31:01 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 17:31:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: use HCLGE_VPORT_STATE_PROMISC_CHANGE to replace HCLGE_STATE_PROMISC_CHANGED
Date:   Mon, 24 May 2021 17:30:43 +0800
Message-ID: <1621848643-18567-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621848643-18567-1-git-send-email-tanhuazhong@huawei.com>
References: <1621848643-18567-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, PF is using HCLGE_STATE_PROMISC_CHANGED to indicate
need synchronize the promisc mode for itself, and using flag
HCLGE_VPORT_STATE_PROMISC_CHANGE for its VF. To keep consistent,
remove flag HCLGE_STATE_PROMISC_CHANGED, and use flag
HCLGE_VPORT_STATE_PROMISC_CHANGE instead.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 12 ++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  1 -
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d37767d..6addeb2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5183,9 +5183,8 @@ static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 static void hclge_request_update_promisc_mode(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
 
-	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 }
 
 static void hclge_sync_fd_state(struct hclge_dev *hdev)
@@ -8050,6 +8049,7 @@ int hclge_vport_start(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 	vport->last_active_jiffies = jiffies;
 
 	if (test_bit(vport->vport_id, hdev->vport_config_block)) {
@@ -10048,7 +10048,6 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 
 	hclge_restore_mac_table_common(vport);
 	hclge_restore_vport_vlan_table(vport);
-	set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
 	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
 	hclge_restore_fd_entries(handle);
 }
@@ -12408,16 +12407,17 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
-		set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 		vport->last_promisc_flags = vport->overflow_promisc_flags;
 	}
 
-	if (test_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state)) {
+	if (test_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state)) {
 		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
 		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
 					     tmp_flags & HNAE3_MPE);
 		if (!ret) {
-			clear_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
+			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				  &vport->state);
 			hclge_enable_vlan_filter(handle,
 						 tmp_flags & HNAE3_VLAN_FLTR);
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 8425dae..9e4d02d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -224,7 +224,6 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_STATISTICS_UPDATING,
 	HCLGE_STATE_CMD_DISABLE,
 	HCLGE_STATE_LINK_UPDATING,
-	HCLGE_STATE_PROMISC_CHANGED,
 	HCLGE_STATE_RST_FAIL,
 	HCLGE_STATE_FD_TBL_CHANGED,
 	HCLGE_STATE_FD_CLEAR_ALL,
-- 
2.7.4

