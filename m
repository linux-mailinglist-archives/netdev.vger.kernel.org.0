Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C3E1FE5B7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgFRC2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgFRBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7A1206F1;
        Thu, 18 Jun 2020 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442987;
        bh=RVSaT6LYoj3XXsg5xvTN1oshIshbjQg32gpKeHuevxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nxkcxo0oal4Oj4bLTDPbPT1KWJDTQXlUSvcdPYgM5+hlc/aBfZf3B9pciTXPwl4ij
         dnNbo9nJte6QkzutnjB20jnILm/T2GCuBA69ICZPumw+xykerlAGweQCzBUeoHGoEH
         /zleJ/N48OsAfTAmYamcxE5pUczihs5V+WT0CjoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 387/388] libbpf: Support pre-initializing .bss global variables
Date:   Wed, 17 Jun 2020 21:08:04 -0400
Message-Id: <20200618010805.600873-387-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit caf62492f479585296e9d636c798d5ac256b7b04 ]

Remove invalid assumption in libbpf that .bss map doesn't have to be updated
in kernel. With addition of skeleton and memory-mapped initialization image,
.bss doesn't have to be all zeroes when BPF map is created, because user-code
might have initialized those variables from user-space.

Fixes: eba9c5f498a1 ("libbpf: Refactor global data map initialization")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200612194504.557844-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c                        |  4 --
 .../selftests/bpf/prog_tests/skeleton.c       | 45 ++++++++++++++++---
 .../selftests/bpf/progs/test_skeleton.c       | 19 ++++++--
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..7d80bb1fea4c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3455,10 +3455,6 @@ bpf_object__populate_internal_map(struct bpf_object *obj, struct bpf_map *map)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero = 0;
 
-	/* kernel already zero-initializes .bss map. */
-	if (map_type == LIBBPF_MAP_BSS)
-		return 0;
-
 	err = bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
 	if (err) {
 		err = -errno;
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index 9264a2736018..fa153cf67b1b 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -15,6 +15,8 @@ void test_skeleton(void)
 	int duration = 0, err;
 	struct test_skeleton* skel;
 	struct test_skeleton__bss *bss;
+	struct test_skeleton__data *data;
+	struct test_skeleton__rodata *rodata;
 	struct test_skeleton__kconfig *kcfg;
 
 	skel = test_skeleton__open();
@@ -24,13 +26,45 @@ void test_skeleton(void)
 	if (CHECK(skel->kconfig, "skel_kconfig", "kconfig is mmaped()!\n"))
 		goto cleanup;
 
+	bss = skel->bss;
+	data = skel->data;
+	rodata = skel->rodata;
+
+	/* validate values are pre-initialized correctly */
+	CHECK(data->in1 != -1, "in1", "got %d != exp %d\n", data->in1, -1);
+	CHECK(data->out1 != -1, "out1", "got %d != exp %d\n", data->out1, -1);
+	CHECK(data->in2 != -1, "in2", "got %lld != exp %lld\n", data->in2, -1LL);
+	CHECK(data->out2 != -1, "out2", "got %lld != exp %lld\n", data->out2, -1LL);
+
+	CHECK(bss->in3 != 0, "in3", "got %d != exp %d\n", bss->in3, 0);
+	CHECK(bss->out3 != 0, "out3", "got %d != exp %d\n", bss->out3, 0);
+	CHECK(bss->in4 != 0, "in4", "got %lld != exp %lld\n", bss->in4, 0LL);
+	CHECK(bss->out4 != 0, "out4", "got %lld != exp %lld\n", bss->out4, 0LL);
+
+	CHECK(rodata->in6 != 0, "in6", "got %d != exp %d\n", rodata->in6, 0);
+	CHECK(bss->out6 != 0, "out6", "got %d != exp %d\n", bss->out6, 0);
+
+	/* validate we can pre-setup global variables, even in .bss */
+	data->in1 = 10;
+	data->in2 = 11;
+	bss->in3 = 12;
+	bss->in4 = 13;
+	rodata->in6 = 14;
+
 	err = test_skeleton__load(skel);
 	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
 		goto cleanup;
 
-	bss = skel->bss;
-	bss->in1 = 1;
-	bss->in2 = 2;
+	/* validate pre-setup values are still there */
+	CHECK(data->in1 != 10, "in1", "got %d != exp %d\n", data->in1, 10);
+	CHECK(data->in2 != 11, "in2", "got %lld != exp %lld\n", data->in2, 11LL);
+	CHECK(bss->in3 != 12, "in3", "got %d != exp %d\n", bss->in3, 12);
+	CHECK(bss->in4 != 13, "in4", "got %lld != exp %lld\n", bss->in4, 13LL);
+	CHECK(rodata->in6 != 14, "in6", "got %d != exp %d\n", rodata->in6, 14);
+
+	/* now set new values and attach to get them into outX variables */
+	data->in1 = 1;
+	data->in2 = 2;
 	bss->in3 = 3;
 	bss->in4 = 4;
 	bss->in5.a = 5;
@@ -44,14 +78,15 @@ void test_skeleton(void)
 	/* trigger tracepoint */
 	usleep(1);
 
-	CHECK(bss->out1 != 1, "res1", "got %d != exp %d\n", bss->out1, 1);
-	CHECK(bss->out2 != 2, "res2", "got %lld != exp %d\n", bss->out2, 2);
+	CHECK(data->out1 != 1, "res1", "got %d != exp %d\n", data->out1, 1);
+	CHECK(data->out2 != 2, "res2", "got %lld != exp %d\n", data->out2, 2);
 	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
 	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
 	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
 	      bss->handler_out5.a, 5);
 	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
 	      bss->handler_out5.b, 6);
+	CHECK(bss->out6 != 14, "res7", "got %d != exp %d\n", bss->out6, 14);
 
 	CHECK(bss->bpf_syscall != kcfg->CONFIG_BPF_SYSCALL, "ext1",
 	      "got %d != exp %d\n", bss->bpf_syscall, kcfg->CONFIG_BPF_SYSCALL);
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
index de03a90f78ca..77ae86f44db5 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -10,16 +10,26 @@ struct s {
 	long long b;
 } __attribute__((packed));
 
-int in1 = 0;
-long long in2 = 0;
+/* .data section */
+int in1 = -1;
+long long in2 = -1;
+
+/* .bss section */
 char in3 = '\0';
 long long in4 __attribute__((aligned(64))) = 0;
 struct s in5 = {};
 
-long long out2 = 0;
+/* .rodata section */
+const volatile int in6 = 0;
+
+/* .data section */
+int out1 = -1;
+long long out2 = -1;
+
+/* .bss section */
 char out3 = 0;
 long long out4 = 0;
-int out1 = 0;
+int out6 = 0;
 
 extern bool CONFIG_BPF_SYSCALL __kconfig;
 extern int LINUX_KERNEL_VERSION __kconfig;
@@ -36,6 +46,7 @@ int handler(const void *ctx)
 	out3 = in3;
 	out4 = in4;
 	out5 = in5;
+	out6 = in6;
 
 	bpf_syscall = CONFIG_BPF_SYSCALL;
 	kern_ver = LINUX_KERNEL_VERSION;
-- 
2.25.1

