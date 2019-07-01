Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370C015C72
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfEGFeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbfEGFet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:34:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC492087F;
        Tue,  7 May 2019 05:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207288;
        bh=4rqMIbNH1T94Qkf3TchZX3oe9AtHP7DZlNSvOzIFhGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOAeMg31beYg+y44eKhK7bOitJOTBQbNh2lfW+V7phcA2gV0V15AyCQ5tUFwzJCC0
         12bHL4DryJSnsTHu/xzZf7ZHGayKRGF+9Cqe9yi4F2OR/cPyhxaoNlPIBGuNu6qzgr
         nGUG7gCEmXajLJvVGrh/1o8PrDzarQ9At9VZv4p4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 65/99] netfilter: nat: fix icmp id randomization
Date:   Tue,  7 May 2019 01:31:59 -0400
Message-Id: <20190507053235.29900-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5bdac418f33f60b07a34e01e722889140ee8fac9 ]

Sven Auhagen reported that a 2nd ping request will fail if 'fully-random'
mode is used.

Reason is that if no proto information is given, min/max are both 0,
so we set the icmp id to 0 instead of chosing a random value between
0 and 65535.

Update test case as well to catch this, without fix this yields:
[..]
ERROR: cannot ping ns1 from ns2 with ip masquerade fully-random (attempt 2)
ERROR: cannot ping ns1 from ns2 with ipv6 masquerade fully-random (attempt 2)

... becaus 2nd ping clashes with existing 'id 0' icmp conntrack and gets
dropped.

Fixes: 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")
Reported-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c                  | 11 ++++--
 tools/testing/selftests/netfilter/nft_nat.sh | 36 +++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d159e9e7835b..ade527565127 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -358,9 +358,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	case IPPROTO_ICMPV6:
 		/* id is same for either direction... */
 		keyptr = &tuple->src.u.icmp.id;
-		min = range->min_proto.icmp.id;
-		range_size = ntohs(range->max_proto.icmp.id) -
-			     ntohs(range->min_proto.icmp.id) + 1;
+		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+			min = 0;
+			range_size = 65536;
+		} else {
+			min = ntohs(range->min_proto.icmp.id);
+			range_size = ntohs(range->max_proto.icmp.id) -
+				     ntohs(range->min_proto.icmp.id) + 1;
+		}
 		goto find_free_id;
 #if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
 	case IPPROTO_GRE:
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605c..3194007cf8d1 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -321,6 +321,7 @@ EOF
 
 test_masquerade6()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -354,13 +355,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip6 nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags"
 		lret=1
 	fi
 
@@ -397,19 +398,26 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip6 nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush ip6 nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IPv6 masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IPv6 masquerade $natflags for ns2"
 
 	return $lret
 }
 
 test_masquerade()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -417,7 +425,7 @@ test_masquerade()
 
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: canot ping ns1 from ns2"
+		echo "ERROR: cannot ping ns1 from ns2 $natflags"
 		lret=1
 	fi
 
@@ -443,13 +451,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquere $natflags"
 		lret=1
 	fi
 
@@ -485,13 +493,19 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IP masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IP masquerade $natflags for ns2"
 
 	return $lret
 }
@@ -750,8 +764,12 @@ test_local_dnat
 test_local_dnat6
 
 reset_counters
-test_masquerade
-test_masquerade6
+test_masquerade ""
+test_masquerade6 ""
+
+reset_counters
+test_masquerade "fully-random"
+test_masquerade6 "fully-random"
 
 reset_counters
 test_redirect
-- 
2.20.1

