Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFA81DCC41
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgEULkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:40:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33910 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729085AbgEULj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 07:39:58 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C3C9CD1B1A2F89196F1F;
        Thu, 21 May 2020 19:39:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 21 May 2020 19:39:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        GuoJia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 2/2] net: hns3: add support for 'QoS' in port based VLAN configuration
Date:   Thu, 21 May 2020 19:38:25 +0800
Message-ID: <1590061105-36478-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GuoJia Liao <liaoguojia@huawei.com>

This patch adds support for 'QoS' in port based VLAN configuration.

Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 32 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 10 +++----
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bdacda4..936e3bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8546,7 +8546,7 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 
 static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 				  u16 port_base_vlan_state,
-				  u16 vlan_tag)
+				  u16 vlan_tag, u8 qos)
 {
 	int ret;
 
@@ -8557,7 +8557,8 @@ static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 	} else {
 		vport->txvlan_cfg.accept_tag1 = false;
 		vport->txvlan_cfg.insert_tag1_en = true;
-		vport->txvlan_cfg.default_tag1 = vlan_tag;
+		vport->txvlan_cfg.default_tag1 = (qos << VLAN_PRIO_SHIFT) |
+						 vlan_tag;
 	}
 
 	vport->txvlan_cfg.accept_untag1 = true;
@@ -8687,13 +8688,15 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		u16 vlan_tag;
+		u8 qos;
 
 		vport = &hdev->vport[i];
 		vlan_tag = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
+		qos = vport->port_base_vlan_cfg.vlan_info.qos;
 
 		ret = hclge_vlan_offload_cfg(vport,
 					     vport->port_base_vlan_cfg.state,
-					     vlan_tag);
+					     vlan_tag, qos);
 		if (ret)
 			return ret;
 	}
@@ -8979,7 +8982,8 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 
 	old_vlan_info = &vport->port_base_vlan_cfg.vlan_info;
 
-	ret = hclge_vlan_offload_cfg(vport, state, vlan_info->vlan_tag);
+	ret = hclge_vlan_offload_cfg(vport, state, vlan_info->vlan_tag,
+				     vlan_info->qos);
 	if (ret)
 		return ret;
 
@@ -9029,18 +9033,19 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 
 static u16 hclge_get_port_base_vlan_state(struct hclge_vport *vport,
 					  enum hnae3_port_base_vlan_state state,
-					  u16 vlan)
+					  u16 vlan, u8 qos)
 {
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE) {
-		if (!vlan)
+		if (!vlan && !qos)
 			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
 
 		return HNAE3_PORT_BASE_VLAN_ENABLE;
 	} else {
-		if (!vlan)
+		if (!vlan && !qos)
 			return HNAE3_PORT_BASE_VLAN_DISABLE;
 
-		if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan)
+		if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan &&
+		    vport->port_base_vlan_cfg.vlan_info.qos == qos)
 			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
 
 		return HNAE3_PORT_BASE_VLAN_MODIFY;
@@ -9054,7 +9059,6 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_vlan_info vlan_info;
 	u16 state;
-	int ret;
 
 	if (hdev->pdev->revision == 0x20)
 		return -EOPNOTSUPP;
@@ -9071,7 +9075,7 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 
 	state = hclge_get_port_base_vlan_state(vport,
 					       vport->port_base_vlan_cfg.state,
-					       vlan);
+					       vlan, qos);
 	if (state == HNAE3_PORT_BASE_VLAN_NOCHANGE)
 		return 0;
 
@@ -9083,11 +9087,9 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 		return hclge_update_port_base_vlan_cfg(vport, state,
 						       &vlan_info);
 	} else {
-		ret = hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-							vport->vport_id, state,
-							vlan, qos,
-							ntohs(proto));
-		return ret;
+		return hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+							 vport->vport_id,
+							 state, &vlan_info);
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 1a1a88a..2d69f98 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1026,8 +1026,8 @@ void hclge_restore_vport_vlan_table(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
-				      u16 state, u16 vlan_tag, u16 qos,
-				      u16 vlan_proto);
+				      u16 state,
+				      struct hclge_vlan_info *vlan_info);
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time);
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 				struct hclge_desc *desc);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0874ae4..b85c9b9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -319,17 +319,17 @@ static int hclge_set_vf_mc_mac_addr(struct hclge_vport *vport,
 }
 
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
-				      u16 state, u16 vlan_tag, u16 qos,
-				      u16 vlan_proto)
+				      u16 state,
+				      struct hclge_vlan_info *vlan_info)
 {
 #define MSG_DATA_SIZE	8
 
 	u8 msg_data[MSG_DATA_SIZE];
 
 	memcpy(&msg_data[0], &state, sizeof(u16));
-	memcpy(&msg_data[2], &vlan_proto, sizeof(u16));
-	memcpy(&msg_data[4], &qos, sizeof(u16));
-	memcpy(&msg_data[6], &vlan_tag, sizeof(u16));
+	memcpy(&msg_data[2], &vlan_info->vlan_proto, sizeof(u16));
+	memcpy(&msg_data[4], &vlan_info->qos, sizeof(u16));
+	memcpy(&msg_data[6], &vlan_info->vlan_tag, sizeof(u16));
 
 	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
 				  HCLGE_MBX_PUSH_VLAN_INFO, vfid);
-- 
2.7.4

