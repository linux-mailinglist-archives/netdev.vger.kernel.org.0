Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9024945A8C7
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbhKWQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:13971 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236837AbhKWQo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="321291070"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="321291070"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="509475753"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 23 Nov 2021 08:41:38 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wp016784;
        Tue, 23 Nov 2021 16:41:35 GMT
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
Subject: [PATCH v2 net-next 13/26] veth: drop 'xdp_' suffix from packets and bytes stats
Date:   Tue, 23 Nov 2021 17:39:42 +0100
Message-Id: <20211123163955.154512-14-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They get updated not only on XDP path. Moreover, packet counter
stores the total number of frames, not only the ones passed to
bpf_prog_run_xdp(), so it's rather confusing.
Drop the xdp_ suffix from both of them to not mix XDP-only stats
with the general ones.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0e6c030576f4..ac3b1a2a91c8 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -38,10 +38,10 @@
 #define VETH_XDP_BATCH		16

 struct veth_stats {
+	u64	packets;
+	u64	bytes;
 	u64	rx_drops;
 	/* xdp */
-	u64	xdp_packets;
-	u64	xdp_bytes;
 	u64	xdp_redirect;
 	u64	xdp_errors;
 	u64	xdp_drops;
@@ -93,8 +93,8 @@ struct veth_q_stat_desc {
 #define VETH_RQ_STAT(m)	offsetof(struct veth_stats, m)

 static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
-	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
-	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
+	{ "packets",		VETH_RQ_STAT(packets) },
+	{ "bytes",		VETH_RQ_STAT(bytes) },
 	{ "drops",		VETH_RQ_STAT(rx_drops) },
 	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
 	{ "xdp_errors",		VETH_RQ_STAT(xdp_errors) },
@@ -378,9 +378,9 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	int i;

 	result->peer_tq_xdp_xmit_err = 0;
-	result->xdp_packets = 0;
+	result->packets = 0;
 	result->xdp_tx_err = 0;
-	result->xdp_bytes = 0;
+	result->bytes = 0;
 	result->rx_drops = 0;
 	for (i = 0; i < dev->num_rx_queues; i++) {
 		u64 packets, bytes, drops, xdp_tx_err, peer_tq_xdp_xmit_err;
@@ -391,14 +391,14 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			peer_tq_xdp_xmit_err = stats->vs.peer_tq_xdp_xmit_err;
 			xdp_tx_err = stats->vs.xdp_tx_err;
-			packets = stats->vs.xdp_packets;
-			bytes = stats->vs.xdp_bytes;
+			packets = stats->vs.packets;
+			bytes = stats->vs.bytes;
 			drops = stats->vs.rx_drops;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 		result->peer_tq_xdp_xmit_err += peer_tq_xdp_xmit_err;
 		result->xdp_tx_err += xdp_tx_err;
-		result->xdp_packets += packets;
-		result->xdp_bytes += bytes;
+		result->packets += packets;
+		result->bytes += bytes;
 		result->rx_drops += drops;
 	}
 }
@@ -418,8 +418,8 @@ static void veth_get_stats64(struct net_device *dev,
 	veth_stats_rx(&rx, dev);
 	tot->tx_dropped += rx.xdp_tx_err;
 	tot->rx_dropped = rx.rx_drops + rx.peer_tq_xdp_xmit_err;
-	tot->rx_bytes = rx.xdp_bytes;
-	tot->rx_packets = rx.xdp_packets;
+	tot->rx_bytes = rx.bytes;
+	tot->rx_packets = rx.packets;

 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
@@ -431,8 +431,8 @@ static void veth_get_stats64(struct net_device *dev,
 		veth_stats_rx(&rx, peer);
 		tot->tx_dropped += rx.peer_tq_xdp_xmit_err;
 		tot->rx_dropped += rx.xdp_tx_err;
-		tot->tx_bytes += rx.xdp_bytes;
-		tot->tx_packets += rx.xdp_packets;
+		tot->tx_bytes += rx.bytes;
+		tot->tx_packets += rx.packets;
 	}
 	rcu_read_unlock();
 }
@@ -867,7 +867,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_xdp_xmit */
 			struct xdp_frame *frame = veth_ptr_to_xdp(ptr);

-			stats->xdp_bytes += frame->len;
+			stats->bytes += frame->len;
 			frame = veth_xdp_rcv_one(rq, frame, bq, stats);
 			if (frame) {
 				/* XDP_PASS */
@@ -882,7 +882,7 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_start_xmit */
 			struct sk_buff *skb = ptr;

-			stats->xdp_bytes += skb->len;
+			stats->bytes += skb->len;
 			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
 			if (skb)
 				napi_gro_receive(&rq->xdp_napi, skb);
@@ -895,10 +895,10 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,

 	u64_stats_update_begin(&rq->stats.syncp);
 	rq->stats.vs.xdp_redirect += stats->xdp_redirect;
-	rq->stats.vs.xdp_bytes += stats->xdp_bytes;
+	rq->stats.vs.bytes += stats->bytes;
 	rq->stats.vs.xdp_drops += stats->xdp_drops;
 	rq->stats.vs.rx_drops += stats->rx_drops;
-	rq->stats.vs.xdp_packets += done;
+	rq->stats.vs.packets += done;
 	u64_stats_update_end(&rq->stats.syncp);

 	return done;
--
2.33.1

