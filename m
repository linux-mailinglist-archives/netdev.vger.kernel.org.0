Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABFB2F0813
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbhAJPec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:34:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28048 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727146AbhAJPe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFVfCY027504;
        Sun, 10 Jan 2021 07:31:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dyE9/YLwb59fQB2E0aL4PmAk5pyAo0YARj4Q1ONvHw4=;
 b=gzokaJFze0e+GUBv2cKu9FFJAOEJUU4+OiwzUCGRy/d/6L0sw3HIMoLxf2qNVcJMM40t
 Ah+udlgyAa5YhLqitc61IkxlGvTytH0N8hUd8L6xt52KSLaiagtEbQa94xKGQFXOPqda
 +3+y8rzVTzhDv1/GQ5vCGwNzg/VfFYffQZOBgUAPD2hio9Anv5BNrvHFQqcOfB7v2Rza
 nQSRp0uiAQL5rJvEaUrHwJt+nHqZ9YCSSCIsdIUMeA3da54KVKvwQ4gXESOhD9sqf/lc
 HDi8dkyL0SLSzSUndbH1YHHw0CEGoGKpvEX0CSi5MD5LvEFIa/f/Z4rjy4GozlWdZWYS pg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsj5g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:41 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:31:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:31:39 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C5B633F7041;
        Sun, 10 Jan 2021 07:31:36 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  12/19] net: mvpp2: enable global flow control
Date:   Sun, 10 Jan 2021 17:30:16 +0200
Message-ID: <1610292623-15564-13-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch enable global flow control in FW.
Per port flow control is still disabled.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  3 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 0ba0598..e6bab52 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1065,6 +1065,9 @@ struct mvpp2 {
 	/* CM3 SRAM pool */
 	struct gen_pool *sram_pool;
 
+	/* Global TX Flow Control config */
+	bool global_tx_fc;
+
 	bool custom_dma_mask;
 
 	/* Spinlocks for CM3 shared memory configuration */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 19648c4..b7ea94f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7142,7 +7142,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int i, shared;
-	int err;
+	int err, val;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -7194,6 +7194,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 		err = mvpp2_get_sram(pdev, priv);
 		if (err)
 			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
+
+		/* Enable global Flow Control only if hanler to SRAM not NULL */
+		if (priv->cm3_base)
+			priv->global_tx_fc = true;
 	}
 
 	if (priv->hw_version != MVPP21 && dev_of_node(&pdev->dev)) {
@@ -7364,6 +7368,15 @@ static int mvpp2_probe(struct platform_device *pdev)
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

