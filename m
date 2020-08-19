Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC9B24A98C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHSWlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgHSWkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:49 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21388C061349
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:43 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id p22so145921qtp.9
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=o5hcafLIur4TPskQP5E6KPZVFbh+qjZrYmSthTwVB04=;
        b=KEVm/sGPyfyG51HlhTXV0YroOEI5zQYZmoLUdxXgIMqVb18ASyPW/KbBdlS7ux/IYv
         py7s5CBpnuj5Z2kI0U5feqHgVdccNJ+ILv5x/tYIgODbbvld+P0r4wahQGtF0n0SOEe+
         YeshFbT8qj9ZXs9EgwKnXGF7Mwlc35Fi/xc3ryWZp9MNsYPfcpSuUnoyD/sjHjkd8fMe
         HyQ6yQr7/g1qaABSsKISXqpygyG+prMVRoGAr81nHP3iHvFjQg4CnPfYp/0Ob3zKEpGQ
         gPHLQRFCRb51ZDeq8u5vgR6X66B0t92iLLHDiNdQi0I8CUu8qonHMcXHm4Iaw5HGqpVI
         IcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o5hcafLIur4TPskQP5E6KPZVFbh+qjZrYmSthTwVB04=;
        b=IIyHmzBHDChaDeCwmeFzjYPYEdYz/yx51wqgxTfy6EdOZpKT5zgFdXZC52KQy0np3r
         xsrbUdf2+7Hbs5/UutyO/epkjpsLDCbLs1U7LBEYwUtbVpPPRdBcp+Y4Lpcq/hiNOfYo
         OpHSjT1bZHwNlGj0EGdqpp9dokSyN2xSa+I6UAOCDtqob9qZ8feBdBlGzoJqTt6js/DI
         ZPRnwPAiGEp9ocxHLGk0Ki96kZVVADVFhdcC55e9UbwSNoDXQxJYoHSbwej+SYLOJJ1w
         /VyhRAk1FOrW3wZVmWR3zjrKpE7//DZvH8fT/XUUssxy3kYFF5ydwrdNmq7S4PQb0ofA
         9S4A==
X-Gm-Message-State: AOAM533C5zl1gnj0iK+U9EEMqO6JpYOLBRsCSg21EP05lRXUZt0oGvzx
        loh672Rh1wcVRjQAVAQTaGmSbCN0q1lKAa2KHlXySGk0RduyBecdKdsTnwmOK15xVdicopJKPdI
        ZEeSTDPYn1iCfEPjJv1ErHw151nlTHLAblUnH5C/qMbM9Q4r0myeLEuy3yaOSeg==
X-Google-Smtp-Source: ABdhPJxyHUudWy1NYp/N8b6eKKKkk9EiTNiuow7ZaLf2G2NTFN8IF+TFATrnL0TqyK5NApAWp9Is+3Q5V9c=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a0c:ee41:: with SMTP id m1mr476956qvs.214.1597876842123;
 Wed, 19 Aug 2020 15:40:42 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:26 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-5-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 4/8] bpf/libbpf: BTF support for typed ksyms
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

If a ksym is defined with a type, libbpf will try to find the ksym's btf
information from kernel btf. If a valid btf entry for the ksym is found,
libbpf can pass in the found btf id to the verifier, which validates the
ksym's type and value.

Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
but it has the symbol's address (read from kallsyms) and its value is
treated as a raw pointer.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/lib/bpf/libbpf.c | 130 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 114 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4a81c6b2d21b..94eff612c7c2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -357,7 +357,16 @@ struct extern_desc {
 			bool is_signed;
 		} kcfg;
 		struct {
-			unsigned long long addr;
+			/*
+			 *  1. If ksym is typeless, the field 'addr' is valid.
+			 *  2. If ksym is typed, the field 'vmlinux_btf_id' is
+			 *     valid.
+			 */
+			bool is_typeless;
+			union {
+				unsigned long long addr;
+				int vmlinux_btf_id;
+			};
 		} ksym;
 	};
 };
@@ -382,6 +391,7 @@ struct bpf_object {
 
 	bool loaded;
 	bool has_pseudo_calls;
+	bool has_typed_ksyms;
 
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -2521,6 +2531,10 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
 	if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
 		need_vmlinux_btf = true;
 
+	/* Support for typed ksyms needs kernel BTF */
+	if (obj->has_typed_ksyms)
+		need_vmlinux_btf = true;
+
 	bpf_object__for_each_program(prog, obj) {
 		if (!prog->load)
 			continue;
@@ -2975,10 +2989,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 			ext->type = EXT_KSYM;
 
 			vt = skip_mods_and_typedefs(obj->btf, t->type, NULL);
-			if (!btf_is_void(vt)) {
-				pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
-				return -ENOTSUP;
-			}
+			ext->ksym.is_typeless = btf_is_void(vt);
+
+			if (!obj->has_typed_ksyms && !ext->ksym.is_typeless)
+				obj->has_typed_ksyms = true;
 		} else {
 			pr_warn("unrecognized extern section '%s'\n", sec_name);
 			return -ENOTSUP;
@@ -2992,9 +3006,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 	/* sort externs by type, for kcfg ones also by (align, size, name) */
 	qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
 
-	/* for .ksyms section, we need to turn all externs into allocated
-	 * variables in BTF to pass kernel verification; we do this by
-	 * pretending that each extern is a 8-byte variable
+	/* for .ksyms section, we need to turn all typeless externs into
+	 * allocated variables in BTF to pass kernel verification; we do
+	 * this by pretending that each typeless extern is a 8-byte variable
 	 */
 	if (ksym_sec) {
 		/* find existing 4-byte integer type in BTF to use for fake
@@ -3012,7 +3026,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 		sec = ksym_sec;
 		n = btf_vlen(sec);
-		for (i = 0, off = 0; i < n; i++, off += sizeof(int)) {
+		for (i = 0, off = 0; i < n; i++) {
 			struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
 			struct btf_type *vt;
 
@@ -3025,9 +3039,14 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 				return -ESRCH;
 			}
 			btf_var(vt)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
-			vt->type = int_btf_id;
+			if (ext->ksym.is_typeless) {
+				vt->type = int_btf_id;
+				vs->size = sizeof(int);
+			}
 			vs->offset = off;
-			vs->size = sizeof(int);
+			off += vs->size;
+			pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
+				 ext->name, vt->type, vs->size, vs->offset);
 		}
 		sec->size = off;
 	}
@@ -5300,8 +5319,13 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 				insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
-				insn[0].imm = (__u32)ext->ksym.addr;
-				insn[1].imm = ext->ksym.addr >> 32;
+				if (ext->ksym.is_typeless) { /* typelss ksyms */
+					insn[0].imm = (__u32)ext->ksym.addr;
+					insn[1].imm = ext->ksym.addr >> 32;
+				} else { /* typed ksyms */
+					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
+					insn[0].imm = ext->ksym.vmlinux_btf_id;
+				}
 			}
 			break;
 		case RELO_CALL:
@@ -6019,6 +6043,10 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 		if (!ext || ext->type != EXT_KSYM)
 			continue;
 
+		/* Typed ksyms have the verifier to fill their addresses. */
+		if (!ext->ksym.is_typeless)
+			continue;
+
 		if (ext->is_set && ext->ksym.addr != sym_addr) {
 			pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
 				sym_name, ext->ksym.addr, sym_addr);
@@ -6037,10 +6065,72 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 	return err;
 }
 
+static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
+{
+	struct extern_desc *ext;
+	int i, id;
+
+	if (!obj->btf_vmlinux) {
+		pr_warn("support of typed ksyms needs kernel btf.\n");
+		return -ENOENT;
+	}
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		const struct btf_type *v, *vx; /* VARs in object and vmlinux btf */
+		const struct btf_type *t, *tx; /* TYPEs in btf */
+		__u32 vt, vtx; /* btf_ids of TYPEs */
+
+		ext = &obj->externs[i];
+		if (ext->type != EXT_KSYM)
+			continue;
+
+		if (ext->ksym.is_typeless)
+			continue;
+
+		if (ext->is_set) {
+			pr_warn("typed ksym '%s' resolved as typeless ksyms.\n",
+				ext->name);
+			return -EFAULT;
+		}
+
+		id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
+					    BTF_KIND_VAR);
+		if (id <= 0) {
+			pr_warn("no btf entry for ksym '%s' in vmlinux.\n",
+				ext->name);
+			return -ESRCH;
+		}
+
+		vx = btf__type_by_id(obj->btf_vmlinux, id);
+		tx = skip_mods_and_typedefs(obj->btf_vmlinux, vx->type, &vtx);
+
+		v = btf__type_by_id(obj->btf, ext->btf_id);
+		t = skip_mods_and_typedefs(obj->btf, v->type, &vt);
+
+		if (!btf_ksym_type_match(obj->btf_vmlinux, vtx, obj->btf, vt)) {
+			const char *tname, *txname; /* names of TYPEs */
+
+			txname = btf__name_by_offset(obj->btf_vmlinux, tx->name_off);
+			tname = btf__name_by_offset(obj->btf, t->name_off);
+
+			pr_warn("ksym '%s' expects type '%s' (vmlinux_btf_id: #%d), "
+				"but got '%s' (btf_id: #%d)\n", ext->name,
+				txname, vtx, tname, vt);
+			return -EINVAL;
+		}
+
+		ext->is_set = true;
+		ext->ksym.vmlinux_btf_id = id;
+		pr_debug("extern (ksym) %s=vmlinux_btf_id(#%d)\n", ext->name, id);
+	}
+	return 0;
+}
+
 static int bpf_object__resolve_externs(struct bpf_object *obj,
 				       const char *extra_kconfig)
 {
-	bool need_config = false, need_kallsyms = false;
+	bool need_config = false;
+	bool need_kallsyms = false, need_vmlinux_btf = false;
 	struct extern_desc *ext;
 	void *kcfg_data = NULL;
 	int err, i;
@@ -6071,7 +6161,10 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 			   strncmp(ext->name, "CONFIG_", 7) == 0) {
 			need_config = true;
 		} else if (ext->type == EXT_KSYM) {
-			need_kallsyms = true;
+			if (ext->ksym.is_typeless)
+				need_kallsyms = true;
+			else
+				need_vmlinux_btf = true;
 		} else {
 			pr_warn("unrecognized extern '%s'\n", ext->name);
 			return -EINVAL;
@@ -6100,6 +6193,11 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 		if (err)
 			return -EINVAL;
 	}
+	if (need_vmlinux_btf) {
+		err = bpf_object__resolve_ksyms_btf_id(obj);
+		if (err)
+			return -EINVAL;
+	}
 	for (i = 0; i < obj->nr_extern; i++) {
 		ext = &obj->externs[i];
 
@@ -6132,10 +6230,10 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	}
 
 	err = bpf_object__probe_loading(obj);
+	err = err ? : bpf_object__load_vmlinux_btf(obj);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
-	err = err ? : bpf_object__load_vmlinux_btf(obj);
 	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
 	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
-- 
2.28.0.220.ged08abb693-goog

