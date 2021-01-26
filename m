Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E687A303C67
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405415AbhAZMBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:01:45 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:17793
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405565AbhAZMBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:01:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNen9Y5fATRc346AcIqicqHdWDC5yPoaMrTDGmH0mpWTBwD6df7op7mblk4u+0mHZOi0sf+RdJfxDOhgj3ki9yz3ngY48twEdncGUX12LTTmf/lAt8Ab9rOOTPX2MNoFFrkcPjIsbURCuRpDqLcydaJmqr/8lcPso18QF6BdBGD/7JX1JeQsJLPk05zaUHBZ/4Wn0fAAraTu7ygNilksjR+GMcAMLpPTgFAyDaZ5qsWK1/G+Cfmb4WgX0RWfWIE1P6lk6ccT6F08N7u1IwsbZHx6qhPgkwo/jG8yhhlA7B8mRsm5gnueU5bf404Jl5Q1uIL3J/tN9LF1JSZG3J7NuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQqS67q2N54aPklPfVIt5dQ8P+A1y1EjOTdqNNSR01Y=;
 b=ezSFAG4wK1lQimqNiD9MtpH7s+MOnrwI8HKTKgB5e00aMoee+4gu6QDIckMzBO/6YWKKMsWCLxZ6u7T0DJbJSPCEGxy4yMRrHlfsd8qC6FpZrhIWkR84+dqrmBV65lzTsnTDgd9wwN4qz+NCLsfW8uCPGLwpNvQnKN4+NMURgmSLQHE0yW7E22u+Mt5wpB1QLblHnKV3Iy23ETNRaRRpZoHkqmzqFV9M/iz3Brd3HIBz7ZWaVG31QpPD2mf0VNJUXtKit/6NNMk54RrtJOQNz7qhSUC582AUppSjZm1xU8kS/zyfGm0sim7ViFHsyVfEoe4O61DhfOPe5Mvz60QiNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQqS67q2N54aPklPfVIt5dQ8P+A1y1EjOTdqNNSR01Y=;
 b=KwioqI9k06UBVDuiO99zM6M5Esj+1GMplKP8P3QJGRt/epFxLxbtBr3l3ZEPPBrkpBCJq713snVIZw4kIokNaso8UllbggR5RrCG6OZED7p5l6nRu0d/Zg/MfFyn+lLUVLaxrdpg/ZdD9H2goWAMnDbLfYd11iDR9bdcClhnA7Q=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 4/6] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Tue, 26 Jan 2021 19:58:52 +0800
Message-Id: <20210126115854.2530-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41171c7c-72ea-4acd-0160-08d8c1f1e19c
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB697141CB51507925792389DCE6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WmJgFdqRE4biX9eDsiCLshSwe+bROQn8FwkV3e6/a+qMWpx0Ab9kfve482qKHIeP3d5dGU1oLA8pWacCmAa/0L3R8wuEDj+1IMoypa8579MEe8xXpu/ncNMG3wZ+gfzW4Ge+GOf1y/aFIotg2VzB1MhlnkABwTgtZbt+Nw8HHKmHx7DxWLwStSLID/2xSGOYqurHf08lkbGz8xIVAlFYwdUdN0+ZXPZ3B5ip07u8TPEakmZvpnSKAW0Rs+4FrXIe9BMgoHqVpr9jOiOcUDx/hH74cOLRnwQYtJjLnHhLrJpF2tTAlemblDEvoby4eJIwSYRHih/q2cHjqb5Cf2jS9ZchxJG0uBI8zPBajH4eydLKMvmf+zHV+42fA31DK7ujTCZQf1a29vT5f1hLg77ZI00ps8jIC6hRrwPOk6SPxPBLN2NnARrTbRvzq8+TOMKwQ3mfwd1G6+6NfUGkZ1edlnYoi/gbfbCVYB/2+Lgq5v9DN1Cnftd788p5E09GeTq/tsZtARg1WI/U18ow4i/RryWifiufEagIz4x549LKTd3/YtWHFXQTk55T9RMz99CqY0jEUWaW7E4dId+nIlmsNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(66556008)(86362001)(6666004)(66476007)(478600001)(2616005)(6486002)(956004)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s4SfEXnFpC5iK4Wzyigr7ty6yvWVuCBSBg62ZzjZ+h6au6ab0Xb1JHJI4JFP?=
 =?us-ascii?Q?l12HDGu5tXwcTMhfco2rzniel8NntmV9WtZtDE7KbRXKCNkeOv7m6hweA01/?=
 =?us-ascii?Q?KmPFgHPFwQJxOvanlospq+gHh//JXanEsjcWhIxPpOxRQxzQwAcHtgOnCPbw?=
 =?us-ascii?Q?smfkdhfE9+MSJ4g34rmIqumnvz7USUtk38VnEt7fozzk9LM9VyUVA4cR4ExE?=
 =?us-ascii?Q?iGUrM8Y5lC0yHmBttNht/SgqHNMgMOCAaYlANxyHGGgVaoQ67H0x1i6m0neq?=
 =?us-ascii?Q?TSPKaRofoZ4wMYDrnpCJq6XST7sFMdnU7mC1QELjfMt40P+T6wtuq9YbO1C/?=
 =?us-ascii?Q?wWAuzGkqJa+pvDSOZMSXXlYnGTqfBLqReoKbiLjx0plQ1smin3YelUZqHY1z?=
 =?us-ascii?Q?lCsX+f7KDhw8ScrWPmJ7y4TotCt0WNaHvY6oTkZXUgqEJgBGuWbR/S1XviX4?=
 =?us-ascii?Q?usSJyiJNNZCDzKfIhsdHjc2a61nVDK8VAr/3DBSLs6JSgp/OBynPvshLg0Qp?=
 =?us-ascii?Q?N4AWx3WGqL+MGRv5na7DxDDIDN3KSCV0+D8WEGNt5W+mp9mssRB0RL9s1v3n?=
 =?us-ascii?Q?MBt7PqKuVD4GUFBp/DG7kloApU5nVlEXSExp9SvLRvpnFgGoTdE5Uzds/GiD?=
 =?us-ascii?Q?LzXcKdCaTRndT0o9XO/+sKLnaERaY37FK2RpxU7gZY166jNroxo1HZ1JLJln?=
 =?us-ascii?Q?Xve9FumAdHJisekYqhxL+6HL9exwYFLb4kDkHaAyTkWV7TM5Ntnh3FgECRoX?=
 =?us-ascii?Q?2Qam/hAotAog9k9dneLyYcgF/0HsQkYfGp7JWgp5GVRRENSALSK6RpfUholC?=
 =?us-ascii?Q?p4U7wxq/zc4eppwT5yljHcrqaWVDcKpKEa4IOcchpKmSN9mZKnltr3Z63Hry?=
 =?us-ascii?Q?9xMifpfmsDJ6nWQrT+873D2uaOf7S9TxRBVZ61QV6NuZnZ0y/1eE+qO6xu2D?=
 =?us-ascii?Q?a812TiL13t4FxhrHURzLNjasJLgz3AjjoGFlcTwZVBn206fbfUsYmJD2xrzN?=
 =?us-ascii?Q?nIP3Ux3woZRTNVo5vgfG8eum8v7X/2xePXmSzrUhp8dleCPtUh6G+id62z5p?=
 =?us-ascii?Q?0/m8pzrp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41171c7c-72ea-4acd-0160-08d8c1f1e19c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:49.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLZhJpQu92yH/oH7x6pgOdgRjO0lTuCFpq0+gJGue8LE/OYIirFl0Yx1ySUkg8ARyeXqA926EdSqK54Mo+Mfrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
dma_alloc_coherent will return both the virtual address and physical
address. AFAIK, virt_to_phys could not convert virtual address to
physical address, for which memory is allocated by dma_alloc_coherent.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  7 +--
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  7 +--
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 54 ++++++++++++-------
 5 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index c6540b003b43..6f951adc5f90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -402,7 +402,8 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
 	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
 }
 
-static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
+static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
+				dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -410,8 +411,8 @@ static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..eaea4cf02386 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -417,7 +417,8 @@ static int enh_desc_get_rx_timestamp_status(void *desc, void *next_desc,
 	}
 }
 
-static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
+static void enh_desc_display_ring(void *head, unsigned int size, bool rx,
+				  dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
 	int i;
@@ -428,8 +429,8 @@ static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
 		u64 x;
 
 		x = *(u64 *)ep;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(ep),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			ep->basic.des2, ep->basic.des3);
 		ep++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index b40b2e0667bb..7417db31402f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -78,7 +78,8 @@ struct stmmac_desc_ops {
 	/* get rx timestamp status */
 	int (*get_rx_timestamp_status)(void *desc, void *next_desc, u32 ats);
 	/* Display ring */
-	void (*display_ring)(void *head, unsigned int size, bool rx);
+	void (*display_ring)(void *head, unsigned int size, bool rx,
+			     dma_addr_t dma_rx_phy, unsigned int desc_size);
 	/* set MSS via context descriptor */
 	void (*set_mss)(struct dma_desc *p, unsigned int mss);
 	/* get descriptor skbuff address */
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index f083360e4ba6..36e769d2e312 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -269,7 +269,8 @@ static int ndesc_get_rx_timestamp_status(void *desc, void *next_desc, u32 ats)
 		return 1;
 }
 
-static void ndesc_display_ring(void *head, unsigned int size, bool rx)
+static void ndesc_display_ring(void *head, unsigned int size, bool rx,
+			       dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -280,8 +281,8 @@ static void ndesc_display_ring(void *head, unsigned int size, bool rx)
 		u64 x;
 
 		x = *(u64 *)p;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4083bbc092f..8d1cc17a99a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1133,6 +1133,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 {
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	unsigned int desc_size;
 	void *head_rx;
 	u32 queue;
 
@@ -1142,19 +1143,24 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_rx = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			head_rx = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 }
 
 static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	unsigned int desc_size;
 	void *head_tx;
 	u32 queue;
 
@@ -1164,14 +1170,19 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_tx = (void *)tx_q->dma_etx;
-		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			desc_size = sizeof(struct dma_extended_desc);
+		} else if (tx_q->tbs & STMMAC_TBS_AVAIL) {
 			head_tx = (void *)tx_q->dma_entx;
-		else
+			desc_size = sizeof(struct dma_edesc);
+		} else {
 			head_tx = (void *)tx_q->dma_tx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false);
+		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false,
+				    tx_q->dma_tx_phy, desc_size);
 	}
 }
 
@@ -3736,18 +3747,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
+	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
 
 		netdev_dbg(priv->dev, "%s: descriptor ring:\n", __func__);
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			rx_head = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			rx_head = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
 		unsigned int buf1_len = 0, buf2_len = 0;
@@ -4315,7 +4331,7 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 static struct dentry *stmmac_fs_dir;
 
 static void sysfs_display_ring(void *head, int size, int extend_desc,
-			       struct seq_file *seq)
+			       struct seq_file *seq, dma_addr_t dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
@@ -4323,16 +4339,16 @@ static void sysfs_display_ring(void *head, int size, int extend_desc,
 
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, (unsigned long long)(dma_phy_addr + i * sizeof(ep)),
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
 				   le32_to_cpu(ep->basic.des3));
 			ep++;
 		} else {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, (unsigned long long)(dma_phy_addr + i * sizeof(p)),
 				   le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 				   le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 			p++;
@@ -4360,11 +4376,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_erx,
-					   priv->dma_rx_size, 1, seq);
+					   priv->dma_rx_size, 1, seq, rx_q->dma_rx_phy);
 		} else {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_rx,
-					   priv->dma_rx_size, 0, seq);
+					   priv->dma_rx_size, 0, seq, rx_q->dma_rx_phy);
 		}
 	}
 
@@ -4376,11 +4392,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_etx,
-					   priv->dma_tx_size, 1, seq);
+					   priv->dma_tx_size, 1, seq, tx_q->dma_tx_phy);
 		} else if (!(tx_q->tbs & STMMAC_TBS_AVAIL)) {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_tx,
-					   priv->dma_tx_size, 0, seq);
+					   priv->dma_tx_size, 0, seq, tx_q->dma_tx_phy);
 		}
 	}
 
-- 
2.17.1

