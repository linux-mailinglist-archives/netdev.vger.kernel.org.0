Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636464D2EE1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiCIMP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiCIMPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:15:53 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2046310E06C;
        Wed,  9 Mar 2022 04:14:54 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KDB0m66rszBrk7;
        Wed,  9 Mar 2022 20:12:56 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 20:14:51 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 4/4] selftests/bpf: Test subprog jit when toggle bpf_jit_harden repeatedly
Date:   Wed, 9 Mar 2022 20:33:21 +0800
Message-ID: <20220309123321.2400262-5-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220309123321.2400262-1-houtao1@huawei.com>
References: <20220309123321.2400262-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When bpf_jit_harden is toggled between 0 and 2, subprog jit may fail
due to inconsistent twice read values of bpf_jit_harden during jit. So
add a test to ensure the problem is fixed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/subprogs.c       | 77 ++++++++++++++++---
 1 file changed, 68 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/subprogs.c b/tools/testing/selftests/bpf/prog_tests/subprogs.c
index 3f3d2ac4dd57..903f35a9e62e 100644
--- a/tools/testing/selftests/bpf/prog_tests/subprogs.c
+++ b/tools/testing/selftests/bpf/prog_tests/subprogs.c
@@ -1,32 +1,83 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #include <test_progs.h>
-#include <time.h>
 #include "test_subprogs.skel.h"
 #include "test_subprogs_unused.skel.h"
 
-static int duration;
+struct toggler_ctx {
+	int fd;
+	bool stop;
+};
 
-void test_subprogs(void)
+static void *toggle_jit_harden(void *arg)
+{
+	struct toggler_ctx *ctx = arg;
+	char two = '2';
+	char zero = '0';
+
+	while (!ctx->stop) {
+		lseek(ctx->fd, SEEK_SET, 0);
+		write(ctx->fd, &two, sizeof(two));
+		lseek(ctx->fd, SEEK_SET, 0);
+		write(ctx->fd, &zero, sizeof(zero));
+	}
+
+	return NULL;
+}
+
+static void test_subprogs_with_jit_harden_toggling(void)
+{
+	struct toggler_ctx ctx;
+	pthread_t toggler;
+	int err;
+	unsigned int i, loop = 10;
+
+	ctx.fd = open("/proc/sys/net/core/bpf_jit_harden", O_RDWR);
+	if (!ASSERT_GE(ctx.fd, 0, "open bpf_jit_harden"))
+		return;
+
+	ctx.stop = false;
+	err = pthread_create(&toggler, NULL, toggle_jit_harden, &ctx);
+	if (!ASSERT_OK(err, "new toggler"))
+		goto out;
+
+	/* Make toggler thread to run */
+	usleep(1);
+
+	for (i = 0; i < loop; i++) {
+		struct test_subprogs *skel = test_subprogs__open_and_load();
+
+		if (!ASSERT_OK_PTR(skel, "skel open"))
+			break;
+		test_subprogs__destroy(skel);
+	}
+
+	ctx.stop = true;
+	pthread_join(toggler, NULL);
+out:
+	close(ctx.fd);
+}
+
+static void test_subprogs_alone(void)
 {
 	struct test_subprogs *skel;
 	struct test_subprogs_unused *skel2;
 	int err;
 
 	skel = test_subprogs__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
 
 	err = test_subprogs__attach(skel);
-	if (CHECK(err, "skel_attach", "failed to attach skeleton: %d\n", err))
+	if (!ASSERT_OK(err, "skel attach"))
 		goto cleanup;
 
 	usleep(1);
 
-	CHECK(skel->bss->res1 != 12, "res1", "got %d, exp %d\n", skel->bss->res1, 12);
-	CHECK(skel->bss->res2 != 17, "res2", "got %d, exp %d\n", skel->bss->res2, 17);
-	CHECK(skel->bss->res3 != 19, "res3", "got %d, exp %d\n", skel->bss->res3, 19);
-	CHECK(skel->bss->res4 != 36, "res4", "got %d, exp %d\n", skel->bss->res4, 36);
+	ASSERT_EQ(skel->bss->res1, 12, "res1");
+	ASSERT_EQ(skel->bss->res2, 17, "res2");
+	ASSERT_EQ(skel->bss->res3, 19, "res3");
+	ASSERT_EQ(skel->bss->res4, 36, "res4");
 
 	skel2 = test_subprogs_unused__open_and_load();
 	ASSERT_OK_PTR(skel2, "unused_progs_skel");
@@ -35,3 +86,11 @@ void test_subprogs(void)
 cleanup:
 	test_subprogs__destroy(skel);
 }
+
+void test_subprogs(void)
+{
+	if (test__start_subtest("subprogs_alone"))
+		test_subprogs_alone();
+	if (test__start_subtest("subprogs_and_jit_harden"))
+		test_subprogs_with_jit_harden_toggling();
+}
-- 
2.29.2

