Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C99849DF30
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiA0KV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:21:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:56253 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239228AbiA0KVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278913; x=1674814913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvQMK7KzzOo7R5MfJomzpX7ofoNTRVp/LbAfKW22fgQ=;
  b=nhV+ZLY4eyqijXPCvPk7azxl4T5gOPyAccdsE+yUbr32zdm8DdI937Si
   jcPC7ooUZ4GOp2biqqWTzVI1NQcRPleP+GOivRSxcncG9ZpPN56ekO7Gt
   igs5H0LvsuqqcAo7E0y9FLFGLbk9XWkNwfeOeDnRtEOET1NM9tsKzRyTa
   6nCyMC8kEbAIHUDm8ScCOMYC597C/4dohB2MTwtWTrzlLrInjcsCOyiI+
   1Rz1d3U/sa3Wx893u+ipuoxgvq6XOrvj2C7f0gAO6iQrx+5cOqpCFI9id
   RJPUuItfxiDskLaSVIE9BxrjmRkdMgHNVRsJ+G5lfdjN7jMPBwZncvAVj
   A==;
IronPort-SDR: SPyX7QkgeZFkXsl9uQhB5K+npbglepxn67uq3qMunxbRvUflDGODW+RJhllqIbkfTk5YzxkmC7
 IgqDXZfLCqis9nCkwUu79X434XHLX4SPTdLsH/ZFonJqxmq9hDxOPimrndFIdyvMkNGqENKo8j
 FeLrSP0h2hNDjH+YnZYFCxT6DMj4tNTwk/f6WkyaXeaekC4VsbYzYM17diUYThDFRpsgOu+FGH
 kGVgRvaashyEy3ivAGNIcXAzvB+aWLAWLcXN40R8emyiT4AMyMl6htJrFS6OArk5gl7Ro7K/B5
 EmYh9N9kBBMu2c7TtU4m7TKP
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="146782907"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:52 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/7] net: lan966x: Update extraction/injection for timestamping
Date:   Thu, 27 Jan 2022 11:23:31 +0100
Message-ID: <20220127102333.987195-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update both the extraction and injection to do timestamping of the
frames. The extraction is always doing the timestamping while for
injection is doing the timestamping only if it is configured.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  51 ++++++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  20 +++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 141 ++++++++++++++++++
 3 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index c62615b9d101..3c19763118ea 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -202,7 +202,7 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 	val = lan_rd(lan966x, QS_INJ_STATUS);
 	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp)) ||
 	    (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)))
-		return NETDEV_TX_BUSY;
+		goto err;
 
 	/* Write start of frame */
 	lan_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
@@ -214,7 +214,7 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 		/* Wait until the fifo is ready */
 		err = lan966x_port_inj_ready(lan966x, grp);
 		if (err)
-			return NETDEV_TX_BUSY;
+			goto err;
 
 		lan_wr((__force u32)ifh[i], lan966x, QS_INJ_WR(grp));
 	}
@@ -226,7 +226,7 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 		/* Wait until the fifo is ready */
 		err = lan966x_port_inj_ready(lan966x, grp);
 		if (err)
-			return NETDEV_TX_BUSY;
+			goto err;
 
 		lan_wr(((u32 *)skb->data)[i], lan966x, QS_INJ_WR(grp));
 	}
@@ -236,7 +236,7 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 		/* Wait until the fifo is ready */
 		err = lan966x_port_inj_ready(lan966x, grp);
 		if (err)
-			return NETDEV_TX_BUSY;
+			goto err;
 
 		lan_wr(0, lan966x, QS_INJ_WR(grp));
 		++i;
@@ -256,8 +256,19 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		return NETDEV_TX_OK;
+
 	dev_consume_skb_any(skb);
 	return NETDEV_TX_OK;
+
+err:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    LAN966X_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		lan966x_ptp_txtstamp_release(port, skb);
+
+	return NETDEV_TX_BUSY;
 }
 
 static void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
@@ -290,10 +301,23 @@ static void lan966x_ifh_set_vid(void *ifh, u64 vid)
 		IFH_POS_TCI, IFH_LEN * 4, PACK, 0);
 }
 
+static void lan966x_ifh_set_rew_op(void *ifh, u64 rew_op)
+{
+	packing(ifh, &rew_op, IFH_POS_REW_CMD + IFH_WID_REW_CMD - 1,
+		IFH_POS_REW_CMD, IFH_LEN * 4, PACK, 0);
+}
+
+static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
+{
+	packing(ifh, &timestamp, IFH_POS_TIMESTAMP + IFH_WID_TIMESTAMP - 1,
+		IFH_POS_TIMESTAMP, IFH_LEN * 4, PACK, 0);
+}
+
 static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	__be32 ifh[IFH_LEN];
+	int err;
 
 	memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
 
@@ -303,6 +327,15 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	lan966x_ifh_set_ipv(ifh, skb->priority >= 7 ? 0x7 : skb->priority);
 	lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
 
+	if (port->lan966x->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		err = lan966x_ptp_txtstamp_request(port, skb);
+		if (err)
+			return err;
+
+		lan966x_ifh_set_rew_op(ifh, LAN966X_SKB_CB(skb)->rew_op);
+		lan966x_ifh_set_timestamp(ifh, LAN966X_SKB_CB(skb)->ts_id);
+	}
+
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
 
@@ -453,6 +486,12 @@ static void lan966x_ifh_get_len(void *ifh, u64 *len)
 		IFH_POS_LEN, IFH_LEN * 4, UNPACK, 0);
 }
 
+static void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp)
+{
+	packing(ifh, timestamp, IFH_POS_TIMESTAMP + IFH_WID_TIMESTAMP - 1,
+		IFH_POS_TIMESTAMP, IFH_LEN * 4, UNPACK, 0);
+}
+
 static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 {
 	struct lan966x *lan966x = args;
@@ -462,10 +501,10 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 		return IRQ_NONE;
 
 	do {
+		u64 src_port, len, timestamp;
 		struct net_device *dev;
 		struct sk_buff *skb;
 		int sz = 0, buf_len;
-		u64 src_port, len;
 		u32 ifh[IFH_LEN];
 		u32 *buf;
 		u32 val;
@@ -480,6 +519,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 
 		lan966x_ifh_get_src_port(ifh, &src_port);
 		lan966x_ifh_get_len(ifh, &len);
+		lan966x_ifh_get_timestamp(ifh, &timestamp);
 
 		WARN_ON(src_port >= lan966x->num_phys_ports);
 
@@ -520,6 +560,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
 			*buf = val;
 		}
 
+		lan966x_ptp_rxtstamp(lan966x, skb, timestamp);
 		skb->protocol = eth_type_trans(skb, dev);
 
 		if (lan966x->bridge_mask & BIT(src_port))
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 55fa5e56b8d1..03c6a4f34ae2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -86,6 +86,16 @@ struct lan966x_phc {
 	u8 index;
 };
 
+struct lan966x_skb_cb {
+	u8 rew_op;
+	u16 ts_id;
+	unsigned long jiffies;
+};
+
+#define LAN966X_PTP_TIMEOUT		msecs_to_jiffies(10)
+#define LAN966X_SKB_CB(skb) \
+	((struct lan966x_skb_cb *)((skb)->cb))
+
 struct lan966x {
 	struct device *dev;
 
@@ -134,7 +144,9 @@ struct lan966x {
 	bool ptp;
 	struct lan966x_phc phc[LAN966X_PHC_COUNT];
 	spinlock_t ptp_clock_lock; /* lock for phc */
+	spinlock_t ptp_ts_id_lock; /* lock for ts_id */
 	struct mutex ptp_lock; /* lock for ptp interface state */
+	u16 ptp_skbs;
 };
 
 struct lan966x_port_config {
@@ -166,6 +178,8 @@ struct lan966x_port {
 	struct fwnode_handle *fwnode;
 
 	u8 ptp_cmd;
+	u16 ts_id;
+	struct sk_buff_head tx_skbs;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -256,6 +270,12 @@ int lan966x_ptp_init(struct lan966x *lan966x);
 void lan966x_ptp_deinit(struct lan966x *lan966x);
 int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr);
 int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr);
+void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
+			  u64 timestamp);
+int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
+				 struct sk_buff *skb);
+void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
+				  struct sk_buff *skb);
 
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 9ff4d3fca5a1..ba65604aef48 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -119,6 +119,103 @@ int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
 			    sizeof(phc->hwtstamp_config)) ? -EFAULT : 0;
 }
 
+static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
+{
+	struct ptp_header *header;
+	u8 msgtype;
+	int type;
+
+	if (port->ptp_cmd == IFH_REW_OP_NOOP)
+		return IFH_REW_OP_NOOP;
+
+	type = ptp_classify_raw(skb);
+	if (type == PTP_CLASS_NONE)
+		return IFH_REW_OP_NOOP;
+
+	header = ptp_parse_header(skb, type);
+	if (!header)
+		return IFH_REW_OP_NOOP;
+
+	if (port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+		return IFH_REW_OP_TWO_STEP_PTP;
+
+	/* If it is sync and run 1 step then set the correct operation,
+	 * otherwise run as 2 step
+	 */
+	msgtype = ptp_get_msgtype(header, type);
+	if ((msgtype & 0xf) == 0)
+		return IFH_REW_OP_ONE_STEP_PTP;
+
+	return IFH_REW_OP_TWO_STEP_PTP;
+}
+
+static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
+{
+	struct sk_buff *skb, *skb_tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->tx_skbs.lock, flags);
+	skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
+		if time_after(LAN966X_SKB_CB(skb)->jiffies + LAN966X_PTP_TIMEOUT,
+			      jiffies)
+			break;
+
+		__skb_unlink(skb, &port->tx_skbs);
+		dev_kfree_skb_any(skb);
+	}
+	spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+}
+
+int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
+				 struct sk_buff *skb)
+{
+	struct lan966x *lan966x = port->lan966x;
+	unsigned long flags;
+	u8 rew_op;
+
+	rew_op = lan966x_ptp_classify(port, skb);
+	LAN966X_SKB_CB(skb)->rew_op = rew_op;
+
+	if (rew_op != IFH_REW_OP_TWO_STEP_PTP)
+		return 0;
+
+	lan966x_ptp_txtstamp_old_release(port);
+
+	spin_lock_irqsave(&lan966x->ptp_ts_id_lock, flags);
+	if (lan966x->ptp_skbs == LAN966X_MAX_PTP_ID) {
+		spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
+		return -EBUSY;
+	}
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	skb_queue_tail(&port->tx_skbs, skb);
+	LAN966X_SKB_CB(skb)->ts_id = port->ts_id;
+	LAN966X_SKB_CB(skb)->jiffies = jiffies;
+
+	lan966x->ptp_skbs++;
+	port->ts_id++;
+	if (port->ts_id == LAN966X_MAX_PTP_ID)
+		port->ts_id = 0;
+
+	spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
+
+	return 0;
+}
+
+void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
+				  struct sk_buff *skb)
+{
+	struct lan966x *lan966x = port->lan966x;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lan966x->ptp_ts_id_lock, flags);
+	port->ts_id--;
+	lan966x->ptp_skbs--;
+	skb_unlink(skb, &port->tx_skbs);
+	spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
+}
+
 static int lan966x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
@@ -324,6 +421,7 @@ static int lan966x_ptp_phc_init(struct lan966x *lan966x,
 int lan966x_ptp_init(struct lan966x *lan966x)
 {
 	u64 tod_adj = lan966x_ptp_get_nominal_value();
+	struct lan966x_port *port;
 	int err, i;
 
 	if (!lan966x->ptp)
@@ -336,6 +434,7 @@ int lan966x_ptp_init(struct lan966x *lan966x)
 	}
 
 	spin_lock_init(&lan966x->ptp_clock_lock);
+	spin_lock_init(&lan966x->ptp_ts_id_lock);
 	mutex_init(&lan966x->ptp_lock);
 
 	/* Disable master counters */
@@ -360,13 +459,55 @@ int lan966x_ptp_init(struct lan966x *lan966x)
 	/* Enable master counters */
 	lan_wr(PTP_DOM_CFG_ENA_SET(0x7), lan966x, PTP_DOM_CFG);
 
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		port = lan966x->ports[i];
+		if (!port)
+			continue;
+
+		skb_queue_head_init(&port->tx_skbs);
+	}
+
 	return 0;
 }
 
 void lan966x_ptp_deinit(struct lan966x *lan966x)
 {
+	struct lan966x_port *port;
 	int i;
 
+	for (i = 0; i < lan966x->num_phys_ports; i++) {
+		port = lan966x->ports[i];
+		if (!port)
+			continue;
+
+		skb_queue_purge(&port->tx_skbs);
+	}
+
 	for (i = 0; i < LAN966X_PHC_COUNT; ++i)
 		ptp_clock_unregister(lan966x->phc[i].clock);
 }
+
+void lan966x_ptp_rxtstamp(struct lan966x *lan966x, struct sk_buff *skb,
+			  u64 timestamp)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct lan966x_phc *phc;
+	struct timespec64 ts;
+	u64 full_ts_in_ns;
+
+	if (!lan966x->ptp)
+		return;
+
+	phc = &lan966x->phc[LAN966X_PHC_PORT];
+	lan966x_ptp_gettime64(&phc->info, &ts);
+
+	/* Drop the sub-ns precision */
+	timestamp = timestamp >> 2;
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

