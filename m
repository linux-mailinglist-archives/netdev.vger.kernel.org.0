Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811BC6CCE72
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 02:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjC2AAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 20:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjC2AAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 20:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56FC3AB2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86DF3618E5
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED0AC433EF;
        Wed, 29 Mar 2023 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680048018;
        bh=Mijmn0E6UMWQju4f0vYRQr2/LdVH1UK3bbX/RbEp0E0=;
        h=From:To:Cc:Subject:Date:From;
        b=sZhKIlSiOEEAAdwpxFhKjlZ1hMlMZ5n8StpTuK93HoSYfafMT0ptGCbUBOjze6Wrc
         NnQjerbZFkykn33TG+P89B/itTzTJ76Z0WErGPzonNTHg74AZzG+E22GgjTJU4SA4Z
         QUkXV/CCN4nrA6CKEFciMgIIw4uVTBMzlCah1ymW8Ur4OTeaGD7OfqHjU4kmauZgTM
         VPSdYJOL4qhEmNpf3OirLK1u/Iu0T1PXToLzRJKMpAfSGonMKn1o7cjepuYX7Gt72D
         xOuHz8Ofd0Hak6xpInfWtnS03desCOdrTmlefjUHDvfr+FR7GrmL5I80oooN7fIOcb
         9IIZ59ar8okrQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, Thomas Voegtle <tv@lio96.de>,
        aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        keescook@chromium.org
Subject: [PATCH net] bnx2x: use the right build_skb() helper
Date:   Tue, 28 Mar 2023 17:00:13 -0700
Message-Id: <20230329000013.2734957-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

build_skb() no longer accepts slab buffers. Since slab use is fairly
uncommon we prefer the drivers to call a separate slab_build_skb()
function appropriately.

bnx2x uses the old semantics where size of 0 meant buffer from slab.
It sets the fp->rx_frag_size to 0 for MTUs which don't fit in a page.
It needs to call slab_build_skb().

This fixes the WARN_ONCE() of incorrect API use seen with bnx2x.

Reported-by: Thomas Voegtle <tv@lio96.de>
Link: https://lore.kernel.org/all/b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de/
Fixes: ce098da1497c ("skbuff: Introduce slab_build_skb()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: aelior@marvell.com
CC: skalluru@marvell.com
CC: manishc@marvell.com
CC: keescook@chromium.org
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 16c490692f42..12083b9679b5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -672,6 +672,18 @@ static int bnx2x_fill_frag_skb(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 	return 0;
 }
 
+static struct sk_buff *
+bnx2x_build_skb(const struct bnx2x_fastpath *fp, void *data)
+{
+	struct sk_buff *skb;
+
+	if (fp->rx_frag_size)
+		skb = build_skb(data, fp->rx_frag_size);
+	else
+		skb = slab_build_skb(data);
+	return skb;
+}
+
 static void bnx2x_frag_free(const struct bnx2x_fastpath *fp, void *data)
 {
 	if (fp->rx_frag_size)
@@ -779,7 +791,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 	dma_unmap_single(&bp->pdev->dev, dma_unmap_addr(rx_buf, mapping),
 			 fp->rx_buf_size, DMA_FROM_DEVICE);
 	if (likely(new_data))
-		skb = build_skb(data, fp->rx_frag_size);
+		skb = bnx2x_build_skb(fp, data);
 
 	if (likely(skb)) {
 #ifdef BNX2X_STOP_ON_ERROR
@@ -1046,7 +1058,7 @@ static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 						 dma_unmap_addr(rx_buf, mapping),
 						 fp->rx_buf_size,
 						 DMA_FROM_DEVICE);
-				skb = build_skb(data, fp->rx_frag_size);
+				skb = bnx2x_build_skb(fp, data);
 				if (unlikely(!skb)) {
 					bnx2x_frag_free(fp, data);
 					bnx2x_fp_qstats(bp, fp)->
-- 
2.39.2

