Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CCA465FAD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbhLBIoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:10 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16336 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345664AbhLBIoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:07 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J4Tt258xpz91WJ;
        Thu,  2 Dec 2021 16:40:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:44 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 3/9] net: hns3: split function hclge_init_vlan_config()
Date:   Thu, 2 Dec 2021 16:35:57 +0800
Message-ID: <20211202083603.25176-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently the function hclge_init_vlan_config() is a bit long.
Split it to several small functions, to simplify code and
improve code readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 97 +++++++++++--------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7de4c56ef014..fd8988d77d06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10194,67 +10194,80 @@ static int hclge_set_vlan_protocol_type(struct hclge_dev *hdev)
 	return status;
 }
 
-static int hclge_init_vlan_config(struct hclge_dev *hdev)
+static int hclge_init_vlan_filter(struct hclge_dev *hdev)
 {
-#define HCLGE_DEF_VLAN_TYPE		0x8100
-
-	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	struct hclge_vport *vport;
 	int ret;
 	int i;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		/* for revision 0x21, vf vlan filter is per function */
-		for (i = 0; i < hdev->num_alloc_vport; i++) {
-			vport = &hdev->vport[i];
-			ret = hclge_set_vlan_filter_ctrl(hdev,
-							 HCLGE_FILTER_TYPE_VF,
-							 HCLGE_FILTER_FE_EGRESS,
-							 true,
-							 vport->vport_id);
-			if (ret)
-				return ret;
-			vport->cur_vlan_fltr_en = true;
-		}
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
+		return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+						  HCLGE_FILTER_FE_EGRESS_V1_B,
+						  true, 0);
 
-		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
-						 HCLGE_FILTER_FE_INGRESS, true,
-						 0);
-		if (ret)
-			return ret;
-	} else {
+	/* for revision 0x21, vf vlan filter is per function */
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
 		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
-						 HCLGE_FILTER_FE_EGRESS_V1_B,
-						 true, 0);
+						 HCLGE_FILTER_FE_EGRESS, true,
+						 vport->vport_id);
 		if (ret)
 			return ret;
+		vport->cur_vlan_fltr_en = true;
 	}
 
-	hdev->vlan_type_cfg.rx_in_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_in_sec_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_ot_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_ot_sec_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.tx_ot_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.tx_in_vlan_type = HCLGE_DEF_VLAN_TYPE;
+	return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
+					  HCLGE_FILTER_FE_INGRESS, true, 0);
+}
 
-	ret = hclge_set_vlan_protocol_type(hdev);
-	if (ret)
-		return ret;
+static int hclge_init_vlan_type(struct hclge_dev *hdev)
+{
+	hdev->vlan_type_cfg.rx_in_fst_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_in_sec_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_ot_fst_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_ot_sec_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.tx_ot_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.tx_in_vlan_type = ETH_P_8021Q;
 
-	for (i = 0; i < hdev->num_alloc_vport; i++) {
-		u16 vlan_tag;
-		u8 qos;
+	return hclge_set_vlan_protocol_type(hdev);
+}
 
+static int hclge_init_vport_vlan_offload(struct hclge_dev *hdev)
+{
+	struct hclge_port_base_vlan_config *cfg;
+	struct hclge_vport *vport;
+	int ret;
+	int i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
-		vlan_tag = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-		qos = vport->port_base_vlan_cfg.vlan_info.qos;
+		cfg = &vport->port_base_vlan_cfg;
 
-		ret = hclge_vlan_offload_cfg(vport,
-					     vport->port_base_vlan_cfg.state,
-					     vlan_tag, qos);
+		ret = hclge_vlan_offload_cfg(vport, cfg->state,
+					     cfg->vlan_info.vlan_tag,
+					     cfg->vlan_info.qos);
 		if (ret)
 			return ret;
 	}
+	return 0;
+}
+
+static int hclge_init_vlan_config(struct hclge_dev *hdev)
+{
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
+	int ret;
+
+	ret = hclge_init_vlan_filter(hdev);
+	if (ret)
+		return ret;
+
+	ret = hclge_init_vlan_type(hdev);
+	if (ret)
+		return ret;
+
+	ret = hclge_init_vport_vlan_offload(hdev);
+	if (ret)
+		return ret;
 
 	return hclge_set_vlan_filter(handle, htons(ETH_P_8021Q), 0, false);
 }
-- 
2.33.0

