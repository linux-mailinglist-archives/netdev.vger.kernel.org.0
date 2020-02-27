Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69778170D16
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgB0AOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:14:55 -0500
Received: from gateway33.websitewelcome.com ([192.185.145.24]:43672 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728062AbgB0AOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 19:14:55 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 1085A611B44
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 18:14:54 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 76pKj8kMiEfyq76pKjEU9m; Wed, 26 Feb 2020 18:14:54 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rT7WWpbwpV4IGTwJi8+zKDNGXv/0UC4c4qJjI8DSims=; b=lwas1jZ90oaNkKFa69uzbJ6nsD
        Dsa2eSzd57FeJ/svt+i01heuytDqQpXLgToXu1nOutwL2WRWLX+A9ZRTrzvRc0pPOcD1cjbjq8/ln
        /LaRrTtPLevkeWR7NX4bIdMaog8FLXeYRobIQ23p8Vc/ORiqncCH3wPJhFUvpcj95gd23V21MnfY3
        0QxUEWzUb5NEK4uOobm6ynoSoj4cIBYwV1andiT1GZY/NIbek3mPg4GgCWChr5OGTxVDXKY1dLoOu
        Wg6Z4fD0f1mY1zp4w/ImfDP3H/9o74YrKBMaHhmyXJKQFHaL1dBD1w8KH+j4DfUuGTE732Gx1/GK4
        eckdxPfA==;
Received: from [201.162.161.175] (port=59980 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j76pI-002FPo-6l; Wed, 26 Feb 2020 18:14:52 -0600
Date:   Wed, 26 Feb 2020 18:17:44 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] bpf: Replace zero-length array with flexible-array member
Message-ID: <20200227001744.GA3317@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.161.175
X-Source-L: No
X-Exim-ID: 1j76pI-002FPo-6l
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.161.175]:59980
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 include/linux/bpf-cgroup.h  | 2 +-
 include/linux/bpf.h         | 2 +-
 include/uapi/linux/bpf.h    | 2 +-
 kernel/bpf/bpf_struct_ops.c | 2 +-
 kernel/bpf/hashtab.c        | 2 +-
 kernel/bpf/lpm_trie.c       | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a11d5b7dbbf3..a7cd5c7a2509 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -36,7 +36,7 @@ struct bpf_cgroup_storage_map;
 
 struct bpf_storage_buffer {
 	struct rcu_head rcu;
-	char data[0];
+	char data[];
 };
 
 struct bpf_cgroup_storage {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1acd5bf70350..9aa33b8f3d55 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -859,7 +859,7 @@ struct bpf_prog_array_item {
 
 struct bpf_prog_array {
 	struct rcu_head rcu;
-	struct bpf_prog_array_item items[0];
+	struct bpf_prog_array_item items[];
 };
 
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 906e9f2752db..8e98ced0963b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -73,7 +73,7 @@ struct bpf_insn {
 /* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
 struct bpf_lpm_trie_key {
 	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
-	__u8	data[0];	/* Arbitrary size */
+	__u8	data[];	/* Arbitrary size */
 };
 
 struct bpf_cgroup_storage_key {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 042f95534f86..c498f0fffb40 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -23,7 +23,7 @@ enum bpf_struct_ops_state {
 
 struct bpf_struct_ops_value {
 	BPF_STRUCT_OPS_COMMON_VALUE;
-	char data[0] ____cacheline_aligned_in_smp;
+	char data[] ____cacheline_aligned_in_smp;
 };
 
 struct bpf_struct_ops_map {
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 53d9483fee10..d541c8486c95 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -118,7 +118,7 @@ struct htab_elem {
 		struct bpf_lru_node lru_node;
 	};
 	u32 hash;
-	char key[0] __aligned(8);
+	char key[] __aligned(8);
 };
 
 static inline bool htab_is_prealloc(const struct bpf_htab *htab)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 3b3c420bc8ed..65c236cf341e 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -25,7 +25,7 @@ struct lpm_trie_node {
 	struct lpm_trie_node __rcu	*child[2];
 	u32				prefixlen;
 	u32				flags;
-	u8				data[0];
+	u8				data[];
 };
 
 struct lpm_trie {
-- 
2.25.0

