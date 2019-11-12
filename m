Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A39CF9577
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLQWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:22:04 -0500
Received: from inva021.nxp.com ([92.121.34.21]:49224 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfKLQWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 11:22:04 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 95F332001F9;
        Tue, 12 Nov 2019 17:22:02 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 89648200247;
        Tue, 12 Nov 2019 17:22:02 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5622F20624;
        Tue, 12 Nov 2019 17:22:02 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net v3] dpaa2-eth: free already allocated channels on probe defer
Date:   Tue, 12 Nov 2019 18:21:52 +0200
Message-Id: <1573575712-1366-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setup_dpio() function tries to allocate a number of channels equal
to the number of CPUs online. When there are not enough DPCON objects
already probed, the function will return EPROBE_DEFER. When this
happens, the already allocated channels are not freed. This results in
the incapacity of properly probing the next time around.
Fix this by freeing the channels on the error path.

Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - add the proper Fixes tag
Changes in v3:
 - cleanup should be done only on EPROBE_DEFER

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 19379bae0144..bf5add954181 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2232,8 +2232,16 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 err_service_reg:
 	free_channel(priv, channel);
 err_alloc_ch:
-	if (err == -EPROBE_DEFER)
+	if (err == -EPROBE_DEFER) {
+		for (i = 0; i < priv->num_channels; i++) {
+			channel = priv->channel[i];
+			nctx = &channel->nctx;
+			dpaa2_io_service_deregister(channel->dpio, nctx, dev);
+			free_channel(priv, channel);
+		}
+		priv->num_channels = 0;
 		return err;
+	}
 
 	if (cpumask_empty(&priv->dpio_cpumask)) {
 		dev_err(dev, "No cpu with an affine DPIO/DPCON\n");
-- 
1.9.1

