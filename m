Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B158B155
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbiHEVtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbiHEVtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:49:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C8F7B7BE
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 14:49:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y13-20020a5b09cd000000b0067114eb5b50so3043714ybq.17
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 14:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=dW0ve3RUvl44+rGQsS2/0XtznS0SegZN0HeyfaKymhE=;
        b=FcM0K74GRCShcr+t25k4c6LpPObXcalMOseAQUOPUmOz8OlCvrqvzMCK6Y9vAnZCnR
         UWm6akwdnzmxv4tKEYumVs4qhmOdm7CvK8Mq1AxbQUjSyn6MLXhGcVyfB3u5fj98/SoH
         j1GyJedYdFi+hi94L8+l+N3KMKuc6xzEc/hgj4DMiBsGrWCFdNYxSUciMpoY5hPX7GgC
         /vBy25ST6Dmy8u+Vu1qHgOPy1ZrdlTvTZ0D+kpjQ6z0pbHlSfF47Ci1M1UoSnFfYg04D
         b0FqIg2n9BK3ii/5Rzg8vyN9hwg6FD/rGR33N3ciXCIGe3RC3DLbjrR8hypKMcIj8sBI
         GgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=dW0ve3RUvl44+rGQsS2/0XtznS0SegZN0HeyfaKymhE=;
        b=itQvxF7kk3N0FzfE5YfKhkV+74KX0tgUeYpvh4K6RH0Lk0ae+4uYwp/WOScu0MI4v5
         90eJuSZckLk9rWaR1KpVoMEFv7HlrbYsyrq6G5QvUekapiZwUJ2ZfpBXVQbWaOANl3M0
         Uit8u3QEFAwqKU8wTUrpdz7Ufw11/GZnsKZ97vzz10d+dcpVAki2iFqcAY75n8K/hkAP
         RWFRhELLEAofC6AoEZ/fn76ANiVViG0IVXiwOMWAq+zpUaUbaln+0YDUyB+Z9UbX0fPw
         OoT1owg1sLmYHqkQ/0gCgDWf+Qp5JWPEOURMedIiT9Ck9Ann2bEAk+VtFjlGK30URjJD
         BCGg==
X-Gm-Message-State: ACgBeo0bWkJqG4lSFvZ7oVmc/HrtXdziprHdKBrXK8nGHQEQCXzecn2G
        PpBywriAz2fhsebSUnSQ9wyMEyMDotk=
X-Google-Smtp-Source: AA6agR6nqiUN1zJwKWDLlC3MaFMaq7bJS40bsbIdwFRa46fTPWzn4D4FD/O9FlJ5WaEOnI7mPX2xy4JHCc4=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:4f27:97db:8644:dc82])
 (user=haoluo job=sendgmr) by 2002:a25:ba45:0:b0:67a:6298:7bac with SMTP id
 z5-20020a25ba45000000b0067a62987bacmr7766888ybj.194.1659736144843; Fri, 05
 Aug 2022 14:49:04 -0700 (PDT)
Date:   Fri,  5 Aug 2022 14:48:18 -0700
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
Message-Id: <20220805214821.1058337-6-haoluo@google.com>
Mime-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH bpf-next v7 5/8] selftests/bpf: Test cgroup_iter.
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
of the following structure:

    ROOT (working cgroup)
     |
   PARENT
  /      \
CHILD1  CHILD2

and tests the following scenarios:

 - invalid cgroup fd.
 - pre-order walk over descendants from PARENT.
 - post-order walk over descendants from PARENT.
 - walk of ancestors from PARENT.
 - walk from PARENT in the default order, which is pre-order.
 - process only a single object (i.e. PARENT).
 - early termination.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 237 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 +++
 3 files changed, 283 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
new file mode 100644
index 000000000000..f9ab31a63c69
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "cgroup_iter.skel.h"
+#include "cgroup_helpers.h"
+
+#define ROOT           0
+#define PARENT         1
+#define CHILD1         2
+#define CHILD2         3
+#define NUM_CGROUPS    4
+
+#define PROLOGUE       "prologue\n"
+#define EPILOGUE       "epilogue\n"
+
+static const char *cg_path[] = {
+	"/", "/parent", "/parent/child1", "/parent/child2"
+};
+
+static int cg_fd[] = {-1, -1, -1, -1};
+static unsigned long long cg_id[] = {0, 0, 0, 0};
+static char expected_output[64];
+
+static int setup_cgroups(void)
+{
+	int fd, i = 0;
+
+	for (i = 0; i < NUM_CGROUPS; i++) {
+		fd = create_and_get_cgroup(cg_path[i]);
+		if (fd < 0)
+			return fd;
+
+		cg_fd[i] = fd;
+		cg_id[i] = get_cgroup_id(cg_path[i]);
+	}
+	return 0;
+}
+
+static void cleanup_cgroups(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_CGROUPS; i++)
+		close(cg_fd[i]);
+}
+
+static void read_from_cgroup_iter(struct bpf_program *prog, int cgroup_fd,
+				  int order, const char *testname)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+	int len, iter_fd;
+	static char buf[128];
+	size_t left;
+	char *p;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = cgroup_fd;
+	linfo.cgroup.order = order;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(prog, &opts);
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
+		return;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (iter_fd < 0)
+		goto free_link;
+
+	memset(buf, 0, sizeof(buf));
+	left = ARRAY_SIZE(buf);
+	p = buf;
+	while ((len = read(iter_fd, p, left)) > 0) {
+		p += len;
+		left -= len;
+	}
+
+	ASSERT_STREQ(buf, expected_output, testname);
+
+	/* read() after iter finishes should be ok. */
+	if (len == 0)
+		ASSERT_OK(read(iter_fd, buf, sizeof(buf)), "second_read");
+
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+}
+
+/* Invalid cgroup. */
+static void test_invalid_cgroup(struct cgroup_iter *skel)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = (__u32)-1;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
+	ASSERT_ERR_PTR(link, "attach_iter");
+	bpf_link__destroy(link);
+}
+
+/* Specifying both cgroup_fd and cgroup_id is invalid. */
+static void test_invalid_cgroup_spec(struct cgroup_iter *skel)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = (__u32)cg_fd[PARENT];
+	linfo.cgroup.cgroup_id = (__u64)cg_id[PARENT];
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
+	ASSERT_ERR_PTR(link, "attach_iter");
+	bpf_link__destroy(link);
+}
+
+/* Preorder walk prints parent and child in order. */
+static void test_walk_preorder(struct cgroup_iter *skel)
+{
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE,
+		 cg_id[PARENT], cg_id[CHILD1], cg_id[CHILD2]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_DESCENDANTS_PRE, "preorder");
+}
+
+/* Postorder walk prints child and parent in order. */
+static void test_walk_postorder(struct cgroup_iter *skel)
+{
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE,
+		 cg_id[CHILD1], cg_id[CHILD2], cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_DESCENDANTS_POST, "postorder");
+}
+
+/* Walking parents prints parent and then root. */
+static void test_walk_ancestors_up(struct cgroup_iter *skel)
+{
+	/* terminate the walk when ROOT is met. */
+	skel->bss->terminal_cgroup = cg_id[ROOT];
+
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n%8llu\n" EPILOGUE,
+		 cg_id[PARENT], cg_id[ROOT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_ANCESTORS_UP, "ancestors_up");
+
+	skel->bss->terminal_cgroup = 0;
+}
+
+/* Default order is pre-order. */
+static void test_walk_default_order(struct cgroup_iter *skel)
+{
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE,
+		 cg_id[PARENT], cg_id[CHILD1], cg_id[CHILD2]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_ORDER_DEFAULT, "default_order");
+}
+
+/* Early termination prints parent only. */
+static void test_early_termination(struct cgroup_iter *skel)
+{
+	/* terminate the walk after the first element is processed. */
+	skel->bss->terminate_early = 1;
+
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n" EPILOGUE, cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_DESCENDANTS_PRE, "early_termination");
+
+	skel->bss->terminate_early = 0;
+}
+
+/* Waling self prints self only. */
+static void test_walk_self(struct cgroup_iter *skel)
+{
+	snprintf(expected_output, sizeof(expected_output),
+		 PROLOGUE "%8llu\n" EPILOGUE, cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_SELF, "self");
+}
+
+void test_cgroup_iter(void)
+{
+	struct cgroup_iter *skel = NULL;
+
+	if (setup_cgroup_environment())
+		return;
+
+	if (setup_cgroups())
+		goto out;
+
+	skel = cgroup_iter__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter__open_and_load"))
+		goto out;
+
+	if (test__start_subtest("cgroup_iter__invalid_cgroup"))
+		test_invalid_cgroup(skel);
+	if (test__start_subtest("cgroup_iter__invalid_cgroup_spec"))
+		test_invalid_cgroup_spec(skel);
+	if (test__start_subtest("cgroup_iter__preorder"))
+		test_walk_preorder(skel);
+	if (test__start_subtest("cgroup_iter__postorder"))
+		test_walk_postorder(skel);
+	if (test__start_subtest("cgroup_iter__ancestors_up_walk"))
+		test_walk_ancestors_up(skel);
+	if (test__start_subtest("cgroup_iter__default_order"))
+		test_walk_default_order(skel);
+	if (test__start_subtest("cgroup_iter__early_termination"))
+		test_early_termination(skel);
+	if (test__start_subtest("cgroup_iter__self"))
+		test_walk_self(skel);
+out:
+	cgroup_iter__destroy(skel);
+	cleanup_cgroups();
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index e9846606690d..c41ee80533ca 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -17,6 +17,7 @@
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
 #define bpf_iter__bpf_link bpf_iter__bpf_link___not_used
+#define bpf_iter__cgroup bpf_iter__cgroup___not_used
 #define btf_ptr btf_ptr___not_used
 #define BTF_F_COMPACT BTF_F_COMPACT___not_used
 #define BTF_F_NONAME BTF_F_NONAME___not_used
@@ -40,6 +41,7 @@
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
 #undef bpf_iter__bpf_link
+#undef bpf_iter__cgroup
 #undef btf_ptr
 #undef BTF_F_COMPACT
 #undef BTF_F_NONAME
@@ -141,6 +143,11 @@ struct bpf_iter__bpf_link {
 	struct bpf_link *link;
 };
 
+struct bpf_iter__cgroup {
+	struct bpf_iter_meta *meta;
+	struct cgroup *cgroup;
+} __attribute__((preserve_access_index));
+
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter.c b/tools/testing/selftests/bpf/progs/cgroup_iter.c
new file mode 100644
index 000000000000..de03997322a7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
+
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+int terminate_early = 0;
+u64 terminal_cgroup = 0;
+
+static inline u64 cgroup_id(struct cgroup *cgrp)
+{
+	return cgrp->kn->id;
+}
+
+SEC("iter/cgroup")
+int cgroup_id_printer(struct bpf_iter__cgroup *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct cgroup *cgrp = ctx->cgroup;
+
+	/* epilogue */
+	if (cgrp == NULL) {
+		BPF_SEQ_PRINTF(seq, "epilogue\n");
+		return 0;
+	}
+
+	/* prologue */
+	if (ctx->meta->seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "prologue\n");
+
+	BPF_SEQ_PRINTF(seq, "%8llu\n", cgroup_id(cgrp));
+
+	if (terminal_cgroup == cgroup_id(cgrp))
+		return 1;
+
+	return terminate_early ? 1 : 0;
+}
-- 
2.37.1.559.g78731f0fdb-goog

