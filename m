Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510844E63CE
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350348AbiCXNB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350341AbiCXNB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:01:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69D890CD8;
        Thu, 24 Mar 2022 06:00:22 -0700 (PDT)
Received: from kwepemi100014.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPQLL36Ztz1GCvr;
        Thu, 24 Mar 2022 21:00:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100014.china.huawei.com (7.221.188.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 21:00:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/4] net: hns3: fix port base vlan add fail when concurrent with reset
Date:   Thu, 24 Mar 2022 20:54:48 +0800
Message-ID: <20220324125450.56417-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324125450.56417-1-huangguangbin2@huawei.com>
References: <20220324125450.56417-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, Port base vlan is initiated by PF and configured to its VFs,
by using command "ip link set <pf name> vf <vf id> vlan <vlan id>".
When a global reset was triggered, the hardware vlan table and the soft
recorded vlan information will be cleared by PF, and restored them until
VFs were ready. There is a short time window between the table had been
cleared and before table restored. If configured a new port base vlan tag
at this moment, driver will check the soft recorded vlan information,
and find there hasn't the old tag in it, which causing a warning print.

Due to the port base vlan is managed by PF, so the VFs's port base vlan
restoring should be handled by PF when PF was ready.

This patch fixes it.

Fixes: 039ba863e8d7 ("net: hns3: optimize the filter table entries handling when resetting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 62 +++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  3 +
 2 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4738c8da9297..d4fe92b22fb9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1863,6 +1863,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 		vport->vf_info.link_state = IFLA_VF_LINK_STATE_AUTO;
 		vport->mps = HCLGE_MAC_DEFAULT_FRAME;
 		vport->port_base_vlan_cfg.state = HNAE3_PORT_BASE_VLAN_DISABLE;
+		vport->port_base_vlan_cfg.tbl_sta = true;
 		vport->rxvlan_cfg.rx_vlan_offload_en = true;
 		vport->req_vlan_fltr_en = true;
 		INIT_LIST_HEAD(&vport->vlan_list);
@@ -9906,34 +9907,52 @@ void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev)
 	}
 }
 
-void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
+void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev)
 {
-	struct hclge_vport_vlan_cfg *vlan, *tmp;
-	struct hclge_dev *hdev = vport->back;
+	struct hclge_vlan_info *vlan_info;
+	struct hclge_vport *vport;
 	u16 vlan_proto;
 	u16 vlan_id;
 	u16 state;
+	int vf_id;
 	int ret;
 
-	vlan_proto = vport->port_base_vlan_cfg.vlan_info.vlan_proto;
-	vlan_id = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-	state = vport->port_base_vlan_cfg.state;
+	/* PF should restore all vfs port base vlan */
+	for (vf_id = 0; vf_id < hdev->num_alloc_vfs; vf_id++) {
+		vport = &hdev->vport[vf_id + HCLGE_VF_VPORT_START_NUM];
+		vlan_info = vport->port_base_vlan_cfg.tbl_sta ?
+			    &vport->port_base_vlan_cfg.vlan_info :
+			    &vport->port_base_vlan_cfg.old_vlan_info;
 
-	if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
-		clear_bit(vport->vport_id, hdev->vlan_table[vlan_id]);
-		hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
-					 vport->vport_id, vlan_id,
-					 false);
-		return;
+		vlan_id = vlan_info->vlan_tag;
+		vlan_proto = vlan_info->vlan_proto;
+		state = vport->port_base_vlan_cfg.state;
+
+		if (state != HNAE3_PORT_BASE_VLAN_DISABLE) {
+			clear_bit(vport->vport_id, hdev->vlan_table[vlan_id]);
+			ret = hclge_set_vlan_filter_hw(hdev, htons(vlan_proto),
+						       vport->vport_id,
+						       vlan_id, false);
+			vport->port_base_vlan_cfg.tbl_sta = ret == 0;
+		}
 	}
+}
 
-	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
-		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
-					       vport->vport_id,
-					       vlan->vlan_id, false);
-		if (ret)
-			break;
-		vlan->hd_tbl_status = true;
+void hclge_restore_vport_vlan_table(struct hclge_vport *vport)
+{
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
+		list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node) {
+			ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+						       vport->vport_id,
+						       vlan->vlan_id, false);
+			if (ret)
+				break;
+			vlan->hd_tbl_status = true;
+		}
 	}
 }
 
@@ -9974,6 +9993,7 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 	struct hnae3_handle *handle = &vport->nic;
 
 	hclge_restore_mac_table_common(vport);
+	hclge_restore_vport_port_base_vlan_config(hdev);
 	hclge_restore_vport_vlan_table(vport);
 	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
 	hclge_restore_fd_entries(handle);
@@ -10030,6 +10050,8 @@ static int hclge_update_vlan_filter_entries(struct hclge_vport *vport,
 						 false);
 	}
 
+	vport->port_base_vlan_cfg.tbl_sta = false;
+
 	/* force add VLAN 0 */
 	ret = hclge_set_vf_vlan_common(hdev, vport->vport_id, false, 0);
 	if (ret)
@@ -10119,7 +10141,9 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	else
 		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
 
+	vport->port_base_vlan_cfg.old_vlan_info = *old_vlan_info;
 	vport->port_base_vlan_cfg.vlan_info = *vlan_info;
+	vport->port_base_vlan_cfg.tbl_sta = true;
 	hclge_set_vport_vlan_fltr_change(vport);
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index adfb26e79262..31fef46b93b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -977,7 +977,9 @@ struct hclge_vlan_info {
 
 struct hclge_port_base_vlan_config {
 	u16 state;
+	bool tbl_sta;
 	struct hclge_vlan_info vlan_info;
+	struct hclge_vlan_info old_vlan_info;
 };
 
 struct hclge_vf_info {
@@ -1097,6 +1099,7 @@ void hclge_rm_vport_all_mac_table(struct hclge_vport *vport, bool is_del_list,
 void hclge_rm_vport_all_vlan_table(struct hclge_vport *vport, bool is_del_list);
 void hclge_uninit_vport_vlan_table(struct hclge_dev *hdev);
 void hclge_restore_mac_table_common(struct hclge_vport *vport);
+void hclge_restore_vport_port_base_vlan_config(struct hclge_dev *hdev);
 void hclge_restore_vport_vlan_table(struct hclge_vport *vport);
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info);
-- 
2.33.0

