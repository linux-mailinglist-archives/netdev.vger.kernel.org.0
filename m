Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F54F7F95
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbiDGMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245514AbiDGMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:55:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009F522E967;
        Thu,  7 Apr 2022 05:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB593B82762;
        Thu,  7 Apr 2022 12:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E3CC385A0;
        Thu,  7 Apr 2022 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649336005;
        bh=DgEukseVqJ2f66I22KOLZIJNNrhxug0fQ7mB3fF8Bhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNx4WUn0yOuXJWvXAlHrVhERbyaCCUJVRzMyjJrVMFaAvsTYEUO6k2Z4dKrAOH6EL
         llymqSRk3jkHxTiezrcJroBpp+0GC0B6xZQgtOfohnYyGa9WwHZo57Vm4RjvQ5Up7b
         cIBxx2uZIUwIjPfE5pgQz9is/EIlkWJqyUle++IYTjqkTNvO2L5KsI1Yk2tV9PTv/D
         FuYw5oD3OkVokbnTO1UNt0E20o7syDRf8LWrLYkJFXhoE+yJq2KoRDkgluOpLsMNTS
         pXFAXF8s5pIDt6xyn+ow5hRUOJTkLC8KpUoCOkEKdgJB7+fTRpgd5VHwtd5uY4h0/B
         Y+t/ZKYJhxMFg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Date:   Thu,  7 Apr 2022 14:52:24 +0200
Message-Id: <20220407125224.310255-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407125224.310255-1-jolsa@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test that reads all functions from ftrace available_filter_functions
file and attach them all through kprobe_multi API.

It checks that the attach and detach times is under 2 seconds
and printf stats info with -v option, like on my setup:

  test_bench_attach: found 48712 functions
  test_bench_attach: attached in   1.069s
  test_bench_attach: detached in   0.373s

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 141 ++++++++++++++++++
 .../selftests/bpf/progs/kprobe_multi_empty.c  |  12 ++
 2 files changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index b9876b55fc0c..6798b54416de 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -2,6 +2,9 @@
 #include <test_progs.h>
 #include "kprobe_multi.skel.h"
 #include "trace_helpers.h"
+#include "kprobe_multi_empty.skel.h"
+#include "bpf/libbpf_internal.h"
+#include "bpf/hashmap.h"
 
 static void kprobe_multi_test_run(struct kprobe_multi *skel, bool test_return)
 {
@@ -301,6 +304,142 @@ static void test_attach_api_fails(void)
 	kprobe_multi__destroy(skel);
 }
 
+static inline __u64 get_time_ns(void)
+{
+	struct timespec t;
+
+	clock_gettime(CLOCK_MONOTONIC, &t);
+	return (__u64) t.tv_sec * 1000000000 + t.tv_nsec;
+}
+
+static size_t symbol_hash(const void *key, void *ctx __maybe_unused)
+{
+	return str_hash((const char *) key);
+}
+
+static bool symbol_equal(const void *key1, const void *key2, void *ctx __maybe_unused)
+{
+	return strcmp((const char *) key1, (const char *) key2) == 0;
+}
+
+#define DEBUGFS "/sys/kernel/debug/tracing/"
+
+static int get_syms(char ***symsp, size_t *cntp)
+{
+	size_t cap = 0, cnt = 0, i;
+	char *name, **syms = NULL;
+	struct hashmap *map;
+	char buf[256];
+	FILE *f;
+	int err;
+
+	/*
+	 * The available_filter_functions contains many duplicates,
+	 * but other than that all symbols are usable in kprobe multi
+	 * interface.
+	 * Filtering out duplicates by using hashmap__add, which won't
+	 * add existing entry.
+	 */
+	f = fopen(DEBUGFS "available_filter_functions", "r");
+	if (!f)
+		return -EINVAL;
+
+	map = hashmap__new(symbol_hash, symbol_equal, NULL);
+	err = libbpf_get_error(map);
+	if (err)
+		goto error;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		/* skip modules */
+		if (strchr(buf, '['))
+			continue;
+		if (sscanf(buf, "%ms$*[^\n]\n", &name) != 1)
+			continue;
+		err = hashmap__add(map, name, NULL);
+		if (err) {
+			free(name);
+			if (err == -EEXIST)
+				continue;
+			goto error;
+		}
+		err = libbpf_ensure_mem((void **) &syms, &cap,
+					sizeof(*syms), cnt + 1);
+		if (err) {
+			free(name);
+			goto error;
+		}
+		syms[cnt] = name;
+		cnt++;
+	}
+
+	*symsp = syms;
+	*cntp = cnt;
+
+error:
+	fclose(f);
+	hashmap__free(map);
+	if (err) {
+		for (i = 0; i < cnt; i++)
+			free(syms[cnt]);
+		free(syms);
+	}
+	return err;
+}
+
+static void test_bench_attach(void)
+{
+	double attach_delta_ns, detach_delta_ns;
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	struct kprobe_multi_empty *skel = NULL;
+	long attach_start_ns, attach_end_ns;
+	long detach_start_ns, detach_end_ns;
+	struct bpf_link *link = NULL;
+	char **syms = NULL;
+	size_t cnt, i;
+
+	if (!ASSERT_OK(get_syms(&syms, &cnt), "get_syms"))
+		return;
+
+	skel = kprobe_multi_empty__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "kprobe_multi_empty__open_and_load"))
+		goto cleanup;
+
+	opts.syms = (const char **) syms;
+	opts.cnt = cnt;
+
+	attach_start_ns = get_time_ns();
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.test_kprobe_empty,
+						     NULL, &opts);
+	attach_end_ns = get_time_ns();
+
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_kprobe_multi_opts"))
+		goto cleanup;
+
+	detach_start_ns = get_time_ns();
+	bpf_link__destroy(link);
+	detach_end_ns = get_time_ns();
+
+	attach_delta_ns = (attach_end_ns - attach_start_ns) / 1000000000.0;
+	detach_delta_ns = (detach_end_ns - detach_start_ns) / 1000000000.0;
+
+	fprintf(stderr, "%s: found %lu functions\n", __func__, cnt);
+	fprintf(stderr, "%s: attached in %7.3lfs\n", __func__, attach_delta_ns);
+	fprintf(stderr, "%s: detached in %7.3lfs\n", __func__, detach_delta_ns);
+
+	if (attach_delta_ns > 2.0)
+		PRINT_FAIL("attach time above 2 seconds\n");
+	if (detach_delta_ns > 2.0)
+		PRINT_FAIL("detach time above 2 seconds\n");
+
+cleanup:
+	kprobe_multi_empty__destroy(skel);
+	if (syms) {
+		for (i = 0; i < cnt; i++)
+			free(syms[i]);
+		free(syms);
+	}
+}
+
 void test_kprobe_multi_test(void)
 {
 	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
@@ -320,4 +459,6 @@ void test_kprobe_multi_test(void)
 		test_attach_api_syms();
 	if (test__start_subtest("attach_api_fails"))
 		test_attach_api_fails();
+	if (test__start_subtest("bench_attach"))
+		test_bench_attach();
 }
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
new file mode 100644
index 000000000000..be9e3d891d46
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("kprobe.multi/*")
+int test_kprobe_empty(struct pt_regs *ctx)
+{
+	return 0;
+}
-- 
2.35.1

