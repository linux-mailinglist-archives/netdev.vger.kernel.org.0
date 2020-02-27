Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E731711C1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgB0Hu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55435 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgB0Hu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so2310579wmj.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=73olL4GleHBGLZJQQ7L5seMOScCikNWKuFolMVDqPWc=;
        b=ZAI7BE11OnAXUdbNPcWsIBlrTtEs9fYRV9jBSm7Gec0pgGBREXHUTPV5b7HjsClZFS
         8oosT/ZEW/L6K3UP5UTfHFnRq2rOm8otnh9i4q5d2DrgN9Sp0jy2bPSTx3qoNyVo7iBS
         voYNtwj9hOSRoBjuV7VQY8BtI2XA8qt+IgSXte3rp0l6Rf+xS0kvhrD7sbWlL+YpLvp5
         V26l8WpVJQ1ZZXeoTo/MDYUNJD/QKAFUDx5xneGnEBzO4hSb2AU4Xhd11uVCr5cSblRw
         KcmUREuzqiYS8qd8Hg/6bXHpD8TKZ3qb+errQECqgntHDCczW7JUI30ihI/xf23iSeey
         EOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=73olL4GleHBGLZJQQ7L5seMOScCikNWKuFolMVDqPWc=;
        b=AOQ8yG8fTsPlUrlGN4W5Q+sFNd6yQT/9Axjh5LA3NINGXfVaEoPFFbhGDPbZBdjbVY
         9pg7u/5kxAvNZzwOMECa6f15ZSxe8tmPixgA1Bzs3wKZ2DbTtpVPB5GZgDFvJUuUFKTB
         JEtBXC4SfyMPvWbXu17w6E1n8nlOXgLJoySQ2XEAIRceoRkHspfFu4eHwcCb0nJfguPv
         vmNueMxOarA0fxRHVqFArJNMJqH/Lwrykq7EW5FvLiv5Nv/ifd4OhEYcbdBVuLO5DZ9t
         LiiAg/ylGibbyuO+O4Yli4KFKF6XvcAMJE6KlW8p3fNxLCbKm/fMj3AxuE6FPnOkoFBI
         l99Q==
X-Gm-Message-State: APjAAAUDQtg+jvDKgVJaqu/ZoKpC78bjXh+Si9fISff8zkaPCpq73yRU
        AtIddXLA9oQdyg6kQVOXAO5Sw3YYZf4=
X-Google-Smtp-Source: APXvYqyCH1bpHX12t1THu9nW4ES/n8oIluq/v4RMc1QIgKJ0kJNgbB9H7v/+OJQkYgFquCAYxsxWNw==
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr3721863wma.171.1582789825165;
        Wed, 26 Feb 2020 23:50:25 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c9sm6997004wrq.44.2020.02.26.23.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 02/16] selftests: mlxsw: Add a RED selftest
Date:   Thu, 27 Feb 2020 08:50:07 +0100
Message-Id: <20200227075021.3472-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This tests that below the queue minimum length, there is no dropping /
marking, and above max, everything is dropped / marked.

The test is structured as a core file with topology and test code, and
three wrappers: one for RED used as a root Qdisc, and two for
testing (W)RED under PRIO and ETS.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 499 ++++++++++++++++++
 .../drivers/net/mlxsw/sch_red_ets.sh          |  83 +++
 .../drivers/net/mlxsw/sch_red_prio.sh         |   5 +
 .../drivers/net/mlxsw/sch_red_root.sh         |  60 +++
 tools/testing/selftests/net/forwarding/lib.sh |  10 +
 5 files changed, 657 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_prio.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
new file mode 100644
index 000000000000..ebf7752f6d93
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -0,0 +1,499 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends a >1Gbps stream of traffic from H1, to the switch, which
+# forwards it to a 1Gbps port. This 1Gbps stream is then looped back to the
+# switch and forwarded to the port under test $swp3, which is also 1Gbps.
+#
+# This way, $swp3 should be 100% filled with traffic without any of it spilling
+# to the backlog. Any extra packets sent should almost 1:1 go to backlog. That
+# is what H2 is used for--it sends the extra traffic to create backlog.
+#
+# A RED Qdisc is installed on $swp3. The configuration is such that the minimum
+# and maximum size are 1 byte apart, so there is a very clear border under which
+# no marking or dropping takes place, and above which everything is marked or
+# dropped.
+#
+# The test uses the buffer build-up behavior to test the installed RED.
+#
+# In order to test WRED, $swp3 actually contains RED under PRIO, with two
+# different configurations. Traffic is prioritized using 802.1p and relies on
+# the implicit mlxsw configuration, where packet priority is taken 1:1 from the
+# 802.1p marking.
+#
+# +--------------------------+                     +--------------------------+
+# | H1                       |                     | H2                       |
+# |     + $h1.10             |                     |     + $h2.10             |
+# |     | 192.0.2.1/28       |                     |     | 192.0.2.2/28       |
+# |     |                    |                     |     |                    |
+# |     |         $h1.11 +   |                     |     |         $h2.11 +   |
+# |     |  192.0.2.17/28 |   |                     |     |  192.0.2.18/28 |   |
+# |     |                |   |                     |     |                |   |
+# |     \______    ______/   |                     |     \______    ______/   |
+# |            \ /           |                     |            \ /           |
+# |             + $h1        |                     |             + $h2        |
+# +-------------|------------+                     +-------------|------------+
+#               | >1Gbps                                         |
+# +-------------|------------------------------------------------|------------+
+# | SW          + $swp1                                          + $swp2      |
+# |     _______/ \___________                        ___________/ \_______    |
+# |    /                     \                      /                     \   |
+# |  +-|-----------------+   |                    +-|-----------------+   |   |
+# |  | + $swp1.10        |   |                    | + $swp2.10        |   |   |
+# |  |                   |   |        .-------------+ $swp5.10        |   |   |
+# |  |     BR1_10        |   |        |           |                   |   |   |
+# |  |                   |   |        |           |     BR2_10        |   |   |
+# |  | + $swp2.10        |   |        |           |                   |   |   |
+# |  +-|-----------------+   |        |           | + $swp3.10        |   |   |
+# |    |                     |        |           +-|-----------------+   |   |
+# |    |   +-----------------|-+      |             |   +-----------------|-+ |
+# |    |   |        $swp1.11 + |      |             |   |        $swp2.11 + | |
+# |    |   |                   |      | .-----------------+ $swp5.11        | |
+# |    |   |      BR1_11       |      | |           |   |                   | |
+# |    |   |                   |      | |           |   |      BR2_11       | |
+# |    |   |        $swp2.11 + |      | |           |   |                   | |
+# |    |   +-----------------|-+      | |           |   |        $swp3.11 + | |
+# |    |                     |        | |           |   +-----------------|-+ |
+# |    \_______   ___________/        | |           \___________   _______/   |
+# |            \ /                    \ /                       \ /           |
+# |             + $swp4                + $swp5                   + $swp3      |
+# +-------------|----------------------|-------------------------|------------+
+#               |                      |                         | 1Gbps
+#               \________1Gbps_________/                         |
+#                                   +----------------------------|------------+
+#                                   | H3                         + $h3        |
+#                                   |      _____________________/ \_______    |
+#                                   |     /                               \   |
+#                                   |     |                               |   |
+#                                   |     + $h3.10                 $h3.11 +   |
+#                                   |       192.0.2.3/28    192.0.2.19/28     |
+#                                   +-----------------------------------------+
+
+NUM_NETIFS=8
+CHECK_TC="yes"
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source qos_lib.sh
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
+	# Some of the tests in this suite use multicast traffic. As this traffic
+	# enters BR2_10 resp. BR2_11, it is flooded to all other ports. Thus
+	# e.g. traffic ingressing through $swp2 is flooded to $swp3 (the
+	# intended destination) and $swp5 (which is intended as ingress for
+	# another stream of traffic).
+	#
+	# This is generally not a problem, but if the $swp5 throughput is lower
+	# than $swp2 throughput, there will be a build-up at $swp5. That may
+	# cause packets to fail to queue up at $swp3 due to shared buffer
+	# quotas, and the test to spuriously fail.
+	#
+	# Prevent this by setting the speed of $h2 to 1Gbps.
+
+	ethtool -s $h2 speed 1000 autoneg off
+}
+
+h2_destroy()
+{
+	ethtool -s $h2 autoneg on
+	host_destroy $h2
+}
+
+h3_create()
+{
+	host_create $h3 3
+	ethtool -s $h3 speed 1000 autoneg off
+}
+
+h3_destroy()
+{
+	ethtool -s $h3 autoneg on
+	host_destroy $h3
+}
+
+switch_create()
+{
+	local intf
+	local vlan
+
+	ip link add dev br1_10 type bridge
+	ip link add dev br1_11 type bridge
+
+	ip link add dev br2_10 type bridge
+	ip link add dev br2_11 type bridge
+
+	for intf in $swp1 $swp2 $swp3 $swp4 $swp5; do
+		ip link set dev $intf up
+		mtu_set $intf 10000
+	done
+
+	for intf in $swp1 $swp4; do
+		for vlan in 10 11; do
+			vlan_create $intf $vlan
+			ip link set dev $intf.$vlan master br1_$vlan
+			ip link set dev $intf.$vlan up
+		done
+	done
+
+	for intf in $swp2 $swp3 $swp5; do
+		for vlan in 10 11; do
+			vlan_create $intf $vlan
+			ip link set dev $intf.$vlan master br2_$vlan
+			ip link set dev $intf.$vlan up
+		done
+	done
+
+	ip link set dev $swp4.10 type vlan egress 0:0
+	ip link set dev $swp4.11 type vlan egress 0:1
+	for intf in $swp1 $swp2 $swp5; do
+		for vlan in 10 11; do
+			ip link set dev $intf.$vlan type vlan ingress 0:0 1:1
+		done
+	done
+
+	for intf in $swp2 $swp3 $swp4 $swp5; do
+		ethtool -s $intf speed 1000 autoneg off
+	done
+
+	ip link set dev br1_10 up
+	ip link set dev br1_11 up
+	ip link set dev br2_10 up
+	ip link set dev br2_11 up
+
+	local size=$(devlink_pool_size_thtype 0 | cut -d' ' -f 1)
+	devlink_port_pool_th_set $swp3 8 $size
+}
+
+switch_destroy()
+{
+	local intf
+	local vlan
+
+	devlink_port_pool_th_restore $swp3 8
+
+	tc qdisc del dev $swp3 root 2>/dev/null
+
+	ip link set dev br2_11 down
+	ip link set dev br2_10 down
+	ip link set dev br1_11 down
+	ip link set dev br1_10 down
+
+	for intf in $swp5 $swp4 $swp3 $swp2; do
+		ethtool -s $intf autoneg on
+	done
+
+	for intf in $swp5 $swp3 $swp2 $swp4 $swp1; do
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
+	ip link del dev br2_11
+	ip link del dev br2_10
+	ip link del dev br1_11
+	ip link del dev br1_10
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
+	h3_mac=$(mac_get $h3)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	h3_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1.10 $(ipaddr 3 10) " from host 1, vlan 10"
+	ping_test $h1.11 $(ipaddr 3 11) " from host 1, vlan 11"
+	ping_test $h2.10 $(ipaddr 3 10) " from host 2, vlan 10"
+	ping_test $h2.11 $(ipaddr 3 11) " from host 2, vlan 11"
+}
+
+get_tc()
+{
+	local vlan=$1; shift
+
+	echo $((vlan - 10))
+}
+
+get_qdisc_handle()
+{
+	local vlan=$1; shift
+
+	local tc=$(get_tc $vlan)
+	local band=$((8 - tc))
+
+	# Handle is 107: for TC1, 108: for TC0.
+	echo "10$band:"
+}
+
+get_qdisc_backlog()
+{
+	local vlan=$1; shift
+
+	qdisc_stats_get $swp3 $(get_qdisc_handle $vlan) .backlog
+}
+
+get_mc_transmit_queue()
+{
+	local vlan=$1; shift
+
+	local tc=$(($(get_tc $vlan) + 8))
+	ethtool_stats_get $swp3 tc_transmit_queue_tc_$tc
+}
+
+get_nmarked()
+{
+	local vlan=$1; shift
+
+	ethtool_stats_get $swp3 ecn_marked
+}
+
+get_qdisc_npackets()
+{
+	local vlan=$1; shift
+
+	busywait_for_counter 1100 +1 \
+		qdisc_stats_get $swp3 $(get_qdisc_handle $vlan) .packets
+}
+
+# This sends traffic in an attempt to build a backlog of $size. Returns 0 on
+# success. After 10 failed attempts it bails out and returns 1. It dumps the
+# backlog size to stdout.
+build_backlog()
+{
+	local vlan=$1; shift
+	local size=$1; shift
+	local proto=$1; shift
+
+	local tc=$((vlan - 10))
+	local band=$((8 - tc))
+	local cur=-1
+	local i=0
+
+	while :; do
+		local cur=$(busywait 1100 until_counter_is $((cur + 1)) \
+					    get_qdisc_backlog $vlan)
+		local diff=$((size - cur))
+		local pkts=$(((diff + 7999) / 8000))
+
+		if ((cur >= size)); then
+			echo $cur
+			return 0
+		elif ((i++ > 10)); then
+			echo $cur
+			return 1
+		fi
+
+		$MZ $h2.$vlan -p 8000 -a own -b $h3_mac \
+		    -A $(ipaddr 2 $vlan) -B $(ipaddr 3 $vlan) \
+		    -t $proto -q -c $pkts "$@"
+	done
+}
+
+check_marking()
+{
+	local vlan=$1; shift
+	local cond=$1; shift
+
+	local npackets_0=$(get_qdisc_npackets $vlan)
+	local nmarked_0=$(get_nmarked $vlan)
+	sleep 5
+	local npackets_1=$(get_qdisc_npackets $vlan)
+	local nmarked_1=$(get_nmarked $vlan)
+
+	local nmarked_d=$((nmarked_1 - nmarked_0))
+	local npackets_d=$((npackets_1 - npackets_0))
+	local pct=$((100 * nmarked_d / npackets_d))
+
+	echo $pct
+	((pct $cond))
+}
+
+do_ecn_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local backlog
+	local pct
+
+	# Main stream.
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+
+	# Build the below-the-limit backlog using UDP. We could use TCP just
+	# fine, but this way we get a proof that UDP is accepted when queue
+	# length is below the limit. The main stream is using TCP, and if the
+	# limit is misconfigured, we would see this traffic being ECN marked.
+	RET=0
+	backlog=$(build_backlog $vlan $((2 * limit / 3)) udp)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking $vlan "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	log_test "TC $((vlan - 10)): ECN backlog < limit"
+
+	# Now push TCP, because non-TCP traffic would be early-dropped after the
+	# backlog crosses the limit, and we want to make sure that the backlog
+	# is above the limit.
+	RET=0
+	backlog=$(build_backlog $vlan $((3 * limit / 2)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking $vlan ">= 95")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected >= 95."
+	log_test "TC $((vlan - 10)): ECN backlog > limit"
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, it should all get dropped, and backlog
+	# building should fail.
+	RET=0
+	build_backlog $vlan $((2 * limit)) udp >/dev/null
+	check_fail $? "UDP traffic went into backlog instead of being early-dropped"
+	log_test "TC $((vlan - 10)): ECN backlog > limit: UDP early-dropped"
+
+	stop_traffic
+	sleep 1
+}
+
+do_red_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local backlog
+	local pct
+
+	# Use ECN-capable TCP to verify there's no marking even though the queue
+	# is above limit.
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+
+	# Pushing below the queue limit should work.
+	RET=0
+	backlog=$(build_backlog $vlan $((2 * limit / 3)) tcp tos=0x01)
+	check_err $? "Could not build the requested backlog"
+	pct=$(check_marking $vlan "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	log_test "TC $((vlan - 10)): RED backlog < limit"
+
+	# Pushing above should not.
+	RET=0
+	backlog=$(build_backlog $vlan $((3 * limit / 2)) tcp tos=0x01)
+	check_fail $? "Traffic went into backlog instead of being early-dropped"
+	pct=$(check_marking $vlan "== 0")
+	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
+	local diff=$((limit - backlog))
+	pct=$((100 * diff / limit))
+	((0 <= pct && pct <= 5))
+	check_err $? "backlog $backlog / $limit expected <= 5% distance"
+	log_test "TC $((vlan - 10)): RED backlog > limit"
+
+	stop_traffic
+	sleep 1
+}
+
+do_mc_backlog_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local backlog
+	local pct
+
+	RET=0
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) bc
+	start_tcp_traffic $h2.$vlan $(ipaddr 2 $vlan) $(ipaddr 3 $vlan) bc
+
+	qbl=$(busywait 5000 until_counter_is 500000 \
+		       get_qdisc_backlog $vlan)
+	check_err $? "Could not build MC backlog"
+
+	# Verify that we actually see the backlog on BUM TC. Do a busywait as
+	# well, performance blips might cause false fail.
+	local ebl
+	ebl=$(busywait 5000 until_counter_is 500000 \
+		       get_mc_transmit_queue $vlan)
+	check_err $? "MC backlog reported by qdisc not visible in ethtool"
+
+	stop_traffic
+	stop_traffic
+
+	log_test "TC $((vlan - 10)): Qdisc reports MC backlog"
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
new file mode 100755
index 000000000000..af83efe9ccf1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -0,0 +1,83 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	ecn_test
+	red_test
+	mc_backlog_test
+"
+: ${QDISC:=ets}
+source sch_red_core.sh
+
+# do_ecn_test first build 2/3 of the requested backlog and expects no marking,
+# and then builds 3/2 of it and does expect marking. The values of $BACKLOG1 and
+# $BACKLOG2 are far enough not to overlap, so that we can assume that if we do
+# see (do not see) marking, it is actually due to the configuration of that one
+# TC, and not due to configuration of the other TC leaking over.
+BACKLOG1=200000
+BACKLOG2=500000
+
+install_qdisc()
+{
+	local -a args=("$@")
+
+	tc qdisc add dev $swp3 root handle 10: $QDISC \
+	   bands 8 priomap 7 6 5 4 3 2 1 0
+	tc qdisc add dev $swp3 parent 10:8 handle 108: red \
+	   limit 1000000 min $BACKLOG1 max $((BACKLOG1 + 1)) \
+	   probability 1.0 avpkt 8000 burst 38 "${args[@]}"
+	tc qdisc add dev $swp3 parent 10:7 handle 107: red \
+	   limit 1000000 min $BACKLOG2 max $((BACKLOG2 + 1)) \
+	   probability 1.0 avpkt 8000 burst 63 "${args[@]}"
+	sleep 1
+}
+
+uninstall_qdisc()
+{
+	tc qdisc del dev $swp3 parent 10:7
+	tc qdisc del dev $swp3 parent 10:8
+	tc qdisc del dev $swp3 root
+}
+
+ecn_test()
+{
+	install_qdisc ecn
+
+	do_ecn_test 10 $BACKLOG1
+	do_ecn_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
+red_test()
+{
+	install_qdisc
+
+	do_red_test 10 $BACKLOG1
+	do_red_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
+mc_backlog_test()
+{
+	install_qdisc
+
+	# Note that the backlog numbers here do not correspond to RED
+	# configuration, but are arbitrary.
+	do_mc_backlog_test 10 $BACKLOG1
+	do_mc_backlog_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+bail_on_lldpad
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_prio.sh
new file mode 100755
index 000000000000..76820a0e9a1b
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_prio.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+QDISC=prio
+source sch_red_ets.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
new file mode 100755
index 000000000000..b2217493a88e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -0,0 +1,60 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	ecn_test
+	red_test
+	mc_backlog_test
+"
+source sch_red_core.sh
+
+BACKLOG=300000
+
+install_qdisc()
+{
+	local -a args=("$@")
+
+	tc qdisc add dev $swp3 root handle 108: red \
+	   limit 1000000 min $BACKLOG max $((BACKLOG + 1)) \
+	   probability 1.0 avpkt 8000 burst 38 "${args[@]}"
+	sleep 1
+}
+
+uninstall_qdisc()
+{
+	tc qdisc del dev $swp3 root
+}
+
+ecn_test()
+{
+	install_qdisc ecn
+	do_ecn_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
+red_test()
+{
+	install_qdisc
+	do_red_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
+mc_backlog_test()
+{
+	install_qdisc
+	# Note that the backlog value here does not correspond to RED
+	# configuration, but is arbitrary.
+	do_mc_backlog_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+bail_on_lldpad
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index f80f384978ce..aff3178edf6d 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -607,6 +607,16 @@ ethtool_stats_get()
 	ethtool -S $dev | grep "^ *$stat:" | head -n 1 | cut -d: -f2
 }
 
+qdisc_stats_get()
+{
+	local dev=$1; shift
+	local handle=$1; shift
+	local selector=$1; shift
+
+	tc -j -s qdisc show dev "$dev" \
+	    | jq '.[] | select(.handle == "'"$handle"'") | '"$selector"
+}
+
 humanize()
 {
 	local speed=$1; shift
-- 
2.21.1

