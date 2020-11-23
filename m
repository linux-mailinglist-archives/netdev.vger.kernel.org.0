Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FBF2C1296
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbgKWR5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:57:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390464AbgKWR5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:57:01 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHsist021505;
        Mon, 23 Nov 2020 09:54:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NaOHOX9tiUGyY/SdhXODG+mMVW/eNja5gUFBpoBkYoU=;
 b=H4XJzAqeaGwMOm2hNzNi4WD1RKZQpF0VSInH6nTImmjtVv6MGlYe2ByfxJn12ZfgNEfR
 M6HGpW0oPMHy+KfiFXM27DBtfXbBD1DklkdM21nSljg+9gtFEQqpcQPvp0FV3anlUi55
 X30uo6DWQrsf1fgsNpInfl9tImiarsUchnsb7g5laREIiZdFu3HPVfFnRecVgFj3Z8KN
 V+Q77VudGTcoRpxplV66ASJoN60/sVj5ILIypEzZJfxdS2rxt0HMpJXVwrd5OAQ8CFHr
 0zvIQqKS6jOhsZ68s4RHrkWJyxepSr6LZZQqMLsuHZOgaMnvV10Zwc1oj42RWDilm0th nQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r6d95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:54:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:54:50 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:54:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Nov 2020 09:54:48 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id CD2333F7040;
        Mon, 23 Nov 2020 09:54:45 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2] net: mvpp2: divide fifo for dts-active ports only
Date:   Mon, 23 Nov 2020 19:54:33 +0200
Message-ID: <1606154073-28267-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Tx/Rx FIFO is a HW resource limited by total size, but shared
by all ports of same CP110 and impacting port-performance.
Do not divide the FIFO for ports which are not enabled in DTS,
so active ports could have more FIFO.
No change in FIFO allocation if all 3 ports on the communication
processor enabled in DTS.

The active port mapping should be done in probe before FIFO-init.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  23 +++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 129 +++++++++++++++++-------
 2 files changed, 108 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8347758..6bd7e40 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -695,6 +695,9 @@
 /* Maximum number of supported ports */
 #define MVPP2_MAX_PORTS			4
 
+/* Loopback port index */
+#define MVPP2_LOOPBACK_PORT_INDEX	3
+
 /* Maximum number of TXQs used by single port */
 #define MVPP2_MAX_TXQ			8
 
@@ -729,22 +732,21 @@
 #define MVPP2_TX_DESC_ALIGN		(MVPP2_DESC_ALIGNED_SIZE - 1)
 
 /* RX FIFO constants */
+#define MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB	0xb000
 #define MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB	0x8000
 #define MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB	0x2000
 #define MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB	0x1000
-#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB	0x200
-#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB	0x80
+#define MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size)	((data_size) >> 6)
 #define MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB	0x40
 #define MVPP2_RX_FIFO_PORT_MIN_PKT		0x80
 
 /* TX FIFO constants */
-#define MVPP22_TX_FIFO_DATA_SIZE_10KB		0xa
-#define MVPP22_TX_FIFO_DATA_SIZE_3KB		0x3
-#define MVPP2_TX_FIFO_THRESHOLD_MIN		256
-#define MVPP2_TX_FIFO_THRESHOLD_10KB	\
-	(MVPP22_TX_FIFO_DATA_SIZE_10KB * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
-#define MVPP2_TX_FIFO_THRESHOLD_3KB	\
-	(MVPP22_TX_FIFO_DATA_SIZE_3KB * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
+#define MVPP22_TX_FIFO_DATA_SIZE_16KB		16
+#define MVPP22_TX_FIFO_DATA_SIZE_10KB		10
+#define MVPP22_TX_FIFO_DATA_SIZE_3KB		3
+#define MVPP2_TX_FIFO_THRESHOLD_MIN		256 /* Bytes */
+#define MVPP2_TX_FIFO_THRESHOLD(kb)	\
+		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
@@ -946,6 +948,9 @@ struct mvpp2 {
 	/* List of pointers to port structures */
 	int port_count;
 	struct mvpp2_port *port_list[MVPP2_MAX_PORTS];
+	/* Map of enabled ports */
+	unsigned long port_map;
+
 	struct mvpp2_tai *tai;
 
 	/* Number of Tx threads used */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8..08c237a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6601,32 +6601,56 @@ static void mvpp2_rx_fifo_init(struct mvpp2 *priv)
 	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
 }
 
-static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
+static void mvpp22_rx_fifo_set_hw(struct mvpp2 *priv, int port, int data_size)
 {
-	int port;
+	int attr_size = MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size);
 
-	/* The FIFO size parameters are set depending on the maximum speed a
-	 * given port can handle:
-	 * - Port 0: 10Gbps
-	 * - Port 1: 2.5Gbps
-	 * - Ports 2 and 3: 1Gbps
-	 */
+	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port), data_size);
+	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port), attr_size);
+}
 
-	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(0),
-		    MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
-	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(0),
-		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB);
+/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2.
+ * 4kB fixed space must be assigned for the loopback port.
+ * Redistribute remaining avialable 44kB space among all active ports.
+ * Guarantee minimum 32kB for 10G port and 8kB for port 1, capable of 2.5G
+ * SGMII link.
+ */
+static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
+{
+	int remaining_ports_count;
+	unsigned long port_map;
+	int size_remainder;
+	int port, size;
+
+	/* The loopback requires fixed 4kB of the FIFO space assignment. */
+	mvpp22_rx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
+			      MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
+	port_map = priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
+
+	/* Set RX FIFO size to 0 for inactive ports. */
+	for_each_clear_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX)
+		mvpp22_rx_fifo_set_hw(priv, port, 0);
+
+	/* Assign remaining RX FIFO space among all active ports. */
+	size_remainder = MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB;
+	remaining_ports_count = hweight_long(port_map);
+
+	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
+		if (remaining_ports_count == 1)
+			size = size_remainder;
+		else if (port == 0)
+			size = max(size_remainder / remaining_ports_count,
+				   MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
+		else if (port == 1)
+			size = max(size_remainder / remaining_ports_count,
+				   MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
+		else
+			size = size_remainder / remaining_ports_count;
 
-	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(1),
-		    MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
-	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(1),
-		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB);
+		size_remainder -= size;
+		remaining_ports_count--;
 
-	for (port = 2; port < MVPP2_MAX_PORTS; port++) {
-		mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port),
-			    MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
-		mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port),
-			    MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB);
+		mvpp22_rx_fifo_set_hw(priv, port, size);
 	}
 
 	mvpp2_write(priv, MVPP2_RX_MIN_PKT_SIZE_REG,
@@ -6634,24 +6658,53 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
 	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
 }
 
-/* Initialize Tx FIFO's: the total FIFO size is 19kB on PPv2.2 and 10G
- * interfaces must have a Tx FIFO size of 10kB. As only port 0 can do 10G,
- * configure its Tx FIFO size to 10kB and the others ports Tx FIFO size to 3kB.
+static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size)
+{
+	int threshold = MVPP2_TX_FIFO_THRESHOLD(size);
+
+	mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
+	mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), threshold);
+}
+
+/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2.
+ * 3kB fixed space must be assigned for the loopback port.
+ * Redistribute remaining avialable 16kB space among all active ports.
+ * The 10G interface should use 10kB (which is maximum possible size
+ * per single port).
  */
 static void mvpp22_tx_fifo_init(struct mvpp2 *priv)
 {
-	int port, size, thrs;
-
-	for (port = 0; port < MVPP2_MAX_PORTS; port++) {
-		if (port == 0) {
+	int remaining_ports_count;
+	unsigned long port_map;
+	int size_remainder;
+	int port, size;
+
+	/* The loopback requires fixed 3kB of the FIFO space assignment. */
+	mvpp22_tx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
+			      MVPP22_TX_FIFO_DATA_SIZE_3KB);
+	port_map = priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
+
+	/* Set TX FIFO size to 0 for inactive ports. */
+	for_each_clear_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX)
+		mvpp22_tx_fifo_set_hw(priv, port, 0);
+
+	/* Assign remaining TX FIFO space among all active ports. */
+	size_remainder = MVPP22_TX_FIFO_DATA_SIZE_16KB;
+	remaining_ports_count = hweight_long(port_map);
+
+	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
+		if (remaining_ports_count == 1)
+			size = min(size_remainder,
+				   MVPP22_TX_FIFO_DATA_SIZE_10KB);
+		else if (port == 0)
 			size = MVPP22_TX_FIFO_DATA_SIZE_10KB;
-			thrs = MVPP2_TX_FIFO_THRESHOLD_10KB;
-		} else {
-			size = MVPP22_TX_FIFO_DATA_SIZE_3KB;
-			thrs = MVPP2_TX_FIFO_THRESHOLD_3KB;
-		}
-		mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
-		mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), thrs);
+		else
+			size = size_remainder / remaining_ports_count;
+
+		size_remainder -= size;
+		remaining_ports_count--;
+
+		mvpp22_tx_fifo_set_hw(priv, port, size);
 	}
 }
 
@@ -6952,6 +7005,12 @@ static int mvpp2_probe(struct platform_device *pdev)
 			goto err_axi_clk;
 	}
 
+	/* Map DTS-active ports. Should be done before FIFO mvpp2_init */
+	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
+		if (!fwnode_property_read_u32(port_fwnode, "port-id", &i))
+			priv->port_map |= BIT(i);
+	}
+
 	/* Initialize network controller */
 	err = mvpp2_init(pdev, priv);
 	if (err < 0) {
-- 
1.9.1

