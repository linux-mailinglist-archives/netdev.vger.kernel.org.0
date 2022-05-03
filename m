Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8328518486
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiECMrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiECMrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:47:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CC221E1E
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4zfMfOrXcFaP9Bk3x9iMeHGuhlPQm1PoQj0kTUExlFSY1pATV6+J0LxfbaFBFQJn6kX/m10LrOAYqOl6c5nioGaCUp4o4eGOzTrh0x7pdXdBRefYzeruzy4FGiThfxfvnion4WFH4VdTSR481ozjt5GZtOuLW2tstk9S3o4M/Ej9V/rC8roH5nnt3ePGGqdMVuQWyJ/0OKTY31yeKD1gqvqTBn1s+j+9p3K1gbCz6J4GFO0o4EycSnw2D9OiIsYi/eWmw2A3p+R2ixjZytgt/8Y/j+JYjG5JNFYJHUjaQujr0mg9aXuhBtJPulWNMpm4JcL3hNfOGAZwv6UWM6ubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qcv0tWphdXxcIc7RyCQtm6j1EaPfTioiYZg0WwIfCZU=;
 b=anfOZhOdrIVSC9MmatGICOTnrYOtVkJomynKjvI5lD393i/f6qUQV4kz4fpqSRk9UgJTYiUO49ef+pxinrz3nxBqV2wgtpCEwBkKFBNy3k4uDGL5hwzDSLle2z8+f9UYHXR3xQ3drzQS1sOjdQRPJEyb9TZGdON46YZU/rnQkrCGtu1i1JhOoGZSJYtsX/oNnjp6Z8qqe8KZIOL92b0bgQcf6esGJpeaU53nlDZJY9KELxt4cUYgVBsyAKT5cuxjqUWs00adW1fyAzkE/HZB9vPp1BCNNbPb8lGIqTxyIBUJFg6Owpiwna6enaRHnok55wJ/nSz6c9rv+5Sv72wfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qcv0tWphdXxcIc7RyCQtm6j1EaPfTioiYZg0WwIfCZU=;
 b=eUIfb20bFatDqGEEDQ3I7aDhj8wIR7S97/nHWnAzlMTsIW1uusD8heFNnWiv6F+xjV547UznRQHwJDuJ09qaEU8C+IXjgu6UZUD7BYtEiU5mV8q70POc/nexs31aUkf98lcJb5awqzKLsRdICCdp5Ward939/YszO6P7dSANNuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 12:43:46 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:43:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/3] selftests: ocelot: tc_flower_chains: streamline test output
Date:   Tue,  3 May 2022 15:43:30 +0300
Message-Id: <20220503124332.857499-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503124332.857499-1-vladimir.oltean@nxp.com>
References: <20220503124332.857499-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::49) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd545e2f-5e16-416f-53db-08da2d02909d
X-MS-TrafficTypeDiagnostic: DBBPR04MB7675:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB767511CE2D19128F5FF0C5DBE0C09@DBBPR04MB7675.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fy90vwpWBoEuJL0O5FBnMJnlsQ8iKKw7yS2O7yZXTpO2TQhbmpCytgGoJQGf3pIBDWbd2EZb/xWpKIlVlaZfRhc3X3XZEoag1K0ccO9qKm2xFS+P6wxgum1RynvZw8UrJdI2vdhgBd4X0Oa3NqXMKu+kAvVHpDo8tpQHjyp7OLKoHuAOwecWWEw4oSnuS64dI0wkgQfPz/nyjWzwK4Ne6+r71x0GmKhdF+7F9Ed3c/ppRzF7n2lnLf77H0xUmqWL48hm1/vyPyb4fHIzYnkPay9zZtbTSjXNhS+koy+U8hugice/TbasSQgN6XLmYYfGOJOxe7xyxN52sc1u6qBuTKapAnwCBzrsLhnSvc5C59NKtgHLC0TfFOWoon8OXg1s2ioDMVncuiTyL7lyc5f34+ioas8IEFSZ+l4v3/fnfLy+tTn6win49v5gqS+ic38+fzqmkyZiKbHGGsf5nQjgAEKe1UjGIbSm+6vE/qBEp6oX/sZ3kFSQoWfxwJ0jLc+keHbSSy8e3LrF28E+f4wvetIjfAHmKCFo9HL+nrCQua3SG4N/3tsziAe02QLh4fPgyixtN6pdASMD8YgdOfyDs3fgFFqX+zBpx3qp2K54knVqSmwQ/Y2ljB8PtyZlAxf+Wlq5wQRGyhWd6zaQUcNyZE+GQzdZibmeJN4mQ6lsXDv13pswDOu30x2WMdZd6+qs/3f1wVSpYrcPRtJru6gdSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(52116002)(83380400001)(6506007)(5660300002)(26005)(6512007)(316002)(86362001)(7416002)(186003)(44832011)(2616005)(36756003)(8936002)(1076003)(4326008)(6666004)(8676002)(6916009)(54906003)(66556008)(66476007)(2906002)(508600001)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wI1b1CcoMLSPR/oewVtZ1nogZOfLpESACrssgoo5lnXVdrY5vH0HOBZv6u9z?=
 =?us-ascii?Q?2tLh0Hua/VexFL9DIweVTe9ZwHhFDndL91jL1u1Wp86OZg2R4J3ALtfSL2B+?=
 =?us-ascii?Q?K2oZe7/mafJg80ow56X75mA4Yq5DtlwSoHCGha0/5HNBpG5HA627CL0+Tif+?=
 =?us-ascii?Q?7U13H3QWqkJ/QOwV6sD5hg74Ae2X2oUgDiGtqSHL9Wy9rCj8oYr4dG7oMIpW?=
 =?us-ascii?Q?ouJWgVCWYHeOBobtQsKA6rwTCaOXjsgX/GsJyna/raGKtCAVykGTZ8D8u0sX?=
 =?us-ascii?Q?g3UyHNpyUVHz2CARrTGYZs6rECHzQsSOIJpiOg3KN0FiMq3b6z1xMIMfMAKF?=
 =?us-ascii?Q?xwq74kAquGTJfuSmIjpvIr6JVp/rFa4uwKWKS8emZc2m17zKmQUYiCueJGi7?=
 =?us-ascii?Q?lTm+6yXaw7fHuoAxpMcwpFIQ1xwpvauA0TpiixYWaEVCApAD6CJkoQy1XeUz?=
 =?us-ascii?Q?00EIMpYbYgmh386pUmNbkGo+ONrtuBDoWV3aBnNssC9rpvOJTmDZHEFITeAK?=
 =?us-ascii?Q?1JzA1jSiCpCL2Auh6wYJiaC5HH3lh/NOcBbJUZ2BdJe41iLWhxdzXIjdLI3i?=
 =?us-ascii?Q?270t2M1U7v0fgiHR8B99iMEiXciK/lV6wmRxkJuHO29pwAFiP1AIGS0dvwpR?=
 =?us-ascii?Q?BNV4coTtH4PShY6AAzVFY6TzTrS2hRWGAdX9PPbh1QUV4b08fHy6e98TdkBR?=
 =?us-ascii?Q?kXAfpcGG858UJzHPBHuU8v+9A0HHd0oWLkXd9llELVjLBW9LjkdxbsMkH8cm?=
 =?us-ascii?Q?zbAaHkoc3g1iKoBC1Fyel6Rv+Tvi14G+bBTf/jw+BmqmBgwpygLy/drN+DGM?=
 =?us-ascii?Q?t9Vw5iyuUk94STbpc3Nwu8ZoVDs/In3upZgbQMnbcfkpykshj50wrM9x8p6M?=
 =?us-ascii?Q?B4XYDBn0ssPom5V2QvGB5W+coFylNIhvvsxlepFURfJdK170rJfYmC7EVASU?=
 =?us-ascii?Q?08pdFj1Cgj92mlWZYrye6qb+V3RRy7n7A9Z4owIqmrMWDO5ZFBSDQnq1UKmB?=
 =?us-ascii?Q?Wkh8cpocs/ph7kauCT2Om0EQw+Ql/41gq5b/BJ6D3ZyH5a0RuZOfEx4phJ+l?=
 =?us-ascii?Q?KoNpI7crCtzvPtg0dHpc46WOeLaaW/I8RKvEXb0jtcnnXGtyLBMH9mC7GoxG?=
 =?us-ascii?Q?Ji41sGq8+x0STzyUAwvzTQMXQH6dpss6cqxl59YPEwzI1RKIljyo36mZZETj?=
 =?us-ascii?Q?VoB1DiVa4C8QBU676jxQfEgc5zTBU8VQW3LezXj16IFkeC4+STyF3MoN/E9H?=
 =?us-ascii?Q?azonJ4QXMTogVjzgHgmYGjzWcHVM8qxg3Q8AX1dAGpRAUBVimXgIEVXoEObv?=
 =?us-ascii?Q?Bgdupq26oG6jJ4I+U6mpmu1IxfM1MVX3Fm3CZ5mDJ6BbsAPc7pJWpIGVR9pQ?=
 =?us-ascii?Q?8BdnjlB4ufHE43q2vPVPM0vNFtGaqcvsUC1B030HBHw8JQtsu5mtuCo9+R+h?=
 =?us-ascii?Q?vo1IQr9pPwCpgwU0kvCVFIz39V+5pkBFkqrYBsxwodYQ4/XKpcUekJHbLq9P?=
 =?us-ascii?Q?oPuzUyzMkEmW4sUG8CQ2xSm1ffkTn55KJXRkNeqt7EdZgVeuBvWoJPrFrO1r?=
 =?us-ascii?Q?XAvWVAOXcdCZ9xsgXfIbemZIWL2VviGM+zlGcCy+toijsjD7vB81S6o/PVcJ?=
 =?us-ascii?Q?FJ2H8NOJCoWSQoL4INdmsu050ndrCy8BEECQeGvGug4Ou1MgZRTWK3/DERIC?=
 =?us-ascii?Q?ghUMThD1zjl7BxbPW/k+x0TG0CaWPvZ1RmADGvO4af6xsRAKZt7abEeam8PD?=
 =?us-ascii?Q?uHMTYTZy4aSEahMK3pUxNc/DyZYSknY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd545e2f-5e16-416f-53db-08da2d02909d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:43:46.7948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lq3yP2G5UxHwPARaw1XQn2D0JVGT4kPy66RaJdcOyDJakLVUirUlhHyJ1YPZAk5oBV35S6/mZZ65MD7wcc0Nsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bring this driver-specific selftest output in line with the other
selftests.

Before:

Testing VLAN pop..                      OK
Testing VLAN push..                     OK
Testing ingress VLAN modification..             OK
Testing egress VLAN modification..              OK
Testing frame prioritization..          OK

After:

TEST: VLAN pop                                                      [ OK ]
TEST: VLAN push                                                     [ OK ]
TEST: Ingress VLAN modification                                     [ OK ]
TEST: Egress VLAN modification                                      [ OK ]
TEST: Frame prioritization                                          [ OK ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 52 +++++++++----------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 4401a654c2c0..a27f24a6aa07 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -204,7 +204,7 @@ cleanup()
 
 test_vlan_pop()
 {
-	printf "Testing VLAN pop..			"
+	RET=0
 
 	tcpdump_start $eth2
 
@@ -217,18 +217,17 @@ test_vlan_pop()
 
 	tcpdump_stop $eth2
 
-	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"; then
-		echo "OK"
-	else
-		echo "FAIL"
-	fi
+	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"
+	check_err "$?" "untagged reception"
 
 	tcpdump_cleanup $eth2
+
+	log_test "VLAN pop"
 }
 
 test_vlan_push()
 {
-	printf "Testing VLAN push..			"
+	RET=0
 
 	tcpdump_start $eth3.100
 
@@ -238,18 +237,17 @@ test_vlan_push()
 
 	tcpdump_stop $eth3.100
 
-	if tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"; then
-		echo "OK"
-	else
-		echo "FAIL"
-	fi
+	tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"
+	check_err "$?" "tagged reception"
 
 	tcpdump_cleanup $eth3.100
+
+	log_test "VLAN push"
 }
 
 test_vlan_ingress_modify()
 {
-	printf "Testing ingress VLAN modification..		"
+	RET=0
 
 	ip link set br0 type bridge vlan_filtering 1
 	bridge vlan add dev $eth0 vid 200
@@ -269,11 +267,8 @@ test_vlan_ingress_modify()
 
 	tcpdump_stop $eth2
 
-	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
-		echo "OK"
-	else
-		echo "FAIL"
-	fi
+	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	check_err "$?" "tagged reception"
 
 	tcpdump_cleanup $eth2
 
@@ -283,11 +278,13 @@ test_vlan_ingress_modify()
 	bridge vlan del dev $eth0 vid 300
 	bridge vlan del dev $eth1 vid 300
 	ip link set br0 type bridge vlan_filtering 0
+
+	log_test "Ingress VLAN modification"
 }
 
 test_vlan_egress_modify()
 {
-	printf "Testing egress VLAN modification..		"
+	RET=0
 
 	tc qdisc add dev $eth1 clsact
 
@@ -307,11 +304,8 @@ test_vlan_egress_modify()
 
 	tcpdump_stop $eth2
 
-	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
-		echo "OK"
-	else
-		echo "FAIL"
-	fi
+	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	check_err "$?" "tagged reception"
 
 	tcpdump_cleanup $eth2
 
@@ -321,14 +315,14 @@ test_vlan_egress_modify()
 	bridge vlan del dev $eth0 vid 200
 	bridge vlan del dev $eth1 vid 200
 	ip link set br0 type bridge vlan_filtering 0
+
+	log_test "Egress VLAN modification"
 }
 
 test_skbedit_priority()
 {
 	local num_pkts=100
 
-	printf "Testing frame prioritization..		"
-
 	before=$(ethtool_stats_get $eth0 'rx_green_prio_7')
 
 	$MZ $eth3 -q -c $num_pkts -p 64 -a $eth3_mac -b $eth2_mac -t ip -A 10.1.1.2
@@ -336,10 +330,12 @@ test_skbedit_priority()
 	after=$(ethtool_stats_get $eth0 'rx_green_prio_7')
 
 	if [ $((after - before)) = $num_pkts ]; then
-		echo "OK"
+		RET=0
 	else
-		echo "FAIL"
+		RET=1
 	fi
+
+	log_test "Frame prioritization"
 }
 
 trap cleanup EXIT
-- 
2.25.1

