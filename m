Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD838BD68
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhEUE2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:41 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47152 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239063AbhEUE20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C6BD1A010C;
        Fri, 21 May 2021 06:26:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 2C6BD1A010C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1621571193;
        bh=Ob6/fAWbo5qLxnUfVt5H5XofuGBwTloUXc68drPWfQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mq3raBtGXqXpdfWka9TdtFPnuLA8djtlgUXplYBCCc7Fvg17fL4E5Ioy5dHgwpEMy
         WzDUcF1fsU4vKr/rlPJI+P+Gn/9QKNBYqBba9oYXYXui0d7rChU4zm94ggLN8lDwOG
         MizguzaemDaScAFntMjeUZDch+zvj5602dijh5k974puqQIg1fv2w9v12v6XkZ5oCY
         DWNPHczOMD6gUIIJsARh3vJ+mmIKLAmSMOOWGb/7JqsHKpKl9ZS2UVmV9uAI0m0e2Y
         KidDDpsPMcSRhtEnkquKFxaOJyq9fLtfdU/afR2yXELoQCfIz90+mLOf+WTpl+wcGd
         38Fp0inDjCN2w==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4F38E1A0401;
        Fri, 21 May 2021 06:26:30 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 4F38E1A0401
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A75C3402A7;
        Fri, 21 May 2021 12:26:26 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 6/7] enetc: store ptp device pointer
Date:   Fri, 21 May 2021 12:36:18 +0800
Message-Id: <20210521043619.44694-7-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store ptp device pointer which will be used for ptp domain
timestamp conversion.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Made sure ptp device was got.
	- Update copyright.
---
 drivers/net/ethernet/freescale/enetc/enetc.h    |  3 ++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 14 +++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 08b283347d9c..925f2a96e375 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
-/* Copyright 2017-2019 NXP */
+/* Copyright 2017-2021 NXP */
 
 #include <linux/timer.h>
 #include <linux/pci.h>
@@ -351,6 +351,7 @@ struct enetc_ndev_priv {
 
 	struct work_struct	tx_onestep_tstamp;
 	struct sk_buff_head	tx_skbs;
+	struct device *ptp_dev;
 };
 
 /* Messaging */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31274325159a..994a4d3b715e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2017-2019 NXP */
+/* Copyright 2017-2021 NXP */
 
 #include <linux/mdio.h>
 #include <linux/module.h>
@@ -1201,6 +1201,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
+	struct pci_dev *ptp_pdev;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	struct enetc_pf *pf;
@@ -1293,6 +1294,16 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
+	ptp_pdev = pci_get_device(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PTP,
+				  NULL);
+	if (!ptp_pdev) {
+		dev_err(&pdev->dev, "no PTP device found\n");
+		err = -ENODEV;
+		goto err_get_ptp;
+	}
+
+	priv->ptp_dev = &ptp_pdev->dev;
+
 	if (!of_get_phy_mode(node, &pf->if_mode)) {
 		err = enetc_mdiobus_create(pf, node);
 		if (err)
@@ -1310,6 +1321,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
+err_get_ptp:
 	enetc_phylink_destroy(priv);
 err_phylink_create:
 	enetc_mdiobus_destroy(pf);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 03090ba7e226..ca1deb7d4dcb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2017-2019 NXP */
+/* Copyright 2017-2021 NXP */
 
 #include <linux/module.h>
 #include "enetc.h"
@@ -138,6 +138,7 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
 	struct enetc_ndev_priv *priv;
+	struct pci_dev *ptp_pdev;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	int err;
@@ -188,6 +189,16 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
+	ptp_pdev = pci_get_device(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PTP,
+				  NULL);
+	if (!ptp_pdev) {
+		dev_err(&pdev->dev, "no PTP device found\n");
+		err = -ENODEV;
+		goto err_get_ptp;
+	}
+
+	priv->ptp_dev = &ptp_pdev->dev;
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
@@ -197,6 +208,7 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
+err_get_ptp:
 	enetc_free_msix(priv);
 err_config_si:
 err_alloc_msix:
-- 
2.25.1

