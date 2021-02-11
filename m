Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4BE3188DE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBKK6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:58:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhBKKx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:53:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BAp92k017018;
        Thu, 11 Feb 2021 02:52:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LFmWAGrCTplhOpuuVqILtSG/sVDzY79lqHAVlQuN2pg=;
 b=kl6iV/WcznYiUeC1yRVr1K+t24hy0UAJTkcTzddCQfS+nFAkA0sWKhRJv/HhZHvYtUl+
 Vylb1J1Rf2qPyE50d3Yme/+4ckKGJxYk+E+9YwbFsIDStuiOYK2EXxoCtK6NfUx5PAGd
 q5cGdRPVc6O38xqQD48qkqPvlgO4mOmvo5gX0Y74lSMgJp+rW8tqx/TISUZRjUo35VKk
 CG8KKn7e8xUn21kMrhwOBBcGqLr2jFRHcuFbExzu/ClcRTTRo+Ye31mL7aOyXIJsh/D6
 DKWriTvqYzYVoodOG8W0W1f90x4enIhe8a1SVSJW9FXVZS40kxm1UIpj2YjAb9FmGOr3 mQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqeff1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 02:52:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:52:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 02:52:41 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id C68F33F703F;
        Thu, 11 Feb 2021 02:52:37 -0800 (PST)
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
Subject: [PATCH v13 net-next 09/15] net: mvpp2: enable global flow control
Date:   Thu, 11 Feb 2021 12:48:56 +0200
Message-ID: <1613040542-16500-10-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch enables global flow control in FW and in the phylink validate mask.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
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

