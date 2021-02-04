Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49230F1FA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhBDLXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbhBDLXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:23:07 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60261C0613ED
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:22:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSjOZOFQY6Q+uZ3fHfWp/Z1X5t0se4+F+6+Hr4OC8uDpotF1LYvWEQq5yheqFN2bklNKcksUP05fHZCA8i5lHGWDjMymtYobfTr0CNVOqaAVQRTvG6vjIT28V/yfsjmIBbUTmhA3mT1wnUc1Vp91Ct9/sjbdBBZpEq4gdbhc9XpGXJQsJOsMbbww+N2yJDGHp+wL1nGLpk+nlf7h3ESvE6oEoYuidzXI/kLW5bfGOkDllv2gKsOYHwMYhtdEBhvsJRY0iiL40+tx/JGKytsM47UEbB4xsj64x4eEK0U2jQAUFmJ+URQoIDSdECgfowEiQUef1HVkZq2z25hLr2auQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mkYLh1wb4mcy073W8L8F2sfckCA7HZw3heQjg0qbqw=;
 b=FVGSWrSwUevt6kVIeEo+T371A0S8bb4l+FeKm44dpfDT+jlvQ5kdxQf8uBOEHqSAoTTHxsoP+cLVl1Dks2uQ+ELZPKxQXA2KaMuwUEr4Z+MzgP9TlOWYy03t1pVnvaH6wrdwcyFRp1/Et/9HDZAq0e/9XhnJU7WPz9necwz3v8b4Prik7p4GGhJt4ZxIo87F4H9dfon295eBKoLdgiccPuguS0tiCLf5QtvhI7u0A/yc5kKFI9kKw0fUiE+vwV5M++txOU7D6nPqlaMc8GtX5ZrH80+A/lwpw1brQatGnknL9ZrwLw1/e946o086OxBGDw46e90IkoNz6EzWbeOv/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mkYLh1wb4mcy073W8L8F2sfckCA7HZw3heQjg0qbqw=;
 b=lBttjaLKF+Ul4L8UWAEfuxkjqZsHPh5HW5MJa5weVAFFCnqLTAk3IqrywYGLtNUGeunTmiG4YEFm1fdt9VQiFDasKMMUcGc5XC7Sh9PRu+efWGkaVmhRFh2uaMK6LQSKNQllYHV9se9nl0zmjkTS06jDbfoD0fq78B6hjp5u9r4=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 4 Feb
 2021 11:21:53 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 4/5] net: stmmac: fix wrongly set buffer2 valid when sph unsupport
Date:   Thu,  4 Feb 2021 19:21:43 +0800
Message-Id: <20210204112144.24163-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bddba885-1c2f-488f-483c-08d8c8ff1163
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6366700B494D2ECBBFF69A76E6B39@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1siGXzyUGaknS1KI9SQ3MzVnrAq9EwRKYC3kp1on4b9IBGKN8tCk1azLA8eIHt1tFqTRTb8ZrWWjyYz1Z/L6Vt6Y5VLGfIExQSfLN7O9Wu4rsOipHK/dDVjqQ2N8biK7NAgBXzA+DeS4lMPtOlbk1KohB0FDcqtQWnOrj0Y9Ta80w+llXLd1lhfFYypiRc1zcs3l7LomyMfTm5ej5QUQCPwnjjBj7lxyGl4/JLPh+cTAr6P9LXMYKsT16FkZGk0XrMJXh9anqlmiRkO5/rgh2DA3rhhrYHdGVO0JIixNunEUu37ghf2m5yD42qKMxzjQUyCNSRnijUd8HFjycpFxQKStKd7XNmjoAaSjT5Cw6+JpvLatj+D6jYk6rWI2EqQ0kLNgmkGrLezl6braHpX5BXASPCqIliokjP3ipm+pC0JGMOhPYTSsdzNNl/cON1ykJR5t3Z64NRTsXxRbTlZafUZ9wrzv7D7h5jSm71jQ9j+9O+MLgNBcLEjWv9JdMxsrAKALDZCGTfcFnJRmSbJLdUJyhbAjv9gHBKkWkI6EEC8/qOCQ4er9qtI+wWybYd/S/J+86b4ZGkeZAc0Hz7oT8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(316002)(83380400001)(66476007)(478600001)(4326008)(66556008)(66946007)(2906002)(26005)(36756003)(956004)(5660300002)(8676002)(1076003)(6486002)(86362001)(8936002)(69590400011)(186003)(16526019)(52116002)(2616005)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kEyTwFYEgukCjcVIHBQkoTBWItMRnk1vwTkyFvthbMRgAa+xturbeqIxsrzD?=
 =?us-ascii?Q?hJyIulG+Oqzn+FR7FrO4U7E6euVf6IyC98SZE4RJkd0ymFJnsF/oYRQVAHVw?=
 =?us-ascii?Q?nUDLx6HvRiiWbL/RijvigL7FJK7kIyAsb36c5lncca14ykqzrLTNopnckuvG?=
 =?us-ascii?Q?uBWa6gxNfpUe8g/P3nADMLRe08PL2TOF/t9Ball9l5QchGPKNtShg/PjJJAx?=
 =?us-ascii?Q?fJfcRTFqvCJeQ/lD/zmJBYFgaezgB6Zi4yb9PO4yYHiYgXc9qGkeDmGpbuMl?=
 =?us-ascii?Q?0r3m28VsYl4ef7tiq+wqWUYbpyQ1fsvXvuFO1mFp/QX3/vAxrkNHc0Pg2eYt?=
 =?us-ascii?Q?mriYIKJsQWXs1iDjyuydBTiUXzwETUQEowAKgRH/8a/WbPpG1oAPkCz1mRxJ?=
 =?us-ascii?Q?pY2Gt1AShV7OOldAUp4khhhUU30GEGWNm+2apjV0B9QvrWP5kdvpHlUPrxd6?=
 =?us-ascii?Q?Eai+kWBUO1MY/4Djcnj2sDtpSClogtOKuAAwV8Wy3tG5lJ4RJY83UIV8vuCX?=
 =?us-ascii?Q?0HU7SeqD0CUf4ySaWVnQgtVPSsNQ+HLZgmHeunqt2R4eDXBp/eOGB4vDwLtB?=
 =?us-ascii?Q?YI1dtFgZNOA5Gl+rDs/WYco7fUQBckdnpvcjeVTy9F6odxL0JBRCGfR4PTiW?=
 =?us-ascii?Q?ohuGW/DBJqCUpQY0xMF+4hexEH8AYEG34uj18lVkq6Db6VpoenCQYeYkGI7p?=
 =?us-ascii?Q?5J8O1xPjFOqdp2RYh5m7bgRoY7Wuk4kdZGXNsPZ7yX9qjrXvPhpQ+gsLJI62?=
 =?us-ascii?Q?oAso1IO+emcZamSMnMCd1nQOfctn1hV5kfAxvMTsDA0dfUYhrDqRI5yqVwAx?=
 =?us-ascii?Q?e/fwjygx1wt0+kNm9nP4UPB/XTsbBpto+/7LGv3UcE/wAEa9qsWqfAG4UsTb?=
 =?us-ascii?Q?5YW148pfOi069C+XnqXNlvjKiE1uLoTaDaFNk9kaxBXuLRfrFHYRFXei9Pqr?=
 =?us-ascii?Q?PEHz8I41WViRF3//y/di8yU8ZgDK0P04Ip7cjHGiBo5JK3HNwaa4EBsH3mG6?=
 =?us-ascii?Q?Wjsch+2pIEzJ8mVfjuDh4VOQvMDVpx8lpIw1wAD2PcfQXOR3kFmyCQp7ksH+?=
 =?us-ascii?Q?FN+RnFbV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bddba885-1c2f-488f-483c-08d8c8ff1163
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:50.8921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YecxwWX2Mz/9O20r4TASmeHr5iHW/GZMDmCDx17iMvu6GIKTWwNBNlK+LKxg0dO0zyQ/VZHP/NegBkVp9o8/Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
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
index 6f951adc5f90..af72be68ee8e 100644
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
index b1950fd4eb80..04ba77775e52 100644
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

