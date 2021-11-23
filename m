Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC845A8FD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhKWQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:20347 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238665AbhKWQpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="222282476"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="222282476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="456747199"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2021 08:41:43 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wr016784;
        Tue, 23 Nov 2021 16:41:40 GMT
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
Subject: [PATCH v2 net-next 15/26] veth: add generic XDP stats callbacks
Date:   Tue, 23 Nov 2021 17:39:44 +0100
Message-Id: <20211123163955.154512-16-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose veth's 7 per-channel counters by providing callbacks
for generic XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 3eb24a5c2d45..c12209fbd1bd 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -437,6 +437,71 @@ static void veth_get_stats64(struct net_device *dev,
 	rcu_read_unlock();
 }

+static int veth_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return max(dev->real_num_rx_queues, dev->real_num_tx_queues);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int veth_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+			      void *attr_data)
+{
+	const struct veth_priv *priv = netdev_priv(dev);
+	const struct net_device *peer = rtnl_dereference(priv->peer);
+	struct ifla_xdp_stats *xdp_iter, *xdp_stats = attr_data;
+	const struct veth_rq_stats *rq_stats;
+	u64 xmit_packets, xmit_errors;
+	u32 i, start;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		rq_stats = &priv->rq[i].stats;
+		xdp_iter = xdp_stats + i;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+
+			xdp_iter->errors = rq_stats->vs.xdp_errors;
+			xdp_iter->redirect = rq_stats->vs.xdp_redirect;
+			xdp_iter->drop = rq_stats->vs.xdp_drops;
+			xdp_iter->tx = rq_stats->vs.xdp_tx;
+			xdp_iter->tx_errors = rq_stats->vs.xdp_tx_err;
+		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+	}
+
+	if (!peer)
+		return 0;
+
+	priv = netdev_priv(peer);
+
+	for (i = 0; i < peer->real_num_rx_queues; i++) {
+		rq_stats = &priv->rq[i].stats;
+		xdp_iter = xdp_stats + (i % dev->real_num_tx_queues);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
+
+			xmit_packets = rq_stats->vs.peer_tq_xdp_xmit;
+			xmit_errors = rq_stats->vs.peer_tq_xdp_xmit_err;
+		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
+
+		xdp_iter->xmit_packets += xmit_packets;
+		xdp_iter->xmit_errors += xmit_errors;
+	}
+
+	return 0;
+}
+
 /* fake multicast ability */
 static void veth_set_multicast_list(struct net_device *dev)
 {
@@ -1537,6 +1602,8 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_stop		= veth_close,
 	.ndo_start_xmit		= veth_xmit,
 	.ndo_get_stats64	= veth_get_stats64,
+	.ndo_get_xdp_stats_nch	= veth_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= veth_get_xdp_stats,
 	.ndo_set_rx_mode	= veth_set_multicast_list,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
--
2.33.1

