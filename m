Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4941CE6BC5
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 06:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfJ1FKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 01:10:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbfJ1FKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 01:10:08 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 88206953F4F381262697;
        Mon, 28 Oct 2019 13:10:01 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 13:09:52 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <zhanghan23@huawei.com>,
        <nixiaoming@huawei.com>, <zhangqiang.cn@hisilicon.com>,
        <dingjingcheng@hisilicon.com>, <joe@perches.com>
Subject: [PATCH v2] net: hisilicon: Fix ping latency when deal with high throughput
Date:   Mon, 28 Oct 2019 13:09:46 +0800
Message-ID: <1572239386-67767-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is due to error in over budget processing.
When dealing with high throughput, the used buffers
that exceeds the budget is not cleaned up. In addition,
it takes a lot of cycles to clean up the used buffer,
and then the buffer where the valid data is located can take effect.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
ChangeLog v1->v2:
- Make rx_cnt_remaining part of struct hip04_priv.
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index c841674..f51bc02 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -237,6 +237,7 @@ struct hip04_priv {
 	dma_addr_t rx_phys[RX_DESC_NUM];
 	unsigned int rx_head;
 	unsigned int rx_buf_size;
+	unsigned int rx_cnt_remaining;
 
 	struct device_node *phy_node;
 	struct phy_device *phy;
@@ -575,7 +576,6 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
 	struct net_device *ndev = priv->ndev;
 	struct net_device_stats *stats = &ndev->stats;
-	unsigned int cnt = hip04_recv_cnt(priv);
 	struct rx_desc *desc;
 	struct sk_buff *skb;
 	unsigned char *buf;
@@ -588,8 +588,8 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 
 	/* clean up tx descriptors */
 	tx_remaining = hip04_tx_reclaim(ndev, false);
-
-	while (cnt && !last) {
+	priv->rx_cnt_remaining += hip04_recv_cnt(priv);
+	while (priv->rx_cnt_remaining && !last) {
 		buf = priv->rx_buf[priv->rx_head];
 		skb = build_skb(buf, priv->rx_buf_size);
 		if (unlikely(!skb)) {
@@ -635,11 +635,13 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 		hip04_set_recv_desc(priv, phys);
 
 		priv->rx_head = RX_NEXT(priv->rx_head);
-		if (rx >= budget)
+		if (rx >= budget) {
+			--priv->rx_cnt_remaining;
 			goto done;
+		}
 
-		if (--cnt == 0)
-			cnt = hip04_recv_cnt(priv);
+		if (--priv->rx_cnt_remaining == 0)
+			priv->rx_cnt_remaining += hip04_recv_cnt(priv);
 	}
 
 	if (!(priv->reg_inten & RCV_INT)) {
@@ -724,6 +726,7 @@ static int hip04_mac_open(struct net_device *ndev)
 	int i;
 
 	priv->rx_head = 0;
+	priv->rx_cnt_remaining = 0;
 	priv->tx_head = 0;
 	priv->tx_tail = 0;
 	hip04_reset_ppe(priv);
-- 
1.8.5.6

