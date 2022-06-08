Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E104542C33
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiFHJ6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiFHJ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:57:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2096.outbound.protection.outlook.com [40.107.223.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E61E20
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 02:30:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBRKeCDQdP1uA56rFlSBAdtq0wor19OM89tbHLSbHRkSyLvzaYp12UTwxbw+XaMO7JG7uKy/y185uUMXgT5R+Lg9lFsRBiGcar8eddg5XCWxvZI7WoJef/P7cYU5k7sYYi7HuphlIiSK77dMI0qR14q+5vnJft7YXCxT0RL5Bh0Dfjg9chf8xihZ46QkeC0utiRmrZR0PKi2ky8Spva+RiRIUT/kb1YkGxlfSldZqO35aj5ECZK4z1QTwL7k89XGlGrwn9WqQm0oBfHAvUOhU8X7BS9BEnmJmIL/2s7JmE5b64TBFzcMX3exHwUnX+NY8YL3WbPdJ1uUs0uk+e/EVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8gd9IN6M/HGRAWkn0Ut8QBW7hAiRv0jBqVOyoJ8Y6Y=;
 b=QVY17908q9GBytxSKFURAN3JkzcuUomheMIuc503L8qYS79LQHBQBMBN8UTZt8WxArChpLMpUDlKx2SXHZNE5gJy4utGAkJTHxuKnmlh9xJcuQBrxdk48Ndrqe3pUEMz0OkOorOQoW50lKo5S9hQs8LK705U037KD4UlZx9DIwfrrnqDSqpqQDjiah+k4ST3gDpgYEKtgsPo0cwiCPha7o0cFB1Zq9qHVtnAAHEFtolteewqUfMoOiy7uOwpFaJws4YfOQNpBMRjlil9cgbmQspFE1nLyTdrkVUH1sAeyrLNXqJixYFTGzWwZWUlbzyLqz7iV+mFVMoSgUBFO3kVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8gd9IN6M/HGRAWkn0Ut8QBW7hAiRv0jBqVOyoJ8Y6Y=;
 b=d7QtkmNfKnvCAAnWJyh7aWyvphO9ClfzgX8smHiT0P3UH8Y4OGvQX4w8+tZ01uOfYp1i/bw3zACuINMhl+oWzM956cCyohnseN/nwBxqJtxBDh1GgoE9gerivS6SUoil9503VYfg+szMtfAq4ctdXqkGe6knNS10m0pzHtYsDjQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5575.namprd13.prod.outlook.com (2603:10b6:510:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Wed, 8 Jun
 2022 09:29:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Wed, 8 Jun 2022
 09:29:58 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>,
        Etienne van der Linde <etienne.vanderlinde@corigine.com>
Subject: [PATCH net 2/2] nfp: flower: restructure flow-key for gre+vlan combination
Date:   Wed,  8 Jun 2022 11:29:01 +0200
Message-Id: <20220608092901.124780-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608092901.124780-1-simon.horman@corigine.com>
References: <20220608092901.124780-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0071.eurprd07.prod.outlook.com
 (2603:10a6:207:4::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f05cff7d-3fbd-4644-32a6-08da493174b4
X-MS-TrafficTypeDiagnostic: PH7PR13MB5575:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55755653864127F424C9DFF5E8A49@PH7PR13MB5575.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2nZ0cUUbbm5IBxm7xDm7PCLAI7LGDCD575hs497gPauGvVwj+wXs6R636iFL49/5Ct3dGWTtW3jpk4GSobLLc3LNqvleFf+gCprnn/G+IUCQCG4JlR8pYgrlyUeR351/RMTLNofsVzrDus9Auv7wMKS6urmJVFslHsD++y/i7brgrgghZw0V65IH6oY+WV+/7yDnXEx7cyDYl9Uc2AHbueka8HOZ/8GVAzSbWcx2eEQGQspe1oTQy6qviKDMT364vrDIZJX9z7NU16f831ycYk0Zn9z3095BNhGWausiRaEewNycfZiHiY8lzuIdaOsRoPgq2tp37v+P35E7sC/reZjb/xR6SrbGOSM+jlU2a4QQr3JZFxO1YY4uGTKxy2L3omZatl8MBccjLHa6/sjGBk4lxL9looWFaIoXUGxI3yJYOeRktXzo/OMrvqWYYwmK2ZIYlwnq2rFenMnsCGyHF7TWRgbbh4WLAWrvmILICVT1WBtbHa7rn9fv+InWnKYT+Lwn6x2lVubA+JcQJbccNEUfAE4NJ+ABZxp6UVUgAWMTMIatgcY0o9QBMTD6YY7ckkdcj7PLLDrkfOEaqez4IQZfgo4eIh+hjH7lMc+bY+ieaZ4YEChnMIvSuGhYZjiTmcec42lGVX3vDj6mAQNu3hZ8HOzWXpj7nSW+8KN39I6Yf4/L/ix3tfuiYcHtEKD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(396003)(136003)(366004)(39840400004)(41300700001)(1076003)(186003)(508600001)(8936002)(2906002)(54906003)(83380400001)(36756003)(6486002)(38100700002)(44832011)(86362001)(2616005)(316002)(110136005)(107886003)(5660300002)(6666004)(6506007)(4326008)(52116002)(8676002)(66556008)(66476007)(66946007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bAJ1ONONGEJE2CiTG88m9p2FsLkYZyPLI4bLzMbFlkjjnaWaRCuzkj7zDAt7?=
 =?us-ascii?Q?tAj/aPNFx5O7YpE1ejTkRc4eomTMCEaKn1/NFNCbcE6/jjzu3nuF1V/4wD1G?=
 =?us-ascii?Q?Bu5rd5heSc8+/Bw8bOEEVTLjIryiY0WFK29rN2Z9zfS+PBjN/fqBhvhwSfJD?=
 =?us-ascii?Q?TBRO2wiOFdvYoQQfTGdMNY4MxuORg9//O4orB6RoUJXUYncwac+B98ecGybi?=
 =?us-ascii?Q?GzwRt0q7YsmDXHon76PEPJFNXJvHyTR7MyiETX+I7Af7mrNlFHdi0QJB3+ni?=
 =?us-ascii?Q?VkVvQVA+YdyyjZp4j//jaxE7iwAFTdD9wRyXiKmuLjtZYt/ECl1uRJ/C02QG?=
 =?us-ascii?Q?yIcigLAdReI3BsmgNY9HjHnPZPvgLL7Mlrx2t0XL5Bn+LorMEMtNyECVY81r?=
 =?us-ascii?Q?qPlSICEmvkpmmbW7eskgzFeZCxTdouH3X+QTUlwIJVsqBi+g05nepzh2Hyet?=
 =?us-ascii?Q?i/El2VhlUQtBZ0r2yfnir+68xH4zBa0rBaoACk/xGPQIpWiZgOiuzbd54IPZ?=
 =?us-ascii?Q?fFcI/7hW1KtyL7hWYLfVlSwAuCSeUgSspwII6aSMC0/8uzZJh45TZgvFAtmt?=
 =?us-ascii?Q?garxwvs/QBVJJuekfRME8AdNbiSUa28HtFHQVTSnen7xD8pUyCDZ/DLyYae3?=
 =?us-ascii?Q?/GVdQUqdCnOcDmO5sVN3uDOOtDKqa1on4FRfEySaTnTVkOZE/VrB8Lvd1c2Y?=
 =?us-ascii?Q?hvweFH5zKzPon3SQXpF/vTD2dnkM43mEYRNOeQHmLltaCbvDjKN1DQOs6hrE?=
 =?us-ascii?Q?/7khdKxBaIdEIPoRMs8K4jk1q4OK4j/HR7H2NU4rofn8PbLj2cSXjQiYZEm/?=
 =?us-ascii?Q?x9NdgY3k3egs2Rw8zI3t9NGvUpKMj6YCGXAteRAC2DAPdKyMk5hkYwER/WWM?=
 =?us-ascii?Q?mAPO65s4BkpDYR/+p6QQTitPVTCpD02ykc7JF3Pg/Ssu/O4Ana7kOpy5NUGD?=
 =?us-ascii?Q?XPsvQxIgzUN2v2PJc4waZA4mAf5YQ/zVBZXb8l6q6JZQO+NhJYH7BYPxgBLM?=
 =?us-ascii?Q?MnBR7FklJ8QI8JKdHQNasd2lNnXf1GGYUojFrw7VM2dAzoLV3Em/9kOBItRy?=
 =?us-ascii?Q?U+jqNznjvjH51WwH9IvdxCA2wGQ2meHTxY/eZXil76hXpvSJZrQRcH20o/Ix?=
 =?us-ascii?Q?+lGB07fEGKNaNkZpdnpHkl9fVxmngRtXMrk2xKys0ldDfhSmsUzUrUYaKwhC?=
 =?us-ascii?Q?BkMe2GhKIlAjIlv9OIFE8mc5vmcvCFmHjK5WpXmPLIowStAOW2LjW99IY7nh?=
 =?us-ascii?Q?WcYEgaaKjb/MRc0Sq/xBEosh1vbHZIQGpwDCeclSsQ88U0jStgK8Ud2tu1Sp?=
 =?us-ascii?Q?umR+q190W5ToUyBAECr9+uPiMh6fTRV2zuWOsuA4KBnYWUNnqmk8ARF+iD+R?=
 =?us-ascii?Q?In18JF7H9YUvHgZIQOWNS5f2WGNObt2GUSbcZSJSSweiBamuBzEpM1X6zpX/?=
 =?us-ascii?Q?Vwe6DNBc16EdKAeFDSa103a9e8V/P8gL4bpcpLu3fNlLyS4JMOf5nEq95ZUb?=
 =?us-ascii?Q?QrsRjYUsyPp77xD6iWND44HxR2somGINJ8WMSAQyx/U/RYlVjkjREKZn9YJI?=
 =?us-ascii?Q?MhgXowhHiDbR9S3IMmrZNVKsUJztlR5/j7mZ4fBjQd/U0GsUdo3huMOVyay8?=
 =?us-ascii?Q?c27bQnolQFZClC3ENYe5GHqp36rtxdl7kO1m8T7+YbbwanXLA/EjHkLF1Dci?=
 =?us-ascii?Q?8U90BrBg/U/i5s+eftFN1Fy0f9V6BoFETE5G3qTNpymlXLUS+YakyKFCStoW?=
 =?us-ascii?Q?rq2C173t3a/wXAYbsRpL/OLjfAZyR2C8PLoxaG1uj2nrIghfdOqRYAYi7MMo?=
X-MS-Exchange-AntiSpam-MessageData-1: cF30SwdS0geASl87m3wAZeJHS+Mr95KiBIk=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f05cff7d-3fbd-4644-32a6-08da493174b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:29:58.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1rwNMVcwHA4yfSJ7VdPxM8+Md+36nYYbCpg211CLDXyzI3Rfkt3GrBFDx+kBMgAVt53EhQizCbJeRTSuZN+mPAJeAIfywaktp/Dv/WSUxgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5575
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Etienne van der Linde <etienne.vanderlinde@corigine.com>

Swap around the GRE and VLAN parts in the flow-key offloaded by
the driver to fit in with other tunnel types and the firmware.
Without this change used cases with GRE+VLAN on the outer header
does not get offloaded as the flow-key mismatches what the
firmware expect.

Fixes: 0d630f58989a ("nfp: flower: add support to offload QinQ match")
Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
Signed-off-by: Etienne van der Linde <etienne.vanderlinde@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 32 +++++++++----------
 .../net/ethernet/netronome/nfp/flower/match.c | 16 +++++-----
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 443a5d6eb57b..7c31a46195b2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -507,6 +507,11 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 		key_size += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
+		map[FLOW_PAY_QINQ] = key_size;
+		key_size += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		map[FLOW_PAY_GRE] = key_size;
 		if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6)
@@ -515,11 +520,6 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 			key_size += sizeof(struct nfp_flower_ipv4_gre_tun);
 	}
 
-	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
-		map[FLOW_PAY_QINQ] = key_size;
-		key_size += sizeof(struct nfp_flower_vlan);
-	}
-
 	if ((in_key_ls.key_layer & NFP_FLOWER_LAYER_VXLAN) ||
 	    (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GENEVE)) {
 		map[FLOW_PAY_UDP_TUN] = key_size;
@@ -758,6 +758,17 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
+		offset = key_map[FLOW_PAY_QINQ];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
+						(struct nfp_flower_vlan *)msk,
+						rules[i]);
+		}
+	}
+
 	if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		offset = key_map[FLOW_PAY_GRE];
 		key = kdata + offset;
@@ -798,17 +809,6 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
-		offset = key_map[FLOW_PAY_QINQ];
-		key = kdata + offset;
-		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
-			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
-						(struct nfp_flower_vlan *)msk,
-						rules[i]);
-		}
-	}
-
 	if (key_layer.key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_layer.key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		offset = key_map[FLOW_PAY_UDP_TUN];
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 193a167a6762..e01430139b6d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -625,6 +625,14 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
+		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
+					(struct nfp_flower_vlan *)msk,
+					rule);
+		ext += sizeof(struct nfp_flower_vlan);
+		msk += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
 			struct nfp_flower_ipv6_gre_tun *gre_match;
@@ -660,14 +668,6 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
-		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
-					(struct nfp_flower_vlan *)msk,
-					rule);
-		ext += sizeof(struct nfp_flower_vlan);
-		msk += sizeof(struct nfp_flower_vlan);
-	}
-
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
-- 
2.30.2

