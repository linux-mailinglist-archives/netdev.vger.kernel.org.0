Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A646E48235C
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhLaK1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:45 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17317 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhLaK1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:41 -0500
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JQLsY4vwmz9s1J;
        Fri, 31 Dec 2021 18:26:41 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:39 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 03/13] net: hns3: use struct hclge_desc to replace hclgevf_desc in VF cmdq module
Date:   Fri, 31 Dec 2021 18:22:33 +0800
Message-ID: <20211231102243.3006-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
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

From: Jie Wang <wangjie125@huawei.com>

This patch use new common struct hclge_desc to replace struct hclgevf_desc
in VF cmdq module and then delete the old struct hclgevf_desc.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 22 +++++++++----------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       | 15 ++++---------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 22 +++++++++----------
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  4 ++--
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index e605c2c5bcce..416b6e41e988 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -123,7 +123,7 @@ static void hclgevf_cmd_init_regs(struct hclgevf_hw *hw)
 
 static int hclgevf_alloc_cmd_desc(struct hclgevf_cmq_ring *ring)
 {
-	int size = ring->desc_num * sizeof(struct hclgevf_desc);
+	int size = ring->desc_num * sizeof(struct hclge_desc);
 
 	ring->desc = dma_alloc_coherent(cmq_ring_to_dev(ring), size,
 					&ring->desc_dma_addr, GFP_KERNEL);
@@ -135,7 +135,7 @@ static int hclgevf_alloc_cmd_desc(struct hclgevf_cmq_ring *ring)
 
 static void hclgevf_free_cmd_desc(struct hclgevf_cmq_ring *ring)
 {
-	int size  = ring->desc_num * sizeof(struct hclgevf_desc);
+	int size  = ring->desc_num * sizeof(struct hclge_desc);
 
 	if (ring->desc) {
 		dma_free_coherent(cmq_ring_to_dev(ring), size,
@@ -163,10 +163,10 @@ static int hclgevf_alloc_cmd_queue(struct hclgevf_dev *hdev, int ring_type)
 	return ret;
 }
 
-void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
+void hclgevf_cmd_setup_basic_desc(struct hclge_desc *desc,
 				  enum hclgevf_opcode_type opcode, bool is_read)
 {
-	memset(desc, 0, sizeof(struct hclgevf_desc));
+	memset(desc, 0, sizeof(struct hclge_desc));
 	desc->opcode = cpu_to_le16(opcode);
 	desc->flag = cpu_to_le16(HCLGEVF_CMD_FLAG_NO_INTR |
 				 HCLGEVF_CMD_FLAG_IN);
@@ -182,9 +182,9 @@ struct vf_errcode {
 };
 
 static void hclgevf_cmd_copy_desc(struct hclgevf_hw *hw,
-				  struct hclgevf_desc *desc, int num)
+				  struct hclge_desc *desc, int num)
 {
-	struct hclgevf_desc *desc_to_use;
+	struct hclge_desc *desc_to_use;
 	int handle = 0;
 
 	while (handle < num) {
@@ -224,7 +224,7 @@ static int hclgevf_cmd_convert_err_code(u16 desc_ret)
 }
 
 static int hclgevf_cmd_check_retval(struct hclgevf_hw *hw,
-				    struct hclgevf_desc *desc, int num, int ntc)
+				    struct hclge_desc *desc, int num, int ntc)
 {
 	u16 opcode, desc_ret;
 	int handle;
@@ -247,7 +247,7 @@ static int hclgevf_cmd_check_retval(struct hclgevf_hw *hw,
 }
 
 static int hclgevf_cmd_check_result(struct hclgevf_hw *hw,
-				    struct hclgevf_desc *desc, int num, int ntc)
+				    struct hclge_desc *desc, int num, int ntc)
 {
 	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
 	bool is_completed = false;
@@ -291,7 +291,7 @@ static int hclgevf_cmd_check_result(struct hclgevf_hw *hw,
  * This is the main send command for command queue, it
  * sends the queue, cleans the queue, etc
  */
-int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
+int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
 {
 	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
 	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
@@ -377,7 +377,7 @@ static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_query_version_cmd *resp;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int status;
 
 	resp = (struct hclgevf_query_version_cmd *)desc.data;
@@ -437,7 +437,7 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 static int hclgevf_firmware_compat_config(struct hclgevf_dev *hdev, bool en)
 {
 	struct hclgevf_firmware_compat_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	u32 compat = 0;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_IMP_COMPAT_CFG, false);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index edc9e154061a..cb33eb806e78 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -6,6 +6,7 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include "hnae3.h"
+#include "hclge_comm_cmd.h"
 
 #define HCLGEVF_CMDQ_TX_TIMEOUT		30000
 #define HCLGEVF_CMDQ_CLEAR_WAIT_TIME	200
@@ -21,14 +22,6 @@ struct hclgevf_firmware_compat_cmd {
 	u8 rsv[20];
 };
 
-struct hclgevf_desc {
-	__le16 opcode;
-	__le16 flag;
-	__le16 retval;
-	__le16 rsv;
-	__le32 data[6];
-};
-
 struct hclgevf_desc_cb {
 	dma_addr_t dma;
 	void *va;
@@ -37,7 +30,7 @@ struct hclgevf_desc_cb {
 
 struct hclgevf_cmq_ring {
 	dma_addr_t desc_dma_addr;
-	struct hclgevf_desc *desc;
+	struct hclge_desc *desc;
 	struct hclgevf_desc_cb *desc_cb;
 	struct hclgevf_dev  *dev;
 	u32 head;
@@ -335,8 +328,8 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev);
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev);
 int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev);
 
-int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num);
-void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
+int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num);
+void hclgevf_cmd_setup_basic_desc(struct hclge_desc *desc,
 				  enum hclgevf_opcode_type opcode,
 				  bool is_read);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 0568cc31d391..28bdc9e38110 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -106,7 +106,7 @@ static int hclgevf_tqps_update_stats(struct hnae3_handle *handle)
 {
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	struct hclgevf_tqp *tqp;
 	int status;
 	int i;
@@ -611,7 +611,7 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 {
 	struct hclgevf_rss_config_cmd *req;
 	unsigned int key_offset = 0;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int key_counts;
 	int key_size;
 	int ret;
@@ -655,7 +655,7 @@ static int hclgevf_set_rss_indir_table(struct hclgevf_dev *hdev)
 {
 	const u8 *indir = hdev->rss_cfg.rss_indirection_tbl;
 	struct hclgevf_rss_indirection_table_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int rss_cfg_tbl_num;
 	int status;
 	int i, j;
@@ -692,7 +692,7 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 	u16 tc_offset[HCLGEVF_MAX_TC_NUM];
 	u16 tc_valid[HCLGEVF_MAX_TC_NUM];
 	u16 tc_size[HCLGEVF_MAX_TC_NUM];
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	u16 roundup_size;
 	unsigned int i;
 	int status;
@@ -961,7 +961,7 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	struct hclgevf_rss_input_tuple_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int ret;
 
 	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
@@ -1074,7 +1074,7 @@ static int hclgevf_set_rss_input_tuple(struct hclgevf_dev *hdev,
 				       struct hclgevf_rss_cfg *rss_cfg)
 {
 	struct hclgevf_rss_input_tuple_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int ret;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
@@ -1273,7 +1273,7 @@ static int hclgevf_tqp_enable_cmd_send(struct hclgevf_dev *hdev, u16 tqp_id,
 				       u16 stream_id, bool enable)
 {
 	struct hclgevf_cfg_com_tqp_queue_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 
 	req = (struct hclgevf_cfg_com_tqp_queue_cmd *)desc.data;
 
@@ -2572,7 +2572,7 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_cfg_gro_status_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int ret;
 
 	if (!hnae3_dev_gro_supported(hdev))
@@ -3121,7 +3121,7 @@ static void hclgevf_pci_uninit(struct hclgevf_dev *hdev)
 static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_query_res_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int ret;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_VF_RSRC, true);
@@ -3184,7 +3184,7 @@ static void hclgevf_set_default_dev_specs(struct hclgevf_dev *hdev)
 }
 
 static void hclgevf_parse_dev_specs(struct hclgevf_dev *hdev,
-				    struct hclgevf_desc *desc)
+				    struct hclge_desc *desc)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_dev_specs_0_cmd *req0;
@@ -3220,7 +3220,7 @@ static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
 
 static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_desc desc[HCLGEVF_QUERY_DEV_SPECS_BD_NUM];
+	struct hclge_desc desc[HCLGEVF_QUERY_DEV_SPECS_BD_NUM];
 	int ret;
 	int i;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index c5ac6ecf36e1..31cbdbae1faf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -97,7 +97,7 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 			 u8 *resp_data, u16 resp_len)
 {
 	struct hclge_mbx_vf_to_pf_cmd *req;
-	struct hclgevf_desc desc;
+	struct hclge_desc desc;
 	int status;
 
 	req = (struct hclge_mbx_vf_to_pf_cmd *)desc.data;
@@ -213,7 +213,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 {
 	struct hclge_mbx_pf_to_vf_cmd *req;
 	struct hclgevf_cmq_ring *crq;
-	struct hclgevf_desc *desc;
+	struct hclge_desc *desc;
 	u16 flag;
 
 	crq = &hdev->hw.cmq.crq;
-- 
2.33.0

