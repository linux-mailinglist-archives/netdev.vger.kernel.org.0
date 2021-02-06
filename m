Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E62F311EDC
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhBFQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:51:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39074 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230494AbhBFQtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:49:20 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116Gj1md021849;
        Sat, 6 Feb 2021 08:48:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OPe9kw3KgrmCl20IXxeiNKwyyAIVDOtu+mzfNNZEIRs=;
 b=LwrQbx93gNyp9ga2R7zykOFP8NBquWr6v/1CIWI9Q4NMiWE/vs67qZoE0C7HVtflI+JI
 OXzWsyNqep0pojeeA+LZ+sl0mZSq48dphZcksh9HFPEuXusTHB2f0X/CsjHKquij75wm
 X2CfiFtrFYL5UX6plVE9rdO7JOL4xxA/ryV/2YC7+Zd0WW5VGfUx+NOSnrWDukP9lGFc
 6MyZlwWylxD1nJVGMgEONlzhPn/pySL3kXyV9eInBVVJoTtJF0P740bDfwuKBByS2yZK
 zYsK0MA6ehf0DlZLCmNH0JWROVPK8+0Evcx3pelWiQbmZ4eCEYmCT+yrxVYD4wVAwIRc vQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbr8gwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:48:32 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:48:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:48:30 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:48:30 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id ABAA83F703F;
        Sat,  6 Feb 2021 08:48:27 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 15/15] net: mvpp2: add TX FC firmware check
Date:   Sat, 6 Feb 2021 18:46:01 +0200
Message-ID: <1612629961-11583-16-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Patch check that TX FC firmware is running in CM3.
If not, global TX FC would be disabled.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 42 ++++++++++++++++----
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 9947385..25013a4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -829,6 +829,7 @@
 
 #define MSS_THRESHOLD_STOP	768
 #define MSS_THRESHOLD_START	1024
+#define MSS_FC_MAX_TIMEOUT	5000
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5526214..dfc2e71 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -932,6 +932,34 @@ static void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
 	spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
 }
 
+static int mvpp2_enable_global_fc(struct mvpp2 *priv)
+{
+	int val, timeout = 0;
+
+	/* Enable global flow control. In this stage global
+	 * flow control enabled, but still disabled per port.
+	 */
+	val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
+	val |= FLOW_CONTROL_ENABLE_BIT;
+	mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
+
+	/* Check if Firmware running and disable FC if not*/
+	val |= FLOW_CONTROL_UPDATE_COMMAND_BIT;
+	mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
+
+	while (timeout < MSS_FC_MAX_TIMEOUT) {
+		val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
+
+		if (!(val & FLOW_CONTROL_UPDATE_COMMAND_BIT))
+			return 0;
+		usleep_range(10, 20);
+		timeout++;
+	}
+
+	priv->global_tx_fc = false;
+	return -EOPNOTSUPP;
+}
+
 /* Release buffer to BM */
 static inline void mvpp2_bm_pool_put(struct mvpp2_port *port, int pool,
 				     dma_addr_t buf_dma_addr,
@@ -7281,7 +7309,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err, val;
+	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7509,13 +7537,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 		goto err_port_probe;
 	}
 
-	/* Enable global flow control. In this stage global
-	 * flow control enabled, but still disabled per port.
-	 */
 	if (priv->global_tx_fc && priv->hw_version != MVPP21) {
-		val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
-		val |= FLOW_CONTROL_ENABLE_BIT;
-		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
+		err = mvpp2_enable_global_fc(priv);
+		if (err) {
+			dev_warn(&pdev->dev, "CM3 firmware not running, version should be higher than 18.09 ");
+			dev_warn(&pdev->dev, "and chip revision B0\n");
+			dev_warn(&pdev->dev, "Flow control not supported\n");
+		}
 	}
 
 	mvpp2_dbgfs_init(priv, pdev->name);
-- 
1.9.1

