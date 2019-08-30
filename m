Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F101A34D8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfH3KUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:20:47 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38716 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfH3KUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 06:20:46 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1D0E0200409;
        Fri, 30 Aug 2019 12:20:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 10916200408;
        Fri, 30 Aug 2019 12:20:45 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CCCCC205C7;
        Fri, 30 Aug 2019 12:20:44 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next 3/3] dpaa2-eth: Poll Tx pending frames counter on if down
Date:   Fri, 30 Aug 2019 13:20:43 +0300
Message-Id: <1567160443-31297-4-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with firmware version MC10.18.0, a new counter for in flight
Tx frames is offered. Use it when bringing down the interface to
determine when all pending Tx frames have been processed by hardware
instead of sleeping a fixed amount of time.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 31 +++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 5402867..162d7d8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1348,7 +1348,7 @@ static u32 ingress_fq_count(struct dpaa2_eth_priv *priv)
 	return total;
 }
 
-static void wait_for_fq_empty(struct dpaa2_eth_priv *priv)
+static void wait_for_ingress_fq_empty(struct dpaa2_eth_priv *priv)
 {
 	int retries = 10;
 	u32 pending;
@@ -1360,6 +1360,31 @@ static void wait_for_fq_empty(struct dpaa2_eth_priv *priv)
 	} while (pending && --retries);
 }
 
+#define DPNI_TX_PENDING_VER_MAJOR	7
+#define DPNI_TX_PENDING_VER_MINOR	13
+static void wait_for_egress_fq_empty(struct dpaa2_eth_priv *priv)
+{
+	union dpni_statistics stats;
+	int retries = 10;
+	int err;
+
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_TX_PENDING_VER_MAJOR,
+				   DPNI_TX_PENDING_VER_MINOR) < 0)
+		goto out;
+
+	do {
+		err = dpni_get_statistics(priv->mc_io, 0, priv->mc_token, 6,
+					  &stats);
+		if (err)
+			goto out;
+		if (stats.page_6.tx_pending_frames == 0)
+			return;
+	} while (--retries);
+
+out:
+	msleep(500);
+}
+
 static int dpaa2_eth_stop(struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
@@ -1379,7 +1404,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	 * on WRIOP. After it finishes, wait until all remaining frames on Rx
 	 * and Tx conf queues are consumed on NAPI poll.
 	 */
-	msleep(500);
+	wait_for_egress_fq_empty(priv);
 
 	do {
 		dpni_disable(priv->mc_io, 0, priv->mc_token);
@@ -1395,7 +1420,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 		 */
 	}
 
-	wait_for_fq_empty(priv);
+	wait_for_ingress_fq_empty(priv);
 	disable_ch_napi(priv);
 
 	/* Empty the buffer pool */
-- 
2.7.4

