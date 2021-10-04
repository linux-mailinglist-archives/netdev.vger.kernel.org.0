Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F604208BB
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhJDJvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbhJDJvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 05:51:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFCAC061745;
        Mon,  4 Oct 2021 02:49:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v11so3394372pgb.8;
        Mon, 04 Oct 2021 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wx9DpnbwUMGeAU5OeC2TqZu1kEa5DvJJ9RhH8/A2uyw=;
        b=UB0pgeNHKkMY9dxXLO+xiIKupBAnbzdzDiwQ8z8zSiACfq+r2f5crtyFJUwGyyGnvP
         nUd+7z0jOiHEYGGZXjMR/mIhE8xnqcsiGhDL85fKuc9Fyv9PNdtysBghDv3ZnNl2F1HJ
         NX7XcUPmhTsSBFNJU4LyJBTS+UKSGG+oCbVngCne3C2d+5hjbjEnqj7PZfLII2oiTVLL
         276W/8fFZk7EcJhKgQ7lLPy+Mdicp59qylhQD8UJAUdt8Y1YezvJQDYuinbgZKqpE02m
         aFrM//9XxFmL631LIcrGNyYudb0N7+2sEV6Mey6c/PL7lCQAuYbqqTvtrD4pEFK1AaDq
         Lt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wx9DpnbwUMGeAU5OeC2TqZu1kEa5DvJJ9RhH8/A2uyw=;
        b=ALN0FaSvvpOrWwqOcSFqmj9vefhefXmRzL8WrKLkkMaYa3l1UOoTbLwfP8YWUGOLxf
         BGskpy8V6TyN/a1Dhboxzhuy4xIp1klogMUUZT22GdprE6nQ5sBHNz8IWH2r5VESjzIA
         Nk/ldNAlp1VAdSSRgeiBTI7uKZb7Wy62cg91osITnBxiaOZqzPERcVqawitvzdq2te1f
         zjiDNqzBuzOS99LVbCXTCFA5u/QeFPPySxp0/zzwwdJabq+od9VvhlSCx+04JvCgUAl8
         jFJ8aA9m93uKExMTT4LeFeHGHcvewpRJegRgna5DUs8UnsF1+3E8FuELIAf62LpSEow1
         m1ZQ==
X-Gm-Message-State: AOAM530pysv6N9nRTDwLd7Qmfde23sSYJzanSSG4YQpfhG1rtyOTFgB+
        QMfqB17iM4PZQAbB0/WHvls=
X-Google-Smtp-Source: ABdhPJwYqTQKMjENNXutliFslHqtbdsPnN5mWxVo1wWrd2U2wZzI7DWdLqFvbyvYeYxHFlunvf+Tqg==
X-Received: by 2002:a62:5304:0:b0:44c:719c:a2c with SMTP id h4-20020a625304000000b0044c719c0a2cmr363051pfb.13.1633340957972;
        Mon, 04 Oct 2021 02:49:17 -0700 (PDT)
Received: from localhost ([27.102.113.79])
        by smtp.gmail.com with ESMTPSA id k14sm12908985pji.45.2021.10.04.02.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:49:17 -0700 (PDT)
From:   Hou Tao <hotforest@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v5 3/3] bpf/selftests: add test for writable bare tracepoint
Date:   Mon,  4 Oct 2021 17:48:57 +0800
Message-Id: <20211004094857.30868-4-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211004094857.30868-1-hotforest@gmail.com>
References: <20211004094857.30868-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Add a writable bare tracepoint in bpf_testmod module, and
trigger its calling when reading /sys/kernel/bpf_testmod
with a specific buffer length. The reading will return
the value in writable context if the early return flag
is enabled in writable context.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 35 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
 tools/testing/selftests/bpf/test_progs.c      |  4 +--
 tools/testing/selftests/bpf/test_progs.h      |  2 ++
 7 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
index 89c6d58e5dd6..11ee801e75e7 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -34,6 +34,21 @@ DECLARE_TRACE(bpf_testmod_test_write_bare,
 	TP_ARGS(task, ctx)
 );
 
+#undef BPF_TESTMOD_DECLARE_TRACE
+#ifdef DECLARE_TRACE_WRITABLE
+#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
+	DECLARE_TRACE_WRITABLE(call, PARAMS(proto), PARAMS(args), size)
+#else
+#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
+	DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
+#endif
+
+BPF_TESTMOD_DECLARE_TRACE(bpf_testmod_test_writable_bare,
+	TP_PROTO(struct bpf_testmod_test_writable_ctx *ctx),
+	TP_ARGS(ctx),
+	sizeof(struct bpf_testmod_test_writable_ctx)
+);
+
 #endif /* _BPF_TESTMOD_EVENTS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 50fc5561110a..1cc1d315ccf5 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -42,6 +42,16 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	if (bpf_testmod_loop_test(101) > 100)
 		trace_bpf_testmod_test_read(current, &ctx);
 
+	/* Magic number to enable writable tp */
+	if (len == 64) {
+		struct bpf_testmod_test_writable_ctx writable = {
+			.val = 1024,
+		};
+		trace_bpf_testmod_test_writable_bare(&writable);
+		if (writable.early_ret)
+			return snprintf(buf, len, "%d\n", writable.val);
+	}
+
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
index b3892dc40111..0d71e2607832 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
@@ -17,4 +17,9 @@ struct bpf_testmod_test_write_ctx {
 	size_t len;
 };
 
+struct bpf_testmod_test_writable_ctx {
+	bool early_ret;
+	int val;
+};
+
 #endif /* _BPF_TESTMOD_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index 1797a6e4d6d8..6d0e50dcf47c 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -2,10 +2,36 @@
 /* Copyright (c) 2020 Facebook */
 
 #include <test_progs.h>
+#include <stdbool.h>
 #include "test_module_attach.skel.h"
 
 static int duration;
 
+static int trigger_module_test_writable(int *val)
+{
+	int fd, err;
+	char buf[65];
+	ssize_t rd;
+
+	fd = open(BPF_TESTMOD_TEST_FILE, O_RDONLY);
+	err = -errno;
+	if (!ASSERT_GE(fd, 0, "testmode_file_open"))
+		return err;
+
+	rd = read(fd, buf, sizeof(buf) - 1);
+	err = -errno;
+	if (!ASSERT_GT(rd, 0, "testmod_file_rd_val")) {
+		close(fd);
+		return err;
+	}
+
+	buf[rd] = '\0';
+	*val = strtol(buf, NULL, 0);
+	close(fd);
+
+	return 0;
+}
+
 static int delete_module(const char *name, int flags)
 {
 	return syscall(__NR_delete_module, name, flags);
@@ -19,6 +45,7 @@ void test_module_attach(void)
 	struct test_module_attach__bss *bss;
 	struct bpf_link *link;
 	int err;
+	int writable_val = 0;
 
 	skel = test_module_attach__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
@@ -51,6 +78,14 @@ void test_module_attach(void)
 	ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
 	ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
 
+	bss->raw_tp_writable_bare_early_ret = true;
+	bss->raw_tp_writable_bare_out_val = 0xf1f2f3f4;
+	ASSERT_OK(trigger_module_test_writable(&writable_val),
+		  "trigger_writable");
+	ASSERT_EQ(bss->raw_tp_writable_bare_in_val, 1024, "writable_test_in");
+	ASSERT_EQ(bss->raw_tp_writable_bare_out_val, writable_val,
+		  "writable_test_out");
+
 	test_module_attach__detach(skel);
 
 	/* attach fentry/fexit and make sure it get's module reference */
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index bd37ceec5587..b36857093f71 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -27,6 +27,20 @@ int BPF_PROG(handle_raw_tp_bare,
 	return 0;
 }
 
+int raw_tp_writable_bare_in_val = 0;
+int raw_tp_writable_bare_early_ret = 0;
+int raw_tp_writable_bare_out_val = 0;
+
+SEC("raw_tp.w/bpf_testmod_test_writable_bare")
+int BPF_PROG(handle_raw_tp_writable_bare,
+	     struct bpf_testmod_test_writable_ctx *writable)
+{
+	raw_tp_writable_bare_in_val = writable->val;
+	writable->early_ret = raw_tp_writable_bare_early_ret;
+	writable->val = raw_tp_writable_bare_out_val;
+	return 0;
+}
+
 __u32 tp_btf_read_sz = 0;
 
 SEC("tp_btf/bpf_testmod_test_read")
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 2ed01f615d20..007b4ff85fea 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -747,7 +747,7 @@ int trigger_module_test_read(int read_sz)
 {
 	int fd, err;
 
-	fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
+	fd = open(BPF_TESTMOD_TEST_FILE, O_RDONLY);
 	err = -errno;
 	if (!ASSERT_GE(fd, 0, "testmod_file_open"))
 		return err;
@@ -769,7 +769,7 @@ int trigger_module_test_write(int write_sz)
 	memset(buf, 'a', write_sz);
 	buf[write_sz-1] = '\0';
 
-	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
+	fd = open(BPF_TESTMOD_TEST_FILE, O_WRONLY);
 	err = -errno;
 	if (!ASSERT_GE(fd, 0, "testmod_file_open")) {
 		free(buf);
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 94bef0aa74cf..9b8a1810b700 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -301,3 +301,5 @@ int trigger_module_test_write(int write_sz);
 #else
 #define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
 #endif
+
+#define BPF_TESTMOD_TEST_FILE "/sys/kernel/bpf_testmod"
-- 
2.20.1

