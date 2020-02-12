Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D3159E99
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgBLBmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:42:23 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40008 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgBLBmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:42:23 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so375181pfh.7
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 17:42:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wNoyqgG4bdan6v7QAEOwx2fZ4oKSQ1fMyHxWFJ76cWc=;
        b=snKZN2sRYs7p8mI8Y9z4lzaOwhbVrvLgW3VveLOFQoEbXZhUXq+AxIuB/sPThzHlRk
         uBsGH0D/7VY+hY7guMzV+J3ySpPjGm3YHkCOPGwMqYJQ4A0ENeFmOPazcZeteJ1QMxDn
         aF5q3QDoZzbATuJ72DZwVlMCZ3oFYQKH3uqCivNq7JOuPspn2U3f4heywMfCA9OgQGZI
         sbyGnhqmhyuQfvnTFIvScEr0EYqgaulYbQxSKE9/3oScZ2vv/7MklSFZkZjhSAgd2yPM
         pabQflvcHfmt1PpQ3rGFfj/np8faXWq0TBEF1Pv1ACWUYV+w8v4oAvkMjvSwRS8fj6dM
         FMBA==
X-Gm-Message-State: APjAAAVSBsfN6LMyhV1KLhUTZ2SM5yIl3ASOrz8TVIN7noUYrwcAIrML
        MPnDizYKTLR1I71HkjyQFfBJI/mOmIM=
X-Google-Smtp-Source: APXvYqyfBbLmotVClLY9mP/aY1qOCsLXaZODfB/FxfE7XBYB0DZr1QpE9qkSq8ipdNqhIYM+VQLYJQ==
X-Received: by 2002:a63:f54c:: with SMTP id e12mr3373191pgk.181.1581471740834;
        Tue, 11 Feb 2020 17:42:20 -0800 (PST)
Received: from f3.synalogic.ca (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id 72sm6067843pfw.7.2020.02.11.17.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 17:42:19 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
Date:   Wed, 12 Feb 2020 10:41:06 +0900
Message-Id: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
longer possible to replace an ECMP-able route by a non ECMP-able route.
For example,
	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
	ip route replace 2001:db8::1/128 dev dummy0
does not work as expected.

Tweak the replacement logic so that point 3 in the log of the above commit
becomes:
3. If the new route is not ECMP-able, and no matching non-ECMP-able route
exists, replace matching ECMP-able route (if any) or add the new route.

We can now summarize the entire replace semantics to:
When doing a replace, prefer replacing a matching route of the same
"ECMP-able-ness" as the replace argument. If there is no such candidate,
fallback to the first route found.

Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 net/ipv6/ip6_fib.c                       | 7 ++++---
 tools/testing/selftests/net/fib_tests.sh | 6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 58fbde244381..72abf892302f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1102,8 +1102,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 					found++;
 					break;
 				}
-				if (rt_can_ecmp)
-					fallback_ins = fallback_ins ?: ins;
+				fallback_ins = fallback_ins ?: ins;
 				goto next_iter;
 			}
 
@@ -1146,7 +1145,9 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 	}
 
 	if (fallback_ins && !found) {
-		/* No ECMP-able route found, replace first non-ECMP one */
+		/* No matching route with same ecmp-able-ness found, replace
+		 * first matching route
+		 */
 		ins = fallback_ins;
 		iter = rcu_dereference_protected(*ins,
 				    lockdep_is_held(&rt->fib6_table->tb6_lock));
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 6dd403103800..60273f1bc7d9 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -910,6 +910,12 @@ ipv6_rt_replace_mpath()
 	check_route6 "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
 	log_test $? 0 "Multipath with single path via multipath attribute"
 
+	# multipath with dev-only
+	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
+	run_cmd "$IP -6 ro replace 2001:db8:104::/64 dev veth1"
+	check_route6 "2001:db8:104::/64 dev veth1 metric 1024"
+	log_test $? 0 "Multipath with dev-only"
+
 	# route replace fails - invalid nexthop 1
 	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
 	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:111::3 nexthop via 2001:db8:103::3"
-- 
2.25.0

