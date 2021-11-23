Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869D345A8DA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhKWQpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:49123 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236152AbhKWQpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="233778651"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="233778651"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="553484662"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2021 08:41:33 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wn016784;
        Tue, 23 Nov 2021 16:41:31 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 11/26] sf100, sfx: implement generic XDP stats callbacks
Date:   Tue, 23 Nov 2021 17:39:40 +0100
Message-Id: <20211123163955.154512-12-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export 4 per-channel XDP counters for both sf100 and sfx drivers
using generic XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  2 ++
 drivers/net/ethernet/sfc/efx.c          |  2 ++
 drivers/net/ethernet/sfc/efx_common.c   | 42 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h   |  3 ++
 4 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..0367f7e043d8 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -219,6 +219,8 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_start_xmit         = ef100_hard_start_xmit,
 	.ndo_tx_timeout         = efx_watchdog,
 	.ndo_get_stats64        = efx_net_stats,
+	.ndo_get_xdp_stats_nch  = efx_get_xdp_stats_nch,
+	.ndo_get_xdp_stats      = efx_get_xdp_stats,
 	.ndo_change_mtu         = efx_change_mtu,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = efx_set_mac_address,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a8c252e2b252..a6a015c4d3b4 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -588,6 +588,8 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_open		= efx_net_open,
 	.ndo_stop		= efx_net_stop,
 	.ndo_get_stats64	= efx_net_stats,
+	.ndo_get_xdp_stats_nch	= efx_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= efx_get_xdp_stats,
 	.ndo_tx_timeout		= efx_watchdog,
 	.ndo_start_xmit		= efx_hard_start_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f187631b2c5c..c2bf79fd66b4 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -606,6 +606,48 @@ void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
 	spin_unlock_bh(&efx->stats_lock);
 }

+int efx_get_xdp_stats_nch(const struct net_device *net_dev, u32 attr_id)
+{
+	const struct efx_nic *efx = netdev_priv(net_dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return efx->n_channels;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int efx_get_xdp_stats(const struct net_device *net_dev, u32 attr_id,
+		      void *attr_data)
+{
+	struct ifla_xdp_stats *xdp_stats = attr_data;
+	struct efx_nic *efx = netdev_priv(net_dev);
+	const struct efx_channel *channel;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	spin_lock_bh(&efx->stats_lock);
+
+	efx_for_each_channel(channel, efx) {
+		xdp_stats->drop = channel->n_rx_xdp_drops;
+		xdp_stats->errors = channel->n_rx_xdp_bad_drops;
+		xdp_stats->redirect = channel->n_rx_xdp_redirect;
+		xdp_stats->tx = channel->n_rx_xdp_tx;
+
+		xdp_stats++;
+	}
+
+	spin_unlock_bh(&efx->stats_lock);
+
+	return 0;
+}
+
 /* Push loopback/power/transmit disable settings to the PHY, and reconfigure
  * the MAC appropriately. All other PHY configuration changes are pushed
  * through phy_op->set_settings(), and pushed asynchronously to the MAC
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..987d7c6608a2 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -32,6 +32,9 @@ void efx_start_all(struct efx_nic *efx);
 void efx_stop_all(struct efx_nic *efx);

 void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
+int efx_get_xdp_stats_nch(const struct net_device *net_dev, u32 attr_id);
+int efx_get_xdp_stats(const struct net_device *net_dev, u32 attr_id,
+		      void *attr_data);

 int efx_create_reset_workqueue(void);
 void efx_queue_reset_work(struct efx_nic *efx);
--
2.33.1

