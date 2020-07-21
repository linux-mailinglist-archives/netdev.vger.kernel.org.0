Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F92285E8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgGUQii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:38:38 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38980 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbgGUQie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:38:34 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CD972201622;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BFDEC2006B0;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 93192202A9;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-eth: add support for TBF offload
Date:   Tue, 21 Jul 2020 19:38:25 +0300
Message-Id: <20200721163825.9462-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721163825.9462-1-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

React to TC_SETUP_QDISC_TBF and configure the egress shaper as
appropriate with the maximum rate and burst size requested by the user.
TBF can only be offloaded on DPAA2 when it's the root qdisc, ie it's a
per port shaper.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 46 ++++++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  3 ++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 18e0c00074ff..c1bea9132f50 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -15,6 +15,7 @@
 #include <linux/fsl/mc.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/pkt_cls.h>
 #include <net/sock.h>
 
 #include "dpaa2-eth.h"
@@ -2251,12 +2252,55 @@ static int dpaa2_eth_setup_mqprio(struct net_device *net_dev,
 	return 0;
 }
 
+#define bps_to_mbits(rate) (div_u64((rate), 1000000) * 8)
+
+static int dpaa2_eth_setup_tbf(struct net_device *net_dev, struct tc_tbf_qopt_offload *p)
+{
+	struct tc_tbf_qopt_offload_replace_params *cfg = &p->replace_params;
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct dpni_tx_shaping_cfg tx_cr_shaper = { 0 };
+	struct dpni_tx_shaping_cfg tx_er_shaper = { 0 };
+	int err;
+
+	if (p->command == TC_TBF_STATS)
+		return -EOPNOTSUPP;
+
+	/* Only per port Tx shaping */
+	if (p->parent != TC_H_ROOT)
+		return -EOPNOTSUPP;
+
+	if (p->command == TC_TBF_REPLACE) {
+		if (cfg->max_size > DPAA2_ETH_MAX_BURST_SIZE) {
+			netdev_err(net_dev, "burst size cannot be greater than %d\n",
+				   DPAA2_ETH_MAX_BURST_SIZE);
+			return -EINVAL;
+		}
+
+		tx_cr_shaper.max_burst_size = cfg->max_size;
+		/* The TBF interface is in bytes/s, whereas DPAA2 expects the
+		 * rate in Mbits/s
+		 */
+		tx_cr_shaper.rate_limit = bps_to_mbits(cfg->rate.rate_bytes_ps);
+	}
+
+	err = dpni_set_tx_shaping(priv->mc_io, 0, priv->mc_token, &tx_cr_shaper,
+				  &tx_er_shaper, 0);
+	if (err) {
+		netdev_err(net_dev, "dpni_set_tx_shaping() = %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static int dpaa2_eth_setup_tc(struct net_device *net_dev,
 			      enum tc_setup_type type, void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return dpaa2_eth_setup_mqprio(net_dev, type_data);
+	case TC_SETUP_QDISC_TBF:
+		return dpaa2_eth_setup_tbf(net_dev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3726,7 +3770,7 @@ static int netdev_init(struct net_device *net_dev)
 	net_dev->features = NETIF_F_RXCSUM |
 			    NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_LLTX;
+			    NETIF_F_LLTX | NETIF_F_HW_TC;
 	net_dev->hw_features = net_dev->features;
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9138a35a68f9..7f3c41dc98f2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -43,6 +43,9 @@
  */
 #define DPAA2_ETH_FQ_TAILDROP_THRESH	(1024 * 1024)
 
+/* Maximum burst size value for Tx shaping */
+#define DPAA2_ETH_MAX_BURST_SIZE	0xF7FF
+
 /* Maximum number of Tx confirmation frames to be processed
  * in a single NAPI call
  */
-- 
2.25.1

