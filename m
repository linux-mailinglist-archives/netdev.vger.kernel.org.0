Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3566757D699
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiGUWMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiGUWMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:12 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AC7951DD;
        Thu, 21 Jul 2022 15:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0iVul68Km7f0uUVBLPaSh8dMDUGefKM1avqmx80lhVM1zdCKmKAfAYrsiZzSNFHBwy5FrVtUoehUu7xh3MVSYnxeXojM80bZtoicQJoefYkZNaerjjmkf1GNJeG6EiUNoINVfp/1F/pEN56+6cGFX8QBNfTByKkTgFkwOrAjCDNmeowut90ulfcUGemUsd5VCIP3ivRk2/oIziYshzFeWJEOjC9/SGGeizbCZJEeDdcg0AcJ6ox/K2eIUZlPgrfhegemTXBhFhQzVb0t3RnlEmXmCxbLBWd6Kk6esTrhp34apVL0ighDfo21acBaT8dgsus5qe2tTYa1adfG4XQ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=ECl+pEkCI0MDT8ckVLkR6TuW3cz7/p7NFPjVU8GYQJm9G8k8FIBMtjsiS+nRJ7vE17NSL3q3uC3VR1q+Pce3yAgbs4EtS9nW7sAr10TM4p7TznesvKPUHB3yqorW7d0gvO2pVtzRV3DlZuhf/i38UaXGVHtPPTECvOaYMEBBfPsT9+XAzS/ETpz1XYmVP7rcVQi3wWNPNF8GpMEa0RRWROHL34cN8eJ58D0iJGn3D91m+ubEYVGt3290CANkdiShE4Tq3mJ3t5Od1pKeM0QzskjyvvM9sHxLVEkTCaaoNpX4p5Bh3bUU9MFTt7u5wvhRt+0ZnPYYuNyCZEMcYtEIkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phsiTmFsyC3SdiNZMzqTCL5Go0NJaBTxYGCPHlMUCNY=;
 b=xwfZqTabMBHE3YXbxozsuikIq3QRr3kIJNXGoFaor4afYP8IAA21oRZpFgqDC56yphB0KabuiC5u47maptPOnUc9OJwz9hmJJdxo4uErDGNVrkF/h06glZRYfXzqyNEeH8Kt/PztdH1gItwfNfVZwjOGXjzvhM+C9WeyUcTKyXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:08 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:08 +0000
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
Subject: [PATCH net-next v2 2/9] net: marvell: prestera: Add cleanup of allocated fib_nodes
Date:   Fri, 22 Jul 2022 01:11:41 +0300
Message-Id: <20220721221148.18787-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
References: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3db06ef-f565-4471-56cf-08da6b660d5a
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFoKCDKJy/j237SomqCBhP22lsphbll6kUHVgV8isK9rkhIPHQorjDeJjindl556RvoqQl7N6mZTj3s0cs8D6L0TygdBXrVUMzOKvRVG7KzG663YYNftkiaocxuO8Vh6ZjWlpGpxolu5Qa6H1RmN1ALuQpflvBP6H1HBE1jEyocArMXt0meNgRXtO/W8QneL5zkFFTJpJkoTTsYder7PzOI6WIEaNoEy7P/ISQ2lvmybCUs2dAiRQzIaL9Jiaq8HKfEK0ULw5mb1YKlwR/eTAMe8XIGPknFyMSMv/hmvF7SD0ckR38b9fJlKf1Tt6lLOXh8nsPt09GTb6L81h5T8To/Sw9zDlfrsSUlaVMRSt9Yjw4izR8OofxiTGs+7EMJ4DF3YGBtr0KE4dnqr2jvQ0uWEZcPPG3wjnqk6dhuBlGY/H88CJolv/0ltVcQVIY3GXFp7ZrvowX4TUpN/2yleN7TjLCEOnudy0/1geXB/6xpl5bVVXELW6/Z0Dif5rGhr4VqchJ10s3q7why3KNJW6hKlupATvsIg62dorRfH+Svgpla0/ZhCvwLBwZyK5rlhEetkpyyWn8Ja9+iHXbYf1bguy6ERk1sn+xxa7k5zMeFFzqgTJMAzAdZxpBWqdPkvwXceVRk7bSpiKzRh6evOJYyw7u1uK9JRFL2S9QOYIRGyysrAxulXiuuOrVDRQQ2HEsug2aoEcJGqoGWLgmLWaKIiJU71eU5b/2igfUiXewjCYuzSgR9g/rP3oGXUj6r9B5LvXtLYM2btM2DBBWtZJSQ29Di7Rr/B5nI9FxgL1uE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bu7Ro2g1JDvPeugQ/7YGsZKBu+/Qz+kguydvEFJQceNmmq8WD29P8mx0xXtA?=
 =?us-ascii?Q?hscvfrS0Wwoa6QypRf2gDDYfMXBnhW+3YvCTExp4RhLgjzyWWJy1rbPnJTHA?=
 =?us-ascii?Q?SS+CxcuMveOTismf6yyxOVTYg03fOfdA+g/pK0mbZmoA+ccOD+gDSB9A/dHF?=
 =?us-ascii?Q?i/AXFZzwxGqLV0++XSxgrHdmKGOTL7cK4cuMvijb17rr3DPYHdmxYvuu0h7O?=
 =?us-ascii?Q?iCqIAdlNKTOjPMFkzi8Yqs3VhXeaZIYY3DhTMZljiLKa2bcMi5ZCySLzlT4J?=
 =?us-ascii?Q?6qgUCcT9sXNJ+0ucdGbMBE8Re1DaEa4XuciSnqln64uspHwJ1YVTWM0NXMpa?=
 =?us-ascii?Q?/+UYodcBTxiHmcLR22j9OR7+xHEkXFP6/8yNy5htVwlHAaPyLXNfZpQoczFZ?=
 =?us-ascii?Q?ieiWWOXRq+g1/aZFLfqr6of2gbRVL8/0I4c/3Nkcxwrs74hMRpiyheNugSbV?=
 =?us-ascii?Q?ON7Bjb8TLj1Q4zdAPnOo7F0MkwNPxKRg9M9rTTGRF6p3CKRPEwTiVLtQ0aJc?=
 =?us-ascii?Q?7BTfGmGpmdtUJfMUW5js4BFr7Xs5KqU3n2Q5NgYjcddhlJNpj//RlrNet4L9?=
 =?us-ascii?Q?QwwZojZzJUdULeQC2qElP7yQTcHOvdYefiJ7bIGhs+i3F8VImGJcU+Omq/qI?=
 =?us-ascii?Q?kwOwgLDlhVOPbhdeuEtIOwK9x7GYTPXzmUwXz5WTDAPweZbExEOZiLqDYj9f?=
 =?us-ascii?Q?WLZ9fTqA+dQPaewLJv20CnELQfzti16379ivovP+razxOKSOhKhJfXt6CR48?=
 =?us-ascii?Q?DTuBD3LYi8Ni3zmP52y64i5EKK7eFDQ6HfdQqfBW4c63YS5TpJ03J0LZ3mwL?=
 =?us-ascii?Q?/8QRyw5Se6CyMupqGvcIRxuFgtk4gjFvES8bRn30/PUtQxvrXQFgDVuBRNr8?=
 =?us-ascii?Q?kGDsbqzJSFlsZbQT3Llen67yw4ZQT8sMHCI2w0o4hk5JCteX1hgCuDOsdCPK?=
 =?us-ascii?Q?G/TZEtq6P915lFlPjN491s3266R50k6AvHc2K1EYjewJyKiVa31PeDG8kCvy?=
 =?us-ascii?Q?1dE+re7xEzwXSBaAIt/oISqN6SAVzaiCCSJ/96MtW+pWOCalcOgIcDEPStDe?=
 =?us-ascii?Q?51bVAh6heLZ+HJmC5URbzNgrsBWv7PutplqwC6X8VzZcJATRKLEJowVaU+Hs?=
 =?us-ascii?Q?ovMjsT7SPShpxW4gFJBSyygJeCKur7UUDtWj0nDJVzjp7y2pxehJ8caf5FJu?=
 =?us-ascii?Q?CJ7j8SJ4XE/xbT5t/0MRxqT2MsC1Ao1IBVVJn4EI/8GIDNR3HA7+ZE34S5CX?=
 =?us-ascii?Q?lC26UhAIRBSpONjz/8GcUm8aWLtXf2qc/+8F+aMuEvY7qeIQEmPqAXlc4U9+?=
 =?us-ascii?Q?aPu2clS/0bH9ZXrwwv0XURG8j45k/RdJzCty0cfgce51U9mBVo8EmazlBc0k?=
 =?us-ascii?Q?sOyhVFJK2mzMsWTtMNqg8aT0qZXsXkFkveMIBpq2NCXAGSky4IJTTnUziXuR?=
 =?us-ascii?Q?jYqe4Y0DHabSNXuCEsasP2DGhNegbPotyYFouBTOm1Z0Evuxr7dPggs2yUPc?=
 =?us-ascii?Q?gHrsAMV0kWPNl9uhkIgM0EbIgBHzdJ5WDGbN8lupCZATPe9hh1pjsD/wXvlG?=
 =?us-ascii?Q?Y1MMy4gvMysIa+COXlQAPPrs4ydBff+Tg+3xo8C3E1+BH3oszBRDCUtIZyRj?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f3db06ef-f565-4471-56cf-08da6b660d5a
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:08.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlZ0ygGvk6jG4SU3RIcz34QQkauZBVSmZ2W/xsP5gl569vBjfCqILN9B5kKZ21E5MvmJcDi5MvdVfZd8Ws3qmp3B61TFb+NOfb69wX6KGX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
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

