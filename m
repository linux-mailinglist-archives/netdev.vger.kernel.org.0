Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D547660F8B
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjAGOln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAGOlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0752568A7
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:41:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3FA60112
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D3EC433EF;
        Sat,  7 Jan 2023 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673102500;
        bh=McacUSoHVNUouXTjebG+SgMnb6S0UDLtKP1fw6la7Vo=;
        h=From:To:Cc:Subject:Date:From;
        b=K/Bv+4sb5MrAC2DdCDzh4zLycCil8i7OlbtoqOKs6PjmhC5DQbAFtk0yu01HO+hd1
         XQdNvRLN7t2td5kx4mgAk8xTd0KqH3xAoFHsknoVrvYoIwgGQ/kiqt18qjfIrsghML
         muCDWgFMaaCjqOTvWHvnG/vfJnlsGMK3ZA+stMJoQONxSDZ96OvqOnZ1S2yRPtZo74
         fN3fSukTQSbRyaBKssPFd5BSmyOOlD5gd5OrXixMadmQfzxDLZSpRh5LOhfu+kPcAD
         /iQx8wkEGgmQ+lDYH85LVqU3A5ATUuXPZ0PDJ9h3TKaFcmeqh4/spZcHFfHlhtHdQc
         2wxvJxHDVrRsg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock for rx queue
Date:   Sat,  7 Jan 2023 15:41:32 +0100
Message-Id: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
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

mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill routines can't run
concurrently so get rid of spinlock for rx queues.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index a0a39643caf7..d32b86499896 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -138,7 +138,6 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 	enum dma_data_direction dir = rx ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	int n_buf = 0;
 
-	spin_lock_bh(&q->lock);
 	while (q->queued < q->n_desc) {
 		struct mtk_wed_wo_queue_entry *entry;
 		dma_addr_t addr;
@@ -172,7 +171,6 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 		q->queued++;
 		n_buf++;
 	}
-	spin_unlock_bh(&q->lock);
 
 	return n_buf;
 }
@@ -316,7 +314,6 @@ mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 {
 	struct page *page;
 
-	spin_lock_bh(&q->lock);
 	for (;;) {
 		void *buf = mtk_wed_wo_dequeue(wo, q, NULL, true);
 
@@ -325,7 +322,6 @@ mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 
 		skb_free_frag(buf);
 	}
-	spin_unlock_bh(&q->lock);
 
 	if (!q->cache.va)
 		return;
-- 
2.39.0

