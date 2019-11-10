Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C1F6504
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfKJDEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfKJCrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:47:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2255D2085B;
        Sun, 10 Nov 2019 02:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354019;
        bh=46aynxYa1blruQAizaAJje0TP9KsL3W8yOgn6Hl7da0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IM8kMdVN/A2E2G7ocmmJSEu4ac+QlZ6Bd4lrvQ0ep5qyP+fObnVrVBfwmzj18obpu
         VNxkrjDtkcWzcwnDrBQWzHaE7zysedzGKq2Uc6Rrrju1bRuXzku0M8UazSnEo9XAvN
         TkfZKUdOHEbRAo0GLu68VubUIE4+d6JhANYmeoNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 042/109] samples/bpf: fix compilation failure
Date:   Sat,  9 Nov 2019 21:44:34 -0500
Message-Id: <20191110024541.31567-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>

[ Upstream commit 32c009798385ce21080beaa87a9b95faad3acd1e ]

following commit:
commit d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
added struct bpf_flow_keys which conflicts with the struct with
same name in sockex2_kern.c and sockex3_kern.c

similar to commit:
commit 534e0e52bc23 ("samples/bpf: fix a compilation failure")
we tried the rename it "flow_keys" but it also conflicted with struct
having same name in include/net/flow_dissector.h. Hence renaming the
struct to "flow_key_record". Also, this commit doesn't fix the
compilation error completely because the similar struct is present in
sockex3_kern.c. Hence renaming it in both files sockex3_user.c and
sockex3_kern.c

Signed-off-by: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/sockex2_kern.c | 11 ++++++-----
 samples/bpf/sockex3_kern.c |  8 ++++----
 samples/bpf/sockex3_user.c |  4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
index f58acfc925561..f2f9dbc021b0d 100644
--- a/samples/bpf/sockex2_kern.c
+++ b/samples/bpf/sockex2_kern.c
@@ -14,7 +14,7 @@ struct vlan_hdr {
 	__be16 h_vlan_encapsulated_proto;
 };
 
-struct bpf_flow_keys {
+struct flow_key_record {
 	__be32 src;
 	__be32 dst;
 	union {
@@ -59,7 +59,7 @@ static inline __u32 ipv6_addr_hash(struct __sk_buff *ctx, __u64 off)
 }
 
 static inline __u64 parse_ip(struct __sk_buff *skb, __u64 nhoff, __u64 *ip_proto,
-			     struct bpf_flow_keys *flow)
+			     struct flow_key_record *flow)
 {
 	__u64 verlen;
 
@@ -83,7 +83,7 @@ static inline __u64 parse_ip(struct __sk_buff *skb, __u64 nhoff, __u64 *ip_proto
 }
 
 static inline __u64 parse_ipv6(struct __sk_buff *skb, __u64 nhoff, __u64 *ip_proto,
-			       struct bpf_flow_keys *flow)
+			       struct flow_key_record *flow)
 {
 	*ip_proto = load_byte(skb,
 			      nhoff + offsetof(struct ipv6hdr, nexthdr));
@@ -96,7 +96,8 @@ static inline __u64 parse_ipv6(struct __sk_buff *skb, __u64 nhoff, __u64 *ip_pro
 	return nhoff;
 }
 
-static inline bool flow_dissector(struct __sk_buff *skb, struct bpf_flow_keys *flow)
+static inline bool flow_dissector(struct __sk_buff *skb,
+				  struct flow_key_record *flow)
 {
 	__u64 nhoff = ETH_HLEN;
 	__u64 ip_proto;
@@ -198,7 +199,7 @@ struct bpf_map_def SEC("maps") hash_map = {
 SEC("socket2")
 int bpf_prog2(struct __sk_buff *skb)
 {
-	struct bpf_flow_keys flow = {};
+	struct flow_key_record flow = {};
 	struct pair *value;
 	u32 key;
 
diff --git a/samples/bpf/sockex3_kern.c b/samples/bpf/sockex3_kern.c
index 95907f8d2b17d..c527b57d3ec8a 100644
--- a/samples/bpf/sockex3_kern.c
+++ b/samples/bpf/sockex3_kern.c
@@ -61,7 +61,7 @@ struct vlan_hdr {
 	__be16 h_vlan_encapsulated_proto;
 };
 
-struct bpf_flow_keys {
+struct flow_key_record {
 	__be32 src;
 	__be32 dst;
 	union {
@@ -88,7 +88,7 @@ static inline __u32 ipv6_addr_hash(struct __sk_buff *ctx, __u64 off)
 }
 
 struct globals {
-	struct bpf_flow_keys flow;
+	struct flow_key_record flow;
 };
 
 struct bpf_map_def SEC("maps") percpu_map = {
@@ -114,14 +114,14 @@ struct pair {
 
 struct bpf_map_def SEC("maps") hash_map = {
 	.type = BPF_MAP_TYPE_HASH,
-	.key_size = sizeof(struct bpf_flow_keys),
+	.key_size = sizeof(struct flow_key_record),
 	.value_size = sizeof(struct pair),
 	.max_entries = 1024,
 };
 
 static void update_stats(struct __sk_buff *skb, struct globals *g)
 {
-	struct bpf_flow_keys key = g->flow;
+	struct flow_key_record key = g->flow;
 	struct pair *value;
 
 	value = bpf_map_lookup_elem(&hash_map, &key);
diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index 4d75674bee35e..741b899b693f3 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -13,7 +13,7 @@
 #define PARSE_IP_PROG_FD (prog_fd[0])
 #define PROG_ARRAY_FD (map_fd[0])
 
-struct flow_keys {
+struct flow_key_record {
 	__be32 src;
 	__be32 dst;
 	union {
@@ -64,7 +64,7 @@ int main(int argc, char **argv)
 	(void) f;
 
 	for (i = 0; i < 5; i++) {
-		struct flow_keys key = {}, next_key;
+		struct flow_key_record key = {}, next_key;
 		struct pair value;
 
 		sleep(1);
-- 
2.20.1

