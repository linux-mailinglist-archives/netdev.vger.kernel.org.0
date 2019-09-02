Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1704A53ED
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfIBKXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:23:24 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42702 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730520AbfIBKXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:23:22 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 85FEA1A02D1;
        Mon,  2 Sep 2019 12:23:20 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 770941A0022;
        Mon,  2 Sep 2019 12:23:20 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 366A3203B1;
        Mon,  2 Sep 2019 12:23:20 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 2/3] dpaa2-eth: Add new DPNI statistics counters
Date:   Mon,  2 Sep 2019 13:23:18 +0300
Message-Id: <1567419799-28179-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent firmware versions expose more  DPNI counters.
Export relevant ones via ethtool -S.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
v2: treat separately error case for unsupported statistics pages

 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 19 ++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h        | 40 ++++++++++++++++++++++
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 1c5b54b..0aa1c34 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -28,6 +28,11 @@ static char dpaa2_ethtool_stats[][ETH_GSTRING_LEN] = {
 	"[hw] rx nobuffer discards",
 	"[hw] tx discarded frames",
 	"[hw] tx confirmed frames",
+	"[hw] tx dequeued bytes",
+	"[hw] tx dequeued frames",
+	"[hw] tx rejected bytes",
+	"[hw] tx rejected frames",
+	"[hw] tx pending frames",
 };
 
 #define DPAA2_ETH_NUM_STATS	ARRAY_SIZE(dpaa2_ethtool_stats)
@@ -192,16 +197,26 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		sizeof(dpni_stats.page_0),
 		sizeof(dpni_stats.page_1),
 		sizeof(dpni_stats.page_2),
+		sizeof(dpni_stats.page_3),
+		sizeof(dpni_stats.page_4),
+		sizeof(dpni_stats.page_5),
+		sizeof(dpni_stats.page_6),
 	};
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
 
 	/* Print standard counters, from DPNI statistics */
-	for (j = 0; j <= 2; j++) {
+	for (j = 0; j <= 6; j++) {
+		/* We're not interested in pages 4 & 5 for now */
+		if (j == 4 || j == 5)
+			continue;
 		err = dpni_get_statistics(priv->mc_io, 0, priv->mc_token,
 					  j, &dpni_stats);
-		if (err != 0)
+		if (err == -EINVAL)
+			/* Older firmware versions don't support all pages */
+			memset(&dpni_stats, 0, sizeof(dpni_stats));
+		else
 			netdev_warn(net_dev, "dpni_get_stats(%d) failed\n", j);
 
 		num_cnt = dpni_stats_page_size[j] / sizeof(u64);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 05e3089..dd54e69 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1470,7 +1470,7 @@ int dpni_get_queue(struct fsl_mc_io *mc_io,
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
  * @token:	Token of DPNI object
  * @page:	Selects the statistics page to retrieve, see
- *		DPNI_GET_STATISTICS output. Pages are numbered 0 to 2.
+ *		DPNI_GET_STATISTICS output. Pages are numbered 0 to 6.
  * @stat:	Structure containing the statistics
  *
  * Return:	'0' on Success; Error code otherwise.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 3e8fc6c..fd583911 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -416,6 +416,26 @@ int dpni_get_tx_data_offset(struct fsl_mc_io	*mc_io,
  *	lack of buffers
  * @page_2.egress_discarded_frames: Egress discarded frame count
  * @page_2.egress_confirmed_frames: Egress confirmed frame count
+ * @page3: Page_3 statistics structure
+ * @page_3.egress_dequeue_bytes: Cumulative count of the number of bytes
+ *	dequeued from egress FQs
+ * @page_3.egress_dequeue_frames: Cumulative count of the number of frames
+ *	dequeued from egress FQs
+ * @page_3.egress_reject_bytes: Cumulative count of the number of bytes in
+ *	egress frames whose enqueue was rejected
+ * @page_3.egress_reject_frames: Cumulative count of the number of egress
+ *	frames whose enqueue was rejected
+ * @page_4: Page_4 statistics structure: congestion points
+ * @page_4.cgr_reject_frames: number of rejected frames due to congestion point
+ * @page_4.cgr_reject_bytes: number of rejected bytes due to congestion point
+ * @page_5: Page_5 statistics structure: policer
+ * @page_5.policer_cnt_red: NUmber of red colored frames
+ * @page_5.policer_cnt_yellow: number of yellow colored frames
+ * @page_5.policer_cnt_green: number of green colored frames
+ * @page_5.policer_cnt_re_red: number of recolored red frames
+ * @page_5.policer_cnt_re_yellow: number of recolored yellow frames
+ * @page_6: Page_6 statistics structure
+ * @page_6.tx_pending_frames: total number of frames pending in egress FQs
  * @raw: raw statistics structure, used to index counters
  */
 union dpni_statistics {
@@ -443,6 +463,26 @@ union dpni_statistics {
 		u64 egress_confirmed_frames;
 	} page_2;
 	struct {
+		u64 egress_dequeue_bytes;
+		u64 egress_dequeue_frames;
+		u64 egress_reject_bytes;
+		u64 egress_reject_frames;
+	} page_3;
+	struct {
+		u64 cgr_reject_frames;
+		u64 cgr_reject_bytes;
+	} page_4;
+	struct {
+		u64 policer_cnt_red;
+		u64 policer_cnt_yellow;
+		u64 policer_cnt_green;
+		u64 policer_cnt_re_red;
+		u64 policer_cnt_re_yellow;
+	} page_5;
+	struct {
+		u64 tx_pending_frames;
+	} page_6;
+	struct {
 		u64 counter[DPNI_STATISTICS_CNT];
 	} raw;
 };
-- 
2.7.4

