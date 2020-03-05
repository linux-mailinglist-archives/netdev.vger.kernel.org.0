Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E37E17AB36
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCERJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:09:05 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34258 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgCERJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:09:05 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9604E2007A1;
        Thu,  5 Mar 2020 18:09:03 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 89FCC20079C;
        Thu,  5 Mar 2020 18:09:03 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 555D82059E;
        Thu,  5 Mar 2020 18:09:03 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, s.hauer@pengutronix.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v3 3/3] dpaa_eth: Use random MAC address when none is given
Date:   Thu,  5 Mar 2020 19:08:58 +0200
Message-Id: <1583428138-12733-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no valid MAC address in the device tree, use a random
MAC address.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e3ac9ec54c7c..190e4478128a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -259,8 +259,20 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->features |= net_dev->hw_features;
 	net_dev->vlan_features = net_dev->features;
 
-	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
-	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+	if (is_valid_ether_addr(mac_addr)) {
+		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
+		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
+	} else {
+		eth_hw_addr_random(net_dev);
+		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+			(enet_addr_t *)net_dev->dev_addr);
+		if (err) {
+			dev_err(dev, "Failed to set random MAC address\n");
+			return -EINVAL;
+		}
+		dev_info(dev, "Using random MAC address: %pM\n",
+			 net_dev->dev_addr);
+	}
 
 	net_dev->ethtool_ops = &dpaa_ethtool_ops;
 
-- 
2.1.0

