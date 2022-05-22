Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666E453022A
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiEVJvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 05:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbiEVJu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 05:50:59 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A9CF5D
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 02:50:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QycL7nva1U/1O/x9KoZJCxilRb1IAz3Z5hxzSWrUiJVKN6mNl8QwEyJGK7mdDXomI7GKItESjtJ5PfWH8C3SINtpPC5gloHYVIPMWjj8YbzmGfYndyW0VcTdB2bkNUh1lRyqBW35+4qiIe9aiKirXbMJdodZEQPJWLQ8eIoJn12+ywklezERtRdXXNTOiu7U7bmdPWLg8Xbmrwp2LCCMZWlh5ZGUdaBIejl/jw4Ul2iCIOxWt4FsGtwA4rSpH7nGIkmq+nK48uZpJAyJ1H1WGLiLAnWkTjVd0lqv7h15OQW9sL6DFMCHJZQrCkekMfykAJDeJOs2DJogFYmeE2O95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qcv0tWphdXxcIc7RyCQtm6j1EaPfTioiYZg0WwIfCZU=;
 b=T21fdnFk6tWDIodyHoiJ2ROgReuih67p6ISpVWT/MIw3CWmv527pIzz9NLFyBisRyOe91EbbIZazs7xGulhBu7nfksfvl8Im+7CSUd2k246X5BHynKbMp8aC8fayYL+Jggg5NXGekmjkxzI2JWuD+Fi8lA2L+5cFx+TIWltLA7c25ipC1ArfXb+4V+R7l/elTZTBizUp5fzxJdl8Xv6FO5dWO6IvEkWQWxCyME6PENMybcQyKclhksXNOseNETwVp4BxN5fsJl4BEbzex39h+TvdFOOdWASAsz+/EVygj5uqoqe7fE2cY1KVVL60TrTmdjDeLrblb5mt0jzPeFoKRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qcv0tWphdXxcIc7RyCQtm6j1EaPfTioiYZg0WwIfCZU=;
 b=eKJ5GE3GRTE/1kiSot+D+F/+JsokwdYksIg/0hOtJWQ5k6m6GKXDfuAEZzIXNY6SDNl9kHT2R0m7KWJ8/AP/LJ++PGlwAtKr7RN2cAew6PAOQ+1OiXMtL1yq4bXPrkMP0f4Lb1Hqx1cfBG9FOms6RUmVcaB9DUQJWTAVmVfmzEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5306.eurprd04.prod.outlook.com (2603:10a6:10:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 09:50:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 09:50:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/3] selftests: ocelot: tc_flower_chains: streamline test output
Date:   Sun, 22 May 2022 12:50:38 +0300
Message-Id: <20220522095040.3002363-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4941814-6e99-418a-d555-08da3bd88f65
X-MS-TrafficTypeDiagnostic: DB7PR04MB5306:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB53064F000692BA7D32E519E4E0D59@DB7PR04MB5306.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cx4pYX4VbmAO34zqQcqY1psWlIKx05JSWmrilhwAZ/ApZu5WlYUKSLjipP7fi2mMKjvNpCqMHrRXxQBg3bD9G09ZikgpZqyIpJGw/k0sxEq8iM26tUIe6V5oMrY5VE4m4dFjIuLdG6R2TRE4gdSqPah8X4P3woN0EUMP46Bp34HAd3IF1GxLTbLqZXhNRHujlfRr7pFCE1KJ5SiiBQlR+3sn4Q+0m2FTxDZrxi+9QtDiJjYdo526s3UUJ+vj+k/nxiF8h0zfCyoElX/IdQiyWg73il8Y7JDxxPSuc+qnHJS/FZ4TzazMtoeWagIE/w/YIMqWCDZnK4TcnfhFZFY/dNie5LCjwjjrebNB70GM9rXKNOmlkg6obM9RdYGrRbNB132UGXOLoMKqnh78jFJbSeQrfZx/EnNQDVcjAB14It+QhCjuAM97Tu/9FAs5InQ2HScFdxRGwVV6qfpJT2Rg1v4d4yLwus6pth8i6wPAND80rnj/5SRutjObyMgTCSsv/7VWlcceoe4j841bhDnwe0GoRItxJ3JMOEKgh/vCS76uXg1ZN3NfSOPdlA3AdD1IKvr9G+ZGVzPDmRawMzqEc30UnNAPUwXD9sJjwqO0F57cvukYr+sodpmdMcljsVwYTBVFQNK+KEVIvahFka0mtOv8+IteKyf3lg1urWI8B2LbCXmeg45G4H4QZFBrg1rnlmFZnTTffjW54tGw4fWmGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(4326008)(66946007)(38350700002)(66476007)(66556008)(83380400001)(36756003)(52116002)(316002)(6916009)(54906003)(6666004)(186003)(6512007)(2616005)(6506007)(26005)(1076003)(8676002)(86362001)(508600001)(2906002)(6486002)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8iZXoNTZgWr4GnN/YBuhulFg6EqgeQ8JUM5pMEWLl6gfgoVWuxWmjOYTx6o?=
 =?us-ascii?Q?3lPKx5cSE80SDI3liRpBitIWItbAViizn1Z83h3EKoLuC8TyFfXOFrSXWTJV?=
 =?us-ascii?Q?3CdUDlWJA4lLnQqfvtYrpStbVPv6H6jOep1m0dsnquESubMKzV3njf0nRymC?=
 =?us-ascii?Q?uAOUAb4mBkbPg6xRC9PsLNmW8iYNsF5Qf33kYRTrf4Zc0pWUyGKZYjxJO5iz?=
 =?us-ascii?Q?vS8dn8bWIVKkolb11AtLyvZL43Tyv/rhMXoxMbvCaZVoQub197jqh8G+wfBK?=
 =?us-ascii?Q?tikrW1twBwYOLyLam7PYQOTvrqp1Li5GHxgC/2UlbqGPcpbWgg3U0FvJYcik?=
 =?us-ascii?Q?i1lVWVvdEJT45oTxs6BTZWOYRYnuwyj3+EJCIfzPwljf4K7jQBYcnsZApD39?=
 =?us-ascii?Q?bEw2WTZVYgi3r0n0SIfZAjNHyRM+ViaT1bXmviQn7x97M7OyJrdJqg1ONqKa?=
 =?us-ascii?Q?n5VMZIx3aJ8zjk4qtUF3cnF7sdcOfXB2ka7o7V7/M79d9o0apBpCyETgJRUa?=
 =?us-ascii?Q?IPJQSziDdi2v7S/2XdQNk7waNbBThL+CTo/J38ivcl49LnWadRCQoYaKFBZH?=
 =?us-ascii?Q?94HvBmLg9ggU/SRRgztZ5SkLNQCnip5PgXUCNA/sUj+HsWdipeMzd11OZv63?=
 =?us-ascii?Q?eiQPIGppSE7lbqo/5zUJSdjIxbiUok26N7p8LtFDjmvsdByB4buMw5YMV9wb?=
 =?us-ascii?Q?J5yxXgiKsnQ1ERadGKHrvSPALCb748rVn5vimIt1Rn2bb+bnUYuezFNifG1f?=
 =?us-ascii?Q?9GEAuU4VDfz8bKgqjkuMEHvTv1BelVnH4fZpNevwFogcC/iPatzYYOzIQ6y6?=
 =?us-ascii?Q?RneB/lxPJMVxjPjhktahZ2VUHQToG+YBomVb3X/a1+EjnXdZ8FhxH1skPEqW?=
 =?us-ascii?Q?GE6DGP+EcpsMfpH1W/PQbWr9WwS0zf6VYxbEFyhngNT7tzKqLszHt5FcEicH?=
 =?us-ascii?Q?4x/dl4rgpPuB/lzF7tUKHTaVTSooba0Y9+8UQS8nVjZ+nwI/mKwsegIb+IBa?=
 =?us-ascii?Q?MgLzSxSNiMjKzsbOYdT4mXxJnF4R0zlJGg+7+2UsiaA2BCfpgXUuDR7WLILu?=
 =?us-ascii?Q?vw6AS1L88f+pnfCAmdC5QMwS6Rx7eO6fdcULMuJMuEGmjyMoWSR2aPWylR+3?=
 =?us-ascii?Q?OBsnijnbBSYdygjnpROV2TpgpyRgG8ulo8ReECnvZH4X7TE2y70foVCXhwqr?=
 =?us-ascii?Q?ZXOnhVit1Am+xxO5ncxgG5zQaLk0pSh0rLklcABsuADA4YPfeHJzTHIQ5wbt?=
 =?us-ascii?Q?E+/aGK7SvJOXwzR1RONBLWP6jMBookICJI4exmxQMQZYqt5ckg0E8NnxE4Mg?=
 =?us-ascii?Q?dcys+RnW+srsbtb8cKiMa+Ustas9L5NrwJ5YnbJz++noCEEccCd4bzf+mT2m?=
 =?us-ascii?Q?6OgUdL906ulD73e9aPKIYzM1jpIQeiVYUBsNlStJuIDBUPumDYIhtz7b3Jai?=
 =?us-ascii?Q?EJOdawXsJaPSlk2mcTKby5nSQlmB57Afx1/TZhZQHcJu+fMz/+sGC37s3d4E?=
 =?us-ascii?Q?FcLH8h86zA17hODPIMESrc9yc/YJkVSkZ+5rk/tBgzyT0UjhevZMce79yFcz?=
 =?us-ascii?Q?divF+c8ozTVGB0fs7PBN84L9kKfdsXe5Ur7mYIGhTAju4sSrIaU9XQcZFxoC?=
 =?us-ascii?Q?MuD80K2mm2os4aPaTHAo2Sk22VxV/vBvgm8Tri+mXsG4z3fIuNR4WZL36Jkd?=
 =?us-ascii?Q?rRg62AXYmBK90bEfw+nrh0jjmzZ24abFlKZgO5mWsPnclVXPa8e3sPi94YvP?=
 =?us-ascii?Q?APt+YEdUlrbelcFU/cPFaJ2P3HfAI3E=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4941814-6e99-418a-d555-08da3bd88f65
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:50:53.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ei4CcLNrufGg2jkhTl88Rpi5NNaIyQdii3p3irLletzEgUOwJlkCVJskInIdgywWyjzi2eMcgFFLB1LmQUqafw==
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

