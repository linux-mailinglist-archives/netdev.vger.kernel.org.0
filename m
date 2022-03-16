Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED144DB8D2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbiCPTYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358060AbiCPTYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:24:22 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10072.outbound.protection.outlook.com [40.107.1.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10BE6F49C
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 12:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heyTlAhFKRAHwc8NLYHMQyTXy68mojXNpzYDo6RWv01oZsAphORWiHZgX5X1IzmbBfd2T+/t5QpdiozUp5vjkC0gIQXAtlURA8TMzIQ/M48d1lYXELVnIt/An4qxIhDAwmkrmyWRc6qLX5qpcmm6gB96+T9zZunf+OQWTIjkPn4Hlruzfptbf2t26yFsH8I65JQjt1tI0fnfMryD8z0aBxzaQu3+KDrhEOqpy+7SEoxrtHrn2N/P527FEbRXq3q43KTlKlkTRinGHwyWixjJRvAn13pnWF8s4BsPmS5I75mMVC622OgryXFKC2pD9kLejXmqWvooAwBNTDQD8whkbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtyaCA/QIiRWtVEgs+Lxg8w5iIWWULkyM7HKzMdMSzA=;
 b=bvryIuj2LVsvFxJk3RuAiPT9MW/LTLwFJXwTSLanZB9JSxD1Pyq+HusdpJ38VIW45GnsSMJfbL05CqsTwfTTfB4JJnSM8W6MKwdYE08c0UH1M4PfGCvXlzgdjyp+iBw34imZXf/X0vVRnp3dMb8iuVNi2a8DfMLWp7Em9WV1KNdFslD3lmRs5+3nobZyxax1VYvqQdMjgXIYCJ69OOvj0ktDiNaNXOjZJXAR/SEEjWzRywB/SQg0jBwXtID47fEGVQ0pAX0QuEuvRdsV9R6w96LfpWXNcHMK2TvOB1Tdtn0AyMB7YS/YIZ7QDyHwfWvAZXV2d3QH0dqttQf2wA0ZOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtyaCA/QIiRWtVEgs+Lxg8w5iIWWULkyM7HKzMdMSzA=;
 b=dRf1b/kyEmAfOG8q7GLog88eilzHDgL6oON1PSomG4PyZJL2Mdjt0zmgIGq9yfsUz0w7LjXmppCpkfvIGr13dz66AxQ9+tD+KqUqqpDc7GM2sUHz3GSYSawAI+dePh8Rs7WYY3vV+mGwr8aNu5pIrfy/LNQgxN8lWSTRCeP7dzU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9194.eurprd04.prod.outlook.com (2603:10a6:10:2f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 19:21:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.029; Wed, 16 Mar 2022
 19:21:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload
Date:   Wed, 16 Mar 2022 21:21:17 +0200
Message-Id: <20220316192117.2568261-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0023.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cda8096-2dcf-4760-b411-08da07822aca
X-MS-TrafficTypeDiagnostic: DU2PR04MB9194:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB9194CA973DB3245582C37E42E0119@DU2PR04MB9194.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzdnwlZwCmH34REhCB9SuuxoL5Za54iI7Q/3VGMnDcZWNHQXtN6wVee3vVoXEZ81uzqYbBQX/cll9I3qb+qoLOOZN0dO0ZCADuVqGqkboEM4nYRRdcETzXoslKkAFl2BfLDwv66KElzcHEOtBC/ihUxUwMmxsjtSAH421Oiaf3K1eOPC6s5c8pYkJbylQE+twEWZe8VpyR+c1kRbiiBoevzNbbXBGnOeqUBmj5h6mhKhPjxYtNzPAEt/6Mym4a4f64vH9WLr++FHlAFSvC9wWG+N1AEP3CMA4HWzO3ykZYysUdDTawbPNTYt36BEsNJho+qorQpyEM0DsvWQnmRx44fbGbFjEPJ/Um5nC+hKmLd6nGY+284P0zLcJMybKtn6VNiguF9i/LjwJu5bvP2sQYDFum3WMsqAgw5kyfUEibkaw2kVOHCrValbSaTlt/HCl5Oj8FbLYVOHDKue5jnX1nVyAjw53YdM9wHq4A5XdIYvpNrg0YlSkq/t+po+IKhYMI1yjH5Ny9aW96fxVx8+JT3v8hwQz9/gL99IlaoaXlm09pZt9544fXUAc86jyMcQdsj1DfGbHNDOtvVbCinVrZE0PTHLOsN4YDcZ5405ICNRo3TUAwA3ar8uRYDF8Iuz2+kdFer1fduNMetKBI7AbpsBnGqF69AShUOf/zorN1iQjxb2W9nkkhX+Bde1csAYWuk1a4TUkuSD7jZW110MIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(2906002)(5660300002)(8936002)(66476007)(8676002)(66556008)(4326008)(66946007)(38100700002)(86362001)(38350700002)(6666004)(6512007)(508600001)(26005)(2616005)(186003)(1076003)(316002)(83380400001)(6486002)(54906003)(36756003)(6916009)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mnFgIpKESvZ7GXqjrS0SikwtzPachV2V1dnXPnMouFqRZg1WLv8fY85HqJnA?=
 =?us-ascii?Q?P/Tp+jc5kN13fJsaq1TG8Zr3HSU6IcOU62PgoVsUIjlDmcLHlH96kq5IMYf1?=
 =?us-ascii?Q?3DD+BLUfNTqxZMuJ6Kh3DcWqHpg5IrVBp4NZ5SxKFW2lDgxHutuFiplhTj1D?=
 =?us-ascii?Q?+Y0+U8pFd23CYA5j05ZeXkLxz+gNEj9pOgPPILXa1QEYq5SDlmavtVYFP05b?=
 =?us-ascii?Q?AmUDmfZh31KlTR5JAplm331Wb4okm5cZDU4/pyp2sCV03yj77eZfz/zzW/TF?=
 =?us-ascii?Q?nhRmbh/T7Ari2R+2xcy/gscXaNcXOjx6zawlkfueFHWkM0P60iTv3YY6k2+p?=
 =?us-ascii?Q?4hzzyxtbx9la9uF07LjWBaH19cwzqHunxJs7TqmU6xesPLEA3+lve8ALCweJ?=
 =?us-ascii?Q?WS6surIxyAdJBPm25UWdcYNjzi0x4Iw81aQS1uSasSe4+zw9os2g3+zNCNEf?=
 =?us-ascii?Q?Vjd0j/TZNiGq5ocq58InyzTA+rwG74blHwCCJBJ70OZzwsvnKyYfXkpI5Vc1?=
 =?us-ascii?Q?a/J4jaUljs7V+ZtjkcWm0rBod36za9EiHbdjMSoEVcRKJv91gU+OjLMZKNfg?=
 =?us-ascii?Q?seRMboed8JogzInYT3yJ14DV6uKwmvD32uB3GRz1RRDJVoH3FxNlU/40z3G3?=
 =?us-ascii?Q?Ds2nRR+PfgJXlt2QqQCGlOtVtNf/o/FWeXX42cV5c/F1H9vrHrjKfmgaCvrx?=
 =?us-ascii?Q?RETqG6EPd39Xm7CzI4GoawTOeDvgjxz5lxKBY1z1S3wS1l3iA/zXl0WpvDiN?=
 =?us-ascii?Q?do0V2rRPw9SiJc7orQL55ShSPpRFKn9POF0mDgILT/Rz06S8vqrIj7oMtqxn?=
 =?us-ascii?Q?ieeHm86bpJfxfRFVHjLD9D9B18oVTW45YqdKRNozZk65ISkRTwUBguNuQ9zN?=
 =?us-ascii?Q?1MJWijYRG73AZFu1quqFnMvu6V6j8h4+rxUpyvqE9ANvv1Jp3z+gqD9zrQ2s?=
 =?us-ascii?Q?49BIhg2VxLB9vdezm2m3DBYhD166UYQiqm4HkQF6oeMJD/Sh0o6eMdwM0QTX?=
 =?us-ascii?Q?tVNTm4fZJYaHryVIfv7UCvtPkxjfSXRPY7wrQj0qmnOVuRIjsauBIVIsrzPH?=
 =?us-ascii?Q?aCAnPiq/k2Bk7KvfJdZFR8agf0xHOlACNgis/au9UVP8YTZ+Daqua01ZLkMx?=
 =?us-ascii?Q?Xo/SfJMOWEb7c5Wdanr5jgKVV7ztOXcW2iPPXHC2fYJyveZTEsdDtKomemhv?=
 =?us-ascii?Q?kTJNiju8F6eHkC6+H3ya48ru7hlHaKw7QWwN2MkXwpeKHvdNU49JYHbFyuI6?=
 =?us-ascii?Q?3F3LRfilQhz7fh9zmvneWIYJNdlSbllhB3xAFQoceqHWQyaFRS1guMFmajT3?=
 =?us-ascii?Q?dSxT8U78lhttBpvtHvCWBfGiXLeqFLK+0GNLSNh/tN20IbN3P1omtSRATzio?=
 =?us-ascii?Q?0hqS972/3vqUF3JHg5EzD8dutusF2iYE5PjEBoNox5qWHJQru4VAC5+0UG+r?=
 =?us-ascii?Q?chCUoadEFJY1iM8iP2rU9WMuKiV30K1Qhi6NNdrlU1B7R7BGblTHZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cda8096-2dcf-4760-b411-08da07822aca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 19:21:27.3760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZT/fdIhFIWVizIWTPPW9qOwqcqmTpe74tPYK6rWUjsTsEzC/RjSIgdEvm+7NaRnaNnk8zG0A63fvg5GoF81XCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9194
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACL rules can be offloaded to VCAP IS2 either through chain 0, or, since
the blamed commit, through a chain index whose number encodes a specific
PAG (Policy Action Group) and lookup number.

The chain number is translated through ocelot_chain_to_pag() into a PAG,
and through ocelot_chain_to_lookup() into a lookup number.

The problem with the blamed commit is that the above 2 functions don't
have special treatment for chain 0. So ocelot_chain_to_pag(0) returns
filter->pag = 224, which is in fact -32, but the "pag" field is an u8.

So we end up programming the hardware with VCAP IS2 entries having a PAG
of 224. But the way in which the PAG works is that it defines a subset
of VCAP IS2 filters which should match on a packet. The default PAG is
0, and previous VCAP IS1 rules (which we offload using 'goto') can
modify it. So basically, we are installing filters with a PAG on which
no packet will ever match. This is the hardware equivalent of adding
filters to a chain which has no 'goto' to it.

Restore the previous functionality by making ACL filters offloaded to
chain 0 go to PAG 0 and lookup number 0. The choice of PAG is clearly
correct, but the choice of lookup number isn't "as before" (which was to
leave the lookup a "don't care"). However, lookup 0 should be fine,
since even though there are ACL actions (policers) which have a
requirement to be used in a specific lookup, that lookup is 0.

Fixes: 226e9cd82a96 ("net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index cc74d20634e5..03b5e59d033e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -61,6 +61,12 @@ static int ocelot_chain_to_block(int chain, bool ingress)
  */
 static int ocelot_chain_to_lookup(int chain)
 {
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
 	return (chain / VCAP_LOOKUP) % 10;
 }
 
@@ -69,7 +75,15 @@ static int ocelot_chain_to_lookup(int chain)
  */
 static int ocelot_chain_to_pag(int chain)
 {
-	int lookup = ocelot_chain_to_lookup(chain);
+	int lookup;
+
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
+	lookup = ocelot_chain_to_lookup(chain);
 
 	/* calculate PAG value as chain index relative to the first PAG */
 	return chain - VCAP_IS2_CHAIN(lookup, 0);
-- 
2.25.1

