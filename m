Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA745A1A3A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243755AbiHYUYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiHYUYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20902C04EB;
        Thu, 25 Aug 2022 13:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv9B0wwxRafM/nR8P6YpBvMR6SIOQd7HJXXnliL/KQQbVLVAiedKu9RJYCEqqI3p7tSpyt34piyIgKyIlmsic6NY9uGZtD/3w9G/3vnLCCxwRWmfcSb6ulPs2tYO3azf6ygtUrXi9YQ8+M2cqO76xVfxiYPzQF0DodsvXBSpsiUTY+yD3Efsb9OFEKjJi04jt+oI1L/cNwSTKEAsnxLn/6fRwKisTerxAPVvn253PgSjPvFJO3ouz1TeqxSIf4OGBja13P5gSOihtIWMYwTScVAYICQft7tSeqipK9merzMPRl0OphkmCyv1+jq7uVsLq007HE0LZfn/oNG0533ZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=bt72M2V0/EY6X65jm7JXcAcWqOLb9aW5UPYfvyCtqoXruiuY2V1qxxpYp5GnsyEm2s/97csqBbIIxE1gDI6dWZO+KB853KLdXKH0/Y1KSVlskUTSkl8yXglaXdfcxuXqCZJZ6Ket3R4SHN3w3/Y4RiIwxWmbdHFs0wMgWYdvF0TNNHE0MG072IZc3tduFvH1iG1NPwTU1dZNHUz4c0P8pwt1wqBDBBenGOw+yahQueBRmuPa6f7EO/X1nu+VqPvCCV2ZMuhVKd1ZQnoPU4qiUraFAth1lfrr+H7OcS9QZogVUq0ygZTmtxtalKdlgBsJPYv2tqGts2D+HGI0oKGH2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=ygiRCPZ0tVhhrYGmF5qtJj8gwrC2FIF5HUyoYP+fuNGWPB0oLsIMshboO4Ly5/oeJBaNtqbDUICYOUPXkUMIBaGT7jRa5guFcr5t/D5LKVT4Sl2Ea5jG2FFv0Pik1X+fejqvqItPGspWU8s0FKC2Pam3y+rJKlvK1htaUAcf+zU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:29 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:29 +0000
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
Subject: [PATCH net-next v4 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Thu, 25 Aug 2022 23:24:08 +0300
Message-Id: <20220825202415.16312-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 884557b1-2338-4bcd-8a82-08da86d7cffb
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lUMI+OalM6M5pRJBeCVRTGoeh4tjUAxzKJWi/fP6dDTeJT8CC84NvnxbJzzfcHEJh0b1eslEgWasjNtZ4AKNu5wwi+REHOTmQ6QZlUZVsFHuRLAGootfKuEChGRqihtddc0qjFmJfl+aOUUzYeuIPja0oS8OqrKlrhqfySuSaYDMIE1knqunInpQuBEHBM3RQABxX3U365KDr1e3CgymhqDDEOXIJf1/KTcBKNDcS13o8Bhrdv8lHoaWVXb0ujCdbOYiOfribtdO9z7/rIb5keT83QY5v9EUPwUU7apFrY0enW2a4V0qr2RSmd2g9+SQDV0gBSzVYAtaaSKxSkquyDywgP1BhDSTQRHCObMLfEY6VbWiXEKtss9kZZOkSepz6yZQTp7Esok+V5K9ArPR0lZBsqIMdzvH+4B0fEvF+pS7UoCY8qyXeZjmvfVxIMTkOnsQOxffqFmjcLZdkacyg0Xss34QxcrY4EkNsxcbYjg/LvKW8gTkvmw6Y6ULabtEYeHLm+iNzr/22RWFNYodFjDRimvU61npnYmN3HlFamP9DP/HnDWbqZVIhFR6xk4JVkp82++yhTCvST6T/Oz+JII2+57mmkVCOUyW1T+b9VQ1+ovHysXfCOdPAzBpyJKTh9PRs/qZc40Mlo4qSRomBjxp9XqukzDfTk6Wsu0q+L2eJO4wBCIwByCP3bkeEl/0zOuzfBHeZrbL8QBABrxpSQeKD2KazjAYmdMP7ydBx7w/Wre9P+dtK7/HvB8hvK7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sNSxIWumIwFCMw8RUWmPMbhXb5RskMx63eW6lFGOG+ULcciQBiU7gVEoCZ8D?=
 =?us-ascii?Q?DkC/K2XTEw2QUWW7oE2MEx6T0GbWeZCDiWTLfUmhL+ghSYhiRLQf7ulm2CMv?=
 =?us-ascii?Q?6wwWSeDgxbAh88tpX8RL7rP7WxUEpWADdUEv9GBHTA0G/VXhSCsXnfPQ8yQ/?=
 =?us-ascii?Q?3eS+4zmz/6XGyNGC/wP35W9/MgHQGF0+c2btylc6EyzgtMolxYbNV+kCrFmW?=
 =?us-ascii?Q?y9GQxe5icbrXnaFS3DU8gR52JdTlXcx24aFdBRq5zelBiAc/D8tS+2k3DarY?=
 =?us-ascii?Q?YMn5/T8nm5HSK4Izj7I4jxOH2mseLXpIo6ldUONb9lAPyZtky0yWoIpgaHWQ?=
 =?us-ascii?Q?S1xB39tIXZ43iHYdu9D6yd4/Nklod7xwwlBUWmjXajtwZAndBjLXjQ/XSadA?=
 =?us-ascii?Q?ecwd5CQfVHbSKKQYvornYfllYd1xxg7qSFH7P9nYmOnyyyy7fqJ2L+8Q0Sae?=
 =?us-ascii?Q?fj9HTZTU8sLYrP62QV4UX0HgHD0fTnDaZh4c8UNVhD18mpwNsbGUjVeyB0xC?=
 =?us-ascii?Q?p9ANATyaAc993OkIcAWSLlM88vb0QhhWBWroVQccZ1cNL6Phje+onxJ1p7Bb?=
 =?us-ascii?Q?SNhqiWx8MsbXRZ+S5EojCrTYh/yOXXL/yk+wn1i6+Ow/CqxcYIJmooEP8Bof?=
 =?us-ascii?Q?uSmduDQZnMcqBni/ckeSvBVbuPZFH5OvUvo0mUtQy/95FmZuUJ0pzXDmYRkf?=
 =?us-ascii?Q?rifOkqe0ODLGRZricrioybDIDQLv29U6jW6bOQvF1qtLh0jUloC3a99jQ7VL?=
 =?us-ascii?Q?kjZYim2hqdm+yZri3Skucy8z7+gVR+2VyWI1nt+G+3OK0dlpFQ0ZYOWVR237?=
 =?us-ascii?Q?lTTGzY9w6QS4lCcc86vw8Gx3DkqfSkgtZd9NF0rOXzDJ3t4nIKv3ENHc2zQo?=
 =?us-ascii?Q?yk8ZZqfdraSB7+3nUlBWDB0wUxTCCClBYRjr9EyLH63R8oIR+/eSDxguQqqS?=
 =?us-ascii?Q?Ptqiy85iUycUfRiHmSzHyEVg3TsqGwVb1lODg1wQxwCV+d8UwhrdCwtQld/o?=
 =?us-ascii?Q?EzsRhH7HloP0/HF5/VHtXh4qe7gphMqH4yvWlvDDeVF+stZOLiBesSAg5XE+?=
 =?us-ascii?Q?aRkIxWzfRBv11LVOyvrzjvH8yyrxyeG85CNEbMa/CBTTvlSTpc0M6QxGoK+U?=
 =?us-ascii?Q?fY/yCcW8u85x55IYU9+zXCDGnBvJMWGtkhiklGNupvYOMlRe4Q6TgrihRCIZ?=
 =?us-ascii?Q?XbBHOq61VHLoe4Y7DNEGpSP/jdgkxEKhKm9Z4ExJ4Eu04UbmyRpoWQ+P4XE3?=
 =?us-ascii?Q?q6Tf4nKLxJ1RbTS61JoX4htJQ6MOsUgcTxbDdYun/vheqLI6DGvbf7LLKHAB?=
 =?us-ascii?Q?QhPhrnsf0BT19XOEecsYnDrulUicLJzdBIp+gLhkoqImxNm6Zc/TQV9WQKSI?=
 =?us-ascii?Q?OlB4hGQ2mm2G2Z7bGpNT/FVT1GzBuD+0FrmYHUsqLuTFTQy+JBz4IOn2j67T?=
 =?us-ascii?Q?pEn1BJ+ePnBK8g/oQEApbHYD0fe5aBju+LWdwalmC/0ko960A3gekKeMY+YC?=
 =?us-ascii?Q?I8Z5Vtn3ukh1Hzk3DX9F95enT09GNF/gE9uaeryDaEsdqDEQ0YhOHhuEv9GT?=
 =?us-ascii?Q?4Ettvi0Oo6Cz+sU9qWfio1lLjELfcOAjHyU8XOQnavvcgaUWedC9rUi3xJ/O?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 884557b1-2338-4bcd-8a82-08da86d7cffb
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:29.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tItOQgEnw4ompYI2jbHvoxUthPQL8Mgj4X4oruhuRcPbHXvG1qSsrosnLds8h/UPd06hRq/QxjdI2OE4ChZ1FheJAkZf7o83l9/lMgzqSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

