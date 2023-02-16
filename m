Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B8698B15
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjBPDQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBPDQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:16:56 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B14C36473;
        Wed, 15 Feb 2023 19:16:55 -0800 (PST)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PHKk06592zFqRh;
        Thu, 16 Feb 2023 11:12:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 16 Feb
 2023 11:16:52 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net,v2,2/2] selftests: fib_tests: Add test cases for IPv4/IPv6 in route notify
Date:   Thu, 16 Feb 2023 12:26:24 +0800
Message-ID: <20230216042624.4069910-3-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230216042624.4069910-1-luwei32@huawei.com>
References: <20230216042624.4069910-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to check whether the total fib info length is calculated
corretly in route notify process.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 tools/testing/selftests/net/fib_tests.sh | 92 +++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 5637b5dadabd..4e48154bd195 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle ipv4_bcast_neigh"
+TESTS="unregister down carrier nexthop suppress ipv6_notify ipv4_notify ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle ipv4_bcast_neigh"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -655,6 +655,94 @@ fib_nexthop_test()
 	cleanup
 }
 
+fib6_notify_test()
+{
+	setup
+
+	echo
+	echo "Fib6 info length calculation in route notify test"
+	set -e
+
+	for i in 10 20 30 40 50 60 70;
+	do
+		$IP link add dummy$i type dummy
+		$IP link set dev dummy$i up
+		$IP -6 addr add 2002::$i/64 dev dummy$i
+	done
+
+	for i in 10 20 30 40 50 60;
+	do
+		$IP -6 route append 100::/64 encap ip6 dst 2002::$i via \
+		2002::1 dev dummy$i metric 100
+	done
+
+	set +e
+
+	$NS_EXEC ip monitor route 2> errors.txt &
+
+	$IP -6 route append 100::/64 via 2002::1 dev dummy70 metric 100
+
+	err=`cat errors.txt |grep "Message too long"`
+	if [ -z "$err" ];then
+		ret=0
+	else
+		ret=1
+	fi
+
+	log_test $ret 0 "ipv6 route add notify"
+
+	{ kill %% && wait %%; } 2>/dev/null
+
+	rm errors.txt
+
+	cleanup &> /dev/null
+}
+
+
+fib_notify_test()
+{
+	setup
+
+	echo
+	echo "Fib4 info length calculation in route notify test"
+
+	set -e
+
+	for i in 10 20 30 40 50 60 70;
+	do
+		$IP link add dummy$i type dummy
+		$IP link set dev dummy$i up
+		$IP addr add 192.168.100.$i/24 dev dummy$i
+	done
+
+	for i in 10 20 30 40 50 60;
+	do
+		$IP route append 10.0.0.0/24 encap ip dst 192.168.100.$i via \
+		192.168.100.1 dev dummy$i metric 100
+	done
+
+	$NS_EXEC ip monitor route 2> errors.txt &
+
+	set +e
+
+	$IP route append 10.0.0.0/24 via 192.168.100.1 dev dummy70 metric 100
+
+	err=`cat errors.txt |grep "Message too long"`
+	if [ -z "$err" ];then
+		ret=0
+	else
+		ret=1
+	fi
+
+	log_test $ret 0 "ipv4 route add notify"
+
+	{ kill %% && wait %%; } 2>/dev/null
+
+	rm errors.txt
+
+	cleanup &> /dev/null
+}
+
 fib_suppress_test()
 {
 	echo
@@ -2109,6 +2197,8 @@ do
 	fib_carrier_test|carrier)	fib_carrier_test;;
 	fib_rp_filter_test|rp_filter)	fib_rp_filter_test;;
 	fib_nexthop_test|nexthop)	fib_nexthop_test;;
+	fib_notify_test|ipv4_notify)	fib_notify_test;;
+	fib6_notify_test|ipv6_notify)	fib6_notify_test;;
 	fib_suppress_test|suppress)	fib_suppress_test;;
 	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
-- 
2.31.1

