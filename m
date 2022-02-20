Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57B4BCEC5
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243473AbiBTNtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243933AbiBTNtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:40 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2275153731;
        Sun, 20 Feb 2022 05:49:00 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id d17so6458773pfl.0;
        Sun, 20 Feb 2022 05:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQ8dyPiqPLmVFyu1015TusWyT0/TCJ+qkiFiAwTmZf8=;
        b=mLuRBE4/06WFBBkBAR/2xL6B4iIVkvAZAB3YXvtRSs1jkYcrMNRRtxnmb7ob/numhA
         +BySUCxf2CPAGnN3ASdpJ8xo2Y28ChSjgkIemZ6yagLssQDPkqQJQutaG6bjaVkVgUeZ
         sAhz6UIuCCCzOpS3Unq5Ekik1pSWPl1LUFu7Rt3d1agJNMC2sFXOD3uQzX2lb/jvvNjt
         YUnnUlH3MMGUZ+1Fqzf2T/xVsobc9H6FfmRk8g14b2BqRLVmivqOTII0h/G7mpSKMnmn
         4ZINMZqfo7sQyW2WyDs2wMB/VtWmerGIhwIExkE6Kl8T37dbE6sQs9SI23jfjJGRwCNf
         wSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQ8dyPiqPLmVFyu1015TusWyT0/TCJ+qkiFiAwTmZf8=;
        b=oRapgkhqHrnTq6FlwikhOLb4d4Zo3biJIDzAl2+3trr81lzggb+jWS2m9XULMY0hIb
         uvDr7Oxd17vGQkdVU9SuKsvsAxnKu1DdywgPsDpLt+fu++hwZkCMuh9OV78K4MVCD41n
         +InasTZaxVCQTGe0SWwoXsgCKqX8+y2Lm4mwHF1jb1gEg9lNZ2jw709wOc8yDm45uu1k
         jvFnK/G3+emKpfLdBgtA8HjcEcN4HvUCfpttLCW2+rVZkbSYCwNZjIebyl2Y+DSEi5k3
         hmr5NhCpYvGKlADoK4BenZBW/iN1nIaNP+umyI0vuzwu6egtGjUPfmg6GVeCjQF495uc
         RC4w==
X-Gm-Message-State: AOAM5304MZemovvwi3zFBg6yWQULznSi3cu/y/XjbXE8YSgg6QhbWJ+M
        KnvwgPI3m5BiDGanaZkEzaG2R6DjxaM=
X-Google-Smtp-Source: ABdhPJz9KW4uedO6mACM8AUtpi2JmrUkgqyYO7JeiSPQD8YSp2dj99ubnVuxXk11BWLgiYlQ4tIN7g==
X-Received: by 2002:a63:e5c:0:b0:365:331e:8dcd with SMTP id 28-20020a630e5c000000b00365331e8dcdmr12983917pgo.431.1645364939411;
        Sun, 20 Feb 2022 05:48:59 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id h21sm9311207pfo.12.2022.02.20.05.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:59 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 14/15] selftests/bpf: Add C tests for PTR_TO_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:12 +0530
Message-Id: <20220220134813.3411982-15-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5959; h=from:subject; bh=wl/5gCvad/dV1Vcz6TclnMJfJeC3nZQ5ne11tiVi4RY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYYZ8ER8Flwj2NzkS2jdee14hb/4b6kPHnYMHD /umIAfyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8RynnCD/ 0YuFM3ove6xY/uJJJ/5V06N0V5ClfXQB05Z8+JyuSb1BmDEoQRXAzogzVuQGbW8vzypEyt2PC4oP5L H8bQR2Xss6aZgdkM3uy0XKrV2Tdxoxx2FqdGQcHnTsqlIKJmb4FqVUtS8Dd9TzP6fB+U6Z++kZRyYk ghPGoYtivdTnLnPFqmWRPjATnAWTzc24bvNjO8HaUs8oK2EV1ftMgCf2UFdpCLI3MAEIbFvXBLUis1 cPID+5xqBeguQQ7M+5dkQxyzCTyeFCbdK6+Q2y9JuGyeNiRfhNeyvGcRMbFB4Jp+AtWJagUOKEyNjA XbDHmCgEv9GvUgmZAlIyR/zh2qYG4FywIKHhivwgacDLcHSu6B4qWbKkEpAoyLZMyf96bGMAvfKfGT Oxee3KvS0yUccLF2jGSEjNWZo8bK3vI9PZ213vvQHapPwQCR7q/DqzysN7Vd5LK5LN7WdwNdmDkRP7 qX1fo7wImxseXAlyXviP7xY9N8I+EySysZIRUjQRYoYaywvh3D/ra38UdjXzIdhYFWV5DaVFmRiBGJ /+W3+JjpEsPhaf+fs4xH38o2NjT6/xEukU96rOGvYK1QtllnUE76LCujBK/W+jbzonVMa+RFyRHzzB 1eqJKLxlktwYMuwaPHzw8vSDL/6YhIb3bHl1L6zvk2LA20fR33Rl5inAjfJA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses the __kptr* macros as well, and tries to test the stuff that
is supposed to work, since we have negative tests in test_verifier
suite.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/map_btf_ptr.c    |  13 +++
 .../testing/selftests/bpf/progs/map_btf_ptr.c | 105 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  31 ++++++
 3 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_btf_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_btf_ptr.c

diff --git a/tools/testing/selftests/bpf/prog_tests/map_btf_ptr.c b/tools/testing/selftests/bpf/prog_tests/map_btf_ptr.c
new file mode 100644
index 000000000000..8fb6acf1b89d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_btf_ptr.c
@@ -0,0 +1,13 @@
+#include <test_progs.h>
+
+#include "map_btf_ptr.skel.h"
+
+void test_map_btf_ptr(void)
+{
+	struct map_btf_ptr *skel;
+
+	skel = map_btf_ptr__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "map_btf_ptr__open_and_load"))
+		return;
+	map_btf_ptr__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/map_btf_ptr.c b/tools/testing/selftests/bpf/progs/map_btf_ptr.c
new file mode 100644
index 000000000000..b0c2ba595290
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/map_btf_ptr.c
@@ -0,0 +1,105 @@
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+#define xchg(dst, src) __sync_lock_test_and_set(&(dst), (src))
+
+struct map_value {
+	struct prog_test_ref_kfunc __kptr *unref_ptr;
+	/* Workarounds for https://lore.kernel.org/bpf/20220220071333.sltv4jrwniool2qy@apollo.legion */
+	struct prog_test_ref_kfunc __kptr __attribute__((btf_type_tag("kernel.bpf.ref"))) *ref_ptr;
+	struct prog_test_ref_kfunc __kptr __attribute__((btf_type_tag("kernel.bpf.percpu"))) *percpu_ptr;
+	struct prog_test_ref_kfunc __kptr __attribute__((btf_type_tag("kernel.bpf.user"))) *user_ptr;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, struct map_value);
+	__uint(max_entries, 1);
+} array_map SEC(".maps");
+
+extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
+extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+
+SEC("tc")
+int map_btf_ptr(struct __sk_buff *ctx)
+{
+	struct prog_test_ref_kfunc *p;
+	char buf[sizeof(*p)];
+	struct map_value *v;
+
+	v = bpf_map_lookup_elem(&array_map, &(int){0});
+	if (!v)
+		return 0;
+	p = v->unref_ptr;
+	/* store untrusted_ptr_or_null_ */
+	v->unref_ptr = p;
+	if (!p)
+		return 0;
+	if (p->a + p->b > 100)
+		return 1;
+	/* store untrusted_ptr_ */
+	v->unref_ptr = p;
+	/* store NULL */
+	v->unref_ptr = NULL;
+
+	p = v->ref_ptr;
+	/* store ptr_or_null_ */
+	v->unref_ptr = p;
+	if (!p)
+		return 0;
+	if (p->a + p->b > 100)
+		return 1;
+	/* store NULL */
+	p = xchg(v->ref_ptr, NULL);
+	if (!p)
+		return 0;
+	if (p->a + p->b > 100) {
+		bpf_kfunc_call_test_release(p);
+		return 1;
+	}
+	/* store ptr_ */
+	v->unref_ptr = p;
+	bpf_kfunc_call_test_release(p);
+
+	p = bpf_kfunc_call_test_acquire(&(unsigned long){0});
+	if (!p)
+		return 0;
+	/* store ptr_ */
+	p = xchg(v->ref_ptr, p);
+	if (!p)
+		return 0;
+	if (p->a + p->b > 100) {
+		bpf_kfunc_call_test_release(p);
+		return 1;
+	}
+	bpf_kfunc_call_test_release(p);
+
+	p = v->percpu_ptr;
+	/* store percpu_ptr_or_null_ */
+	v->percpu_ptr = p;
+	if (!p)
+		return 0;
+	p = bpf_this_cpu_ptr(p);
+	if (p->a + p->b > 100)
+		return 1;
+	/* store percpu_ptr_ */
+	v->percpu_ptr = p;
+	/* store NULL */
+	v->percpu_ptr = NULL;
+
+	p = v->user_ptr;
+	/* store user_ptr_or_null_ */
+	v->user_ptr = p;
+	if (!p)
+		return 0;
+	bpf_probe_read_user(buf, sizeof(buf), p);
+	/* store user_ptr_ */
+	v->user_ptr = p;
+	/* store NULL */
+	v->user_ptr = NULL;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..74e3892be544 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -30,8 +30,21 @@ struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_ct_kptr_get(struct nf_conn **, struct bpf_sock_tuple *, u32,
+				u8, u8) __ksym;
 void bpf_ct_release(struct nf_conn *) __ksym;
 
+struct nf_map_value {
+	struct nf_conn __kptr_ref *ct;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, struct nf_map_value);
+	__uint(max_entries, 1);
+} array_map SEC(".maps");
+
 static __always_inline void
 nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 				   struct bpf_ct_opts___local *, u32),
@@ -101,10 +114,27 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_eafnosupport = opts_def.error;
 }
 
+static __always_inline void
+nf_ct_test_kptr(void)
+{
+	struct bpf_sock_tuple tuple = {};
+	struct nf_map_value *v;
+	struct nf_conn *ct;
+
+	v = bpf_map_lookup_elem(&array_map, &(int){0});
+	if (!v)
+		return;
+	ct = bpf_ct_kptr_get(&v->ct, &tuple, sizeof(tuple.ipv4), IPPROTO_TCP, IP_CT_DIR_ORIGINAL);
+	if (!ct)
+		return;
+	bpf_ct_release(ct);
+}
+
 SEC("xdp")
 int nf_xdp_ct_test(struct xdp_md *ctx)
 {
 	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
+	nf_ct_test_kptr();
 	return 0;
 }
 
@@ -112,6 +142,7 @@ SEC("tc")
 int nf_skb_ct_test(struct __sk_buff *ctx)
 {
 	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
+	nf_ct_test_kptr();
 	return 0;
 }
 
-- 
2.35.1

