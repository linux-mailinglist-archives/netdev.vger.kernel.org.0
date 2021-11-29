Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B797D4626D2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhK2W5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:57:48 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:33453 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbhK2W5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:57:22 -0500
Received: by mail-qt1-f174.google.com with SMTP id n15so18362015qta.0;
        Mon, 29 Nov 2021 14:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LFzXZvSu/hYGCGAXuiBJLb7IpGiGNx/uzZ+EjDroC6A=;
        b=Jb14raQNKKUNxQ30i8vIk4wGeUdpJs8lCBV6D1oS4qoPEwrQJdld58u1Ux4zEK2DrN
         z/3DxRU12zWbN+bAvPIvbgCwKm1aV7WcsfAQ/W9/MV9prY5ygLpL82ftyElmEL917nLy
         Op/TU1byrRACpH+SIOkuYROy/FFrKfFNan/iW1cN0gszfSAzdtylegc0BazL6sloI/PZ
         9ALYd0YNkk4cIbxT6oIEpx3eLTyR8fJp7yMUPSFNQ2VOLFbr8P2AOvGay67P7Oagv7cZ
         Yfq0PGIkcf/0QvmoCNrgEAZOd73HtE7UZvPqUassZR180titvdAwRsZQFJowRFhEvq48
         DRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LFzXZvSu/hYGCGAXuiBJLb7IpGiGNx/uzZ+EjDroC6A=;
        b=Lykjfgsz6Z6NPrEthGOu9LbyYC5gq8LWVn3VAmBNyZNl1HwrZoMU3xsiX/1/gtatBD
         VqV98N0R4f4Ek9m7W8qb8mlWdr7LXzbPCGMqhx87zrbOa11zpVqHejexIHw4T/KdcLVM
         A0EK183nebqcFzZRSJAfBY7y1/B+hrfSaJqMR03mDbIXPKxI7HN+mhjRtUwp8bl2wWCe
         LtoswVWcEvP+f6PwqJHc3/41ZLpX3F4tE9qAj7KR8i8uvnULuYPDNDnnf/NC0ESm2lor
         oHYGF6dBobjcjZ2CVwYIPUm6M2j3SIStBbnfMSEFWWxZmpDcTl2ihT+HRtnOM4oGzRPh
         haBw==
X-Gm-Message-State: AOAM530qoPoC/juLCd/ppgNimNEMOVQN/gzUw6zXUdiwJ3m0CnCYKEY0
        QalcSWETfQenx/Q9a4H1Xg==
X-Google-Smtp-Source: ABdhPJxUKySSC3R6DZ/z16u+gLky30MR9ehiOkeuqjIm6otqMEjlKQBVZuHc70t8lrEPMv4l+x1Lgg==
X-Received: by 2002:ac8:4459:: with SMTP id m25mr37794060qtn.659.1638226383512;
        Mon, 29 Nov 2021 14:53:03 -0800 (PST)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id b6sm9611057qtk.91.2021.11.29.14.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:53:03 -0800 (PST)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] selftests/fib_tests: ping from dummy0 in fib_rp_filter_test()
Date:   Mon, 29 Nov 2021 14:52:30 -0800
Message-Id: <20211129225230.3668-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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
ping_lookup() for SOCK_ICMP sockets.

Fix the tests by binding to dummy0 instead.  Redirect ping requests to
dummy1 before redirecting them again to lo, so that sk->sk_bound_dev_if
agrees with our routing table.

These tests used to pass due to a bug [1] in iputils, where "ping -I"
actually did not bind ICMP message sockets to device.  The bug has been
fixed by iputils commit f455fee41c07 ("ping: also bind the ICMP socket
to the specific device") in 2016, which is why our rp_filter tests
started to fail.  See [2] .

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
 tools/testing/selftests/net/fib_tests.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 5abe92d55b69..b8bceae00f8e 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -453,15 +453,19 @@ fib_rp_filter_test()
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
 	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
 
+	$NS_EXEC tc qd add dev dummy0 parent root handle 1: fq_codel
+	$NS_EXEC tc filter add dev dummy0 parent 1: protocol arp basic action mirred egress redirect dev dummy1
+	$NS_EXEC tc filter add dev dummy0 parent 1: protocol ip basic action mirred egress redirect dev dummy1
+
 	$NS_EXEC tc qd add dev dummy1 parent root handle 1: fq_codel
 	$NS_EXEC tc filter add dev dummy1 parent 1: protocol arp basic action mirred egress redirect dev lo
 	$NS_EXEC tc filter add dev dummy1 parent 1: protocol ip basic action mirred egress redirect dev lo
 	set +e
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 198.51.100.1"
+	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 198.51.100.1"
 	log_test $? 0 "rp_filter passes local packets"
 
-	run_cmd "ip netns exec ns1 ping -I dummy1 -w1 -c1 127.0.0.1"
+	run_cmd "ip netns exec ns1 ping -I dummy0 -w1 -c1 127.0.0.1"
 	log_test $? 0 "rp_filter passes loopback packets"
 
 	cleanup
-- 
2.20.1

