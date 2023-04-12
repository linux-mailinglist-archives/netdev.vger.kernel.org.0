Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C0E6DE921
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDLBux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDLBut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:50:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B0C4EDA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 18:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F10D62C29
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC9FC4339E;
        Wed, 12 Apr 2023 01:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681264245;
        bh=2rbWuO+4EqTH7iH4aBTn0LQxQtvVu1SdjxFAAn9m+ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyXL6ZMHRxmsqTOk9wLeP7YhINqdlksK9yiGQ/Un+hTFMhz14VjpksfJkoIQAJ0Rz
         NT+5GXCCdwZb9WB/+6CqWSrx1qBWowNa/5l9tX8UY771Anjwf0PdidzvHFZknBGUF4
         cQvK+tj5x3YB57C+/QjvlumR0gXnvkjAUhd82XrDT95wUPGEB2k0sTRRRUX0qvIRAO
         MTS5l5MJOjxOXkElkCTLrNohXOIh6ZSmyDvOafXcx+kvMJxzYWUylJYo6eQZ2YyOID
         eD40dO6V0LQS2nv5752NEunzXEcFKo8+vYu4fYx/IindcZcCxKlbdCXz8s/oX6vHoM
         55EoolBe6+40w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        michael.chan@broadcom.com
Subject: [PATCH net-next v2 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
Date:   Tue, 11 Apr 2023 18:50:37 -0700
Message-Id: <20230412015038.674023-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412015038.674023-1-kuba@kernel.org>
References: <20230412015038.674023-1-kuba@kernel.org>
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

Eric points out that we should make sure that ring index updates
are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.

Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - cover writes in bnxt_xdp.c
v1: https://lore.kernel.org/all/20230411013323.513688-3-kuba@kernel.org/
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 9 ++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 6 +++---
 3 files changed, 10 insertions(+), 11 deletions(-)

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
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 5843c93b1711..4efa5fe6972b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -64,7 +64,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 		int frag_len;
 
 		prod = NEXT_TX(prod);
-		txr->tx_prod = prod;
+		WRITE_ONCE(txr->tx_prod, prod);
 
 		/* first fill up the first buffer */
 		frag_tx_buf = &txr->tx_buf_ring[prod];
@@ -94,7 +94,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 	/* Sync TX BD */
 	wmb();
 	prod = NEXT_TX(prod);
-	txr->tx_prod = prod;
+	WRITE_ONCE(txr->tx_prod, prod);
 
 	return tx_buf;
 }
@@ -161,7 +161,7 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		}
 		tx_cons = NEXT_TX(tx_cons);
 	}
-	txr->tx_cons = tx_cons;
+	WRITE_ONCE(txr->tx_cons, tx_cons);
 	if (rx_doorbell_needed) {
 		tx_buf = &txr->tx_buf_ring[last_tx_cons];
 		bnxt_db_write(bp, &rxr->rx_db, tx_buf->rx_prod);
-- 
2.39.2

