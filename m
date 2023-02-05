Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7CC68B15A
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 20:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjBETYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 14:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBETYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 14:24:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C50018AB2;
        Sun,  5 Feb 2023 11:24:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQilMgcJw+APNkCM9FAHCJ/Z8kee4I/qz/bESgmMIwU6qKd5Ho4jDcN6Wzlb6fLrq3CEtrCl4H4qy9Ws3OUENGJ0bv4xEWQtt6W+32yHrNC6HwxmHlb+TFXTt6bCUyNI89PO5F7k0FQwFxuck0YGgBEg+obYSRQDH21BeQjT4NyVj/2kx9vjl2dRzMXnyGAqIv60Nf/J4n6CBPiVKy+QagSlKS0DI4znKR1m9KL/meIbb65CqBWVR83YKQ5GNDW44zehhe9R6z1Y6yB0S7I6g6TtV8CuV2qNZZS6P2aFlABaVpRmra76zE+dQVHzQozc7FtA3+b8X9DWc9sWUSeiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxIwUwKxWN6RNJn8UkA+u1msz2UasSdFRO0co8Oegik=;
 b=Ml3xMwGSOpiUK0U+WOmsLw1wwLS4Xplfqbe8/+ngRERMmFA6ntlHZfSYWYbU3t24xH/G3D8inUMyRsRhVWbvWcoLb6vLCGYuCiz5Nuev3ec7j2SZghZFpie2lrdJnn/2zN6/srD2QdapPWFqkaZ50VtuaLvFNNfPIJCOJeQOJOgD2/ehu1obcUnXg27p2nMRdXdOnj8++odHqcPXiF/uWdiDPlDWWMt+DaKfcS3lILRiBOjY4f9resOR7C7r/+adrVfd8yYPeN0329IzWFhxFvD/fQGDvjCccgOt75dR5rTnm2KuRQXnZj4SwWwDTuzWPmACrA/O3TQ2sigmwc2bLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxIwUwKxWN6RNJn8UkA+u1msz2UasSdFRO0co8Oegik=;
 b=Bd6w/JyEdZ838H6BszlVVy2OaPMLSQZgWEyAy5ezBFgMzsxwIEEUz0qyKM5EUddo/sp9NBZxeMbBI9v9abH9qlKyJnKRP8GDwejdfjvtE1itxDWyX7VZPlc+71w7AGmTEFe1xiBwNSlfPSA7+V9M2hu230/xH4uK443xg9jyR6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8391.eurprd04.prod.outlook.com (2603:10a6:102:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 19:24:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 19:24:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net 2/2] selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive
Date:   Sun,  5 Feb 2023 21:24:09 +0200
Message-Id: <20230205192409.1796428-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
References: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8391:EE_
X-MS-Office365-Filtering-Correlation-Id: aac7520a-c306-4c21-0113-08db07ae978c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRuyUax3nGD4S+aM5Dmud4gYHPMr7uOkr8k2KPKX7A/Wa2naY3ITigyjUWX/TyfaW4nt8G9vDXwKIcr0ye8EN8hqyXLlI/QCvOKIH0rovAQofJNmWfEWodloYlwHU9OZH6L5GvyhSXaEl5JBQGBkA4IHtVnCjy1DcZmBRvyV8K0xWEBRK0oQOnEUg2LkujVkjnlr+OPCFyagoMrBjrjGDcwItJrtdBHmxmLxcQnvvKxq6fEkVNkbRHe/YwQKepSb9cfHQoRJhJ69j5jldK9oEHKFYch/quqhTl/J6ApeCJaoICGP3/VrQWTvslVJkofqcZCD3gPUZ8a6wK7+qWVhvP9RMd5aLS+6ixl+knVK67g/qjJeyxMcbESPcOFaHOYyqDhDrsGFK0u/Da2zetRHNUpIj4ttdF8M+ZQ4MsHjUmpEWIzI++aKPMGMHqGmycercwMztU9Pgf61V3nzz6KpnQDTek/LAbMu4cKqrDziXqxG20zJDDUXBECErt/6k3vNflf51LLFQiW1fS7h/34rp6EL9zNKvNqrebhvpTg7uNSvzngy7JUeIrAAphOoUqqgrAr9Z1SNUx4X1xyxjT34RlM6gD2RtQjA/i+75oDQmrh36aKZa40CZDEqro4VVjG/pWwtnwxHmtGM0Lqwn6aOpY1bNGydiWVH1Qeqy0WwcIUDcpL/muW7FOgTDk7o03bc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(52116002)(54906003)(66556008)(66946007)(316002)(4326008)(6916009)(38350700002)(86362001)(36756003)(38100700002)(2616005)(186003)(26005)(6512007)(44832011)(41300700001)(83380400001)(7416002)(2906002)(66476007)(8676002)(8936002)(6666004)(6486002)(5660300002)(478600001)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7jmWD+gXNOe26vSjK8WLEgQf0tpArf8Ewk19DEmfkLQECqAFUelcTwZPthR?=
 =?us-ascii?Q?94Ak2VfLwWRrHLpOMDUYsHAZp9/8xveg6OUPKP6L8BrjItDTPFJGQWPyT23F?=
 =?us-ascii?Q?h8jGkY8L/98P7Ub3kjW3Y31Of2h7HghObK9DZGnZbT6eYGYFK8EEXIXSf28C?=
 =?us-ascii?Q?O2rw3I0/4MEQOErEqttcJrD84mt9Sdp9Jqs2ukQxSX+eBPXxQqdNUT/y2MoU?=
 =?us-ascii?Q?K8P2I0BVoWG0rOZCldMVSyXwMElo81gFDzcRt2ujn/ZiwfXRZu4w8sU+i5CI?=
 =?us-ascii?Q?kSChNRymjV60gWSJNgFPusmCaN8YLeOxp7KsGTvqreyGsvgbqkukJCUQhuGX?=
 =?us-ascii?Q?pbEN0OdTdcdlyjHBqnGic8SWI0Q7LWgHER4xJKHqwnQkeaHnq062xQvyDMuT?=
 =?us-ascii?Q?tKSSMQWPRkIclgW80v3N2YPMx+CrrDtcTPfuoDWp22MsL9kowtt5FVXe3nmX?=
 =?us-ascii?Q?IZnLdcPJHq6IKbVnmDQN7PsX0zwIXAUo1aeN8kC2ePXXlE/yOSchJS+V5vzI?=
 =?us-ascii?Q?tYNzNhGOvsDtXWRywJfH3errvRehMKrkneXwitvsVqKFozyswVMmfYpc1Y7F?=
 =?us-ascii?Q?omwcSgqvuF3Qg7SXv9HvqxoUVR0P/el2K8BmVknqOWF3+EijtrBp529Z81hd?=
 =?us-ascii?Q?SG7bG651MmdkJldmHFKEiEpb/1vlbSLSlVgR/trC9CGxwCGCnDO0fQSsLWPh?=
 =?us-ascii?Q?fUJy4Bpy7kRa2E1dMoi5wDAujlOwc1gQL9pp7TjyvL7QjGZO2iOe+kQS2UcX?=
 =?us-ascii?Q?7kcbGPJaolsKPFC/1JcNDzT7taihoXZYwQDd2zyPYFBRyUQLlKZDKHen4cQs?=
 =?us-ascii?Q?YE4xG2JP0KGA2T3BbNoQ6eI3peQCtb0q6OahuMyvpp7TrHlzmgiNZLvza+6W?=
 =?us-ascii?Q?HpqbVd48bbL/pFT0g1h328pIaBpbMGt8Iw26ixaGQS3yksRrkRh1AUfmQLZ8?=
 =?us-ascii?Q?W6lqtcBVVr9bMYuIanI76dNqWpCUCdus3x/ZQzkfJPm0jYS95tCEIGhIoQOL?=
 =?us-ascii?Q?5FT4fR/nQgFAM+Q81a2ReC7+5AzOE/jWzgBNKmSyDVmTlGqNkg082ypRz7PL?=
 =?us-ascii?Q?xjxBMiVXgONx7SioR5Lbf7anHJcng937ZooBCLpmqcZEPwVPHvmXvWO5YdT1?=
 =?us-ascii?Q?PcEltA8B8AD2eOCo8WQczblR6FUtb2eQiCNXJfuATldteGbfSk0dJH+Ix5mQ?=
 =?us-ascii?Q?AjxD0ITBMEG6Ex57Et987H9zWXeX/eUOwR4pL4pRMONXFrlliJpKzxOI03ob?=
 =?us-ascii?Q?hmKcvrMqqBNaYDXyHsUDVTyNiyk9LZYIo68+UqvueAGlkhzOb+GVmkT19uSn?=
 =?us-ascii?Q?Sww/hGrTlshankrruKeOeJ20S8gMID/Wv6SQPExNjbmQjmp4btqpB4sxF284?=
 =?us-ascii?Q?FUAHNKjkdftqnFJ8NnybeKYmHY/B7TnAP0iO+KbmSgNBNilas+y++D1yR6AF?=
 =?us-ascii?Q?9Nez0yJTDN1tkm46CjUqEbQTKZnrQ9bwlEvmJazTIqUC5Y10f7HdHixhqhNx?=
 =?us-ascii?Q?OHNnfhp0dO2ROBzsB5uOjQQRvDkpygnc/R5iFU1FVUXD5y29M6GpXiprgouX?=
 =?us-ascii?Q?x7/J1ZGHUuMqN/Tp4wNEXev3b8V+A0bIqDZC/vOwW8Y2bRHlkdXzbWdWZL8Q?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aac7520a-c306-4c21-0113-08db07ae978c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 19:24:25.8014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ElCJRPJVMK6N1Cnwyr7++tydJfXnMPWonRna7WH2UvVzWZpI/UwD3P6d/8YaWTCaIuhz05IS7iooAVIJ9GxqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have two IS1 filters of the OCELOT_VCAP_KEY_ANY key type (the one with
"action vlan pop" and the one with "action vlan modify") and one of the
OCELOT_VCAP_KEY_IPV4 key type (the one with "action skbedit priority").
But we have no IS1 filter with the OCELOT_VCAP_KEY_ETYPE key type, and
there was an uncaught breakage there.

To increase test coverage, convert one of the OCELOT_VCAP_KEY_ANY
filters to OCELOT_VCAP_KEY_ETYPE, by making the filter also match on the
MAC SA of the traffic sent by mausezahn, $h1_mac.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 9c79bbcce5a8..aff0a59f92d9 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -246,7 +246,7 @@ test_vlan_ingress_modify()
 	bridge vlan add dev $swp2 vid 300
 
 	tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
-		protocol 802.1Q flower skip_sw vlan_id 200 \
+		protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
 		action vlan modify id 300 \
 		action goto chain $(IS2 0 0)
 
-- 
2.34.1

