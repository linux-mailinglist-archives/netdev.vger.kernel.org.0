Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0CFEAEC3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfJaLXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbfJaLXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:03 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 243ED166494BE8CB9A62;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/9] net: hns3: cleanup some magic numbers
Date:   Thu, 31 Oct 2019 19:23:18 +0800
Message-ID: <1572521004-36126-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

To make the code more readable, this patch replaces
some magic numbers with macro or sizeof operation.

Also uses macro lower_32_bits and upper_32_bits to
get bits 0-31 and 32-63 of a number, instead of
using type conversion and '>>' operation.

No functional change.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 29 ++++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  9 +++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  3 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  8 +++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  4 ++-
 6 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 919911f..a4633d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
+#define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
 struct hclge_desc {
@@ -19,7 +20,7 @@ struct hclge_desc {
 	__le16 flag;
 	__le16 retval;
 	__le16 rsv;
-	__le32 data[6];
+	__le32 data[HCLGE_DESC_DATA_LEN];
 };
 
 struct hclge_cmq_ring {
@@ -429,8 +430,10 @@ struct hclge_rx_pkt_buf_cmd {
 #define HCLGE_PF_MAC_NUM_MASK	0x3
 #define HCLGE_PF_STATE_MAIN	BIT(HCLGE_PF_STATE_MAIN_B)
 #define HCLGE_PF_STATE_DONE	BIT(HCLGE_PF_STATE_DONE_B)
+#define HCLGE_VF_RST_STATUS_CMD	4
+
 struct hclge_func_status_cmd {
-	__le32  vf_rst_state[4];
+	__le32  vf_rst_state[HCLGE_VF_RST_STATUS_CMD];
 	u8 pf_state;
 	u8 mac_id;
 	u8 rsv1;
@@ -486,10 +489,12 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_UMV_TBL_SPACE_S	16
 #define HCLGE_CFG_UMV_TBL_SPACE_M	GENMASK(31, 16)
 
+#define HCLGE_CFG_CMD_CNT		4
+
 struct hclge_cfg_param_cmd {
 	__le32 offset;
 	__le32 rsv;
-	__le32 param[4];
+	__le32 param[HCLGE_CFG_CMD_CNT];
 };
 
 #define HCLGE_MAC_MODE		0x0
@@ -758,20 +763,27 @@ struct hclge_vlan_filter_ctrl_cmd {
 	u8 rsv2[19];
 };
 
+#define HCLGE_VLAN_ID_OFFSET_STEP	160
+#define HCLGE_VLAN_BYTE_SIZE		8
+#define	HCLGE_VLAN_OFFSET_BITMAP \
+	(HCLGE_VLAN_ID_OFFSET_STEP / HCLGE_VLAN_BYTE_SIZE)
+
 struct hclge_vlan_filter_pf_cfg_cmd {
 	u8 vlan_offset;
 	u8 vlan_cfg;
 	u8 rsv[2];
-	u8 vlan_offset_bitmap[20];
+	u8 vlan_offset_bitmap[HCLGE_VLAN_OFFSET_BITMAP];
 };
 
+#define HCLGE_MAX_VF_BYTES  16
+
 struct hclge_vlan_filter_vf_cfg_cmd {
 	__le16 vlan_id;
 	u8  resp_code;
 	u8  rsv;
 	u8  vlan_cfg;
 	u8  rsv1[3];
-	u8  vf_bitmap[16];
+	u8  vf_bitmap[HCLGE_MAX_VF_BYTES];
 };
 
 #define HCLGE_SWITCH_ANTI_SPOOF_B	0U
@@ -806,6 +818,7 @@ enum hclge_mac_vlan_cfg_sel {
 #define HCLGE_CFG_NIC_ROCE_SEL_B	4
 #define HCLGE_ACCEPT_TAG2_B		5
 #define HCLGE_ACCEPT_UNTAG2_B		6
+#define HCLGE_VF_NUM_PER_BYTE		8
 
 struct hclge_vport_vtag_tx_cfg_cmd {
 	u8 vport_vlan_cfg;
@@ -813,7 +826,7 @@ struct hclge_vport_vtag_tx_cfg_cmd {
 	u8 rsv1[2];
 	__le16 def_vlan_tag1;
 	__le16 def_vlan_tag2;
-	u8 vf_bitmap[8];
+	u8 vf_bitmap[HCLGE_VF_NUM_PER_BYTE];
 	u8 rsv2[8];
 };
 
@@ -825,7 +838,7 @@ struct hclge_vport_vtag_rx_cfg_cmd {
 	u8 vport_vlan_cfg;
 	u8 vf_offset;
 	u8 rsv1[6];
-	u8 vf_bitmap[8];
+	u8 vf_bitmap[HCLGE_VF_NUM_PER_BYTE];
 	u8 rsv2[8];
 };
 
@@ -864,7 +877,7 @@ struct hclge_mac_ethertype_idx_rd_cmd {
 	u8	flags;
 	u8	resp_code;
 	__le16  vlan_tag;
-	u8      mac_addr[6];
+	u8      mac_addr[ETH_ALEN];
 	__le16  index;
 	__le16	ethter_type;
 	__le16  egress_port;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 19667c9..dbdc245 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7744,8 +7744,6 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 				    bool is_kill, u16 vlan,
 				    __be16 proto)
 {
-#define HCLGE_MAX_VF_BYTES  16
-
 	struct hclge_vport *vport = &hdev->vport[vfid];
 	struct hclge_vlan_filter_vf_cfg_cmd *req0;
 	struct hclge_vlan_filter_vf_cfg_cmd *req1;
@@ -7845,9 +7843,10 @@ static int hclge_set_port_vlan_filter(struct hclge_dev *hdev, __be16 proto,
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_PF_CFG, false);
 
-	vlan_offset_160 = vlan_id / 160;
-	vlan_offset_byte = (vlan_id % 160) / 8;
-	vlan_offset_byte_val = 1 << (vlan_id % 8);
+	vlan_offset_160 = vlan_id / HCLGE_VLAN_ID_OFFSET_STEP;
+	vlan_offset_byte = (vlan_id % HCLGE_VLAN_ID_OFFSET_STEP) /
+			   HCLGE_VLAN_BYTE_SIZE;
+	vlan_offset_byte_val = 1 << (vlan_id % HCLGE_VLAN_BYTE_SIZE);
 
 	req = (struct hclge_vlan_filter_pf_cfg_cmd *)desc.data;
 	req->vlan_offset = vlan_offset_160;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 4386788..599f76a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -141,7 +141,6 @@
 
 /* Factor used to calculate offset and bitmap of VF num */
 #define HCLGE_VF_NUM_PER_CMD           64
-#define HCLGE_VF_NUM_PER_BYTE          8
 
 enum HLCGE_PORT_TYPE {
 	HOST_PORT,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 97463e11..088fc7c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -590,7 +590,8 @@ static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_data, &qid_in_pf, sizeof(qid_in_pf));
 
-	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data, 2);
+	return hclge_gen_resp_to_vf(vport, mbx_req, 0, resp_data,
+				    sizeof(resp_data));
 }
 
 static int hclge_get_rss_key(struct hclge_vport *vport,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index d5d1cc5..d261b5a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -92,9 +92,9 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 	u32 reg_val;
 
 	if (ring->flag == HCLGEVF_TYPE_CSQ) {
-		reg_val = (u32)ring->desc_dma_addr;
+		reg_val = lower_32_bits(ring->desc_dma_addr);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_L_REG, reg_val);
-		reg_val = (u32)((ring->desc_dma_addr >> 31) >> 1);
+		reg_val = upper_32_bits(ring->desc_dma_addr);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_H_REG, reg_val);
 
 		reg_val = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG);
@@ -105,9 +105,9 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
 	} else {
-		reg_val = (u32)ring->desc_dma_addr;
+		reg_val = lower_32_bits(ring->desc_dma_addr);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_L_REG, reg_val);
-		reg_val = (u32)((ring->desc_dma_addr >> 31) >> 1);
+		reg_val = upper_32_bits(ring->desc_dma_addr);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_H_REG, reg_val);
 
 		reg_val = (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index c38eba8..2f3f63b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1813,6 +1813,8 @@ static void hclgevf_service_timer(struct timer_list *t)
 
 static void hclgevf_reset_service_task(struct work_struct *work)
 {
+#define	HCLGEVF_MAX_RESET_ATTEMPTS_CNT	3
+
 	struct hclgevf_dev *hdev =
 		container_of(work, struct hclgevf_dev, rst_service_task);
 	int ret;
@@ -1865,7 +1867,7 @@ static void hclgevf_reset_service_task(struct work_struct *work)
 		 * We cannot do much for 2. but to check first we can try reset
 		 * our PCIe + stack and see if it alleviates the problem.
 		 */
-		if (hdev->reset_attempts > 3) {
+		if (hdev->reset_attempts > HCLGEVF_MAX_RESET_ATTEMPTS_CNT) {
 			/* prepare for full reset of stack + pcie interface */
 			set_bit(HNAE3_VF_FULL_RESET, &hdev->reset_pending);
 
-- 
2.7.4

