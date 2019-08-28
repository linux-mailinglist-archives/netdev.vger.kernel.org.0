Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0883FA04D1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfH1O0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726857AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2A0C48B96A2FB2AA8AF1;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: implement .process_hw_error for hns3 client
Date:   Wed, 28 Aug 2019 22:23:13 +0800
Message-ID: <1567002196-63242-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

When hardware or IMP get specified error it may need the client
to take some special operations.

This patch implements the hns3 client's process_hw_errorx.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  9 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 24 ++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  5 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  4 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 33 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +++
 7 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 3e21533..c4b7bf8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -146,6 +146,12 @@ enum hnae3_reset_notify_type {
 	HNAE3_RESTORE_CLIENT,
 };
 
+enum hnae3_hw_error_type {
+	HNAE3_PPU_POISON_ERROR,
+	HNAE3_CMDQ_ECC_ERROR,
+	HNAE3_IMP_RD_POISON_ERROR,
+};
+
 enum hnae3_reset_type {
 	HNAE3_VF_RESET,
 	HNAE3_VF_FUNC_RESET,
@@ -210,7 +216,8 @@ struct hnae3_client_ops {
 	int (*setup_tc)(struct hnae3_handle *handle, u8 tc);
 	int (*reset_notify)(struct hnae3_handle *handle,
 			    enum hnae3_reset_notify_type type);
-	enum hnae3_reset_type (*process_hw_error)(struct hnae3_handle *handle);
+	void (*process_hw_error)(struct hnae3_handle *handle,
+				 enum hnae3_hw_error_type);
 };
 
 #define HNAE3_CLIENT_NAME_LENGTH 16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a11d514..9f3f8e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4470,12 +4470,36 @@ int hns3_set_channels(struct net_device *netdev,
 	return hns3_reset_notify(h, HNAE3_UP_CLIENT);
 }
 
+static const struct hns3_hw_error_info hns3_hw_err[] = {
+	{ .type = HNAE3_PPU_POISON_ERROR,
+	  .msg = "PPU poison" },
+	{ .type = HNAE3_CMDQ_ECC_ERROR,
+	  .msg = "IMP CMDQ error" },
+	{ .type = HNAE3_IMP_RD_POISON_ERROR,
+	  .msg = "IMP RD poison" },
+};
+
+static void hns3_process_hw_error(struct hnae3_handle *handle,
+				  enum hnae3_hw_error_type type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hns3_hw_err); i++) {
+		if (hns3_hw_err[i].type == type) {
+			dev_err(&handle->pdev->dev, "Detected %s!\n",
+				hns3_hw_err[i].msg);
+			break;
+		}
+	}
+}
+
 static const struct hnae3_client_ops client_ops = {
 	.init_instance = hns3_client_init,
 	.uninit_instance = hns3_client_uninit,
 	.link_status_change = hns3_link_status_change,
 	.setup_tc = hns3_client_setup_tc,
 	.reset_notify = hns3_reset_notify,
+	.process_hw_error = hns3_process_hw_error,
 };
 
 /* hns3_init_module - Driver registration routine
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index e37e64e..2110fa3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -552,6 +552,11 @@ union l4_hdr_info {
 	unsigned char *hdr;
 };
 
+struct hns3_hw_error_info {
+	enum hnae3_hw_error_type type;
+	const char *msg;
+};
+
 static inline int ring_space(struct hns3_enet_ring *ring)
 {
 	/* This smp_load_acquire() pairs with smp_store_release() in
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index d986c36..58c6231 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1325,10 +1325,12 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 	/* log PPU(RCB) errors */
 	desc_data = (__le32 *)&desc[3];
 	status = le32_to_cpu(*desc_data) & HCLGE_PPU_PF_INT_RAS_MASK;
-	if (status)
+	if (status) {
 		hclge_log_error(dev, "PPU_PF_ABNORMAL_INT_ST0",
 				&hclge_ppu_pf_abnormal_int[0], status,
 				&ae_dev->hw_err_reset_req);
+		hclge_report_hw_error(hdev, HNAE3_PPU_POISON_ERROR);
+	}
 
 	/* clear all PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 7ea8bb2..876fd81a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -5,6 +5,7 @@
 #define __HCLGE_ERR_H
 
 #include "hclge_main.h"
+#include "hnae3.h"
 
 #define HCLGE_MPF_RAS_INT_MIN_BD_NUM	10
 #define HCLGE_PF_RAS_INT_MIN_BD_NUM	4
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f43c298..9ef1f468 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3265,6 +3265,38 @@ static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 	return -ETIME;
 }
 
+void hclge_report_hw_error(struct hclge_dev *hdev,
+			   enum hnae3_hw_error_type type)
+{
+	struct hnae3_client *client = hdev->nic_client;
+	u16 i;
+
+	if (!client || !client->ops->process_hw_error ||
+	    !test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state))
+		return;
+
+	for (i = 0; i < hdev->num_vmdq_vport + 1; i++)
+		client->ops->process_hw_error(&hdev->vport[i].nic, type);
+}
+
+static void hclge_handle_imp_error(struct hclge_dev *hdev)
+{
+	u32 reg_val;
+
+	reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
+	if (reg_val & BIT(HCLGE_VECTOR0_IMP_RD_POISON_B)) {
+		hclge_report_hw_error(hdev, HNAE3_IMP_RD_POISON_ERROR);
+		reg_val &= ~BIT(HCLGE_VECTOR0_IMP_RD_POISON_B);
+		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, reg_val);
+	}
+
+	if (reg_val & BIT(HCLGE_VECTOR0_IMP_CMDQ_ERR_B)) {
+		hclge_report_hw_error(hdev, HNAE3_CMDQ_ECC_ERROR);
+		reg_val &= ~BIT(HCLGE_VECTOR0_IMP_CMDQ_ERR_B);
+		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG, reg_val);
+	}
+}
+
 int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id)
 {
 	struct hclge_desc desc;
@@ -3471,6 +3503,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		hdev->rst_stats.flr_rst_cnt++;
 		break;
 	case HNAE3_IMP_RESET:
+		hclge_handle_imp_error(hdev);
 		reg_val = hclge_read_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG);
 		hclge_write_dev(&hdev->hw, HCLGE_PF_OTHER_INT_REG,
 				BIT(HCLGE_VECTOR0_IMP_RESET_INT_B) | reg_val);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 00c07f8..a3bc382 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -178,6 +178,8 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_RX_CMDQ_INT_B	1
 
 #define HCLGE_VECTOR0_IMP_RESET_INT_B	1
+#define HCLGE_VECTOR0_IMP_CMDQ_ERR_B	4U
+#define HCLGE_VECTOR0_IMP_RD_POISON_B	5U
 
 #define HCLGE_MAC_DEFAULT_FRAME \
 	(ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN + ETH_DATA_LEN)
@@ -986,4 +988,6 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time);
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
 				struct hclge_desc *desc);
+void hclge_report_hw_error(struct hclge_dev *hdev,
+			   enum hnae3_hw_error_type type);
 #endif
-- 
2.7.4

