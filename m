Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094FB3DF2D1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhHCQiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:38:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:5348 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234477AbhHCQiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="211865584"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="211865584"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521316683"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2021 09:37:37 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF2029968;
        Tue, 3 Aug 2021 17:37:32 +0100
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
Subject: [PATCH net-next 12/21] ethernet, mvpp2: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:32 +0200
Message-Id: <20210803163641.3743-13-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert PPv2 driver to provide standard XDP statistics instead of
custom-defined Ethtool stats. This also allows to greatly simplify
stats filling code.
In the same fashion as mvneta, the driver uses global XDP counters.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 90 +++++--------------
 1 file changed, 20 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a3aee1a6d760..ed34f8fefced 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1824,16 +1824,6 @@ static void mvpp2_port_loopback_set(struct mvpp2_port *port,
 	writel(val, port->base + MVPP2_GMAC_CTRL_1_REG);
 }
 
-enum {
-	ETHTOOL_XDP_REDIRECT,
-	ETHTOOL_XDP_PASS,
-	ETHTOOL_XDP_DROP,
-	ETHTOOL_XDP_TX,
-	ETHTOOL_XDP_TX_ERR,
-	ETHTOOL_XDP_XMIT,
-	ETHTOOL_XDP_XMIT_DROPS,
-};
-
 struct mvpp2_ethtool_counter {
 	unsigned int offset;
 	const char string[ETH_GSTRING_LEN];
@@ -1926,21 +1916,10 @@ static const struct mvpp2_ethtool_counter mvpp2_ethtool_rxq_regs[] = {
 	{ MVPP2_RX_PKTS_BM_DROP_CTR, "rxq_%d_packets_bm_drops" },
 };
 
-static const struct mvpp2_ethtool_counter mvpp2_ethtool_xdp[] = {
-	{ ETHTOOL_XDP_REDIRECT, "rx_xdp_redirect", },
-	{ ETHTOOL_XDP_PASS, "rx_xdp_pass", },
-	{ ETHTOOL_XDP_DROP, "rx_xdp_drop", },
-	{ ETHTOOL_XDP_TX, "rx_xdp_tx", },
-	{ ETHTOOL_XDP_TX_ERR, "rx_xdp_tx_errors", },
-	{ ETHTOOL_XDP_XMIT, "tx_xdp_xmit", },
-	{ ETHTOOL_XDP_XMIT_DROPS, "tx_xdp_xmit_drops", },
-};
-
 #define MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs)	(ARRAY_SIZE(mvpp2_ethtool_mib_regs) + \
 						 ARRAY_SIZE(mvpp2_ethtool_port_regs) + \
 						 (ARRAY_SIZE(mvpp2_ethtool_txq_regs) * (ntxqs)) + \
-						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)) + \
-						 ARRAY_SIZE(mvpp2_ethtool_xdp))
+						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)))
 
 static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 				      u8 *data)
@@ -1979,20 +1958,23 @@ static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 			data += ETH_GSTRING_LEN;
 		}
 	}
-
-	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_xdp); i++) {
-		strscpy(data, mvpp2_ethtool_xdp[i].string,
-			ETH_GSTRING_LEN);
-		data += ETH_GSTRING_LEN;
-	}
 }
 
-static void
-mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
+static void mvpp2_ethtool_get_xdp_stats(struct net_device *dev,
+					struct ethtool_xdp_stats *xdp_stats)
 {
+	const struct mvpp2_port *port = netdev_priv(dev);
 	unsigned int start;
 	unsigned int cpu;
 
+	xdp_stats->redirect = 0;
+	xdp_stats->pass = 0;
+	xdp_stats->drop = 0;
+	xdp_stats->xmit = 0;
+	xdp_stats->xmit_drops = 0;
+	xdp_stats->tx = 0;
+	xdp_stats->tx_errors = 0;
+
 	/* Gather XDP Statistics */
 	for_each_possible_cpu(cpu) {
 		struct mvpp2_pcpu_stats *cpu_stats;
@@ -2016,20 +1998,18 @@ mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
 			xdp_tx_err   = cpu_stats->xdp_tx_err;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		xdp_stats->xdp_redirect += xdp_redirect;
-		xdp_stats->xdp_pass   += xdp_pass;
-		xdp_stats->xdp_drop += xdp_drop;
-		xdp_stats->xdp_xmit   += xdp_xmit;
-		xdp_stats->xdp_xmit_drops += xdp_xmit_drops;
-		xdp_stats->xdp_tx   += xdp_tx;
-		xdp_stats->xdp_tx_err   += xdp_tx_err;
+		xdp_stats->redirect += xdp_redirect;
+		xdp_stats->pass += xdp_pass;
+		xdp_stats->drop += xdp_drop;
+		xdp_stats->xmit += xdp_xmit;
+		xdp_stats->xmit_drops += xdp_xmit_drops;
+		xdp_stats->tx += xdp_tx;
+		xdp_stats->tx_errors  += xdp_tx_err;
 	}
 }
 
 static void mvpp2_read_stats(struct mvpp2_port *port)
 {
-	struct mvpp2_pcpu_stats xdp_stats = {};
-	const struct mvpp2_ethtool_counter *s;
 	u64 *pstats;
 	int i, q;
 
@@ -2057,37 +2037,6 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 			*pstats++ += mvpp2_read_index(port->priv,
 						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
-
-	/* Gather XDP Statistics */
-	mvpp2_get_xdp_stats(port, &xdp_stats);
-
-	for (i = 0, s = mvpp2_ethtool_xdp;
-		 s < mvpp2_ethtool_xdp + ARRAY_SIZE(mvpp2_ethtool_xdp);
-	     s++, i++) {
-		switch (s->offset) {
-		case ETHTOOL_XDP_REDIRECT:
-			*pstats++ = xdp_stats.xdp_redirect;
-			break;
-		case ETHTOOL_XDP_PASS:
-			*pstats++ = xdp_stats.xdp_pass;
-			break;
-		case ETHTOOL_XDP_DROP:
-			*pstats++ = xdp_stats.xdp_drop;
-			break;
-		case ETHTOOL_XDP_TX:
-			*pstats++ = xdp_stats.xdp_tx;
-			break;
-		case ETHTOOL_XDP_TX_ERR:
-			*pstats++ = xdp_stats.xdp_tx_err;
-			break;
-		case ETHTOOL_XDP_XMIT:
-			*pstats++ = xdp_stats.xdp_xmit;
-			break;
-		case ETHTOOL_XDP_XMIT_DROPS:
-			*pstats++ = xdp_stats.xdp_xmit_drops;
-			break;
-		}
-	}
 }
 
 static void mvpp2_gather_hw_statistics(struct work_struct *work)
@@ -5735,6 +5684,7 @@ static const struct ethtool_ops mvpp2_eth_tool_ops = {
 	.set_rxfh		= mvpp2_ethtool_set_rxfh,
 	.get_rxfh_context	= mvpp2_ethtool_get_rxfh_context,
 	.set_rxfh_context	= mvpp2_ethtool_set_rxfh_context,
+	.get_xdp_stats		= mvpp2_ethtool_get_xdp_stats,
 };
 
 /* Used for PPv2.1, or PPv2.2 with the old Device Tree binding that
-- 
2.31.1

