Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7841B307E42
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhA1SkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:40:12 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232161AbhA1SfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:35:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SI5sfU020038;
        Thu, 28 Jan 2021 10:32:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=iUIBeD+BhObIJdIltYd8fBbVWNmmS1YgZDHdfGObhcE=;
 b=RhwTM7otkWxdHSHrbaiU0ccYskbXooTBjI1ctHKHde2EEeRmdAF/Egzdnu3nCiKjA/LO
 PdeiRg9Dd5PaOBzhIxAtrLfiCX/M8JaWCDpz0Fb7SOjd/TL1JLBhlfYrtST55qQZnP2L
 25xBdRqHrrgu35iGkowKV3KGpkftuGC5BWn2t5cxZuwKrt+Z88rahXjH9rR+DbhSxvY/
 WylhqdZeJncn63Wrwn6vBKPVw6DVhg18BeRcU6kg+TumLURG1t77DI81UKXmrRl4CIWH
 X3q78M02f/zjHfYTMvAaV6d+n8OAfkRfoLCZm211Bo6Ui4a5s9eR1jqBg4jjrDJQd61f TA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ufxga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 10:32:23 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:32:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 10:32:22 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 3097C3F7040;
        Thu, 28 Jan 2021 10:32:19 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v5 net-next 15/18] net: mvpp2: add PPv23 RX FIFO flow control
Date:   Thu, 28 Jan 2021 20:31:19 +0200
Message-ID: <1611858682-9845-16-git-send-email-stefanc@marvell.com>
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

New FIFO flow control feature were added in PPv23.
PPv2 FIFO polled by HW and trigger pause frame if FIFO
fill level is below threshold.
FIFO HW flow control enabled with CM3 RXQ&BM flow
control with ethtool.
Current  FIFO thresholds is:
9KB for port with maximum speed 10Gb/s port
4KB for port with maximum speed 5Gb/s port
2KB for port with maximum speed 1Gb/s port

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 15 ++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 53 ++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 1967493..9947385 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -770,6 +770,18 @@
 #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
+/* RX FIFO threshold in 1KB granularity */
+#define MVPP23_PORT0_FIFO_TRSH	(9 * 1024)
+#define MVPP23_PORT1_FIFO_TRSH	(4 * 1024)
+#define MVPP23_PORT2_FIFO_TRSH	(2 * 1024)
+
+/* RX Flow Control Registers */
+#define MVPP2_RX_FC_REG(port)		(0x150 + 4 * (port))
+#define     MVPP2_RX_FC_EN		BIT(24)
+#define     MVPP2_RX_FC_TRSH_OFFS	16
+#define     MVPP2_RX_FC_TRSH_MASK	(0xFF << MVPP2_RX_FC_TRSH_OFFS)
+#define     MVPP2_RX_FC_TRSH_UNIT	256
+
 /* MSS Flow control */
 #define MSS_SRAM_SIZE			0x800
 #define MSS_FC_COM_REG			0
@@ -1502,6 +1514,8 @@ struct mvpp2_bm_pool {
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
 
+void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en);
+
 #ifdef CONFIG_MVPP2_PTP
 int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
 void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
@@ -1534,4 +1548,5 @@ static inline bool mvpp22_rx_hwtstamping(struct mvpp2_port *port)
 {
 	return IS_ENABLED(CONFIG_MVPP2_PTP) && port->rx_hwtstamp;
 }
+
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c7517b1f..afa61cc 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6535,6 +6535,8 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			mvpp2_bm_pool_update_fc(port, port->pool_long, tx_pause);
 			mvpp2_bm_pool_update_fc(port, port->pool_short, tx_pause);
 		}
+		if (port->priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_en(port->priv, port->id, tx_pause);
 	}
 
 	mvpp2_port_enable(port);
@@ -7003,6 +7005,55 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
 	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
 }
 
+/* Configure Rx FIFO Flow control thresholds */
+static void mvpp23_rx_fifo_fc_set_tresh(struct mvpp2 *priv)
+{
+	int port, val;
+
+	/* Port 0: maximum speed -10Gb/s port
+	 *	   required by spec RX FIFO threshold 9KB
+	 * Port 1: maximum speed -5Gb/s port
+	 *	   required by spec RX FIFO threshold 4KB
+	 * Port 2: maximum speed -1Gb/s port
+	 *	   required by spec RX FIFO threshold 2KB
+	 */
+
+	/* Without loopback port */
+	for (port = 0; port < (MVPP2_MAX_PORTS - 1); port++) {
+		if (port == 0) {
+			val = (MVPP23_PORT0_FIFO_TRSH / MVPP2_RX_FC_TRSH_UNIT)
+				<< MVPP2_RX_FC_TRSH_OFFS;
+			val &= MVPP2_RX_FC_TRSH_MASK;
+			mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
+		} else if (port == 1) {
+			val = (MVPP23_PORT1_FIFO_TRSH / MVPP2_RX_FC_TRSH_UNIT)
+				<< MVPP2_RX_FC_TRSH_OFFS;
+			val &= MVPP2_RX_FC_TRSH_MASK;
+			mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
+		} else {
+			val = (MVPP23_PORT2_FIFO_TRSH / MVPP2_RX_FC_TRSH_UNIT)
+				<< MVPP2_RX_FC_TRSH_OFFS;
+			val &= MVPP2_RX_FC_TRSH_MASK;
+			mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
+		}
+	}
+}
+
+/* Configure Rx FIFO Flow control thresholds */
+void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en)
+{
+	int val;
+
+	val = mvpp2_read(priv, MVPP2_RX_FC_REG(port));
+
+	if (en)
+		val |= MVPP2_RX_FC_EN;
+	else
+		val &= ~MVPP2_RX_FC_EN;
+
+	mvpp2_write(priv, MVPP2_RX_FC_REG(port), val);
+}
+
 static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size)
 {
 	int threshold = MVPP2_TX_FIFO_THRESHOLD(size);
@@ -7154,6 +7205,8 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	} else {
 		mvpp22_rx_fifo_init(priv);
 		mvpp22_tx_fifo_init(priv);
+		if (priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_set_tresh(priv);
 	}
 
 	if (priv->hw_version == MVPP21)
-- 
1.9.1

