Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144F83953F1
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhEaCkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:40:55 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3295 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhEaCks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FtfWR56BYz1BFVD;
        Mon, 31 May 2021 10:34:27 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: add 'QoS' support for port based VLAN configuration
Date:   Mon, 31 May 2021 10:38:38 +0800
Message-ID: <1622428725-30049-2-git-send-email-tanhuazhong@huawei.com>
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

Currently, option "qos" is igored by HNS3 driver for command
"ip link set ethx vf <vf id> vlan <vlan id> qos <qos value>".
Add support for it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 91 +++++++++++++++-------
 1 file changed, 63 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6addeb2..af5b278 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9724,7 +9724,7 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 
 static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 				  u16 port_base_vlan_state,
-				  u16 vlan_tag)
+				  u16 vlan_tag, u8 qos)
 {
 	int ret;
 
@@ -9738,7 +9738,8 @@ static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 		vport->txvlan_cfg.accept_tag1 =
 			ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3;
 		vport->txvlan_cfg.insert_tag1_en = true;
-		vport->txvlan_cfg.default_tag1 = vlan_tag;
+		vport->txvlan_cfg.default_tag1 = (qos << VLAN_PRIO_SHIFT) |
+						 vlan_tag;
 	}
 
 	vport->txvlan_cfg.accept_untag1 = true;
@@ -9867,13 +9868,15 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 
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
@@ -10084,6 +10087,10 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 
 	if (port_base_vlan_state == HNAE3_PORT_BASE_VLAN_ENABLE) {
 		hclge_rm_vport_all_vlan_table(vport, false);
+		/* force clear VLAN 0 */
+		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id, true, 0);
+		if (ret)
+			return ret;
 		return hclge_set_vlan_filter_hw(hdev,
 						 htons(new_info->vlan_proto),
 						 vport->vport_id,
@@ -10091,6 +10098,11 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 						 false);
 	}
 
+	/* force add VLAN 0 */
+	ret = hclge_set_vf_vlan_common(hdev, vport->vport_id, false, 0);
+	if (ret)
+		return ret;
+
 	ret = hclge_set_vlan_filter_hw(hdev, htons(old_info->vlan_proto),
 				       vport->vport_id, old_info->vlan_tag,
 				       true);
@@ -10100,6 +10112,18 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 	return hclge_add_vport_all_vlan_table(vport);
 }
 
+static bool hclge_need_update_vlan_filter(const struct hclge_vlan_info *new_cfg,
+					  const struct hclge_vlan_info *old_cfg)
+{
+	if (new_cfg->vlan_tag != old_cfg->vlan_tag)
+		return true;
+
+	if (new_cfg->vlan_tag == 0 && (new_cfg->qos == 0 || old_cfg->qos == 0))
+		return true;
+
+	return false;
+}
+
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info)
 {
@@ -10110,10 +10134,14 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 
 	old_vlan_info = &vport->port_base_vlan_cfg.vlan_info;
 
-	ret = hclge_vlan_offload_cfg(vport, state, vlan_info->vlan_tag);
+	ret = hclge_vlan_offload_cfg(vport, state, vlan_info->vlan_tag,
+				     vlan_info->qos);
 	if (ret)
 		return ret;
 
+	if (!hclge_need_update_vlan_filter(vlan_info, old_vlan_info))
+		goto out;
+
 	if (state == HNAE3_PORT_BASE_VLAN_MODIFY) {
 		/* add new VLAN tag */
 		ret = hclge_set_vlan_filter_hw(hdev,
@@ -10125,15 +10153,23 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 			return ret;
 
 		/* remove old VLAN tag */
-		ret = hclge_set_vlan_filter_hw(hdev,
-					       htons(old_vlan_info->vlan_proto),
-					       vport->vport_id,
-					       old_vlan_info->vlan_tag,
-					       true);
-		if (ret)
+		if (old_vlan_info->vlan_tag == 0)
+			ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
+						       true, 0);
+		else
+			ret = hclge_set_vlan_filter_hw(hdev,
+						       htons(ETH_P_8021Q),
+						       vport->vport_id,
+						       old_vlan_info->vlan_tag,
+						       true);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to clear vport%u port base vlan %u, ret = %d.\n",
+				vport->vport_id, old_vlan_info->vlan_tag, ret);
 			return ret;
+		}
 
-		goto update;
+		goto out;
 	}
 
 	ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
@@ -10141,38 +10177,37 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (ret)
 		return ret;
 
-	/* update state only when disable/enable port based VLAN */
+out:
 	vport->port_base_vlan_cfg.state = state;
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_DISABLE;
 	else
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
 
-update:
-	vport->port_base_vlan_cfg.vlan_info.vlan_tag = vlan_info->vlan_tag;
-	vport->port_base_vlan_cfg.vlan_info.qos = vlan_info->qos;
-	vport->port_base_vlan_cfg.vlan_info.vlan_proto = vlan_info->vlan_proto;
+	vport->port_base_vlan_cfg.vlan_info = *vlan_info;
 
 	return 0;
 }
 
 static u16 hclge_get_port_base_vlan_state(struct hclge_vport *vport,
 					  enum hnae3_port_base_vlan_state state,
-					  u16 vlan)
+					  u16 vlan, u8 qos)
 {
 	if (state == HNAE3_PORT_BASE_VLAN_DISABLE) {
-		if (!vlan)
+		if (!vlan && !qos)
 			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
-		else
-			return HNAE3_PORT_BASE_VLAN_ENABLE;
-	} else {
-		if (!vlan)
-			return HNAE3_PORT_BASE_VLAN_DISABLE;
-		else if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan)
-			return HNAE3_PORT_BASE_VLAN_NOCHANGE;
-		else
-			return HNAE3_PORT_BASE_VLAN_MODIFY;
+
+		return HNAE3_PORT_BASE_VLAN_ENABLE;
 	}
+
+	if (!vlan && !qos)
+		return HNAE3_PORT_BASE_VLAN_DISABLE;
+
+	if (vport->port_base_vlan_cfg.vlan_info.vlan_tag == vlan &&
+	    vport->port_base_vlan_cfg.vlan_info.qos == qos)
+		return HNAE3_PORT_BASE_VLAN_NOCHANGE;
+
+	return HNAE3_PORT_BASE_VLAN_MODIFY;
 }
 
 static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
@@ -10200,7 +10235,7 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 
 	state = hclge_get_port_base_vlan_state(vport,
 					       vport->port_base_vlan_cfg.state,
-					       vlan);
+					       vlan, qos);
 	if (state == HNAE3_PORT_BASE_VLAN_NOCHANGE)
 		return 0;
 
-- 
2.7.4

