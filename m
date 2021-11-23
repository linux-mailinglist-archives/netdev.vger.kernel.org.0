Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4861045A8D1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbhKWQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:62051 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236061AbhKWQpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="298468505"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="298468505"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="474813338"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2021 08:41:26 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wk016784;
        Tue, 23 Nov 2021 16:41:23 GMT
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
Subject: [PATCH v2 net-next 08/26] mvpp2: provide .ndo_get_xdp_stats() callback
Date:   Tue, 23 Nov 2021 17:39:37 +0100
Message-Id: <20211123163955.154512-9-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as mvneta, mvpp2 stores 7 XDP counters in per-cpu containers.
Expose them via generic XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 97bd2ee8a010..58203cde3b60 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5131,6 +5131,56 @@ mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }

+static int mvpp2_get_xdp_stats_ndo(const struct net_device *dev, u32 attr_id,
+				   void *attr_data)
+{
+	const struct mvpp2_port *port = netdev_priv(dev);
+	struct ifla_xdp_stats *xdp_stats = attr_data;
+	u32 cpu, start;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for_each_possible_cpu(cpu) {
+		const struct mvpp2_pcpu_stats *ps;
+		u64 xdp_xmit_err;
+		u64 xdp_redirect;
+		u64 xdp_tx_err;
+		u64 xdp_pass;
+		u64 xdp_drop;
+		u64 xdp_xmit;
+		u64 xdp_tx;
+
+		ps = per_cpu_ptr(port->stats, cpu);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&ps->syncp);
+
+			xdp_redirect = ps->xdp_redirect;
+			xdp_pass = ps->xdp_pass;
+			xdp_drop = ps->xdp_drop;
+			xdp_xmit = ps->xdp_xmit;
+			xdp_xmit_err = ps->xdp_xmit_err;
+			xdp_tx = ps->xdp_tx;
+			xdp_tx_err = ps->xdp_tx_err;
+		} while (u64_stats_fetch_retry_irq(&ps->syncp, start));
+
+		xdp_stats->redirect += xdp_redirect;
+		xdp_stats->pass += xdp_pass;
+		xdp_stats->drop += xdp_drop;
+		xdp_stats->xmit_packets += xdp_xmit;
+		xdp_stats->xmit_errors += xdp_xmit_err;
+		xdp_stats->tx += xdp_tx;
+		xdp_stats->tx_errors  += xdp_tx_err;
+	}
+
+	return 0;
+}
+
 static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
@@ -5719,6 +5769,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
 	.ndo_set_mac_address	= mvpp2_set_mac_address,
 	.ndo_change_mtu		= mvpp2_change_mtu,
 	.ndo_get_stats64	= mvpp2_get_stats64,
+	.ndo_get_xdp_stats	= mvpp2_get_xdp_stats_ndo,
 	.ndo_eth_ioctl		= mvpp2_ioctl,
 	.ndo_vlan_rx_add_vid	= mvpp2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
--
2.33.1

