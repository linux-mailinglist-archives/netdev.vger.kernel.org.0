Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA81636B42
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbiKWUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiKWUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:31:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2F0B46;
        Wed, 23 Nov 2022 12:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669235247; x=1700771247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iKDTlOAUZqqB5RQV8RImjoFEKIKyw5FL5Cc7xV3NePg=;
  b=ihj3wKVO9hnRNld1pAUpHgTe1ukP3WggtLea3/HiVg9yKraZPdaFFqLk
   n7PVLsZfO6RAazz9wJztKN6ufEgRh6ZSpRxbm3cxtS5WT4wrQb4yJ/IBB
   kQWRyD2kA+Fgesh9fmyDV5NLSr2kxLy+tUv70tBarQHvhjgBA8eFKmUZB
   S7+bet21Jgzk298xFeo471MzbBeDZBQoY2BMBJUmkdvkZQ3HTASeruv+M
   lwXDZhkuXuO7tTbwSiNbXCgcrqxJnAY2Osw7kwJgRe9tI4LlMI12cHYhZ
   VyyTg5bjNSFCej6NRmuDCWxGJAy6wsxJ8UK8BD11G2/X2FY0u/0pOm1t2
   A==;
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="184921921"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 13:27:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 13:27:21 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 13:27:18 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 5/7] net: lan966x: Update dma_dir of page_pool_params
Date:   Wed, 23 Nov 2022 21:31:37 +0100
Message-ID: <20221123203139.3828548-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
References: <20221123203139.3828548-1-horatiu.vultur@microchip.com>
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

To add support for XDP_TX it is required to be able to write to the DMA
area therefore it is required that the pages will be mapped using
DMA_BIDIRECTIONAL flag.
Therefore check if there are any xdp programs on the interfaces and in
that case set DMA_BIDRECTIONAL otherwise use DMA_FROM_DEVICE.
Therefore when a new XDP program is added it is required to redo the
page_pool.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 29 +++++++++++++++----
 .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  | 28 ++++++++++++++++++
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 3df3b3d29b4ff..bc30c31c43602 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -79,6 +79,9 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
 			   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
 	};
 
+	if (lan966x_xdp_present(lan966x))
+		pp_params.dma_dir = DMA_BIDIRECTIONAL;
+
 	rx->page_pool = page_pool_create(&pp_params);
 
 	for (int i = 0; i < lan966x->num_phys_ports; ++i) {
@@ -826,16 +829,11 @@ static int lan966x_fdma_get_max_frame(struct lan966x *lan966x)
 	       XDP_PACKET_HEADROOM;
 }
 
-int lan966x_fdma_change_mtu(struct lan966x *lan966x)
+static int __lan966x_fdma_reload(struct lan966x *lan966x, int max_mtu)
 {
-	int max_mtu;
 	int err;
 	u32 val;
 
-	max_mtu = lan966x_fdma_get_max_frame(lan966x);
-	if (max_mtu == lan966x->rx.max_mtu)
-		return 0;
-
 	/* Disable the CPU port */
 	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(0),
 		QSYS_SW_PORT_MODE_PORT_ENA,
@@ -861,6 +859,25 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 	return err;
 }
 
+int lan966x_fdma_change_mtu(struct lan966x *lan966x)
+{
+	int max_mtu;
+
+	max_mtu = lan966x_fdma_get_max_frame(lan966x);
+	if (max_mtu == lan966x->rx.max_mtu)
+		return 0;
+
+	return __lan966x_fdma_reload(lan966x, max_mtu);
+}
+
+int lan966x_fdma_reload_page_pool(struct lan966x *lan966x)
+{
+	int max_mtu;
+
+	max_mtu = lan966x_fdma_get_max_frame(lan966x);
+	return __lan966x_fdma_reload(lan966x, max_mtu);
+}
+
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
 {
 	if (lan966x->fdma_ndev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c762e3732f88f..81c0b11097ce2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -466,6 +466,7 @@ void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev)
 int lan966x_fdma_init(struct lan966x *lan966x);
 void lan966x_fdma_deinit(struct lan966x *lan966x);
 irqreturn_t lan966x_fdma_irq_handler(int irq, void *args);
+int lan966x_fdma_reload_page_pool(struct lan966x *lan966x);
 
 int lan966x_lag_port_join(struct lan966x_port *port,
 			  struct net_device *brport_dev,
@@ -556,6 +557,7 @@ int lan966x_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int lan966x_xdp_run(struct lan966x_port *port,
 		    struct page *page,
 		    u32 data_len);
+bool lan966x_xdp_present(struct lan966x *lan966x);
 static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 {
 	return !!port->xdp_prog;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
index 8ebde1eb6a09c..ba7aa6df9d0e6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
@@ -11,6 +11,8 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
 	struct bpf_prog *old_prog;
+	bool old_xdp, new_xdp;
+	int err;
 
 	if (!lan966x->fdma) {
 		NL_SET_ERR_MSG_MOD(xdp->extack,
@@ -18,7 +20,20 @@ static int lan966x_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
 		return -EOPNOTSUPP;
 	}
 
+	old_xdp = lan966x_xdp_present(lan966x);
 	old_prog = xchg(&port->xdp_prog, xdp->prog);
+	new_xdp = lan966x_xdp_present(lan966x);
+
+	if (old_xdp == new_xdp)
+		goto out;
+
+	err = lan966x_fdma_reload_page_pool(lan966x);
+	if (err) {
+		xchg(&port->xdp_prog, old_prog);
+		return err;
+	}
+
+out:
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -62,6 +77,19 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
 	}
 }
 
+bool lan966x_xdp_present(struct lan966x *lan966x)
+{
+	for (int p = 0; p < lan966x->num_phys_ports; ++p) {
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
 int lan966x_xdp_port_init(struct lan966x_port *port)
 {
 	struct lan966x *lan966x = port->lan966x;
-- 
2.38.0

