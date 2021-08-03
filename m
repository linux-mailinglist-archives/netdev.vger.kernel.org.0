Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6DA3DF2DC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhHCQjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:17023 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234530AbhHCQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213715316"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213715316"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="419720900"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2021 09:37:29 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF0029968;
        Tue, 3 Aug 2021 17:37:24 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 10/21] ethernet, mvneta: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:30 +0200
Message-Id: <20210803163641.3743-11-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace custom Ethtools XDP statistics with the standard infra based
one (7 basic fields).
This driver uses global [per-cpu] stats, no other callbacks needed.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 108 +++++++++++++-------------
 1 file changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f030d5b7bdee..9015c8b45395 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -345,13 +345,6 @@ enum {
 	ETHTOOL_STAT_EEE_WAKEUP,
 	ETHTOOL_STAT_SKB_ALLOC_ERR,
 	ETHTOOL_STAT_REFILL_ERR,
-	ETHTOOL_XDP_REDIRECT,
-	ETHTOOL_XDP_PASS,
-	ETHTOOL_XDP_DROP,
-	ETHTOOL_XDP_TX,
-	ETHTOOL_XDP_TX_ERR,
-	ETHTOOL_XDP_XMIT,
-	ETHTOOL_XDP_XMIT_DROPS,
 	ETHTOOL_MAX_STATS,
 };
 
@@ -406,13 +399,6 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
 	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
 	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
-	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
-	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
-	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
-	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
-	{ ETHTOOL_XDP_TX_ERR, T_SW, "rx_xdp_tx_errors", },
-	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
-	{ ETHTOOL_XDP_XMIT_DROPS, T_SW, "tx_xdp_xmit_drops", },
 };
 
 struct mvneta_stats {
@@ -4630,38 +4616,17 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 	for_each_possible_cpu(cpu) {
 		struct mvneta_pcpu_stats *stats;
 		u64 skb_alloc_error;
-		u64 xdp_xmit_drops;
 		u64 refill_error;
-		u64 xdp_redirect;
-		u64 xdp_tx_err;
-		u64 xdp_pass;
-		u64 xdp_drop;
-		u64 xdp_xmit;
-		u64 xdp_tx;
 
 		stats = per_cpu_ptr(pp->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			skb_alloc_error = stats->es.skb_alloc_error;
 			refill_error = stats->es.refill_error;
-			xdp_redirect = stats->es.ps.xdp_redirect;
-			xdp_pass = stats->es.ps.xdp_pass;
-			xdp_drop = stats->es.ps.xdp_drop;
-			xdp_xmit = stats->es.ps.xdp_xmit;
-			xdp_xmit_drops = stats->es.ps.xdp_xmit_drops;
-			xdp_tx = stats->es.ps.xdp_tx;
-			xdp_tx_err = stats->es.ps.xdp_tx_err;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
 		es->skb_alloc_error += skb_alloc_error;
 		es->refill_error += refill_error;
-		es->ps.xdp_redirect += xdp_redirect;
-		es->ps.xdp_pass += xdp_pass;
-		es->ps.xdp_drop += xdp_drop;
-		es->ps.xdp_xmit += xdp_xmit;
-		es->ps.xdp_xmit_drops += xdp_xmit_drops;
-		es->ps.xdp_tx += xdp_tx;
-		es->ps.xdp_tx_err += xdp_tx_err;
 	}
 }
 
@@ -4702,27 +4667,6 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_STAT_REFILL_ERR:
 				pp->ethtool_stats[i] = stats.refill_error;
 				break;
-			case ETHTOOL_XDP_REDIRECT:
-				pp->ethtool_stats[i] = stats.ps.xdp_redirect;
-				break;
-			case ETHTOOL_XDP_PASS:
-				pp->ethtool_stats[i] = stats.ps.xdp_pass;
-				break;
-			case ETHTOOL_XDP_DROP:
-				pp->ethtool_stats[i] = stats.ps.xdp_drop;
-				break;
-			case ETHTOOL_XDP_TX:
-				pp->ethtool_stats[i] = stats.ps.xdp_tx;
-				break;
-			case ETHTOOL_XDP_TX_ERR:
-				pp->ethtool_stats[i] = stats.ps.xdp_tx_err;
-				break;
-			case ETHTOOL_XDP_XMIT:
-				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
-				break;
-			case ETHTOOL_XDP_XMIT_DROPS:
-				pp->ethtool_stats[i] = stats.ps.xdp_xmit_drops;
-				break;
 			}
 			break;
 		}
@@ -4748,6 +4692,57 @@ static int mvneta_ethtool_get_sset_count(struct net_device *dev, int sset)
 	return -EOPNOTSUPP;
 }
 
+static void mvneta_ethtool_get_xdp_stats(struct net_device *dev,
+					 struct ethtool_xdp_stats *xdp_stats)
+{
+	const struct mvneta_port *pp = netdev_priv(dev);
+	u32 cpu;
+
+	xdp_stats->drop = 0;
+	xdp_stats->pass = 0;
+	xdp_stats->redirect = 0;
+	xdp_stats->tx = 0;
+	xdp_stats->tx_errors = 0;
+	xdp_stats->xmit = 0;
+	xdp_stats->xmit_drops = 0;
+
+	for_each_possible_cpu(cpu) {
+		const struct mvneta_pcpu_stats *stats;
+		const struct mvneta_stats *ps;
+		u64 xdp_xmit_drops;
+		u64 xdp_redirect;
+		u64 xdp_tx_err;
+		u64 xdp_pass;
+		u64 xdp_drop;
+		u64 xdp_xmit;
+		u64 xdp_tx;
+		u32 start;
+
+		stats = per_cpu_ptr(pp->stats, cpu);
+		ps = &stats->es.ps;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+
+			xdp_drop = ps->xdp_drop;
+			xdp_pass = ps->xdp_pass;
+			xdp_redirect = ps->xdp_redirect;
+			xdp_tx = ps->xdp_tx;
+			xdp_tx_err = ps->xdp_tx_err;
+			xdp_xmit = ps->xdp_xmit;
+			xdp_xmit_drops = ps->xdp_xmit_drops;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		xdp_stats->drop += xdp_drop;
+		xdp_stats->pass += xdp_pass;
+		xdp_stats->redirect += xdp_redirect;
+		xdp_stats->tx += xdp_tx;
+		xdp_stats->tx_errors += xdp_tx_err;
+		xdp_stats->xmit += xdp_xmit;
+		xdp_stats->xmit_drops += xdp_xmit_drops;
+	}
+}
+
 static u32 mvneta_ethtool_get_rxfh_indir_size(struct net_device *dev)
 {
 	return MVNETA_RSS_LU_TABLE_SIZE;
@@ -5025,6 +5020,7 @@ static const struct ethtool_ops mvneta_eth_tool_ops = {
 	.set_wol        = mvneta_ethtool_set_wol,
 	.get_eee	= mvneta_ethtool_get_eee,
 	.set_eee	= mvneta_ethtool_set_eee,
+	.get_xdp_stats	= mvneta_ethtool_get_xdp_stats,
 };
 
 /* Initialize hw */
-- 
2.31.1

