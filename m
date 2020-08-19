Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D724A9A8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgHSWmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgHSWkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23853C061346
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w17so109444ybl.9
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=05RINSlNZpxkz4+XFh9vffd8x++7Xi2oImwEGbIboIw=;
        b=bvCqfxtE89wPaDPHtG2KP3DVu3Cufv99C8GojGuQCFL9y27nN0rOopfPwO2vwfymzC
         lqkRkUypcojwKSQVGrz26UL/g4gE3fBQYLpODEQ9ICYgV2hp18x332AL6x7b641aTOmp
         Iz8k6B8r/tPk5Orl/N7dDyMCG/rSjX7v8Z6zazG5bZR9FjE7Tz2qLrfRaL6Hk0hvdMjX
         mLRJ5glMA/vaZ70wPFs6ft1f/gh0xj3HRoar/Pj1zKXRf0HjTS14gKksTiqDwQfT7OFH
         E/pmIx93X/0dz+6kUiVVUghypZ10lb4nxzGm7CYih879+eiAqNx6m7WGHdXn7ozCU++F
         LYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=05RINSlNZpxkz4+XFh9vffd8x++7Xi2oImwEGbIboIw=;
        b=tibtTsEiYkukVtVF+VzyizMYpMAX839oXiTAme+QTu/+PDdJoinjVf7GOiMZbVWMXj
         hsesSRhgZRhpaifM5HQYjQOY9m5BFZ2TG4DHZhASZTB+2w2zm0MoBhO4ExslF0ZiA0Qq
         pqqivjXWOBV1WJ6ONhU71YEx0D3AziMkvfvWXstoHrVWyH0/IOWCpzIZz8H2gzavUoVl
         vVh8KUqOEGu6LvRP0swyMmNVby58IUg7yS/yAnq7TT3jM/liELiLgME55lRYRoDE8sjv
         03Q1GvsddSHiL50IXOuYh089BPYa5QK7m8IYX3Y3Z9v8ZHJQk0bMJ2Rjlo0o0ZMqbTJA
         ncDQ==
X-Gm-Message-State: AOAM532+hwyNkzvhy7XCrAqRsmmVqimantSpkg8VcXTfJiaUZQm4+Y1m
        aSpgANWYWWvhxZVu7AbEIDA3uJW9V40Gp5tPpJUpwtqh5B+r0ac+uzMnn2VTESciKjzHdFX7vMS
        FqgLhLh296omQqsJ9oNth/qZSzKG97H2HA/1rXFX80KGgh75dkOaoIYdPPC3o5A==
X-Google-Smtp-Source: ABdhPJx+VL0RsYyIRSbcn1wDvK0fb0lyt4S9Ju6v1CCixPKoa2AzooiMvkcYAjrEIUWzQ0XfkYjGGpXZSrI=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a5b:744:: with SMTP id s4mr965454ybq.26.1597876840168;
 Wed, 19 Aug 2020 15:40:40 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:25 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-4-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 3/8] bpf: Introduce help function to validate
 ksym's type.
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a ksym to be safely dereferenced and accessed, its type defined in
bpf program should basically match its type defined in kernel. Implement
a help function for a quick matching, which is used by libbpf when
resolving the kernel btf_id of a ksym.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/lib/bpf/btf.c | 171 ++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/btf.h |   2 +
 2 files changed, 173 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index a3d259e614b0..2ff31f244d7a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1005,6 +1005,177 @@ int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 	return 0;
 }
 
+/*
+ * Basic type check for ksym support. Only checks type kind and resolved size.
+ */
+static inline
+bool btf_ksym_equal_type(const struct btf *ba, __u32 type_a,
+			 const struct btf *bb, __u32 type_b)
+{
+	const struct btf_type *ta, *tb;
+
+	ta = btf__type_by_id(ba, type_a);
+	tb = btf__type_by_id(bb, type_b);
+
+	/* compare type kind */
+	if (btf_kind(ta) != btf_kind(tb))
+		return false;
+
+	/* compare resolved type size */
+	return btf__resolve_size(ba, type_a) == btf__resolve_size(bb, type_b);
+}
+
+/*
+ * Match a ksym's type defined in bpf programs against its type encoded in
+ * kernel btf.
+ */
+bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
+			 const struct btf *bb, __u32 id_b)
+{
+	const struct btf_type *ta = btf__type_by_id(ba, id_a);
+	const struct btf_type *tb = btf__type_by_id(bb, id_b);
+	int i;
+
+	/* compare type kind */
+	if (btf_kind(ta) != btf_kind(tb)) {
+		pr_warn("%s:mismatched type kind (%d v.s. %d).\n",
+			__func__, btf_kind(ta), btf_kind(tb));
+		return false;
+	}
+
+	switch (btf_kind(ta)) {
+	case BTF_KIND_INT: { /* compare size and encoding */
+		__u32 ea, eb;
+
+		if (ta->size != tb->size) {
+			pr_warn("%s:INT size mismatch, (%u v.s. %u)\n",
+				__func__, ta->size, tb->size);
+			return false;
+		}
+		ea = *(__u32 *)(ta + 1);
+		eb = *(__u32 *)(tb + 1);
+		if (ea != eb) {
+			pr_warn("%s:INT encoding mismatch (%u v.s. %u)\n",
+				__func__, ea, eb);
+			return false;
+		}
+		break;
+	}
+	case BTF_KIND_ARRAY: { /* compare type and number of elements */
+		const struct btf_array *ea, *eb;
+
+		ea = btf_array(ta);
+		eb = btf_array(tb);
+		if (!btf_ksym_equal_type(ba, ea->type, bb, eb->type)) {
+			pr_warn("%s:ARRAY elem type mismatch.\n", __func__);
+			return false;
+		}
+		if (ea->nelems != eb->nelems) {
+			pr_warn("%s:ARRAY nelems mismatch (%d v.s. %d)\n",
+				__func__, ea->nelems, eb->nelems);
+			return false;
+		}
+		break;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: { /* compare size, vlen and member offset, name */
+		const struct btf_member *ma, *mb;
+
+		if (ta->size != tb->size) {
+			pr_warn("%s:STRUCT size mismatch, (%u v.s. %u)\n",
+				__func__, ta->size, tb->size);
+			return false;
+		}
+		if (btf_vlen(ta) != btf_vlen(tb)) {
+			pr_warn("%s:STRUCT vlen mismatch, (%u v.s. %u)\n",
+				__func__, btf_vlen(ta), btf_vlen(tb));
+			return false;
+		}
+
+		ma = btf_members(ta);
+		mb = btf_members(tb);
+		for (i = 0; i < btf_vlen(ta); i++, ma++, mb++) {
+			const char *na, *nb;
+
+			if (ma->offset != mb->offset) {
+				pr_warn("%s:STRUCT field offset mismatch, (%u v.s. %u)\n",
+					__func__, ma->offset, mb->offset);
+				return false;
+			}
+			na = btf__name_by_offset(ba, ma->name_off);
+			nb = btf__name_by_offset(bb, mb->name_off);
+			if (strcmp(na, nb)) {
+				pr_warn("%s:STRUCT field name mismatch, (%s v.s. %s)\n",
+					__func__, na, nb);
+				return false;
+			}
+		}
+		break;
+	}
+	case BTF_KIND_ENUM: { /* compare vlen and member value, name */
+		const struct btf_enum *ma, *mb;
+
+		if (btf_vlen(ta) != btf_vlen(tb)) {
+			pr_warn("%s:ENUM vlen mismatch, (%u v.s. %u)\n",
+				__func__, btf_vlen(ta), btf_vlen(tb));
+			return false;
+		}
+
+		ma = btf_enum(ta);
+		mb = btf_enum(tb);
+		for (i = 0; i < btf_vlen(ta); i++, ma++, mb++) {
+			if (ma->val != mb->val) {
+				pr_warn("%s:ENUM val mismatch, (%u v.s. %u)\n",
+					__func__, ma->val, mb->val);
+				return false;
+			}
+		}
+		break;
+	}
+	case BTF_KIND_PTR: { /* naive compare of ref type for PTR */
+		if (!btf_ksym_equal_type(ba, ta->type, bb, tb->type)) {
+			pr_warn("%s:PTR ref type mismatch.\n", __func__);
+			return false;
+		}
+		break;
+	}
+	case BTF_KIND_FUNC_PROTO: { /* naive compare of vlen and param types */
+		const struct btf_param *pa, *pb;
+
+		if (btf_vlen(ta) != btf_vlen(tb)) {
+			pr_warn("%s:FUNC_PROTO vlen mismatch, (%u v.s. %u)\n",
+				__func__, btf_vlen(ta), btf_vlen(tb));
+			return false;
+		}
+
+		pa = btf_params(ta);
+		pb = btf_params(tb);
+		for (i = 0; i < btf_vlen(ta); i++, pa++, pb++) {
+			if (!btf_ksym_equal_type(ba, pa->type, bb, pb->type)) {
+				pr_warn("%s:FUNC_PROTO params type mismatch.\n",
+					__func__);
+				return false;
+			}
+		}
+		break;
+	}
+	case BTF_KIND_FUNC:
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_TYPEDEF:
+	case BTF_KIND_VAR:
+	case BTF_KIND_DATASEC:
+		pr_warn("unexpected type for matching ksym types.\n");
+		return false;
+	default:
+		pr_warn("unsupported btf types.\n");
+		return false;
+	}
+
+	return true;
+}
+
 struct btf_ext_sec_setup_param {
 	__u32 off;
 	__u32 len;
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 91f0ad0e0325..5ef220e52485 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -52,6 +52,8 @@ LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
 				    __u32 expected_key_size,
 				    __u32 expected_value_size,
 				    __u32 *key_type_id, __u32 *value_type_id);
+LIBBPF_API bool btf_ksym_type_match(const struct btf *ba, __u32 id_a,
+				    const struct btf *bb, __u32 id_b);
 
 LIBBPF_API struct btf_ext *btf_ext__new(__u8 *data, __u32 size);
 LIBBPF_API void btf_ext__free(struct btf_ext *btf_ext);
-- 
2.28.0.220.ged08abb693-goog

