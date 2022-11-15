Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CBB628F20
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiKOBTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKOBTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:02 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6FC13DD6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePq0TtBnJc8GUs05IdLHyJiXSCvQhbDIgugz1r+lCPRWbAjG9PXmxR6b71HokfX0l8jnHyLq4a5EGUM/c3jUPWsk2g3DWLMCCtQLQpU/7BBiPQxnhmfu0+mkSC9ChPoubA6T2Zs0gEAcDJHCYHnIPXdnspHHNP9/UClLNwX0/1z1z/e7G2ULWla8wqHaitNSrje4IpY+7tD3Sn4GY/UrCnPyFPVCv+WiNYbYsfeymSA+yY7uN1SYO1BS89AmJhK4WdEe5878QwWeM+WYBY6H32QZt8b6Q6NTMY3Txn4c3/jA1TWyGcbhCaeJUmXJmDF8ieMASDm4Qewnx6lGEp+guQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1v/2rCKfo2bc8jqIB5EsNRR4IMToUZrDkyWnobfWKw=;
 b=T4r/yLgxfoYGWsE+5Sp4PMfWy/+peXhJ6oAplEu4jaRqZzaObhSDreqyKbZ7pT9g/FYMcNcdC6fwUr4mYgzYICJ9j4WcJjbuEpvzSDWfjMhJ+hdVSakuIAZR2e7Rbyoz2ZKCEr1p5O+0GAh8SeI7OnW3tVtG4gjxt9Xhd95DwyOq/k8ks+qUTjAey/cusN13SXej1PfVnII7b2GC/q2U0vezuqWGXuGkXrd98sLJsZxR8eTQh9bxPug4GCUyT5dAFF9b9fnPflnRemrnvTOis8CPsG5zvJ26imzQPRbDc30jZSy+21a6LO71Uvbcj1Zz7orjW05OTer3/kn1GZC17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1v/2rCKfo2bc8jqIB5EsNRR4IMToUZrDkyWnobfWKw=;
 b=OyyGewcI6vvtElnEwHwsyd2thlELRN5HKnFtNbbfByRRjyWsTX4kIr1CwlqynRTDsZxLUYhWoJXFM1amf3Qt7hPXB9h9yhmMKjmltVoe6TMm6GWADbZyC30OhbbnmmqZvoE8OXdi3WZL/utxDiWBXGtAntUIZCTH8uvO9zb6XiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:18:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:18:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 net-next 2/6] net: dsa: rename tagging protocol driver modalias
Date:   Tue, 15 Nov 2022 03:18:43 +0200
Message-Id: <20221115011847.2843127-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a33188-cf21-4a67-7c9e-08dac6a75f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znFDlz7VJux8ZgWZR717KfQBY5Tm6g1Ow8nKq58Q2BkT6BWwsJ1kcOPmIVFU3B8H6nABqIHU0O1qndgB8wiyZPvP+w+GN/0YcoFCDxd/2zhYBDif+p2yOXUFyjsoJVir+RUWPnCHtZGAgKZPaZr/YQ8j/baGXBWac0PEXCmo9PPHNg6S8lrTmTTGyn3adzqlGF2vLuBT6+owyPjmDiQhladRx4bHaRkfnqfYpyDzU15sv1CnARyJa8bxvmCQxrKMdqpZ8DVDuwvpm4yQKkhKKjA6vfvKUY7C+MqI4HJ4txcy5JzErJBtMOodrDsaFUKck4yIRmKNGMkm2ALwPzFmMtN4aGhgUSXLzeRqM+vFtOYNZZ8pRc1+g/EQR5TQ++KeK/VLbe3ebPDrwdchZBWppssuKueg8K8g1cKmau+C32e2n0wAjh5M1gP76qKgB1DnXmXpno7PrBTUVasxZGz0d2aSWEc5TusU5tuiazu/H3rBKGQESJLEdiPGhSgeFhvS/R1rTES6qehVHc5giA8i8EopYzPQog5QiASN6/eglBvXUkG57xZdQOhAG2IMDVFeenaLvYDk6I7SHUbb1g5nXdKPjEOddLi6RoFINj13nPFroc8ZR01uweUFTbOZFsay1/Zsn1sJUUFgKBY2PuRrsuHT0/MB8Ia9p0gjY6BJG80le/6RbXUN+bNNI9mAdDMTizc2ck8T4Ys7pb2tlg/TUhf46/rQwIj8IW+C3RUwh1WJmzCXl97Jf2EKSkI3xJEmh4fmrMxwtxtbPq/Yckom6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uStRGjaI0AbxYejKdua9Dp8q52WP/sp+ZwwGNLpDn4EfNxH7eTdZHG0q0o9D?=
 =?us-ascii?Q?gdsbnvwgxGvtbqWOXN/Mfz88PNoBFKbKjmh0kZrAYq+Q3QXerLOL6Trlwgai?=
 =?us-ascii?Q?VMyGu/hEfQWGoGZBVKR8OyPLs3flTpi2CX1UhheZSxv/Ncy5zzhdf9T9SbDe?=
 =?us-ascii?Q?GwMAsC5RlqyNSQrrM5cZslPlrXWLyPO7UsjTjgnuVtDbfZhI1SoMrz30OBzi?=
 =?us-ascii?Q?ybPDTs+M44MIUmysQXqE+OCc44lggnWH07sTb6MLg5lsCe65x3ZjZNyA8OBa?=
 =?us-ascii?Q?uS9oeFds1jeSV7NAWYahD4QuX57JHHzwFaQIRLhwoQmx+5N2BfdYR8OkJkUx?=
 =?us-ascii?Q?NhCF0QnXrUhYfS6ZTAmq4solVMzjNzQx2EKYBo5kfFg2g5HI8vbw2HCu7kZy?=
 =?us-ascii?Q?nbVbtP4cW/7pRxNpP1OirgBYX7fYCJxOSi8BXq6428JXhLBvZxxnFJkC5jYi?=
 =?us-ascii?Q?yL0cf5KuvalAIzSENrdjbBzUWF03RH5I8uQnAiqWJb2z1cayTXm0DtX5VqtY?=
 =?us-ascii?Q?oyYGjTeD4Uk8VhSm+BiZc7LguNHegV2CSi8jEVOm5AiKvFsEoyJwE5B1h3AV?=
 =?us-ascii?Q?lsJ82n5aB/CgepGA2Q70ookcOn3mk1Eexz1owN9opHalN+d50EQKz8dwlhV6?=
 =?us-ascii?Q?2EIiiiIH4deygcGGQN7mac8J3QVMFpsuULA5VbblCgwWho7Vqsdg8iYYzAih?=
 =?us-ascii?Q?nzqH2kLxuu5k0focQOWSVOzkp/WQqkRxPkWElg4YaiJlQfHf/In9La2yDmAN?=
 =?us-ascii?Q?9DNcB1J1jG3DCO/yuYS5KH97TRua6zL2YrvBAywy/YhCLKjBycXnHDnQs+xU?=
 =?us-ascii?Q?K4Kae0tPh4aUH2kxS7puTxOrNsZa4tohuOgVMMta2mzhkYWlBQ7caLDRUxUW?=
 =?us-ascii?Q?qdR7QMMyDFfzq02zPCPP39B1aI87lwYACOHYf8aUf+Jlb/FMeHgYhKfXxRJC?=
 =?us-ascii?Q?gX1wKth72cn33yQ2v2T85twlxeMhquGIkjvwqYdQ8eI8u7G0Q+BDW4ejA6CR?=
 =?us-ascii?Q?11RyG0Zq7/EsZ+T9lXqdH6Ci9NSOsMbo0HV0wxzshOwn2EpO0DVFU4n5qXaB?=
 =?us-ascii?Q?jToTiId10P3LclV3hD/8b5mAwbAXVbrb0a6/o+jXVA94Ov+A0pfoiukNhHyt?=
 =?us-ascii?Q?A+2oYkl4Wpc0fFO6SWZP8tIMjCkYn8OLlret5itrc7FgFiQkRg2vcnSBMnQc?=
 =?us-ascii?Q?4Q50+vFpDPKV9suieXEdNwJ+hGitSUqbtErzzQ7Qz5dx6EUEdVPIyPiZdulf?=
 =?us-ascii?Q?7ctOIRsdEO1NGLZ/NwLCCwzFai7eEPKri/rmfNOgw4eCIqbkCcqkkIXd6dB2?=
 =?us-ascii?Q?cTwczzKG9MB+E7DUNDIKYWs5IDIaoLYvZb80llszlBJYnFYvIJT+EOEJEd1e?=
 =?us-ascii?Q?ZDLGOAjvWGKoEHvNNns0AJSk1fpzP8OylINW7mv8gGUo6bppCpw20Bk1d4CU?=
 =?us-ascii?Q?XI2LRuQInZEHnff8Y+c+t+N2CmC2GkoYNHFTEzLqorendCiJSPkiraEOR8Ry?=
 =?us-ascii?Q?VHJpI4hIg1f7aFVQhhixbVegBy06H6cLgSZRUfVhDA+YUraDwgRqv8p8f9mG?=
 =?us-ascii?Q?FQ+SxHQWrU4Y+NGlYmI5/UlINBJF60zSBEbopu7qZebXmpPDmHELv38LQoF2?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a33188-cf21-4a67-7c9e-08dac6a75f96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:18:59.4382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUC8LawTLCmN5KQhMayqANsBjggQ+SI7vPqg5WjLpBDkDSZOxKEI7R5zYLAE7mZd/NG5JWDy44ld8xCwcR4xWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's autumn cleanup time, and today's target are modaliases.

Michael says that for users of modinfo, "dsa_tag-20" is not the most
suggestive name, and recommends a change to "dsa_tag-id-20".

Andrew points out that other modaliases have a prefix delimited by
colons, so he recommends "dsa_tag:20" instead of "dsa_tag-20".

To satisfy both proposals, Florian recommends "dsa_tag:id-20".

The modaliases are not stable ABI, and the essential information
(protocol ID) is still conveyed in the new string, which
request_module() must be adapted to form.

Link: 20221027210830.3577793-1-vladimir.oltean@nxp.com
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Michael Walle <michael@walle.cc>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/dsa.c      | 2 +-
 net/dsa/dsa_priv.h | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 64b14f655b23..38c64cc5c0d2 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -107,7 +107,7 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol)
 	const struct dsa_device_ops *ops;
 	bool found = false;
 
-	request_module("%s%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
+	request_module("%sid-%d", DSA_TAG_DRIVER_ALIAS, tag_protocol);
 
 	mutex_lock(&dsa_tag_drivers_lock);
 	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a7f1c2ca1089..9b635dddad3f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -17,9 +17,10 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
-#define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
-#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
-	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
+#define DSA_TAG_DRIVER_ALIAS "dsa_tag:"
+#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto) \
+	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS "id-" \
+		     __stringify(__proto##_VALUE))
 
 struct dsa_tag_driver {
 	const struct dsa_device_ops *ops;
-- 
2.34.1

