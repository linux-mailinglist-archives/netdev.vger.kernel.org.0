Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249053DF2D8
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhHCQjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:39:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:60864 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhHCQiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:38:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213766160"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213766160"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="500883687"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2021 09:37:41 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahF3029968;
        Tue, 3 Aug 2021 17:37:36 +0100
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
Subject: [PATCH net-next 13/21] ethernet, sfc: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:33 +0200
Message-Id: <20210803163641.3743-14-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just like DPAA2 driver, EF{100,X} store XDP stats per-channel, but
present them as the sums across all channels.
Switch to the standard per-channel XDP stats. n_rx_xdp_bad_drops
goes as "general XDP errors", because driver uses just one counter
for all kinds of errors.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 ++
 drivers/net/ethernet/sfc/ethtool.c        |  2 ++
 drivers/net/ethernet/sfc/ethtool_common.c | 35 ++++++++++++++++++++---
 drivers/net/ethernet/sfc/ethtool_common.h |  3 ++
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 835c838b7dfa..c4797fefef2e 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -49,6 +49,8 @@ const struct ethtool_ops ef100_ethtool_ops = {
 	.get_fecparam		= efx_ethtool_get_fecparam,
 	.set_fecparam		= efx_ethtool_set_fecparam,
 	.get_ethtool_stats	= efx_ethtool_get_stats,
+	.get_std_stats_channels	= efx_ethtool_get_std_stats_channels,
+	.get_xdp_stats		= efx_ethtool_get_xdp_stats,
 	.get_rxnfc              = efx_ethtool_get_rxnfc,
 	.set_rxnfc              = efx_ethtool_set_rxnfc,
 	.reset                  = efx_ethtool_reset,
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 058d9fe41d99..307724275a3e 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -269,4 +269,6 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.get_fec_stats		= efx_ethtool_get_fec_stats,
 	.get_fecparam		= efx_ethtool_get_fecparam,
 	.set_fecparam		= efx_ethtool_set_fecparam,
+	.get_std_stats_channels	= efx_ethtool_get_std_stats_channels,
+	.get_xdp_stats		= efx_ethtool_get_xdp_stats,
 };
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bf1443539a1a..4aa6792d5795 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -87,10 +87,6 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_frm_trunc),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_events),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_merge_packets),
-	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_drops),
-	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
-	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
-	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
 #ifdef CONFIG_RFS_ACCEL
 	EFX_ETHTOOL_UINT_CHANNEL_STAT_NO_N(rfs_filter_count),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_succeeded),
@@ -557,6 +553,37 @@ void efx_ethtool_get_stats(struct net_device *net_dev,
 	efx_ptp_update_stats(efx, data);
 }
 
+int efx_ethtool_get_std_stats_channels(struct net_device *net_dev, u32 sset)
+{
+	const struct efx_nic *efx = netdev_priv(net_dev);
+
+	switch (sset) {
+	case ETH_SS_STATS_XDP:
+		return efx->n_channels;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void efx_ethtool_get_xdp_stats(struct net_device *net_dev,
+			       struct ethtool_xdp_stats *xdp_stats)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	const struct efx_channel *channel;
+
+	spin_lock_bh(&efx->stats_lock);
+
+	efx_for_each_channel(channel, efx) {
+		xdp_stats->drop = channel->n_rx_xdp_drops;
+		xdp_stats->errors = channel->n_rx_xdp_bad_drops;
+		xdp_stats->redirect = channel->n_rx_xdp_redirect;
+		xdp_stats->tx = channel->n_rx_xdp_tx;
+		xdp_stats++;
+	}
+
+	spin_unlock_bh(&efx->stats_lock);
+}
+
 /* This must be called with rtnl_lock held. */
 int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
 				   struct ethtool_link_ksettings *cmd)
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 659491932101..bb2a43873ba1 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -30,6 +30,9 @@ void efx_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats __attribute__ ((unused)),
 			   u64 *data);
+int efx_ethtool_get_std_stats_channels(struct net_device *net_dev, u32 sset);
+void efx_ethtool_get_xdp_stats(struct net_device *net_dev,
+			       struct ethtool_xdp_stats *xdp_stats);
 int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
 				   struct ethtool_link_ksettings *out);
 int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
-- 
2.31.1

