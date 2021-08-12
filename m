Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F243E9BAA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 02:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhHLAis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhHLAir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 20:38:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF72C0613D3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 17:38:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v40-20020a25abab0000b02905938a82d807so4453348ybi.20
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 17:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xpwbWXkoxps6vS7xZs4NeOUU3E2020bu8+no3GCu58U=;
        b=cU2VRMQtp5PBEtThVNul5/DRtGAy+0nIi27lOe0tcPoN/9Ad/bsM0b/tIuBcQwmBZS
         VBAgST+QCLOlcCkDdNbPYdQsa4CKHwRoW+SRm2Ixd6HRvq2wtbXwNNAt18P64eb3a+wg
         l7TbNMNC78iZEgFlLYmG1Dg+vNPFb1onrMBwPs+r/IyUBcewweOj6I29HnkN2GHtEAth
         7bWJpz7xSQ3+s/ZDZ67TnNo9noqKHgZW5UP1Li/Uw4q2czx7bulf3gyJO5q2Qmx4y4hW
         d5Bw9o6YEuQxJuWwb0JrO4tE+nkBZu1zd40kJGRVg6QQIIer8D8gUwxOSj9GmpwSjiND
         9O2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xpwbWXkoxps6vS7xZs4NeOUU3E2020bu8+no3GCu58U=;
        b=iM7D1Mw1aLo2FuBNfhv3HUl0FYoXf9OWcO9qDVTnPoRb77DyET3Oo5B01o8QWYydLR
         kxS4s98UKJI5sbKhP9G626EZLjSDhjDU3c9dwYHt65G1jEDCVieoVBJnmCeaC56AUW45
         dO2vGDrBFcsfD0KLOaU9c+GfQaXeBxsuIiUhumPKCtAP23NbrbxpJatKxmbp8hmfT6qc
         xZoiAODgNFPjyHgqV4GMnM7m6vHpONCUmOHhAwk6ALdYXHG4eCmZEUA9c6j9nNk1797O
         cZo0Nho2MsdD7sNZOhPPPEAhMTk0288HuDi8HQjZ8Pf8ydNWfVPuGnjD5peyUNymFBuz
         Lo1A==
X-Gm-Message-State: AOAM531sRN2fJAYdq3ZOVCTTCJE9TYywdZudfYDzjM2E4X+K/CBX2fho
        uyO9l/DD8Kz70iwbxfcc3HT5JCohl0O/5iPywayAYsJ9oFxq41RAOpIz5USId2MtfapEI8wUMxY
        4F+jNRO2UofA6RclImehofHoQILzmayV2GMuNZSj+Mla8HXslGN4HJ734q0zg5Q==
X-Google-Smtp-Source: ABdhPJxjutJjHQVe5c22v8ivjJugR13Z3HLl3/RMzQ/QEb7ZE1sQ2GXl1QmeoheN9NCKKsLBBx9uNS9bQuo=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:d426:eb6d:7242:119b])
 (user=haoluo job=sendgmr) by 2002:a25:842:: with SMTP id 63mr937153ybi.518.1628728702452;
 Wed, 11 Aug 2021 17:38:22 -0700 (PDT)
Date:   Wed, 11 Aug 2021 17:38:19 -0700
Message-Id: <20210812003819.2439037-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH bpf-next v3] libbpf: support weak typed ksyms.
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently weak typeless ksyms have default value zero, when they don't
exist in the kernel. However, weak typed ksyms are rejected by libbpf
if they can not be resolved. This means that if a bpf object contains
the declaration of a nonexistent weak typed ksym, it will be rejected
even if there is no program that references the symbol.

Nonexistent weak typed ksyms can also default to zero just like
typeless ones. This allows programs that access weak typed ksyms to be
accepted by verifier, if the accesses are guarded. For example,

extern const int bpf_link_fops3 __ksym __weak;

/* then in BPF program */

if (&bpf_link_fops3) {
   /* use bpf_link_fops3 */
}

If actual use of nonexistent typed ksym is not guarded properly,
verifier would see that register is not PTR_TO_BTF_ID and wouldn't
allow to use it for direct memory reads or passing it to BPF helpers.

Signed-off-by: Hao Luo <haoluo@google.com>
---
Changes since v2:
 - Move special handling and warning from find_ksym_btf_id() to
   bpf_object__resolve_ksym_var_btf_id().
 - Removed bpf_link_fops3 from tests since it's not used.
 - Separated variable declaration and statements.

Changes since v1:
 - Weak typed symbols default to zero, as suggested by Andrii.
 - Use ASSERT_XXX() for tests.

 tools/lib/bpf/libbpf.c                        | 16 +++---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 31 ++++++++++
 .../selftests/bpf/progs/test_ksyms_weak.c     | 56 +++++++++++++++++++
 3 files changed, 96 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cb106e8c42cb..ff3c0ee79d85 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5277,11 +5277,11 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 				}
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
-				if (ext->ksym.type_id) { /* typed ksyms */
+				if (ext->ksym.type_id && ext->is_set) { /* typed ksyms */
 					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
 					insn[0].imm = ext->ksym.kernel_btf_id;
 					insn[1].imm = ext->ksym.kernel_btf_obj_fd;
-				} else { /* typeless ksyms */
+				} else { /* typeless ksyms or unresolved typed ksyms */
 					insn[0].imm = (__u32)ext->ksym.addr;
 					insn[1].imm = ext->ksym.addr >> 32;
 				}
@@ -6608,11 +6608,8 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 				break;
 		}
 	}
-	if (id <= 0) {
-		pr_warn("extern (%s ksym) '%s': failed to find BTF ID in kernel BTF(s).\n",
-			__btf_kind_str(kind), ksym_name);
+	if (id <= 0)
 		return -ESRCH;
-	}
 
 	*res_btf = btf;
 	*res_btf_fd = btf_fd;
@@ -6629,8 +6626,13 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	struct btf *btf = NULL;
 
 	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
-	if (id < 0)
+	if (id == -ESRCH && ext->is_weak) {
+		return 0;
+	} else if (id < 0) {
+		pr_warn("extern (var ksym) '%s': not found in kernel BTF\n",
+			ext->name);
 		return id;
+	}
 
 	/* find local type_id */
 	local_type_id = ext->ksym.type_id;
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index 67bebd324147..cf3acfa5a91d 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -6,6 +6,7 @@
 #include <bpf/btf.h>
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
+#include "test_ksyms_weak.skel.h"
 
 static int duration;
 
@@ -81,6 +82,33 @@ static void test_null_check(void)
 	test_ksyms_btf_null_check__destroy(skel);
 }
 
+static void test_weak_syms(void)
+{
+	struct test_ksyms_weak *skel;
+	struct test_ksyms_weak__data *data;
+	int err;
+
+	skel = test_ksyms_weak__open_and_load();
+	if (CHECK(!skel, "test_ksyms_weak__open_and_load", "failed\n"))
+		return;
+
+	err = test_ksyms_weak__attach(skel);
+	if (CHECK(err, "test_ksyms_weak__attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	ASSERT_EQ(data->out__existing_typed, 0, "existing typed ksym");
+	ASSERT_NEQ(data->out__existing_typeless, -1, "existing typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typeless, 0, "nonexistent typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typed, 0, "nonexistent typed ksym");
+
+cleanup:
+	test_ksyms_weak__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -105,4 +133,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("null_check"))
 		test_null_check();
+
+	if (test__start_subtest("weak_ksyms"))
+		test_weak_syms();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
new file mode 100644
index 000000000000..5f8379aadb29
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test weak ksyms.
+ *
+ * Copyright (c) 2021 Google
+ */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+int out__existing_typed = -1;
+__u64 out__existing_typeless = -1;
+
+__u64 out__non_existent_typeless = -1;
+__u64 out__non_existent_typed = -1;
+
+/* existing weak symbols */
+
+/* test existing weak symbols can be resolved. */
+extern const struct rq runqueues __ksym __weak; /* typed */
+extern const void bpf_prog_active __ksym __weak; /* typeless */
+
+
+/* non-existent weak symbols. */
+
+/* typeless symbols, default to zero. */
+extern const void bpf_link_fops1 __ksym __weak;
+
+/* typed symbols, default to zero. */
+extern const int bpf_link_fops2 __ksym __weak;
+
+SEC("raw_tp/sys_enter")
+int pass_handler(const void *ctx)
+{
+	struct rq *rq;
+
+	/* tests existing symbols. */
+	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
+	if (rq)
+		out__existing_typed = rq->cpu;
+	out__existing_typeless = (__u64)&bpf_prog_active;
+
+	/* tests non-existent symbols. */
+	out__non_existent_typeless = (__u64)&bpf_link_fops1;
+
+	/* tests non-existent symbols. */
+	out__non_existent_typed = (__u64)&bpf_link_fops2;
+
+	if (&bpf_link_fops2) /* can't happen */
+		out__non_existent_typed = (__u64)bpf_per_cpu_ptr(&bpf_link_fops2, 0);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.32.0.605.g8dce9f2422-goog

