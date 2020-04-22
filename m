Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911D01B4F74
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 23:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDVVkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 17:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDVVkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 17:40:23 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D8B20781;
        Wed, 22 Apr 2020 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587591623;
        bh=q7gvLfkKNG0l/eA45XopwzvMK2nkm9+t3mU297up0fI=;
        h=From:To:Cc:Subject:Date:From;
        b=hioCJ5L0WJYgZzPGTOFlW72rKu589dMcjojrmUD+o78FVbYDSY2N9832+jS+eNH34
         ZxTlV8OWkTVskMWcKuPoqKRPbnWy/V0ODYc6HssGOkBI3ySzpxxKCXX2Ib3n0CHY4D
         rCMn6REawEYcGrPR6mMie/3TlmsGilnJvI/3Ejjg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: Update fib_select_default to handle nexthop objects
Date:   Wed, 22 Apr 2020 15:40:20 -0600
Message-Id: <20200422214020.72107-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A user reported [0] hitting the WARN_ON in fib_info_nh:

    [ 8633.839816] ------------[ cut here ]------------
    [ 8633.839819] WARNING: CPU: 0 PID: 1719 at include/net/nexthop.h:251 fib_select_path+0x303/0x381
    ...
    [ 8633.839846] RIP: 0010:fib_select_path+0x303/0x381
    ...
    [ 8633.839848] RSP: 0018:ffffb04d407f7d00 EFLAGS: 00010286
    [ 8633.839850] RAX: 0000000000000000 RBX: ffff9460b9897ee8 RCX: 00000000000000fe
    [ 8633.839851] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
    [ 8633.839852] RBP: ffff946076049850 R08: 0000000059263a83 R09: ffff9460840e4000
    [ 8633.839853] R10: 0000000000000014 R11: 0000000000000000 R12: ffffb04d407f7dc0
    [ 8633.839854] R13: ffffffffa4ce3240 R14: 0000000000000000 R15: ffff9460b7681f60
    [ 8633.839857] FS:  00007fcac2e02700(0000) GS:ffff9460bdc00000(0000) knlGS:0000000000000000
    [ 8633.839858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 8633.839859] CR2: 00007f27beb77e28 CR3: 0000000077734000 CR4: 00000000000006f0
    [ 8633.839867] Call Trace:
    [ 8633.839871]  ip_route_output_key_hash_rcu+0x421/0x890
    [ 8633.839873]  ip_route_output_key_hash+0x5e/0x80
    [ 8633.839876]  ip_route_output_flow+0x1a/0x50
    [ 8633.839878]  __ip4_datagram_connect+0x154/0x310
    [ 8633.839880]  ip4_datagram_connect+0x28/0x40
    [ 8633.839882]  __sys_connect+0xd6/0x100
    ...

The WARN_ON is triggered in fib_select_default which is invoked when
there are multiple default routes. Update the function to use
fib_info_nhc and convert the nexthop checks to use fib_nh_common.

Add test case that covers the affected code path.

[0] https://github.com/FRRouting/frr/issues/6089

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_semantics.c                    |  6 +++---
 tools/testing/selftests/net/fib_nexthops.sh | 23 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 6ed8c9317179..55ca2e521828 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2014,7 +2014,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 
 	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
 		struct fib_info *next_fi = fa->fa_info;
-		struct fib_nh *nh;
+		struct fib_nh_common *nhc;
 
 		if (fa->fa_slen != slen)
 			continue;
@@ -2037,8 +2037,8 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 		    fa->fa_type != RTN_UNICAST)
 			continue;
 
-		nh = fib_info_nh(next_fi, 0);
-		if (!nh->fib_nh_gw4 || nh->fib_nh_scope != RT_SCOPE_LINK)
+		nhc = fib_info_nhc(next_fi, 0);
+		if (!nhc->nhc_gw_family || nhc->nhc_scope != RT_SCOPE_LINK)
 			continue;
 
 		fib_alias_accessed(fa);
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 796670ebc65b..6560ed796ac4 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -749,6 +749,29 @@ ipv4_fcnal_runtime()
 	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
 	log_test $? 0 "Ping - multipath"
 
+	run_cmd "$IP ro delete 172.16.101.1/32 nhid 122"
+
+	#
+	# multiple default routes
+	# - tests fib_select_default
+	run_cmd "$IP nexthop add id 501 via 172.16.1.2 dev veth1"
+	run_cmd "$IP ro add default nhid 501"
+	run_cmd "$IP ro add default via 172.16.1.3 dev veth1 metric 20"
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "Ping - multiple default routes, nh first"
+
+	# flip the order
+	run_cmd "$IP ro del default nhid 501"
+	run_cmd "$IP ro del default via 172.16.1.3 dev veth1 metric 20"
+	run_cmd "$IP ro add default via 172.16.1.2 dev veth1 metric 20"
+	run_cmd "$IP nexthop replace id 501 via 172.16.1.3 dev veth1"
+	run_cmd "$IP ro add default nhid 501 metric 20"
+	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	log_test $? 0 "Ping - multiple default routes, nh second"
+
+	run_cmd "$IP nexthop delete nhid 501"
+	run_cmd "$IP ro del default"
+
 	#
 	# IPv4 with blackhole nexthops
 	#
-- 
2.20.1

