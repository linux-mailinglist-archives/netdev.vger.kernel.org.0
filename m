Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948863F9BB6
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245470AbhH0P2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245400AbhH0P2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8981960FDA;
        Fri, 27 Aug 2021 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630078068;
        bh=t7fWbLVsWiMa0N2/aC7fRhxZX2LPycloDIMDjrAfWsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lz+L+s2r4nHDOA1paTXJm407DML/GAU971LY1NBLq7qbnaVSnkYTQDeSM/9DKT46t
         8kk3vRs5KFK1dQaMf9SsHYlqtzk0788BrWN26ArfzdEFw53fxcaCZx18G7rYBPRCdG
         hWi74BH2zR/HYVDld/1gXr1dXFjjwRegP9FqTKeOlFq97IcsyWAtb4U7e0kyFy77F2
         VBk/hG4En9bSw0zsSW7sGRGDO9MYnR6Nrq60bUsLKsDulNR5z9L4oDjzM468kXBlQG
         8jJOKr//JTe2T4wPdJtlXd/n1LPPtIrlBPEBeQexT8d7qDKybUtm7t3pYTkRp43/Mh
         diHyDhgxE0CDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 1/2] bnxt: count packets discarded because of netpoll
Date:   Fri, 27 Aug 2021 08:27:44 -0700
Message-Id: <20210827152745.68812-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827152745.68812-1-kuba@kernel.org>
References: <20210827152745.68812-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt may discard packets if Rx completions are consumed
in an attempt to let netpoll make progress. It should be
extremely rare in practice but nonetheless such events
should be counted.

Since completion ring memory is allocated dynamically use
a similar scheme to what is done for HW stats to save them.

Report the stats in rx_dropped and per-netdev ethtool
counter. Chances that users care which ring dropped are
very low.

v3: only save the stat to rx_dropped on reset,
rx_total_netpoll_discards will now only show drops since
last reset, similar to other "total_discard" counters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: don't count ret == 0 case [Michael]
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 9 ++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 4 ++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ee66d410c82c..95c1c4237fa8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2003,6 +2003,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	struct rx_cmp *rxcmp;
 	u16 cp_cons;
 	u8 cmp_type;
+	int ret;
 
 	cp_cons = RING_CMP(tmp_raw_cons);
 	rxcmp = (struct rx_cmp *)
@@ -2031,7 +2032,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 		tpa_end1->rx_tpa_end_cmp_errors_v2 |=
 			cpu_to_le32(RX_TPA_END_CMP_ERRORS);
 	}
-	return bnxt_rx_pkt(bp, cpr, raw_cons, event);
+	ret = bnxt_rx_pkt(bp, cpr, raw_cons, event);
+	if (ret && ret != -EBUSY)
+		cpr->sw_stats.rx.rx_netpoll_discards += 1;
+	return ret;
 }
 
 u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)
@@ -10646,6 +10650,8 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 		stats->multicast += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
 
 		stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
+
+		stats->rx_dropped += cpr->sw_stats.rx.rx_netpoll_discards;
 	}
 }
 
@@ -10660,6 +10666,7 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 	stats->tx_bytes += prev_stats->tx_bytes;
 	stats->rx_missed_errors += prev_stats->rx_missed_errors;
 	stats->multicast += prev_stats->multicast;
+	stats->rx_dropped += prev_stats->rx_dropped;
 	stats->tx_dropped += prev_stats->tx_dropped;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 7b989b6e4f6e..c8cdc770426c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -939,6 +939,7 @@ struct bnxt_rx_sw_stats {
 	u64			rx_l4_csum_errors;
 	u64			rx_resets;
 	u64			rx_buf_errors;
+	u64			rx_netpoll_discards;
 };
 
 struct bnxt_cmn_sw_stats {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9f8c72d95228..5852ae3b26a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -307,6 +307,7 @@ static const char * const bnxt_cmn_sw_stats_str[] = {
 enum {
 	RX_TOTAL_DISCARDS,
 	TX_TOTAL_DISCARDS,
+	RX_NETPOLL_DISCARDS,
 };
 
 static struct {
@@ -315,6 +316,7 @@ static struct {
 } bnxt_sw_func_stats[] = {
 	{0, "rx_total_discard_pkts"},
 	{0, "tx_total_discard_pkts"},
+	{0, "rx_total_netpoll_discards"},
 };
 
 #define NUM_RING_RX_SW_STATS		ARRAY_SIZE(bnxt_rx_sw_stats_str)
@@ -603,6 +605,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			BNXT_GET_RING_STATS64(sw_stats, rx_discard_pkts);
 		bnxt_sw_func_stats[TX_TOTAL_DISCARDS].counter +=
 			BNXT_GET_RING_STATS64(sw_stats, tx_discard_pkts);
+		bnxt_sw_func_stats[RX_NETPOLL_DISCARDS].counter +=
+			cpr->sw_stats.rx.rx_netpoll_discards;
 	}
 
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++, j++)
-- 
2.31.1

