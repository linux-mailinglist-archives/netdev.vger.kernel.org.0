Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F581314AC4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBIIta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:49:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49822 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229733AbhBIIqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:46:33 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1198jbPg027034;
        Tue, 9 Feb 2021 00:45:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UrL4S17emqCRulz9TWUJtPhwJxRUYZLo7+JL/qJJ06c=;
 b=YFRXdaHV5UX0s5RbI/cdC9ueoHlEKkhaK+gefT3/ifo/u/nSGfr4m5dzeMm0wJfEkyL8
 SnS9+m8nm+vGTfIFfw2dl3AXLu2f1A8BzJHlhda2oZOCwVrChYYOFjE6QHqMPDINROOc
 V/ENS6X3R866T/cdkn7zhAf/J8NG1MmACIPpiUmIVlf+iKRyxY1HlI0cRbNaPukvgWcT
 q+BgvqSJzNTnDHTx7LIrLbhwNsPkvRxr1DBbH6wyulLf13XiNT5ypssggRUBSbZ+HqEx
 3KTKr8GDYARSH//R2k8DQACzMkQ0NO9pDVknLovMJ4OgoZTWi7D6roF0D8ug+cEsTByB Gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq7m4k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 00:45:41 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 00:45:31 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 00:45:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 00:45:31 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 39F373F703F;
        Tue,  9 Feb 2021 00:45:27 -0800 (PST)
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
Subject: [PATCH v11 net-next 09/15] net: mvpp2: enable global flow control
Date:   Tue, 9 Feb 2021 10:42:25 +0200
Message-ID: <1612860151-12275-10-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
References: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_02:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch enables global flow control in FW and in the phylink validate mask.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 11 +++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 30 +++++++++++++++++++-
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index d2cc513c..8945fb9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -763,9 +763,11 @@
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
 /* MSS Flow control */
-#define FC_QUANTA		0xFFFF
-#define FC_CLK_DIVIDER		100
-#define MSS_THRESHOLD_STOP	768
+#define MSS_FC_COM_REG			0
+#define FLOW_CONTROL_ENABLE_BIT		BIT(0)
+#define FC_QUANTA			0xFFFF
+#define FC_CLK_DIVIDER			100
+#define MSS_THRESHOLD_STOP		768
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
@@ -1017,6 +1019,9 @@ struct mvpp2 {
 
 	/* page_pool allocator */
 	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
+
+	/* Global TX Flow Control config */
+	bool global_tx_fc;
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8b4073c..027101b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -91,6 +91,16 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 	return cpu % priv->nthreads;
 }
 
+static void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data)
+{
+	writel(data, priv->cm3_base + offset);
+}
+
+static u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset)
+{
+	return readl(priv->cm3_base + offset);
+}
+
 static struct page_pool *
 mvpp2_create_page_pool(struct device *dev, int num, int len,
 		       enum dma_data_direction dma_dir)
@@ -5950,6 +5960,11 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
 
+	if (port->priv->global_tx_fc) {
+		phylink_set(mask, Pause);
+		phylink_set(mask, Asym_Pause);
+	}
+
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
@@ -6951,7 +6966,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err;
+	int err, val;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7003,6 +7018,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 		err = mvpp2_get_sram(pdev, priv);
 		if (err)
 			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
+
+		/* Enable global Flow Control only if handler to SRAM not NULL */
+		if (priv->cm3_base)
+			priv->global_tx_fc = true;
 	}
 
 	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
@@ -7168,6 +7187,15 @@ static int mvpp2_probe(struct platform_device *pdev)
 		goto err_port_probe;
 	}
 
+	/* Enable global flow control. In this stage global
+	 * flow control enabled, but still disabled per port.
+	 */
+	if (priv->global_tx_fc && priv->hw_version != MVPP21) {
+		val = mvpp2_cm3_read(priv, MSS_FC_COM_REG);
+		val |= FLOW_CONTROL_ENABLE_BIT;
+		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
+	}
+
 	mvpp2_dbgfs_init(priv, pdev->name);
 
 	platform_set_drvdata(pdev, priv);
-- 
1.9.1

