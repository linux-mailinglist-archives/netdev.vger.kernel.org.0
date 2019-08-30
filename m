Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB472A3EEA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfH3UXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:23:36 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:30873 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3UXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:23:35 -0400
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d57 with ME
        id vYPF200053xPcdm03YPRdx; Fri, 30 Aug 2019 22:23:34 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 30 Aug 2019 22:23:34 +0200
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     yangbo.lu@nxp.com, claudiu.manoil@nxp.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] enetc: Add missing call to 'pci_free_irq_vectors()' in probe and remove functions
Date:   Fri, 30 Aug 2019 22:23:12 +0200
Message-Id: <20190830202312.21287-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call to 'pci_free_irq_vectors()' are missing both in the error handling
path of the probe function, and in the remove function.
Add them.

Fixes: 19971f5ea0ab ("enetc: add PTP clock driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index 2fd2586e42bf..bc594892507a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -82,7 +82,7 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 	n = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSIX);
 	if (n != 1) {
 		err = -EPERM;
-		goto err_irq;
+		goto err_irq_vectors;
 	}
 
 	ptp_qoriq->irq = pci_irq_vector(pdev, 0);
@@ -107,6 +107,8 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 err_no_clock:
 	free_irq(ptp_qoriq->irq, ptp_qoriq);
 err_irq:
+	pci_free_irq_vectors(pdev);
+err_irq_vectors:
 	iounmap(base);
 err_ioremap:
 	kfree(ptp_qoriq);
@@ -125,6 +127,7 @@ static void enetc_ptp_remove(struct pci_dev *pdev)
 
 	enetc_phc_index = -1;
 	ptp_qoriq_free(ptp_qoriq);
+	pci_free_irq_vectors(pdev);
 	kfree(ptp_qoriq);
 
 	pci_release_mem_regions(pdev);
-- 
2.20.1

