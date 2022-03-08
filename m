Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C6E4D141E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345598AbiCHKBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbiCHKBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:01:54 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300092.outbound.protection.outlook.com [40.107.130.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D201639830;
        Tue,  8 Mar 2022 02:00:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyBZkip7Iq0jBexI8jTUGAgwj8Nh+WIGG8giuN8MqVVRD1aKzv0ocT0xcOkJ5eJTtZYkoEws5h4kAk1muHvpBDBTkLCbiHvHgS4KXGjM4a+Iy2KJ+JEc2qPwFlHK6539DOJjtxY9gXWn+tD1FptqGkC8WZ1q2YBB7YK8O0SN+vvWvLhykbCew0YSOk3NGv3DqfJPv1GRPrRpIIWS6zR3xCW3VSogSz87f0nIleB8QfmsaUgXGsZfkkTcY7UKUyI6ccnSG8Jgrluph4yrM0LbpRrNZSPuG2Okrquo9rZJtCNz373Ge0gRFWNda/1dD74OAg9vvEjJM1s+rrh0rfVeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K81FkGlrCFf5BpdIHe4ZDeX1ZgGmSSWdUqLF8qkavxM=;
 b=Mivte9WFmuAGCzfG3qvp91YGS0x39Jledww6LSqMUur9ofXXsTOnCpRTQo7M+14BYPOfGyjvS3wgS609c40Vpx/+fWp4XEfKAAHK/r6c4eG4rGwYQbzbpYWqkUhJfZcOV3QHzsIuE57u8e//ORFau15dCWlVyg7THSAgRkKV89zBZInMUQbaYWC4MJg38gONSeYiHa5jEcixnaN7/ut7Y9YbSpZced0WJ09EIIZy2TGrZY2yZK4ryBokwu1EGBalDURwuJOlVkcDoiRQVBx6V0ppEzwV5pM49S8wPxd+ly5SVnNBgzue8kXnr34WgRdLGafZBbEnQ8zBeNx9ihCQ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K81FkGlrCFf5BpdIHe4ZDeX1ZgGmSSWdUqLF8qkavxM=;
 b=GAdh47Bq9RZbTyiutvavSaBrXhy9DcCzZDO2EKtV1+FThzs0CoX2v8T4iSh5a9F93GWOtXn0TkcgotXOleQXfz5owyzhooMDxU9a3VYWfZRGz2wALouxSc3dKnIhG/uHrf3TC+ZteRRCH/rjxYetdaasbhsikFvB+dJIyOY6QIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by TYAPR06MB2333.apcprd06.prod.outlook.com (2603:1096:404:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 10:00:54 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 10:00:54 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] drivers: vxlan: fix returnvar.cocci warning
Date:   Tue,  8 Mar 2022 18:00:14 +0800
Message-Id: <20220308100034.29035-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0090.apcprd04.prod.outlook.com
 (2603:1096:202:15::34) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3775d84-410e-4268-d726-08da00ea8844
X-MS-TrafficTypeDiagnostic: TYAPR06MB2333:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB2333519D617F9B55778466DFC7099@TYAPR06MB2333.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOc5x3McfLcU2eNXab1CW6TIS5Diw7FDiEHL1IMeVWtlH/czMxcPWkjGthgZbUiovcR08A8LJjB7tShiKcydkxy7kNYJo3ouuCf2YYGcK3pwH3ApzsEx2bbma0e80AF611/xDzJLoJMap+n6UsMgdOMeAAe425zwv4aPip+3aSZiB5vScU4/mZXTRxjDh6dS/XZjiJo09R9/dROCnrS4SD8uTzA0i2P+CLFYDzWPZ6nPXvG9rrcs5GjKcpPbjGEZDL/FIhwyU3y2tfVfv0p9MCAUCK9EoXStOknFVEzpMZIkgf0mfSeoOhIRoJ3WckseqIb42eGCjTFk4Njm4/ELK8gC25Tl4L9zOOoyWG4TfH2ogqqk7DlMR8f0XyC3DJ5dmVoo5Yfn63MzLSj7M3e+uuVBWHLTbt8/uZHmlLJdOjx2p18j26btSnx8dZhkti0UjKIBHxgvokjaoqmIR7CyAD7ZJ7JoVXYO2nisP94pljphzBbXTop9Z0jzHABOxm0tpgFn/YxqN9FdJGjXlT6FpRhNrCtg4xwPH6xO4o7EJQOg2oI1J0UyQ9X/Ea68WmSRZMtZvbzQmUCcAq9ZwFnjp2lBaZjVM1KjFhTbsNd0+tCOJctxYpI9bm0JQ+MFpWwOTNjFElQ4qhPw56OJ102Naf4xjD+j/4tdSc33Yvsir1FoICPfdEW4vYKkAestS/XTZUFqhKhs0D2Zq1HOeP2WOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(4326008)(83380400001)(86362001)(66946007)(66476007)(36756003)(5660300002)(316002)(8676002)(66556008)(110136005)(52116002)(6486002)(6506007)(6666004)(6512007)(1076003)(2616005)(107886003)(186003)(26005)(38100700002)(38350700002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJtMfu/dlabz+ITqA7UHui9jYBTdBsuy1bdctux0nfIF7T9Jg3caLYSRRBvz?=
 =?us-ascii?Q?knOFuP3K3Aj+ec0VbtNEwx3MIDOh4+RGnxwvgv/SIe+S3bWBWk3xRO2OVf9j?=
 =?us-ascii?Q?kEeOOErtl6Osstf9/PuIbs2Fh5pIvZBQb1zgrq1BcrZKxjmf8DPD/RZGdswv?=
 =?us-ascii?Q?6zgmqXWiMrKeDkia4yc1AgCTCqEevFLfYD8N0mLaRfs4owJA7JgQqZIReaeQ?=
 =?us-ascii?Q?XLBlA1791mFYa5zLPHPFITKLOJG9AtKXhe6oSXYDQ6R/d9VIhgcDEkrynIEy?=
 =?us-ascii?Q?8g7MCs+1eFZ7ujuYU1YWg5JDVXY8ewDB77H3vWx4t+XDqbyOugPMqUF3r7Jn?=
 =?us-ascii?Q?cgduzsUjWOkRkvuFbssAib1s+bjkBpYubOEX5J260dYmiG+o4D901vb/tzx6?=
 =?us-ascii?Q?vuH96Jkwx8yZDbyHypr78PfKTcgTtPwNxR07jqfaqaDP9V0JQ/rnE9l66QMV?=
 =?us-ascii?Q?IRQs4U4Fxwud5/OB0fgNTtlqlYYat6cI6qjLW5UZ05Hz0a1mSaToJt3er7Dl?=
 =?us-ascii?Q?8d+e6j40DA0ZQB5oda9NcCYaySZ8FET+i32NpNY6YGGEnUL7LYrmTIjg67kx?=
 =?us-ascii?Q?cVgl4cq8bOqyFusBABpLHwbnxyfSX7HdTBhdA59xbDUaoPqTip+CfY0fhHk7?=
 =?us-ascii?Q?NN5yY9B3n2kHKHy1oGPIsh9boEN0848eEddnkSXLmoczxFv/WNPgLnEqeG8u?=
 =?us-ascii?Q?k2iaHe0Zj24NaBkmHrfhhOty12sXkXNylxgwXUnrrr045wL9tZEL61l/aV/4?=
 =?us-ascii?Q?Mr1mLQ7zJoVgNkLH2DtKt0N0ElCplx7E/J3P7MoFOOX2mjMGyehg+BhjA2Va?=
 =?us-ascii?Q?65EQzJYLIe/OawNOL1Srj0VNB1OG680QQlp0tGZVtkqED/cJPybLsc9CefPF?=
 =?us-ascii?Q?Z20iC5Sh++TNo7GIt+z84MMCKyWU/w5f6pyZIOaX6U+2+KjTuiTHImS7Arb5?=
 =?us-ascii?Q?GTCeaXUUYKsbpBzCwDD3jSpBTAWD8W4oXIO1EyY7zeGy9Hmn/YOQ/3TRJLhO?=
 =?us-ascii?Q?Khuid0XUhUrRRlNMH3/KGme3Q4PPu6PcKTyr91Vs8XSoUmmxJhJHGMqc1KXT?=
 =?us-ascii?Q?lhqpxobKD5+rvBtCZAbjO3qVuhJVKivGKRxhqCsryQeJvoi64v/k4cPZ6krc?=
 =?us-ascii?Q?WacvylaoqXfJVb7bq3yzVDF3M0zHzLKJza4hx6qUep8uCgu6EiKcR/O3RJm4?=
 =?us-ascii?Q?Do8lzmEmXb8LzL5Ll9eHcU45ieNHCW7wHYwbDXT9PPsWfJl3GItWtjDt2fY1?=
 =?us-ascii?Q?J8CuM/8htRtYMFSLTtO1aNWsanTwldNG1S6Hgdk9TiE/UqVnu+jQa7hNTxUL?=
 =?us-ascii?Q?q92Y7sCV+Aah3NxABQJrlzKSlhS49PlIM1pZegqEK8db4KM5EZ5uiFoZXF7U?=
 =?us-ascii?Q?nfP23v/uUOF5SVGfDPPrj1x0RqcBZki7lk1PazrBbmfxszxrLfxeXg5vEI1n?=
 =?us-ascii?Q?SCvg5mh+gchL1pBJidMRchBqXd28iln5ShQ1mTqhxXIJE20hDsaCklJnd7PB?=
 =?us-ascii?Q?/aKOiIUNPGndKaEsnyJAVa0YPDIwvwGT6UVcRjS72Yl8LeV4CjwutqcdmdZm?=
 =?us-ascii?Q?416WimBCp8KQ3vixg3LD94w6SMmgPFz1m9rlph2hr7TeBgoN2s7KjHBGpWLT?=
 =?us-ascii?Q?kpuQIMicEvpOKg8H1UKeV34=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3775d84-410e-4268-d726-08da00ea8844
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 10:00:54.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qBKI3zOAe3eYz7HA2PcHGkPfIAkTNLGa+ngwm/FSvoFf5Ksi2cyPuO9bhB2L5KQP5VrshBaAPmH0tlKB6tFGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2333
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/vxlan/vxlan_core.c:2995:5-8:
Unneeded variable: "ret". Return "0" on line 3004.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/vxlan/vxlan_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b3cbd37c4b93..e06158a42823 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2986,28 +2986,27 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 		}
 		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
 }
 
 /* Cleanup timer and forwarding table on shutdown */
 static int vxlan_stop(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	int ret = 0;
 
 	vxlan_multicast_leave(vxlan);
 
 	del_timer_sync(&vxlan->age_timer);
 
 	vxlan_flush(vxlan, false);
 	vxlan_sock_release(vxlan);
 
-	return ret;
+	return 0;
 }
 
 /* Stub, nothing needs to be done. */
 static void vxlan_set_multicast_list(struct net_device *dev)
 {
 }
 
 static int vxlan_change_mtu(struct net_device *dev, int new_mtu)
 {
-- 
2.20.1

