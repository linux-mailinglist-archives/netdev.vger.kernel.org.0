Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2B2ADAB1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgKJPna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:43:30 -0500
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:65377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730681AbgKJPn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:43:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B81QCyE21MYhcoXl7y00Rnu3QFDCkDh8jw8XGSjoNBSKiQGpO6jxtRmn7SFG3eUXVfe9pPL8uKU2dzThabmdIhwlIoEfgpjuiAyDzkyLfxTo5K4V3nVek35eZj8nXmy0ahfvUugmXeRetGZIFx8gn5Sz/B/eYLFNDYGAGsjNEKcMFjrI2v37LAr+Tk0ymbLDWpcufCHif27Sm6qcF/GftxColNHiWu4g4rE0uKdQ1FJW7yGVe6AvMRxEVjpk82lZTYjm0ZTwdl/80YiyKnrgjQq08b3+iRDoP2uMzGZcoUQ0yrmgUux2se2cHsRBP2emRc4l4GlwSZiiiiBqQxzwcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVuo2/DLRliHqB2FVm08WtlC8IFPi3t+6j7YyKqUJrg=;
 b=ls1eg8EL3n/ArivG4upulcnDfeV9tgSoEE7jXPvT0ISdW2+AZbn/JJ6OZ6gUcHghglwZybA+HRVWLm3KuAlHxAzZzhg+wbv0ayCIAWrV/vvhks5oDQMViutmFTaQIgNoo21rb7IUNh0tM68BKOni0xXb6jIVW1zHGwq2gWj8xmnbH9Ah+0tqnMkicWTv6cY/TQDRD3tkCDGDFemeTJSbHJnFcSqPVxIu09E+XvKdvaobQ58nxR8Ct3k0bmMrzcLlsDBmapcKUnQ3SGuYxwFao+QPuMkcMMGVyYu+R8rWc2Os2W1BpuU9MtKyV/ANSpOTnBHNl4L3wuGC8XY4OYGmAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVuo2/DLRliHqB2FVm08WtlC8IFPi3t+6j7YyKqUJrg=;
 b=UfIUz/Na+xl7zGpAuq8q7jw7nY5m9KMIQGLbOTNfOgNhhrf2PbSQlrv1jyGv+6N30XjMWYi4XRnxB5HVRuNciwq1zN7KNzkh8Vx6MVtOGzXcrpo4mBY0RVWm686y63m68MOW1mWNB8Spxni05NcVy4xxsmuTBdXzfu6lxOGGBu0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3506.eurprd04.prod.outlook.com (2603:10a6:208:17::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 15:43:24 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 15:43:24 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] enetc: Workaround for MDIO register access issue
Date:   Tue, 10 Nov 2020 17:43:04 +0200
Message-Id: <20201110154304.30871-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR03CA0053.eurprd03.prod.outlook.com
 (2603:10a6:207:5::11) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR03CA0053.eurprd03.prod.outlook.com (2603:10a6:207:5::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 15:43:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 514fed6b-3684-4d4c-825b-08d8858f5c26
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3506:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB350631B4B99434F087CC20B696E90@AM0PR0402MB3506.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftta4bctx1+U3FnA0xp4Rn16/ZKuqMUmU+QLUmE0Z4uUUiZt9zNqZ8WoelM0nvdR7i2yTZ5wuMw633TA37R95aEBCdqKyoGEgP27SGdTgmUyV24Sk2SriROd+WIjTsGsrp0uVuSGYR1HunK64kr9duMHpurIRYnMfkovlOkP0fGT3vzxfQ93ppojc06gnttVsUFjq3AnoSlSJwfTMIIn+Qtq/JT5mzeeMYgJfu4PRKyantHtfpZ896MCgyVb5JUBmkPv89k2nilPLkVQzxfSZUgjFX2fZP1LvuYMdp0lCIAdSc8RwUAfObbLEcSnwgLhCUHtvPGkBQmuZcM6TLGNFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39850400004)(346002)(376002)(44832011)(1076003)(66946007)(66476007)(8676002)(2906002)(66556008)(478600001)(36756003)(5660300002)(956004)(16526019)(30864003)(54906003)(4326008)(6916009)(6666004)(316002)(186003)(52116002)(26005)(2616005)(86362001)(7696005)(83380400001)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HsInnYj8dhido4munlCEvjWACkJJ5BXNPRz+VoocTvRqBKLuj5ghp0ctsq31+CCL5Iyjb7ARM48+ZZF6dCVNRiqjDKyfSvVOQKOCh8KZki+cqQHw7snHScWwDYJtck4pbncyjfAe3TBPQ6cPQmoD93+ILvUWdVeiW2+Diaijng2du7E7Odmw0TqECcjTRAXa/EVkNMaW6eiNP2gs+entzMo1xiArjy4Wg+bQXRp2c/wjfCM1jAl71jkYOK+KIW+6gPtElvUjWJIqosBhjwsUIwL9pV9cmzrbPCKQoUWYDUerpbjH1CQSYAAX8aJNQFgQKZVyRQUfYE7b08q6EmyzuzHC2Nxu0dGC7YGRBkZW381bStdJR/l1gudJu3SrqyMCWoVeXn+Bkl55MSK8mx+cVLmyT33oGs3vEy7MU1jlp2vYug7M7t2UFWYCa0vMv2JSRzGrhgNWKmLrhOXPMejwlbmNy8B+i7KMc3mTFzYkX2PV4rphPNAW441HoroMP4kbp181woaVqTQQtoy/k+HhhKTfc7lwso7uJPmY9O8VBAdoLDLIH83W6N3/0MS4uOczBt1OMwr0n5ICYP33c8g95nq4mGJmi7BOoLjtVZU4Ls6xSMYj5uQh3L/eNNy7J0ULbnJV07C+dMIW+L+nzuk4Pg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514fed6b-3684-4d4c-825b-08d8858f5c26
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 15:43:24.8528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzKqtTq15EkYnC5JCgX0HedECyAr+89UkJ32f9eXYRpIVCvyzEraXV/m709CZArahmdtVkXOB1CbEbRNP9KybQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

Due to a hardware issue, an access to MDIO registers
that is concurrent with other ENETC register accesses
may lead to the MDIO access being dropped or corrupted.
The workaround introduces locking for all register accesses
to the ENETC register space.  To reduce performance impact,
a readers-writers locking scheme has been implemented.
The writer in this case is the MDIO access code (irrelevant
whether that MDIO access is a register read or write), and
the reader is any access code to non-MDIO ENETC registers.
Also, the datapath functions acquire the read lock fewer times
and use _hot accessors.  All the rest of the code uses the _wa
accessors which lock every register access.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  |  1 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 60 ++++++++++++++-----
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 60 +++++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_mdio.c |  8 ++-
 4 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 0fa18b00c49b..d99ea0f4e4a6 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -16,6 +16,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI
+	select FSL_ENETC_MDIO
 	select PHYLINK
 	select DIMLIB
 	help
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 01089c30b462..83ab8e5d691b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -33,7 +33,10 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 
+	read_lock(&enetc_mdio_lock);
 	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
+	read_unlock(&enetc_mdio_lock);
+
 	if (unlikely(!count))
 		goto drop_packet_err;
 
@@ -199,7 +202,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	skb_tx_timestamp(skb);
 
 	/* let H/W know BD ring has been updated */
-	enetc_wr_reg(tx_ring->tpir, i); /* includes wmb() */
+	enetc_wr_reg_hot(tx_ring->tpir, i); /* includes wmb() */
 
 	return count;
 
@@ -222,12 +225,16 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	struct enetc_int_vector	*v = data;
 	int i;
 
+	read_lock(&enetc_mdio_lock);
+
 	/* disable interrupts */
-	enetc_wr_reg(v->rbier, 0);
-	enetc_wr_reg(v->ricr1, v->rx_ictt);
+	enetc_wr_reg_hot(v->rbier, 0);
+	enetc_wr_reg_hot(v->ricr1, v->rx_ictt);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i), 0);
+
+	read_unlock(&enetc_mdio_lock);
 
 	napi_schedule(&v->napi);
 
@@ -294,19 +301,23 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 
 	v->rx_napi_work = false;
 
+	read_lock(&enetc_mdio_lock);
+
 	/* enable interrupts */
-	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
+	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
-			     ENETC_TBIER_TXTIE);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i),
+				 ENETC_TBIER_TXTIE);
+
+	read_unlock(&enetc_mdio_lock);
 
 	return work_done;
 }
 
 static int enetc_bd_ready_count(struct enetc_bdr *tx_ring, int ci)
 {
-	int pi = enetc_rd_reg(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
+	int pi = enetc_rd_reg_hot(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
 
 	return pi >= ci ? pi - ci : tx_ring->bd_count - ci + pi;
 }
@@ -346,7 +357,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 	i = tx_ring->next_to_clean;
 	tx_swbd = &tx_ring->tx_swbd[i];
+
+	read_lock(&enetc_mdio_lock);
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+	read_unlock(&enetc_mdio_lock);
 
 	do_tstamp = false;
 
@@ -389,16 +403,20 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			tx_swbd = tx_ring->tx_swbd;
 		}
 
+		read_lock(&enetc_mdio_lock);
+
 		/* BD iteration loop end */
 		if (is_eof) {
 			tx_frm_cnt++;
 			/* re-arm interrupt source */
-			enetc_wr_reg(tx_ring->idr, BIT(tx_ring->index) |
-				     BIT(16 + tx_ring->index));
+			enetc_wr_reg_hot(tx_ring->idr, BIT(tx_ring->index) |
+					 BIT(16 + tx_ring->index));
 		}
 
 		if (unlikely(!bds_to_clean))
 			bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+
+		read_unlock(&enetc_mdio_lock);
 	}
 
 	tx_ring->next_to_clean = i;
@@ -476,13 +494,14 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 		rx_ring->next_to_alloc = i; /* keep track from page reuse */
 		rx_ring->next_to_use = i;
 		/* update ENETC's consumer index */
-		enetc_wr_reg(rx_ring->rcir, i);
+		enetc_wr_reg_hot(rx_ring->rcir, i);
 	}
 
 	return j;
 }
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
+/* Must be called with the read-side enetc_mdio_lock held */
 static void enetc_get_rx_tstamp(struct net_device *ndev,
 				union enetc_rx_bd *rxbd,
 				struct sk_buff *skb)
@@ -494,8 +513,8 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 	u64 tstamp;
 
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TSTMP) {
-		lo = enetc_rd(hw, ENETC_SICTR0);
-		hi = enetc_rd(hw, ENETC_SICTR1);
+		lo = enetc_rd_reg_hot(hw->reg + ENETC_SICTR0);
+		hi = enetc_rd_reg_hot(hw->reg + ENETC_SICTR1);
 		rxbd = enetc_rxbd_ext(rxbd);
 		tstamp_lo = le32_to_cpu(rxbd->ext.tstamp);
 		if (lo <= tstamp_lo)
@@ -644,6 +663,8 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		u32 bd_status;
 		u16 size;
 
+		read_lock(&enetc_mdio_lock);
+
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
 			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
 
@@ -652,15 +673,19 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
-		if (!bd_status)
+		if (!bd_status) {
+			read_unlock(&enetc_mdio_lock);
 			break;
+		}
 
-		enetc_wr_reg(rx_ring->idr, BIT(rx_ring->index));
+		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
-		if (!skb)
+		if (!skb) {
+			read_unlock(&enetc_mdio_lock);
 			break;
+		}
 
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
@@ -672,6 +697,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
+			read_unlock(&enetc_mdio_lock);
 			dev_kfree_skb(skb);
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
@@ -711,6 +737,8 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		enetc_process_skb(rx_ring, skb);
 
+		read_unlock(&enetc_mdio_lock);
+
 		napi_gro_receive(napi, skb);
 
 		rx_frm_cnt++;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 68ef4f959982..95cb4fc30fbf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -325,8 +325,15 @@ struct enetc_hw {
 };
 
 /* general register accessors */
-#define enetc_rd_reg(reg)	ioread32((reg))
-#define enetc_wr_reg(reg, val)	iowrite32((val), (reg))
+#define enetc_rd_reg(reg)	enetc_rd_reg_wa((reg))
+#define enetc_wr_reg(reg, val)	enetc_wr_reg_wa((reg), (val))
+
+/* accessors for data-path, due to MDIO issue on LS1028 these should be called
+ * only under the rwlock_t enetc_mdio_lock
+ */
+#define enetc_rd_reg_hot(reg)	ioread32((reg))
+#define enetc_wr_reg_hot(reg, val)	iowrite32((val), (reg))
+
 #ifdef ioread64
 #define enetc_rd_reg64(reg)	ioread64((reg))
 #else
@@ -345,12 +352,57 @@ static inline u64 enetc_rd_reg64(void __iomem *reg)
 }
 #endif
 
+extern rwlock_t enetc_mdio_lock;
+
+static inline u32 enetc_rd_reg_wa(void *reg)
+{
+	u32 val;
+
+	read_lock(&enetc_mdio_lock);
+	val = ioread32(reg);
+	read_unlock(&enetc_mdio_lock);
+
+	return val;
+}
+
+static inline void enetc_wr_reg_wa(void *reg, u32 val)
+{
+	read_lock(&enetc_mdio_lock);
+	iowrite32(val, reg);
+	read_unlock(&enetc_mdio_lock);
+}
+
+static inline u32 enetc_rd_reg_wa_single(void *reg)
+{
+	unsigned long flags;
+	u32 val;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	val = ioread32(reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+
+	return val;
+}
+
+static inline void enetc_wr_reg_wa_single(void *reg, u32 val)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	iowrite32(val, reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+}
+
 #define enetc_rd(hw, off)		enetc_rd_reg((hw)->reg + (off))
 #define enetc_wr(hw, off, val)		enetc_wr_reg((hw)->reg + (off), val)
 #define enetc_rd64(hw, off)		enetc_rd_reg64((hw)->reg + (off))
 /* port register accessors - PF only */
-#define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))
-#define enetc_port_wr(hw, off, val)	enetc_wr_reg((hw)->port + (off), val)
+#define enetc_port_rd(hw, off)		enetc_rd_reg_wa((hw)->port + (off))
+#define enetc_port_wr(hw, off, val)	enetc_wr_reg_wa((hw)->port + (off), val)
+#define enetc_port_rd_single(hw, off)		enetc_rd_reg_wa_single(\
+							(hw)->port + (off))
+#define enetc_port_wr_single(hw, off, val)	enetc_wr_reg_wa_single(\
+							(hw)->port + (off), val)
 /* global register accessors - PF only */
 #define enetc_global_rd(hw, off)	enetc_rd_reg((hw)->global + (off))
 #define enetc_global_wr(hw, off, val)	enetc_wr_reg((hw)->global + (off), val)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 48c32a171afa..a4a6f373eb41 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -16,13 +16,13 @@
 
 static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
 {
-	return enetc_port_rd(mdio_priv->hw, mdio_priv->mdio_base + off);
+	return enetc_port_rd_single(mdio_priv->hw, mdio_priv->mdio_base + off);
 }
 
 static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 				  u32 val)
 {
-	enetc_port_wr(mdio_priv->hw, mdio_priv->mdio_base + off, val);
+	enetc_port_wr_single(mdio_priv->hw, mdio_priv->mdio_base + off, val);
 }
 
 #define enetc_mdio_rd(mdio_priv, off) \
@@ -174,3 +174,7 @@ struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
 	return hw;
 }
 EXPORT_SYMBOL_GPL(enetc_hw_alloc);
+
+/* Lock for MDIO access errata on LS1028A */
+DEFINE_RWLOCK(enetc_mdio_lock);
+EXPORT_SYMBOL_GPL(enetc_mdio_lock);
-- 
2.17.1

