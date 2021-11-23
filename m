Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCBA45A8A9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhKWQok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:39357 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234887AbhKWQoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215767236"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215767236"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="474813286"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2021 08:41:14 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wf016784;
        Tue, 23 Nov 2021 16:41:11 GMT
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
Subject: [PATCH v2 net-next 03/26] ena: implement generic XDP statistics callbacks
Date:   Tue, 23 Nov 2021 17:39:32 +0100
Message-Id: <20211123163955.154512-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ena driver has 6 XDP counters collected per-channel. Add callbacks
for getting the number of channels and those counters using generic
XDP stats infra.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 7d5d885d85d5..83e9b85cc998 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3313,12 +3313,65 @@ static void ena_get_stats64(struct net_device *netdev,
 	stats->tx_errors = 0;
 }

+static int ena_get_xdp_stats_nch(const struct net_device *netdev, u32 attr_id)
+{
+	const struct ena_adapter *adapter = netdev_priv(netdev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return adapter->num_io_queues;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ena_get_xdp_stats(const struct net_device *netdev, u32 attr_id,
+			     void *attr_data)
+{
+	const struct ena_adapter *adapter = netdev_priv(netdev);
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
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		const struct u64_stats_sync *syncp;
+		const struct ena_stats_rx *stats;
+		u32 start;
+
+		stats = &adapter->rx_ring[i].rx_stats;
+		syncp = &adapter->rx_ring[i].syncp;
+
+		do {
+			start = u64_stats_fetch_begin_irq(syncp);
+
+			xdp_stats->drop = stats->xdp_drop;
+			xdp_stats->pass = stats->xdp_pass;
+			xdp_stats->tx = stats->xdp_tx;
+			xdp_stats->redirect = stats->xdp_redirect;
+			xdp_stats->aborted = stats->xdp_aborted;
+			xdp_stats->invalid = stats->xdp_invalid;
+		} while (u64_stats_fetch_retry_irq(syncp, start));
+
+		xdp_stats++;
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops ena_netdev_ops = {
 	.ndo_open		= ena_open,
 	.ndo_stop		= ena_close,
 	.ndo_start_xmit		= ena_start_xmit,
 	.ndo_select_queue	= ena_select_queue,
 	.ndo_get_stats64	= ena_get_stats64,
+	.ndo_get_xdp_stats_nch	= ena_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= ena_get_xdp_stats,
 	.ndo_tx_timeout		= ena_tx_timeout,
 	.ndo_change_mtu		= ena_change_mtu,
 	.ndo_set_mac_address	= NULL,
--
2.33.1

