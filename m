Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501471485F3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389834AbgAXNYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:37 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:32843 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389794AbgAXNYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 66FD621F1E;
        Fri, 24 Jan 2020 08:24:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Da7Mnd2VtstaNQA/pcyJPez0/YqQH+F8HgpQmHw6gZQ=; b=v4EMY+gM
        FzbgwXB15WyGqcmEgOmBUIfDiwkDzuLgDPAjc3bO34b9iqWfAh3v4zHZuJTEYXGK
        MkAMGrS2bnkGcsliYcSCufGE4oB2lY+7ak8IYmpArxtjLQAG1ZKVcXbj8aAtjJ9r
        arYqF3yeAR2igDpuMMvMh6t7+D2Qfb1Is9cMPBNvS3i/4a6zJ9igTvnR7wspuHqg
        vFCypss/yAXc5qTfjfcHyYyednhHNPK6JHYe7HSfpom7/NMTdX31+B/YiXAgq5o5
        b2MdAyQR4bjQiFhU3S4BMVfaTU90CR44eS+vBPiAgu7JxSB942cJR+vnmR//UdQW
        Ygxgf2LBYDVoJQ==
X-ME-Sender: <xms:E_AqXkJRfBfQF9EExJJYuGkTNP5engq8RgWv_W-qwDohBaGXM22jJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:E_AqXjAsO6X4B98gWWnlUFOr5UxXvOklgC1I2U6zu-i0czFj3a40wA>
    <xmx:E_AqXu810LMSFisUvtjZaDayPmRsKF7tBRLEvOYb_A3F2wy0U3VTLQ>
    <xmx:E_AqXntKgAcdH97UcYDpJVqX2pBmys7Yftn2otJBrKua5gbwdlX5RQ>
    <xmx:E_AqXtOkBNHsNKeVwGHSYgYO9cYCMFZgtRor3b2Yk9bc3HSET_J_xg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3CC473060F1F;
        Fri, 24 Jan 2020 08:24:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/14] selftests: mlxsw: Add a TBF selftest
Date:   Fri, 24 Jan 2020 15:23:18 +0200
Message-Id: <20200124132318.712354-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a test that runs traffic across a port throttled with TBF. The test
checks that the observed throughput is within +-5% from the installed
shaper.

To allow checking both the software datapath and the offloaded one, make
the test suitable for inclusion from driver-specific wrapper. Introduce
such wrappers for mlxsw.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/sch_tbf_ets.sh          |   9 +
 .../drivers/net/mlxsw/sch_tbf_prio.sh         |   9 +
 .../drivers/net/mlxsw/sch_tbf_root.sh         |   9 +
 .../selftests/net/forwarding/sch_tbf_core.sh  | 233 ++++++++++++++++++
 .../selftests/net/forwarding/sch_tbf_ets.sh   |   6 +
 .../net/forwarding/sch_tbf_etsprio.sh         |  39 +++
 .../selftests/net/forwarding/sch_tbf_prio.sh  |   6 +
 .../selftests/net/forwarding/sch_tbf_root.sh  |  33 +++
 8 files changed, 344 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_tbf_core.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_ets.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_prio.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_tbf_root.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
new file mode 100755
index 000000000000..c6ce0b448bf3
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source qos_lib.sh
+bail_on_lldpad
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+TCFLAGS=skip_sw
+source $lib_dir/sch_tbf_ets.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
new file mode 100755
index 000000000000..8d245f331619
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source qos_lib.sh
+bail_on_lldpad
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+TCFLAGS=skip_sw
+source $lib_dir/sch_tbf_prio.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
new file mode 100755
index 000000000000..013886061f15
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source qos_lib.sh
+bail_on_lldpad
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+TCFLAGS=skip_sw
+source $lib_dir/sch_tbf_root.sh
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_core.sh b/tools/testing/selftests/net/forwarding/sch_tbf_core.sh
new file mode 100644
index 000000000000..d1f26cb7cd73
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_core.sh
@@ -0,0 +1,233 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends a stream of traffic from H1 through a switch, to H2. On the
+# egress port from the switch ($swp2), a shaper is installed. The test verifies
+# that the rates on the port match the configured shaper.
+#
+# In order to test per-class shaping, $swp2 actually contains TBF under PRIO or
+# ETS, with two different configurations. Traffic is prioritized using 802.1p.
+#
+# +-------------------------------------------+
+# | H1                                        |
+# |     + $h1.10                  $h1.11 +    |
+# |     | 192.0.2.1/28     192.0.2.17/28 |    |
+# |     |                                |    |
+# |     \______________    _____________/     |
+# |                    \ /                    |
+# |                     + $h1                 |
+# +---------------------|---------------------+
+#                       |
+# +---------------------|---------------------+
+# | SW                  + $swp1               |
+# |     _______________/ \_______________     |
+# |    /                                 \    |
+# |  +-|--------------+   +--------------|-+  |
+# |  | + $swp1.10     |   |     $swp1.11 + |  |
+# |  |                |   |                |  |
+# |  |     BR10       |   |       BR11     |  |
+# |  |                |   |                |  |
+# |  | + $swp2.10     |   |     $swp2.11 + |  |
+# |  +-|--------------+   +--------------|-+  |
+# |    \_______________   ______________/     |
+# |                    \ /                    |
+# |                     + $swp2               |
+# +---------------------|---------------------+
+#                       |
+# +---------------------|---------------------+
+# | H2                  + $h2                 |
+# |      ______________/ \______________      |
+# |     /                               \     |
+# |     |                               |     |
+# |     + $h2.10                 $h2.11 +     |
+# |       192.0.2.2/28    192.0.2.18/28       |
+# +-------------------------------------------+
+
+NUM_NETIFS=4
+CHECK_TC="yes"
+source $lib_dir/lib.sh
+
+ipaddr()
+{
+	local host=$1; shift
+	local vlan=$1; shift
+
+	echo 192.0.2.$((16 * (vlan - 10) + host))
+}
+
+host_create()
+{
+	local dev=$1; shift
+	local host=$1; shift
+
+	simple_if_init $dev
+	mtu_set $dev 10000
+
+	vlan_create $dev 10 v$dev $(ipaddr $host 10)/28
+	ip link set dev $dev.10 type vlan egress 0:0
+
+	vlan_create $dev 11 v$dev $(ipaddr $host 11)/28
+	ip link set dev $dev.11 type vlan egress 0:1
+}
+
+host_destroy()
+{
+	local dev=$1; shift
+
+	vlan_destroy $dev 11
+	vlan_destroy $dev 10
+	mtu_restore $dev
+	simple_if_fini $dev
+}
+
+h1_create()
+{
+	host_create $h1 1
+}
+
+h1_destroy()
+{
+	host_destroy $h1
+}
+
+h2_create()
+{
+	host_create $h2 2
+
+	tc qdisc add dev $h2 clsact
+	tc filter add dev $h2 ingress pref 1010 prot 802.1q \
+	   flower $TCFLAGS vlan_id 10 action pass
+	tc filter add dev $h2 ingress pref 1011 prot 802.1q \
+	   flower $TCFLAGS vlan_id 11 action pass
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	host_destroy $h2
+}
+
+switch_create()
+{
+	local intf
+	local vlan
+
+	ip link add dev br10 type bridge
+	ip link add dev br11 type bridge
+
+	for intf in $swp1 $swp2; do
+		ip link set dev $intf up
+		mtu_set $intf 10000
+
+		for vlan in 10 11; do
+			vlan_create $intf $vlan
+			ip link set dev $intf.$vlan master br$vlan
+			ip link set dev $intf.$vlan up
+		done
+	done
+
+	for vlan in 10 11; do
+		ip link set dev $swp1.$vlan type vlan ingress 0:0 1:1
+	done
+
+	ip link set dev br10 up
+	ip link set dev br11 up
+}
+
+switch_destroy()
+{
+	local intf
+	local vlan
+
+	# A test may have been interrupted mid-run, with Qdisc installed. Delete
+	# it here.
+	tc qdisc del dev $swp2 root 2>/dev/null
+
+	ip link set dev br11 down
+	ip link set dev br10 down
+
+	for intf in $swp2 $swp1; do
+		for vlan in 11 10; do
+			ip link set dev $intf.$vlan down
+			ip link set dev $intf.$vlan nomaster
+			vlan_destroy $intf $vlan
+		done
+
+		mtu_restore $intf
+		ip link set dev $intf down
+	done
+
+	ip link del dev br11
+	ip link del dev br10
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
+	swp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
+	swp4=${NETIFS[p7]}
+	swp5=${NETIFS[p8]}
+
+	h2_mac=$(mac_get $h2)
+
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
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1.10 $(ipaddr 2 10) " vlan 10"
+	ping_test $h1.11 $(ipaddr 2 11) " vlan 11"
+}
+
+tbf_get_counter()
+{
+	local vlan=$1; shift
+
+	tc_rule_stats_get $h2 10$vlan ingress .bytes
+}
+
+do_tbf_test()
+{
+	local vlan=$1; shift
+	local mbit=$1; shift
+
+	start_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 2 $vlan) $h2_mac
+	sleep 5 # Wait for the burst to dwindle
+
+	local t2=$(busywait_for_counter 1000 +1 tbf_get_counter $vlan)
+	sleep 10
+	local t3=$(tbf_get_counter $vlan)
+	stop_traffic
+
+	RET=0
+
+	# Note: TBF uses 10^6 Mbits, not 2^20 ones.
+	local er=$((mbit * 1000 * 1000))
+	local nr=$(rate $t2 $t3 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-5 <= nr_pct && nr_pct <= 5))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-5%."
+
+	log_test "TC $((vlan - 10)): TBF rate ${mbit}Mbit"
+}
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_ets.sh b/tools/testing/selftests/net/forwarding/sch_tbf_ets.sh
new file mode 100755
index 000000000000..84fb6cab88e4
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_ets.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+QDISC="ets strict"
+: ${lib_dir:=.}
+source $lib_dir/sch_tbf_etsprio.sh
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
new file mode 100644
index 000000000000..8bd85da1905a
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
@@ -0,0 +1,39 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	tbf_test
+"
+source $lib_dir/sch_tbf_core.sh
+
+tbf_test_one()
+{
+	local bs=$1; shift
+
+	tc qdisc replace dev $swp2 parent 10:3 handle 103: tbf \
+	   rate 400Mbit burst $bs limit 1M
+	tc qdisc replace dev $swp2 parent 10:2 handle 102: tbf \
+	   rate 800Mbit burst $bs limit 1M
+
+	do_tbf_test 10 400 $bs
+	do_tbf_test 11 800 $bs
+}
+
+tbf_test()
+{
+	# This test is used for both ETS and PRIO. Even though we only need two
+	# bands, PRIO demands a minimum of three.
+	tc qdisc add dev $swp2 root handle 10: $QDISC 3 priomap 2 1 0
+	tbf_test_one 128K
+	tc qdisc del dev $swp2 root
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
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_prio.sh b/tools/testing/selftests/net/forwarding/sch_tbf_prio.sh
new file mode 100755
index 000000000000..9c8cb1cb9ba4
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_prio.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+QDISC="prio bands"
+: ${lib_dir:=.}
+source $lib_dir/sch_tbf_etsprio.sh
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_root.sh b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
new file mode 100755
index 000000000000..72aa21ba88c7
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	tbf_test
+"
+: ${lib_dir:=.}
+source $lib_dir/sch_tbf_core.sh
+
+tbf_test_one()
+{
+	local bs=$1; shift
+
+	tc qdisc replace dev $swp2 root handle 108: tbf \
+	   rate 400Mbit burst $bs limit 1M
+	do_tbf_test 10 400 $bs
+}
+
+tbf_test()
+{
+	tbf_test_one 128K
+	tc qdisc del dev $swp2 root
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
2.24.1

