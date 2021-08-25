Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF23F7EF6
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhHYXTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhHYXTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 19:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F01E610CE;
        Wed, 25 Aug 2021 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629933514;
        bh=lozxBCSeJDigd15rfYvNs2OPJ5f6wSM8ZObjOJtEaJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my6Fqg29faGQxWIeKugpQnZq5ppNZXzn+Z0oRIeb6gmTyCoTFOxmz+m6qYNane/gy
         tq77XuifUHY9eWNYzQV4E8EyuppyVIeAbeGl2wB2+lRIyii10u4vtvTlZ0ZNe6l9Qs
         bMYeSjUfRoiKF/hLyjYnPttjjj+xjDNReDFSY8wwUZsvlVNPCRKnXZox2Wva/GtIL4
         8MUeTxwc3wNiNgItaFOis2HHbKwMgEmtFhGMhizIFT//7ysnZ6XJ5C2T2eVSj5OOo3
         imp8x8YlqsyYoalSzsLOStVQDP90oZzwLmSyEKnd/4CUYrA8SAjA06Pf0AnzBJrK7s
         Ec5u/Nh+DBqvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] bnxt: count discards due to memory allocation errors
Date:   Wed, 25 Aug 2021 16:18:30 -0700
Message-Id: <20210825231830.2748915-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210825231830.2748915-1-kuba@kernel.org>
References: <20210825231830.2748915-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count packets dropped due to buffer or skb allocation errors.
Report as part of rx_dropped, and per-queue in ethtool
(retaining only the former across down/up cycles).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 14 +++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

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
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 25f1327aedb6..f8a28021389b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -188,6 +188,7 @@ static const char * const bnxt_rx_sw_stats_str[] = {
 	"rx_l4_csum_errors",
 	"rx_resets",
 	"rx_buf_errors",
+	"rx_oom_discards",
 };
 
 static const char * const bnxt_cmn_sw_stats_str[] = {
-- 
2.31.1

