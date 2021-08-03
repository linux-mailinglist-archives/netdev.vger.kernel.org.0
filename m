Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747073DF30E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhHCQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:43:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:28280 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhHCQnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:43:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="235674742"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="235674742"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:42:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="670509401"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2021 09:42:33 -0700
Received: from alobakin-mobl.ger.corp.intel.com (lkalica-MOBL.ger.corp.intel.com [10.213.13.182])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GgTIX032348;
        Tue, 3 Aug 2021 17:42:29 +0100
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
Subject: [PATCH net-next 20/21] virtio-net: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:42:28 +0200
Message-Id: <20210803164228.4342-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have 1:1 correspondence between the driver XDP stats and
the standard XDP stats, we can go forth and convert the driver to
expose XDP statistics via our standard interface.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/virtio_net.c | 52 ++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index acad099006cd..df1fe36cf089 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -101,8 +101,6 @@ struct virtnet_rq_stats {
 static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "packets",		VIRTNET_SQ_STAT(packets) },
 	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
-	{ "xdp_xmit",		VIRTNET_SQ_STAT(xdp_xmit) },
-	{ "xdp_xmit_drops",	VIRTNET_SQ_STAT(xdp_xmit_drops) },
 	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
 };
 
@@ -110,11 +108,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
 	{ "packets",		VIRTNET_RQ_STAT(packets) },
 	{ "bytes",		VIRTNET_RQ_STAT(bytes) },
 	{ "drops",		VIRTNET_RQ_STAT(drops) },
-	{ "xdp_packets",	VIRTNET_RQ_STAT(xdp_packets) },
-	{ "xdp_tx",		VIRTNET_RQ_STAT(xdp_tx) },
-	{ "xdp_redirects",	VIRTNET_RQ_STAT(xdp_redirects) },
-	{ "xdp_drops",		VIRTNET_RQ_STAT(xdp_drops) },
-	{ "xdp_errors",		VIRTNET_RQ_STAT(xdp_errors) },
 	{ "kicks",		VIRTNET_RQ_STAT(kicks) },
 };
 
@@ -2295,6 +2288,49 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
+static int virtnet_get_std_stats_channels(struct net_device *dev, u32 sset)
+{
+	const struct virtnet_info *vi = netdev_priv(dev);
+
+	switch (sset) {
+	case ETH_SS_STATS_XDP:
+		return vi->curr_queue_pairs;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void virtnet_get_xdp_stats(struct net_device *dev,
+				  struct ethtool_xdp_stats *xdp_stats)
+{
+	const struct virtnet_info *vi = netdev_priv(dev);
+	u32 i;
+
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		const struct virtnet_rq_stats *rqs = &vi->rq[i].stats;
+		const struct virtnet_sq_stats *sqs = &vi->sq[i].stats;
+		struct ethtool_xdp_stats *iter = xdp_stats + i;
+		u32 start;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rqs->syncp);
+
+			iter->packets = rqs->xdp_packets;
+			iter->tx = rqs->xdp_tx;
+			iter->redirect = rqs->xdp_redirects;
+			iter->drop = rqs->xdp_drops;
+			iter->errors = rqs->xdp_errors;
+		} while (u64_stats_fetch_retry_irq(&rqs->syncp, start));
+
+		do {
+			start = u64_stats_fetch_begin_irq(&sqs->syncp);
+
+			iter->xmit = sqs->xdp_xmit;
+			iter->xmit_drops = sqs->xdp_xmit_drops;
+		} while (u64_stats_fetch_retry_irq(&sqs->syncp, start));
+	}
+}
+
 static void virtnet_get_channels(struct net_device *dev,
 				 struct ethtool_channels *channels)
 {
@@ -2409,6 +2445,8 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 	.set_link_ksettings = virtnet_set_link_ksettings,
 	.set_coalesce = virtnet_set_coalesce,
 	.get_coalesce = virtnet_get_coalesce,
+	.get_std_stats_channels = virtnet_get_std_stats_channels,
+	.get_xdp_stats = virtnet_get_xdp_stats,
 };
 
 static void virtnet_freeze_down(struct virtio_device *vdev)
-- 
2.31.1

