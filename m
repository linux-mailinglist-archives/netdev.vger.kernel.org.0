Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53D45A8C9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhKWQpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:49123 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236471AbhKWQo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="233778645"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="233778645"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="553484649"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2021 08:41:31 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wm016784;
        Tue, 23 Nov 2021 16:41:28 GMT
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
Subject: [PATCH v2 net-next 10/26] mlx5: provide generic XDP stats callbacks
Date:   Tue, 23 Nov 2021 17:39:39 +0100
Message-Id: <20211123163955.154512-11-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 driver has a bunch of per-channel stats for XDP. 7 and 5 of
them can be exported through generic XDP stats infra for XDP and XSK
correspondingly.
Add necessary calbacks for that. Note that the driver doesn't expose
XSK stats if XSK setup has never been requested.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 69 +++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 48b12ee44b8d..cc8cf3ff7d49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1212,4 +1212,9 @@ int mlx5e_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate, int max_t
 int mlx5e_get_vf_config(struct net_device *dev, int vf, struct ifla_vf_info *ivi);
 int mlx5e_get_vf_stats(struct net_device *dev, int vf, struct ifla_vf_stats *vf_stats);
 #endif
+
+int mlx5e_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id);
+int mlx5e_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+			void *attr_data);
+
 #endif /* __MLX5_EN_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..d5b3abf09c82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4532,6 +4532,8 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_setup_tc            = mlx5e_setup_tc,
 	.ndo_select_queue        = mlx5e_select_queue,
 	.ndo_get_stats64         = mlx5e_get_stats,
+	.ndo_get_xdp_stats_nch   = mlx5e_get_xdp_stats_nch,
+	.ndo_get_xdp_stats       = mlx5e_get_xdp_stats,
 	.ndo_set_rx_mode         = mlx5e_set_rx_mode,
 	.ndo_set_mac_address     = mlx5e_set_mac,
 	.ndo_vlan_rx_add_vid     = mlx5e_vlan_rx_add_vid,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 3631dafb4ea2..834457e3f19a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2292,3 +2292,72 @@ unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
 {
 	return ARRAY_SIZE(mlx5e_nic_stats_grps);
 }
+
+int mlx5e_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	const struct mlx5e_priv *priv = netdev_priv(dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return priv->max_nch;
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return priv->xsk.ever_used ? priv->max_nch : -ENODATA;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int mlx5e_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+			void *attr_data)
+{
+	const struct mlx5e_priv *priv = netdev_priv(dev);
+	struct ifla_xdp_stats *xdp_stats = attr_data;
+	u32 i;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		if (!priv->xsk.ever_used)
+			return -ENODATA;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < priv->max_nch; i++) {
+		const struct mlx5e_channel_stats *cs = priv->channel_stats + i;
+
+		switch (attr_id) {
+		case IFLA_XDP_XSTATS_TYPE_XDP:
+			/* mlx5e_rq_stats rq */
+			xdp_stats->errors = cs->rq.xdp_errors;
+			xdp_stats->drop = cs->rq.xdp_drop;
+			xdp_stats->redirect = cs->rq.xdp_redirect;
+			/* mlx5e_xdpsq_stats rq_xdpsq */
+			xdp_stats->tx = cs->rq_xdpsq.xmit;
+			xdp_stats->tx_errors = cs->rq_xdpsq.err +
+					       cs->rq_xdpsq.full;
+			/* mlx5e_xdpsq_stats xdpsq */
+			xdp_stats->xmit_packets = cs->xdpsq.xmit;
+			xdp_stats->xmit_errors = cs->xdpsq.err;
+			xdp_stats->xmit_full = cs->xdpsq.full;
+			break;
+		case IFLA_XDP_XSTATS_TYPE_XSK:
+			/* mlx5e_rq_stats xskrq */
+			xdp_stats->errors = cs->xskrq.xdp_errors;
+			xdp_stats->drop = cs->xskrq.xdp_drop;
+			xdp_stats->redirect = cs->xskrq.xdp_redirect;
+			/* mlx5e_xdpsq_stats xsksq */
+			xdp_stats->xmit_packets = cs->xsksq.xmit;
+			xdp_stats->xmit_errors = cs->xsksq.err;
+			xdp_stats->xmit_full = cs->xsksq.full;
+			break;
+		}
+
+		xdp_stats++;
+	}
+
+	return 0;
+}
--
2.33.1

