Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA43126C0
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBGSlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:41:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9983 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhBGSk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:40:57 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117ITVqg027003;
        Sun, 7 Feb 2021 10:40:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yiE2ADaG2u4SWFtFQYQcMMzcQhr3YAXBFzh91k7yIkc=;
 b=KpenzF3RFf8E462oUChh3R6TwV2sRxMgwwYbODGf2YEhHoNNnSo6epP/lKpM+1Y9RWdi
 gilNH9GHZCOY1D5NKmpKtsGmEd5bsvjn5cn3qb6rAjJq6rcc3zpCPUhQcRw2Oou8a97K
 0pNj9DAU7cT/wCxdIJDs9KawuBWozhPY8gnKqJTQZjKmZ1dfTRZ1kQXGjn6QFzXwv7sq
 DvtKY/9aHGNLjMPNNUylyObLwAa3lmk0Yr8VKbkthorNq8hPigYKrEcrhyr8G28QHpUX
 q1bkCPXNM8tWVtPdwQ6C+0GKpEaFP8EnfYyB9jIaLp6kaktXtmWvBdsfOIdS6evjUCPY iQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq2etm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:40:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:40:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 7 Feb 2021 10:40:05 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 115AE3F703F;
        Sun,  7 Feb 2021 10:40:00 -0800 (PST)
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
Subject: [PATCH v9 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
Date:   Sun, 7 Feb 2021 20:38:45 +0200
Message-ID: <1612723137-18045-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
References: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_10:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds CM3 memory map and CM3 read/write callbacks.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..56e90ab 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -925,6 +925,7 @@ struct mvpp2 {
 	/* Shared registers' base addresses */
 	void __iomem *lms_base;
 	void __iomem *iface_base;
+	void __iomem *cm3_base;
 
 	/* On PPv2.2, each "software thread" can access the base
 	 * register through a separate address space, each 64 KB apart
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a07cf60..eec3796 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6846,6 +6846,27 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	return 0;
 }
 
+static int mvpp2_get_sram(struct platform_device *pdev,
+			  struct mvpp2 *priv)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (!res) {
+		if (has_acpi_companion(&pdev->dev))
+			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
+		else
+			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
+		return 0;
+	}
+
+	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->cm3_base))
+		return PTR_ERR(priv->cm3_base);
+
+	return 0;
+}
+
 static int mvpp2_probe(struct platform_device *pdev)
 {
 	const struct acpi_device_id *acpi_id;
@@ -6902,6 +6923,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(priv->iface_base))
 			return PTR_ERR(priv->iface_base);
+
+		/* Map CM3 SRAM */
+		err = mvpp2_get_sram(pdev, priv);
+		if (err)
+			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
 	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
-- 
1.9.1

