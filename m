Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1187E278B23
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgIYOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:44:43 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46416 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgIYOol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:44:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2120E1A0921;
        Fri, 25 Sep 2020 16:44:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1457D1A0917;
        Fri, 25 Sep 2020 16:44:39 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D479A2030E;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-eth: install a single steering rule when SHARED_FS is enabled
Date:   Fri, 25 Sep 2020 17:44:21 +0300
Message-Id: <20200925144421.7811-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925144421.7811-1-ioana.ciornei@nxp.com>
References: <20200925144421.7811-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ionut-robert Aron <ionut-robert.aron@nxp.com>

When SHARED_FS is enabled on a DPNI object the flow steering tables are
shared between all the traffic classes. Modify the driver so that we
only add a new flow steering entry on the TC#0 when this new option is
enabled.

Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     | 12 ++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h          |  4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a29c102b94f5..5ea309c9867d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3454,6 +3454,12 @@ static int dpaa2_eth_config_hash_key(struct dpaa2_eth_priv *priv, dma_addr_t key
 			dev_err(dev, "dpni_set_rx_hash_dist failed\n");
 			break;
 		}
+
+		/* If the flow steering / hashing key is shared between all
+		 * traffic classes, install it just once
+		 */
+		if (priv->dpni_attrs.options & DPNI_OPT_SHARED_FS)
+			break;
 	}
 
 	return err;
@@ -3480,6 +3486,12 @@ static int dpaa2_eth_config_cls_key(struct dpaa2_eth_priv *priv, dma_addr_t key)
 			dev_err(dev, "dpni_set_rx_fs_dist failed\n");
 			break;
 		}
+
+		/* If the flow steering / hashing key is shared between all
+		 * traffic classes, install it just once
+		 */
+		if (priv->dpni_attrs.options & DPNI_OPT_SHARED_FS)
+			break;
 	}
 
 	return err;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 11e0c047dbd2..f981a523e13a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -618,7 +618,7 @@ static int dpaa2_eth_do_cls_rule(struct net_device *net_dev,
 			err = dpni_remove_fs_entry(priv->mc_io, 0,
 						   priv->mc_token, i,
 						   &rule_cfg);
-		if (err)
+		if (err || priv->dpni_attrs.options & DPNI_OPT_SHARED_FS)
 			break;
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 74456a37a997..e7b9e195b534 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -75,6 +75,10 @@ struct fsl_mc_io;
  * Disables the flow steering table.
  */
 #define DPNI_OPT_NO_FS				0x000020
+/**
+ * Flow steering table is shared between all traffic classes
+ */
+#define DPNI_OPT_SHARED_FS			0x001000
 
 int dpni_open(struct fsl_mc_io	*mc_io,
 	      u32		cmd_flags,
-- 
2.25.1

