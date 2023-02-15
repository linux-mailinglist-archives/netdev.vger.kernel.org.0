Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFFD6976D4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjBOG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbjBOG7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:59:24 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A275436467;
        Tue, 14 Feb 2023 22:58:29 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e17so10520362plg.12;
        Tue, 14 Feb 2023 22:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8I10jbDH4ZyflBE0D8tfGS/blxYbJnK9A5cKtOXY1U=;
        b=IaM20xC4s7jFhGCY90FbZH5YE8eeIlykeO45fkCLttdPcbZdZHOUhBonXYXfszRsqV
         BbO5PWbI7Vyqysh8yF2DsN0AmtKKGUMFmFmIlmzmUWxHYawOkt4yQ1LYUP0C1NKiDftv
         ME2TrKWtWNKhz5hrRjtriJiB0K68m/uUqc63SKehcNNJFe7J0f84FHa5rG2KCUwdv+Rm
         D001jOx/pwrDGOzzKInxkAGZLxFJp+pQOAgzRQEc2xj6PsMSJQSX617wbXyCTIPteT/w
         B1VQINBLwBA9pbVM7Y6lsy2VgU7X7wTiY5sEC2dvlGwwq4MmmucTGg1foeRIbaDnmNq1
         8Pew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8I10jbDH4ZyflBE0D8tfGS/blxYbJnK9A5cKtOXY1U=;
        b=FX+Jgis3KwGJ94enhP8ej3LqVPi8L8vihm+0SRz8yj9RAKdIEIe0HUd+REOUT26rKO
         fxj9DZhiEdUKD7pVgqUD9h4JtMpJpFs1OpxDJv1G08WUQpGoVV9/vWiS8jfJUOA/bhnZ
         lq2Lsrt/hcFzAxuHSgONdk0jt0YwJFPrzC6kfIisilJVOmhbl3K2LKvvfDZeAvVTthOo
         +mfLOR6Mk3ZDM5cLxzgpUINdWo18gfJZx5ZbjEKIomZ75MTWFbVaeyUXxzfr6B9DchFZ
         /IQkeYveKT5y1P37UjT21YVcnLc8h6Dmmh0fHaadIAn4pDX7bTJWhSu2ehNKpuyNgYht
         629A==
X-Gm-Message-State: AO0yUKV6BETgBWlr4X03LretWllmrX/WgUo9277kjAwwvRh2nK+YTF/O
        i6UuLOQ0CXg6Lsbm50HgaNo=
X-Google-Smtp-Source: AK7set81rn2s+98Af2nEmcjpNdcC6WIUhc33cP4/kfsINlhGZamNXmPSbQ/bS1We/L4EdSQXE8fL7w==
X-Received: by 2002:a17:903:785:b0:19a:a815:286b with SMTP id kn5-20020a170903078500b0019aa815286bmr1182723plb.15.1676444300205;
        Tue, 14 Feb 2023 22:58:20 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:d0de])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709027e4b00b00189b2b8dbedsm11217940pln.228.2023.02.14.22.58.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Feb 2023 22:58:19 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/4] bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
Date:   Tue, 14 Feb 2023 22:58:09 -0800
Message-Id: <20230215065812.7551-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

__kptr meant to store PTR_UNTRUSTED kernel pointers inside bpf maps.
The concept felt useful, but didn't get much traction,
since bpf_rdonly_cast() was added soon after and bpf programs received
a simpler way to access PTR_UNTRUSTED kernel pointers
without going through restrictive __kptr usage.

Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted to indicate
its intended usage.
The main goal of __kptr_untrusted was to read/write such pointers
directly while bpf_kptr_xchg was a mechanism to access refcnted
kernel pointers. The next patch will allow RCU protected __kptr access
with direct read. At that point __kptr_untrusted will be deprecated.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst           |  4 ++--
 Documentation/bpf/cpumasks.rst                |  4 ++--
 Documentation/bpf/kfuncs.rst                  |  2 +-
 kernel/bpf/btf.c                              |  4 ++--
 tools/lib/bpf/bpf_helpers.h                   |  2 +-
 tools/testing/selftests/bpf/progs/cb_refs.c   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |  2 +-
 .../selftests/bpf/progs/cpumask_common.h      |  2 +-
 .../selftests/bpf/progs/jit_probe_mem.c       |  2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c   |  2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  |  4 ++--
 .../selftests/bpf/progs/map_kptr_fail.c       |  6 ++---
 .../selftests/bpf/progs/task_kfunc_common.h   |  2 +-
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++++++----------
 14 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index bfff0e7e37c2..38372a956d65 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -314,7 +314,7 @@ Q: What is the compatibility story for special BPF types in map values?
 Q: Users are allowed to embed bpf_spin_lock, bpf_timer fields in their BPF map
 values (when using BTF support for BPF maps). This allows to use helpers for
 such objects on these fields inside map values. Users are also allowed to embed
-pointers to some kernel types (with __kptr and __kptr_ref BTF tags). Will the
+pointers to some kernel types (with __kptr_untrusted and __kptr BTF tags). Will the
 kernel preserve backwards compatibility for these features?
 
 A: It depends. For bpf_spin_lock, bpf_timer: YES, for kptr and everything else:
@@ -324,7 +324,7 @@ For struct types that have been added already, like bpf_spin_lock and bpf_timer,
 the kernel will preserve backwards compatibility, as they are part of UAPI.
 
 For kptrs, they are also part of UAPI, but only with respect to the kptr
-mechanism. The types that you can use with a __kptr and __kptr_ref tagged
+mechanism. The types that you can use with a __kptr_untrusted and __kptr tagged
 pointer in your struct are NOT part of the UAPI contract. The supported types can
 and will change across kernel releases. However, operations like accessing kptr
 fields and bpf_kptr_xchg() helper will continue to be supported across kernel
diff --git a/Documentation/bpf/cpumasks.rst b/Documentation/bpf/cpumasks.rst
index 24bef9cbbeee..75344cd230e5 100644
--- a/Documentation/bpf/cpumasks.rst
+++ b/Documentation/bpf/cpumasks.rst
@@ -51,7 +51,7 @@ A ``struct bpf_cpumask *`` is allocated, acquired, and released, using the
 .. code-block:: c
 
         struct cpumask_map_value {
-                struct bpf_cpumask __kptr_ref * cpumask;
+                struct bpf_cpumask __kptr * cpumask;
         };
 
         struct array_map {
@@ -128,7 +128,7 @@ a map, the reference can be removed from the map with bpf_kptr_xchg(), or
 
 	/* struct containing the struct bpf_cpumask kptr which is stored in the map. */
 	struct cpumasks_kfunc_map_value {
-		struct bpf_cpumask __kptr_ref * bpf_cpumask;
+		struct bpf_cpumask __kptr * bpf_cpumask;
 	};
 
 	/* The map containing struct cpumasks_kfunc_map_value entries. */
diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index ca96ef3f6896..d085594eae19 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -527,7 +527,7 @@ You may also acquire a reference to a ``struct cgroup`` kptr that's already
 
 	/* struct containing the struct task_struct kptr which is actually stored in the map. */
 	struct __cgroups_kfunc_map_value {
-		struct cgroup __kptr_ref * cgroup;
+		struct cgroup __kptr * cgroup;
 	};
 
 	/* The map containing struct __cgroups_kfunc_map_value entries. */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6582735ef1fc..1bba71c6176a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3283,9 +3283,9 @@ static int btf_find_kptr(const struct btf *btf, const struct btf_type *t,
 	/* Reject extra tags */
 	if (btf_type_is_type_tag(btf_type_by_id(btf, t->type)))
 		return -EINVAL;
-	if (!strcmp("kptr", __btf_name_by_offset(btf, t->name_off)))
+	if (!strcmp("kptr_untrusted", __btf_name_by_offset(btf, t->name_off)))
 		type = BPF_KPTR_UNREF;
-	else if (!strcmp("kptr_ref", __btf_name_by_offset(btf, t->name_off)))
+	else if (!strcmp("kptr", __btf_name_by_offset(btf, t->name_off)))
 		type = BPF_KPTR_REF;
 	else
 		return -EINVAL;
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 5ec1871acb2f..7d12d3e620cc 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -174,8 +174,8 @@ enum libbpf_tristate {
 
 #define __kconfig __attribute__((section(".kconfig")))
 #define __ksym __attribute__((section(".ksyms")))
+#define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
 #define __kptr __attribute__((btf_type_tag("kptr")))
-#define __kptr_ref __attribute__((btf_type_tag("kptr_ref")))
 
 #ifndef ___bpf_concat
 #define ___bpf_concat(a, b) a ## b
diff --git a/tools/testing/selftests/bpf/progs/cb_refs.c b/tools/testing/selftests/bpf/progs/cb_refs.c
index 7653df1bc787..ce96b33e38d6 100644
--- a/tools/testing/selftests/bpf/progs/cb_refs.c
+++ b/tools/testing/selftests/bpf/progs/cb_refs.c
@@ -4,7 +4,7 @@
 #include <bpf/bpf_helpers.h>
 
 struct map_value {
-	struct prog_test_ref_kfunc __kptr_ref *ptr;
+	struct prog_test_ref_kfunc __kptr *ptr;
 };
 
 struct {
diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
index 7d30855bfe78..50d8660ffa26 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
@@ -10,7 +10,7 @@
 #include <bpf/bpf_tracing.h>
 
 struct __cgrps_kfunc_map_value {
-	struct cgroup __kptr_ref * cgrp;
+	struct cgroup __kptr * cgrp;
 };
 
 struct hash_map {
diff --git a/tools/testing/selftests/bpf/progs/cpumask_common.h b/tools/testing/selftests/bpf/progs/cpumask_common.h
index ad34f3b602be..65e5496ca1b2 100644
--- a/tools/testing/selftests/bpf/progs/cpumask_common.h
+++ b/tools/testing/selftests/bpf/progs/cpumask_common.h
@@ -10,7 +10,7 @@
 int err;
 
 struct __cpumask_map_value {
-	struct bpf_cpumask __kptr_ref * cpumask;
+	struct bpf_cpumask __kptr * cpumask;
 };
 
 struct array_map {
diff --git a/tools/testing/selftests/bpf/progs/jit_probe_mem.c b/tools/testing/selftests/bpf/progs/jit_probe_mem.c
index 2d2e61470794..13f00ca2ed0a 100644
--- a/tools/testing/selftests/bpf/progs/jit_probe_mem.c
+++ b/tools/testing/selftests/bpf/progs/jit_probe_mem.c
@@ -4,7 +4,7 @@
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_helpers.h>
 
-static struct prog_test_ref_kfunc __kptr_ref *v;
+static struct prog_test_ref_kfunc __kptr *v;
 long total_sum = -1;
 
 extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
diff --git a/tools/testing/selftests/bpf/progs/lru_bug.c b/tools/testing/selftests/bpf/progs/lru_bug.c
index 687081a724b3..ad73029cb1e3 100644
--- a/tools/testing/selftests/bpf/progs/lru_bug.c
+++ b/tools/testing/selftests/bpf/progs/lru_bug.c
@@ -4,7 +4,7 @@
 #include <bpf/bpf_helpers.h>
 
 struct map_value {
-	struct task_struct __kptr *ptr;
+	struct task_struct __kptr_untrusted *ptr;
 };
 
 struct {
diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 228ec45365a8..4a7da6cb5800 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -4,8 +4,8 @@
 #include <bpf/bpf_helpers.h>
 
 struct map_value {
-	struct prog_test_ref_kfunc __kptr *unref_ptr;
-	struct prog_test_ref_kfunc __kptr_ref *ref_ptr;
+	struct prog_test_ref_kfunc __kptr_untrusted *unref_ptr;
+	struct prog_test_ref_kfunc __kptr *ref_ptr;
 };
 
 struct array_map {
diff --git a/tools/testing/selftests/bpf/progs/map_kptr_fail.c b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
index 760e41e1a632..e19e2a5f38cf 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
@@ -7,9 +7,9 @@
 
 struct map_value {
 	char buf[8];
-	struct prog_test_ref_kfunc __kptr *unref_ptr;
-	struct prog_test_ref_kfunc __kptr_ref *ref_ptr;
-	struct prog_test_member __kptr_ref *ref_memb_ptr;
+	struct prog_test_ref_kfunc __kptr_untrusted *unref_ptr;
+	struct prog_test_ref_kfunc __kptr *ref_ptr;
+	struct prog_test_member __kptr *ref_memb_ptr;
 };
 
 struct array_map {
diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_common.h b/tools/testing/selftests/bpf/progs/task_kfunc_common.h
index c0ffd171743e..4c2a4b0e3a25 100644
--- a/tools/testing/selftests/bpf/progs/task_kfunc_common.h
+++ b/tools/testing/selftests/bpf/progs/task_kfunc_common.h
@@ -10,7 +10,7 @@
 #include <bpf/bpf_tracing.h>
 
 struct __tasks_kfunc_map_value {
-	struct task_struct __kptr_ref * task;
+	struct task_struct __kptr * task;
 };
 
 struct hash_map {
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 887c49dc5abd..fc29e2d1f992 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -699,13 +699,13 @@ static int create_cgroup_storage(bool percpu)
  *   struct bpf_timer t;
  * };
  * struct btf_ptr {
+ *   struct prog_test_ref_kfunc __kptr_untrusted *ptr;
  *   struct prog_test_ref_kfunc __kptr *ptr;
- *   struct prog_test_ref_kfunc __kptr_ref *ptr;
- *   struct prog_test_member __kptr_ref *ptr;
+ *   struct prog_test_member __kptr *ptr;
  * }
  */
 static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0timer\0t"
-				  "\0btf_ptr\0prog_test_ref_kfunc\0ptr\0kptr\0kptr_ref"
+				  "\0btf_ptr\0prog_test_ref_kfunc\0ptr\0kptr\0kptr_untrusted"
 				  "\0prog_test_member";
 static __u32 btf_raw_types[] = {
 	/* int */
@@ -724,20 +724,20 @@ static __u32 btf_raw_types[] = {
 	BTF_MEMBER_ENC(41, 4, 0), /* struct bpf_timer t; */
 	/* struct prog_test_ref_kfunc */		/* [6] */
 	BTF_STRUCT_ENC(51, 0, 0),
-	BTF_STRUCT_ENC(89, 0, 0),			/* [7] */
+	BTF_STRUCT_ENC(95, 0, 0),			/* [7] */
+	/* type tag "kptr_untrusted" */
+	BTF_TYPE_TAG_ENC(80, 6),			/* [8] */
 	/* type tag "kptr" */
-	BTF_TYPE_TAG_ENC(75, 6),			/* [8] */
-	/* type tag "kptr_ref" */
-	BTF_TYPE_TAG_ENC(80, 6),			/* [9] */
-	BTF_TYPE_TAG_ENC(80, 7),			/* [10] */
+	BTF_TYPE_TAG_ENC(75, 6),			/* [9] */
+	BTF_TYPE_TAG_ENC(75, 7),			/* [10] */
 	BTF_PTR_ENC(8),					/* [11] */
 	BTF_PTR_ENC(9),					/* [12] */
 	BTF_PTR_ENC(10),				/* [13] */
 	/* struct btf_ptr */				/* [14] */
 	BTF_STRUCT_ENC(43, 3, 24),
-	BTF_MEMBER_ENC(71, 11, 0), /* struct prog_test_ref_kfunc __kptr *ptr; */
-	BTF_MEMBER_ENC(71, 12, 64), /* struct prog_test_ref_kfunc __kptr_ref *ptr; */
-	BTF_MEMBER_ENC(71, 13, 128), /* struct prog_test_member __kptr_ref *ptr; */
+	BTF_MEMBER_ENC(71, 11, 0), /* struct prog_test_ref_kfunc __kptr_untrusted *ptr; */
+	BTF_MEMBER_ENC(71, 12, 64), /* struct prog_test_ref_kfunc __kptr *ptr; */
+	BTF_MEMBER_ENC(71, 13, 128), /* struct prog_test_member __kptr *ptr; */
 };
 
 static char bpf_vlog[UINT_MAX >> 8];
-- 
2.30.2

