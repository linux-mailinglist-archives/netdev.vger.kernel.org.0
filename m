Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3916D307E4D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhA1Sn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:43:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231939AbhA1Se4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:34:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SI5s2w020045;
        Thu, 28 Jan 2021 10:32:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8IUf7vqinngQfZFrVANEASlSKRG8tSSA9G2MXrBXfsY=;
 b=AhRREkiJ6btFS23tFulle8l9MEc9QNrsjW8Zp8/g3aSXp4zhOnPrpIVAjKsus0QV1yig
 XjxcvHTfrn5IXPkWLdlnWMW4uPqq/d6ac8Qif/9gIdUY1qIyzo9Sb5zwZbMi/TDsIOnc
 xfwBr78MzjzH0BclMo+JoQ6bnn/uJalp2sk/646ZIIaRNBLlarMKUejLicyWJOW7YMJq
 2OgkTP93JAkg/ou3v7EOdcM31f9znYrqin4Ec9Xi2RnEeSBewv6+Bb9j5pkOtVHG9Lq0
 vK/qk9/5/jWyRaoJWmD/pif3q02qjQvhGKw0yWPx0ba/yJQaaODutDXIuegPclHm+1R7 nQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ufxfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 10:32:07 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 10:32:05 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 52C7B3F7040;
        Thu, 28 Jan 2021 10:32:02 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v5 net-next 10/18] net: mvpp2: add FCA RXQ non occupied descriptor threshold
Date:   Thu, 28 Jan 2021 20:31:14 +0200
Message-ID: <1611858682-9845-11-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

The firmware needs to monitor the RX Non-occupied descriptor
bits for flow control to move to XOFF mode.
These bits need to be unmasked to be functional, but they will
not raise interrupts as we leave the RX exception summary
bit in MVPP2_ISR_RX_TX_MASK_REG clear.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 44 ++++++++++++++++----
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 73f087c..ca84995 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -295,6 +295,8 @@
 #define     MVPP2_PON_CAUSE_TXP_OCCUP_DESC_ALL_MASK	0x3fc00000
 #define     MVPP2_PON_CAUSE_MISC_SUM_MASK		BIT(31)
 #define MVPP2_ISR_MISC_CAUSE_REG		0x55b0
+#define MVPP2_ISR_RX_ERR_CAUSE_REG(port)	(0x5520 + 4 * (port))
+#define     MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK	0x00ff
 
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
index 6e59d07..19a3f38 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1134,14 +1134,19 @@ static inline void mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)
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
@@ -1151,20 +1156,25 @@ static void mvpp2_interrupts_mask(void *arg)
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
@@ -1189,6 +1199,9 @@ static void mvpp2_interrupts_unmask(void *arg)
 
 		mvpp2_thread_write(port->priv, v->sw_thread_id,
 				   MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
+		mvpp2_thread_write(port->priv, v->sw_thread_id,
+				   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
+				   MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
 	}
 }
 
@@ -2394,6 +2407,20 @@ static void mvpp2_txp_max_tx_size_set(struct mvpp2_port *port)
 	}
 }
 
+/* Set the number of non-occupied descriptors threshold */
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
@@ -2649,6 +2676,9 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rx_pkts_coal_set(port, rxq);
 	mvpp2_rx_time_coal_set(port, rxq);
 
+	/* Set the number of non occupied descriptors threshold */
+	mvpp2_set_rxq_free_tresh(port, rxq);
+
 	/* Add number of descriptors ready for receiving packets */
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
-- 
1.9.1

