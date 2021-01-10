Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F0F2F081C
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbhAJPex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32538 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbhAJPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFPbMc022764;
        Sun, 10 Jan 2021 07:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zCDDXxQbdPvXnvoU4RfIc+k368IGC6J99qFMEkd7/j8=;
 b=UjPVaspk+U1FLNvylCc6s+qnGHAasEpGwCz+yY7YJ0BhlQWNR2P1ppAC5NBmuMkU8LoI
 lOF+o6vJQ+5lkrnUkVyetzkGxwbe1+0VFLDBshKsm/uf0icoomOfIO54rtQ0oS8Uclk/
 GJD+1YRaYcwqwqIO8JqJij157yEuWrCIh7Hv2+eSuBYLnE1oP9/lPZRL72USEP7d+Qs+
 TD8K1jB+1HrDELUT4sm/mUAIbv09ccKg9p9VqSh2gwZTgmS3pf5DpXXuu5unzLYm6VpJ
 9e1B3zObCZUVmNQvzpo4cTu2lFr5mONXEXiYq8MLMe0+1yGYYRXyPYFbwPYOkAWNEJvv xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphved-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:58 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:56 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 42C693F703F;
        Sun, 10 Jan 2021 07:31:53 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  16/19] net: mvpp2: add PPv23 RX FIFO flow control
Date:   Sun, 10 Jan 2021 17:30:20 +0200
Message-ID: <1610292623-15564-17-git-send-email-stefanc@marvell.com>
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 16 +++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 55 ++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 27aa593..3451618 100644
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
@@ -818,7 +830,6 @@
 #define MSS_THRESHOLD_STOP	768
 #define MSS_THRESHOLD_START	1024
 
-
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
 	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
@@ -1505,6 +1516,8 @@ struct mvpp2_bm_pool {
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
 
+void mvpp23_rx_fifo_fc_en(struct mvpp2 *priv, int port, bool en);
+
 #ifdef CONFIG_MVPP2_PTP
 int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
 void mvpp22_tai_tstamp(struct mvpp2_tai *tai, u32 tstamp,
@@ -1537,4 +1550,5 @@ static inline bool mvpp22_rx_hwtstamping(struct mvpp2_port *port)
 {
 	return IS_ENABLED(CONFIG_MVPP2_PTP) && port->rx_hwtstamp;
 }
+
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8827f52..757dfe0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5448,6 +5448,8 @@ static int mvpp2_ethtool_set_pause_param(struct net_device *dev,
 			mvpp2_bm_pool_update_fc(port, port->pool_long, true);
 			mvpp2_bm_pool_update_fc(port, port->pool_short, true);
 		}
+		if (port->priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_en(port->priv, port->id, true);
 
 	} else if (port->priv->global_tx_fc) {
 		port->tx_fc = false;
@@ -5459,6 +5461,8 @@ static int mvpp2_ethtool_set_pause_param(struct net_device *dev,
 			mvpp2_bm_pool_update_fc(port, port->pool_long, false);
 			mvpp2_bm_pool_update_fc(port, port->pool_short, false);
 		}
+		if (port->priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_en(port->priv, port->id, false);
 	}
 
 	if (!port->phylink)
@@ -7022,6 +7026,55 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
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
@@ -7173,6 +7226,8 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	} else {
 		mvpp22_rx_fifo_init(priv);
 		mvpp22_tx_fifo_init(priv);
+		if (priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_set_tresh(priv);
 	}
 
 	if (priv->hw_version == MVPP21)
-- 
1.9.1

