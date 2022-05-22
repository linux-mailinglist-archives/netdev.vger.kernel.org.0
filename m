Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84553022C
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 11:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiEVJvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 05:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbiEVJvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 05:51:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B728CF42
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 02:51:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U67ixu1tRuJyOZAbKKX722AfjS/d07UNCqwTGiSk35sY7H/po3awoVZEVobeteuxIjZj12FEpdgICdJ/KRGtDeEEQ1K4Qjee8yE362dhGy7GAddRWjywMTijtHJynLrPPBml3Oo3z3UQf1YOdJKQA6T0YqsQcb0rXLAHRr9Cy+GniQLFbyORCCecTJLWBMrlzUjQlyGYaBToL0HiUemgMoPvNZjHCP1sO13tmypgMQ6NQkbfih9qe2hlqheY24iUQjb18R6NhwLo0dNeYTvOB2OhUjeYzuUPZ1w3OMWj6VsBKZ0hu+EuCcu5a+bpH9U1NxlMuMdlEWKIeqdumCxANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFS76mxws2f6vryN4CiWBGlkh+ruYBCYz21LiRpvmiM=;
 b=G17z66CrfR2G/YZ1z0RxbvXypo0RUJkVoZ8ZqKPJ8QGmkGOibglT2NT6auz1ZgMDnrJCLgWz3dXd7Pwdm4Lr3ul9v4/+J+WEV759zMbfqVKTHETtmX1JYdG57BKlr+dgxAI40YMV6+Zcbv2bDmwZPnqL5KF0WPIhrTeqOZcqncFiIB1coKMc7mTEpIN7Ef8OK1RCNS90XD8NgkW5ymeIn2Dlap2kZgMnfjRYl763PxMdh0NvviTFRBRkZX4k+IZlkWzQtLSnZtN2NA/p/fWANYAji3wO7FWufUBrYt+IyGNxi/DYoczi/+G/kxhBx2qpTP/QxLXVRGCYPK5ECJMX0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFS76mxws2f6vryN4CiWBGlkh+ruYBCYz21LiRpvmiM=;
 b=D3EnU3WtnM4sSYc38H671yZQTUCicqmhaaVeTZpPslRvXU6afkyxLYQ5vXqz2Ure+vSV0mE8vJ3F2B22zpAHGhvZTRqTu2RyLYMOM0d93VZmzzHcttI8oUxqaNhn3y9t4qOqnbBSmRbTsJ9wWoUMMm2YNEpABNeCl+uhXLd5+so=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5306.eurprd04.prod.outlook.com (2603:10a6:10:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 09:50:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 09:50:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/3] selftests: ocelot: tc_flower_chains: reorder interfaces
Date:   Sun, 22 May 2022 12:50:40 +0300
Message-Id: <20220522095040.3002363-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
References: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02d9a39c-36a3-4b94-f8d8-08da3bd890d4
X-MS-TrafficTypeDiagnostic: DB7PR04MB5306:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB53066525A3AAEA156951D74DE0D59@DB7PR04MB5306.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPNRISlMKahEMxZNsIqO6/LQtsoSuuxaowYdobCC79D58TYeRCFHsG2xHyoXS5s+FH8c9NbrBmPmGkbXMZ91/mq4UvKBloBpYKqhY0+RNXSKwn2qKilZhfVhxc4bJulN2Coo55bWFQC/LrV8FGRJHptx1BuzWqzFtydLS3WX76AcbqjnFaH98b8/6OCMcPDmqCvCKcdA6wlfjBhr8ha6q3iFaiwXrnNn5uXb/z9FBavK3OQd3RuZsfNk0oL/DthYSsCIb6asIDNo8dUAD0Bt1cOWvsEGkMYUb86hr6rZoRVHVSOp4VAce4oeZcvfNla4B5UVBV1rgIWelDgBQ4aYrSHCtJddX0a4+MMzplMBWjsINUGGIFCthXG/vQxl/5HRoa07g+WUmu9gPoxXZG6z+ZJqxtgfnE6aOPo382MVjxKFhC726PyEJl2TUTebDmyaUXbjuPcQboMRieRZgGlbCB+E1ph8ozrukk3uKQnO3V8L8omgOJA13nvs2SBQilRG8VMSUveImOX/KfygyQlF2WlukIzlozEEoOtcohrx0KExS/dbyRJ+pDverqTW6jn83ZPSjBq/TscuoQyZ2k+81l5AjFv+iXJmFsniwAaDHKdbNAwSiivmaQeUyn6jWobya/IN6UafEI8F7HGAuu/czhbYrkAmg0wMcmUC9Td/uxP8Sl4FG9yJzm+22Gn8ECsivn3qZ3hjPdfcUcD26QuRkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(4326008)(66946007)(38350700002)(66476007)(66556008)(83380400001)(36756003)(52116002)(316002)(6916009)(54906003)(6666004)(186003)(6512007)(2616005)(6506007)(26005)(1076003)(8676002)(86362001)(508600001)(2906002)(6486002)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VAsVNrtxZOtw6j0/HLJogZL/PAJVpJKcHf1pPGZXJ/AIZmDz72AdADYBgU3z?=
 =?us-ascii?Q?WuZNsLw3dqWVDSLBZSBJAF5jRv8SZYSxmJ+3n+jDH8AlkL1LmnCIPcnmbH+j?=
 =?us-ascii?Q?9ePmFhabh7UPAUT4ZQgkI1rKczB31WGK7i/y7zWIDG4we7f5tfLL09bY6pfH?=
 =?us-ascii?Q?LdLizO4JUstSOusV+9EHyXxxmXhdNx9dHVe/koZer8TSDlhZJqFGnE7uTNSw?=
 =?us-ascii?Q?oW+VQtIAOICwtdj+9ky/w2qqtqbf3FTJ0x017+6WRXuheVGbc0/c7EYLGJ1L?=
 =?us-ascii?Q?qJiRCcySkCjj0QT6gf44Z5bmxkOT5j0VTGdQAs9fsk1NWUxt46qjURaExA7O?=
 =?us-ascii?Q?puNQ4jqzNkTI3ogiVpEmgFHdrrqCqrwK57q1qYQqMPqhxsywlnMA0HZa45Va?=
 =?us-ascii?Q?vlY++okKVYtCrs0JA8xOS4KMRGpwpi4I6Ai9qvu+6UCCEo12uIRkP1xFeF+i?=
 =?us-ascii?Q?F4DeVhfY6jrL4Rq5qp4a5pgSz5wsYQA2soVoRLZ4+jK2bBen63IKDSlOP44V?=
 =?us-ascii?Q?rFh+IUdO/sdyeRLdcMJoKt9VV0W/OQDW1NXES76rqmtQc1yCm+EZyAwOxFQq?=
 =?us-ascii?Q?cAuSSY+Fo2nmJzcz/f7IDo0GNZOrtk0DjbAkC+0F5b6/sAQxH4+lTrFBwgFz?=
 =?us-ascii?Q?9vyelooQzpRKHOFjPaZlMw4N9ef8Cso21MaYgY7C7zo09Kk4R5goBfWrCrG5?=
 =?us-ascii?Q?PPLVzQfWnduqU1pY01IGliufrdzEXPIABXWaidAD4O8UJs4rHt3AdX6KHbWu?=
 =?us-ascii?Q?WauOsfnIswnXJwaFJclBkmwD3b4oU7t6TgnSVdlXsdoG//LRKcpKUm0LJFEk?=
 =?us-ascii?Q?851IhIKlyZS5fVBXum+x0OpVn7c/ZSHgr27dTkNvRlWOqEA9q1K4f73KvJTQ?=
 =?us-ascii?Q?7dcuUebsNX06piBdfVGhrDZDVwYUR6boyA20Jwkf5uTFrX2X4272ItZCEQ45?=
 =?us-ascii?Q?Blogw8ymdyaFl5vWt4kBW4k2ePfJzzXzUUfwfzhfSlQoGDsNXVaqF2pioNLb?=
 =?us-ascii?Q?ESWypsemX25IO2DE8DH1w+Cp6ywfcLM3MsgHPt3xbe9/20WAI4x5T6eCk9F/?=
 =?us-ascii?Q?trYrzMuKGR/v/AG1nQr4/mUmilxeUFs6gK+DOY7GsXIC62+rU3uNzHcg2583?=
 =?us-ascii?Q?/a1uVe6DzfLms672H0Bi8XFA0fYuYXJJX/bipmJXGXD3aTVFL+GYEZL0ZEUu?=
 =?us-ascii?Q?Ma+l1sJSyE/sWc299eklKFiU5pDZnbxRchGEK503nY1sapofCmqMg0KH9wse?=
 =?us-ascii?Q?qnntuCZObydTE6/66yFHkhXbEcAvMYrwSNs+VrfOIKNwWM1iYOjsM7YnKZ3/?=
 =?us-ascii?Q?6dNWxJYPVCXSNQ6RaYvU/VEvwQewLyhKTmz/t5wQxQW9Yprxkd6MoJ4lD6UY?=
 =?us-ascii?Q?56AXOh9urjRRfJYqxN/2GdnwOz2PsD2P5d2eFPQcSVZucxgQOcHgYfOV0mWS?=
 =?us-ascii?Q?4iQRChcRJ65q0W8sXtW+ZpbgEKSfF1NYC0/lAf1gfMhMhbJCSoQSMIviwZXD?=
 =?us-ascii?Q?GeIq7tRBF3/wRJjC8isPCWN4M0TriK3Ht8x4PD8KBV+MnKRSdqejHWhyIKeS?=
 =?us-ascii?Q?ByQaShpxREZsVPpvxbO1MtwBDMtvgSEaDREO0DQU7mllU4gFOD0+HR0/yumE?=
 =?us-ascii?Q?/+HwRpx8cCS9WQlxgVDLZg8K2gw214XHax1ErYoi0K32L9qbzPpa2CmY09c2?=
 =?us-ascii?Q?we5NWoEZVKbR8U1AS2CxXoVvkcPXI7A83SvvMlPmwj6t5GnwfT7wtam9uBWc?=
 =?us-ascii?Q?wrNhAzWVc4lBUJjxf57hBQxUrhHQfrQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d9a39c-36a3-4b94-f8d8-08da3bd890d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:50:55.6760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aqLasWNMaCEXDJn/aRBZcywsnmGbE7XVq592xoLv1oTlQSatEnZLCBt2jEwr6DiV+ZDudsRaXqzvxgMfW+SNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5306
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the standard interface order h1, swp1, swp2, h2 that is used by the
forwarding selftest framework. The previous order was confusing even
with the ASCII drawing. That isn't needed anymore.

This also drops the fixed MAC addresses and uses STABLE_MAC_ADDRS, which
ensures the MAC addresses are unique.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 42 +++++++++----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index ecaeae7197b8..9c79bbcce5a8 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -4,35 +4,17 @@
 
 WAIT_TIME=1
 NUM_NETIFS=4
+STABLE_MAC_ADDRS=yes
 lib_dir=$(dirname $0)/../../../net/forwarding
 source $lib_dir/tc_common.sh
 source $lib_dir/lib.sh
 
 require_command tcpdump
 
-#
-#   +---------------------------------------------+
-#   |       DUT ports         Generator ports     |
-#   | +--------+ +--------+ +--------+ +--------+ |
-#   | |        | |        | |        | |        | |
-#   | |  swp1  | |  swp2  | |   h2   | |    h1  | |
-#   | |        | |        | |        | |        | |
-#   +-+--------+-+--------+-+--------+-+--------+-+
-#          |         |           |          |
-#          |         |           |          |
-#          |         +-----------+          |
-#          |                                |
-#          +--------------------------------+
-
-swp1=${NETIFS[p1]}
-swp2=${NETIFS[p2]}
-h2=${NETIFS[p3]}
-h1=${NETIFS[p4]}
-
-swp1_mac="de:ad:be:ef:00:00"
-swp2_mac="de:ad:be:ef:00:01"
-h2_mac="de:ad:be:ef:00:02"
-h1_mac="de:ad:be:ef:00:03"
+h1=${NETIFS[p1]}
+swp1=${NETIFS[p2]}
+swp2=${NETIFS[p3]}
+h2=${NETIFS[p4]}
 
 # Helpers to map a VCAP IS1 and VCAP IS2 lookup and policy to a chain number
 # used by the kernel driver. The numbers are:
@@ -204,6 +186,9 @@ cleanup()
 
 test_vlan_pop()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	tcpdump_start $h2
@@ -227,6 +212,9 @@ test_vlan_pop()
 
 test_vlan_push()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	tcpdump_start $h1.100
@@ -247,6 +235,9 @@ test_vlan_push()
 
 test_vlan_ingress_modify()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	ip link set br0 type bridge vlan_filtering 1
@@ -284,6 +275,9 @@ test_vlan_ingress_modify()
 
 test_vlan_egress_modify()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	tc qdisc add dev $swp2 clsact
@@ -321,6 +315,8 @@ test_vlan_egress_modify()
 
 test_skbedit_priority()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
 	local num_pkts=100
 
 	before=$(ethtool_stats_get $swp1 'rx_green_prio_7')
-- 
2.25.1

