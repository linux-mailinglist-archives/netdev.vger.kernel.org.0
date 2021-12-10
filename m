Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0123747013A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbhLJNGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241458AbhLJNGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:32 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E9C061A32;
        Fri, 10 Dec 2021 05:02:57 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id m24so6223662pls.10;
        Fri, 10 Dec 2021 05:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/cf1FojfoMcIVly88PLWeE+SGmQVmsIvi1Qqoa4dd/o=;
        b=f+7vzxwrcGTy4KXsvYXvxNCEtsAUgytyaq5RzItRrEa6KA3ZV6I4BfoPNdIa8ridO/
         cwvn1PYpO1GX0R7XhR9fYeqAHuYqolQQKgBDVoeNItBoF3J5iGi/h+cR0jk/JIemi6bL
         3l7Ac61/UpEkAtrbhvqm3I/oAAfzLNmBo6xpShDVDRdWR1UZZhHXsQ17kCv6hAzUu93p
         jJxIfrWaVHPiiJDlDrJYdo8465/JVo40rXWeEKKscvd7Bg60Vbkn9SdI1g3v1GVQ/16i
         Q9wj3+5i7MOzjMD5HIlLeqRVDQ76l4A6La0tBU4gv+Zcn7zSuzQdW3KlKOEm3dgpsGWT
         lGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/cf1FojfoMcIVly88PLWeE+SGmQVmsIvi1Qqoa4dd/o=;
        b=lmzvTn+6/e5kVb2J3PkmQDl5ofObF1CfFzkrRKpZ0eOvtWP1j92m2EGPoWCM39Bo+g
         MAnttqZo9r2S65OTYRC6yjAR0QqP2ZLn7iuSBER1F4TzLah4bsl7Z52FT2SWr+VouHa5
         1TcgBU+QMWzgfVXtRaVol3lskA+OoENR4CjX/6mwAXViAy45tR/qPVkHtd5zCRTZe/3X
         nJvmw9FavohZFmjskupLSJtweWxfGZZLF/NukIUABJs00HsbdwhQ5BJ/r3QDWtppKzJO
         PZSMJl7YbGwqfgbE1GQSjMdYL26jEwLS887U/JYfHUGoUe7bTV6ehnfWkZqL8bT0+tJ5
         dQNA==
X-Gm-Message-State: AOAM531HAwsYczrqpTJDIpphvGeGKZXaRZPh+lNjXJxZqoYDUG5OelHT
        T3gTvlqx9c00fVY3aO2Iin91A7XegOE=
X-Google-Smtp-Source: ABdhPJxPBRRuKMzhccgDEd9CBviYj+ftf1iGj/w9pWZOezJ85XvlTddMPN+n1SeBTGhPxEya1umaiw==
X-Received: by 2002:a17:902:ce8c:b0:141:d411:7e25 with SMTP id f12-20020a170902ce8c00b00141d4117e25mr76216352plg.85.1639141376789;
        Fri, 10 Dec 2021 05:02:56 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id ip5sm3020374pjb.5.2021.12.10.05.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:56 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v3 7/9] net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
Date:   Fri, 10 Dec 2021 18:32:28 +0530
Message-Id: <20211210130230.4128676-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=22344; h=from:subject; bh=UZKXafxeD31dza2nDRrLzmiJdCVz7Pntczk0Oktfwok=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/UxQzLveDV85rwPf9s1Ed7pcIooLC5RTEPsvd3 BrjcYz2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP1AAKCRBM4MiGSL8RyjxpEA CVbUocKGefBuEwIIC8AA/MsqaEPme88eBrJSgIZLo3bNwJRgPvzZ8akM2IwZDEaaNYRQfW+prrY4ac otIw4vSAA2RqiCjbcoz2oEsq475I73pH/WQrMUCXDIDQr5Yw3ASUbxTN27fGB01laiOHvvVX+RLiXZ rJFXZBEtrOiwwQhBI3zBuUOpSy75gk+0yydcJdtd7zdsE3dRmvGgkh+raMALr7nfKEMG3d9pWrK+X3 1RRp8W2MQoPOcF+21ypMALlamwRsBuYxjZgarbzOMlkd31MtthS7R30QXha3PlL32Zym7AJMC3y45T eAO/LzuI3oHp91ind4RLaGeEvEY9D3+7mWmOVccScdSqLN91HQeS2JJggBu8yh8uCrwaUdL1uZ5ZPW ywOgEznOLRc7JW4WWA6sWpkZFIMUxNzcc3vBB/ou4jC9k0StASw9Qaj5+2wUg2rEN0DwmvYOfyAT2q p0Ac8dumIggfj8Jc+vOO6Vunvhs251yOlcFI3RrhSA4iN85wKuDa21F+LT+ziOaPt+VrD4gtZIcnQk dFdakQnRiHmAwQhiqZFKmdSk3KDvPGi4LIoTa7GNWEsS2ir/PDFfRcJ9U5x0Kczm8w/zILZAX+oBoZ H6zsUhI2ZebTFfVjnWLS9iAw5N6NRymlK9l39ebe/7DhgaV9LLzIWkbewdJA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds conntrack lookup helpers using the unstable kfunc call
interface for the XDP and TC-BPF hooks. The primary usecase is
implementing a synproxy in XDP, see Maxim's patchset at [0].

Also add acquire/release functions (randomly returning NULL), and also
exercise the PTR_TO_BTF_ID_OR_NULL path so that BPF program caller has
to check for NULL before dereferencing the pointer, for the TC hook.
Introduce kfunc that take various argument types (for PTR_TO_MEM) that
will pass and fail the verifier checks. These will be used in selftests.

Export get_net_ns_by_id as nf_conntrack needs to call it.

Note that we search for acquire, release, and null returning kfuncs in
the intersection of those sets and main set.

This implies that the kfunc_btf_id_list acq_set, rel_set, null_set may
contain BTF ID not in main set, this is explicitly allowed and
recommended (to save on definining more and more sets), since
check_kfunc_call verifier operation would filter out the invalid BTF ID
fairly early, so later checks for acquire, release, and ret_type_null
kfunc will only consider allowed BTF IDs for that program that are
allowed in main set. This is why the nf_conntrack_acq_ids set has BTF
IDs for both xdp and tc hook kfuncs.

  [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h               |  21 +++
 include/linux/btf.h               |  31 +++-
 kernel/bpf/btf.c                  |  19 +++
 net/bpf/test_run.c                | 147 +++++++++++++++++
 net/core/filter.c                 |  27 ++++
 net/core/net_namespace.c          |   1 +
 net/netfilter/nf_conntrack_core.c | 252 ++++++++++++++++++++++++++++++
 7 files changed, 497 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6a14072c72a0..7b370ed06b1d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1675,6 +1675,9 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner);
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1933,6 +1936,24 @@ static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
 	return false;
 }
 
+static inline bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_release_kfunc(u32 kfunc_id,
+						  struct module *owner)
+{
+	return false;
+}
+
+static inline bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id,
+							struct module *owner)
+{
+	return false;
+}
+
 static inline void bpf_map_put(struct bpf_map *map)
 {
 }
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 3730e845d266..bc92825d6e3f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -321,7 +321,10 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 #endif
 
 enum kfunc_btf_id_set_types {
-	BTF_SET_CHECK,
+	BTF_SET_CHECK,    /* Allowed kfunc set */
+	BTF_SET_ACQUIRE,  /* Acquire kfunc set */
+	BTF_SET_RELEASE,  /* Release kfunc set */
+	BTF_SET_RET_NULL, /* kfunc with 'return type PTR_TO_BTF_ID_OR_NULL' set */
 	__BTF_SET_MAX,
 };
 
@@ -331,6 +334,9 @@ struct kfunc_btf_id_set {
 		struct btf_id_set *sets[__BTF_SET_MAX];
 		struct {
 			struct btf_id_set *set;
+			struct btf_id_set *acq_set;
+			struct btf_id_set *rel_set;
+			struct btf_id_set *null_set;
 		};
 	};
 	struct module *owner;
@@ -345,6 +351,12 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 				 struct kfunc_btf_id_set *s);
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 			      struct module *owner);
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner);
 #else
 static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					     struct kfunc_btf_id_set *s)
@@ -359,9 +371,26 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 {
 	return false;
 }
+static inline bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline bool
+bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			       struct module *owner)
+{
+	return false;
+}
 #endif
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
+extern struct kfunc_btf_id_list xdp_kfunc_list;
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a790ba6d93d8..4b955f47b800 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6539,6 +6539,24 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_ACQUIRE);
+}
+
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RELEASE);
+}
+
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RET_NULL);
+}
+
 #endif
 
 #define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
@@ -6548,6 +6566,7 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(xdp_kfunc_list);
 
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..779377f4af25 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -232,6 +232,117 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
 	return sk;
 }
 
+struct prog_test_ref_kfunc {
+	int a;
+	int b;
+	struct prog_test_ref_kfunc *next;
+};
+
+static struct prog_test_ref_kfunc prog_test_struct = {
+	.a = 42,
+	.b = 108,
+	.next = &prog_test_struct,
+};
+
+noinline struct prog_test_ref_kfunc *
+bpf_kfunc_call_test_acquire(unsigned long *scalar_ptr)
+{
+	/* randomly return NULL */
+	if (get_jiffies_64() % 2)
+		return NULL;
+	return &prog_test_struct;
+}
+
+noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
+{
+}
+
+struct prog_test_pass1 {
+	int x0;
+	struct {
+		int x1;
+		struct {
+			int x2;
+			struct {
+				int x3;
+				struct {
+					int x4;
+					struct {
+						int x5;
+						struct {
+							int x6;
+							struct {
+								int x7;
+							};
+						};
+					};
+				};
+			};
+		};
+	};
+};
+
+struct prog_test_pass2 {
+	int len;
+	short arr1[4];
+	struct {
+		char arr2[4];
+		unsigned long arr3[8];
+	} x;
+};
+
+struct prog_test_fail1 {
+	void *p;
+	int x;
+};
+
+struct prog_test_fail2 {
+	int x8;
+	struct prog_test_pass1 x;
+};
+
+struct prog_test_fail3 {
+	int len;
+	char arr1[2];
+	char arr2[0];
+};
+
+noinline void bpf_kfunc_call_test_pass_ctx(struct __sk_buff *skb)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass1(struct prog_test_pass1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_pass2(struct prog_test_pass2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail1(struct prog_test_fail1 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail2(struct prog_test_fail2 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_fail3(struct prog_test_fail3 *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_pass1(void *mem, int len__mem)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail1(void *mem, int len)
+{
+}
+
+noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -240,8 +351,23 @@ BTF_SET_START(test_sk_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test1)
 BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+BTF_ID(func, bpf_kfunc_call_test_pass_ctx)
+BTF_ID(func, bpf_kfunc_call_test_pass1)
+BTF_ID(func, bpf_kfunc_call_test_pass2)
+BTF_ID(func, bpf_kfunc_call_test_fail1)
+BTF_ID(func, bpf_kfunc_call_test_fail2)
+BTF_ID(func, bpf_kfunc_call_test_fail3)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
+BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
 BTF_SET_END(test_sk_kfunc_ids)
 
+BTF_ID_LIST(test_sk_acq_rel)
+BTF_ID(func, bpf_kfunc_call_test_acquire)
+BTF_ID(func, bpf_kfunc_call_test_release)
+
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
@@ -249,6 +375,27 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
+bool bpf_prog_test_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_acquire_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[1])
+		return true;
+	return bpf_is_mod_release_kfunc(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
+bool bpf_prog_test_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	if (kfunc_id == test_sk_acq_rel[0])
+		return true;
+	return bpf_is_mod_kfunc_ret_type_null(&prog_test_kfunc_list, kfunc_id, owner);
+}
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index fe27c91e3758..ad84ec6e0daa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10000,17 +10000,44 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
 	.check_kfunc_call	= bpf_prog_test_check_kfunc_call,
+	.is_acquire_kfunc	= bpf_prog_test_is_acquire_kfunc,
+	.is_release_kfunc	= bpf_prog_test_is_release_kfunc,
+	.is_kfunc_ret_type_null = bpf_prog_test_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
+static bool xdp_check_kfunc_call(u32 kfunc_id, struct module *owner)
+{
+	return bpf_check_mod_kfunc_call(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_acquire_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_acquire_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_release_kfunc(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_release_kfunc(&xdp_kfunc_list, kfunc_id, owner);
+}
+
+static bool xdp_is_kfunc_ret_type_null(u32 kfunc_id, struct module *owner)
+{
+	return bpf_is_mod_kfunc_ret_type_null(&xdp_kfunc_list, kfunc_id, owner);
+}
+
 const struct bpf_verifier_ops xdp_verifier_ops = {
 	.get_func_proto		= xdp_func_proto,
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.check_kfunc_call	= xdp_check_kfunc_call,
+	.is_acquire_kfunc	= xdp_is_acquire_kfunc,
+	.is_release_kfunc	= xdp_is_release_kfunc,
+	.is_kfunc_ret_type_null = xdp_is_kfunc_ret_type_null,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 202fa5eacd0f..7b4bfe793002 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -299,6 +299,7 @@ struct net *get_net_ns_by_id(const struct net *net, int id)
 
 	return peer;
 }
+EXPORT_SYMBOL_GPL(get_net_ns_by_id);
 
 /*
  * setup_net runs the initializers for the network namespace object.
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..85042cb6f82e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -11,6 +11,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
@@ -2451,6 +2454,249 @@ static int kill_all(struct nf_conn *i, void *data)
 	return net_eq(nf_ct_net(i), data);
 }
 
+/* Unstable Kernel Helpers for XDP and TC-BPF hook
+ *
+ * These are called from the XDP and SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
+					  struct bpf_sock_tuple *bpf_tuple,
+					  u32 tuple_len, u8 protonum,
+					  s32 netns_id)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tuple;
+
+	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
+		return ERR_PTR(-EPROTO);
+	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
+		return ERR_PTR(-EINVAL);
+
+	memset(&tuple, 0, sizeof(tuple));
+	switch (tuple_len) {
+	case sizeof(bpf_tuple->ipv4):
+		tuple.src.l3num = AF_INET;
+		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
+		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
+		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
+		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
+		break;
+	case sizeof(bpf_tuple->ipv6):
+		tuple.src.l3num = AF_INET6;
+		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
+		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
+		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
+		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
+		break;
+	default:
+		return ERR_PTR(-EAFNOSUPPORT);
+	}
+
+	tuple.dst.protonum = protonum;
+
+	if (netns_id >= 0) {
+		net = get_net_ns_by_id(net, netns_id);
+		if (unlikely(!net))
+			return ERR_PTR(-ENONET);
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
+	if (netns_id >= 0)
+		put_net(net);
+	if (!hash)
+		return ERR_PTR(-ENOENT);
+	return nf_ct_tuplehash_to_ctrack(hash);
+}
+
+/* bpf_ct_opts - Options for CT lookup helpers
+ *
+ * Members:
+ * @error      - Out parameter, set for any errors encountered
+ *		 Values:
+ *		   -EINVAL - Passed NULL for bpf_tuple pointer
+ *		   -EINVAL - opts->reserved is not 0
+ *		   -EINVAL - netns_id is less than -1
+ *		   -EINVAL - len__opts isn't NF_BPF_CT_OPTS_SZ (12)
+ *		   -EPROTO - l4proto isn't one of IPPROTO_TCP or IPPROTO_UDP
+ *		   -ENONET - No network namespace found for netns_id
+ *		   -ENOENT - Conntrack lookup could not find entry for tuple
+ *		   -EAFNOSUPPORT - len__tuple isn't one of sizeof(tuple->ipv4)
+ *				   or sizeof(tuple->ipv6)
+ * @l4proto    - Layer 4 protocol
+ *		 Values:
+ *		   IPPROTO_TCP, IPPROTO_UDP
+ * @reserved   - Reserved member, will be reused for more options in future
+ *		 Values:
+ *		   0
+ * @netns_id   - Specify the network namespace for lookup
+ *		 Values:
+ *		   BPF_F_CURRENT_NETNS (-1)
+ *		     Use namespace associated with ctx (xdp_md, __sk_buff)
+ *		   [0, S32_MAX]
+ *		     Network Namespace ID
+ */
+struct bpf_ct_opts {
+	s32 netns_id;
+	s32 error;
+	u8 l4proto;
+	u8 reserved[3];
+};
+
+enum {
+	NF_BPF_CT_OPTS_SZ = 12,
+};
+
+/* bpf_xdp_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @xdp_ctx	- Pointer to ctx (xdp_md) in XDP program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
+				  struct bpf_sock_tuple *bpf_tuple,
+				  u32 len__tuple, struct bpf_ct_opts *opts,
+				  u32 len__opts)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = dev_net(ctx->rxq->dev);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_skb_ct_lookup - Lookup CT entry for the given tuple, and acquire a
+ *		       reference to it
+ *
+ * Parameters:
+ * @skb_ctx	- Pointer to ctx (__sk_buff) in TC program
+ *		    Cannot be NULL
+ * @bpf_tuple	- Pointer to memory representing the tuple to look up
+ *		    Cannot be NULL
+ * @len__tuple	- Length of the tuple structure
+ *		    Must be one of sizeof(bpf_tuple->ipv4) or
+ *		    sizeof(bpf_tuple->ipv6)
+ * @opts	- Additional options for lookup (documented above)
+ *		    Cannot be NULL
+ * @len__opts	- Length of the bpf_ct_opts structure
+ *		    Must be NF_BPF_CT_OPTS_SZ (12)
+ */
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
+				  struct bpf_sock_tuple *bpf_tuple,
+				  u32 len__tuple, struct bpf_ct_opts *opts,
+				  u32 len__opts)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+	struct nf_conn *nfct;
+
+	BUILD_BUG_ON(sizeof(struct bpf_ct_opts) != NF_BPF_CT_OPTS_SZ);
+
+	if (!opts)
+		return NULL;
+	if (!bpf_tuple || opts->reserved[0] || opts->reserved[1] ||
+	    opts->reserved[2] || len__opts != NF_BPF_CT_OPTS_SZ) {
+		opts->error = -EINVAL;
+		return NULL;
+	}
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	nfct = __bpf_nf_ct_lookup(caller_net, bpf_tuple, len__tuple, opts->l4proto,
+				  opts->netns_id);
+	if (IS_ERR(nfct)) {
+		opts->error = PTR_ERR(nfct);
+		return NULL;
+	}
+	return nfct;
+}
+
+/* bpf_ct_release - Release acquired nf_conn object
+ *
+ * This must be invoked for referenced PTR_TO_BTF_ID, and the verifier rejects
+ * the program if any references remain in the program in all of the explored
+ * states.
+ *
+ * Parameters:
+ * @nf_conn	 - Pointer to referenced nf_conn object, obtained using
+ *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
+ */
+void bpf_ct_release(struct nf_conn *nfct)
+{
+	if (!nfct)
+		return;
+	nf_ct_put(nfct);
+}
+
+/* kfuncs that may return NULL PTR_TO_BTF_ID */
+BTF_SET_START(nf_conntrack_null_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(nf_conntrack_null_ids)
+
+/* XDP hook allowed kfuncs */
+BTF_SET_START(nf_conntrack_xdp_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_xdp_ids)
+
+/* TC-BPF hook allowed kfuncs */
+BTF_SET_START(nf_conntrack_skb_ids)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_skb_ids)
+
+/* XDP and TC-BPF hook acquire kfuncs */
+BTF_SET_START(nf_conntrack_acq_ids)
+BTF_ID(func, bpf_xdp_ct_lookup)
+BTF_ID(func, bpf_skb_ct_lookup)
+BTF_SET_END(nf_conntrack_acq_ids)
+
+/* XDP and TC-BPF hook release kfuncs */
+BTF_SET_START(nf_conntrack_rel_ids)
+BTF_ID(func, bpf_ct_release)
+BTF_SET_END(nf_conntrack_rel_ids)
+
+static struct kfunc_btf_id_set nf_ct_xdp_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_xdp_ids,
+	.acq_set	       = &nf_conntrack_acq_ids,
+	.rel_set	       = &nf_conntrack_rel_ids,
+	.null_set	       = &nf_conntrack_null_ids,
+};
+
+static struct kfunc_btf_id_set nf_ct_skb_kfunc_set = {
+	.owner                 = THIS_MODULE,
+	.set                   = &nf_conntrack_skb_ids,
+	.acq_set	       = &nf_conntrack_acq_ids,
+	.rel_set	       = &nf_conntrack_rel_ids,
+	.null_set	       = &nf_conntrack_null_ids,
+};
+
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
@@ -2459,6 +2705,9 @@ void nf_conntrack_cleanup_start(void)
 
 void nf_conntrack_cleanup_end(void)
 {
+	unregister_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
@@ -2745,6 +2994,9 @@ int nf_conntrack_init_start(void)
 	conntrack_gc_work_init(&conntrack_gc_work);
 	queue_delayed_work(system_power_efficient_wq, &conntrack_gc_work.dwork, HZ);
 
+	register_kfunc_btf_id_set(&prog_test_kfunc_list, &nf_ct_skb_kfunc_set);
+	register_kfunc_btf_id_set(&xdp_kfunc_list, &nf_ct_xdp_kfunc_set);
+
 	return 0;
 
 err_proto:
-- 
2.34.1

