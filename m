Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0198D513CDE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiD1Uy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiD1Uy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:54:27 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5EA6E8E3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 13:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWo8i3YCdBc8rTJqPpl2OVzx873GrT50pMe5QuDkar74cMxd6CtBEsaqfL0NEgtDoAExGt6DUzrIW5zYNqn4sBy7lbtTuxqkKrHd2ZcmTrSyNactIj63iqjeou75UJn2bxyaPYDXBRswdz423tpKMWX5osjY7yHeyGQZtdytQ6+PpFTHd0xv66aVu0m0AoE8oC1c7RXMmaOetm2lav+xGDQOARA/LBYSE5lVIWUT7/wwMKlW/UEF+h/AzPMNUKx2MERfHByS2xaz33LexPGIyU+R3WDjFsttVQtvcZoRD1eJjVfVASpEbO5o++nfG5pcyLhe6b6NBoVZMR1yYN6gUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzYnd3eagidAlXlNCLytYSM/gewyc94DeEYPvBEvXGo=;
 b=HhKOs70NH7u0fG5Atayt5GwcD+kVfA7MZvVLsg++5E3P+I4Rp6FPYnrCrgzLIu1uYDlTnGA2TEfxrNRVVzH20hE4BSrmS+GaNwuh6Q+AOY3xyHVgjXbAJFST37SLn/T1SHEMgxNx1rbLgITC/8WqkH38c7jJRnFk7xYg5ruAYdrjSdfPVgpxJBlC650z/DTtbMq4X6Z1lPoWVs7TX36kc7MTYM8aJClQAc8pG+22NktN3/Ps7xlbm21OgtuPAW4V0vlL0joJuF9rQ/DcDz2xl5lXJ0o8D+7iLu7Qo6JLvtHy0LaCwnQngpOAZv4n78TDZQGIG+F9+X6LM3RPmWgT8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzYnd3eagidAlXlNCLytYSM/gewyc94DeEYPvBEvXGo=;
 b=K/CP5I1nqQHGpFkte1mDa7mMRPH97FH7GhxjAhcGf8yn3ea7Jykf3BAzvf1vb77lsFGFT5uVgehloxoTx5/8zygD927vx1PI1pevpHzRYDtbsqUU7cHf+RpW4G5UML9fNiXGr31GcovwD85sUdbyXL9KXZiR0kRqMe9Mxztkg+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5182.eurprd04.prod.outlook.com (2603:10a6:803:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 20:51:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Thu, 28 Apr 2022
 20:51:06 +0000
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
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering and Policing test for Ocelot
Date:   Thu, 28 Apr 2022 23:48:39 +0300
Message-Id: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e41efa-1144-4d76-7999-08da2958d0f6
X-MS-TrafficTypeDiagnostic: VI1PR04MB5182:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5182B8CDAC43F5CE5F0F13AAE0FD9@VI1PR04MB5182.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9H0+DP/Z7lYxwFkl4snruqfmsVIfJlD8vcO5LfV+1FMXyOIL8PGWr2Y+HzIijHQUKqkJAYwoT6U2Zp4knQU7p3jKtzyAa4mX5HBXBotb4DP25v2VOPuR9hPK2j9+O5IaKcYN/y9s6+0xaGvu3B/e86k/0Ywn95M8dFd6LtVpqEfJ2uAw7hZS15KTNSCPBjS3yZNe5ejzHoesKLhTqi6r4jN+Pf5UvdWuTBMVx3oswbaeQ38pu64FQYxk1a/yajqsw4g+xfU+KIWoJnIQGdQCN0l1t2nm+YflNXAmxevexdlFtHAZ+pKyv+pOSlCuykEHGBnnCoACa3590l0JYezWmDe/zvrjkLJh4geGm8UTf9/16ytg1am84VaZ8pzucz7Gr1bFSHqciAPoJOEky++dVWPBToDO7LPyR2l8Z7fPsSJCweuMRjh93hK1+wN1+lDymWr1t906LYgSDztlxAcipPYQCmOAyBzPcEftZ8e5Wo9BQrFDcJnvjjjqwTr7FQB8Xpi+AkpRHxcz7HJIs6zrZLrrWqFXmAIfVMGMI4S4+grCrlk0a6HAmvVDv9xOg+NxPlqLdNPMOUPVxRHbdpIK5qLt2AtbC+zNA5ps0Yl4Fiv2UYLiO9Mhel85g4hrE3BiaUucbERy0nTMSW+m7BoG4U84BBM91+DnBbEQ0931IoAjhM0aOb6VeLyy/B+ny7CrwvV6gqDYh0S4cviGoMAilNG8nUtBky101nRZ2FZFCvzfpPE28yEBy11Ew0voc4H8R6EeVK7EZbqUxHQantMzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(83380400001)(1076003)(6506007)(6666004)(6512007)(6916009)(316002)(36756003)(54906003)(86362001)(52116002)(508600001)(6486002)(966005)(2906002)(5660300002)(8676002)(44832011)(38350700002)(26005)(4326008)(66556008)(8936002)(38100700002)(30864003)(66946007)(7416002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6o627+0pkYPnpBUy73Coq1N6KprMK0prbnR1pnbI5Wf2ZE1zwY6nWJdAaI/c?=
 =?us-ascii?Q?1eutOrcNxPQ1xGi4lFghFk8xL3zhaLeqL3WqwsiOuzRzoE4l4rbsFLTpw5ZO?=
 =?us-ascii?Q?kUUIhJwxTWFpQl2NIZmYIHVEVm9hL6Iyk9QsJAzMYeC4gzJid1WMVL5lxIxF?=
 =?us-ascii?Q?Vj5X9Jl+upv8FA2FnUsU9re0+7meTWHR3+woCpMrZNvEK9TG2S1DyyQNm9yk?=
 =?us-ascii?Q?KSi3BqdaujQP5hjyk9SIQyTutC0Plx/9Wn82acYyf87aoDqn5v96Yef31iur?=
 =?us-ascii?Q?oyPSZMKQcIwKSxPTKwnKhQyHQx2mtPPslTDql3E8frZ3WWt02mTUX9UG9ttc?=
 =?us-ascii?Q?SGYIJAnZzGEqeAzPPEhXpnLUBguW4MY9iis7QKPzF1uQrTtgDcYu/SLxHKH0?=
 =?us-ascii?Q?6SZEiUFs1UXHqHbhFkwk7wwfdST7Z7LabCDoh7ttpyP9EAosaoLGasTsmV4U?=
 =?us-ascii?Q?iO5lbo2HMZAZ5/rXNmqj4Ca4iDLuMPDuUwghR558Z6FoPYXz+tmnNJUHDazn?=
 =?us-ascii?Q?+FIJKHhhQu6zUMKm1V4b0+taHlnKGTOABt8dq+HxRPrGAmdnNEx+tkSjGP7H?=
 =?us-ascii?Q?oUNiRFOjKXKfogezhVKKC8gieGopkP49kvJIQ45BRpIjVLsMy47i/9jxBC5P?=
 =?us-ascii?Q?h3B6XhXDiA2VPhBnTTezSd6OiCVnvojM5rBVzKuI05LvU0/gI5dGfxzYGjfP?=
 =?us-ascii?Q?NQobvnxVUPyP8EUhwhW+dV28BuKwFXPEF1ebzhljHUW4HFl8n3nLn9ytfXyo?=
 =?us-ascii?Q?Ph6W8YEKWniCmtT6RctJ4UReW+HFRWtFlwHFHwRRKGEVoX/LkzJnCmHHFX8O?=
 =?us-ascii?Q?fofTdXdXTSTH/Pz3nLPKqNeBVhMGT7p6uCvBP3sr9c9r7hx8dfYn7F3MBpta?=
 =?us-ascii?Q?N+1aoSdhTlWlpETCrtMX8NszVSggq9jx0vFm3XL/U3dYoeWalOqn3vreg0LT?=
 =?us-ascii?Q?6xeResd+lM+/vJjfCpOR38YyNnMO5RVk0lYMtxccWL4CjWThQi1WmNhvq78w?=
 =?us-ascii?Q?t2j+rT7be4v5H/Qlng/XknSzgeYKpmoFWzYl6COqZxa8S+7hqcLDqYuOMkh/?=
 =?us-ascii?Q?+4D3hFVC9myRg3+bxOoVcse85UQi5tSyHgQudYRFogxdCB0bnenCLDO11iCp?=
 =?us-ascii?Q?heuHcfRnJovoQ7GzzicXVS3CSPYi+CP2BbuWz4sg5MySV8qB2daIFvvHsqpf?=
 =?us-ascii?Q?zgKfXatWc0dOCkttaNLIepa/6VChLDJ0Z8v63rmWAbJ8ntTTiePsIi53vdE5?=
 =?us-ascii?Q?b/MqzW0n5GORodFBu/ptk2DIzacP4MI9ane8JouYStJJKqnpJvnCBuuXaBa4?=
 =?us-ascii?Q?WjpTYkh5cU0cgQm4IqQ43BzkNT/9brT15iCgrokwdrgJ6D5aN4C+Fko0PIyS?=
 =?us-ascii?Q?3bJFOxFWISGLcfDPmiPVBCfCvsmfk1J776SlOOsGs+T3oisMeH5G+tMjF4nP?=
 =?us-ascii?Q?kiu2C+6UCJ6q0N+XQqfYQVSkuPCTzQaCdZHvUVxJLYUi1pnb9u77bKWReuh1?=
 =?us-ascii?Q?ls+up1XHwDzvJXBDpEv6AYjGjLcPfGFLli4TLnzon0ZLL+BMuvCjTAmeUKwY?=
 =?us-ascii?Q?mTeq8oOhzGQHWJ/PCkCZqXNZ0whUAOONPZnPPFhw6NGChAWBmTqpuL0VDmw1?=
 =?us-ascii?Q?Y4DUAH/uknwF1XOpdet6dZ3NUM8VCPs43yBixtZXQV6ZcSqFIePPwvLn4sXV?=
 =?us-ascii?Q?h7jWTKDbzf9r2jm/qq48DlWm3NDI2J3ovEY6fY/XDyVL8yAB9TG0EJmyiIpS?=
 =?us-ascii?Q?8ZZA+BuJJxyG3PwzF8vtXBBDE5ZgRNE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e41efa-1144-4d76-7999-08da2958d0f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 20:51:06.7896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PB7lkzjd25JM9UZyiEnCxSxweC6EgUFZEdCb+4GcG5S8p1eK3dUPigcWSDNrO7Vb3Kzb8c3b1DKHCO4liafyQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../selftests/drivers/net/ocelot/psfp.sh      | 282 ++++++++++++++++++
 .../selftests/net/forwarding/tsn_lib.sh       | 219 ++++++++++++++
 2 files changed, 501 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/psfp.sh
 create mode 100644 tools/testing/selftests/net/forwarding/tsn_lib.sh

diff --git a/tools/testing/selftests/drivers/net/ocelot/psfp.sh b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
new file mode 100755
index 000000000000..27800a4552d7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/ocelot/psfp.sh
@@ -0,0 +1,282 @@
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
+	local expected_matches=$1
+	local packets=""
+	local drops=""
+	local stats=""
+
+	stats=$(tc -j -s filter show dev ${swp1} ingress chain $(PSFP) pref 1)
+	packets=$(echo ${stats} | jq ".[1].options.actions[].stats.packets")
+	drops=$(echo ${stats} | jq ".[1].options.actions[].stats.drops")
+
+	if ! [ "${packets}" = "${expected_matches}" ]; then
+		echo "Expected filter to match on ${expected_matches} packets but matched on ${packets} instead"
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
+	# Set up TC 6 for SO_TXTIME
+	tc qdisc replace dev ${if_name} parent 100:6 etf \
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
+run_test()
+{
+	local base_time=$1
+	local expected=$2
+	local test_name=$3
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
+	# Count all received seqid's
+	received=$(isochron report --quiet \
+		--input-file "${isochron_dat}" \
+		--printf-format "%u\n" --printf-args "q" | \
+		wc -l)
+
+	if [ "${received}" = "${expected}" ]; then
+		RET=0
+	else
+		RET=1
+		echo "Expected isochron to receive ${expected} packets but received ${received}"
+	fi
+
+	rm ${isochron_dat} 2> /dev/null
+
+	log_test "${test_name}"
+}
+
+test_gate_in_band()
+{
+	# Send packets in-band with the OPEN gate entry
+	run_test 0.000000000 ${NUM_PKTS} "In band"
+
+	psfp_filter_check ${NUM_PKTS}
+}
+
+test_gate_out_of_band()
+{
+	# Send packets in-band with the CLOSE gate entry
+	run_test 0.005000000 0 "Out of band"
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
index 000000000000..efac5badd5a0
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -0,0 +1,219 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2021-2022 NXP
+
+# Tunables
+UTC_TAI_OFFSET=37
+ISOCHRON_CPU=1
+
+# https://github.com/vladimiroltean/tsn-scripts
+# WARNING: isochron versions pre-1.0 are unstable,
+# always use the latest version
+require_command isochron
+require_command phc2sys
+require_command ptp4l
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
+		--sched-rr \
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

