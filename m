Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126963DF2B3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhHCQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:62834 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233560AbhHCQhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194013613"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194013613"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="636665237"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2021 09:37:08 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEt029968;
        Tue, 3 Aug 2021 17:37:04 +0100
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
Subject: [PATCH net-next 05/21] ethernet, dpaa2: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:25 +0200
Message-Id: <20210803163641.3743-6-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 driver has 4 XDP counters which align just fine with the
standard XDP stats. Convert the driver to use the new approach.

Note that those counters are stored per-channel, but originally
were being given to Ethtool as sums across all channels. This
change makes them per-channel in Ethtool as well by providing
a number of channels to the standard stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  4 +--
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 36 ++++++++++++++++---
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 8cb57f103d6b..fbba28fbb527 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -377,13 +377,13 @@ struct dpaa2_eth_ch_stats {
 	__u64 pull_err;
 	/* Number of CDANs; useful to estimate avg NAPI len */
 	__u64 cdan;
+	/* The rest of the structure does not show up in ethtool stats */
+	struct { } __eth_end;
 	/* XDP counters */
 	__u64 xdp_drop;
 	__u64 xdp_tx;
 	__u64 xdp_tx_err;
 	__u64 xdp_redirect;
-	/* The rest of the structure does not show up in ethtool stats */
-	struct { } __eth_end;
 	/* Must be last */
 	__u64 frames;
 };
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 95ae83905458..6529fa35c532 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -53,10 +53,6 @@ static char dpaa2_ethtool_extras[][ETH_GSTRING_LEN] = {
 	"[drv] dequeue portal busy",
 	"[drv] channel pull errors",
 	"[drv] cdan",
-	"[drv] xdp drop",
-	"[drv] xdp tx",
-	"[drv] xdp tx errors",
-	"[drv] xdp redirect",
 	/* FQ stats */
 	"[qbman] rx pending frames",
 	"[qbman] rx pending bytes",
@@ -317,6 +313,36 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
 }
 
+static int dpaa2_eth_get_std_stats_channels(struct net_device *net_dev,
+					    u32 sset)
+{
+	const struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	switch (sset) {
+	case ETH_SS_STATS_XDP:
+		return priv->num_channels;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void dpaa2_eth_get_xdp_stats(struct net_device *net_dev,
+				    struct ethtool_xdp_stats *xdp_stats)
+{
+	const struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	const struct dpaa2_eth_ch_stats *ch_stats;
+	u32 i;
+
+	for (i = 0; i < priv->num_channels; i++) {
+		ch_stats = &priv->channel[i]->stats;
+
+		xdp_stats[i].drop = ch_stats->xdp_drop;
+		xdp_stats[i].redirect = ch_stats->xdp_redirect;
+		xdp_stats[i].tx = ch_stats->xdp_tx;
+		xdp_stats[i].tx_errors = ch_stats->xdp_tx_err;
+	}
+}
+
 static int dpaa2_eth_prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
 				   void *key, void *mask, u64 *fields)
 {
@@ -836,4 +862,6 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_ts_info = dpaa2_eth_get_ts_info,
 	.get_tunable = dpaa2_eth_get_tunable,
 	.set_tunable = dpaa2_eth_set_tunable,
+	.get_std_stats_channels = dpaa2_eth_get_std_stats_channels,
+	.get_xdp_stats = dpaa2_eth_get_xdp_stats,
 };
-- 
2.31.1

