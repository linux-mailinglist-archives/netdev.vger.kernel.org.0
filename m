Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCB64116A2
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbhITORY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240109AbhITORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC72C061760;
        Mon, 20 Sep 2021 07:15:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 203so8518474pfy.13;
        Mon, 20 Sep 2021 07:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRGphm3b+XT9QQT+YO+BQZpkTXn1fo620/l+VWTepmA=;
        b=aANnd5bu86kFqZyct/nKh3nZLFuVgp3QdXLZ3+0NiSekm5aLqG09/3Vg8PaQvdoLnj
         DCCBwF4wKvnnKx7p2SGn9N1qotSec4Mig+mBFh7NIYPXmGj90CWmjSyuSW4k4Irrt8sy
         y8O5JLwpAjz2vzE4pl30B0zDVvv76nG7rLlFQLbNkfbwnr6ClPl0VI2wYFkoOcXEG2JI
         fj03xgfOwEz9KDee0XeueoE2EO1opGu1kHVrVtSSqT/740TFXXFPEwqzWRTEM13hxH3T
         SQff7fY7x8q2k2NLi4upjFgIr+pgPK73K1pch3iko/FyruzyigtCpJJZb0iw5bHX32jd
         sDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRGphm3b+XT9QQT+YO+BQZpkTXn1fo620/l+VWTepmA=;
        b=7no1/+Kr/hgohVQrZETGhkVbtyY8E1t0vgRVyrG9LJ7cbir478OfDky6kxOgn6iZRB
         UuOtBI8i2tKRvk0gD1N0wfTz0wa8faWzJa4toEqUF0SwPROeHckMK7PxOikDAXyrFNGS
         07nzJgNdSo8f0IRRlb+NcCRkeXyqzYPF4oY3+9aLEzWmtvQxzF5IxNDOdvcZiY2cP4Mx
         S1dvoBqhnG8oPmTfDM63iLfp2VzDBXq2xAA6jJhTCTICAlbcjyRWpVoxxAZKZG5bxBuF
         LBvGWQ92MShCtJBge8w/3TnPPaIWj+qPSqRWGIZhmEmP6HTb2bcViOtH6yBFyTkDOEah
         UGAQ==
X-Gm-Message-State: AOAM531cUnFbUAorR/zJ25zcrFP1GhiqM1pceHCB12tbjPXmlKrOPblv
        yjJVn4gk6y9L2HtKuF1gkQnq1pdoE3j2+Q==
X-Google-Smtp-Source: ABdhPJy7ARAbSva0OXWwMgurIYfCzz+mX9PFRBF+qIQK8K+eYl5LAxDCmohMQoi+fU9EtB+MTpcXww==
X-Received: by 2002:a63:2b4b:: with SMTP id r72mr2579896pgr.57.1632147350453;
        Mon, 20 Sep 2021 07:15:50 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id h15sm2392715pjg.34.2021.09.20.07.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:50 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 06/11] libbpf: Support kernel module function calls
Date:   Mon, 20 Sep 2021 19:45:21 +0530
Message-Id: <20210920141526.3940002-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4883; h=from:subject; bh=NzeLk3EBOD7kX+YzOxCmipgaRdkG/mH0QJLLStwF1Y0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaEVy6AuHGJjWhyXdSSiK9J799QWgbPiW0OO2Yr ykXEGWmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8Rym0kD/ 9BEsAen1zi7NqZgAnfqTZQCWPoMZk6ZR2W2wTbBafhB/AbIlKvyWXlrVnBtBLoRS282yBs9zJgZnmF M6JZWr+to5h9NStXRwUK58bMC3gUc/Qcq5ni9HQS0DL0+viFA2+ZcX4LmPRCT6vqueL3NFZ26frMQX nXjRXEuhe4NLVl3V1Yla7KUvQSzmD64Wg6A8n3ypmPAoDTzgT/BYtgYlUXhaZUggoMjMLLS6DMUUuH PHPG4MIoDvjhCOLOF9wNud63P0PX/MlH2rKqg61UtFIbCDd1FbNV1j2Die9SQ4RDgh5qcYPD/2ecav oChhG42azgp20W6YMRsq47/B0TrDi7xReVzt0VWEEaQWSeXGW+xjj0CUzqsc9w3S3Hjyyinw+yT5Ip Vh4EmaqksDdQnOWHaX25A7Tuif59ZEclKVLRM0CG/d/0w5VT0eA7J3uOjqGV8qGo88UoFXbNzX8hSN hYgOXXwW9qioPpS0N5RGnKo95F03nVVMipoO0pSJWFICAHhEGbEuagutRfvlwR3qSMbTRYj3TILytf MrwTm/52cy8ignPtj4LrbiUSou2QA8FAwU+SBZXAu6v99p++C6t1D2F/NKF/JKMWRfW/Z9bWhBumWi lfM5G9GIMfd1BxbfqZKmU7AZX4WJ7XvfOOUDITN7A1OBuOpkBQ/QNEH+tUSw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds libbpf support for kernel module function call support.
The fd_array parameter is used during BPF program load is used to pass
module BTFs referenced by the program. insn->off is set to index into
this array, but starts from 1, because insn->off as 0 is reserved for
btf_vmlinux.

We try to use existing insn->off for a module, since the kernel limits
the maximum distinct module BTFs for kfuncs to 256, and also because
index must never exceed the maximum allowed value that can fit in
insn->off (INT16_MAX). In the future, if kernel interprets signed offset
as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             |  1 +
 tools/lib/bpf/libbpf.c          | 58 +++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 57 insertions(+), 3 deletions(-)

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
index da65a1666a5e..3049dfc6088e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -420,6 +420,12 @@ struct extern_desc {
 
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
@@ -516,6 +522,10 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	int *fd_array;
+	size_t fd_cap_cnt;
+	int nr_fds;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -5357,6 +5367,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6151,6 +6162,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	if (prog->obj->gen_loader) {
 		bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
@@ -6763,9 +6775,46 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
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
+			/* index = 0 is for vmlinux BTF, so skip it */
+			obj->nr_fds = 1;
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
+		if (index > INT16_MAX) {
+			/* insn->off is s16 */
+			pr_warn("extern (func ksym) '%s': module btf fd index too big\n",
+				ext->name);
+			return -E2BIG;
+		}
+		ext->ksym.offset = index;
+	} else {
+		ext->ksym.offset = 0;
 	}
 
 	kern_func = btf__type_by_id(kern_btf, kfunc_id);
@@ -6941,6 +6990,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up fd_array */
+	zfree(&obj->fd_array);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index ceb0c98979bc..44b8f381b035 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -291,6 +291,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
-- 
2.33.0

