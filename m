Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5920862EE3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGIDbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51594 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbfGIDbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:34 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 96328BE1485FE9F8D83D;
        Tue,  9 Jul 2019 11:31:29 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:22 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 08/10] net: hisilicon: Offset buf address to adapt HI13X1_GMAC
Date:   Tue, 9 Jul 2019 11:31:09 +0800
Message-ID: <1562643071-46811-9-git-send-email-xiaojiangfeng@huawei.com>
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

The buf unit size of HI13X1_GMAC is cache_line_size,
which is 64, so the address we write to the buf register
needs to be shifted right by 6 bits.

The 31st bit of the PPE_CFG_CPU_ADD_ADDR register
of HI13X1_GMAC indicates whether to release the buffer
of the message, and the low indicates that it is valid.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 5328219..c578934 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -120,12 +120,20 @@
 #define PPE_CFG_STS_RX_PKT_CNT_RC	BIT(0)
 #define PPE_CFG_QOS_VMID_MODE		BIT(15)
 #define PPE_CFG_BUS_LOCAL_REL		(BIT(9) | BIT(15) | BIT(19) | BIT(23))
+
+/* buf unit size is cache_line_size, which is 64, so the shift is 6 */
+#define PPE_BUF_SIZE_SHIFT		6
+#define PPE_TX_BUF_HOLD			BIT(31)
 #else
 #define PPE_CFG_QOS_VMID_GRP_SHIFT	8
 #define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
 #define PPE_CFG_STS_RX_PKT_CNT_RC	BIT(12)
 #define PPE_CFG_QOS_VMID_MODE		BIT(14)
 #define PPE_CFG_BUS_LOCAL_REL		BIT(14)
+
+/* buf unit size is 1, so the shift is 6 */
+#define PPE_BUF_SIZE_SHIFT		0
+#define PPE_TX_BUF_HOLD			0
 #endif /* CONFIG_HI13X1_GMAC */
 
 #define PPE_CFG_RX_FIFO_FSFU		BIT(11)
@@ -286,7 +294,7 @@ static void hip04_config_fifo(struct hip04_priv *priv)
 	val |= PPE_CFG_QOS_VMID_MODE;
 	writel_relaxed(val, priv->base + PPE_CFG_QOS_VMID_GEN);
 
-	val = RX_BUF_SIZE;
+	val = RX_BUF_SIZE >> PPE_BUF_SIZE_SHIFT;
 	regmap_write(priv->map, priv->port * 4 + PPE_CFG_RX_BUF_SIZE, val);
 
 	val = RX_DESC_NUM << PPE_CFG_RX_DEPTH_SHIFT;
@@ -369,12 +377,18 @@ static void hip04_mac_disable(struct net_device *ndev)
 
 static void hip04_set_xmit_desc(struct hip04_priv *priv, dma_addr_t phys)
 {
-	writel(phys, priv->base + PPE_CFG_CPU_ADD_ADDR);
+	u32 val;
+
+	val = phys >> PPE_BUF_SIZE_SHIFT | PPE_TX_BUF_HOLD;
+	writel(val, priv->base + PPE_CFG_CPU_ADD_ADDR);
 }
 
 static void hip04_set_recv_desc(struct hip04_priv *priv, dma_addr_t phys)
 {
-	regmap_write(priv->map, priv->port * 4 + PPE_CFG_RX_ADDR, phys);
+	u32 val;
+
+	val = phys >> PPE_BUF_SIZE_SHIFT;
+	regmap_write(priv->map, priv->port * 4 + PPE_CFG_RX_ADDR, val);
 }
 
 static u32 hip04_recv_cnt(struct hip04_priv *priv)
-- 
1.8.5.6

