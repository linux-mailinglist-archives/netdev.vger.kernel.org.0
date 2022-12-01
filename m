Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4419F63F3C8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiLAP1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLAP1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:27:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4203A95A8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:27:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 961A861FA9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 15:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A137FC433D6;
        Thu,  1 Dec 2022 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669908438;
        bh=fjBkFSHXsfnsna0pkKiMUUzJlNUEorxvMDs0l/ALuZw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ee/B22uKb/cFiI9/KlaoIh5LAQweauDguc70tsKFG5EvKotk7zh8iD52IT3TMNUr2
         lh2bBc1LDXt/RpwA7u6zR/rh9vOx/+rwtq4EcyTo0u0MO4IlpCnHMkjA/PhCDOqZSp
         8Q8uvATwL5SoPiS291hG2TZa8XyxWmPy2gg43zX0AvDTLPLPeVAzW3J1bBCCTJkaeo
         GFeE3ory3BeKO0ukalGhO8oJKFcNhVt9WomsL3EChCb8p15lHKlFPPCjbgtzPl/KVP
         Y4HI4b4IAw3D0ioLet6qTegm16Y3qoEwLNFrUOZPI+lpyyDQEoKGOLqGIC6pEwp+7a
         zO9Ui2hLPTu+w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill
Date:   Thu,  1 Dec 2022 16:26:53 +0100
Message-Id: <67ca94bdd3d9eaeb86e52b3050fbca0bcf7bb02f.1669908312.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

In order to fix the following sleep while atomic bug always alloc pages
with GFP_ATOMIC in mtk_wed_wo_queue_refill since page_frag_alloc runs in
spin_lock critical section.

[    9.049719] Hardware name: MediaTek MT7986a RFB (DT)
[    9.054665] Call trace:
[    9.057096]  dump_backtrace+0x0/0x154
[    9.060751]  show_stack+0x14/0x1c
[    9.064052]  dump_stack_lvl+0x64/0x7c
[    9.067702]  dump_stack+0x14/0x2c
[    9.071001]  ___might_sleep+0xec/0x120
[    9.074736]  __might_sleep+0x4c/0x9c
[    9.078296]  __alloc_pages+0x184/0x2e4
[    9.082030]  page_frag_alloc_align+0x98/0x1ac
[    9.086369]  mtk_wed_wo_queue_refill+0x134/0x234
[    9.090974]  mtk_wed_wo_init+0x174/0x2c0
[    9.094881]  mtk_wed_attach+0x7c8/0x7e0
[    9.098701]  mt7915_mmio_wed_init+0x1f0/0x3a0 [mt7915e]
[    9.103940]  mt7915_pci_probe+0xec/0x3bc [mt7915e]
[    9.108727]  pci_device_probe+0xac/0x13c
[    9.112638]  really_probe.part.0+0x98/0x2f4
[    9.116807]  __driver_probe_device+0x94/0x13c
[    9.121147]  driver_probe_device+0x40/0x114
[    9.125314]  __driver_attach+0x7c/0x180
[    9.129133]  bus_for_each_dev+0x5c/0x90
[    9.132953]  driver_attach+0x20/0x2c
[    9.136513]  bus_add_driver+0x104/0x1fc
[    9.140333]  driver_register+0x74/0x120
[    9.144153]  __pci_register_driver+0x40/0x50
[    9.148407]  mt7915_init+0x5c/0x1000 [mt7915e]
[    9.152848]  do_one_initcall+0x40/0x25c
[    9.156669]  do_init_module+0x44/0x230
[    9.160403]  load_module+0x1f30/0x2750
[    9.164135]  __do_sys_init_module+0x150/0x200
[    9.168475]  __arm64_sys_init_module+0x18/0x20
[    9.172901]  invoke_syscall.constprop.0+0x4c/0xe0
[    9.177589]  do_el0_svc+0x48/0xe0
[    9.180889]  el0_svc+0x14/0x50
[    9.183929]  el0t_64_sync_handler+0x9c/0x120
[    9.188183]  el0t_64_sync+0x158/0x15c

Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index 4754b6db009e..a219da85f4db 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -133,17 +133,18 @@ mtk_wed_wo_dequeue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q, u32 *len,
 
 static int
 mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
-			gfp_t gfp, bool rx)
+			bool rx)
 {
 	enum dma_data_direction dir = rx ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	int n_buf = 0;
 
 	spin_lock_bh(&q->lock);
 	while (q->queued < q->n_desc) {
-		void *buf = page_frag_alloc(&q->cache, q->buf_size, gfp);
 		struct mtk_wed_wo_queue_entry *entry;
 		dma_addr_t addr;
+		void *buf;
 
+		buf = page_frag_alloc(&q->cache, q->buf_size, GFP_ATOMIC);
 		if (!buf)
 			break;
 
@@ -215,7 +216,7 @@ mtk_wed_wo_rx_run_queue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
 			mtk_wed_mcu_rx_unsolicited_event(wo, skb);
 	}
 
-	if (mtk_wed_wo_queue_refill(wo, q, GFP_ATOMIC, true)) {
+	if (mtk_wed_wo_queue_refill(wo, q, true)) {
 		u32 index = (q->head - 1) % q->n_desc;
 
 		mtk_wed_wo_queue_kick(wo, q, index);
@@ -432,7 +433,7 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
 	if (ret)
 		goto error;
 
-	mtk_wed_wo_queue_refill(wo, &wo->q_tx, GFP_KERNEL, false);
+	mtk_wed_wo_queue_refill(wo, &wo->q_tx, false);
 	mtk_wed_wo_queue_reset(wo, &wo->q_tx);
 
 	regs.desc_base = MTK_WED_WO_CCIF_DUMMY5;
@@ -446,7 +447,7 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
 	if (ret)
 		goto error;
 
-	mtk_wed_wo_queue_refill(wo, &wo->q_rx, GFP_KERNEL, true);
+	mtk_wed_wo_queue_refill(wo, &wo->q_rx, true);
 	mtk_wed_wo_queue_reset(wo, &wo->q_rx);
 
 	/* rx queue irqmask */
-- 
2.38.1

