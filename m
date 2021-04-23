Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053453689CF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhDWA1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWA1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FBFC06138B;
        Thu, 22 Apr 2021 17:27:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so307208pjb.4;
        Thu, 22 Apr 2021 17:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6yT1ByoX159U3vaGMBYzet+3E76VUkccZqjOF7M8F8U=;
        b=DwVqyIlY9LhTDrGvxPtEeSlfUUfVqx7o4+9XC+CVHT8ghOARzO/Jl0uAXdFl0qMpMK
         HHFDlI8pDZltwSVUbJ1lH1+qE2GwqRciD90VEHVJhmj0SiqZnF3deUqcg9dnUfHjagBs
         rLr3Gz+wjZ9AQVep5F6566A+NGCRwME7pyCriD4kARMJ/iDPA7QMgNtimbqjkpAXaDvM
         C8+7X+lCIgNZLlGFQJqSWIfK+KMDR6AR+NtHJRcbN09jNfO1BNk1MlUBkRGXW5j3P32J
         /lzWf+prspFGfBv4h8U+mzH62ZKIpZ6tmmBiWgZJFI/3HGm0OhPocqFnPyEl7MbpfXa2
         1R7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6yT1ByoX159U3vaGMBYzet+3E76VUkccZqjOF7M8F8U=;
        b=PJbJ8+/0JBemdQp+tXejKd4rhrb4vNrArKOF+Wl/6Pi0ZRIn1Jxs5YL/1r+nbVTTsH
         rmI+bePsBwskOWS3HC8meWcrT5iI77yDXdtIZphIDiD2OctYkTVDou9n37rGGrbzQbra
         7xChKBtUIJuITEQhl7jGaJcKj6SWuOgq6Fh8FA0Wvgcw2405trkcTT2lboRXsmpUCJXv
         hV/SG/4ph/p0yU3xQtRhhZXopc2mUVrEBdyrnS5sN5K7mQlMNAEwkhLX6GRen91fpjfi
         G6WH/ciut1GERopyZdWqXynGHKiam7bLq24vaFIw2hhzhEKW0UW2HjN3NHLwSiwnnxNE
         FemQ==
X-Gm-Message-State: AOAM532/LkHanQjK1aIEQXvzyfRG3Kd5ITsFOQ6pTMTFULqShJ4okfkK
        KkSRpfTeY/KcoM2zw3gAaZIQGD89OvA=
X-Google-Smtp-Source: ABdhPJwj+Be6xAfmHQ2LZ/5ZkqvMxLf+fA7I2YZxl/A3KfSP0AiJgjn6Q6Q4EQNwAkjLft8QVS6JCw==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr2768060pjq.67.1619137621001;
        Thu, 22 Apr 2021 17:27:01 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:00 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 09/16] libbpf: Support for fd_idx
Date:   Thu, 22 Apr 2021 17:26:39 -0700
Message-Id: <20210423002646.35043-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add support for FD_IDX make libbpf prefer that approach to loading programs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/bpf.c             |  1 +
 tools/lib/bpf/libbpf.c          | 70 +++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index bba48ff4c5c0..b96a3aba6fcc 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -252,6 +252,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 
 	attr.prog_btf_fd = load_attr->prog_btf_fd;
 	attr.prog_flags = load_attr->prog_flags;
+	attr.fd_array = ptr_to_u64(load_attr->fd_array);
 
 	attr.func_info_rec_size = load_attr->func_info_rec_size;
 	attr.func_info_cnt = load_attr->func_info_cnt;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 254a0c9aa6cf..17cfc5b66111 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -176,6 +176,8 @@ enum kern_feature_id {
 	FEAT_MODULE_BTF,
 	/* BTF_KIND_FLOAT support */
 	FEAT_BTF_FLOAT,
+	/* Kernel support for FD_IDX */
+	FEAT_FD_IDX,
 	__FEAT_CNT,
 };
 
@@ -288,6 +290,7 @@ struct bpf_program {
 	__u32 line_info_rec_size;
 	__u32 line_info_cnt;
 	__u32 prog_flags;
+	int *fd_array;
 };
 
 struct bpf_struct_ops {
@@ -4181,6 +4184,24 @@ static int probe_module_btf(void)
 	return !err;
 }
 
+static int probe_kern_fd_idx(void)
+{
+	struct bpf_load_program_attr attr;
+	struct bpf_insn insns[] = {
+		BPF_LD_IMM64_RAW(BPF_REG_0, BPF_PSEUDO_MAP_IDX, 0),
+		BPF_EXIT_INSN(),
+	};
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+	attr.insns = insns;
+	attr.insns_cnt = ARRAY_SIZE(insns);
+	attr.license = "GPL";
+
+	probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
+	return errno == EPROTO;
+}
+
 enum kern_feature_result {
 	FEAT_UNKNOWN = 0,
 	FEAT_SUPPORTED = 1,
@@ -4231,6 +4252,9 @@ static struct kern_feature_desc {
 	[FEAT_BTF_FLOAT] = {
 		"BTF_KIND_FLOAT support", probe_kern_btf_float,
 	},
+	[FEAT_FD_IDX] = {
+		"prog_load with fd_idx", probe_kern_fd_idx,
+	},
 };
 
 static bool kernel_supports(enum kern_feature_id feat_id)
@@ -6309,19 +6333,34 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 
 		switch (relo->type) {
 		case RELO_LD64:
-			insn[0].src_reg = BPF_PSEUDO_MAP_FD;
-			insn[0].imm = obj->maps[relo->map_idx].fd;
+			if (kernel_supports(FEAT_FD_IDX)) {
+				insn[0].src_reg = BPF_PSEUDO_MAP_IDX;
+				insn[0].imm = relo->map_idx;
+			} else {
+				insn[0].src_reg = BPF_PSEUDO_MAP_FD;
+				insn[0].imm = obj->maps[relo->map_idx].fd;
+			}
 			break;
 		case RELO_DATA:
-			insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
 			insn[1].imm = insn[0].imm + relo->sym_off;
-			insn[0].imm = obj->maps[relo->map_idx].fd;
+			if (kernel_supports(FEAT_FD_IDX)) {
+				insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
+				insn[0].imm = relo->map_idx;
+			} else {
+				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+				insn[0].imm = obj->maps[relo->map_idx].fd;
+			}
 			break;
 		case RELO_EXTERN_VAR:
 			ext = &obj->externs[relo->sym_off];
 			if (ext->type == EXT_KCFG) {
-				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
-				insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
+				if (kernel_supports(FEAT_FD_IDX)) {
+					insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
+					insn[0].imm = obj->kconfig_map_idx;
+				} else {
+					insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+					insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
+				}
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
 				if (ext->ksym.type_id) { /* typed ksyms */
@@ -7047,6 +7086,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.attach_btf_id = prog->attach_btf_id;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
+	load_attr.fd_array = prog->fd_array;
 
 	/* specify func_info/line_info only if kernel supports them */
 	btf_fd = bpf_object__btf_fd(prog->obj);
@@ -7239,6 +7279,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	struct bpf_program *prog;
 	size_t i;
 	int err;
+	struct bpf_map *map;
+	int *fd_array = NULL;
 
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
@@ -7247,6 +7289,16 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 			return err;
 	}
 
+	if (kernel_supports(FEAT_FD_IDX) && obj->nr_maps) {
+		fd_array = malloc(sizeof(int) * obj->nr_maps);
+		if (!fd_array)
+			return -ENOMEM;
+		for (i = 0; i < obj->nr_maps; i++) {
+			map = &obj->maps[i];
+			fd_array[i] = map->fd;
+		}
+	}
+
 	for (i = 0; i < obj->nr_programs; i++) {
 		prog = &obj->programs[i];
 		if (prog_is_subprog(obj, prog))
@@ -7256,10 +7308,14 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 			continue;
 		}
 		prog->log_level |= log_level;
+		prog->fd_array = fd_array;
 		err = bpf_program__load(prog, obj->license, obj->kern_version);
-		if (err)
+		if (err) {
+			free(fd_array);
 			return err;
+		}
 	}
+	free(fd_array);
 	return 0;
 }
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 6017902c687e..9114c7085f2a 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -204,6 +204,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
-- 
2.30.2

