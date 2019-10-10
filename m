Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05803D2E77
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfJJQUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:20:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47940 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfJJQUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 12:20:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9C3F3200210;
        Thu, 10 Oct 2019 18:19:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8F6472001ED;
        Thu, 10 Oct 2019 18:19:59 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 57E65205FA;
        Thu, 10 Oct 2019 18:19:59 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Florin Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 1/2] dpaa2-eth: add irq for the dpmac connect/disconnect event
Date:   Thu, 10 Oct 2019 19:19:46 +0300
Message-Id: <1570724387-5370-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1570724387-5370-1-git-send-email-ioana.ciornei@nxp.com>
References: <1570724387-5370-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>

Add IRQ for the DPNI endpoint change event, resolving the issue
when a dynamically created DPNI gets a randomly generated hw address
when the endpoint is a DPMAC object.

Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h      | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 162d7d8fb295..5acd734a216b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3306,6 +3306,9 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
 		link_state_update(netdev_priv(net_dev));
 
+	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
+		set_mac_addr(netdev_priv(net_dev));
+
 	return IRQ_HANDLED;
 }
 
@@ -3331,7 +3334,8 @@ static int setup_irqs(struct fsl_mc_device *ls_dev)
 	}
 
 	err = dpni_set_irq_mask(ls_dev->mc_io, 0, ls_dev->mc_handle,
-				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED);
+				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED |
+				DPNI_IRQ_EVENT_ENDPOINT_CHANGED);
 	if (err < 0) {
 		dev_err(&ls_dev->dev, "dpni_set_irq_mask(): %d\n", err);
 		goto free_irq;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index fd583911b6c0..ee0711d06b3a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -133,9 +133,12 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
  */
 #define DPNI_IRQ_INDEX				0
 /**
- * IRQ event - indicates a change in link state
+ * IRQ events:
+ *       indicates a change in link state
+ *       indicates a change in endpoint
  */
 #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
+#define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002
 
 int dpni_set_irq_enable(struct fsl_mc_io	*mc_io,
 			u32			cmd_flags,
-- 
1.9.1

