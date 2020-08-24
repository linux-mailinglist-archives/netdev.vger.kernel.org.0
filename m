Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF12505FE
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgHXRZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgHXQfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4691D22BED;
        Mon, 24 Aug 2020 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286940;
        bh=Plwn9+PtEhypVPu9A4Uepi4cmZZJ8AR2GDq/yp++gJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmM9UuELcZlBDDuvhJygMh2d9qRClfVVnfYSB78THYpWwyEpg/s+EVOzFdHP8Pz3P
         Bb/i4YrO/E/Mqlux8TVz6gdULPvfPUXPy7HKjHLH/eY3P4SxAqxwo5lLRbTv8zd6e9
         BQbvQeVf0msJ+c/Awm4sIdJz9h3XiquweBspnHrw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 26/63] selftest/bpf: Fix compilation warnings in 32-bit mode
Date:   Mon, 24 Aug 2020 12:34:26 -0400
Message-Id: <20200824163504.605538-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 9028bbcc3e12510cac13a9554f1a1e39667a4387 ]

Fix compilation warnings emitted when compiling selftests for 32-bit platform
(x86 in my case).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200813204945.1020225-3-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c     | 8 ++++----
 tools/testing/selftests/bpf/prog_tests/core_extern.c    | 4 ++--
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 6 +++---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/global_data.c    | 6 +++---
 tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c        | 2 +-
 tools/testing/selftests/bpf/test_btf.c                  | 8 ++++----
 tools/testing/selftests/bpf/test_progs.h                | 5 +++++
 9 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index 7afa4160416f6..284d5921c3458 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -159,15 +159,15 @@ void test_bpf_obj_id(void)
 		/* Check getting link info */
 		info_len = sizeof(struct bpf_link_info) * 2;
 		bzero(&link_infos[i], info_len);
-		link_infos[i].raw_tracepoint.tp_name = (__u64)&tp_name;
+		link_infos[i].raw_tracepoint.tp_name = ptr_to_u64(&tp_name);
 		link_infos[i].raw_tracepoint.tp_name_len = sizeof(tp_name);
 		err = bpf_obj_get_info_by_fd(bpf_link__fd(links[i]),
 					     &link_infos[i], &info_len);
 		if (CHECK(err ||
 			  link_infos[i].type != BPF_LINK_TYPE_RAW_TRACEPOINT ||
 			  link_infos[i].prog_id != prog_infos[i].id ||
-			  link_infos[i].raw_tracepoint.tp_name != (__u64)&tp_name ||
-			  strcmp((char *)link_infos[i].raw_tracepoint.tp_name,
+			  link_infos[i].raw_tracepoint.tp_name != ptr_to_u64(&tp_name) ||
+			  strcmp(u64_to_ptr(link_infos[i].raw_tracepoint.tp_name),
 				 "sys_enter") ||
 			  info_len != sizeof(struct bpf_link_info),
 			  "get-link-info(fd)",
@@ -178,7 +178,7 @@ void test_bpf_obj_id(void)
 			  link_infos[i].type, BPF_LINK_TYPE_RAW_TRACEPOINT,
 			  link_infos[i].id,
 			  link_infos[i].prog_id, prog_infos[i].id,
-			  (char *)link_infos[i].raw_tracepoint.tp_name,
+			  (const char *)u64_to_ptr(link_infos[i].raw_tracepoint.tp_name),
 			  "sys_enter"))
 			goto done;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools/testing/selftests/bpf/prog_tests/core_extern.c
index b093787e94489..1931a158510e0 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_extern.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -159,8 +159,8 @@ void test_core_extern(void)
 		exp = (uint64_t *)&t->data;
 		for (j = 0; j < n; j++) {
 			CHECK(got[j] != exp[j], "check_res",
-			      "result #%d: expected %lx, but got %lx\n",
-			       j, exp[j], got[j]);
+			      "result #%d: expected %llx, but got %llx\n",
+			       j, (__u64)exp[j], (__u64)got[j]);
 		}
 cleanup:
 		test_core_extern__destroy(skel);
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index a895bfed55db0..197d0d217b56b 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -16,7 +16,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 	__u32 duration = 0, retval;
 	struct bpf_map *data_map;
 	const int zero = 0;
-	u64 *result = NULL;
+	__u64 *result = NULL;
 
 	err = bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
 			    &pkt_obj, &pkt_fd);
@@ -29,7 +29,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 
 	link = calloc(sizeof(struct bpf_link *), prog_cnt);
 	prog = calloc(sizeof(struct bpf_program *), prog_cnt);
-	result = malloc((prog_cnt + 32 /* spare */) * sizeof(u64));
+	result = malloc((prog_cnt + 32 /* spare */) * sizeof(__u64));
 	if (CHECK(!link || !prog || !result, "alloc_memory",
 		  "failed to alloc memory"))
 		goto close_prog;
@@ -72,7 +72,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 		goto close_prog;
 
 	for (i = 0; i < prog_cnt; i++)
-		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %ld\n",
+		if (CHECK(result[i] != 1, "result", "fexit_bpf2bpf failed err %llu\n",
 			  result[i]))
 			goto close_prog;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index f11f187990e95..cd6dc80edf18e 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -591,7 +591,7 @@ void test_flow_dissector(void)
 		CHECK_ATTR(tattr.data_size_out != sizeof(flow_keys) ||
 			   err || tattr.retval != 1,
 			   tests[i].name,
-			   "err %d errno %d retval %d duration %d size %u/%lu\n",
+			   "err %d errno %d retval %d duration %d size %u/%zu\n",
 			   err, errno, tattr.retval, tattr.duration,
 			   tattr.data_size_out, sizeof(flow_keys));
 		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
index e3cb62b0a110e..9efa7e50eab27 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
@@ -5,7 +5,7 @@
 static void test_global_data_number(struct bpf_object *obj, __u32 duration)
 {
 	int i, err, map_fd;
-	uint64_t num;
+	__u64 num;
 
 	map_fd = bpf_find_map(__func__, obj, "result_number");
 	if (CHECK_FAIL(map_fd < 0))
@@ -14,7 +14,7 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
 	struct {
 		char *name;
 		uint32_t key;
-		uint64_t num;
+		__u64 num;
 	} tests[] = {
 		{ "relocate .bss reference",     0, 0 },
 		{ "relocate .data reference",    1, 42 },
@@ -32,7 +32,7 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
 	for (i = 0; i < sizeof(tests) / sizeof(tests[0]); i++) {
 		err = bpf_map_lookup_elem(map_fd, &tests[i].key, &num);
 		CHECK(err || num != tests[i].num, tests[i].name,
-		      "err %d result %lx expected %lx\n",
+		      "err %d result %llx expected %llx\n",
 		      err, num, tests[i].num);
 	}
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
index dde2b7ae7bc9e..935a294f049a2 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
@@ -28,7 +28,7 @@ void test_prog_run_xattr(void)
 	      "err %d errno %d retval %d\n", err, errno, tattr.retval);
 
 	CHECK_ATTR(tattr.data_size_out != sizeof(pkt_v4), "data_size_out",
-	      "incorrect output size, want %lu have %u\n",
+	      "incorrect output size, want %zu have %u\n",
 	      sizeof(pkt_v4), tattr.data_size_out);
 
 	CHECK_ATTR(buf[5] != 0, "overflow",
diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index 7021b92af3134..c61b2b69710a9 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -80,7 +80,7 @@ void test_skb_ctx(void)
 
 	CHECK_ATTR(tattr.ctx_size_out != sizeof(skb),
 		   "ctx_size_out",
-		   "incorrect output size, want %lu have %u\n",
+		   "incorrect output size, want %zu have %u\n",
 		   sizeof(skb), tattr.ctx_size_out);
 
 	for (i = 0; i < 5; i++)
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 305fae8f80a98..c75fc6447186a 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -3883,7 +3883,7 @@ static int test_big_btf_info(unsigned int test_num)
 	info_garbage.garbage = 0;
 	err = bpf_obj_get_info_by_fd(btf_fd, info, &info_len);
 	if (CHECK(err || info_len != sizeof(*info),
-		  "err:%d errno:%d info_len:%u sizeof(*info):%lu",
+		  "err:%d errno:%d info_len:%u sizeof(*info):%zu",
 		  err, errno, info_len, sizeof(*info))) {
 		err = -1;
 		goto done;
@@ -4094,7 +4094,7 @@ static int do_test_get_info(unsigned int test_num)
 	if (CHECK(err || !info.id || info_len != sizeof(info) ||
 		  info.btf_size != raw_btf_size ||
 		  (ret = memcmp(raw_btf, user_btf, expected_nbytes)),
-		  "err:%d errno:%d info.id:%u info_len:%u sizeof(info):%lu raw_btf_size:%u info.btf_size:%u expected_nbytes:%u memcmp:%d",
+		  "err:%d errno:%d info.id:%u info_len:%u sizeof(info):%zu raw_btf_size:%u info.btf_size:%u expected_nbytes:%u memcmp:%d",
 		  err, errno, info.id, info_len, sizeof(info),
 		  raw_btf_size, info.btf_size, expected_nbytes, ret)) {
 		err = -1;
@@ -4730,7 +4730,7 @@ ssize_t get_pprint_expected_line(enum pprint_mapv_kind_t mapv_kind,
 
 		nexpected_line = snprintf(expected_line, line_size,
 					  "%s%u: {%u,0,%d,0x%x,0x%x,0x%x,"
-					  "{%lu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
+					  "{%llu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
 					  "%u,0x%x,[[%d,%d],[%d,%d]]}\n",
 					  percpu_map ? "\tcpu" : "",
 					  percpu_map ? cpu : next_key,
@@ -4738,7 +4738,7 @@ ssize_t get_pprint_expected_line(enum pprint_mapv_kind_t mapv_kind,
 					  v->unused_bits2a,
 					  v->bits28,
 					  v->unused_bits2b,
-					  v->ui64,
+					  (__u64)v->ui64,
 					  v->ui8a[0], v->ui8a[1],
 					  v->ui8a[2], v->ui8a[3],
 					  v->ui8a[4], v->ui8a[5],
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index b809246039181..b5670350e3263 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -133,6 +133,11 @@ static inline __u64 ptr_to_u64(const void *ptr)
 	return (__u64) (unsigned long) ptr;
 }
 
+static inline void *u64_to_ptr(__u64 ptr)
+{
+	return (void *) (unsigned long) ptr;
+}
+
 int bpf_find_map(const char *test, struct bpf_object *obj, const char *name);
 int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
-- 
2.25.1

