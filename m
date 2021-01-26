Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005A303C6C
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405526AbhAZMDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:03:25 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:42486
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405572AbhAZMBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:01:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfC+ik79IHdh+B31EtybcIIKzYumhdHWFd1aWy5KiLa56bQ1Ylwff6MegqDfJfQD9wZrfDWUqZTwiH4sPhWRP/63UJVsXKQ9lKP1LLIPA4LYhMG4iMwrUKzVnF62aneU6g8029bhI4QuttGcHdYNLY0dgqkrdbtfXROcswSKJbCJnCbQlwZ8h+Gnk18R4lKKIjpjqniYnvY0g4hVgqfDXTuA2SvFv4Vcw6YunOVKoFNzDbClwLMX/TckjHHWOg9lM0qY1Nc72Zn6uRnxrMGyHGqsD8p5N36ivjZuV6mg/3AMxaRUmyR7sYaQqR3U3XcqevJglGlEvumLjWP1Wrferw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMRxDvwDwkvMcjpCs1UZsNQPdAaHdEiPjArZu97F6iA=;
 b=SPMT42oqiqq1Itj1LIcBcAvBLy42GTsmD7UnJjyvh4lZ6YqQOFo4F6usZsrDRWi8glVjBDkse+xJ7upAk8QK0Kuu3xQRVbZzrR5/iCtWJweuDeF9sjdOTnTKnqLBw2Zb28BV/F6iw7qB7VhRRYEZDDiUdITDUR+kVZXwKfuY9TAHGeS2bqJNv0BE3g4bDrF/mM0R1xtmgJfxfCMyiOpsR83YgTIDjGcLyiHzkGew5YG4wNbSloGA15Rxqh991DbPfb44IlvwuYaxrfkGWYbpUMdDIRWvSrFZfMWUli4DTQS9D//iQgcEFeaC0d94Lnf3WbN2jLfVwuXG6lev4IQ4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMRxDvwDwkvMcjpCs1UZsNQPdAaHdEiPjArZu97F6iA=;
 b=Uyzdx5v95F93prbdVvc/pcuN3zjQVaibOCwDxlUXnoJDA7Iqa7kbzQpeaOeMjXXQSS9H+udBnTA1prrnpySLr2pjhLAeoUESG65xHxaYZe0pwL6bVTg9WLaFETo9/pkX46sMwqkALqa6zGSowsMa3cTDVhQxXVo4s49JHIc/Zpo=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 5/6] net: stmmac: fix wrongly set buffer2 valid when sph unsupport
Date:   Tue, 26 Jan 2021 19:58:53 +0800
Message-Id: <20210126115854.2530-6-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5c58bd6-3fb8-46e6-4a5d-08d8c1f1e3f0
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971547D42877D37B7BE8B64E6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0ZUY4Kze4maEl8LSsdH+d/EzgEUYPJRPjTnuHz1bMkhuvgZ6l8PJjB9Oh0vznC3EBrPeJw04K9LZ4Wfr/xyYh2r31ay+Hchz0lCGhDmxmDjlOFqdZgNZiR8gfEWle8I4lZIWPRnVn2W8KE3H2NOeTUGEufWdK6eK7iIYDOWPofAh3wG3nvDWC3155GMhN+SJURIto5Q30Jnvy/oKcFwO0WoUJdkWq1m9KgrXPFgXFla3dZsUVGT+NevGXvjHZ1DdYpxJ2VVRph5yRLcEewL7rlvYrdMyNAwIJUV7TEn0MfQMhNT2Ew1f3s2c1syiRTbVzUZ3P3Iytt6oO8kM6+Mox2ryYV2Txhh2R19rKyGqzfGELzQaVp0X6V1xOhhWADyu6RglKXjznkQfrh9gFpkRGFcGxGoc0+JbSbCN/aBKZzJqQR4t/G8bMtwzcCb+tFIxJDsYq2UeVJW1HDl5pVDOeZyyn42jnXLKbEw7QEeitYVvPJwbDp+2le5aytQEMqlGX65j0mm3vII5GVqhe3CZIdovRCitEfywi3m1hu38XQev8F0EKn2rW7HPG2MYJEfKk60nCYb3LNR2Tqb9A45KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(66556008)(86362001)(6666004)(66476007)(478600001)(2616005)(6486002)(956004)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kVJpr0+FIeakGPm/BAD37Kpgy5DwZbgSOwyq9+kjnU7WOdT3JyeOoyphDKn6?=
 =?us-ascii?Q?0okujDRTIVAymBfByOu0WCqvv1bDiehsf5wQN5Xp+g7iGRa92fTjL9+4QOc1?=
 =?us-ascii?Q?aLKyvWaIaLlX7mchS0Sr1hBcuWrJCU0Kl35MrhGwtzlt1Ytvk5fdUNw/t0QF?=
 =?us-ascii?Q?h5Xn+zR1zdUj4ItU5XcsplyESDhdZswEEPmb2CfeZGKnKb3HYrcA1eOczQMj?=
 =?us-ascii?Q?4vEZ9dfnY2/XRaapkslgAKLeX/Y2wlPl+TWlzmny2neoVEXXUKIRHYWaY7RJ?=
 =?us-ascii?Q?KREHMHiel+P1TS44KD2bRl6jpEp6varWktthH05bgDGzHjH0055nDjtYUDB/?=
 =?us-ascii?Q?+5wOKDRDqZwy4eZE/Fs5Y0bMJL0ex6NMgdLqUsAjy/5bheP/f4Hxm3HBNir5?=
 =?us-ascii?Q?uwPeoifN1We+k0yMNlCWmGbPj6+t5fZkGVonBcpwW8+cETEwnTkLd50ykSyA?=
 =?us-ascii?Q?TESfDurFDs/kD/OFGKveknv7dzDmzz86gqyJd6MgJyYG89bNm0SNlRNpimCM?=
 =?us-ascii?Q?Fs29WwO+sd0l86JWGSshrxh8U1XttpMg+sUaf8Dj4PEeCT5jd6fMtDB+4WpM?=
 =?us-ascii?Q?8pelRaDftJGM1TutraB+AEaBJsyazsK7ENW/dIuuRt/qR24a304CktuHAfTd?=
 =?us-ascii?Q?J6eA9hhzsUkRYyU7DppIRsSxmpTznSGa4VzH/5K/+2xJXtDHahmwV7Y2LaV+?=
 =?us-ascii?Q?3wuxMWjEi+QeMKvapzL9RwJU7m7ym7ssGQGLuKidPCtsmAW/29JQS3+nAqTI?=
 =?us-ascii?Q?A+Yf6LM8MvGYzMEHX43NSW+Dpjnv9Gnza+j9Y6sTrgEBnnV4Xu9BnXkNLJjD?=
 =?us-ascii?Q?0scl6E6tmLzQXXiJ4J6js1WDfumc+Cq1tH3vcNfIlJkdX+C/WpDcBXjv/vIG?=
 =?us-ascii?Q?22ugbd2rihL0TOjMp+cZPRDAM5XmpYfrJlt59E9R9DbXbWka/bpmKIDN1FO6?=
 =?us-ascii?Q?zQIG1UcrOk/Y06VE2CvrbEJxV28oBXCaJrThLMEMm8SVO4UNeX/Bchebv5Tw?=
 =?us-ascii?Q?7fwg7G0XBPrqwkA6G0F0V8B4qIycB4sn729++kc67k+INnT9NDruP5BN+s9b?=
 =?us-ascii?Q?jxXpZEQi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c58bd6-3fb8-46e6-4a5d-08d8c1f1e3f0
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:53.1088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0NMFf57R4Hu3UliKzvyf9DAFU2Vy8FIz6zzLY87ku0ckfmovdWuCsCf3sYTNBFeoFmrZ9bSv1ZT7gDEP6fWOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
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
index 8d1cc17a99a5..2505e314f543 100644
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

