Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65945A8F0
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbhKWQpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:10141 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236471AbhKWQpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="295864778"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="295864778"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="674540123"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2021 08:41:53 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wv016784;
        Tue, 23 Nov 2021 16:41:50 GMT
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
Subject: [PATCH v2 net-next 19/26] virtio_net: add callbacks for generic XDP stats
Date:   Tue, 23 Nov 2021 17:39:48 +0100
Message-Id: <20211123163955.154512-20-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic XDP stats callbacks to be able to query 7 per-channel
virtio-net XDP stats via generic XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f7c5511e510c..0b4cc9662d91 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1919,6 +1919,60 @@ static void virtnet_stats(struct net_device *dev,
 	tot->rx_frame_errors = dev->stats.rx_frame_errors;
 }

+static int virtnet_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	const struct virtnet_info *vi = netdev_priv(dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return vi->curr_queue_pairs;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int virtnet_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+				 void *attr_data)
+{
+	const struct virtnet_info *vi = netdev_priv(dev);
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
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		const struct virtnet_rq_stats *rqs = &vi->rq[i].stats;
+		const struct virtnet_sq_stats *sqs = &vi->sq[i].stats;
+		u32 start;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rqs->syncp);
+
+			xdp_stats->packets = rqs->xdp_packets;
+			xdp_stats->tx = rqs->xdp_tx;
+			xdp_stats->redirect = rqs->xdp_redirects;
+			xdp_stats->drop = rqs->xdp_drops;
+			xdp_stats->errors = rqs->xdp_errors;
+		} while (u64_stats_fetch_retry_irq(&rqs->syncp, start));
+
+		do {
+			start = u64_stats_fetch_begin_irq(&sqs->syncp);
+
+			xdp_stats->xmit_packets = sqs->xdp_xmit;
+			xdp_stats->xmit_errors = sqs->xdp_xmit_errors;
+		} while (u64_stats_fetch_retry_irq(&sqs->syncp, start));
+
+		xdp_stats++;
+	}
+
+	return 0;
+}
+
 static void virtnet_ack_link_announce(struct virtnet_info *vi)
 {
 	rtnl_lock();
@@ -2717,6 +2771,8 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_set_mac_address	= virtnet_set_mac_address,
 	.ndo_set_rx_mode	= virtnet_set_rx_mode,
 	.ndo_get_stats64	= virtnet_stats,
+	.ndo_get_xdp_stats_nch	= virtnet_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= virtnet_get_xdp_stats,
 	.ndo_vlan_rx_add_vid	= virtnet_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= virtnet_vlan_rx_kill_vid,
 	.ndo_bpf		= virtnet_xdp,
--
2.33.1

