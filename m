Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FB30B978
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhBBITS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:19:18 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56852 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232511AbhBBITG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:19:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1128AYtl016723;
        Tue, 2 Feb 2021 00:18:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yiLgoJVz1rIiIxYuBmuvwWvpY/XQr24wCzJ3+kq83j0=;
 b=cpPo5a6RH/ZEp/F9XPRzZdV3ln+dsy5MBbjCWKiNubgQm3Sm7wHcbDfVBG6u/W828kvY
 uVqhsxS6zR6bppcaYY5ZZQEPiFzHo8VOzdYIRm2Z998/ix8DlnQXaZIbADYYK96CAaRj
 mftpnJhUy45AHf3gjoDnStBa3iBkCevj2yeiaH1Pw9vXG6RHjZeTIHQ1an6h94M+LMfd
 0Lq5xrCCDhuLMAhiwPgS978MAQZVg+9wIAqoMKCp08PZk0G68VTTn7LZoCC58oDfgRH3
 0GdZO25XtxQ1J4KI1Yp6ZwaILXzDu3eHyfNUhPMypNHrV9eaH9Gf8fpBWMMiONPJMnec 4Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psxp2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 00:18:16 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 00:18:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 00:18:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 00:18:15 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id DDC343F703F;
        Tue,  2 Feb 2021 00:18:11 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 10/15] net: mvpp2: add RXQ flow control configurations
Date:   Tue, 2 Feb 2021 10:16:56 +0200
Message-ID: <1612253821-1148-11-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_04:2021-01-29,2021-02-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds RXQ flow control configurations.
Flow control disabled by default.
Minimum ring size limited to 1024 descriptors.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  35 +++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 116 ++++++++++++++++++++
 2 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index e010410..0f27be0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -766,9 +766,36 @@
 #define MSS_SRAM_SIZE			0x800
 #define MSS_FC_COM_REG			0
 #define FLOW_CONTROL_ENABLE_BIT		BIT(0)
+#define FLOW_CONTROL_UPDATE_COMMAND_BIT	BIT(31)
 #define FC_QUANTA			0xFFFF
 #define FC_CLK_DIVIDER			100
-#define MSS_THRESHOLD_STOP		768
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
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
@@ -1026,6 +1053,9 @@ struct mvpp2 {
 
 	/* Global TX Flow Control config */
 	bool global_tx_fc;
+
+	/* Spinlocks for CM3 shared memory configuration */
+	spinlock_t mss_spinlock;
 };
 
 struct mvpp2_pcpu_stats {
@@ -1188,6 +1218,9 @@ struct mvpp2_port {
 	bool rx_hwtstamp;
 	enum hwtstamp_tx_types tx_hwtstamp_type;
 	struct mvpp2_hwtstamp_queue tx_hwtstamp_queue[2];
+
+	/* Firmware TX flow control */
+	bool tx_fc;
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 770f45a..d778ae1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -742,6 +742,110 @@ static void *mvpp2_buf_alloc(struct mvpp2_port *port,
 	return data;
 }
 
+/* Routine enable flow control for RXQs condition */
+static void mvpp2_rxq_enable_fc(struct mvpp2_port *port)
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
+			host_id = port->nqvecs;
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
+/* Routine disable flow control for RXQs condition */
+static void mvpp2_rxq_disable_fc(struct mvpp2_port *port)
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
 /* Release buffer to BM */
 static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
 				     dma_addr_t buf_dma_addr,
@@ -3006,6 +3110,9 @@ static void mvpp2_cleanup_rxqs(struct mvpp2_port *port)
 
 	for (queue = 0; queue < port->nrxqs; queue++)
 		mvpp2_rxq_deinit(port, port->rxqs[queue]);
+
+	if (port->tx_fc)
+		mvpp2_rxq_disable_fc(port);
 }
 
 /* Init all Rx queues for port */
@@ -3018,6 +3125,10 @@ static int mvpp2_setup_rxqs(struct mvpp2_port *port)
 		if (err)
 			goto err_cleanup;
 	}
+
+	if (port->tx_fc)
+		mvpp2_rxq_enable_fc(port);
+
 	return 0;
 
 err_cleanup:
@@ -4317,6 +4428,8 @@ static int mvpp2_check_ringparam_valid(struct net_device *dev,
 
 	if (ring->rx_pending > MVPP2_MAX_RXD_MAX)
 		new_rx_pending = MVPP2_MAX_RXD_MAX;
+	else if (ring->rx_pending < MSS_THRESHOLD_START)
+		new_rx_pending = MSS_THRESHOLD_START;
 	else if (!IS_ALIGNED(ring->rx_pending, 16))
 		new_rx_pending = ALIGN(ring->rx_pending, 16);
 
@@ -7170,6 +7283,9 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->hw_version = MVPP23;
 	}
 
+	/* Init mss lock */
+	spin_lock_init(&priv->mss_spinlock);
+
 	/* Initialize network controller */
 	err = mvpp2_init(pdev, priv);
 	if (err < 0) {
-- 
1.9.1

