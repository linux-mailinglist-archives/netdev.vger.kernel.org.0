Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D52F119B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbhAKLh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:58 -0500
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:22167
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729760AbhAKLh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXyqozjlcojVnAB70oHsDwlRAKhUUu3+QQt8Iq1vtMYBp6uf2L+lIbkdoXJRl65fDZEkvKnvNg3xDh8ia4VjsI75gyYQSR6PcLRKQlSO6myixokDmTVy6Oz1W3hD11BHVQDC8tC5NxAq50wB9zwHgobhm+nBU1wJ16aP/ecQQgdR2N4px24zcAYR8B/aNo407dGgNynPC/KKm+6R8KCTYCtczWt+j1Hdu22YUmDME4rYO1vScNbTdchUowF/22Hw5vhNqCiJyl6TSyBP98sObMM5Bs53tFsM6nZPzW3kRBfOBTWdY+xuaIdg0+/a/G5QHkLlAZsyj1iXDfS1xnhN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PyrxR3aJVmgVFlha4+BYYd9Mxl+++J2D7PKdmnWPfo=;
 b=ivPo+Fo9W8Ox7hJgTp0byRYDoLmxrBb2xdZMkIid+AUBMMeOWqulJWRGrf7AZjYnHAVvP9kUqMEq2+jCrWA+kScJSY9AkkcdIXNlLfkNWlwLR4D239MaH7hHby3J6AynrZpjXcIctsYGg1xC72+sFYoYQoMlYLsFu9IZ8GMWMRoweNgug9UJIeoEy9uC4e4DBjgh3izzQ0iOOk++IZjQw2+qySU6cDm3ugMKnGpGlGs+eK4b1sN78/HK2REmtglBUYXaOqiX+N+koVVHIBGPFikxA87GRKUrMrAlCTRadLFm34jDgoKAVnZMBT8tYECc7b378UPaw5QEIeeD4/xjEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PyrxR3aJVmgVFlha4+BYYd9Mxl+++J2D7PKdmnWPfo=;
 b=Rx6ccf7kJF0kEe+INRLUWx2/OXs/8HN0drbkX9/GJ9FI6CXBBPRrinsgrdsoSz76AyV84hztvvXo1KhQVZ8R9nHBQsMAyTkhSO9N4aV8KlWUJ2NoqJSTc/Ythap/YdC3wo6wGVzrvcwojW2a5ehu0Sc7BPzakXGZvf4ZcOI/KD8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7674.eurprd04.prod.outlook.com (2603:10a6:10:1f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 11:36:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 5/6] ethernet: stmmac: fix wrongly set buffer2 valid when sph unsupport
Date:   Mon, 11 Jan 2021 19:35:37 +0800
Message-Id: <20210111113538.12077-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28a23278-8644-48c9-2baa-08d8b62524af
X-MS-TrafficTypeDiagnostic: DBBPR04MB7674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7674E1C41E286D910C15A00CE6AB0@DBBPR04MB7674.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrworm5LWy5hpbl/4kb94bANInBq72yuU9U1ee3pXjWuB3lr3NW6OtAHey27dbBavwK1F4xj5jkPpAmRcVHhb+PsL76riSWs0JOmUBcEi3W2BcOLZ1TEPYiKuWgvBkbPmBhYQu4FQdaBJez6wCDiapEjH3ZScYRQg/fI4g84uZiYU3mVg01JAovFpWWrG1FWZA/69soFUr/kJDzm22vrRCtmJLuqo1Ltmpm7f/pXqvI2p5pZy8m7IOUPg/vINYdeeHbVftemD97t8V3cwAOsWnr6ZEkLldoWKlZJSYbfOsf+uynBW0I2louZzcw/xCW7CaaXusVq3wxhVEchmEYOFdE2cg22U6z9zX2Zf5D4Lxl4DZQO7muG/Y3dMw+yPQNkgctlKnIgYv1/k73OWMK/F7/G/xlBGnQkyPwt4igQ26HgX88bqOQYsQfdT1LpSBXaCOJN88i/evC9E7dCvshSZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(66476007)(66946007)(6512007)(8676002)(8936002)(86362001)(16526019)(6486002)(66556008)(4326008)(83380400001)(2616005)(36756003)(52116002)(69590400011)(1076003)(478600001)(956004)(5660300002)(6506007)(2906002)(186003)(316002)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?My6w049/+D4QKnuyhz1HBqms+xC+zNOfPfH8DahJVph08tztMt0D1nXUvQZi?=
 =?us-ascii?Q?JfZ9O8Cf1fdkKN9zY0dyRQUvs6Jrijf/kv+MyfcjfT2LIQBZBQzPoWy8Iz97?=
 =?us-ascii?Q?7TvC+liYWZDv3fw821qMqYiz1+lXCKkIkrXZJBfPOtjajF0/Ch61lp4ulveK?=
 =?us-ascii?Q?tsUcx5a4O3Gu0OKsN2oxMLojWB/V19B3STldY0D457xbyPaWSCxAw9PIMh1g?=
 =?us-ascii?Q?9Vbz/glmvsPxDcAZJYCWsSzbnjazAjdNhuLVd7GTdcgBDOSnBbGZWBg3GBcs?=
 =?us-ascii?Q?42Bz4bpJn0hLetqKGT5eDpnq+Jhaw+DXgpha80WWvYNdKLTWRECQUOBHQBRK?=
 =?us-ascii?Q?I/ZfOEFiWnKNo/gBgD/zNtYeE1HjFen6YxUQZcf3Z9XrKqs5EfvVBOhVDua4?=
 =?us-ascii?Q?gSDX6IOQUD0/a2SOicMCLUaMYXYxny9lQ6OA7BojPPmTbIcaWl9LGytzvn/3?=
 =?us-ascii?Q?NKBtFqN338WzhitX/+Xxeq8RUOI3yQEGfdK1iROckjwq1DZmozeywesKwNIb?=
 =?us-ascii?Q?+btUBAYdS4L/kTOWaXSjDf0jozGxJivqLUe6NnIpvy4Z2ICsUTGF6bKI3BDt?=
 =?us-ascii?Q?c2YSUlcnU9ngOP6ra0RtoHvVeC1avJvM+3hkrYUU4WVROvCyNVhB3CNtrYN2?=
 =?us-ascii?Q?YAvgeDelUy6K9iuN8dKlE/Ly5GY1d2AOjcuy2r35xFa2DD+fOBnn7CGVLmQJ?=
 =?us-ascii?Q?Nr9aypz67XrzDFzag8/TCHs6HdDMLnHFM5oTk91FlFhlrLBB5UjzXmOhUgzC?=
 =?us-ascii?Q?Khs1o4RkVCWzjR9BkZiHAcvmNNQLn8fyEn9na0zP3rNiugzqcw3190ymGatb?=
 =?us-ascii?Q?bjoJeAeiW+XFdc8kxqbjrGZfBP0pmMfHGrWUwvz1IO8Mp3+hWXV3jj/z5P7n?=
 =?us-ascii?Q?Wr6QIHnq7YlOuxRCAvyuBapjmxPEiaFmpQng6LcttibtX9bd9ODRx6YztajP?=
 =?us-ascii?Q?L5kPMCIYxFLZQLcy+lkCRIeqBKWSiZOXYsEM3GnuRMvklAJnpVuGVvhuOymS?=
 =?us-ascii?Q?t7il?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:31.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a23278-8644-48c9-2baa-08d8b62524af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVXcxjo8rn9dyMEdi1AiWKmJ7M9yL5yeHZUmn/5+1ugxNMjcs+U0SqbKfEYpmPK4o8VRaTv0k5NvZNVFPUvqOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7674
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
index 8e1ee33ba1e6..aecba8b1302f 100644
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
+		p->des3 |= RDES3_BUFFER2_VALID_ADDR;
+	else
+		p->des3 &= ~RDES3_BUFFER2_VALID_ADDR;
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
index fc5260cf27ea..6423dd5ef45a 100644
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
index ca24e268f49a..e30529b8f40a 100644
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

