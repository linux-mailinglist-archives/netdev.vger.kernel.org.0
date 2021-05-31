Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAB3953F7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhEaClO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:14 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6087 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhEaCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYk6YsRzYprJ;
        Mon, 31 May 2021 10:36:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:08 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/8] net: hns3: add query basic info support for VF
Date:   Mon, 31 May 2021 10:38:43 +0800
Message-ID: <1622428725-30049-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

There are some features of VF depend on PF, so it's necessary
for VF to know whether PF supports. For compatibility, modify
the mailbox HCLGE_MBX_GET_TCINFO, extend its function, use to
get the basic information of PF, including mailbox api version
and PF capabilities.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  9 +++++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 19 +++++++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 33 +++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 5 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index a2c17af..d752862 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -20,7 +20,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_API_NEGOTIATE,	/* (VF -> PF) negotiate API version */
 	HCLGE_MBX_GET_QINFO,		/* (VF -> PF) get queue config */
 	HCLGE_MBX_GET_QDEPTH,		/* (VF -> PF) get queue depth */
-	HCLGE_MBX_GET_TCINFO,		/* (VF -> PF) get TC config */
+	HCLGE_MBX_GET_BASIC_INFO,	/* (VF -> PF) get basic info */
 	HCLGE_MBX_GET_RETA,		/* (VF -> PF) get RETA */
 	HCLGE_MBX_GET_RSS_KEY,		/* (VF -> PF) get RSS key */
 	HCLGE_MBX_GET_MAC_ADDR,		/* (VF -> PF) get MAC addr */
@@ -85,6 +85,13 @@ struct hclge_ring_chain_param {
 	u8 int_gl_index;
 };
 
+struct hclge_basic_info {
+	u8 hw_tc_map;
+	u8 rsv;
+	u16 mbx_api_version;
+	u32 pf_caps;
+};
+
 struct hclgevf_mbx_resp_status {
 	struct mutex mbx_mutex; /* protects against contending sync cmd resp */
 	u32 origin_mbx_msg;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index c79fef9..0ce353da 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -147,6 +147,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_rxd_adv_layout_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, (ae_dev)->caps)
 
+enum HNAE3_PF_CAP_BITS {
+	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
+};
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
 #define ring_ptr_move_bw(ring, p) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 54eee94..5995194 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -384,16 +384,23 @@ static int hclge_set_vf_alive(struct hclge_vport *vport,
 	return ret;
 }
 
-static void hclge_get_vf_tcinfo(struct hclge_vport *vport,
-				struct hclge_respond_to_vf_msg *resp_msg)
+static void hclge_get_basic_info(struct hclge_vport *vport,
+				 struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hnae3_ae_dev *ae_dev = vport->back->ae_dev;
+	struct hclge_basic_info *basic_info;
 	unsigned int i;
 
+	basic_info = (struct hclge_basic_info *)resp_msg->data;
 	for (i = 0; i < kinfo->tc_info.num_tc; i++)
-		resp_msg->data[0] |= BIT(i);
+		basic_info->hw_tc_map |= BIT(i);
 
-	resp_msg->len = sizeof(u8);
+	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
+		hnae3_set_bit(basic_info->pf_caps,
+			      HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B, 1);
+
+	resp_msg->len = HCLGE_MBX_MAX_RESP_DATA_SIZE;
 }
 
 static void hclge_get_vf_queue_info(struct hclge_vport *vport,
@@ -752,8 +759,8 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 		case HCLGE_MBX_GET_QDEPTH:
 			hclge_get_vf_queue_depth(vport, &resp_msg);
 			break;
-		case HCLGE_MBX_GET_TCINFO:
-			hclge_get_vf_tcinfo(vport, &resp_msg);
+		case HCLGE_MBX_GET_BASIC_INFO:
+			hclge_get_basic_info(vport, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_STATUS:
 			ret = hclge_push_vf_link_status(vport);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7bef6b2..7c10145 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -243,23 +243,31 @@ static void hclgevf_build_send_msg(struct hclge_vf_to_pf_msg *msg, u8 code,
 	}
 }
 
-static int hclgevf_get_tc_info(struct hclgevf_dev *hdev)
+static int hclgevf_get_basic_info(struct hclgevf_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	u8 resp_msg[HCLGE_MBX_MAX_RESP_DATA_SIZE];
+	struct hclge_basic_info *basic_info;
 	struct hclge_vf_to_pf_msg send_msg;
-	u8 resp_msg;
+	unsigned long caps;
 	int status;
 
-	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_TCINFO, 0);
-	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, &resp_msg,
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_BASIC_INFO, 0);
+	status = hclgevf_send_mbx_msg(hdev, &send_msg, true, resp_msg,
 				      sizeof(resp_msg));
 	if (status) {
 		dev_err(&hdev->pdev->dev,
-			"VF request to get TC info from PF failed %d",
-			status);
+			"failed to get basic info from pf, ret = %d", status);
 		return status;
 	}
 
-	hdev->hw_tc_map = resp_msg;
+	basic_info = (struct hclge_basic_info *)resp_msg;
+
+	hdev->hw_tc_map = basic_info->hw_tc_map;
+	hdev->mbx_api_version = basic_info->mbx_api_version;
+	caps = basic_info->pf_caps;
+	if (test_bit(HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B, &caps))
+		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
 	return 0;
 }
@@ -2466,6 +2474,10 @@ static int hclgevf_configure(struct hclgevf_dev *hdev)
 {
 	int ret;
 
+	ret = hclgevf_get_basic_info(hdev);
+	if (ret)
+		return ret;
+
 	/* get current port based vlan state from PF */
 	ret = hclgevf_get_port_base_vlan_filter_state(hdev);
 	if (ret)
@@ -2481,12 +2493,7 @@ static int hclgevf_configure(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclgevf_get_pf_media_type(hdev);
-	if (ret)
-		return ret;
-
-	/* get tc configuration from PF */
-	return hclgevf_get_tc_info(hdev);
+	return hclgevf_get_pf_media_type(hdev);
 }
 
 static int hclgevf_alloc_hdev(struct hnae3_ae_dev *ae_dev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index b146d04..d7d0284 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -285,6 +285,7 @@ struct hclgevf_dev {
 	struct semaphore reset_sem;	/* protect reset process */
 
 	u32 fw_version;
+	u16 mbx_api_version;
 	u16 num_tqps;		/* num task queue pairs of this VF */
 
 	u16 alloc_rss_size;	/* allocated RSS task queue */
-- 
2.7.4

