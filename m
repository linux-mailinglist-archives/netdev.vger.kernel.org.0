Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5660B1606A5
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgBPVI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgBPVIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:25 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7F1208C4;
        Sun, 16 Feb 2020 21:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887305;
        bh=YFetBIA2X5kPdwuJMmxRPGv9j0SfUdrvsD1YDUgSOJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GC0tUbiaFFneU/QOyMPqjQeuVqIJQFb0Y6np05PcOMadVjD3ZEDE6CfUFgdb+/90P
         EZm0w7EthugtAVP6TMsELXHnFWNzpU1jqZG/95UTErxZMfROSHMsGrpQNVKTVsqNom
         SfKjq8ydgbsDVtRhoYyvq9jC2V7ryWrABZCY/GqQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to ethtool
Date:   Sun, 16 Feb 2020 22:07:32 +0100
Message-Id: <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add xdp_redirect, xdp_pass, xdp_drop and xdp_tx counters
to ethtool statistics

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 45 +++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index d41fc7044fa6..e4eb2bd097d4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -341,6 +341,10 @@ enum {
 	ETHTOOL_STAT_EEE_WAKEUP,
 	ETHTOOL_STAT_SKB_ALLOC_ERR,
 	ETHTOOL_STAT_REFILL_ERR,
+	ETHTOOL_XDP_REDIRECT,
+	ETHTOOL_XDP_PASS,
+	ETHTOOL_XDP_DROP,
+	ETHTOOL_XDP_TX,
 	ETHTOOL_MAX_STATS,
 };
 
@@ -395,6 +399,10 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
 	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
+	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
+	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
+	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
+	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
 };
 
 struct mvneta_stats {
@@ -402,6 +410,11 @@ struct mvneta_stats {
 	u64	rx_bytes;
 	u64	tx_packets;
 	u64	tx_bytes;
+	/* xdp */
+	u64	xdp_redirect;
+	u64	xdp_pass;
+	u64	xdp_drop;
+	u64	xdp_tx;
 };
 
 struct mvneta_ethtool_stats {
@@ -1957,6 +1970,10 @@ mvneta_update_stats(struct mvneta_port *pp,
 	u64_stats_update_begin(&stats->syncp);
 	stats->es.ps.rx_packets += ps->rx_packets;
 	stats->es.ps.rx_bytes += ps->rx_bytes;
+	/* xdp */
+	stats->es.ps.xdp_redirect += ps->xdp_redirect;
+	stats->es.ps.xdp_pass += ps->xdp_pass;
+	stats->es.ps.xdp_drop += ps->xdp_drop;
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -2033,6 +2050,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	u64_stats_update_begin(&stats->syncp);
 	stats->es.ps.tx_bytes += xdpf->len;
 	stats->es.ps.tx_packets++;
+	stats->es.ps.xdp_tx++;
 	u64_stats_update_end(&stats->syncp);
 
 	mvneta_txq_inc_put(txq);
@@ -2114,6 +2132,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 	switch (act) {
 	case XDP_PASS:
+		stats->xdp_pass++;
 		return MVNETA_XDP_PASS;
 	case XDP_REDIRECT: {
 		int err;
@@ -2126,6 +2145,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 					     len, true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
+			stats->xdp_redirect++;
 		}
 		break;
 	}
@@ -2147,6 +2167,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 				     virt_to_head_page(xdp->data),
 				     len, true);
 		ret = MVNETA_XDP_DROPPED;
+		stats->xdp_drop++;
 		break;
 	}
 
@@ -4464,16 +4485,28 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		struct mvneta_pcpu_stats *stats;
 		u64 skb_alloc_error;
 		u64 refill_error;
+		u64 xdp_redirect;
+		u64 xdp_pass;
+		u64 xdp_drop;
+		u64 xdp_tx;
 
 		stats = per_cpu_ptr(pp->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			skb_alloc_error = stats->es.skb_alloc_error;
 			refill_error = stats->es.refill_error;
+			xdp_redirect = stats->es.ps.xdp_redirect;
+			xdp_pass = stats->es.ps.xdp_pass;
+			xdp_drop = stats->es.ps.xdp_drop;
+			xdp_tx = stats->es.ps.xdp_tx;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
 		es->skb_alloc_error += skb_alloc_error;
 		es->refill_error += refill_error;
+		es->ps.xdp_redirect += xdp_redirect;
+		es->ps.xdp_pass += xdp_pass;
+		es->ps.xdp_drop += xdp_drop;
+		es->ps.xdp_tx += xdp_tx;
 	}
 }
 
@@ -4514,6 +4547,18 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_STAT_REFILL_ERR:
 				pp->ethtool_stats[i] = stats.refill_error;
 				break;
+			case ETHTOOL_XDP_REDIRECT:
+				pp->ethtool_stats[i] = stats.ps.xdp_redirect;
+				break;
+			case ETHTOOL_XDP_PASS:
+				pp->ethtool_stats[i] = stats.ps.xdp_pass;
+				break;
+			case ETHTOOL_XDP_DROP:
+				pp->ethtool_stats[i] = stats.ps.xdp_drop;
+				break;
+			case ETHTOOL_XDP_TX:
+				pp->ethtool_stats[i] = stats.ps.xdp_tx;
+				break;
 			}
 			break;
 		}
-- 
2.24.1

