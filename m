Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C44D5FF9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiCKKoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiCKKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD30A1C230A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQh4B8WwkUmCj21hZ3LgXU41i397SufPFF7vaAlc007AsYRVGsYuBe0EbeOqwA8A3LoMePmDgp/wP1RRIAfC0b94OXEIEUr6jxruMfENS10kdAn9z/laiZToFOTy9nfW/WoMk5Ow9rp1rk023Cw66UWYi8yp7z4AL3hbieFQB2WT4lAxhXIR6SggD5PkOuV1W7qqDzs2MHAClKHBFS7UdCav7P9nJIf2D+AXJdBaHXHYQ50LoIc4SnH/WzCMCG4HXFBG7F8T/nZ8kzMEUDlelSYlmEsI0JnKRGZFdyvRfKSplEkByDiwLPNj3NLBzENezYzDNK01zmjBVYI8RSGvzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNRXbH4LOengW3x08fIzKlfb8SAEpnQRqwFWlqrb16w=;
 b=PR6+6G33W/Bdf8N6ONzEe9l79tPznFMICn9aGBNutEZvvTPfMY0vFcuLk6uiQI8OqU/af5eZ5mYvJ+0pErZyjmcZPMIDa8SarTX7wxAAd9noT/btiwD1O0h8HMsD5w8JthyE1HC+Kf+2iLir8ODj4/vvalNzCXA+6IehKX5+HGfKYLfpgfFmR0MTXwxKtkm5J5CFU3qQtVEfMBFz+Mj4qwnsr6ZL2OG5RM3QJ+WsM9j3ozpRvKn7+WHBhpUa5stuyzKkVEfCJO8iMdnAy8b2jk32HG5bESKTlTCD2mG/Jo/ZHiTLxZIkyVuKOMoYytHObX4WWLqq0L8u3cr0LGd+nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNRXbH4LOengW3x08fIzKlfb8SAEpnQRqwFWlqrb16w=;
 b=jJ9sH82jH/7MRaD+NJ22AgOzRVgUxy7iOj2netu++7zhyCNlBFXyN2U0uhOPN3rb2mt6uYRszTUV9lfHHvFAy1Y1+PLuZo7pAQoas/3GdiwzrvGtBU69veSh1qJ7nsBgTO3x2b14V8hAfGQtKrsiR/xRYNREgGNaVfylGnaTbOs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 11/11] nfp: add support for NFP3800/NFP3803 PCIe devices
Date:   Fri, 11 Mar 2022 11:43:06 +0100
Message-Id: <20220311104306.28357-12-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0a467a62-ecd4-4d2a-b679-08da034bfef0
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB47485A5CE132F7AEFF74D4D5E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NOTw97aK5Yv9dWdve/PTB3DMQHPu0a05TM+IXFcVsfxLtY0SFz/omVq/nn6hzHlKSgg4PdqgcU3zFlG3R/3e3uHAQJWYx2T/yGJ0pNpDr4Qf2eBEFrTB3X2NPfyoySmqRjPkdNuOyou4nxR7JCIzLezJnWr+qW3lNQNQS8ES3Otxo6jIQkOvv2rh/hg7ryeGckS/tmHRJ/x83InF+qwhFFEm+AtK5JepqvJaoS69c2bNHp3KgEQORWvBwPnXlDT3G07leHrZ7qvrLotybxZZgtyY6qDDPdaLakp3xFWpS/nKeHtKHN0NdbX41i6eIrIoGFdo5TenVhhK0IpWAi1kodZj7pcvq6bvKeGrykgK0FyDC5vChvHBULSJV/OKuCbcvl2caTaQrKokt9iMQj7TM7yWd1jKl+d6CemOCfhsxXzRWRpHGMvTha7zcBHxPafE9q8x6Lx2K5OSQi/paJ30j9VZk6Mf5ikoIJ8OZ2NEbCDuzhxrBUwsfHwflf6YJB+Ae99p8IkBaLOMgb/gtYyF/R/abdx5KZJq37vPXZzGauFTdUvCUKIFvi+L6AE8guFcdLlSsD+ky//HdV1LCCtbMXa3e9MPCdBz7ihVYOOpXRLST4xFf4irl+s3FqkjeQC3a+mP2ZII5avJUVhCvLQGXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R5qBDc/PureXJrm8cmLgIp5qNvYbhbNFYTRaEkcc9nsRhMwXYPKMVipNUG+u?=
 =?us-ascii?Q?C0JO3JrQcEPgGpI7+8QjeruZvTZUpb7XU751kBy5kR2nLqHq+mOV/ei8CGNX?=
 =?us-ascii?Q?c3cZvtsS5/3vMPCDm4griKkI0ESrUKNzKkjeVdNVtu1Wb3dCKzRRajPuq7cr?=
 =?us-ascii?Q?jN+iWetzbaQSCjKBdNtmwpEbSLkg4EEj128yX/LxYRnnD6w9AMV/J/CKFpUD?=
 =?us-ascii?Q?J/enAl4zdRbhMsW7Ubr6zdLe25qJIDtTGAFn6kmVrZLzfZbUvj0OHWqV7Ptd?=
 =?us-ascii?Q?thsxpI+bNoWBU1HZa76fkOtFJft8f9BcZL3UVixz4Bf88PwndK9ceB1g8BeC?=
 =?us-ascii?Q?onVhPFXEIOwDS9fuhqNG2Ewgm2C2iO41z0Y5fJLJ2IQQa6xy5G+S1Q9+3nhU?=
 =?us-ascii?Q?amQJT/wV5dDAZXp7P0JCVDeJUVWbcKclHXJPqcswXZEyY3OIPqz5zU/3j4NW?=
 =?us-ascii?Q?5Ehj8cWn1dlxp9ndQExOe/3rGR34vWDN3P35smmIhtUnLLgEc1VPtB8QfQ24?=
 =?us-ascii?Q?uLjV3+EouxCAPgLNGxnRCpuZlHp70u9FWSE3aFIHU1n8Cff3Ut5dRLwry4sO?=
 =?us-ascii?Q?9codzb+N5ZgVuO20TNKWZ8FX6j07P63301BdD9ZW1/Tm8XP2VBknqrzTZsI1?=
 =?us-ascii?Q?FDQweK579ms6PVn0vDcMHDCkMo73MD0X1oijYXdSRRZdlfB6BOxgGBBgCKSV?=
 =?us-ascii?Q?7apcQT9QE5o8+VNEqufevCK5vk+UAtZJDiAwCSu9worirLRzqK9UjQKs+qCY?=
 =?us-ascii?Q?iqch/XIqIxzPQoimt1MeUScO1ODeTygiSnbPmQM9HOd+bdaPXuDW8JeK345l?=
 =?us-ascii?Q?+qKAIEpIWeCFooNLZf10El59pO6p16GIKIzcGGOudExH3XPqbJxk1St2jfu+?=
 =?us-ascii?Q?iI4qShXQd/z1cTg0DHjk2HH7BoJRlicN0Tme5kqslm9xFKfw+NwKJKJmZMht?=
 =?us-ascii?Q?DdXhE/heRjbp0bKDCwRKKvjQssuwsxDuiHmqro6REdDt3OgkqTldq3XhQPTL?=
 =?us-ascii?Q?pAvSSBZjbDLrPvR382sKUApvjj29ufEREP/AL92VDClmkS3eaAdIhy/PkdEX?=
 =?us-ascii?Q?v4l0d0IbLH+TUUGMX0RzLYQ0uKBQpSxEkSmbjZ7g1bUH8ZLT2c3zTYaqxR2p?=
 =?us-ascii?Q?s1lxv9qzrHPNB3t4FMtjM0gzROiv8FxWxAqKjYBT4CpbH+RMkziRTem6u3nu?=
 =?us-ascii?Q?3VSQ1+1beWcR3oQl9S7j1sO4SZPqTgXzMxioBpYNhQpKImvGcNeE8duftOld?=
 =?us-ascii?Q?wECejrOT87dh7c5Qv9/+HEszXAL8j0ZcxzxOQ00+XtRLBcGDotdJ0PgYXGWr?=
 =?us-ascii?Q?QYGLaTplMSZgXbLojjs/qTvIffWJvtAUPOrWiN4tWU3jOsWH9DOhnmUSfOf6?=
 =?us-ascii?Q?+ZmIA/96OgckmLCzZG+xh/dAmYXKUZuRASGuCjM6KAt/uqH3joadch70PS5R?=
 =?us-ascii?Q?DswsqEAK6Si/cCxJI1oG8fvnfruryG1BBvEg3DUtB5SJhhPm0VlFq7KItonM?=
 =?us-ascii?Q?giIYUhA8pOCcZi4DOriGgQ9kptzSNK8oKuiYLf8FMIzW2i3NOHe/Y7Ij1g?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a467a62-ecd4-4d2a-b679-08da034bfef0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:36.3308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGOnmoGpc1Z9qaKYcSMNS7Frqvur36kmfMLzwpmvEU2YBPkWcVjs8v4LojkJie9bW6dMSSMj2pSyDf3E3IZn92gEZBT56nkyPGXedhmrlFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Enable binding the nfp driver to NFP3800 and NFP3803 devices.
The PCIE_SRAM offset is different for the NFP3800 device, which also
only supports a single explicit group.

Changes to Dirk's work:
* 48-bit dma addressing is not ready yet. Keep 40-bit dma addressing
for NFP3800.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  4 ++++
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |  4 ++++
 .../ethernet/netronome/nfp/nfpcore/nfp_cpp.h  |  4 ----
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c  | 19 +++++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h  |  2 ++
 include/linux/pci_ids.h                       |  2 ++
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index dd135ac8b1a3..8693f9905fbe 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -33,6 +33,10 @@
 static const char nfp_driver_name[] = "nfp";
 
 static const struct pci_device_id nfp_pci_device_ids[] = {
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800,
+	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP3800,
+	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index db4301f8cd85..9ef226c6706e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -38,6 +38,10 @@ struct nfp_net_vf {
 static const char nfp_net_driver_name[] = "nfp_netvf";
 
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800_VF,
+	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP3800_VF,
+	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, NFP_DEV_NFP6000_VF,
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
index 2dd0f5842873..3d379e937184 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
@@ -32,10 +32,6 @@
 
 #define PCI_64BIT_BAR_COUNT             3
 
-/* NFP hardware vendor/device ids.
- */
-#define PCI_DEVICE_ID_NETRONOME_NFP3800	0x3800
-
 #define NFP_CPP_NUM_TARGETS             16
 /* Max size of area it should be safe to request */
 #define NFP_CPP_SAFE_AREA_SIZE		SZ_2M
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 0c1ef01f90eb..28384d6d1c6f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -8,6 +8,25 @@
 #include "nfp_dev.h"
 
 const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
+	[NFP_DEV_NFP3800] = {
+		.dma_mask		= DMA_BIT_MASK(40),
+		.qc_idx_mask		= GENMASK(8, 0),
+		.qc_addr_offset		= 0x400000,
+		.min_qc_size		= 512,
+		.max_qc_size		= SZ_64K,
+
+		.chip_names		= "NFP3800",
+		.pcie_cfg_expbar_offset	= 0x0a00,
+		.pcie_expl_offset	= 0xd000,
+		.qc_area_sz		= 0x100000,
+	},
+	[NFP_DEV_NFP3800_VF] = {
+		.dma_mask		= DMA_BIT_MASK(40),
+		.qc_idx_mask		= GENMASK(8, 0),
+		.qc_addr_offset		= 0,
+		.min_qc_size		= 512,
+		.max_qc_size		= SZ_64K,
+	},
 	[NFP_DEV_NFP6000] = {
 		.dma_mask		= DMA_BIT_MASK(40),
 		.qc_idx_mask		= GENMASK(7, 0),
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index deadd9b97f9f..d4189869cf7b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -7,6 +7,8 @@
 #include <linux/types.h>
 
 enum nfp_dev_id {
+	NFP_DEV_NFP3800,
+	NFP_DEV_NFP3800_VF,
 	NFP_DEV_NFP6000,
 	NFP_DEV_NFP6000_VF,
 	NFP_DEV_CNT,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c7e6f2043c7d..5462c29f0538 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2531,9 +2531,11 @@
 #define PCI_VENDOR_ID_HUAWEI		0x19e5
 
 #define PCI_VENDOR_ID_NETRONOME		0x19ee
+#define PCI_DEVICE_ID_NETRONOME_NFP3800	0x3800
 #define PCI_DEVICE_ID_NETRONOME_NFP4000	0x4000
 #define PCI_DEVICE_ID_NETRONOME_NFP5000	0x5000
 #define PCI_DEVICE_ID_NETRONOME_NFP6000	0x6000
+#define PCI_DEVICE_ID_NETRONOME_NFP3800_VF	0x3803
 #define PCI_DEVICE_ID_NETRONOME_NFP6000_VF	0x6003
 
 #define PCI_VENDOR_ID_QMI		0x1a32
-- 
2.30.2

