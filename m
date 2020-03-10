Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A23D17FDBA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgCJN3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:29:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54854 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgCJMv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:27 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id ED3DD1A0571;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E1B061A0568;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AC0332036B;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/4] enetc: Clean up of ehtool stats len
Date:   Tue, 10 Mar 2020 14:51:22 +0200
Message-Id: <1583844684-28202-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
References: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the stats len computation code to make it easier
to add new stats counters.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 301ee0dde02d..888d45fef529 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -195,15 +195,21 @@ static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int len;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
 
-	if (sset == ETH_SS_STATS)
-		return ARRAY_SIZE(enetc_si_counters) +
-			ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
-			ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings +
-			(enetc_si_is_pf(priv->si) ?
-			ARRAY_SIZE(enetc_port_counters) : 0);
+	len = ARRAY_SIZE(enetc_si_counters) +
+	      ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
+	      ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings;
 
-	return -EOPNOTSUPP;
+	if (!enetc_si_is_pf(priv->si))
+		return len;
+
+	len += ARRAY_SIZE(enetc_port_counters);
+
+	return len;
 }
 
 static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
-- 
2.17.1

