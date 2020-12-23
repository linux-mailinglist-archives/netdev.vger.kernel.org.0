Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1112E207E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgLWSir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:38:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4854 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbgLWSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:38:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BNIHKCu029568;
        Wed, 23 Dec 2020 10:35:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=P+WpMiPyk7oIrJqS4VH5QprshtGLxMyxirTRn4K0GVM=;
 b=RRQZmjEExJnk1pAHgv+LZYkaH5YVk9MqYNJQwa+TNdzBx+D91JNj5GN1pZwYyw3wqf/e
 afVJNMk6j3Iliko+QNWGQITJF/olJt+XbtpXMwIwoJQl4MI9BgI3Bv4ui8nLzi6YXtmQ
 szeD3oBc43w0Xn/ShcXK1nnnrwrDsrREpuD2NBPJefKvbvQ/Gtv2ZXHLFu5cCP6aId+a
 6XjCcoJn1/BdaoX2AewmcmAOH+cJ0Uko3q0qSnTrZfVOpamnOA0pqx9GyolDKo5r2iJc
 VVV4y2i6mv2J30ZT3Wvq4bcFQPnIwHPJifL+BpFvnoFrf8JvWWgqKijyWIMJBB0iVEfD eQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35k0ebevr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 10:35:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Dec
 2020 10:35:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 10:35:42 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 96A753F703F;
        Wed, 23 Dec 2020 10:35:39 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH net] net: mvpp2: fix pkt coalescing int-threshold configuration
Date:   Wed, 23 Dec 2020 20:35:21 +0200
Message-ID: <1608748521-11033-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-23_10:2020-12-23,2020-12-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

The packet coalescing interrupt threshold has separated registers
for different aggregated/cpu (sw-thread). The required value should
be loaded for every thread but not only for 1 current cpu.

Fixes: 213f428f5056 ("net: mvpp2: add support for TX interrupts and RX queue distribution modes")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 87068eb..3982956 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2370,17 +2370,18 @@ static void mvpp2_rx_pkts_coal_set(struct mvpp2_port *port,
 static void mvpp2_tx_pkts_coal_set(struct mvpp2_port *port,
 				   struct mvpp2_tx_queue *txq)
 {
-	unsigned int thread = mvpp2_cpu_to_thread(port->priv, get_cpu());
+	unsigned int thread;
 	u32 val;
 
 	if (txq->done_pkts_coal > MVPP2_TXQ_THRESH_MASK)
 		txq->done_pkts_coal = MVPP2_TXQ_THRESH_MASK;
 
 	val = (txq->done_pkts_coal << MVPP2_TXQ_THRESH_OFFSET);
-	mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_NUM_REG, txq->id);
-	mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_THRESH_REG, val);
-
-	put_cpu();
+	/* PKT-coalescing registers are per-queue + per-thread */
+	for (thread = 0; thread < MVPP2_MAX_THREADS; thread++) {
+		mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_NUM_REG, txq->id);
+		mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_THRESH_REG, val);
+	}
 }
 
 static u32 mvpp2_usec_to_cycles(u32 usec, unsigned long clk_hz)
-- 
1.9.1

