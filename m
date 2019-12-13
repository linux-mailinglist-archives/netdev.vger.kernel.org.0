Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A5711E193
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfLMKFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 05:05:39 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44214 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMKFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 05:05:39 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 30C31200A30;
        Fri, 13 Dec 2019 11:05:37 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 221DB200E8C;
        Fri, 13 Dec 2019 11:05:37 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E8FA4205D0;
        Fri, 13 Dec 2019 11:05:36 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
Date:   Fri, 13 Dec 2019 12:04:22 +0200
Message-Id: <1576231462-23886-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was
used on the remove path to free any allocated resources.
The ptp_qoriq IRQ is among these resources that are freed in
ptp_qoriq_free() even though it is also a managed one (allocated using
devm_request_threaded_irq).

Drop the resource managed version of requesting the IRQ in order to not
trigger a double free of the interrupt as below:

[  226.731005] Trying to free already-free IRQ 126
[  226.735533] WARNING: CPU: 6 PID: 749 at kernel/irq/manage.c:1707
__free_irq+0x9c/0x2b8
[  226.743435] Modules linked in:
[  226.746480] CPU: 6 PID: 749 Comm: bash Tainted: G        W
5.4.0-03629-gfd7102c32b2c-dirty #912
[  226.755857] Hardware name: NXP Layerscape LX2160ARDB (DT)
[  226.761244] pstate: 40000085 (nZcv daIf -PAN -UAO)
[  226.766022] pc : __free_irq+0x9c/0x2b8
[  226.769758] lr : __free_irq+0x9c/0x2b8
[  226.773493] sp : ffff8000125039f0
(...)
[  226.856275] Call trace:
[  226.858710]  __free_irq+0x9c/0x2b8
[  226.862098]  free_irq+0x30/0x70
[  226.865229]  devm_irq_release+0x14/0x20
[  226.869054]  release_nodes+0x1b0/0x220
[  226.872790]  devres_release_all+0x34/0x50
[  226.876790]  device_release_driver_internal+0x100/0x1c0

Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index a9503aea527f..04a4b316f1dc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -160,10 +160,10 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	irq = mc_dev->irqs[0];
 	ptp_qoriq->irq = irq->msi_desc->irq;
 
-	err = devm_request_threaded_irq(dev, ptp_qoriq->irq, NULL,
-					dpaa2_ptp_irq_handler_thread,
-					IRQF_NO_SUSPEND | IRQF_ONESHOT,
-					dev_name(dev), ptp_qoriq);
+	err = request_threaded_irq(ptp_qoriq->irq, NULL,
+				   dpaa2_ptp_irq_handler_thread,
+				   IRQF_NO_SUSPEND | IRQF_ONESHOT,
+				   dev_name(dev), ptp_qoriq);
 	if (err < 0) {
 		dev_err(dev, "devm_request_threaded_irq(): %d\n", err);
 		goto err_free_mc_irq;
@@ -173,7 +173,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 				   DPRTC_IRQ_INDEX, 1);
 	if (err < 0) {
 		dev_err(dev, "dprtc_set_irq_enable(): %d\n", err);
-		goto err_free_mc_irq;
+		goto err_free_threaded_irq;
 	}
 
 	err = ptp_qoriq_init(ptp_qoriq, base, &dpaa2_ptp_caps);
@@ -185,6 +185,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 
 	return 0;
 
+err_free_threaded_irq:
+	free_irq(ptp_qoriq->irq, ptp_qoriq);
 err_free_mc_irq:
 	fsl_mc_free_irqs(mc_dev);
 err_unmap:
-- 
1.9.1

