Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A2345A8AE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhKWQos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:48 -0500
Received: from mga12.intel.com ([192.55.52.136]:26573 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234942AbhKWQoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215086302"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215086302"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="456747076"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2021 08:41:17 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wg016784;
        Tue, 23 Nov 2021 16:41:14 GMT
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
Subject: [PATCH v2 net-next 04/26] dpaa2: implement generic XDP stats callbacks
Date:   Tue, 23 Nov 2021 17:39:33 +0100
Message-Id: <20211123163955.154512-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an ability to dpaa2 to query its 5 per-channel XDP counters
using generic XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6451c8383639..7715aecedacc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1973,6 +1973,49 @@ static void dpaa2_eth_get_stats(struct net_device *net_dev,
 	}
 }

+static int dpaa2_eth_get_xdp_stats_nch(const struct net_device *net_dev,
+				       u32 attr_id)
+{
+	const struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return priv->num_channels;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dpaa2_eth_get_xdp_stats(const struct net_device *net_dev,
+				   u32 attr_id, void *attr_data)
+{
+	const struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct ifla_xdp_stats *xdp_stats = attr_data;
+	u32 i;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < priv->num_channels; i++) {
+		const struct dpaa2_eth_ch_stats *ch_stats;
+
+		ch_stats = &priv->channel[i]->stats;
+
+		xdp_stats->drop = ch_stats->xdp_drop;
+		xdp_stats->redirect = ch_stats->xdp_redirect;
+		xdp_stats->tx = ch_stats->xdp_tx;
+		xdp_stats->tx_errors = ch_stats->xdp_tx_err;
+
+		xdp_stats++;
+	}
+
+	return 0;
+}
+
 /* Copy mac unicast addresses from @net_dev to @priv.
  * Its sole purpose is to make dpaa2_eth_set_rx_mode() more readable.
  */
@@ -2601,6 +2644,8 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_stop = dpaa2_eth_stop,
 	.ndo_set_mac_address = dpaa2_eth_set_addr,
 	.ndo_get_stats64 = dpaa2_eth_get_stats,
+	.ndo_get_xdp_stats_nch = dpaa2_eth_get_xdp_stats_nch,
+	.ndo_get_xdp_stats = dpaa2_eth_get_xdp_stats,
 	.ndo_set_rx_mode = dpaa2_eth_set_rx_mode,
 	.ndo_set_features = dpaa2_eth_set_features,
 	.ndo_eth_ioctl = dpaa2_eth_ioctl,
--
2.33.1

