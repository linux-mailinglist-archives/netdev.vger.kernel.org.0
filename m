Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A82FE9CC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbhAUMSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:18:14 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54710 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729929AbhAUMRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:17:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5BFE72035C;
        Thu, 21 Jan 2021 13:16:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JHru7HleNCul; Thu, 21 Jan 2021 13:16:03 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EC7572026E;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:16:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:16:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BA2C63182E98;
 Thu, 21 Jan 2021 13:16:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/5] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Date:   Thu, 21 Jan 2021 13:15:58 +0100
Message-ID: <20210121121558.621339-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121121558.621339-1-steffen.klassert@secunet.com>
References: <20210121121558.621339-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Visa Hankala <visa@hankala.org>

Use three-way comparison for address components to avoid integer
wraparound in the result of xfrm_policy_addr_delta(). This ensures
that the search trees are built and traversed correctly.

Treat IPv4 and IPv6 similarly by returning 0 when prefixlen == 0.
Prefix /0 has only one equivalence class.

Fixes: 9cf545ebd591d ("xfrm: policy: store inexact policies in a tree ordered by destination address")
Signed-off-by: Visa Hankala <visa@hankala.org>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c                     | 26 +++++++++----
 tools/testing/selftests/net/xfrm_policy.sh | 43 ++++++++++++++++++++++
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 2f84136af48a..b74f28cabe24 100644
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
index 5922941e70c6..bdf450eaf60c 100755
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
-- 
2.25.1

