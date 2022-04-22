Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2850B4CB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446467AbiDVKSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiDVKSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:21 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EFC30571
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxqWeprz12jJftiMfem1K5qa7hkUU+EBdwu0fjcDScRMb5/mOIBwtUXJ0G+o6JpmaUikbY1s+o5dVZsGuf0ZEK26muqMtRPlCo+/9zSnws2fz5yCW2m7n1lOVg+yK/AqY2a3gD1q/EXACEZp9RHOd9njRDo3ZjXjHGoW4/fpk6Nrn+CUVNENT/lBIw6Yd6mHk6CGPweD1I3sSFzYtFv0SzXbGPy4MyGkiYUIp6mOD7ShukyJirnOqYtUgGTtp+EYgEREwv0RGmAX5B9o7PN7rr0qSuChud7V4BQp1xOS2inx4yZzszShyUkux8WjQTQxgh/PtiR21PzI2uA53Jjzog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jt4d+IS8gg0NxBZDCnI8FEk3BrIouluT6r4s5pkKDSo=;
 b=El4j8QjvYS+Nlu7IFEmx/Myo9dnwPKvg70IKN0ZbCme6sZ/md+Rt0bw3snwrQB39C3YEv+aDTZVujFXCmuYM8gxMLBmVJFOt2YZufw5XIUOXjKv5fpYfNGtUy4rLufPJDZ6dpOey940ArEyJ0Y0I2O9SyxBFT//EXMe5s2BftoC5kre6PFotuqfzP0HCbrZJcIZk/gcWp9tAf/fiEQ9+jddNixCN3iDSNUuQr9qq/h94QlqywZceiJntQuugmOctMi/INS9LNGc91eUqmVyEEsaDdSNHDsAJe1FIEO8jY38TPWlW3ba0W9G3Og2ik1L2RSVRHgQkhcUWSvGQnMIZzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt4d+IS8gg0NxBZDCnI8FEk3BrIouluT6r4s5pkKDSo=;
 b=CjqMnlbPHefXWj4m03JmRGum7jUpMPkjVdYE7cKr7grpzm5qXoo2LrQjfz0NDyxYbXcK7gEo7jJ9nmGhSkwbW7WfYl0Az9o0XovVLYx8QreJJSy5M9jRybrwMIYnCjtqZajOoqAXo2AI6NzLK2LZTzydEihBt8B6nkpJgUyh6o4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3856.eurprd04.prod.outlook.com (2603:10a6:803:21::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 10:15:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 6/8] selftests: forwarding: add a no_forwarding.sh test
Date:   Fri, 22 Apr 2022 13:15:02 +0300
Message-Id: <20220422101504.3729309-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dfc18a0-f365-4389-cfdc-08da24490415
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3856:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3856C790E41B1283A9B3C4D2E0F79@VI1PR0402MB3856.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vT8PY9NY0AGsCeZA9omXRzQMg4uhOcRhMIT57W618aTLWEGwPOQoaX+uKXq/eBvCVTeJYvN8P2D/+woMlqGdylr4kjsCfYW1qRG70XxT6QwdXWu7pbtuBv53oZPgEGNR645cxY6V+qU4eo+oS4P8+leIyCDLYlrkjQ3fa/eosVTolkZwPdLYW4nIWhVF8gV7C1FtYuEUYyrhMYJL6v/RKHXdgApjR3Kme0eMkfaUCpqdOD11mi8AHZ575R68XJON1JTDUR1E+59UXKu3Mwn4SSULoLER/65Jil7U67bArYfUt+8m+z3qqLcV74FMyPqeQr9nROGiNB/Jkwr5YOs11s9dh0Lwl08WbVjfOEni3on+RNePYyH57sqzSX89SgY5xMSZUWNOMXTBlkqAX/OKqGNdfUe8c5pCTTYDm3U/h2Np21fJXq8PkqVYquFz6NdalivNMg/8NCOF7uk3sVIotNv/2vptn83Kuie4XRiiaMnbns1P1NjB5CnwTOU+C1cZCAcPPgkiU0g8IuJnKt8WoYlgctREaApN62EjggJkTfhNertolm2LdBXeNU/HmFzFzMWY8HL/mZbZyO1Kq3RS7qsSFaC2fEqiYO1EgV+ilhsiGIaixhzLLZf4SQTo+ztZMxBskkdHeb7JO76OP//sk2Gl7Xysnwh9v363rVhl4SRtkw9nKFNsug53np+gXuYCLcxQn8wznOERbUZsATmzqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(36756003)(86362001)(52116002)(8936002)(2616005)(40140700001)(6666004)(6486002)(508600001)(1076003)(186003)(44832011)(26005)(38100700002)(6512007)(2906002)(316002)(38350700002)(6916009)(66556008)(66476007)(54906003)(66946007)(7416002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4LW5o6/024jVPcJ50U/13SccP1l0CwPmDzHzk0q5xw3rDR9CbkmWcGP0w20N?=
 =?us-ascii?Q?oJ+iyPO5MnkMV8FqHAhQLe5JJA5lMsas4sa065Btc8T7BArCPiTJimLan0cK?=
 =?us-ascii?Q?JZI3brobR5nPUqA1F6iZ89ZzHJLJ/FAjX93hApepcAnQVpzAs3QYetNkm48Q?=
 =?us-ascii?Q?f18TuqZHw4a/1CbTTN1QZETreisau2Zlbqv4g66PWBI4qywGD3beJs9rIu11?=
 =?us-ascii?Q?tZPCpPfv+VqFUDa3xxbDUMKgHsmXlk4JO0BWHO84JqkH2aWFQQrrQCMxJAs9?=
 =?us-ascii?Q?9S577lZxRFiz1kaqT66aNM3xF/SBMlbPzpp7et2NRz+XzdjlGQzrNsLKkDW9?=
 =?us-ascii?Q?HUPX8P7C5MuRWVrrTCgfs16Hgt2fAOzMe2B88w4w5m/+EFV96Sqp8OO9U//9?=
 =?us-ascii?Q?lFTiMPKl4keHXdddaXZPonsDBn50YUlrJAaRQ02cNf/NSjHi0eVdVemWHora?=
 =?us-ascii?Q?k1iGpSaVaZUKY7ehee+Wmjcp6ikFAiz9JXDrt5hMVDROWnqgBzIS5/mHI3bH?=
 =?us-ascii?Q?LHQPTZW9A6GJKO6t/je3i6HKaBPeifPD26kctQBLWYlrurWY/ZLgEvDos6VV?=
 =?us-ascii?Q?pF3t8En/cdDGQSSOrGkpgSb4QkkSPy1cIO0l450+wKoHBqzcv8MOUdeWqON0?=
 =?us-ascii?Q?KOV6xScvKFY5Rqmk3hWEAixn6RJoJHy2OT9z+FetBJt2lqO9hEkEBrceLgdU?=
 =?us-ascii?Q?MRV1ZcPNoWfucFgUkptLaA31DoRoBHOA7kYfC38B13mi7JS5Utg+uLw26hXZ?=
 =?us-ascii?Q?EzvYi7dAfavg5j3LB9MzqhfHipYh0kH1X/WjXcrMQ/bPxTf9tZHvoTOJ33g/?=
 =?us-ascii?Q?VydmWzp35NjabGHb4N6GWn5IYg3NArOBU5c8lewiMDEf1j1sNZ0wbTmIA3bz?=
 =?us-ascii?Q?J9gQH7S/heN3EDsgPD8LroupJp6PT3lokZFpEOZgsK7+dbkC89nIhgyZsJv5?=
 =?us-ascii?Q?I6JOuNI2qZjjfc82QSzXYlA3lp08azx3DiWMgsMmD90dZRyisBVzhMv3LQVy?=
 =?us-ascii?Q?75USFcki/D69C9rVi2cwaMemzDz5q8SRxSTb/hrtSAzdjFpvzKHPXhni78jG?=
 =?us-ascii?Q?oWibeAS9WRiG0kXodOA8HfLu6dTpZnsB2K8sgJBq3CdtmZ5yj+OtuR/i7k2e?=
 =?us-ascii?Q?YZ6r6BJyhwiQpgxuTp5tRytucOYH9ZO9LrLRD6SRy3IGo1a0OP3uV602BsZZ?=
 =?us-ascii?Q?Q8jH9X1hQVT6hW214Tmw4oL3lNJmJcj6hy4TD5NOvaHmW1vXSXg97GOA0WME?=
 =?us-ascii?Q?1VJ/ttNTXCnoYGYPuy+vR8qxWwgGIocXLHHBo11bTXq1ycb5mgZNpm35zTfW?=
 =?us-ascii?Q?O0Ru3Vk59G8NSVcPqhtW19iFBpNsXmAoA5avtL2dFRQJBozVxhWaS4HDTuuO?=
 =?us-ascii?Q?Xse3vPoHjM2PMOMdlMTgXd92iq8fPD8fjgte0eF56nLf+ACQZ4CQSOqWxgbZ?=
 =?us-ascii?Q?10lU1MWnm88+EfNhwbD9ibUEMpd/ITftTwZ6xhJKPK2BZat+UfZTWjimPERt?=
 =?us-ascii?Q?2MFzxIcbWUWfd4AF6gc3MFBP+/xD7rsUBaHdwLYpJy/+sZUataill5mBe7N3?=
 =?us-ascii?Q?0FCvkgreGcVj0km7RL5jd7qxQTmiXe1y2MO2ugnIU/05T35qAeP1U2eu+iM3?=
 =?us-ascii?Q?vmSsu/RWPoG8pyoTMdfO6RjtjyUjjgrl3kS3iEWKTVP9NsnHBzajXjjnU1Bp?=
 =?us-ascii?Q?Qp9fFE2AjRmp5FCKKDmFXmwqBAdaOPCBB5Z2iFaGFhNRyjDy7SfO6ac4n5s2?=
 =?us-ascii?Q?RvZh1f+LaP6Lc13l1cS3Oogb/vEJ0SY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfc18a0-f365-4389-cfdc-08da24490415
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:25.0315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsBP3YcA84a5o0NZPeWx7xfonIOv97i4kXslGWsq7FSXpeBKW0m3BqI9/5dod4VwjulFZ33OuGlbtKzrKeZR2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3856
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bombard a standalone switch port with various kinds of traffic to ensure
it is really standalone and doesn't leak packets to other switch ports.
Also check for switch ports in different bridges, and switch ports in a
VLAN-aware bridge but having different pvids. No forwarding should take
place in either case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../selftests/net/forwarding/no_forwarding.sh | 261 ++++++++++++++++++
 1 file changed, 261 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/no_forwarding.sh

diff --git a/tools/testing/selftests/net/forwarding/no_forwarding.sh b/tools/testing/selftests/net/forwarding/no_forwarding.sh
new file mode 100755
index 000000000000..af3b398d13f0
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/no_forwarding.sh
@@ -0,0 +1,261 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="standalone two_bridges one_bridge_two_pvids"
+NUM_NETIFS=4
+
+source lib.sh
+
+h1=${NETIFS[p1]}
+h2=${NETIFS[p3]}
+swp1=${NETIFS[p2]}
+swp2=${NETIFS[p4]}
+
+H1_IPV4="192.0.2.1"
+H2_IPV4="192.0.2.2"
+H1_IPV6="2001:db8:1::1"
+H2_IPV6="2001:db8:1::2"
+
+IPV4_ALLNODES="224.0.0.1"
+IPV6_ALLNODES="ff02::1"
+MACV4_ALLNODES="01:00:5e:00:00:01"
+MACV6_ALLNODES="33:33:00:00:00:01"
+NON_IP_MC="01:02:03:04:05:06"
+NON_IP_PKT="00:04 48:45:4c:4f"
+BC="ff:ff:ff:ff:ff:ff"
+
+# The full 4K VLAN space is too much to check, so strategically pick some
+# values which should provide reasonable coverage
+vids=(0 1 2 5 10 20 50 100 200 500 1000 1000 2000 4000 4094)
+
+send_non_ip()
+{
+	local if_name=$1
+	local smac=$2
+	local dmac=$3
+
+	$MZ -q $if_name "$dmac $smac $NON_IP_PKT"
+}
+
+send_uc_ipv4()
+{
+	local if_name=$1
+	local dmac=$2
+
+	ip neigh add $H2_IPV4 lladdr $dmac dev $if_name
+	ping_do $if_name $H2_IPV4
+	ip neigh del $H2_IPV4 dev $if_name
+}
+
+send_mc_ipv4()
+{
+	local if_name=$1
+
+	ping_do $if_name $IPV4_ALLNODES "-I $if_name"
+}
+
+send_uc_ipv6()
+{
+	local if_name=$1
+	local dmac=$2
+
+	ip -6 neigh add $H2_IPV6 lladdr $dmac dev $if_name
+	ping6_do $if_name $H2_IPV6
+	ip -6 neigh del $H2_IPV6 dev $if_name
+}
+
+send_mc_ipv6()
+{
+	local if_name=$1
+
+	ping6_do $if_name $IPV6_ALLNODES%$if_name
+}
+
+check_rcv()
+{
+	local if_name=$1
+	local type=$2
+	local pattern=$3
+	local should_fail=1
+
+	RET=0
+
+	tcpdump_show $if_name | grep -q "$pattern"
+
+	check_err_fail "$should_fail" "$?" "reception"
+
+	log_test "$type"
+}
+
+run_test()
+{
+	local test_name="$1"
+	local smac=$(mac_get $h1)
+	local dmac=$(mac_get $h2)
+	local h1_ipv6_lladdr=$(ipv6_lladdr_get $h1)
+	local vid=
+
+	echo "$test_name: Sending packets"
+
+	tcpdump_start $h2
+
+	send_non_ip $h1 $smac $dmac
+	send_non_ip $h1 $smac $NON_IP_MC
+	send_non_ip $h1 $smac $BC
+	send_uc_ipv4 $h1 $dmac
+	send_mc_ipv4 $h1
+	send_uc_ipv6 $h1 $dmac
+	send_mc_ipv6 $h1
+
+	for vid in "${vids[@]}"; do
+		vlan_create $h1 $vid
+		simple_if_init $h1.$vid $H1_IPV4/24 $H1_IPV6/64
+
+		send_non_ip $h1.$vid $smac $dmac
+		send_non_ip $h1.$vid $smac $NON_IP_MC
+		send_non_ip $h1.$vid $smac $BC
+		send_uc_ipv4 $h1.$vid $dmac
+		send_mc_ipv4 $h1.$vid
+		send_uc_ipv6 $h1.$vid $dmac
+		send_mc_ipv6 $h1.$vid
+
+		simple_if_fini $h1.$vid $H1_IPV4/24 $H1_IPV6/64
+		vlan_destroy $h1 $vid
+	done
+
+	sleep 1
+
+	echo "$test_name: Checking which packets were received"
+
+	tcpdump_stop $h2
+
+	check_rcv $h2 "$test_name: Unicast non-IP untagged" \
+		"$smac > $dmac, 802.3, length 4:"
+
+	check_rcv $h2 "$test_name: Multicast non-IP untagged" \
+		"$smac > $NON_IP_MC, 802.3, length 4:"
+
+	check_rcv $h2 "$test_name: Broadcast non-IP untagged" \
+		"$smac > $BC, 802.3, length 4:"
+
+	check_rcv $h2 "$test_name: Unicast IPv4 untagged" \
+		"$smac > $dmac, ethertype IPv4 (0x0800)"
+
+	check_rcv $h2 "$test_name: Multicast IPv4 untagged" \
+		"$smac > $MACV4_ALLNODES, ethertype IPv4 (0x0800).*: $H1_IPV4 > $IPV4_ALLNODES"
+
+	check_rcv $h2 "$test_name: Unicast IPv6 untagged" \
+		"$smac > $dmac, ethertype IPv6 (0x86dd).*8: $H1_IPV6 > $H2_IPV6"
+
+	check_rcv $h2 "$test_name: Multicast IPv6 untagged" \
+		"$smac > $MACV6_ALLNODES, ethertype IPv6 (0x86dd).*: $h1_ipv6_lladdr > $IPV6_ALLNODES"
+
+	for vid in "${vids[@]}"; do
+		check_rcv $h2 "$test_name: Unicast non-IP VID $vid" \
+			"$smac > $dmac, ethertype 802.1Q (0x8100).*vlan $vid,.*length 4"
+
+		check_rcv $h2 "$test_name: Multicast non-IP VID $vid" \
+			"$smac > $NON_IP_MC, ethertype 802.1Q (0x8100).*vlan $vid,.*length 4"
+
+		check_rcv $h2 "$test_name: Broadcast non-IP VID $vid" \
+			"$smac > $BC, ethertype 802.1Q (0x8100).*vlan $vid,.*length 4"
+
+		check_rcv $h2 "$test_name: Unicast IPv4 VID $vid" \
+			"$smac > $dmac, ethertype 802.1Q (0x8100).*vlan $vid,.*ethertype IPv4 (0x0800), $H1_IPV4 > $H2_IPV4"
+
+		check_rcv $h2 "$test_name: Multicast IPv4 VID $vid" \
+			"$smac > $MACV4_ALLNODES, ethertype 802.1Q (0x8100).*vlan $vid,.*ethertype IPv4 (0x0800), $H1_IPV4 > $IPV4_ALLNODES"
+
+		check_rcv $h2 "$test_name: Unicast IPv6 VID $vid" \
+			"$smac > $dmac, ethertype 802.1Q (0x8100).*vlan $vid,.*ethertype IPv6 (0x86dd), $H1_IPV6 > $H2_IPV6"
+
+		check_rcv $h2 "$test_name: Multicast IPv6 VID $vid" \
+			"$smac > $MACV6_ALLNODES, ethertype 802.1Q (0x8100).*vlan $vid,.*ethertype IPv6 (0x86dd), $h1_ipv6_lladdr > $IPV6_ALLNODES"
+	done
+
+	tcpdump_cleanup $h2
+}
+
+standalone()
+{
+	run_test "Standalone switch ports"
+}
+
+two_bridges()
+{
+	ip link add br0 type bridge && ip link set br0 up
+	ip link add br1 type bridge && ip link set br1 up
+	ip link set $swp1 master br0
+	ip link set $swp2 master br1
+
+	run_test "Switch ports in different bridges"
+
+	ip link del br1
+	ip link del br0
+}
+
+one_bridge_two_pvids()
+{
+	ip link add br0 type bridge vlan_filtering 1 vlan_default_pvid 0
+	ip link set br0 up
+	ip link set $swp1 master br0
+	ip link set $swp2 master br0
+
+	bridge vlan add dev $swp1 vid 1 pvid untagged
+	bridge vlan add dev $swp1 vid 2 pvid untagged
+
+	run_test "Switch ports in VLAN-aware bridge with different PVIDs"
+
+	ip link del br0
+}
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
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+setup_prepare()
+{
+	vrf_prepare
+
+	h1_create
+	h2_create
+	# we call simple_if_init from the test itself, but setup_wait expects
+	# that we call it from here, and waits until the interfaces are up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.25.1

