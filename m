Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B140ADF6
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhINMjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbhINMjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146DCC061574;
        Tue, 14 Sep 2021 05:38:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id 5so8091113plo.5;
        Tue, 14 Sep 2021 05:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJfnGeMTrgzS5XEpdbIRzvfzOUWBznUfpOiCHuYJ/KY=;
        b=qf/VIJ8kfstOIS+6IQ5VCbUaijb4UOJFSXbZw9BYnDAh17hIDtKz4eZ463Vz0nGBpa
         Gfcv0FtRGR1QuHriFZ4a/fbIH8kDNJ7+cRv3hTE65wEnnxMdVfmvpo/ZoRwlKlWWWBO4
         JKOgTXtzhjzYtlhje1UuSxco4ePY0R0lp21z5T8F4Q2PWW25usSK+djSo3q3zeZeOB8b
         kSM/tetLsEC0LOO4LMyJsISdVE/+QO3JT8KogCW7V2BADCinmNOlyTlCMQPxwVuJqMWg
         hNQefEnpdQY6VpsFhV/MUidglC2A3PiMKlbXvGLwrhV4yTtAo1+pCAEsns/Kedm4uzPj
         fgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJfnGeMTrgzS5XEpdbIRzvfzOUWBznUfpOiCHuYJ/KY=;
        b=MgqXmUPEX0WfxPorLAk3EoKhHYcCCs/g1SUPQ50N8TgHznk5ToVQT7LNr1ElK7z/05
         NkmAlLrLm4HhwE2Ua9sGYXSJ9WSFCr3Y/xG1kKG9RklXvCzIcRgnflFYhFw+3qpKxgik
         4GR4ubFYwWJwrnaquAAyO2+Rh3wYBAXC9vGPP/mmAWg2h4fAiJybUjuaINHsP1XEerEd
         z1AxdjnXzFbFll6CZwrJAzMdOKEXg083+Yqz0gST/87+3ab+DTd73zvga89Kc8U6hWWj
         uZtcBX/ADnHBr5TH0bQ8wDhQhvxm37mqMfQsfOCQANJBwS1i3T4XWC1wxp8IDa/IGIlL
         PDHA==
X-Gm-Message-State: AOAM530Mqsgc6/RZGljugjJoIEeADM7FQf8d7012vsjQFvUcIBoKdCE3
        VcOugJ463GueyFa18r/TNUFC6NMJAlv5fw==
X-Google-Smtp-Source: ABdhPJxAQ752bpmvWdnqro9et2IqWmRyrg+zxzRfXOsdKNwhCTsEyk0aJd7L8ujfMVcuX3oXklbZRQ==
X-Received: by 2002:a17:90a:a791:: with SMTP id f17mr1834714pjq.225.1631623098138;
        Tue, 14 Sep 2021 05:38:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id gn11sm1616246pjb.39.2021.09.14.05.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:17 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 07/10] libbpf: Support kernel module function calls
Date:   Tue, 14 Sep 2021 18:07:46 +0530
Message-Id: <20210914123750.460750-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4871; h=from:subject; bh=/QTomyMTxP3ElJBV9UogAOv6leVi7U3issFhKkwHUR4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdW/clEWXeJqcK/WMVktGAjIwiMWAZqbaqmetId 8mYU4kGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVgAKCRBM4MiGSL8RyvpDEA CG5za7L8COw6VTi3JnFkspQoUWy9G1KWH6FEadoWwcixNdlKk9aX6pNBqngQVLL5tvUAF6fberk8Lh JyrTMXkj8UUHVSjwpSIYVskE8SVK8SYWPxnPZWhNI7+AMG34AHpQb27GTeqU5cvz2NDL76GvZwvEel KAJoyJ6oj6Ebkl4iXzZZs/hOYXZl+cAM/sRJHmwhBEp6yelfaa+4G8j830WaUxIGtm8SGCAvrTCFYw A+pr1XX+etCcTgmQk2RsvHgRlZO9eW3u+3NP4bzCUtQJuEVd9zPhC0RG3aKeGjxZsbsaaJ1VyxzVUZ 6HI7KgfmBBfWGSzJykxk/I5qvLQpz5MH6Eb+q6+L6h21c4ADjmUNXtreK5FX8kIeP3lPKpYsb1pnoC qpzxSlmCWZVYrI/JWbXr/b+8J/hlrCm2xpTeJ1UPtfnM7Iz6leBemxhSgsOAlfPj2AGH5H+AQXUW7p 6lHQEC780Gtz6gUoGiL/lTX61aKbpAvHlVWPyMd1wf1MoWw0HBtOdb3svhZCehOGbAtZnx6RLswx8o pf90UUWlJPG2f60yD5FXapZfMC3OTAiFmPSKJmBX6bOGokrwaTm+ZLEwUNpvj2Ns04ZN0J3wc11JIV vUvwe9PpywArlUDKZ5qKu3XI/McPKDOAcirqZeVlckcyemSs6KGI1qdLgebw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds libbpf support for kernel module function call support.
The fd_array parameter is used during BPF program load is used to pass
module BTFs referenced by the program. insn->off is set to index into
this array + 1, because insn->off as 0 is reserved for btf_vmlinux. The
kernel subtracts 1 from insn->off when indexing into env->fd_array.

We try to use existing insn->off for a module, since the kernel limits
the maximum distinct module BTFs for kfuncs to 256, and also because
index must never exceed the maximum allowed value that can fit in
insn->off (INT16_MAX). In the future, if kernel interprets signed offset
as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             |  1 +
 tools/lib/bpf/libbpf.c          | 56 +++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..7d1741ceaa32 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -264,6 +264,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	attr.line_info_rec_size = load_attr->line_info_rec_size;
 	attr.line_info_cnt = load_attr->line_info_cnt;
 	attr.line_info = ptr_to_u64(load_attr->line_info);
+	attr.fd_array = ptr_to_u64(load_attr->fd_array);
 
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ecfdc1fa7ba..e78ae57e4379 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -419,6 +419,12 @@ struct extern_desc {
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
+			/* offset to be patched in for insn->off,
+			 * this is 0 for btf_vmlinux, and index + 1
+			 * for module BTF, where index is BTF index in
+			 * obj->fd_array
+			 */
+			__s16 offset;
 		} ksym;
 	};
 };
@@ -515,6 +521,10 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	int *fd_array;
+	size_t fd_cap_cnt;
+	int nr_fds;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -5333,6 +5343,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6127,6 +6138,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	if (prog->obj->gen_loader) {
 		bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
@@ -6729,9 +6741,44 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	}
 
 	if (kern_btf != obj->btf_vmlinux) {
-		pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
-			ext->name);
-		return -ENOTSUP;
+		int index = -1;
+
+		if (!obj->fd_array) {
+			obj->fd_array = calloc(8, sizeof(*obj->fd_array));
+			if (!obj->fd_array)
+				return -ENOMEM;
+			obj->fd_cap_cnt = 8;
+		}
+
+		for (int i = 0; i < obj->nr_fds; i++) {
+			if (obj->fd_array[i] == kern_btf_fd) {
+				index = i;
+				break;
+			}
+		}
+
+		if (index == -1) {
+			if (obj->nr_fds == obj->fd_cap_cnt) {
+				ret = libbpf_ensure_mem((void **)&obj->fd_array,
+							&obj->fd_cap_cnt, sizeof(int),
+							obj->fd_cap_cnt + 1);
+				if (ret)
+					return ret;
+			}
+
+			index = obj->nr_fds;
+			obj->fd_array[obj->nr_fds++] = kern_btf_fd;
+		}
+
+		if (index >= INT16_MAX) {
+			/* insn->off is s16 */
+			pr_warn("extern (func ksym) '%s': module btf fd index too big\n",
+				ext->name);
+			return -E2BIG;
+		}
+		ext->ksym.offset = index + 1;
+	} else {
+		ext->ksym.offset = 0;
 	}
 
 	kern_func = btf__type_by_id(kern_btf, kfunc_id);
@@ -6907,6 +6954,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up fd_array */
+	zfree(&obj->fd_array);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 4f6ff5c23695..4a948318aa89 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -289,6 +289,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
-- 
2.33.0

