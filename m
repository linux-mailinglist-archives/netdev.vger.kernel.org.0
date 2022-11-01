Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D19F614822
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiKALDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKALDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:03:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C52B01
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niXBrbq/MJ5mouQzUE/4YkMCH+5vE1BZlXLIACx7r8KBCBGmCGZye+OAUOhjW6K0IL2ZZ94qRtzFWea78iQGQ8xDtTE9kSQInR4Vog3PCDhE90dU3ftlupJh6SvSlFOjf0I08vcfFDUcB5A/liRqV1eIfCD6MIud8l7JfIfUDu0nuUXtWhTg+CYMUcWCIuKi4HE+Pt0kSxcSYgqnlxHezyEW+fgUW5ltf13m04RK2tXOKdqs0K8Z7Kp3Cfjl2Xp0e8ygWZv3MisanlorwAw8D+L/nJDtDboSYsiyvv+vfeAaTE27o28Q7I22FyN3NvuhVt3mrVxVB9eOH4MOenKuSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IB35D36ZIUI2W7b+owjbICMCq3T2QxU/rrMLwLEDSL0=;
 b=MAkEPuodGbWAA+Wwlj5fZgJFqDIOQUtOXu03zj1maidbGBHMxHfoMEz3iX6zEj6LuO4F6cacqeM/+vCWSaobRPv46p2tPGqAg88Dd8Cr614ALumxE/kBMFZY4mQYYiiIHtwD98kpZApnlaVSttHsDnpkADpCAnnNRmsJe+Vx5i/S9t8p6ZNI04VbJuaJDMHnbemb54UKApzLn6bsLZxzCUvgNCiVSPyYU3Bm+A7rdaewn2H5sOz4QYKDhK09ubz0kgTrerKJtTxr2tcZpU4/qpHDr9faw7hlNnoz0u0Xe8jUC7gL5/pzyYNgUOCQD+hfw1DHfAntKSALgQzoIWk2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IB35D36ZIUI2W7b+owjbICMCq3T2QxU/rrMLwLEDSL0=;
 b=GNf8CrqblkLf+hstmEjG898R3xaeI4mLBHzgxAXPcdcDV6FJk2RtTykZ7B1FSf5ynNMSLL8nkIo7lnycIc2LUcqfGfZngzPN2Kv7s/xPhiZ79j+4YXEBf25Cq2FMgDCu8+44wgBC6iF0i3p/qKdM0e32OQGlegHoHz3WyIMZE1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4578.namprd13.prod.outlook.com (2603:10b6:208:332::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.19; Tue, 1 Nov
 2022 11:03:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5791.017; Tue, 1 Nov 2022
 11:03:12 +0000
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
Subject: [PATCH net-next v3 1/3] nfp: extend capability and control words
Date:   Tue,  1 Nov 2022 12:02:46 +0100
Message-Id: <20221101110248.423966-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101110248.423966-1-simon.horman@corigine.com>
References: <20221101110248.423966-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0007.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2225de-e75e-48a1-fc79-08dabbf8aafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/XH4HipQUbdif2UfoAPcSX5X462mU8NLHqZ1lzeYEE6gfKk4cVJ7cAqQRNhRDzWNYldPnkJwGIx+Lfs5JoSEQmdu+YlrW6inwfx1XWXxVlJ1ds3Xb5v7LR90xfPphlyT1l76Sdoazge1gau13SpT6UJ9ovb2fgiInx9NKUQ3tMK6ZscXPrSRruwFJDq6fy+EdLwBHNcQ+MlJqtCIWF0MsU/L/st6/dicCOH4cW4gUGhRb/6ZzwtKdpNRqMEfo9le03rxcFhEi1axOgjy2WTTQOmSj7X37AqSFztARyPBzXqiKO4+4X8Kht5KxCktA6JQya4G9VLpwlcz9Wc5/ZS/oUCZZw9CAIkOaZc1lItHhqn+8YKSOFRxtU3fPiY/nif0xs061FQt6n8j0ZwQObhqdzLNXVHiTcvFj6gL61P8zcYMKTZyWsP8HA5kq9x1O7vz83KdI8jOLKMmwdq5pTSTQL59v7ifFzleW4nKOoHsyZSL75yT62I3/BEpJlZ/4r3LtwVO/FP8AL602EPA9Jam8f/4uHa187Q9YapnAxraoehvRinejcEw2orH+bufJWD+SKOj1VOdijSLNS7joL7eMfaRq/5/uxIof8KlCzNNHPcOTmslJbdv17khiTTYLZ20meN1RKjUgYjYMpqbsg4vzbmPAkqhzU4BE21qbzY98jgTAXo59sYTJfngMizBnjCsBMgCicSBebAIwpH4jhSqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39830400003)(366004)(396003)(451199015)(41300700001)(2616005)(86362001)(83380400001)(38100700002)(6512007)(316002)(36756003)(5660300002)(6506007)(4326008)(8676002)(66946007)(52116002)(66556008)(66476007)(54906003)(2906002)(186003)(110136005)(6666004)(107886003)(6486002)(44832011)(478600001)(1076003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tq5br07NLouySpPpvVfLQqgS5qDUG7zLZ3QQpHmFK7pCIr+xRXBMHcbfp+bt?=
 =?us-ascii?Q?7SXBbvnr5Pu4tG9NYP6FZ+kvUWod3CqC5ACFXXBAPss2gV0F8IVxwBjuS6WY?=
 =?us-ascii?Q?TGgqzTDxLFC3yrZSoS0zABJRrpPahVX0IpTnSIy6D7skZtXb5qUKefUNyFvr?=
 =?us-ascii?Q?ggnRw+/wvdzb0ZIwXxQT5aKEmU9pZUjE2l6GAQg23A2FimmnvmISaR8PbTB1?=
 =?us-ascii?Q?UVmt5OLQyPU8xpfI7GGy9hGeCobxErvlOA3faZGPVoP24LfYPPuxf7ZqWhxd?=
 =?us-ascii?Q?8/WofSfceWyOow9pLKeI+ibQLTPkXddsL149xu7A6g//ZEpD936SWMO3+6tT?=
 =?us-ascii?Q?nOkzf5I/zpEOR27WnPiX/shdvFiwblfrSqh2Ts7r/aEG8bltuhRtQ7rz1woV?=
 =?us-ascii?Q?n3NGWpfDBVpP6XOTN/LCTskrwckfciRiG7/zdHqT5vE9y6Hg3q/t/wSuDJJC?=
 =?us-ascii?Q?OZo+OalpCRYGHSf1b/KgZ+eCg79fdsxt0000FB+p1Y9po1Z5CRQBRO2h4X0a?=
 =?us-ascii?Q?nqUVenFM+ad/pQBTjRShd2Xkd43rb2PZp2y3zbKFkfcDV65vqo/WRCZIy82+?=
 =?us-ascii?Q?fsoMxwd2HFsDk0dXvmNEgm2t5v38rj9Q/FbFPCy4BumSui0F/Hfe682WH9/5?=
 =?us-ascii?Q?F34LHQlBQwh6PdPCQPP2nDcitCgxMphM/ToxInmfqcOvV16zjqqHh5MK0mLj?=
 =?us-ascii?Q?10hMzhZIW7i+OxlBVJ2kVbUDwLod1UFjoU9nBZ+d9YfjnuEcwbsIuvFdPIdg?=
 =?us-ascii?Q?RSMXR2NwibxbS4l9m88eQOI5fBnQ/arkXbAQaPJZRMHNllPxfQqTb+IMyEJF?=
 =?us-ascii?Q?tRH9dBUfdL3FkXJCMRQdIdAeKCgYCrwsYPXmLc9uGBiirwwSpVCL9SJBjth4?=
 =?us-ascii?Q?J3VKNPH8h9Ypr8BZfCbZAcKl2Yr3B0LjGwqCbz3BHTBgXC5m9RwmjhT7VGkQ?=
 =?us-ascii?Q?fO8LuRV3yWwkn91/RxYvWL59E0ZJ8cekraMuRuC73q66gvUT4k/mmclbR+8N?=
 =?us-ascii?Q?sPNqnzL4x3vr6UXA8oZuprT4CDfxJ4FdqH1EWFpqNWPddBaQw67opAJn/YDM?=
 =?us-ascii?Q?UgxNypJCsNovspMbQo9NlF5QX7ZSAtZNTnCmFu2Nu2PdpHcx5ASkpzjhms75?=
 =?us-ascii?Q?zjMhiC0hIcO5KL/6SsDNqxlVUTudFCqSIcK0y5q3UDM44oWO9i3OmzMS1vLY?=
 =?us-ascii?Q?ksHhNu80sKYjOnzn2OqDcE08Px+iUdxmWAMbmv4Ls/tXGFZHLRs0+x7JAoI7?=
 =?us-ascii?Q?aMsJ1DZdB2D9jjMRYdEfalYaQ8woMqzeWEY1CuMYWZyc1To2nRkB4x69olxI?=
 =?us-ascii?Q?vrIgHYRzbFqCIVSeyBwJVsnP+QB7Ts32CkmhMyOUYPfIVFjtSKZiVF+OyEq1?=
 =?us-ascii?Q?omwQYOu4zLZ3khd9OCG2nvRlgP5mNX1WPOZeylA+IkYXK6ixDl4XYeZz3X4C?=
 =?us-ascii?Q?7XCpLCtPBZZ9li1jgijvK3POOk3OzNXKfnOw7FATmN6RoWwZ1EdawF87flbL?=
 =?us-ascii?Q?ClHRjYVVgAa+fWeV08AtT/cDCYqh4WIfKuRanyhUGkN9ux2s5NrWF3a5GjN1?=
 =?us-ascii?Q?u8yg1LRHVNlug8QMPDW/7jr0PBfkJwBkoUFe2lNfMpDe1et+dLg1YGPQhWd0?=
 =?us-ascii?Q?DQB7ngO+8zv2fxBawKVMAvLkWQtZ6VxX/IVaaKT76lqBvdCMXMpsYAAsZR+/?=
 =?us-ascii?Q?HpFAkA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2225de-e75e-48a1-fc79-08dabbf8aafb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:03:12.2677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62D05I/DkyR5a0rYgJ0tGF3nFy7wgFkMZ48SDMA8L+VCeM+Q+i5Qrok6Ux7yg+7X9FWV1Mb3TMtsfCL7IqMSppmEnlhTNWFCjS5UnzrExqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4578
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
index a5ca5c4a7896..50bc5f5a40f3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2454,6 +2454,7 @@ static int nfp_net_read_caps(struct nfp_net *nn)
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

