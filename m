Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED19FF70F6
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 10:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKJlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 04:41:05 -0500
Received: from inva020.nxp.com ([92.121.34.13]:45540 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfKKJlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 04:41:05 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A37CC1A08B6;
        Mon, 11 Nov 2019 10:41:01 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A15691A060B;
        Mon, 11 Nov 2019 10:41:01 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6BDA6205FE;
        Mon, 11 Nov 2019 10:41:01 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: free already allocated channels on probe defer
Date:   Mon, 11 Nov 2019 11:40:55 +0200
Message-Id: <1573465255-31409-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setup_dpio() function tries to allocate a number of channels equal
to the number of CPUs online. When there are no enough DPCON objects
already probed, the function will return EPROBE_DEFER. When this
happens, the already allocated channels are not freed. This results in
the incapacity of properly probing the next time around.
Fix this by freeing the channels on the error path.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
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

