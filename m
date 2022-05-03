Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14416518484
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiECMr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiECMr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:47:27 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9887237BC2
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7YLxq9SKSCXrVm6Y8aTM5nnTRZT3nWFjhx68i/BMS0hK6fy9jQEKk92dWWlbz1uvMRLN20UC7xBlWGGrUc62OxIBKhcoUeLlO7rGLoQfD/19JwW8vTAYOX/EBIasrURSv8/acYtTtWdldN4LY5O+SgPC1GyOCa2vkGIF7QLyZ4eaguOtT5OLxZmxnbdasdTzUJfuR29e/+2q2fkeVvBF09y2u0psdPWvXZR5Zcj69uL/Mqp3Ia3xJDAm5DR58EMhj46pC/SOrHA0zYV1AQHLogdvZkmQJ7txRdn29RD4bQvYRwSr7sWiS7Sro9b87ixVi0qcyuGppl6Bp0ujuFN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiE1COJTfZGy7OsKQNNtzSgUNqX+wnaOvcM95te6Wo8=;
 b=En4vFOg91XJo6Jc2jzjm0zivwdb8raB7WqR4gRJWcHngl4zfNBIR/wWpRHTD/ATGDfyqli9SHErzj4dJoLrhx2bDiR7AVznCmFMHr5hUZKEmWOTso83u2j4WxEzU7JyKbTyvmyjzrAfAo3wFUa1br6TSt2kQ0Qe5SPbJijMXEnOHZy2trGrvb4cPy0oMPgbykCQyGxYeGTGd+Ge0YJW/sHLjr2xJGQ1ZApuH3M6X55EAMOlFv3d8jdLMts/Jz1OYuL8wTalFeIiFhDHtnSrNawxTfcwLVvsIGTdH8MjifMP3hFIoJwr8IvzI9QX1X39e+HCttdmJrxjf2qdV7wXc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiE1COJTfZGy7OsKQNNtzSgUNqX+wnaOvcM95te6Wo8=;
 b=E92/KRxvjh20T3Mbhi4v9bQP+ULaBvd5L/MlZWeEeO3Zma3vDWNYf5UAZ0TD2+EATmmPnU2Iz0vyDDmGtJteKAyaEFJWMGRh/hdeKVZbvw59eMkE8KhX5d3fBbv7MHK5aFFcszgoxEhZQuHQMa2PYoolpMVL2nUVPEpXe9fevog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 12:43:49 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:43:49 +0000
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
Subject: [PATCH net-next 3/3] selftests: ocelot: tc_flower_chains: reorder interfaces
Date:   Tue,  3 May 2022 15:43:32 +0300
Message-Id: <20220503124332.857499-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8423b3c2-9c6e-409d-35d7-08da2d02924f
X-MS-TrafficTypeDiagnostic: DBBPR04MB7675:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB76758827EE1C83FAA6C5659DE0C09@DBBPR04MB7675.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4aMHgBhaye9J3fwfAsI9Xy5/3PcVgkCe0/4793NyywAaePwbGfHB9bDhY++qT05nEoBPAFaOVuiU+Fn0d+h76WJgGfT2aKIlsQZdWC7RFFTaBlv4OTVTeca7hbaZ2IsOeqrqAqkSxTKPz53AiTBxMh5qu4yeWsnzoQQWw9ppCmhlDaNi5tMwYw90IbAahLmjz7Uj8tiLSC5YzWXZN1TvWyiisOecqXxoL0PKU8nIs16gOPbq8DFvvzY7zzt/3AWeLKLCxo8YqaVXL9gt06rzY2CdjUx88nB/+KqWKdXRcCgsUopIYoei/xSptfZUezNbjoEqdQ5InjTTfGMqQl7yVU3hS53BUgMAalBUlQI8+K/9/FaYKtf7IKUztflRkH44LPptzaJKfIZxgRJQDzsZuQAiYELM3I8sibEg7jv47Qbrxsvs4tKz6Zrnzxx7aPwGGN+FAvBgPkDN4JiGD94+X92k5wkqQ0+Z3M1Luemq5J2xxlN1SdleL8twR3QDqBnTVZVstgCywBy5Du1m4/vWyM1znkscnTacrytRsJRTH4+J9mcQOONjGmrQ7nr4ojkpUQSITGzUijCNznYdJSNNLR+sFJKT16tb/V1FArXfVjBEd75XlKyPEtI9YLCdTYdLmXM7gR/lk4kUnSrIU9ErBCBYUGOmdWDuh20QKOUhHMDbPewAwa8QK9tGXvJm2ZKHRo+ZG7C6+mFjCGSg8tSD1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(52116002)(83380400001)(6506007)(5660300002)(26005)(6512007)(316002)(86362001)(7416002)(186003)(44832011)(2616005)(36756003)(8936002)(1076003)(4326008)(6666004)(8676002)(6916009)(54906003)(66556008)(66476007)(2906002)(508600001)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j7l/k7IKCyNxXreK+WoA/7ng1ryLbMRypqDx9GjqK6ENFKYjTQX6y2y/pXj/?=
 =?us-ascii?Q?8ClvasYLHyGpnebmzIxCpRn+b08mup5vIlzxwHgoi3PivqUBQxph9hotpmpB?=
 =?us-ascii?Q?7TAyxVPhEEi9c6dPtF/4pleKf8pqHl6RS7QBSr6MzRnz8J1pUWAgBPpLUyfG?=
 =?us-ascii?Q?i63sYov2kY4HyZuEAfu9O8KN1POz4eTt4Brw1l2K1Ot3QDAuYOE23qo5i3AA?=
 =?us-ascii?Q?Av8gvNCmdECc6x44tkJK7J3YlTc0LQU4nPLROm+u6mfSR4NaSZ+urP1V3KQP?=
 =?us-ascii?Q?KGaItr8Umi7mPWt7fCt/qF1DqnC9Le8JeIiczW14/TVd9jobMGsn2SjkUPbj?=
 =?us-ascii?Q?OBjLU4if0WC1nXrveof/FF/N0+D+MxkW4WrCyKFMZtSJTX6JT7FW316Gpa2Y?=
 =?us-ascii?Q?rFEgsgytwMw9OL1wYTnBrrM6ax61V8QdHrfPk1RM9xCmOPRduzLC7MzSSm6q?=
 =?us-ascii?Q?io+vU4yi2LVV4nVFUO6V/PtoBR0gBT6DT4cSNYHKs3azDriaoYc/ABSmrR3R?=
 =?us-ascii?Q?wUr4OKdjLKfYtK16zNgTckO7jEosc7w6AOXB56bVBZmiSwyVbZLlA+Tr74SP?=
 =?us-ascii?Q?TnwiCbBLnHH0PvyVdp2Ie8THTnk4+X70tyNHwzJ+fTYl60OowwlH2n+Bv8rN?=
 =?us-ascii?Q?VzCJKcIDrYJvIzhpW9kshmCozJGXK/FIhyw1JgF86OsLiwxTat3ez6WA0v7S?=
 =?us-ascii?Q?0bkNnQxgr2PsEri9/q73ivUO+eE3ss7FoEWfBWRb4QLcvdR6LyUKzHzXtDsO?=
 =?us-ascii?Q?efsCSf2LD1gGZvc8CyGGSOe9XZWPIHtDDcjuVKaykBC+51hNMZofzHDzuoKd?=
 =?us-ascii?Q?PnN7hzjwsDPUn1O6T5d6Ep2k+/JqDb7XxWPTDpPwdtCb2PiSSZK5R6tcMNpk?=
 =?us-ascii?Q?ArzjNs96xaeN2bsdwS/neUPBYREME07pDECHNhYru0x84xjkmkLF65nAI3cQ?=
 =?us-ascii?Q?jc0ZnlJD1rlBDIHXOd7hG6LET7eiBKBCReMBcMePu6ARRTIX6Vc6cBI4252L?=
 =?us-ascii?Q?R/2pC9nLBB9hmR52uCcUHev5P91CHcE/oiMmMcZqnDPf2wZqTFAheDkDzvO7?=
 =?us-ascii?Q?xxfEIh2f5bWDB8mA7MizABIVITt5Z2DZW+BWgcj636sVVTE1uRfQ7LMUWn4r?=
 =?us-ascii?Q?TrbSuuMScBITLMzxsXdGEQkal4d6eRdLu1sF049ht0amQ+BMicDZNC17zBTr?=
 =?us-ascii?Q?oV1bxUKcA8XS837AMIfNY5lpvEZV3+kSb/iMAGqiiPwJ4yWT9ey5Fw0wer88?=
 =?us-ascii?Q?/pC7RceUZaZrOXue/sU8P46Uhl6M61WtyLgeqjbHMKdtoD5+2tlcl34kRZu9?=
 =?us-ascii?Q?s9WFHuHvfRpJ87y9WhKdK0TuhUPCW2oj+z7+CBGoAPfjFLgMYfZ6CANLaJUv?=
 =?us-ascii?Q?X9TuOJZWzjgmkYXggk8qeq1jGz110+ybfNn55IbRzC/EPNrIoVLGdNZytRDO?=
 =?us-ascii?Q?odeae9tBnOjZPuflDxVunewKU3T5Q37ZWPT9VdkCRm8FSEJTe5c9hUHcQy/A?=
 =?us-ascii?Q?QgCZ5CtIsV5cKC1mrImrXmFwxHTQ6wm2avlW3FMmDjb4FOUwfHfWOnUWRXZg?=
 =?us-ascii?Q?0Is/CWzz7J6aPYpT3M75dYFrE38Dvf9e03nds0D71nwYfovSJlmDPIQ77ng1?=
 =?us-ascii?Q?qHpxSrGUUOTYg8V1RGmHtBZR4pZRfnYaHrecKY4OyoZmo1x3xi8OvX0jj6cu?=
 =?us-ascii?Q?GVE5AaY0od7WFCAAg/ozoH3OKY52XaTD5H4Wh+xcyhXfgPfspo6EUfGp3KJy?=
 =?us-ascii?Q?59kV3+aTVqHaG51KQBqp6jdLPeYXaXY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8423b3c2-9c6e-409d-35d7-08da2d02924f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:43:49.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+Sn0XC7sYW7pBoDOnwfbWn64aTuMYo452YBS0ZFsa2T6bLjVd+aGZM9tTh8CVjiDkczA5eXNNxBJb5FbBbwag==
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

Use the standard interface order h1, swp1, swp2, h2 that is used by the
forwarding selftest framework. The previous order was confusing even
with the ASCII drawing. That isn't needed anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 38 +++++++++----------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index e67a722b2013..d04cbe217eef 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -4,36 +4,18 @@
 
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
-#   | |  swp2  | |  swp1  | |   h1   | |    h2  | |
-#   | |        | |        | |        | |        | |
-#   +-+--------+-+--------+-+--------+-+--------+-+
-#          |         |           |          |
-#          |         |           |          |
-#          |         +-----------+          |
-#          |                                |
-#          +--------------------------------+
-
-swp2=${NETIFS[p1]}
+h1=${NETIFS[p1]}
 swp1=${NETIFS[p2]}
-h1=${NETIFS[p3]}
+swp2=${NETIFS[p3]}
 h2=${NETIFS[p4]}
 
-swp2_mac="de:ad:be:ef:00:00"
-swp1_mac="de:ad:be:ef:00:01"
-h1_mac="de:ad:be:ef:00:02"
-h2_mac="de:ad:be:ef:00:03"
-
 # Helpers to map a VCAP IS1 and VCAP IS2 lookup and policy to a chain number
 # used by the kernel driver. The numbers are:
 # VCAP IS1 lookup 0:            10000
@@ -204,6 +186,9 @@ cleanup()
 
 test_vlan_pop()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	tcpdump_start $h1
@@ -227,6 +212,9 @@ test_vlan_pop()
 
 test_vlan_push()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
 	RET=0
 
 	tcpdump_start $h2.100
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
 
 	tc qdisc add dev $swp1 clsact
@@ -321,6 +315,8 @@ test_vlan_egress_modify()
 
 test_skbedit_priority()
 {
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
 	local num_pkts=100
 
 	before=$(ethtool_stats_get $swp2 'rx_green_prio_7')
-- 
2.25.1

