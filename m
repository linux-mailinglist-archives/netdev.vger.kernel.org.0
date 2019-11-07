Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC61F2EC9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbfKGNDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:03:50 -0500
Received: from inva020.nxp.com ([92.121.34.13]:47228 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKGNDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 08:03:50 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C66B01A01C2;
        Thu,  7 Nov 2019 14:03:48 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BA0E01A0164;
        Thu,  7 Nov 2019 14:03:48 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 467F7205E3;
        Thu,  7 Nov 2019 14:03:48 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     hkallweit1@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next] net: phy: at803x: add missing dependency on CONFIG_REGULATOR
Date:   Thu,  7 Nov 2019 15:03:44 +0200
Message-Id: <1573131824-21664-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compilation fails on PPC targets as CONFIG_REGULATOR is not set and
drivers/regulator/devres.c is not compiled in while functions exported
there are used by drivers/net/phy/at803x.c. Here's the error log:

  LD      .tmp_vmlinux1
drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_set_voltage_sel':
drivers/net/phy/at803x.c:294: undefined reference to `.rdev_get_drvdata'
drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_get_voltage_sel':
drivers/net/phy/at803x.c:306: undefined reference to `.rdev_get_drvdata'
drivers/net/phy/at803x.o: In function `at8031_register_regulators':
drivers/net/phy/at803x.c:359: undefined reference to `.devm_regulator_register'
drivers/net/phy/at803x.c:365: undefined reference to `.devm_regulator_register'
drivers/net/phy/at803x.o:(.data.rel+0x0): undefined reference to `regulator_list_voltage_table'
linux/Makefile:1074: recipe for target 'vmlinux' failed
make[1]: *** [vmlinux] Error 1

Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 8bccadf17e60..fd6a82ce49a4 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -441,6 +441,7 @@ config NXP_TJA11XX_PHY
 
 config AT803X_PHY
 	tristate "Qualcomm Atheros AR803X PHYs"
+	depends on REGULATOR
 	help
 	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
 
-- 
2.1.0

