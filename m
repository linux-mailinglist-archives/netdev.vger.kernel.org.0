Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DAD2279F8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgGUHz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:55:26 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57638 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgGUHzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:55:25 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5FAE6200687;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 538C3200417;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 25FE2202A9;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 1/6] enetc: Refine buffer descriptor ring sizes
Date:   Tue, 21 Jul 2020 10:55:17 +0300
Message-Id: <1595318122-18490-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's time to differentiate between Rx and Tx ring sizes.
Not only Tx rings are processed differently than Rx rings,
but their default number also differs - i.e. up to 8 Tx rings
per device (8 traffic classes) vs. 2 Rx rings (one per CPU).
So let's set Tx rings sizes to half the size of the Rx rings
for now, to be conservative.
The default ring sizes were decreased as well (to the next
lower power of 2), to reduce the memory footprint, buffering
etc., since the measurements I've made so far show that the
rings are very unlikely to get full.
This change also anticipates the introduction of the
dynamic interrupt moderation (dim) algorithm which operates
on maximum packet thresholds of 256 packets for Rx and 128
packets for Tx.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none
v3: none

 drivers/net/ethernet/freescale/enetc/enetc.c | 4 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3f32b85ba2cf..d91e52618681 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1064,8 +1064,8 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 	struct enetc_si *si = priv->si;
 	int cpus = num_online_cpus();
 
-	priv->tx_bd_count = ENETC_BDR_DEFAULT_SIZE;
-	priv->rx_bd_count = ENETC_BDR_DEFAULT_SIZE;
+	priv->tx_bd_count = ENETC_TX_RING_DEFAULT_SIZE;
+	priv->rx_bd_count = ENETC_RX_RING_DEFAULT_SIZE;
 
 	/* Enable all available TX rings in order to configure as many
 	 * priorities as possible, when needed.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index b705464f6882..0dd8ee179753 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -44,8 +44,9 @@ struct enetc_ring_stats {
 	unsigned int rx_alloc_errs;
 };
 
-#define ENETC_BDR_DEFAULT_SIZE	1024
-#define ENETC_DEFAULT_TX_WORK	256
+#define ENETC_RX_RING_DEFAULT_SIZE	512
+#define ENETC_TX_RING_DEFAULT_SIZE	256
+#define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
 
 struct enetc_bdr {
 	struct device *dev; /* for DMA mapping */
-- 
2.17.1

