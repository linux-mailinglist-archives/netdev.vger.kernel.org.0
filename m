Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A249309D10
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhAaOkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:40:24 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232774AbhAaOiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:38:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEaYOL018216;
        Sun, 31 Jan 2021 06:37:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rjBdecuOfRqCWmng2kaVg+9HCHUiq/inEk1h/EaHoeY=;
 b=aDv4YC6N4eMf4XGiou+Qxi5Xpp+VvAGewnOH3TwVuMyhc/UfVpVrTtThgE0qBPpHaC7Z
 jodkJaGAMOgH+dSXqCGdnldVI9P8TAUOj8GMqhbMTA9sUZv7b1IFngHGIA7Jzl+IZ/Xa
 yD3SkNgAkEmjvGxFS7S66zwsn5Aemzh6NiRZdM8B7JVPNehLmD2FqOu5o1eAyRJyBMtJ
 zK7hjX850i/1D7hJGAyJIHb9Sczidt0otbF0y872Z1A4X9vs1sBSrQWqf9aIfNwk0/i9
 1WGXPVbPHH77//XjC9aLokxzlNSvGuCoElKXo62+k5+8E2KoJNZ1abcmH7PbL9814eca mA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5pssw3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:37:34 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:37:33 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:37:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 06:37:32 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 92C523F703F;
        Sun, 31 Jan 2021 06:37:29 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 09/15] net: mvpp2: enable global flow control
Date:   Sun, 31 Jan 2021 16:33:52 +0200
Message-ID: <1612103638-16108-10-git-send-email-stefanc@marvell.com>
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
index 19a3f38..770f45a 100644
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

