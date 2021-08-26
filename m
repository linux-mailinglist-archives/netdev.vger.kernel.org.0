Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8A3F8004
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhHZBsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhHZBsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 21:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1689610C8;
        Thu, 26 Aug 2021 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629942454;
        bh=GYJpZfXA/tMoO5lXjK0b/e6smFE5QWeA6cyx0QbG9Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APWwZrCjrACQdwaJCYULqCMGVBrUUacmYGvgJsHBURSpE8fWvhRbJKob/bkINpWZ4
         Md+JABFnDzZFMIF3WgKI5J8O1FwSc5bDURN/VzqGLRHMH3NTclB5ZHSi6RCczEF/Jv
         HMHpw8OmBL9Mlbl2xS8AuOkHTONVAvi/zrR2GbVi6ZA6udTssHfrVxptd0lWiuM7iN
         5tiMuTqnn4DZ/9ylgSZiKkH7IEbsngrqFpNQoZf4FBzLUtCwuv6GTIDFopSXpTFacR
         ey9xbjlBr63DAehyRHD6IHWg1V0+x40H7VdcD4Fp0F6hAJAX9kYex7AH55I5dAG9j8
         Dm0Gr4hy7C5lw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/3] bnxt: reorder logic in bnxt_get_stats64()
Date:   Wed, 25 Aug 2021 18:47:29 -0700
Message-Id: <20210826014731.2764066-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826014731.2764066-1-kuba@kernel.org>
References: <20210826014731.2764066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saved ring stats and port stats are completely disjoint.
We can reorder getting the old stats and collecting new
stats from rings with reading port stats.

We can also use bnxt_add_prev_stats() instead of doing
a struct assignment.

With that we can use the same code for closed and open
device, next commits will add more stats at the end
of bnxt_get_stats64().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ee66d410c82c..d39449e7b236 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10673,14 +10673,8 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	 * we check the BNXT_STATE_OPEN flag.
 	 */
 	smp_mb__after_atomic();
-	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
-		clear_bit(BNXT_STATE_READ_STATS, &bp->state);
-		*stats = bp->net_stats_prev;
-		return;
-	}
-
-	bnxt_get_ring_stats(bp, stats);
-	bnxt_add_prev_stats(bp, stats);
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state))
+		goto skip_current;
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
 		u64 *rx = bp->port_stats.sw_stats;
@@ -10704,6 +10698,11 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 			BNXT_GET_TX_PORT_STATS64(tx, tx_fifo_underruns);
 		stats->tx_errors = BNXT_GET_TX_PORT_STATS64(tx, tx_err);
 	}
+
+	bnxt_get_ring_stats(bp, stats);
+skip_current:
+	bnxt_add_prev_stats(bp, stats);
+
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
 
-- 
2.31.1

