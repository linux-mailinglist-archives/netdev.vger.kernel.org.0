Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A976F1E8582
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgE2Ro7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:44:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50832 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbgE2Roy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:44:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5304E1A11D9;
        Fri, 29 May 2020 19:44:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D0B81A11D7;
        Fri, 29 May 2020 19:44:53 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id F39BA2039E;
        Fri, 29 May 2020 19:44:52 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 5/7] dpaa2-eth: Update FQ taildrop threshold and buffer pool count
Date:   Fri, 29 May 2020 20:43:43 +0300
Message-Id: <20200529174345.27537-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529174345.27537-1-ioana.ciornei@nxp.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Now that we have congestion group taildrop configured at all
times, we can afford to increase the frame queue taildrop
threshold; this will ensure a better response when receiving
bursts of large-sized frames.

Also decouple the buffer pool count from the Rx FQ taildrop
threshold, as above change would increase it too much. Instead,
keep the old count as a hardcoded value.

With the new limits, we try to ensure that:
* we allow enough leeway for large frame bursts (by buffering
enough of them in queues to avoid heavy dropping in case of
bursty traffic, but when overall ingress bandwidth is manageable)
* allow pending frames to be evenly spread between ingress FQs,
regardless of frame size
* avoid dropping frames due to the buffer pool being empty; this
is not a bad behaviour per se, but system overall response is
more linear and predictable when frames are dropped at frame
queue/group level.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 184d5d83e497..02c0eea69a23 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -36,24 +36,24 @@
 /* Convert L3 MTU to L2 MFL */
 #define DPAA2_ETH_L2_MAX_FRM(mtu)	((mtu) + VLAN_ETH_HLEN)
 
-/* Set the taildrop threshold (in bytes) to allow the enqueue of several jumbo
- * frames in the Rx queues (length of the current frame is not
- * taken into account when making the taildrop decision)
+/* Set the taildrop threshold (in bytes) to allow the enqueue of a large
+ * enough number of jumbo frames in the Rx queues (length of the current
+ * frame is not taken into account when making the taildrop decision)
  */
-#define DPAA2_ETH_FQ_TAILDROP_THRESH	(64 * 1024)
+#define DPAA2_ETH_FQ_TAILDROP_THRESH	(1024 * 1024)
 
 /* Maximum number of Tx confirmation frames to be processed
  * in a single NAPI call
  */
 #define DPAA2_ETH_TXCONF_PER_NAPI	256
 
-/* Buffer quota per queue. Must be large enough such that for minimum sized
- * frames taildrop kicks in before the bpool gets depleted, so we compute
- * how many 64B frames fit inside the taildrop threshold and add a margin
- * to accommodate the buffer refill delay.
+/* Buffer qouta per channel. We want to keep in check number of ingress frames
+ * in flight: for small sized frames, congestion group taildrop may kick in
+ * first; for large sizes, Rx FQ taildrop threshold will ensure only a
+ * reasonable number of frames will be pending at any given time.
+ * Ingress frame drop due to buffer pool depletion should be a corner case only
  */
-#define DPAA2_ETH_MAX_FRAMES_PER_QUEUE	(DPAA2_ETH_FQ_TAILDROP_THRESH / 64)
-#define DPAA2_ETH_NUM_BUFS		(DPAA2_ETH_MAX_FRAMES_PER_QUEUE + 256)
+#define DPAA2_ETH_NUM_BUFS		1280
 #define DPAA2_ETH_REFILL_THRESH \
 	(DPAA2_ETH_NUM_BUFS - DPAA2_ETH_BUFS_PER_CMD)
 
@@ -63,8 +63,7 @@
  * taildrop kicks in
  */
 #define DPAA2_ETH_CG_TAILDROP_THRESH(priv)				\
-	(DPAA2_ETH_MAX_FRAMES_PER_QUEUE * dpaa2_eth_queue_count(priv) /	\
-	 dpaa2_eth_tc_count(priv))
+	(1024 * dpaa2_eth_queue_count(priv) / dpaa2_eth_tc_count(priv))
 
 /* Maximum number of buffers that can be acquired/released through a single
  * QBMan command
-- 
2.17.1

