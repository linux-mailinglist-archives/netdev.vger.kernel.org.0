Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248655F9A4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfGDOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:06:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfGDOGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:06:33 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F2A60F18719F914A0E8D;
        Thu,  4 Jul 2019 22:06:26 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 22:06:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 8/9] net: hns3: bitwise operator should use unsigned type
Date:   Thu, 4 Jul 2019 22:04:27 +0800
Message-ID: <1562249068-40176-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

There are some bitwise operator used signed type, this patch fixes
them with unsigned type.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  9 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 43 ++++++++++++----------
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ab5a339..310afa70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -951,8 +951,9 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 static void hns3_set_txbd_baseinfo(u16 *bdtp_fe_sc_vld_ra_ri, int frag_end)
 {
 	/* Config bd buffer end */
-	hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_FE_B, !!frag_end);
-	hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_VLD_B, 1);
+	if (!!frag_end)
+		hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_FE_B, 1U);
+	hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_VLD_B, 1U);
 }
 
 static int hns3_fill_desc_vtags(struct sk_buff *skb,
@@ -2575,7 +2576,7 @@ static bool hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
 	}
 }
 
-static int hns3_alloc_skb(struct hns3_enet_ring *ring, int length,
+static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 			  unsigned char *va)
 {
 #define HNS3_NEED_ADD_FRAG	1
@@ -2818,8 +2819,8 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 	struct sk_buff *skb = ring->skb;
 	struct hns3_desc_cb *desc_cb;
 	struct hns3_desc *desc;
+	unsigned int length;
 	u32 bd_base_info;
-	int length;
 	int ret;
 
 	desc = &ring->desc[ring->next_to_clean];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index a2b73d6..848b866 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -610,7 +610,7 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define hnae3_buf_size(_ring) ((_ring)->buf_size)
 #define hnae3_page_order(_ring) (get_order(hnae3_buf_size(_ring)))
-#define hnae3_page_size(_ring) (PAGE_SIZE << hnae3_page_order(_ring))
+#define hnae3_page_size(_ring) (PAGE_SIZE << (u32)hnae3_page_order(_ring))
 
 /* iterator for handling rings in ring group */
 #define hns3_for_each_ring(pos, head) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2abd5f5..3fde5471 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1360,8 +1360,9 @@ static int hclge_map_tqps_to_func(struct hclge_dev *hdev, u16 func_id,
 	req = (struct hclge_tqp_map_cmd *)desc.data;
 	req->tqp_id = cpu_to_le16(tqp_pid);
 	req->tqp_vf = func_id;
-	req->tqp_flag = !is_pf << HCLGE_TQP_MAP_TYPE_B |
-			1 << HCLGE_TQP_MAP_EN_B;
+	req->tqp_flag = 1U << HCLGE_TQP_MAP_EN_B;
+	if (!is_pf)
+		req->tqp_flag |= 1U << HCLGE_TQP_MAP_TYPE_B;
 	req->tqp_vid = cpu_to_le16(tqp_vid);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -2320,7 +2321,8 @@ static int hclge_set_autoneg_en(struct hclge_dev *hdev, bool enable)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_AN_MODE, false);
 
 	req = (struct hclge_config_auto_neg_cmd *)desc.data;
-	hnae3_set_bit(flag, HCLGE_MAC_CFG_AN_EN_B, !!enable);
+	if (enable)
+		hnae3_set_bit(flag, HCLGE_MAC_CFG_AN_EN_B, 1U);
 	req->cfg_an_cmd_flag = cpu_to_le32(flag);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -5935,20 +5937,20 @@ static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAC_MODE, false);
-	hnae3_set_bit(loop_en, HCLGE_MAC_TX_EN_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_RX_EN_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_PAD_TX_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_PAD_RX_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_1588_TX_B, 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_1588_RX_B, 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_APP_LP_B, 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_LINE_LP_B, 0);
-	hnae3_set_bit(loop_en, HCLGE_MAC_FCS_TX_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_RX_FCS_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B, enable);
-	hnae3_set_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B, enable);
+
+	if (enable) {
+		hnae3_set_bit(loop_en, HCLGE_MAC_TX_EN_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_RX_EN_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_PAD_TX_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_PAD_RX_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_FCS_TX_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_RX_FCS_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B, 1U);
+		hnae3_set_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B, 1U);
+	}
+
 	req->txrx_pad_fcs_loop_en = cpu_to_le32(loop_en);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -6310,8 +6312,8 @@ static int hclge_update_desc_vfid(struct hclge_desc *desc, int vfid, bool clr)
 {
 #define HCLGE_VF_NUM_IN_FIRST_DESC 192
 
-	int word_num;
-	int bit_num;
+	unsigned int word_num;
+	unsigned int bit_num;
 
 	if (vfid > 255 || vfid < 0)
 		return -EIO;
@@ -7972,7 +7974,8 @@ static int hclge_send_reset_tqp_cmd(struct hclge_dev *hdev, u16 queue_id,
 
 	req = (struct hclge_reset_tqp_queue_cmd *)desc.data;
 	req->tqp_id = cpu_to_le16(queue_id & HCLGE_RING_ID_MASK);
-	hnae3_set_bit(req->reset_req, HCLGE_TQP_RESET_B, enable);
+	if (enable)
+		hnae3_set_bit(req->reset_req, HCLGE_TQP_RESET_B, 1U);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-- 
2.7.4

