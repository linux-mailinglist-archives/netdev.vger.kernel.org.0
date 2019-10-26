Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F87E594A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfJZIt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 04:49:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54492 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfJZIt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 04:49:58 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2D1B4FC900DF94AB1320;
        Sat, 26 Oct 2019 16:49:54 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Sat, 26 Oct 2019
 16:49:46 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <zhanghan23@huawei.com>,
        <nixiaoming@huawei.com>, <zhangqiang.cn@hisilicon.com>,
        <dingjingcheng@hisilicon.com>
Subject: [PATCH] net: hisilicon: Fix ping latency when deal with high throughput
Date:   Sat, 26 Oct 2019 16:49:39 +0800
Message-ID: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
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
 drivers/net/ethernet/hisilicon/hip04_eth.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index ad6d912..78f338a 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -575,7 +575,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
 	struct net_device *ndev = priv->ndev;
 	struct net_device_stats *stats = &ndev->stats;
-	unsigned int cnt = hip04_recv_cnt(priv);
+	static unsigned int cnt_remaining;
 	struct rx_desc *desc;
 	struct sk_buff *skb;
 	unsigned char *buf;
@@ -588,8 +588,8 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 
 	/* clean up tx descriptors */
 	tx_remaining = hip04_tx_reclaim(ndev, false);
-
-	while (cnt && !last) {
+	cnt_remaining += hip04_recv_cnt(priv);
+	while (cnt_remaining && !last) {
 		buf = priv->rx_buf[priv->rx_head];
 		skb = build_skb(buf, priv->rx_buf_size);
 		if (unlikely(!skb)) {
@@ -635,11 +635,13 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 		hip04_set_recv_desc(priv, phys);
 
 		priv->rx_head = RX_NEXT(priv->rx_head);
-		if (rx >= budget)
+		if (rx >= budget) {
+			--cnt_remaining;
 			goto done;
+		}
 
-		if (--cnt == 0)
-			cnt = hip04_recv_cnt(priv);
+		if (--cnt_remaining == 0)
+			cnt_remaining += hip04_recv_cnt(priv);
 	}
 
 	if (!(priv->reg_inten & RCV_INT)) {
-- 
1.8.5.6

