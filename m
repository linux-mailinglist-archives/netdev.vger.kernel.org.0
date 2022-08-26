Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8028B5A2751
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiHZMCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHZMCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:02:37 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD35CD7418;
        Fri, 26 Aug 2022 05:02:33 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 83A1F1888676;
        Fri, 26 Aug 2022 12:02:30 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 7AA6425032BD;
        Fri, 26 Aug 2022 12:02:30 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 21D369EC0004; Fri, 26 Aug 2022 11:46:14 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.beijerelectronics.com (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id DB2899EC0009;
        Fri, 26 Aug 2022 11:46:11 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v5 net-next 6/6] selftests: forwarding: add test of MAC-Auth Bypass to locked port tests
Date:   Fri, 26 Aug 2022 13:45:38 +0200
Message-Id: <20220826114538.705433-7-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826114538.705433-1-netdev@kapio-technology.com>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that the MAC-Auth mechanism works by adding a FDB entry with the
locked flag set, denying access until the FDB entry is replaced with a
FDB entry without the locked flag set.

Also add a test that verifies that sticky FDB entries cannot roam.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 .../net/forwarding/bridge_locked_port.sh      | 107 +++++++++++++++++-
 .../net/forwarding/bridge_sticky_fdb.sh       |  21 +++-
 2 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 5b02b6b60ce7..b763b3b9fdf0 100755
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
@@ -166,6 +174,103 @@ locked_port_ipv6()
 	log_test "Locked port ipv6"
 }
 
+locked_port_mab()
+{
+	RET=0
+	check_locked_port_support || return 0
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work before locking port"
+
+	bridge link set dev $swp1 locked on
+	bridge link set dev $swp1 learning on
+	if ! bridge link set dev $swp1 mab on 2>/dev/null; then
+		echo "SKIP: iproute2 too old; MacAuth feature not supported."
+		return $ksft_skip
+	fi
+
+	ping_do $h1 192.0.2.2
+	check_fail $? "MAB: Ping worked on locked port without FDB entry"
+
+	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
+	check_err $? "MAB: No locked fdb entry after ping on locked port"
+
+	bridge fdb replace `mac_get $h1` dev $swp1 master static
+
+	ping_do $h1 192.0.2.2
+	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
+
+	bridge fdb del `mac_get $h1` dev $swp1 master
+	bridge link set dev $swp1 learning off
+	bridge link set dev $swp1 locked off
+
+	log_test "Locked port MAB"
+}
+
+# No roaming allowed to a simple locked port
+locked_port_station_move()
+{
+	local mac=a0:b0:c0:c0:b0:a0
+
+	RET=0
+	check_locked_port_support || return 0
+
+	bridge link set dev $swp1 locked on
+	bridge link set dev $swp1 learning on
+
+	$MZ $h1 -q -t udp -a $mac -b rand
+	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0"
+	check_fail $? "Locked port station move: FDB entry on first injection"
+
+	$MZ $h2 -q -t udp -a $mac -b rand
+	bridge fdb show dev $swp2 | grep -q "$mac vlan 1 master br0"
+	check_err $? "Locked port station move: Entry not found on unlocked port"
+
+	$MZ $h1 -q -t udp -a $mac -b rand
+	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0"
+	check_fail $? "Locked port station move: entry roamed to locked port"
+
+	log_test "Locked port station move"
+}
+
+# Roaming to and from a MAB enabled port should work if sticky flag is not set
+locked_port_mab_station_move()
+{
+	local mac=10:20:30:30:20:10
+
+	RET=0
+	check_locked_port_support || return 0
+
+	bridge link set dev $swp1 locked on
+	bridge link set dev $swp1 learning on
+	if ! bridge link set dev $swp1 mab on 2>/dev/null; then
+		echo "SKIP: iproute2 too old; MacAuth feature not supported."
+		return $ksft_skip
+	fi
+
+	$MZ $h1 -q -t udp -a $mac -b rand
+	if bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0" | grep -q sticky; then
+		echo "SKIP: Roaming not possible with sticky flag, run sticky flag roaming test"
+		return $ksft_skip
+	fi
+
+	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
+	check_err $? "MAB station move: no locked entry on first injection"
+
+	$MZ $h2 -q -t udp -a $mac -b rand
+	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
+	check_fail $? "MAB station move: locked entry did not move"
+
+	bridge fdb show dev $swp2 | grep -q "$mac vlan 1 master br0"
+	check_err $? "MAB station move: roamed entry not found"
+
+	$MZ $h1 -q -t udp -a $mac -b rand
+	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
+	check_err $? "MAB station move: entry did not roam back to locked port"
+
+	log_test "Locked port MAB station move"
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/bridge_sticky_fdb.sh b/tools/testing/selftests/net/forwarding/bridge_sticky_fdb.sh
index 1f8ef0eff862..bca77bc3fe09 100755
--- a/tools/testing/selftests/net/forwarding/bridge_sticky_fdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_sticky_fdb.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="sticky"
+ALL_TESTS="sticky sticky_no_roaming"
 NUM_NETIFS=4
 TEST_MAC=de:ad:be:ef:13:37
 source lib.sh
@@ -59,6 +59,25 @@ sticky()
 	log_test "Sticky fdb entry"
 }
 
+# No roaming allowed with the sticky flag set
+sticky_no_roaming()
+{
+	local mac=a8:b4:c2:c2:b4:a8
+
+	RET=0
+
+	bridge link set dev $swp2 learning on
+	bridge fdb add $mac dev $swp1 master static sticky
+	bridge fdb show dev $swp1 | grep "$mac master br0" | grep -q sticky
+	check_err $? "Sticky no roaming: No sticky FDB entry found after adding"
+
+	$MZ $h2 -q -t udp -c 10 -d 100msec -a $mac -b rand
+	bridge fdb show dev $swp2 | grep "$mac master br0" | grep -q sticky
+	check_fail $? "Sticky no roaming: Sticky entry roamed"
+
+	log_test "Sticky no roaming"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.30.2

