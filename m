Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35D36DCF5F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjDKBde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjDKBdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6681995
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 18:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB9061B18
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ADDC433EF;
        Tue, 11 Apr 2023 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681176809;
        bh=KpZvix6cycUriBVdwxMpkH9qP9KPJmTKVlEicxov7I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la7f/Kr718xCRv9tTBeAtObndDXAi8yGluGq9WughwQ12gahWwZye4r1aVXt1rfSD
         Q3iYiqVXQnfwLC46GE9jqZuzV1QzzVapoe4F2hOshkzJWe3DwHpCnPtkK/6d5MvJyc
         w9e5ewrIcIfJUJ9RNcNO/8aFjL2HY83166/Z6eyMvLp83eG5l8b9Au+RzstPEd72+q
         wfffLATbMH+FWB4mFaWJmZtc2D3wWAOhvWW06wn20zRyKZsKred+kRUEwU04gbwPtV
         BXAevGk3rw29uTRqKZY2t/sKOOscWBLgWYdAjqj2yxRmZz07/YQtcedKglxX7/80ih
         CBiuFMi5eRGsQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com
Subject: [PATCH net-next 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
Date:   Mon, 10 Apr 2023 18:33:22 -0700
Message-Id: <20230411013323.513688-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411013323.513688-1-kuba@kernel.org>
References: <20230411013323.513688-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric points out that we should make sure that ring index updates
are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 9 ++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f7602d8d79e3..92289ab2f34a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -472,7 +472,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		prod = NEXT_TX(prod);
 		tx_push->doorbell =
 			cpu_to_le32(DB_KEY_TX_PUSH | DB_LONG_TX_PUSH | prod);
-		txr->tx_prod = prod;
+		WRITE_ONCE(txr->tx_prod, prod);
 
 		tx_buf->is_push = 1;
 		netdev_tx_sent_queue(txq, skb->len);
@@ -583,7 +583,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	wmb();
 
 	prod = NEXT_TX(prod);
-	txr->tx_prod = prod;
+	WRITE_ONCE(txr->tx_prod, prod);
 
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
 		bnxt_txr_db_kick(bp, txr, prod);
@@ -688,7 +688,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		dev_kfree_skb_any(skb);
 	}
 
-	txr->tx_cons = cons;
+	WRITE_ONCE(txr->tx_cons, cons);
 
 	__netif_txq_completed_wake(txq, nr_pkts, tx_bytes,
 				   bnxt_tx_avail(bp, txr), bp->tx_wake_thresh,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 18cac98ba58e..080e73496066 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2231,13 +2231,12 @@ struct bnxt {
 #define SFF_MODULE_ID_QSFP28			0x11
 #define BNXT_MAX_PHY_I2C_RESP_SIZE		64
 
-static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
+static inline u32 bnxt_tx_avail(struct bnxt *bp,
+				const struct bnxt_tx_ring_info *txr)
 {
-	/* Tell compiler to fetch tx indices from memory. */
-	barrier();
+	u32 used = READ_ONCE(txr->tx_prod) - READ_ONCE(txr->tx_cons);
 
-	return bp->tx_ring_size -
-		((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
+	return bp->tx_ring_size - (used & bp->tx_ring_mask);
 }
 
 static inline void bnxt_writeq(struct bnxt *bp, u64 val,
-- 
2.39.2

