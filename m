Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F77B7D2D2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 03:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfHABZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 21:25:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbfHABZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 21:25:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 91F4EC641AFD03DCBEBC;
        Thu,  1 Aug 2019 09:24:59 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 09:24:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set
Date:   Thu, 1 Aug 2019 09:24:19 +0800
Message-ID: <20190801012419.9728-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like FSL_ENETC, when CONFIG_FSL_ENETC_VF is set,
we should select PHYLIB, otherwise building still fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c:(.text+0x2744): undefined reference to `phy_start'
enetc.c:(.text+0x282c): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c:(.text+0x28f8): undefined reference to `phy_stop'
enetc.c:(.text+0x2904): undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x3f8): undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x400): undefined reference to `phy_ethtool_set_link_ksettings'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 46fdf36b..04a59db 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -13,6 +13,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  virtual function (VF) devices enabled by the ENETC PF driver.
-- 
2.7.4


