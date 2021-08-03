Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A013DF2E9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhHCQja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:42242 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhHCQib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299318875"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="299318875"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:38:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="466746585"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 03 Aug 2021 09:37:58 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF7029968;
        Tue, 3 Aug 2021 17:37:53 +0100
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
Subject: [PATCH net-next 17/21] veth: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:37 +0200
Message-Id: <20210803163641.3743-18-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

veth has 7 per-channel XDP counters which could be aligned to the
standard XDP stats. Peer stats are here too as well, with the
original channel numbering logics.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 91 +++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d7e95f09e19d..79614d8e88bd 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -94,22 +94,10 @@ struct veth_q_stat_desc {
 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "packets",		VETH_RQ_STAT(packets) },
 	{ "bytes",		VETH_RQ_STAT(bytes) },
-	{ "xdp_errors",		VETH_RQ_STAT(xdp_errors) },
-	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
-	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
-	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
-	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
 };
 
 #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
 
-static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
-	{ "xdp_xmit",		VETH_RQ_STAT(peer_tq_xdp_xmit) },
-	{ "xdp_xmit_drops",	VETH_RQ_STAT(peer_tq_xdp_xmit_drops) },
-};
-
-#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
-
 static struct {
 	const char string[ETH_GSTRING_LEN];
 } ethtool_stats_keys[] = {
@@ -149,14 +137,6 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				p += ETH_GSTRING_LEN;
 			}
 		}
-		for (i = 0; i < dev->real_num_tx_queues; i++) {
-			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN,
-					 "tx_queue_%u_%.18s",
-					 i, veth_tq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
-		}
 		break;
 	}
 }
@@ -166,8 +146,7 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(ethtool_stats_keys) +
-		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
-		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
+		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -176,8 +155,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 static void veth_get_ethtool_stats(struct net_device *dev,
 		struct ethtool_stats *stats, u64 *data)
 {
-	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
-	struct net_device *peer = rtnl_dereference(priv->peer);
+	const struct veth_priv *priv = netdev_priv(dev);
+	const struct net_device *peer = rtnl_dereference(priv->peer);
 	int i, j, idx;
 
 	data[0] = peer ? peer->ifindex : 0;
@@ -197,25 +176,67 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
 		idx += VETH_RQ_STATS_LEN;
 	}
+}
+
+static int veth_get_std_stats_channels(struct net_device *dev, u32 sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS_XDP:
+		return max(dev->real_num_rx_queues, dev->real_num_tx_queues);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void veth_get_xdp_stats(struct net_device *dev,
+			       struct ethtool_xdp_stats *xdp_stats)
+{
+	const struct veth_priv *priv = netdev_priv(dev);
+	const struct net_device *peer = rtnl_dereference(priv->peer);
+	const struct veth_rq_stats *rq_stats;
+	struct ethtool_xdp_stats *iter;
+	u64 xmit, xmit_drops;
+	u32 i, start;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		rq_stats = &priv->rq[i].stats;
+		iter = xdp_stats + i;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+
+			iter->errors = rq_stats->vs.xdp_errors;
+			iter->redirect = rq_stats->vs.xdp_redirect;
+			iter->drop = rq_stats->vs.xdp_drops;
+			iter->tx = rq_stats->vs.xdp_tx;
+			iter->tx_errors = rq_stats->vs.xdp_tx_err;
+		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+	}
 
 	if (!peer)
 		return;
 
-	rcv_priv = netdev_priv(peer);
+	for (i = 0; i < dev->real_num_tx_queues; i++) {
+		iter = xdp_stats + i;
+		iter->xmit = 0;
+		iter->xmit_drops = 0;
+	}
+
+	priv = netdev_priv(peer);
+
 	for (i = 0; i < peer->real_num_rx_queues; i++) {
-		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
-		const void *base = (void *)&rq_stats->vs;
-		unsigned int start, tx_idx = idx;
-		size_t offset;
+		rq_stats = &priv->rq[i].stats;
+		iter = xdp_stats + (i % dev->real_num_tx_queues);
 
-		tx_idx += (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
 		do {
 			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
-			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
-				offset = veth_tq_stats_desc[j].offset;
-				data[tx_idx + j] += *(u64 *)(base + offset);
-			}
+
+			xmit = rq_stats->vs.peer_tq_xdp_xmit;
+			xmit_drops = rq_stats->vs.peer_tq_xdp_xmit_drops;
 		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+
+		iter->xmit += xmit;
+		iter->xmit_drops += xmit_drops;
 	}
 }
 
@@ -241,6 +262,8 @@ static const struct ethtool_ops veth_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_channels		= veth_get_channels,
 	.set_channels		= veth_set_channels,
+	.get_std_stats_channels	= veth_get_std_stats_channels,
+	.get_xdp_stats		= veth_get_xdp_stats,
 };
 
 /* general routines */
-- 
2.31.1

