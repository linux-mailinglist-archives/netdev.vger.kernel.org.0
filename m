Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849744D5FF7
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiCKKos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiCKKok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:40 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290E8156C7C
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2ENpbhrCYD4DvNFcSCIXpGc5sVYsTQJ5Tj5uHCkEPXQ3wiaQCz30sieZ8MJ1eDWruFBq14q4HhjPUAdiNuiQWW1qHJ6vhNG04cPidXJgtYR//E3pp4Tu1+XGwczTuY9rXQusmibEe5WptCbF2rahKd2Bq+NQeWSFgLG8pIrD3TQMaFQZFLcRDpnM3ghR6oZrcER06/vUwJQ+b2GNxZJp2qM75iiKSlv2DK2Dv4VwEYk2jMN8EwYJ23tSMD/oFwVLIzXReqd+QK5Qw5NFgzBJhdrJyVk2H/fMSP+zazfGQInvGI2L+n0i3xhSh3LoMKzTh0LW0ASFabZ4MfcL38s3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAXe8/Fr9qAUZFkJpwyJ7FNqN9dvhUx/pHipRTHIs5s=;
 b=cVYO+LzYLJyDJXDxEJiG/ZP1f2Jw01PyZQnMwT5Zc3xIcdP+pgp3pyqZq+vX2th5sVrwx5NUCE03QGnmq2l3UrWNGFji50CbwfKBExgUtFObIbhIxQ9EO0i+2aYl+3fosqW9sBEAcF9whi8sr4FwMxxhmGzAFaoWKhf/m1kri3tlp4MsFoMF03wSnV+7YAB7mqAKamIbXmBCpp9jvFiRLr+09YLOLbungfMyfQ5Zjar+gJCe+4+MxumOp3i6RUAVCyqPDaSxApby2BjfwF+V44xZaq+7uBrTM6iPU/bJo+naNTmJYOYV3UqOfTwgNQeFxDxWgOpgoqJ1PXZtr2BOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAXe8/Fr9qAUZFkJpwyJ7FNqN9dvhUx/pHipRTHIs5s=;
 b=Mi+mDxz5qnODBr5fj/oifZXInuF/RUxyprAg42/tl5k/i7c9JZyPjrJSvZYflKYw2VOmwR14P4DS53EAeVsZWL0ksrXFfjJrqljPLtAGH8sbMO0PUQRWQiQEtvNCZd8312uC5c9r9mWOYuwCNiKaBEhYX54+xFSVwDnqH+x9CFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 07/11] nfp: use dev_info for PCIe config space BAR offsets
Date:   Fri, 11 Mar 2022 11:43:02 +0100
Message-Id: <20220311104306.28357-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7916230e-56ba-413d-fba2-08da034bfc05
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB47485873576D40C4F88252D1E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KqFyztwVTyJlHQsSwlU6JYlqAERGf2CYI3FTNxn1g+lqoh6UAm8LC8Hwts8s5VTqb+guDHNBnzyGtwiawHwIF45dglzmU3VTtWZWcnxiStWdAYzVidu/Qn5pg9iOtJxj4WH/IgQcwblLYv29dkc8V1v8NGir8e7SzNW3XAA767T8U3dTnQmebLBdcAoyq4yOSWiM5E5f51doa2Z/ZL60dqVJ+jEoC0uFN+wqTYkuInItDcrwdN6ndeYZHSPMdLMHLarh94h3LZ2HAfNzEXXuAfGZF3mm8H7a2wE2YS0lwIiVidAvrTRl5UnyUuhiXiDtCDVlHhRi42qCrPBKKvvuY2hfXdpAfV+xqbEKZRwQQdKWl+/Y08hCPj9v2Yp+fvsFQClR/6iR6HCkcW0GJku1Lzbdedttqhl5OntV/Hyh9AzQlFgB1aWxs3u8n11UHqnHAOrqAIsMPxFR/JR1YSnf5QhldP72HLLmFf1uLGg8vqzSGSXngNRjiB1lHC0+gQuMh6smzmaw2yV2ykLMnh0CTtKDRQ8TvdmfaEK+a3V/EZZq83abevCmnG3wJZyNxfSvcgZsKZxDPIzEdjqDGWxhz9cP2f59jaA+QrNwmWYKvmiB4QJZEcxsA8zYJP03f7hzk057XOZxg6rA6d8UaPGd1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qBxwrrqimCmDfL799vUIXLo8cO8Rx1sNWYSKpP58XsYF4airmjjoPkd99kNH?=
 =?us-ascii?Q?vgGnmm7GJm1G2OfwBiMy5iAw6cENwKbLd/OzgrVvrlU+ujg9EptbduPqoiTN?=
 =?us-ascii?Q?naRlIZUfhiIz74uzgLDeYQBP9ViMxskT83lHRMY6conhxc8dxwTaZ3OpuTsi?=
 =?us-ascii?Q?J6j3E/VLEq6ZWE0+cDFDKU5DKjNQOjO2nDSuOjuoPn3tammM5RL0LwRD+Woj?=
 =?us-ascii?Q?yh/wZyVLvznWndY1L4NAUtgrcN1KM+o9tcSdb6wb4WHDp285hwzf9e7/4zhp?=
 =?us-ascii?Q?g0pcT+ipiFQ3ITPtM/CowQYEfZ4D1V4+m4lU0uyRkJw5jwJ5fPnCyX1Hw3Xt?=
 =?us-ascii?Q?HTas0s1L5XJQkXl71cvq8h6eN8y+7jDrFKSapELO1DWPkukzGfTPIaeJgpEF?=
 =?us-ascii?Q?b1iVk1YUWGNzacWwIaFAxXhggCA3mkbBXf0tmWxHbNuV++wavH8hUM15WSrF?=
 =?us-ascii?Q?FH7jESRCAfaUGJI8BUcEFrHYhdVQfzZGPWTbH61fUPcLipS78aZ4NQVSv3kr?=
 =?us-ascii?Q?ORsOtDxcgVgdlXpVhudEVDDt18ENE6PRLPzyf917Ql41Lhyl0hDSiFsjNnKH?=
 =?us-ascii?Q?HchHFfg9YDtagqdnc8YZQA/d7jZgb9+bSkOcEpTOlwqG41+5gjC5BpZsolZ+?=
 =?us-ascii?Q?H/kYT9hT5KDnMcJzjvzkNSbOGKeIuoXmqye4wyRSfIdHntmbtRYPXs/gCmJu?=
 =?us-ascii?Q?cKjZ489HIGCYHx9fd+EsfbA8Ucyf1iKvSTrTDnozM/53Q2iUWfJ3rAbByA2u?=
 =?us-ascii?Q?QIX3Ktb4HuxpJX9wn8LO521y+XJTMZPsHqQumIImfaUxQ5d5mex3Llh2tBNI?=
 =?us-ascii?Q?KBQ3YBRF0D678UKa3/dEVKxTNFFq64kUIqgLrGdQd/33SgSqVFPeqtTnuoPT?=
 =?us-ascii?Q?/ZOdvlHReIpL117XvOEkzhlHcW61sA6HcTpuCAwiomyH8/DaTa1mkqdlib6F?=
 =?us-ascii?Q?dZCbFMpvHCTsJFTM4TUK+7//sYpqQYcuJO5X1wGiKOpiRCWKySyD2QaSFVk3?=
 =?us-ascii?Q?WEv8znou1mM3LAWsKqyypPvRyO2nuBYnezysFSkNKeOyNJEUqdtIKjFdm98l?=
 =?us-ascii?Q?6YutkX1CYJjSLBk9fFmbmdFbegSLHVNMvaHo2BK+gJYbG2jvysRbFk+ddywl?=
 =?us-ascii?Q?y0JcSyBcFQm14HHgt6DPFxFuUpgGcGKt1WeBh0T9tDNYXHbz3f/Q6IqFiny5?=
 =?us-ascii?Q?XYCp+cR99VVsBg2v5FGrqgOLivJG3y6Tk/PnIjO/D2y5qZbLOCQDx4mWM9A7?=
 =?us-ascii?Q?8XvyG3YUza60Mw4dInJsW8h1YV3s7XXRBMCOCLoUAJRR2ESSg/LfBolEUG9h?=
 =?us-ascii?Q?232K6LXQsgb2YzV4TJRlDW2JtJM2UGKeoimQWCc/xJgEhSO+DUvz9NvzUgLk?=
 =?us-ascii?Q?41NPGt2tD2rKKx3M0aDF9enh/QJnMY2MhsUnjapa8EvIp0Sq/3UmTg2dvlLe?=
 =?us-ascii?Q?9WU3S+ddlUA4Ohi2hPMlouGcsc2STVSDv+I4KiNrGBN8Ksuk4C6tYTM4SI1x?=
 =?us-ascii?Q?YzdNqGYeLtS/vPVrqcacHK8wB9l8RIBABBSwk3UdA8Lt4wp2eiHQR9zxxw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7916230e-56ba-413d-fba2-08da034bfc05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:31.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vfd7nlhpECaq6UyFjd99Pbag485Q32j10N0oxoz9Y8KTL93Vap7zNMJrw/jMbKcETKFm5UKeNj7TV7t9onnjY8XAZ9FkZ2rfNImyuA5jLi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

NFP3800 uses a different PCIe configuration to CPP expansion BAR offsets.
We don't need to differentiate between the NFP4000, NFP5000 and NFP6000
since they all use the same offsets.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/nfpcore/nfp6000_pcie.c       | 18 ++++++------------
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c   |  2 ++
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h   |  4 ++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index aa8122f751ae..0d1d39edbbae 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -101,11 +101,7 @@
 #define NFP_PCIE_P2C_GENERAL_TOKEN_OFFSET(bar, x) ((x) << ((bar)->bitsize - 4))
 #define NFP_PCIE_P2C_GENERAL_SIZE(bar)             (1 << ((bar)->bitsize - 4))
 
-#define NFP_PCIE_CFG_BAR_PCIETOCPPEXPANSIONBAR(bar, slot) \
-	(0x400 + ((bar) * 8 + (slot)) * 4)
-
-#define NFP_PCIE_CPP_BAR_PCIETOCPPEXPANSIONBAR(bar, slot) \
-	(((bar) * 8 + (slot)) * 4)
+#define NFP_PCIE_P2C_EXPBAR_OFFSET(bar_index)		((bar_index) * 4)
 
 /* The number of explicit BARs to reserve.
  * Minimum is 0, maximum is 4 on the NFP6000.
@@ -271,19 +267,16 @@ compute_bar(const struct nfp6000_pcie *nfp, const struct nfp_bar *bar,
 static int
 nfp6000_bar_write(struct nfp6000_pcie *nfp, struct nfp_bar *bar, u32 newcfg)
 {
-	int base, slot;
-	int xbar;
+	unsigned int xbar;
 
-	base = bar->index >> 3;
-	slot = bar->index & 7;
+	xbar = NFP_PCIE_P2C_EXPBAR_OFFSET(bar->index);
 
 	if (nfp->iomem.csr) {
-		xbar = NFP_PCIE_CPP_BAR_PCIETOCPPEXPANSIONBAR(base, slot);
 		writel(newcfg, nfp->iomem.csr + xbar);
 		/* Readback to ensure BAR is flushed */
 		readl(nfp->iomem.csr + xbar);
 	} else {
-		xbar = NFP_PCIE_CFG_BAR_PCIETOCPPEXPANSIONBAR(base, slot);
+		xbar += nfp->dev_info->pcie_cfg_expbar_offset;
 		pci_write_config_dword(nfp->pdev, xbar, newcfg);
 	}
 
@@ -624,7 +617,8 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 
 		nfp6000_bar_write(nfp, bar, barcfg_msix_general);
 
-		nfp->expl.data = bar->iomem + NFP_PCIE_SRAM + 0x1000;
+		nfp->expl.data = bar->iomem + NFP_PCIE_SRAM +
+			nfp->dev_info->pcie_expl_offset;
 
 		switch (nfp->pdev->device) {
 		case PCI_DEVICE_ID_NETRONOME_NFP3800:
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 6069d1818725..b3fb09c2732f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -6,5 +6,7 @@
 const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 	[NFP_DEV_NFP6000] = {
 		.chip_names		= "NFP4000/NFP5000/NFP6000",
+		.pcie_cfg_expbar_offset	= 0x0400,
+		.pcie_expl_offset	= 0x1000,
 	},
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index 514aa081022f..18ca8ac68fec 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -4,6 +4,8 @@
 #ifndef _NFP_DEV_H_
 #define _NFP_DEV_H_
 
+#include <linux/types.h>
+
 enum nfp_dev_id {
 	NFP_DEV_NFP6000,
 	NFP_DEV_CNT,
@@ -11,6 +13,8 @@ enum nfp_dev_id {
 
 struct nfp_dev_info {
 	const char *chip_names;
+	u32 pcie_cfg_expbar_offset;
+	u32 pcie_expl_offset;
 };
 
 extern const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT];
-- 
2.30.2

