Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A885322072D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgGOI2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56225 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730074AbgGOI2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 956E35C010C;
        Wed, 15 Jul 2020 04:28:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=qsz2RcrGanpnMdi4tJlVz+dNEBXLDuLYa2OOwseF4Oo=; b=A/0T7qdf
        KAcLoCccxtgeoJ0vW3EU+tg9g54JliT6amrfamNjp3FBVRjmo+line1Hu5i8az4y
        dM+7El7mC6kllraoQUpXF6Ctn3A08Qsm1U65DYksY5Vv6QYyrPv8GlpKDBu16lah
        h1cJJpRGMI6lkh82XZ/Iy7k4beYepQRGMeNlI1aGbqa5G3kb1AbEeFeZm9RqE+Jm
        UpecZwh1pgJew47iqWoxKOqIuBlIlWyEEHrHlnYURE8f00GS04v0mlKVJJ16znLW
        0y3QoxzRAHvuOYVe5jQxhp4i0CnCQKI9fP2MRAtxWa04A2k/Xpro+wusxB20c8Zm
        ZRMSboUWxNtm9g==
X-ME-Sender: <xms:I74OX7ZSgtAnjOfCt_8owWEoVtjCUIyz-q8oeMWBhySWvN05wre_RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:I74OX6bXijkvZnCBKcKkfl-1zPCQp76oY4OKwhGo9XsbtyTTqUuMAA>
    <xmx:I74OX99NRfbpzMYKWPC96pvbpWT8QbjWLg6KPMUZiOiFz17xXnf5Sg>
    <xmx:I74OXxru74_lK0svm8wLPew3eq5sq7weoY9j58NdwHX9jW4aHRwe3Q>
    <xmx:I74OX92RvfNOIvjAdK38EsA69a7c7WUTZmqkdBjzlby9U7DhRirYqw>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id E46343280063;
        Wed, 15 Jul 2020 04:28:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/11] selftests: forwarding: Add tc-police tests
Date:   Wed, 15 Jul 2020 11:27:30 +0300
Message-Id: <20200715082733.429610-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test tc-police action in various scenarios such as Rx policing, Tx
policing, shared policer and police piped to mirred. The test passes
with both veth pairs and loopbacked ports.

# ./tc_police.sh
TEST: police on rx                                                  [ OK ]
TEST: police on tx                                                  [ OK ]
TEST: police with shared policer - rx                               [ OK ]
TEST: police with shared policer - tx                               [ OK ]
TEST: police rx and mirror                                          [ OK ]
TEST: police tx and mirror                                          [ OK ]

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../selftests/net/forwarding/tc_police.sh     | 333 ++++++++++++++++++
 1 file changed, 333 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_police.sh

diff --git a/tools/testing/selftests/net/forwarding/tc_police.sh b/tools/testing/selftests/net/forwarding/tc_police.sh
new file mode 100755
index 000000000000..160f9cccdfb7
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_police.sh
@@ -0,0 +1,333 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test tc-police action.
+#
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
+# |        198.51.100.2/24                           203.0.113.2/24           |
+# |    + $rp2                                    + $rp3                       |
+# |    |                                         |                            |
+# +----|-----------------------------------------|----------------------------+
+#      |                                         |
+# +----|----------------------------+       +----|----------------------------+
+# |    |  default via 198.51.100.2  |       |    |  default via 203.0.113.2   |
+# |    |                            |       |    |                            |
+# |    | 198.51.100.1/24            |       |    | 203.0.113.1/24             |
+# |    + $h2                        |       |    + $h3                        |
+# | H2 (vrf)                        |       | H3 (vrf)                        |
+# +---------------------------------+       +---------------------------------+
+
+ALL_TESTS="
+	police_rx_test
+	police_tx_test
+	police_shared_test
+	police_rx_mirror_test
+	police_tx_mirror_test
+"
+NUM_NETIFS=6
+source tc_common.sh
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+
+	ip -4 route add default vrf v$h1 nexthop via 192.0.2.2
+}
+
+h1_destroy()
+{
+	ip -4 route del default vrf v$h1 nexthop via 192.0.2.2
+
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 198.51.100.1/24
+
+	ip -4 route add default vrf v$h2 nexthop via 198.51.100.2
+
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+
+	ip -4 route del default vrf v$h2 nexthop via 198.51.100.2
+
+	simple_if_fini $h2 198.51.100.1/24
+}
+
+h3_create()
+{
+	simple_if_init $h3 203.0.113.1/24
+
+	ip -4 route add default vrf v$h3 nexthop via 203.0.113.2
+
+	tc qdisc add dev $h3 clsact
+}
+
+h3_destroy()
+{
+	tc qdisc del dev $h3 clsact
+
+	ip -4 route del default vrf v$h3 nexthop via 203.0.113.2
+
+	simple_if_fini $h3 203.0.113.1/24
+}
+
+router_create()
+{
+	ip link set dev $rp1 up
+	ip link set dev $rp2 up
+	ip link set dev $rp3 up
+
+	__addr_add_del $rp1 add 192.0.2.2/24
+	__addr_add_del $rp2 add 198.51.100.2/24
+	__addr_add_del $rp3 add 203.0.113.2/24
+
+	tc qdisc add dev $rp1 clsact
+	tc qdisc add dev $rp2 clsact
+}
+
+router_destroy()
+{
+	tc qdisc del dev $rp2 clsact
+	tc qdisc del dev $rp1 clsact
+
+	__addr_add_del $rp3 del 203.0.113.2/24
+	__addr_add_del $rp2 del 198.51.100.2/24
+	__addr_add_del $rp1 del 192.0.2.2/24
+
+	ip link set dev $rp3 down
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
+}
+
+police_common_test()
+{
+	local test_name=$1; shift
+
+	RET=0
+
+	# Rule to measure bandwidth on ingress of $h2
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 0 -q &
+
+	local t0=$(tc_rule_stats_get $h2 1 ingress .bytes)
+	sleep 10
+	local t1=$(tc_rule_stats_get $h2 1 ingress .bytes)
+
+	local er=$((80 * 1000 * 1000))
+	local nr=$(rate $t0 $t1 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-10 <= nr_pct && nr_pct <= 10))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-10%."
+
+	log_test "$test_name"
+
+	{ kill %% && wait %%; } 2>/dev/null
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_rx_test()
+{
+	# Rule to police traffic destined to $h2 on ingress of $rp1
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police rate 80mbit burst 16k conform-exceed drop/ok
+
+	police_common_test "police on rx"
+
+	tc filter del dev $rp1 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_tx_test()
+{
+	# Rule to police traffic destined to $h2 on egress of $rp2
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police rate 80mbit burst 16k conform-exceed drop/ok
+
+	police_common_test "police on tx"
+
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+}
+
+police_shared_common_test()
+{
+	local dport=$1; shift
+	local test_name=$1; shift
+
+	RET=0
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=$dport -p 1000 -c 0 -q &
+
+	local t0=$(tc_rule_stats_get $h2 1 ingress .bytes)
+	sleep 10
+	local t1=$(tc_rule_stats_get $h2 1 ingress .bytes)
+
+	local er=$((80 * 1000 * 1000))
+	local nr=$(rate $t0 $t1 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-10 <= nr_pct && nr_pct <= 10))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-10%."
+
+	log_test "$test_name"
+
+	{ kill %% && wait %%; } 2>/dev/null
+}
+
+police_shared_test()
+{
+	# Rule to measure bandwidth on ingress of $h2
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp src_port 12345 \
+		action drop
+
+	# Rule to police traffic destined to $h2 on ingress of $rp1
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police rate 80mbit burst 16k conform-exceed drop/ok \
+		index 10
+
+	# Rule to police a different flow destined to $h2 on egress of $rp2
+	# using same policer
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 22222 \
+		action police index 10
+
+	police_shared_common_test 54321 "police with shared policer - rx"
+
+	police_shared_common_test 22222 "police with shared policer - tx"
+
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+	tc filter del dev $rp1 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_mirror_common_test()
+{
+	local pol_if=$1; shift
+	local dir=$1; shift
+	local test_name=$1; shift
+
+	RET=0
+
+	# Rule to measure bandwidth on ingress of $h2
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	# Rule to measure bandwidth of mirrored traffic on ingress of $h3
+	tc filter add dev $h3 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	# Rule to police traffic destined to $h2 and mirror to $h3
+	tc filter add dev $pol_if $dir protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police rate 80mbit burst 16k conform-exceed drop/pipe \
+		action mirred egress mirror dev $rp3
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 0 -q &
+
+	local t0=$(tc_rule_stats_get $h2 1 ingress .bytes)
+	sleep 10
+	local t1=$(tc_rule_stats_get $h2 1 ingress .bytes)
+
+	local er=$((80 * 1000 * 1000))
+	local nr=$(rate $t0 $t1 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-10 <= nr_pct && nr_pct <= 10))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-10%."
+
+	local t0=$(tc_rule_stats_get $h3 1 ingress .bytes)
+	sleep 10
+	local t1=$(tc_rule_stats_get $h3 1 ingress .bytes)
+
+	local er=$((80 * 1000 * 1000))
+	local nr=$(rate $t0 $t1 10)
+	local nr_pct=$((100 * (nr - er) / er))
+	((-10 <= nr_pct && nr_pct <= 10))
+	check_err $? "Expected rate $(humanize $er), got $(humanize $nr), which is $nr_pct% off. Required accuracy is +-10%."
+
+	log_test "$test_name"
+
+	{ kill %% && wait %%; } 2>/dev/null
+	tc filter del dev $pol_if $dir protocol ip pref 1 handle 101 flower
+	tc filter del dev $h3 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+}
+
+police_rx_mirror_test()
+{
+	police_mirror_common_test $rp1 ingress "police rx and mirror"
+}
+
+police_tx_mirror_test()
+{
+	police_mirror_common_test $rp2 egress "police tx and mirror"
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
+	rp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	h3_create
+	router_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	router_destroy
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
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
2.26.2

