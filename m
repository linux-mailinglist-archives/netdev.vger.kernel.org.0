Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CF2324C6B
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhBYJGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:06:50 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:43078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234563AbhBYJCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:02:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqoCZXnQZbesjcKhDoDsDg0hnd5n4wWEAjb5iV8E1+aPU1cKjpXAep4b0UvRsjt2johVLlFUrqkPUvtBI903ZjoI54/qby6RRjltbpr47r2eBOBESdE3ZqSUFeXccqas4chJd+DzdUZL59aZdnLiQRKJuRY9P2dbXuD3DxcLrft8QRX04zdQpnKxVeARGpW17jHUobt+R3IH5gn5xR41LYeivUBnSrdhLhhNaTyK/uIsnaIYns77ly8nC6SrBckvyujnrNHEMUUdIBcB64YeHBf3TvGmzAIDeAK6WQzvLlj32WcOot5RkEtVfyEPdhlrL2voEtB4PwrLiV9ADaPy0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sJQW2wSH4ju9zcA7XOP3Miw6lj4B5QOUy8a8FzU9Tk=;
 b=V+tIBUTS8OTYTGP+8v7BQpBEFOWOfSiKzE+qjt7FnCSDdCw35qL46imnDEIEM/HETi0jisoR1X/S3TuZbUsK6fgYoH5rLkTzoUa408fSWwhM0+cRCAu+MpgE1/m4ZCKheRrDVkaNIU+ZTSNtHgHUlqCfesQgw3U+5NZypAXJesabdRG+MsawxOwQVyTLAw3bBSlK175liD8LB2F1+rN3Vw1cHVrq4DyfrecmtcxMnUwDgr+3XBZ8jucQTRtTzafLzmtjm8gUw+Ppr6Ysk+5rin6wT7ymOYD226oxPK4zJIp2QUG4Uu/V2Y3j+INlzC/QCvwg++oIcEQ6IzCTU4w02g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sJQW2wSH4ju9zcA7XOP3Miw6lj4B5QOUy8a8FzU9Tk=;
 b=E4QQbszd2NPYEwkq+gNgPcECX/2p4pkwMZdPQnoNAQg+74S51GVTgGMl/mGEx1hoaxJtr86e953XBnHMHWPPP0hVjAXWyuVmxulIP9zF8jZlSLfhUJAwjzFPNgiiPTeDzEpBcLLf//oID14veA8yRB7cDj7DwzLIVilrrPsL1vA=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2504.eurprd04.prod.outlook.com (2603:10a6:4:36::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 25 Feb
 2021 09:01:38 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 3/5] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Thu, 25 Feb 2021 17:01:12 +0800
Message-Id: <20210225090114.17562-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
References: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9faeac6f-0340-407d-963e-08d8d96bf5ba
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB25047137288AAD14EF95184CE69E9@DB6PR0401MB2504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsR2VD0NNMZ1CaxtLjJbzweZGF3Ara4qiGblZbUwrXPiAyYnJHcJp93vXZm+wdoz8IhA3N5vscfPHEyNlupyMvHhrJLqyaHHsYp3lN7xT72VBSWrOhAOFK4NoUJvrIt3cn4vqX1WzltmAmVKcclggkQzHBAoRV+F7D9uL5mL7k/PEVmqEfMmK25GhEYlSSbc3oyYHTB2/CPEaVIminpnRqrHln0L1a/J1QNVeZeOYMA24lucaRSGW6ds7bpqBno4P9aS4OVRGZBylny3Nufx0Skt+9XgHNpGDsSBGKLbCv7SfTl6CVERjlwyaGl07KKiDMFmbZ/p9Ecu8O4lqdcisy+rKg92cB5Ra7gHVw7aTBmGYVuxsWFIocCadKwwtReeKHTy6nw5gkVVIZ6Bt+oFLJ/55jghNPemRbbP3MvpsnV4spBPWdKpKFPkZoZWVG2eJ96ypFHAcOeZ7HvAilgEOFD8XcCFKL67WwKkpcrUMRUi0wtJcvWIk8ojV65ZqqPnbupZ12zb2uoWoSctXppB5EMy7Q3oh3mZ2uQS9xwRkshPBAV/JeIH0i/ih/xu6Ra00FTAIQUA4tvRz/vHYKUxCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(6512007)(186003)(69590400012)(2906002)(4326008)(2616005)(6506007)(6486002)(478600001)(36756003)(16526019)(956004)(86362001)(5660300002)(6666004)(66946007)(52116002)(316002)(83380400001)(30864003)(8676002)(66476007)(26005)(66556008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RosUMLSha1MCxJ2mJqe0cbIpPS7QzZcoI3VibPfiXHhqX1PSf5d+X6kJ9G5Y?=
 =?us-ascii?Q?2XvPQ0yhDFogMwhrkXUNg4VTM55brpG4K6o0gpz0oHtKGiVYh6dhnkZmh+Wz?=
 =?us-ascii?Q?t0PIqVo/dc9InZWJxwtkQ1dPteEJYeSZh6OIvgLBY0QP/YUKyvjIWS7sb1pp?=
 =?us-ascii?Q?E9OMqj9W145mYgQnTqvK/LL+zJzABusZ3Zag0NgCcQUFgs7Ci0Y45gN+Ex0u?=
 =?us-ascii?Q?nKdTcBH1Puw43mZ0LEYuX/6d5Jv/5czVOgQDvo26lk88qVzZ7wvNqYpLfGSt?=
 =?us-ascii?Q?7T5k/CgJfveZS9gl2E7K6vjV5sOi7gDHnfkY14C6QxOQD80wXQL8lzvdXMAl?=
 =?us-ascii?Q?4YDP9CxXYiYWUXExOQ9qjB9RKJDPwrpYVOR9r/H4lFC4w13ENTMcpzd9q8pR?=
 =?us-ascii?Q?1r8ua1F2AOX8dt5qxyq7T22Y6py3praTUtcUeRFdrcInvFlj69lBe/mOQ2UC?=
 =?us-ascii?Q?oXaFLyW7JBhBDl9w0SXicAO2rx9cjanzxCcpBkUfenv/abp2UwZToDMU6Fpw?=
 =?us-ascii?Q?FLL3O82aPNCDDObSjDbLPSei2KqH3OXdTL86v1AzMHC49mLhRXT1UeoWpJnR?=
 =?us-ascii?Q?e9sGpAKFS8dajRNaPD0jXIieOTgtSvGu/B4s7A1DbU6A+Ory+HthK/+AyUMf?=
 =?us-ascii?Q?+9o8Rqzxhuv8TJycH9fyk3zmSUeVaZtebCjXOEwZVSDOpBbhtT0XO9r/ovCb?=
 =?us-ascii?Q?hlISsCkiWBFpxy5FFF82b8pZYBjMJulpmCYQ/2peoWDZqWcTtfuDLPuIFrbE?=
 =?us-ascii?Q?g4bgLbC7V9PgSKO5RWF90XkBC5iKTDAgTu54Z5quW45OnbM6RrpkRKS/Hiv4?=
 =?us-ascii?Q?EIcztF65GBYOQkbcgKSvJ62+DYRrjivKf2DdNlZgiiObUx5tF9wH6F6Py8wF?=
 =?us-ascii?Q?EjHFQEBQOg8p7O2VOin0I7vb/lYzk/3B1TOg3dI1m3Y4aw36bWou1ttV4CFs?=
 =?us-ascii?Q?19agj+uVSoocAks66vHMuUq9XanQRJS2FLliTicMAzi/9HfhBVDiDfNknm8Q?=
 =?us-ascii?Q?WXe+tAG+nkBQvoklT2SPr5UOu3nJYQfwT1Z3itAqY9XO6gVoAaX6ycf0ZUAI?=
 =?us-ascii?Q?DT8G9ruvoMKZ2ddyj8gbQ43x8ox/bxthWRenMjzekFQ9hkgMAIq+NeYB1e5m?=
 =?us-ascii?Q?qCNI7a8F8AfbSoH4kHfVlfpQK6iIO5UtFY0gRIwlqnXHkozCpNTUSQxZQdSC?=
 =?us-ascii?Q?51R+YfvTYFhOzD8yrEg+di3Y0BzE7ngwy4+u7+k5WCQwAG2+n5aZYkqEGaCY?=
 =?us-ascii?Q?74CPjS9oLrQN0QkBYx+cZwinZT9yOYWTxou44WHLBD2LokBucEJT/0G/hX29?=
 =?us-ascii?Q?LKidgDd9UrIWrVHb8JIVllS3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faeac6f-0340-407d-963e-08d8d96bf5ba
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:38.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7GSV/afLBSgAMg94xneAdS9bYptrn27mhk+QopbxU4TMbYFztkxNa3eBW/YzVoLn6kFWGm8UOTe5OD7jnovkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
dma_alloc_coherent will return both the virtual address and physical
address. AFAIK, virt_to_phys could not convert virtual address to
physical address, for which memory is allocated by dma_alloc_coherent.

dwmac4_display_ring() function is broken for various descriptor, it only
support normal descriptor(struct dma_desc) now, this patch also extends to
support all descriptor types.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    | 50 +++++++++++++---
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  9 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  9 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 57 ++++++++++++-------
 5 files changed, 94 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index c6540b003b43..e509b4eb95e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -402,19 +402,53 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
 	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
 }
 
-static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
+static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
+				dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
-	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
-	for (i = 0; i < size; i++) {
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(p),
-			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
-			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
-		p++;
+	if (desc_size == sizeof(struct dma_desc)) {
+		struct dma_desc *p = (struct dma_desc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*p);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(p->des0), le32_to_cpu(p->des1),
+				le32_to_cpu(p->des2), le32_to_cpu(p->des3));
+			p++;
+		}
+	} else if (desc_size == sizeof(struct dma_extended_desc)) {
+		struct dma_extended_desc *extp = (struct dma_extended_desc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*extp);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(extp->basic.des0), le32_to_cpu(extp->basic.des1),
+				le32_to_cpu(extp->basic.des2), le32_to_cpu(extp->basic.des3),
+				le32_to_cpu(extp->des4), le32_to_cpu(extp->des5),
+				le32_to_cpu(extp->des6), le32_to_cpu(extp->des7));
+			extp++;
+		}
+	} else if (desc_size == sizeof(struct dma_edesc)) {
+		struct dma_edesc *ep = (struct dma_edesc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*ep);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(ep->des4), le32_to_cpu(ep->des5),
+				le32_to_cpu(ep->des6), le32_to_cpu(ep->des7),
+				le32_to_cpu(ep->basic.des0), le32_to_cpu(ep->basic.des1),
+				le32_to_cpu(ep->basic.des2), le32_to_cpu(ep->basic.des3));
+			ep++;
+		}
+	} else {
+		pr_err("unsupported descriptor!");
 	}
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..fcda214b07b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -417,19 +417,22 @@ static int enh_desc_get_rx_timestamp_status(void *desc, void *next_desc,
 	}
 }
 
-static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
+static void enh_desc_display_ring(void *head, unsigned int size, bool rx,
+				  dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("Extended %s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
 		u64 x;
+		dma_addr = dma_rx_phy + i * sizeof(*ep);
 
 		x = *(u64 *)ep;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(ep),
+		pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, &dma_addr,
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
index f083360e4ba6..0ccec4f9db48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -269,19 +269,22 @@ static int ndesc_get_rx_timestamp_status(void *desc, void *next_desc, u32 ats)
 		return 1;
 }
 
-static void ndesc_display_ring(void *head, unsigned int size, bool rx)
+static void ndesc_display_ring(void *head, unsigned int size, bool rx,
+			       dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
 		u64 x;
+		dma_addr = dma_rx_phy + i * sizeof(*p);
 
 		x = *(u64 *)p;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x",
+			i, &dma_addr,
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 12ed337a239b..071b6bb3b21f 100644
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
@@ -4315,24 +4331,27 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 static struct dentry *stmmac_fs_dir;
 
 static void sysfs_display_ring(void *head, int size, int extend_desc,
-			       struct seq_file *seq)
+			       struct seq_file *seq, dma_addr_t dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
 	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+			dma_addr = dma_phy_addr + i * sizeof(*ep);
+			seq_printf(seq, "%d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, &dma_addr,
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
 				   le32_to_cpu(ep->basic.des3));
 			ep++;
 		} else {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+			dma_addr = dma_phy_addr + i * sizeof(*p);
+			seq_printf(seq, "%d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, &dma_addr,
 				   le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 				   le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 			p++;
@@ -4360,11 +4379,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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
 
@@ -4376,11 +4395,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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

