Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87E309D12
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhAaOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:40:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41634 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231944AbhAaOhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:37:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEZ6mi024058;
        Sun, 31 Jan 2021 06:37:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6pDdBO4FiW4J3ZSh6Q2cfqQ4yvjsrELQlYlAuzrXKH0=;
 b=ZaP299rEBa4fKb3tv939gJ2gFxNLXpmgzKYrfM9NJKv6q+GrElRW+6t9oQqsdrIpVq7L
 TiC0zoDwqiXzLhFr8+Ee+/ELvfpXvO74itnmzKWppdCHQi6iw+QApGwbT2WQyIH7CtcC
 TNJcbvXmDK/HWvLvxujXgW48M1WAJsQ4N+hL9HVs3GYGdbrEy6edQr3pGa7T9UgRkevN
 AR+UIbGhhFkmDfqOB1Jwjqe1EgIEC3AgDvaGTn5Pk80ngArsZFTvq/K1B10V627/Gldw
 Dqn4txR6V7hZLPtCB5cRxBVUvDS4nFoKIDYPjvyUrAPZWdDru7SRuzSXuNMbIo5m342P Wg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1q2j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:37:04 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:37:02 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:37:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 06:37:01 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 71B0D3F703F;
        Sun, 31 Jan 2021 06:36:58 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 07/15] net: mvpp2: add FCA periodic timer configurations
Date:   Sun, 31 Jan 2021 16:33:50 +0200
Message-ID: <1612103638-16108-8-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
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
index d80947a..6e59d07 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1281,6 +1281,49 @@ static void mvpp22_gop_init_10gkr(struct mvpp2_port *port)
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
@@ -1325,6 +1368,8 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	val |= GENCONF_SOFT_RESET1_GOP;
 	regmap_write(priv->sysctrl_base, GENCONF_SOFT_RESET1, val);
 
+	mvpp22_gop_fca_set_periodic_timer(port);
+
 unsupported_conf:
 	return 0;
 
-- 
1.9.1

