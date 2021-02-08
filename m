Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CED312C10
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBHIlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:41:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23552 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230362AbhBHIgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:36:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1188WC1p003077;
        Mon, 8 Feb 2021 00:35:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YyIJ/1eDbCh0foaOPgcKNNopcXPvlFkHzZZvwgJfM/4=;
 b=jYw6XAx6w0vr5hapCC6qyNsg61jkLptnEgHj+PN+TACuppuRsT+8rD0yeY0nkCl1bGxE
 WmINrTzQ55xZS9JDQc4ExJ36kw28xd03qKFIup8l+hi8rjGc7yfsGpe5bm+R1qezbS7q
 DwbmtSXMu+IB71QsoBXGcheuP4VZ4eYWhjLiE5sUb92Szjp6jc9KBzE0sZUH6grP2Wo4
 6LMIwWdPrWZKQKAsrR37Jz+4cltsVKEGBJD4fpgcYmRuk/dgqc8yYAetyHw4G6Sb2JSZ
 ZzZ3nBU0qXeijwuKKHxSwf/nER6JmDX3ujZUMHu+3exF5ISccyVRyyKv6NsRsZuqO4VN OQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq3ydr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Feb 2021 00:35:57 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Feb
 2021 00:35:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 8 Feb 2021 00:35:55 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 987AA3F7040;
        Mon,  8 Feb 2021 00:35:51 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v10 net-next 15/15] net: mvpp2: add TX FC firmware check
Date:   Mon, 8 Feb 2021 10:32:47 +0200
Message-ID: <1612773167-22490-16-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612773167-22490-1-git-send-email-stefanc@marvell.com>
References: <1612773167-22490-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-08_02:2021-02-08,2021-02-08 signatures=0
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
index b61a1ba..da87152 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -828,6 +828,7 @@
 
 #define MSS_THRESHOLD_STOP	768
 #define MSS_THRESHOLD_START	1024
+#define MSS_FC_MAX_TIMEOUT	5000
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4d0a398..fed4521 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -931,6 +931,34 @@ static void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
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
@@ -7263,7 +7291,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err, val;
+	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7487,13 +7515,13 @@ static int mvpp2_probe(struct platform_device *pdev)
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

