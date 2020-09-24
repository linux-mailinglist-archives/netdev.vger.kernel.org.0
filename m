Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB2C27786B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgIXSVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:21:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:39348 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgIXSVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:21:42 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLVsA-00040c-2K; Thu, 24 Sep 2020 20:21:38 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 5/6] bpf, selftests: use bpf_tail_call_static where appropriate
Date:   Thu, 24 Sep 2020 20:21:26 +0200
Message-Id: <0c8a5df84b2f174412c252ad32734d3545947b31.1600967205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1600967205.git.daniel@iogearbox.net>
References: <cover.1600967205.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For those locations where we use an immediate tail call map index use the
newly added bpf_tail_call_static() helper.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 12 ++++----
 tools/testing/selftests/bpf/progs/tailcall1.c | 28 +++++++++----------
 tools/testing/selftests/bpf/progs/tailcall2.c | 14 +++++-----
 tools/testing/selftests/bpf/progs/tailcall3.c |  4 +--
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |  4 +--
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  6 ++--
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |  6 ++--
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  6 ++--
 8 files changed, 40 insertions(+), 40 deletions(-)

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

