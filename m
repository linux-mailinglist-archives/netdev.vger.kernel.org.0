Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A7A517354
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbiEBP6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiEBP6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:58:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048C76155;
        Mon,  2 May 2022 08:54:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fw+Fpvr/lsXZK2OTfxfcPLmbnicou+9SAAg7OYzvhqd1lbiijZz4DD6ALU54mx20r5iXlH9c/VEv4qeDRyiUckVT22KfURsF5eM0BSkcIenXiTwxHbJEQOd7UekQ92l7o+W8CZ3x0Z4rwqmkckyFgF42vFxzua+q+mrH8eph886JPFJ2Psi7hNVEBp41eHNI8JF0JSq/pdBsr7fJ8u3wgA7u1IdFLY1W45lZSfRNoJxnaRv4RKVMlwgnB9/BH1sdxaVHOp7BZkZL9t2MrGVb5KQkm3d+lECmXh7Tz9GXSlT2EiM1bAWw6AKeERwZXds5DGRQuBXbBjRchBlowpISlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW2i10I0OQkMG+Q+7QLtzppy1vs6dsFtnZfcFhjDZcs=;
 b=G0FVulwyKop6vP2zMHBCohV1HB5f1jbTfXmQtoE1l954hPPS5lA8tZRIWZryFMSThS9JiVv8KkLBiC2fZDpInVwMh6ecN9DR6l2mEJtBvUvqGxIh5c4/KhGp5808pLoxw8+PXTbfiBWCaCGl7KUa97WmrPAewKhXmMG44UFu04MP+keBfCMSb5EFCjPxEuowoymI181qdoc22+PrZ+a24LS5SwsSOLW31wEU9+w/knDzC94Tuta3aMT8XqVcg8VPoIu36cJVyoolhoHsHvwJ81bbubkhjMEbuqCaxPFGRwcQCbMHnUGbeZ4BCP4zLMNsY9a4wDYxTOqVsaE6rStTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW2i10I0OQkMG+Q+7QLtzppy1vs6dsFtnZfcFhjDZcs=;
 b=o+lHZdgWuqtYofhDhSwFZVGaxKRVYTr2/AQhF5Djq6T6Y2NDnZD2z9mD5UW/sxVj+lGhjVJ+flv9eGOR6gzwFJx5LCNiYXVO1A++ESLgzpOi5WGpdE/DTmqltvPZahMlRPJ94bIn7fZju615mm7jf4rsNuNXpAIxzij0IEOhS9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7702.eurprd04.prod.outlook.com (2603:10a6:20b:23f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Mon, 2 May
 2022 15:54:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 15:54:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, "Y . b . Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [PATCH net-next] selftests: forwarding: add basic QoS classification test for Ocelot switches
Date:   Mon,  2 May 2022 18:54:24 +0300
Message-Id: <20220502155424.4098917-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72c0eeff-c311-43db-4d9c-08da2c5411a8
X-MS-TrafficTypeDiagnostic: AS8PR04MB7702:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB77024A025E2193FAD7FAE2D1E0C19@AS8PR04MB7702.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHvAJfw3E6YTckhEne2SLIQkfRiIvlxxnc2Hi2SxW3cmVgXP2cAmzFXmx+XE0IhWiZ2GlsTQPAVHnbvEqfhjbLeszJpI+CvNTK1pYUnS+agR4iikU8cVnvNWbuQvU0SkA4ENEAyqw42TtTGeQEm0h5xshubWHS0UX9SVlfMwSR/Jcbn63WrJHQCMsRLuftHAIQXIMnce3RO9c5KUOX+JjylbpsLFcAnxgr5UM+ePw/hqsumwkSP39OWpX18W3krnjSNMVqflE4H9DOQNA5xwBfHPRTEfyq2kIlJae6O6hR+WO1JHfDQsSixxzi3sOlfIPU0bs3fumOlDnoJPfWnOFsWaeObnYZ0MQE/XXi4Q5ZYiRnRcfyDYeYhvTM9GXKzwFznQ49FtLxPZDbg4d4lGplKVs8dFnMrTBSAZ8lUTMaWNZAsCyHhxyQs3/Nl5gPhmXnYhmtGWYVjliu/1ipm2h/F7B02WDmKjZbhuawtkCV0Qu0OOjdbk70t8fd+4rbPL4xxcBKzBw9P0md1Lm0Swng1/yxn9bAS88U/f9zP0Lvi+2liF2CLLZogqTc8iGY13AFTc/3271iyTYlJAuwh2Q8UkgH7xVzD6FsZIbsTtdNOU5WuKEMb20GtYEeibIc4atpG/0sKk+y1hcj2TTIohWjlrkwQGp4VX7mlRSIvZ+mLJENUkwU+qWCetY1EGQOOUrOUzoQvq4BA+9/NuYWM5lpX/nREn2isE9lwqAf6Fk0KDwNr85tlqAXXZK9xOMnRSOjJ3qi7mDz2tS0gi2v15oDaPfDnF2UPhrJoAcnLU+k0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(66946007)(4326008)(86362001)(186003)(8936002)(508600001)(966005)(6486002)(7416002)(44832011)(5660300002)(2616005)(6512007)(26005)(38350700002)(8676002)(38100700002)(2906002)(6916009)(6666004)(6506007)(36756003)(1076003)(52116002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lXmJw4NK6S2kDtGUSJur1GnOy2lEWi3iWaG3bg3vJRap55/Op8v7UZ544IXn?=
 =?us-ascii?Q?FnDdBV6HIlrPUL6iHZCJ4ZjGkRt6NIRL3ntUmLgDjQyces1oeAbDIaQB6AF6?=
 =?us-ascii?Q?Y3bg2kVp3UShXtYNNwLugDY2frHWmxWzxvNLmCgGXrJ2CdctivXaXyz2koA7?=
 =?us-ascii?Q?chp4de6FipKt+uUKqvWIA/4xHqHjqHp81uFYvKFAF+RG2ym4pGkSNB0GgeE1?=
 =?us-ascii?Q?vtGFEos94xbW42+WIqi9/ydJeUkHzy7ZTsV9SjpJv95H+/Pocf8zNoTOfJcU?=
 =?us-ascii?Q?a7UzjSGiiypr8K5MdQDZLbXJvUiaFhEI0KQmvFkqt/CZqN1soB0lcTWqBFMO?=
 =?us-ascii?Q?6i/l0ZQB4PvPtHag+amn8jX8WT4XbIq35rJ0oCg/3vOk3CNcAvXs8ho4RfEB?=
 =?us-ascii?Q?UtbG1rvur6XwxMDZ5xuG1kF0OzKujiQfpZS6Pw03fNnefxl51uCSNHyahlgg?=
 =?us-ascii?Q?p8+n0dXeCZXMSePySEkAQl3+S4JZu/trEb5ZrQ1z3nPAS0K/AEJP5aMTh31H?=
 =?us-ascii?Q?whWizoQ2IyHiApIXSyQyjslcjQjShhT2XuBNkqVSmO12LkmALiPkJwdsb/aV?=
 =?us-ascii?Q?G5p2PNmkTEySaDC4HCmQApXrNTdG8F+BjM/t8hM49FJqdU+ND/vHoltNSQTK?=
 =?us-ascii?Q?Osh7mEm+9Ylj6DE7r6bdtG7Sn4sAZD4iKTHbgRJYnfobnHbawg75kv5XB2yU?=
 =?us-ascii?Q?LGL5bIaAlzb+lj681myQBjLRhXsHRy/mcUbUaEb8PA7qua5aPmaI/0fqw20n?=
 =?us-ascii?Q?auj2BS6byEp69dXEB7/lXViV4uqogzQo3GBI9hYMrkX4v3VKjOoTNy5B3feH?=
 =?us-ascii?Q?U3IMH/787EYBXAiE7DlpeWjfc5MRdPqFBxWg5fiQLHD4gk/CPbjyCPSRKkOe?=
 =?us-ascii?Q?bA35JnsyFv2X0I5spXZQo7AbdJlqYba+DZwCqXhPrqGIJb0mxQgjOFvVxSrh?=
 =?us-ascii?Q?29CjDCktr0tvmC1QNnIOfiEP/F5KTC422BhD9d9HBdbQHet1J6uEQIM+3Kjx?=
 =?us-ascii?Q?DBpBo1GBytWVN5jXa78WHDDcv5VwTAIVHSVegE5e+/ZEVPzvys6EPOdm1Lr7?=
 =?us-ascii?Q?a2+hpn0tF7L4ZyCJLMBfL7rIe8x/gimOTYhzZ9aZGpLDRve17FUvru1CPa3l?=
 =?us-ascii?Q?8PQc+XPxvShewtjCRzxNk5SXzf91D5iSP8ClYVpgd/93KetCFSkLpHi1SdoR?=
 =?us-ascii?Q?uN21poAxOs84daHeJ6lVByaD39xqTGdAWB9Q8L47dpxzaIyjRy1b/fg/Ndq2?=
 =?us-ascii?Q?cjJXMI3ePD2fQbHNcOGMofwNn1VJ0yVx+2se/MQtEze85LxNOgf6xdMVr5MS?=
 =?us-ascii?Q?b4G+d/LEjAmt/MrTJp3UVBy1iteA29ouWQguFKXkrCxcRAXDb0TFMTyfoQ4i?=
 =?us-ascii?Q?eYscw3lO8xaTmfjdgNt0k3Z1I/8XN0IbAV3Yz7Q82PCbWZUxvTNTtup2wsbD?=
 =?us-ascii?Q?6lsFRw2cVzWSVmQfFy9sNb4olhOBBtiD3erBI2iDhCAO+bOk5gzY70qo0Bri?=
 =?us-ascii?Q?dWDL0b8rgmPGtytnWrgufuuOBhpCr8qQGAGCatU06SVCLjXzD3yWKXa0o7Hd?=
 =?us-ascii?Q?bXfI+w38+wgJ4ytgI4TUQw8zMDSfyCWGqJyq2mKdkykJwpr+IJQ2ULOUcShK?=
 =?us-ascii?Q?bQwwCiGWIB/xAv/WeHed5MwtnZ4A8y2kGayLnRE1+kmHaT2HFJdORReGmXZA?=
 =?us-ascii?Q?AInUj53cOfwZLx3oPE4R7Qe3cErmjruNlWBr3RRiJIN8MT9l+3h8ZJbcjEcn?=
 =?us-ascii?Q?739Zzs7P2Nd5gE6HAwZS4+dLaRy9N9s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c0eeff-c311-43db-4d9c-08da2c5411a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 15:54:41.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hsmU91aLZ+O5q4zPi/6C6P3t2HrrGJd9k/omu8CKI2/7zR5KSJ05jsattOq5khXv32MD4I+OVM7kBNf5LqDeDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test basic (port-default, VLAN PCP and IP DSCP) QoS classification for
Ocelot switches. Advanced QoS classification using tc filters is covered
by tc_flower_chains.sh in the same directory.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../selftests/drivers/net/ocelot/basic_qos.sh | 253 ++++++++++++++++++
 1 file changed, 253 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/basic_qos.sh

diff --git a/tools/testing/selftests/drivers/net/ocelot/basic_qos.sh b/tools/testing/selftests/drivers/net/ocelot/basic_qos.sh
new file mode 100755
index 000000000000..c51c83421c61
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/ocelot/basic_qos.sh
@@ -0,0 +1,253 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2022 NXP
+
+# The script is mostly generic, with the exception of the
+# ethtool per-TC counter names ("rx_green_prio_${tc}")
+
+WAIT_TIME=1
+NUM_NETIFS=4
+STABLE_MAC_ADDRS=yes
+NETIF_CREATE=no
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+
+require_command dcb
+
+h1=${NETIFS[p1]}
+swp1=${NETIFS[p2]}
+swp2=${NETIFS[p3]}
+h2=${NETIFS[p4]}
+
+H1_IPV4="192.0.2.1"
+H2_IPV4="192.0.2.2"
+H1_IPV6="2001:db8:1::1"
+H2_IPV6="2001:db8:1::2"
+
+h1_create()
+{
+	simple_if_init $h1 $H1_IPV4/24 $H1_IPV6/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 $H1_IPV4/24 $H1_IPV6/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 $H2_IPV4/24 $H2_IPV6/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 $H2_IPV4/24 $H2_IPV6/64
+}
+
+h1_vlan_create()
+{
+	local vid=$1
+
+	vlan_create $h1 $vid
+	simple_if_init $h1.$vid $H1_IPV4/24 $H1_IPV6/64
+	ip link set $h1.$vid type vlan \
+		egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7 \
+		ingress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+}
+
+h1_vlan_destroy()
+{
+	local vid=$1
+
+	simple_if_fini $h1.$vid $H1_IPV4/24 $H1_IPV6/64
+	vlan_destroy $h1 $vid
+}
+
+h2_vlan_create()
+{
+	local vid=$1
+
+	vlan_create $h2 $vid
+	simple_if_init $h2.$vid $H2_IPV4/24 $H2_IPV6/64
+	ip link set $h2.$vid type vlan \
+		egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7 \
+		ingress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+}
+
+h2_vlan_destroy()
+{
+	local vid=$1
+
+	simple_if_fini $h2.$vid $H2_IPV4/24 $H2_IPV6/64
+	vlan_destroy $h2 $vid
+}
+
+vlans_prepare()
+{
+	h1_vlan_create 100
+	h2_vlan_create 100
+
+	tc qdisc add dev ${h1}.100 clsact
+	tc filter add dev ${h1}.100 egress protocol ipv4 \
+		flower ip_proto icmp action skbedit priority 3
+	tc filter add dev ${h1}.100 egress protocol ipv6 \
+		flower ip_proto icmpv6 action skbedit priority 3
+}
+
+vlans_destroy()
+{
+	tc qdisc del dev ${h1}.100 clsact
+
+	h1_vlan_destroy 100
+	h2_vlan_destroy 100
+}
+
+switch_create()
+{
+	ip link set ${swp1} up
+	ip link set ${swp2} up
+
+	# Ports should trust VLAN PCP even with vlan_filtering=0
+	ip link add br0 type bridge
+	ip link set ${swp1} master br0
+	ip link set ${swp2} master br0
+	ip link set br0 up
+}
+
+switch_destroy()
+{
+	ip link del br0
+}
+
+setup_prepare()
+{
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+	switch_destroy
+
+	vrf_cleanup
+}
+
+dscp_cs_to_tos()
+{
+	local dscp_cs=$1
+
+	# https://datatracker.ietf.org/doc/html/rfc2474
+	# 4.2.2.1  The Class Selector Codepoints
+	echo $((${dscp_cs} << 5))
+}
+
+run_test()
+{
+	local test_name=$1; shift
+	local if_name=$1; shift
+	local tc=$1; shift
+	local tos=$1; shift
+	local counter_name="rx_green_prio_${tc}"
+	local ipv4_before
+	local ipv4_after
+	local ipv6_before
+	local ipv6_after
+
+	ipv4_before=$(ethtool_stats_get ${swp1} "${counter_name}")
+	ping_do ${if_name} $H2_IPV4 "-Q ${tos}"
+	ipv4_after=$(ethtool_stats_get ${swp1} "${counter_name}")
+
+	if [ $((${ipv4_after} - ${ipv4_before})) -lt ${PING_COUNT} ]; then
+		RET=1
+	else
+		RET=0
+	fi
+	log_test "IPv4 ${test_name}"
+
+	ipv6_before=$(ethtool_stats_get ${swp1} "${counter_name}")
+	ping_do ${if_name} $H2_IPV6 "-Q ${tos}"
+	ipv6_after=$(ethtool_stats_get ${swp1} "${counter_name}")
+
+	if [ $((${ipv6_after} - ${ipv6_before})) -lt ${PING_COUNT} ]; then
+		RET=1
+	else
+		RET=0
+	fi
+	log_test "IPv6 ${test_name}"
+}
+
+port_default_prio_get()
+{
+	local if_name=$1
+	local prio
+
+	prio="$(dcb -j app show dev ${if_name} default-prio | \
+		jq '.default_prio[]')"
+	if [ -z "${prio}" ]; then
+		prio=0
+	fi
+
+	echo ${prio}
+}
+
+test_port_default()
+{
+	local orig=$(port_default_prio_get ${swp1})
+	local dmac=$(mac_get ${h2})
+
+	dcb app replace dev ${swp1} default-prio 5
+
+	run_test "Port-default QoS classification" ${h1} 5 0
+
+	dcb app replace dev ${swp1} default-prio ${orig}
+}
+
+test_vlan_pcp()
+{
+	vlans_prepare
+
+	run_test "Trusted VLAN PCP QoS classification" ${h1}.100 3 0
+
+	vlans_destroy
+}
+
+test_ip_dscp()
+{
+	local port_default=$(port_default_prio_get ${swp1})
+	local tos=$(dscp_cs_to_tos 4)
+
+	dcb app add dev ${swp1} dscp-prio CS4:4
+	run_test "Trusted DSCP QoS classification" ${h1} 4 ${tos}
+	dcb app del dev ${swp1} dscp-prio CS4:4
+
+	vlans_prepare
+	run_test "Untrusted DSCP QoS classification follows VLAN PCP" \
+		${h1}.100 3 ${tos}
+	vlans_destroy
+
+	run_test "Untrusted DSCP QoS classification follows port default" \
+		${h1} ${port_default} ${tos}
+}
+
+trap cleanup EXIT
+
+ALL_TESTS="
+	test_port_default
+	test_vlan_pcp
+	test_ip_dscp
+"
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.25.1

