Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A651B49D819
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiA0Ce2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:34:28 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:32063 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiA0Ce1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:34:27 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Jkl1d4mkyz1FD4Y;
        Thu, 27 Jan 2022 10:30:29 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 27 Jan
 2022 10:34:24 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize ring buffer size
Date:   Thu, 27 Jan 2022 10:49:39 +0800
Message-ID: <20220127024939.364016-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4096 is OK for x86-64, but for other archs with greater than 4KB
page size (e.g. 64KB under arm64), test_verifier for test case
"check valid spill/fill, ptr to mem" will fail, so just use
getpagesize() to initialize the ring buffer size. Do this for
test_progs as well.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/d_path.c | 14 ++++++++++++--
 .../testing/selftests/bpf/prog_tests/test_ima.c | 17 +++++++++++++----
 tools/testing/selftests/bpf/progs/ima.c         |  1 -
 .../bpf/progs/test_d_path_check_types.c         |  1 -
 tools/testing/selftests/bpf/test_verifier.c     |  2 +-
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index 911345c526e6..abfa3697e34d 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -171,10 +171,20 @@ static void test_d_path_check_rdonly_mem(void)
 static void test_d_path_check_types(void)
 {
 	struct test_d_path_check_types *skel;
+	int err;
+
+	skel = test_d_path_check_types__open();
+	if (!ASSERT_OK_PTR(skel, "d_path_check_types open failed"))
+		return;
 
-	skel = test_d_path_check_types__open_and_load();
-	ASSERT_ERR_PTR(skel, "unexpected_load_passing_wrong_type");
+	err = bpf_map__set_max_entries(skel->maps.ringbuf, getpagesize());
+	if (!ASSERT_OK(err, "set max entries"))
+		goto cleanup;
 
+	err = test_d_path_check_types__load(skel);
+	ASSERT_EQ(err, -EACCES, "unexpected_load_passing_wrong_type");
+
+cleanup:
 	test_d_path_check_types__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 97d8a6f84f4a..ffc4d8b6e753 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -48,11 +48,19 @@ void test_test_ima(void)
 	char cmd[256];
 
 	int err, duration = 0;
-	struct ima *skel = NULL;
+	struct ima *skel;
 
-	skel = ima__open_and_load();
-	if (CHECK(!skel, "skel_load", "skeleton failed\n"))
-		goto close_prog;
+	skel = ima__open();
+	if (!ASSERT_OK_PTR(skel, "skel open"))
+		return;
+
+	err = bpf_map__set_max_entries(skel->maps.ringbuf, getpagesize());
+	if (!ASSERT_OK(err, "set max entries"))
+		goto destroy_skel;
+
+	err = ima__load(skel);
+	if (!ASSERT_OK(err, "skel load"))
+		goto destroy_skel;
 
 	ringbuf = ring_buffer__new(bpf_map__fd(skel->maps.ringbuf),
 				   process_sample, NULL, NULL);
@@ -86,5 +94,6 @@ void test_test_ima(void)
 	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
 	ring_buffer__free(ringbuf);
+destroy_skel:
 	ima__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 96060ff4ffc6..e192a9f16aea 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -13,7 +13,6 @@ u32 monitored_pid = 0;
 
 struct {
 	__uint(type, BPF_MAP_TYPE_RINGBUF);
-	__uint(max_entries, 1 << 12);
 } ringbuf SEC(".maps");
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
index 7e02b7361307..1b68d4a65abb 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
@@ -8,7 +8,6 @@ extern const int bpf_prog_active __ksym;
 
 struct {
 	__uint(type, BPF_MAP_TYPE_RINGBUF);
-	__uint(max_entries, 1 << 12);
 } ringbuf SEC(".maps");
 
 SEC("fentry/security_inode_getattr")
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 29bbaa58233c..6acb5e747715 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -931,7 +931,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 	if (*fixup_map_ringbuf) {
 		map_fds[20] = create_map(BPF_MAP_TYPE_RINGBUF, 0,
-					   0, 4096);
+					   0, getpagesize());
 		do {
 			prog[*fixup_map_ringbuf].imm = map_fds[20];
 			fixup_map_ringbuf++;
-- 
2.29.2

