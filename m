Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B698427D9E7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgI2VXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:23:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:53020 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbgI2VXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:23:19 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNN5g-00077N-6D; Tue, 29 Sep 2020 23:23:16 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 5/6] bpf, selftests: use bpf_tail_call_static where appropriate
Date:   Tue, 29 Sep 2020 23:23:05 +0200
Message-Id: <7567cc9972d9c397346ecf27df57658b1f946eea.1601414174.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601414174.git.daniel@iogearbox.net>
References: <cover.1601414174.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For those locations where we use an immediate tail call map index use the
newly added bpf_tail_call_static() helper.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 samples/bpf/sockex3_kern.c                    | 20 +++++++------
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 12 ++++----
 tools/testing/selftests/bpf/progs/tailcall1.c | 28 +++++++++----------
 tools/testing/selftests/bpf/progs/tailcall2.c | 14 +++++-----
 tools/testing/selftests/bpf/progs/tailcall3.c |  4 +--
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |  4 +--
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  6 ++--
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |  6 ++--
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  6 ++--
 9 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index cab9cca0b8eb..8142d02b33e6 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -31,28 +31,30 @@ struct {
 #define PARSE_IP 3
 #define PARSE_IPV6 4
 
-/* protocol dispatch routine.
- * It tail-calls next BPF program depending on eth proto
- * Note, we could have used:
- * bpf_tail_call(skb, &jmp_table, proto);
- * but it would need large prog_array
+/* Protocol dispatch routine. It tail-calls next BPF program depending
+ * on eth proto. Note, we could have used ...
+ *
+ *   bpf_tail_call(skb, &jmp_table, proto);
+ *
+ * ... but it would need large prog_array and cannot be optimised given
+ * the map key is not static.
  */
 static inline void parse_eth_proto(struct __sk_buff *skb, u32 proto)
 {
 	switch (proto) {
 	case ETH_P_8021Q:
 	case ETH_P_8021AD:
-		bpf_tail_call(skb, &jmp_table, PARSE_VLAN);
+		bpf_tail_call_static(skb, &jmp_table, PARSE_VLAN);
 		break;
 	case ETH_P_MPLS_UC:
 	case ETH_P_MPLS_MC:
-		bpf_tail_call(skb, &jmp_table, PARSE_MPLS);
+		bpf_tail_call_static(skb, &jmp_table, PARSE_MPLS);
 		break;
 	case ETH_P_IP:
-		bpf_tail_call(skb, &jmp_table, PARSE_IP);
+		bpf_tail_call_static(skb, &jmp_table, PARSE_IP);
 		break;
 	case ETH_P_IPV6:
-		bpf_tail_call(skb, &jmp_table, PARSE_IPV6);
+		bpf_tail_call_static(skb, &jmp_table, PARSE_IPV6);
 		break;
 	}
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index de6de9221518..5a65f6b51377 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -118,18 +118,18 @@ static __always_inline int parse_eth_proto(struct __sk_buff *skb, __be16 proto)
 
 	switch (proto) {
 	case bpf_htons(ETH_P_IP):
-		bpf_tail_call(skb, &jmp_table, IP);
+		bpf_tail_call_static(skb, &jmp_table, IP);
 		break;
 	case bpf_htons(ETH_P_IPV6):
-		bpf_tail_call(skb, &jmp_table, IPV6);
+		bpf_tail_call_static(skb, &jmp_table, IPV6);
 		break;
 	case bpf_htons(ETH_P_MPLS_MC):
 	case bpf_htons(ETH_P_MPLS_UC):
-		bpf_tail_call(skb, &jmp_table, MPLS);
+		bpf_tail_call_static(skb, &jmp_table, MPLS);
 		break;
 	case bpf_htons(ETH_P_8021Q):
 	case bpf_htons(ETH_P_8021AD):
-		bpf_tail_call(skb, &jmp_table, VLAN);
+		bpf_tail_call_static(skb, &jmp_table, VLAN);
 		break;
 	default:
 		/* Protocol not supported */
@@ -246,10 +246,10 @@ static __always_inline int parse_ipv6_proto(struct __sk_buff *skb, __u8 nexthdr)
 	switch (nexthdr) {
 	case IPPROTO_HOPOPTS:
 	case IPPROTO_DSTOPTS:
-		bpf_tail_call(skb, &jmp_table, IPV6OP);
+		bpf_tail_call_static(skb, &jmp_table, IPV6OP);
 		break;
 	case IPPROTO_FRAGMENT:
-		bpf_tail_call(skb, &jmp_table, IPV6FR);
+		bpf_tail_call_static(skb, &jmp_table, IPV6FR);
 		break;
 	default:
 		return parse_ip_proto(skb, nexthdr);
diff --git a/tools/testing/selftests/bpf/progs/tailcall1.c b/tools/testing/selftests/bpf/progs/tailcall1.c
index 1f407e65ae52..7115bcefbe8a 100644
--- a/tools/testing/selftests/bpf/progs/tailcall1.c
+++ b/tools/testing/selftests/bpf/progs/tailcall1.c
@@ -26,20 +26,20 @@ int entry(struct __sk_buff *skb)
 	/* Multiple locations to make sure we patch
 	 * all of them.
 	 */
-	bpf_tail_call(skb, &jmp_table, 0);
-	bpf_tail_call(skb, &jmp_table, 0);
-	bpf_tail_call(skb, &jmp_table, 0);
-	bpf_tail_call(skb, &jmp_table, 0);
-
-	bpf_tail_call(skb, &jmp_table, 1);
-	bpf_tail_call(skb, &jmp_table, 1);
-	bpf_tail_call(skb, &jmp_table, 1);
-	bpf_tail_call(skb, &jmp_table, 1);
-
-	bpf_tail_call(skb, &jmp_table, 2);
-	bpf_tail_call(skb, &jmp_table, 2);
-	bpf_tail_call(skb, &jmp_table, 2);
-	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
+
+	bpf_tail_call_static(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
+
+	bpf_tail_call_static(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
 
 	return 3;
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall2.c b/tools/testing/selftests/bpf/progs/tailcall2.c
index a093e739cf0e..0431e4fe7efd 100644
--- a/tools/testing/selftests/bpf/progs/tailcall2.c
+++ b/tools/testing/selftests/bpf/progs/tailcall2.c
@@ -13,14 +13,14 @@ struct {
 SEC("classifier/0")
 int bpf_func_0(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
 	return 0;
 }
 
 SEC("classifier/1")
 int bpf_func_1(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
 	return 1;
 }
 
@@ -33,25 +33,25 @@ int bpf_func_2(struct __sk_buff *skb)
 SEC("classifier/3")
 int bpf_func_3(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 4);
+	bpf_tail_call_static(skb, &jmp_table, 4);
 	return 3;
 }
 
 SEC("classifier/4")
 int bpf_func_4(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 3);
+	bpf_tail_call_static(skb, &jmp_table, 3);
 	return 4;
 }
 
 SEC("classifier")
 int entry(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 	/* Check multi-prog update. */
-	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
 	/* Check tail call limit. */
-	bpf_tail_call(skb, &jmp_table, 3);
+	bpf_tail_call_static(skb, &jmp_table, 3);
 	return 3;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/tailcall3.c b/tools/testing/selftests/bpf/progs/tailcall3.c
index cabda877cf0a..739dc2a51e74 100644
--- a/tools/testing/selftests/bpf/progs/tailcall3.c
+++ b/tools/testing/selftests/bpf/progs/tailcall3.c
@@ -16,14 +16,14 @@ SEC("classifier/0")
 int bpf_func_0(struct __sk_buff *skb)
 {
 	count++;
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 	return 1;
 }
 
 SEC("classifier")
 int entry(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
index b5d9c8e778ae..0103f3dd9f02 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
@@ -21,7 +21,7 @@ TAIL_FUNC(1)
 static __noinline
 int subprog_tail(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 
 	return skb->len * 2;
 }
@@ -29,7 +29,7 @@ int subprog_tail(struct __sk_buff *skb)
 SEC("classifier")
 int entry(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
 
 	return subprog_tail(skb);
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
index a004ab28ce28..7b1c04183824 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
@@ -14,9 +14,9 @@ static __noinline
 int subprog_tail(struct __sk_buff *skb)
 {
 	if (load_byte(skb, 0))
-		bpf_tail_call(skb, &jmp_table, 1);
+		bpf_tail_call_static(skb, &jmp_table, 1);
 	else
-		bpf_tail_call(skb, &jmp_table, 0);
+		bpf_tail_call_static(skb, &jmp_table, 0);
 	return 1;
 }
 
@@ -32,7 +32,7 @@ int bpf_func_0(struct __sk_buff *skb)
 SEC("classifier")
 int entry(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
index 96dbef2b6b7c..0d5482bea6c9 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
@@ -16,9 +16,9 @@ int subprog_tail2(struct __sk_buff *skb)
 	volatile char arr[64] = {};
 
 	if (load_word(skb, 0) || load_half(skb, 0))
-		bpf_tail_call(skb, &jmp_table, 10);
+		bpf_tail_call_static(skb, &jmp_table, 10);
 	else
-		bpf_tail_call(skb, &jmp_table, 1);
+		bpf_tail_call_static(skb, &jmp_table, 1);
 
 	return skb->len;
 }
@@ -28,7 +28,7 @@ int subprog_tail(struct __sk_buff *skb)
 {
 	volatile char arr[64] = {};
 
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 
 	return skb->len * 2;
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
index 98b40a95bc67..9a1b166b7fbe 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
@@ -14,21 +14,21 @@ static volatile int count;
 __noinline
 int subprog_tail_2(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 2);
+	bpf_tail_call_static(skb, &jmp_table, 2);
 	return skb->len * 3;
 }
 
 __noinline
 int subprog_tail_1(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 1);
+	bpf_tail_call_static(skb, &jmp_table, 1);
 	return skb->len * 2;
 }
 
 __noinline
 int subprog_tail(struct __sk_buff *skb)
 {
-	bpf_tail_call(skb, &jmp_table, 0);
+	bpf_tail_call_static(skb, &jmp_table, 0);
 	return skb->len;
 }
 
-- 
2.21.0

