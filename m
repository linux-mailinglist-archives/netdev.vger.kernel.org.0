Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922C6663CE9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbjAJJcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbjAJJbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:31:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751051759B
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27940B81168
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E429CC433EF;
        Tue, 10 Jan 2023 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673343092;
        bh=vl7i/bpeTbE9pfLXHnTMXiKLVmUJ6DbfbUK8d/yIjZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=KU1w1GB+1A0P6g1ZlWspfDG8SgkgKlIdn3xeSSP2raFWKo9LGJRkBqWp7Wpy03F5l
         c5fR0mT9Di3lmeaAo+cU3hfXV0dnpjVnOD1pQJa9KBHZ3S890YEEdxDRix75XmQUDz
         GbsS0Nhb+4cBL+BaYq4eDgUy9azVaW6HCUwEvUVxEbFs1iZIpEQQzCk2VIwRIWKWFa
         Q/qb5FTwmY8jQBsL5Mlogsk10+JK0NtToZNgED5hZUK0tDEYIwFrmIzRjDhKLEeFrY
         Hmb527B+cTbTkbVSdkfGjBgPCXvcJwa8WdVKq9p6lfDFI27mA67OitFfvqeAexaT2S
         F7Sfil2lQ+iaQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org,
        alexanderduyck@fb.com
Subject: [PATCH v2 net-next] net: ethernet: mtk_wed: get rid of queue lock for rx queue
Date:   Tue, 10 Jan 2023 10:31:26 +0100
Message-Id: <36ec3b729542ea60898471d890796f745479ba32.1673342990.git.lorenzo@kernel.org>
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

Queue spinlock is currently held in mtk_wed_wo_queue_rx_clean and
mtk_wed_wo_queue_refill routines for MTK Wireless Ethernet Dispatcher
MCU rx queue. mtk_wed_wo_queue_refill() is running during initialization
and in rx tasklet while mtk_wed_wo_queue_rx_clean() is running in
mtk_wed_wo_hw_deinit() during hw de-init phase after rx tasklet has been
disabled. Since mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill
routines can't run concurrently get rid of spinlock for mcu rx queue.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- improve commit message
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

