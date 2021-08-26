Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6BD3F8006
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhHZBsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236315AbhHZBsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 21:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C84610C7;
        Thu, 26 Aug 2021 01:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629942454;
        bh=Y248U5FJHJ5w7DSbbTTgw/eTUvrPOm1xQFO46Tpp7oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzU1tX580WULLCunIXnAP2upCo2JdhDLkJMkAo6PzFcC1Lmt7cKgj5EakOT+w+G94
         vlQ1Cr9qnakAvogNsodw19Mov87wlJT4lSAUZajj5lDbQ/AmGMO1fbEBzOgVoNp8Ja
         jI6BEC9StUjnofynudVdnL2UHUpA/ysUZ+PjlxvqiCMtnPhWWImhzRO1cKfCR8pFD5
         d292z0QVeVGyrpUjcOZfzcdkP82+6gxe8QnXtTkzKK18BDF3thbOZKImlMYBzxbKEA
         e7AQnM87ssTxH3LNvuKmyusVNv6qJbRJXr6UQS6RqANobuoHXNzEl3S9Qw6pACxxuc
         C0BAgfFv/zc4A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/3] bnxt: count discards due to memory allocation errors
Date:   Wed, 25 Aug 2021 18:47:31 -0700
Message-Id: <20210826014731.2764066-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826014731.2764066-1-kuba@kernel.org>
References: <20210826014731.2764066-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count packets dropped due to buffer or skb allocation errors.
Report as part of rx_dropped.

v2: drop the ethtool -S entry [Vladimir]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 +++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d12a9052388f..bdc5eb42f55b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1651,6 +1651,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, mapping);
 		if (!skb) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	} else {
@@ -1660,6 +1661,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		new_data = __bnxt_alloc_rx_data(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 
@@ -1675,6 +1677,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		if (!skb) {
 			kfree(data);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 		skb_reserve(skb, bp->rx_offset);
@@ -1685,6 +1688,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_rx_pages(bp, cpr, skb, idx, agg_bufs, true);
 		if (!skb) {
 			/* Page reuse already handled by bnxt_rx_pages(). */
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	}
@@ -1888,6 +1892,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			if (agg_bufs)
 				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0,
 						       agg_bufs, false);
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			rc = -ENOMEM;
 			goto next_rx;
 		}
@@ -1901,6 +1906,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		skb = bp->rx_skb_func(bp, rxr, cons, data, data_ptr, dma_addr,
 				      payload | len);
 		if (!skb) {
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			rc = -ENOMEM;
 			goto next_rx;
 		}
@@ -1909,6 +1915,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	if (agg_bufs) {
 		skb = bnxt_rx_pages(bp, cpr, skb, cp_cons, agg_bufs, false);
 		if (!skb) {
+			cpr->sw_stats.rx.rx_oom_discards += 1;
 			rc = -ENOMEM;
 			goto next_rx;
 		}
@@ -10656,6 +10663,8 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 
 		bsw_stats->rx.rx_netpoll_discards +=
 			cpr->sw_stats.rx.rx_netpoll_discards;
+		bsw_stats->rx.rx_oom_discards +=
+			cpr->sw_stats.rx.rx_oom_discards;
 	}
 }
 
@@ -10675,6 +10684,7 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 
 	bsw_stats->rx.rx_netpoll_discards +=
 		bp->sw_stats_prev.rx.rx_netpoll_discards;
+	bsw_stats->rx.rx_oom_discards += bp->sw_stats_prev.rx.rx_oom_discards;
 }
 
 static void
@@ -10718,7 +10728,9 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 skip_current:
 	bnxt_add_prev_stats(bp, stats, &bsw_stats);
 
-	stats->rx_dropped += bsw_stats.rx.rx_netpoll_discards;
+	stats->rx_dropped +=
+		bsw_stats.rx.rx_netpoll_discards +
+		bsw_stats.rx.rx_oom_discards;
 
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5c2e9a06e959..2f37f03b7e2d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -939,6 +939,7 @@ struct bnxt_rx_sw_stats {
 	u64			rx_l4_csum_errors;
 	u64			rx_resets;
 	u64			rx_buf_errors;
+	u64			rx_oom_discards;
 	u64			rx_netpoll_discards;
 };
 
-- 
2.31.1

