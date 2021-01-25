Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5029B302888
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbhAYRNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:13:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730492AbhAYRMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:12:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PGqCSR013946;
        Mon, 25 Jan 2021 09:09:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6g15w3uNCwvIp8J1tMnuTZzSBalD75DB53rQXgqy48M=;
 b=EMPHR8MEr+URooAie1lLXMDnwkiMImhJSsGDhEEDn5inStJcexgpnlFOzRx855+6M4i3
 TmubbrrTiKuzDsnWms2fDi0aH0zlMjvvI5C4zgf/kHqaumPsJaJIM35ODa62tGmyaMrI
 JohEK7AefrhTwOZ13ycakeWESk0XgYTa0ci3deFODwG1UnroYsSaR/kWJU63sCt6nLBA
 wuZXELg+49YkuwvG78UnjeW/QqT8rBBpYPFPIlKbFxd+bYaUJ6YsW7JcA/anrkM/0Lbl
 WADZz2+Z5UoRgXamNwAK1p8iu9VH1PBSQnOlCnVpBoBVIYUsKdWhTLFQfZX2Z3p6ECfj Lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6ud2e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:09:50 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 Jan 2021 09:09:48 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 2313F3F7040;
        Mon, 25 Jan 2021 09:09:44 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v3 RFC net-next 09/19] net: mvpp2: add FCA periodic timer configurations
Date:   Mon, 25 Jan 2021 19:07:56 +0200
Message-ID: <1611594486-29431-10-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
References: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_07:2021-01-25,2021-01-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Flow Control periodic timer would be used if port in
XOFF to transmit periodic XOFF frames.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 13 +++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 45 ++++++++++++++++++++
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index cac9885..73f087c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -596,6 +596,15 @@
 #define     MVPP22_MPCS_CLK_RESET_DIV_RATIO(n)	((n) << 4)
 #define     MVPP22_MPCS_CLK_RESET_DIV_SET	BIT(11)
 
+/* FCA registers. PPv2.2 and PPv2.3 */
+#define MVPP22_FCA_BASE(port)			(0x7600 + (port) * 0x1000)
+#define MVPP22_FCA_REG_SIZE			16
+#define MVPP22_FCA_REG_MASK			0xFFFF
+#define MVPP22_FCA_CONTROL_REG			0x0
+#define MVPP22_FCA_ENABLE_PERIODIC		BIT(11)
+#define MVPP22_PERIODIC_COUNTER_LSB_REG		(0x110)
+#define MVPP22_PERIODIC_COUNTER_MSB_REG		(0x114)
+
 /* XPCS registers. PPv2.2 and PPv2.3 */
 #define MVPP22_XPCS_BASE(port)			(0x7400 + (port) * 0x1000)
 #define MVPP22_XPCS_CFG0			0x0
@@ -752,7 +761,9 @@
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
 /* MSS Flow control */
-#define MSS_SRAM_SIZE	0x800
+#define MSS_SRAM_SIZE		0x800
+#define FC_QUANTA		0xFFFF
+#define FC_CLK_DIVIDER		100
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 409ca64..8f40293a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1291,6 +1291,49 @@ static void mvpp22_gop_init_10gkr(struct mvpp2_port *port)
 	writel(val, mpcs + MVPP22_MPCS_CLK_RESET);
 }
 
+static void mvpp22_gop_fca_enable_periodic(struct mvpp2_port *port, bool en)
+{
+	struct mvpp2 *priv = port->priv;
+	void __iomem *fca = priv->iface_base + MVPP22_FCA_BASE(port->gop_id);
+	u32 val;
+
+	val = readl(fca + MVPP22_FCA_CONTROL_REG);
+	val &= ~MVPP22_FCA_ENABLE_PERIODIC;
+	if (en)
+		val |= MVPP22_FCA_ENABLE_PERIODIC;
+	writel(val, fca + MVPP22_FCA_CONTROL_REG);
+}
+
+static void mvpp22_gop_fca_set_timer(struct mvpp2_port *port, u32 timer)
+{
+	struct mvpp2 *priv = port->priv;
+	void __iomem *fca = priv->iface_base + MVPP22_FCA_BASE(port->gop_id);
+	u32 lsb, msb;
+
+	lsb = timer & MVPP22_FCA_REG_MASK;
+	msb = timer >> MVPP22_FCA_REG_SIZE;
+
+	writel(lsb, fca + MVPP22_PERIODIC_COUNTER_LSB_REG);
+	writel(msb, fca + MVPP22_PERIODIC_COUNTER_MSB_REG);
+}
+
+/* Set Flow Control timer x100 faster than pause quanta to ensure that link
+ * partner won't send traffic if port is in XOFF mode.
+ */
+static void mvpp22_gop_fca_set_periodic_timer(struct mvpp2_port *port)
+{
+	u32 timer;
+
+	timer = (port->priv->tclk / (USEC_PER_SEC * FC_CLK_DIVIDER))
+		* FC_QUANTA;
+
+	mvpp22_gop_fca_enable_periodic(port, false);
+
+	mvpp22_gop_fca_set_timer(port, timer);
+
+	mvpp22_gop_fca_enable_periodic(port, true);
+}
+
 static int mvpp22_gop_init(struct mvpp2_port *port)
 {
 	struct mvpp2 *priv = port->priv;
@@ -1335,6 +1378,8 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	val |= GENCONF_SOFT_RESET1_GOP;
 	regmap_write(priv->sysctrl_base, GENCONF_SOFT_RESET1, val);
 
+	mvpp22_gop_fca_set_periodic_timer(port);
+
 unsupported_conf:
 	return 0;
 
-- 
1.9.1

