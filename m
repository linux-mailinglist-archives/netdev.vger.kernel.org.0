Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D31324C77
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhBYJHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:07:30 -0500
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:33865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234567AbhBYJCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:02:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1BFysDNkhpR7ZDqEb446wOzVnV/D3aXsqOHEElhATNIXJPllp2rfEEPZ7AFIRREiiTDRafg1DXGtBkdmoPUhBw8Ws4jX+Lc+B6HD89EgB++bkANjUYjsGbyBGUVr7d07gU9lRk+zSDN1BX83fujpW2XYd9WDaVofPRIRh7ycHPPfq1D0DXc+pdRBjhRF42Nt7wP5NPHsTSRC9KQqb4dyoAbkxYXYcbpijhKg7vmxFFK/ho3YNG9VWHz0/kALkbIIOcchlPFAcpi/SCFvf6AW9TRglYMKgJHZCITtjRdkAymUfzqSnr/UIsNgy0QzZvdj9uSj9Ja9zRZNUOArKG9SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ktXabzYN9lsVz8M/CG/zFmo+LcpLpHAue15OZ2gEkw=;
 b=eAVC8f9QBT/AVlIg8W7oLLyROuwxHym72bOLL1gA4rVsE8QdyUBalIR/7r0K3wCYjlxK3HIRRZJ+nEPicMLeQeh5Pa5bdO42rdTY44djJKbM6TpX+36oSPdbB/a8njBtVxVFHDcd08mO4yB3Qi8QCp3cQoAbtAC1c9g/kgRQ8MYkpjbdIu329V6Rp+qKtNLPcVZ1Pr1PqRq2qLVc7T3rBmickyDBRr0Gx4EzbrGmfDHZS4O2gUjdOHJmBPcNUBFLGBR6rAFnDB/hYcOYKYAmRyrTKydoNL5KZBxOVnEY98oIK0jr/ettG6+aZHxlfF7Wp+LBI0biahur2gQqLy3r5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ktXabzYN9lsVz8M/CG/zFmo+LcpLpHAue15OZ2gEkw=;
 b=ni9lZGF4ULdJR95Utm9ViWLpZqc552Y5TWrGXyRXVcAAgr19j3GqZkEXAz02QG0L+KIPSftHXd+VE8ZUamuooiAZZdwFjnvNhyiKh2KjT7ltWtOQWmEyeydMhB6nJAs4r5Hrv35uRzW5cjuoTBwgIaJx5xy9HH1Ax/nUGKHCA5M=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6970.eurprd04.prod.outlook.com (2603:10a6:10:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 25 Feb
 2021 09:01:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 4/5] net: stmmac: fix wrongly set buffer2 valid when sph unsupport
Date:   Thu, 25 Feb 2021 17:01:13 +0800
Message-Id: <20210225090114.17562-5-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dd8b59d-6043-4507-6b77-08d8d96bf7cb
X-MS-TrafficTypeDiagnostic: DB8PR04MB6970:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB697077B4DF3D03D3D7F1F6E3E69E9@DB8PR04MB6970.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qm9gF/XrhB8Px2NuZIsXQRKpYuLnNhejyIo3hi0+1rrMHUkgGRMpPsaXTHwL5uU8dqo7/gPzu0u3Z037mDty1viB0zRs7jky9IyA/Qqof0v9f0RTkkS48Gk232h6yF6Ae3Mmg+u/l8Qs/TbPn5mp9OirOe6i6MkRzE5XFeJ7iDhJQ0yCNwTIe74PMKX5vORKBqUhKdkSaXfY2xe4bmxPy7Z/aL0gfXdoFdlx4+amWXrPeOP/Jcil7dw89mo6T1CLHjcQ838KBj8uyEAgNv5Yb8wzF5dS4fVwlxxDcFzirTzCNO6iMcnz0dwx3Qi/DovDfvuU2Q7QgZd1hD8OnKc/t+OrN108hdKEuQbWnxrytLcIMZqqwmSe8MDnCubpY6VR/V5hJ/xmw7vJO7ZbNtU+h03BQ9C1GlQzyCyOISlSQxdODeSU5jPT5H5+eSzXudWW/kz3e3LS+jRytJT9vv3OqQLT1t0TK6zj2t0j1fF4j9Yj0sLF1qVcYIUCHE7841+5Aoc8RRXt9FOvmmSxtHpMvFCQV9oCKaJgEzfUxNsYjBlRRvlIuhAcpP1f8T6kUR/vwfI+u05x8K3fwg2XrEs/rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(52116002)(36756003)(5660300002)(478600001)(83380400001)(6512007)(6486002)(1076003)(26005)(8936002)(86362001)(186003)(16526019)(6666004)(2906002)(956004)(69590400012)(316002)(66946007)(66556008)(2616005)(6506007)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Htaj+H6yCZAK933fHbwgWMbVpZVh/Vo6RtXvIxLTUdeG9uDKTamt6W91jmVe?=
 =?us-ascii?Q?Bz6t6aC/yGkuGovOigv+oDpy5nMqs/rIWqc8xUEswX85XwTIrtmMginzQIdr?=
 =?us-ascii?Q?0VsHwnXVyzrt44quPYAyT/YnTz2v2KMitPf6aeGSfZ14W6vfD97Ela35MwAE?=
 =?us-ascii?Q?aINUvgCEHFWO2pboMehCMQJF79F1Xoa38XCvADp0uhzoCoVcRreTg6Tuaqfz?=
 =?us-ascii?Q?h0h38nb7RH/QU7v+AsUPhy6cgWlen5oVclDfmPHusj3Yn9m798wwolSYD1lJ?=
 =?us-ascii?Q?DRmvWRdZ4OC97CmnwsS0guFQMAUT6g3xLVG0ZTG1KR+65dPXHj9YMs48u358?=
 =?us-ascii?Q?+Z3l7YIW7TlsKxk794tplvKJa2Q9yx6s1QTzkQ1/TytlfFtfcMZjkazwUXFi?=
 =?us-ascii?Q?W6tIdK/OldBkgCGeHnb3Ee9LuNk8tABrOzhmNU76+t2DdFw+G3HtHYlz+gr8?=
 =?us-ascii?Q?Sz9sQRmN7dySWHwY9wMhxO6hwx9ap5px3zYdeutp94Qgtl2swvd2b4rsiSpT?=
 =?us-ascii?Q?mc47Aoahvy2gtogJrOnPEOGdQm7+8QjOlXq2gnyMewnHBsSDbrL1z+m3TNiF?=
 =?us-ascii?Q?jBR6LNktO3dF+YMFItaTKCAoMFH6Rph6n1PHGAOoQ3IF94kUCpZMiZ4Wxu+b?=
 =?us-ascii?Q?nwneY/L5EDz7w2rK8NlUgMTFbfAyc/AQXxLpDw9wCmExhKzOa2paMlKHkBog?=
 =?us-ascii?Q?WILVHjU22VNRupLgrNfw37R193HviFfiXaBMgoH8c3E3OyIOXzHy6dIJqjsq?=
 =?us-ascii?Q?/SgqRc75G3yaTCp+dK5klEB0QeR1odpVVLX6DvJf7ulhvCDKVeMnNzwTO9aU?=
 =?us-ascii?Q?9AB63dXNMf58rGqBcgbueyFtr6lXhhQo2vtKH2Acrta49vrfyvoD+W44NgJN?=
 =?us-ascii?Q?QhY/LM65MPmUqke44F3kXzD3eBHn8Pm9ki2J+LQKmvPNAgFtLmlpzQoigFtv?=
 =?us-ascii?Q?lVdZ0HCTbPyy+Gcn55TaZj4tyrcX1aGKpK046UOb/E1Ni2VQcjVnG7/0pNF/?=
 =?us-ascii?Q?owt1H9OeK6LJ/++A3fmlvwK0ITfNHzNQeind9nHzSUtrfuX2xBKuLXoJkym1?=
 =?us-ascii?Q?4S2nelpqxdICxHe/vySmxcCeDQRjRDUwC35DkOeN9FjzGUcvLgdDg/Dlv/EN?=
 =?us-ascii?Q?E9UIiXMtvOYNuLVDzPDrIvELldO7d5xGMt5vtBSBzolVTsnQSNVUqkRqG0ay?=
 =?us-ascii?Q?9IQ5yrRcuQULubNmsZrzjszalfDL06qRXUiAksQCP7u7wHxnG8RqpmiLlYqM?=
 =?us-ascii?Q?TaNevhg2z8ZwNvH6v5sHfBE/G/byk/y0r94IoEmWOzTKWycV4p7HznMm0/3u?=
 =?us-ascii?Q?8upr0fSrCOdTa4Qjs2Foz/ly?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd8b59d-6043-4507-6b77-08d8d96bf7cb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:41.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAaTe334tNH0VkyDfM4pt21uxEsFC0qz9eA5WFjxuuO5hR3nhkXc1T7ApyQVMsuwdEFe5NTKbvuTN2f3kKPWxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6970
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
index e509b4eb95e0..3d3d9038f522 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -533,10 +533,15 @@ static void dwmac4_get_rx_header_len(struct dma_desc *p, unsigned int *len)
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
index 071b6bb3b21f..6cf6ba59c07f 100644
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

