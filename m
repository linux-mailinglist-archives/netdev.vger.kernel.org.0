Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350E0229854
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgGVMiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:38:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51518 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 08:38:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BB3611A0B37;
        Wed, 22 Jul 2020 14:38:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AF3671A0B18;
        Wed, 22 Jul 2020 14:38:48 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A05F202AC;
        Wed, 22 Jul 2020 14:38:48 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] enetc: Remove the imdio bus on PF probe bailout
Date:   Wed, 22 Jul 2020 15:38:48 +0300
Message-Id: <1595421528-14063-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_imdio_remove() is missing from the enetc_pf_probe()
bailout path. Not surprisingly because enetc_setup_serdes()
is registering the imdio bus for internal purposes, and it's
not obvious that enetc_imdio_remove() currently performs the
teardown of enetc_setup_serdes().
To fix this, define enetc_teardown_serdes() to wrap
enetc_imdio_remove() (improve code maintenance) and call it
on bailout and remove paths.

Fixes: 975d183ef0ca ("net: enetc: Initialize SerDes for SGMII and USXGMII protocols")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 5a08f66b123c..1d2158fd9a28 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -966,6 +966,13 @@ static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
 	return 0;
 }
 
+static void enetc_teardown_serdes(struct enetc_ndev_priv *priv)
+{
+	struct enetc_pf *pf = enetc_si_priv(priv->si);
+
+	enetc_imdio_remove(pf);
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1045,6 +1052,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
+	enetc_teardown_serdes(priv);
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -1071,7 +1079,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	priv = netdev_priv(si->ndev);
 	unregister_netdev(si->ndev);
 
-	enetc_imdio_remove(pf);
+	enetc_teardown_serdes(priv);
 	enetc_mdio_remove(pf);
 	enetc_of_put_phy(pf);
 
-- 
2.17.1

