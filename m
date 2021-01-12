Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BE2F2E0D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbhALLfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:17 -0500
Received: from mail-eopbgr60065.outbound.protection.outlook.com ([40.107.6.65]:52551
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728953AbhALLfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iP+Xd+0lH+4/jnefMinzTx13layAlKVYDZI8/s2q5iFzBmtQnFj+vhdwWHqBp6G7w5tSAXGaZwFLXc6HDBqC7ngGpOA1LbaW8cr6cmPPsqMeHowEwARudYRr7CBhDTGt1zL2D5MkleU4wJopVXgxm96L8FQqBUc/68mX3CSTPKnkrLFxQams3LHV3NMtKDGagO2Da6/5FR6lmwEmz+fFrAvBsRVz7GOL9TJwYx8jhPOV2cd7f1gZYw4WyEw2gnu5Z5acqHAFaVO9YVdDNHcxZEsMjal1LMPar2G4fknbseA49BG3MZe2VGwMXuAZuECxHQmoE4UH/s2UApxEbEExzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeyC2lGbPEUQNVer5r+2xGomcOMw/S8PTuDrfqKE0Qc=;
 b=KZ0+PZSuv2+hpm1UTsz8XTAWcDx1jfruU7QgwmDAd1QRSpyaG5j48y2ffeAPoQbBp9v/klh3te5/6NXcLvzluT+LCIWqIOxSr6BYi95xaZ1we4hMKMa1MUQGvufgtw5Sgme+wWfPeGG/TdwRyLDxs/g9DSHzv+HvKVJYkvE7oe/zVtu+sXIFfy1d4s1WWV0WXaZcsc+0KnTZeH8zWAhj5ZZeQJy8IF4+mIHVwLs7jcOxn09Y+thCte9o1TZuIAA/D2MGtosYosRUB3bQt0w4oUl0O+G8D0KfxKE3fb9axRNfiHxfe3JHgTBgsrnKyvF5XgzM2eY1zgK+sBzr2pkuEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeyC2lGbPEUQNVer5r+2xGomcOMw/S8PTuDrfqKE0Qc=;
 b=jUPW1qn+kY9eX2W2pMW5SeoZf6ftGm70rpVNfwZ33eFSTd6pYut1BP5Rk5GEW4Rk0oozpAJe5LWvsgvRuSucqoeoPIpvKxvAFGix9n087LAmaYqc+8c+rE+zL8C+/QVG2hqQ8Y20eqYdwblIULiaIW1T+zMOxknwvwF9JveTlRs=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3706.eurprd04.prod.outlook.com (2603:10a6:8:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 11:34:24 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 4/6] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Tue, 12 Jan 2021 19:33:43 +0800
Message-Id: <20210112113345.12937-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb896f03-6b96-4fe8-f708-08d8b6ee035b
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB370612DA39123E820542F528E6AA0@DB3PR0402MB3706.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClZhzuOltT4UvsZz4vdk+1TjDESjJskAdClxWIKqPez/Fij/5MFj0eCyCnh6BGBMC566GOTVI0EBqW15hx3n402KMHAhSWa19WI2zGfjZj5V9qBHDHICSAseyktxzieeb4KAy1an5fdSwzb25kwXvwo5PpcE8t66BpRBQudoMb9Z7HPYlzwIobwvBmoK6RU1NvcZZa6PNi8JmrIIMiIhsJFumwPxWDIQibjHPJSjavt06r87ZTh9ThbXNjtYOoR23w7++yIdBmx8BzmdrAOdRfIQPLMPgcM3gVj92zJB53V3Hh4aEnbX+Eq9BGxSCTETmobM9229+VFNfwh1965x4xfGd085/YUQKYr1vx9DloyC5XrCu5HRiNQGLm/bUTUJePxXkMLzWmWlXSH/0rkB0PsHWjmD6oZenOmhyD3/UTmsbf6Tl+lxD3+D92X9yE4w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(69590400007)(956004)(2616005)(498600001)(2906002)(86362001)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QhF2TLRx1nOTETDk6w74NpULZsb6+ipUN5dZunKvSAec6lQbXwC4nRg+CAv9?=
 =?us-ascii?Q?XYOmrvhNeEVPo2bSLm+0YRi9aO2iPuJUEVR8DZO/XIDonowPWTGa6KfXsgJj?=
 =?us-ascii?Q?veeeEFwth6BHmHFd29js6DvuyBfHX75LSSgYi5SPM6YowSB06LlhYWAOMphD?=
 =?us-ascii?Q?a+jiOoRwbNJdq+cpQO/Qb5vS8rizFSqbO2aPcjgxd6TDfpI9pk3viuuzPJAd?=
 =?us-ascii?Q?eFkazPbEBdGeRBmRRyjEd6j+ByGqcvfDpz3sG31kFcjfwmTRbxezSgf1Pd49?=
 =?us-ascii?Q?qNmF0HLxAmZFCxyIkS6GqJyjjoTHLR+H3/8IzLREwkHh3LTDG+t8ozrnCMgE?=
 =?us-ascii?Q?0m/oNhSnkkUl1HX16NLGQAg4TZxtpAlR4VhlIU6JIFC7KRjNTGOx1t8bqMYK?=
 =?us-ascii?Q?0kX/D1jh6p1YPhmY+3E34MJwsqvMRJdhIaNOewlknbUXxxswVFaJ8BR+UN+u?=
 =?us-ascii?Q?qr2rTLSpijoXL0XYnXqO3YBfLb/2TaV7eGeETpcScaDWnxSCyEINruCAjiIs?=
 =?us-ascii?Q?PwsJvfDRZ++htRsSGoMzDZO7YseA0LEp0tR+oe2eTavPl9Pyo6PtTyodO4Bp?=
 =?us-ascii?Q?Bk9lCEBGTNzsKroYbgzchIw9imjgilbqPF/G+vXh0YY6C8MAedO+vGlRes42?=
 =?us-ascii?Q?bj7psNcZlB54CglU45Dyk/TA4paufoERbcfC3708MHJ5y6ve+iEAY8Dk6hrH?=
 =?us-ascii?Q?A6I2c7rCu7eJGoT3FNL70zAe2bu4WyiyjfxDcyLaObPx4sBH8l6hxZSD/3dp?=
 =?us-ascii?Q?ieN3onkiSEo2y1WrlkhfD4cHTIdWDyHXVBjscDu9uo/U2NtrooubfbJP23vi?=
 =?us-ascii?Q?naoKn76N5IYvkZhDSrx5q0W60sq2nmSIrbrshgnp81YoBjGyylniZkViT3e9?=
 =?us-ascii?Q?f6sbjOhTpwdOp8gueOr/put+gjTKmyc8Lv7Wv1aX92mw7eUAM7I34r2NsfGw?=
 =?us-ascii?Q?ECHdYht/xyVgs+wNOIMmPseLRWHD0LMT7AkBehLHmgBOMqd+DjI7uUTrm3Ww?=
 =?us-ascii?Q?LE++?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:24.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: bb896f03-6b96-4fe8-f708-08d8b6ee035b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLXwgRA7pMxXQ/3KRK2DGepkXzPadxQMcwcYFZScvcww3t3jF8vCXvcOYdDjEup1q+KC1SPJbDhCncS2TB5C/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3706
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
index c6540b003b43..be9132de216b 100644
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
+			i, dma_rx_phy + i * desc_size,
 			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..6d02528cc33b 100644
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
+			i, dma_rx_phy + i * desc_size,
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
index f083360e4ba6..eb0509b78f2f 100644
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
+			i, dma_rx_phy + i * desc_size,
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 41d9a5a3cc9a..f612f2693adc 100644
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
@@ -4314,7 +4330,7 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 static struct dentry *stmmac_fs_dir;
 
 static void sysfs_display_ring(void *head, int size, int extend_desc,
-			       struct seq_file *seq)
+			       struct seq_file *seq, dma_addr_t dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
@@ -4322,16 +4338,16 @@ static void sysfs_display_ring(void *head, int size, int extend_desc,
 
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, dma_phy_addr + i * sizeof(ep),
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
 				   le32_to_cpu(ep->basic.des3));
 			ep++;
 		} else {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, dma_phy_addr + i * sizeof(p),
 				   le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 				   le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 			p++;
@@ -4359,11 +4375,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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
 
@@ -4375,11 +4391,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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

