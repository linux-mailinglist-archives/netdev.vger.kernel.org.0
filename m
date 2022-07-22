Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A046C57E5E7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbiGVRt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbiGVRtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:49:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD69DEC5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e7-20020a17090a77c700b001f1f79c8b92so2508547pjs.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/2zgWSswf48FBVcdSK+ZCEzEIOisbOgEmAjPmkYvrqc=;
        b=mKV2CCfr3dADsvvKbrvY0lMmRnFpE/Cb5IR2o4TF/ePGFTP1HCbmpgW67xbbZNBkDn
         2F7Xtd3dBoWqsmRNN6m0tEeKbyoVEJ8TN2OV7kaqhvDBVo5Wv5vWJ48lpHJ6CobThflh
         O+QLg5Yyjzq9dBqD/K50UNSMdpuK+qf3cf9k136cucv6tm1mVgBQNrn5e8WZqeOJFIJH
         Xq3c/Q/ePrCuHUStkbPwTT3HHDE7G8fObf7u4Tedi8/YHe1QLq4uJ3EILivCrILHhdEH
         2jYCLLoEfhjZPFalvDGNAD4nm2B4wb5k1GjgvXc5qJFnl7RpQxddILNamdccbxGIfDxS
         XDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/2zgWSswf48FBVcdSK+ZCEzEIOisbOgEmAjPmkYvrqc=;
        b=1dcpGnRER9Dy2gkUD+t+vbqpOUpFGOAyhCoauuQTZ+juUln3cvXUhlFAW0wxqzI/ml
         GK086sr+GXU8eUk6hsan8hjNPMMeO3MG0KywGInThKF9IVMGcEyosQ4sH8uKWLqBP/4T
         AvXnR4blRkuMWpOZax3WZ5ZgORfnMgcMZENfFXzQg+ilRsz8BElrk7IwX1pIdg0Tl+VJ
         4sEeEVhALP5v78SnPC/7DdPLmjz1vgcgTHQJQwEW90yBXOGi/PNu+c++omFUMoklo6wP
         5jUI9U8nuy4lclnOzyZMgLt7prlX1YD2wfU/kTh5QHpzpsOIdSdOu3S04EBkHovWIi5C
         bQog==
X-Gm-Message-State: AJIora9cAzolYxSrIlbUXF2ifTyA+pJWoU/8LvEltQdXQ+Lp8kqkzJiB
        TNHLRKT+YMtRgHP4k7ofJQLRMB04ihscXf1X
X-Google-Smtp-Source: AGRyM1uMeVMcZiqkaA+pFNYZLL7idLnGKFm8YqqZOcxDWsXLn305aNfEHeX4s/CjENGbxlu+wl3i6GxA9vZlhYJn
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:244f:b0:528:be6f:3935 with
 SMTP id d15-20020a056a00244f00b00528be6f3935mr1124090pfj.4.1658512137190;
 Fri, 22 Jul 2022 10:48:57 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:48:26 +0000
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
Message-Id: <20220722174829.3422466-6-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v5 5/8] selftests/bpf: Test cgroup_iter.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Luo <haoluo@google.com>

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
 - early termination.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 190 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
 3 files changed, 236 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
new file mode 100644
index 000000000000..4c8f11f78491
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "cgroup_iter.skel.h"
+#include "cgroup_helpers.h"
+
+#define ROOT		0
+#define PARENT		1
+#define CHILD1		2
+#define CHILD2		3
+#define NUM_CGROUPS	4
+
+#define PROLOGUE	"prologue\n"
+#define EPILOGUE	"epilogue\n"
+
+#define format_expected_output1(cg_id1) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n" EPILOGUE, (cg_id1))
+
+#define format_expected_output2(cg_id1, cg_id2) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n%8llu\n" EPILOGUE, \
+		 (cg_id1), (cg_id2))
+
+#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
+		 (cg_id1), (cg_id2), (cg_id3))
+
+const char *cg_path[] = {
+	"/", "/parent", "/parent/child1", "/parent/child2"
+};
+
+static int cg_fd[] = {-1, -1, -1, -1};
+static unsigned long long cg_id[] = {0, 0, 0, 0};
+static char expected_output[64];
+
+int setup_cgroups(void)
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
+void cleanup_cgroups(void)
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
+	static char buf[64];
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = cgroup_fd;
+	linfo.cgroup.traversal_order = order;
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
+	while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
+		;
+
+	ASSERT_STREQ(buf, expected_output, testname);
+
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+}
+
+/* Invalid cgroup. */
+static void test_invalid_cgroup(struct cgroup_iter *skel)
+{
+
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
+	if (!ASSERT_ERR_PTR(link, "attach_iter"))
+		bpf_link__destroy(link);
+}
+
+/* Preorder walk prints parent and child in order. */
+static void test_walk_preorder(struct cgroup_iter *skel)
+{
+	format_expected_output3(cg_id[PARENT], cg_id[CHILD1], cg_id[CHILD2]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PRE, "preorder");
+}
+
+/* Postorder walk prints child and parent in order. */
+static void test_walk_postorder(struct cgroup_iter *skel)
+{
+	format_expected_output3(cg_id[CHILD1], cg_id[CHILD2], cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_POST, "postorder");
+}
+
+/* Walking parents prints parent and then root. */
+static void test_walk_parent_up(struct cgroup_iter *skel)
+{
+	/* terminate the walk when ROOT is met. */
+	skel->bss->terminal_cgroup = cg_id[ROOT];
+
+	format_expected_output2(cg_id[PARENT], cg_id[ROOT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PARENT_UP, "parent_up");
+
+	skel->bss->terminal_cgroup = 0;
+}
+
+/* Early termination prints parent only. */
+static void test_early_termination(struct cgroup_iter *skel)
+{
+	/* terminate the walk after the first element is processed. */
+	skel->bss->terminate_early = 1;
+
+	format_expected_output1(cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PRE, "early_termination");
+
+	skel->bss->terminate_early = 0;
+}
+
+void test_cgroup_iter(void)
+{
+	struct cgroup_iter *skel = NULL;
+
+	if (setup_cgroup_environment() < 0)
+		return;
+
+	if (setup_cgroups() < 0)
+		goto out;
+
+	skel = cgroup_iter__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter__open_and_load"))
+		goto out;
+
+	if (test__start_subtest("cgroup_iter__invalid_cgroup"))
+		test_invalid_cgroup(skel);
+	if (test__start_subtest("cgroup_iter__preorder"))
+		test_walk_preorder(skel);
+	if (test__start_subtest("cgroup_iter__postorder"))
+		test_walk_postorder(skel);
+	if (test__start_subtest("cgroup_iter__parent_up_walk"))
+		test_walk_parent_up(skel);
+	if (test__start_subtest("cgroup_iter__early_termination"))
+		test_early_termination(skel);
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
index 000000000000..2a34d146d6df
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
+volatile int terminate_early = 0;
+volatile u64 terminal_cgroup = 0;
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
2.37.1.359.gd136c6c3e2-goog

