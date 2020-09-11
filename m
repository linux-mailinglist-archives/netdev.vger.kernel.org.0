Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15424265D9C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgIKKQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:16:45 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40598 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgIKKQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 06:16:41 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 833D3200A2A;
        Fri, 11 Sep 2020 12:16:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 74468200663;
        Fri, 11 Sep 2020 12:16:36 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 425FE20395;
        Fri, 11 Sep 2020 12:16:36 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] enetc: Fix mdio bus removal on PF probe bailout
Date:   Fri, 11 Sep 2020 13:16:35 +0300
Message-Id: <1599819395-26206-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the correct resolution for the conflict from
merging the "net" tree fix:
commit 26cb7085c898 ("enetc: Remove the mdio bus on PF probe bailout")
with the "net-next" new work:
commit 07095c025ac2 ("net: enetc: Use DT protocol information to set up the ports")
that moved mdio bus allocation to an ealier stage of
the PF probing routine.

Fixes: a57066b1a019 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 26d5981b798f..177334f0adb1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1053,7 +1053,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 
 err_reg_netdev:
 	enetc_teardown_serdes(priv);
-	enetc_mdio_remove(pf);
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -1061,6 +1060,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+	enetc_mdio_remove(pf);
 	enetc_of_put_phy(pf);
 err_map_pf_space:
 	enetc_pci_remove(pdev);
-- 
2.17.1

