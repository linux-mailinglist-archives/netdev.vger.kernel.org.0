Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF379311ED4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhBFQuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:50:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230470AbhBFQst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:48:49 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GixS0021712;
        Sat, 6 Feb 2021 08:48:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=7LwR1nLKUpv51GM9JH6RPwo2xhMdAQWWEf6bm82cJYo=;
 b=E7KYQz/8CW6SGQtnTNxVZmDDUXP+C66kBbnmcXPo5SjG8nWl5z5QPlrx6iuqyuQCW2pg
 MiR1CGHM7GKYfwzmFqAxi7GJU1sXeF0KsmfdqloZSxAFVgO6oVbEaxlL20e02PItTS24
 fMkdY5BTVvp1RdsZEXH6rRE1EcSq7qT63S+ymJzF9DGqXA2sLPf5ybcRLRF3QClNiz7w
 BVsbVK1aRw+dyD044QBsC7bDMTKegpcKvzAUBfOAeV9hGod4Y0pMzMXbclkn59xteZLv
 aGFKsMoEVXcrOnPDgRnq6NAWAyRJ+nt3wWy7rAAbAjKMqKD8q38awcUkZaj5ssTHMlxV xA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbr8gvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:48:00 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:47:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:47:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:47:58 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 713B33F703F;
        Sat,  6 Feb 2021 08:47:55 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 12/15] net: mvpp2: add BM protection underrun feature support
Date:   Sat, 6 Feb 2021 18:45:58 +0200
Message-ID: <1612629961-11583-13-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
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
index 9071ab6..1967493 100644
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
index 5d80c5e..e41b173 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -70,6 +70,11 @@ enum mvpp2_bm_pool_log_num {
 module_param(queue_mode, int, 0444);
 MODULE_PARM_DESC(queue_mode, "Set queue_mode (single=0, multi=1)");
 
+static int bm_underrun_protect = 1;
+
+module_param(bm_underrun_protect, int, 0444);
+MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect feature (0-1), def=1");
+
 /* Utility/helper methods */
 
 void mvpp2_write(struct mvpp2 *priv, u32 offset, u32 data)
@@ -424,6 +429,21 @@ static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 
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
@@ -592,6 +612,16 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
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
@@ -645,6 +675,9 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 	if (!priv->bm_pools)
 		return -ENOMEM;
 
+	if (priv->hw_version == MVPP23 && bm_underrun_protect)
+		mvpp23_bm_set_8pool_mode(priv);
+
 	err = mvpp2_bm_pools_init(dev, priv);
 	if (err < 0)
 		return err;
@@ -6491,7 +6524,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			     val);
 	}
 
-	if (port->priv->global_tx_fc) {
+	if (port->priv->global_tx_fc && bm_underrun_protect) {
 		port->tx_fc = tx_pause;
 		if (tx_pause)
 			mvpp2_rxq_enable_fc(port);
-- 
1.9.1

