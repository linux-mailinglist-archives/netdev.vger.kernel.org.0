Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265BE62DC85
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbiKQNV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiKQNVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:21:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70D259879
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:21:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Arv0rFTSAagBhlNIrd/1RiPds5+hjovHwgE59jrFkhfzrqEw8u66f3x3mkMHFl/KXyqz+fDLvmEcq1/9djGnLMm77gfl2RctKJvLXaA7Gcu2mvZ1NDMQG89vfJQFqPwqHA3RKZrZjk0WAa9Wx1sTKb7tLrGIHY+hWvzmSo87ZUBbNCAgXFucrJ0yuoVj39KFXckH+1x/l8y4iuezXdWKvnqIC772Kg6ZddrMPOR67tP6IMpeMGnroCTTLzTXvoiNvHfry4p+kkVPgIY+MQQZ95wwFb9hKU4tafVWE0phYGwGfC2lkBcZEqvgkj7+2pfa2GFxCOb3bA5Dhfx1zwhR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJ7za6X8cqf0I7KOCsw/Dpu18MZRDovmok34kyE19xs=;
 b=lJTGr12NxjKiLvCkWpnNarrfVpJ1M57oLek132olo0WqNJCPpfj/Pa6uEDveztTNmezXUI4XnRhYdZubHx1f/ysrrr40hxU8pyNQuuyvWPeW9WZZXglrTkqo9s5Mfo6FEWBy4kYEWIFgBhlEqSCIlql/Z1rqUgai02ALYGeEo8g4acyXhI+vxVP9GNwWhVM4SPHSbiiQF+QXajcqbU1UT4kOuU7g6H6CukVwD9NcqO623vPst8rkFPbeVHM8Fks0yILT0iWXTjqLJSGRqWIOaZoXNAfeeZVJsa2ST1BgaS2QtIM/bdNQobMtPVsDKEcz82CFT9MjJD6Yb9VRzbhmYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJ7za6X8cqf0I7KOCsw/Dpu18MZRDovmok34kyE19xs=;
 b=qe4WNOn4QPIHDHaNEdxeh8mILpItwcwQ1OGpqweTMBLL2YbHUGe8Zgin+R1s+sNg6p/o4WJx+nuhHAwcTixj9kdQg+I+kPswMlPkQGksVV5upbZaTYkTfupGxzoNk0+Y399S7IsYnqKC9OFHeEk/A8dInY6HV+ntnNe9jls9mYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3792.namprd13.prod.outlook.com (2603:10b6:208:1e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 13:21:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 13:21:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v4 1/3] nfp: extend capability and control words
Date:   Thu, 17 Nov 2022 14:21:00 +0100
Message-Id: <20221117132102.678708-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117132102.678708-1-simon.horman@corigine.com>
References: <20221117132102.678708-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3792:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a515f7-05d9-436b-c841-08dac89e9e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4QxeSVL0ntYEXqbtMeFBewLxtBdClqzO4GAJYOD/mjQGE8IuH3WaFjGASOjaSM96U08Da5KBPvobmW1r/DmRFA58KokIy0funk/QqWxRq74RVIDMM4+NdJZzkWkOw/ZkbeM3B1HMVaHAshABwYvhsMsi4Gy0UUVM3J5/DHR04Qtftn8BBmABrz8PK1emIB37vHe1vyobKSe9pZqNUnOODwx3hQEjwpJXXAsg7tTpi43nA5WUrvBOMiL5GuSJ+tvg/s5n/h4hypKHkT8qIXwj4+wR2qHYWnnlTNe7/GrH5tLea0T5jVs6PMjBE4cNDP2pJqZRa/Ggje9rAIcaEGa46ESTZrMl0jXHlaK/y+7ZbwmtSV5PCizRsnkn4dNLr8y5CmUMV3UcPfJ6FIbOvrziCw6f+muPp+jFGOOk29K64hcHePi7/7sr0TyfX7+yU9HiTqbTee+4RAPaQsfAV7goo6nB4203t1l8bWwvTkK7hObBOxTT9KHqCU7PzZqZn3Iw2tokuY1bunrNQJo+8Udcpu4qXmVMo3HQNoWJXhL/Sux0BzqAY55Iad06JN8gFqvk5qK/EnOMT9k6vXVPxWLZ8+XKyAcInqQU432u9tNqSin2IEuIy+LpyjhsOs8GOiegdCj8RHk3Ui4ZhlLwi6v+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39840400004)(136003)(366004)(451199015)(44832011)(2906002)(5660300002)(41300700001)(8676002)(66476007)(66556008)(316002)(66946007)(54906003)(6486002)(110136005)(4326008)(6506007)(6666004)(107886003)(86362001)(478600001)(2616005)(83380400001)(186003)(6512007)(52116002)(1076003)(8936002)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UwWlpBoQ1Ljl+v7dr41qC/sHAmyGYyLHyrT/n9i+vUrTN94m20FG4CT2mq0V?=
 =?us-ascii?Q?3Xk/DY5DK0d+ht88jNXTpNAQ7INIKtNRsVJV/KyM6UAfAmHBKrdxFtic7HBU?=
 =?us-ascii?Q?hWduRknSJ59MHjkdIKJu1aUUB/3WwFy6f+Gew6+curUeWtusRXNvKVDmIsWq?=
 =?us-ascii?Q?Rv2N6gifBNVOnTwmgGWDZORLLsFvdS9YMdM+9Bh93SPKxptWCCgn8bHRZhct?=
 =?us-ascii?Q?hhzmJ2eJw4T9zCWsh4wv6aHqKU4K9/tqzcoZxL/KWv91Ah50bInAVcnUKWA0?=
 =?us-ascii?Q?CNJsz7xyugfy2YEMFhQArHMB/0tv/mwXSnSboSvOTotPpe2e2GAyGhEGdwBs?=
 =?us-ascii?Q?B/D6pZoO3nSbwmiNASYcaIc7Qn0pu9HJoP4q/TROr+HnFsDSh0CaGcO33x+j?=
 =?us-ascii?Q?SRQ6RwItVxQHd/0/llEdGeE35Dwfvx2If2Uvs+Li5XbIicwVUBQBHdmfsEkj?=
 =?us-ascii?Q?uyg3bUAHWwLv5xZnEMOlVEtoKoMMeywK4hwhuDWjht3yNFllpA2R7qzPvwQT?=
 =?us-ascii?Q?9MzWZW36QHPO+cnd338WgR18CJkvwcG4JJZ5svFp925PgYe3Tub67PB4zaf/?=
 =?us-ascii?Q?oVGbz9fTd5WUvetNk8YdCDTXMxrQ2fNokm7UVRBrN+mPRIi3FSBb5zcIPBtK?=
 =?us-ascii?Q?lEOi1c03x6Cq8xJcJ6kg75EyH0bPIFVihX5KSv3QXjwv+VGYZG9inWLISo/q?=
 =?us-ascii?Q?aAf12R7UrMPZ4GpfWiQkXipB5Rf7HXKRLbJ1jIAvlPs7DNYJt9SDyuUDajm3?=
 =?us-ascii?Q?ptCT/vjyFXLEfLtldBRRQwdgTehORthCjQIEYYUCPCHfNZAEOkI+0hDLn2vK?=
 =?us-ascii?Q?nFxzRpdINU+fhaJSsc4wAjme83679DsoUmcxxr/yHVF6zpvfO0BlG9eX7fN/?=
 =?us-ascii?Q?rmkQbC/GFJ4Y2Bxo5AOqKVUI1KUF+7KHoBCzO4yZoIn2rBZIRfUU5b17BluY?=
 =?us-ascii?Q?ZM8hDT3TSAw6vRSEXHbl/RPFgZWUtBAo+eT8SqD/fwudf0XLyxNb7i+57E/s?=
 =?us-ascii?Q?/MzFRTbkQzACe+4pt4saWNcQbwLb64Wh2onqk4iBOr4dIBi+ci+HuZ8aANIG?=
 =?us-ascii?Q?3BBZHy74EW1w4hvaNQL3T00mupc0Pec7ypJ2VVFudEDUDJ6hom6f2U1GrZc8?=
 =?us-ascii?Q?YQOoiyxV57a+xUymKhYNjUJzLyML4UjFH2J+tCIPrax9D5T4nSv6ZWr7bLmU?=
 =?us-ascii?Q?ZqsGCnkceLVBrWnyY18diM/3LwactfQH4FNrFFs1Llj2fyzXqQggihQ4uqhu?=
 =?us-ascii?Q?bSP6aQ3Co8TS4RK7M6Yunrgi4kpYV1Jyy7O0534Op6x/kxrl+55bMokoXb2R?=
 =?us-ascii?Q?QDCQsnRk6CO+WCefjKaT53GXFfo86cSPk6mmuVeyoM0f38wpgVIADF/41nuD?=
 =?us-ascii?Q?r4jDdfkjEIQ1PJlIwcaq/HR4yPrUAmDppHGKZn/11tIqGT0F7KqszIvlwxLv?=
 =?us-ascii?Q?ALkY1F0CH7ONZBAh6jS2tX8EwHt8h4ckxcJBHrlfByv45PD8iSb9DFDh/lzv?=
 =?us-ascii?Q?QJpr3RNKR5AWtySE2LrfLjOgvkxAhnV4rsOyoNYS2I4Q2sw0GIZ8Ysc7EJxw?=
 =?us-ascii?Q?Hg3HHw6sSeGrFh0UIM0r/l441X8b4ZAVPTedQTH4kV1oKLptjI3m2Myzwf6l?=
 =?us-ascii?Q?vHMZ1E0t44Piz25QR+nMFZeOZMXxmhqIUfYKZjR2oZ/BU9En7hAXk0o5p4Cw?=
 =?us-ascii?Q?xepfSw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a515f7-05d9-436b-c841-08dac89e9e5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 13:21:21.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9IceN50rabC1P9yfSV7V31F/VR4ohJDRCS9Gd+r/TAyOMjQRMuYJ04JlHuNhjM+86xGkqPEa8H62XJKq/ufF+iRuejibNCbsbru3CmfR+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3792
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Currently the 32-bit capability word is almost exhausted, now
allocate some more words to support new features, and control
word is also extended accordingly. Packet-type offloading is
implemented in NIC application firmware, but it's not used in
kernel driver, so reserve this bit here in case it's redefined
for other use.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  2 ++
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  | 14 +++++++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..0c3e7e2f856d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -541,6 +541,7 @@ struct nfp_net_dp {
  * @id:			vNIC id within the PF (0 for VFs)
  * @fw_ver:		Firmware version
  * @cap:                Capabilities advertised by the Firmware
+ * @cap_w1:             Extended capabilities word advertised by the Firmware
  * @max_mtu:            Maximum support MTU advertised by the Firmware
  * @rss_hfunc:		RSS selected hash function
  * @rss_cfg:            RSS configuration
@@ -617,6 +618,7 @@ struct nfp_net {
 	u32 id;
 
 	u32 cap;
+	u32 cap_w1;
 	u32 max_mtu;
 
 	u8 rss_hfunc;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5620faa63c7e..3b3cad449f7a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2452,6 +2452,7 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 {
 	/* Get some of the read-only fields from the BAR */
 	nn->cap = nn_readl(nn, NFP_NET_CFG_CAP);
+	nn->cap_w1 = nn_readq(nn, NFP_NET_CFG_CAP_WORD1);
 	nn->max_mtu = nn_readl(nn, NFP_NET_CFG_MAX_MTU);
 
 	/* ABI 4.x and ctrl vNIC always use chained metadata, in other cases
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 6714d5e8fdab..bc94d2cf1042 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -257,10 +257,18 @@
 #define   NFP_NET_CFG_BPF_CFG_MASK	7ULL
 #define   NFP_NET_CFG_BPF_ADDR_MASK	(~NFP_NET_CFG_BPF_CFG_MASK)
 
-/* 40B reserved for future use (0x0098 - 0x00c0)
+/* 3 words reserved for extended ctrl words (0x0098 - 0x00a4)
+ * 3 words reserved for extended cap words (0x00a4 - 0x00b0)
+ * Currently only one word is used, can be extended in future.
  */
-#define NFP_NET_CFG_RESERVED		0x0098
-#define NFP_NET_CFG_RESERVED_SZ		0x0028
+#define NFP_NET_CFG_CTRL_WORD1		0x0098
+#define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
+
+#define NFP_NET_CFG_CAP_WORD1		0x00a4
+
+/* 16B reserved for future use (0x00b0 - 0x00c0) */
+#define NFP_NET_CFG_RESERVED		0x00b0
+#define NFP_NET_CFG_RESERVED_SZ		0x0010
 
 /* RSS configuration (0x0100 - 0x01ac):
  * Used only when NFP_NET_CFG_CTRL_RSS is enabled
-- 
2.30.2

