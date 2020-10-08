Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC5D287E00
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgJHVb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:31:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:46948 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHVby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:31:54 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQdVw-0007v1-2N; Thu, 08 Oct 2020 23:31:52 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 4/6] bpf, selftests: add test for different array inner map size
Date:   Thu,  8 Oct 2020 23:31:46 +0200
Message-Id: <20201008213148.26848-5-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201008213148.26848-1-daniel@iogearbox.net>
References: <20201008213148.26848-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25951/Thu Oct  8 15:53:03 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the "diff_size" subtest to also include a non-inlined array map variant
where dynamic inner #elems are possible.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 39 ++++++++++++-----
 .../selftests/bpf/progs/test_btf_map_in_map.c | 43 +++++++++++++++++++
 2 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
index 540fea4c91a5..e478bdec73b8 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
@@ -55,10 +55,10 @@ static int kern_sync_rcu(void)
 
 static void test_lookup_update(void)
 {
-	int err, key = 0, val, i;
+	int map1_fd, map2_fd, map3_fd, map4_fd, map5_fd, map1_id, map2_id;
+	int outer_arr_fd, outer_hash_fd, outer_arr_dyn_fd;
 	struct test_btf_map_in_map *skel;
-	int outer_arr_fd, outer_hash_fd;
-	int fd, map1_fd, map2_fd, map1_id, map2_id;
+	int err, key = 0, val, i, fd;
 
 	skel = test_btf_map_in_map__open_and_load();
 	if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
@@ -70,32 +70,45 @@ static void test_lookup_update(void)
 
 	map1_fd = bpf_map__fd(skel->maps.inner_map1);
 	map2_fd = bpf_map__fd(skel->maps.inner_map2);
+	map3_fd = bpf_map__fd(skel->maps.inner_map3);
+	map4_fd = bpf_map__fd(skel->maps.inner_map4);
+	map5_fd = bpf_map__fd(skel->maps.inner_map5);
+	outer_arr_dyn_fd = bpf_map__fd(skel->maps.outer_arr_dyn);
 	outer_arr_fd = bpf_map__fd(skel->maps.outer_arr);
 	outer_hash_fd = bpf_map__fd(skel->maps.outer_hash);
 
-	/* inner1 = input, inner2 = input + 1 */
-	map1_fd = bpf_map__fd(skel->maps.inner_map1);
+	/* inner1 = input, inner2 = input + 1, inner3 = input + 2 */
 	bpf_map_update_elem(outer_arr_fd, &key, &map1_fd, 0);
-	map2_fd = bpf_map__fd(skel->maps.inner_map2);
 	bpf_map_update_elem(outer_hash_fd, &key, &map2_fd, 0);
+	bpf_map_update_elem(outer_arr_dyn_fd, &key, &map3_fd, 0);
 	skel->bss->input = 1;
 	usleep(1);
-
 	bpf_map_lookup_elem(map1_fd, &key, &val);
 	CHECK(val != 1, "inner1", "got %d != exp %d\n", val, 1);
 	bpf_map_lookup_elem(map2_fd, &key, &val);
 	CHECK(val != 2, "inner2", "got %d != exp %d\n", val, 2);
+	bpf_map_lookup_elem(map3_fd, &key, &val);
+	CHECK(val != 3, "inner3", "got %d != exp %d\n", val, 3);
 
-	/* inner1 = input + 1, inner2 = input */
+	/* inner1 = input, inner2 = input + 1, inner4 = input + 2 */
 	bpf_map_update_elem(outer_arr_fd, &key, &map2_fd, 0);
 	bpf_map_update_elem(outer_hash_fd, &key, &map1_fd, 0);
+	bpf_map_update_elem(outer_arr_dyn_fd, &key, &map4_fd, 0);
 	skel->bss->input = 3;
 	usleep(1);
-
 	bpf_map_lookup_elem(map1_fd, &key, &val);
 	CHECK(val != 4, "inner1", "got %d != exp %d\n", val, 4);
 	bpf_map_lookup_elem(map2_fd, &key, &val);
 	CHECK(val != 3, "inner2", "got %d != exp %d\n", val, 3);
+	bpf_map_lookup_elem(map4_fd, &key, &val);
+	CHECK(val != 5, "inner4", "got %d != exp %d\n", val, 5);
+
+	/* inner5 = input + 2 */
+	bpf_map_update_elem(outer_arr_dyn_fd, &key, &map5_fd, 0);
+	skel->bss->input = 5;
+	usleep(1);
+	bpf_map_lookup_elem(map5_fd, &key, &val);
+	CHECK(val != 7, "inner5", "got %d != exp %d\n", val, 7);
 
 	for (i = 0; i < 5; i++) {
 		val = i % 2 ? map1_fd : map2_fd;
@@ -106,7 +119,13 @@ static void test_lookup_update(void)
 		}
 		err = bpf_map_update_elem(outer_arr_fd, &key, &val, 0);
 		if (CHECK_FAIL(err)) {
-			printf("failed to update hash_of_maps on iter #%d\n", i);
+			printf("failed to update array_of_maps on iter #%d\n", i);
+			goto cleanup;
+		}
+		val = i % 2 ? map4_fd : map5_fd;
+		err = bpf_map_update_elem(outer_arr_dyn_fd, &key, &val, 0);
+		if (CHECK_FAIL(err)) {
+			printf("failed to update array_of_maps (dyn) on iter #%d\n", i);
 			goto cleanup;
 		}
 	}
diff --git a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
index 193fe0198b21..ccad6f9beabd 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
@@ -41,6 +41,43 @@ struct outer_arr {
 	.values = { (void *)&inner_map1, 0, (void *)&inner_map2 },
 };
 
+struct inner_map_sz3 {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(map_flags, BPF_F_NO_INLINE);
+	__uint(max_entries, 3);
+	__type(key, int);
+	__type(value, int);
+} inner_map3 SEC(".maps"),
+  inner_map4 SEC(".maps");
+
+struct inner_map_sz4 {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(map_flags, BPF_F_NO_INLINE);
+	__uint(max_entries, 5);
+	__type(key, int);
+	__type(value, int);
+} inner_map5 SEC(".maps");
+
+struct outer_arr_dyn {
+	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
+	__uint(max_entries, 3);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__array(values, struct {
+		__uint(type, BPF_MAP_TYPE_ARRAY);
+		__uint(map_flags, BPF_F_NO_INLINE);
+		__uint(max_entries, 1);
+		__type(key, int);
+		__type(value, int);
+	});
+} outer_arr_dyn SEC(".maps") = {
+	.values = {
+		[0] = (void *)&inner_map3,
+		[1] = (void *)&inner_map4,
+		[2] = (void *)&inner_map5,
+	},
+};
+
 struct outer_hash {
 	__uint(type, BPF_MAP_TYPE_HASH_OF_MAPS);
 	__uint(max_entries, 5);
@@ -101,6 +138,12 @@ int handle__sys_enter(void *ctx)
 	val = input + 1;
 	bpf_map_update_elem(inner_map, &key, &val, 0);
 
+	inner_map = bpf_map_lookup_elem(&outer_arr_dyn, &key);
+	if (!inner_map)
+		return 1;
+	val = input + 2;
+	bpf_map_update_elem(inner_map, &key, &val, 0);
+
 	return 0;
 }
 
-- 
2.17.1

