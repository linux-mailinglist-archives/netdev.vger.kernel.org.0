Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAB35FFEC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhDOCVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:21:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16464 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhDOCVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:21:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FLNLB3KWvzwS2k;
        Thu, 15 Apr 2021 10:18:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 10:20:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH RESEND net-next 1/2] net: hns3: PF add support for pushing link status to VFs
Date:   Thu, 15 Apr 2021 10:20:38 +0800
Message-ID: <1618453239-10451-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
References: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Previously, VF updates its link status every second by send query command
to PF in periodic service task. If link stats of PF is changed, VF may
need at most one second to update its link status.

To reduce delay of link status between PF and VFs, PF actively push its
link status to VFs when its link status is updated. And to let VF know
PF supports this new feature, the link status changed mailbox command
adds one bit to indicate it.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 35 +++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 12 ++++----
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 33defa4..a2c17af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -172,4 +172,7 @@ struct hclgevf_mbx_arq_ring {
 		(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #define hclge_mbx_head_ptr_move_arq(arq) \
 		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
+
+/* PF immediately push link status to VFs when link status changed */
+#define HCLGE_MBX_PUSH_LINK_STATUS_EN			BIT(0)
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1c17fdc..dc06986 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2880,6 +2880,28 @@ static int hclge_get_mac_phy_link(struct hclge_dev *hdev, int *link_status)
 	return hclge_get_mac_link_status(hdev, link_status);
 }
 
+static void hclge_push_link_status(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
+
+	for (i = 0; i < pci_num_vf(hdev->pdev); i++) {
+		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
+
+		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) ||
+		    vport->vf_info.link_state != IFLA_VF_LINK_STATE_AUTO)
+			continue;
+
+		ret = hclge_push_vf_link_status(vport);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to push link status to vf%u, ret = %d\n",
+				i, ret);
+		}
+	}
+}
+
 static void hclge_update_link_status(struct hclge_dev *hdev)
 {
 	struct hnae3_handle *rhandle = &hdev->vport[0].roce;
@@ -2908,6 +2930,7 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 			rclient->ops->link_status_change(rhandle, state);
 
 		hdev->hw.mac.link = state;
+		hclge_push_link_status(hdev);
 	}
 
 	clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
@@ -3246,14 +3269,24 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	int link_state_old;
+	int ret;
 
 	vport = hclge_get_vf_vport(hdev, vf);
 	if (!vport)
 		return -EINVAL;
 
+	link_state_old = vport->vf_info.link_state;
 	vport->vf_info.link_state = link_state;
 
-	return 0;
+	ret = hclge_push_vf_link_status(vport);
+	if (ret) {
+		vport->vf_info.link_state = link_state_old;
+		dev_err(&hdev->pdev->dev,
+			"failed to push vf%d link status, ret = %d\n", vf, ret);
+	}
+
+	return ret;
 }
 
 static u32 hclge_check_event_cause(struct hclge_dev *hdev, u32 *clearval)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c1aaf7c5..ff1d473 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1089,4 +1089,5 @@ void hclge_report_hw_error(struct hclge_dev *hdev,
 			   enum hnae3_hw_error_type type);
 void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 void hclge_dbg_dump_rst_info(struct hclge_dev *hdev);
+int hclge_push_vf_link_status(struct hclge_vport *vport);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c88607b..5512ffe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -490,16 +490,14 @@ static void hclge_get_vf_media_type(struct hclge_vport *vport,
 	resp_msg->len = HCLGE_VF_MEDIA_TYPE_LENGTH;
 }
 
-static int hclge_get_link_info(struct hclge_vport *vport,
-			       struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+int hclge_push_vf_link_status(struct hclge_vport *vport)
 {
 #define HCLGE_VF_LINK_STATE_UP		1U
 #define HCLGE_VF_LINK_STATE_DOWN	0U
 
 	struct hclge_dev *hdev = vport->back;
 	u16 link_status;
-	u8 msg_data[8];
-	u8 dest_vfid;
+	u8 msg_data[9];
 	u16 duplex;
 
 	/* mac.link can only be 0 or 1 */
@@ -520,11 +518,11 @@ static int hclge_get_link_info(struct hclge_vport *vport,
 	memcpy(&msg_data[0], &link_status, sizeof(u16));
 	memcpy(&msg_data[2], &hdev->hw.mac.speed, sizeof(u32));
 	memcpy(&msg_data[6], &duplex, sizeof(u16));
-	dest_vfid = mbx_req->mbx_src_vfid;
+	msg_data[8] = HCLGE_MBX_PUSH_LINK_STATUS_EN;
 
 	/* send this requested info to VF */
 	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
-				  HCLGE_MBX_LINK_STAT_CHANGE, dest_vfid);
+				  HCLGE_MBX_LINK_STAT_CHANGE, vport->vport_id);
 }
 
 static void hclge_get_link_mode(struct hclge_vport *vport,
@@ -794,7 +792,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			hclge_get_vf_tcinfo(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_STATUS:
-			ret = hclge_get_link_info(vport, req);
+			ret = hclge_push_vf_link_status(vport);
 			if (ret)
 				dev_err(&hdev->pdev->dev,
 					"failed to inform link stat to VF, ret = %d\n",
-- 
2.7.4

