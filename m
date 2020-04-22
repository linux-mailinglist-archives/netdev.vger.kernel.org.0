Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956671B50A7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 01:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDVXIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 19:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDVXIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 19:08:24 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C0762076E;
        Wed, 22 Apr 2020 23:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587596903;
        bh=sWXg+5PMgt2I069BA/AikzoZTNqdydc7gaV7yjaQeMs=;
        h=From:To:Cc:Subject:Date:From;
        b=bKfCikyVuVgBxXTXBcno5xTpJr0bpNtn4GtDh41ketDR6w+BIWKLjZl3cy3UNeA4W
         NtqdO+TZca1ArqYe61TICGRennjEPmgPKBpj3x5sHo/WYx1gPS5ZCgvV84R/DtOZ4o
         7htsvokPQsE1E/BlwJBN4sTmv+X+sPhuX/3vWdHc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftests: A few improvements to fib_nexthops.sh
Date:   Wed, 22 Apr 2020 17:08:22 -0600
Message-Id: <20200422230822.72861-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add nodad when adding IPv6 addresses and remove the sleep.

A recent change to iproute2 moved the 'pref medium' to the prefix
(where it belongs). Change the expected route check to strip
'pref medium' to be compatible with old and new iproute2.

Add IPv4 runtime test with an IPv6 address as the gateway in
the default route.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 25 ++++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 6560ed796ac4..b785241127df 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -150,31 +150,31 @@ setup()
 	$IP li add veth1 type veth peer name veth2
 	$IP li set veth1 up
 	$IP addr add 172.16.1.1/24 dev veth1
-	$IP -6 addr add 2001:db8:91::1/64 dev veth1
+	$IP -6 addr add 2001:db8:91::1/64 dev veth1 nodad
 
 	$IP li add veth3 type veth peer name veth4
 	$IP li set veth3 up
 	$IP addr add 172.16.2.1/24 dev veth3
-	$IP -6 addr add 2001:db8:92::1/64 dev veth3
+	$IP -6 addr add 2001:db8:92::1/64 dev veth3 nodad
 
 	$IP li set veth2 netns peer up
 	ip -netns peer addr add 172.16.1.2/24 dev veth2
-	ip -netns peer -6 addr add 2001:db8:91::2/64 dev veth2
+	ip -netns peer -6 addr add 2001:db8:91::2/64 dev veth2 nodad
 
 	$IP li set veth4 netns peer up
 	ip -netns peer addr add 172.16.2.2/24 dev veth4
-	ip -netns peer -6 addr add 2001:db8:92::2/64 dev veth4
+	ip -netns peer -6 addr add 2001:db8:92::2/64 dev veth4 nodad
 
 	ip -netns remote li add veth5 type veth peer name veth6
 	ip -netns remote li set veth5 up
 	ip -netns remote addr add dev veth5 172.16.101.1/24
-	ip -netns remote addr add dev veth5 2001:db8:101::1/64
+	ip -netns remote -6 addr add dev veth5 2001:db8:101::1/64 nodad
 	ip -netns remote ro add 172.16.0.0/22 via 172.16.101.2
 	ip -netns remote -6 ro add 2001:db8:90::/40 via 2001:db8:101::2
 
 	ip -netns remote li set veth6 netns peer up
 	ip -netns peer addr add dev veth6 172.16.101.2/24
-	ip -netns peer addr add dev veth6 2001:db8:101::2/64
+	ip -netns peer -6 addr add dev veth6 2001:db8:101::2/64 nodad
 	set +e
 }
 
@@ -248,7 +248,7 @@ check_route6()
 	local expected="$2"
 	local out
 
-	out=$($IP -6 route ls match ${pfx} 2>/dev/null)
+	out=$($IP -6 route ls match ${pfx} 2>/dev/null | sed -e 's/pref medium//')
 
 	check_output "${out}" "${expected}"
 }
@@ -423,8 +423,6 @@ ipv6_fcnal_runtime()
 	echo "IPv6 functional runtime"
 	echo "-----------------------"
 
-	sleep 5
-
 	#
 	# IPv6 - the basics
 	#
@@ -481,12 +479,12 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP -6 nexthop add id 85 dev veth1"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 85"
 	log_test $? 0 "IPv6 route with device only nexthop"
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 85 dev veth1 metric 1024 pref medium"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 85 dev veth1 metric 1024"
 
 	run_cmd "$IP nexthop add id 123 group 81/85"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 123"
 	log_test $? 0 "IPv6 multipath route with nexthop mix - dev only + gw"
-	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 123 metric 1024 nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop dev veth1 weight 1 pref medium"
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 123 metric 1024 nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop dev veth1 weight 1"
 
 	#
 	# IPv6 route with v4 nexthop - not allowed
@@ -866,6 +864,11 @@ ipv4_fcnal_runtime()
 		$IP neigh sh | grep 'dev veth1'
 	fi
 
+	run_cmd "$IP ro del 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
+	run_cmd "$IP -4 ro add default via inet6 ${lladdr} dev veth1"
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "IPv4 default route with IPv6 gateway"
+
 	#
 	# MPLS as an example of LWT encap
 	#
-- 
2.20.1

