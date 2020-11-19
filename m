Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E342B97FC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgKSQ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:29:44 -0500
Received: from inva021.nxp.com ([92.121.34.21]:56626 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgKSQ3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:29:43 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2488B2004E6;
        Thu, 19 Nov 2020 17:29:42 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 176D42002F0;
        Thu, 19 Nov 2020 17:29:42 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AE52F20329;
        Thu, 19 Nov 2020 17:29:41 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v3 3/7] dpaa_eth: limit the possible MTU range when XDP is enabled
Date:   Thu, 19 Nov 2020 18:29:32 +0200
Message-Id: <859f2a69342d32d7c4a5885bfb4cb0097f246ac4.1605802951.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1605802951.git.camelia.groza@nxp.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605802951.git.camelia.groza@nxp.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ndo_change_mtu callback to prevent users from setting an
MTU that would permit processing of S/G frames. The maximum MTU size
is dependent on the buffer size.

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 32 ++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 102023c..242ed45 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2756,6 +2756,34 @@ static int dpaa_eth_stop(struct net_device *net_dev)
 	return err;
 }
 
+static bool xdp_validate_mtu(struct dpaa_priv *priv, int mtu)
+{
+	int max_contig_data = priv->dpaa_bp->size - priv->rx_headroom;
+
+	/* We do not support S/G fragments when XDP is enabled.
+	 * Limit the MTU in relation to the buffer size.
+	 */
+	if (mtu + VLAN_ETH_HLEN + ETH_FCS_LEN > max_contig_data) {
+		dev_warn(priv->net_dev->dev.parent,
+			 "The maximum MTU for XDP is %d\n",
+			 max_contig_data - VLAN_ETH_HLEN - ETH_FCS_LEN);
+		return false;
+	}
+
+	return true;
+}
+
+static int dpaa_change_mtu(struct net_device *net_dev, int new_mtu)
+{
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+
+	if (priv->xdp_prog && !xdp_validate_mtu(priv, new_mtu))
+		return -EINVAL;
+
+	net_dev->mtu = new_mtu;
+	return 0;
+}
+
 static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog *prog)
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
@@ -2764,8 +2792,7 @@ static int dpaa_setup_xdp(struct net_device *net_dev, struct bpf_prog *prog)
 	int err;
 
 	/* S/G fragments are not supported in XDP-mode */
-	if (prog && (priv->dpaa_bp->raw_size <
-	    net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN))
+	if (prog && !xdp_validate_mtu(priv, net_dev->mtu))
 		return -EINVAL;
 
 	up = netif_running(net_dev);
@@ -2862,6 +2889,7 @@ static int dpaa_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd)
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
 	.ndo_do_ioctl = dpaa_ioctl,
 	.ndo_setup_tc = dpaa_setup_tc,
+	.ndo_change_mtu = dpaa_change_mtu,
 	.ndo_bpf = dpaa_xdp,
 };
 
-- 
1.9.1

