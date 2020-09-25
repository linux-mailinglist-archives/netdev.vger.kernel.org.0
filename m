Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257D6278B21
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgIYOol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:44:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46784 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbgIYOok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:44:40 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D293D20076D;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C6B95200604;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B2EB2030E;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: no need to check link state right after ndo_open
Date:   Fri, 25 Sep 2020 17:44:20 +0300
Message-Id: <20200925144421.7811-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925144421.7811-1-ioana.ciornei@nxp.com>
References: <20200925144421.7811-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to dpaa2_eth_link_state_update() is a leftover from the time
when on DPAA2 platforms the PHYs were started at boot time so when an
ifconfig was issued on the associated interface, the link status needed
to be checked directly from the ndo_open() callback.
This is not needed anymore since we are now properly integrated with the
PHY layer thus a link interrupt will come directly from the PHY
eventually without the need to call the sync function.
Fix this up by removing the call to dpaa2_eth_link_state_update().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 5bc965186f8c..a29c102b94f5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1700,22 +1700,11 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	if (!priv->mac) {
-		/* If the DPMAC object has already processed the link up
-		 * interrupt, we have to learn the link state ourselves.
-		 */
-		err = dpaa2_eth_link_state_update(priv);
-		if (err < 0) {
-			netdev_err(net_dev, "Can't update link state\n");
-			goto link_state_err;
-		}
-	} else {
+	if (priv->mac)
 		phylink_start(priv->mac->phylink);
-	}
 
 	return 0;
 
-link_state_err:
 enable_err:
 	dpaa2_eth_disable_ch_napi(priv);
 	dpaa2_eth_drain_pool(priv);
-- 
2.25.1

