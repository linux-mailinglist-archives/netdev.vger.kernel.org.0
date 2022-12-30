Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54146657333
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiL1G2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiL1G16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:27:58 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7630CE20
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:27:56 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NhhPV3Hxjz16Lth;
        Wed, 28 Dec 2022 14:26:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 28 Dec 2022 14:27:54 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <huangguangbin2@huawei.com>,
        <tanhuazhong@huawei.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>, <lkp@intel.com>
Subject: [PATCH net v2] net: hns3: refine the handling for VF heartbeat
Date:   Wed, 28 Dec 2022 14:27:49 +0800
Message-ID: <20221228062749.58809-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the PF check the VF alive by the KEEP_ALVE
mailbox from VF. VF keep sending the mailbox per 2
seconds. Once PF lost the mailbox for more than 8
seconds, it will regards the VF is abnormal, and stop
notifying the state change to VF, include link state,
vf mac, reset, even though it receives the KEEP_ALIVE
mailbox again. It's inreasonable.

This patch fixes it. PF will record the state change which
need to notify VF when lost the VF's KEEP_ALIVE mailbox.
And notify VF when receive the mailbox again. Introduce a
new flag HCLGE_VPORT_STATE_INITED, used to distinguish the
case whether VF driver loaded or not. For VF will query
these states when initializing, so it's unnecessary to
notify it in this case.

Fixes: aa5c4f175be6 ("net: hns3: add reset handling for VF when doing PF reset")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 57 +++++++++++----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  7 ++
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 71 ++++++++++++++++---
 3 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6c2742f59c77..07ad5f35219e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3910,9 +3910,17 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 			return ret;
 		}
 
-		if (!reset || !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		if (!reset ||
+		    !test_bit(HCLGE_VPORT_STATE_INITED, &vport->state))
 			continue;
 
+		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) &&
+		    hdev->reset_type == HNAE3_FUNC_RESET) {
+			set_bit(HCLGE_VPORT_NEED_NOTIFY_RESET,
+				&vport->need_notify);
+			continue;
+		}
+
 		/* Inform VF to process the reset.
 		 * hclge_inform_reset_assert_to_vf may fail if VF
 		 * driver is not loaded.
@@ -4609,18 +4617,25 @@ static void hclge_reset_service_task(struct hclge_dev *hdev)
 
 static void hclge_update_vport_alive(struct hclge_dev *hdev)
 {
+#define HCLGE_ALIVE_SECONDS_NORMAL		8
+
+	unsigned long alive_time = HCLGE_ALIVE_SECONDS_NORMAL * HZ;
 	int i;
 
 	/* start from vport 1 for PF is always alive */
 	for (i = 1; i < hdev->num_alloc_vport; i++) {
 		struct hclge_vport *vport = &hdev->vport[i];
 
-		if (time_after(jiffies, vport->last_active_jiffies + 8 * HZ))
+		if (!test_bit(HCLGE_VPORT_STATE_INITED, &vport->state) ||
+		    !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+			continue;
+		if (time_after(jiffies, vport->last_active_jiffies +
+			       alive_time)) {
 			clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
-
-		/* If vf is not alive, set to default value */
-		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-			vport->mps = HCLGE_MAC_DEFAULT_FRAME;
+			dev_warn(&hdev->pdev->dev,
+				 "VF %u heartbeat timeout\n",
+				 i - HCLGE_VF_VPORT_START_NUM);
+		}
 	}
 }
 
@@ -8064,9 +8079,11 @@ int hclge_vport_start(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
 
+	set_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
 	set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 	set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 	vport->last_active_jiffies = jiffies;
+	vport->need_notify = 0;
 
 	if (test_bit(vport->vport_id, hdev->vport_config_block)) {
 		if (vport->vport_id) {
@@ -8084,7 +8101,9 @@ int hclge_vport_start(struct hclge_vport *vport)
 
 void hclge_vport_stop(struct hclge_vport *vport)
 {
+	clear_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
 	clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	vport->need_notify = 0;
 }
 
 static int hclge_client_start(struct hnae3_handle *handle)
@@ -9208,7 +9227,8 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 		return 0;
 	}
 
-	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
+	dev_info(&hdev->pdev->dev,
+		 "MAC of VF %d has been set to %s, will be active after VF reset\n",
 		 vf, format_mac_addr);
 	return 0;
 }
@@ -10465,12 +10485,16 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	 * for DEVICE_VERSION_V3, vf doesn't need to know about the port based
 	 * VLAN state.
 	 */
-	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
-	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-		(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-							vport->vport_id,
-							state, &vlan_info);
-
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3) {
+		if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+			(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+								vport->vport_id,
+								state,
+								&vlan_info);
+		else
+			set_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN,
+				&vport->need_notify);
+	}
 	return 0;
 }
 
@@ -11941,7 +11965,7 @@ static void hclge_reset_vport_state(struct hclge_dev *hdev)
 	int i;
 
 	for (i = 0; i < hdev->num_alloc_vport; i++) {
-		hclge_vport_stop(vport);
+		clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
 		vport++;
 	}
 }
@@ -12955,6 +12979,11 @@ static void hclge_clear_vport_vf_info(struct hclge_vport *vport, int vfid)
 	struct hclge_vlan_info vlan_info;
 	int ret;
 
+	clear_bit(HCLGE_VPORT_STATE_INITED, &vport->state);
+	clear_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+	vport->need_notify = 0;
+	vport->mps = 0;
+
 	/* after disable sriov, clean VF rate configured by PF */
 	ret = hclge_tm_qs_shaper_cfg(vport, 0);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 495b639b0dc2..13f23d606e77 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -995,9 +995,15 @@ enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 	HCLGE_VPORT_STATE_PROMISC_CHANGE,
 	HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
+	HCLGE_VPORT_STATE_INITED,
 	HCLGE_VPORT_STATE_MAX
 };
 
+enum HCLGE_VPORT_NEED_NOTIFY {
+	HCLGE_VPORT_NEED_NOTIFY_RESET,
+	HCLGE_VPORT_NEED_NOTIFY_VF_VLAN,
+};
+
 struct hclge_vlan_info {
 	u16 vlan_proto; /* so far support 802.1Q only */
 	u16 qos;
@@ -1044,6 +1050,7 @@ struct hclge_vport {
 	struct hnae3_handle roce;
 
 	unsigned long state;
+	unsigned long need_notify;
 	unsigned long last_active_jiffies;
 	u32 mps; /* Max packet size */
 	struct hclge_vf_info vf_info;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index a7b06c63143c..04ff9bf12185 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -124,17 +124,26 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	return status;
 }
 
+static int hclge_inform_vf_reset(struct hclge_vport *vport, u16 reset_type)
+{
+	__le16 msg_data;
+	u8 dest_vfid;
+
+	dest_vfid = (u8)vport->vport_id;
+	msg_data = cpu_to_le16(reset_type);
+
+	/* send this requested info to VF */
+	return hclge_send_mbx_msg(vport, (u8 *)&msg_data, sizeof(msg_data),
+				  HCLGE_MBX_ASSERTING_RESET, dest_vfid);
+}
+
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
-	__le16 msg_data;
 	u16 reset_type;
-	u8 dest_vfid;
 
 	BUILD_BUG_ON(HNAE3_MAX_RESET > U16_MAX);
 
-	dest_vfid = (u8)vport->vport_id;
-
 	if (hdev->reset_type == HNAE3_FUNC_RESET)
 		reset_type = HNAE3_VF_PF_FUNC_RESET;
 	else if (hdev->reset_type == HNAE3_FLR_RESET)
@@ -142,11 +151,7 @@ int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 	else
 		reset_type = HNAE3_VF_FUNC_RESET;
 
-	msg_data = cpu_to_le16(reset_type);
-
-	/* send this requested info to VF */
-	return hclge_send_mbx_msg(vport, (u8 *)&msg_data, sizeof(msg_data),
-				  HCLGE_MBX_ASSERTING_RESET, dest_vfid);
+	return hclge_inform_vf_reset(vport, reset_type);
 }
 
 static void hclge_free_vector_ring_chain(struct hnae3_ring_chain_node *head)
@@ -652,9 +657,56 @@ static int hclge_reset_vf(struct hclge_vport *vport)
 	return hclge_func_reset_cmd(hdev, vport->vport_id);
 }
 
+static void hclge_notify_vf_config(struct hclge_vport *vport)
+{
+	struct hclge_dev *hdev = vport->back;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclge_port_base_vlan_config *vlan_cfg;
+	int ret;
+
+	hclge_push_vf_link_status(vport);
+	if (test_bit(HCLGE_VPORT_NEED_NOTIFY_RESET, &vport->need_notify)) {
+		ret = hclge_inform_vf_reset(vport, HNAE3_VF_PF_FUNC_RESET);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to inform VF %u reset!",
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+			return;
+		}
+		vport->need_notify = 0;
+		return;
+	}
+
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
+	    test_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN, &vport->need_notify)) {
+		vlan_cfg = &vport->port_base_vlan_cfg;
+		ret = hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+							vport->vport_id,
+							vlan_cfg->state,
+							&vlan_cfg->vlan_info);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to inform VF %u port base vlan!",
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+			return;
+		}
+		clear_bit(HCLGE_VPORT_NEED_NOTIFY_VF_VLAN, &vport->need_notify);
+	}
+}
+
 static void hclge_vf_keep_alive(struct hclge_vport *vport)
 {
+	struct hclge_dev *hdev = vport->back;
+
 	vport->last_active_jiffies = jiffies;
+
+	if (test_bit(HCLGE_VPORT_STATE_INITED, &vport->state) &&
+	    !test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
+		set_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state);
+		dev_info(&hdev->pdev->dev, "VF %u is alive!",
+			 vport->vport_id - HCLGE_VF_VPORT_START_NUM);
+		hclge_notify_vf_config(vport);
+	}
 }
 
 static int hclge_set_vf_mtu(struct hclge_vport *vport,
@@ -954,6 +1006,7 @@ static int hclge_mbx_vf_uninit_handler(struct hclge_mbx_ops_param *param)
 	hclge_rm_vport_all_mac_table(param->vport, true,
 				     HCLGE_MAC_ADDR_MC);
 	hclge_rm_vport_all_vlan_table(param->vport, true);
+	param->vport->mps = 0;
 	return 0;
 }
 
-- 
2.30.0

