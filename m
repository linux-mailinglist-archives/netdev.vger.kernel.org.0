Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CA229A48
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgGVOkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:40:15 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39554 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgGVOkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 10:40:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B78C200943;
        Wed, 22 Jul 2020 16:40:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0FACF20024B;
        Wed, 22 Jul 2020 16:40:13 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DE532202AC;
        Wed, 22 Jul 2020 16:40:12 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2] enetc: Remove the mdio bus on PF probe bailout
Date:   Wed, 22 Jul 2020 17:40:12 +0300
Message-Id: <1595428812-28995-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ENETC ports that register an external MDIO bus,
the bus doesn't get removed on the error bailout path
of enetc_pf_probe().

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
v2: called enetc_mdio_remove() directly,
instead of embedding it into enetc_of_put_phy()

 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 4fac57dbb3c8..7a9675bd36e8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -906,6 +906,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
+	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 	enetc_free_msix(priv);
 err_alloc_msix:
-- 
2.17.1

