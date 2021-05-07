Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280D5376251
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhEGIsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:48:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59788 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236434AbhEGIsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 04:48:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 275F31A09FD;
        Fri,  7 May 2021 10:47:50 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 66DED1A19D2;
        Fri,  7 May 2021 10:47:47 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C9284402E6;
        Fri,  7 May 2021 10:47:43 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next 5/6] enetc: store ptp device pointer
Date:   Fri,  7 May 2021 16:57:55 +0800
Message-Id: <20210507085756.20427-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store ptp device pointer which will be used for ptp domain
timestamp conversion.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h    | 1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 +++++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 08b283347d9c..03e1ee1f6615 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -351,6 +351,7 @@ struct enetc_ndev_priv {
 
 	struct work_struct	tx_onestep_tstamp;
 	struct sk_buff_head	tx_skbs;
+	struct device *ptp_dev;
 };
 
 /* Messaging */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31274325159a..71029b26e92e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1201,6 +1201,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
+	struct pci_dev *ptp_pdev;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	struct enetc_pf *pf;
@@ -1293,6 +1294,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
+	ptp_pdev = pci_get_device(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PTP, NULL);
+	if (ptp_pdev)
+		priv->ptp_dev = &ptp_pdev->dev;
+
 	if (!of_get_phy_mode(node, &pf->if_mode)) {
 		err = enetc_mdiobus_create(pf, node);
 		if (err)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 03090ba7e226..17fea364b091 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -138,6 +138,7 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
 	struct enetc_ndev_priv *priv;
+	struct pci_dev *ptp_pdev;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	int err;
@@ -188,6 +189,10 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
+	ptp_pdev = pci_get_device(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PTP, NULL);
+	if (ptp_pdev)
+		priv->ptp_dev = &ptp_pdev->dev;
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
-- 
2.25.1

