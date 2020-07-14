Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DAA21F00E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGNMIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:08:23 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50450 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgGNMIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 08:08:23 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AE0EE200FFD;
        Tue, 14 Jul 2020 14:08:21 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A0E192015C2;
        Tue, 14 Jul 2020 14:08:21 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 64C93205A4;
        Tue, 14 Jul 2020 14:08:21 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: check fsl_mc_get_endpoint for IS_ERR_OR_NULL()
Date:   Tue, 14 Jul 2020 15:08:16 +0300
Message-Id: <20200714120816.6929-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fsl_mc_get_endpoint() function can return an error or directly a
NULL pointer in case the peer device is not under the root DPRC
container. Treat this case also, otherwise it would lead to a NULL
pointer when trying to access the peer fsl_mc_device.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f150cd454fa4..0998ceb1a26e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3632,7 +3632,7 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
-	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
 	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
-- 
2.25.1

