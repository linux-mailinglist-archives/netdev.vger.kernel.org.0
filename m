Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BBC6048C6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiJSOIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiJSOIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:08:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CB4110B39;
        Wed, 19 Oct 2022 06:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666187397; x=1697723397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PJS259bMZ6Vl7hDKWsjlKqwsvvabW6MHvQxeu9lg7+4=;
  b=gDk+Q5y7Q+7yCPwwmY5OgGsNImh5gMCB3o7pM2EWDz+v1z4JRzNT7RhM
   Mmuv+vqhpN3bonUEJzPux6Di7RDdSPNi78IZ72AWoUMMutl5UMxu2/+Kq
   1FtmyQmeoHoW0aqTPQNLFd34D2w9BnEubOFiyaC0fbSo9UoD1FmcuAJZh
   KafkhOPgLU2f7f6zCZTVSEOs7uFp+2aIXa8EJAH4v9FUJN6fZK8qhCPKt
   w+pxvYlRde/VJr/4QEXh05apWPdD57lGnlgDTk2o8H8JKGxaFEkqi2gu/
   rA55fxMFssbnP1qAzmk5BcHlRurtXV7HHDJ4Y/tMNu2dYeZ1minouAakL
   w==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="196129601"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 06:46:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 06:46:47 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 06:46:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/5] net: lan966x: Add basic XDP support
Date:   Wed, 19 Oct 2022 15:50:07 +0200
Message-ID: <20221019135008.3281743-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
References: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce basic XDP support to lan966x driver. Currently the driver
supports only the actions XDP_PASS, XDP_DROP and XDP_ABORTED.
Currently the driver doesn't support xdp programs if any of the ports
have the MTU bigger than a page size.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  14 ++-
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  14 +++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 100 ++++++++++++++++++
 5 files changed, 134 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 962f7c5f9e7dd..251a7d561d633 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -11,4 +11,5 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_ptp.o lan966x_fdma.o lan966x_lag.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
-			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o
+			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o \
+			lan966x_xdp.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 6b6baf6a3d1ee..4e8f7e47c5536 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -422,6 +422,7 @@ static bool lan966x_fdma_rx_more_frames(struct lan966x_rx *rx)
 static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 {
 	struct lan966x *lan966x = rx->lan966x;
+	struct lan966x_port *port;
 	struct lan966x_db *db;
 	struct page *page;
 
@@ -439,7 +440,11 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
 		return FDMA_RX_ERROR;
 
-	return FDMA_RX_OK;
+	port = lan966x->ports[*src_port];
+	if (!lan966x_xdp_port_present(port))
+		return FDMA_RX_OK;
+
+	return lan966x_xdp_run(port, page, FDMA_DCB_STATUS_BLOCKL(db->status));
 }
 
 static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
@@ -518,6 +523,10 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		switch (err) {
 		case FDMA_RX_OK:
 			break;
+		case FDMA_RX_DROP:
+			lan966x_fdma_rx_free_page(rx);
+			lan966x_fdma_rx_advance_dcb(rx);
+			continue;
 		case FDMA_RX_ERROR:
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
@@ -776,6 +785,9 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 	    lan966x->rx.page_order)
 		return 0;
 
+	if (lan966x_xdp_present(lan966x) && max_mtu >= PAGE_SIZE)
+		return -EINVAL;
+
 	/* Disable the CPU port */
 	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(0),
 		QSYS_SW_PORT_MODE_PORT_ENA,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 4fa8c07039d9f..2e48caaadd59c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -487,6 +487,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 	.ndo_eth_ioctl			= lan966x_port_ioctl,
 	.ndo_setup_tc			= lan966x_tc_setup,
+	.ndo_bpf			= lan966x_xdp,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
@@ -713,6 +714,7 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 		if (port->dev)
 			unregister_netdev(port->dev);
 
+		lan966x_xdp_port_deinit(port);
 		if (lan966x->fdma && lan966x->fdma_ndev == port->dev)
 			lan966x_fdma_netdev_deinit(lan966x, port->dev);
 
@@ -1155,6 +1157,9 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->ports[p]->serdes = serdes;
 
 		lan966x_port_init(lan966x->ports[p]);
+		err = lan966x_xdp_port_init(lan966x->ports[p]);
+		if (err)
+			goto cleanup_ports;
 	}
 
 	lan966x_mdb_init(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 608e2cb81b095..e635e529df0d4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -100,10 +100,12 @@ enum macaccess_entry_type {
 
 /* FDMA rx error codes for checking if the frame is valid
  * FDMA_RX_OK, frame is valid and can be used
+ * FDMA_RX_DROP, frame is dropped, but continue to get more frames
  * FDMA_RX_ERROR, something went wrong, stop getting more frames
  */
 enum lan966x_fdma_rx_error {
 	FDMA_RX_OK = 0,
+	FDMA_RX_DROP,
 	FDMA_RX_ERROR,
 };
 
@@ -327,6 +329,9 @@ struct lan966x_port {
 	enum netdev_lag_hash hash_type;
 
 	struct lan966x_port_tc tc;
+
+	struct bpf_prog *xdp_prog;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -536,6 +541,15 @@ void lan966x_mirror_port_stats(struct lan966x_port *port,
 			       struct flow_stats *stats,
 			       bool ingress);
 
+int lan966x_xdp_port_init(struct lan966x_port *port);
+void lan966x_xdp_port_deinit(struct lan966x_port *port);
+int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp);
+int lan966x_xdp_run(struct lan966x_port *port,
+		    struct page *page,
+		    u32 data_len);
+bool lan966x_xdp_present(struct lan966x *lan966x);
+bool lan966x_xdp_port_present(struct lan966x_port *port);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
new file mode 100644
index 0000000000000..b65bf648c543b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/filter.h>
+
+#include "lan966x_main.h"
+
+static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct bpf_prog *old_prog;
+
+	if (!lan966x->fdma) {
+		NL_SET_ERR_MSG_MOD(xdp->extack,
+				   "Allow to set xdp only when using fdma");
+		return -EOPNOTSUPP;
+	}
+
+	if (lan966x_get_max_mtu(lan966x) >= PAGE_SIZE) {
+		NL_SET_ERR_MSG_MOD(xdp->extack,
+				   "Jumbo frames not supported on XDP");
+		return -EOPNOTSUPP;
+	}
+
+	old_prog = xchg(&port->xdp_prog, xdp->prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return lan966x_xdp_setup(dev, xdp);
+	default:
+		return -EINVAL;
+	}
+}
+
+int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
+{
+	struct bpf_prog *xdp_prog = port->xdp_prog;
+	struct xdp_buff xdp;
+	u32 act;
+
+	xdp_init_buff(&xdp, PAGE_SIZE, &port->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
+			 data_len - IFH_LEN_BYTES, false);
+	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	switch (act) {
+	case XDP_PASS:
+		return FDMA_RX_OK;
+	default:
+		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(port->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+		return FDMA_RX_DROP;
+	}
+}
+
+bool lan966x_xdp_port_present(struct lan966x_port *port)
+{
+	return !!port->xdp_prog;
+}
+
+bool lan966x_xdp_present(struct lan966x *lan966x)
+{
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		if (!lan966x->ports[p])
+			continue;
+
+		if (lan966x_xdp_port_present(lan966x->ports[p]))
+			return true;
+	}
+
+	return false;
+}
+
+int lan966x_xdp_port_init(struct lan966x_port *port)
+{
+	struct lan966x *lan966x = port->lan966x;
+
+	return xdp_rxq_info_reg(&port->xdp_rxq, port->dev, 0,
+				lan966x->napi.napi_id);
+}
+
+void lan966x_xdp_port_deinit(struct lan966x_port *port)
+{
+	if (xdp_rxq_info_is_reg(&port->xdp_rxq))
+		xdp_rxq_info_unreg(&port->xdp_rxq);
+}
-- 
2.38.0

