Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69F946294B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhK3AyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:54:11 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:42878 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhK3AyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:54:09 -0500
Received: by mail-qk1-f172.google.com with SMTP id g28so24947496qkk.9;
        Mon, 29 Nov 2021 16:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mZwUhNOlTldzwCySZH7KwoLjITrisyHGYQ8WGBoGe0A=;
        b=Y+jX5SsGSq6Z32i/Dvafwl07I3gQJxEtyADI/WcOjunOGMBOQ80o7e4eU9t4Eug5lF
         +RoMayesqSi7DaMfHjYUrRtoF2xntY7HEQe43pu39C60A77H9roBAc+4rwEz4G1D/puq
         iCFbm9zhOe8ptc1zBLV9EcYhYns2lFa8HE8y47wZM6HKRkAj58gwDkca3AALm7U3A6WF
         w/OwHxmmO6ECqrZx4qrpC9wOQexegQc4JWq334Fn+miT5NIKdQ5c0Adw8nu2vWI8UNPG
         k8jbkhK0ftq4E2rFuAFiRBfzgnPhLP3ivyna3ZfsErrDNNtX1pU8njkyiLAycAe/w8gS
         Frqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mZwUhNOlTldzwCySZH7KwoLjITrisyHGYQ8WGBoGe0A=;
        b=r+Y+k6e/HrV30bnjo0kmn40i9oJBKiQuX5E6upDB+slQx8YyvZcq3nGi4E3jPHvjPN
         Rj+3TqYkcbuPu5NyYWWM0M5MLSXuSlRdEcK8fAw1nX/zBMpEB6ZyREGO6Recmh4cAxYZ
         mrPWZPXfsXkbVR9ImM5uhnRMh3Np+l4yte3drgCn/dxbDsAN8htSvvdMrpIuJowrEPFz
         88Cu0k2Gg5gsGCeM3U0dXJAYNChz7wehMOY/ra+caWBxbDb5+ZjOH4mmqKjiM2Bs/dql
         lPcef4clHG1PTkfCfQ9GHGlGhySVgL/FiPeCckUU5SzRajMhomrYolMQk+m0ckgs4NN8
         jKNw==
X-Gm-Message-State: AOAM531Ftxg2VjalI/rEAJSo8VlM6qoRCnkksiOTrQyaF4ezT1IpX1nt
        OC8dbE05VMFPX/kLUWBBJg==
X-Google-Smtp-Source: ABdhPJxeUTniSksqY6gizoFDH8cXkZSbMiqtCG83/FA3cI9YuOBxjhfjNYnyRyF6SEOGHlMvpWrXdA==
X-Received: by 2002:a05:620a:151a:: with SMTP id i26mr42705229qkk.499.1638233391014;
        Mon, 29 Nov 2021 16:49:51 -0800 (PST)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id de40sm8858941qkb.99.2021.11.29.16.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:49:50 -0800 (PST)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] selftests/fib_tests: ping from dummy0 in fib_rp_filter_test()
Date:   Mon, 29 Nov 2021 16:49:05 -0800
Message-Id: <20211130004905.4146-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129225230.3668-1-yepeilin.cs@gmail.com>
References: <20211129225230.3668-1-yepeilin.cs@gmail.com>
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
ping_lookup() for SOCK_DGRAM sockets.

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
Change in v2:
    - s/SOCK_ICMP/SOCK_DGRAM/ in commit message

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

