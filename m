Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0D2279F9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgGUHzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:55:40 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57650 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgGUHz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:55:26 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B5D12006A5;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8F348200417;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 61CE1202A9;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/6] enetc: Factor out the traffic start/stop procedures
Date:   Tue, 21 Jul 2020 10:55:18 +0300
Message-Id: <1595318122-18490-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A reliable traffic pause (and reconfiguration) procedure
is needed to be able to safely make h/w configuration
changes during run-time, like changing the mode in which the
interrupts are operating (i.e. with or without coalescing),
as opposed to making on-the-fly register updates that
may be subject to h/w or s/w concurrency issues.
To this end, the code responsible of the run-time device
configurations that basically starts resp. stops the traffic
flow through the device has been extracted from the
the enetc_open/_close procedures, to the separate standalone
enetc_start/_stop procedures. Traffic stop should be as
graceful as possible, it lets the executing napi threads to
to finish while the interrupts stay disabled.  But since
the napi thread will try to re-enable interrupts by clearing
the device's unmask register, the enable_irq/ disable_irq
API has been used to avoid this potential concurrency issue
and make the traffic pause procedure more reliable.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none
v3: none

 drivers/net/ethernet/freescale/enetc/enetc.c | 74 +++++++++++++-------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d91e52618681..51a1c97aedac 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1264,6 +1264,7 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 			dev_err(priv->dev, "request_irq() failed!\n");
 			goto irq_err;
 		}
+		disable_irq(irq);
 
 		v->tbier_base = hw->reg + ENETC_BDR(TX, 0, ENETC_TBIER);
 		v->rbier = hw->reg + ENETC_BDR(RX, i, ENETC_RBIER);
@@ -1306,7 +1307,7 @@ static void enetc_free_irqs(struct enetc_ndev_priv *priv)
 	}
 }
 
-static void enetc_enable_interrupts(struct enetc_ndev_priv *priv)
+static void enetc_setup_interrupts(struct enetc_ndev_priv *priv)
 {
 	int i;
 
@@ -1322,7 +1323,7 @@ static void enetc_enable_interrupts(struct enetc_ndev_priv *priv)
 	}
 }
 
-static void enetc_disable_interrupts(struct enetc_ndev_priv *priv)
+static void enetc_clear_interrupts(struct enetc_ndev_priv *priv)
 {
 	int i;
 
@@ -1369,10 +1370,33 @@ static int enetc_phy_connect(struct net_device *ndev)
 	return 0;
 }
 
+static void enetc_start(struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int i;
+
+	enetc_setup_interrupts(priv);
+
+	for (i = 0; i < priv->bdr_int_num; i++) {
+		int irq = pci_irq_vector(priv->si->pdev,
+					 ENETC_BDR_INT_BASE_IDX + i);
+
+		napi_enable(&priv->int_vector[i]->napi);
+		enable_irq(irq);
+	}
+
+	if (ndev->phydev)
+		phy_start(ndev->phydev);
+	else
+		netif_carrier_on(ndev);
+
+	netif_tx_start_all_queues(ndev);
+}
+
 int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int i, err;
+	int err;
 
 	err = enetc_setup_irqs(priv);
 	if (err)
@@ -1390,8 +1414,6 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_alloc_rx;
 
-	enetc_setup_bdrs(priv);
-
 	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
 	if (err)
 		goto err_set_queues;
@@ -1400,17 +1422,8 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_set_queues;
 
-	for (i = 0; i < priv->bdr_int_num; i++)
-		napi_enable(&priv->int_vector[i]->napi);
-
-	enetc_enable_interrupts(priv);
-
-	if (ndev->phydev)
-		phy_start(ndev->phydev);
-	else
-		netif_carrier_on(ndev);
-
-	netif_tx_start_all_queues(ndev);
+	enetc_setup_bdrs(priv);
+	enetc_start(ndev);
 
 	return 0;
 
@@ -1427,28 +1440,39 @@ int enetc_open(struct net_device *ndev)
 	return err;
 }
 
-int enetc_close(struct net_device *ndev)
+static void enetc_stop(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int i;
 
 	netif_tx_stop_all_queues(ndev);
 
-	if (ndev->phydev) {
-		phy_stop(ndev->phydev);
-		phy_disconnect(ndev->phydev);
-	} else {
-		netif_carrier_off(ndev);
-	}
-
 	for (i = 0; i < priv->bdr_int_num; i++) {
+		int irq = pci_irq_vector(priv->si->pdev,
+					 ENETC_BDR_INT_BASE_IDX + i);
+
+		disable_irq(irq);
 		napi_synchronize(&priv->int_vector[i]->napi);
 		napi_disable(&priv->int_vector[i]->napi);
 	}
 
-	enetc_disable_interrupts(priv);
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
+	else
+		netif_carrier_off(ndev);
+
+	enetc_clear_interrupts(priv);
+}
+
+int enetc_close(struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+
+	enetc_stop(ndev);
 	enetc_clear_bdrs(priv);
 
+	if (ndev->phydev)
+		phy_disconnect(ndev->phydev);
 	enetc_free_rxtx_rings(priv);
 	enetc_free_rx_resources(priv);
 	enetc_free_tx_resources(priv);
-- 
2.17.1

