Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275F82F0810
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbhAJPe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbhAJPe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFPKpE022742;
        Sun, 10 Jan 2021 07:31:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=O6gUucpqQdO3vhuOAnJQg26P9zy2tPaVPSxW/GTYZCQ=;
 b=SFexWpgf7cTNSLxqoYPaB2Usr2FSLM2jmu/iMUBk1Hi2B1coQURCrNt+H5v/GZtI8Mim
 jwNIPvX3UADklk4qhvAejzR+WmO22sjJG59jE0Z/nM1DaDpMXn7rMo8ncaKaKo3N4/0v
 2lk/UuDeS57XonPpW8cG4R1QyeOmtBx+qYRNP0no2D2n9q8CiBQrG3ItN4lBvSc04ljw
 e1BXg81Sv6QvVGe2ODpvwm6UkL8BzXMRaZe5nrXVKlb7Pari8vFr4WOQSTbdJ/As5kCX
 zXYYE8SKRC9Xv0nbNfgOBwqba6jjzOhooGSljzm0UGaQUfxWZzuFmqJpQdK5XSL5EH/y cA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphvdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:35 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 682213F7040;
        Sun, 10 Jan 2021 07:31:32 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  11/19] net: mvpp2: add flow control RXQ and BM pool config callbacks
Date:   Sun, 10 Jan 2021 17:30:15 +0200
Message-ID: <1610292623-15564-12-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch did not change any functionality.
Added flow control RXQ and BM pool config callbacks that would be
used to configure RXQ and BM pool thresholds.
APIs also will disable/enable RXQ and pool Flow Control polling.

In this stage BM pool and RXQ has same stop/start thresholds
defined in code.
Also there are common thresholds for all RXQs.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  51 +++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 169 ++++++++++++++++++++
 2 files changed, 216 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4d58af6..0ba0598 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -763,10 +763,53 @@
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
 /* MSS Flow control */
-#define MSS_SRAM_SIZE		0x800
-#define FC_QUANTA		0xFFFF
-#define FC_CLK_DIVIDER		0x140
-#define MSS_THRESHOLD_STOP    768
+#define MSS_SRAM_SIZE			0x800
+#define MSS_FC_COM_REG			0
+#define FLOW_CONTROL_ENABLE_BIT		BIT(0)
+#define FLOW_CONTROL_UPDATE_COMMAND_BIT	BIT(31)
+#define FC_QUANTA			0xFFFF
+#define FC_CLK_DIVIDER			0x140
+
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
+#define MSS_RXQ_TRESH_BASE		0x200
+#define MSS_RXQ_TRESH_OFFS		4
+#define MSS_RXQ_TRESH_REG(q, fq)	(MSS_RXQ_TRESH_BASE + (((q) + (fq)) \
+					* MSS_RXQ_TRESH_OFFS))
+
+#define MSS_RXQ_TRESH_START_MASK	0xFFFF
+#define MSS_RXQ_TRESH_STOP_MASK		(0xFFFF << MSS_RXQ_TRESH_STOP_OFFS)
+#define MSS_RXQ_TRESH_STOP_OFFS		16
+
+#define MSS_RXQ_ASS_BASE	0x80
+#define MSS_RXQ_ASS_OFFS	4
+#define MSS_RXQ_ASS_PER_REG	4
+#define MSS_RXQ_ASS_PER_OFFS	8
+#define MSS_RXQ_ASS_PORTID_OFFS	0
+#define MSS_RXQ_ASS_PORTID_MASK	0x3
+#define MSS_RXQ_ASS_HOSTID_OFFS	2
+#define MSS_RXQ_ASS_HOSTID_MASK	0x3F
+
+#define MSS_RXQ_ASS_Q_BASE(q, fq) ((((q) + (fq)) % MSS_RXQ_ASS_PER_REG)	 \
+				  * MSS_RXQ_ASS_PER_OFFS)
+#define MSS_RXQ_ASS_PQ_BASE(q, fq) ((((q) + (fq)) / MSS_RXQ_ASS_PER_REG) \
+				   * MSS_RXQ_ASS_OFFS)
+#define MSS_RXQ_ASS_REG(q, fq) (MSS_RXQ_ASS_BASE + MSS_RXQ_ASS_PQ_BASE(q, fq))
+
+#define MSS_THRESHOLD_STOP	768
+#define MSS_THRESHOLD_START	1024
+
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index bc4b8069..19648c4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -744,6 +744,175 @@ static void *mvpp2_buf_alloc(struct mvpp2_port *port,
 	return data;
 }
 
+/* Routine calculate single queue shares address space */
+static int mvpp22_calc_shared_addr_space(struct mvpp2_port *port)
+{
+	/* If number of CPU's greater than number of threads, return last
+	 * address space
+	 */
+	if (num_active_cpus() >= MVPP2_MAX_THREADS)
+		return MVPP2_MAX_THREADS - 1;
+
+	return num_active_cpus();
+}
+
+/* Routine enable flow control for RXQs conditon */
+void mvpp2_rxq_enable_fc(struct mvpp2_port *port)
+{
+	int val, cm3_state, host_id, q;
+	int fq = port->first_rxq;
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
+	/* Set same Flow control for all RXQs */
+	for (q = 0; q < port->nrxqs; q++) {
+		/* Set stop and start Flow control RXQ thresholds */
+		val = MSS_THRESHOLD_START;
+		val |= (MSS_THRESHOLD_STOP << MSS_RXQ_TRESH_STOP_OFFS);
+		mvpp2_cm3_write(port->priv, MSS_RXQ_TRESH_REG(q, fq), val);
+
+		val = mvpp2_cm3_read(port->priv, MSS_RXQ_ASS_REG(q, fq));
+		/* Set RXQ port ID */
+		val &= ~(MSS_RXQ_ASS_PORTID_MASK << MSS_RXQ_ASS_Q_BASE(q, fq));
+		val |= (port->id << MSS_RXQ_ASS_Q_BASE(q, fq));
+		val &= ~(MSS_RXQ_ASS_HOSTID_MASK << (MSS_RXQ_ASS_Q_BASE(q, fq)
+			+ MSS_RXQ_ASS_HOSTID_OFFS));
+
+		/* Calculate RXQ host ID:
+		 * In Single queue mode: Host ID equal to Host ID used for
+		 *			 shared RX interrupt
+		 * In Multi queue mode: Host ID equal to number of
+		 *			RXQ ID / number of CoS queues
+		 * In Single resource mode: Host ID always equal to 0
+		 */
+		if (queue_mode == MVPP2_QDIST_SINGLE_MODE)
+			host_id = mvpp22_calc_shared_addr_space(port);
+		else if (queue_mode == MVPP2_QDIST_MULTI_MODE)
+			host_id = q;
+		else
+			host_id = 0;
+
+		/* Set RXQ host ID */
+		val |= (host_id << (MSS_RXQ_ASS_Q_BASE(q, fq)
+			+ MSS_RXQ_ASS_HOSTID_OFFS));
+
+		mvpp2_cm3_write(port->priv, MSS_RXQ_ASS_REG(q, fq), val);
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
+/* Routine disable flow control for RXQs conditon */
+void mvpp2_rxq_disable_fc(struct mvpp2_port *port)
+{
+	int val, cm3_state, q;
+	unsigned long flags;
+	int fq = port->first_rxq;
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
+	/* Disable Flow control for all RXQs */
+	for (q = 0; q < port->nrxqs; q++) {
+		/* Set threshold 0 to disable Flow control */
+		val = 0;
+		val |= (0 << MSS_RXQ_TRESH_STOP_OFFS);
+		mvpp2_cm3_write(port->priv, MSS_RXQ_TRESH_REG(q, fq), val);
+
+		val = mvpp2_cm3_read(port->priv, MSS_RXQ_ASS_REG(q, fq));
+
+		val &= ~(MSS_RXQ_ASS_PORTID_MASK << MSS_RXQ_ASS_Q_BASE(q, fq));
+
+		val &= ~(MSS_RXQ_ASS_HOSTID_MASK << (MSS_RXQ_ASS_Q_BASE(q, fq)
+			+ MSS_RXQ_ASS_HOSTID_OFFS));
+
+		mvpp2_cm3_write(port->priv, MSS_RXQ_ASS_REG(q, fq), val);
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
+/* Routine disable/enable flow control for BM pool conditon */
+void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
+			     struct mvpp2_bm_pool *pool,
+			     bool en)
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
-- 
1.9.1

