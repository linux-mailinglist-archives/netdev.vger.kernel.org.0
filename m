Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F2A5B29A5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIHWxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIHWxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:50 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2119.outbound.protection.outlook.com [40.107.20.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F3C1316FE;
        Thu,  8 Sep 2022 15:53:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwtmfPm0AufO12+5Egf/eBA1SU476rGVGKXnz+RClFntu94HFOcolgvx4oPrPUp5M5WDJ7bRC2+FjVa/aGttd89/AXnJ6BfKO+2U0y7ivoKn93RuXdRAStFx+G36wRv/fC6VMLYVe+B8VlEILvNgEIz2Do+twqpDKpEsFTpaasv+z53zOhfMyBK61Kc+o1TQkdq1o3m9IrVuuahn8jWeuRvaZ8YDcABRJlahryo/cekgW9kP5fR/R0q0jBI5uzEmuonN4N8Eck2a9i0ScoFtpGZSyQ0sWC/TTwQUWjPfPcOqCBYKB0VJnR0JqF4OFOGdhl8wbJYGVzvBu3D1x+NOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hn+vllKNqCDrzvCy3JLN63DRNdTmAlku1u/GsZVezaU=;
 b=BY+8qJdhxbszEQgXHhed4WzYw7p5uQorF3XySwJSZuyF/QcomhknoPgEJmzguSEtS3/KxLxKoc31vWpfwSbWZJIXg1lHyrxbuU91rvQROYGGegcXdhteqs9qpV1RNxJW792fR6SK3LSTgR7wW9Y/iO43KSIt5L9qqcMUq8XVNxw4XxJmgxXhTvWHq0unqDT1kl+7DijOTsqyxtBVyodt85Ces3DYYJgaDc8tLEDv+Pb+jL6cEipLJLpv+ruyzlKa2Xi7uYVUBKFey7sEQaJtYZFCuwzlfu7Ah0pgKdMOJ9R56vJXVM1pxV5fKVkwWp91CYQFGZvZUSJevU/XWdcxlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hn+vllKNqCDrzvCy3JLN63DRNdTmAlku1u/GsZVezaU=;
 b=N8sxjpYIfW7YLD9d+KdreP3Vm85NH6ThNfHizqFtXJyRcW/Zc1mr74CTG+34wCmpAZIV+vjd0S5mpSnrhy+MQv1ttZtqBS3xVeOw9wAich1BBXRNMnHZpnv/x4tBJGC/OwtIA2c+snqxquXLtk+bDMf1bxFM3lUiBLoWS9QxOP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:34 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:34 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v5 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Fri,  9 Sep 2022 01:52:05 +0300
Message-Id: <20220908225211.31482-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8445fc88-ecec-4bd7-8d3c-08da91ecf53f
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Opq2G3piQi/3ozuW/OC1Uv8mTVjG/R7ro+URSB1iUtvQaRtiAtLS7DiSxnwJ1NMP/Dvxfk/2cHuLODkjIvzYhaXjMfwV1PpHvdXfmAlWP1IXzndKgDoWc3bB688Ew+dCQ1tFl76s6uq0SzKp37GTPzyQFtRNaenvuMd/M5s0aiXkkOSqYpws9dqlB1sgKLk+MiQsxM1OuT1VAIPxGDIh4otwGhzONRoXyuLIBhZuhSED46psz6ipjLiVpjTIpB+HAot6Wj8ShEzrBR1mhZ7u2xWBgJbAVdliDb803EQSs0uG5H6lCFSAEV71uUIQ0kqGKQ6NdlVjuXp2jN/ZD785kjXo+tmhat9hB2/G4tx4N/mzpGfsIva4JG1f1xs8qku8E9n0iPOXe2EIL/bM5gKTa0eiKcIhA4SXVbfPgjX1IvzRsNCbxTbSvK2NOTg1iX8qTW+OuegCDBpNUVL/M0Uaeilq6ogq9/n+jYQO/tRLAn6MOwJYQWhRKYXUcA969Wjg4wDGBd8I2+7cg4VDJZDf7exFQneV4efV9NpkWTn0V7sLXsn8bXr/qq7OjjxQiKUa/7mM1aftMuabUXM4lcKc3K8Z10VTa3I/2lvw6j46pJCi95x4OzhBZbDNsvp5bPsoZvclnhfagtHF+iANugfTAW08FQTblS4S8+wCZURlu9pTkQojcSocVNv3uTnyxHkD+JcLRN115NfpV/UXf45Fg9ZvvX5ucBEOfDj1Bd0daGblndfr0LhidAuzE/szwSnO3k/dvX9ENgjhm+mwJHtWdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(83380400001)(52116002)(2906002)(6512007)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S606InStJHOtCc6qGPDh3B2G6xb07Vhsyd0m1HnaVi1dF+y4tMD0YfR8IcHi?=
 =?us-ascii?Q?A42BRE3yFT+iD9N4GY7+dZ7cjVpvRaPimuNISTIyWVkLillXJrkug0TXsVOM?=
 =?us-ascii?Q?6Bj5Elf3nmca64iVz+hWUMDxNYvNArAv/7PQUiR4C5h+htE3Wg3r14LXgXJI?=
 =?us-ascii?Q?HIje7C1pKM1wdglU5c1onnQfytLLaxX4QiB7awIqX+515FmAiGAEQCjiHE51?=
 =?us-ascii?Q?AyrlXUeowtZ8CkPUXAAZi6hQYRSujbQM1g4PNeC6pg/mBbgPnObNsnyS62/n?=
 =?us-ascii?Q?pEfh3fHLnYlWDV2cIn6j+0FXaYNDDWZKVLfMrGklfgVj0Mhw1+OPTRehdH05?=
 =?us-ascii?Q?ym3zRDBaAjIWCRZuqkYVYoqBJ/nzZQgi0r5sElVmRVEa5X9gmnxre8TsuFuz?=
 =?us-ascii?Q?Vr+T+XfR8yu1zxG+so8nNbhCQ29zPOz7goIdOUPbkzSsOf+yeS/6d+yTCvz2?=
 =?us-ascii?Q?rgicRI36pocFlsTnbASSyq/6lb/2A9TyGLJGfAPtqNHfs1CyzFBp0cD8EIet?=
 =?us-ascii?Q?z0FdJ40qqraAqLoZjfz/3Pr47OBuluT2NMuy6bDQVFOU3Nuh/lspkMazXtnO?=
 =?us-ascii?Q?jpt2krnAynLHkc8yFKiHiRPrwzWf6+mtxK5wcWTSdwoXWMPvwoB+hjabAF/X?=
 =?us-ascii?Q?th17442VMTkkpt+t3/zy/1P+hbn68y2BnVV16GtUM7pY5M44iuETEvAqAgyd?=
 =?us-ascii?Q?mENGmGIUeFS/As1r6iC1pmYWSf23lbRg/aW4TO9nC1+wLlA0Pk6lpzh9IuAe?=
 =?us-ascii?Q?/KDhbixIQS2OHmVNGZABRwdLBhF39kJC7PFhRUBH5oH3tj4FGqEF5YvUjxxo?=
 =?us-ascii?Q?CL9iHTHPp2bXVXk5hVn1FTjAppd7bV8W6mdAkka197Kv0l7dBHc7sifI5Ef4?=
 =?us-ascii?Q?Hzp6/wRr2Wsg9RHZ9pEU1wclhuSl7olHQf3GS+yOfA16EdJra/fcIOWzCV+H?=
 =?us-ascii?Q?KxBYxf7fKAWR7oUDcfdnrvBA4kwU0NGeUXZN9eefwXCrY2FfMvoF8+fsWZnR?=
 =?us-ascii?Q?xvdT9VkhQ8HFaEFJXjn/iurD2rhPZsjsC987yk71a/ArGNL1pnZ/E8CZdidi?=
 =?us-ascii?Q?t+dwdlPm7IHXiq1mP+f5ilzvr9t32ErXGymwIYM6U5ZDEJ+yxZ4seSi9heU+?=
 =?us-ascii?Q?MftGM3v/2DnGDSCwzCkHj6Q2DGEEteIsxVxKVBIWMLBum/efK1jzjn6uq6EP?=
 =?us-ascii?Q?2a0GUyT0bQTtQQ5V6rNoH5q6Y0DM03e4IzNthwjqz18znr89VHpFDu2PF3yR?=
 =?us-ascii?Q?bKvWbYq3SzH2pHjSR2ESSN6AY7LikbUfaHyI+++3Xft6WWSjbwF1dNHDwdX8?=
 =?us-ascii?Q?DBqfILGqusnD704313GWtiZoFH+7TvtIcE10YOKgqbV99qybXL0/1AOVYFF8?=
 =?us-ascii?Q?yPtfSADiip1rujTuXi/OhPSNpFEWFu+iK3RRXVLUk0e10Ag4dTaPwywsl100?=
 =?us-ascii?Q?bzsWvDW6hwBJTcgkNuq5SNiHkuoo3BPHKil5eMIHNW9TekbL9qm11wNTiol+?=
 =?us-ascii?Q?SyKt3pvAsjuMNMe4UXrDRjMB4vUBugPTYiIkaTKvx1mIhHby7aPqD42bssgu?=
 =?us-ascii?Q?Ye52fzfqgqcnTfDVU+AhlAF9NiZanIxZOTVhaeY1tR+Mfm4miei8g11kZPuk?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8445fc88-ecec-4bd7-8d3c-08da91ecf53f
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:34.0644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1hbn4j4BslHi7kSoA7zijQAsvGy0nPxqi7/Ux02Gd1ax0u06WsnnR+CGP+LZ/M9DANcXSPainuk2559xcevMNAYEVOwRJSoW4GVMW0waas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will, ensure, that there is no more, preciously allocated fib_cache
entries left after deinit.
Will be used to free allocated resources of nexthop routes, that points
to "not our" port (e.g. eth0).

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index a8548b9f9cf1..bd0b21597676 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -336,6 +336,49 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	return 0;
 }
 
+static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_fib_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		fib_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!fib_cache) {
+			break;
+		} else if (IS_ERR(fib_cache)) {
+			continue;
+		} else if (fib_cache) {
+			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
+							     false, false,
+							     false);
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			prestera_kern_fib_cache_destroy(sw, fib_cache);
+		}
+	}
+}
+
+static void prestera_k_arb_abort(struct prestera_switch *sw)
+{
+	/* Function to remove all arbiter entries and related hw objects. */
+	/* Sequence:
+	 *   1) Clear arbiter tables, but don't touch hw
+	 *   2) Clear hw
+	 * We use such approach, because arbiter object is not directly mapped
+	 * to hw. So deletion of one arbiter object may even lead to creation of
+	 * hw object (e.g. in case of overlapped routes).
+	 */
+	__prestera_k_arb_abort_fib(sw);
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -602,6 +645,9 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+
+	prestera_k_arb_abort(sw);
+
 	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
-- 
2.17.1

