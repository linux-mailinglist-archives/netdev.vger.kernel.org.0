Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B01E301BA8
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbhAXL5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:57:38 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17044 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbhAXLsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:48:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBjOoD026994;
        Sun, 24 Jan 2021 03:45:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Q96hOwPqU63A3G1H507m5q7P0IFcr56pYkxUBYlKrT0=;
 b=GJl0o6r9ZOzBYpyg+nArvkkP7Uxv/myjtH+fP5RSpLcaVDGxd+440NlE/zlC1/3mz7F1
 JL3qcoPx8rpymrLgQkWLnum+pK2OdTVFWb7p31LGa3yVU5HxkkC9ZmibgEx4mxv+TMKO
 It2TfoEwSjKv8dxMpbVOHOyEAPxKfJYPYnZHLsOEiJ8CkFBPJ1OFKEZ8O9fjfR2llcQu
 gzexS48aJR0YY3YWPot2kUC+FMEbki0NuZsvsC0vDwTqLYLF42SBrwjSKaFEYxcGZhS1
 1SawL+KstxCtHD9kmMi7gn3mqRdKJt2Su3Qe03v8mqsM99DpZOW1yLhM8yUBvEtbw/6O /w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9su5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:45:24 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:21 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:21 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:45:21 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 5505F3F7040;
        Sun, 24 Jan 2021 03:45:18 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 11/18] net: mvpp2: enable global flow control
Date:   Sun, 24 Jan 2021 13:44:00 +0200
Message-ID: <1611488647-12478-12-git-send-email-stefanc@marvell.com>
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

This patch enables global flow control in FW and in the phylink validate mask.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 20 +++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4d58af6..4c8e422 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1022,6 +1022,9 @@ struct mvpp2 {
 	/* CM3 SRAM pool */
 	struct gen_pool *sram_pool;
 
+	/* Global TX Flow Control config */
+	bool global_tx_fc;
+
 	bool custom_dma_mask;
 
 	/* Spinlocks for CM3 shared memory configuration */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 32c79c50..d79c687 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5962,6 +5962,11 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
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
@@ -6977,7 +6982,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err;
+	int err, val;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7031,6 +7036,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 			return err;
 		else if (err)
 			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
+
+		/* Enable global Flow Control only if handler to SRAM not NULL */
+		if (priv->cm3_base)
+			priv->global_tx_fc = true;
 	}
 
 	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
@@ -7201,6 +7210,15 @@ static int mvpp2_probe(struct platform_device *pdev)
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

