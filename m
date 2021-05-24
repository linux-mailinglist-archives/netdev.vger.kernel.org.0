Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC4038E35F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhEXJcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:32:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3975 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbhEXJca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:32:30 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FpX2d4NtczmYqX;
        Mon, 24 May 2021 17:28:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
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
Subject: [PATCH net-next 1/2] net: hns3: configure promisc mode for VF asynchronously
Date:   Mon, 24 May 2021 17:30:42 +0800
Message-ID: <1621848643-18567-2-git-send-email-tanhuazhong@huawei.com>
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

Currently, when host set VF untrusted, the driver will disable
the promisc mode of VF. It may be conflicted when the VF requests
the host to set promisc mode. So refactor it by changing promisc
mode for VF asynchronously. With this change, the promisc mode of
VF can be restored when the VF being trusted again.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 43 +++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  5 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 40 +++++---------------
 3 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3882f82..d37767d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11500,10 +11500,7 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
 	u32 new_trusted = enable ? 1 : 0;
-	bool en_bc_pmc;
-	int ret;
 
 	vport = hclge_get_vf_vport(hdev, vf);
 	if (!vport)
@@ -11512,18 +11509,9 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 	if (vport->vf_info.trusted == new_trusted)
 		return 0;
 
-	/* Disable promisc mode for VF if it is not trusted any more. */
-	if (!enable && vport->vf_info.promisc_enable) {
-		en_bc_pmc = ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2;
-		ret = hclge_set_vport_promisc_mode(vport, false, false,
-						   en_bc_pmc);
-		if (ret)
-			return ret;
-		vport->vf_info.promisc_enable = 0;
-		hclge_inform_vf_promisc_info(vport);
-	}
-
 	vport->vf_info.trusted = new_trusted;
+	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+	hclge_task_schedule(hdev, 0);
 
 	return 0;
 }
@@ -12417,6 +12405,7 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 	struct hnae3_handle *handle = &vport->nic;
 	u8 tmp_flags;
 	int ret;
+	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
 		set_bit(HCLGE_STATE_PROMISC_CHANGED, &hdev->state);
@@ -12433,6 +12422,32 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 						 tmp_flags & HNAE3_VLAN_FLTR);
 		}
 	}
+
+	for (i = 1; i < hdev->num_alloc_vport; i++) {
+		bool uc_en = false;
+		bool mc_en = false;
+		bool bc_en;
+
+		vport = &hdev->vport[i];
+
+		if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+					&vport->state))
+			continue;
+
+		if (vport->vf_info.trusted) {
+			uc_en = vport->vf_info.request_uc_en > 0;
+			mc_en = vport->vf_info.request_mc_en > 0;
+		}
+		bc_en = vport->vf_info.request_bc_en > 0;
+
+		ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
+						 mc_en, bc_en);
+		if (ret) {
+			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state);
+			return;
+		}
+	}
 }
 
 static bool hclge_module_existed(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 4bdb024..8425dae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -952,6 +952,7 @@ struct hclge_rss_tuple_cfg {
 enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_ALIVE,
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
+	HCLGE_VPORT_STATE_PROMISC_CHANGE,
 	HCLGE_VPORT_STATE_MAX
 };
 
@@ -972,7 +973,9 @@ struct hclge_vf_info {
 	u32 spoofchk;
 	u32 max_tx_rate;
 	u32 trusted;
-	u16 promisc_enable;
+	u8 request_uc_en;
+	u8 request_mc_en;
+	u8 request_bc_en;
 };
 
 struct hclge_vport {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 8e5f9dc..d86fc5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -231,19 +231,15 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 	return ret;
 }
 
-static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
-				     struct hclge_mbx_vf_to_pf_cmd *req)
+static void hclge_set_vf_promisc_mode(struct hclge_vport *vport,
+				      struct hclge_mbx_vf_to_pf_cmd *req)
 {
-	bool en_bc = req->msg.en_bc ? true : false;
-	bool en_uc = req->msg.en_uc ? true : false;
-	bool en_mc = req->msg.en_mc ? true : false;
 	struct hnae3_handle *handle = &vport->nic;
-	int ret;
+	struct hclge_dev *hdev = vport->back;
 
-	if (!vport->vf_info.trusted) {
-		en_uc = false;
-		en_mc = false;
-	}
+	vport->vf_info.request_uc_en = req->msg.en_uc;
+	vport->vf_info.request_mc_en = req->msg.en_mc;
+	vport->vf_info.request_bc_en = req->msg.en_bc;
 
 	if (req->msg.en_limit_promisc)
 		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->priv_flags);
@@ -251,22 +247,8 @@ static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 		clear_bit(HNAE3_PFLAG_LIMIT_PROMISC,
 			  &handle->priv_flags);
 
-	ret = hclge_set_vport_promisc_mode(vport, en_uc, en_mc, en_bc);
-
-	vport->vf_info.promisc_enable = (en_uc || en_mc) ? 1 : 0;
-
-	return ret;
-}
-
-void hclge_inform_vf_promisc_info(struct hclge_vport *vport)
-{
-	u8 dest_vfid = (u8)vport->vport_id;
-	u8 msg_data[2];
-
-	memcpy(&msg_data[0], &vport->vf_info.promisc_enable, sizeof(u16));
-
-	hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
-			   HCLGE_MBX_PUSH_PROMISC_INFO, dest_vfid);
+	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+	hclge_task_schedule(hdev, 0);
 }
 
 static int hclge_set_vf_uc_mac_addr(struct hclge_vport *vport,
@@ -748,11 +730,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 								req);
 			break;
 		case HCLGE_MBX_SET_PROMISC_MODE:
-			ret = hclge_set_vf_promisc_mode(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to set VF promisc mode\n",
-					ret);
+			hclge_set_vf_promisc_mode(vport, req);
 			break;
 		case HCLGE_MBX_SET_UNICAST:
 			ret = hclge_set_vf_uc_mac_addr(vport, req);
-- 
2.7.4

