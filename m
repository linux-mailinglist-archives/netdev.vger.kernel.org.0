Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BA4301BA2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbhAXL4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:56:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14536 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbhAXLsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:48:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBjVYC027004;
        Sun, 24 Jan 2021 03:45:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hNV+K6KdB/uaGigEcvTFxKYIKxUdl6phKRzpf5t5THk=;
 b=PTxqvT9bBt0UPvFqhCuZrovAeMVxHoRBwgZfA7VZ3w+pVwuNENCFPGl0tbJ0g3LfkA+0
 hfEDRhqomaE8JGJLNN7zRSWWGzoC2IwpNm2C6Gfd2dDP7WMD/Jqw2KgQFnDRc7GCnolZ
 Oti3b8oXKsBEWQ0ncQVB+dLv6r5ds6OyCtWgip9/dDnOp9sT3a7a7RdvFehKpiFmugiD
 ff6HN1CboUv28hze8Yo18sOPJ4z/okKQOLmYbltq+xfYMLJwKLCJSv5RpqfzsIdA2vzo
 VYTsELlgzJsHI7D2nd/kEQ6JFh34jA+iaoR0gqzH35K0fnhssnAvCHKA+4B6uetbI5Yq Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9sue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:45:30 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:45:28 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 1F7E23F7040;
        Sun, 24 Jan 2021 03:45:24 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 13/18] net: mvpp2: add ethtool flow control configuration support
Date:   Sun, 24 Jan 2021 13:44:02 +0200
Message-ID: <1611488647-12478-14-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  13 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 106 ++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ba57465..feac64c 100644
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
index 2407c52..20157b5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -848,6 +848,59 @@ static void mvpp2_rxq_disable_fc(struct mvpp2_port *port)
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
@@ -1178,6 +1231,16 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
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
@@ -1195,6 +1258,25 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
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
@@ -6357,6 +6439,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
+	int i;
 
 	if (mvpp2_is_xlg(interface)) {
 		if (!phylink_autoneg_inband(mode)) {
@@ -6407,6 +6490,29 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			     val);
 	}
 
+	if (tx_pause && port->priv->global_tx_fc) {
+		port->tx_fc = true;
+		mvpp2_rxq_enable_fc(port);
+		if (port->priv->percpu_pools) {
+			for (i = 0; i < port->nrxqs; i++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], true);
+		} else {
+			mvpp2_bm_pool_update_fc(port, port->pool_long, true);
+			mvpp2_bm_pool_update_fc(port, port->pool_short, true);
+		}
+
+	} else if (port->priv->global_tx_fc) {
+		port->tx_fc = false;
+		mvpp2_rxq_disable_fc(port);
+		if (port->priv->percpu_pools) {
+			for (i = 0; i < port->nrxqs; i++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], false);
+		} else {
+			mvpp2_bm_pool_update_fc(port, port->pool_long, false);
+			mvpp2_bm_pool_update_fc(port, port->pool_short, false);
+		}
+	}
+
 	mvpp2_port_enable(port);
 
 	mvpp2_egress_enable(port);
-- 
1.9.1

