Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D846661F3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbjAKRas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbjAKR3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:29:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3689F3056C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8BF7B81C8A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 17:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DF9C433F0;
        Wed, 11 Jan 2023 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457998;
        bh=6K5MYdGlyj551655ckTxrM7kU/YsxrSkd9hEceigUVE=;
        h=From:To:Cc:Subject:Date:From;
        b=Di3MsrADb4AvXTljJQdv/QHsPKXiisnfNnSl14gV4wZIE5MPwUh6gjzISciAnlJxD
         j3aF6hkvyk1sNN9iDbZQZOgLoOo7hv3uderxQp1OK0ImIYz7YNpc6SgrzGhDhk7dSj
         EFTDMZQXtP7e6MYk93CjzFMDdGA8ND2JQ3GT2b3j+vvfOGDqVWsI3RriIOGqeyf4pZ
         4d1ToSlKCqz5X0TO7f0rtoWfbFzrL6mftCEQ+MrjTpv5qjtZ6r6KssA6AMICE3zZr+
         seQAUtRGKKE61E6zXL5OqmS8flgACzjQAxkiXifFCe4BfWZK8NtuFuEbUjTOP7icHa
         zumASlDmil0qw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com
Subject: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock for tx queue
Date:   Wed, 11 Jan 2023 18:26:29 +0100
Message-Id: <61c985987cae6571bd25b51d414b09496d80dbe5.1673457839.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to MTK Wireless Ethernet Dispatcher (WED) MCU rx queue,
we do not need to protect WED MCU tx queue with a spin lock since
the tx queue is accessed in the two following routines:
- mtk_wed_wo_queue_tx_skb():
  it is run at initialization and during mt7915 normal operation.
  Moreover MCU messages are serialized through MCU mutex.
- mtk_wed_wo_queue_tx_clean():
  it runs just at mt7915 driver module unload when no more messages
  are sent to the MCU.

Remove tx queue spinlock.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch is based on the following patch not applied yet:
https://lore.kernel.org/netdev/36ec3b729542ea60898471d890796f745479ba32.1673342990.git.lorenzo@kernel.org/
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 7 -------
 drivers/net/ethernet/mediatek/mtk_wed_wo.h | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index d32b86499896..69fba29055e9 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -258,7 +258,6 @@ mtk_wed_wo_queue_alloc(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 		       int n_desc, int buf_size, int index,
 		       struct mtk_wed_wo_queue_regs *regs)
 {
-	spin_lock_init(&q->lock);
 	q->regs = *regs;
 	q->n_desc = n_desc;
 	q->buf_size = buf_size;
@@ -290,7 +289,6 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 	struct page *page;
 	int i;
 
-	spin_lock_bh(&q->lock);
 	for (i = 0; i < q->n_desc; i++) {
 		struct mtk_wed_wo_queue_entry *entry = &q->entry[i];
 
@@ -299,7 +297,6 @@ mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 		skb_free_frag(entry->buf);
 		entry->buf = NULL;
 	}
-	spin_unlock_bh(&q->lock);
 
 	if (!q->cache.va)
 		return;
@@ -347,8 +344,6 @@ int mtk_wed_wo_queue_tx_skb(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 	int ret = 0, index;
 	u32 ctrl;
 
-	spin_lock_bh(&q->lock);
-
 	q->tail = mtk_wed_mmio_r32(wo, q->regs.dma_idx);
 	index = (q->head + 1) % q->n_desc;
 	if (q->tail == index) {
@@ -379,8 +374,6 @@ int mtk_wed_wo_queue_tx_skb(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 	mtk_wed_wo_queue_kick(wo, q, q->head);
 	mtk_wed_wo_kickout(wo);
 out:
-	spin_unlock_bh(&q->lock);
-
 	dev_kfree_skb(skb);
 
 	return ret;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index c8fb85795864..dbcf42ce9173 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -211,7 +211,6 @@ struct mtk_wed_wo_queue {
 	struct mtk_wed_wo_queue_regs regs;
 
 	struct page_frag_cache cache;
-	spinlock_t lock;
 
 	struct mtk_wed_wo_queue_desc *desc;
 	dma_addr_t desc_dma;
-- 
2.39.0

