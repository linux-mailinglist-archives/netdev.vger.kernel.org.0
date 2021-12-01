Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545BE464493
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345317AbhLABif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:38:35 -0500
Received: from inva021.nxp.com ([92.121.34.21]:45026 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241105AbhLABie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 20:38:34 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0043920190F;
        Wed,  1 Dec 2021 02:35:13 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C0A70201917;
        Wed,  1 Dec 2021 02:35:12 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 04766183AD6E;
        Wed,  1 Dec 2021 09:35:10 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, Joao.Pinto@synopsys.com,
        mingkai.hu@nxp.com, leoyang.li@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 2/2] net: stmmac: make stmmac-tx-timeout configurable in Kconfig
Date:   Wed,  1 Dec 2021 09:47:05 +0800
Message-Id: <20211201014705.6975-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_tx_timeout() function is called when a queue transmission
timeout. When Strict Priority is used as scheduling algorithms, the
lower priority queue may be blocked by a higher prority queue, which
will lead to tx timeout. We don't want to enable the tx watchdog timeout
in this case. Therefore, this patch make stmmac-tx-timeout configurable.

This patch set the CONFIG_STMMAC_TX_TIMEOUT by default when STMMAC_ETH
is selected. If anyone want to disable the tx watchdog timeout of
stmmac, he can unset the CONFIG_STMMAC_TX_TIMEOUT in menuconfig.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig       | 12 ++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 929cfc22cd0c..856c7d056b61 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -271,4 +271,16 @@ config STMMAC_PCI
 	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
+
+config STMMAC_TX_TIMEOUT
+	bool "STMMAC TX timeout support"
+	default STMMAC_ETH
+	depends on STMMAC_ETH
+	help
+	  Support for TX timeout enable on stmmac.
+
+	  This selects the TX watchdog timeout support for stmmac driver. The
+	  feature is enabled by default when STMMAC_ETH is selected. If you
+	  want to disable the TX watchdog timeout feature, say N here.
+
 endif
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89a6c35e2546..0a712b5d0715 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5421,6 +5421,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
 	return min(rxtx_done, budget - 1);
 }
 
+#ifdef CONFIG_STMMAC_TX_TIMEOUT
 /**
  *  stmmac_tx_timeout
  *  @dev : Pointer to net device structure
@@ -5436,6 +5437,7 @@ static void stmmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 
 	stmmac_global_err(priv);
 }
+#endif
 
 /**
  *  stmmac_set_rx_mode - entry point for multicast addressing
@@ -6632,7 +6634,9 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_fix_features = stmmac_fix_features,
 	.ndo_set_features = stmmac_set_features,
 	.ndo_set_rx_mode = stmmac_set_rx_mode,
+#ifdef CONFIG_STMMAC_TX_TIMEOUT
 	.ndo_tx_timeout = stmmac_tx_timeout,
+#endif
 	.ndo_eth_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
 	.ndo_select_queue = stmmac_select_queue,
-- 
2.17.1

