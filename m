Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E925E5434
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiIUUKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiIUUKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786664B0C8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F4263270
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05949C433D6;
        Wed, 21 Sep 2022 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663791007;
        bh=fRRS1r1I5OkBSlVUBkkvyxYU/Jo4W5DShVGC9lEjd4o=;
        h=From:To:Cc:Subject:Date:From;
        b=BPhDu/gHAL+HiVGP9KC+lgJHxGHYicZYaSrc50kkEf2wKAY3XyWHGi+AFv19sihiQ
         9hCypvpfrZJn1aizcnnrOkRcp2ldvVX/9aHuxIIqKO2Ch84vIba8tnf07m4n71nkpv
         wzviUVqGwLLROsfP2gU8VftLTkSxrssxRGX8ZYbNRlhCbxg/gwjfdtaD4mTvAXxUJx
         Z0ORPdL0q815qj9ox+WxPyVXx2jsEkgCh8PvwikwfHeQf4GEDCxTdbl9XY2RC96ebV
         h5ausUERiEzwZWBGqpr/v9llvD3nMmc6AwLdnJxJb8ulxp1P3cSRZnDKiE5GpCbXft
         c4bhsQAOFbqZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com,
        pavan.chebbi@broadcom.com, edwin.peer@broadcom.com,
        andrew.gospodarek@broadcom.com
Subject: [PATCH net] bnxt: prevent skb UAF after handing over to PTP worker
Date:   Wed, 21 Sep 2022 13:10:05 -0700
Message-Id: <20220921201005.335390-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
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

When reading the timestamp is required bnxt_tx_int() hands
over the ownership of the completed skb to the PTP worker.
The skb should not be used afterwards, as the worker may
run before the rest of our code and free the skb, leading
to a use-after-free.

Since dev_kfree_skb_any() accepts NULL make the loss of
ownership more obvious and set skb to NULL.

Fixes: 83bb623c968e ("bnxt_en: Transmit and retrieve packet timestamps")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
CC: pavan.chebbi@broadcom.com
CC: edwin.peer@broadcom.com
CC: andrew.gospodarek@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f46eefb5a029..96da0ba3d507 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -659,7 +659,6 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	for (i = 0; i < nr_pkts; i++) {
 		struct bnxt_sw_tx_bd *tx_buf;
-		bool compl_deferred = false;
 		struct sk_buff *skb;
 		int j, last;
 
@@ -668,6 +667,8 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		skb = tx_buf->skb;
 		tx_buf->skb = NULL;
 
+		tx_bytes += skb->len;
+
 		if (tx_buf->is_push) {
 			tx_buf->is_push = 0;
 			goto next_tx_int;
@@ -688,8 +689,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		}
 		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
 			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				/* PTP worker takes ownership of the skb */
 				if (!bnxt_get_tx_ts_p5(bp, skb))
-					compl_deferred = true;
+					skb = NULL;
 				else
 					atomic_inc(&bp->ptp_cfg->tx_avail);
 			}
@@ -698,9 +700,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 next_tx_int:
 		cons = NEXT_TX(cons);
 
-		tx_bytes += skb->len;
-		if (!compl_deferred)
-			dev_kfree_skb_any(skb);
+		dev_kfree_skb_any(skb);
 	}
 
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
-- 
2.37.3

