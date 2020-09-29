Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5EE27DCFC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgI2XvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbgI2Xu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:50:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C960C0613D7
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:50:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so6556584ybb.8
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=W9XBHhUFu+u4392g4jbQPWXhoBEabYN3bo91tMs1wPs=;
        b=FCf83Y4aWYyvOX4W3QxUs6ZWBNN6aa3+kyXmLE65Ftd0NPxrlFDqqW5y4UMlNpq8SW
         Eag8k3fRDKsUUXjhZMM61V7AmlmesV6vkK00S61DBZ/ABt6yfWacopSEfWdokuUMoGCL
         cNUxUdcVR0cl4QLsngBUlqCK/U1/EgQyiG8qQFFtwHXNDmX/RnsIVOvLElXRuojeeRiz
         Bq5cQMkS+r1XzrfyS5rp3D7yCfK81UJizuiil7pepYmhxuqGncL5MQCYb0AH7dzMb8eY
         ylDX+atGhQYdk7YHiGh98TWXvX6JUF04XK/I4IjeW213ovOofLd9L9uTFMicqZLxthW6
         Q+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W9XBHhUFu+u4392g4jbQPWXhoBEabYN3bo91tMs1wPs=;
        b=aZX0j5eogN5zlMb/xzyqyeeEGUhNwpwOk4XyqkfViI/JRsUZifbZ2o5EfxhwfBR/0V
         NuAxIw4zPDY6HXYIbSoH9pwMx8sKZ1TR1I6XrRhLQ6xh1ocp1Kf/sazmSmiE0k4Bumrr
         3foBD0WVDZN4tb4vkC1lQZxjbtzvf+OHwQbZ1Q1amsE7/xoppVoU6aTd05JFFQk+ImZO
         1cIUlcAHe3Qnt1q8RN7S36RkG1yF9S1g6DJUnKVxFg7c0/daFF8BJpYSTilP0e2BFew0
         Br4p0+PGGBDcZaasSiPyK2zt5xGj/Nq+Nys7OpLmGve5T3gE7/sC/gBCrJ2GSfbb8HDs
         31bw==
X-Gm-Message-State: AOAM532lmrGUrBX82pGjpocYN7OKMC4YgqUl2eungtdpYwSbpTCVLfRG
        0J4phDx8D1VsK5j0lILI0nH29vRzPmwAMZWqgRQ7umqPgXK2w9aZ8Ggmfnavj16hTyyygtwluxf
        2EUzHDAsx7hbO1m1SFwFokxvCYZgqZS0nVXxWmgIANWfDFM34PQfoOIPnqnLi/w==
X-Google-Smtp-Source: ABdhPJzXbfWCHOUlK5eRan67Zm6UkQUzA9XB+4fpv0GjUe0PfBJO1b+s778KQkZlYyiUSZFHCHc2IgPRGU0=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a25:58d7:: with SMTP id m206mr9362128ybb.225.1601423458692;
 Tue, 29 Sep 2020 16:50:58 -0700 (PDT)
Date:   Tue, 29 Sep 2020 16:50:45 -0700
In-Reply-To: <20200929235049.2533242-1-haoluo@google.com>
Message-Id: <20200929235049.2533242-3-haoluo@google.com>
Mime-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH bpf-next v4 2/6] bpf/libbpf: BTF support for typed ksyms
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
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/lib/bpf/libbpf.c | 112 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 99 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a4f55f8a460d..9b36c52b8511 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -390,6 +390,12 @@ struct extern_desc {
 		} kcfg;
 		struct {
 			unsigned long long addr;
+
+			/* target btf_id of the corresponding kernel var. */
+			int vmlinux_btf_id;
+
+			/* local btf_id of the ksym extern's type. */
+			__u32 type_id;
 		} ksym;
 	};
 };
@@ -2522,12 +2528,23 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
 {
 	bool need_vmlinux_btf = false;
 	struct bpf_program *prog;
-	int err;
+	int i, err;
 
 	/* CO-RE relocations need kernel BTF */
 	if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
 		need_vmlinux_btf = true;
 
+	/* Support for typed ksyms needs kernel BTF */
+	for (i = 0; i < obj->nr_extern; i++) {
+		const struct extern_desc *ext;
+
+		ext = &obj->externs[i];
+		if (ext->type == EXT_KSYM && ext->ksym.type_id) {
+			need_vmlinux_btf = true;
+			break;
+		}
+	}
+
 	bpf_object__for_each_program(prog, obj) {
 		if (!prog->load)
 			continue;
@@ -3156,16 +3173,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 				return -ENOTSUP;
 			}
 		} else if (strcmp(sec_name, KSYMS_SEC) == 0) {
-			const struct btf_type *vt;
-
 			ksym_sec = sec;
 			ext->type = EXT_KSYM;
-
-			vt = skip_mods_and_typedefs(obj->btf, t->type, NULL);
-			if (!btf_is_void(vt)) {
-				pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
-				return -ENOTSUP;
-			}
+			skip_mods_and_typedefs(obj->btf, t->type,
+					       &ext->ksym.type_id);
 		} else {
 			pr_warn("unrecognized extern section '%s'\n", sec_name);
 			return -ENOTSUP;
@@ -5800,8 +5811,13 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 				insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
-				insn[0].imm = (__u32)ext->ksym.addr;
-				insn[1].imm = ext->ksym.addr >> 32;
+				if (ext->ksym.type_id) { /* typed ksyms */
+					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
+					insn[0].imm = ext->ksym.vmlinux_btf_id;
+				} else { /* typeless ksyms */
+					insn[0].imm = (__u32)ext->ksym.addr;
+					insn[1].imm = ext->ksym.addr >> 32;
+				}
 			}
 			relo->processed = true;
 			break;
@@ -6933,10 +6949,72 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 	return err;
 }
 
+static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
+{
+	struct extern_desc *ext;
+	int i, id;
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		const struct btf_type *targ_var, *targ_type;
+		__u32 targ_type_id, local_type_id;
+		const char *targ_var_name;
+		int ret;
+
+		ext = &obj->externs[i];
+		if (ext->type != EXT_KSYM || !ext->ksym.type_id)
+			continue;
+
+		id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
+					    BTF_KIND_VAR);
+		if (id <= 0) {
+			pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
+				ext->name);
+			return -ESRCH;
+		}
+
+		/* find local type_id */
+		local_type_id = ext->ksym.type_id;
+
+		/* find target type_id */
+		targ_var = btf__type_by_id(obj->btf_vmlinux, id);
+		targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
+						    targ_var->name_off);
+		targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
+						   targ_var->type,
+						   &targ_type_id);
+
+		ret = bpf_core_types_are_compat(obj->btf, local_type_id,
+						obj->btf_vmlinux, targ_type_id);
+		if (ret <= 0) {
+			const struct btf_type *local_type;
+			const char *targ_name, *local_name;
+
+			local_type = btf__type_by_id(obj->btf, local_type_id);
+			local_name = btf__name_by_offset(obj->btf,
+							 local_type->name_off);
+			targ_name = btf__name_by_offset(obj->btf_vmlinux,
+							targ_type->name_off);
+
+			pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
+				ext->name, local_type_id,
+				btf_kind_str(local_type), local_name, targ_type_id,
+				btf_kind_str(targ_type), targ_name);
+			return -EINVAL;
+		}
+
+		ext->is_set = true;
+		ext->ksym.vmlinux_btf_id = id;
+		pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
+			 ext->name, id, btf_kind_str(targ_var), targ_var_name);
+	}
+	return 0;
+}
+
 static int bpf_object__resolve_externs(struct bpf_object *obj,
 				       const char *extra_kconfig)
 {
 	bool need_config = false, need_kallsyms = false;
+	bool need_vmlinux_btf = false;
 	struct extern_desc *ext;
 	void *kcfg_data = NULL;
 	int err, i;
@@ -6967,7 +7045,10 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 			   strncmp(ext->name, "CONFIG_", 7) == 0) {
 			need_config = true;
 		} else if (ext->type == EXT_KSYM) {
-			need_kallsyms = true;
+			if (ext->ksym.type_id)
+				need_vmlinux_btf = true;
+			else
+				need_kallsyms = true;
 		} else {
 			pr_warn("unrecognized extern '%s'\n", ext->name);
 			return -EINVAL;
@@ -6996,6 +7077,11 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
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
 
@@ -7028,10 +7114,10 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
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
2.28.0.709.gb0816b6eb0-goog

