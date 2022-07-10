Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525D056D06D
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiGJRWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGJRWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:22:40 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60113.outbound.protection.outlook.com [40.107.6.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D03CCE0E;
        Sun, 10 Jul 2022 10:22:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODRXabeiJ6TGu++x+DxUBe5eXizzND62Mre1lsHhdoAnyA0HZeGJP1uDzJfDOlbJEWhUBGe+LX2NnhpDhA0T0wgOPrAuns7pYK7jzpPvgP6VvjU7/ZN87zO7CZWMGV4GgyQL1EV+JwW4NF2t0uS3Q7e09x+dma2TmarmYrgAYStlQUv1Gkn7yxaJeDtvAi6okTwAVhltRqSSihePiISQ2ZrX3ICIp1NHeNpO8ah8r8C+rgARmbkZRcf+NxkDw6xEXTpHl4GG7KiG1TZMp3YC05dRnF6YnwpK4GVv75in5w2pVyVi307nZndMZkk/SVAzpHHRrxfNQO8pOKGgXfUvkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=UXxkQv+h5GeZmrVEHHu8GeiJKz9FZQE9hK+Cl7rvu875e4NOzVjliutHOfVeQ3Vmro9d+5+S6Ki2oMMiPWmJFgpTdlPu5ZnJyb6s6Ox3ZztoUqyeo5EwuH6K7//kCuIZUxMMnoI6fun5DwNVY+GxOGPSPWqLznGJLAOUTR55CFqizZUb17GYIaChlvT5glzMKmq/CC67hW2ATybTohMVMFAk6+wq+yCMTKdmS1RnXGIpabXnuhhjQ0y/GCq7giKn14sEAnNKggarAQ89w+8cp6Nuuadf42bocU48SveSxlF5qoLrF0qn1yOQys9AkySAinJPpWxDWoLVdQ5/luwmjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=AgeK4h6YG8JYI1UvNUDWVkAiO6Nf5L/rOAjNe7KxTO+0LCUxPVxagVWfYvssGi+9xeVZun5/X6JXQs9E0kXs/sjOJGrAZk/mHX9WB5aWoAjmptsyR/JkVZ0j6Nls0oWtudb0wopfbN0V7BvKP6ov5qIp3a3IwjS9FJfWLVT93y8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:35 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:35 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Sun, 10 Jul 2022 20:22:00 +0300
Message-Id: <20220710172208.29851-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e96dcd79-90eb-4f68-a9d6-08da6298c7aa
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFKkseY+gGGjJu0W0jsvrNfGOhIl9L8iSNrRmJTH/mopOO4siAd1sO35pnyxDjnmQ/JkuRz/3BTPynaLrcs8sPl2Gtoida9193M7Bw4LQNbiOj4Ya5YPtahDtkdMfObseRqybGDM0VjS5sCO/oqqjiM8U9cy1E4duKXw7gJKipp8T/8SlqQuHB7vOusJhCivfueS/bOggXgjszhiL6baOUA/nkvw5CziQG3C02CB/WC5DCJtY0smV2SLEjyLv22UuK18mqU4PvlzNejdQdaHJG3zm1J4C0towEmu2DmzYDxhpXdD+sYvYmXBtwcyhnKvFf5OndN1rbZXySEcHOIp2OAOic0sxmG68xKE/nR+JFIDtfByHBI2miMk0uBSKycr0ZXQrx7JdeTxzueGkeQopU4S5jubIyGT81Bt1azqr/Qs6CGC10Lsx0CSJo1H/2gI6YAbZwMPNYXih9vC/NjMD+5UsrA4fgPk4jn5vJtw9ebCx3zCGA1/T6dlYSE+lh2pbYxEzpBWGGvQbdFXbKF3dvvuigilJggKzkqS0o85S6FI6X09Ccy8TmcKfYoxBzDs6mg12HYkIPwGa5+zY0ugP1Ujrz/4NTzcIc3rH5NW/CKNaoDgsRzMKmkuZ/FNM+fG3rV4ZzJQANzF8nuzkWreRFi1s/CbX0wu/3gl030czP+/8y3xf1xIxrG+C6eIWIlOmsv5FpQIJQl0e454B1M42KpHpg9S9it1xeSps8pxK3wzihY46f18PK0gcki/WRBs5PsoAcguskX6JgrXqVFuxT471wwW7YqwWMMOkgOgE5pZ54KBJT68FBerNnvgt8n5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLU9OE2KkFa/73XnqIKgyZwGhSGpZktdoGxSpwERx7fpd4N9qgQQiJAdTUgU?=
 =?us-ascii?Q?Xm+yBs/Rd4cAmJCtwX5IBMiwj85xiuemlAtnsVGKaYP9UzWk5f1X/to8TAnQ?=
 =?us-ascii?Q?EjRzMHyyF8DM5L0HxbLP5bWJOuL8KOoInU6hiUqnTlYwq1e+SXPkyZmlLDrS?=
 =?us-ascii?Q?vvAMwcsBwsOn23h2xxlubv5nLL+P9SMXjYyIzAic2k2AZ5y5MI0sWT+X9rUj?=
 =?us-ascii?Q?+ytAKLBSg8ObzZG6wFZ+oGgn1jQPCvXSpRYYhGu0OoRIoQKVSSPvEm+kvOm/?=
 =?us-ascii?Q?OBc960r7ZlhwoDwMxqdP4lgbAI/oZeO0uwnJyLJfkNkzipUJmtbe5KLvwH0F?=
 =?us-ascii?Q?+ILMDv2A4aP66gc7hJa8cfvIskmtzSHF5ZX77WpCRTXuaSgTIBlxrMb4EAIg?=
 =?us-ascii?Q?+SnLzsNm63N+AtrLhPdbQTRzIjlIgwex5LkEvcU7IWH9c8K7kTpSLJkLwhbY?=
 =?us-ascii?Q?ZM/oKhei8IymhRJzOUU1oomm/KaVdBU1tNjekyNN09d1c9ER4D0PKAYVv/D3?=
 =?us-ascii?Q?W2Rw5y10arubXIy644cMPm86MpWy0P7e8RnfB/vQiyYL4DyloX2hEZ0X3m60?=
 =?us-ascii?Q?/NIIPAvzCRjh0z9o5WJnwI5aLUkHtfBQv/Rli0U0BW0YEFkS7iNVwKWETJM0?=
 =?us-ascii?Q?1NffW8VE69sKRDCPtfCFfmKdF6D7idDDZo8ZX83nK1scxlo/fqtBFZLUc3Q7?=
 =?us-ascii?Q?Ge2b6yxa3SJ6fIeGazdxbhSfvIX1XeYbhB8EZpShbO0urybokNGEPfbgg5pb?=
 =?us-ascii?Q?CG5JsBEJZCil8AhUWvWh2uXvgQEFBYc+xU8t7CERblwG/rqPAD6MWwzfiqnu?=
 =?us-ascii?Q?JVqXawWcCHnuYebucz7yYhfCEUnyivlv0lm2FyXhaXAHRwF9eGhJDydgcq8u?=
 =?us-ascii?Q?T+62xvNsM1aqGte33qT+ZQGkMfM8wOkWwbbC+2GmVDA1deokEu7Pfu9LofJU?=
 =?us-ascii?Q?DjNDm+oHw4GvFNfxMWSFCz5+7vMHH/9F4vFDzqCnVpxwAVAJCaUuqiSF0UoB?=
 =?us-ascii?Q?8Bo3HMVf3xJ7JcUcovpewA+bMO5fMi0VrhxqeNXr2nyMVeLeKGsxpZHXxGiY?=
 =?us-ascii?Q?DOdzp2yOpR8nYT0FhVASgzgeflwQbbxRf3wkbCIUaCqi+EIRS/egEftzYuFP?=
 =?us-ascii?Q?tjtlfRcp30uIRLVsFqvb/fN6/7WKY9emD0+sfpbeS3iW75u1jskBDe+a7DlR?=
 =?us-ascii?Q?VzzurOBjM8etpO3avyKn0Ol0nd3bfigmG5xQaJBUhvIhT3pTV28cOaekkDsD?=
 =?us-ascii?Q?DGKtkEjpIlLu3g9RIzRBiYYRxLrQNDghiV7Cw9yxj4QR7sqlflbuZrYp5dsg?=
 =?us-ascii?Q?C4XbP0tesG9vUB0hyz6dpTz7FWiI37NAm0Z9zCZJuORYfdN97wNSF/QyeX2r?=
 =?us-ascii?Q?TDiF+acwh6F+XR2GmBW2Nw/dL3kajlQ1W6qOJjpGW7NWe4QSoLPytUogful/?=
 =?us-ascii?Q?RmkHuNYjT5OsydjVwToPgRNx8i2rg6gwHQOWHL6/XJ1ttAqPFwSCxCJY1p56?=
 =?us-ascii?Q?cF2YBBMwessJBT/PhWSWI8ismCPE++5Toti7OaZphrLIcq+aHgHQwHGV9lt5?=
 =?us-ascii?Q?4xVLS3nPQntkJRJbY5upPZoNTz20yHDNYFU0uqiUJqim8VAa+PLJqyayabun?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e96dcd79-90eb-4f68-a9d6-08da6298c7aa
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:35.1685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpkuMqUSzHutZxf6GQlygPZ5PRRh1KUJaQ9Wf7TAkt9KjuB69ML41Fax/4H3FFeOBBfumWpAJLO4NDw6vICVgk/pR+RFKOPUQ7ZAXckiugs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do explicity cleanup on router_hw_fini, to ensure, that all allocated
objects cleaned. This will be used in cases, when upper layer (cache) is not
mapped to router_hw layer.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router_hw.c     | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index b5407bb88d51..407f465f7562 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -57,6 +57,7 @@ static int prestera_nexthop_group_set(struct prestera_switch *sw,
 static bool
 prestera_nexthop_group_util_hw_state(struct prestera_switch *sw,
 				     struct prestera_nexthop_group *nh_grp);
+static void prestera_fib_node_destroy_ht(struct prestera_switch *sw);
 
 /* TODO: move to router.h as macros */
 static bool prestera_nh_neigh_key_is_valid(struct prestera_nh_neigh_key *key)
@@ -98,6 +99,7 @@ int prestera_router_hw_init(struct prestera_switch *sw)
 
 void prestera_router_hw_fini(struct prestera_switch *sw)
 {
+	prestera_fib_node_destroy_ht(sw);
 	WARN_ON(!list_empty(&sw->router->vr_list));
 	WARN_ON(!list_empty(&sw->router->rif_entry_list));
 	rhashtable_destroy(&sw->router->fib_ht);
@@ -606,6 +608,27 @@ void prestera_fib_node_destroy(struct prestera_switch *sw,
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

