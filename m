Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B882A1984B3
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgC3Tjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:42 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56441 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728900AbgC3Tjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 47528580542;
        Mon, 30 Mar 2020 15:39:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YWZaictIH+knTj7OVHypEFxO9+wKUgQ+2oZGsQafYJ8=; b=xAl/BjiK
        +kLXSm7Ly/S+WhKkghwHKFR6IwnabK7FIyMk6ai3efqAHDuWdFHiSQLOWRVLiL67
        09ZdaSLX41Kpwtej6DCaFdrHKirb1We50eyn1IMpv8zoGOv+uHP+Tar8qLmQ2Sfd
        tPwNs98yykLWc4JRUqCOhd+RTjSVpzMCmmAbtwowy6/p9LR87G2+ODdyYnuz6sPg
        5R1eDmBpZHmpHfYdcBTvUEmiyR0QFvR8kwW6P8jUNk66dnla0jJgBc6mKSErxEjy
        WThb2QF7YvTpkRI/l7heE36PVL+c7u/V8czmR/mokHbpcemx293BpKDLwZcbu7AU
        KpcBx+8EKPd7fw==
X-ME-Sender: <xms:-0qCXgnFnelTj1EkgDUhzPgWHBKbEeOhPOTyLh6azY7B6DO8DQxFkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:-0qCXmlLQiyhS-F5xIKXKF6x17yQyKd6mdW6dzIs9OADvA142g_z3A>
    <xmx:-0qCXgZSei0K_Jxe2pMlgkHRVXyFvx1x4yj4JC5NnWBH1zkcnS-OMg>
    <xmx:-0qCXoQlbJs585ZugsS5OzUZnhiy3ncMs3HRvZcWWRpdvQ_uV8Bryg>
    <xmx:-0qCXjTDIPl2LPVpRB6m17ssuIpESdBgMO6H6OrcJUH1TQFikzvz1g>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20038306CA45;
        Mon, 30 Mar 2020 15:39:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 15/15] selftests: mlxsw: Add test cases for devlink-trap policers
Date:   Mon, 30 Mar 2020 22:38:32 +0300
Message-Id: <20200330193832.2359876-16-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add test cases that verify that each registered packet trap policer:

* Honors that imposed limitations of rate and burst size
* Able to police trapped packets to the specified rate
* Able to police trapped packets to the specified burst size
* Able to be unbound from its trap group

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 384 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |   6 +
 2 files changed, 390 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
new file mode 100755
index 000000000000..47edf099a17e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
@@ -0,0 +1,384 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap policer functionality over mlxsw.
+
+# +---------------------------------+
+# | H1 (vrf)                        |
+# |    + $h1                        |
+# |    | 192.0.2.1/24               |
+# |    |                            |
+# |    |  default via 192.0.2.2     |
+# +----|----------------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# |    + $rp1                                                                 |
+# |        192.0.2.2/24                                                       |
+# |                                                                           |
+# |        198.51.100.2/24                                                    |
+# |    + $rp2                                                                 |
+# |    |                                                                      |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|----------------------------+
+# |    |  default via 198.51.100.2  |
+# |    |                            |
+# |    | 198.51.100.1/24            |
+# |    + $h2                        |
+# | H2 (vrf)                        |
+# +---------------------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	rate_limits_test
+	burst_limits_test
+	rate_test
+	burst_test
+"
+NUM_NETIFS=4
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+	mtu_set $h1 10000
+
+	ip -4 route add default vrf v$h1 nexthop via 192.0.2.2
+}
+
+h1_destroy()
+{
+	ip -4 route del default vrf v$h1 nexthop via 192.0.2.2
+
+	mtu_restore $h1
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 198.51.100.1/24
+	mtu_set $h2 10000
+
+	ip -4 route add default vrf v$h2 nexthop via 198.51.100.2
+}
+
+h2_destroy()
+{
+	ip -4 route del default vrf v$h2 nexthop via 198.51.100.2
+
+	mtu_restore $h2
+	simple_if_fini $h2 198.51.100.1/24
+}
+
+router_create()
+{
+	ip link set dev $rp1 up
+	ip link set dev $rp2 up
+
+	__addr_add_del $rp1 add 192.0.2.2/24
+	__addr_add_del $rp2 add 198.51.100.2/24
+	mtu_set $rp1 10000
+	mtu_set $rp2 10000
+
+	ip -4 route add blackhole 198.51.100.100
+
+	devlink trap set $DEVLINK_DEV trap blackhole_route action trap
+}
+
+router_destroy()
+{
+	devlink trap set $DEVLINK_DEV trap blackhole_route action drop
+
+	ip -4 route del blackhole 198.51.100.100
+
+	mtu_restore $rp2
+	mtu_restore $rp1
+	__addr_add_del $rp2 del 198.51.100.2/24
+	__addr_add_del $rp1 del 192.0.2.2/24
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp1=${NETIFS[p2]}
+
+	rp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	rp1_mac=$(mac_get $rp1)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	router_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	router_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+
+	# Reload to ensure devlink-trap settings are back to default.
+	devlink_reload
+}
+
+rate_limits_test()
+{
+	RET=0
+
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 0 &> /dev/null
+	check_fail $? "Policer rate was changed to rate lower than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 \
+		rate 2000000001 &> /dev/null
+	check_fail $? "Policer rate was changed to rate higher than limit"
+
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 1
+	check_err $? "Failed to set policer rate to minimum"
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 2000000000
+	check_err $? "Failed to set policer rate to maximum"
+
+	log_test "Trap policer rate limits"
+}
+
+burst_limits_test()
+{
+	RET=0
+
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 0 &> /dev/null
+	check_fail $? "Policer burst size was changed to 0"
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 17 &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size that is not power of 2"
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 8 &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size lower than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 \
+		burst $((2**25)) &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size higher than limit"
+
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 16
+	check_err $? "Failed to set policer burst size to minimum"
+	devlink trap policer set $DEVLINK_DEV policer 1 burst $((2**24))
+	check_err $? "Failed to set policer burst size to maximum"
+
+	log_test "Trap policer burst size limits"
+}
+
+trap_rate_get()
+{
+	local t0 t1
+
+	t0=$(devlink_trap_rx_packets_get blackhole_route)
+	sleep 10
+	t1=$(devlink_trap_rx_packets_get blackhole_route)
+
+	echo $(((t1 - t0) / 10))
+}
+
+policer_drop_rate_get()
+{
+	local id=$1; shift
+	local t0 t1
+
+	t0=$(devlink_trap_policer_rx_dropped_get $id)
+	sleep 10
+	t1=$(devlink_trap_policer_rx_dropped_get $id)
+
+	echo $(((t1 - t0) / 10))
+}
+
+__rate_test()
+{
+	local rate pct drop_rate
+	local id=$1; shift
+
+	RET=0
+
+	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 16
+	devlink trap group set $DEVLINK_DEV group l3_drops policer $id
+
+	# Send packets at highest possible rate and make sure they are dropped
+	# by the policer. Make sure measured received rate is about 1000 pps
+	log_info "=== Tx rate: Highest, Policer rate: 1000 pps ==="
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac
+
+	sleep 5 # Take measurements when rate is stable
+
+	rate=$(trap_rate_get)
+	pct=$((100 * (rate - 1000) / 1000))
+	((-5 <= pct && pct <= 5))
+	check_err $? "Expected rate 1000 pps, got $rate pps, which is $pct% off. Required accuracy is +-5%"
+	log_info "Expected rate 1000 pps, measured rate $rate pps"
+
+	drop_rate=$(policer_drop_rate_get $id)
+	(( drop_rate > 0 ))
+	check_err $? "Expected non-zero policer drop rate, got 0"
+	log_info "Measured policer drop rate of $drop_rate pps"
+
+	stop_traffic
+
+	# Send packets at a rate of 1000 pps and make sure they are not dropped
+	# by the policer
+	log_info "=== Tx rate: 1000 pps, Policer rate: 1000 pps ==="
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac -d 1msec
+
+	sleep 5 # Take measurements when rate is stable
+
+	drop_rate=$(policer_drop_rate_get $id)
+	(( drop_rate == 0 ))
+	check_err $? "Expected zero policer drop rate, got a drop rate of $drop_rate pps"
+	log_info "Measured policer drop rate of $drop_rate pps"
+
+	stop_traffic
+
+	# Unbind the policer and send packets at highest possible rate. Make
+	# sure they are not dropped by the policer and that the measured
+	# received rate is higher than 1000 pps
+	log_info "=== Tx rate: Highest, Policer rate: No policer ==="
+
+	devlink trap group set $DEVLINK_DEV group l3_drops nopolicer
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac
+
+	rate=$(trap_rate_get)
+	(( rate > 1000 ))
+	check_err $? "Expected rate higher than 1000 pps, got $rate pps"
+	log_info "Measured rate $rate pps"
+
+	drop_rate=$(policer_drop_rate_get $id)
+	(( drop_rate == 0 ))
+	check_err $? "Expected zero policer drop rate, got a drop rate of $drop_rate pps"
+	log_info "Measured policer drop rate of $drop_rate pps"
+
+	stop_traffic
+
+	log_test "Trap policer rate"
+}
+
+rate_test()
+{
+	local id
+
+	for id in $(devlink_trap_policer_ids_get); do
+		echo
+		log_info "Running rate test for policer $id"
+		__rate_test $id
+	done
+}
+
+__burst_test()
+{
+	local t0_rx t0_drop t1_rx t1_drop rx drop
+	local id=$1; shift
+
+	RET=0
+
+	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 32
+	devlink trap group set $DEVLINK_DEV group l3_drops policer $id
+
+	# Send a burst of 64 packets and make sure that about 32 are received
+	# and the rest are dropped by the policer
+	log_info "=== Tx burst size: 64, Policer burst size: 32 pps ==="
+
+	t0_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t0_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac -c 64
+
+	t1_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t1_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	rx=$((t1_rx - t0_rx))
+	pct=$((100 * (rx - 32) / 32))
+	((-20 <= pct && pct <= 20))
+	check_err $? "Expected burst size of 32 packets, got $rx packets, which is $pct% off. Required accuracy is +-20%"
+	log_info "Expected burst size of 32 packets, measured burst size of $rx packets"
+
+	drop=$((t1_drop - t0_drop))
+	(( drop > 0 ))
+	check_err $? "Expected non-zero policer drops, got 0"
+	log_info "Measured policer drops of $drop packets"
+
+	# Send a burst of 16 packets and make sure that 16 are received
+	# and that none are dropped by the policer
+	log_info "=== Tx burst size: 16, Policer burst size: 32 pps ==="
+
+	t0_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t0_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac -c 16
+
+	t1_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t1_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	rx=$((t1_rx - t0_rx))
+	(( rx == 16 ))
+	check_err $? "Expected burst size of 16 packets, got $rx packets"
+	log_info "Expected burst size of 16 packets, measured burst size of $rx packets"
+
+	drop=$((t1_drop - t0_drop))
+	(( drop == 0 ))
+	check_err $? "Expected zero policer drops, got $drop"
+	log_info "Measured policer drops of $drop packets"
+
+	# Unbind the policer and send a burst of 64 packets. Make sure that
+	# 64 packets are received and that none are dropped by the policer
+	log_info "=== Tx burst size: 64, Policer burst size: No policer ==="
+
+	devlink trap group set $DEVLINK_DEV group l3_drops nopolicer
+
+	t0_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t0_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	start_traffic $h1 192.0.2.1 198.51.100.100 $rp1_mac -c 64
+
+	t1_rx=$(devlink_trap_rx_packets_get blackhole_route)
+	t1_drop=$(devlink_trap_policer_rx_dropped_get $id)
+
+	rx=$((t1_rx - t0_rx))
+	(( rx == 64 ))
+	check_err $? "Expected burst size of 64 packets, got $rx packets"
+	log_info "Expected burst size of 64 packets, measured burst size of $rx packets"
+
+	drop=$((t1_drop - t0_drop))
+	(( drop == 0 ))
+	check_err $? "Expected zero policer drops, got $drop"
+	log_info "Measured policer drops of $drop packets"
+
+	log_test "Trap policer burst size"
+}
+
+burst_test()
+{
+	local id
+
+	for id in $(devlink_trap_policer_ids_get); do
+		echo
+		log_info "Running burst size test for policer $id"
+		__burst_test $id
+	done
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
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index c48645a344e2..155d48bd4d9e 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -457,6 +457,12 @@ devlink_trap_group_policer_get()
 		| jq '.[][][]["policer"]'
 }
 
+devlink_trap_policer_ids_get()
+{
+	devlink -j -p trap policer show \
+		| jq '.[]["'$DEVLINK_DEV'"][]["policer"]'
+}
+
 devlink_port_by_netdev()
 {
 	local if_name=$1
-- 
2.24.1

