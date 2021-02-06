Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF09311ED3
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBFQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:50:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230463AbhBFQsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:48:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GlJF5026166;
        Sat, 6 Feb 2021 08:47:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Z/zUncY028ZMbqVWZPPn8XjfHgebj1nbRWeQGsz2pGs=;
 b=hYS+sXQByz7uKO3HxSPYbN+Uo2m1SAoj90eLRmLakj8CoOFuKoFwr8LZ7Z1GyACf6wjV
 ssrG3Xs/Pz3Q8WNJVQGXSYRtiElVjU4R4w4UcLtTDLkxJFfHyqKyZL2zwTmA/KgTUVuV
 x7/j19i4mRpyzHqUqTZLJDJzwD4TQXPJE1UqTl8UsQ89X6TIJ5N+87ZUw1gmF0KRAq0N
 UMh9c3+b8tP0611NzyRN2vKqanOqDPXcD+cq6PnhM6Qxy8jbAxXj2QC+SBighQAG3SwI
 moSYdgeY5DDtqguKKiBqAhlhLxVpubAZxDZY/4LQ3P1QAeChheLCi7JqOYOuiVABOZ9/ tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq09xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:47:52 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:47:50 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:47:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:47:49 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id B96BC3F703F;
        Sat,  6 Feb 2021 08:47:46 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 11/15] net: mvpp2: add ethtool flow control configuration support
Date:   Sat, 6 Feb 2021 18:45:57 +0200
Message-ID: <1612629961-11583-12-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch add ethtool flow control configuration support.

Tx flow control retrieved correctly by ethtool get function.
FW per port ethtool configuration capability added.

Patch also takes care about mtu change procedure, if PPv2 switch
BM pools during mtu change.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 13 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 98 ++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 0f27be0..9071ab6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -775,6 +775,19 @@
 #define MSS_RXQ_TRESH_REG(q, fq)	(MSS_RXQ_TRESH_BASE + (((q) + (fq)) \
 					* MSS_RXQ_TRESH_OFFS))
 
+#define MSS_BUF_POOL_BASE		0x40
+#define MSS_BUF_POOL_OFFS		4
+#define MSS_BUF_POOL_REG(id)		(MSS_BUF_POOL_BASE		\
+					+ (id) * MSS_BUF_POOL_OFFS)
+
+#define MSS_BUF_POOL_STOP_MASK		0xFFF
+#define MSS_BUF_POOL_START_MASK		(0xFFF << MSS_BUF_POOL_START_OFFS)
+#define MSS_BUF_POOL_START_OFFS		12
+#define MSS_BUF_POOL_PORTS_MASK		(0xF << MSS_BUF_POOL_PORTS_OFFS)
+#define MSS_BUF_POOL_PORTS_OFFS		24
+#define MSS_BUF_POOL_PORT_OFFS(id)	(0x1 <<				\
+					((id) + MSS_BUF_POOL_PORTS_OFFS))
+
 #define MSS_RXQ_TRESH_START_MASK	0xFFFF
 #define MSS_RXQ_TRESH_STOP_MASK		(0xFFFF << MSS_RXQ_TRESH_STOP_OFFS)
 #define MSS_RXQ_TRESH_STOP_OFFS		16
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 29ba62a..5d80c5e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -846,6 +846,59 @@ static void mvpp2_rxq_disable_fc(struct mvpp2_port *port)
 	spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
 }
 
+/* Routine disable/enable flow control for BM pool condition */
+static void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
+				    struct mvpp2_bm_pool *pool,
+				    bool en)
+{
+	int val, cm3_state;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->priv->mss_spinlock, flags);
+
+	/* Remove Flow control enable bit to prevent race between FW and Kernel
+	 * If Flow control were enabled, it would be re-enabled.
+	 */
+	val = mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
+	cm3_state = (val & FLOW_CONTROL_ENABLE_BIT);
+	val &= ~FLOW_CONTROL_ENABLE_BIT;
+	mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
+
+	/* Check if BM pool should be enabled/disable */
+	if (en) {
+		/* Set BM pool start and stop thresholds per port */
+		val = mvpp2_cm3_read(port->priv, MSS_BUF_POOL_REG(pool->id));
+		val |= MSS_BUF_POOL_PORT_OFFS(port->id);
+		val &= ~MSS_BUF_POOL_START_MASK;
+		val |= (MSS_THRESHOLD_START << MSS_BUF_POOL_START_OFFS);
+		val &= ~MSS_BUF_POOL_STOP_MASK;
+		val |= MSS_THRESHOLD_STOP;
+		mvpp2_cm3_write(port->priv, MSS_BUF_POOL_REG(pool->id), val);
+	} else {
+		/* Remove BM pool from the port */
+		val = mvpp2_cm3_read(port->priv, MSS_BUF_POOL_REG(pool->id));
+		val &= ~MSS_BUF_POOL_PORT_OFFS(port->id);
+
+		/* Zero BM pool start and stop thresholds to disable pool
+		 * flow control if pool empty (not used by any port)
+		 */
+		if (!pool->buf_num) {
+			val &= ~MSS_BUF_POOL_START_MASK;
+			val &= ~MSS_BUF_POOL_STOP_MASK;
+		}
+
+		mvpp2_cm3_write(port->priv, MSS_BUF_POOL_REG(pool->id), val);
+	}
+
+	/* Notify Firmware that Flow control config space ready for update */
+	val = mvpp2_cm3_read(port->priv, MSS_FC_COM_REG);
+	val |= FLOW_CONTROL_UPDATE_COMMAND_BIT;
+	val |= cm3_state;
+	mvpp2_cm3_write(port->priv, MSS_FC_COM_REG, val);
+
+	spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
+}
+
 /* Release buffer to BM */
 static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
 				     dma_addr_t buf_dma_addr,
@@ -1176,6 +1229,16 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		new_long_pool = MVPP2_BM_LONG;
 
 	if (new_long_pool != port->pool_long->id) {
+		if (port->tx_fc) {
+			if (pkt_size > MVPP2_BM_LONG_PKT_SIZE)
+				mvpp2_bm_pool_update_fc(port,
+							port->pool_short,
+							false);
+			else
+				mvpp2_bm_pool_update_fc(port, port->pool_long,
+							false);
+		}
+
 		/* Remove port from old short & long pool */
 		port->pool_long = mvpp2_bm_pool_use(port, port->pool_long->id,
 						    port->pool_long->pkt_size);
@@ -1193,6 +1256,25 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		mvpp2_swf_bm_pool_init(port);
 
 		mvpp2_set_hw_csum(port, new_long_pool);
+
+		if (port->tx_fc) {
+			if (pkt_size > MVPP2_BM_LONG_PKT_SIZE)
+				mvpp2_bm_pool_update_fc(port, port->pool_long,
+							true);
+			else
+				mvpp2_bm_pool_update_fc(port, port->pool_short,
+							true);
+		}
+
+		/* Update L4 checksum when jumbo enable/disable on port */
+		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
+			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
+			dev->hw_features &= ~(NETIF_F_IP_CSUM |
+					      NETIF_F_IPV6_CSUM);
+		} else {
+			dev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+			dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		}
 	}
 
 out_set:
@@ -6358,6 +6440,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
+	int i;
 
 	if (mvpp2_is_xlg(interface)) {
 		if (!phylink_autoneg_inband(mode)) {
@@ -6408,6 +6491,21 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			     val);
 	}
 
+	if (port->priv->global_tx_fc) {
+		port->tx_fc = tx_pause;
+		if (tx_pause)
+			mvpp2_rxq_enable_fc(port);
+		else
+			mvpp2_rxq_disable_fc(port);
+		if (port->priv->percpu_pools) {
+			for (i = 0; i < port->nrxqs; i++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], tx_pause);
+		} else {
+			mvpp2_bm_pool_update_fc(port, port->pool_long, tx_pause);
+			mvpp2_bm_pool_update_fc(port, port->pool_short, tx_pause);
+		}
+	}
+
 	mvpp2_port_enable(port);
 
 	mvpp2_egress_enable(port);
-- 
1.9.1

