Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3937E4D5FF6
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiCKKor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiCKKok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2122.outbound.protection.outlook.com [40.107.237.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DAD18A7AC
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0VBbE9AHoB3D4DzrjTk30IgXMjYFU77Dvh6WJSH6DTz155exot0k+4D9MeoQY8Ol/6tnmbckw/PTQpIsHYEiOd6n1ejXkJpRMi+HisvvwlkQKB6taMiOUoLgyuNv3Qq4t+IcyuJ5b80OMHM6dIlfBXoW7J4QGOlh6gZ+fD6IN0vg53Pn8tIMPAv5K399eQulfd1QjC+eLX/G/wI+/112U/jnd7URVAr2UPb3fcdrmCH35Zf9m1iZcdiPbnq4H5F6h4GLVzXi/WaSPed+7gF1OAmLgKAyAnQNWYmgQll/tKGeij5uR0MGftPlKUbgDdrTcTYnvQnZg1AJ1Vgz06gnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=boBxymxqzmJWQFMIazO1q1FjmJbmER7VMmyOpEKLXc4=;
 b=aRXwAOPeSJGG/nTin8SRb7Kyzfs0NeSn17s1i4qvIW0oQng6lJA+mTBYJiuQ6zbNsJ6dkYHJNw9n/Lso3jYM+zC0Nzf0IJYfH/fwCZBSutDwzcF5ku+JXs6kvouUHkr4Y/vuzJd+bvss8FZ0JPQzTq+VdINAYXpLdvKmOJET86JCYGLe+YrikIK7jwtw64MrhyQEReOyQZhWblQusDZ5E3F+t8P7dhJ+/AbSUcfoG9SyVhCabKPa5shb+ONAI57UWayZubnl6FehqKcOhj0Q2ZnhAH39JVff035kkhEbFyH2yByCtc00e8JXUq3B+Y2J5TE/BYo3jt/EEgcV3WJDJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boBxymxqzmJWQFMIazO1q1FjmJbmER7VMmyOpEKLXc4=;
 b=VKZ8UVZAWn14do0I9CyJe4sQkCwnS6UieLeZRxCpFtJSJaLtZF3o/X9L0XwbFMqj4fHoKfTcAuFsRA8zLycEEygLu+2VjpRlsV7tu6FinDEoAdE6PgkAv32nI356eXms0yf3th1GgDV2NQeXJ38oHD1FiUqEGKuMblYnk6tuVEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 08/11] nfp: use dev_info for the DMA mask
Date:   Fri, 11 Mar 2022 11:43:03 +0100
Message-Id: <20220311104306.28357-9-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01f1cbdf-0a1c-4398-83ea-08da034bfcbb
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1184AA2034E69632F9EBA85BE80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fz1lhxpvF6epq841QOvqdHJqP/MjP6fPsnr+NXtTAA5+vNuj0aHW/xvMbCAUTgMT6kf+sZ4otqinZQDegCNQnceC2sRZjTOg+ierAnyJA33ly4XOdNt/GxFYM1RGtfClgvj9ClS0hlNBy7oUmPrH5IEDuBRUfs7Zn4WKS21Ca0J+tRLCnaQT301GBSe5EGdxnzxews+GLCfhWwjsC54bIVOqbT8GZJZvj/wS3LNYY4u94Y61aQ4rnJCwkFK2nwtHscUEqwAgbRayXb/1/f6QmU6muYju0osCPyOaXzupSidWUgAHKTJqN7OqmbymkpGE5VHWlP0ZcR2WnfC2eSyUO83bq3aX7hbpyxchgfj0c2XucDBOC+Iw9qBVxQrUiZS1dhfp0NJ8a7I2RF1k8wn9LNtvW0Bs34p3DYCUnOl/H59UjffjS82GTcBnonHlmLUjBcXMW94LEvDtCkEZFz7hrQILQapbl5ryR0AUYzTwb9rfai6vzUlpGUGzS+kIVWg85HDRFa1MGV3a0TNIV3mwMl39amD9Jvcbc7Vvt0RsLhmdV7tlhaqiXrQCFFs9NaK58vYFiPw3+vri83vbM8ctsRji1PDeK0d1L4zf4c0GFCU2oT3tcQ/VPZAosBwKflg8LFjf0I+dIwtsGWW3wUg3Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pJwl8/Nvxt6isaay+U77xGz6VK+7kuc6FHyZu8Exwd0Q26CIrNGMnv1QuX4k?=
 =?us-ascii?Q?UC/hx82tYXZYjBB5RhbE6cNvRdFArAOwWXkiOPllz/2uiK25vNpPEvrKGStq?=
 =?us-ascii?Q?K8/vN1wKxuItakuXtJ0agzoBbWCrri++wqf2PsWcsLrK7+qVupO5QEaEvduW?=
 =?us-ascii?Q?dFVaWZ8nmVO9OLP7Vyf5XJXIrLnTExy/ZEKI7XRdV/jJnBpZQAJskraCp9Gu?=
 =?us-ascii?Q?R3CVSZDU6kDvWrGk6vXVXDaI4byy2j6qh0VuPLkbhtuXMZSDGn+sWsIHQdqI?=
 =?us-ascii?Q?aNs3c055a1gUBdBqhsy4NPmBXLAErd7IT5dHsuaLlSVUKyvfGXtPaw1EXUzh?=
 =?us-ascii?Q?Owh2aDCFOErRGGoD3QdCt8rGgIErfi0OIDbMlZ0g2mbLjuyEoGohUkyrHJ1+?=
 =?us-ascii?Q?HhcFBHTzaiyfUy8xoIus2T4BwqgNb6aEWoQ2JcRAcU5j/YK9znSEKQwnrD1G?=
 =?us-ascii?Q?YDj7ZjN5+iMyI/7YzwJTnjv+XYh38aHlsjIOiOkS5PthO9nLw00NzNIJB2pM?=
 =?us-ascii?Q?uARmBF/0AH1axLbAJOgSv/37cUqIA+yaz7WBmpU45vKMsLd8Lu4CmyFKUFkf?=
 =?us-ascii?Q?LAlQ1yBtmNDD5fkymF2Mm9tTxujz4H202C4C1NJvnew1iRKw9oYYVW3NUGL4?=
 =?us-ascii?Q?T3gZaJ8hWvOsqaK3tlMA8AqD5FmRAiBhk0fX/E4Fg8JAqxPJT6+gOL8EX/Ib?=
 =?us-ascii?Q?TUQhvyC5IQb/kIV5xupLt28Kvys7Aa4RCwOiEAc34YPFkJlZNR35VZcmPlrp?=
 =?us-ascii?Q?fIoyqol3odGiJExcN/5fPianrn35CyUwKsyAC/okRrpQnnOa+5ceojDJ6f9d?=
 =?us-ascii?Q?OuKvZQ1e8tGFpy5LrtQQUvmNaGR7XqnIkgRepxChDOA+4/dZ03pl9WgBqk14?=
 =?us-ascii?Q?MNrIDPLLqsePaRBK6hAs2qiLr1F+DpXAvtown6JfcXdX6tM3E9ZbTUhQOqLE?=
 =?us-ascii?Q?qGmgIKPBpIQ2giTS4sOE3yp8yErK/S8t6Y0drP0g3W3wqbJtV/FLOZWP3Uao?=
 =?us-ascii?Q?Ji2QVyfebnfIY+n2Q15gS++pN1Qu2g+s2Qzy7vI16nbFQowmsfVTtTr8TjJR?=
 =?us-ascii?Q?9Al6PAgcOA3yOYrQLimXdh/NWDtuPEkYE7ochDCvaue/XivsAJcVd9ui7WaP?=
 =?us-ascii?Q?PZQHvqA5g5NXT3d2WK/2ZyVseyV8hNWJ5kGW4zVRz/OrJuIrhpeZO6PQ6I1B?=
 =?us-ascii?Q?k4iX8bCl2eTG3aUjfOeI2hj/Y7DdXTN16bKbkWYI2AcuCwSaU5Zn3PlNgdZD?=
 =?us-ascii?Q?hywxiy06Lx7Az6VJ1ogkSNe+Zlw9BthII05fMvB8r8X/PmKgrZO9TVlsptyQ?=
 =?us-ascii?Q?J5si7OUqaLueO4R6KI56UM4FnfnP4baZ8+AKC2BUQNwEqjf0emmrIHnytHzK?=
 =?us-ascii?Q?94uvagsFbjiGDb9/uWZtFeHZrp5QdnaudvDpUXMYnoZtRFL/jpf5Rz7Ijr/p?=
 =?us-ascii?Q?CuzZAJPdWoBV6VERuJaC40+2MmO1wNSz0MbW9ZzJvIRy/xwS2PrQz/TsMOze?=
 =?us-ascii?Q?Kb2Hm/q5hIw+dR15mGY9GOFvrEF9l4e53IQtlXUqEileK40pn7/17tHMsQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f1cbdf-0a1c-4398-83ea-08da034bfcbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:32.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEbqKPD7pYIxwQVOFIHza7iyecl6kNNV0tywADS7tnYo0+r1Fivv6/fw9rc6FxiHCVuNcJpgrH+43S2uZJwoiNMQcRRM8XVwy+4CEgxHuuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

In preparation for new chips instead of defines use dev_info constants
to store DMA mask length.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c        | 3 +--
 drivers/net/ethernet/netronome/nfp/nfp_net.h         | 3 ---
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c  | 3 +--
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c | 3 +++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h | 1 +
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index aca49552f2f5..dd135ac8b1a3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -685,8 +685,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = dma_set_mask_and_coherent(&pdev->dev,
-					DMA_BIT_MASK(NFP_NET_MAX_DMA_BITS));
+	err = dma_set_mask_and_coherent(&pdev->dev, dev_info->dma_mask);
 	if (err)
 		goto err_pci_disable;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 9fc931084bbf..232e0a622ee7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -63,9 +63,6 @@
 #define NFP_NET_Q0_BAR		2
 #define NFP_NET_Q1_BAR		4	/* OBSOLETE */
 
-/* Max bits in DMA address */
-#define NFP_NET_MAX_DMA_BITS	40
-
 /* Default size for MTU and freelist buffer sizes */
 #define NFP_NET_DEFAULT_MTU		1500U
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index a9e05ef7d644..1ac2a1d97c18 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -98,8 +98,7 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = dma_set_mask_and_coherent(&pdev->dev,
-					DMA_BIT_MASK(NFP_NET_MAX_DMA_BITS));
+	err = dma_set_mask_and_coherent(&pdev->dev, dev_info->dma_mask);
 	if (err)
 		goto err_pci_regions;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index b3fb09c2732f..5a8be13a5596 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/dma-mapping.h>
+
 #include "nfp_dev.h"
 
 const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 	[NFP_DEV_NFP6000] = {
+		.dma_mask		= DMA_BIT_MASK(40),
 		.chip_names		= "NFP4000/NFP5000/NFP6000",
 		.pcie_cfg_expbar_offset	= 0x0400,
 		.pcie_expl_offset	= 0x1000,
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index 18ca8ac68fec..ea61156c2075 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -12,6 +12,7 @@ enum nfp_dev_id {
 };
 
 struct nfp_dev_info {
+	u64 dma_mask;
 	const char *chip_names;
 	u32 pcie_cfg_expbar_offset;
 	u32 pcie_expl_offset;
-- 
2.30.2

