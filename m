Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C513188F3
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhBKLBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:01:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231288AbhBKKyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:54:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BApK5g017036;
        Thu, 11 Feb 2021 02:53:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kibyRIO/feslyfagTjuGXg398CY47q8XHSH9+KaIMgY=;
 b=g9gHAWV5Zh+8QflOFw2EUxqJ+7CKh+6op3b9i/Cg6VFD+YKW1QQEObN31nz2r+oJlLV3
 kREFH3aZ9AXF92j1IP6s8/CYreurrscWq2SMixhOVy7XiHKPCqJO4XlW4VjCtdth9IzZ
 WBwQ8KDuOecMdgfFZy2OmWC/+8nJkMMMe2zsQDlILe9dfoP6LOpYihw2VW3LlFUHAgoS
 0g3cgd6pmOOesxtS1/gG/diBHWA6WggOXFW5a1IL19+UoLHtZeH5NXqL3nmusFM0l9mL
 iZLyEHGQ/u/AxOX/4bP+mLCNhVPKdV5MJSK9plPyD9mr/gcxdwYAxJydAzncw6xahdjj Iw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqefgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 02:53:28 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:53:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 02:53:26 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 85F793F703F;
        Thu, 11 Feb 2021 02:53:22 -0800 (PST)
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
Subject: [PATCH v13 net-next 12/15] net: mvpp2: add BM protection underrun feature support
Date:   Thu, 11 Feb 2021 12:48:59 +0200
Message-ID: <1613040542-16500-13-git-send-email-stefanc@marvell.com>
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

The PP2v23 hardware supports a feature allowing to double the
size of BPPI by decreasing number of pools from 16 to 8.
Increasing of BPPI size protect BM drop from BPPI underrun.
Underrun could occurred due to stress on DDR and as result slow buffer
transition from BPPE to BPPI.
New BPPI threshold recommended by spec is:
BPPI low threshold - 640 buffers
BPPI high threshold - 832 buffers
Supported only in PPv23.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  8 ++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 ++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 0731dc7..9b525b60 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -324,6 +324,10 @@
 #define     MVPP2_BM_HIGH_THRESH_MASK		0x7f0000
 #define     MVPP2_BM_HIGH_THRESH_VALUE(val)	((val) << \
 						MVPP2_BM_HIGH_THRESH_OFFS)
+#define     MVPP2_BM_BPPI_HIGH_THRESH		0x1E
+#define     MVPP2_BM_BPPI_LOW_THRESH		0x1C
+#define     MVPP23_BM_BPPI_HIGH_THRESH		0x34
+#define     MVPP23_BM_BPPI_LOW_THRESH		0x28
 #define MVPP2_BM_INTR_CAUSE_REG(pool)		(0x6240 + ((pool) * 4))
 #define     MVPP2_BM_RELEASED_DELAY_MASK	BIT(0)
 #define     MVPP2_BM_ALLOC_FAILED_MASK		BIT(1)
@@ -352,6 +356,10 @@
 #define MVPP2_OVERRUN_ETH_DROP			0x7000
 #define MVPP2_CLS_ETH_DROP			0x7020
 
+#define MVPP22_BM_POOL_BASE_ADDR_HIGH_REG	0x6310
+#define     MVPP22_BM_POOL_BASE_ADDR_HIGH_MASK	0xff
+#define     MVPP23_BM_8POOL_MODE		BIT(8)
+
 /* Hit counters registers */
 #define MVPP2_CTRS_IDX				0x7040
 #define     MVPP22_CTRS_TX_CTR(port, txq)	((txq) | ((port) << 3) | BIT(7))
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 90c9265..9226d2f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -423,6 +423,19 @@ static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 
 	val = mvpp2_read(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id));
 	val |= MVPP2_BM_START_MASK;
+
+	val &= ~MVPP2_BM_LOW_THRESH_MASK;
+	val &= ~MVPP2_BM_HIGH_THRESH_MASK;
+
+	/* Set 8 Pools BPPI threshold for MVPP23 */
+	if (priv->hw_version == MVPP23) {
+		val |= MVPP2_BM_LOW_THRESH_VALUE(MVPP23_BM_BPPI_LOW_THRESH);
+		val |= MVPP2_BM_HIGH_THRESH_VALUE(MVPP23_BM_BPPI_HIGH_THRESH);
+	} else {
+		val |= MVPP2_BM_LOW_THRESH_VALUE(MVPP2_BM_BPPI_LOW_THRESH);
+		val |= MVPP2_BM_HIGH_THRESH_VALUE(MVPP2_BM_BPPI_HIGH_THRESH);
+	}
+
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
 	bm_pool->size = size;
@@ -591,6 +604,16 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 	return err;
 }
 
+/* Routine enable PPv23 8 pool mode */
+static void mvpp23_bm_set_8pool_mode(struct mvpp2 *priv)
+{
+	int val;
+
+	val = mvpp2_read(priv, MVPP22_BM_POOL_BASE_ADDR_HIGH_REG);
+	val |= MVPP23_BM_8POOL_MODE;
+	mvpp2_write(priv, MVPP22_BM_POOL_BASE_ADDR_HIGH_REG, val);
+}
+
 static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
 	enum dma_data_direction dma_dir = DMA_FROM_DEVICE;
@@ -644,6 +667,9 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 	if (!priv->bm_pools)
 		return -ENOMEM;
 
+	if (priv->hw_version == MVPP23)
+		mvpp23_bm_set_8pool_mode(priv);
+
 	err = mvpp2_bm_pools_init(dev, priv);
 	if (err < 0)
 		return err;
-- 
1.9.1

