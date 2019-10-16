Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A9D89D7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391101AbfJPHgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:36:36 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55900 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391056AbfJPHgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:36:35 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6EA542004E2;
        Wed, 16 Oct 2019 09:36:33 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 610592004D7;
        Wed, 16 Oct 2019 09:36:33 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 10F9C205D2;
        Wed, 16 Oct 2019 09:36:33 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v3 net 2/2] dpaa2-eth: Fix TX FQID values
Date:   Wed, 16 Oct 2019 10:36:23 +0300
Message-Id: <1571211383-5759-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Depending on when MC connects the DPNI to a MAC, Tx FQIDs may
not be available during probe time.

Read the FQIDs each time the link goes up to avoid using invalid
values. In case an error occurs or an invalid value is retrieved,
fall back to QDID-based enqueueing.

Fixes: 1fa0f68c9255 ("dpaa2-eth: Use FQ-based DPIO enqueue API")
Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - used reverse christmas tree ordering in update_tx_fqids
Changes in v3:
 - add a missing new line
 - go back to FQ based enqueueing after a transient error

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 44 ++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 5acd734a216b..19379bae0144 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 	priv->rx_td_enabled = enable;
 }
 
+static void update_tx_fqids(struct dpaa2_eth_priv *priv);
+
 static int link_state_update(struct dpaa2_eth_priv *priv)
 {
 	struct dpni_link_state state = {0};
@@ -1261,6 +1263,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 		goto out;
 
 	if (state.up) {
+		update_tx_fqids(priv);
 		netif_carrier_on(priv->net_dev);
 		netif_tx_start_all_queues(priv->net_dev);
 	} else {
@@ -2533,6 +2536,47 @@ static int set_pause(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
+static void update_tx_fqids(struct dpaa2_eth_priv *priv)
+{
+	struct dpni_queue_id qid = {0};
+	struct dpaa2_eth_fq *fq;
+	struct dpni_queue queue;
+	int i, j, err;
+
+	/* We only use Tx FQIDs for FQID-based enqueue, so check
+	 * if DPNI version supports it before updating FQIDs
+	 */
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,
+				   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)
+		return;
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		fq = &priv->fq[i];
+		if (fq->type != DPAA2_TX_CONF_FQ)
+			continue;
+		for (j = 0; j < dpaa2_eth_tc_count(priv); j++) {
+			err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
+					     DPNI_QUEUE_TX, j, fq->flowid,
+					     &queue, &qid);
+			if (err)
+				goto out_err;
+
+			fq->tx_fqid[j] = qid.fqid;
+			if (fq->tx_fqid[j] == 0)
+				goto out_err;
+		}
+	}
+
+	priv->enqueue = dpaa2_eth_enqueue_fq;
+
+	return;
+
+out_err:
+	netdev_info(priv->net_dev,
+		    "Error reading Tx FQID, fallback to QDID-based enqueue\n");
+	priv->enqueue = dpaa2_eth_enqueue_qd;
+}
+
 /* Configure the DPNI object this interface is associated with */
 static int setup_dpni(struct fsl_mc_device *ls_dev)
 {
-- 
1.9.1

