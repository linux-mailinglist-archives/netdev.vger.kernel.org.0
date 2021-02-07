Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2946C31228E
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBGIZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:25:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhBGIWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:22:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1178LSqI025719;
        Sun, 7 Feb 2021 00:21:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EFISppJR0xWqQHvPJYuLckZ8Kkn25DMA3D5BqIG+aRI=;
 b=QbgB7GTYU9TwIqrdIKWMh2ykwXBScNSqZ9VUa0qVY8Q2vgdLDI3eAKEK1/fF12DSINdJ
 1ssDj/LSCSKD3DTM0W6i1B2F4ALzJI0OMr0/4T1eSq9PHtr49cHPjnpV+C1Sv9iYkAbP
 RY+Dap7AxmK7EhrZDNuMexMJsSURNXJSSwsCVyxJZZgNVsZShIh9+suABfwYWAZsGyFx
 6izu2qjy2LR9nwRC6s26XUwhDfMKm3HfagQ0Bocpr3oKx454idCwzjrX7+FNaGE0d01L
 5xoooaTsm5RXzTSCtkMzEb8eLFSenoCIlMcyRAGE1BWi7YSCuvw7iX2vvxMj4wgo3UbW xA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq1m26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 00:21:39 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 00:21:37 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 00:21:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 7 Feb 2021 00:21:37 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 7EC413F7041;
        Sun,  7 Feb 2021 00:21:33 -0800 (PST)
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
Subject: [RESEND PATCH v8 net-next 09/15] net: mvpp2: enable global flow control
Date:   Sun, 7 Feb 2021 10:19:18 +0200
Message-ID: <1612685964-21890-10-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
References: <1612685964-21890-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_03:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch enables global flow control in FW and in the phylink validate mask.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 13 ++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 30 +++++++++++++++++++-
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ca84995..e010410 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -763,10 +763,12 @@
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
 /* MSS Flow control */
-#define MSS_SRAM_SIZE		0x800
-#define FC_QUANTA		0xFFFF
-#define FC_CLK_DIVIDER		100
-#define MSS_THRESHOLD_STOP	768
+#define MSS_SRAM_SIZE			0x800
+#define MSS_FC_COM_REG			0
+#define FLOW_CONTROL_ENABLE_BIT		BIT(0)
+#define FC_QUANTA			0xFFFF
+#define FC_CLK_DIVIDER			100
+#define MSS_THRESHOLD_STOP		768
 
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
@@ -1021,6 +1023,9 @@ struct mvpp2 {
 
 	/* CM3 SRAM pool */
 	struct gen_pool *sram_pool;
+
+	/* Global TX Flow Control config */
+	bool global_tx_fc;
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a72a390..fec1c81 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -92,6 +92,16 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
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
@@ -5951,6 +5961,11 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
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
@@ -6969,7 +6984,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err;
+	int err, val;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7023,6 +7038,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 			return err;
 		else if (err)
 			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
+
+		/* Enable global Flow Control only if handler to SRAM not NULL */
+		if (priv->cm3_base)
+			priv->global_tx_fc = true;
 	}
 
 	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
@@ -7190,6 +7209,15 @@ static int mvpp2_probe(struct platform_device *pdev)
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

