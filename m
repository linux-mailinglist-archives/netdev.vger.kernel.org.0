Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1E561ECA5
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiKGIKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiKGIKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:10:33 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A739013F61;
        Mon,  7 Nov 2022 00:10:30 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,143,1665414000"; 
   d="scan'208";a="141750250"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 07 Nov 2022 17:10:29 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E05C94002C03;
        Mon,  7 Nov 2022 17:10:29 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>
Subject: [PATCH] net: ethernet: renesas: rswitch: Fix endless loop in error paths
Date:   Mon,  7 Nov 2022 17:10:21 +0900
Message-Id: <20221107081021.2955122-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity reported that the error path in rswitch_gwca_queue_alloc_skb()
has an issue to cause endless loop. So, fix the issue by changing
variables' types from u32 to int. After changed the types,
rswitch_tx_free() should use rswitch_get_num_cur_queues() to
calculate number of current queues.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527147 ("Control flow issues")
Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 17 +++++++++--------
 drivers/net/ethernet/renesas/rswitch.h |  6 +++---
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index f0168fedfef9..3bd5e6239855 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -219,9 +219,9 @@ static void rswitch_ack_data_irq(struct rswitch_private *priv, int index)
 	iowrite32(BIT(index % 32), priv->addr + offs);
 }
 
-static u32 rswitch_next_queue_index(struct rswitch_gwca_queue *gq, bool cur, u32 num)
+static int rswitch_next_queue_index(struct rswitch_gwca_queue *gq, bool cur, int num)
 {
-	u32 index = cur ? gq->cur : gq->dirty;
+	int index = cur ? gq->cur : gq->dirty;
 
 	if (index + num >= gq->ring_size)
 		index = (index + num) % gq->ring_size;
@@ -231,7 +231,7 @@ static u32 rswitch_next_queue_index(struct rswitch_gwca_queue *gq, bool cur, u32
 	return index;
 }
 
-static u32 rswitch_get_num_cur_queues(struct rswitch_gwca_queue *gq)
+static int rswitch_get_num_cur_queues(struct rswitch_gwca_queue *gq)
 {
 	if (gq->cur >= gq->dirty)
 		return gq->cur - gq->dirty;
@@ -250,9 +250,9 @@ static bool rswitch_is_queue_rxed(struct rswitch_gwca_queue *gq)
 }
 
 static int rswitch_gwca_queue_alloc_skb(struct rswitch_gwca_queue *gq,
-					u32 start_index, u32 num)
+					int start_index, int num)
 {
-	u32 i, index;
+	int i, index;
 
 	for (i = 0; i < num; i++) {
 		index = (i + start_index) % gq->ring_size;
@@ -410,12 +410,12 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 
 static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 				      struct rswitch_gwca_queue *gq,
-				      u32 start_index, u32 num)
+				      int start_index, int num)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_ext_ts_desc *desc;
 	dma_addr_t dma_addr;
-	u32 i, index;
+	int i, index;
 
 	for (i = 0; i < num; i++) {
 		index = (i + start_index) % gq->ring_size;
@@ -736,7 +736,8 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 	int free_num = 0;
 	int size;
 
-	for (; gq->cur - gq->dirty > 0; gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
+	for (; rswitch_get_num_cur_queues(gq) > 0;
+	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
 		desc = &gq->ring[gq->dirty];
 		if (free_txed_only && (desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 			break;
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 778177ec8d4f..edbdd1b98d3d 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -908,9 +908,9 @@ struct rswitch_gwca_queue {
 		struct rswitch_ext_ts_desc *ts_ring;
 	};
 	dma_addr_t ring_dma;
-	u32 ring_size;
-	u32 cur;
-	u32 dirty;
+	int ring_size;
+	int cur;
+	int dirty;
 	struct sk_buff **skbs;
 
 	struct net_device *ndev;	/* queue to ndev for irq */
-- 
2.25.1

