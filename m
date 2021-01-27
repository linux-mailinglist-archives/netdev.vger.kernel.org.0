Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7B305B28
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhA0MWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:22:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23694 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237108AbhA0LrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:47:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RBdkPb000664;
        Wed, 27 Jan 2021 03:44:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DUpO0wHw6W9Q7OIz6Ir6AZBxbH3roAo4pdxP7MQK5/E=;
 b=jSgIvZ7Po578BLKIsYmZXJxbZW3WhyxPLJQ/DAaQjmJFqyVG0r/m4e3HvM+K3RT9hdBw
 7BUbM3JYURy53y0QCQLOIQe9dxnw6vERTwkb+PyvvzTtbJMn7iFM6XLMmwA8XRKt+2qU
 5/P7Aho10gxznrg8WPBx8ICHB27kVVrkDvuyBPDgOTYm6Q1ZsXSLfX2aMiNI+x6uR1o1
 Q9B8rBBIuYcUzow0Kl0vRLX8ig2+HZlVaBczbcF/uq2/IAPte5LzC8JAJcPFt49o1j+B
 gNaV1JRBP5wMYLvDOSulRK+eGj65Cs2TIJwqEZAnVUtZQQAUjL8kO9IcR2u+Gkj+QLbR OA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ube88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 03:44:22 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:44:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 Jan 2021 03:44:20 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id B6D803F703F;
        Wed, 27 Jan 2021 03:44:17 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v4 net-next 10/19] net: mvpp2: add FCA RXQ non occupied descriptor threshold
Date:   Wed, 27 Jan 2021 13:43:26 +0200
Message-ID: <1611747815-1934-11-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

RXQ non occupied descriptor threshold would be used by
Flow Control Firmware feature to move to the XOFF mode.
RXQ non occupied threshold would change interrupt cause
that polled by CM3 Firmware.
Actual non occupied interrupt masked and won't trigger interrupt.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 46 +++++++++++++++++---
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 73f087c..9d8993f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -295,6 +295,8 @@
 #define     MVPP2_PON_CAUSE_TXP_OCCUP_DESC_ALL_MASK	0x3fc00000
 #define     MVPP2_PON_CAUSE_MISC_SUM_MASK		BIT(31)
 #define MVPP2_ISR_MISC_CAUSE_REG		0x55b0
+#define MVPP2_ISR_RX_ERR_CAUSE_REG(port)	(0x5520 + 4 * (port))
+#define	    MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK	0x00ff
 
 /* Buffer Manager registers */
 #define MVPP2_BM_POOL_BASE_REG(pool)		(0x6000 + ((pool) * 4))
@@ -764,6 +766,7 @@
 #define MSS_SRAM_SIZE		0x800
 #define FC_QUANTA		0xFFFF
 #define FC_CLK_DIVIDER		100
+#define MSS_THRESHOLD_STOP	768
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8f40293a..a4933c4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1144,14 +1144,19 @@ static inline void mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)
 static void mvpp2_interrupts_mask(void *arg)
 {
 	struct mvpp2_port *port = arg;
+	int cpu = smp_processor_id();
+	u32 thread;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (cpu >= port->priv->nthreads)
 		return;
 
-	mvpp2_thread_write(port->priv,
-			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
+	thread = mvpp2_cpu_to_thread(port->priv, cpu);
+
+	mvpp2_thread_write(port->priv, thread,
 			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
+	mvpp2_thread_write(port->priv, thread,
+			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
 }
 
 /* Unmask the current thread's Rx/Tx interrupts.
@@ -1161,20 +1166,25 @@ static void mvpp2_interrupts_mask(void *arg)
 static void mvpp2_interrupts_unmask(void *arg)
 {
 	struct mvpp2_port *port = arg;
-	u32 val;
+	int cpu = smp_processor_id();
+	u32 val, thread;
 
 	/* If the thread isn't used, don't do anything */
-	if (smp_processor_id() > port->priv->nthreads)
+	if (cpu >= port->priv->nthreads)
 		return;
 
+	thread = mvpp2_cpu_to_thread(port->priv, cpu);
+
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
 		MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(port->priv->hw_version);
 	if (port->has_tx_irqs)
 		val |= MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_MASK;
 
-	mvpp2_thread_write(port->priv,
-			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
+	mvpp2_thread_write(port->priv, thread,
 			   MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
+	mvpp2_thread_write(port->priv, thread,
+			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
+			   MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
 }
 
 static void
@@ -1199,6 +1209,9 @@ static void mvpp2_interrupts_unmask(void *arg)
 
 		mvpp2_thread_write(port->priv, v->sw_thread_id,
 				   MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
+		mvpp2_thread_write(port->priv, v->sw_thread_id,
+				   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
+				   MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
 	}
 }
 
@@ -2404,6 +2417,22 @@ static void mvpp2_txp_max_tx_size_set(struct mvpp2_port *port)
 	}
 }
 
+/* Routine set the number of non-occupied descriptors threshold that change
+ * interrupt error cause polled by FW Flow Control
+ */
+static void mvpp2_set_rxq_free_tresh(struct mvpp2_port *port,
+				     struct mvpp2_rx_queue *rxq)
+{
+	u32 val;
+
+	mvpp2_write(port->priv, MVPP2_RXQ_NUM_REG, rxq->id);
+
+	val = mvpp2_read(port->priv, MVPP2_RXQ_THRESH_REG);
+	val &= ~MVPP2_RXQ_NON_OCCUPIED_MASK;
+	val |= MSS_THRESHOLD_STOP << MVPP2_RXQ_NON_OCCUPIED_OFFSET;
+	mvpp2_write(port->priv, MVPP2_RXQ_THRESH_REG, val);
+}
+
 /* Set the number of packets that will be received before Rx interrupt
  * will be generated by HW.
  */
@@ -2659,6 +2688,9 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rx_pkts_coal_set(port, rxq);
 	mvpp2_rx_time_coal_set(port, rxq);
 
+	/* Set the number of non occupied descriptors threshold */
+	mvpp2_set_rxq_free_tresh(port, rxq);
+
 	/* Add number of descriptors ready for receiving packets */
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
-- 
1.9.1

