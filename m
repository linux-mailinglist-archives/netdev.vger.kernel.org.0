Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501A42FBAEF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391287AbhASPTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:19:36 -0500
Received: from mail-eopbgr80093.outbound.protection.outlook.com ([40.107.8.93]:54406
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390848AbhASPLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOrzfQz1yRx8ZTa8yjsSdcj1ah4suvYL6Je/sU11PzWPg83oWj2Bt20kTs8KPgMlFooi5aPn1CWV/chweVfIXn6Qvccf+VberAt2iiRstU7ZhNArECgkwdJel/TAoKIMSWAK2MY4NNJyTda67r51Nem84MJ7RfVC0eRwfwUQDVu+oUfUSmjT5I/qP36AblJFgZUbzBt3S+fji3lt9LXAripCoOzrYULVrTPerH/5r5kXsnK9DNbotPLs+3CNbtAunzSTtuvwwp6P3i1gOq+lW6HfGazWbL2WkmbcuShzDfbHnJH4arKMN2t9z4sjRS9+vCyuv0Po9fgNvXdftynYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbeuYQ5z0yv0bqY63C91Xkj2WIbCJKoREPOQvXArM50=;
 b=ffOPDXytVicZRKRQUNCUuOPBxOHn1j5oVI3YDARJlOEUjPwTBLkDUDNcRRNvhGeelJQFXqt71bVEPYmtUWJuG0lKkyTvE29cuZh6gPZityEvPI1Db2BgmvmcaBwud1/yHYf/EEeF32Lp97aTXDtFbD7gMHXAA2LZWK0LjtghP39hY0VtcVGADSiMp8dnms1zuIAXy/BECwoBLVoo5IQVKJRgyshZSWPX14/lnAHRFmM1br71S2C0sCA2SsRKWfv4vBQvFw7lYkN0lPJUsRAmJB2PgtuBU3Kr7yjIQ5/3+SNsOX7aCq7kzRwfe8L2XduEvvL+b0wg0S8KVM0pUUmgeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbeuYQ5z0yv0bqY63C91Xkj2WIbCJKoREPOQvXArM50=;
 b=mcmjpHyDvqCXaN9uwQE+PNI81czZBDM+6pYBT6T0wGN9GLTF4I2T2lhJLcUEWCmgl2CGKZn0srLTui8IvYJMSenoKytLcsPJe+NggRhq28b67GO1dD+GGgjEvlCXIJeGmRw9pfMpZfPrbHkzcb5izvSBhNphoeVbgfh4/SHKkuo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:05 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:05 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 04/17] soc: fsl: qe: add cpm_muram_free_addr() helper
Date:   Tue, 19 Jan 2021 16:07:49 +0100
Message-Id: <20210119150802.19997-5-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c2c460a-6988-4c07-fbdd-08d8bc8c2999
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB192253D3E918B6C15B63520293A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: How+uVAyzJBgCKr6ie3hUNWnQELY0W5+DpQmQP+mBlKrnnv+mzmB/IDsO9QT1kDtZXZQWAm6oVO797ZXWUJKJGr6tku8BF/lG1C7cba/gv3aCN6uNI6jdLUSTKEt3mlT/vMj//UoYCe9Wi1YjweSZQ80ao0Bebpy/b1HQpp2jmR136g+f1p8AeOoKuWegXyhy0yrE7KZyT5W6KV8OwU0a4Kuqc42pKU/4yUPaukR7BDVJYzZ4uwi3aZhW5AYXWkFyfrBJdEDW4a36SZqhLWLx/9WrgTnIhS3VOgi+dFb1Na0pFmqHegONcI49CmmdI1OOJvR01C5eWYIWYb2fKf3bA0JsRDwrymQurAm8Uvgu+8XAqQePO2RocbSIMnQeDl9Y6T6otVgSk/F8ubQlQcwyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wCDgn8Rv/FDfY+2mGQF3BI6HNekiUsaWtDEqcBwqnOxVc8Dfwp7Z0Dfgp878?=
 =?us-ascii?Q?n9Zz0DP2IbvCE3EUzlCssHiukyCg1DBWGxSbZO1/f+zJGPtnzdTOJ0kff1aP?=
 =?us-ascii?Q?mlLf8S86+UiRdYshMcCkkiO4vaKvwcrpRQHZz9OG3EqnLBsLWsmfg3r6isx4?=
 =?us-ascii?Q?0lkKLkaA6m1GgK6EX/5ijALjgDtEV9FVpDJPnEr6D1GPnx7irO+ktX8V015A?=
 =?us-ascii?Q?OWg0DO6J4kVzlS8TCE1wZRDQxX9DjCG8nIxD1bTZEPtIkM/qjWCjjFovICPe?=
 =?us-ascii?Q?mD9817jjeubIFqsYgx9vKRaP2tLfGRWtH4IkXO9gglny0/lZUoSUpnBT2WOP?=
 =?us-ascii?Q?5p21bbZDPrjmDZI4s0YPmGGZyhGcvnGFMZ9DVzaGUxZDB0oRj+DclUia1ypa?=
 =?us-ascii?Q?lHV2mG76TLbAfNWAZVoUXCnID5pTQ4LESCu29IlEYiHBgjzwfb4RGGWB7vSm?=
 =?us-ascii?Q?BUpT8WNZJVWGVW1d+2HlSEK45TgGCSDE6k0QHnrqcpRm8AGkdByCN5YGmNEz?=
 =?us-ascii?Q?IGrPrV6+eAbZTQusg/C1zI4OVpkqDDdWl0H3/VtZ0iTfrLJj7ZdLp6VTlx9p?=
 =?us-ascii?Q?oWZsz81Y0R8RzeUjjmK8LjqUEsdwYUPDs3IC3spmSiv1Glf4kyXEEgkxQqJb?=
 =?us-ascii?Q?iVnWYaMN89/eXkx5u5KEwN5K2bhxWLUJsJGPLafBOwrI4KOCGDP4oIJJ62vX?=
 =?us-ascii?Q?KOsHsUYkhpc9GoScRDpeWHEK0D7ELnH+GfMx77o57rR1NnVa74kTPI4cBYYW?=
 =?us-ascii?Q?zPhadeypozs4nB7kvqAuQzeZhkcH/CQxGCIZPSje7WwyzWKewkRd0frefT1L?=
 =?us-ascii?Q?w9fr7IVeO2RTmN3jFw+OJRODpDijV18eo8B0Sy9D4jJxjauMpzZevKtvbMaW?=
 =?us-ascii?Q?vWV26o6hhk0JfxEwLQDYcf/Wys7FFGD3CAlca0Kas6cQ41tMPNhlOHmdKBJx?=
 =?us-ascii?Q?+5h78pkAcMW9bCogv3B+ln0znOfxGtCZj/SieomjDCyA25WARuJes3HTC604?=
 =?us-ascii?Q?yeCA?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2c460a-6988-4c07-fbdd-08d8bc8c2999
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:05.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5wOqwqtMHdShuEQuKzB/J31NDg2R4X2Bug4QldmOLaSZjPLrxjupD4m5vWjNxgLJ7HCWFrqDoKVZVAEpvGSsowPRYJ2Adz5n/++NULVIgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper that takes a virtual address rather than the muram
offset. This will be used in a couple of places to avoid having to
store both the offset and the virtual address, as well as removing
NULL checks from the callers.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/soc/fsl/qe/qe_common.c | 12 ++++++++++++
 include/soc/fsl/qe/qe.h        |  5 +++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/soc/fsl/qe/qe_common.c b/drivers/soc/fsl/qe/qe_common.c
index 303cc2f5eb4a..448ef7f5321a 100644
--- a/drivers/soc/fsl/qe/qe_common.c
+++ b/drivers/soc/fsl/qe/qe_common.c
@@ -238,3 +238,15 @@ dma_addr_t cpm_muram_dma(void __iomem *addr)
 	return muram_pbase + (addr - muram_vbase);
 }
 EXPORT_SYMBOL(cpm_muram_dma);
+
+/*
+ * As cpm_muram_free, but takes the virtual address rather than the
+ * muram offset.
+ */
+void cpm_muram_free_addr(const void __iomem *addr)
+{
+	if (!addr)
+		return;
+	cpm_muram_free(cpm_muram_offset(addr));
+}
+EXPORT_SYMBOL(cpm_muram_free_addr);
diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
index 8ee3747433c0..66f1afc393d1 100644
--- a/include/soc/fsl/qe/qe.h
+++ b/include/soc/fsl/qe/qe.h
@@ -104,6 +104,7 @@ s32 cpm_muram_alloc_fixed(unsigned long offset, unsigned long size);
 void __iomem *cpm_muram_addr(unsigned long offset);
 unsigned long cpm_muram_offset(const void __iomem *addr);
 dma_addr_t cpm_muram_dma(void __iomem *addr);
+void cpm_muram_free_addr(const void __iomem *addr);
 #else
 static inline s32 cpm_muram_alloc(unsigned long size,
 				  unsigned long align)
@@ -135,6 +136,9 @@ static inline dma_addr_t cpm_muram_dma(void __iomem *addr)
 {
 	return 0;
 }
+static inline void cpm_muram_free_addr(const void __iomem *addr)
+{
+}
 #endif /* defined(CONFIG_CPM) || defined(CONFIG_QUICC_ENGINE) */
 
 /* QE PIO */
@@ -239,6 +243,7 @@ static inline int qe_alive_during_sleep(void)
 #define qe_muram_addr cpm_muram_addr
 #define qe_muram_offset cpm_muram_offset
 #define qe_muram_dma cpm_muram_dma
+#define qe_muram_free_addr cpm_muram_free_addr
 
 #ifdef CONFIG_PPC32
 #define qe_iowrite8(val, addr)     out_8(addr, val)
-- 
2.23.0

