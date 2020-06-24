Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3A5207230
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390683AbgFXLfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:35:05 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36746 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388972AbgFXLex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:53 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E0B602010C3;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DC8112010BF;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A66352047A;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/5] dpaa2-eth: fix condition for number of buffer acquire retries
Date:   Wed, 24 Jun 2020 14:34:19 +0300
Message-Id: <20200624113421.17360-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should keep retrying to acquire buffers through the software portals
as long as the function returns -EBUSY and the number of retries is
__below__ DPAA2_ETH_SWP_BUSY_RETRIES.

Fixes: ef17bd7cc0c8 ("dpaa2-eth: Avoid unbounded while loops")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index db27f959d409..712bbfdbe7d7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1113,7 +1113,7 @@ static void drain_bufs(struct dpaa2_eth_priv *priv, int count)
 					       buf_array, count);
 		if (ret < 0) {
 			if (ret == -EBUSY &&
-			    retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
+			    retries++ < DPAA2_ETH_SWP_BUSY_RETRIES)
 				continue;
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
-- 
2.25.1

