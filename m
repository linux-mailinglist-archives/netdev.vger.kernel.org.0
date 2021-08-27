Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5FC3F9BB7
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245477AbhH0P2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245451AbhH0P2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:28:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D922561008;
        Fri, 27 Aug 2021 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630078069;
        bh=XcH55H2TtAk5vnHYmy3fBlbrsFNq3owOTONkUMrhJZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTNM3B91+5FHHrU8+NE3oOXi/dGcHvjx5EhBdE/Ox3vckkxXp90dHWxka+3dHpkHA
         Xa2D88FraiAnvi/heXqKkhklCykzZSn7tlg5wFexDuO7627qoa3/8YY3D3qlciYhUi
         C5bPepyiGTEDa8oPiVVMu5UFtzD9gaShvtZDEWQvwgFq6Px5t5wFA6IODCSpAlcfq1
         vMF8H/FQaOgJUwo8uoUsRrBWpE6CeldDi//0055xqYtfH6I/Fq12EmFsTjkUOMeuKS
         n2fQ5bmsP6aEV0xycdDlFiYkTAr3JCUdNiwC4U1ovtUc6wWWWPrhg/oEl74368wsRx
         udQspLRfiUITQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 2/2] bnxt: count discards due to memory allocation errors
Date:   Fri, 27 Aug 2021 08:27:45 -0700
Message-Id: <20210827152745.68812-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827152745.68812-1-kuba@kernel.org>
References: <20210827152745.68812-1-kuba@kernel.org>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 ++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 95c1c4237fa8..31e80d90ee98 100644
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
@@ -10651,7 +10658,9 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 
 		stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
 
-		stats->rx_dropped += cpr->sw_stats.rx.rx_netpoll_discards;
+		stats->rx_dropped +=
+			cpr->sw_stats.rx.rx_netpoll_discards +
+			cpr->sw_stats.rx.rx_oom_discards;
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c8cdc770426c..dc96dd6957c9 100644
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

