Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2973953F4
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEaClG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:41:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6083 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhEaCkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYk5cQFzYppw;
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
Subject: [PATCH net-next 4/8] net: hns3: refine function hclge_set_vf_vlan_cfg()
Date:   Mon, 31 May 2021 10:38:41 +0800
Message-ID: <1622428725-30049-5-git-send-email-tanhuazhong@huawei.com>
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

The struct hclge_vf_vlan_cfg is firstly designed for setting
VLAN filter tag. And it's reused for enable RX VLAN offload
later. It's strange to use member "is_kill" to indicate "enable".
So redefine the struct hclge_vf_vlan_cfg to adapt it.

For there are already 3 subcodes being used in function
hclge_set_vf_vlan_cfg(), use "switch-case" style for each
branch, rather than "if-else". Also simplify the assignment for
each branch to make it more clearly.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 11 +++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 35 +++++++++-------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index e3dc216..cd1e401 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -759,9 +759,14 @@ struct hclge_mac_tnl_stats {
 struct hclge_vf_vlan_cfg {
 	u8 mbx_cmd;
 	u8 subcode;
-	u8 is_kill;
-	u16 vlan;
-	u16 proto;
+	union {
+		struct {
+			u8 is_kill;
+			u16 vlan;
+			u16 proto;
+		};
+		u8 enable;
+	};
 };
 
 #pragma pack()
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 3f7d1f2..54eee94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -341,40 +341,33 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 #define HCLGE_MBX_VLAN_STATE_OFFSET	0
 #define HCLGE_MBX_VLAN_INFO_OFFSET	2
 
+	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
 	struct hclge_vf_vlan_cfg *msg_cmd;
-	int status = 0;
 
 	msg_cmd = (struct hclge_vf_vlan_cfg *)&mbx_req->msg;
-	if (msg_cmd->subcode == HCLGE_MBX_VLAN_FILTER) {
-		struct hnae3_handle *handle = &vport->nic;
-		u16 vlan, proto;
-		bool is_kill;
-
-		is_kill = !!msg_cmd->is_kill;
-		vlan =  msg_cmd->vlan;
-		proto =  msg_cmd->proto;
-		status = hclge_set_vlan_filter(handle, cpu_to_be16(proto),
-					       vlan, is_kill);
-	} else if (msg_cmd->subcode == HCLGE_MBX_VLAN_RX_OFF_CFG) {
-		struct hnae3_handle *handle = &vport->nic;
-		bool en = msg_cmd->is_kill ? true : false;
-
-		status = hclge_en_hw_strip_rxvtag(handle, en);
-	} else if (msg_cmd->subcode == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
-		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(vport->nic.pdev);
+	switch (msg_cmd->subcode) {
+	case HCLGE_MBX_VLAN_FILTER:
+		return hclge_set_vlan_filter(handle,
+					     cpu_to_be16(msg_cmd->proto),
+					     msg_cmd->vlan, msg_cmd->is_kill);
+	case HCLGE_MBX_VLAN_RX_OFF_CFG:
+		return hclge_en_hw_strip_rxvtag(handle, msg_cmd->enable);
+	case HCLGE_MBX_GET_PORT_BASE_VLAN_STATE:
 		/* vf does not need to know about the port based VLAN state
 		 * on device HNAE3_DEVICE_VERSION_V3. So always return disable
 		 * on device HNAE3_DEVICE_VERSION_V3 if vf queries the port
 		 * based VLAN state.
 		 */
 		resp_msg->data[0] =
-			ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3 ?
+			hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3 ?
 			HNAE3_PORT_BASE_VLAN_DISABLE :
 			vport->port_base_vlan_cfg.state;
 		resp_msg->len = sizeof(u8);
+		return 0;
+	default:
+		return 0;
 	}
-
-	return status;
 }
 
 static int hclge_set_vf_alive(struct hclge_vport *vport,
-- 
2.7.4

