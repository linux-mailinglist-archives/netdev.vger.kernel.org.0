Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D223953F3
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhEaClD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhEaCkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYk5qVFzYpqB;
        Mon, 31 May 2021 10:36:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:07 +0800
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
Subject: [PATCH net-next 7/8] net: hns3: add support for VF modify VLAN filter state
Date:   Mon, 31 May 2021 10:38:44 +0800
Message-ID: <1622428725-30049-8-git-send-email-tanhuazhong@huawei.com>
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

Previously, there is hardware limitation for VF to modify
the VLAN filter state, and the VLAN filter state is default
enabled. Now the limitation has been removed in some device,
so add capability flag to check whether the device supports
modify VLAN filter state. If flag on, user will be able to
modify the VLAN filter state by ethtool -K.
VF needs to send mailbox to request the PF to modify the VLAN
filter state for it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h         |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c  |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   | 17 +++++++++++++++++
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index d752862..0a6cda30 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -69,6 +69,7 @@ enum hclge_mbx_vlan_cfg_subcode {
 	HCLGE_MBX_VLAN_RX_OFF_CFG,	/* set rx side vlan offload */
 	HCLGE_MBX_PORT_BASE_VLAN_CFG,	/* set port based vlan configuration */
 	HCLGE_MBX_GET_PORT_BASE_VLAN_STATE,	/* get port based vlan state */
+	HCLGE_MBX_ENABLE_VLAN_FILTER,
 };
 
 enum hclge_mbx_tbl_cfg_subcode {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c6444d2..35aa4ac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9515,8 +9515,7 @@ static bool hclge_need_enable_vport_vlan_filter(struct hclge_vport *vport)
 	return false;
 }
 
-static int hclge_enable_vport_vlan_filter(struct hclge_vport *vport,
-					  bool request_en)
+int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en)
 {
 	struct hclge_dev *hdev = vport->back;
 	bool need_en;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index eb03652..bb778433 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1107,4 +1107,5 @@ void hclge_report_hw_error(struct hclge_dev *hdev,
 void hclge_inform_vf_promisc_info(struct hclge_vport *vport);
 int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
+int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 5995194..e10a2c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -365,6 +365,8 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 			vport->port_base_vlan_cfg.state;
 		resp_msg->len = sizeof(u8);
 		return 0;
+	case HCLGE_MBX_ENABLE_VLAN_FILTER:
+		return hclge_enable_vport_vlan_filter(vport, msg_cmd->enable);
 	default:
 		return 0;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7c10145..f84b3a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1650,6 +1650,22 @@ static void hclgevf_uninit_mac_list(struct hclgevf_dev *hdev)
 	spin_unlock_bh(&hdev->mac_table.mac_list_lock);
 }
 
+static int hclgevf_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	struct hclge_vf_to_pf_msg send_msg;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
+		return -EOPNOTSUPP;
+
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
+			       HCLGE_MBX_ENABLE_VLAN_FILTER);
+	send_msg.data[0] = enable ? 1 : 0;
+
+	return hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
+}
+
 static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 				   __be16 proto, u16 vlan_id,
 				   bool is_kill)
@@ -3808,6 +3824,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.get_tc_size = hclgevf_get_tc_size,
 	.get_fw_version = hclgevf_get_fw_version,
 	.set_vlan_filter = hclgevf_set_vlan_filter,
+	.enable_vlan_filter = hclgevf_enable_vlan_filter,
 	.enable_hw_strip_rxvtag = hclgevf_en_hw_strip_rxvtag,
 	.reset_event = hclgevf_reset_event,
 	.set_default_reset_request = hclgevf_set_def_reset_request,
-- 
2.7.4

