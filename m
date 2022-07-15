Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6B7576442
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiGOPRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGOPRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:17:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1A17D1D9
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfNLlYel4jeB1Parc2lTcxumpQB1jBEgI0qEy+SIma+oJyr8ultZBIsKbstkJ8VAC7Bxv/Aom/wE2ZP02R2h3ohwXJMpZCgGTV0C6tUfh+fsnvM2cI5b79hoFSMaSePO4eeKmVVO0I94o1qqh391LybQTllWUvFLzcwhZNKLAB3szTJ50Z6FetwqftWAnIVd/bWiVcMOSs9Neq2GBNkEcuv1re2LNXG+oCMMpn97t/5oFfUXMORLTVihsEEMxhk/NtmSq7MCbcQOZvkFfgapAZjcyLIqwjX5vtSrkPAMiMbeelV3N9lYAFvKX45wbcD34+Fsuf7qh7xj//bZzNEJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzUxL95M7Bi8vMg6cwLIxneV7vroYa7s4NKanyAuh4Y=;
 b=FFcKJvltgt5/j+mV4cIyrR59QjGZU9DDDhjTjypVjZaDnUxH3euYXh78TfDS43iEhsHGlYQ5q2vN1X8WFli8LB46QdKoxQvAYkDZnmC0pd7Y/sE74I7sotHFh2fBbmgu4r+qPQVGf6NG8LXLMoVjJPFd3EWOf24n9cEi/d8wNeVLgyG/ShdP6EmDXAJcJCE5dtXTcPgeIYbPwJVFrmZFAWe5/xAqYU+Xs/O8d9RfmdBKGM3aeXcZ1TgBHBNw0zKyaNc5HKKNkaSG8i180ZUjwJdv82gToUCCBWRw3VtFnYosgBk+dve4k0AO9dhUM1ETENqqZz7hEgdU/lxdO9vkaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzUxL95M7Bi8vMg6cwLIxneV7vroYa7s4NKanyAuh4Y=;
 b=D5IREX8UOj/aylRiCIaPPCWEmGFBSxoWHo8ON7mDCpRXxyn/zp0rrjZtmU8/ic/t/nu7qSSGOGs7uvxPt73tdzi5m1umhPwRQU7pJQbsb56i4jcKW5r4f41TQsvrRCklxebDt6OLjnF1q65x/KWHANsoS3aLydP9n9Y0swGd5xI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4192.eurprd04.prod.outlook.com (2603:10a6:803:4c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 15:17:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 15:17:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lucian Banu <Lucian.Banu@westermo.com>
Subject: [PATCH net 1/2] net: dsa: fix dsa_port_vlan_filtering when global
Date:   Fri, 15 Jul 2022 18:16:58 +0300
Message-Id: <20220715151659.780544-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220715151659.780544-1-vladimir.oltean@nxp.com>
References: <20220715151659.780544-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54fc15f0-e389-418b-aaa9-08da667517fc
X-MS-TrafficTypeDiagnostic: VI1PR04MB4192:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5i+xwGqCBUOrAYtReJf0lgPHcGEaIb9BFk4V3TA6ctrwMXvjoxd4zvPnu69VBgvpWjOO2BTEYKdBYdaPMCuhF8QbL8bXP/Czix2FsAo9MiXr0qvJHYNKl2A838a09mSoAQHyfVaS/SraIQ7Ytzn80hfz3OUU6FW3i4rFjFcibzeYHZ0Pf6K6dIvs9JJHPZ9HGN3tYGyOAZIyZSaoCV1JeR6zZC7a2DyDaSvtCGPEwTfr+ifWI9HCpwuXMjrhaJ3F25FwvPeRCHNZBrPaEeRyr1gxokB4c1wld5hfL8lJi5ZepnXKCSPWvC3IooI9uALzkyyEKWzPblIV3M683bJbczhRLtn/FF56uq/8+t13C9H+LyOuC7OMLB5o6X46V3zZ1y1XgpG9fKJsPFeH8YyMAwsBXzZEZEndSX1pRoDEiarneZ0ckyJQIe06849025jt/eXEC5KFJKbSCS4xOTJvnBO327SD1Ij41aeS3qMiZrwzNEgMO3wA5nRva+bstKbAaS8AnN8h0Fi+E/99tlu9OKYg4ZzYEorN6aiU9Dgs9fKK19FBoo256Wc/ugKKalbeN1HyWAPtNAZBqFwehxLBsqTEo/gdwhakHrwn5BBY7LlN7K1YUt5paJGAklNE0EqU4IJfkEJWq1Il2fLYfwmQwpgZJUUYsEB0aOWu3te/Mmqqs3CxeG11uWLWj7/ZVAVROjeNULGLM7hdiMB+hKz178MwE5nqhKGYLyl/ExP27CwFTO2SBaL5WfcoYm/EGVL4Ud4Y783c+VkBpyFdlqZYV/nRBMdEpLpwG2Bh2IeEFWKpKwMCs2QpvcJx0ju8hSb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(478600001)(52116002)(6506007)(44832011)(186003)(6486002)(38350700002)(26005)(6512007)(38100700002)(86362001)(6916009)(316002)(54906003)(1076003)(8676002)(66946007)(41300700001)(8936002)(66476007)(66556008)(5660300002)(4326008)(6666004)(2616005)(2906002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hjEDPfmCz55srPlmBndUKQ6dlQrAJnuEQZOMKOJPjncQtq+r1kA17SUQQO7A?=
 =?us-ascii?Q?ajiM4YN3trRNNjxL1khody4GUl38Ou1DcKTpXDKExruJrLEyoesdw+hAEvhI?=
 =?us-ascii?Q?38Ilj0ll/jUkB80U5ZU34RUmp5XYgevvnr2UgcTbsUWuCT1HVxmXAhJvBqAo?=
 =?us-ascii?Q?qV7NAhdBHJy0Az7FJcZUTB1ITro+8T8t8Ti4XIqVQGosELOrDrEC4Dy9Ipez?=
 =?us-ascii?Q?/d1urEUp2BFReESO4kTcYHMR9sudOfg2luk5pcUKMpOgCF/QGPGkTKGgZCID?=
 =?us-ascii?Q?zPDqX4kTFsjkqdynWWVYgC1O+wtO+CxTFpQGA/Agi55tgki62L3F5R54QB9z?=
 =?us-ascii?Q?h7/B02aeTNJp7FIo4qzmbjua1n2TKsnto3w1Ozf05HtJSd48MGNmfyE/L24A?=
 =?us-ascii?Q?3EcVjTr7HLDzmSZYNRj0IzaSjt0uiM3woXcoDpuRrd3KAUOo19ikLkYC9htt?=
 =?us-ascii?Q?PhXNR/w/y7/bVffXz0lypBfdMlLSkIu4zZoKURKvVn7udexcwhPImw4mK8gj?=
 =?us-ascii?Q?NfPJAWB9KzSmchLiSXNFI4O8CxrJjLbv+dripauCAevMYgfTFGa6We7BULc4?=
 =?us-ascii?Q?GK0EQXnZhbrfZjmLPM1BEVCmasZeK2nquD4WlrFvD0Audi89bnbSK1FJOW9a?=
 =?us-ascii?Q?pqRCCWoO5Mu85cdopnwXqcIx1dsr7jahDi6zrRlRWYai/xy0H4tT+98zVc0h?=
 =?us-ascii?Q?F8VLRftQtY9yTuCGCBnAsYejbTkyUEMuwmruVxALV9yyerbnK8Kv8ErwcBNx?=
 =?us-ascii?Q?rPwA8Jl76vIwFBsU+DuNUA9BqwHhgHNtBOWXYk87x32y8sMD6xc2YtYf5x+s?=
 =?us-ascii?Q?Q1narYYtXE84r3XqeIML0mI1Q8rocnzZtUJulObjosEvKsXDeKly5h6tZP0F?=
 =?us-ascii?Q?wJ5qkgzQ7PjIBykKqS4V6neerxHPsF8a8b0eTfTEts3dz7KOUQPI6HpoaKxU?=
 =?us-ascii?Q?DN7m5i6s+A7DTutOFQDfe7dXBC7Mhh13cwKpcU8Lk0xrDQqhzSgp987MYaCF?=
 =?us-ascii?Q?fzu+xLTDtqgUv9cMk2HjUxRGcbay7bLxKrzfolJyfz/2dD7Kbt5GRwQ44ke6?=
 =?us-ascii?Q?FWvFE17+u+8t6tKBP1qNi91t8bGrxbmtCSHlXsE8eRSs/Y2fRpLK022pwxNa?=
 =?us-ascii?Q?VKBGCyUKwWv0d+jGRMO9nPfyLA50/Iz9V6rFtoi1c4/wivpOJVo5Z+k/7wxV?=
 =?us-ascii?Q?P/HTn2bthc6M7DTP1CK6CseIg1OOXq281FBEawQGsnqMRwFP4+GUxvXsmvpg?=
 =?us-ascii?Q?6jbjGvuD0/cPCh098Z+6cmdT77pc1QA2204TKrR0bKq/78MkvgZj3AsQYAxg?=
 =?us-ascii?Q?/99NNpInI0nQkAbaCRFF8TrTUNuv/RZOLoKWDVaf/jDS/dI3vYeS39Dn5nFP?=
 =?us-ascii?Q?5gZAhHf064vYQAi++B1vULAjB6nbO+gl4xNKJci6bFDsNiPA0L/h0e1UY1sB?=
 =?us-ascii?Q?kWwngOnOLZngYlcrAw8pKVRRIyGdxDWjKbpGg7AszCUHMU7HIvdfEuPjbqqP?=
 =?us-ascii?Q?Rfs0bOzntfCOXYjLpYzpwVChRBKFa5t/nmdeQ7CQFWZy59j3bCZX4ggwBQP8?=
 =?us-ascii?Q?bsC3jvgfS6fA+M0IauWU2hHqYTy11E3FdOMVPaEjMhxPZoyywuiP5/ydx3yq?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fc15f0-e389-418b-aaa9-08da667517fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 15:17:12.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NI5IICmv4wnkK5PMFA8YW1H8k68i8IGTUY+5J+cNOY+0LDnRdrUx2u5tw6Yx6gGHubhKyoHmOpL0CctqJZ/Diw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed refactoring commit changed a "port" iterator with "other_dp",
but still looked at the slave_dev of the dp outside the loop, instead of
other_dp->slave from the loop.

As a result, dsa_port_vlan_filtering() would not call
dsa_slave_manage_vlan_filtering() except for the port in cause, and not
for all switch ports as expected.

Fixes: d0004a020bb5 ("net: dsa: remove the "dsa_to_port in a loop" antipattern from the core")
Reported-by: Lucian Banu <Lucian.Banu@westermo.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..a4052174ac50 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -799,7 +799,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 		ds->vlan_filtering = vlan_filtering;
 
 		dsa_switch_for_each_user_port(other_dp, ds) {
-			struct net_device *slave = dp->slave;
+			struct net_device *slave = other_dp->slave;
 
 			/* We might be called in the unbind path, so not
 			 * all slave devices might still be registered.
-- 
2.34.1

