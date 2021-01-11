Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F92F1196
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbhAKLhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:21 -0500
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:57742
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728731AbhAKLhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS6wrhBPLJ4aSB1Y88cZhDVqpOqpSB1BQjZEdJgl9qtdLmrbpGQvbjm/UQGCRb7e5jirbOzmjvx8wlIgThJQxtMfgca+urkca95YthHbASgQRAfxmv2sROtHcIEG5suOd8ll69ZOjW/SSuRA+wq5Gros/kBq+f1VJEH/fOjBWqqOKwhxfLslllmBjI6brxmC/sqInPgvvR5A7Ma2g3yZW/cVoucfOamLXIAHQwnkmMer6DdpEhjatTXnXvDKB7L0m4RgpxxkJ3NW8yB4DhbUpy5b0r1pWuSfLuz0PFiVN5ldJ0LsLV5kAvHg9INXnEm6yF0EyI/LJm9LA8tiDaQHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9krP2sTXBBhE0sBFtZH9DGphaUAe41h/eUEi44rJhtU=;
 b=FF8DdOaXIV8OHN8mmox+9aAQ38KEF1QRGpnMRs55cNzgGb5c4omDq88Hyg/dI89GAgc7VYO3kK1v8MpSRIY3IteF6trc4uxSTIwyf3Lv1IQzphoyhUzv+Zr4Py8nQAcn90S7IlWZwXMB+Mp1CkmYqrK4fX2rs7oLqc9Lx8VITGYNVg34gNGeN3EILAljBywl5IdDI1lz8RWJ09YyOT9lXch8sNy8/ndah8mnA4TE4A49Qezv8+0j7KWomx2XODxSp/+Ulosx/3yQBuJupUfowXJ4hEV5RTNuo/Z6jH5VE+u1jGxDfd+KrCuLnaHUpBELkItWokh4tUN8RIthC0kUcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9krP2sTXBBhE0sBFtZH9DGphaUAe41h/eUEi44rJhtU=;
 b=HcNAXN++tI6NbC4cWYNqta1t118MleaxNls2bRV+0eQs5cJ/ZNSWKOqqZ/m2Oisfhr1jyXkGtWjgOkahe1Dctjw3Sq4zw5GIqnBTaUJiZh93l+iYQ1Yvp11o9RGJ7leAk5aB/aUrOtsKpz/ptDeQZn52h1fezauUyYZ0UcZOtNk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7674.eurprd04.prod.outlook.com (2603:10a6:10:1f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 11:36:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 4/6] ethernet: stmmac: fix dma physical address of descriptor when display ring
Date:   Mon, 11 Jan 2021 19:35:36 +0800
Message-Id: <20210111113538.12077-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6fedb031-3a38-4fbd-da86-08d8b62522e2
X-MS-TrafficTypeDiagnostic: DBBPR04MB7674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7674FE187AC9558E2867452DE6AB0@DBBPR04MB7674.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIs9gyWbQrY/JL/afMJ3gTmWdd02En/jY7cDc7R5M+lDvkGBRgYV2FVcxttabRwL+Yq1ZNZjJuIsM3dekZ2KWUZkhuVM/VnU5aAoHgVjfVT/HLzQ1N8d05LMjY9vhdjXw7CO6zJnlQFiX3X6DsASLcJ/dQT+emMLIymOeILBqp0eCCEtEnih2RExkURZkKVllwhoAlVnYeNyC2eknrWCXwyFCz6yH9q97FqGLjH9ZFgz8KX1eYdCwddls1iFRQQuFF79dEfOfVAUNOtWkeNKc1nzmfD9kRChTkDj8pWLi/3YjlNkZ5mG1d/ZYA+IEIQX4MWb7rB/CWggHfKtrQ78PdmD4DLNSGEwqJlhO0SCuvivBL/v7SY/H1zCWBflSxnAFwyy77KgO42s8TnW0/Bc6X8SeLRaG7Rd4wnSFTNKwIzJjq02FhjccWwk3fVgLPoP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(66476007)(66946007)(6512007)(8676002)(8936002)(86362001)(16526019)(6486002)(66556008)(4326008)(83380400001)(2616005)(36756003)(52116002)(69590400011)(1076003)(478600001)(956004)(5660300002)(6506007)(2906002)(186003)(316002)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?M0Vn/GnDuRUf97koGtbq5FJnnvIdmY4Ek/pdP2tKPxxx30WHhG3rCiBOMxvR?=
 =?us-ascii?Q?u/Mi4cwl+df7ZTaXMm4dJRy96vjOcoJTgqBffCquK6KfxgoO6mUZ/G4KKF8k?=
 =?us-ascii?Q?CpLbqf0WCpM039OsY3Rz/k2R0b+ezLQOAT8rc8IUVqYU//k53Oodg40cE4XM?=
 =?us-ascii?Q?QX49+t3H7pe8C5pUPneUwK8gV2XbRR3CWP9yMoQTI+Di6FnVRMq9wY0L/IUF?=
 =?us-ascii?Q?dvT7pN2ByhgH6uZ10dGlS+6qfNjHUEVTrCyWSObnjnI8548ZEwfIcFRlRM9+?=
 =?us-ascii?Q?sTGXTv31q16TO3jicnRg9J7CfbKDc1DwYCeG/LQu23ZpGvkHWYo5qw1zIu2W?=
 =?us-ascii?Q?ebIRbSlBD20xm+wylXEOpJrJm/3MfKLyUSXXJU+IeEXxwxJ2bwv7lKRg+8Xu?=
 =?us-ascii?Q?z8+WOE4phqomXWn5yo3m4dzQYHrYnh2lMAXLx08YEBSUUofR/cOtQZ79MtQ6?=
 =?us-ascii?Q?N8RxZnuVFLSAxSXJugN2k1sIULnfQ2RvctZV8er6nLAMn+Zmugx0tHIe9uLK?=
 =?us-ascii?Q?kwMbIcJQzIUFeyXiRIuGgKCLxip0DnHRb01xthxQut3KRJbZHJ/wv4RtmB+Y?=
 =?us-ascii?Q?EHguIBxd8fnrsqSWQJiX0j0eG3Qy47bCkNp9ENyOv1PQ1ofGP1LHFzxXo8H0?=
 =?us-ascii?Q?DVlz7C1tyZ0fWE5kThIoBAYKI4BAuoQ9BBxMyM5HHZgH4RpIIdoyQxR2BP7X?=
 =?us-ascii?Q?XEFcf15CYquuYx7zi9Ko/StsVKfQVa6GkHc/pBf924AIQzkV4dHxyCRipuSz?=
 =?us-ascii?Q?nWYlHKVPz214XaLyMe8Bl74Hw4PuCv4dyuLiWFzLD3Qau3AQLXC1f6BVUBYE?=
 =?us-ascii?Q?6YbE1qw+D/JDpmVkdtD/t5WbQFEa5fDt/yG48b3qWKH7LpS8fYJk4tyUSMSM?=
 =?us-ascii?Q?LPKro8DtiLCG+ZiFNlaoIzBydgDhZKiU6JZNudN5zuGU6XLbXrd0SF5g1pq8?=
 =?us-ascii?Q?SJQXHn8nB586DZB/FnC7iM8mWthCv56KGXWHzyCy/C6AeUeS1AeCqKVT+kEi?=
 =?us-ascii?Q?w9Ck?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:28.4638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fedb031-3a38-4fbd-da86-08d8b62522e2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUftT8WYtlvzinfzO36uf0noUwrf4zVFUKYwa9dS2mocH4GB+vaq+nuxKGVwbiEs6yWylazqv1VNEOUiWSFEGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
dma_alloc_coherent will return both the virtual address and physical
address. AFAIK, virt_to_phys could not convert virtual address to
physical address, for which memory is allocated by dma_alloc_coherent.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  5 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  5 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 50 ++++++++++++-------
 5 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index c6540b003b43..8e1ee33ba1e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -402,7 +402,8 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
 	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
 }
 
-static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
+static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
+				unsigned int dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -411,7 +412,7 @@ static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
 
 	for (i = 0; i < size; i++) {
 		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(p),
+			i, (unsigned int)(dma_rx_phy + i * desc_size),
 			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..a7324b9c1a02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -417,7 +417,8 @@ static int enh_desc_get_rx_timestamp_status(void *desc, void *next_desc,
 	}
 }
 
-static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
+static void enh_desc_display_ring(void *head, unsigned int size, bool rx,
+				  unsigned int dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
 	int i;
@@ -429,7 +430,7 @@ static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
 
 		x = *(u64 *)ep;
 		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(ep),
+			i, (unsigned int)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			ep->basic.des2, ep->basic.des3);
 		ep++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index b40b2e0667bb..fc5260cf27ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -78,7 +78,8 @@ struct stmmac_desc_ops {
 	/* get rx timestamp status */
 	int (*get_rx_timestamp_status)(void *desc, void *next_desc, u32 ats);
 	/* Display ring */
-	void (*display_ring)(void *head, unsigned int size, bool rx);
+	void (*display_ring)(void *head, unsigned int size, bool rx,
+			     unsigned int dma_rx_phy, unsigned int desc_size);
 	/* set MSS via context descriptor */
 	void (*set_mss)(struct dma_desc *p, unsigned int mss);
 	/* get descriptor skbuff address */
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index f083360e4ba6..c26544de0766 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -269,7 +269,8 @@ static int ndesc_get_rx_timestamp_status(void *desc, void *next_desc, u32 ats)
 		return 1;
 }
 
-static void ndesc_display_ring(void *head, unsigned int size, bool rx)
+static void ndesc_display_ring(void *head, unsigned int size, bool rx,
+			       unsigned int dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -281,7 +282,7 @@ static void ndesc_display_ring(void *head, unsigned int size, bool rx)
 
 		x = *(u64 *)p;
 		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x",
-			i, (unsigned int)virt_to_phys(p),
+			i, (unsigned int)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 41d9a5a3cc9a..ca24e268f49a 100644
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
+			       struct seq_file *seq, unsigned int dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
@@ -4323,7 +4339,7 @@ static void sysfs_display_ring(void *head, int size, int extend_desc,
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
 			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+				   i, (unsigned int)(dma_phy_addr + i * sizeof(ep)),
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
@@ -4331,7 +4347,7 @@ static void sysfs_display_ring(void *head, int size, int extend_desc,
 			ep++;
 		} else {
 			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+				   i, (unsigned int)(dma_phy_addr + i * sizeof(p)),
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

