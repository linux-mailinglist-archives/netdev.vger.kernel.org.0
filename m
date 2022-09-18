Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71345BBF94
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiIRTr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIRTrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:47:23 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80102.outbound.protection.outlook.com [40.107.8.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBDF175B9;
        Sun, 18 Sep 2022 12:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByOQUOGoDDANJ9c2rqV9eKFrotZ924sv3+P1NoAFkI5xrKU0hoVHF9YNFL7BpxFceYtXwDPB6gMxn5l26o7aPt610iS1Kx1uul4R+FmCVQNucqanNmyew+F7374mrjnxim7Q1QwBjuhsixPA322hKU1C5IkE4ywOhaQp3+S1TyL7f7Hed5mT0+Q2wGXjqOg+6EpAFocahXxKUBIxD7QfD87jOnzmBtYRvU0dko9x0LXAh+LI/Nx4SyjRK8cvxICPfSYSNBXKWChpGDHZqRni7bygqjB0kHPYp3O5PoofzAHZ+EJXJE5leVKfP/AOlxGQJou6pXKvjwOPUNPkfC215g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxmPEsFbZ4dg2vNzAFoUrclgi7szYxyiDzOtk3+uEEY=;
 b=Vb6233lgR/QEU7JmyLQiOfp7ULYxxkVqDaZN3BBkuT5/7kPBgo3LFcDc6jJlEkEmWwG1+IiarSEX0uk9Jnmemw/nCCMr6nD2EiMKMvc7R6B4oAjVzaS09d8f7p4HSwYddNRbJbgkrEN5bJxduNX0qPnRFmf/9PXn8V+bN82cmTWCZVptIxEtVpmVasqF6gsTYAOHtw13m8FOID/W2a20BSwsMbrdIGT+AyozoE2cGrL65FqgeZLRNJCBk0dcNt31QW51zunNur7kl4ylq9j7ioSzHenVYjowubVGIvS9+5NVeV3YCQ/Zv14af/GlowBfwSUgpAWe52yJ6hIqfdTybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxmPEsFbZ4dg2vNzAFoUrclgi7szYxyiDzOtk3+uEEY=;
 b=MlLGune12QJDcWnNAR3N2SZ5cZv8d/jNziuk6jR54p0OxtfOO7z190jgvlsz54AposvGiChdwtUvUm0WEcI11Xv21kOlYPUVr4VyNnPJ4iE7GrBMyyXHj40WqpbjONtnJrhl693ysnbt/o+kkWlkOKMGabUh/M/91JSFZE0QRQE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS4P190MB1927.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:513::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Sun, 18 Sep
 2022 19:47:18 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::75d9:ce33:75f0:d49f%5]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 19:47:18 +0000
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
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v6 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Sun, 18 Sep 2022 22:46:53 +0300
Message-Id: <20220918194700.19905-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
References: <20220918194700.19905-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::18) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|AS4P190MB1927:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b689586-3d25-4cc2-2d5b-08da99ae9856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /w6I40G4N2A+JuDruxPmOguOJXHu9VLb+plMuaVshPTCbN1xRWk7ZUHwhk4yWIai9Ow0CaYcubyMpi9e9wYDnEazMimNtP9odUk7zBm5JWtprj9Ajof2J2ylJ83OutVfIDg6ea93MOGEJjWgx9Zhxl/ViFiV+WdAXJxebGYCiviWWqLuLLzdPXR21SY0v9XhbVc8z9T/sLoJ6Vz3yqC0I43MS8NWTqLiEaksl47FYi5XowRTbgPNFMEFeBPFws+EzV6QrnSFJ7hyHrnILcjTLbzi8syEgqwiNOIvsFy4rflS0Kgjku7cCiNzoCMV/pU1/Bh24L2vwsTK4hLT96RAOs9BSEIU5YcrhZOjWfDGwzxl5zbD7YURhEN4wJkk7vo1C/pJMIl7uKuP0pyjo+TEskefempPALDgrq54Agt68ZROc4XrumGlWT8RebC2OCYJIa1LINfUekfenAC2kfJ/W7sitTO2qmOkmxhXe0b9zK+JakztojYbobWmlcQzx20hJDh+9/Kl3aBERgz52nzPpdKg/UN2E8NgBIqMt+RYYDXOqbWVQOhmk2uvo0jNJMFhwYwz4VV/P32kichqPBAp6BAzpSnBR8kWZe8N7SPMTl7SGR3IuliZIn8xBoWRtODZJVvYM9g632mrHG28qUHCn//bZURehu/BORrkWePJcpCbWr1+vmCNYw3lSu5ZfE682B7bElYlnbHMJ+zgBvmBWiTpxYmk8QCZRlpJo8+i9UBO0cpBJKjF0MkQ+rmJj1gr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199015)(478600001)(6486002)(316002)(36756003)(66574015)(186003)(1076003)(2616005)(86362001)(38100700002)(38350700002)(26005)(6916009)(54906003)(52116002)(6512007)(6506007)(6666004)(107886003)(66946007)(66556008)(41300700001)(44832011)(5660300002)(8936002)(7416002)(66476007)(2906002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEPg63fULGKcJta3hsbNE2uNI1OpUb14DZYeRDLfr6AXKCyZC6xTFAB6jH2M?=
 =?us-ascii?Q?0KfQWVwoxvBX9MZQi/5pGJMF++Vkvv1iKBz64CMLc8Ch6WGsYSiNOUzIivWg?=
 =?us-ascii?Q?Kq27ltemFmHnNPcJi7FK7jJSpOpMkho1cjRXuM2usQSdO8xmqcS/jI4ivomv?=
 =?us-ascii?Q?6n2jCWFMPU8zQZEwetOlMzqp0yvZn3xCsGEOsPUXoqqc5kyEFo8ZZtvPJ/W3?=
 =?us-ascii?Q?jt0IOFTJTt2sAnk2vBjWclnAMad1DFCvGnwWgKZ8nZ136WfqqyOAuo9spbij?=
 =?us-ascii?Q?AKYggAlSzQxOdbatf0iO95jjW589uDskGqMUx15WEAPYQ5Ag+aAzS4/mq+Sx?=
 =?us-ascii?Q?MwpfgJllngSITecpX9Vq0dDrEO4URoP+WPnQDqL9gu1rt9g9A3RE3nQdck5N?=
 =?us-ascii?Q?IIcYr5dJZyinoRsvlV9+vVblzC9Y0YcRi8/eV/7OQ56Lok1ldjwRm3QRduet?=
 =?us-ascii?Q?9ewPvmB98Lda60GJhEGkMEL5glGx7wfUC9PrCbosIHUsEMruqu8leG9ruuUC?=
 =?us-ascii?Q?e7QsLkpVllHhhZb5KqmKJwyKRyBVuMqNa/Bv+ecRsSg1L5NYe6onlkVvEk1w?=
 =?us-ascii?Q?ampafxaqSK3AC/5wBpQV0Zqj2mO3+WFavUMG32SGipXpb+ouzTjVAm10qEXC?=
 =?us-ascii?Q?4PmJgCApEancEQaQLwqZdMjL8mGNRXcBsIk2mTETad80uovQjZzFIDMBWIY4?=
 =?us-ascii?Q?hnwdbeOO6wxu6ELNEG/XrFpOnD31+WCTLHvoy9tImmeiHn8rJlXRB4tsfqdP?=
 =?us-ascii?Q?AH6mqw48/xDKrmcm6RnhJbG//LYRbXjxWOO78TytFy4o5HbEyIXWSACd3Kog?=
 =?us-ascii?Q?ef46zTv1RdzyStnH1fpqWtMDeycjG/fqsIJTo3mOExTmsIfJe7p71PtHtiX4?=
 =?us-ascii?Q?DkWNESQ620kgESNWlc8gMMdi/jR1FbTNrlx56VYUc/y+hhGOzdW2KeTCjXoo?=
 =?us-ascii?Q?j47+YMIFKISP2pKxS9kDKT09w5W7Uunt07sBRXVTmJRYrZNc9N7dcfey2a1Y?=
 =?us-ascii?Q?cqxXHvQq7BgSalIX8p6tGFiWJdajZDvh2bu5jFuCbRQzr/Rf1rf6t+dcz77t?=
 =?us-ascii?Q?MwuYepHMuVx09I5nZNuFZkUJ15gWKuDMHaduNnLmbH+kJqserl3j3xGDX+x2?=
 =?us-ascii?Q?ZsfnfIzf1eXHlHk7aA1LWZAorjfimxi1xkl69ZIW+qJVdoXN5VuZ+efy9Op4?=
 =?us-ascii?Q?SeR+zzqDxHnpLDNMNThK1Q4BCwU3QziMHLFAW1l9FANh5Dgc1qAULvHMz7Tf?=
 =?us-ascii?Q?m+AuChKaYzKJmOtanS1J0rYejl4i25Q5ahmXe7SwaoA1TYCA750H/jVP4q6D?=
 =?us-ascii?Q?F1+LtgNOOewN0ORfIBH6Nl0pP4ylZvAbxFnbwtpNb0WPuxLAxKoqNOsQbXfL?=
 =?us-ascii?Q?Pjd+keIIdA9g4PJ35ZrGYB4BMl62ICUXDQkbhApNm7mW7sobZkqbDHssratU?=
 =?us-ascii?Q?XQh9bO+71KGhT9pgqHaYAUf/CUUIol35uyMvpDTLXqw7hfidbA3HBi8mWpnl?=
 =?us-ascii?Q?uq9fI+8CDBfqAYYXSXFYxx4KDGeAwZAfRaAbcoM999al7sg0vtMN+c4uKuhu?=
 =?us-ascii?Q?mq8DZcFER/QF4e2ZLT3cQ1/lkMp0rTDQoc7K6EIr53j3ymlyt5LP8aoxIIxD?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b689586-3d25-4cc2-2d5b-08da99ae9856
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 19:47:18.6896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOkxpKkJd3atCWFq+1f1sBUVtY+yatx0kd3kIYqDGWfE/38mKfhCYvFe8u5hrFOcR+U/nUQ3Hntyh8Xx3zRIjmTFCPX9Du5+xW0xd/sr/2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do explicity cleanup on router_hw_fini, to ensure, that all allocated
objects cleaned. This will be used in cases,
when upper layer (cache) is not mapped to router_hw layer.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router_hw.c     | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index db9d2e9d9904..1b9feb396811 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -56,6 +56,7 @@ static int prestera_nexthop_group_set(struct prestera_switch *sw,
 static bool
 prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
 				     struct prestera_nexthop_group *nh_grp);
+static void prestera_fib_node_destroy_ht(struct prestera_switch *sw);
 
 /* TODO: move to router.h as macros */
 static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
@@ -97,6 +98,7 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 
 void prestera_router_hw_fini(struct prestera_switch *sw)
 {
+	prestera_fib_node_destroy_ht(sw);
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
@@ -605,6 +607,27 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
 	kfree(fib_node);
 }
 
+static void prestera_fib_node_destroy_ht(struct prestera_switch *sw)
+{
+	struct prestera_fib_node *node;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->fib_ht, &iter);
+		rhashtable_walk_start(&iter);
+		node = rhashtable_walk_next(&iter);
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!node)
+			break;
+		else if (IS_ERR(node))
+			continue;
+		else if (node)
+			prestera_fib_node_destroy(sw, node);
+	}
+}
+
 struct prestera_fib_node *
 prestera_fib_node_create(struct prestera_switch *sw,
 			 struct prestera_fib_key *key,
-- 
2.17.1

