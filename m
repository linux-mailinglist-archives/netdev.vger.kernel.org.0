Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030B051E740
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446505AbiEGNCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446474AbiEGNBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:01:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257B4BE1;
        Sat,  7 May 2022 05:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5A2260920;
        Sat,  7 May 2022 12:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55757C385A5;
        Sat,  7 May 2022 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651928287;
        bh=tXxPK7uOyKwoq08t3XKrG6uJTh0f242vVIV4mBZWcH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RS5BiS2d/qnb3CboifiFJvt+6y46O6Iqi2w3qGZrp1+jjxeD3kd7089Fts5ROVp0G
         mYxDrcCcA3JDgWb8+CZDm4Qg6nHD6U8MhuhGOWMcwfmwIewTqW7F/3XwEWKLHUz26V
         4MUp86U5sHLv3gdn762BXEiOFaV8bImc0fZcBXSjeNX6J6s0UvHfM2OGTDALU/zVNL
         XLKNZfqsiSc85akQxhzOZ/MYuuwq43cT2gEAwe8ZBFyUzc8ZDNJ9Tak22eto3k6FGl
         27Rhhur8dLB+cj6jKyoSt2Jigns6a8kNQBd5EdMT8z81zQwjXjc+ust07oltMvuHnK
         qeBWEvs6Z2+GQ==
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv5 bpf-next 5/5] selftests/bpf: Add attach bench test
Date:   Sat,  7 May 2022 14:57:11 +0200
Message-Id: <20220507125711.2022238-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507125711.2022238-1-jolsa@kernel.org>
References: <20220507125711.2022238-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

It also prints stats info with -v option, like on my setup:

  test_bench_attach: found 48712 functions
  test_bench_attach: attached in   1.069s
  test_bench_attach: detached in   0.373s

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 143 ++++++++++++++++++
 .../selftests/bpf/progs/kprobe_multi_empty.c  |  12 ++
 2 files changed, 155 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index c56db65d4c15..816eacededd1 100644
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
@@ -301,6 +304,144 @@ static void test_attach_api_fails(void)
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
+	f = fopen("/sys/kernel/debug/tracing/available_filter_functions", "r");
+	if (!f)
+		return -EINVAL;
+
+	map = hashmap__new(symbol_hash, symbol_equal, NULL);
+	if (IS_ERR(map))
+		goto error;
+
+	while (fgets(buf, sizeof(buf), f)) {
+		/* skip modules */
+		if (strchr(buf, '['))
+			continue;
+		if (sscanf(buf, "%ms$*[^\n]\n", &name) != 1)
+			continue;
+		/*
+		 * We attach to almost all kernel functions and some of them
+		 * will cause 'suspicious RCU usage' when fprobe is attached
+		 * to them. Filter out the current culprits - arch_cpu_idle
+		 * and rcu_* functions.
+		 */
+		if (!strcmp(name, "arch_cpu_idle"))
+			continue;
+		if (!strncmp(name, "rcu_", 4))
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
+	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	struct kprobe_multi_empty *skel = NULL;
+	long attach_start_ns, attach_end_ns;
+	long detach_start_ns, detach_end_ns;
+	double attach_delta, detach_delta;
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
+	attach_delta = (attach_end_ns - attach_start_ns) / 1000000000.0;
+	detach_delta = (detach_end_ns - detach_start_ns) / 1000000000.0;
+
+	printf("%s: found %lu functions\n", __func__, cnt);
+	printf("%s: attached in %7.3lfs\n", __func__, attach_delta);
+	printf("%s: detached in %7.3lfs\n", __func__, detach_delta);
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
@@ -320,4 +461,6 @@ void test_kprobe_multi_test(void)
 		test_attach_api_syms();
 	if (test__start_subtest("attach_api_fails"))
 		test_attach_api_fails();
+	if (test__start_subtest("bench_attach"))
+		test_bench_attach();
 }
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c b/tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
new file mode 100644
index 000000000000..e76e499aca39
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
+SEC("kprobe.multi/")
+int test_kprobe_empty(struct pt_regs *ctx)
+{
+	return 0;
+}
-- 
2.35.1

