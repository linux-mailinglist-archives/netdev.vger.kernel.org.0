Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDA241F103
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355004AbhJAPRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:48 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355012AbhJAPRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWohLX4hVEWHHiK9jKhOEvNlX4tB8CybreAPDEnLVIVmwxc5FK8s5lQMElRSSEb9IVuVAtcMYT6BDEb7Z/GxZbbnPKKqYGBF/s5p+WgMQm+gvZ8T8oJHwrcyUVOQwcsWYI1osYCwNQghBX7vMAAmd0+PrAfRqyg+GFsFudqOVkt4ntHSXY/CslNClDyRwVep67JJ22EDZYi0QUmKItupPnPIJV/lH3/9zCzhDSYTRoMWJWi+UN06K9StLZvBCH964TOO9kOBCuk2tzqIqGiAa1X3vATLQxYyJ8NlVtHENcxw5SFwPRn+wX+p4tdXHJNE3AbT3DlpzHsUrMLXJU4FeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5z+msfh4j7fAWBNFS+aBKb0nTrq/ibZXnEaauLgFS0=;
 b=MuzoinDuj3TNfCutp2Xv29EPEcUjrppJYH61q0ee88S/3WoBSbLgt1hGfmRsjVcpV2a7TXkqfGUgh6YvS/MvubsMQZMniffiAJwuBtlCfZG+q+DW92ISUK7SueJVY2nvxZyOVkHHGlqcBipCYiS8SRP4Mw96cEb6ssWBD53pf+eQAC77I9uNBtdPtJp6BXwDfMkdEV8yp30s77ZWKg34Mlj6yD1PWGrJARSqp0MTO2h1wKRh7iClucNpVkhLVWMyo5uVr28d05uip9L+2VGV+1kar9jLQ334PZJaIMBlBbmz3loO/KuB9drb4oG+BlJDXbhvWQRAPfFWJVlVgeLQVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5z+msfh4j7fAWBNFS+aBKb0nTrq/ibZXnEaauLgFS0=;
 b=drKnPETEAPYHUYEVxiKt44RZr0g6rWnr/mh/Xncz8EGgHD6zRq+uuYiXJLvWSR7Yn5mjzPO8NiSDj1gNxJ0B0D8zb5zXeKmR38op96cV0FzpqR1x1C9Yt9RDCdlp38w8N4T73QJzWtuuA0xhVdqMbgvESxv53glSs5MIFY+3xCA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 6/6] selftests: net: mscc: ocelot: add a test for egress VLAN modification
Date:   Fri,  1 Oct 2021 18:15:31 +0300
Message-Id: <20211001151531.2840873-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57be06b4-799a-4a33-acc6-08d984ee5a11
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB422414147D12B65751A90394E0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/88m1apXjpEOj8cUNFk+m52u4afNp1FFiIIKYP628K0uRGgTcYAAvF/QW4SiZWecATTRZSwrvUg0GMSnkwleaj7cOey+GPhvlQVx0JhZVHYrjGzZdYntmzqGykSalFNnsKjVcs3gALCbQ9jwUhgC4QEwpOg7gTMgFawncSzxYydfw/GKxSth1NjQWd+EEtI0UbxCGNmSYz/LP2rZp85VsRhHzgj9LDjnSWbvoFU4QVy64e3yryl5L/7i3i/5Q86oB6mzNVBdnAW+2+Fu4F76a0IzuTbCSXwCu+T/Y/sjary9JrlmM0FpnaPISfe6gpW/F03UmCI0CwDS5o0VpyBBSgFTs/0P4tGPvOQJugdzMkq2LDh5JXLmDcEbOaz641APYIuR3xsNlL3JMqfe7e5akjjr757lNy/JbJxBUZOaedr+woqkkMTslmA415CRW8ZIfG+cXOvXm6qltAcpVz5WkdLHGnUYjfNv979Xuoui5/an2ZOgDtvvnAU3QoaTNuwmq+zRtuDXN8XbmQHHB9SIf5wgRQd9e3UCrMQC7tBIJ3xho4b77Z/STxLycmMePFt3KLBBDpkjFtI2qL6koSDVt8yV4t5Ahy8DCywSVJ/EyH/NEo+dt077zFsUtNrJ05RO35H/q+sHt+XCtdQawhC6ACZJMd44gckPlvj+u/fumENK8bZp7aXxDKt77tfkX9R5duXPTCPgOl9llPWvePO2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lRgghemD4pdwZFP0eO0tDJXRUZ9aJxbcGLnsTCEoGR8mLsa2cfgzTIqUYZDL?=
 =?us-ascii?Q?G6+KLOq94fgVzwqzvHgpouhGlGMMKfqD00rbulUg+Bgo1LQp268jV58Iih8u?=
 =?us-ascii?Q?YcMQ9LY4FQ2esAz5yATf8kSvMxFTjAt/NWVowpSEUfVf+HOC5yTypPfPdKRM?=
 =?us-ascii?Q?Sx5dJFwXjwrUJNNuPcaLAUs+qHSzjZMhsLkbHdT4B26To1rGG+jFIoaXOdWf?=
 =?us-ascii?Q?Y77FgdnLkmJ/Smr85wKJx8d3Cvy6gTLXA18Sw+7KV4vCxWXhHmc6M1m07UJj?=
 =?us-ascii?Q?843QzTD9mpL6fOuPIz+waVOL7dJ7gLjbE+WJBN0uc3Xj4dLNywyWA93agn6v?=
 =?us-ascii?Q?nQ4m25spp6Rj2Bj4CKURf5GQXh7ytgZZ3awt0HdB/c9CoJ0TryM2gi6ZWn2G?=
 =?us-ascii?Q?aqZhhW/BM3Xk1O2LI49195Wi9GHM/aX4klv3en/pIqXzQQDyO19ME0d4vqRT?=
 =?us-ascii?Q?wmyaTlXCIyur8nm8HuQ8wyu7zkiAAGuH2mhwxU746LcchwnnK8GpsLx/UaHK?=
 =?us-ascii?Q?2kJfDAvJyuuE1rY7jPXRtF/KjB9eZ8O7vwHBtleTdnFcv04s9dusd4BSdbeO?=
 =?us-ascii?Q?QeF5Ck+fHohggixNGb2HWwYb/4lKMrWUJNc54Y+Vrv9hWMWjfL02VW1WO794?=
 =?us-ascii?Q?UxUkoArK4pn2V2kRn4DmOxBgmtCp4JiVon+gSWHZJ21BoLHxHS6eC9krgbPk?=
 =?us-ascii?Q?yZD9v70o3KQu231PPN4BH83qsfD06wazI1RrsWuk9nAgDChz5ZnA3ExKNlg2?=
 =?us-ascii?Q?HUD663woAb4NPNYsFKwzvNfB4NunDMAdL6ASCfFvBG8A8il/gcUnseYPVtwR?=
 =?us-ascii?Q?vN5d86LMf0VIdqTzNKuIUx8O9KZhRPu5P7nQLvG4DqsYVGOK1LmlmAeEBVrj?=
 =?us-ascii?Q?AIe+HGpcD1VlSpbtueRQjQwI8OcmS5ger4C6rxs3YEXF4r7R8IOVT6F73TvS?=
 =?us-ascii?Q?Bu0y66/l2v9isQagvZU94X67LziK7kTRAwRGPkLKFYLGdNtE98sRE8qUzX20?=
 =?us-ascii?Q?MnWHwHB8vsQOxaC8AmNTI4nEwuoJoOCtoLtbYr/vFa9r2AekUxdtGWSuTXfB?=
 =?us-ascii?Q?WL2ngaaWYzVrlgP+27uuPI8TePsAA8OhCzFmPwn7AwOHDBju3XteSBZAihd0?=
 =?us-ascii?Q?FdaNhT+/P5XF0x/O8uqB+0QTh7tEmLPLZe6g5Cqu5edGzAqsrn8Kg31gKewO?=
 =?us-ascii?Q?nDUHhbvhzEcdDel4PG7oGXblLxc1atDmcteYSXYx8RavwwfPfqrZW3GwNl9W?=
 =?us-ascii?Q?7uEAnTeHLk7PPKgzm47/89u/uFoJg9rxw4OO3zQtuG0z9ePuThwfDZdTTTHQ?=
 =?us-ascii?Q?ypVW9o85SwjdLG7+Nbxlsl/O?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57be06b4-799a-4a33-acc6-08d984ee5a11
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:49.9535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRuKuZ/jL45ZHN1bMuq1PsFqnifYYCAV9GbKZFCdHAeLX+SK6BPpuGobT7aBvu9QzAqlGG7Sceej3K8VTf5ugA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For this test we are exercising the VCAP ES0 block's ability to match on
a packet with a given VLAN ID, and push an ES0 TAG A with a VID derived
from VID_A_VAL plus the classified VLAN.

$eth3.200 is the generator port
$eth0 is the bridged DUT port that receives
$eth1 is the bridged DUT port that forwards and rewrites VID 200 to 300
      on egress via VCAP ES0
$eth2 is the port that receives from the DUT port $eth1

Since the egress rewriting happens outside the bridging service, VID 300
does not need to be in the bridge VLAN table of $eth1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 4711313a92a3..eaf8a04a7ca5 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -285,6 +285,44 @@ test_vlan_ingress_modify()
 	ip link set br0 type bridge vlan_filtering 0
 }
 
+test_vlan_egress_modify()
+{
+	printf "Testing egress VLAN modification..		"
+
+	tc qdisc add dev $eth1 clsact
+
+	ip link set br0 type bridge vlan_filtering 1
+	bridge vlan add dev $eth0 vid 200
+	bridge vlan add dev $eth1 vid 200
+
+	tc filter add dev $eth1 egress chain $(ES0) pref 3 \
+		protocol 802.1Q flower skip_sw vlan_id 200 vlan_prio 0 \
+		action vlan modify id 300 priority 7
+
+	tcpdump_start $eth2
+
+	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+
+	sleep 1
+
+	tcpdump_stop
+
+	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+		echo "OK"
+	else
+		echo "FAIL"
+	fi
+
+	tcpdump_cleanup
+
+	tc filter del dev $eth1 egress chain $(ES0) pref 3
+	tc qdisc del dev $eth1 clsact
+
+	bridge vlan del dev $eth0 vid 200
+	bridge vlan del dev $eth1 vid 200
+	ip link set br0 type bridge vlan_filtering 0
+}
+
 test_skbedit_priority()
 {
 	local num_pkts=100
@@ -310,6 +348,7 @@ ALL_TESTS="
 	test_vlan_pop
 	test_vlan_push
 	test_vlan_ingress_modify
+	test_vlan_egress_modify
 	test_skbedit_priority
 "
 
-- 
2.25.1

