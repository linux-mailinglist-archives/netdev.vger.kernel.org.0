Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2A2C56B4
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390284AbgKZOJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:09:40 -0500
Received: from foss.arm.com ([217.140.110.172]:34032 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389606AbgKZOJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 09:09:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 456F931B;
        Thu, 26 Nov 2020 06:09:39 -0800 (PST)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 42E703F71F;
        Thu, 26 Nov 2020 06:09:38 -0800 (PST)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     netdev@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] dpaa2-mac: select NET_DEVLINK to fix build
Date:   Thu, 26 Nov 2020 14:09:33 +0000
Message-Id: <20201126140933.1535197-1-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NET_DEVLINK is not selected, we get the following build error:

ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_rx_err':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:554: undefined reference to `devlink_trap_report'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_info_get':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:42: undefined reference to `devlink_info_driver_name_put'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:47: undefined reference to `devlink_info_version_running_put'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_register':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:199: undefined reference to `devlink_alloc'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:207: undefined reference to `devlink_register'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:216: undefined reference to `devlink_free'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_unregister':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:223: undefined reference to `devlink_unregister'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:224: undefined reference to `devlink_free'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_port_add':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:234: undefined reference to `devlink_port_attrs_set'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:236: undefined reference to `devlink_port_register'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:240: undefined reference to `devlink_port_type_eth_set'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_port_del':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:249: undefined reference to `devlink_port_type_clear'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:250: undefined reference to `devlink_port_unregister'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_traps_register':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:273: undefined reference to `devlink_trap_groups_register'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:280: undefined reference to `devlink_traps_register'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:290: undefined reference to `devlink_trap_groups_unregister'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_traps_unregister':
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:303: undefined reference to `devlink_traps_unregister'
ld: drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c:305: undefined reference to `devlink_trap_groups_unregister'

Commit f6b19b354d50 ("net: devlink: select NET_DEVLINK from drivers")
selected NET_DEVLINK from several drivers and rely on the functions
being there.

Replicate the same for FSL_DPAA2_ETH.

Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index cfd369cf4c8c..a86f9ebcf63b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -4,6 +4,7 @@ config FSL_DPAA2_ETH
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
 	select PCS_LYNX
+	select NET_DEVLINK
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
-- 
2.25.1

