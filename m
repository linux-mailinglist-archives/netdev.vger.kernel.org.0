Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4B45236DA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiEKPOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiEKPOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:48 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B97EAD09
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuTYeOpV80aghUcNno7OLsDfLOnTRiNS9xEyq8y4FpL5+G6x1tamTKxvRcdCly3z+Be/Zyt1D06jfFtG8zY2QOQaaS2QFDJMgqqx7560g2IeXNVGDNcbjRzjDWhNIelqt5naYHe2g4XhXtaohoWkS50pgp0A4C8zeiU9KQiqO5eo4/f1LtrFSDz2wFZKWOetPAYflM/Bl+jGiHdrhfZD04vCRObEtSgX4jxNFXvB/c1Ow4ysshC+vhxxQdxzAle9ZaYxE0uBkYmvSY52XY5I36v1VxHX2rp2RB0YwhirlEHskrrrFJhodrYFIdRQDKO7jS2WcgBUA29VhielubPnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xx71UODi9zpqdmr6FaDbNEMl6N+JWSrcJxHsKZnHJ68=;
 b=XemXESvz1KA/9SuC+9EER87zLTukpiDjlmWZra1NtQriuJ22TRW3EWOOhipflkomukNVc8yZOIXQRkMBDk/mOPBV4UUum20DRkmMJxB3WIf6SZVLagXTqmu9wb8fX4wxYEtsZxODk/H/r+Qz8poW5Ybkk/hIYx0qU3Of7aNsqflE3XbmvHE4eSNGXJjSpgwa+rzEhhiY4kbROcWEFcS7/k3RRH8bNjM62/i1e74A10LwPtJZoT90c3e9BW154GcixvhbCeaGD3ycOmhjxNSjkWfQXOg8LJN1Z/93J8zAF1rVi1AFNwnO5+dsUDmrWVIexrCJ8clZUDkcAZ2NPWdQhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx71UODi9zpqdmr6FaDbNEMl6N+JWSrcJxHsKZnHJ68=;
 b=NbkKYIlBlLUpKbB1BUKz0DxqcKJPoe89uwsa8g9B73A+KlqbzlTCoofWTjswv1xl38+mg1jHVfuWCqkuUwnpxjxuf/2o7TB6sFRGokDG+JqytLIEIfYasESB1vZEoeBszCM0tsQgNDw8UYlAOWc1GjXpdjOY3cDsx/PuHD1XlSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2300.eurprd04.prod.outlook.com (2603:10a6:3:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:14:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/5] net: dsa: tag_rtl4_a: __skb_put_padto() can never fail
Date:   Wed, 11 May 2022 18:14:27 +0300
Message-Id: <20220511151431.780120-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8df2b8b6-f6d6-403e-4b37-08da3360fa82
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2300:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB2300AA096AAD6EF62A42481BE0C89@HE1PR0401MB2300.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvchrwopEt+X1oWYwXtr341K4dAOupGSNSBPSMNR2u1aIItG56MAgz+5qWsrMtVh3fgjGCO34F9lmMLzFhE9wQmXEGJKPkr/jZkqSnW6VKTii4Orv57whqy1+XL7HQJcCcOMKZNqm428myKzAr7Cah8Lam6XrU9VebQDwSev3OKa4fbzAjg1XBSmlkZDl4nDwawGxYQbHPL0zdjiE0zw1cJWEaMfHk7b2+kpNogoAZ+qDQN3vt+SSTq7vQyzRhmX9UAIf66lI1Vg0mCcR6Y621GVOoaGtzSZ8AZ1eg5fB3huOpTMlMerrKFUItb7cQ8gm8F5UzDa6gVuOTxiFSnxlq4Li7zWPeQdjUjWuwEW1+C6DcxaQDXYIrC9WBF3Y2hc+omwYlptdiN+wKXqwYr4thQVwAW0n3H/7my/xp6ioyuDqylqP8BUtulDZRXEK8Dq4MLV7XfvwqtNUoQprhVgBLOIgKR3vpziRLTKPqBVJlaCtPuyDtGxblYxeKu6I15koAn/F3/l6oE6nlgKah3/VW2STg4pFnpa/Imc2FvMudBDk918ndE/eeLjfTBWAO7dTVbVJePVYXgcHBXfy/6NiHix8my8jgtMhw9nyiv+2wzB2KxmHap1UsQt7VFc3ARReO84oLQhccFHzCR9sHvq8rS9pkneAl7yL6HFb4bC8G3b3ZMPB/LP7zNI7LKCP1bA1zqkIEGmZwbhSRVvQTheIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6916009)(26005)(6512007)(316002)(38350700002)(2906002)(54906003)(83380400001)(508600001)(8936002)(8676002)(5660300002)(7416002)(38100700002)(186003)(6486002)(86362001)(2616005)(66556008)(36756003)(1076003)(6506007)(66946007)(6666004)(66476007)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?so3xtahNh7EohhXWVVoGbTysM0JKpj9nczXJK82rbLiPwGBI0YypGpSdlwhY?=
 =?us-ascii?Q?cyVtGNek1PCqV3lEIpU0qEK8u5KIrxpEhVIYCXy5R53Tv9IPANwQeOVxAYqa?=
 =?us-ascii?Q?64GVS5cDO+su9nikN0kIzeuG7K62cFFzh/XYyjg6xpOBMMxaBXIly2VIz2iQ?=
 =?us-ascii?Q?f2Vg82yeb0OmBvcUAX+a8WQKubmyMk9TbIQAhvKGo58v3Xu9tt76ti5LaojU?=
 =?us-ascii?Q?lnjvx5kZ99zJc1ExM6cO3XkWCoOvvjMHoAxJwoe2X7/9E0REOGHO846pm0e/?=
 =?us-ascii?Q?xqih8+wv4RixQmfX0yEqVzIqZV7opbCShlh5U/6XvlVoVRvGYhDiMJLI9F4b?=
 =?us-ascii?Q?hWf+coeiHSbwyWSAFYc2X65KE98eEnaj8C30s/7WkHM0bnibFA4pOBoJIMJa?=
 =?us-ascii?Q?RDSoXjkTcShSkDZ8GPdoHWFuRoA5Fj+UqUQbhyS3yzkzLW3L+gPXSDzO1gHM?=
 =?us-ascii?Q?WYMPkhZtWPyybc1sw3kjH82nEzafP7QTlgRhwuw0Li6ed1xxDw6t7QakCmV0?=
 =?us-ascii?Q?Br56iirYHw5GyugEh0+ty2f2JmeJrIYWo98uDEzQ5ApEhpziI8BV+dnsn9V5?=
 =?us-ascii?Q?clB9KUBDr7vBaGGnvjEWg6RYGP6b7UcHeJO5uI4otfv1Su2vQVNpf9npewbP?=
 =?us-ascii?Q?xsZoJIa0Fcb/X26Mq8bfBqLp2Vw0h3unyiSLU+qcShpCXdZ1ktywmCsAsXyw?=
 =?us-ascii?Q?JoWF7+O6Q28IVNqXDGhZxzpOqyHRyRfkPcv9jU7HdQ9GDZR1KDUrc0+hp8M3?=
 =?us-ascii?Q?GucUCW9Qo0vGK4JeAzRK2NHIL5B9s5H/nzqiss8PkyXvjOj37O3yPROropS3?=
 =?us-ascii?Q?ybE9X1+nxBUOSacZLTJva6Z496uI1xTTO9cmEoBAdm09sX8xnOUsbMnIEP6B?=
 =?us-ascii?Q?G+CV0P76E90eLJAgAuBpUB0HlV36cCLX52vVxhWm+FDoxiEjuVdklPpbQ02f?=
 =?us-ascii?Q?i1pThMiDaMHFFjUJZzT0w3ipzvfJMjUV6ftVLUbckWwnRyC4EOQ5BmV/phZp?=
 =?us-ascii?Q?fOoJJM4oD+JHCS2JrUbhkgzWspMgOd5Xuy6qlqGlhrCrQDkXYaYd7PvkdJ9L?=
 =?us-ascii?Q?ZEcyb/i17D8hZ7F89MxcqZDQFmxFaRihncikg6qnAhVy94Qh0QrVz9GuWGO8?=
 =?us-ascii?Q?K2JSpHuWTLz1aKhmFpi7ukTNDoC/Mv0UljK+viguE5sxxKii1LeuEc3+5Ocz?=
 =?us-ascii?Q?ZOSmLTy7rNtLwLpbTE7FpC//ryRqcm7HLCjUjA74S51BvZnIvLTGAq5HPFwX?=
 =?us-ascii?Q?a825pZ00yDjgB7bjCWvaXBHBz4rJhHbcwJgunFx41TKj2P7kekHKcqpm/0DV?=
 =?us-ascii?Q?Q6eeIxjamwS1zIhI0fhSsJyit/mQE38yel1+mfXisxrsaHw4eAYJQSI1JM7B?=
 =?us-ascii?Q?2PW48NmL4OSjdY2N+TlZzNIKIB+tHJx1UgG9OhsXTvrP1+vogZN6LHWmiKaI?=
 =?us-ascii?Q?OPsC3XdWzyowiw630waVqAyJE9x0CbncJsb8tWsZq6I0YbBN3O9TCu77KV+E?=
 =?us-ascii?Q?IIbkLFPgVQfuYmIumKy1P42+TLdLZe3XNedQBQGowzbBWSa8REJzOLDJWFJH?=
 =?us-ascii?Q?6ea47VdHmFlJIX2OEObJpmLRVV8BWp3GycRgl2cKbbq/IKdBxdNIR4/U6Rft?=
 =?us-ascii?Q?CkgVwP+Hp0vNmH9J/TUGjEY7T0XkDTLowxmm0IvbOZ/StdEYgBg6oEiDRU/e?=
 =?us-ascii?Q?H5/u0JAd6/9CoVWT0NZoEAWslauC746XPYRDMTj+NCg4Tw3etW6DyqgnfQUR?=
 =?us-ascii?Q?BNs0vcQVAbCWPX7l1iG1yQhJuCFre3k=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df2b8b6-f6d6-403e-4b37-08da3360fa82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:44.1097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22X7wRjjvN5T4kshO+n8qZCNt/2eweZV5PXfJMNXmo/7d2Lg99ejDcymR87AvsW1ZU9Euwc6TiSEm7OT5p0Thg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2300
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the purposes of the central dsa_realloc_skb() is to ensure that
the skb has a geometry which does not need to be adjusted by tagging
protocol drivers for most cases. This includes making sure that the skb
is not cloned (otherwise pskb_expand_head() is called).

So there is no reason why __skb_put_padto() is going to return an error,
otherwise it would have returned the error in dsa_realloc_skb().

Use the simple eth_skb_pad() which passes "true" to "free_on_error"
(which does not matter) and save a conditional in the TX data path.
With this, also remove the uninformative comment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_rtl4_a.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 6d928ee3ef7a..e71d011ce4cc 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -39,9 +39,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	u8 *tag;
 	u16 out;
 
-	/* Pad out to at least 60 bytes */
-	if (unlikely(__skb_put_padto(skb, ETH_ZLEN, false)))
-		return NULL;
+	eth_skb_pad(skb);
 
 	netdev_dbg(dev, "add realtek tag to package to port %d\n",
 		   dp->index);
-- 
2.25.1

