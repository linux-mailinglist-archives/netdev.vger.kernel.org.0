Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADAD59986
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfF1LxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:53:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7677 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbfF1LwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:09 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F1ECDB8DA3BAFCC954CE;
        Fri, 28 Jun 2019 19:52:05 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:51:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: change SSU's buffer allocation according to UM
Date:   Fri, 28 Jun 2019 19:50:09 +0800
Message-ID: <1561722618-12168-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently when there is share buffer in the SSU(storage
switching unit), the low waterline for RX private buffer is
too low to keep the hardware running. Hardware may have
processed all the packet stored in the private buffer of the
low waterline before the new packet comes, because hardware
only tell the peer send packet again when the private buffer
is under the low waterline.

So this patch only allocate RX private buffer if there is
enough buffer according to hardware user manual.

This patch also reserve some buffer for reusing when TC num
is less than or equal to 2, and change PAUSE_TRANS_GAP &
HCLGE_NON_DCB_ADDITIONAL_BUF according to hardware user
manual.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 65 +++++++++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  2 +-
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index cf52cdf..d23ab2b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -884,7 +884,7 @@ struct hclge_serdes_lb_cmd {
 #define HCLGE_TOTAL_PKT_BUF		0x108000 /* 1.03125M bytes */
 #define HCLGE_DEFAULT_DV		0xA000	 /* 40k byte */
 #define HCLGE_DEFAULT_NON_DCB_DV	0x7800	/* 30K byte */
-#define HCLGE_NON_DCB_ADDITIONAL_BUF	0x200	/* 512 byte */
+#define HCLGE_NON_DCB_ADDITIONAL_BUF	0x1400	/* 5120 byte */
 
 #define HCLGE_TYPE_CRQ			0
 #define HCLGE_TYPE_CSQ			1
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b25365c..a2401c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -30,6 +30,9 @@
 #define HCLGE_BUF_SIZE_UNIT	256U
 #define HCLGE_BUF_MUL_BY	2
 #define HCLGE_BUF_DIV_BY	2
+#define NEED_RESERVE_TC_NUM	2
+#define BUF_MAX_PERCENT		100
+#define BUF_RESERVE_PERCENT	90
 
 #define HCLGE_RESET_MAX_FAIL_CNT	5
 
@@ -1694,10 +1697,14 @@ static bool  hclge_is_rx_buf_ok(struct hclge_dev *hdev,
 	}
 
 	if (hnae3_dev_dcb_supported(hdev)) {
+		hi_thrd = shared_buf - hdev->dv_buf_size;
+
+		if (tc_num <= NEED_RESERVE_TC_NUM)
+			hi_thrd = hi_thrd * BUF_RESERVE_PERCENT
+					/ BUF_MAX_PERCENT;
+
 		if (tc_num)
-			hi_thrd = (shared_buf - hdev->dv_buf_size) / tc_num;
-		else
-			hi_thrd = shared_buf - hdev->dv_buf_size;
+			hi_thrd = hi_thrd / tc_num;
 
 		hi_thrd = max_t(u32, hi_thrd, HCLGE_BUF_MUL_BY * aligned_mps);
 		hi_thrd = rounddown(hi_thrd, HCLGE_BUF_SIZE_UNIT);
@@ -1837,6 +1844,55 @@ static bool hclge_drop_pfc_buf_till_fit(struct hclge_dev *hdev,
 	return hclge_is_rx_buf_ok(hdev, buf_alloc, rx_all);
 }
 
+static int hclge_only_alloc_priv_buff(struct hclge_dev *hdev,
+				      struct hclge_pkt_buf_alloc *buf_alloc)
+{
+#define COMPENSATE_BUFFER	0x3C00
+#define COMPENSATE_HALF_MPS_NUM	5
+#define PRIV_WL_GAP		0x1800
+
+	u32 rx_priv = hdev->pkt_buf_size - hclge_get_tx_buff_alloced(buf_alloc);
+	u32 tc_num = hclge_get_tc_num(hdev);
+	u32 half_mps = hdev->mps >> 1;
+	u32 min_rx_priv;
+	unsigned int i;
+
+	if (tc_num)
+		rx_priv = rx_priv / tc_num;
+
+	if (tc_num <= NEED_RESERVE_TC_NUM)
+		rx_priv = rx_priv * BUF_RESERVE_PERCENT / BUF_MAX_PERCENT;
+
+	min_rx_priv = hdev->dv_buf_size + COMPENSATE_BUFFER +
+			COMPENSATE_HALF_MPS_NUM * half_mps;
+	min_rx_priv = round_up(min_rx_priv, HCLGE_BUF_SIZE_UNIT);
+	rx_priv = round_down(rx_priv, HCLGE_BUF_SIZE_UNIT);
+
+	if (rx_priv < min_rx_priv)
+		return false;
+
+	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
+		struct hclge_priv_buf *priv = &buf_alloc->priv_buf[i];
+
+		priv->enable = 0;
+		priv->wl.low = 0;
+		priv->wl.high = 0;
+		priv->buf_size = 0;
+
+		if (!(hdev->hw_tc_map & BIT(i)))
+			continue;
+
+		priv->enable = 1;
+		priv->buf_size = rx_priv;
+		priv->wl.high = rx_priv - hdev->dv_buf_size;
+		priv->wl.low = priv->wl.high - PRIV_WL_GAP;
+	}
+
+	buf_alloc->s_buf.buf_size = 0;
+
+	return true;
+}
+
 /* hclge_rx_buffer_calc: calculate the rx private buffer size for all TCs
  * @hdev: pointer to struct hclge_dev
  * @buf_alloc: pointer to buffer calculation data
@@ -1856,6 +1912,9 @@ static int hclge_rx_buffer_calc(struct hclge_dev *hdev,
 		return 0;
 	}
 
+	if (hclge_only_alloc_priv_buff(hdev, buf_alloc))
+		return 0;
+
 	if (hclge_rx_buf_calc_all(hdev, true, buf_alloc))
 		return 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 5150daa..8186109 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -12,7 +12,7 @@
 
 #define HCLGE_TM_PORT_BASE_MODE_MSK	BIT(0)
 
-#define HCLGE_DEFAULT_PAUSE_TRANS_GAP	0xFF
+#define HCLGE_DEFAULT_PAUSE_TRANS_GAP	0x7F
 #define HCLGE_DEFAULT_PAUSE_TRANS_TIME	0xFFFF
 
 /* SP or DWRR */
-- 
2.7.4

