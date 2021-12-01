Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7101B464406
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345861AbhLAAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbhLAAvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:51:17 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C07C061574;
        Tue, 30 Nov 2021 16:47:58 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id m17so19864905qvx.8;
        Tue, 30 Nov 2021 16:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TueRT9eXGPk5L3ZnZcGtoDgs9by54hZ+3rLa7zOmY0w=;
        b=UcK2oOSubesvikDIDI3VfCLRA5VzA3BZyo44N162ELaVWTrUFPkqTwBKasDyAUv/2B
         tPovKxZ1Xh/IHkArFJU8u3Ko26xk5vfwbuFFMgPp+t8HnowYe/obVkNeTQm8Kkp2fgJH
         3hJ8cqlSddwYuwUPv9DoUC+KMpr51Oiwt7NzQXOGE24o6F0mAwIm1J48coLtgrAogJx7
         9abaYEvAHe/FBT3Z/QKX5iksfcnXlUBM2mGyELiCZCdkJW32kJlIFo4KFgdasAN7vY2M
         DedxvuH3pX/sN2JDXJjigwsEZe3JIW95rD7wo1K+gybtMkNCYuYE9zpqGIHG1gQTUMfq
         uwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TueRT9eXGPk5L3ZnZcGtoDgs9by54hZ+3rLa7zOmY0w=;
        b=scCE1YPdqXGxOs0jPxggr/UdUGt565yy6hI5yjJRslLkhv7gflum8yQvocqJFy5bNw
         687KiB7zvhPAfabP/XGaprB9mZ5MnF5DeWKCY0eg6fRWhbL1zagpUx9uIv9MNhJn3JTw
         8k/Ds04oEYQIpImPUT9BTOI61f8raJYAwtyP7bncJcaFESQclcZ/iRSzIvRMSjP0mkZJ
         HWSsaf0YXadrUHrjFeiBjJi299ukRi0EiUKaGNvjs2HjTB2xFd96bBDvDcNTuVKrkNL0
         U5uniyKcyuJf+sc9W6R1gwpf/UbeiPSpDh+I6WhjgTJr3cUoyQ4I9Sb/x9d+K4zFIQvT
         p4lA==
X-Gm-Message-State: AOAM531Eket6MkfrugUT/dHaVPoLutBurmxRuHsXJHvaUX5ews+0cWI3
        O9xlp8PbTXT15kI6a1W7pQ==
X-Google-Smtp-Source: ABdhPJw5qPwfFkXJ4mkYl0p1UiX8dJsT0PjQT8t9dNj+XYqAFq3WqVHISSWefJ/OvBVWTMnV6RVlYw==
X-Received: by 2002:ad4:59c5:: with SMTP id el5mr2927524qvb.65.1638319677178;
        Tue, 30 Nov 2021 16:47:57 -0800 (PST)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id r65sm10365853qke.85.2021.11.30.16.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:47:56 -0800 (PST)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net v3] selftests/fib_tests: Rework fib_rp_filter_test()
Date:   Tue, 30 Nov 2021 16:47:20 -0800
Message-Id: <20211201004720.6357-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211130004905.4146-1-yepeilin.cs@gmail.com>
References: <20211130004905.4146-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently rp_filter tests in fib_tests.sh:fib_rp_filter_test() are
failing.  ping sockets are bound to dummy1 using the "-I" option
(SO_BINDTODEVICE), but socket lookup is failing when receiving ping
replies, since the routing table thinks they belong to dummy0.

For example, suppose ping is using a SOCK_RAW socket for ICMP messages.
When receiving ping replies, in __raw_v4_lookup(), sk->sk_bound_dev_if
is 3 (dummy1), but dif (skb_rtable(skb)->rt_iif) says 2 (dummy0), so the
raw_sk_bound_dev_eq() check fails.  Similar things happen in
ping_lookup() for SOCK_DGRAM sockets.

These tests used to pass due to a bug [1] in iputils, where "ping -I"
actually did not bind ICMP message sockets to device.  The bug has been
fixed by iputils commit f455fee41c07 ("ping: also bind the ICMP socket
to the specific device") in 2016, which is why our rp_filter tests
started to fail.  See [2] .

Fixing the tests while keeping everything in one netns turns out to be
nontrivial.  Rework the tests and build the following topology:

 ┌─────────────────────────────┐    ┌─────────────────────────────┐
 │  network namespace 1 (ns1)  │    │  network namespace 2 (ns2)  │
 │                             │    │                             │
 │  ┌────┐     ┌─────┐         │    │  ┌─────┐            ┌────┐  │
 │  │ lo │<───>│veth1│<────────┼────┼─>│veth2│<──────────>│ lo │  │
 │  └────┘     ├─────┴──────┐  │    │  ├─────┴──────┐     └────┘  │
 │             │192.0.2.1/24│  │    │  │192.0.2.1/24│             │
 │             └────────────┘  │    │  └────────────┘             │
 └─────────────────────────────┘    └─────────────────────────────┘

Consider sending an ICMP_ECHO packet A in ns2.  Both source and
destination IP addresses are 192.0.2.1, and we use strict mode rp_filter
in both ns1 and ns2:

  1. A is routed to lo since its destination IP address is one of ns2's
     local addresses (veth2);
  2. A is redirected from lo's egress to veth2's egress using mirred;
  3. A arrives at veth1's ingress in ns1;
  4. A is redirected from veth1's ingress to lo's ingress, again, using
     mirred;
  5. In __fib_validate_source(), fib_info_nh_uses_dev() returns false,
     since A was received on lo, but reverse path lookup says veth1;
  6. However A is not dropped since we have relaxed this check for lo in
     commit 66f8209547cc ("fib: relax source validation check for loopback
     packets");

Making sure A is not dropped here in this corner case is the whole point
of having this test.

  7. As A reaches the ICMP layer, an ICMP_ECHOREPLY packet, B, is
     generated;
  8. Similarly, B is redirected from lo's egress to veth1's egress (in
     ns1), then redirected once again from veth2's ingress to lo's
     ingress (in ns2), using mirred.

Also test "ping 127.0.0.1" from ns2.  It does not trigger the relaxed
check in __fib_validate_source(), but just to make sure the topology
works with loopback addresses.

Tested with ping from iputils 20210722-41-gf9fb573:

$ ./fib_tests.sh -t rp_filter

IPv4 rp_filter tests
    TEST: rp_filter passes local packets		[ OK ]
    TEST: rp_filter passes loopback packets		[ OK ]

[1] https://github.com/iputils/iputils/issues/55
[2] https://github.com/iputils/iputils/commit/f455fee41c077d4b700a473b2f5b3487b8febc1d

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: adb701d6cfa4 ("selftests: add a test case for rp_filter")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Change in v3:
    - "ping -I dummy0 198.51.100.1" always work (David Ahern
      <dsahern@gmail.com>); use a different approach instead

Change in v2:
    - s/SOCK_ICMP/SOCK_DGRAM/ in commit message

 tools/testing/selftests/net/fib_tests.sh | 59 ++++++++++++++++++++----
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 5abe92d55b69..996af1ae3d3d 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -444,24 +444,63 @@ fib_rp_filter_test()
 	setup
 
 	set -e
+	ip netns add ns2
+	ip netns set ns2 auto
+
+	ip -netns ns2 link set dev lo up
+
+	$IP link add name veth1 type veth peer name veth2
+	$IP link set dev veth2 netns ns2
+	$IP address add 192.0.2.1/24 dev veth1
+	ip -netns ns2 address add 192.0.2.1/24 dev veth2
+	$IP link set dev veth1 up
+	ip -netns ns2 link set dev veth2 up
+
 	$IP link set dev lo address 52:54:00:6a:c7:5e
-	$IP link set dummy0 address 52:54:00:6a:c7:5e
-	$IP link add dummy1 type dummy
-	$IP link set dummy1 address 52:54:00:6a:c7:5e
-	$IP link set dev dummy1 up
+	$IP link set dev veth1 address 52:54:00:6a:c7:5e
+	ip -netns ns2 link set dev lo address 52:54:00:6a:c7:5e
+	ip -netns ns2 link set dev veth2 address 52:54:00:6a:c7:5e
+
+	# 1. (ns2) redirect lo's egress to veth2's egress
+	ip netns exec ns2 tc qdisc add dev lo parent root handle 1: fq_codel
+	ip netns exec ns2 tc filter add dev lo parent 1: protocol arp basic \
+		action mirred egress redirect dev veth2
+	ip netns exec ns2 tc filter add dev lo parent 1: protocol ip basic \
+		action mirred egress redirect dev veth2
+
+	# 2. (ns1) redirect veth1's ingress to lo's ingress
+	$NS_EXEC tc qdisc add dev veth1 ingress
+	$NS_EXEC tc filter add dev veth1 ingress protocol arp basic \
+		action mirred ingress redirect dev lo
+	$NS_EXEC tc filter add dev veth1 ingress protocol ip basic \
+		action mirred ingress redirect dev lo
+
+	# 3. (ns1) redirect lo's egress to veth1's egress
+	$NS_EXEC tc qdisc add dev lo parent root handle 1: fq_codel
+	$NS_EXEC tc filter add dev lo parent 1: protocol arp basic \
+		action mirred egress redirect dev veth1
+	$NS_EXEC tc filter add dev lo parent 1: protocol ip basic \
+		action mirred egress redirect dev veth1
+
+	# 4. (ns2) redirect veth2's ingress to lo's ingress
+	ip netns exec ns2 tc qdisc add dev veth2 ingress
+	ip netns exec ns2 tc filter add dev veth2 ingress protocol arp basic \
+		action mirred ingress redirect dev lo
+	ip netns exec ns2 tc filter add dev veth2 ingress protocol ip basic \
+		action mirred ingress redirect dev lo
+
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.rp_filter=1
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
-
-	$NS_EXEC tc qd add dev dummy1 parent root handle 1: fq_codel
-	$NS_EXEC tc filter add dev dummy1 parent 1: protocol arp basic action mirred egress redirect dev lo
-	$NS_EXEC tc filter add dev dummy1 parent 1: protocol ip basic action mirred egress redirect dev lo
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.accept_local=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.route_localnet=1
 	set +e
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
+	run_cmd "ip netns exec ns2 ping -w1 -c1 192.0.2.1"
 	log_test $? 0 "rp_filter passes local packets"
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 127.0.0.1"
+	run_cmd "ip netns exec ns2 ping -w1 -c1 127.0.0.1"
 	log_test $? 0 "rp_filter passes loopback packets"
 
 	cleanup
-- 
2.20.1

