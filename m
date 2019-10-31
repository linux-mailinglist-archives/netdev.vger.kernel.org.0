Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B178BEAF0A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfJaLhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:37:19 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56448 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfJaLhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:37:14 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1AB671A0509;
        Thu, 31 Oct 2019 12:37:13 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E0181A01F8;
        Thu, 31 Oct 2019 12:37:13 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BB6AF205E9;
        Thu, 31 Oct 2019 12:37:12 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next 13/13] dpaa_eth: register a device link for the qman portal used
Date:   Thu, 31 Oct 2019 13:36:59 +0200
Message-Id: <1572521819-10458-14-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change, unbinding the QMan portals did not trigger a
corresponding unbinding of the dpaa_eth making use of it; the first
QMan portal related operation issued afterwards crashed the kernel.
The device link ensures the dpaa_eth dependency upon the qman portal
used is honoured at the QMan portal removal.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 5 +++--
 drivers/soc/fsl/qbman/qman.c                   | 6 ------
 include/soc/fsl/qman.h                         | 7 -------
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9e6080aaf77a..18d3ec0f96d9 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -750,7 +750,7 @@ static void dpaa_release_channel(void)
 	qman_release_pool(rx_pool_channel);
 }
 
-static void dpaa_eth_add_channel(u16 channel)
+static void dpaa_eth_add_channel(u16 channel, struct device *dev)
 {
 	u32 pool = QM_SDQCR_CHANNELS_POOL_CONV(channel);
 	const cpumask_t *cpus = qman_affine_cpus();
@@ -760,6 +760,7 @@ static void dpaa_eth_add_channel(u16 channel)
 	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		portal = qman_get_affine_portal(cpu);
 		qman_p_static_dequeue_add(portal, pool);
+		qman_start_using_portal(portal, dev);
 	}
 }
 
@@ -2873,7 +2874,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	/* Walk the CPUs with affine portals
 	 * and add this pool channel to each's dequeue mask.
 	 */
-	dpaa_eth_add_channel(priv->channel);
+	dpaa_eth_add_channel(priv->channel, &pdev->dev);
 
 	dpaa_fq_setup(priv, &dpaa_fq_cbs, priv->mac_dev->port[TX]);
 
diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index bc75a5882b9e..1e164e03410a 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -1756,12 +1756,6 @@ int qman_start_using_portal(struct qman_portal *p, struct device *dev)
 }
 EXPORT_SYMBOL(qman_start_using_portal);
 
-void qman_stop_using_portal(struct qman_portal *p, struct device *dev)
-{
-	device_link_remove(dev, p->config->dev);
-}
-EXPORT_SYMBOL(qman_stop_using_portal);
-
 int qman_p_poll_dqrr(struct qman_portal *p, unsigned int limit)
 {
 	return __poll_portal_fast(p, limit);
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index c499c5cfa7c9..cfe00e08e85b 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -926,13 +926,6 @@ struct qman_portal *qman_get_affine_portal(int cpu);
 int qman_start_using_portal(struct qman_portal *p, struct device *dev);
 
 /**
- * qman_stop_using_portal - deregister a device link for the portal user
- * @p: the portal that will no longer be in use
- * @dev: the device that uses the portal
- */
-void qman_stop_using_portal(struct qman_portal *p, struct device *dev);
-
-/**
  * qman_p_poll_dqrr - process DQRR (fast-path) entries
  * @limit: the maximum number of DQRR entries to process
  *
-- 
2.1.0

