Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623642E7AFE
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgL3QQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgL3QQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:16:43 -0500
Received: from vale.hankala.org (vale.hankala.org [IPv6:2a02:2770:3:0:21a:4aff:fefb:f65c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CD7C06179B
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 08:16:02 -0800 (PST)
Received: by vale.hankala.org (OpenSMTPD) with ESMTPS id 3ab65689 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Dec 2020 16:15:55 +0000 (UTC)
Date:   Wed, 30 Dec 2020 16:15:53 +0000
From:   Visa Hankala <visa@hankala.org>
To:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20201230160902.sYeDeDSVSPay2WBC@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use three-way comparison for address components to avoid integer
wraparound in the result of xfrm_policy_addr_delta(). This ensures
that the search trees are built and traversed correctly.

Treat IPv4 and IPv6 similarly by returning 0 when prefixlen == 0.
Prefix /0 has only one equivalence class.

Fixes: 9cf545ebd591d ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Signed-off-by: Visa Hankala <visa@hankala.org>
---
 net/xfrm/xfrm_policy.c                     | 26 +++++++++----
 tools/testing/selftests/net/xfrm_policy.sh | 43 ++++++++++++++++++++++
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d622c2548d22..68258ff6a30b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -793,15 +793,22 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				  const xfrm_address_t *b,
 				  u8 prefixlen, u16 family)
 {
+	u32 ma, mb, mask;
 	unsigned int pdw, pbi;
 	int delta = 0;
 
 	switch (family) {
 	case AF_INET:
-		if (sizeof(long) == 4 && prefixlen == 0)
-			return ntohl(a->a4) - ntohl(b->a4);
-		return (ntohl(a->a4) & ((~0UL << (32 - prefixlen)))) -
-		       (ntohl(b->a4) & ((~0UL << (32 - prefixlen))));
+		if (prefixlen == 0)
+			return 0;
+		mask = ~0U << (32 - prefixlen);
+		ma = ntohl(a->a4) & mask;
+		mb = ntohl(b->a4) & mask;
+		if (ma < mb)
+			delta = -1;
+		else if (ma > mb)
+			delta = 1;
+		break;
 	case AF_INET6:
 		pdw = prefixlen >> 5;
 		pbi = prefixlen & 0x1f;
@@ -812,10 +819,13 @@ static int xfrm_policy_addr_delta(const xfrm_address_t *a,
 				return delta;
 		}
 		if (pbi) {
-			u32 mask = ~0u << (32 - pbi);
-
-			delta = (ntohl(a->a6[pdw]) & mask) -
-				(ntohl(b->a6[pdw]) & mask);
+			mask = ~0U << (32 - pbi);
+			ma = ntohl(a->a6[pdw]) & mask;
+			mb = ntohl(b->a6[pdw]) & mask;
+			if (ma < mb)
+				delta = -1;
+			else if (ma > mb)
+				delta = 1;
 		}
 		break;
 	default:
diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 7a1bf94c5bd3..9e2dffb670d5 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -287,6 +287,47 @@ check_hthresh_repeat()
 	return 0
 }
 
+# insert non-overlapping policies in a random order and check that
+# all of them can be fetched using the traffic selectors.
+check_random_order()
+{
+	local ns=$1
+	local log=$2
+
+	for i in $(seq 100); do
+		ip -net $ns xfrm policy flush
+		for j in $(seq 0 16 255 | sort -R); do
+			ip -net $ns xfrm policy add dst $j.0.0.0/24 dir out priority 10 action allow
+		done
+		for j in $(seq 0 16 255); do
+			if ! ip -net $ns xfrm policy get dst $j.0.0.0/24 dir out > /dev/null; then
+				echo "FAIL: $log" 1>&2
+				return 1
+			fi
+		done
+	done
+
+	for i in $(seq 100); do
+		ip -net $ns xfrm policy flush
+		for j in $(seq 0 16 255 | sort -R); do
+			local addr=$(printf "e000:0000:%02x00::/56" $j)
+			ip -net $ns xfrm policy add dst $addr dir out priority 10 action allow
+		done
+		for j in $(seq 0 16 255); do
+			local addr=$(printf "e000:0000:%02x00::/56" $j)
+			if ! ip -net $ns xfrm policy get dst $addr dir out > /dev/null; then
+				echo "FAIL: $log" 1>&2
+				return 1
+			fi
+		done
+	done
+
+	ip -net $ns xfrm policy flush
+
+	echo "PASS: $log"
+	return 0
+}
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
@@ -438,6 +479,8 @@ check_exceptions "exceptions and block policies after htresh change to normal"
 
 check_hthresh_repeat "policies with repeated htresh change"
 
+check_random_order ns3 "policies inserted in random order"
+
 for i in 1 2 3 4;do ip netns del ns$i;done
 
 exit $ret
