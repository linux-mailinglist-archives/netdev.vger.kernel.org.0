Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F115AA53EF
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfIBKXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:23:24 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46092 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbfIBKXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:23:22 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 38B4820039B;
        Mon,  2 Sep 2019 12:23:20 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 24B012001B9;
        Mon,  2 Sep 2019 12:23:20 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DB65F203B1;
        Mon,  2 Sep 2019 12:23:19 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 1/3] dpaa2-eth: Minor refactoring in ethtool stats
Date:   Mon,  2 Sep 2019 13:23:17 +0300
Message-Id: <1567419799-28179-2-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we prepare to read more pages from the DPNI stat counters,
reorganize the code a bit to make it easier to extend.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
v2: no changes

 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 93076fe..1c5b54b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -188,6 +188,11 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_eth_drv_stats *extras;
 	struct dpaa2_eth_ch_stats *ch_stats;
+	int dpni_stats_page_size[DPNI_STATISTICS_CNT] = {
+		sizeof(dpni_stats.page_0),
+		sizeof(dpni_stats.page_1),
+		sizeof(dpni_stats.page_2),
+	};
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
@@ -198,17 +203,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 					  j, &dpni_stats);
 		if (err != 0)
 			netdev_warn(net_dev, "dpni_get_stats(%d) failed\n", j);
-		switch (j) {
-		case 0:
-			num_cnt = sizeof(dpni_stats.page_0) / sizeof(u64);
-			break;
-		case 1:
-			num_cnt = sizeof(dpni_stats.page_1) / sizeof(u64);
-			break;
-		case 2:
-			num_cnt = sizeof(dpni_stats.page_2) / sizeof(u64);
-			break;
-		}
+
+		num_cnt = dpni_stats_page_size[j] / sizeof(u64);
 		for (k = 0; k < num_cnt; k++)
 			*(data + i++) = dpni_stats.raw.counter[k];
 	}
-- 
2.7.4

