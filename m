Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B716062EE6
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfGIDbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727395AbfGIDbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:37 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1B449C352392AD38BA6E;
        Tue,  9 Jul 2019 11:31:34 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:23 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 10/10] net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC
Date:   Tue, 9 Jul 2019 11:31:11 +0800
Message-ID: <1562643071-46811-11-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI13X1 changed the offsets and bitmaps for tx_desc
registers in the same peripheral device on different
models of the hip04_eth.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 34 +++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 780fc46..6256357 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -76,8 +76,15 @@
 /* TX descriptor config */
 #define TX_FREE_MEM			BIT(0)
 #define TX_READ_ALLOC_L3		BIT(1)
-#define TX_FINISH_CACHE_INV		BIT(2)
+#if defined(CONFIG_HI13X1_GMAC)
+#define TX_CLEAR_WB			BIT(7)
+#define TX_RELEASE_TO_PPE		BIT(4)
+#define TX_FINISH_CACHE_INV		BIT(6)
+#define TX_POOL_SHIFT			16
+#else
 #define TX_CLEAR_WB			BIT(4)
+#define TX_FINISH_CACHE_INV		BIT(2)
+#endif
 #define TX_L3_CHECKSUM			BIT(5)
 #define TX_LOOP_BACK			BIT(11)
 
@@ -124,6 +131,7 @@
 /* buf unit size is cache_line_size, which is 64, so the shift is 6 */
 #define PPE_BUF_SIZE_SHIFT		6
 #define PPE_TX_BUF_HOLD			BIT(31)
+#define CACHE_LINE_MASK			0x3F
 #else
 #define PPE_CFG_QOS_VMID_GRP_SHIFT	8
 #define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
@@ -163,11 +171,22 @@
 #define HIP04_MIN_TX_COALESCE_FRAMES	100
 
 struct tx_desc {
+#if defined(CONFIG_HI13X1_GMAC)
+	u32 reserved1[2];
+	u32 send_addr;
+	u16 send_size;
+	u16 data_offset;
+	u32 reserved2[7];
+	u32 cfg;
+	u32 wb_addr;
+	u32 reserved3[3];
+#else
 	u32 send_addr;
 	u32 send_size;
 	u32 next_addr;
 	u32 cfg;
 	u32 wb_addr;
+#endif
 } __aligned(64);
 
 struct rx_desc {
@@ -505,11 +524,20 @@ static void hip04_start_tx_timer(struct hip04_priv *priv)
 
 	priv->tx_skb[tx_head] = skb;
 	priv->tx_phys[tx_head] = phys;
-	desc->send_addr = (__force u32)cpu_to_be32(phys);
+
 	desc->send_size = (__force u32)cpu_to_be32(skb->len);
+#if defined(CONFIG_HI13X1_GMAC)
+	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV
+		| TX_RELEASE_TO_PPE | priv->port << TX_POOL_SHIFT);
+	desc->data_offset = (__force u32)cpu_to_be32(phys & CACHE_LINE_MASK);
+	desc->send_addr =  (__force u32)cpu_to_be32(phys & ~CACHE_LINE_MASK);
+#else
 	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV);
+	desc->send_addr = (__force u32)cpu_to_be32(phys);
+#endif
 	phys = priv->tx_desc_dma + tx_head * sizeof(struct tx_desc);
-	desc->wb_addr = (__force u32)cpu_to_be32(phys);
+	desc->wb_addr = (__force u32)cpu_to_be32(phys +
+		offsetof(struct tx_desc, send_addr));
 	skb_tx_timestamp(skb);
 
 	hip04_set_xmit_desc(priv, phys);
-- 
1.8.5.6

