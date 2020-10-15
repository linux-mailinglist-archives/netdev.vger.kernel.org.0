Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF4B28F9DB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392054AbgJOUAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:00:43 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53570 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392040AbgJOUAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 16:00:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B549C2007C4;
        Thu, 15 Oct 2020 22:00:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A67C820060C;
        Thu, 15 Oct 2020 22:00:39 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 440C3202DA;
        Thu, 15 Oct 2020 22:00:39 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rdunlap@infradead.org, Jose.Abreu@synopsys.com, andrew@lunn.ch,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] net: pcs-xpcs: depend on MDIO_BUS instead of selecting it
Date:   Thu, 15 Oct 2020 23:00:23 +0300
Message-Id: <20201015200023.15746-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The below compile time error can be seen when PHYLIB is configured as a
module.

 ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_read':
 pcs-xpcs.c:(.text+0x29): undefined reference to `mdiobus_read'
 ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_soft_reset.constprop.7':
 pcs-xpcs.c:(.text+0x80): undefined reference to `mdiobus_write'
 ld: drivers/net/pcs/pcs-xpcs.o: in function `xpcs_config_aneg':
 pcs-xpcs.c:(.text+0x318): undefined reference to `mdiobus_write'
 ld: pcs-xpcs.c:(.text+0x38e): undefined reference to `mdiobus_write'
 ld: pcs-xpcs.c:(.text+0x3eb): undefined reference to `mdiobus_write'
 ld: pcs-xpcs.c:(.text+0x437): undefined reference to `mdiobus_write'
 ld: drivers/net/pcs/pcs-xpcs.o:pcs-xpcs.c:(.text+0xb1e): more undefined references to `mdiobus_write' follow

PHYLIB being a module leads to MDIO_BUS being a module as well while the
XPCS is still built-in. What should happen in this configuration is that
PCS_XPCS should be forced to build as module. However, that select only
acts in the opposite way so we should turn it into a depends.

Fix this up by explicitly depending on MDIO_BUS.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Fixes: 2fa4e4b799e1 ("net: pcs: Move XPCS into new PCS subdirectory")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/pcs/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 074fb3f5db18..22ba7b0b476d 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -7,8 +7,7 @@ menu "PCS device drivers"
 
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
-	select MDIO_BUS
-	depends on MDIO_DEVICE
+	depends on MDIO_DEVICE && MDIO_BUS
 	help
 	  This module provides helper functions for Synopsys DesignWare XPCS
 	  controllers.
-- 
2.17.1

