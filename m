Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A4A45A8C5
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhKWQpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:62027 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhKWQow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="298468496"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="298468496"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="457119935"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2021 08:41:24 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wj016784;
        Tue, 23 Nov 2021 16:41:21 GMT
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
Subject: [PATCH v2 net-next 07/26] mvneta: add .ndo_get_xdp_stats() callback
Date:   Tue, 23 Nov 2021 17:39:36 +0100
Message-Id: <20211123163955.154512-8-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta driver implements 7 per-cpu counters which means we can
only provide them as a global sum across CPUs.
Implement a callback for querying them using generic XDP stats
infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 54 +++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7c30417a0464..5bb0bbfa1ee6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -802,6 +802,59 @@ mvneta_get_stats64(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }

+static int mvneta_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+				void *attr_data)
+{
+	const struct mvneta_port *pp = netdev_priv(dev);
+	struct ifla_xdp_stats *xdp_stats = attr_data;
+	u32 cpu;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for_each_possible_cpu(cpu) {
+		const struct mvneta_pcpu_stats *stats;
+		const struct mvneta_stats *ps;
+		u64 xdp_xmit_err;
+		u64 xdp_redirect;
+		u64 xdp_tx_err;
+		u64 xdp_pass;
+		u64 xdp_drop;
+		u64 xdp_xmit;
+		u64 xdp_tx;
+		u32 start;
+
+		stats = per_cpu_ptr(pp->stats, cpu);
+		ps = &stats->es.ps;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+
+			xdp_drop = ps->xdp_drop;
+			xdp_pass = ps->xdp_pass;
+			xdp_redirect = ps->xdp_redirect;
+			xdp_tx = ps->xdp_tx;
+			xdp_tx_err = ps->xdp_tx_err;
+			xdp_xmit = ps->xdp_xmit;
+			xdp_xmit_err = ps->xdp_xmit_err;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		xdp_stats->drop += xdp_drop;
+		xdp_stats->pass += xdp_pass;
+		xdp_stats->redirect += xdp_redirect;
+		xdp_stats->tx += xdp_tx;
+		xdp_stats->tx_errors += xdp_tx_err;
+		xdp_stats->xmit_packets += xdp_xmit;
+		xdp_stats->xmit_errors += xdp_xmit_err;
+	}
+
+	return 0;
+}
+
 /* Rx descriptors helper methods */

 /* Checks whether the RX descriptor having this status is both the first
@@ -4957,6 +5010,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
 	.ndo_change_mtu		= mvneta_change_mtu,
 	.ndo_fix_features	= mvneta_fix_features,
 	.ndo_get_stats64	= mvneta_get_stats64,
+	.ndo_get_xdp_stats	= mvneta_get_xdp_stats,
 	.ndo_eth_ioctl		= mvneta_ioctl,
 	.ndo_bpf		= mvneta_xdp,
 	.ndo_xdp_xmit		= mvneta_xdp_xmit,
--
2.33.1

