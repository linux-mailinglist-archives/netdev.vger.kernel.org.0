Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051D6F921C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfKLOZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:25:08 -0500
Received: from inva020.nxp.com ([92.121.34.13]:37896 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfKLOZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:25:06 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E09851A07A7;
        Tue, 12 Nov 2019 15:25:04 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D4CF21A06FE;
        Tue, 12 Nov 2019 15:25:04 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A7C51205E9;
        Tue, 12 Nov 2019 15:25:04 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net v2] dpaa2-eth: free already allocated channels on probe defer
Date:   Tue, 12 Nov 2019 16:24:53 +0200
Message-Id: <1573568693-18642-1-git-send-email-ioana.ciornei@nxp.com>
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

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 19379bae0144..22e9519f65bb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2232,6 +2232,14 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 err_service_reg:
 	free_channel(priv, channel);
 err_alloc_ch:
+	for (i = 0; i < priv->num_channels; i++) {
+		channel = priv->channel[i];
+		nctx = &channel->nctx;
+		dpaa2_io_service_deregister(channel->dpio, nctx, dev);
+		free_channel(priv, channel);
+	}
+	priv->num_channels = 0;
+
 	if (err == -EPROBE_DEFER)
 		return err;
 
-- 
1.9.1

