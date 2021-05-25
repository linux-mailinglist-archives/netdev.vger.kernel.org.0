Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443BF38F91D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 05:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhEYEBT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 May 2021 00:01:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35186 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230032AbhEYEBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 00:01:18 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14P3hdt3005327
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:48 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 38rjj22gp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:47 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:59:45 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E6FA52EDBE05; Mon, 24 May 2021 20:59:42 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2 bpf-next 2/5] selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
Date:   Mon, 24 May 2021 20:59:32 -0700
Message-ID: <20210525035935.1461796-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525035935.1461796-1-andrii@kernel.org>
References: <20210525035935.1461796-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: 5fgocHfdDDSq64myznTFGt4iNz0Dts1h
X-Proofpoint-GUID: 5fgocHfdDDSq64myznTFGt4iNz0Dts1h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_02:2021-05-24,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turn ony libbpf 1.0 mode. Fix all the explicit IS_ERR checks that now will be
broken because libbpf returns NULL on error (and sets errno). Fix
ASSERT_OK_PTR and ASSERT_ERR_PTR to work for both old mode and new modes and
use them throughout selftests. This is trivial to do by using
libbpf_get_error() API that all libbpf users are supposed to use, instead of
IS_ERR checks.

A bunch of checks also did explicit -1 comparison for various fd-returning
APIs. Such checks are replaced with >= 0 or < 0 cases.

There were also few misuses of bpf_object__find_map_by_name() in test_maps.
Those are fixed in this patch as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/bench.c           |   1 +
 .../selftests/bpf/benchs/bench_rename.c       |   2 +-
 .../selftests/bpf/benchs/bench_ringbufs.c     |   6 +-
 .../selftests/bpf/benchs/bench_trigger.c      |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   |  12 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       |  31 ++--
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |   8 +-
 tools/testing/selftests/bpf/prog_tests/btf.c  |  93 +++++-----
 .../selftests/bpf/prog_tests/btf_dump.c       |   8 +-
 .../selftests/bpf/prog_tests/btf_write.c      |   4 +-
 .../bpf/prog_tests/cg_storage_multi.c         |  84 +++------
 .../bpf/prog_tests/cgroup_attach_multi.c      |   2 +-
 .../selftests/bpf/prog_tests/cgroup_link.c    |  14 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c     |   2 +-
 .../selftests/bpf/prog_tests/check_mtu.c      |   2 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |  15 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  25 +--
 .../selftests/bpf/prog_tests/flow_dissector.c |   2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c  |  10 +-
 .../bpf/prog_tests/get_stack_raw_tp.c         |  10 +-
 .../prog_tests/get_stackid_cannot_attach.c    |   9 +-
 .../selftests/bpf/prog_tests/hashmap.c        |   9 +-
 .../selftests/bpf/prog_tests/kfree_skb.c      |  19 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |   3 +-
 .../selftests/bpf/prog_tests/link_pinning.c   |   7 +-
 .../selftests/bpf/prog_tests/obj_name.c       |   8 +-
 .../selftests/bpf/prog_tests/perf_branches.c  |   4 +-
 .../selftests/bpf/prog_tests/perf_buffer.c    |   2 +-
 .../bpf/prog_tests/perf_event_stackmap.c      |   3 +-
 .../selftests/bpf/prog_tests/probe_user.c     |   7 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c |   4 +-
 .../bpf/prog_tests/raw_tp_test_run.c          |   4 +-
 .../selftests/bpf/prog_tests/rdonly_maps.c    |   7 +-
 .../bpf/prog_tests/reference_tracking.c       |   2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c |   2 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c  |   2 +-
 .../bpf/prog_tests/select_reuseport.c         |  53 +++---
 .../selftests/bpf/prog_tests/send_signal.c    |   3 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      |   2 +-
 .../selftests/bpf/prog_tests/sock_fields.c    |  14 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  |   8 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c   |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c |  10 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   3 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |   5 +-
 .../bpf/prog_tests/tcp_hdr_options.c          |  15 +-
 .../selftests/bpf/prog_tests/test_overhead.c  |  12 +-
 .../bpf/prog_tests/trampoline_count.c         |  14 +-
 .../selftests/bpf/prog_tests/udp_limit.c      |   7 +-
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    |   2 +-
 .../selftests/bpf/prog_tests/xdp_link.c       |   8 +-
 tools/testing/selftests/bpf/test_maps.c       | 168 +++++++++---------
 tools/testing/selftests/bpf/test_progs.c      |   3 +
 tools/testing/selftests/bpf/test_progs.h      |   9 +-
 .../selftests/bpf/test_tcpnotify_user.c       |   7 +-
 56 files changed, 347 insertions(+), 425 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 332ed2f7b402..6ea15b93a2f8 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -43,6 +43,7 @@ void setup_libbpf()
 {
 	int err;
 
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 	libbpf_set_print(libbpf_print_fn);
 
 	err = bump_memlock_rlimit();
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index a967674098ad..c7ec114eca56 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (IS_ERR(link)) {
+	if (!link) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
index bde6c9d4cbd4..d167bffac679 100644
--- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -181,7 +181,7 @@ static void ringbuf_libbpf_setup()
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
-	if (IS_ERR(link)) {
+	if (!link) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
@@ -271,7 +271,7 @@ static void ringbuf_custom_setup()
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
-	if (IS_ERR(link)) {
+	if (!link) {
 		fprintf(stderr, "failed to attach program\n");
 		exit(1);
 	}
@@ -430,7 +430,7 @@ static void perfbuf_libbpf_setup()
 	}
 
 	link = bpf_program__attach(ctx->skel->progs.bench_perfbuf);
-	if (IS_ERR(link)) {
+	if (!link) {
 		fprintf(stderr, "failed to attach program\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 2a0b6c9885a4..f41a491a8cc0 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -60,7 +60,7 @@ static void attach_bpf(struct bpf_program *prog)
 	struct bpf_link *link;
 
 	link = bpf_program__attach(prog);
-	if (IS_ERR(link)) {
+	if (!link) {
 		fprintf(stderr, "failed to attach program!\n");
 		exit(1);
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 9dc4e3dfbcf3..ec11e20d2b92 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -85,16 +85,14 @@ void test_attach_probe(void)
 	kprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kprobe,
 						 false /* retprobe */,
 						 SYS_NANOSLEEP_KPROBE_NAME);
-	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
-		  "err %ld\n", PTR_ERR(kprobe_link)))
+	if (!ASSERT_OK_PTR(kprobe_link, "attach_kprobe"))
 		goto cleanup;
 	skel->links.handle_kprobe = kprobe_link;
 
 	kretprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kretprobe,
 						    true /* retprobe */,
 						    SYS_NANOSLEEP_KPROBE_NAME);
-	if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
-		  "err %ld\n", PTR_ERR(kretprobe_link)))
+	if (!ASSERT_OK_PTR(kretprobe_link, "attach_kretprobe"))
 		goto cleanup;
 	skel->links.handle_kretprobe = kretprobe_link;
 
@@ -103,8 +101,7 @@ void test_attach_probe(void)
 						 0 /* self pid */,
 						 "/proc/self/exe",
 						 uprobe_offset);
-	if (CHECK(IS_ERR(uprobe_link), "attach_uprobe",
-		  "err %ld\n", PTR_ERR(uprobe_link)))
+	if (!ASSERT_OK_PTR(uprobe_link, "attach_uprobe"))
 		goto cleanup;
 	skel->links.handle_uprobe = uprobe_link;
 
@@ -113,8 +110,7 @@ void test_attach_probe(void)
 						    -1 /* any pid */,
 						    "/proc/self/exe",
 						    uprobe_offset);
-	if (CHECK(IS_ERR(uretprobe_link), "attach_uretprobe",
-		  "err %ld\n", PTR_ERR(uretprobe_link)))
+	if (!ASSERT_OK_PTR(uretprobe_link, "attach_uretprobe"))
 		goto cleanup;
 	skel->links.handle_uretprobe = uretprobe_link;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 2d3590cfb5e1..1f1aade56504 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -47,7 +47,7 @@ static void do_dummy_read(struct bpf_program *prog)
 	int iter_fd, len;
 
 	link = bpf_program__attach_iter(prog, NULL);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		return;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -201,7 +201,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel)
 	int ret = 0;
 
 	link = bpf_program__attach_iter(prog, NULL);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		return ret;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -396,7 +396,7 @@ static void test_file_iter(void)
 		return;
 
 	link = bpf_program__attach_iter(skel1->progs.dump_task, NULL);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	/* unlink this path if it exists. */
@@ -502,7 +502,7 @@ static void test_overflow(bool test_e2big_overflow, bool ret1)
 	skel->bss->map2_id = map_info.id;
 
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_map, NULL);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto free_map2;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -607,14 +607,12 @@ static void test_bpf_hash_map(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-	if (CHECK(!IS_ERR(link), "attach_iter",
-		  "attach_iter for hashmap2 unexpected succeeded\n"))
+	if (!ASSERT_ERR_PTR(link, "attach_iter"))
 		goto out;
 
 	linfo.map.map_fd = bpf_map__fd(skel->maps.hashmap3);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-	if (CHECK(!IS_ERR(link), "attach_iter",
-		  "attach_iter for hashmap3 unexpected succeeded\n"))
+	if (!ASSERT_ERR_PTR(link, "attach_iter"))
 		goto out;
 
 	/* hashmap1 should be good, update map values here */
@@ -636,7 +634,7 @@ static void test_bpf_hash_map(void)
 
 	linfo.map.map_fd = map_fd;
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -727,7 +725,7 @@ static void test_bpf_percpu_hash_map(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_percpu_hash_map, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -798,7 +796,7 @@ static void test_bpf_array_map(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_array_map, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -894,7 +892,7 @@ static void test_bpf_percpu_array_map(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_percpu_array_map, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -957,7 +955,7 @@ static void test_bpf_sk_storage_delete(void)
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.delete_bpf_sk_storage_map,
 					&opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -1075,7 +1073,7 @@ static void test_bpf_sk_storage_map(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_sk_storage_map, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -1128,7 +1126,7 @@ static void test_rdonly_buf_out_of_bound(void)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-	if (CHECK(!IS_ERR(link), "attach_iter", "unexpected success\n"))
+	if (!ASSERT_ERR_PTR(link, "attach_iter"))
 		bpf_link__destroy(link);
 
 	bpf_iter_test_kern5__destroy(skel);
@@ -1186,8 +1184,7 @@ static void test_task_vma(void)
 	skel->links.proc_maps = bpf_program__attach_iter(
 		skel->progs.proc_maps, NULL);
 
-	if (CHECK(IS_ERR(skel->links.proc_maps), "bpf_program__attach_iter",
-		  "attach iterator failed\n")) {
+	if (!ASSERT_OK_PTR(skel->links.proc_maps, "bpf_program__attach_iter")) {
 		skel->links.proc_maps = NULL;
 		goto out;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index e25917f04602..efe1e979affb 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -82,7 +82,7 @@ static void *server(void *arg)
 	      bytes, total_bytes, nr_sent, errno);
 
 done:
-	if (fd != -1)
+	if (fd >= 0)
 		close(fd);
 	if (err) {
 		WRITE_ONCE(stop, 1);
@@ -191,8 +191,7 @@ static void test_cubic(void)
 		return;
 
 	link = bpf_map__attach_struct_ops(cubic_skel->maps.cubic);
-	if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\n",
-		  PTR_ERR(link))) {
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops")) {
 		bpf_cubic__destroy(cubic_skel);
 		return;
 	}
@@ -213,8 +212,7 @@ static void test_dctcp(void)
 		return;
 
 	link = bpf_map__attach_struct_ops(dctcp_skel->maps.dctcp);
-	if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\n",
-		  PTR_ERR(link))) {
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops")) {
 		bpf_dctcp__destroy(dctcp_skel);
 		return;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 0457ae32b270..857e3f26086f 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -3811,7 +3811,7 @@ static void do_test_raw(unsigned int test_num)
 			      always_log);
 	free(raw_btf);
 
-	err = ((btf_fd == -1) != test->btf_load_err);
+	err = ((btf_fd < 0) != test->btf_load_err);
 	if (CHECK(err, "btf_fd:%d test->btf_load_err:%u",
 		  btf_fd, test->btf_load_err) ||
 	    CHECK(test->err_str && !strstr(btf_log_buf, test->err_str),
@@ -3820,7 +3820,7 @@ static void do_test_raw(unsigned int test_num)
 		goto done;
 	}
 
-	if (err || btf_fd == -1)
+	if (err || btf_fd < 0)
 		goto done;
 
 	create_attr.name = test->map_name;
@@ -3834,16 +3834,16 @@ static void do_test_raw(unsigned int test_num)
 
 	map_fd = bpf_create_map_xattr(&create_attr);
 
-	err = ((map_fd == -1) != test->map_create_err);
+	err = ((map_fd < 0) != test->map_create_err);
 	CHECK(err, "map_fd:%d test->map_create_err:%u",
 	      map_fd, test->map_create_err);
 
 done:
 	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
-	if (btf_fd != -1)
+	if (btf_fd >= 0)
 		close(btf_fd);
-	if (map_fd != -1)
+	if (map_fd >= 0)
 		close(map_fd);
 }
 
@@ -3941,7 +3941,7 @@ static int test_big_btf_info(unsigned int test_num)
 	btf_fd = bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
 			      always_log);
-	if (CHECK(btf_fd == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -3987,7 +3987,7 @@ static int test_big_btf_info(unsigned int test_num)
 	free(raw_btf);
 	free(user_btf);
 
-	if (btf_fd != -1)
+	if (btf_fd >= 0)
 		close(btf_fd);
 
 	return err;
@@ -4029,7 +4029,7 @@ static int test_btf_id(unsigned int test_num)
 	btf_fd[0] = bpf_load_btf(raw_btf, raw_btf_size,
 				 btf_log_buf, BTF_LOG_BUF_SIZE,
 				 always_log);
-	if (CHECK(btf_fd[0] == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd[0] < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4043,7 +4043,7 @@ static int test_btf_id(unsigned int test_num)
 	}
 
 	btf_fd[1] = bpf_btf_get_fd_by_id(info[0].id);
-	if (CHECK(btf_fd[1] == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd[1] < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4071,7 +4071,7 @@ static int test_btf_id(unsigned int test_num)
 	create_attr.btf_value_type_id = 2;
 
 	map_fd = bpf_create_map_xattr(&create_attr);
-	if (CHECK(map_fd == -1, "errno:%d", errno)) {
+	if (CHECK(map_fd < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4094,7 +4094,7 @@ static int test_btf_id(unsigned int test_num)
 
 	/* Test BTF ID is removed from the kernel */
 	btf_fd[0] = bpf_btf_get_fd_by_id(map_info.btf_id);
-	if (CHECK(btf_fd[0] == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd[0] < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4105,7 +4105,7 @@ static int test_btf_id(unsigned int test_num)
 	close(map_fd);
 	map_fd = -1;
 	btf_fd[0] = bpf_btf_get_fd_by_id(map_info.btf_id);
-	if (CHECK(btf_fd[0] != -1, "BTF lingers")) {
+	if (CHECK(btf_fd[0] >= 0, "BTF lingers")) {
 		err = -1;
 		goto done;
 	}
@@ -4117,11 +4117,11 @@ static int test_btf_id(unsigned int test_num)
 		fprintf(stderr, "\n%s", btf_log_buf);
 
 	free(raw_btf);
-	if (map_fd != -1)
+	if (map_fd >= 0)
 		close(map_fd);
 	for (i = 0; i < 2; i++) {
 		free(user_btf[i]);
-		if (btf_fd[i] != -1)
+		if (btf_fd[i] >= 0)
 			close(btf_fd[i]);
 	}
 
@@ -4166,7 +4166,7 @@ static void do_test_get_info(unsigned int test_num)
 	btf_fd = bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
 			      always_log);
-	if (CHECK(btf_fd == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd <= 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4212,7 +4212,7 @@ static void do_test_get_info(unsigned int test_num)
 	free(raw_btf);
 	free(user_btf);
 
-	if (btf_fd != -1)
+	if (btf_fd >= 0)
 		close(btf_fd);
 }
 
@@ -4249,8 +4249,9 @@ static void do_test_file(unsigned int test_num)
 		return;
 
 	btf = btf__parse_elf(test->file, &btf_ext);
-	if (IS_ERR(btf)) {
-		if (PTR_ERR(btf) == -ENOENT) {
+	err = libbpf_get_error(btf);
+	if (err) {
+		if (err == -ENOENT) {
 			printf("%s:SKIP: No ELF %s found", __func__, BTF_ELF_SEC);
 			test__skip();
 			return;
@@ -4263,7 +4264,8 @@ static void do_test_file(unsigned int test_num)
 	btf_ext__free(btf_ext);
 
 	obj = bpf_object__open(test->file);
-	if (CHECK(IS_ERR(obj), "obj: %ld", PTR_ERR(obj)))
+	err = libbpf_get_error(obj);
+	if (CHECK(err, "obj: %d", err))
 		return;
 
 	prog = bpf_program__next(NULL, obj);
@@ -4298,7 +4300,7 @@ static void do_test_file(unsigned int test_num)
 	info_len = sizeof(struct bpf_prog_info);
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
 
-	if (CHECK(err == -1, "invalid get info (1st) errno:%d", errno)) {
+	if (CHECK(err < 0, "invalid get info (1st) errno:%d", errno)) {
 		fprintf(stderr, "%s\n", btf_log_buf);
 		err = -1;
 		goto done;
@@ -4330,7 +4332,7 @@ static void do_test_file(unsigned int test_num)
 
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
 
-	if (CHECK(err == -1, "invalid get info (2nd) errno:%d", errno)) {
+	if (CHECK(err < 0, "invalid get info (2nd) errno:%d", errno)) {
 		fprintf(stderr, "%s\n", btf_log_buf);
 		err = -1;
 		goto done;
@@ -4886,7 +4888,7 @@ static void do_test_pprint(int test_num)
 			      always_log);
 	free(raw_btf);
 
-	if (CHECK(btf_fd == -1, "errno:%d", errno)) {
+	if (CHECK(btf_fd < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4901,7 +4903,7 @@ static void do_test_pprint(int test_num)
 	create_attr.btf_value_type_id = test->value_type_id;
 
 	map_fd = bpf_create_map_xattr(&create_attr);
-	if (CHECK(map_fd == -1, "errno:%d", errno)) {
+	if (CHECK(map_fd < 0, "errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -4982,7 +4984,7 @@ static void do_test_pprint(int test_num)
 
 					err = check_line(expected_line, nexpected_line,
 							 sizeof(expected_line), line);
-					if (err == -1)
+					if (err < 0)
 						goto done;
 				}
 
@@ -4998,7 +5000,7 @@ static void do_test_pprint(int test_num)
 								  cpu, cmapv);
 			err = check_line(expected_line, nexpected_line,
 					 sizeof(expected_line), line);
-			if (err == -1)
+			if (err < 0)
 				goto done;
 
 			cmapv = cmapv + rounded_value_size;
@@ -5036,9 +5038,9 @@ static void do_test_pprint(int test_num)
 		fprintf(stderr, "OK");
 	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
-	if (btf_fd != -1)
+	if (btf_fd >= 0)
 		close(btf_fd);
-	if (map_fd != -1)
+	if (map_fd >= 0)
 		close(map_fd);
 	if (pin_file)
 		fclose(pin_file);
@@ -5950,7 +5952,7 @@ static int test_get_finfo(const struct prog_info_raw_test *test,
 	/* get necessary lens */
 	info_len = sizeof(struct bpf_prog_info);
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (CHECK(err == -1, "invalid get info (1st) errno:%d", errno)) {
+	if (CHECK(err < 0, "invalid get info (1st) errno:%d", errno)) {
 		fprintf(stderr, "%s\n", btf_log_buf);
 		return -1;
 	}
@@ -5980,7 +5982,7 @@ static int test_get_finfo(const struct prog_info_raw_test *test,
 	info.func_info_rec_size = rec_size;
 	info.func_info = ptr_to_u64(func_info);
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (CHECK(err == -1, "invalid get info (2nd) errno:%d", errno)) {
+	if (CHECK(err < 0, "invalid get info (2nd) errno:%d", errno)) {
 		fprintf(stderr, "%s\n", btf_log_buf);
 		err = -1;
 		goto done;
@@ -6044,7 +6046,7 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 
 	info_len = sizeof(struct bpf_prog_info);
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (CHECK(err == -1, "err:%d errno:%d", err, errno)) {
+	if (CHECK(err < 0, "err:%d errno:%d", err, errno)) {
 		err = -1;
 		goto done;
 	}
@@ -6123,7 +6125,7 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 	 * Only recheck the info.*line_info* fields.
 	 * Other fields are not the concern of this test.
 	 */
-	if (CHECK(err == -1 ||
+	if (CHECK(err < 0 ||
 		  info.nr_line_info != cnt ||
 		  (jited_cnt && !info.jited_line_info) ||
 		  info.nr_jited_line_info != jited_cnt ||
@@ -6260,7 +6262,7 @@ static void do_test_info_raw(unsigned int test_num)
 			      always_log);
 	free(raw_btf);
 
-	if (CHECK(btf_fd == -1, "invalid btf_fd errno:%d", errno)) {
+	if (CHECK(btf_fd < 0, "invalid btf_fd errno:%d", errno)) {
 		err = -1;
 		goto done;
 	}
@@ -6273,7 +6275,8 @@ static void do_test_info_raw(unsigned int test_num)
 	patched_linfo = patch_name_tbd(test->line_info,
 				       test->str_sec, linfo_str_off,
 				       test->str_sec_size, &linfo_size);
-	if (IS_ERR(patched_linfo)) {
+	err = libbpf_get_error(patched_linfo);
+	if (err) {
 		fprintf(stderr, "error in creating raw bpf_line_info");
 		err = -1;
 		goto done;
@@ -6297,7 +6300,7 @@ static void do_test_info_raw(unsigned int test_num)
 	}
 
 	prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
-	err = ((prog_fd == -1) != test->expected_prog_load_failure);
+	err = ((prog_fd < 0) != test->expected_prog_load_failure);
 	if (CHECK(err, "prog_fd:%d expected_prog_load_failure:%u errno:%d",
 		  prog_fd, test->expected_prog_load_failure, errno) ||
 	    CHECK(test->err_str && !strstr(btf_log_buf, test->err_str),
@@ -6306,7 +6309,7 @@ static void do_test_info_raw(unsigned int test_num)
 		goto done;
 	}
 
-	if (prog_fd == -1)
+	if (prog_fd < 0)
 		goto done;
 
 	err = test_get_finfo(test, prog_fd);
@@ -6323,12 +6326,12 @@ static void do_test_info_raw(unsigned int test_num)
 	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
 
-	if (btf_fd != -1)
+	if (btf_fd >= 0)
 		close(btf_fd);
-	if (prog_fd != -1)
+	if (prog_fd >= 0)
 		close(prog_fd);
 
-	if (!IS_ERR(patched_linfo))
+	if (!libbpf_get_error(patched_linfo))
 		free(patched_linfo);
 }
 
@@ -6839,9 +6842,9 @@ static void do_test_dedup(unsigned int test_num)
 		return;
 
 	test_btf = btf__new((__u8 *)raw_btf, raw_btf_size);
+	err = libbpf_get_error(test_btf);
 	free(raw_btf);
-	if (CHECK(IS_ERR(test_btf), "invalid test_btf errno:%ld",
-		  PTR_ERR(test_btf))) {
+	if (CHECK(err, "invalid test_btf errno:%d", err)) {
 		err = -1;
 		goto done;
 	}
@@ -6853,9 +6856,9 @@ static void do_test_dedup(unsigned int test_num)
 	if (!raw_btf)
 		return;
 	expect_btf = btf__new((__u8 *)raw_btf, raw_btf_size);
+	err = libbpf_get_error(expect_btf);
 	free(raw_btf);
-	if (CHECK(IS_ERR(expect_btf), "invalid expect_btf errno:%ld",
-		  PTR_ERR(expect_btf))) {
+	if (CHECK(err, "invalid expect_btf errno:%d", err)) {
 		err = -1;
 		goto done;
 	}
@@ -6966,10 +6969,8 @@ static void do_test_dedup(unsigned int test_num)
 	}
 
 done:
-	if (!IS_ERR(test_btf))
-		btf__free(test_btf);
-	if (!IS_ERR(expect_btf))
-		btf__free(expect_btf);
+	btf__free(test_btf);
+	btf__free(expect_btf);
 }
 
 void test_btf(void)
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 5e129dc2073c..1b90e684ff13 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -32,8 +32,9 @@ static int btf_dump_all_types(const struct btf *btf,
 	int err = 0, id;
 
 	d = btf_dump__new(btf, NULL, opts, btf_dump_printf);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	err = libbpf_get_error(d);
+	if (err)
+		return err;
 
 	for (id = 1; id <= type_cnt; id++) {
 		err = btf_dump__dump_type(d, id);
@@ -56,8 +57,7 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
 	snprintf(test_file, sizeof(test_file), "%s.o", t->file);
 
 	btf = btf__parse_elf(test_file, NULL);
-	if (CHECK(IS_ERR(btf), "btf_parse_elf",
-	    "failed to load test BTF: %ld\n", PTR_ERR(btf))) {
+	if (!ASSERT_OK_PTR(btf, "btf_parse_elf")) {
 		err = -PTR_ERR(btf);
 		btf = NULL;
 		goto done;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/testing/selftests/bpf/prog_tests/btf_write.c
index f36da15b134f..022c7d89d6f4 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_write.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
@@ -4,8 +4,6 @@
 #include <bpf/btf.h>
 #include "btf_helpers.h"
 
-static int duration = 0;
-
 void test_btf_write() {
 	const struct btf_var_secinfo *vi;
 	const struct btf_type *t;
@@ -16,7 +14,7 @@ void test_btf_write() {
 	int id, err, str_off;
 
 	btf = btf__new_empty();
-	if (CHECK(IS_ERR(btf), "new_empty", "failed: %ld\n", PTR_ERR(btf)))
+	if (!ASSERT_OK_PTR(btf, "new_empty"))
 		return;
 
 	str_off = btf__find_str(btf, "int");
diff --git a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
index 643dfa35419c..876be0ecb654 100644
--- a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
@@ -102,8 +102,7 @@ static void test_egress_only(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	parent_link = bpf_program__attach_cgroup(obj->progs.egress,
 						 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_link), "parent-cg-attach",
-		  "err %ld", PTR_ERR(parent_link)))
+	if (!ASSERT_OK_PTR(parent_link, "parent-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "first-connect-send", "errno %d", errno))
@@ -126,8 +125,7 @@ static void test_egress_only(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	child_link = bpf_program__attach_cgroup(obj->progs.egress,
 						child_cgroup_fd);
-	if (CHECK(IS_ERR(child_link), "child-cg-attach",
-		  "err %ld", PTR_ERR(child_link)))
+	if (!ASSERT_OK_PTR(child_link, "child-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "second-connect-send", "errno %d", errno))
@@ -147,10 +145,8 @@ static void test_egress_only(int parent_cgroup_fd, int child_cgroup_fd)
 		goto close_bpf_object;
 
 close_bpf_object:
-	if (!IS_ERR(parent_link))
-		bpf_link__destroy(parent_link);
-	if (!IS_ERR(child_link))
-		bpf_link__destroy(child_link);
+	bpf_link__destroy(parent_link);
+	bpf_link__destroy(child_link);
 
 	cg_storage_multi_egress_only__destroy(obj);
 }
@@ -176,18 +172,15 @@ static void test_isolated(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	parent_egress1_link = bpf_program__attach_cgroup(obj->progs.egress1,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_egress1_link), "parent-egress1-cg-attach",
-		  "err %ld", PTR_ERR(parent_egress1_link)))
+	if (!ASSERT_OK_PTR(parent_egress1_link, "parent-egress1-cg-attach"))
 		goto close_bpf_object;
 	parent_egress2_link = bpf_program__attach_cgroup(obj->progs.egress2,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_egress2_link), "parent-egress2-cg-attach",
-		  "err %ld", PTR_ERR(parent_egress2_link)))
+	if (!ASSERT_OK_PTR(parent_egress2_link, "parent-egress2-cg-attach"))
 		goto close_bpf_object;
 	parent_ingress_link = bpf_program__attach_cgroup(obj->progs.ingress,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_ingress_link), "parent-ingress-cg-attach",
-		  "err %ld", PTR_ERR(parent_ingress_link)))
+	if (!ASSERT_OK_PTR(parent_ingress_link, "parent-ingress-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "first-connect-send", "errno %d", errno))
@@ -221,18 +214,15 @@ static void test_isolated(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	child_egress1_link = bpf_program__attach_cgroup(obj->progs.egress1,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_egress1_link), "child-egress1-cg-attach",
-		  "err %ld", PTR_ERR(child_egress1_link)))
+	if (!ASSERT_OK_PTR(child_egress1_link, "child-egress1-cg-attach"))
 		goto close_bpf_object;
 	child_egress2_link = bpf_program__attach_cgroup(obj->progs.egress2,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_egress2_link), "child-egress2-cg-attach",
-		  "err %ld", PTR_ERR(child_egress2_link)))
+	if (!ASSERT_OK_PTR(child_egress2_link, "child-egress2-cg-attach"))
 		goto close_bpf_object;
 	child_ingress_link = bpf_program__attach_cgroup(obj->progs.ingress,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_ingress_link), "child-ingress-cg-attach",
-		  "err %ld", PTR_ERR(child_ingress_link)))
+	if (!ASSERT_OK_PTR(child_ingress_link, "child-ingress-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "second-connect-send", "errno %d", errno))
@@ -264,18 +254,12 @@ static void test_isolated(int parent_cgroup_fd, int child_cgroup_fd)
 		goto close_bpf_object;
 
 close_bpf_object:
-	if (!IS_ERR(parent_egress1_link))
-		bpf_link__destroy(parent_egress1_link);
-	if (!IS_ERR(parent_egress2_link))
-		bpf_link__destroy(parent_egress2_link);
-	if (!IS_ERR(parent_ingress_link))
-		bpf_link__destroy(parent_ingress_link);
-	if (!IS_ERR(child_egress1_link))
-		bpf_link__destroy(child_egress1_link);
-	if (!IS_ERR(child_egress2_link))
-		bpf_link__destroy(child_egress2_link);
-	if (!IS_ERR(child_ingress_link))
-		bpf_link__destroy(child_ingress_link);
+	bpf_link__destroy(parent_egress1_link);
+	bpf_link__destroy(parent_egress2_link);
+	bpf_link__destroy(parent_ingress_link);
+	bpf_link__destroy(child_egress1_link);
+	bpf_link__destroy(child_egress2_link);
+	bpf_link__destroy(child_ingress_link);
 
 	cg_storage_multi_isolated__destroy(obj);
 }
@@ -301,18 +285,15 @@ static void test_shared(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	parent_egress1_link = bpf_program__attach_cgroup(obj->progs.egress1,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_egress1_link), "parent-egress1-cg-attach",
-		  "err %ld", PTR_ERR(parent_egress1_link)))
+	if (!ASSERT_OK_PTR(parent_egress1_link, "parent-egress1-cg-attach"))
 		goto close_bpf_object;
 	parent_egress2_link = bpf_program__attach_cgroup(obj->progs.egress2,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_egress2_link), "parent-egress2-cg-attach",
-		  "err %ld", PTR_ERR(parent_egress2_link)))
+	if (!ASSERT_OK_PTR(parent_egress2_link, "parent-egress2-cg-attach"))
 		goto close_bpf_object;
 	parent_ingress_link = bpf_program__attach_cgroup(obj->progs.ingress,
 							 parent_cgroup_fd);
-	if (CHECK(IS_ERR(parent_ingress_link), "parent-ingress-cg-attach",
-		  "err %ld", PTR_ERR(parent_ingress_link)))
+	if (!ASSERT_OK_PTR(parent_ingress_link, "parent-ingress-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "first-connect-send", "errno %d", errno))
@@ -338,18 +319,15 @@ static void test_shared(int parent_cgroup_fd, int child_cgroup_fd)
 	 */
 	child_egress1_link = bpf_program__attach_cgroup(obj->progs.egress1,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_egress1_link), "child-egress1-cg-attach",
-		  "err %ld", PTR_ERR(child_egress1_link)))
+	if (!ASSERT_OK_PTR(child_egress1_link, "child-egress1-cg-attach"))
 		goto close_bpf_object;
 	child_egress2_link = bpf_program__attach_cgroup(obj->progs.egress2,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_egress2_link), "child-egress2-cg-attach",
-		  "err %ld", PTR_ERR(child_egress2_link)))
+	if (!ASSERT_OK_PTR(child_egress2_link, "child-egress2-cg-attach"))
 		goto close_bpf_object;
 	child_ingress_link = bpf_program__attach_cgroup(obj->progs.ingress,
 							child_cgroup_fd);
-	if (CHECK(IS_ERR(child_ingress_link), "child-ingress-cg-attach",
-		  "err %ld", PTR_ERR(child_ingress_link)))
+	if (!ASSERT_OK_PTR(child_ingress_link, "child-ingress-cg-attach"))
 		goto close_bpf_object;
 	err = connect_send(CHILD_CGROUP);
 	if (CHECK(err, "second-connect-send", "errno %d", errno))
@@ -375,18 +353,12 @@ static void test_shared(int parent_cgroup_fd, int child_cgroup_fd)
 		goto close_bpf_object;
 
 close_bpf_object:
-	if (!IS_ERR(parent_egress1_link))
-		bpf_link__destroy(parent_egress1_link);
-	if (!IS_ERR(parent_egress2_link))
-		bpf_link__destroy(parent_egress2_link);
-	if (!IS_ERR(parent_ingress_link))
-		bpf_link__destroy(parent_ingress_link);
-	if (!IS_ERR(child_egress1_link))
-		bpf_link__destroy(child_egress1_link);
-	if (!IS_ERR(child_egress2_link))
-		bpf_link__destroy(child_egress2_link);
-	if (!IS_ERR(child_ingress_link))
-		bpf_link__destroy(child_ingress_link);
+	bpf_link__destroy(parent_egress1_link);
+	bpf_link__destroy(parent_egress2_link);
+	bpf_link__destroy(parent_ingress_link);
+	bpf_link__destroy(child_egress1_link);
+	bpf_link__destroy(child_egress2_link);
+	bpf_link__destroy(child_ingress_link);
 
 	cg_storage_multi_shared__destroy(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
index 0a1fc9816cef..20bb8831dda6 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
@@ -167,7 +167,7 @@ void test_cgroup_attach_multi(void)
 	prog_cnt = 2;
 	CHECK_FAIL(bpf_prog_query(cg5, BPF_CGROUP_INET_EGRESS,
 				  BPF_F_QUERY_EFFECTIVE, &attach_flags,
-				  prog_ids, &prog_cnt) != -1);
+				  prog_ids, &prog_cnt) >= 0);
 	CHECK_FAIL(errno != ENOSPC);
 	CHECK_FAIL(prog_cnt != 4);
 	/* check that prog_ids are returned even when buffer is too small */
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
index 736796e56ed1..9091524131d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -65,8 +65,7 @@ void test_cgroup_link(void)
 	for (i = 0; i < cg_nr; i++) {
 		links[i] = bpf_program__attach_cgroup(skel->progs.egress,
 						      cgs[i].fd);
-		if (CHECK(IS_ERR(links[i]), "cg_attach", "i: %d, err: %ld\n",
-				 i, PTR_ERR(links[i])))
+		if (!ASSERT_OK_PTR(links[i], "cg_attach"))
 			goto cleanup;
 	}
 
@@ -121,8 +120,7 @@ void test_cgroup_link(void)
 
 	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
 						    cgs[last_cg].fd);
-	if (CHECK(IS_ERR(links[last_cg]), "cg_attach", "err: %ld\n",
-		  PTR_ERR(links[last_cg])))
+	if (!ASSERT_OK_PTR(links[last_cg], "cg_attach"))
 		goto cleanup;
 
 	ping_and_check(cg_nr + 1, 0);
@@ -147,7 +145,7 @@ void test_cgroup_link(void)
 	/* attempt to mix in with multi-attach bpf_link */
 	tmp_link = bpf_program__attach_cgroup(skel->progs.egress,
 					      cgs[last_cg].fd);
-	if (CHECK(!IS_ERR(tmp_link), "cg_attach_fail", "unexpected success!\n")) {
+	if (!ASSERT_ERR_PTR(tmp_link, "cg_attach_fail")) {
 		bpf_link__destroy(tmp_link);
 		goto cleanup;
 	}
@@ -165,8 +163,7 @@ void test_cgroup_link(void)
 	/* attach back link-based one */
 	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
 						    cgs[last_cg].fd);
-	if (CHECK(IS_ERR(links[last_cg]), "cg_attach", "err: %ld\n",
-		  PTR_ERR(links[last_cg])))
+	if (!ASSERT_OK_PTR(links[last_cg], "cg_attach"))
 		goto cleanup;
 
 	ping_and_check(cg_nr, 0);
@@ -249,8 +246,7 @@ void test_cgroup_link(void)
 				 BPF_CGROUP_INET_EGRESS);
 
 	for (i = 0; i < cg_nr; i++) {
-		if (!IS_ERR(links[i]))
-			bpf_link__destroy(links[i]);
+		bpf_link__destroy(links[i]);
 	}
 	test_cgroup_link__destroy(skel);
 
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
index 464edc1c1708..b9dc4ec655b5 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_sk_lookup.c
@@ -60,7 +60,7 @@ static void run_cgroup_bpf_test(const char *cg_path, int out_sk)
 		goto cleanup;
 
 	link = bpf_program__attach_cgroup(skel->progs.ingress_lookup, cgfd);
-	if (CHECK(IS_ERR(link), "cgroup_attach", "err: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "cgroup_attach"))
 		goto cleanup;
 
 	run_lookup_test(&skel->bss->g_serv_port, out_sk);
diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
index b62a39315336..012068f33a0a 100644
--- a/tools/testing/selftests/bpf/prog_tests/check_mtu.c
+++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
@@ -53,7 +53,7 @@ static void test_check_mtu_xdp_attach(void)
 	prog = skel->progs.xdp_use_helper_basic;
 
 	link = bpf_program__attach_xdp(prog, IFINDEX_LO);
-	if (CHECK(IS_ERR(link), "link_attach", "failed: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "link_attach"))
 		goto out;
 	skel->links.xdp_use_helper_basic = link;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 607710826dca..d02e064c535f 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -369,8 +369,7 @@ static int setup_type_id_case_local(struct core_reloc_test_case *test)
 	const char *name;
 	int i;
 
-	if (CHECK(IS_ERR(local_btf), "local_btf", "failed: %ld\n", PTR_ERR(local_btf)) ||
-	    CHECK(IS_ERR(targ_btf), "targ_btf", "failed: %ld\n", PTR_ERR(targ_btf))) {
+	if (!ASSERT_OK_PTR(local_btf, "local_btf") || !ASSERT_OK_PTR(targ_btf, "targ_btf")) {
 		btf__free(local_btf);
 		btf__free(targ_btf);
 		return -EINVAL;
@@ -848,8 +847,7 @@ void test_core_reloc(void)
 		}
 
 		obj = bpf_object__open_file(test_case->bpf_obj_file, NULL);
-		if (CHECK(IS_ERR(obj), "obj_open", "failed to open '%s': %ld\n",
-			  test_case->bpf_obj_file, PTR_ERR(obj)))
+		if (!ASSERT_OK_PTR(obj, "obj_open"))
 			continue;
 
 		probe_name = "raw_tracepoint/sys_enter";
@@ -899,8 +897,7 @@ void test_core_reloc(void)
 		data->my_pid_tgid = my_pid_tgid;
 
 		link = bpf_program__attach_raw_tracepoint(prog, tp_name);
-		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-			  PTR_ERR(link)))
+		if (!ASSERT_OK_PTR(link, "attach_raw_tp"))
 			goto cleanup;
 
 		/* trigger test run */
@@ -941,10 +938,8 @@ void test_core_reloc(void)
 			CHECK_FAIL(munmap(mmap_data, mmap_sz));
 			mmap_data = NULL;
 		}
-		if (!IS_ERR_OR_NULL(link)) {
-			bpf_link__destroy(link);
-			link = NULL;
-		}
+		bpf_link__destroy(link);
+		link = NULL;
 		bpf_object__close(obj);
 	}
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 63990842d20f..73b4c76e6b86 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -146,10 +146,8 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 
 close_prog:
 	for (i = 0; i < prog_cnt; i++)
-		if (!IS_ERR_OR_NULL(link[i]))
-			bpf_link__destroy(link[i]);
-	if (!IS_ERR_OR_NULL(obj))
-		bpf_object__close(obj);
+		bpf_link__destroy(link[i]);
+	bpf_object__close(obj);
 	bpf_object__close(tgt_obj);
 	free(link);
 	free(prog);
@@ -231,7 +229,7 @@ static int test_second_attach(struct bpf_object *obj)
 		return err;
 
 	link = bpf_program__attach_freplace(prog, tgt_fd, tgt_name);
-	if (CHECK(IS_ERR(link), "second_link", "failed to attach second link prog_fd %d tgt_fd %d\n", bpf_program__fd(prog), tgt_fd))
+	if (!ASSERT_OK_PTR(link, "second_link"))
 		goto out;
 
 	err = bpf_prog_test_run(tgt_fd, 1, &pkt_v6, sizeof(pkt_v6),
@@ -283,9 +281,7 @@ static void test_fmod_ret_freplace(void)
 	opts.attach_prog_fd = pkt_fd;
 
 	freplace_obj = bpf_object__open_file(freplace_name, &opts);
-	if (CHECK(IS_ERR_OR_NULL(freplace_obj), "freplace_obj_open",
-		  "failed to open %s: %ld\n", freplace_name,
-		  PTR_ERR(freplace_obj)))
+	if (!ASSERT_OK_PTR(freplace_obj, "freplace_obj_open"))
 		goto out;
 
 	err = bpf_object__load(freplace_obj);
@@ -294,14 +290,12 @@ static void test_fmod_ret_freplace(void)
 
 	prog = bpf_program__next(NULL, freplace_obj);
 	freplace_link = bpf_program__attach_trace(prog);
-	if (CHECK(IS_ERR(freplace_link), "freplace_attach_trace", "failed to link\n"))
+	if (!ASSERT_OK_PTR(freplace_link, "freplace_attach_trace"))
 		goto out;
 
 	opts.attach_prog_fd = bpf_program__fd(prog);
 	fmod_obj = bpf_object__open_file(fmod_ret_name, &opts);
-	if (CHECK(IS_ERR_OR_NULL(fmod_obj), "fmod_obj_open",
-		  "failed to open %s: %ld\n", fmod_ret_name,
-		  PTR_ERR(fmod_obj)))
+	if (!ASSERT_OK_PTR(fmod_obj, "fmod_obj_open"))
 		goto out;
 
 	err = bpf_object__load(fmod_obj);
@@ -350,9 +344,7 @@ static void test_obj_load_failure_common(const char *obj_file,
 			   );
 
 	obj = bpf_object__open_file(obj_file, &opts);
-	if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
-		  "failed to open %s: %ld\n", obj_file,
-		  PTR_ERR(obj)))
+	if (!ASSERT_OK_PTR(obj, "obj_open"))
 		goto close_prog;
 
 	/* It should fail to load the program */
@@ -361,8 +353,7 @@ static void test_obj_load_failure_common(const char *obj_file,
 		goto close_prog;
 
 close_prog:
-	if (!IS_ERR_OR_NULL(obj))
-		bpf_object__close(obj);
+	bpf_object__close(obj);
 	bpf_object__close(pkt_obj);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index cd6dc80edf18..225714f71ac6 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -541,7 +541,7 @@ static void test_skb_less_link_create(struct bpf_flow *skel, int tap_fd)
 		return;
 
 	link = bpf_program__attach_netns(skel->progs._dissect, net_fd);
-	if (CHECK(IS_ERR(link), "attach_netns", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_netns"))
 		goto out_close;
 
 	run_tests_skb_less(tap_fd, skel->maps.last_dissection);
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
index 172c586b6996..3931ede5c534 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -134,9 +134,9 @@ static void test_link_create_link_create(int netns, int prog1, int prog2)
 	/* Expect failure creating link when another link exists */
 	errno = 0;
 	link2 = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
-	if (CHECK_FAIL(link2 != -1 || errno != E2BIG))
+	if (CHECK_FAIL(link2 >= 0 || errno != E2BIG))
 		perror("bpf_prog_attach(prog2) expected E2BIG");
-	if (link2 != -1)
+	if (link2 >= 0)
 		close(link2);
 	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
 
@@ -159,9 +159,9 @@ static void test_prog_attach_link_create(int netns, int prog1, int prog2)
 	/* Expect failure creating link when prog attached */
 	errno = 0;
 	link = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
-	if (CHECK_FAIL(link != -1 || errno != EEXIST))
+	if (CHECK_FAIL(link >= 0 || errno != EEXIST))
 		perror("bpf_link_create(prog2) expected EEXIST");
-	if (link != -1)
+	if (link >= 0)
 		close(link);
 	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
 
@@ -623,7 +623,7 @@ static void run_tests(int netns)
 	}
 out_close:
 	for (i = 0; i < ARRAY_SIZE(progs); i++) {
-		if (progs[i] != -1)
+		if (progs[i] >= 0)
 			CHECK_FAIL(close(progs[i]));
 	}
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
index 925722217edf..522237aa4470 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -121,12 +121,12 @@ void test_get_stack_raw_tp(void)
 		goto close_prog;
 
 	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_raw_tp"))
 		goto close_prog;
 
 	pb_opts.sample_cb = get_stack_print_output;
 	pb = perf_buffer__new(bpf_map__fd(map), 8, &pb_opts);
-	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto close_prog;
 
 	/* trigger some syscall action */
@@ -141,9 +141,7 @@ void test_get_stack_raw_tp(void)
 	}
 
 close_prog:
-	if (!IS_ERR_OR_NULL(link))
-		bpf_link__destroy(link);
-	if (!IS_ERR_OR_NULL(pb))
-		perf_buffer__free(pb);
+	bpf_link__destroy(link);
+	perf_buffer__free(pb);
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c b/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
index d884b2ed5bc5..8d5a6023a1bb 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
@@ -48,8 +48,7 @@ void test_get_stackid_cannot_attach(void)
 
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
-	CHECK(!IS_ERR(skel->links.oncpu), "attach_perf_event_no_callchain",
-	      "should have failed\n");
+	ASSERT_ERR_PTR(skel->links.oncpu, "attach_perf_event_no_callchain");
 	close(pmu_fd);
 
 	/* add PERF_SAMPLE_CALLCHAIN, attach should succeed */
@@ -65,8 +64,7 @@ void test_get_stackid_cannot_attach(void)
 
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
-	CHECK(IS_ERR(skel->links.oncpu), "attach_perf_event_callchain",
-	      "err: %ld\n", PTR_ERR(skel->links.oncpu));
+	ASSERT_OK_PTR(skel->links.oncpu, "attach_perf_event_callchain");
 	close(pmu_fd);
 
 	/* add exclude_callchain_kernel, attach should fail */
@@ -82,8 +80,7 @@ void test_get_stackid_cannot_attach(void)
 
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
-	CHECK(!IS_ERR(skel->links.oncpu), "attach_perf_event_exclude_callchain_kernel",
-	      "should have failed\n");
+	ASSERT_ERR_PTR(skel->links.oncpu, "attach_perf_event_exclude_callchain_kernel");
 	close(pmu_fd);
 
 cleanup:
diff --git a/tools/testing/selftests/bpf/prog_tests/hashmap.c b/tools/testing/selftests/bpf/prog_tests/hashmap.c
index 428d488830c6..4747ab18f97f 100644
--- a/tools/testing/selftests/bpf/prog_tests/hashmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/hashmap.c
@@ -48,8 +48,7 @@ static void test_hashmap_generic(void)
 	struct hashmap *map;
 
 	map = hashmap__new(hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "hashmap__new",
-		  "failed to create map: %ld\n", PTR_ERR(map)))
+	if (!ASSERT_OK_PTR(map, "hashmap__new"))
 		return;
 
 	for (i = 0; i < ELEM_CNT; i++) {
@@ -267,8 +266,7 @@ static void test_hashmap_multimap(void)
 
 	/* force collisions */
 	map = hashmap__new(collision_hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "hashmap__new",
-		  "failed to create map: %ld\n", PTR_ERR(map)))
+	if (!ASSERT_OK_PTR(map, "hashmap__new"))
 		return;
 
 	/* set up multimap:
@@ -339,8 +337,7 @@ static void test_hashmap_empty()
 
 	/* force collisions */
 	map = hashmap__new(hash_fn, equal_fn, NULL);
-	if (CHECK(IS_ERR(map), "hashmap__new",
-		  "failed to create map: %ld\n", PTR_ERR(map)))
+	if (!ASSERT_OK_PTR(map, "hashmap__new"))
 		goto cleanup;
 
 	if (CHECK(hashmap__size(map) != 0, "hashmap__size",
diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index d65107919998..ddfb6bf97152 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -97,15 +97,13 @@ void test_kfree_skb(void)
 		goto close_prog;
 
 	link = bpf_program__attach_raw_tracepoint(prog, NULL);
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_raw_tp"))
 		goto close_prog;
 	link_fentry = bpf_program__attach_trace(fentry);
-	if (CHECK(IS_ERR(link_fentry), "attach fentry", "err %ld\n",
-		  PTR_ERR(link_fentry)))
+	if (!ASSERT_OK_PTR(link_fentry, "attach fentry"))
 		goto close_prog;
 	link_fexit = bpf_program__attach_trace(fexit);
-	if (CHECK(IS_ERR(link_fexit), "attach fexit", "err %ld\n",
-		  PTR_ERR(link_fexit)))
+	if (!ASSERT_OK_PTR(link_fexit, "attach fexit"))
 		goto close_prog;
 
 	perf_buf_map = bpf_object__find_map_by_name(obj2, "perf_buf_map");
@@ -116,7 +114,7 @@ void test_kfree_skb(void)
 	pb_opts.sample_cb = on_sample;
 	pb_opts.ctx = &passed;
 	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
-	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto close_prog;
 
 	memcpy(skb.cb, &cb, sizeof(cb));
@@ -144,12 +142,9 @@ void test_kfree_skb(void)
 	CHECK_FAIL(!test_ok[0] || !test_ok[1]);
 close_prog:
 	perf_buffer__free(pb);
-	if (!IS_ERR_OR_NULL(link))
-		bpf_link__destroy(link);
-	if (!IS_ERR_OR_NULL(link_fentry))
-		bpf_link__destroy(link_fentry);
-	if (!IS_ERR_OR_NULL(link_fexit))
-		bpf_link__destroy(link_fexit);
+	bpf_link__destroy(link);
+	bpf_link__destroy(link_fentry);
+	bpf_link__destroy(link_fexit);
 	bpf_object__close(obj);
 	bpf_object__close(obj2);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index b58b775d19f3..67bebd324147 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -87,8 +87,7 @@ void test_ksyms_btf(void)
 	struct btf *btf;
 
 	btf = libbpf_find_kernel_btf();
-	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
-		  PTR_ERR(btf)))
+	if (!ASSERT_OK_PTR(btf, "btf_exists"))
 		return;
 
 	percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
diff --git a/tools/testing/selftests/bpf/prog_tests/link_pinning.c b/tools/testing/selftests/bpf/prog_tests/link_pinning.c
index a743288cf384..6fc97c45f71e 100644
--- a/tools/testing/selftests/bpf/prog_tests/link_pinning.c
+++ b/tools/testing/selftests/bpf/prog_tests/link_pinning.c
@@ -17,7 +17,7 @@ void test_link_pinning_subtest(struct bpf_program *prog,
 	int err, i;
 
 	link = bpf_program__attach(prog);
-	if (CHECK(IS_ERR(link), "link_attach", "err: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "link_attach"))
 		goto cleanup;
 
 	bss->in = 1;
@@ -51,7 +51,7 @@ void test_link_pinning_subtest(struct bpf_program *prog,
 
 	/* re-open link from BPFFS */
 	link = bpf_link__open(link_pin_path);
-	if (CHECK(IS_ERR(link), "link_open", "err: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "link_open"))
 		goto cleanup;
 
 	CHECK(strcmp(link_pin_path, bpf_link__pin_path(link)), "pin_path2",
@@ -84,8 +84,7 @@ void test_link_pinning_subtest(struct bpf_program *prog,
 	CHECK(i == 10000, "link_attached", "got to iteration #%d\n", i);
 
 cleanup:
-	if (!IS_ERR(link))
-		bpf_link__destroy(link);
+	bpf_link__destroy(link);
 }
 
 void test_link_pinning(void)
diff --git a/tools/testing/selftests/bpf/prog_tests/obj_name.c b/tools/testing/selftests/bpf/prog_tests/obj_name.c
index e178416bddad..6194b776a28b 100644
--- a/tools/testing/selftests/bpf/prog_tests/obj_name.c
+++ b/tools/testing/selftests/bpf/prog_tests/obj_name.c
@@ -38,13 +38,13 @@ void test_obj_name(void)
 
 		fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
 		CHECK((tests[i].success && fd < 0) ||
-		      (!tests[i].success && fd != -1) ||
+		      (!tests[i].success && fd >= 0) ||
 		      (!tests[i].success && errno != tests[i].expected_errno),
 		      "check-bpf-prog-name",
 		      "fd %d(%d) errno %d(%d)\n",
 		       fd, tests[i].success, errno, tests[i].expected_errno);
 
-		if (fd != -1)
+		if (fd >= 0)
 			close(fd);
 
 		/* test different attr.map_name during BPF_MAP_CREATE */
@@ -59,13 +59,13 @@ void test_obj_name(void)
 		memcpy(attr.map_name, tests[i].name, ncopy);
 		fd = syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
 		CHECK((tests[i].success && fd < 0) ||
-		      (!tests[i].success && fd != -1) ||
+		      (!tests[i].success && fd >= 0) ||
 		      (!tests[i].success && errno != tests[i].expected_errno),
 		      "check-bpf-map-name",
 		      "fd %d(%d) errno %d(%d)\n",
 		      fd, tests[i].success, errno, tests[i].expected_errno);
 
-		if (fd != -1)
+		if (fd >= 0)
 			close(fd);
 	}
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_branches.c b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
index e35c444902a7..12c4f45cee1a 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_branches.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
@@ -74,7 +74,7 @@ static void test_perf_branches_common(int perf_fd,
 
 	/* attach perf_event */
 	link = bpf_program__attach_perf_event(skel->progs.perf_branches, perf_fd);
-	if (CHECK(IS_ERR(link), "attach_perf_event", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
 		goto out_destroy_skel;
 
 	/* generate some branches on cpu 0 */
@@ -119,7 +119,7 @@ static void test_perf_branches_hw(void)
 	 * Some setups don't support branch records (virtual machines, !x86),
 	 * so skip test in this case.
 	 */
-	if (pfd == -1) {
+	if (pfd < 0) {
 		if (errno == ENOENT || errno == EOPNOTSUPP) {
 			printf("%s:SKIP:no PERF_SAMPLE_BRANCH_STACK\n",
 			       __func__);
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index ca9f0895ec84..6490e9673002 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -80,7 +80,7 @@ void test_perf_buffer(void)
 	pb_opts.sample_cb = on_sample;
 	pb_opts.ctx = &cpu_seen;
 	pb = perf_buffer__new(bpf_map__fd(skel->maps.perf_buf_map), 1, &pb_opts);
-	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto out_close;
 
 	CHECK(perf_buffer__epoll_fd(pb) < 0, "epoll_fd",
diff --git a/tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c b/tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c
index 72c3690844fb..33144c9432ae 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c
@@ -97,8 +97,7 @@ void test_perf_event_stackmap(void)
 
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
-	if (CHECK(IS_ERR(skel->links.oncpu), "attach_perf_event",
-		  "err %ld\n", PTR_ERR(skel->links.oncpu))) {
+	if (!ASSERT_OK_PTR(skel->links.oncpu, "attach_perf_event")) {
 		close(pmu_fd);
 		goto cleanup;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
index 7aecfd9e87d1..95bd12097358 100644
--- a/tools/testing/selftests/bpf/prog_tests/probe_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
@@ -15,7 +15,7 @@ void test_probe_user(void)
 	static const int zero = 0;
 
 	obj = bpf_object__open_file(obj_file, &opts);
-	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
 		return;
 
 	kprobe_prog = bpf_object__find_program_by_title(obj, prog_name);
@@ -33,11 +33,8 @@ void test_probe_user(void)
 		goto cleanup;
 
 	kprobe_link = bpf_program__attach(kprobe_prog);
-	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
-		  "err %ld\n", PTR_ERR(kprobe_link))) {
-		kprobe_link = NULL;
+	if (!ASSERT_OK_PTR(kprobe_link, "attach_kprobe"))
 		goto cleanup;
-	}
 
 	memset(&curr, 0, sizeof(curr));
 	in->sin_family = AF_INET;
diff --git a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
index 131d7f7eeb42..89fc98faf19e 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
@@ -46,7 +46,7 @@ void test_prog_run_xattr(void)
 	tattr.prog_fd = bpf_program__fd(skel->progs.test_pkt_access);
 
 	err = bpf_prog_test_run_xattr(&tattr);
-	CHECK_ATTR(err != -1 || errno != ENOSPC || tattr.retval, "run",
+	CHECK_ATTR(err >= 0 || errno != ENOSPC || tattr.retval, "run",
 	      "err %d errno %d retval %d\n", err, errno, tattr.retval);
 
 	CHECK_ATTR(tattr.data_size_out != sizeof(pkt_v4), "data_size_out",
@@ -78,6 +78,6 @@ void test_prog_run_xattr(void)
 cleanup:
 	if (skel)
 		test_pkt_access__destroy(skel);
-	if (stats_fd != -1)
+	if (stats_fd >= 0)
 		close(stats_fd);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
index c5fb191874ac..41720a62c4fa 100644
--- a/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
+++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
@@ -77,7 +77,7 @@ void test_raw_tp_test_run(void)
 	/* invalid cpu ID should fail with ENXIO */
 	opts.cpu = 0xffffffff;
 	err = bpf_prog_test_run_opts(prog_fd, &opts);
-	CHECK(err != -1 || errno != ENXIO,
+	CHECK(err >= 0 || errno != ENXIO,
 	      "test_run_opts_fail",
 	      "should failed with ENXIO\n");
 
@@ -85,7 +85,7 @@ void test_raw_tp_test_run(void)
 	opts.cpu = 1;
 	opts.flags = 0;
 	err = bpf_prog_test_run_opts(prog_fd, &opts);
-	CHECK(err != -1 || errno != EINVAL,
+	CHECK(err >= 0 || errno != EINVAL,
 	      "test_run_opts_fail",
 	      "should failed with EINVAL\n");
 
diff --git a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
index 563e12120e77..5f9eaa3ab584 100644
--- a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
+++ b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
@@ -30,7 +30,7 @@ void test_rdonly_maps(void)
 	struct bss bss;
 
 	obj = bpf_object__open_file(file, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+	if (!ASSERT_OK_PTR(obj, "obj_open"))
 		return;
 
 	err = bpf_object__load(obj);
@@ -58,11 +58,8 @@ void test_rdonly_maps(void)
 			goto cleanup;
 
 		link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
-		if (CHECK(IS_ERR(link), "attach_prog", "prog '%s', err %ld\n",
-			  t->prog_name, PTR_ERR(link))) {
-			link = NULL;
+		if (!ASSERT_OK_PTR(link, "attach_prog"))
 			goto cleanup;
-		}
 
 		/* trigger probe */
 		usleep(1);
diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index ac1ee10cffd8..de2688166696 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -15,7 +15,7 @@ void test_reference_tracking(void)
 	int err = 0;
 
 	obj = bpf_object__open_file(file, &open_opts);
-	if (CHECK_FAIL(IS_ERR(obj)))
+	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
 		return;
 
 	if (CHECK(strcmp(bpf_object__name(obj), obj_name), "obj_name",
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
index d3c2de2c24d1..f62361306f6d 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -76,7 +76,7 @@ __resolve_symbol(struct btf *btf, int type_id)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_symbols); i++) {
-		if (test_symbols[i].id != -1)
+		if (test_symbols[i].id >= 0)
 			continue;
 
 		if (BTF_INFO_KIND(type->info) != test_symbols[i].type)
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
index cef63e703924..167cd8a2edfd 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -63,7 +63,7 @@ void test_ringbuf_multi(void)
 		goto cleanup;
 
 	proto_fd = bpf_create_map(BPF_MAP_TYPE_RINGBUF, 0, 0, page_size, 0);
-	if (CHECK(proto_fd == -1, "bpf_create_map", "bpf_create_map failed\n"))
+	if (CHECK(proto_fd < 0, "bpf_create_map", "bpf_create_map failed\n"))
 		goto cleanup;
 
 	err = bpf_map__set_inner_map_fd(skel->maps.ringbuf_hash, proto_fd);
diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 821b4146b7b6..4efd337d6a3c 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -78,7 +78,7 @@ static int create_maps(enum bpf_map_type inner_type)
 	attr.max_entries = REUSEPORT_ARRAY_SIZE;
 
 	reuseport_array = bpf_create_map_xattr(&attr);
-	RET_ERR(reuseport_array == -1, "creating reuseport_array",
+	RET_ERR(reuseport_array < 0, "creating reuseport_array",
 		"reuseport_array:%d errno:%d\n", reuseport_array, errno);
 
 	/* Creating outer_map */
@@ -89,7 +89,7 @@ static int create_maps(enum bpf_map_type inner_type)
 	attr.max_entries = 1;
 	attr.inner_map_fd = reuseport_array;
 	outer_map = bpf_create_map_xattr(&attr);
-	RET_ERR(outer_map == -1, "creating outer_map",
+	RET_ERR(outer_map < 0, "creating outer_map",
 		"outer_map:%d errno:%d\n", outer_map, errno);
 
 	return 0;
@@ -102,8 +102,9 @@ static int prepare_bpf_obj(void)
 	int err;
 
 	obj = bpf_object__open("test_select_reuseport_kern.o");
-	RET_ERR(IS_ERR_OR_NULL(obj), "open test_select_reuseport_kern.o",
-		"obj:%p PTR_ERR(obj):%ld\n", obj, PTR_ERR(obj));
+	err = libbpf_get_error(obj);
+	RET_ERR(err, "open test_select_reuseport_kern.o",
+		"obj:%p PTR_ERR(obj):%d\n", obj, err);
 
 	map = bpf_object__find_map_by_name(obj, "outer_map");
 	RET_ERR(!map, "find outer_map", "!map\n");
@@ -116,31 +117,31 @@ static int prepare_bpf_obj(void)
 	prog = bpf_program__next(NULL, obj);
 	RET_ERR(!prog, "get first bpf_program", "!prog\n");
 	select_by_skb_data_prog = bpf_program__fd(prog);
-	RET_ERR(select_by_skb_data_prog == -1, "get prog fd",
+	RET_ERR(select_by_skb_data_prog < 0, "get prog fd",
 		"select_by_skb_data_prog:%d\n", select_by_skb_data_prog);
 
 	map = bpf_object__find_map_by_name(obj, "result_map");
 	RET_ERR(!map, "find result_map", "!map\n");
 	result_map = bpf_map__fd(map);
-	RET_ERR(result_map == -1, "get result_map fd",
+	RET_ERR(result_map < 0, "get result_map fd",
 		"result_map:%d\n", result_map);
 
 	map = bpf_object__find_map_by_name(obj, "tmp_index_ovr_map");
 	RET_ERR(!map, "find tmp_index_ovr_map\n", "!map");
 	tmp_index_ovr_map = bpf_map__fd(map);
-	RET_ERR(tmp_index_ovr_map == -1, "get tmp_index_ovr_map fd",
+	RET_ERR(tmp_index_ovr_map < 0, "get tmp_index_ovr_map fd",
 		"tmp_index_ovr_map:%d\n", tmp_index_ovr_map);
 
 	map = bpf_object__find_map_by_name(obj, "linum_map");
 	RET_ERR(!map, "find linum_map", "!map\n");
 	linum_map = bpf_map__fd(map);
-	RET_ERR(linum_map == -1, "get linum_map fd",
+	RET_ERR(linum_map < 0, "get linum_map fd",
 		"linum_map:%d\n", linum_map);
 
 	map = bpf_object__find_map_by_name(obj, "data_check_map");
 	RET_ERR(!map, "find data_check_map", "!map\n");
 	data_check_map = bpf_map__fd(map);
-	RET_ERR(data_check_map == -1, "get data_check_map fd",
+	RET_ERR(data_check_map < 0, "get data_check_map fd",
 		"data_check_map:%d\n", data_check_map);
 
 	return 0;
@@ -237,7 +238,7 @@ static long get_linum(void)
 	int err;
 
 	err = bpf_map_lookup_elem(linum_map, &index_zero, &linum);
-	RET_ERR(err == -1, "lookup_elem(linum_map)", "err:%d errno:%d\n",
+	RET_ERR(err < 0, "lookup_elem(linum_map)", "err:%d errno:%d\n",
 		err, errno);
 
 	return linum;
@@ -254,11 +255,11 @@ static void check_data(int type, sa_family_t family, const struct cmd *cmd,
 	addrlen = sizeof(cli_sa);
 	err = getsockname(cli_fd, (struct sockaddr *)&cli_sa,
 			  &addrlen);
-	RET_IF(err == -1, "getsockname(cli_fd)", "err:%d errno:%d\n",
+	RET_IF(err < 0, "getsockname(cli_fd)", "err:%d errno:%d\n",
 	       err, errno);
 
 	err = bpf_map_lookup_elem(data_check_map, &index_zero, &result);
-	RET_IF(err == -1, "lookup_elem(data_check_map)", "err:%d errno:%d\n",
+	RET_IF(err < 0, "lookup_elem(data_check_map)", "err:%d errno:%d\n",
 	       err, errno);
 
 	if (type == SOCK_STREAM) {
@@ -347,7 +348,7 @@ static void check_results(void)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_lookup_elem(result_map, &i, &results[i]);
-		RET_IF(err == -1, "lookup_elem(result_map)",
+		RET_IF(err < 0, "lookup_elem(result_map)",
 		       "i:%u err:%d errno:%d\n", i, err, errno);
 	}
 
@@ -524,12 +525,12 @@ static void test_syncookie(int type, sa_family_t family)
 	 */
 	err = bpf_map_update_elem(tmp_index_ovr_map, &index_zero,
 				  &tmp_index, BPF_ANY);
-	RET_IF(err == -1, "update_elem(tmp_index_ovr_map, 0, 1)",
+	RET_IF(err < 0, "update_elem(tmp_index_ovr_map, 0, 1)",
 	       "err:%d errno:%d\n", err, errno);
 	do_test(type, family, &cmd, PASS);
 	err = bpf_map_lookup_elem(tmp_index_ovr_map, &index_zero,
 				  &tmp_index);
-	RET_IF(err == -1 || tmp_index != -1,
+	RET_IF(err < 0 || tmp_index >= 0,
 	       "lookup_elem(tmp_index_ovr_map)",
 	       "err:%d errno:%d tmp_index:%d\n",
 	       err, errno, tmp_index);
@@ -569,7 +570,7 @@ static void test_detach_bpf(int type, sa_family_t family)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_lookup_elem(result_map, &i, &tmp);
-		RET_IF(err == -1, "lookup_elem(result_map)",
+		RET_IF(err < 0, "lookup_elem(result_map)",
 		       "i:%u err:%d errno:%d\n", i, err, errno);
 		nr_run_before += tmp;
 	}
@@ -584,7 +585,7 @@ static void test_detach_bpf(int type, sa_family_t family)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_lookup_elem(result_map, &i, &tmp);
-		RET_IF(err == -1, "lookup_elem(result_map)",
+		RET_IF(err < 0, "lookup_elem(result_map)",
 		       "i:%u err:%d errno:%d\n", i, err, errno);
 		nr_run_after += tmp;
 	}
@@ -632,24 +633,24 @@ static void prepare_sk_fds(int type, sa_family_t family, bool inany)
 					 SO_ATTACH_REUSEPORT_EBPF,
 					 &select_by_skb_data_prog,
 					 sizeof(select_by_skb_data_prog));
-			RET_IF(err == -1, "setsockopt(SO_ATTACH_REUEPORT_EBPF)",
+			RET_IF(err < 0, "setsockopt(SO_ATTACH_REUEPORT_EBPF)",
 			       "err:%d errno:%d\n", err, errno);
 		}
 
 		err = bind(sk_fds[i], (struct sockaddr *)&srv_sa, addrlen);
-		RET_IF(err == -1, "bind()", "sk_fds[%d] err:%d errno:%d\n",
+		RET_IF(err < 0, "bind()", "sk_fds[%d] err:%d errno:%d\n",
 		       i, err, errno);
 
 		if (type == SOCK_STREAM) {
 			err = listen(sk_fds[i], 10);
-			RET_IF(err == -1, "listen()",
+			RET_IF(err < 0, "listen()",
 			       "sk_fds[%d] err:%d errno:%d\n",
 			       i, err, errno);
 		}
 
 		err = bpf_map_update_elem(reuseport_array, &i, &sk_fds[i],
 					  BPF_NOEXIST);
-		RET_IF(err == -1, "update_elem(reuseport_array)",
+		RET_IF(err < 0, "update_elem(reuseport_array)",
 		       "sk_fds[%d] err:%d errno:%d\n", i, err, errno);
 
 		if (i == first) {
@@ -682,7 +683,7 @@ static void setup_per_test(int type, sa_family_t family, bool inany,
 	prepare_sk_fds(type, family, inany);
 	err = bpf_map_update_elem(tmp_index_ovr_map, &index_zero, &ovr,
 				  BPF_ANY);
-	RET_IF(err == -1, "update_elem(tmp_index_ovr_map, 0, -1)",
+	RET_IF(err < 0, "update_elem(tmp_index_ovr_map, 0, -1)",
 	       "err:%d errno:%d\n", err, errno);
 
 	/* Install reuseport_array to outer_map? */
@@ -691,7 +692,7 @@ static void setup_per_test(int type, sa_family_t family, bool inany,
 
 	err = bpf_map_update_elem(outer_map, &index_zero, &reuseport_array,
 				  BPF_ANY);
-	RET_IF(err == -1, "update_elem(outer_map, 0, reuseport_array)",
+	RET_IF(err < 0, "update_elem(outer_map, 0, reuseport_array)",
 	       "err:%d errno:%d\n", err, errno);
 }
 
@@ -720,18 +721,18 @@ static void cleanup_per_test(bool no_inner_map)
 		return;
 
 	err = bpf_map_delete_elem(outer_map, &index_zero);
-	RET_IF(err == -1, "delete_elem(outer_map)",
+	RET_IF(err < 0, "delete_elem(outer_map)",
 	       "err:%d errno:%d\n", err, errno);
 }
 
 static void cleanup(void)
 {
-	if (outer_map != -1) {
+	if (outer_map >= 0) {
 		close(outer_map);
 		outer_map = -1;
 	}
 
-	if (reuseport_array != -1) {
+	if (reuseport_array >= 0) {
 		close(reuseport_array);
 		reuseport_array = -1;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index a1eade51d440..023cc532992d 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -91,8 +91,7 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 
 		skel->links.send_signal_perf =
 			bpf_program__attach_perf_event(skel->progs.send_signal_perf, pmu_fd);
-		if (CHECK(IS_ERR(skel->links.send_signal_perf), "attach_perf_event",
-			  "err %ld\n", PTR_ERR(skel->links.send_signal_perf)))
+		if (!ASSERT_OK_PTR(skel->links.send_signal_perf, "attach_perf_event"))
 			goto disable_pmu;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 45c82db3c58c..aee41547e7f4 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -480,7 +480,7 @@ static struct bpf_link *attach_lookup_prog(struct bpf_program *prog)
 	}
 
 	link = bpf_program__attach_netns(prog, net_fd);
-	if (CHECK(IS_ERR(link), "bpf_program__attach_netns", "failed\n")) {
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_netns")) {
 		errno = -PTR_ERR(link);
 		log_err("failed to attach program '%s' to netns",
 			bpf_program__name(prog));
diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
index af87118e748e..577d619fb07e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -97,12 +97,12 @@ static void check_result(void)
 
 	err = bpf_map_lookup_elem(linum_map_fd, &egress_linum_idx,
 				  &egress_linum);
-	CHECK(err == -1, "bpf_map_lookup_elem(linum_map_fd)",
+	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
 	err = bpf_map_lookup_elem(linum_map_fd, &ingress_linum_idx,
 				  &ingress_linum);
-	CHECK(err == -1, "bpf_map_lookup_elem(linum_map_fd)",
+	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
 	memcpy(&srv_sk, &skel->bss->srv_sk, sizeof(srv_sk));
@@ -355,14 +355,12 @@ void test_sock_fields(void)
 
 	egress_link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields,
 						 child_cg_fd);
-	if (CHECK(IS_ERR(egress_link), "attach_cgroup(egress)", "err:%ld\n",
-		  PTR_ERR(egress_link)))
+	if (!ASSERT_OK_PTR(egress_link, "attach_cgroup(egress)"))
 		goto done;
 
 	ingress_link = bpf_program__attach_cgroup(skel->progs.ingress_read_sock_fields,
 						  child_cg_fd);
-	if (CHECK(IS_ERR(ingress_link), "attach_cgroup(ingress)", "err:%ld\n",
-		  PTR_ERR(ingress_link)))
+	if (!ASSERT_OK_PTR(ingress_link, "attach_cgroup(ingress)"))
 		goto done;
 
 	linum_map_fd = bpf_map__fd(skel->maps.linum_map);
@@ -375,8 +373,8 @@ void test_sock_fields(void)
 	bpf_link__destroy(egress_link);
 	bpf_link__destroy(ingress_link);
 	test_sock_fields__destroy(skel);
-	if (child_cg_fd != -1)
+	if (child_cg_fd >= 0)
 		close(child_cg_fd);
-	if (parent_cg_fd != -1)
+	if (parent_cg_fd >= 0)
 		close(parent_cg_fd);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index ab77596b64e3..1352ec104149 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -88,11 +88,11 @@ static void test_sockmap_create_update_free(enum bpf_map_type map_type)
 	int s, map, err;
 
 	s = connected_socket_v4();
-	if (CHECK_FAIL(s == -1))
+	if (CHECK_FAIL(s < 0))
 		return;
 
 	map = bpf_create_map(map_type, sizeof(int), sizeof(int), 1, 0);
-	if (CHECK_FAIL(map == -1)) {
+	if (CHECK_FAIL(map < 0)) {
 		perror("bpf_create_map");
 		goto out;
 	}
@@ -245,7 +245,7 @@ static void test_sockmap_copy(enum bpf_map_type map_type)
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.copy, &opts);
-	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
 		goto out;
 
 	iter_fd = bpf_iter_create(bpf_link__fd(link));
@@ -304,7 +304,7 @@ static void test_sockmap_skb_verdict_attach(enum bpf_attach_type first,
 	}
 
 	err = bpf_prog_attach(verdict, map, second, 0);
-	assert(err == -1 && errno == EBUSY);
+	ASSERT_EQ(err, -EBUSY, "prog_attach_fail");
 
 	err = bpf_prog_detach2(verdict, map, first);
 	if (CHECK_FAIL(err)) {
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
index 06b86addc181..7a0d64fdc192 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
@@ -98,7 +98,7 @@ static void run_tests(int family, enum bpf_map_type map_type)
 	int map;
 
 	map = bpf_create_map(map_type, sizeof(int), sizeof(int), 1, 0);
-	if (CHECK_FAIL(map == -1)) {
+	if (CHECK_FAIL(map < 0)) {
 		perror("bpf_map_create");
 		return;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..0f066b89b4af 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -139,7 +139,7 @@
 #define xbpf_map_delete_elem(fd, key)                                          \
 	({                                                                     \
 		int __ret = bpf_map_delete_elem((fd), (key));                  \
-		if (__ret == -1)                                               \
+		if (__ret < 0)                                               \
 			FAIL_ERRNO("map_delete");                              \
 		__ret;                                                         \
 	})
@@ -147,7 +147,7 @@
 #define xbpf_map_lookup_elem(fd, key, val)                                     \
 	({                                                                     \
 		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
-		if (__ret == -1)                                               \
+		if (__ret < 0)                                               \
 			FAIL_ERRNO("map_lookup");                              \
 		__ret;                                                         \
 	})
@@ -155,7 +155,7 @@
 #define xbpf_map_update_elem(fd, key, val, flags)                              \
 	({                                                                     \
 		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
-		if (__ret == -1)                                               \
+		if (__ret < 0)                                               \
 			FAIL_ERRNO("map_update");                              \
 		__ret;                                                         \
 	})
@@ -164,7 +164,7 @@
 	({                                                                     \
 		int __ret =                                                    \
 			bpf_prog_attach((prog), (target), (type), (flags));    \
-		if (__ret == -1)                                               \
+		if (__ret < 0)                                               \
 			FAIL_ERRNO("prog_attach(" #type ")");                  \
 		__ret;                                                         \
 	})
@@ -172,7 +172,7 @@
 #define xbpf_prog_detach2(prog, target, type)                                  \
 	({                                                                     \
 		int __ret = bpf_prog_detach2((prog), (target), (type));        \
-		if (__ret == -1)                                               \
+		if (__ret < 0)                                               \
 			FAIL_ERRNO("prog_detach2(" #type ")");                 \
 		__ret;                                                         \
 	})
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 11a769e18f5d..0a91d8d9954b 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -62,8 +62,7 @@ void test_stacktrace_build_id_nmi(void)
 
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
-	if (CHECK(IS_ERR(skel->links.oncpu), "attach_perf_event",
-		  "err %ld\n", PTR_ERR(skel->links.oncpu))) {
+	if (!ASSERT_OK_PTR(skel->links.oncpu, "attach_perf_event")) {
 		close(pmu_fd);
 		goto cleanup;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
index 37269d23df93..04b476bd62b9 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
@@ -21,7 +21,7 @@ void test_stacktrace_map(void)
 		goto close_prog;
 
 	link = bpf_program__attach_tracepoint(prog, "sched", "sched_switch");
-	if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_tp"))
 		goto close_prog;
 
 	/* find map fds */
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
index 404a5498e1a3..4fd30bb651ad 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
@@ -21,7 +21,7 @@ void test_stacktrace_map_raw_tp(void)
 		goto close_prog;
 
 	link = bpf_program__attach_raw_tracepoint(prog, "sched_switch");
-	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_raw_tp"))
 		goto close_prog;
 
 	/* find map fds */
@@ -59,7 +59,6 @@ void test_stacktrace_map_raw_tp(void)
 		goto close_prog;
 
 close_prog:
-	if (!IS_ERR_OR_NULL(link))
-		bpf_link__destroy(link);
+	bpf_link__destroy(link);
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 08d19cafd5e8..1fa772079967 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -353,8 +353,7 @@ static void fastopen_estab(void)
 		return;
 
 	link = bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
-	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
-		  PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(estab)"))
 		return;
 
 	if (sk_fds_connect(&sk_fds, true)) {
@@ -398,8 +397,7 @@ static void syncookie_estab(void)
 		return;
 
 	link = bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
-	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
-		  PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(estab)"))
 		return;
 
 	if (sk_fds_connect(&sk_fds, false)) {
@@ -431,8 +429,7 @@ static void fin(void)
 		return;
 
 	link = bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
-	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
-		  PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(estab)"))
 		return;
 
 	if (sk_fds_connect(&sk_fds, false)) {
@@ -471,8 +468,7 @@ static void __simple_estab(bool exprm)
 		return;
 
 	link = bpf_program__attach_cgroup(skel->progs.estab, cg_fd);
-	if (CHECK(IS_ERR(link), "attach_cgroup(estab)", "err: %ld\n",
-		  PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(estab)"))
 		return;
 
 	if (sk_fds_connect(&sk_fds, false)) {
@@ -509,8 +505,7 @@ static void misc(void)
 		return;
 
 	link = bpf_program__attach_cgroup(misc_skel->progs.misc_estab, cg_fd);
-	if (CHECK(IS_ERR(link), "attach_cgroup(misc_estab)", "err: %ld\n",
-		  PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(misc_estab)"))
 		return;
 
 	if (sk_fds_connect(&sk_fds, false)) {
diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
index 9966685866fd..123c68c1917d 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_overhead.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -73,7 +73,7 @@ void test_test_overhead(void)
 		return;
 
 	obj = bpf_object__open_file("./test_overhead.o", NULL);
-	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
 		return;
 
 	kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
@@ -108,7 +108,7 @@ void test_test_overhead(void)
 	/* attach kprobe */
 	link = bpf_program__attach_kprobe(kprobe_prog, false /* retprobe */,
 					  kprobe_func);
-	if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_kprobe"))
 		goto cleanup;
 	test_run("kprobe");
 	bpf_link__destroy(link);
@@ -116,28 +116,28 @@ void test_test_overhead(void)
 	/* attach kretprobe */
 	link = bpf_program__attach_kprobe(kretprobe_prog, true /* retprobe */,
 					  kprobe_func);
-	if (CHECK(IS_ERR(link), "attach kretprobe", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_kretprobe"))
 		goto cleanup;
 	test_run("kretprobe");
 	bpf_link__destroy(link);
 
 	/* attach raw_tp */
 	link = bpf_program__attach_raw_tracepoint(raw_tp_prog, "task_rename");
-	if (CHECK(IS_ERR(link), "attach fentry", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_raw_tp"))
 		goto cleanup;
 	test_run("raw_tp");
 	bpf_link__destroy(link);
 
 	/* attach fentry */
 	link = bpf_program__attach_trace(fentry_prog);
-	if (CHECK(IS_ERR(link), "attach fentry", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_fentry"))
 		goto cleanup;
 	test_run("fentry");
 	bpf_link__destroy(link);
 
 	/* attach fexit */
 	link = bpf_program__attach_trace(fexit_prog);
-	if (CHECK(IS_ERR(link), "attach fexit", "err %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "attach_fexit"))
 		goto cleanup;
 	test_run("fexit");
 	bpf_link__destroy(link);
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index f3022d934e2d..d7f5a931d7f3 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -55,7 +55,7 @@ void test_trampoline_count(void)
 	/* attach 'allowed' trampoline programs */
 	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
 		obj = bpf_object__open_file(object, NULL);
-		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
+		if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
 			obj = NULL;
 			goto cleanup;
 		}
@@ -68,14 +68,14 @@ void test_trampoline_count(void)
 
 		if (rand() % 2) {
 			link = load(inst[i].obj, fentry_name);
-			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
+			if (!ASSERT_OK_PTR(link, "attach_prog")) {
 				link = NULL;
 				goto cleanup;
 			}
 			inst[i].link_fentry = link;
 		} else {
 			link = load(inst[i].obj, fexit_name);
-			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
+			if (!ASSERT_OK_PTR(link, "attach_prog")) {
 				link = NULL;
 				goto cleanup;
 			}
@@ -85,7 +85,7 @@ void test_trampoline_count(void)
 
 	/* and try 1 extra.. */
 	obj = bpf_object__open_file(object, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
+	if (!ASSERT_OK_PTR(obj, "obj_open_file")) {
 		obj = NULL;
 		goto cleanup;
 	}
@@ -96,13 +96,15 @@ void test_trampoline_count(void)
 
 	/* ..that needs to fail */
 	link = load(obj, fentry_name);
-	if (CHECK(!IS_ERR(link), "cannot attach over the limit", "err %ld\n", PTR_ERR(link))) {
+	err = libbpf_get_error(link);
+	if (!ASSERT_ERR_PTR(link, "cannot attach over the limit")) {
 		bpf_link__destroy(link);
 		goto cleanup_extra;
 	}
 
 	/* with E2BIG error */
-	CHECK(PTR_ERR(link) != -E2BIG, "proper error check", "err %ld\n", PTR_ERR(link));
+	ASSERT_EQ(err, -E2BIG, "proper error check");
+	ASSERT_EQ(link, NULL, "ptr_is_null");
 
 	/* and finaly execute the probe */
 	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
index 2aba09d4d01b..56c9d6bd38a3 100644
--- a/tools/testing/selftests/bpf/prog_tests/udp_limit.c
+++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
@@ -22,11 +22,10 @@ void test_udp_limit(void)
 		goto close_cgroup_fd;
 
 	skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.sock, "cg_attach_sock"))
+		goto close_skeleton;
 	skel->links.sock_release = bpf_program__attach_cgroup(skel->progs.sock_release, cgroup_fd);
-	if (CHECK(IS_ERR(skel->links.sock) || IS_ERR(skel->links.sock_release),
-		  "cg-attach", "sock %ld sock_release %ld",
-		  PTR_ERR(skel->links.sock),
-		  PTR_ERR(skel->links.sock_release)))
+	if (!ASSERT_OK_PTR(skel->links.sock_release, "cg_attach_sock_release"))
 		goto close_skeleton;
 
 	/* BPF program enforces a single UDP socket per cgroup,
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 2c6c570b21f8..3bd5904b4db5 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -90,7 +90,7 @@ void test_xdp_bpf2bpf(void)
 	pb_opts.ctx = &passed;
 	pb = perf_buffer__new(bpf_map__fd(ftrace_skel->maps.perf_buf_map),
 			      1, &pb_opts);
-	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto out;
 
 	/* Run test program */
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
index 6f814999b395..46eed0a33c23 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -51,7 +51,7 @@ void test_xdp_link(void)
 
 	/* BPF link is not allowed to replace prog attachment */
 	link = bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
-	if (CHECK(!IS_ERR(link), "link_attach_fail", "unexpected success\n")) {
+	if (!ASSERT_ERR_PTR(link, "link_attach_should_fail")) {
 		bpf_link__destroy(link);
 		/* best-effort detach prog */
 		opts.old_fd = prog_fd1;
@@ -67,7 +67,7 @@ void test_xdp_link(void)
 
 	/* now BPF link should attach successfully */
 	link = bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
-	if (CHECK(IS_ERR(link), "link_attach", "failed: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "link_attach"))
 		goto cleanup;
 	skel1->links.xdp_handler = link;
 
@@ -95,7 +95,7 @@ void test_xdp_link(void)
 
 	/* BPF link is not allowed to replace another BPF link */
 	link = bpf_program__attach_xdp(skel2->progs.xdp_handler, IFINDEX_LO);
-	if (CHECK(!IS_ERR(link), "link_attach_fail", "unexpected success\n")) {
+	if (!ASSERT_ERR_PTR(link, "link_attach_should_fail")) {
 		bpf_link__destroy(link);
 		goto cleanup;
 	}
@@ -105,7 +105,7 @@ void test_xdp_link(void)
 
 	/* new link attach should succeed */
 	link = bpf_program__attach_xdp(skel2->progs.xdp_handler, IFINDEX_LO);
-	if (CHECK(IS_ERR(link), "link_attach", "failed: %ld\n", PTR_ERR(link)))
+	if (!ASSERT_OK_PTR(link, "link_attach"))
 		goto cleanup;
 	skel2->links.xdp_handler = link;
 
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 8410a730c82f..30cbf5d98f7d 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -53,12 +53,12 @@ static void test_hashmap(unsigned int task, void *data)
 
 	value = 0;
 	/* BPF_NOEXIST means add new element if it doesn't exist. */
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       /* key=1 already exists. */
 	       errno == EEXIST);
 
 	/* -1 is an invalid flag. */
-	assert(bpf_map_update_elem(fd, &key, &value, -1) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, -1) < 0 &&
 	       errno == EINVAL);
 
 	/* Check that key=1 can be found. */
@@ -73,10 +73,10 @@ static void test_hashmap(unsigned int task, void *data)
 	assert(bpf_map_lookup_and_delete_elem(fd, &key, &value) == 0 && value == 1234);
 
 	/* Check that key=2 is not found. */
-	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, &value) < 0 && errno == ENOENT);
 
 	/* BPF_EXIST means update existing element. */
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_EXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_EXIST) < 0 &&
 	       /* key=2 is not there. */
 	       errno == ENOENT);
 
@@ -87,7 +87,7 @@ static void test_hashmap(unsigned int task, void *data)
 	 * inserted due to max_entries limit.
 	 */
 	key = 0;
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Update existing element, though the map is full. */
@@ -96,12 +96,12 @@ static void test_hashmap(unsigned int task, void *data)
 	key = 2;
 	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == 0);
 	key = 3;
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Check that key = 0 doesn't exist. */
 	key = 0;
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == ENOENT);
 
 	/* Iterate over two elements. */
 	assert(bpf_map_get_next_key(fd, NULL, &first_key) == 0 &&
@@ -111,7 +111,7 @@ static void test_hashmap(unsigned int task, void *data)
 	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == 0 &&
 	       (next_key == 1 || next_key == 2) &&
 	       (next_key != first_key));
-	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, &next_key, &next_key) < 0 &&
 	       errno == ENOENT);
 
 	/* Delete both elements. */
@@ -119,13 +119,13 @@ static void test_hashmap(unsigned int task, void *data)
 	assert(bpf_map_delete_elem(fd, &key) == 0);
 	key = 2;
 	assert(bpf_map_delete_elem(fd, &key) == 0);
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == ENOENT);
 
 	key = 0;
 	/* Check that map is empty. */
-	assert(bpf_map_get_next_key(fd, NULL, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, NULL, &next_key) < 0 &&
 	       errno == ENOENT);
-	assert(bpf_map_get_next_key(fd, &key, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, &key, &next_key) < 0 &&
 	       errno == ENOENT);
 
 	close(fd);
@@ -186,12 +186,12 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 	expected_key_mask |= key;
 
 	/* BPF_NOEXIST means add new element if it doesn't exist. */
-	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) < 0 &&
 	       /* key=1 already exists. */
 	       errno == EEXIST);
 
 	/* -1 is an invalid flag. */
-	assert(bpf_map_update_elem(fd, &key, value, -1) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, value, -1) < 0 &&
 	       errno == EINVAL);
 
 	/* Check that key=1 can be found. Value could be 0 if the lookup
@@ -203,10 +203,10 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 
 	key = 2;
 	/* Check that key=2 is not found. */
-	assert(bpf_map_lookup_elem(fd, &key, value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, value) < 0 && errno == ENOENT);
 
 	/* BPF_EXIST means update existing element. */
-	assert(bpf_map_update_elem(fd, &key, value, BPF_EXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, value, BPF_EXIST) < 0 &&
 	       /* key=2 is not there. */
 	       errno == ENOENT);
 
@@ -219,11 +219,11 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 	 * inserted due to max_entries limit.
 	 */
 	key = 0;
-	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, value, BPF_NOEXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Check that key = 0 doesn't exist. */
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == ENOENT);
 
 	/* Iterate over two elements. */
 	assert(bpf_map_get_next_key(fd, NULL, &first_key) == 0 &&
@@ -254,13 +254,13 @@ static void test_hashmap_percpu(unsigned int task, void *data)
 	assert(bpf_map_delete_elem(fd, &key) == 0);
 	key = 2;
 	assert(bpf_map_delete_elem(fd, &key) == 0);
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == ENOENT);
 
 	key = 0;
 	/* Check that map is empty. */
-	assert(bpf_map_get_next_key(fd, NULL, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, NULL, &next_key) < 0 &&
 	       errno == ENOENT);
-	assert(bpf_map_get_next_key(fd, &key, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, &key, &next_key) < 0 &&
 	       errno == ENOENT);
 
 	close(fd);
@@ -377,7 +377,7 @@ static void test_arraymap(unsigned int task, void *data)
 	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == 0);
 
 	value = 0;
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       errno == EEXIST);
 
 	/* Check that key=1 can be found. */
@@ -391,11 +391,11 @@ static void test_arraymap(unsigned int task, void *data)
 	 * due to max_entries limit.
 	 */
 	key = 2;
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_EXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_EXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Check that key = 2 doesn't exist. */
-	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, &value) < 0 && errno == ENOENT);
 
 	/* Iterate over two elements. */
 	assert(bpf_map_get_next_key(fd, NULL, &next_key) == 0 &&
@@ -404,12 +404,12 @@ static void test_arraymap(unsigned int task, void *data)
 	       next_key == 0);
 	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == 0 &&
 	       next_key == 1);
-	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, &next_key, &next_key) < 0 &&
 	       errno == ENOENT);
 
 	/* Delete shouldn't succeed. */
 	key = 1;
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == EINVAL);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == EINVAL);
 
 	close(fd);
 }
@@ -435,7 +435,7 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 	assert(bpf_map_update_elem(fd, &key, values, BPF_ANY) == 0);
 
 	bpf_percpu(values, 0) = 0;
-	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, BPF_NOEXIST) < 0 &&
 	       errno == EEXIST);
 
 	/* Check that key=1 can be found. */
@@ -450,11 +450,11 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 
 	/* Check that key=2 cannot be inserted due to max_entries limit. */
 	key = 2;
-	assert(bpf_map_update_elem(fd, &key, values, BPF_EXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, values, BPF_EXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Check that key = 2 doesn't exist. */
-	assert(bpf_map_lookup_elem(fd, &key, values) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, values) < 0 && errno == ENOENT);
 
 	/* Iterate over two elements. */
 	assert(bpf_map_get_next_key(fd, NULL, &next_key) == 0 &&
@@ -463,12 +463,12 @@ static void test_arraymap_percpu(unsigned int task, void *data)
 	       next_key == 0);
 	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == 0 &&
 	       next_key == 1);
-	assert(bpf_map_get_next_key(fd, &next_key, &next_key) == -1 &&
+	assert(bpf_map_get_next_key(fd, &next_key, &next_key) < 0 &&
 	       errno == ENOENT);
 
 	/* Delete shouldn't succeed. */
 	key = 1;
-	assert(bpf_map_delete_elem(fd, &key) == -1 && errno == EINVAL);
+	assert(bpf_map_delete_elem(fd, &key) < 0 && errno == EINVAL);
 
 	close(fd);
 }
@@ -572,7 +572,7 @@ static void test_queuemap(unsigned int task, void *data)
 		assert(bpf_map_update_elem(fd, NULL, &vals[i], 0) == 0);
 
 	/* Check that element cannot be pushed due to max_entries limit */
-	assert(bpf_map_update_elem(fd, NULL, &val, 0) == -1 &&
+	assert(bpf_map_update_elem(fd, NULL, &val, 0) < 0 &&
 	       errno == E2BIG);
 
 	/* Peek element */
@@ -588,12 +588,12 @@ static void test_queuemap(unsigned int task, void *data)
 		       val == vals[i]);
 
 	/* Check that there are not elements left */
-	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &val) == -1 &&
+	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &val) < 0 &&
 	       errno == ENOENT);
 
 	/* Check that non supported functions set errno to EINVAL */
-	assert(bpf_map_delete_elem(fd, NULL) == -1 && errno == EINVAL);
-	assert(bpf_map_get_next_key(fd, NULL, NULL) == -1 && errno == EINVAL);
+	assert(bpf_map_delete_elem(fd, NULL) < 0 && errno == EINVAL);
+	assert(bpf_map_get_next_key(fd, NULL, NULL) < 0 && errno == EINVAL);
 
 	close(fd);
 }
@@ -630,7 +630,7 @@ static void test_stackmap(unsigned int task, void *data)
 		assert(bpf_map_update_elem(fd, NULL, &vals[i], 0) == 0);
 
 	/* Check that element cannot be pushed due to max_entries limit */
-	assert(bpf_map_update_elem(fd, NULL, &val, 0) == -1 &&
+	assert(bpf_map_update_elem(fd, NULL, &val, 0) < 0 &&
 	       errno == E2BIG);
 
 	/* Peek element */
@@ -646,12 +646,12 @@ static void test_stackmap(unsigned int task, void *data)
 		       val == vals[i]);
 
 	/* Check that there are not elements left */
-	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &val) == -1 &&
+	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &val) < 0 &&
 	       errno == ENOENT);
 
 	/* Check that non supported functions set errno to EINVAL */
-	assert(bpf_map_delete_elem(fd, NULL) == -1 && errno == EINVAL);
-	assert(bpf_map_get_next_key(fd, NULL, NULL) == -1 && errno == EINVAL);
+	assert(bpf_map_delete_elem(fd, NULL) < 0 && errno == EINVAL);
+	assert(bpf_map_get_next_key(fd, NULL, NULL) < 0 && errno == EINVAL);
 
 	close(fd);
 }
@@ -852,7 +852,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 
 	bpf_map_rx = bpf_object__find_map_by_name(obj, "sock_map_rx");
-	if (IS_ERR(bpf_map_rx)) {
+	if (!bpf_map_rx) {
 		printf("Failed to load map rx from verdict prog\n");
 		goto out_sockmap;
 	}
@@ -864,7 +864,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 
 	bpf_map_tx = bpf_object__find_map_by_name(obj, "sock_map_tx");
-	if (IS_ERR(bpf_map_tx)) {
+	if (!bpf_map_tx) {
 		printf("Failed to load map tx from verdict prog\n");
 		goto out_sockmap;
 	}
@@ -876,7 +876,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 
 	bpf_map_msg = bpf_object__find_map_by_name(obj, "sock_map_msg");
-	if (IS_ERR(bpf_map_msg)) {
+	if (!bpf_map_msg) {
 		printf("Failed to load map msg from msg_verdict prog\n");
 		goto out_sockmap;
 	}
@@ -888,7 +888,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 
 	bpf_map_break = bpf_object__find_map_by_name(obj, "sock_map_break");
-	if (IS_ERR(bpf_map_break)) {
+	if (!bpf_map_break) {
 		printf("Failed to load map tx from verdict prog\n");
 		goto out_sockmap;
 	}
@@ -1170,7 +1170,7 @@ static void test_map_in_map(void)
 	}
 
 	map = bpf_object__find_map_by_name(obj, "mim_array");
-	if (IS_ERR(map)) {
+	if (!map) {
 		printf("Failed to load array of maps from test prog\n");
 		goto out_map_in_map;
 	}
@@ -1181,7 +1181,7 @@ static void test_map_in_map(void)
 	}
 
 	map = bpf_object__find_map_by_name(obj, "mim_hash");
-	if (IS_ERR(map)) {
+	if (!map) {
 		printf("Failed to load hash of maps from test prog\n");
 		goto out_map_in_map;
 	}
@@ -1194,7 +1194,7 @@ static void test_map_in_map(void)
 	bpf_object__load(obj);
 
 	map = bpf_object__find_map_by_name(obj, "mim_array");
-	if (IS_ERR(map)) {
+	if (!map) {
 		printf("Failed to load array of maps from test prog\n");
 		goto out_map_in_map;
 	}
@@ -1211,7 +1211,7 @@ static void test_map_in_map(void)
 	}
 
 	map = bpf_object__find_map_by_name(obj, "mim_hash");
-	if (IS_ERR(map)) {
+	if (!map) {
 		printf("Failed to load hash of maps from test prog\n");
 		goto out_map_in_map;
 	}
@@ -1263,7 +1263,7 @@ static void test_map_large(void)
 	}
 
 	key.c = -1;
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       errno == E2BIG);
 
 	/* Iterate through all elements. */
@@ -1271,12 +1271,12 @@ static void test_map_large(void)
 	key.c = -1;
 	for (i = 0; i < MAP_SIZE; i++)
 		assert(bpf_map_get_next_key(fd, &key, &key) == 0);
-	assert(bpf_map_get_next_key(fd, &key, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_get_next_key(fd, &key, &key) < 0 && errno == ENOENT);
 
 	key.c = 0;
 	assert(bpf_map_lookup_elem(fd, &key, &value) == 0 && value == 0);
 	key.a = 1;
-	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, &value) < 0 && errno == ENOENT);
 
 	close(fd);
 }
@@ -1408,7 +1408,7 @@ static void test_map_parallel(void)
 	run_parallel(TASKS, test_update_delete, data);
 
 	/* Check that key=0 is already there. */
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) < 0 &&
 	       errno == EEXIST);
 
 	/* Check that all elements were inserted. */
@@ -1416,7 +1416,7 @@ static void test_map_parallel(void)
 	key = -1;
 	for (i = 0; i < MAP_SIZE; i++)
 		assert(bpf_map_get_next_key(fd, &key, &key) == 0);
-	assert(bpf_map_get_next_key(fd, &key, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_get_next_key(fd, &key, &key) < 0 && errno == ENOENT);
 
 	/* Another check for all elements */
 	for (i = 0; i < MAP_SIZE; i++) {
@@ -1432,8 +1432,8 @@ static void test_map_parallel(void)
 
 	/* Nothing should be left. */
 	key = -1;
-	assert(bpf_map_get_next_key(fd, NULL, &key) == -1 && errno == ENOENT);
-	assert(bpf_map_get_next_key(fd, &key, &key) == -1 && errno == ENOENT);
+	assert(bpf_map_get_next_key(fd, NULL, &key) < 0 && errno == ENOENT);
+	assert(bpf_map_get_next_key(fd, &key, &key) < 0 && errno == ENOENT);
 }
 
 static void test_map_rdonly(void)
@@ -1451,12 +1451,12 @@ static void test_map_rdonly(void)
 	key = 1;
 	value = 1234;
 	/* Try to insert key=1 element. */
-	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == -1 &&
+	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) < 0 &&
 	       errno == EPERM);
 
 	/* Check that key=1 is not found. */
-	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
-	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == ENOENT);
+	assert(bpf_map_lookup_elem(fd, &key, &value) < 0 && errno == ENOENT);
+	assert(bpf_map_get_next_key(fd, &key, &value) < 0 && errno == ENOENT);
 
 	close(fd);
 }
@@ -1479,8 +1479,8 @@ static void test_map_wronly_hash(void)
 	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == 0);
 
 	/* Check that reading elements and keys from the map is not allowed. */
-	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == EPERM);
-	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == EPERM);
+	assert(bpf_map_lookup_elem(fd, &key, &value) < 0 && errno == EPERM);
+	assert(bpf_map_get_next_key(fd, &key, &value) < 0 && errno == EPERM);
 
 	close(fd);
 }
@@ -1507,10 +1507,10 @@ static void test_map_wronly_stack_or_queue(enum bpf_map_type map_type)
 	assert(bpf_map_update_elem(fd, NULL, &value, BPF_ANY) == 0);
 
 	/* Peek element should fail */
-	assert(bpf_map_lookup_elem(fd, NULL, &value) == -1 && errno == EPERM);
+	assert(bpf_map_lookup_elem(fd, NULL, &value) < 0 && errno == EPERM);
 
 	/* Pop element should fail */
-	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &value) == -1 &&
+	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &value) < 0 &&
 	       errno == EPERM);
 
 	close(fd);
@@ -1564,7 +1564,7 @@ static void prepare_reuseport_grp(int type, int map_fd, size_t map_elem_size,
 			value = &fd32;
 		}
 		err = bpf_map_update_elem(map_fd, &index0, value, BPF_ANY);
-		CHECK(err != -1 || errno != EINVAL,
+		CHECK(err >= 0 || errno != EINVAL,
 		      "reuseport array update unbound sk",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
@@ -1593,7 +1593,7 @@ static void prepare_reuseport_grp(int type, int map_fd, size_t map_elem_size,
 			 */
 			err = bpf_map_update_elem(map_fd, &index0, value,
 						  BPF_ANY);
-			CHECK(err != -1 || errno != EINVAL,
+			CHECK(err >= 0 || errno != EINVAL,
 			      "reuseport array update non-listening sk",
 			      "sock_type:%d err:%d errno:%d\n",
 			      type, err, errno);
@@ -1623,31 +1623,31 @@ static void test_reuseport_array(void)
 
 	map_fd = bpf_create_map(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
 				sizeof(__u32), sizeof(__u64), array_size, 0);
-	CHECK(map_fd == -1, "reuseport array create",
+	CHECK(map_fd < 0, "reuseport array create",
 	      "map_fd:%d, errno:%d\n", map_fd, errno);
 
 	/* Test lookup/update/delete with invalid index */
 	err = bpf_map_delete_elem(map_fd, &bad_index);
-	CHECK(err != -1 || errno != E2BIG, "reuseport array del >=max_entries",
+	CHECK(err >= 0 || errno != E2BIG, "reuseport array del >=max_entries",
 	      "err:%d errno:%d\n", err, errno);
 
 	err = bpf_map_update_elem(map_fd, &bad_index, &fd64, BPF_ANY);
-	CHECK(err != -1 || errno != E2BIG,
+	CHECK(err >= 0 || errno != E2BIG,
 	      "reuseport array update >=max_entries",
 	      "err:%d errno:%d\n", err, errno);
 
 	err = bpf_map_lookup_elem(map_fd, &bad_index, &map_cookie);
-	CHECK(err != -1 || errno != ENOENT,
+	CHECK(err >= 0 || errno != ENOENT,
 	      "reuseport array update >=max_entries",
 	      "err:%d errno:%d\n", err, errno);
 
 	/* Test lookup/delete non existence elem */
 	err = bpf_map_lookup_elem(map_fd, &index3, &map_cookie);
-	CHECK(err != -1 || errno != ENOENT,
+	CHECK(err >= 0 || errno != ENOENT,
 	      "reuseport array lookup not-exist elem",
 	      "err:%d errno:%d\n", err, errno);
 	err = bpf_map_delete_elem(map_fd, &index3);
-	CHECK(err != -1 || errno != ENOENT,
+	CHECK(err >= 0 || errno != ENOENT,
 	      "reuseport array del not-exist elem",
 	      "err:%d errno:%d\n", err, errno);
 
@@ -1661,7 +1661,7 @@ static void test_reuseport_array(void)
 		/* BPF_EXIST failure case */
 		err = bpf_map_update_elem(map_fd, &index3, &grpa_fds64[fds_idx],
 					  BPF_EXIST);
-		CHECK(err != -1 || errno != ENOENT,
+		CHECK(err >= 0 || errno != ENOENT,
 		      "reuseport array update empty elem BPF_EXIST",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
@@ -1670,7 +1670,7 @@ static void test_reuseport_array(void)
 		/* BPF_NOEXIST success case */
 		err = bpf_map_update_elem(map_fd, &index3, &grpa_fds64[fds_idx],
 					  BPF_NOEXIST);
-		CHECK(err == -1,
+		CHECK(err < 0,
 		      "reuseport array update empty elem BPF_NOEXIST",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
@@ -1679,7 +1679,7 @@ static void test_reuseport_array(void)
 		/* BPF_EXIST success case. */
 		err = bpf_map_update_elem(map_fd, &index3, &grpa_fds64[fds_idx],
 					  BPF_EXIST);
-		CHECK(err == -1,
+		CHECK(err < 0,
 		      "reuseport array update same elem BPF_EXIST",
 		      "sock_type:%d err:%d errno:%d\n", type, err, errno);
 		fds_idx = REUSEPORT_FD_IDX(err, fds_idx);
@@ -1687,7 +1687,7 @@ static void test_reuseport_array(void)
 		/* BPF_NOEXIST failure case */
 		err = bpf_map_update_elem(map_fd, &index3, &grpa_fds64[fds_idx],
 					  BPF_NOEXIST);
-		CHECK(err != -1 || errno != EEXIST,
+		CHECK(err >= 0 || errno != EEXIST,
 		      "reuseport array update non-empty elem BPF_NOEXIST",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
@@ -1696,7 +1696,7 @@ static void test_reuseport_array(void)
 		/* BPF_ANY case (always succeed) */
 		err = bpf_map_update_elem(map_fd, &index3, &grpa_fds64[fds_idx],
 					  BPF_ANY);
-		CHECK(err == -1,
+		CHECK(err < 0,
 		      "reuseport array update same sk with BPF_ANY",
 		      "sock_type:%d err:%d errno:%d\n", type, err, errno);
 
@@ -1705,32 +1705,32 @@ static void test_reuseport_array(void)
 
 		/* The same sk cannot be added to reuseport_array twice */
 		err = bpf_map_update_elem(map_fd, &index3, &fd64, BPF_ANY);
-		CHECK(err != -1 || errno != EBUSY,
+		CHECK(err >= 0 || errno != EBUSY,
 		      "reuseport array update same sk with same index",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
 
 		err = bpf_map_update_elem(map_fd, &index0, &fd64, BPF_ANY);
-		CHECK(err != -1 || errno != EBUSY,
+		CHECK(err >= 0 || errno != EBUSY,
 		      "reuseport array update same sk with different index",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
 
 		/* Test delete elem */
 		err = bpf_map_delete_elem(map_fd, &index3);
-		CHECK(err == -1, "reuseport array delete sk",
+		CHECK(err < 0, "reuseport array delete sk",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
 
 		/* Add it back with BPF_NOEXIST */
 		err = bpf_map_update_elem(map_fd, &index3, &fd64, BPF_NOEXIST);
-		CHECK(err == -1,
+		CHECK(err < 0,
 		      "reuseport array re-add with BPF_NOEXIST after del",
 		      "sock_type:%d err:%d errno:%d\n", type, err, errno);
 
 		/* Test cookie */
 		err = bpf_map_lookup_elem(map_fd, &index3, &map_cookie);
-		CHECK(err == -1 || sk_cookie != map_cookie,
+		CHECK(err < 0 || sk_cookie != map_cookie,
 		      "reuseport array lookup re-added sk",
 		      "sock_type:%d err:%d errno:%d sk_cookie:0x%llx map_cookie:0x%llxn",
 		      type, err, errno, sk_cookie, map_cookie);
@@ -1739,7 +1739,7 @@ static void test_reuseport_array(void)
 		for (f = 0; f < ARRAY_SIZE(grpa_fds64); f++)
 			close(grpa_fds64[f]);
 		err = bpf_map_lookup_elem(map_fd, &index3, &map_cookie);
-		CHECK(err != -1 || errno != ENOENT,
+		CHECK(err >= 0 || errno != ENOENT,
 		      "reuseport array lookup after close()",
 		      "sock_type:%d err:%d errno:%d\n",
 		      type, err, errno);
@@ -1750,7 +1750,7 @@ static void test_reuseport_array(void)
 	CHECK(fd64 == -1, "socket(SOCK_RAW)", "err:%d errno:%d\n",
 	      err, errno);
 	err = bpf_map_update_elem(map_fd, &index3, &fd64, BPF_NOEXIST);
-	CHECK(err != -1 || errno != ENOTSUPP, "reuseport array update SOCK_RAW",
+	CHECK(err >= 0 || errno != ENOTSUPP, "reuseport array update SOCK_RAW",
 	      "err:%d errno:%d\n", err, errno);
 	close(fd64);
 
@@ -1760,16 +1760,16 @@ static void test_reuseport_array(void)
 	/* Test 32 bit fd */
 	map_fd = bpf_create_map(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
 				sizeof(__u32), sizeof(__u32), array_size, 0);
-	CHECK(map_fd == -1, "reuseport array create",
+	CHECK(map_fd < 0, "reuseport array create",
 	      "map_fd:%d, errno:%d\n", map_fd, errno);
 	prepare_reuseport_grp(SOCK_STREAM, map_fd, sizeof(__u32), &fd64,
 			      &sk_cookie, 1);
 	fd = fd64;
 	err = bpf_map_update_elem(map_fd, &index3, &fd, BPF_NOEXIST);
-	CHECK(err == -1, "reuseport array update 32 bit fd",
+	CHECK(err < 0, "reuseport array update 32 bit fd",
 	      "err:%d errno:%d\n", err, errno);
 	err = bpf_map_lookup_elem(map_fd, &index3, &map_cookie);
-	CHECK(err != -1 || errno != ENOSPC,
+	CHECK(err >= 0 || errno != ENOSPC,
 	      "reuseport array lookup 32 bit fd",
 	      "err:%d errno:%d\n", err, errno);
 	close(fd);
@@ -1815,6 +1815,8 @@ int main(void)
 {
 	srand(time(NULL));
 
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	map_flags = 0;
 	run_all_tests();
 
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 6396932b97e2..6f103106a39b 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -737,6 +737,9 @@ int main(int argc, char **argv)
 	if (err)
 		return err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	libbpf_set_print(libbpf_print_fn);
 
 	srand(time(NULL));
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index dda52cb649dc..8ef7f334e715 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -249,16 +249,17 @@ extern int test__join_cgroup(const char *path);
 #define ASSERT_OK_PTR(ptr, name) ({					\
 	static int duration = 0;					\
 	const void *___res = (ptr);					\
-	bool ___ok = !IS_ERR_OR_NULL(___res);				\
-	CHECK(!___ok, (name),						\
-	      "unexpected error: %ld\n", PTR_ERR(___res));		\
+	int ___err = libbpf_get_error(___res);				\
+	bool ___ok = ___err == 0;					\
+	CHECK(!___ok, (name), "unexpected error: %d\n", ___err);	\
 	___ok;								\
 })
 
 #define ASSERT_ERR_PTR(ptr, name) ({					\
 	static int duration = 0;					\
 	const void *___res = (ptr);					\
-	bool ___ok = IS_ERR(___res);					\
+	int ___err = libbpf_get_error(___res);				\
+	bool ___ok = ___err != 0;					\
 	CHECK(!___ok, (name), "unexpected pointer: %p\n", ___res);	\
 	___ok;								\
 })
diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
index 73da7fe8c152..4a39304cc5a6 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -82,6 +82,8 @@ int main(int argc, char **argv)
 	cpu_set_t cpuset;
 	__u32 key = 0;
 
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	CPU_ZERO(&cpuset);
 	CPU_SET(0, &cpuset);
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
@@ -116,7 +118,7 @@ int main(int argc, char **argv)
 
 	pb_opts.sample_cb = dummyfn;
 	pb = perf_buffer__new(bpf_map__fd(perf_map), 8, &pb_opts);
-	if (IS_ERR(pb))
+	if (!pb)
 		goto err;
 
 	pthread_create(&tid, NULL, poller_thread, pb);
@@ -163,7 +165,6 @@ int main(int argc, char **argv)
 	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
 	close(cg_fd);
 	cleanup_cgroup_environment();
-	if (!IS_ERR_OR_NULL(pb))
-		perf_buffer__free(pb);
+	perf_buffer__free(pb);
 	return error;
 }
-- 
2.30.2

