Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9784FEB2ED
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJaOiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:38:20 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54948 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfJaOiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:38:17 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 748101A0C37;
        Thu, 31 Oct 2019 15:38:15 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 685161A0556;
        Thu, 31 Oct 2019 15:38:15 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2355520605;
        Thu, 31 Oct 2019 15:38:15 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com, joe@perches.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next v2 10/13] dpaa_eth: remove netdev_err() for user errors
Date:   Thu, 31 Oct 2019 16:37:56 +0200
Message-Id: <1572532679-472-11-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User reports that an application making an (incorrect) call to
restart AN on a fixed link DPAA interface triggers an error in
the kernel log while the returned EINVAL should be enough.

Reported-by: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 1c689e11c61f..66d150872d48 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -80,10 +80,8 @@ static char dpaa_stats_global[][ETH_GSTRING_LEN] = {
 static int dpaa_get_link_ksettings(struct net_device *net_dev,
 				   struct ethtool_link_ksettings *cmd)
 {
-	if (!net_dev->phydev) {
-		netdev_dbg(net_dev, "phy device not initialized\n");
+	if (!net_dev->phydev)
 		return 0;
-	}
 
 	phy_ethtool_ksettings_get(net_dev->phydev, cmd);
 
@@ -95,10 +93,8 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
 {
 	int err;
 
-	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
+	if (!net_dev->phydev)
 		return -ENODEV;
-	}
 
 	err = phy_ethtool_ksettings_set(net_dev->phydev, cmd);
 	if (err < 0)
@@ -142,10 +138,8 @@ static int dpaa_nway_reset(struct net_device *net_dev)
 {
 	int err;
 
-	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
+	if (!net_dev->phydev)
 		return -ENODEV;
-	}
 
 	err = 0;
 	if (net_dev->phydev->autoneg) {
@@ -167,10 +161,8 @@ static void dpaa_get_pauseparam(struct net_device *net_dev,
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
 
-	if (!net_dev->phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
+	if (!net_dev->phydev)
 		return;
-	}
 
 	epause->autoneg = mac_dev->autoneg_pause;
 	epause->rx_pause = mac_dev->rx_pause_active;
-- 
2.1.0

