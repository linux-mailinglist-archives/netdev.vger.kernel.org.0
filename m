Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABE13F7EF4
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhHYXTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233291AbhHYXTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 19:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E0DD610CA;
        Wed, 25 Aug 2021 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629933513;
        bh=GYJpZfXA/tMoO5lXjK0b/e6smFE5QWeA6cyx0QbG9Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxwXdyH1h43BdgmZMZw6Iz07MvTcDeLWR1fOn1nfVjuH65VtJSaSgIFNgFkaxZXeL
         bh46sGa9yqzMTne0rVAv4NoXDC+USHW9bHtaXJU4KrHX743SO917spttlyvB0wxlsF
         tyGDwjwZ2usF0p/DPWbSs+C1JqLJktArUm3Et9HV9niU+lI1v4Vc7vyuqkBtd4yYs3
         LXTlLjcNKk38kJ7VuDRgzCN+5VdmboMzxeouqBv8K22PJNoyyHfNEmuxhzvfV2VP1N
         LG60IAHLFJT/WWBdOyzIFDY4yMR/CcZ5n0HjylVx9UnBY3SHOZOLHuxd5OHudRE0kU
         aB1HQSNdfpW2g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] bnxt: reorder logic in bnxt_get_stats64()
Date:   Wed, 25 Aug 2021 16:18:28 -0700
Message-Id: <20210825231830.2748915-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210825231830.2748915-1-kuba@kernel.org>
References: <20210825231830.2748915-1-kuba@kernel.org>
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

