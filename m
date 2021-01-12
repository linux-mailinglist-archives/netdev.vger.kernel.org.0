Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F192F2E14
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbhALLfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:52 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:56242
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729686AbhALLfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HavdRglQ0K1m+/x5g5C/fqqZQUghIoV8c5in5wfpwF+lpc9aQiID8q5Z6L1gyJ3X0RoAeqA6zVOgKpFHfAlWB3RxQXAT2XvsjblEcG4oO4tLOLPeQK6iVbUXk4DWp/qrT7apHF5zYA49FMZQDQJr4k/Sm2t2MFByp2awxBANL6bhjTfFYFezRm1P8153DsBquHQYp2JiHu4C79RypBJoXzs2o6x+Ia+8KRGXVyc75Sif0QGe+nmgEHKTtNUCPSegipn6QgG2ZMEAIbyPQNdraxNa4fBzfzaWxQ5nRyU0soJl1oAPbnOhPVYLWQxfHq6HLOmk+qq9uzyjXXL/sqIQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFXIhY47NFvvEpEE79FlOmCIGpMYuPL7QHw7OkkvXJ4=;
 b=ZV0Fe3H24XTU/EmEShV1oEXroybBM/g0gNeiwUyazHb0cbNiO/X+hXNmkA9rW5G/fdzboMsc4IFUI+JjN6CReBRfCHTC9oNtICPtzrDWrTDCGNkvizQXIyyDgC9MNxsibYZgm9CjUbY1QdFC49BKIhLXCLJJZVfn+iPi8uPIPkWaAIjvhqxxgAMk6mJ+NDFGiMO77SQkfP01nThTrFHyndek+QlQbFdv789lpTuVUHgO7zmqiicYYLwPJJD05eiaY9BYNoQuqbL75NJVANkE2fkri74GX05vaRnvLJt8jfOJcxNc4z3bGKI2UiYiMXgPGI7V2rp+erfVdLNZA21wIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFXIhY47NFvvEpEE79FlOmCIGpMYuPL7QHw7OkkvXJ4=;
 b=II/TcivtI3wHMlD5EhYr+zbJ+MDSvZJEUZCZGxyc3uxI/V2pYCv70lvyTPt8jwMULVngBsyCBQT4X1xY9yNoghw28zIrSo9a5wFRoKYGsF0zi1MwiRu2ddCQBPdrdsydREgqosmqc6SeuER2vvjbKwqmVKBmMCP8Tfq7buGFKcw=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3706.eurprd04.prod.outlook.com (2603:10a6:8:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 11:34:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 5/6] net: stmmac: fix wrongly set buffer2 valid when sph unsupport
Date:   Tue, 12 Jan 2021 19:33:44 +0800
Message-Id: <20210112113345.12937-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b328590-3a52-47ee-cbd9-08d8b6ee0560
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB370650D4A4AF31A9D31680F2E6AA0@DB3PR0402MB3706.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bO9QRAfqYhAbX1M9pyrkMirCVd9VmPHsxyGwwP8v6bHpiDbPqglG4ZVntpl/ZJ5lGMqYOhi9/xUxQ4sJoSSvt88c70qZyG++vIaQZHNjMMLwQtrxsAXVMQblC/0NgQEGBezGlHi7zBh4ARznLcWnAwVcvKMZaMmuH2vyoBrOn2M7zluBC97uZlez5fu0337KZfCUrsQyZGm+mC4NlZaN0Ay/XtlBW3olL+4OvMSf54mU+jOQ0igCNS6q1eeOo7Nw5h03lRfSZiwar+gUSz8SBTBkuPrUL3V6DS2ZWhOwhl0IvWvzeK2gQQyQi80kG9h/9Xp2UGVgCJmaXrunawBVJyXzJwk16rO6Wuix/oj2CKvJrkMNWLlxQQv1Si6XqeN8mZz8N3UY7RaQPSgWAebZyOoWRraSxlwSTQCBa8ppr4FbkwsdzLY2e1RmeJZvHgkLBezu1o4HTZvKCDdMt7ZIgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(69590400007)(956004)(2616005)(498600001)(2906002)(86362001)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LN5HiyFn5/6qlsSqehu31V3+C6HZSWnG+YWN1opdrULCo5vh43v6/GAOwPOV?=
 =?us-ascii?Q?wd0J224vc0hj+x8DUVqpcWz4VVCHDvqxHl3Jb61m7zBmvB7v9n3UD3mZYryl?=
 =?us-ascii?Q?nRY3M8x8YCTRl7GWdc3S9ThDXdY3V1tZc9mNSyht697fUDyIy0myPT25PB7i?=
 =?us-ascii?Q?jMviIz2Uhv5KVKGeU8AF4jZtev1FmYJ8OAACavM9XtQMGtcxmeXB3xw8TB2I?=
 =?us-ascii?Q?Ve6IX5NO164+YAw/tWI/79yu2rhSVvtUGK6ES/tfTWdMa17As+fE2Nb4+TnV?=
 =?us-ascii?Q?xjimJbXhDuWuN8gfaeWf4D3ca+rLT/jhug6d+SvVbmaVSdiEQEecQvNoOHOE?=
 =?us-ascii?Q?JS68XG+81Auia8mWJdME0dlEWd/ydMy8wRK3UX+0mynHaxkiY5kt/4pmp397?=
 =?us-ascii?Q?+CB//l0eTSqa8jfPcVnhU7Pi9XN97TSPdeX18XRk4MyWbMm7VlowmBWxTwje?=
 =?us-ascii?Q?2cpBXEb6jv3Q88bNYbJKHzFREf/MRvrxH8HjZgTmqRmCrxNymYSzmxw1eCFC?=
 =?us-ascii?Q?MqHM7h2XvnfcgM29ep71nOVlz93oARPxqNMor4Bi6D4SQ1+kn/P0j4/tvSSh?=
 =?us-ascii?Q?Ln6Dxgf79AtdgEZ565GUyNX5HpcGd8r88oeKJpydUbVdizn2vHwAdlEsRygl?=
 =?us-ascii?Q?pv9u3cOhEJ/Yo4/RXqa8CaJSRpQHu9/uF1hCXTvdb/PsDStJWLgU3uajmopr?=
 =?us-ascii?Q?cchDoPz+EvRO5FyWev1Rc3nLBL8Az4yOTNTBAYuhgbTZunNvXqD02fvTj4C5?=
 =?us-ascii?Q?IyOhtreOEoH3Zb8RJfQpQSJlX8VqOVMRVXQijOpi/HBbDo6Z02vPPhI+ZifN?=
 =?us-ascii?Q?j8odmVeP532vGCpoZN4iZhR0lVoAnydEEPcQZD3/cBP2acieKY3cFoO9UxZW?=
 =?us-ascii?Q?NnfD2C0OehpMOfGAslU3vKc7YpcNNxGES3hMHF5KFxUPV43aXNLAADATcMPO?=
 =?us-ascii?Q?bhOMlbIxcLeO/lXhT4rvZDYKynb26TBBovSg8KcHys5rzyjvilmHoIqt5TVK?=
 =?us-ascii?Q?yp7F?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:28.1178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b328590-3a52-47ee-cbd9-08d8b6ee0560
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wl6SmpiR4RYAkVEPwgc1V3rNzSAvRS8RJbxnpqzLLhCTdWyR3sTetsqeAibsfLXOzxxW/VpPxFV76rJs6FoUqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In current driver, buffer2 available only when hardware supports split
header. Wrongly set buffer2 valid in stmmac_rx_refill when refill buffer
address. You can see that desc3 is 0x81000000 after initialization, but
turn out to be 0x83000000 after refill.

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c   | 9 +++++++--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h           | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 8 ++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index be9132de216b..afc028747fd6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -500,10 +500,15 @@ static void dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 	*len = le32_to_cpu(p->des2) & RDES2_HL;
 }
 
-static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
+static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr, bool buf2_valid)
 {
 	p->des2 = cpu_to_le32(lower_32_bits(addr));
-	p->des3 = cpu_to_le32(upper_32_bits(addr) | RDES3_BUFFER2_VALID_ADDR);
+	p->des3 = cpu_to_le32(upper_32_bits(addr));
+
+	if (buf2_valid)
+		p->des3 |= cpu_to_le32(RDES3_BUFFER2_VALID_ADDR);
+	else
+		p->des3 &= cpu_to_le32(~RDES3_BUFFER2_VALID_ADDR);
 }
 
 static void dwmac4_set_tbs(struct dma_edesc *p, u32 sec, u32 nsec)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 0aaf19ab5672..ccfb0102dde4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -292,7 +292,7 @@ static void dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 		*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
 }
 
-static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
+static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr, bool is_valid)
 {
 	p->des2 = cpu_to_le32(lower_32_bits(addr));
 	p->des3 = cpu_to_le32(upper_32_bits(addr));
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 7417db31402f..979ac9fca23c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -92,7 +92,7 @@ struct stmmac_desc_ops {
 	int (*get_rx_hash)(struct dma_desc *p, u32 *hash,
 			   enum pkt_hash_types *type);
 	void (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
-	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
+	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr, bool buf2_valid);
 	void (*set_sarc)(struct dma_desc *p, u32 sarc_type);
 	void (*set_vlan_tag)(struct dma_desc *p, u16 tag, u16 inner_tag,
 			     u32 inner_type);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f612f2693adc..3ab1ad429aec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1314,9 +1314,10 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 			return -ENOMEM;
 
 		buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
-		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
 	} else {
 		buf->sec_page = NULL;
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 	}
 
 	buf->addr = page_pool_get_dma_addr(buf->page);
@@ -3659,7 +3660,10 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 					   DMA_FROM_DEVICE);
 
 		stmmac_set_desc_addr(priv, p, buf->addr);
-		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
+		if (priv->sph)
+			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
+		else
+			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
-- 
2.17.1

