Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4825E516431
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346371AbiEALdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbiEALdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:33:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0051036;
        Sun,  1 May 2022 04:30:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQ9EbNpy7nl0SOM2WO5R3d8drnSxzjflK0kp+Hny/coIxnCfHhNQHOMNuTT3HE9fsLjPfzIQrre9+uZxh/a9szmroIN2V2NKH7DurYLJKwVRTsxqHBrD+sGyJYXNFlLCIGRL5RCMiMMsH3+ZSpfZRSlb2qXM79KzQOwXedq03bqDzjOOnQ96XCFkPzvD66sNERdrWTNgDsad6luLX3agSfMJAqjZSBDpUbjW53T5Sp13boEk0GbfB7snUg7M1ZBnXxccOTM3sp3d30/7s1vwiuTmLwSdvAdSBc7alAvsQhcP/jifnCr2UxWQ+9Y3CWFcRWKRCspu4oyNGPh1GunK9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBekmuOuEMIRYZT/SKnpocC70vYDZNSLXwCBxTO0Jd4=;
 b=JD0HNgzCNw2gmPPiQYeJ4082gdu3LYsywu8EONSv6kKWOiB3/hAikcqUnprBBlEGxX6ziHSuTcY25uWkUog3cgdlybJ6JrHO1AcwbE1zbglsT5/uoUYyhfNG1UB9ZFbQ/rZScvwdIsfBv12ckVWeX8MpDauMsflWDy0Kar5GMYIXUHXZ+mQ1nnB1zwT6zBN/+mo7pD0EiqyL2r6PiMzlqbs61Jn6JQ8AYfX1WkKFaVtgOdAOcWUohlZYM/6I67ujXQnpGuhgkjnCA1WlZ3KcGZ2DIEOHQj30E3kL1dMbQZ7Ku9yFTM1VFpn1MnpJjBoMBrp5R3tupJypdLYprmFlXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBekmuOuEMIRYZT/SKnpocC70vYDZNSLXwCBxTO0Jd4=;
 b=Gg+dSR+GedfA2cewR425K+qWYbTi4XXnfMtubPiaXO36fplshdoD+znjxaYYzrEqhAluY04rqNqafRnA+4ju81w5/EiJsglA7w9wpBf1MMBgd45YB1WL0mW3Ntwul//WIqYoIuFiFBIFBTyGWQKbBOTdWr/5cohXZxTbRgw9FoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5170.eurprd04.prod.outlook.com (2603:10a6:208:cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 1 May
 2022 11:30:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sun, 1 May 2022
 11:30:11 +0000
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
        UNGLinuxDriver@microchip.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [PATCH v2 net-next] selftests: forwarding: add Per-Stream Filtering and Policing test for Ocelot
Date:   Sun,  1 May 2022 14:29:53 +0300
Message-Id: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0077.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8996e43b-d6a6-4a52-2fbf-08da2b65f3c1
X-MS-TrafficTypeDiagnostic: AM0PR04MB5170:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB51700E953CAAD3C201B47D5BE0FE9@AM0PR04MB5170.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQAnUFicdkdSQ2oF71/ac1pP5W6P+qn+/y2H/FAzvL2TGePxEZrqiYUiu3PIVXpZWOFFgGJ/0n5C9eHpxkRM6SkQiXsWMPgOJEoES/+aXTbY1ebdkDCP8QbpTmH6fMJY0wXtvu2u53IJ3d8WCCoZW5lHh7/+wPb0lZIQMYo7xYTIAp8XFlc5NNOEYT72VBYK1NS/RJJ3h7uZYLQRCvSqfz5bzedIDkzNFWjyVl+r5goypRVQmbgd4rqZ/E5aPia03B9lZPoYQMMzLpIGKRvDiQdhO3bBBDT9uKnaGsywQz8cCxOWQBmelA9v/J+PD6+B+r+RDBmm9qezUUHH3aYzac7m6Pe4bx8/0binByESdGD1SFRBJwYbBWPZhE34EHjfueQ2I3TOTtNrKsvHKxtR/mxx4p3+yz+3JFWMwUIDuYJqUEL9DSDsb+RpxTRdtzKqxcVJeKiL+czDHRJZ8QD8h7oQxtcmU1YP5OhY+0Br/o2dy2TSRgXcrARZKJ/XQ6B0JKxGSaIZBPA7bKVvsTSOIp4WXdJKt6pzOykeILeelP/ZfIvbXjoYmgD4EMlqeldlCp5aaUWdQLwN5mUc6mu9di+6qm3fXjdnCpfnDwaihrLB8CPEjQ5nKNdcX4YJou7a654IX+VSCgpusz3jKUrlBvbVLO9CkMYFo56H+xMGwJ8OmSLJVz2KkX+pbZZjgKIEC0uzJW5tWMcRfuqcU75yXdxWOXllPEhNP9yCT9POKJqCqsgJrYPH0eMVLd/Uj9mr/oScBXag+HAcKIvmCC9a/qWltST08U2+pKs4xGw0P1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(30864003)(5660300002)(2616005)(38100700002)(38350700002)(66556008)(66476007)(2906002)(4326008)(6506007)(66946007)(6666004)(44832011)(6512007)(26005)(186003)(508600001)(6916009)(8936002)(52116002)(54906003)(316002)(6486002)(1076003)(86362001)(83380400001)(966005)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?585qmXal87aOrH8JqwAoRqAqfVoP4jmRRl7892NTkJucccUOPKkjm/gt9REy?=
 =?us-ascii?Q?qJ42J0/2POmv7TXQVyhwdR/5Lpmrt2FOnlVg655/LCsAwrhDXnFMo90Dl/uE?=
 =?us-ascii?Q?r+OgJd3g6HFQNzWElOd9gH8wQMq/45qM7qNTh4ohYwCp2q/lpQ9OBY3GURQB?=
 =?us-ascii?Q?f9iODrKw4pUbGBvVrwuucNrR7QXnKoMmX5oQopOooVuET45DsLk7uXGcYw26?=
 =?us-ascii?Q?7liRV8r8FI9SI5SnVCWILU6gVFZyfNuF2WfESVjwI227aZ9G8wt91yM9anPl?=
 =?us-ascii?Q?pXXj69ko7E3jWSMLSKYF/kkYb6kzcYuVX9q0DImkWe8+yXwHhLORz4EddSi+?=
 =?us-ascii?Q?K0G+5ACswVL0iEEIBkqamgAD4yo1sroE8P/SuHMaGOgeJGP2YLe9Mz/d8Rmt?=
 =?us-ascii?Q?shanLWVC6q3bKlDrxHSu/8N/K5P9EB8zlrOapYfHwVWr+gcDxoXLS2kkCIjV?=
 =?us-ascii?Q?QrrYljKqbBHIRy2cUgd7JSgc8s//VsnXDtpWrUQ4Z4Jx3hCgYRBurlVF4tJ9?=
 =?us-ascii?Q?bF9WhpWeGgG430+te6YiDP8+Zz7zobeE79dmrpfLpd3xwMqLBu1uM/vXLpQt?=
 =?us-ascii?Q?DAfyYEHEWGuDPkbp0nlNITrJlYQAuBq/VXB6+rDXe5U4xUFgvryIYnSue8c8?=
 =?us-ascii?Q?h9+hGob7fhdqS4EZSFffi0qVszZjT3brkMG925PJ5/ap+f2ON00OObxBLb8y?=
 =?us-ascii?Q?FA5CU7Q5Y56BUQPy2kl4kMggxydl+P9470xZfvmxLT1silgpQ+QEWR6l3LNZ?=
 =?us-ascii?Q?pizL1MDwDqMsZehHbd4qMVqAmmviDEJdzgr6OKE70h3XmfJQxhgBu5WMYjCb?=
 =?us-ascii?Q?uoCtdpLGW4kF0YZ9tchFqzxt8nJOcNTNWCfbwpFajfZxZSA6odNeAMNVQ0F5?=
 =?us-ascii?Q?WzIh/8S3/Afy36uoCSqr1rOmtyYlndreFNnolE8gYyvcRlzsB9v2feBBeo1x?=
 =?us-ascii?Q?Benhq4KDVqPKwmLwyrPxHb80muLT0tLTkYxO7500m+l9IbuFR/pB34MWC9Z9?=
 =?us-ascii?Q?qOUzFigNJJPBiDx+gJDahWqEqNAexyfoGUCpQdmWwFv6NG2ivyGDr0X8Ud/Y?=
 =?us-ascii?Q?DWqIA/IY+N1WZuKeF03I997SlUdD4SA2eHwEtd4BU3vyPVPS3vhQ6stcCbzT?=
 =?us-ascii?Q?UTRhUkwBSllWbDiWUSnnoYfwWo+Z2Ej3PM1cjiKA1hF9keHL9iAGt9qTKwiQ?=
 =?us-ascii?Q?Os+hnfJ87yE+YcuFVqVFN33ZsVTGhwCnlI3DhJ3HGcXVGvUpmaknAuE8CFlO?=
 =?us-ascii?Q?HRl5tfmdTFFQadi9uX6CK7N5Pnlgi5GcvL2GIfjxZ0PhAGbiAh5dIN+qZU2F?=
 =?us-ascii?Q?A5zZpddd+3cHONn7Jy+QhrkgLdQBl7/g+wUcgwdI8IGSXEkjcLZxul8RkF/R?=
 =?us-ascii?Q?zQOiUbCYZ9i0LZhM2THXjKhr+9y9GGUYvpj2g5stsw+SFz+sc0UNh7kaVnE2?=
 =?us-ascii?Q?pnK1Di807SXO16BQLCEpVTeBLvYlnMO02MSdfAQEPwHUaG3NJNImGTiQk9zY?=
 =?us-ascii?Q?uIr4sVSdRug/JG0KNtyoRBO6Y7SPT9R+0f2oB4T9HcHnQKZ8xWRMZ95AE5wf?=
 =?us-ascii?Q?MAgpp9AaE86rQh0WIemG6QgByWmmz96+LIhC0TWD/TuFa9WQh//OX8tfy8PG?=
 =?us-ascii?Q?5fu+T5QE4LjJ9yquURjhuAmy+8/gcckKE2LdaZoeyh+i8UeW/Z2pZ4jHQkeI?=
 =?us-ascii?Q?HhVUpss8MJ4Nmd1MQIpPhstAOazN9J4kgDE9DnwvpL4G03jhHtOOO+BzBsLX?=
 =?us-ascii?Q?iJPQgD8sdqNHxPZQvOqhS7i9pN1sJKc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8996e43b-d6a6-4a52-2fbf-08da2b65f3c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 11:30:11.0530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yJCpuPsoggbkKDqN1m/976fv6KxbejMNYlnNCM3w6POvtmWVVAyGEuOSnp5hVuQsAD23HJnirEJ3YmDPJS3tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5170
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
which enforced time-based access control per stream. A stream as seen by
this switch is identified by {MAC DA, VID}.

We use the standard forwarding selftest topology with 2 host interfaces
and 2 switch interfaces. The host ports must require timestamping non-IP
packets and supporting tc-etf offload, for isochron to work. The
isochron program monitors network sync status (ptp4l, phc2sys) and
deterministically transmits packets to the switch such that the tc-gate
action either (a) always accepts them based on its schedule, or
(b) always drops them.

I tried to keep as much of the logic that isn't specific to the NXP
LS1028A in a new tsn_lib.sh, for future reuse. This covers
synchronization using ptp4l and phc2sys, and isochron.

The cycle-time chosen for this selftest isn't particularly impressive
(and the focus is the functionality of the switch), but I didn't really
know what to do better, considering that it will mostly be run during
debugging sessions, various kernel bloatware would be enabled, like
lockdep, KASAN, etc, and we certainly can't run any races with those on.

I tried to look through the kselftest framework for other real time
applications and didn't really find any, so I'm not sure how better to
prepare the environment in case we want to go for a lower cycle time.
At the moment, the only thing the selftest is ensuring is that dynamic
frequency scaling is disabled on the CPU that isochron runs on. It would
probably be useful to have a blacklist of kernel config options (checked
through zcat /proc/config.gz) and some cyclictest scripts to run
beforehand, but I saw none of those.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- fix an off-by-one bug introduced at the last minute regarding which
  tc-mqprio queue was used for tc-etf and SO_TXTIME
- introduce debugging for packets incorrectly received / incorrectly
  dropped based on "isochron report"
- make the tsn_lib.sh dependency on isochron and linuxptp optional via
  REQUIRE_ISOCHRON and REQUIRE_LINUXPTP
- avoid errors when CONFIG_CPU_FREQ is disabled
- consistently use SCHED_FIFO instead of SCHED_RR for the isochron
  receiver

 .../selftests/drivers/net/ocelot/psfp.sh      | 327 ++++++++++++++++++
 .../selftests/net/forwarding/tsn_lib.sh       | 235 +++++++++++++
 2 files changed, 562 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/psfp.sh
 create mode 100644 tools/testing/selftests/net/forwarding/tsn_lib.sh

diff --git a/tools/testing/selftests/drivers/net/ocelot/psfp.sh b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
new file mode 100755
index 000000000000..5a5cee92c665
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
@@ -0,0 +1,327 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2021-2022 NXP
+
+# Note: On LS1028A, in lack of enough user ports, this setup requires patching
+# the device tree to use the second CPU port as a user port
+
+WAIT_TIME=1
+NUM_NETIFS=4
+STABLE_MAC_ADDRS=yes
+NETIF_CREATE=no
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/tsn_lib.sh
+
+UDS_ADDRESS_H1="/var/run/ptp4l_h1"
+UDS_ADDRESS_SWP1="/var/run/ptp4l_swp1"
+
+# Tunables
+NUM_PKTS=1000
+STREAM_VID=100
+STREAM_PRIO=6
+# Use a conservative cycle of 10 ms to allow the test to still pass when the
+# kernel has some extra overhead like lockdep etc
+CYCLE_TIME_NS=10000000
+# Create two Gate Control List entries, one OPEN and one CLOSE, of equal
+# durations
+GATE_DURATION_NS=$((${CYCLE_TIME_NS} / 2))
+# Give 2/3 of the cycle time to user space and 1/3 to the kernel
+FUDGE_FACTOR=$((${CYCLE_TIME_NS} / 3))
+# Shift the isochron base time by half the gate time, so that packets are
+# always received by swp1 close to the middle of the time slot, to minimize
+# inaccuracies due to network sync
+SHIFT_TIME_NS=$((${GATE_DURATION_NS} / 2))
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
+# Chain number exported by the ocelot driver for
+# Per-Stream Filtering and Policing filters
+PSFP()
+{
+	echo 30000
+}
+
+psfp_chain_create()
+{
+	local if_name=$1
+
+	tc qdisc add dev $if_name clsact
+
+	tc filter add dev $if_name ingress chain 0 pref 49152 flower \
+		skip_sw action goto chain $(PSFP)
+}
+
+psfp_chain_destroy()
+{
+	local if_name=$1
+
+	tc qdisc del dev $if_name clsact
+}
+
+psfp_filter_check()
+{
+	local expected=$1
+	local packets=""
+	local drops=""
+	local stats=""
+
+	stats=$(tc -j -s filter show dev ${swp1} ingress chain $(PSFP) pref 1)
+	packets=$(echo ${stats} | jq ".[1].options.actions[].stats.packets")
+	drops=$(echo ${stats} | jq ".[1].options.actions[].stats.drops")
+
+	if ! [ "${packets}" = "${expected}" ]; then
+		printf "Expected filter to match on %d packets but matched on %d instead\n" \
+			"${expected}" "${packets}"
+	fi
+
+	echo "Hardware filter reports ${drops} drops"
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
+switch_create()
+{
+	local h2_mac_addr=$(mac_get $h2)
+
+	ip link set ${swp1} up
+	ip link set ${swp2} up
+
+	ip link add br0 type bridge vlan_filtering 1
+	ip link set ${swp1} master br0
+	ip link set ${swp2} master br0
+	ip link set br0 up
+
+	bridge vlan add dev ${swp2} vid ${STREAM_VID}
+	bridge vlan add dev ${swp1} vid ${STREAM_VID}
+	# PSFP on Ocelot requires the filter to also be added to the bridge
+	# FDB, and not be removed
+	bridge fdb add dev ${swp2} \
+		${h2_mac_addr} vlan ${STREAM_VID} static master
+
+	psfp_chain_create ${swp1}
+
+	tc filter add dev ${swp1} ingress chain $(PSFP) pref 1 \
+		protocol 802.1Q flower skip_sw \
+		dst_mac ${h2_mac_addr} vlan_id ${STREAM_VID} \
+		action gate base-time 0.000000000 \
+		sched-entry OPEN  ${GATE_DURATION_NS} -1 -1 \
+		sched-entry CLOSE ${GATE_DURATION_NS} -1 -1
+}
+
+switch_destroy()
+{
+	psfp_chain_destroy ${swp1}
+	ip link del br0
+}
+
+txtime_setup()
+{
+	local if_name=$1
+
+	tc qdisc add dev ${if_name} clsact
+	# Classify PTP on TC 7 and isochron on TC 6
+	tc filter add dev ${if_name} egress protocol 0x88f7 \
+		flower action skbedit priority 7
+	tc filter add dev ${if_name} egress protocol 802.1Q \
+		flower vlan_ethtype 0xdead action skbedit priority 6
+	tc qdisc add dev ${if_name} handle 100: parent root mqprio num_tc 8 \
+		queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
+		map 0 1 2 3 4 5 6 7 \
+		hw 1
+	# Set up TC 6 for SO_TXTIME. tc-mqprio queues count from 1.
+	tc qdisc replace dev ${if_name} parent 100:$((${STREAM_PRIO} + 1)) etf \
+		clockid CLOCK_TAI offload delta ${FUDGE_FACTOR}
+}
+
+txtime_cleanup()
+{
+	local if_name=$1
+
+	tc qdisc del dev ${if_name} root
+	tc qdisc del dev ${if_name} clsact
+}
+
+setup_prepare()
+{
+	vrf_prepare
+
+	h1_create
+	h2_create
+	switch_create
+
+	txtime_setup ${h1}
+
+	# Set up swp1 as a master PHC for h1, synchronized to the local
+	# CLOCK_REALTIME.
+	phc2sys_start ${swp1} ${UDS_ADDRESS_SWP1}
+
+	# Assumption true for LS1028A: h1 and h2 use the same PHC. So by
+	# synchronizing h1 to swp1 via PTP, h2 is also implicitly synchronized
+	# to swp1 (and both to CLOCK_REALTIME).
+	ptp4l_start ${h1} true ${UDS_ADDRESS_H1}
+	ptp4l_start ${swp1} false ${UDS_ADDRESS_SWP1}
+
+	# Make sure there are no filter matches at the beginning of the test
+	psfp_filter_check 0
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ptp4l_stop ${swp1}
+	ptp4l_stop ${h1}
+	phc2sys_stop
+	isochron_recv_stop
+
+	txtime_cleanup ${h1}
+
+	h2_destroy
+	h1_destroy
+	switch_destroy
+
+	vrf_cleanup
+}
+
+debug_incorrectly_dropped_packets()
+{
+	local isochron_dat=$1
+	local dropped_seqids
+	local seqid
+
+	echo "Packets incorrectly dropped:"
+
+	dropped_seqids=$(isochron report \
+		--input-file "${isochron_dat}" \
+		--printf-format "%u RX hw %T\n" \
+		--printf-args "qR" | \
+		grep 'RX hw 0.000000000' | \
+		awk '{print $1}')
+
+	for seqid in ${dropped_seqids}; do
+		isochron report \
+			--input-file "${isochron_dat}" \
+			--start ${seqid} --stop ${seqid} \
+			--printf-format "seqid %u scheduled for %T, HW TX timestamp %T\n" \
+			--printf-args "qST"
+	done
+}
+
+debug_incorrectly_received_packets()
+{
+	local isochron_dat=$1
+
+	echo "Packets incorrectly received:"
+
+	isochron report \
+		--input-file "${isochron_dat}" \
+		--printf-format "seqid %u scheduled for %T, HW TX timestamp %T, HW RX timestamp %T\n" \
+		--printf-args "qSTR" |
+		grep -v 'HW RX timestamp 0.000000000'
+}
+
+run_test()
+{
+	local base_time=$1
+	local expected=$2
+	local test_name=$3
+	local debug=$4
+	local isochron_dat="$(mktemp)"
+	local extra_args=""
+	local received
+
+	isochron_do \
+		"${h1}" \
+		"${h2}" \
+		"${UDS_ADDRESS_H1}" \
+		"" \
+		"${base_time}" \
+		"${CYCLE_TIME_NS}" \
+		"${SHIFT_TIME_NS}" \
+		"${NUM_PKTS}" \
+		"${STREAM_VID}" \
+		"${STREAM_PRIO}" \
+		"" \
+		"${isochron_dat}"
+
+	# Count all received packets by looking at the non-zero RX timestamps
+	received=$(isochron report \
+		--input-file "${isochron_dat}" \
+		--printf-format "%u\n" --printf-args "R" | \
+		grep -w -v '0' | wc -l)
+
+	if [ "${received}" = "${expected}" ]; then
+		RET=0
+	else
+		RET=1
+		echo "Expected isochron to receive ${expected} packets but received ${received}"
+	fi
+
+	log_test "${test_name}"
+
+	if [ "$RET" = "1" ]; then
+		${debug} "${isochron_dat}"
+	fi
+
+	rm ${isochron_dat} 2> /dev/null
+}
+
+test_gate_in_band()
+{
+	# Send packets in-band with the OPEN gate entry
+	run_test 0.000000000 ${NUM_PKTS} "In band" \
+		debug_incorrectly_dropped_packets
+
+	psfp_filter_check ${NUM_PKTS}
+}
+
+test_gate_out_of_band()
+{
+	# Send packets in-band with the CLOSE gate entry
+	run_test 0.005000000 0 "Out of band" \
+		debug_incorrectly_received_packets
+
+	psfp_filter_check $((2 * ${NUM_PKTS}))
+}
+
+trap cleanup EXIT
+
+ALL_TESTS="
+	test_gate_in_band
+	test_gate_out_of_band
+"
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
new file mode 100644
index 000000000000..60a1423e8116
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -0,0 +1,235 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2021-2022 NXP
+
+REQUIRE_ISOCHRON=${REQUIRE_ISOCHRON:=yes}
+REQUIRE_LINUXPTP=${REQUIRE_LINUXPTP:=yes}
+
+# Tunables
+UTC_TAI_OFFSET=37
+ISOCHRON_CPU=1
+
+if [[ "$REQUIRE_ISOCHRON" = "yes" ]]; then
+	# https://github.com/vladimiroltean/tsn-scripts
+	# WARNING: isochron versions pre-1.0 are unstable,
+	# always use the latest version
+	require_command isochron
+fi
+if [[ "$REQUIRE_LINUXPTP" = "yes" ]]; then
+	require_command phc2sys
+	require_command ptp4l
+fi
+
+phc2sys_start()
+{
+	local if_name=$1
+	local uds_address=$2
+	local extra_args=""
+
+	if ! [ -z "${uds_address}" ]; then
+		extra_args="${extra_args} -z ${uds_address}"
+	fi
+
+	phc2sys_log="$(mktemp)"
+
+	chrt -f 10 phc2sys -m \
+		-c ${if_name} \
+		-s CLOCK_REALTIME \
+		-O ${UTC_TAI_OFFSET} \
+		--step_threshold 0.00002 \
+		--first_step_threshold 0.00002 \
+		${extra_args} \
+		> "${phc2sys_log}" 2>&1 &
+	phc2sys_pid=$!
+
+	echo "phc2sys logs to ${phc2sys_log} and has pid ${phc2sys_pid}"
+
+	sleep 1
+}
+
+phc2sys_stop()
+{
+	{ kill ${phc2sys_pid} && wait ${phc2sys_pid}; } 2> /dev/null
+	rm "${phc2sys_log}" 2> /dev/null
+}
+
+ptp4l_start()
+{
+	local if_name=$1
+	local slave_only=$2
+	local uds_address=$3
+	local log="ptp4l_log_${if_name}"
+	local pid="ptp4l_pid_${if_name}"
+	local extra_args=""
+
+	if [ "${slave_only}" = true ]; then
+		extra_args="${extra_args} -s"
+	fi
+
+	# declare dynamic variables ptp4l_log_${if_name} and ptp4l_pid_${if_name}
+	# as global, so that they can be referenced later
+	declare -g "${log}=$(mktemp)"
+
+	chrt -f 10 ptp4l -m -2 -P \
+		-i ${if_name} \
+		--step_threshold 0.00002 \
+		--first_step_threshold 0.00002 \
+		--tx_timestamp_timeout 100 \
+		--uds_address="${uds_address}" \
+		${extra_args} \
+		> "${!log}" 2>&1 &
+	declare -g "${pid}=$!"
+
+	echo "ptp4l for interface ${if_name} logs to ${!log} and has pid ${!pid}"
+
+	sleep 1
+}
+
+ptp4l_stop()
+{
+	local if_name=$1
+	local log="ptp4l_log_${if_name}"
+	local pid="ptp4l_pid_${if_name}"
+
+	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
+	rm "${!log}" 2> /dev/null
+}
+
+cpufreq_max()
+{
+	local cpu=$1
+	local freq="cpu${cpu}_freq"
+	local governor="cpu${cpu}_governor"
+
+	# Kernel may be compiled with CONFIG_CPU_FREQ disabled
+	if ! [ -d /sys/bus/cpu/devices/cpu${cpu}/cpufreq ]; then
+		return
+	fi
+
+	# declare dynamic variables cpu${cpu}_freq and cpu${cpu}_governor as
+	# global, so they can be referenced later
+	declare -g "${freq}=$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq)"
+	declare -g "${governor}=$(cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor)"
+
+	cat /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_max_freq > \
+		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq
+	echo -n "performance" > \
+		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
+}
+
+cpufreq_restore()
+{
+	local cpu=$1
+	local freq="cpu${cpu}_freq"
+	local governor="cpu${cpu}_governor"
+
+	if ! [ -d /sys/bus/cpu/devices/cpu${cpu}/cpufreq ]; then
+		return
+	fi
+
+	echo "${!freq}" > /sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_min_freq
+	echo -n "${!governor}" > \
+		/sys/bus/cpu/devices/cpu${cpu}/cpufreq/scaling_governor
+}
+
+isochron_recv_start()
+{
+	local if_name=$1
+	local uds=$2
+	local extra_args=$3
+
+	if ! [ -z "${uds}" ]; then
+		extra_args="--unix-domain-socket ${uds}"
+	fi
+
+	isochron rcv \
+		--interface ${if_name} \
+		--sched-priority 98 \
+		--sched-fifo \
+		--utc-tai-offset ${UTC_TAI_OFFSET} \
+		--quiet \
+		${extra_args} & \
+	isochron_pid=$!
+
+	sleep 1
+}
+
+isochron_recv_stop()
+{
+	{ kill ${isochron_pid} && wait ${isochron_pid}; } 2> /dev/null
+}
+
+isochron_do()
+{
+	local sender_if_name=$1; shift
+	local receiver_if_name=$1; shift
+	local sender_uds=$1; shift
+	local receiver_uds=$1; shift
+	local base_time=$1; shift
+	local cycle_time=$1; shift
+	local shift_time=$1; shift
+	local num_pkts=$1; shift
+	local vid=$1; shift
+	local priority=$1; shift
+	local dst_ip=$1; shift
+	local isochron_dat=$1; shift
+	local extra_args=""
+	local receiver_extra_args=""
+	local vrf="$(master_name_get ${sender_if_name})"
+	local use_l2="true"
+
+	if ! [ -z "${dst_ip}" ]; then
+		use_l2="false"
+	fi
+
+	if ! [ -z "${vrf}" ]; then
+		dst_ip="${dst_ip}%${vrf}"
+	fi
+
+	if ! [ -z "${vid}" ]; then
+		vid="--vid=${vid}"
+	fi
+
+	if [ -z "${receiver_uds}" ]; then
+		extra_args="${extra_args} --omit-remote-sync"
+	fi
+
+	if ! [ -z "${shift_time}" ]; then
+		extra_args="${extra_args} --shift-time=${shift_time}"
+	fi
+
+	if [ "${use_l2}" = "true" ]; then
+		extra_args="${extra_args} --l2 --etype=0xdead ${vid}"
+		receiver_extra_args="--l2 --etype=0xdead"
+	else
+		extra_args="${extra_args} --l4 --ip-destination=${dst_ip}"
+		receiver_extra_args="--l4"
+	fi
+
+	cpufreq_max ${ISOCHRON_CPU}
+
+	isochron_recv_start "${h2}" "${receiver_uds}" "${receiver_extra_args}"
+
+	isochron send \
+		--interface ${sender_if_name} \
+		--unix-domain-socket ${sender_uds} \
+		--priority ${priority} \
+		--base-time ${base_time} \
+		--cycle-time ${cycle_time} \
+		--num-frames ${num_pkts} \
+		--frame-size 64 \
+		--txtime \
+		--utc-tai-offset ${UTC_TAI_OFFSET} \
+		--cpu-mask $((1 << ${ISOCHRON_CPU})) \
+		--sched-fifo \
+		--sched-priority 98 \
+		--client 127.0.0.1 \
+		--sync-threshold 5000 \
+		--output-file ${isochron_dat} \
+		${extra_args} \
+		--quiet
+
+	isochron_recv_stop
+
+	cpufreq_restore ${ISOCHRON_CPU}
+}
-- 
2.25.1

