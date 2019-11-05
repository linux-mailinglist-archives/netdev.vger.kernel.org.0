Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1513F00F0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbfKEPOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:14:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36260 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389083AbfKEPOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:03 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3702BBDD1F94A57917F7;
        Tue,  5 Nov 2019 23:13:57 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 5 Nov 2019 23:13:48 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <ruxandra.radulescu@nxp.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] dpaa2-ptp: fix compile error
Date:   Tue, 5 Nov 2019 23:20:32 +0800
Message-ID: <1572967232-96724-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chenwandun <chenwandun@huawei.com>

phylink_set_port_modes will be compiled if CONFIG_PHYLINK enabled,
dpaa2_mac_validate will be compiled if CONFIG_FSL_DPAA2_ETH enabled,
it should select CONFIG_PHYLINK when dpaa2_mac_validate call
phylink_set_port_modes

drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.o: In function `dpaa2_mac_validate':
dpaa2-mac.c:(.text+0x3a1): undefined reference to `phylink_set_port_modes'
drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.o: In function `dpaa2_mac_connect':
dpaa2-mac.c:(.text+0x91a): undefined reference to `phylink_create'
dpaa2-mac.c:(.text+0x94e): undefined reference to `phylink_of_phy_connect'
dpaa2-mac.c:(.text+0x97f): undefined reference to `phylink_destroy'
drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.o: In function `dpaa2_mac_disconnect':
dpaa2-mac.c:(.text+0xa9f): undefined reference to `phylink_disconnect_phy'
dpaa2-mac.c:(.text+0xab0): undefined reference to `phylink_destroy'
make: *** [vmlinux] Error 1
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index fbef282..c6fb8e4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -2,6 +2,7 @@
 config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
+	select PHYLINK
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
-- 
2.7.4

