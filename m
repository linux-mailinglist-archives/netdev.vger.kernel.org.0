Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC97535595
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349177AbiEZVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349212AbiEZVgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:36:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E36E8B94;
        Thu, 26 May 2022 14:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 406EDB82208;
        Thu, 26 May 2022 21:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A07C385B8;
        Thu, 26 May 2022 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600962;
        bh=0rdcDRJpYy6UBMk+2JLOt3p8eZJxwAKLEbUhro+J8eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5TuItuo4Di7tSDOOU/FJwKIUO5PLRopn1wwozLCxtDLO34nhoat1+ufyN5CDbVrH
         5HvkBAvdrM4yvgmXWnYaR3ociyFqzLwNOVntB8dAlp/1KtEINu9LJjGFQW80+Pk6cC
         lOWbJv2QB1EWrOxkhsl/J5SxVVv/CY++yWkvw+uE/DWfcdyYV5p2A9fvfrlZDBpb2H
         H2aW9AdyzmtxkxgMATMr8vR3BNbMLjPJzQBZzHt4qXvguhftPn582NrSbwFWxHPtml
         p6Vg0sqwIBIws/aK+KNw2VfNfczV7U77mcW/RFZGU7omkDs/eI8JocxpHdrXEJKkH1
         41y0ZDF4TrE6A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 09/14] selftests/bpf: Add C tests for rdonly PTR_TO_BTF_ID
Date:   Thu, 26 May 2022 23:34:57 +0200
Message-Id: <033365d2afbbd18f6524203f1e729c477865ce2b.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Both the return value of bpf_kptr_xchg and load of read only kptr must
be marked with MEM_RDONLY.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../selftests/bpf/prog_tests/map_kptr.c       |   9 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  |  31 ++++-
 .../selftests/bpf/progs/map_kptr_fail.c       | 114 ++++++++++++++++++
 3 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/map_kptr.c b/tools/testing/selftests/bpf/prog_tests/map_kptr.c
index fdcea7a61491..cca0bb51b752 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_kptr.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_kptr.c
@@ -36,6 +36,13 @@ struct {
 	{ "reject_indirect_global_func_access", "kptr cannot be accessed indirectly by helper" },
 	{ "kptr_xchg_ref_state", "Unreleased reference id=5 alloc_insn=" },
 	{ "kptr_get_ref_state", "Unreleased reference id=3 alloc_insn=" },
+	{ "kptr_const_to_non_const", "invalid kptr access, R0 type=rdonly_ptr_" },
+	{ "kptr_const_to_non_const_xchg", "invalid kptr access, R2 type=rdonly_ptr_" },
+	{ "kptr_const_or_null_to_non_const_xchg", "invalid kptr access, R2 type=rdonly_ptr_or_null_" },
+	{ "mark_rdonly", "R1 type=rdonly_untrusted_ptr_or_null_ expected=percpu_ptr_" },
+	{ "mark_ref_rdonly", "R1 type=rdonly_untrusted_ptr_or_null_ expected=percpu_ptr_" },
+	{ "mark_xchg_rdonly", "R1 type=rdonly_ptr_or_null_ expected=percpu_ptr_" },
+	{ "kptr_get_no_const", "arg#0 cannot raise reference for pointer to const" },
 };
 
 static void test_map_kptr_fail_prog(const char *prog_name, const char *err_msg)
@@ -91,7 +98,7 @@ static void test_map_kptr_success(bool test_run)
 	);
 	struct map_kptr *skel;
 	int key = 0, ret;
-	char buf[16];
+	char buf[32];
 
 	skel = map_kptr__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "map_kptr__open_and_load"))
diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index eb8217803493..f77689544e65 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -6,6 +6,8 @@
 struct map_value {
 	struct prog_test_ref_kfunc __kptr *unref_ptr;
 	struct prog_test_ref_kfunc __kptr_ref *ref_ptr;
+	const struct prog_test_ref_kfunc __kptr *const_unref_ptr;
+	const struct prog_test_ref_kfunc __kptr_ref *const_ref_ptr;
 };
 
 struct array_map {
@@ -58,12 +60,14 @@ DEFINE_MAP_OF_MAP(BPF_MAP_TYPE_HASH_OF_MAPS, hash_malloc_map, hash_of_hash_mallo
 DEFINE_MAP_OF_MAP(BPF_MAP_TYPE_HASH_OF_MAPS, lru_hash_map, hash_of_lru_hash_maps);
 
 extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern const struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire_const(void) __ksym;
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
-extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+extern void bpf_kfunc_call_test_release(const struct prog_test_ref_kfunc *p) __ksym;
 
 static void test_kptr_unref(struct map_value *v)
 {
+	const struct prog_test_ref_kfunc *pc;
 	struct prog_test_ref_kfunc *p;
 
 	p = v->unref_ptr;
@@ -77,10 +81,21 @@ static void test_kptr_unref(struct map_value *v)
 	v->unref_ptr = p;
 	/* store NULL */
 	v->unref_ptr = NULL;
+
+	pc = v->const_ref_ptr;
+	/* store rdonly_untrusted_ptr_or_null_ */
+	v->const_unref_ptr = pc;
+	if (!pc)
+		return;
+	/* store rdonly_untrusted_ptr_ */
+	v->const_unref_ptr = pc;
+	/* store NULL */
+	v->const_unref_ptr = NULL;
 }
 
 static void test_kptr_ref(struct map_value *v)
 {
+	const struct prog_test_ref_kfunc *pc;
 	struct prog_test_ref_kfunc *p;
 
 	p = v->ref_ptr;
@@ -114,6 +129,20 @@ static void test_kptr_ref(struct map_value *v)
 		return;
 	}
 	bpf_kfunc_call_test_release(p);
+
+	pc = bpf_kptr_xchg(&v->const_ref_ptr, NULL);
+	if (!pc)
+		return;
+	/* store rdonly_ptr_ */
+	v->const_unref_ptr = pc;
+	bpf_kfunc_call_test_release(pc);
+
+	pc = bpf_kfunc_call_test_acquire_const();
+	if (!pc)
+		return;
+	v->const_unref_ptr = pc;
+	bpf_kfunc_call_test_release(pc);
+	v->const_unref_ptr = v->const_ref_ptr;
 }
 
 static void test_kptr_get(struct map_value *v)
diff --git a/tools/testing/selftests/bpf/progs/map_kptr_fail.c b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
index 05e209b1b12a..a1c4209a09e4 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr_fail.c
@@ -9,6 +9,8 @@ struct map_value {
 	struct prog_test_ref_kfunc __kptr *unref_ptr;
 	struct prog_test_ref_kfunc __kptr_ref *ref_ptr;
 	struct prog_test_member __kptr_ref *ref_memb_ptr;
+	const struct prog_test_ref_kfunc __kptr *const_unref_ptr;
+	const struct prog_test_ref_kfunc __kptr_ref *const_ref_ptr;
 };
 
 struct array_map {
@@ -19,6 +21,7 @@ struct array_map {
 } array_map SEC(".maps");
 
 extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern const struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire_const(void) __ksym;
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 
@@ -415,4 +418,115 @@ int kptr_get_ref_state(struct __sk_buff *ctx)
 	return 0;
 }
 
+SEC("?tc")
+int kptr_const_to_non_const(struct __sk_buff *ctx)
+{
+	const struct prog_test_ref_kfunc *p;
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	p = bpf_kfunc_call_test_acquire_const();
+	if (!p)
+		return 0;
+
+	v->unref_ptr = (void *)p;
+	return 0;
+}
+
+SEC("?tc")
+int kptr_const_to_non_const_xchg(struct __sk_buff *ctx)
+{
+	const struct prog_test_ref_kfunc *p;
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	p = bpf_kfunc_call_test_acquire_const();
+	if (!p)
+		return 0;
+
+	bpf_kptr_xchg(&v->ref_ptr, p);
+	return 0;
+}
+
+SEC("?tc")
+int kptr_const_or_null_to_non_const_xchg(struct __sk_buff *ctx)
+{
+	const struct prog_test_ref_kfunc *p;
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	p = bpf_kfunc_call_test_acquire_const();
+
+	bpf_kptr_xchg(&v->ref_ptr, p);
+	return 0;
+}
+
+SEC("?tc")
+int mark_rdonly(struct __sk_buff *ctx)
+{
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	bpf_this_cpu_ptr(v->const_unref_ptr);
+	return 0;
+}
+
+SEC("?tc")
+int mark_ref_rdonly(struct __sk_buff *ctx)
+{
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	bpf_this_cpu_ptr(v->const_ref_ptr);
+	return 0;
+}
+
+SEC("?tc")
+int mark_xchg_rdonly(struct __sk_buff *ctx)
+{
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	bpf_this_cpu_ptr(bpf_kptr_xchg(&v->const_ref_ptr, NULL));
+	return 0;
+}
+
+SEC("?tc")
+int kptr_get_no_const(struct __sk_buff *ctx)
+{
+	struct map_value *v;
+	int key = 0;
+
+	v = bpf_map_lookup_elem(&array_map, &key);
+	if (!v)
+		return 0;
+
+	bpf_kfunc_call_test_kptr_get((void *)&v->const_ref_ptr, 0, 0);
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.35.3

