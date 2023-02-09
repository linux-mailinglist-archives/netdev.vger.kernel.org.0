Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A38F691145
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 20:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBITXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 14:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBITXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 14:23:46 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C6A69518
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 11:23:43 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 141so2290147pgc.0
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 11:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=95HxeBvzenu+ijIXFcOlNVKQdoWMdAneLWKscet2sE4=;
        b=BDAO7jx7KdqPedFQPrdTWfuyEDJC1PN9Bysq2Xo5zyh/C+lhvMzeTx6RtclgYDrV3v
         qSZgwQuXU+LzV2FHx/p3VYZ4Tvo+o1L6f/65gvupTIAsxwrBCt80sfQCf8tdZj7ipt6Z
         e+3xQGYtck+pjDbwAKDRrzWTGUOg0rlRr8seo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=95HxeBvzenu+ijIXFcOlNVKQdoWMdAneLWKscet2sE4=;
        b=N41df3gb1ugqs2VX41jpnW2xFA7Qotai1ogFLhKuEcDSCEIpfKpzLMiKo6WqDNG007
         3CyapnuKvcjFtm5Npjl5yvs65hmDkGgM/Xv1v/TkFwWRChKv0IaC+VP6nryVwHElfSOy
         LT91b/8rlPrXDU+VSlWVSF78UjnxscItC6WKL+gx5O21XdOAT++bGT8yCOFdDheVlhuE
         q/hj9Tfo9y9z4fzTHAfWPfDuIG5V8a9aOrXUs0MJ5BEbmqWE+U66eBHhnbCgmUFbWFAL
         zDfgsRgRVRNkp3+TNNaZYgzwqX5qs0V+f3R7pNqHKIzV4SbERLRBtriVDZX2taje68JT
         X9WA==
X-Gm-Message-State: AO0yUKX3CmIdgUUIrNIYUamQVuLfaZVzoCgT6GjVVLl2tFKaYpyyadsK
        /qpUAYjUspwylPoEo87DkeOL+w==
X-Google-Smtp-Source: AK7set/iKISfX4STDLBfTHgHasnaPFpDw/LhXElJRde7iIlzGSeOTIdimXbThAWtEzOwyjZEGwydtQ==
X-Received: by 2002:a05:6a00:1d0a:b0:5a8:473e:2fdc with SMTP id a10-20020a056a001d0a00b005a8473e2fdcmr4503466pfx.12.1675970623175;
        Thu, 09 Feb 2023 11:23:43 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id y19-20020a62b513000000b00589a7824703sm1784567pfe.194.2023.02.09.11.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 11:23:42 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Haowen Bai <baihaowen@meizu.com>, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
Date:   Thu,  9 Feb 2023 11:23:41 -0800
Message-Id: <20230209192337.never.690-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12186; h=from:subject:message-id; bh=9CDGuuBIAFANWICcv8yRx8EyXbGptyp5vGwRbdTQpPU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj5Ug8X1KSIuD8fW/lSvneIGxbcZoZyQmf+3nRXvx3 xxj+pEGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY+VIPAAKCRCJcvTf3G3AJisCD/ oCjOJhcBmsEVwaEpp16vu0DTw3/9s26uvI/Ri4f37vZngY3Zbn5VwWed6ssOsXO3jnrBgPtWIO9uQa dN9FG7bECnVjRB2qUgvBbymFmpujN1SORfuIcRd8qUw/1iDSYE8oYDvY7aV+uI2sKIJphLnf9tLJdE AEoUaatVMuWqbAU1MgLYL3eSG2WiwudQ5cp9XC+6kLlwg3wUpuwUUgiPmwjk/pNqUJiUWoj3SBx5Dr 9AFbSVQgZUSRpN+4zhQoUp+1dbvJ8e8wAvttA0KAo87k8O92WiMIy6do0dAF02Ls5W3wnf3XgO5ICR wpZnqKtLOyy+CU13ShKoINTKLF4zE+tE/kf3nP5wHBDZY0GkWg0OhEspuAFR9Y/yXLTn2s0nr5Wt+X BYoh6rKN6OVjZ+iYW17FriuRLlKTBaJU45x6u0CT3EwWYO4lPfSCLgI4qULx8ByMbG9aytWrrwefo8 PaOYexquNLddZ+q7agEpbv4CSd1N2J5R0JkzarKExfwGC/dsBXz4R0UsVsSP6xNo7zjFDyZi+5FyOL 5UBeKokzuk5nn3LRvKMXiQtd70ravZpUrHd8rYFQYONnu764gxTG1xKonwrSduO9RehS+1ZUdiXtTd Ru0DBoTuUBIAVfnUwxK8m5poKfJMZbYIcA5QogC+VPWrdrEtHzZ1QWNZOxuA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel is globally removing the ambiguous 0-length and 1-element
arrays in favor of flexible arrays, so that we can gain both compile-time
and run-time array bounds checking[1]. Most cases of these changes are
trivial, but this case in BPF is not. It faces some difficulties:

1) struct bpf_lpm_trie_key is part of UAPI so changes can be fragile in
   the sense that projects external to Linux may be impacted.

2) The struct is intended to be used as a header, which means it may
   be within another structure, resulting in the "data" array member
   overlapping with the surrounding structure's following members. When
   converting from [0]-style to []-style, this overlap elicits warnings
   under Clang, and GCC considers it a deprecated extension (and similarly
   warns under -pedantic): https://godbolt.org/z/vWzqs41h6

3) Both the kernel and userspace access the existing "data" member
   for more than just static initializers and offsetof() calculations.
   For example:

      cilium:
        struct egress_gw_policy_key in_key = {
                .lpm_key = { 32 + 24, {} },
                .saddr   = CLIENT_IP,
                .daddr   = EXTERNAL_SVC_IP & 0Xffffff,
        };

      systemd:
        ipv6_map_fd = bpf_map_new(
                        BPF_MAP_TYPE_LPM_TRIE,
                        offsetof(struct bpf_lpm_trie_key, data) + sizeof(uint32_t)*4,
                        sizeof(uint64_t), ...);
	...
        struct bpf_lpm_trie_key *key_ipv4, *key_ipv6;
	...
	memcpy(key_ipv4->data, &a->address, sizeof(uint32_t));

   Searching for other uses in Debian Code Search seem to be just copies
   of UAPI headers:
   https://codesearch.debian.net/search?q=struct+bpf_lpm_trie_key&literal=1&perpkg=1

Introduce struct bpf_lpm_trie_key_u8 for the kernel (and future userspace)
to use for walking the individual bytes following the header, and leave
the "data" member of struct bpf_lpm_trie_key as-is (i.e. a [0]-style
array). This will allow existing userspace code to continue to use "data"
as a fake flexible array. The kernel (and future userspace code) building
with -fstrict-flex-arrays=3 will see struct bpf_lpm_trie_key::data has
having 0 bytes so there will be no overlap warnings, and can instead
use struct bpf_lpm_trie_key_u8::data for accessing the actual byte
array contents. The definition of struct bpf_lpm_trie_key_u8 uses a
union with struct bpf_lpm_trie_key so that things like container_of()
can be used instead of doing explicit casting, all while leaving the
member names un-namespaced (i.e. key->prefixlen == key_u8->prefixlen,
key->data == key_u8->data), allowing for trivial drop-in replacement
without collateral member renaming.

This will avoid structure overlap warnings and array bounds warnings
while enabling run-time array bounds checking under CONFIG_UBSAN_BOUNDS=y
and -fstrict-flex-arrays=3.

For reference, the current warning under GCC 13 with -fstrict-flex-arrays=3
and -Warray-bounds is:

../kernel/bpf/lpm_trie.c:207:51: warning: array subscript i is outside array bounds of 'const __u8[0]' {aka 'const unsigned char[]'} [-Warray-bounds=]
  207 |                                        *(__be16 *)&key->data[i]);
      |                                                   ^~~~~~~~~~~~~
../include/uapi/linux/swab.h:102:54: note: in definition of macro '__swab16'
  102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
      |                                                      ^
../include/linux/byteorder/generic.h:97:21: note: in expansion of macro '__be16_to_cpu'
   97 | #define be16_to_cpu __be16_to_cpu
      |                     ^~~~~~~~~~~~~
../kernel/bpf/lpm_trie.c:206:28: note: in expansion of macro 'be16_to_cpu'
  206 |                 u16 diff = be16_to_cpu(*(__be16 *)&node->data[i]
^
      |                            ^~~~~~~~~~~
In file included from ../include/linux/bpf.h:7:
../include/uapi/linux/bpf.h:82:17: note: while referencing 'data'
   82 |         __u8    data[0];        /* Arbitrary size */
      |                 ^~~~

Additionally update the samples and selftests to use the new structure,
for demonstrating best practices.

[1] For lots of details, see both:
    https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays
    https://people.kernel.org/kees/bounded-flexible-arrays-in-c

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mykola Lysenko <mykolal@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: bpf@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/bpf.h                   | 15 +++++++++++++--
 kernel/bpf/lpm_trie.c                      | 16 +++++++++-------
 samples/bpf/map_perf_test_user.c           |  2 +-
 samples/bpf/xdp_router_ipv4_user.c         |  2 +-
 tools/testing/selftests/bpf/test_lpm_map.c | 14 +++++++-------
 5 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba0f0cfb5e42..f843a7582456 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -76,10 +76,21 @@ struct bpf_insn {
 	__s32	imm;		/* signed immediate constant */
 };
 
-/* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
+/* Header for a key of a BPF_MAP_TYPE_LPM_TRIE entry */
 struct bpf_lpm_trie_key {
 	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
-	__u8	data[0];	/* Arbitrary size */
+	__u8	data[0];	/* Deprecated field: use struct bpf_lpm_trie_key_u8 */
+};
+
+/* Raw (u8 byte array) key of a BPF_MAP_TYPE_LPM_TRIE entry */
+struct bpf_lpm_trie_key_u8 {
+	union {
+		struct bpf_lpm_trie_key hdr;
+		struct {
+			__u32	prefixlen;
+			__u8	data[];
+		};
+	};
 };
 
 struct bpf_cgroup_storage_key {
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index d833496e9e42..3a93ace62c87 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -164,13 +164,15 @@ static inline int extract_bit(const u8 *data, size_t index)
  */
 static size_t longest_prefix_match(const struct lpm_trie *trie,
 				   const struct lpm_trie_node *node,
-				   const struct bpf_lpm_trie_key *key)
+				   const struct bpf_lpm_trie_key_u8 *key)
 {
 	u32 limit = min(node->prefixlen, key->prefixlen);
 	u32 prefixlen = 0, i = 0;
 
-	BUILD_BUG_ON(offsetof(struct lpm_trie_node, data) % sizeof(u32));
-	BUILD_BUG_ON(offsetof(struct bpf_lpm_trie_key, data) % sizeof(u32));
+	BUILD_BUG_ON(offsetof(typeof(*node), data) % sizeof(u32));
+	BUILD_BUG_ON(offsetof(typeof(*key), data) % sizeof(u32));
+	BUILD_BUG_ON(offsetof(typeof(*key), data) !=
+		     offsetof(typeof(key->hdr), data));
 
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && defined(CONFIG_64BIT)
 
@@ -229,7 +231,7 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
 	struct lpm_trie_node *node, *found = NULL;
-	struct bpf_lpm_trie_key *key = _key;
+	struct bpf_lpm_trie_key_u8 *key = _key;
 
 	/* Start walking the trie from the root node ... */
 
@@ -306,7 +308,7 @@ static int trie_update_elem(struct bpf_map *map,
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
 	struct lpm_trie_node *node, *im_node = NULL, *new_node = NULL;
 	struct lpm_trie_node __rcu **slot;
-	struct bpf_lpm_trie_key *key = _key;
+	struct bpf_lpm_trie_key_u8 *key = _key;
 	unsigned long irq_flags;
 	unsigned int next_bit;
 	size_t matchlen = 0;
@@ -434,7 +436,7 @@ static int trie_update_elem(struct bpf_map *map,
 static int trie_delete_elem(struct bpf_map *map, void *_key)
 {
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
-	struct bpf_lpm_trie_key *key = _key;
+	struct bpf_lpm_trie_key_u8 *key = _key;
 	struct lpm_trie_node __rcu **trim, **trim2;
 	struct lpm_trie_node *node, *parent;
 	unsigned long irq_flags;
@@ -616,7 +618,7 @@ static int trie_get_next_key(struct bpf_map *map, void *_key, void *_next_key)
 {
 	struct lpm_trie_node *node, *next_node = NULL, *parent, *search_root;
 	struct lpm_trie *trie = container_of(map, struct lpm_trie, map);
-	struct bpf_lpm_trie_key *key = _key, *next_key = _next_key;
+	struct bpf_lpm_trie_key_u8 *key = _key, *next_key = _next_key;
 	struct lpm_trie_node **node_stack = NULL;
 	int err = 0, stack_ptr = -1;
 	unsigned int next_bit;
diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test_user.c
index d2fbcf963cdf..07ff471ed6ae 100644
--- a/samples/bpf/map_perf_test_user.c
+++ b/samples/bpf/map_perf_test_user.c
@@ -370,7 +370,7 @@ static void run_perf_test(int tasks)
 
 static void fill_lpm_trie(void)
 {
-	struct bpf_lpm_trie_key *key;
+	struct bpf_lpm_trie_key_u8 *key;
 	unsigned long value = 0;
 	unsigned int i;
 	int r;
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 9d41db09c480..266fdd0b025d 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -91,7 +91,7 @@ static int recv_msg(struct sockaddr_nl sock_addr, int sock)
 static void read_route(struct nlmsghdr *nh, int nll)
 {
 	char dsts[24], gws[24], ifs[16], dsts_len[24], metrics[24];
-	struct bpf_lpm_trie_key *prefix_key;
+	struct bpf_lpm_trie_key_u8 *prefix_key;
 	struct rtattr *rt_attr;
 	struct rtmsg *rt_msg;
 	int rtm_family;
diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index c028d621c744..e2e822759e13 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -211,7 +211,7 @@ static void test_lpm_map(int keysize)
 	volatile size_t n_matches, n_matches_after_delete;
 	size_t i, j, n_nodes, n_lookups;
 	struct tlpm_node *t, *list = NULL;
-	struct bpf_lpm_trie_key *key;
+	struct bpf_lpm_trie_key_u8 *key;
 	uint8_t *data, *value;
 	int r, map;
 
@@ -331,8 +331,8 @@ static void test_lpm_map(int keysize)
 static void test_lpm_ipaddr(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_NO_PREALLOC);
-	struct bpf_lpm_trie_key *key_ipv4;
-	struct bpf_lpm_trie_key *key_ipv6;
+	struct bpf_lpm_trie_key_u8 *key_ipv4;
+	struct bpf_lpm_trie_key_u8 *key_ipv6;
 	size_t key_size_ipv4;
 	size_t key_size_ipv6;
 	int map_fd_ipv4;
@@ -423,7 +423,7 @@ static void test_lpm_ipaddr(void)
 static void test_lpm_delete(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_NO_PREALLOC);
-	struct bpf_lpm_trie_key *key;
+	struct bpf_lpm_trie_key_u8 *key;
 	size_t key_size;
 	int map_fd;
 	__u64 value;
@@ -532,7 +532,7 @@ static void test_lpm_delete(void)
 static void test_lpm_get_next_key(void)
 {
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_NO_PREALLOC);
-	struct bpf_lpm_trie_key *key_p, *next_key_p;
+	struct bpf_lpm_trie_key_u8 *key_p, *next_key_p;
 	size_t key_size;
 	__u32 value = 0;
 	int map_fd;
@@ -693,7 +693,7 @@ static void *lpm_test_command(void *arg)
 {
 	int i, j, ret, iter, key_size;
 	struct lpm_mt_test_info *info = arg;
-	struct bpf_lpm_trie_key *key_p;
+	struct bpf_lpm_trie_key_u8 *key_p;
 
 	key_size = sizeof(struct bpf_lpm_trie_key) + sizeof(__u32);
 	key_p = alloca(key_size);
@@ -717,7 +717,7 @@ static void *lpm_test_command(void *arg)
 				ret = bpf_map_lookup_elem(info->map_fd, key_p, &value);
 				assert(ret == 0 || errno == ENOENT);
 			} else {
-				struct bpf_lpm_trie_key *next_key_p = alloca(key_size);
+				struct bpf_lpm_trie_key_u8 *next_key_p = alloca(key_size);
 				ret = bpf_map_get_next_key(info->map_fd, key_p, next_key_p);
 				assert(ret == 0 || errno == ENOENT || errno == ENOMEM);
 			}
-- 
2.34.1

