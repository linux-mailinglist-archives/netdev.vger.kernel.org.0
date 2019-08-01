Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28A17D43A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfHAD7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:59:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728217AbfHAD5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 78E2527F5D6C20CA1A0C;
        Thu,  1 Aug 2019 11:57:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: add link change event report
Date:   Thu, 1 Aug 2019 11:55:34 +0800
Message-ID: <1564631745-36733-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, PF updates link status per second. For some scenario,
it requires link down event being reported more quickly.
To solve it, firmware pushes the link change event to PF with
CMDQ message, and driver updates the link status directly.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 25 ++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  7 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  9 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 ++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 33 ++++++++++++++++++++++
 6 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 75329ab..1564be5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -47,6 +47,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf reset status */
+	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
 };
 
 /* below are per-VF mac-vlan subcodes */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index d9858f2..538d101 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -383,6 +383,22 @@ int hclge_cmd_queue_init(struct hclge_dev *hdev)
 	return ret;
 }
 
+static int hclge_firmware_compat_config(struct hclge_dev *hdev)
+{
+	struct hclge_firmware_compat_cmd *req;
+	struct hclge_desc desc;
+	u32 compat = 0;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_M7_COMPAT_CFG, false);
+
+	req = (struct hclge_firmware_compat_cmd *)desc.data;
+
+	hnae3_set_bit(compat, HCLGE_LINK_EVENT_REPORT_EN_B, 1);
+	req->compat = cpu_to_le32(compat);
+
+	return hclge_cmd_send(&hdev->hw, &desc, 1);
+}
+
 int hclge_cmd_init(struct hclge_dev *hdev)
 {
 	u32 version;
@@ -429,6 +445,15 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
 				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
+	/* ask the firmware to enable some features, driver can work without
+	 * it.
+	 */
+	ret = hclge_firmware_compat_config(hdev);
+	if (ret)
+		dev_warn(&hdev->pdev->dev,
+			 "Firmware compatible features not enabled(%d).\n",
+			 ret);
+
 	return 0;
 
 err_cmd_init:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 96840d8..743c9f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -257,6 +257,7 @@ enum hclge_opcode_type {
 	/* M7 stats command */
 	HCLGE_OPC_M7_STATS_BD		= 0x7012,
 	HCLGE_OPC_M7_STATS_INFO		= 0x7013,
+	HCLGE_OPC_M7_COMPAT_CFG		= 0x701A,
 
 	/* SFP command */
 	HCLGE_OPC_GET_SFP_INFO		= 0x7104,
@@ -1009,6 +1010,12 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 	u8 rsv[4];
 };
 
+#define HCLGE_LINK_EVENT_REPORT_EN_B	0
+struct hclge_firmware_compat_cmd {
+	__le32 compat;
+	u8 rsv[20];
+};
+
 int hclge_cmd_init(struct hclge_dev *hdev);
 static inline void hclge_write_reg(void __iomem *base, u32 reg, u32 value)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4138780..855b65e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2517,7 +2517,7 @@ static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 			      &hdev->rst_service_task);
 }
 
-static void hclge_task_schedule(struct hclge_dev *hdev)
+void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
 	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
 	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
@@ -2526,7 +2526,7 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
 		hdev->fd_arfs_expire_timer++;
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
 				    system_wq, &hdev->service_task,
-				    round_jiffies_relative(HZ));
+				    delay_time);
 	}
 }
 
@@ -3636,7 +3636,7 @@ static void hclge_service_task(struct work_struct *work)
 		hdev->fd_arfs_expire_timer = 0;
 	}
 
-	hclge_task_schedule(hdev);
+	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 }
 
 struct hclge_vport *hclge_get_vport(struct hnae3_handle *handle)
@@ -6175,7 +6175,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 	struct hclge_dev *hdev = vport->back;
 
 	if (enable) {
-		hclge_task_schedule(hdev);
+		hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 	} else {
 		/* Set the DOWN flag here to disable the service to be
 		 * scheduled again
@@ -6220,6 +6220,7 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) &&
 	    hdev->reset_type != HNAE3_FUNC_RESET) {
 		hclge_mac_stop_phy(hdev);
+		hclge_update_link_status(hdev);
 		return;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 688e425..c9b9867f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -302,6 +302,13 @@ enum hclge_fc_mode {
 	HCLGE_FC_DEFAULT
 };
 
+enum hclge_link_fail_code {
+	HCLGE_LF_NORMAL,
+	HCLGE_LF_REF_CLOCK_LOST,
+	HCLGE_LF_XSFP_TX_DISABLE,
+	HCLGE_LF_XSFP_ABSENT,
+};
+
 #define HCLGE_PG_NUM		4
 #define HCLGE_SCH_MODE_SP	0
 #define HCLGE_SCH_MODE_DWRR	1
@@ -1021,4 +1028,5 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 				      u16 state, u16 vlan_tag, u16 qos,
 				      u16 vlan_proto);
+void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 690b999..87de32d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -545,6 +545,36 @@ static int hclge_get_rss_key(struct hclge_vport *vport,
 				    HCLGE_RSS_MBX_RESP_LEN);
 }
 
+static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
+{
+	switch (link_fail_code) {
+	case HCLGE_LF_REF_CLOCK_LOST:
+		dev_warn(&hdev->pdev->dev, "Reference clock lost!\n");
+		break;
+	case HCLGE_LF_XSFP_TX_DISABLE:
+		dev_warn(&hdev->pdev->dev, "SFP tx is disabled!\n");
+		break;
+	case HCLGE_LF_XSFP_ABSENT:
+		dev_warn(&hdev->pdev->dev, "SFP is absent!\n");
+		break;
+	default:
+		break;
+	}
+}
+
+static void hclge_handle_link_change_event(struct hclge_dev *hdev,
+					   struct hclge_mbx_vf_to_pf_cmd *req)
+{
+#define LINK_STATUS_OFFSET	1
+#define LINK_FAIL_CODE_OFFSET	2
+
+	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
+	hclge_task_schedule(hdev, 0);
+
+	if (!req->msg[LINK_STATUS_OFFSET])
+		hclge_link_fail_parse(hdev, req->msg[LINK_FAIL_CODE_OFFSET]);
+}
+
 static bool hclge_cmd_crq_empty(struct hclge_hw *hw)
 {
 	u32 tail = hclge_read_dev(hw, HCLGE_NIC_CRQ_TAIL_REG);
@@ -707,6 +737,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"PF fail(%d) to media type for VF\n",
 					ret);
 			break;
+		case HCLGE_MBX_PUSH_LINK_STATUS:
+			hclge_handle_link_change_event(hdev, req);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"un-supported mailbox message, code = %d\n",
-- 
2.7.4

