Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73D9301B84
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbhAXLsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:48:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8420 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbhAXLsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:48:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBjJeO026736;
        Sun, 24 Jan 2021 03:45:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bqJq1pEiwvkw+qADtgyEC7zoCmpfpST1Pt0BgGBZ62s=;
 b=KC/Vvwy3OTFpSGO23/Q7sEosLezwamWDaMci/WKO7lb32rCa8bDMLGfPRTosuyLOgIrV
 1LFQXbbiQAF82Rag52D5ePTieb7HIJGqcOc8e4vQrEjeg+ppUwCbimNBCagguqaH/l7Y
 0/bpOLGxQ/UEyf3nBVBw5MJbCklWXmzyh0h/8CMfE4xhSFehTects57jj0UzZEB69FYB
 xmblnNEeGQjFMkTt31V5vnPVNt/0hyBC8ZR//qoPsygt/h4RWn8bOzn4z322gL4qCDuk
 BI9+Pp6Ta6CSSWCFMKUd6DvlJZW4/gnlF/n7KF0wi7LHt6ZNBHlXWLme0XXJoI/0EQjk 2A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9stq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:45:19 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:15 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:45:14 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 9381C3F7040;
        Sun, 24 Jan 2021 03:45:11 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 09/18] net: mvpp2: add FCA RXQ non occupied descriptor threshold
Date:   Sun, 24 Jan 2021 13:43:58 +0200
Message-ID: <1611488647-12478-10-git-send-email-stefanc@marvell.com>
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

RXQ non occupied descriptor threshold would be used by
Flow Control Firmware feature to move to the XOFF mode.
RXQ non occupied threshold would change interrupt cause
that polled by CM3 Firmware.
Actual non occupied interrupt masked and won't trigger interrupt.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 29 ++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 0861c0b..3df8f60 100644
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
 #define FC_CLK_DIVIDER		0x140
+#define MSS_THRESHOLD_STOP    768
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9d69752..0f5069f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1154,6 +1154,9 @@ static void mvpp2_interrupts_mask(void *arg)
 	mvpp2_thread_write(port->priv,
 			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
 			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
+	mvpp2_thread_write(port->priv,
+			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
+			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
 }
 
 /* Unmask the current thread's Rx/Tx interrupts.
@@ -1177,6 +1180,10 @@ static void mvpp2_interrupts_unmask(void *arg)
 	mvpp2_thread_write(port->priv,
 			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
 			   MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
+	mvpp2_thread_write(port->priv,
+			   mvpp2_cpu_to_thread(port->priv, smp_processor_id()),
+			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
+			   MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
 }
 
 static void
@@ -1201,6 +1208,9 @@ static void mvpp2_interrupts_unmask(void *arg)
 
 		mvpp2_thread_write(port->priv, v->sw_thread_id,
 				   MVPP2_ISR_RX_TX_MASK_REG(port->id), val);
+		mvpp2_thread_write(port->priv, v->sw_thread_id,
+				   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id),
+				   MVPP2_ISR_RX_ERR_CAUSE_NONOCC_MASK);
 	}
 }
 
@@ -2406,6 +2416,22 @@ static void mvpp2_txp_max_tx_size_set(struct mvpp2_port *port)
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
@@ -2661,6 +2687,9 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rx_pkts_coal_set(port, rxq);
 	mvpp2_rx_time_coal_set(port, rxq);
 
+	/* Set the number of non occupied descriptors threshold */
+	mvpp2_set_rxq_free_tresh(port, rxq);
+
 	/* Add number of descriptors ready for receiving packets */
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
-- 
1.9.1

