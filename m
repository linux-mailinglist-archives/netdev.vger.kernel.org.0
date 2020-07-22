Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AF8229851
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGVMiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:38:11 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50306 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 08:38:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6CC211A0A7D;
        Wed, 22 Jul 2020 14:38:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 60A601A0A6A;
        Wed, 22 Jul 2020 14:38:08 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B34C202AD;
        Wed, 22 Jul 2020 14:38:08 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] enetc: Remove the mdio bus on PF probe bailout
Date:   Wed, 22 Jul 2020 15:38:07 +0300
Message-Id: <1595421487-13978-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ENETC ports that register an external MDIO bus,
the bus doesn't get removed on the error bailout path
of enetc_pf_probe().  Fix this by unregistering the bus
inside enetc_of_put_phy(), since enetc_of_get_phy() is
were it gets registered.

This issue became much more visible after recent:
commit 07095c025ac2 ("net: enetc: Use DT protocol information to set up the ports")
Before this commit, one could make probing fail on the error
path only by having register_netdev() fail, which is unlikely.
But after this commit, because it moved the enetc_of_phy_get()
call up in the probing sequence, now we can trigger an mdiobus_free()
bug just by forcing enetc_alloc_msix() to return error, i.e. with the
'pci=nomsi' kernel bootarg (since ENETC relies on MSI support to work),
as the calltrace below shows:

kernel BUG at /home/eiz/work/enetc/net/drivers/net/phy/mdio_bus.c:648!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[...]
Hardware name: LS1028A RDB Board (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO BTYPE=--)
pc : mdiobus_free+0x50/0x58
lr : devm_mdiobus_free+0x14/0x20
[...]
Call trace:
 mdiobus_free+0x50/0x58
 devm_mdiobus_free+0x14/0x20
 release_nodes+0x138/0x228
 devres_release_all+0x38/0x60
 really_probe+0x1c8/0x368
 driver_probe_device+0x5c/0xc0
 device_driver_attach+0x74/0x80
 __driver_attach+0x8c/0xd8
 bus_for_each_dev+0x7c/0xd8
 driver_attach+0x24/0x30
 bus_add_driver+0x154/0x200
 driver_register+0x64/0x120
 __pci_register_driver+0x44/0x50
 enetc_pf_driver_init+0x24/0x30
 do_one_initcall+0x60/0x1c0
 kernel_init_freeable+0x1fc/0x274
 kernel_init+0x14/0x110
 ret_from_fork+0x10/0x34

Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 4fac57dbb3c8..bd42732f1375 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -827,6 +827,7 @@ static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
 {
 	struct device_node *np = priv->dev->of_node;
 
+	enetc_mdio_remove(pf);
 	if (np && of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	if (priv->phy_node)
@@ -932,7 +933,6 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	priv = netdev_priv(si->ndev);
 	unregister_netdev(si->ndev);
 
-	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 
 	enetc_free_msix(priv);
-- 
2.17.1

