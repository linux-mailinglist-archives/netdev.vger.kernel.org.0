Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF87161E28
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 01:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgBRAPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 19:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:32780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgBRAPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 19:15:07 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14541207FD;
        Tue, 18 Feb 2020 00:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581984906;
        bh=wy2pRQV+bU+yOoXVAQAXXPoSzon9kgDk14ziMHLv6IE=;
        h=From:To:Cc:Subject:Date:From;
        b=mR+EzqiQqBhBrktMURSKmDttWLwGKALjseyBBQBm5WzDoK8PaEjq0cZSLnI4fN4as
         qqo58tAI3NtC3CJhREMRIYcvRD/xjBiYMV5R5az1aHizAGeHsNmE9iI/qXc0qIiMKY
         3Rmj/Fe84ABCOLg5pNTMO+v2dWPUjHrmt6NjqNms=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, andrew@lunn.ch, brouer@redhat.com,
        dsahern@kernel.org, bpf@vger.kernel.org
Subject: [RFC net-next] net: mvneta: align xdp stats naming scheme to mlx5 driver
Date:   Tue, 18 Feb 2020 01:14:29 +0100
Message-Id: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce "rx" prefix in the name scheme for xdp counters
on rx path.
Differentiate between XDP_TX and ndo_xdp_xmit counters

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b7045b6a15c2..6223700dc3df 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -344,6 +344,7 @@ enum {
 	ETHTOOL_XDP_REDIRECT,
 	ETHTOOL_XDP_PASS,
 	ETHTOOL_XDP_DROP,
+	ETHTOOL_XDP_XMIT,
 	ETHTOOL_XDP_TX,
 	ETHTOOL_MAX_STATS,
 };
@@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
 	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
-	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
-	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
-	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
-	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
+	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
+	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
+	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
+	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx_xmit", },
+	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
 };
 
 struct mvneta_stats {
@@ -414,6 +416,7 @@ struct mvneta_stats {
 	u64	xdp_redirect;
 	u64	xdp_pass;
 	u64	xdp_drop;
+	u64	xdp_xmit;
 	u64	xdp_tx;
 };
 
@@ -2050,7 +2053,10 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 	u64_stats_update_begin(&stats->syncp);
 	stats->es.ps.tx_bytes += xdpf->len;
 	stats->es.ps.tx_packets++;
-	stats->es.ps.xdp_tx++;
+	if (buf->type == MVNETA_TYPE_XDP_NDO)
+		stats->es.ps.xdp_xmit++;
+	else
+		stats->es.ps.xdp_tx++;
 	u64_stats_update_end(&stats->syncp);
 
 	mvneta_txq_inc_put(txq);
@@ -4484,6 +4490,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		u64 xdp_redirect;
 		u64 xdp_pass;
 		u64 xdp_drop;
+		u64 xdp_xmit;
 		u64 xdp_tx;
 
 		stats = per_cpu_ptr(pp->stats, cpu);
@@ -4494,6 +4501,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 			xdp_redirect = stats->es.ps.xdp_redirect;
 			xdp_pass = stats->es.ps.xdp_pass;
 			xdp_drop = stats->es.ps.xdp_drop;
+			xdp_xmit = stats->es.ps.xdp_xmit;
 			xdp_tx = stats->es.ps.xdp_tx;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
@@ -4502,6 +4510,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		es->ps.xdp_redirect += xdp_redirect;
 		es->ps.xdp_pass += xdp_pass;
 		es->ps.xdp_drop += xdp_drop;
+		es->ps.xdp_xmit += xdp_xmit;
 		es->ps.xdp_tx += xdp_tx;
 	}
 }
@@ -4555,6 +4564,9 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_XDP_TX:
 				pp->ethtool_stats[i] = stats.ps.xdp_tx;
 				break;
+			case ETHTOOL_XDP_XMIT:
+				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
+				break;
 			}
 			break;
 		}
-- 
2.24.1

