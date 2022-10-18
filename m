Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852AE604B86
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiJSPcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJSPbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:31:49 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B3172518;
        Wed, 19 Oct 2022 08:25:02 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B2DB21884AE3;
        Wed, 19 Oct 2022 15:12:49 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 57E2C250071A;
        Wed, 19 Oct 2022 15:12:49 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 0)
        id 1D1A79EC000B; Wed, 19 Oct 2022 15:12:49 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id B585D9EC0007;
        Tue, 18 Oct 2022 16:57:02 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v8 net-next 12/12] selftests: forwarding: add MAB tests to locked port tests
Date:   Tue, 18 Oct 2022 18:56:19 +0200
Message-Id: <20221018165619.134535-13-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018165619.134535-1-netdev@kapio-technology.com>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that the MacAuth/MAB mechanism works by adding a FDB entry with
the locked flag set, denying access until the FDB entry is replaced with
a FDB entry without the locked flag set. Also verify that FDB entries
cannot roam from an unlocked port to a locked port.

Add test of blackhole fdb entries, verifying that there is no forwarding
to a blackhole entry from any port, and that the blackhole entry can be
replaced.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 .../selftests/drivers/net/dsa/Makefile        |   1 +
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/bridge_blackhole_fdb.sh    | 131 ++++++++++++++++++
 .../net/forwarding/bridge_locked_port.sh      |  99 ++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh |  17 +++
 5 files changed, 248 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh

diff --git a/tools/testing/selftests/drivers/net/dsa/Makefile b/tools/testing/selftests/drivers/net/dsa/Makefile
index c393e7b73805..c0a75d869763 100644
--- a/tools/testing/selftests/drivers/net/dsa/Makefile
+++ b/tools/testing/selftests/drivers/net/dsa/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
 TEST_PROGS = bridge_locked_port.sh \
+	bridge_blackhole_fdb.sh \
 	bridge_mdb.sh \
 	bridge_mld.sh \
 	bridge_vlan_aware.sh \
diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index a9c5c1be5088..7d832020937f 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0+ OR MIT
 
 TEST_PROGS = bridge_igmp.sh \
+	bridge_blackhole_fdb.sh \
 	bridge_locked_port.sh \
 	bridge_mdb.sh \
 	bridge_mdb_port_down.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
new file mode 100755
index 000000000000..42d9367f7339
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
@@ -0,0 +1,131 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="blackhole_fdb"
+NUM_NETIFS=4
+source tc_common.sh
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/24
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/24
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge vlan_filtering 1
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+	h2=${NETIFS[p3]}
+	swp2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+# Check that there is no egress with blackhole entry and that blackhole entries
+# can be replaced
+blackhole_fdb()
+{
+	RET=0
+
+	check_blackhole_fdb_support || return 0
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 1 flower \
+		dst_ip 192.0.2.2 ip_proto udp dst_port 12345 action pass
+
+	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
+		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
+
+	tc_check_packets "dev $swp2 egress" 1 1
+	check_err $? "Packet not seen on egress before adding blackhole entry"
+
+	bridge fdb replace `mac_get $h2` dev br0 vlan 1 blackhole
+	bridge fdb get `mac_get $h2` br br0 vlan 1 | grep -q blackhole
+	check_err $? "Blackhole entry not found"
+
+	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
+		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
+
+	tc_check_packets "dev $swp2 egress" 1 1
+	check_err $? "Packet seen on egress after adding blackhole entry"
+
+	# Check blackhole entries can be replaced.
+	bridge fdb replace `mac_get $h2` dev $swp2 vlan 1 master static
+	bridge fdb get `mac_get $h2` br br0 vlan 1 | grep -q blackhole
+	check_fail $? "Blackhole entry found after replacement"
+
+	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
+		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
+
+	tc_check_packets "dev $swp2 egress" 1 2
+	check_err $? "Packet not seen on egress after replacing blackhole entry"
+
+	bridge fdb del `mac_get $h2` dev $swp2 vlan 1 master static
+	tc filter del dev $swp2 egress protocol ip pref 1 handle 1 flower
+
+	log_test "Blackhole FDB entry"
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
diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 5b02b6b60ce7..f0bc0bcbc246 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -1,7 +1,15 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
+ALL_TESTS="
+	locked_port_ipv4
+	locked_port_ipv6
+	locked_port_vlan
+	locked_port_mab
+	locked_port_station_move
+	locked_port_mab_station_move
+"
+
 NUM_NETIFS=4
 CHECK_TC="no"
 source lib.sh
@@ -166,6 +174,95 @@ locked_port_ipv6()
 	log_test "Locked port ipv6"
 }
 
+locked_port_mab()
+{
+	RET=0
+	check_port_mab_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work before locking port"
+
+	bridge link set dev $swp1 locked on mab on
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "MAB: Ping worked on mab enabled port without FDB entry"
+
+	bridge fdb get `mac_get $h1` br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
+	check_err $? "MAB: No locked FDB entry after ping on mab enabled port"
+
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work with FDB entry without locked flag"
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+	bridge link set dev $swp1 locked off mab off
+
+	log_test "Locked port MAB"
+}
+
+# Check that entries cannot roam from an unlocked port to a locked port.
+locked_port_station_move()
+{
+	local mac=a0:b0:c0:c0:b0:a0
+
+	RET=0
+	check_locked_port_support || return 0
+
+	bridge link set dev $swp1 locked on learning on
+
+	$MZ $h1 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 &> /dev/null
+	check_fail $? "Locked port station move: FDB entry on first injection"
+
+	$MZ $h2 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep -q "dev $swp2"
+	check_err $? "Locked port station move: Entry not found on unlocked port"
+
+	$MZ $h1 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep -q "dev $swp1"
+	check_fail $? "Locked port station move: entry roamed to locked port"
+
+	bridge fdb del $mac vlan 1 dev $swp2 master
+	bridge link set dev $swp1 locked off learning off
+
+	log_test "Locked port station move"
+}
+
+# Check that entries can roam from a locked port if blackhole FDB flag is not
+# set.
+locked_port_mab_station_move()
+{
+	local mac=10:20:30:30:20:10
+
+	RET=0
+	check_port_mab_support || return 0
+
+	bridge link set dev $swp1 locked on mab on
+
+	$MZ $h1 -q -c 5 -d 100 mesc -t udp -a $mac -b rand
+	if bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "blackhole"; then
+		echo "SKIP: Roaming not possible with blackhole flag, skipping test..."
+		bridge link set dev $swp1 locked off mab off
+		return $ksft_skip
+	fi
+
+	bridge fdb get $mac br br0 vlan 1 | grep "dev $swp1" | grep -q "locked"
+	check_err $? "MAB station move: no locked entry on first injection"
+
+	$MZ $h2 -q -c 5 -d 100msec -t udp -a $mac -b rand
+	bridge fdb get $mac br br0 vlan 1 | grep -q "dev $swp2"
+	check_err $? "MAB station move: roamed entry not found"
+
+	bridge fdb get $mac br br0 vlan 1 | grep -q "locked"
+	check_fail $? "MAB station move: roamed entry to unlocked port had locked flag on"
+
+	bridge fdb del $mac vlan 1 dev $swp2 master
+	bridge link set dev $swp1 locked off mab off
+
+	log_test "Locked port MAB station move"
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 3ffb9d6c0950..d6abe873665c 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -137,6 +137,23 @@ check_locked_port_support()
 	fi
 }
 
+check_port_mab_support()
+{
+	if ! bridge -d link show | grep -q "mab"; then
+		echo "SKIP: iproute2 too old; MacAuth feature not supported."
+		return $ksft_skip
+	fi
+}
+
+check_blackhole_fdb_support()
+{
+	bridge fdb help 2>&1|grep blackhole &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: Blackhole fdb feature not supported."
+		return $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit $ksft_skip
-- 
2.34.1

