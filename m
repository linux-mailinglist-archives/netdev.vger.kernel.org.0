Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7BF301BA0
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbhAXL4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:56:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726673AbhAXLsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:48:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBjOoF026994;
        Sun, 24 Jan 2021 03:45:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n8W04+vO8Fw+RA4LWhAUrPFhh2JTUBvs9YjycUemky0=;
 b=TuUI+F15L2tKsWhmRdTF8PP6akyMHyAfJeW2iL631kwOwm62jj/IyL06OMSlkAJsZuM2
 bQQYP5oRhGjfxJC8AF7R9M40sPQot17vwkrbApl7NnlWAUXrE4w1Je7z/gYWGxWJ9kHV
 Md/6pQrpOJPRKKyPaobHoKAKeio2wGHeexpJ3oSbmKfMYecASmwvAn+05LBgbIuorhPm
 5bt24TmURudgaMLC478d8t344cFMPXY73NT7u7Z0H2k2N2NlWkLSylyXJtM86fIMn50W
 Uqm1xEaQUBenn+96NeAhtky+W5G5s9lpqepMBxzJRikaszimSFIcDZB5UF+aIzsCOK3a 9Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9sug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:45:33 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:45:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:45:31 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 7A4113F7040;
        Sun, 24 Jan 2021 03:45:28 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v2 RFC net-next 14/18] net: mvpp2: add BM protection underrun feature support
Date:   Sun, 24 Jan 2021 13:44:03 +0200
Message-ID: <1611488647-12478-15-git-send-email-stefanc@marvell.com>
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

Feature double size of BPPI by decreasing number of pools from 16 to 8.
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
index feac64c..1db8245 100644
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
index 20157b5..da387dd2 100644
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
@@ -426,6 +431,21 @@ static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 
 	val = mvpp2_read(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id));
 	val |= MVPP2_BM_START_MASK;
+
+	val &= ~MVPP2_BM_LOW_THRESH_MASK;
+	val &= ~MVPP2_BM_HIGH_THRESH_MASK;
+
+	/* Set 8 Pools BPPI threshold if BM underrun protection feature
+	 * were enabled
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
@@ -594,6 +614,16 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
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
@@ -647,6 +677,9 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
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
 
-	if (tx_pause && port->priv->global_tx_fc) {
+	if (tx_pause && port->priv->global_tx_fc && bm_underrun_protect) {
 		port->tx_fc = true;
 		mvpp2_rxq_enable_fc(port);
 		if (port->priv->percpu_pools) {
-- 
1.9.1

