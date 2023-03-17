Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC46BECE2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCQP2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCQP2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:28:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C2837721;
        Fri, 17 Mar 2023 08:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679066927; x=1710602927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JJmgG0IrPX1K8hh63/+eloLkE2YLdl99GxbNs4GisBk=;
  b=0rFX+t68ec1Fwgh6qCaOa3RutcOgSjDhCuEtmL+wgxvTzKRYH8ic+/62
   7BGDgtNRrgWfox0vOqp4y7MPMRJFFSQt7lHZLhQd0c8qCuD6jFOTSNMON
   zxq0RBLA8EO9/XPb5mBSer7jkdqI/38JqIiKrBnQZZ7QhoePr9kqYNi3o
   2OOy1uhFHhItIPPm6NdNaJjenvUh4VgoPCuIn5e+Cbu/UJapt0ipWMn6z
   a4wy2kbsN/A1mLoL8ogyk0ABKTxfqHi8o35XzhthwPHUtyzZbPXfuhTUw
   uocoHimAwgC4TA35QNubcKv35yWUZObyrt+qGZGKYzzepUSRCNdeq1peg
   g==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205234276"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 08:28:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:28:47 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:28:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <david.laight@aculab.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/2] net: lan966x: Don't read RX timestamp if not needed
Date:   Fri, 17 Mar 2023 16:27:12 +0100
Message-ID: <20230317152713.4141614-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
References: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever a frame was received to the CPU, the HW is timestamping the
frame. In the IFH(Inter Frame Header) it is found the nanosecond part
of the timestamps the SW is required to read from HW the second part.
But reading the second part it seems to be a expensive operations, so
so change this such to read the second part only when rx filter is
enabled.
Doing this change gives the RX a performance boost of ~70mbit.

before:
[  5]   0.00-10.01  sec   546 MBytes   457 Mbits/sec    0 sender

now:
[  5]   0.00-10.01  sec   652 MBytes   530 Mbits/sec    0 sender

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  2 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +++--
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 20 +++++++++----------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 55b484b105627..2ed76bb61a731 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -517,7 +517,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
 
-	lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
+	lan966x_ptp_rxtstamp(lan966x, skb, src_port, timestamp);
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
 	if (lan966x->bridge_mask & BIT(src_port)) {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 685e8cd7658c9..4584a78c6ecbd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -668,7 +668,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 			*buf = val;
 		}
 
-		lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
+		lan966x_ptp_rxtstamp(lan966x, skb, src_port, timestamp);
 		skb->protocol = eth_type_trans(skb, dev);
 
 		if (lan966x->bridge_mask & BIT(src_port)) {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index cbdae0ab8bb6d..851afb0166b19 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -407,7 +407,8 @@ struct lan966x_port {
 	struct phy *serdes;
 	struct fwnode_handle *fwnode;
 
-	u8 ptp_cmd;
+	u8 ptp_tx_cmd;
+	bool ptp_rx_cmd;
 	u16 ts_id;
 	struct sk_buff_head tx_skbs;
 
@@ -527,7 +528,7 @@ void lan966x_ptp_deinit(struct lan966x *lan966x);
 int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr);
 int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr);
 void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
-			  u64 timestamp);
+			  u64 src_port, u64 timestamp);
 int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 				 struct sk_buff *skb);
 void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 931e37b9a0ada..266a21a2d1246 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -272,13 +272,13 @@ int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
 
 	switch (cfg.tx_type) {
 	case HWTSTAMP_TX_ON:
-		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		port->ptp_tx_cmd = IFH_REW_OP_TWO_STEP_PTP;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		port->ptp_cmd = IFH_REW_OP_ONE_STEP_PTP;
+		port->ptp_tx_cmd = IFH_REW_OP_ONE_STEP_PTP;
 		break;
 	case HWTSTAMP_TX_OFF:
-		port->ptp_cmd = IFH_REW_OP_NOOP;
+		port->ptp_tx_cmd = IFH_REW_OP_NOOP;
 		break;
 	default:
 		return -ERANGE;
@@ -286,6 +286,7 @@ int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
 
 	switch (cfg.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
+		port->ptp_rx_cmd = false;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
@@ -301,6 +302,7 @@ int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
+		port->ptp_rx_cmd = true;
 		cfg.rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
 	default:
@@ -332,7 +334,7 @@ static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
 	u8 msgtype;
 	int type;
 
-	if (port->ptp_cmd == IFH_REW_OP_NOOP)
+	if (port->ptp_tx_cmd == IFH_REW_OP_NOOP)
 		return IFH_REW_OP_NOOP;
 
 	type = ptp_classify_raw(skb);
@@ -343,7 +345,7 @@ static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
 	if (!header)
 		return IFH_REW_OP_NOOP;
 
-	if (port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+	if (port->ptp_tx_cmd == IFH_REW_OP_TWO_STEP_PTP)
 		return IFH_REW_OP_TWO_STEP_PTP;
 
 	/* If it is sync and run 1 step then set the correct operation,
@@ -1009,9 +1011,6 @@ static int lan966x_ptp_phc_init(struct lan966x *lan966x,
 	phc->index = index;
 	phc->lan966x = lan966x;
 
-	/* PTP Rx stamping is always enabled.  */
-	phc->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-
 	return 0;
 }
 
@@ -1088,14 +1087,15 @@ void lan966x_ptp_deinit(struct lan966x *lan966x)
 }
 
 void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
-			  u64 timestamp)
+			  u64 src_port, u64 timestamp)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
 	struct lan966x_phc *phc;
 	struct timespec64 ts;
 	u64 full_ts_in_ns;
 
-	if (!lan966x->ptp)
+	if (!lan966x->ptp ||
+	    !lan966x->ports[src_port]->ptp_rx_cmd)
 		return;
 
 	phc = &lan966x->phc[LAN966X_PHC_PORT];
-- 
2.38.0

