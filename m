Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC16AADCC
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 03:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCECIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 21:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCECIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 21:08:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE4013D45
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 18:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aemgN5qIiQEXTBmjjyHuwmEC8bbg0+4AndH9n+s6pG0=; b=WYepPKnfcMHdFfWiZ8KVt7gFPA
        pF8RbIOM0I+2a6PR+Ch8iB3CzGlXa3pVXLzJkg7FHuTemftSjUzMfhjxtVrLGOnPM86XbbeBlVgoC
        7xa8cIo/SfrOxkbJicHJFBfr+M79wQd2mWKdU8sep3GErFHaZK1TxGh7jls6CsaP4K9gIo24OD6zz
        QF6yNDPU6BmIqf/UgpHEEdmETfHHBl2Znklmn8D6SaDPxTcUk4Z4CZQnktNmz2qYu48dsYepP5IyG
        11v7lDnIrVSjXrkEuk/9IM2syBgOs2s6F9wqF3fvYluOy9qLHCms4peKD9SatVMDb5rcWn5GhLROm
        DWsj7CSQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYdnF-006Wd2-7j; Sun, 05 Mar 2023 02:08:09 +0000
Message-Id: <45545484eadcf15a3ef06e35ccf34981cda2e867.1677981671.git.geoff@infradead.org>
In-Reply-To: <cover.1677981671.git.geoff@infradead.org>
References: <cover.1677981671.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 4 Mar 2023 17:48:15 -0800
Subject: [PATCH net v7 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 05 Mar 2023 02:08:09 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index b0ebe0e603b4..40261947e0ea 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -323,7 +323,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
 				       GELIC_DESCR_SIZE,
 				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		if (dma_mapping_error(ctodev(card), descr->bus_addr))
 			goto iommu_error;
 
 		descr->next = descr + 1;
@@ -401,7 +401,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 						     descr->skb->data,
 						     GELIC_NET_MAX_FRAME,
 						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	if (dma_mapping_error(ctodev(card), descr->buf_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -781,7 +781,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
-- 
2.34.1

