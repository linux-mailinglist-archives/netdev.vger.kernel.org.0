Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4087E301BB7
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbhAXMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:02:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbhAXLro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:47:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBhfqm025134;
        Sun, 24 Jan 2021 03:44:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=oIoVD4Z9Z8IyzQzDBtQ7BTZcgwFql9PRYhL69gi2Lik=;
 b=a3Cua/N+04gTvDXpD8u7lk4CJvT2xpRLfThg8HFBtloMgDY9I04UbWIIdtOiwSCZFMnc
 G/oFeUJSsKSL7oGKqX+Yzf34bVLqEIniCZ9kE1GGKuby/DNZapIWojRygg8jC5P6Z28O
 tgd/w2WO4OpWcq30J+/3K9RhHhkYEk6P/a2/7r/QPk6VXn6cWmR/3Ifn8ZODtDarJo6e
 vll+7/dx+7R6qOE9ZlkPKlvqOGyrljZAz4THXNaHecCF9x0E+9r8694TUg4WQ5mtiZ9m
 xmaNbCC1rp3SuUIXta8IajOS4G2csdJJ+OxbL13JfWUhGqiophX6xQQoSnBxXXgfc2So bg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9st8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:44:56 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:44:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:44:54 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 528053F7040;
        Sun, 24 Jan 2021 03:44:51 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM memory map
Date:   Sun, 24 Jan 2021 13:43:52 +0200
Message-ID: <1611488647-12478-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds CM3 memory map and CM3 read/write callbacks.
No functionality changes.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  7 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 74 +++++++++++++++++++-
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..aec9179 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -748,6 +748,9 @@
 #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
 
+/* MSS Flow control */
+#define MSS_SRAM_SIZE	0x800
+
 /* RX buffer constants */
 #define MVPP2_SKB_SHINFO_SIZE \
 	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
@@ -925,6 +928,7 @@ struct mvpp2 {
 	/* Shared registers' base addresses */
 	void __iomem *lms_base;
 	void __iomem *iface_base;
+	void __iomem *cm3_base;
 
 	/* On PPv2.2, each "software thread" can access the base
 	 * register through a separate address space, each 64 KB apart
@@ -996,6 +1000,9 @@ struct mvpp2 {
 
 	/* page_pool allocator */
 	struct page_pool *page_pool[MVPP2_PORT_MAX_RXQ];
+
+	/* CM3 SRAM pool */
+	struct gen_pool *sram_pool;
 };
 
 struct mvpp2_pcpu_stats {
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a07cf60..c969a2d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -25,6 +25,7 @@
 #include <linux/of_net.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/genalloc.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/phy/phy.h>
@@ -91,6 +92,18 @@ static inline u32 mvpp2_cpu_to_thread(struct mvpp2 *priv, int cpu)
 	return cpu % priv->nthreads;
 }
 
+static inline
+void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data)
+{
+	writel(data, priv->cm3_base + offset);
+}
+
+static inline
+u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset)
+{
+	return readl(priv->cm3_base + offset);
+}
+
 static struct page_pool *
 mvpp2_create_page_pool(struct device *dev, int num, int len,
 		       enum dma_data_direction dma_dir)
@@ -6846,6 +6859,41 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	return 0;
 }
 
+static int mvpp2_get_sram(struct platform_device *pdev,
+			  struct mvpp2 *priv)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	static bool defer_once;
+	struct resource *res;
+
+	if (has_acpi_companion(&pdev->dev)) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		if (!res) {
+			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
+			return 0;
+		}
+		priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(priv->cm3_base))
+			return PTR_ERR(priv->cm3_base);
+	} else {
+		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
+		if (!priv->sram_pool) {
+			if (!defer_once) {
+				defer_once = true;
+				/* Try defer once */
+				return -EPROBE_DEFER;
+			}
+			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
+			return -ENOMEM;
+		}
+		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
+								MSS_SRAM_SIZE);
+		if (!priv->cm3_base)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static int mvpp2_probe(struct platform_device *pdev)
 {
 	const struct acpi_device_id *acpi_id;
@@ -6902,6 +6950,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(priv->iface_base))
 			return PTR_ERR(priv->iface_base);
+
+		/* Map CM3 SRAM */
+		err = mvpp2_get_sram(pdev, priv);
+		if (err == -EPROBE_DEFER)
+			return err;
+		else if (err)
+			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
 	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
@@ -6947,11 +7002,13 @@ static int mvpp2_probe(struct platform_device *pdev)
 
 	if (dev_of_node(&pdev->dev)) {
 		priv->pp_clk = devm_clk_get(&pdev->dev, "pp_clk");
-		if (IS_ERR(priv->pp_clk))
-			return PTR_ERR(priv->pp_clk);
+		if (IS_ERR(priv->pp_clk)) {
+			err = PTR_ERR(priv->pp_clk);
+			goto err_cm3;
+		}
 		err = clk_prepare_enable(priv->pp_clk);
 		if (err < 0)
-			return err;
+			goto err_cm3;
 
 		priv->gop_clk = devm_clk_get(&pdev->dev, "gop_clk");
 		if (IS_ERR(priv->gop_clk)) {
@@ -7087,6 +7144,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->gop_clk);
 err_pp_clk:
 	clk_disable_unprepare(priv->pp_clk);
+err_cm3:
+	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base)
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+
 	return err;
 }
 
@@ -7127,6 +7189,12 @@ static int mvpp2_remove(struct platform_device *pdev)
 				  aggr_txq->descs_dma);
 	}
 
+	if (!has_acpi_companion(&pdev->dev) && priv->cm3_base) {
+		gen_pool_free(priv->sram_pool, (unsigned long)priv->cm3_base,
+			      MSS_SRAM_SIZE);
+		gen_pool_destroy(priv->sram_pool);
+	}
+
 	if (is_acpi_node(port_fwnode))
 		return 0;
 
-- 
1.9.1

