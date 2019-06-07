Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2F73827E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfFGCFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58412 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727935AbfFGCFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C41047189F11DF843D24;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 09/12] net: hns3: use macros instead of magic numbers
Date:   Fri, 7 Jun 2019 10:03:10 +0800
Message-ID: <1559872993-14507-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch adds some macros instead of magic numbers in serval places

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  5 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 10 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 53 ++++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 20 +++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  3 ++
 8 files changed, 75 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index d1588ea..22526ba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -60,6 +60,7 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 #define HNS3_NIC_LB_TEST_PKT_NUM	1
 #define HNS3_NIC_LB_TEST_RING_ID	0
 #define HNS3_NIC_LB_TEST_PACKET_SIZE	128
+#define HNS3_NIC_LB_SETUP_USEC		10000
 
 /* Nic loopback test err  */
 #define HNS3_NIC_LB_TEST_NO_MEM_ERR	1
@@ -117,7 +118,7 @@ static int hns3_lp_up(struct net_device *ndev, enum hnae3_loop loop_mode)
 		return ret;
 
 	ret = hns3_lp_setup(ndev, loop_mode, true);
-	usleep_range(10000, 20000);
+	usleep_range(HNS3_NIC_LB_SETUP_USEC, HNS3_NIC_LB_SETUP_USEC * 2);
 
 	return ret;
 }
@@ -132,7 +133,7 @@ static int hns3_lp_down(struct net_device *ndev, enum hnae3_loop loop_mode)
 		return ret;
 	}
 
-	usleep_range(10000, 20000);
+	usleep_range(HNS3_NIC_LB_SETUP_USEC, HNS3_NIC_LB_SETUP_USEC * 2);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 7d78b5a..c9fd730 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -649,6 +649,11 @@ enum hclge_mac_vlan_tbl_opcode {
 	HCLGE_MAC_VLAN_LKUP,    /* Lookup a entry through mac_vlan key */
 };
 
+enum hclge_mac_vlan_add_resp_code {
+	HCLGE_ADD_UC_OVERFLOW = 2,	/* ADD failed for UC overflow */
+	HCLGE_ADD_MC_OVERFLOW,		/* ADD failed for MC overflow */
+};
+
 #define HCLGE_MAC_VLAN_BIT0_EN_B	0
 #define HCLGE_MAC_VLAN_BIT1_EN_B	1
 #define HCLGE_MAC_EPORT_SW_EN_B		12
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index e1007d9..c2844e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -64,6 +64,8 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 				      char *cmd_buf, int msg_num, int offset,
 				      enum hclge_opcode_type cmd)
 {
+#define BD_DATA_NUM       6
+
 	struct hclge_desc *desc_src;
 	struct hclge_desc *desc;
 	int bd_num, buf_len;
@@ -92,14 +94,16 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 		return;
 	}
 
-	max = (bd_num * 6) <= msg_num ? (bd_num * 6) : msg_num;
+	max = (bd_num * BD_DATA_NUM) <= msg_num ?
+		(bd_num * BD_DATA_NUM) : msg_num;
 
 	desc = desc_src;
 	for (i = 0; i < max; i++) {
-		(((i / 6) > 0) && ((i % 6) == 0)) ? desc++ : desc;
+		((i > 0) && ((i % BD_DATA_NUM) == 0)) ? desc++ : desc;
 		if (dfx_message->flag)
 			dev_info(&hdev->pdev->dev, "%s: 0x%x\n",
-				 dfx_message->message, desc->data[i % 6]);
+				 dfx_message->message,
+				 desc->data[i % BD_DATA_NUM]);
 
 		dfx_message++;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 36a92a1..755cc43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -28,6 +28,8 @@
 #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 
 #define HCLGE_BUF_SIZE_UNIT	256
+#define HCLGE_BUF_MUL_BY	2
+#define HCLGE_BUF_DIV_BY	2
 
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
@@ -728,6 +730,8 @@ static int hclge_parse_func_status(struct hclge_dev *hdev,
 
 static int hclge_query_function_status(struct hclge_dev *hdev)
 {
+#define HCLGE_QUERY_MAX_CNT	5
+
 	struct hclge_func_status_cmd *req;
 	struct hclge_desc desc;
 	int timeout = 0;
@@ -750,7 +754,7 @@ static int hclge_query_function_status(struct hclge_dev *hdev)
 		if (req->pf_state)
 			break;
 		usleep_range(1000, 2000);
-	} while (timeout++ < 5);
+	} while (timeout++ < HCLGE_QUERY_MAX_CNT);
 
 	ret = hclge_parse_func_status(hdev, req);
 
@@ -1662,7 +1666,8 @@ static bool  hclge_is_rx_buf_ok(struct hclge_dev *hdev,
 	aligned_mps = roundup(hdev->mps, HCLGE_BUF_SIZE_UNIT);
 
 	if (hnae3_dev_dcb_supported(hdev))
-		shared_buf_min = 2 * aligned_mps + hdev->dv_buf_size;
+		shared_buf_min = HCLGE_BUF_MUL_BY * aligned_mps +
+					hdev->dv_buf_size;
 	else
 		shared_buf_min = aligned_mps + HCLGE_NON_DCB_ADDITIONAL_BUF
 					+ hdev->dv_buf_size;
@@ -1680,7 +1685,8 @@ static bool  hclge_is_rx_buf_ok(struct hclge_dev *hdev,
 	if (hnae3_dev_dcb_supported(hdev)) {
 		buf_alloc->s_buf.self.high = shared_buf - hdev->dv_buf_size;
 		buf_alloc->s_buf.self.low = buf_alloc->s_buf.self.high
-			- roundup(aligned_mps / 2, HCLGE_BUF_SIZE_UNIT);
+			- roundup(aligned_mps / HCLGE_BUF_DIV_BY,
+				  HCLGE_BUF_SIZE_UNIT);
 	} else {
 		buf_alloc->s_buf.self.high = aligned_mps +
 						HCLGE_NON_DCB_ADDITIONAL_BUF;
@@ -1693,9 +1699,9 @@ static bool  hclge_is_rx_buf_ok(struct hclge_dev *hdev,
 		else
 			hi_thrd = shared_buf - hdev->dv_buf_size;
 
-		hi_thrd = max_t(u32, hi_thrd, 2 * aligned_mps);
+		hi_thrd = max_t(u32, hi_thrd, HCLGE_BUF_MUL_BY * aligned_mps);
 		hi_thrd = rounddown(hi_thrd, HCLGE_BUF_SIZE_UNIT);
-		lo_thrd = hi_thrd - aligned_mps / 2;
+		lo_thrd = hi_thrd - aligned_mps / HCLGE_BUF_DIV_BY;
 	} else {
 		hi_thrd = aligned_mps + HCLGE_NON_DCB_ADDITIONAL_BUF;
 		lo_thrd = aligned_mps;
@@ -1756,12 +1762,13 @@ static bool hclge_rx_buf_calc_all(struct hclge_dev *hdev, bool max,
 		priv->enable = 1;
 
 		if (hdev->tm_info.hw_pfc_map & BIT(i)) {
-			priv->wl.low = max ? aligned_mps : 256;
+			priv->wl.low = max ? aligned_mps : HCLGE_BUF_SIZE_UNIT;
 			priv->wl.high = roundup(priv->wl.low + aligned_mps,
 						HCLGE_BUF_SIZE_UNIT);
 		} else {
 			priv->wl.low = 0;
-			priv->wl.high = max ? (aligned_mps * 2) : aligned_mps;
+			priv->wl.high = max ? (aligned_mps * HCLGE_BUF_MUL_BY) :
+					aligned_mps;
 		}
 
 		priv->buf_size = priv->wl.high + hdev->dv_buf_size;
@@ -3213,7 +3220,6 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 static bool hclge_reset_err_handle(struct hclge_dev *hdev, bool is_timeout)
 {
 #define MAX_RESET_FAIL_CNT 5
-#define RESET_UPGRADE_DELAY_SEC 10
 
 	if (hdev->reset_pending) {
 		dev_info(&hdev->pdev->dev, "Reset pending %lu\n",
@@ -3238,7 +3244,7 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev, bool is_timeout)
 		dev_info(&hdev->pdev->dev, "Upgrade reset level\n");
 		hclge_clear_reset_cause(hdev);
 		mod_timer(&hdev->reset_timer,
-			  jiffies + RESET_UPGRADE_DELAY_SEC * HZ);
+			  jiffies + HCLGE_RESET_INTERVAL);
 
 		return false;
 	}
@@ -3382,7 +3388,8 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	if (!handle)
 		handle = &hdev->vport[0].nic;
 
-	if (time_before(jiffies, (hdev->last_reset_time + 3 * HZ)))
+	if (time_before(jiffies, (hdev->last_reset_time +
+				  HCLGE_RESET_INTERVAL)))
 		return;
 	else if (hdev->default_reset_request)
 		hdev->reset_level =
@@ -6150,11 +6157,11 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 	if (op == HCLGE_MAC_VLAN_ADD) {
 		if ((!resp_code) || (resp_code == 1)) {
 			return_status = 0;
-		} else if (resp_code == 2) {
+		} else if (resp_code == HCLGE_ADD_UC_OVERFLOW) {
 			return_status = -ENOSPC;
 			dev_err(&hdev->pdev->dev,
 				"add mac addr failed for uc_overflow.\n");
-		} else if (resp_code == 3) {
+		} else if (resp_code == HCLGE_ADD_MC_OVERFLOW) {
 			return_status = -ENOSPC;
 			dev_err(&hdev->pdev->dev,
 				"add mac addr failed for mc_overflow.\n");
@@ -6199,13 +6206,15 @@ static int hclge_get_mac_vlan_cmd_status(struct hclge_vport *vport,
 
 static int hclge_update_desc_vfid(struct hclge_desc *desc, int vfid, bool clr)
 {
+#define HCLGE_VF_NUM_IN_FIRST_DESC 192
+
 	int word_num;
 	int bit_num;
 
 	if (vfid > 255 || vfid < 0)
 		return -EIO;
 
-	if (vfid >= 0 && vfid <= 191) {
+	if (vfid >= 0 && vfid < HCLGE_VF_NUM_IN_FIRST_DESC) {
 		word_num = vfid / 32;
 		bit_num  = vfid % 32;
 		if (clr)
@@ -6213,7 +6222,7 @@ static int hclge_update_desc_vfid(struct hclge_desc *desc, int vfid, bool clr)
 		else
 			desc[1].data[word_num] |= cpu_to_le32(1 << bit_num);
 	} else {
-		word_num = (vfid - 192) / 32;
+		word_num = (vfid - HCLGE_VF_NUM_IN_FIRST_DESC) / 32;
 		bit_num  = vfid % 32;
 		if (clr)
 			desc[2].data[word_num] &= cpu_to_le32(~(1 << bit_num));
@@ -8896,10 +8905,12 @@ static int hclge_get_32_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 				 void *data)
 {
 #define HCLGE_32_BIT_REG_RTN_DATANUM 8
+#define HCLGE_32_BIT_DESC_NODATA_LEN 2
 
 	struct hclge_desc *desc;
 	u32 *reg_val = data;
 	__le32 *desc_data;
+	int nodata_num;
 	int cmd_num;
 	int i, k, n;
 	int ret;
@@ -8907,7 +8918,9 @@ static int hclge_get_32_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 	if (regs_num == 0)
 		return 0;
 
-	cmd_num = DIV_ROUND_UP(regs_num + 2, HCLGE_32_BIT_REG_RTN_DATANUM);
+	nodata_num = HCLGE_32_BIT_DESC_NODATA_LEN;
+	cmd_num = DIV_ROUND_UP(regs_num + nodata_num,
+			       HCLGE_32_BIT_REG_RTN_DATANUM);
 	desc = kcalloc(cmd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
@@ -8924,7 +8937,7 @@ static int hclge_get_32_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 	for (i = 0; i < cmd_num; i++) {
 		if (i == 0) {
 			desc_data = (__le32 *)(&desc[i].data[0]);
-			n = HCLGE_32_BIT_REG_RTN_DATANUM - 2;
+			n = HCLGE_32_BIT_REG_RTN_DATANUM - nodata_num;
 		} else {
 			desc_data = (__le32 *)(&desc[i]);
 			n = HCLGE_32_BIT_REG_RTN_DATANUM;
@@ -8946,10 +8959,12 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 				 void *data)
 {
 #define HCLGE_64_BIT_REG_RTN_DATANUM 4
+#define HCLGE_64_BIT_DESC_NODATA_LEN 1
 
 	struct hclge_desc *desc;
 	u64 *reg_val = data;
 	__le64 *desc_data;
+	int nodata_len;
 	int cmd_num;
 	int i, k, n;
 	int ret;
@@ -8957,7 +8972,9 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 	if (regs_num == 0)
 		return 0;
 
-	cmd_num = DIV_ROUND_UP(regs_num + 1, HCLGE_64_BIT_REG_RTN_DATANUM);
+	nodata_len = HCLGE_64_BIT_DESC_NODATA_LEN;
+	cmd_num = DIV_ROUND_UP(regs_num + nodata_len,
+			       HCLGE_64_BIT_REG_RTN_DATANUM);
 	desc = kcalloc(cmd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
@@ -8974,7 +8991,7 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 	for (i = 0; i < cmd_num; i++) {
 		if (i == 0) {
 			desc_data = (__le64 *)(&desc[i].data[0]);
-			n = HCLGE_64_BIT_REG_RTN_DATANUM - 1;
+			n = HCLGE_64_BIT_REG_RTN_DATANUM - nodata_len;
 		} else {
 			desc_data = (__le64 *)(&desc[i]);
 			n = HCLGE_64_BIT_REG_RTN_DATANUM;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index f0d99d4..2189675 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -699,6 +699,8 @@ struct hclge_mac_tnl_stats {
 	u32 status;
 };
 
+#define HCLGE_RESET_INTERVAL	(10 * HZ)
+
 /* For each bit of TCAM entry, it uses a pair of 'x' and
  * 'y' to indicate which value to match, like below:
  * ----------------------------------
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index fac5193..c6d813c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -43,6 +43,9 @@ enum hclge_shaper_level {
 static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 				  u8 *ir_b, u8 *ir_u, u8 *ir_s)
 {
+#define DIVISOR_CLK		(1000 * 8)
+#define DIVISOR_IR_B_126	(126 * DIVISOR_CLK)
+
 	const u16 tick_array[HCLGE_SHAPER_LVL_CNT] = {
 		6 * 256,        /* Prioriy level */
 		6 * 32,         /* Prioriy group level */
@@ -66,7 +69,7 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 	 * ir_calc = ---------------- * 1000
 	 *		tick * 1
 	 */
-	ir_calc = (1008000 + (tick >> 1) - 1) / tick;
+	ir_calc = (DIVISOR_IR_B_126 + (tick >> 1) - 1) / tick;
 
 	if (ir_calc == ir) {
 		*ir_b = 126;
@@ -78,27 +81,28 @@ static int hclge_shaper_para_calc(u32 ir, u8 shaper_level,
 		/* Increasing the denominator to select ir_s value */
 		while (ir_calc > ir) {
 			ir_s_calc++;
-			ir_calc = 1008000 / (tick * (1 << ir_s_calc));
+			ir_calc = DIVISOR_IR_B_126 / (tick * (1 << ir_s_calc));
 		}
 
 		if (ir_calc == ir)
 			*ir_b = 126;
 		else
-			*ir_b = (ir * tick * (1 << ir_s_calc) + 4000) / 8000;
+			*ir_b = (ir * tick * (1 << ir_s_calc) +
+				 (DIVISOR_CLK >> 1)) / DIVISOR_CLK;
 	} else {
 		/* Increasing the numerator to select ir_u value */
 		u32 numerator;
 
 		while (ir_calc < ir) {
 			ir_u_calc++;
-			numerator = 1008000 * (1 << ir_u_calc);
+			numerator = DIVISOR_IR_B_126 * (1 << ir_u_calc);
 			ir_calc = (numerator + (tick >> 1)) / tick;
 		}
 
 		if (ir_calc == ir) {
 			*ir_b = 126;
 		} else {
-			u32 denominator = (8000 * (1 << --ir_u_calc));
+			u32 denominator = (DIVISOR_CLK * (1 << --ir_u_calc));
 			*ir_b = (ir * tick + (denominator >> 1)) / denominator;
 		}
 	}
@@ -604,12 +608,14 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
 
 static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 {
+#define BW_PERCENT	100
+
 	u8 i;
 
 	for (i = 0; i < hdev->tm_info.num_pg; i++) {
 		int k;
 
-		hdev->tm_info.pg_dwrr[i] = i ? 0 : 100;
+		hdev->tm_info.pg_dwrr[i] = i ? 0 : BW_PERCENT;
 
 		hdev->tm_info.pg_info[i].pg_id = i;
 		hdev->tm_info.pg_info[i].pg_sch_mode = HCLGE_SCH_MODE_DWRR;
@@ -621,7 +627,7 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 
 		hdev->tm_info.pg_info[i].tc_bit_map = hdev->hw_tc_map;
 		for (k = 0; k < hdev->tm_info.num_tc; k++)
-			hdev->tm_info.pg_info[i].tc_dwrr[k] = 100;
+			hdev->tm_info.pg_info[i].tc_dwrr[k] = BW_PERCENT;
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 121c4e5..7fd25ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1243,7 +1243,7 @@ static int hclgevf_set_vlan_filter(struct hnae3_handle *handle,
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	u8 msg_data[HCLGEVF_VLAN_MBX_MSG_LEN];
 
-	if (vlan_id > 4095)
+	if (vlan_id > HCLGEVF_MAX_VLAN_ID)
 		return -EINVAL;
 
 	if (proto != htons(ETH_P_8021Q))
@@ -1652,7 +1652,8 @@ static void hclgevf_service_timer(struct timer_list *t)
 {
 	struct hclgevf_dev *hdev = from_timer(hdev, t, service_timer);
 
-	mod_timer(&hdev->service_timer, jiffies + 5 * HZ);
+	mod_timer(&hdev->service_timer, jiffies +
+		  HCLGEVF_GENERAL_TASK_INTERVAL * HZ);
 
 	hdev->stats_timer++;
 	hclgevf_task_schedule(hdev);
@@ -1752,7 +1753,8 @@ static void hclgevf_keep_alive_timer(struct timer_list *t)
 	struct hclgevf_dev *hdev = from_timer(hdev, t, keep_alive_timer);
 
 	schedule_work(&hdev->keep_alive_task);
-	mod_timer(&hdev->keep_alive_timer, jiffies + 2 * HZ);
+	mod_timer(&hdev->keep_alive_timer, jiffies +
+		  HCLGEVF_KEEP_ALIVE_TASK_INTERVAL * HZ);
 }
 
 static void hclgevf_keep_alive_task(struct work_struct *work)
@@ -2084,7 +2086,8 @@ static int hclgevf_client_start(struct hnae3_handle *handle)
 	if (ret)
 		return ret;
 
-	mod_timer(&hdev->keep_alive_timer, jiffies + 2 * HZ);
+	mod_timer(&hdev->keep_alive_timer, jiffies +
+		  HCLGEVF_KEEP_ALIVE_TASK_INTERVAL * HZ);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index a7fbd38..4f86c87 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -12,9 +12,12 @@
 #define HCLGEVF_MOD_VERSION "1.0"
 #define HCLGEVF_DRIVER_NAME "hclgevf"
 
+#define HCLGEVF_MAX_VLAN_ID	4095
 #define HCLGEVF_MISC_VECTOR_NUM		0
 
 #define HCLGEVF_INVALID_VPORT		0xffff
+#define HCLGEVF_GENERAL_TASK_INTERVAL	  5
+#define HCLGEVF_KEEP_ALIVE_TASK_INTERVAL  2
 
 /* This number in actual depends upon the total number of VFs
  * created by physical function. But the maximum number of
-- 
2.7.4

