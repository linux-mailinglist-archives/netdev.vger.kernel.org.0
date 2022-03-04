Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3F4CD30C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbiCDLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiCDLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:08:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7D11B0C41;
        Fri,  4 Mar 2022 03:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392025; x=1677928025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TseXg9eYtzS0QOuDicu1ocr99OoNaltLlH47uRchcio=;
  b=RhcOVCJa8lJzQwQafEHg/euUZUhcyeGfcG5mNvhNu6mVcA5jifAvbo8H
   yEdbVbfAc922OkfzPPP+FHnWyOECKGwXPz3KxWPxF/7gT/GR/+yFdgWeO
   tVOkYuDrFypfDKGfLV/PXfsv8p5jgdQz7EKub4Iad5G1a6+Lk1qFmyxCw
   MX2UdQQToVFZ8/XEl59MnJY6AJ51m3gtMot0dzofZgqVP6iLCDO9xDkva
   ql/0CQhUHL9CHMltAMcdOghkUyjNNOByD0M7r24Trz5SV8Qr4i09L2WAC
   5yJav5FlwCsMhhe9QmmCDVHOffLgOeIxld805LJQBwvIP1HNuuENgbqOe
   A==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="150853677"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:48 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 7/9] net: sparx5: Update extraction/injection for timestamping
Date:   Fri, 4 Mar 2022 12:08:58 +0100
Message-ID: <20220304110900.3199904-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update both the extraction and injection to do timestamping of the
frames. The extraction is always doing the timestamping while for
injection is doing the timestamping only if it is configured.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |   2 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  32 ++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  20 +++
 .../ethernet/microchip/sparx5/sparx5_packet.c |  29 ++-
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 166 ++++++++++++++++++
 5 files changed, 248 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 7436f62fa152..2dc87584023a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -240,6 +240,8 @@ static bool sparx5_fdma_rx_get_frame(struct sparx5 *sparx5, struct sparx5_rx *rx
 	skb_pull(skb, IFH_LEN * sizeof(u32));
 	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
+
+	sparx5_ptp_rxtstamp(sparx5, skb, fi.timestamp);
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	/* Everything we see on an interface that is in the HW bridge
 	 * has already been forwarded
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 8f3c7a904f71..16d691fdee65 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -88,6 +88,11 @@ enum sparx5_vlan_port_type {
 #define IFH_REW_OP_ONE_STEP_PTP		0x3
 #define IFH_REW_OP_TWO_STEP_PTP		0x4
 
+#define IFH_PDU_TYPE_NONE		0x0
+#define IFH_PDU_TYPE_PTP		0x5
+#define IFH_PDU_TYPE_IPV4_UDP_PTP	0x6
+#define IFH_PDU_TYPE_IPV6_UDP_PTP	0x7
+
 struct sparx5;
 
 struct sparx5_db_hw {
@@ -180,6 +185,8 @@ struct sparx5_port {
 	struct hrtimer inj_timer;
 	/* ptp */
 	u8 ptp_cmd;
+	u16 ts_id;
+	struct sk_buff_head tx_skbs;
 };
 
 enum sparx5_core_clockfreq {
@@ -197,6 +204,18 @@ struct sparx5_phc {
 	u8 index;
 };
 
+struct sparx5_skb_cb {
+	u8 rew_op;
+	u8 pdu_type;
+	u8 pdu_w16_offset;
+	u16 ts_id;
+	unsigned long jiffies;
+};
+
+#define SPARX5_PTP_TIMEOUT		msecs_to_jiffies(10)
+#define SPARX5_SKB_CB(skb) \
+	((struct sparx5_skb_cb *)((skb)->cb))
+
 struct sparx5 {
 	struct platform_device *pdev;
 	struct device *dev;
@@ -248,7 +267,9 @@ struct sparx5 {
 	bool ptp;
 	struct sparx5_phc phc[SPARX5_PHC_COUNT];
 	spinlock_t ptp_clock_lock; /* lock for phc */
+	spinlock_t ptp_ts_id_lock; /* lock for ts_id */
 	struct mutex ptp_lock; /* lock for ptp interface state */
+	u16 ptp_skbs;
 };
 
 /* sparx5_switchdev.c */
@@ -258,6 +279,7 @@ void sparx5_unregister_notifier_blocks(struct sparx5 *sparx5);
 /* sparx5_packet.c */
 struct frame_info {
 	int src_port;
+	u32 timestamp;
 };
 
 void sparx5_xtr_flush(struct sparx5 *sparx5, u8 grp);
@@ -311,6 +333,10 @@ void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats
 int sparx_stats_init(struct sparx5 *sparx5);
 
 /* sparx5_netdev.c */
+void sparx5_set_port_ifh_timestamp(void *ifh_hdr, u64 timestamp);
+void sparx5_set_port_ifh_rew_op(void *ifh_hdr, u32 rew_op);
+void sparx5_set_port_ifh_pdu_type(void *ifh_hdr, u32 pdu_type);
+void sparx5_set_port_ifh_pdu_w16_offset(void *ifh_hdr, u32 pdu_w16_offset);
 void sparx5_set_port_ifh(void *ifh_hdr, u16 portno);
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
@@ -323,6 +349,12 @@ int sparx5_ptp_init(struct sparx5 *sparx5);
 void sparx5_ptp_deinit(struct sparx5 *sparx5);
 int sparx5_ptp_hwtstamp_set(struct sparx5_port *port, struct ifreq *ifr);
 int sparx5_ptp_hwtstamp_get(struct sparx5_port *port, struct ifreq *ifr);
+void sparx5_ptp_rxtstamp(struct sparx5 *sparx5, struct sk_buff *skb,
+			 u64 timestamp);
+int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
+				struct sk_buff *skb);
+void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
+				 struct sk_buff *skb);
 
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 5fd0b2eea021..af4d3e1f1a6d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -74,6 +74,26 @@ void sparx5_set_port_ifh(void *ifh_hdr, u16 portno)
 	ifh_encode_bitfield(ifh_hdr, 1,        67, 1);
 }
 
+void sparx5_set_port_ifh_rew_op(void *ifh_hdr, u32 rew_op)
+{
+	ifh_encode_bitfield(ifh_hdr, rew_op, VSTAX + 32,  10);
+}
+
+void sparx5_set_port_ifh_pdu_type(void *ifh_hdr, u32 pdu_type)
+{
+	ifh_encode_bitfield(ifh_hdr, pdu_type, 191, 4);
+}
+
+void sparx5_set_port_ifh_pdu_w16_offset(void *ifh_hdr, u32 pdu_w16_offset)
+{
+	ifh_encode_bitfield(ifh_hdr, pdu_w16_offset, 195, 6);
+}
+
+void sparx5_set_port_ifh_timestamp(void *ifh_hdr, u64 timestamp)
+{
+	ifh_encode_bitfield(ifh_hdr, timestamp, 232,  40);
+}
+
 static int sparx5_port_open(struct net_device *ndev)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index d9c812f7d248..304f84aadc36 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -44,6 +44,12 @@ void sparx5_ifh_parse(u32 *ifh, struct frame_info *info)
 		((u32)xtr_hdr[30] <<  0);
 	fwd = (fwd >> 5);
 	info->src_port = FIELD_GET(GENMASK(7, 1), fwd);
+
+	info->timestamp =
+		((u64)xtr_hdr[2] << 24) |
+		((u64)xtr_hdr[3] << 16) |
+		((u64)xtr_hdr[4] <<  8) |
+		((u64)xtr_hdr[5] <<  0);
 }
 
 static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
@@ -144,6 +150,7 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	/* Finish up skb */
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
+	sparx5_ptp_rxtstamp(sparx5, skb, fi.timestamp);
 	skb->protocol = eth_type_trans(skb, netdev);
 	netdev->stats.rx_bytes += skb->len;
 	netdev->stats.rx_packets++;
@@ -224,6 +231,18 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	memset(ifh, 0, IFH_LEN * 4);
 	sparx5_set_port_ifh(ifh, port->portno);
 
+	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		ret = sparx5_ptp_txtstamp_request(port, skb);
+		if (ret)
+			return ret;
+
+		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
+		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
+		sparx5_set_port_ifh_pdu_w16_offset(ifh, SPARX5_SKB_CB(skb)->pdu_w16_offset);
+		sparx5_set_port_ifh_timestamp(ifh, SPARX5_SKB_CB(skb)->ts_id);
+	}
+
+	skb_tx_timestamp(skb);
 	if (sparx5->fdma_irq > 0)
 		ret = sparx5_fdma_xmit(sparx5, ifh, skb);
 	else
@@ -232,10 +251,18 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	if (ret == NETDEV_TX_OK) {
 		stats->tx_bytes += skb->len;
 		stats->tx_packets++;
-		skb_tx_timestamp(skb);
+
+		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+			return ret;
+
 		dev_kfree_skb_any(skb);
 	} else {
 		stats->tx_dropped++;
+
+		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+			sparx5_ptp_txtstamp_release(port, skb);
 	}
 	return ret;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0d919e249aef..976817d826ac 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -147,6 +147,130 @@ int sparx5_ptp_hwtstamp_get(struct sparx5_port *port, struct ifreq *ifr)
 			    sizeof(phc->hwtstamp_config)) ? -EFAULT : 0;
 }
 
+static void sparx5_ptp_classify(struct sparx5_port *port, struct sk_buff *skb,
+				u8 *rew_op, u8 *pdu_type, u8 *pdu_w16_offset)
+{
+	struct ptp_header *header;
+	u8 msgtype;
+	int type;
+
+	if (port->ptp_cmd == IFH_REW_OP_NOOP) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		*pdu_w16_offset = 0;
+		return;
+	}
+
+	type = ptp_classify_raw(skb);
+	if (type == PTP_CLASS_NONE) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		*pdu_w16_offset = 0;
+		return;
+	}
+
+	header = ptp_parse_header(skb, type);
+	if (!header) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		*pdu_w16_offset = 0;
+		return;
+	}
+
+	*pdu_w16_offset = 7;
+	if (type & PTP_CLASS_L2)
+		*pdu_type = IFH_PDU_TYPE_PTP;
+	if (type & PTP_CLASS_IPV4)
+		*pdu_type = IFH_PDU_TYPE_IPV4_UDP_PTP;
+	if (type & PTP_CLASS_IPV6)
+		*pdu_type = IFH_PDU_TYPE_IPV6_UDP_PTP;
+
+	if (port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		*rew_op = IFH_REW_OP_TWO_STEP_PTP;
+		return;
+	}
+
+	/* If it is sync and run 1 step then set the correct operation,
+	 * otherwise run as 2 step
+	 */
+	msgtype = ptp_get_msgtype(header, type);
+	if ((msgtype & 0xf) == 0) {
+		*rew_op = IFH_REW_OP_ONE_STEP_PTP;
+		return;
+	}
+
+	*rew_op = IFH_REW_OP_TWO_STEP_PTP;
+}
+
+static void sparx5_ptp_txtstamp_old_release(struct sparx5_port *port)
+{
+	struct sk_buff *skb, *skb_tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->tx_skbs.lock, flags);
+	skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+		if time_after(SPARX5_SKB_CB(skb)->jiffies + SPARX5_PTP_TIMEOUT,
+			      jiffies)
+			break;
+
+		__skb_unlink(skb, &port->tx_skbs);
+		dev_kfree_skb_any(skb);
+	}
+	spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+}
+
+int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
+				struct sk_buff *skb)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	u8 rew_op, pdu_type, pdu_w16_offset;
+	unsigned long flags;
+
+	sparx5_ptp_classify(port, skb, &rew_op, &pdu_type, &pdu_w16_offset);
+	SPARX5_SKB_CB(skb)->rew_op = rew_op;
+	SPARX5_SKB_CB(skb)->pdu_type = pdu_type;
+	SPARX5_SKB_CB(skb)->pdu_w16_offset = pdu_w16_offset;
+
+	if (rew_op != IFH_REW_OP_TWO_STEP_PTP)
+		return 0;
+
+	sparx5_ptp_txtstamp_old_release(port);
+
+	spin_lock_irqsave(&sparx5->ptp_ts_id_lock, flags);
+	if (sparx5->ptp_skbs == SPARX5_MAX_PTP_ID) {
+		spin_unlock_irqrestore(&sparx5->ptp_ts_id_lock, flags);
+		return -EBUSY;
+	}
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	skb_queue_tail(&port->tx_skbs, skb);
+	SPARX5_SKB_CB(skb)->ts_id = port->ts_id;
+	SPARX5_SKB_CB(skb)->jiffies = jiffies;
+
+	sparx5->ptp_skbs++;
+	port->ts_id++;
+	if (port->ts_id == SPARX5_MAX_PTP_ID)
+		port->ts_id = 0;
+
+	spin_unlock_irqrestore(&sparx5->ptp_ts_id_lock, flags);
+
+	return 0;
+}
+
+void sparx5_ptp_txtstamp_release(struct sparx5_port *port,
+				 struct sk_buff *skb)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sparx5->ptp_ts_id_lock, flags);
+	port->ts_id--;
+	sparx5->ptp_skbs--;
+	skb_unlink(skb, &port->tx_skbs);
+	spin_unlock_irqrestore(&sparx5->ptp_ts_id_lock, flags);
+}
+
 static int sparx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
@@ -352,6 +476,7 @@ static int sparx5_ptp_phc_init(struct sparx5 *sparx5,
 int sparx5_ptp_init(struct sparx5 *sparx5)
 {
 	u64 tod_adj = sparx5_ptp_get_nominal_value(sparx5);
+	struct sparx5_port *port;
 	int err, i;
 
 	if (!sparx5->ptp)
@@ -364,6 +489,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	}
 
 	spin_lock_init(&sparx5->ptp_clock_lock);
+	spin_lock_init(&sparx5->ptp_ts_id_lock);
 	mutex_init(&sparx5->ptp_lock);
 
 	/* Disable master counters */
@@ -388,13 +514,53 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	/* Enable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
 
+	for (i = 0; i < sparx5->port_count; i++) {
+		port = sparx5->ports[i];
+		if (!port)
+			continue;
+
+		skb_queue_head_init(&port->tx_skbs);
+	}
+
 	return 0;
 }
 
 void sparx5_ptp_deinit(struct sparx5 *sparx5)
 {
+	struct sparx5_port *port;
 	int i;
 
+	for (i = 0; i < sparx5->port_count; i++) {
+		port = sparx5->ports[i];
+		if (!port)
+			continue;
+
+		skb_queue_purge(&port->tx_skbs);
+	}
+
 	for (i = 0; i < SPARX5_PHC_COUNT; ++i)
 		ptp_clock_unregister(sparx5->phc[i].clock);
 }
+
+void sparx5_ptp_rxtstamp(struct sparx5 *sparx5, struct sk_buff *skb,
+			 u64 timestamp)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct sparx5_phc *phc;
+	struct timespec64 ts;
+	u64 full_ts_in_ns;
+
+	if (!sparx5->ptp)
+		return;
+
+	phc = &sparx5->phc[SPARX5_PHC_PORT];
+	sparx5_ptp_gettime64(&phc->info, &ts);
+
+	if (ts.tv_nsec < timestamp)
+		ts.tv_sec--;
+	ts.tv_nsec = timestamp;
+	full_ts_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+
+	shhwtstamps = skb_hwtstamps(skb);
+	shhwtstamps->hwtstamp = full_ts_in_ns;
+}
-- 
2.33.0

