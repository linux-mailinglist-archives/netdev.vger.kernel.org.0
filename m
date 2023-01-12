Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4CB666E35
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbjALJ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbjALJ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:28:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232914FD78
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD86AB81DEB
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE8C433EF;
        Thu, 12 Jan 2023 09:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673515320;
        bh=DtkFtI5R9Mhikmhhpnkfs4gGN7PFxRGrjj7SSkUK4q4=;
        h=From:To:Cc:Subject:Date:From;
        b=lYJn2qkcfHAxVTfxWdsRATh9RH509A+FHD/xP90H1w/Pr5PBWrrk4fv9pgjP1ZNz5
         vz31oBwVs3EmI42GCgFjXlKkZOCUcr5ZjZy+QWg25aPwdngO8SjMhZ9SxQBxje1/ji
         L5U8JQpTFdxmRGwXOuTo4oh/b0egVh4CPYSdMHSPw5ywjTYM9pBbLS9+Qz94asi3Cg
         QUpdQJWyX7Fq6u0uQZK4bJ7h4N06Viru9yU6qp1G6IbvIC+4stYbv+p5dOm4cdlJwA
         JTL4xSsibzQRHFKYD+FOcNiCoQh5j9fyp72Dds48ASDEyq4MH/NaEKecqQIfpJ2xMj
         70gKqj9Wb9h4g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com
Subject: [PATCH v2 net-next] net: ethernet: mtk_wed: get rid of queue lock for tx queue
Date:   Thu, 12 Jan 2023 10:21:29 +0100
Message-Id: <7bd0337b2a13ab1a63673b7c03fd35206b3b284e.1673515140.git.lorenzo@kernel.org>
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
Changes since v1:
- rebase on top of net-next
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

