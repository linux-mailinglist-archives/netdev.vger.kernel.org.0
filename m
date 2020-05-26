Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D831B70FB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgDXJdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:33:42 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58054 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgDXJdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:33:42 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 28CB41A02A0;
        Fri, 24 Apr 2020 11:33:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1AFF31A02BC;
        Fri, 24 Apr 2020 11:33:40 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C5D75205CB;
        Fri, 24 Apr 2020 11:33:39 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] dpaa2-eth: add channel stat to debugfs
Date:   Fri, 24 Apr 2020 12:33:18 +0300
Message-Id: <20200424093318.27490-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compute the average number of frames processed for each CDAN (Channel
Data Availability Notification) and export it to debugfs detailed
channel stats.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 9 ++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c         | 1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h         | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c     | 2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index a9afe46b837f..80291afff3ea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -127,16 +127,19 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Channel stats for %s:\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s\n",
-		   "CHID", "CPU", "Deq busy", "CDANs", "Buf count");
+	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s\n",
+		   "CHID", "CPU", "Deq busy", "Frames", "CDANs",
+		   "Avg Frm/CDAN", "Buf count");
 
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
-		seq_printf(file, "%4d%16d%16llu%16llu%16d\n",
+		seq_printf(file, "%4d%16d%16llu%16llu%16llu%16llu%16d\n",
 			   ch->ch_id,
 			   ch->nctx.desired_cpu,
 			   ch->stats.dequeue_portal_busy,
+			   ch->stats.frames,
 			   ch->stats.cdan,
+			   ch->stats.frames / ch->stats.cdan,
 			   ch->buf_count);
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 9d4061bba0b8..57248b8148cd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -493,6 +493,7 @@ static int consume_frames(struct dpaa2_eth_channel *ch,
 		return 0;
 
 	fq->stats.frames += cleaned;
+	ch->stats.frames += cleaned;
 
 	/* A dequeue operation only pulls frames from a single queue
 	 * into the store. Return the frame queue as an out param.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 289053099974..43cd8409f2e9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -288,6 +288,8 @@ struct dpaa2_eth_ch_stats {
 	__u64 xdp_tx;
 	__u64 xdp_tx_err;
 	__u64 xdp_redirect;
+	/* Must be last, does not show up in ethtool stats */
+	__u64 frames;
 };
 
 /* Maximum number of queues associated with a DPNI */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 94347c695233..bd13ee48d623 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -277,7 +277,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	/* Per-channel stats */
 	for (k = 0; k < priv->num_channels; k++) {
 		ch_stats = &priv->channel[k]->stats;
-		for (j = 0; j < sizeof(*ch_stats) / sizeof(__u64); j++)
+		for (j = 0; j < sizeof(*ch_stats) / sizeof(__u64) - 1; j++)
 			*((__u64 *)data + i + j) += *((__u64 *)ch_stats + j);
 	}
 	i += j;
-- 
2.17.1

