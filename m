Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EB16361DF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbiKWObN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbiKWOad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:30:33 -0500
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AD919C0F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:29:41 -0800 (PST)
Received: from [192.168.16.157] (helo=fisk.sw.ru)
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <nikolay.borisov@virtuozzo.com>)
        id 1oxqjh-001EZF-D8;
        Wed, 23 Nov 2022 15:28:25 +0100
From:   Nikolay Borisov <nikolay.borisov@virtuozzo.com>
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel@virtuozzo.com,
        Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Subject: [PATCH net-next v2 3/3] selftests: net: Add drop monitor tests for namespace filtering functionality
Date:   Wed, 23 Nov 2022 16:28:17 +0200
Message-Id: <20221123142817.2094993-4-nikolay.borisov@virtuozzo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the current set of tests with new ones covering the updated
functionality allowing to filter events based on the net namespace they
originated from. The new set of tests:

Software drops test
    TEST: No filtering                                                  [ OK ]
    TEST: Filter everything                                             [ OK ]
    TEST: NS2 packet drop filtered                                      [ OK ]
    TEST: Filtering reset                                               [ OK ]
    TEST: Filtering disabled                                            [ OK ]

Hardware drops test
    TEST: No filtering                                                  [ OK ]
    TEST: Filter everything                                             [ OK ]
    TEST: NS2 packet drop filtered                                      [ OK ]
    TEST: Filtering reset                                               [ OK ]
    TEST: Filtering disabled                                            [ OK ]

Signed-off-by: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
---
 .../selftests/net/drop_monitor_tests.sh       | 127 +++++++++++++++---
 1 file changed, 108 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/net/drop_monitor_tests.sh b/tools/testing/selftests/net/drop_monitor_tests.sh
index b7650e30d18b..776aabc036f1 100755
--- a/tools/testing/selftests/net/drop_monitor_tests.sh
+++ b/tools/testing/selftests/net/drop_monitor_tests.sh
@@ -13,14 +13,13 @@ TESTS="
 	hw_drops
 "
 
-IP="ip -netns ns1"
-TC="tc -netns ns1"
-DEVLINK="devlink -N ns1"
-NS_EXEC="ip netns exec ns1"
 NETDEVSIM_PATH=/sys/bus/netdevsim/
-DEV_ADDR=1337
-DEV=netdevsim${DEV_ADDR}
-DEVLINK_DEV=netdevsim/${DEV}
+DEV1_ADDR=1336
+DEV2_ADDR=1337
+DEV1=netdevsim${DEV1_ADDR}
+DEV2=netdevsim${DEV2_ADDR}
+DEVLINK_DEV1=netdevsim/${DEV1}
+DEVLINK_DEV2=netdevsim/${DEV2}
 
 log_test()
 {
@@ -44,20 +43,29 @@ setup()
 
 	set -e
 	ip netns add ns1
-	$IP link add dummy10 up type dummy
-
-	$NS_EXEC echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	ip netns add ns2
+	NS1INUM=$(findmnt -t nsfs | grep -m1 ns1 | sed -rn 's/.*net:\[([[:digit:]]+)\].*/\1/p')
+	NS2INUM=$(findmnt -t nsfs | grep -m1 ns2 | sed -rn 's/.*net:\[([[:digit:]]+)\].*/\1/p')
+	ip -netns ns1 link add dummy10 up type dummy
+	ip -netns ns2 link add dummy10 up type dummy
+
+	ip netns exec ns1 echo "$DEV1_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	ip netns exec ns2 echo "$DEV2_ADDR 1" > ${NETDEVSIM_PATH}/new_device
 	udevadm settle
-	local netdev=$($NS_EXEC ls ${NETDEVSIM_PATH}/devices/${DEV}/net/)
-	$IP link set dev $netdev up
+	local netdev=$(ip netns exec ns1 ls ${NETDEVSIM_PATH}/devices/${DEV1}/net/)
+	ip -netns ns1 link set dev $netdev up
+	netdev=$(ip netns exec ns2 ls ${NETDEVSIM_PATH}/devices/${DEV2}/net/)
+	ip -netns ns2 link set dev $netdev up
 
 	set +e
 }
 
 cleanup()
 {
-	$NS_EXEC echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	ip netns exec ns1 echo "$DEV1_ADDR" > ${NETDEVSIM_PATH}/del_device
+	ip netns exec ns2 echo "$DEV2_ADDR" > ${NETDEVSIM_PATH}/del_device
 	ip netns del ns1
+	ip netns del ns2
 }
 
 sw_drops_test()
@@ -69,13 +77,53 @@ sw_drops_test()
 
 	local dir=$(mktemp -d)
 
-	$TC qdisc add dev dummy10 clsact
-	$TC filter add dev dummy10 egress pref 1 handle 101 proto ip \
+	tc -netns ns1 qdisc add dev dummy10 clsact
+	tc -netns ns2 qdisc add dev dummy10 clsact
+	tc -netns ns1 filter add dev dummy10 egress pref 1 handle 101 proto ip \
+		flower dst_ip 192.0.2.10 action drop
+	tc -netns ns2 filter add dev dummy10 egress pref 1 handle 101 proto ip \
 		flower dst_ip 192.0.2.10 action drop
 
-	$NS_EXEC mausezahn dummy10 -a 00:11:22:33:44:55 -b 00:aa:bb:cc:dd:ee \
+	ip netns exec ns1 mausezahn dummy10 -a 00:11:22:33:44:55 -b 00:aa:bb:cc:dd:ee \
 		-A 192.0.2.1 -B 192.0.2.10 -t udp sp=12345,dp=54321 -c 0 -q \
 		-d 100msec &
+	ip netns exec ns2 mausezahn dummy10 -a 00:11:22:33:44:55 -b 00:aa:bb:cc:dd:ee \
+		-A 192.0.2.1 -B 192.0.2.10 -t udp sp=12345,dp=54321 -c 0 -q \
+		-d 100msec &
+
+	# Test that if we set to 0 we get all packets
+	echo -e  "set alertmode summary\nset ns 0\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q $NS1INUM $dir/output.txt
+	local ret1=$?
+	grep -q $NS2INUM $dir/output.txt
+	local ret2=$?
+	(( ret1 == 0 && ret2 == 0 ))
+	log_test $? 0 "No filtering"
+
+	# Set filter to a non-existant ns and we should see nothing
+	echo -e  "set alertmode summary\nset ns -1\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q drops $dir/output.txt
+	log_test $? 1 "Filter everything"
+
+	# Set filter to NS1 so we shouldn't see NS2
+	echo -e  "set ns $NS1INUM\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q $NS2INUM $dir/output.txt
+	log_test $? 1 "NS2 packet drop filtered"
+
+	# Return filter to 0 and ensure everything is fine
+	echo -e  "set ns 0\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q $NS1INUM $dir/output.txt
+	ret1=$?
+	grep -q $NS2INUM $dir/output.txt
+	ret2=$?
+	(( ret1 == 0 && ret2 == 0 ))
+	log_test $? 0 "Filtering reset"
+
+	# disable ns capability at all
+	echo -e  "set ns off\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q ns: $dir/output.txt
+	log_test $? 1 "Filtering disabled"
+
 	timeout 5 dwdump -o sw -w ${dir}/packets.pcap
 	(( $(tshark -r ${dir}/packets.pcap \
 		-Y 'ip.dst == 192.0.2.10' 2> /dev/null | wc -l) != 0))
@@ -83,7 +131,8 @@ sw_drops_test()
 
 	rm ${dir}/packets.pcap
 
-	{ kill %% && wait %%; } 2>/dev/null
+	{ kill $(jobs -p) && wait $(jobs -p); } 2> /dev/null
+
 	timeout 5 dwdump -o sw -w ${dir}/packets.pcap
 	(( $(tshark -r ${dir}/packets.pcap \
 		-Y 'ip.dst == 192.0.2.10' 2> /dev/null | wc -l) == 0))
@@ -103,16 +152,56 @@ hw_drops_test()
 
 	local dir=$(mktemp -d)
 
-	$DEVLINK trap set $DEVLINK_DEV trap blackhole_route action trap
+	devlink -N ns1 trap set $DEVLINK_DEV1 trap blackhole_route action trap
+	devlink -N ns2 trap set $DEVLINK_DEV2 trap blackhole_route action trap
+
+	# Test that if we set to 0 we get all packets
+	echo -e  "set alertmode summary\nset ns 0\nset hw true\nstart" \
+		| timeout -s 2 5 dropwatch &> $dir/output.txt
+	#echo -e  "set hw true\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -Eq ".*blackhole_route \[hardware\] \[ns: $NS1INUM\]" $dir/output.txt
+	local ret1=$?
+	grep -Eq ".*blackhole_route \[hardware\] \[ns: $NS2INUM\]" $dir/output.txt
+	local ret2=$?
+	(( ret1 == 0 && ret2 == 0 ))
+	log_test $? 0 "No filtering"
+
+	# Set filter to a non-existant ns and we should see nothing
+	echo -e  "set ns -1\nset hw true\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q "\[hardware\]" $dir/output.txt
+	log_test $? 1 "Filter everything"
+
+	# Set filter to NS1 so we shouldn't see NS2
+	echo -e  "set ns $NS1INUM\nset hw true\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q $NS2INUM $dir/output.txt
+	log_test $? 1 "NS2 packet drop filtered"
+
+	# Return filter to 0 and ensure everything is fine
+	echo -e  "set ns 0\nset hw true\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -Eq ".*blackhole_route \[hardware\] \[ns: $NS1INUM\]" $dir/output.txt
+	local ret1=$?
+	grep -Eq ".*blackhole_route \[hardware\] \[ns: $NS2INUM\]" $dir/output.txt
+	local ret2=$?
+	(( ret1 == 0 && ret2 == 0 ))
+	log_test $? 0 "Filtering reset"
+
+	# disable ns capability at all
+	echo -e  "set ns off\nset hw true\nstart" | timeout -s 2 5 dropwatch &> $dir/output.txt
+	grep -q ns: $dir/output.txt
+	log_test $? 1 "Filtering disabled"
+
 	timeout 5 dwdump -o hw -w ${dir}/packets.pcap
 	(( $(tshark -r ${dir}/packets.pcap \
 		-Y 'net_dm.hw_trap_name== blackhole_route' 2> /dev/null \
 		| wc -l) != 0))
 	log_test $? 0 "Capturing active hardware drops"
 
+	cp ${dir}/packets.pcap /root/host/
 	rm ${dir}/packets.pcap
 
-	$DEVLINK trap set $DEVLINK_DEV trap blackhole_route action drop
+	devlink -N ns1 trap set $DEVLINK_DEV1 trap blackhole_route action drop
+	devlink -N ns2 trap set $DEVLINK_DEV2 trap blackhole_route action drop
+
 	timeout 5 dwdump -o hw -w ${dir}/packets.pcap
 	(( $(tshark -r ${dir}/packets.pcap \
 		-Y 'net_dm.hw_trap_name== blackhole_route' 2> /dev/null \
-- 
2.34.1

