Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78116234C8
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiKIUm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiKIUlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:41:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C952FC17;
        Wed,  9 Nov 2022 12:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668026511; x=1699562511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7J+txe2QCDmqgVLlF+l62Dh9hxkU0xy6Qshc999yOJk=;
  b=TL/iT6BqmI01k5Y+e3mzc5BWGlehLizXOzBB5+HivvrDZvFL2hRs9VgO
   dbZBty4DsmHoAFazlfqVKhjiWVJ55/799+CCph1fWtjTA1DMrv8PvnmeU
   iExUM0QUF3nX+2woO6Z9jAsyuAg2NyKCn8EPoCSxD6xwTGss0GmyZc+Sr
   VauY1YzKXlzewbOsY4yxvd09C/7Ou76msEu8g/Onh7TV5w/byFTva3ZZq
   IYdoSZleSKXXvvVYZq0VY/JV8Oz5f4nI2Jf28OvKL9pLMnSamQsUVSOrv
   nTEolYeh8f+PCgmSmtRy/1KLVfzbwhLOkfF9LVxO/nMmM72tLQHt9XAF4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="182748504"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 13:41:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 13:41:48 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 13:41:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.co>,
        <linux@armlinux.org.uk>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 3/4] net: lan966x: Add basic XDP support
Date:   Wed, 9 Nov 2022 21:46:12 +0100
Message-ID: <20221109204613.3669905-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce basic XDP support to lan966x driver. Currently the driver
supports only the actions XDP_PASS, XDP_DROP and XDP_ABORTED.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 11 ++-
 .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++
 .../ethernet/microchip/lan966x/lan966x_main.h | 16 ++++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 76 +++++++++++++++++++
 5 files changed, 109 insertions(+), 2 deletions(-)
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
index d37765ddd53ae..fa4198c617667 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -423,6 +423,7 @@ static bool lan966x_fdma_rx_more_frames(struct lan966x_rx *rx)
 static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 {
 	struct lan966x *lan966x = rx->lan966x;
+	struct lan966x_port *port;
 	struct lan966x_db *db;
 	struct page *page;
 
@@ -443,7 +444,11 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
 		return FDMA_ERROR;
 
-	return FDMA_PASS;
+	port = lan966x->ports[*src_port];
+	if (!lan966x_xdp_port_present(port))
+		return FDMA_PASS;
+
+	return lan966x_xdp_run(port, page, FDMA_DCB_STATUS_BLOCKL(db->status));
 }
 
 static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
@@ -524,6 +529,10 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 			lan966x_fdma_rx_free_page(rx);
 			lan966x_fdma_rx_advance_dcb(rx);
 			goto allocate_new;
+		case FDMA_DROP:
+			lan966x_fdma_rx_free_page(rx);
+			lan966x_fdma_rx_advance_dcb(rx);
+			continue;
 		}
 
 		skb = lan966x_fdma_rx_get_frame(rx, src_port);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1a27946ccaf44..42be5d0f1f015 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -468,6 +468,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 	.ndo_eth_ioctl			= lan966x_port_ioctl,
 	.ndo_setup_tc			= lan966x_tc_setup,
+	.ndo_bpf			= lan966x_xdp,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
@@ -694,6 +695,7 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 		if (port->dev)
 			unregister_netdev(port->dev);
 
+		lan966x_xdp_port_deinit(port);
 		if (lan966x->fdma && lan966x->fdma_ndev == port->dev)
 			lan966x_fdma_netdev_deinit(lan966x, port->dev);
 
@@ -1136,6 +1138,9 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->ports[p]->serdes = serdes;
 
 		lan966x_port_init(lan966x->ports[p]);
+		err = lan966x_xdp_port_init(lan966x->ports[p]);
+		if (err)
+			goto cleanup_ports;
 	}
 
 	lan966x_mdb_init(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 464fb5e4a8ff6..b3b0619b17c61 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -103,10 +103,12 @@ enum macaccess_entry_type {
 /* FDMA return action codes for checking if the frame is valid
  * FDMA_PASS, frame is valid and can be used
  * FDMA_ERROR, something went wrong, stop getting more frames
+ * FDMA_DROP, frame is dropped, but continue to get more frames
  */
 enum lan966x_fdma_action {
 	FDMA_PASS = 0,
 	FDMA_ERROR,
+	FDMA_DROP,
 };
 
 struct lan966x_port;
@@ -329,6 +331,9 @@ struct lan966x_port {
 	enum netdev_lag_hash hash_type;
 
 	struct lan966x_port_tc tc;
+
+	struct bpf_prog *xdp_prog;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -536,6 +541,17 @@ void lan966x_mirror_port_stats(struct lan966x_port *port,
 			       struct flow_stats *stats,
 			       bool ingress);
 
+int lan966x_xdp_port_init(struct lan966x_port *port);
+void lan966x_xdp_port_deinit(struct lan966x_port *port);
+int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp);
+int lan966x_xdp_run(struct lan966x_port *port,
+		    struct page *page,
+		    u32 data_len);
+static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
+{
+	return !!port->xdp_prog;
+}
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
new file mode 100644
index 0000000000000..e77d9f2aad2b4
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -0,0 +1,76 @@
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
+	struct lan966x *lan966x = port->lan966x;
+	struct xdp_buff xdp;
+	u32 act;
+
+	xdp_init_buff(&xdp, PAGE_SIZE << lan966x->rx.page_order,
+		      &port->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
+			 data_len - IFH_LEN_BYTES, false);
+	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	switch (act) {
+	case XDP_PASS:
+		return FDMA_PASS;
+	default:
+		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(port->dev, xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+		return FDMA_DROP;
+	}
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

