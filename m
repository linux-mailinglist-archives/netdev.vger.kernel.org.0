Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C53C314AD3
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhBIIuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:50:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3666 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhBIIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:47:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1198jcr6027043;
        Tue, 9 Feb 2021 00:46:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ONxyPelp9fH1mkghm338rZTKOjU3yNemu45/C3nD9qQ=;
 b=RhwAsI2LAnUAUHGRBquUS3Yzs8rwpU9ez0WJMlTBXGRaoQj6cWliQAvt2Ld3LGUbBU3U
 onXIcs1Jc96TlMXUe8PFY1OydfqCaGQieM8GsSn2QIlI4zFVUAKSaBzbLvJHStbWma13
 vuy+NWq0sTz5p/E6oyHfYmQJamR4HOPxxIlTc8HcpXl0x/n1ZorQO7QHdh0HoPNn/nt7
 96nLe/jGitmHlT39/Miyhj6dS4OP/W0u1p0Hhc5UdF8ws89gUUmyh8o9o0bmrYkXbCcM
 CSfaYiS609LEnvVHOJ8MF3vOyfJuqm0FwJQFTAcbF4M1zD+RD623InNbSvqdOZvY56MW Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq7m73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 00:46:32 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 00:46:30 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 00:46:30 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 0D1483F703F;
        Tue,  9 Feb 2021 00:46:25 -0800 (PST)
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
Subject: [PATCH v11 net-next 12/15] net: mvpp2: add BM protection underrun feature support
Date:   Tue, 9 Feb 2021 10:42:28 +0200
Message-ID: <1612860151-12275-13-git-send-email-stefanc@marvell.com>
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
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  8 +++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 35 +++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

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
index 90c9265..3faad04 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -69,6 +69,11 @@ enum mvpp2_bm_pool_log_num {
 module_param(queue_mode, int, 0444);
 MODULE_PARM_DESC(queue_mode, "Set queue_mode (single=0, multi=1)");
 
+static int bm_underrun_protect = 1;
+
+module_param(bm_underrun_protect, int, 0444);
+MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect feature (0-1), def=1");
+
 /* Utility/helper methods */
 
 void mvpp2_write(struct mvpp2 *priv, u32 offset, u32 data)
@@ -423,6 +428,21 @@ static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 
 	val = mvpp2_read(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id));
 	val |= MVPP2_BM_START_MASK;
+
+	val &= ~MVPP2_BM_LOW_THRESH_MASK;
+	val &= ~MVPP2_BM_HIGH_THRESH_MASK;
+
+	/* Set 8 Pools BPPI threshold if BM underrun protection feature
+	 * was enabled
+	 */
+	if (priv->hw_version == MVPP23 && bm_underrun_protect) {
+		val |= MVPP2_BM_LOW_THRESH_VALUE(MVPP23_BM_BPPI_LOW_THRESH);
+		val |= MVPP2_BM_HIGH_THRESH_VALUE(MVPP23_BM_BPPI_HIGH_THRESH);
+	} else {
+		val |= MVPP2_BM_LOW_THRESH_VALUE(MVPP2_BM_BPPI_LOW_THRESH);
+		val |= MVPP2_BM_HIGH_THRESH_VALUE(MVPP2_BM_BPPI_HIGH_THRESH);
+	}
+
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
 	bm_pool->size = size;
@@ -591,6 +611,16 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
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
@@ -644,6 +674,9 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 	if (!priv->bm_pools)
 		return -ENOMEM;
 
+	if (priv->hw_version == MVPP23 && bm_underrun_protect)
+		mvpp23_bm_set_8pool_mode(priv);
+
 	err = mvpp2_bm_pools_init(dev, priv);
 	if (err < 0)
 		return err;
@@ -6490,7 +6523,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			     val);
 	}
 
-	if (port->priv->global_tx_fc) {
+	if (port->priv->global_tx_fc && bm_underrun_protect) {
 		port->tx_fc = tx_pause;
 		if (tx_pause)
 			mvpp2_rxq_enable_fc(port);
-- 
1.9.1

