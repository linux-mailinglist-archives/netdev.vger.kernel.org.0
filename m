Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE266114E7C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLFJyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:54:17 -0500
Received: from inva021.nxp.com ([92.121.34.21]:51260 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfLFJyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 04:54:16 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 509A4201663;
        Fri,  6 Dec 2019 10:54:15 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2D2E9200595;
        Fri,  6 Dec 2019 10:54:13 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 706DE402F7;
        Fri,  6 Dec 2019 17:54:10 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH] enetc: disable EEE autoneg by default
Date:   Fri,  6 Dec 2019 17:53:35 +0800
Message-Id: <20191206095335.7450-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EEE support has not been enabled on ENETC, but it may connect
to a PHY which supports EEE and advertises EEE by default, while
its link partner also advertises EEE. If this happens, the PHY enters
low power mode when the traffic rate is low and causes packet loss.
This patch disables EEE advertisement by default for any PHY that
ENETC connects to, to prevent the above unwanted outcome.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9db1b96..1773990 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1332,6 +1332,7 @@ static int enetc_phy_connect(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct phy_device *phydev;
+	struct ethtool_eee edata;
 
 	if (!priv->phy_node)
 		return 0; /* phy-less mode */
@@ -1345,6 +1346,10 @@ static int enetc_phy_connect(struct net_device *ndev)
 
 	phy_attached_info(phydev);
 
+	/* disable EEE autoneg, until ENETC driver supports it */
+	memset(&edata, 0, sizeof(struct ethtool_eee));
+	phy_ethtool_set_eee(phydev, &edata);
+
 	return 0;
 }
 
-- 
2.7.4

