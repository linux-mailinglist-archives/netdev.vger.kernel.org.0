Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934F06885F2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjBBSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbjBBSBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:36 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271A379099
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:01:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lk8T1i84M9Rrf4TLArSK0Hr374FA+0Gv699OpR8QT0LpoHe90igQ2jMW0iGHKwpE2AIZzYIp6Z4+RjWZ2wthsw0+IwLfIu0PwjTIaBXUnRibUFU5kP1UGcRVcGt1G7QlDh84dMei3RcD6R6sU14yGbcoQ52J3/3Q/46gkS5OD95QNcZo95I8TvhBUewlMsRgZXL+oXCgAOrsbFQIejLTDue5SshLw5oSz3KuwMM528HUfZwlGkB7ZSDtubVNA1BDdefe2zQSTg3pI1x5+mM7fFWADMd9nZb91OZG85OfYR2spU25lUr2jbPwag4x9+b2EqYiZZDWfg1RBxUiynRO2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YS6ih+nsVXirqpLG0l62qYRNEqSRpUAo2BENdXI3/Tg=;
 b=Off58xEuButkl1D+2mB9FDl7qo6/I/TXMb8ZcYI45xjpuEn4IPr93OPDARX2cbiYbLpGqcSvAALqx8/4KDf5LaeidwJPjn49PQ/2K7UzF4ObeFOoY60x2rYyTIVUH1Uu3LNmCS3qcL1GKWnJDmbriQpdepe9Xy8rvmReQjo155DRYuj6GIJ6TjwF6uvemYNHYInOc03XOEmhhp6P8qvntpZufRf3Nj2Jolkn2wGa1Y3NnuwldVAkPeGm/YAvWbDd9sVgCC4PFuEmcxUBS9D0o1ZXLO/4/O6wDcQ8e2ngIXIKzu/fxmWCRoODIB9nXrAzaoiUze+pQEYtxZN8LsnLbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS6ih+nsVXirqpLG0l62qYRNEqSRpUAo2BENdXI3/Tg=;
 b=h30A7rmM/R2G/1gaAOn1VVs5WMY8aozApjiHnTM9tlp3R6BQEyBuH8OzSn94eaSMWjl0X+mkyEUj4VzPtAggMyAd88PE9PyoOmkWykgaYRbY6kknIRErhVCVSrLPtBvrHYmenCm4RoHBTOiCwyU3r/MPT0VnLU81SAkWD6GcQCK4rvlYbkhwaNo4mjrrl30fVcDG83Wd5GvvYFP+b/apk79mCdivjFf8IOmBN2tsQfJhsNmMt6zxkHom9hZEnxjAPrCn61NBD7P4MUYgDr2ZJvkZb3ByV6nyWCBhFsrrYUlt+rlrsnpSubhCG2Cux7yp60nxSvh1mgasQWuKMmhPMw==
Received: from MW3PR05CA0023.namprd05.prod.outlook.com (2603:10b6:303:2b::28)
 by PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 18:01:14 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::a) by MW3PR05CA0023.outlook.office365.com
 (2603:10b6:303:2b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.8 via Frontend
 Transport; Thu, 2 Feb 2023 18:01:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:01:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:59 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:56 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next v3 16/16] selftests: forwarding: bridge_mdb_max: Add a new selftest
Date:   Thu, 2 Feb 2023 18:59:34 +0100
Message-ID: <ea90ca36a55f0ec3e0f1a20418f4c9e685a7a8ab.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT028:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 686bbf97-5ea7-4176-1970-08db0547797c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqvRwqZpa8OQjpMx+v9VMiOmrYR0u9qHIkLjBMFCPsqRt9JuI6NYJ39HGMTvuqy9rqJjFYSuNiJ9ckXMFT0xfYgGbsZTPMh3RitaXzNx/hxj5mV2nvpWwDP4IbqPnNQIyymf6a88Fq/Qw/jq5xl8V8LFd0skNbKhEZtp/X0KRb3GkumX9FJeuE3kQiB0FYafPiNb0856wsuowkFWPRVaYPXO/EcjhWrNVxMibprc6Gp4kN4VHHCnVRhmIw611IG7BEwcn9K3I+wPSopuhCdc5gz5qhCZPFZnodVk1OIK8ky+ehiURlBsTb2GNtApEYR2d82zPG9oqJyCmPR0Z6t+m/yNBHyofGbTXr8yhxfiksEV8fTpIO7wIbMLa7OhKHF7BJqT3woa7NOmZV7xJ4H2SfIu7Flf4X8PUyHhAyybEXQS+YHP6offsEf2IG/o5EZ2ZSqS3voea440bMRaMYkLc8RHjMAT4ZEF/Dh5r0FiXYV+g8HLB1G9GNdC+Vvd1cP4IdhAisaYyW6huKXKvf/W67mplNPNoUXUtqmT9DrhrdvT4humuXdzl8zhlm1XKHN0xghnLxPD5PIxWzFZoQs5hve10F4/ewBM7+4Y8J7dimtWYeusVjCC3SfMc54CXh2IPZ0sZbAV3rkeqzb56ozN3dFK2aHDjpCbbAf8qBGYRDErWFMNFsZeDXlG7rr1KVZEXJatNFeTnNoj8e/0+hZzGg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(110136005)(8676002)(54906003)(2906002)(478600001)(40480700001)(316002)(41300700001)(40460700003)(8936002)(4326008)(70206006)(30864003)(70586007)(5660300002)(86362001)(356005)(36756003)(82310400005)(7636003)(47076005)(16526019)(2616005)(186003)(26005)(336012)(83380400001)(6666004)(82740400003)(426003)(36860700001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:01:14.0487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 686bbf97-5ea7-4176-1970-08db0547797c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a suite covering mcast_n_groups and mcast_max_groups bridge features.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Adjust the tests that check setting max below n and
      reset of max on VLAN snooping enablement
    - Make test naming uniform
    - Enable testing of control path (IGMP/MLD) in
      mcast_vlan_snooping bridge
    - Reorganize the code so that test instances (per bridge
      type and configuration type) always come right after
      the test, in order of {d,q,qvs}{4,6}{cfg,ctl}.
      Then groups of selftests are at the end of the file.
      Similarly adjust invocation order of the tests.

 .../testing/selftests/net/forwarding/Makefile |    1 +
 .../net/forwarding/bridge_mdb_max.sh          | 1336 +++++++++++++++++
 2 files changed, 1337 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 453ae006fbcf..91201ab3c4fc 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -4,6 +4,7 @@ TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
 	bridge_mdb.sh \
 	bridge_mdb_host.sh \
+	bridge_mdb_max.sh \
 	bridge_mdb_port_down.sh \
 	bridge_mld.sh \
 	bridge_port_isolation.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
new file mode 100755
index 000000000000..ae255b662ba3
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
@@ -0,0 +1,1336 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# | + $h1.10              |                          | + $h2.10               |
+# | | 192.0.2.1/28        |                          | | 192.0.2.2/28         |
+# | | 2001:db8:1::1/64    |                          | | 2001:db8:1::2/64     |
+# | |                     |                          | |                      |
+# | |  + $h1.20           |                          | |  + $h2.20            |
+# | \  | 198.51.100.1/24  |                          | \  | 198.51.100.2/24   |
+# |  \ | 2001:db8:2::1/64 |                          |  \ | 2001:db8:2::2/64  |
+# |   \|                  |                          |   \|                   |
+# |    + $h1              |                          |    + $h2               |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR0 (802.1q)             + $swp2           | |
+# | |     vid 10                                             vid 10         | |
+# | |     vid 20                                             vid 20         | |
+# | |                                                                       | |
+# | +-----------------------------------------------------------------------+ |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	test_8021d
+	test_8021q
+	test_8021qvs
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 10 v$h1 192.0.2.1/28 2001:db8:1::1/64
+	vlan_create $h1 20 v$h1 198.51.100.1/24 2001:db8:2::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 10 v$h2 192.0.2.2/28
+	vlan_create $h2 20 v$h2 198.51.100.2/24
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	simple_if_fini $h2
+}
+
+switch_create_8021d()
+{
+	log_info "802.1d tests"
+
+	ip link add name br0 type bridge vlan_filtering 0 \
+		mcast_snooping 1 \
+		mcast_igmp_version 3 mcast_mld_version 2
+	ip link set dev br0 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp1 up
+	bridge link set dev $swp1 fastleave on
+
+	ip link set dev $swp2 master br0
+	ip link set dev $swp2 up
+}
+
+switch_create_8021q()
+{
+	local br_flags=$1; shift
+
+	log_info "802.1q $br_flags${br_flags:+ }tests"
+
+	ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 1 $br_flags \
+		mcast_igmp_version 3 mcast_mld_version 2
+	bridge vlan add vid 10 dev br0 self
+	bridge vlan add vid 20 dev br0 self
+	ip link set dev br0 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp1 up
+	bridge link set dev $swp1 fastleave on
+	bridge vlan add vid 10 dev $swp1
+	bridge vlan add vid 20 dev $swp1
+
+	ip link set dev $swp2 master br0
+	ip link set dev $swp2 up
+	bridge vlan add vid 10 dev $swp2
+	bridge vlan add vid 20 dev $swp2
+}
+
+switch_create_8021qvs()
+{
+	switch_create_8021q "mcast_vlan_snooping 1"
+	bridge vlan global set dev br0 vid 10 mcast_igmp_version 3
+	bridge vlan global set dev br0 vid 10 mcast_mld_version 2
+	bridge vlan global set dev br0 vid 20 mcast_igmp_version 3
+	bridge vlan global set dev br0 vid 20 mcast_mld_version 2
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev br0 down
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy 2>/dev/null
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+cfg_src_list()
+{
+	local IPs=("$@")
+	local IPstr=$(echo ${IPs[@]} | tr '[:space:]' , | sed 's/,$//')
+
+	echo ${IPstr:+source_list }${IPstr}
+}
+
+cfg_group_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local GRP=$1; shift
+	local state=$1; shift
+	local IPs=("$@")
+
+	local source_list=$(cfg_src_list ${IPs[@]})
+
+	# Everything besides `bridge mdb' uses the "dev X vid Y" syntax,
+	# so we use it here as well and convert.
+	local br_locus=$(echo "$locus" | sed 's/^dev /port /')
+
+	bridge mdb $op dev br0 $br_locus grp $GRP $state \
+	       filter_mode include $source_list
+}
+
+cfg4_entries_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local GRP=239.1.1.${grp}
+	local IPs=$(seq -f 192.0.2.%g 1 $((n - 1)))
+	cfg_group_op "$op" "$locus" "$GRP" "$state" ${IPs[@]}
+}
+
+cfg4_entries_add()
+{
+	cfg4_entries_op add "$@"
+}
+
+cfg4_entries_del()
+{
+	cfg4_entries_op del "$@"
+}
+
+cfg6_entries_op()
+{
+	local op=$1; shift
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local GRP=ff0e::${grp}
+	local IPs=$(printf "2001:db8:1::%x\n" $(seq 1 $((n - 1))))
+	cfg_group_op "$op" "$locus" "$GRP" "$state" ${IPs[@]}
+}
+
+cfg6_entries_add()
+{
+	cfg6_entries_op add "$@"
+}
+
+cfg6_entries_del()
+{
+	cfg6_entries_op del "$@"
+}
+
+locus_dev_peer()
+{
+	local dev_kw=$1; shift
+	local dev=$1; shift
+	local vid_kw=$1; shift
+	local vid=$1; shift
+
+	echo "$h1.${vid:-10}"
+}
+
+locus_dev()
+{
+	local dev_kw=$1; shift
+	local dev=$1; shift
+
+	echo $dev
+}
+
+ctl4_entries_add()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local IPs=$(seq -f 192.0.2.%g 1 $((n - 1)))
+	local peer=$(locus_dev_peer $locus)
+	local GRP=239.1.1.${grp}
+	$MZ $peer -c 1 -A 192.0.2.1 -B $GRP \
+		-t ip proto=2,p=$(igmpv3_is_in_get $GRP $IPs) -q
+	sleep 1
+
+	local nn=$(bridge mdb show dev br0 | grep $GRP | wc -l)
+	if ((nn != n)); then
+		echo mcast_max_groups > /dev/stderr
+		false
+	fi
+}
+
+ctl4_entries_del()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local peer=$(locus_dev_peer $locus)
+	local GRP=239.1.1.${grp}
+	$MZ $peer -c 1 -A 192.0.2.1 -B 224.0.0.2 \
+		-t ip proto=2,p=$(igmpv2_leave_get $GRP) -q
+	sleep 1
+	! bridge mdb show dev br0 | grep -q $GRP
+}
+
+ctl6_entries_add()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local IPs=$(printf "2001:db8:1::%x\n" $(seq 1 $((n - 1))))
+	local peer=$(locus_dev_peer $locus)
+	local SIP=fe80::1
+	local GRP=ff0e::${grp}
+	local p=$(mldv2_is_in_get $SIP $GRP $IPs)
+	$MZ -6 $peer -c 1 -A $SIP -B $GRP -t ip hop=1,next=0,p="$p" -q
+	sleep 1
+
+	local nn=$(bridge mdb show dev br0 | grep $GRP | wc -l)
+	if ((nn != n)); then
+		echo mcast_max_groups > /dev/stderr
+		false
+	fi
+}
+
+ctl6_entries_del()
+{
+	local locus=$1; shift
+	local state=$1; shift
+	local n=$1; shift
+	local grp=${1:-1}; shift
+
+	local peer=$(locus_dev_peer $locus)
+	local SIP=fe80::1
+	local GRP=ff0e::${grp}
+	local p=$(mldv1_done_get $SIP $GRP)
+	$MZ -6 $peer -c 1 -A $SIP -B $GRP -t ip hop=1,next=0,p="$p" -q
+	sleep 1
+	! bridge mdb show dev br0 | grep -q $GRP
+}
+
+bridge_maxgroups_errmsg_check_cfg()
+{
+	local msg=$1; shift
+	local needle=$1; shift
+
+	echo "$msg" | grep -q mcast_max_groups
+	check_err $? "Adding MDB entries failed for the wrong reason: $msg"
+}
+
+bridge_maxgroups_errmsg_check_cfg4()
+{
+	bridge_maxgroups_errmsg_check_cfg "$@"
+}
+
+bridge_maxgroups_errmsg_check_cfg6()
+{
+	bridge_maxgroups_errmsg_check_cfg "$@"
+}
+
+bridge_maxgroups_errmsg_check_ctl4()
+{
+	:
+}
+
+bridge_maxgroups_errmsg_check_ctl6()
+{
+	:
+}
+
+bridge_port_ngroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d link show $locus |
+	    jq '.[].mcast_n_groups'
+}
+
+bridge_port_maxgroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d link show $locus |
+	    jq '.[].mcast_max_groups'
+}
+
+bridge_port_maxgroups_set()
+{
+	local locus=$1; shift
+	local max=$1; shift
+
+	bridge link set dev $(locus_dev $locus) mcast_max_groups $max
+}
+
+bridge_port_vlan_ngroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d vlan show $locus |
+	    jq '.[].vlans[].mcast_n_groups'
+}
+
+bridge_port_vlan_maxgroups_get()
+{
+	local locus=$1; shift
+
+	bridge -j -d vlan show $locus |
+	    jq '.[].vlans[].mcast_max_groups'
+}
+
+bridge_port_vlan_maxgroups_set()
+{
+	local locus=$1; shift
+	local max=$1; shift
+
+	bridge vlan set $locus mcast_max_groups $max
+}
+
+test_ngroups_reporting()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+
+	local n0=$(bridge_${context}_ngroups_get "$locus")
+	${CFG}_entries_add "$locus" temp 5
+	check_err $? "Couldn't add MDB entries"
+	local n1=$(bridge_${context}_ngroups_get "$locus")
+
+	((n1 == n0 + 5))
+	check_err $? "Number of groups was $n0, now is $n1, but $((n0 + 5)) expected"
+
+	${CFG}_entries_del "$locus" temp 5
+	check_err $? "Couldn't delete MDB entries"
+	local n2=$(bridge_${context}_ngroups_get "$locus")
+
+	((n2 == n0))
+	check_err $? "Number of groups was $n0, now is $n2, but should be back to $n0"
+
+	log_test "$CFG: $context: ngroups reporting"
+}
+
+test_8021d_ngroups_reporting_cfg4()
+{
+	test_ngroups_reporting cfg4 port "dev $swp1"
+}
+
+test_8021d_ngroups_reporting_ctl4()
+{
+	test_ngroups_reporting ctl4 port "dev $swp1"
+}
+
+test_8021d_ngroups_reporting_cfg6()
+{
+	test_ngroups_reporting cfg6 port "dev $swp1"
+}
+
+test_8021d_ngroups_reporting_ctl6()
+{
+	test_ngroups_reporting ctl6 port "dev $swp1"
+}
+
+test_8021q_ngroups_reporting_cfg4()
+{
+	test_ngroups_reporting cfg4 port "dev $swp1 vid 10"
+}
+
+test_8021q_ngroups_reporting_ctl4()
+{
+	test_ngroups_reporting ctl4 port "dev $swp1 vid 10"
+}
+
+test_8021q_ngroups_reporting_cfg6()
+{
+	test_ngroups_reporting cfg6 port "dev $swp1 vid 10"
+}
+
+test_8021q_ngroups_reporting_ctl6()
+{
+	test_ngroups_reporting ctl6 port "dev $swp1 vid 10"
+}
+
+test_8021qvs_ngroups_reporting_cfg4()
+{
+	test_ngroups_reporting cfg4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_ngroups_reporting_ctl4()
+{
+	test_ngroups_reporting ctl4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_ngroups_reporting_cfg6()
+{
+	test_ngroups_reporting cfg6 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_ngroups_reporting_ctl6()
+{
+	test_ngroups_reporting ctl6 port_vlan "dev $swp1 vid 10"
+}
+
+test_ngroups_cross_vlan()
+{
+	local CFG=$1; shift
+
+	local locus1="dev $swp1 vid 10"
+	local locus2="dev $swp1 vid 20"
+
+	RET=0
+
+	local n10=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n20=$(bridge_port_vlan_ngroups_get "$locus2")
+	${CFG}_entries_add "$locus1" temp 5 111
+	check_err $? "Couldn't add MDB entries to VLAN 10"
+	local n11=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n21=$(bridge_port_vlan_ngroups_get "$locus2")
+
+	((n11 == n10 + 5))
+	check_err $? "Number of groups at VLAN 10 was $n10, now is $n11, but 5 entries added on VLAN 10, $((n10 + 5)) expected"
+
+	((n21 == n20))
+	check_err $? "Number of groups at VLAN 20 was $n20, now is $n21, but no change expected on VLAN 20"
+
+	${CFG}_entries_add "$locus2" temp 5 112
+	check_err $? "Couldn't add MDB entries to VLAN 20"
+	local n12=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n22=$(bridge_port_vlan_ngroups_get "$locus2")
+
+	((n12 == n11))
+	check_err $? "Number of groups at VLAN 10 was $n11, now is $n12, but no change expected on VLAN 10"
+
+	((n22 == n21 + 5))
+	check_err $? "Number of groups at VLAN 20 was $n21, now is $n22, but 5 entries added on VLAN 20, $((n21 + 5)) expected"
+
+	${CFG}_entries_del "$locus1" temp 5 111
+	check_err $? "Couldn't delete MDB entries from VLAN 10"
+	${CFG}_entries_del "$locus2" temp 5 112
+	check_err $? "Couldn't delete MDB entries from VLAN 20"
+	local n13=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n23=$(bridge_port_vlan_ngroups_get "$locus2")
+
+	((n13 == n10))
+	check_err $? "Number of groups at VLAN 10 was $n10, now is $n13, but should be back to $n10"
+
+	((n23 == n20))
+	check_err $? "Number of groups at VLAN 20 was $n20, now is $n23, but should be back to $n20"
+
+	log_test "$CFG: port_vlan: isolation of port and per-VLAN ngroups"
+}
+
+test_8021qvs_ngroups_cross_vlan_cfg4()
+{
+	test_ngroups_cross_vlan cfg4
+}
+
+test_8021qvs_ngroups_cross_vlan_ctl4()
+{
+	test_ngroups_cross_vlan ctl4
+}
+
+test_8021qvs_ngroups_cross_vlan_cfg6()
+{
+	test_ngroups_cross_vlan cfg6
+}
+
+test_8021qvs_ngroups_cross_vlan_ctl6()
+{
+	test_ngroups_cross_vlan ctl6
+}
+
+test_maxgroups_zero()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+	local max
+
+	max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 0))
+	check_err $? "Max groups on $locus should be 0, but $max reported"
+
+	bridge_${context}_maxgroups_set "$locus" 100
+	check_err $? "Failed to set max to 100"
+	max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 100))
+	check_err $? "Max groups expected to be 100, but $max reported"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "Couldn't set maximum to 0"
+
+	# Test that setting 0 explicitly still serves as infinity.
+	${CFG}_entries_add "$locus" temp 5
+	check_err $? "Adding 5 MDB entries failed but should have passed"
+	${CFG}_entries_del "$locus" temp 5
+	check_err $? "Couldn't delete MDB entries"
+
+	log_test "$CFG: $context maxgroups: reporting and treatment of 0"
+}
+
+test_8021d_maxgroups_zero_cfg4()
+{
+	test_maxgroups_zero cfg4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_zero_ctl4()
+{
+	test_maxgroups_zero ctl4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_zero_cfg6()
+{
+	test_maxgroups_zero cfg6 port "dev $swp1"
+}
+
+test_8021d_maxgroups_zero_ctl6()
+{
+	test_maxgroups_zero ctl6 port "dev $swp1"
+}
+
+test_8021q_maxgroups_zero_cfg4()
+{
+	test_maxgroups_zero cfg4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_zero_ctl4()
+{
+	test_maxgroups_zero ctl4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_zero_cfg6()
+{
+	test_maxgroups_zero cfg6 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_zero_ctl6()
+{
+	test_maxgroups_zero ctl6 port "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_zero_cfg4()
+{
+	test_maxgroups_zero cfg4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_zero_ctl4()
+{
+	test_maxgroups_zero ctl4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_zero_cfg6()
+{
+	test_maxgroups_zero cfg6 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_zero_ctl6()
+{
+	test_maxgroups_zero ctl6 port_vlan "dev $swp1 vid 10"
+}
+
+test_maxgroups_zero_cross_vlan()
+{
+	local CFG=$1; shift
+
+	local locus0="dev $swp1"
+	local locus1="dev $swp1 vid 10"
+	local locus2="dev $swp1 vid 20"
+	local max
+
+	RET=0
+
+	bridge_port_vlan_maxgroups_set "$locus1" 100
+	check_err $? "$locus1: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus2" 100
+	check_err $? "$locus2: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_maxgroups_set "$locus0" 100
+	check_err $? "$locus0: Failed to set max to 100"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus1" 0
+	check_err $? "$locus1: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 100))
+	check_err $? "$locus2: Max groups expected to be 100, but $max reported"
+
+	bridge_port_vlan_maxgroups_set "$locus2" 0
+	check_err $? "$locus2: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 100))
+	check_err $? "$locus0: Max groups expected to be 100, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0 but $max reported"
+
+	bridge_port_maxgroups_set "$locus0" 0
+	check_err $? "$locus0: Failed to set max to 0"
+
+	max=$(bridge_port_maxgroups_get "$locus0")
+	((max == 0))
+	check_err $? "$locus0: Max groups expected to be 0, but $max reported"
+
+	max=$(bridge_port_vlan_maxgroups_get "$locus2")
+	((max == 0))
+	check_err $? "$locus2: Max groups expected to be 0, but $max reported"
+
+	log_test "$CFG: port_vlan maxgroups: isolation of port and per-VLAN maximums"
+}
+
+test_8021qvs_maxgroups_zero_cross_vlan_cfg4()
+{
+	test_maxgroups_zero_cross_vlan cfg4
+}
+
+test_8021qvs_maxgroups_zero_cross_vlan_ctl4()
+{
+	test_maxgroups_zero_cross_vlan ctl4
+}
+
+test_8021qvs_maxgroups_zero_cross_vlan_cfg6()
+{
+	test_maxgroups_zero_cross_vlan cfg6
+}
+
+test_8021qvs_maxgroups_zero_cross_vlan_ctl6()
+{
+	test_maxgroups_zero_cross_vlan ctl6
+}
+
+test_maxgroups_too_low()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local msg
+
+	${CFG}_entries_add "$locus" temp 5 111
+	check_err $? "$locus: Couldn't add MDB entries"
+
+	bridge_${context}_maxgroups_set "$locus" $((n+2))
+	check_err $? "$locus: Setting maxgroups to $((n+2)) failed"
+
+	msg=$(${CFG}_entries_add "$locus" temp 2 112 2>&1)
+	check_fail $? "$locus: Adding more entries passed when max<n"
+	bridge_maxgroups_errmsg_check_cfg "$msg"
+
+	${CFG}_entries_del "$locus" temp 5 111
+	check_err $? "$locus: Couldn't delete MDB entries"
+
+	${CFG}_entries_add "$locus" temp 2 112
+	check_err $? "$locus: Adding more entries failed"
+
+	${CFG}_entries_del "$locus" temp 2 112
+	check_err $? "$locus: Deleting more entries failed"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "$locus: Couldn't set maximum to 0"
+
+	log_test "$CFG: $context maxgroups: configure below ngroups"
+}
+
+test_8021d_maxgroups_too_low_cfg4()
+{
+	test_maxgroups_too_low cfg4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_low_ctl4()
+{
+	test_maxgroups_too_low ctl4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_low_cfg6()
+{
+	test_maxgroups_too_low cfg6 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_low_ctl6()
+{
+	test_maxgroups_too_low ctl6 port "dev $swp1"
+}
+
+test_8021q_maxgroups_too_low_cfg4()
+{
+	test_maxgroups_too_low cfg4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_low_ctl4()
+{
+	test_maxgroups_too_low ctl4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_low_cfg6()
+{
+	test_maxgroups_too_low cfg6 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_low_ctl6()
+{
+	test_maxgroups_too_low ctl6 port "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_low_cfg4()
+{
+	test_maxgroups_too_low cfg4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_low_ctl4()
+{
+	test_maxgroups_too_low ctl4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_low_cfg6()
+{
+	test_maxgroups_too_low cfg6 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_low_ctl6()
+{
+	test_maxgroups_too_low ctl6 port_vlan "dev $swp1 vid 10"
+}
+
+test_maxgroups_too_many_entries()
+{
+	local CFG=$1; shift
+	local context=$1; shift
+	local locus=$1; shift
+
+	RET=0
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local msg
+
+	# Configure a low maximum
+	bridge_${context}_maxgroups_set "$locus" $((n+1))
+	check_err $? "$locus: Couldn't set maximum"
+
+	# Try to add more entries than the configured maximum
+	msg=$(${CFG}_entries_add "$locus" temp 5 2>&1)
+	check_fail $? "Adding 5 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	# When adding entries through the control path, as many as possible
+	# get created. That's consistent with the mcast_hash_max behavior.
+	# So there, drop the entries explicitly.
+	if [[ ${CFG%[46]} == ctl ]]; then
+		${CFG}_entries_del "$locus" temp 17 2>&1
+	fi
+
+	local n2=$(bridge_${context}_ngroups_get "$locus")
+	((n2 == n))
+	check_err $? "Number of groups was $n, but after a failed attempt to add MDB entries it changed to $n2"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "$locus: Couldn't set maximum to 0"
+
+	log_test "$CFG: $context maxgroups: add too many MDB entries"
+}
+
+test_8021d_maxgroups_too_many_entries_cfg4()
+{
+	test_maxgroups_too_many_entries cfg4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_many_entries_ctl4()
+{
+	test_maxgroups_too_many_entries ctl4 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_many_entries_cfg6()
+{
+	test_maxgroups_too_many_entries cfg6 port "dev $swp1"
+}
+
+test_8021d_maxgroups_too_many_entries_ctl6()
+{
+	test_maxgroups_too_many_entries ctl6 port "dev $swp1"
+}
+
+test_8021q_maxgroups_too_many_entries_cfg4()
+{
+	test_maxgroups_too_many_entries cfg4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_many_entries_ctl4()
+{
+	test_maxgroups_too_many_entries ctl4 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_many_entries_cfg6()
+{
+	test_maxgroups_too_many_entries cfg6 port "dev $swp1 vid 10"
+}
+
+test_8021q_maxgroups_too_many_entries_ctl6()
+{
+	test_maxgroups_too_many_entries ctl6 port "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_many_entries_cfg4()
+{
+	test_maxgroups_too_many_entries cfg4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_many_entries_ctl4()
+{
+	test_maxgroups_too_many_entries ctl4 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_many_entries_cfg6()
+{
+	test_maxgroups_too_many_entries cfg6 port_vlan "dev $swp1 vid 10"
+}
+
+test_8021qvs_maxgroups_too_many_entries_ctl6()
+{
+	test_maxgroups_too_many_entries ctl6 port_vlan "dev $swp1 vid 10"
+}
+
+test_maxgroups_too_many_cross_vlan()
+{
+	local CFG=$1; shift
+
+	RET=0
+
+	local locus0="dev $swp1"
+	local locus1="dev $swp1 vid 10"
+	local locus2="dev $swp1 vid 20"
+	local n1=$(bridge_port_vlan_ngroups_get "$locus1")
+	local n2=$(bridge_port_vlan_ngroups_get "$locus2")
+	local msg
+
+	if ((n1 > n2)); then
+		local tmp=$n1
+		n1=$n2
+		n2=$tmp
+
+		tmp="$locus1"
+		locus1="$locus2"
+		locus2="$tmp"
+	fi
+
+	# Now 0 <= n1 <= n2.
+	${CFG}_entries_add "$locus2" temp 5 112
+	check_err $? "Couldn't add 5 entries"
+
+	n2=$(bridge_port_vlan_ngroups_get "$locus2")
+	# Now 0 <= n1 < n2-1.
+
+	# Setting locus1'maxgroups to n2-1 should pass. The number is
+	# smaller than both the absolute number of MDB entries, and in
+	# particular than number of locus2's number of entries, but it is
+	# large enough to cover locus1's entries. Thus we check that
+	# individual VLAN's ngroups are independent.
+	bridge_port_vlan_maxgroups_set "$locus1" $((n2-1))
+	check_err $? "Setting ${locus1}'s maxgroups to $((n2-1)) failed"
+
+	msg=$(${CFG}_entries_add "$locus1" temp $n2 111 2>&1)
+	check_fail $? "$locus1: Adding $n2 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	bridge_port_maxgroups_set "$locus0" $((n1 + n2 + 2))
+	check_err $? "$locus0: Couldn't set maximum"
+
+	msg=$(${CFG}_entries_add "$locus1" temp 5 111 2>&1)
+	check_fail $? "$locus1: Adding 5 MDB entries passed, but should have failed"
+	bridge_maxgroups_errmsg_check_${CFG} "$msg"
+
+	# IGMP/MLD packets can cause several entries to be added, before
+	# the maximum is hit and the rest is then bounced. Remove what was
+	# committed, if anything.
+	${CFG}_entries_del "$locus1" temp 5 111 2>/dev/null
+
+	${CFG}_entries_add "$locus1" temp 2 111
+	check_err $? "$locus1: Adding 2 MDB entries failed, but should have passed"
+
+	${CFG}_entries_del "$locus1" temp 2 111
+	check_err $? "Couldn't delete MDB entries"
+
+	${CFG}_entries_del "$locus2" temp 5 112
+	check_err $? "Couldn't delete MDB entries"
+
+	bridge_port_vlan_maxgroups_set "$locus1" 0
+	check_err $? "$locus1: Couldn't set maximum to 0"
+
+	bridge_port_maxgroups_set "$locus0" 0
+	check_err $? "$locus0: Couldn't set maximum to 0"
+
+	log_test "$CFG: port_vlan maxgroups: isolation of port and per-VLAN ngroups"
+}
+
+test_8021qvs_maxgroups_too_many_cross_vlan_cfg4()
+{
+	test_maxgroups_too_many_cross_vlan cfg4
+}
+
+test_8021qvs_maxgroups_too_many_cross_vlan_ctl4()
+{
+	test_maxgroups_too_many_cross_vlan ctl4
+}
+
+test_8021qvs_maxgroups_too_many_cross_vlan_cfg6()
+{
+	test_maxgroups_too_many_cross_vlan cfg6
+}
+
+test_8021qvs_maxgroups_too_many_cross_vlan_ctl6()
+{
+	test_maxgroups_too_many_cross_vlan ctl6
+}
+
+test_vlan_attributes()
+{
+	local locus=$1; shift
+	local expect=$1; shift
+
+	RET=0
+
+	local max=$(bridge_port_vlan_maxgroups_get "$locus")
+	local n=$(bridge_port_vlan_ngroups_get "$locus")
+
+	eval "[[ $max $expect ]]"
+	check_err $? "$locus: maxgroups attribute expected to be $expect, but was $max"
+
+	eval "[[ $n $expect ]]"
+	check_err $? "$locus: ngroups attribute expected to be $expect, but was $n"
+
+	log_test "port_vlan: presence of ngroups and maxgroups attributes"
+}
+
+test_8021q_vlan_attributes()
+{
+	test_vlan_attributes "dev $swp1 vid 10" "== null"
+}
+
+test_8021qvs_vlan_attributes()
+{
+	test_vlan_attributes "dev $swp1 vid 10" "-ge 0"
+}
+
+test_toggle_vlan_snooping()
+{
+	local mode=$1; shift
+
+	RET=0
+
+	local CFG=cfg4
+	local context=port_vlan
+	local locus="dev $swp1 vid 10"
+
+	${CFG}_entries_add "$locus" $mode 5
+	check_err $? "Couldn't add MDB entries"
+
+	bridge_${context}_maxgroups_set "$locus" 100
+	check_err $? "Failed to set max to 100"
+
+	ip link set dev br0 type bridge mcast_vlan_snooping 0
+	sleep 1
+	ip link set dev br0 type bridge mcast_vlan_snooping 1
+
+	local n=$(bridge_${context}_ngroups_get "$locus")
+	local nn=$(bridge mdb show dev br0 | grep $swp1 | wc -l)
+	((nn == n))
+	check_err $? "mcast_n_groups expected to be $nn, but $n reported"
+
+	local max=$(bridge_${context}_maxgroups_get "$locus")
+	((max == 100))
+	check_err $? "Max groups expected to be 100 but $max reported"
+
+	bridge_${context}_maxgroups_set "$locus" 0
+	check_err $? "Failed to set max to 0"
+
+	log_test "$CFG: $context: $mode: mcast_vlan_snooping toggle"
+}
+
+test_toggle_vlan_snooping_temp()
+{
+	test_toggle_vlan_snooping temp
+}
+
+test_toggle_vlan_snooping_permanent()
+{
+	test_toggle_vlan_snooping permanent
+}
+
+# ngroup test suites
+
+test_8021d_ngroups_cfg4()
+{
+	test_8021d_ngroups_reporting_cfg4
+}
+
+test_8021d_ngroups_ctl4()
+{
+	test_8021d_ngroups_reporting_ctl4
+}
+
+test_8021d_ngroups_cfg6()
+{
+	test_8021d_ngroups_reporting_cfg6
+}
+
+test_8021d_ngroups_ctl6()
+{
+	test_8021d_ngroups_reporting_ctl6
+}
+
+test_8021q_ngroups_cfg4()
+{
+	test_8021q_ngroups_reporting_cfg4
+}
+
+test_8021q_ngroups_ctl4()
+{
+	test_8021q_ngroups_reporting_ctl4
+}
+
+test_8021q_ngroups_cfg6()
+{
+	test_8021q_ngroups_reporting_cfg6
+}
+
+test_8021q_ngroups_ctl6()
+{
+	test_8021q_ngroups_reporting_ctl6
+}
+
+test_8021qvs_ngroups_cfg4()
+{
+	test_8021qvs_ngroups_reporting_cfg4
+	test_8021qvs_ngroups_cross_vlan_cfg4
+}
+
+test_8021qvs_ngroups_ctl4()
+{
+	test_8021qvs_ngroups_reporting_ctl4
+	test_8021qvs_ngroups_cross_vlan_ctl4
+}
+
+test_8021qvs_ngroups_cfg6()
+{
+	test_8021qvs_ngroups_reporting_cfg6
+	test_8021qvs_ngroups_cross_vlan_cfg6
+}
+
+test_8021qvs_ngroups_ctl6()
+{
+	test_8021qvs_ngroups_reporting_ctl6
+	test_8021qvs_ngroups_cross_vlan_ctl6
+}
+
+# maxgroups test suites
+
+test_8021d_maxgroups_cfg4()
+{
+	test_8021d_maxgroups_zero_cfg4
+	test_8021d_maxgroups_too_low_cfg4
+	test_8021d_maxgroups_too_many_entries_cfg4
+}
+
+test_8021d_maxgroups_ctl4()
+{
+	test_8021d_maxgroups_zero_ctl4
+	test_8021d_maxgroups_too_low_ctl4
+	test_8021d_maxgroups_too_many_entries_ctl4
+}
+
+test_8021d_maxgroups_cfg6()
+{
+	test_8021d_maxgroups_zero_cfg6
+	test_8021d_maxgroups_too_low_cfg6
+	test_8021d_maxgroups_too_many_entries_cfg6
+}
+
+test_8021d_maxgroups_ctl6()
+{
+	test_8021d_maxgroups_zero_ctl6
+	test_8021d_maxgroups_too_low_ctl6
+	test_8021d_maxgroups_too_many_entries_ctl6
+}
+
+test_8021q_maxgroups_cfg4()
+{
+	test_8021q_maxgroups_zero_cfg4
+	test_8021q_maxgroups_too_low_cfg4
+	test_8021q_maxgroups_too_many_entries_cfg4
+}
+
+test_8021q_maxgroups_ctl4()
+{
+	test_8021q_maxgroups_zero_ctl4
+	test_8021q_maxgroups_too_low_ctl4
+	test_8021q_maxgroups_too_many_entries_ctl4
+}
+
+test_8021q_maxgroups_cfg6()
+{
+	test_8021q_maxgroups_zero_cfg6
+	test_8021q_maxgroups_too_low_cfg6
+	test_8021q_maxgroups_too_many_entries_cfg6
+}
+
+test_8021q_maxgroups_ctl6()
+{
+	test_8021q_maxgroups_zero_ctl6
+	test_8021q_maxgroups_too_low_ctl6
+	test_8021q_maxgroups_too_many_entries_ctl6
+}
+
+test_8021qvs_maxgroups_cfg4()
+{
+	test_8021qvs_maxgroups_zero_cfg4
+	test_8021qvs_maxgroups_zero_cross_vlan_cfg4
+	test_8021qvs_maxgroups_too_low_cfg4
+	test_8021qvs_maxgroups_too_many_entries_cfg4
+	test_8021qvs_maxgroups_too_many_cross_vlan_cfg4
+}
+
+test_8021qvs_maxgroups_ctl4()
+{
+	test_8021qvs_maxgroups_zero_ctl4
+	test_8021qvs_maxgroups_zero_cross_vlan_ctl4
+	test_8021qvs_maxgroups_too_low_ctl4
+	test_8021qvs_maxgroups_too_many_entries_ctl4
+	test_8021qvs_maxgroups_too_many_cross_vlan_ctl4
+}
+
+test_8021qvs_maxgroups_cfg6()
+{
+	test_8021qvs_maxgroups_zero_cfg6
+	test_8021qvs_maxgroups_zero_cross_vlan_cfg6
+	test_8021qvs_maxgroups_too_low_cfg6
+	test_8021qvs_maxgroups_too_many_entries_cfg6
+	test_8021qvs_maxgroups_too_many_cross_vlan_cfg6
+}
+
+test_8021qvs_maxgroups_ctl6()
+{
+	test_8021qvs_maxgroups_zero_ctl6
+	test_8021qvs_maxgroups_zero_cross_vlan_ctl6
+	test_8021qvs_maxgroups_too_low_ctl6
+	test_8021qvs_maxgroups_too_many_entries_ctl6
+	test_8021qvs_maxgroups_too_many_cross_vlan_ctl6
+}
+
+# other test suites
+
+test_8021qvs_toggle_vlan_snooping()
+{
+	test_toggle_vlan_snooping_temp
+	test_toggle_vlan_snooping_permanent
+}
+
+# test groups
+
+test_8021d()
+{
+	# Tests for vlan_filtering 0 mcast_vlan_snooping 0.
+
+	switch_create_8021d
+	setup_wait
+
+	test_8021d_ngroups_cfg4
+	test_8021d_ngroups_ctl4
+	test_8021d_ngroups_cfg6
+	test_8021d_ngroups_ctl6
+	test_8021d_maxgroups_cfg4
+	test_8021d_maxgroups_ctl4
+	test_8021d_maxgroups_cfg6
+	test_8021d_maxgroups_ctl6
+
+	switch_destroy
+}
+
+test_8021q()
+{
+	# Tests for vlan_filtering 1 mcast_vlan_snooping 0.
+
+	switch_create_8021q
+	setup_wait
+
+	test_8021q_vlan_attributes
+	test_8021q_ngroups_cfg4
+	test_8021q_ngroups_ctl4
+	test_8021q_ngroups_cfg6
+	test_8021q_ngroups_ctl6
+	test_8021q_maxgroups_cfg4
+	test_8021q_maxgroups_ctl4
+	test_8021q_maxgroups_cfg6
+	test_8021q_maxgroups_ctl6
+
+	switch_destroy
+}
+
+test_8021qvs()
+{
+	# Tests for vlan_filtering 1 mcast_vlan_snooping 1.
+
+	switch_create_8021qvs
+	setup_wait
+
+	test_8021qvs_vlan_attributes
+	test_8021qvs_ngroups_cfg4
+	test_8021qvs_ngroups_ctl4
+	test_8021qvs_ngroups_cfg6
+	test_8021qvs_ngroups_ctl6
+	test_8021qvs_maxgroups_cfg4
+	test_8021qvs_maxgroups_ctl4
+	test_8021qvs_maxgroups_cfg6
+	test_8021qvs_maxgroups_ctl6
+	test_8021qvs_toggle_vlan_snooping
+
+	switch_destroy
+}
+
+trap cleanup EXIT
+
+setup_prepare
+tests_run
+
+exit $EXIT_STATUS
-- 
2.39.0

