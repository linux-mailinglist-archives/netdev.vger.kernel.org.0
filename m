Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F7E5B299E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiIHWxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIHWxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:44 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2121.outbound.protection.outlook.com [40.107.20.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6931228CE;
        Thu,  8 Sep 2022 15:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6CZb0RcRT1+uT+VxHSQutc67/IIkqI1Rz9PqSO0BwPxz+eOIDXLDthuGBM6LoGUB3wUjXdjYotbi77JGpUEq3KLPCcDeko1Ygg48nDZITtNDW37TAf1i07+C/FktacLph76PGhPw0WMfAR3N4Vsg6wgLaqeHGDQB9tdE3GwzuxnqvLOcnssBHel/uSLkZL6YvmwdRh2bBVtv/h0i+bJFM84lCCkiIPxFmw75RHW2me0EU9cxUNhzunDwYrg0J1uVkoi3FAHIiIdjmGYc4vtwfNFaLLgk70+kYme1dOspU1i6k9RQ9yadgaN5sW/1VjrJ7s0ckcEHQSlEgK1wvIrrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxmPEsFbZ4dg2vNzAFoUrclgi7szYxyiDzOtk3+uEEY=;
 b=CxRSb9VFq5QV93bKSgX8/X9VnccaEV9crGQHp9xM/rOyhkJRoTZCB71xn3DQLh32i1DtF8LNk4uwo6vs0aCERYC/D+yc3lKJFMwDA3Cp8L/FmgJET0jE4YJtgmmwln3r9VAW6B5Mq+ehDzALFYVIQ9f6VkkfRSBahcsA9G27JSQhB7r60DGUVgZ3/yKuJz9tF0yNZmCmn189zLeF7et2pNCCAbZFFWouJd0hm24/D968QbUtfeIvAnO0lOm1eSgUct9Cdbg0sm4LuvWikuGad7vYFU/EBadIdHB7pJgOIjb/K8acrShKyms9XrGTZiFtPv8awPN4UORo0t2u5QsJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxmPEsFbZ4dg2vNzAFoUrclgi7szYxyiDzOtk3+uEEY=;
 b=Q/5bpEmtCqCGo9MD9Q1SYr0kCuRlgqK7I2P33ktuU9rRVkB8mg4fulb+ALS+r06I7U7x+kvOE6tc1uaaLJ3sn9/yEUn5SR0UTDN+4T0663xTR+vyFN0Rw8DOyMHclaManHxuT5f5HQz1susyrrsc3ikAyf7D9yCCscJo+3ChKAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:33 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:33 +0000
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
Subject: [PATCH net-next v5 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Fri,  9 Sep 2022 01:52:04 +0300
Message-Id: <20220908225211.31482-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 833a2fba-db9e-4612-be12-08da91ecf493
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yhvMo0F6JLRlUaKmImeUXUBFM+2DJBXWwkSAubF0EiXvN5jXJejBrKW7UTp0vGqsmEbuTyLio/4PX5GHpkdQX4ooF3JMTuBTvO4opr3x1dbWj2iABynKQkV+81eiyWL5P6wUShLK2UxE1O1phKyS+fpE4ZTEddYAB5fKNFCtakFCNMMi6KoOQ0z2FVFqYizU91Z9zW8pjsvFB/Fh85rLLhI8/w5iLVbIHIns2tTM7Wvyw0F6FvRCy3FET+r+p+MorbKKDbG8JTJxbZ8XGaPxkiE/ZmpwYr6xekRVn02BGPlNTly7pGq4WHUFqLvQch/AuBSffKmjJLpPRuq4xs6MAWFCNfNaKfY1qHX9okz4pZCiMxb+bjLgehk0m1Ghn4UcnuE9s3HGBSuw3j9E1UMg88Ja1Gc30eRXsa6F6LAJx3TUMFTGqaYCtYy018zlT0d3Lcw4zfvqaz4a5qep4CJENthFSi8BbrU0iHIU4/oKsDnFUlYNZy/ugCG4Z2cLMsIOMibbPa8Zq3Dw1hCpzUS3WO34Ff6hmADX4GqG54/2D87Sts/W2qrmPyYzrI9GXNT5zvJfaUxZKfid6UHSfq0vWPp/8mCaX7w7/yhlEfCJadUO9k41nCBKIL4+tBbKg6VouSUAFpyHY4owylVyRXh0Ot+pcjEpiiGEtQ7wK9bWtKptdqXZIsh6/iD0rnRvjW8d3AFOucIq+QgpqctS01lX7HqKUvQy4H6CyvYTjMLFTaRhbqAdHTi7/AF9mhAhPf7P2UU+djX3veTgY3YnloFpIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwboiNwZt09rtPzzLdEAwxa70/i1DOB+Bs81zWxZnggrfOxbivlpfV+iMNVD?=
 =?us-ascii?Q?yrYhI+qt+ULGlkPgpkOYoDY9CcFUUOD8N0jTQZygd/JjnE20XrLkTGpMFeKA?=
 =?us-ascii?Q?zbo0iGFsRVy4dwxboZd1COZFTGaqgJm5KtOEnfYCeShW6YGCv/fwHxrHRXIs?=
 =?us-ascii?Q?s3pf7oUY5MOxgoslQ9/0LVZh6ekoW7PZUCkPg4sL3CgGDM5uPiW7AyiZjevW?=
 =?us-ascii?Q?Hc0C6e0CWH+XdmFUriDlW2R+89KujVYpxW0VCclDkZEP07Tt1nKhfBzWjORg?=
 =?us-ascii?Q?xjhqiM5GiuoBV0piIPiShI3QPHcA2m03LFF4A5a3PuBVGITp5lM/Bv/7vwLT?=
 =?us-ascii?Q?4o01qh9TivP+mbd4yM+NrkXKTdcr2ySoA4WNhkPDM8pVmaJM/m+BU/rVN7An?=
 =?us-ascii?Q?UOHHIsvXbkjdo0mBU6WLr0KapNbCAa7ydNDIoUKg0jUpQvWOGuhYXNwwSwuh?=
 =?us-ascii?Q?1s+C6h4nD7oTEoYuzVR+r10aT/zh+b8VglTxtc0gqzCgR3Hch6Hmb+o6FZdi?=
 =?us-ascii?Q?J/a10k2vK9VtCOdxwCNHbRf063pwEj2Y2sL/sPB2XEVKoLsNa2g8q90UnE0a?=
 =?us-ascii?Q?DU+68pZZJBMg5K+uf1gIGiyE/yIJHQ2Qs/2o18pnHnt5CYSDjfTggvJ3aJ+c?=
 =?us-ascii?Q?edzKNZUNqogYdGIG1nq6g+Hb20uIU7/9y8MJr7cSlpXgFXwZx6MqKVvIbqd5?=
 =?us-ascii?Q?TA8HDKRwyg/RVi9POHARyw784y+vqBf2ZwoSAw7UmLIVtrtW00DnwyfZ86nY?=
 =?us-ascii?Q?cqxZFEc6VZPK9fiG8Ogqb6+kqUeWNUn4pc1VYPFWO44GCqq7C/F/O4245apG?=
 =?us-ascii?Q?DlSJ9Gw2wYaimSr8nszoeDUz5FYcoDbbcip1SwQbxXr5t9oiwQeP0afeZCPq?=
 =?us-ascii?Q?WNk3T5g6Gv6cUvkxBmeTQV81AvONmFO9aXqyquAzspzR0vnN/B5Lq4HBll1J?=
 =?us-ascii?Q?TD/e2QR0obzfbT1lJUVlXYHt/k5fQDdCtdpf11AaZ0Gh66JPcHcoPQ4vo2HH?=
 =?us-ascii?Q?Gm/Sv+2UBjTeIuMb6wi6BFc2QhRmA5WV8ksyNhGJdtERBDE5rJSV6Gtmsg8f?=
 =?us-ascii?Q?LoMdnQHPUyq2Ki5kA7Zm80+zRyJhUUyZMVbJf/2CxeVsbF2HA9Gjh/YACmL3?=
 =?us-ascii?Q?Yqot80JJZvHc9PgUahEU5pKvAjfVV6FA8PZw2ae5VfLgc+KUvE4wU7qZ9KAs?=
 =?us-ascii?Q?n6wvxL+LfcRSEDpyXJuucyMfSfMzuA6NN4Dy0ocSpq4v0mP8nk6uVanz6vHH?=
 =?us-ascii?Q?wbHjN8wC3A3dhhUbo1ttgioIPsXfk9OQ2TvkidHJUdIIZ6Rj1KSX8Huf4gIF?=
 =?us-ascii?Q?BZVnTLA+uRzWY65ky9Baq0I2/qRK+Hv+ALXjNtzjKs8sgxw9jSQKwZJ0DhO1?=
 =?us-ascii?Q?PcNToRRJtN30oqh0nDK2TpcHhJ6SFqbVpu6VAqbZtrP7+jYFLEcCO8Zj40I0?=
 =?us-ascii?Q?34KIyCXqb42q1vYqoDStphMW6k6/jiaVRWp6KHe/k9UPykPAsx+JsVOp1cFL?=
 =?us-ascii?Q?EKNRhOWMjk45ABtrghxr6QQW3dHCVlVD+yPjK+fskdu0+Pfk6cvx0U1IpqWJ?=
 =?us-ascii?Q?TyABIcGtz6dWewem3UNuDN0Ln/gPdlhOoo795VlX9CxsUiFIYW1k/Tk/r5g2?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 833a2fba-db9e-4612-be12-08da91ecf493
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:32.9396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JRzhJ0QBGq7YMMBzRyWzazwqMG0mByiYTPrGi74tH7m2gFaHUiyzei1g1DN4W/2vJ+LBXtl6T38l+xvwiXw4f7sL5Oq0Jr305g6xSrxc6M=
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

