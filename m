Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC9943539C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhJTTRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhJTTRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:17:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D003BC06161C;
        Wed, 20 Oct 2021 12:15:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j190so16644116pgd.0;
        Wed, 20 Oct 2021 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ihWK6EEqi4kGuUo9+ytnHk9crjtI937Vwkz9H7nKHoc=;
        b=WaQOIfO8h6JOrAXTVixH8D5VxLdj3P3Jj7n8kYPA0OPXomWiwIw4b5z0aGpLg9PxTw
         riul7RR00DCicrfPkck/ascI7Q2iFfTb/clRAxPWlgnswETMoQ0G4ExfA/nh9noDEH2h
         RvL2CdEhmJA10+t3SvyQa/V9n+mfFD13bomwfkV5FM9ug9yz/fnve5+cMAhhXde28ahy
         HlRhpLlWo7VWzvCwzo8gWuvmMBx4/TCvnmJNX60MGPwXBR6lAYNAOvGx0GJCI2mqEQNJ
         IPCckx7lCI3oekUf4IJZ59lBQqae37OuzDl/ehyPMcyM1nnIMC4dokRcnj5VJtAtQ2Aw
         RULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ihWK6EEqi4kGuUo9+ytnHk9crjtI937Vwkz9H7nKHoc=;
        b=YfYqZFHFtrvHf8F/dUkb7xvW9Ll1JZyd4I0ZAuD4sjmiLDvJswd4FCJ7VxY7BRopdB
         65Wo980PEUMOslYkx/abMS993mBKeVuhij3h21b37Djl7eQ3/V811c5+OYNTL2+InNLD
         5yvuXN9tKpAl4C56e4yRa17MqgJJhiErEyTbqsboVy3EpYa969LzkKXYRjh1lpNuWKUR
         VybqJ4joaQsxSxGR3OuuRsJ2FZ+tMyINJEIzzc95c7fBpedXt6vx7TUhKNsgcBA1VVNw
         pemrqM+6xqDzbK+cO/2Ed359CiHOvqIpeFVMLRU/JduCW+A0Z+uPw6jac6ruXw5KcN/H
         So1A==
X-Gm-Message-State: AOAM532eMWzDDcF+BrQsbt/EjC/+JLXa+XbGNmN6GWRHl2WmH4NTiJM/
        GTqtJuoNsFwCp+h3nipvHh4zVcF+cKMZPw==
X-Google-Smtp-Source: ABdhPJyjQ0dU7kEH0OJNLwatrhjxxgnSO8h5hFENHCU2A3NQteqmnq95DaRsXF2Df1ln9ZWDWmIhIg==
X-Received: by 2002:a05:6a00:214d:b0:44d:35e9:4ce2 with SMTP id o13-20020a056a00214d00b0044d35e94ce2mr639446pfk.13.1634757332152;
        Wed, 20 Oct 2021 12:15:32 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z126sm2961851pgz.55.2021.10.20.12.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:31 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 1/8] bpf: Add bpf_kallsyms_lookup_name helper
Date:   Thu, 21 Oct 2021 00:45:19 +0530
Message-Id: <20211020191526.2306852-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4895; h=from:subject; bh=1alFqsJ3vtRyLxpa0FtqITuaqYN1DwqYkdrkAsZ5N9E=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoeFntlrWjn+cIb82pS0pqkOahDGsEDK+19d6Hc Lm6ybtCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8Rysc7EA C1y8FgP5reXK421zA3P8dIJVMfwSlUDa++kyvd5PtZDkE7DfhOv0ewDcRY9J33tkJo058qDUrZDJb1 z1ZGtF1anTDjgYP8U1dXvnybnVaNtaIVsmyQFWlPcX/0I0DVnf1zwv4JQYZGOgmQUjJwG3M2FPn4QG 49sxkPNfLrAyZ5IQ75yBDwFB8MDaCwS+2oDub1Je1m9sRSaFVc3ynTNan2IUI0Xmjmmcgn5/I3Pdzk I/IXgAPV0zNlLizVBd0ykX/Zw4usm1RkeSKDkDoGe2xzW0UQcTAeadhjYM0a6Fm3M32qXNTjMFPhTh XFA0OYhDYc4ZD2YV7evEtLottVo+VLOAUdALFS/Zd0aF3AEnPMZtke/whfqMbd0ga7TOVc3uPBsDSK xmOPvnV5s93mH00OWpPOrO8XVcUm6wUZUPKQZtLk15R6X4rdtLMgM5I8onQiX5Pd4Su8xoV+gkT6TS tDzHQb8SLqLpUQPaufj/9odBerEGkVLeBxpfdfHVdZRiDD3/sgMKflRhmKFnuFkNMj10bpg0QOcfkm WYEYIgRWwBuBwH66Sh9v+ZUGIBdLVtwgUxmQAOmZ7CEbXsB0HaVj9MGfHBOPJi5A2HEATQYAhFo1UU 6x8WZpz4c0Gkvm4iJxtsz1Km0R+J9vKwqqw3IdilRlAwMkcwFjiGPS0xUOZg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper allows us to get the address of a kernel symbol from inside
a BPF_PROG_TYPE_SYSCALL prog (used by gen_loader), so that we can
relocate typeless ksym vars.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 16 ++++++++++++++++
 kernel/bpf/syscall.c           | 27 +++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 16 ++++++++++++++++
 4 files changed, 60 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d604c8251d88..17206aae329d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2107,6 +2107,7 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
+extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..03da5511e3bf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4909,6 +4909,21 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * long bpf_kallsyms_lookup_name(const char *name, int name_sz, int flags, u64 *res)
+ *	Description
+ *		Get the address of a kernel symbol, returned in *res*. *res* is
+ *		set to 0 if the symbol is not found.
+ *	Return
+ *		On success, zero. On error, a negative value.
+ *
+ *		**-EINVAL** if *flags* is not zero.
+ *
+ *		**-EINVAL** if string *name* is not the same size as *name_sz*.
+ *
+ *		**-ENOENT** if symbol is not found.
+ *
+ *		**-EPERM** if caller does not have permission to obtain kernel address.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5104,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..95214e536db6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4753,6 +4753,31 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
+{
+	if (flags)
+		return -EINVAL;
+
+	if (name_sz <= 1 || name[name_sz - 1])
+		return -EINVAL;
+
+	if (!bpf_dump_raw_ok(current_cred()))
+		return -EPERM;
+
+	*res = kallsyms_lookup_name(name);
+	return *res ? 0 : -ENOENT;
+}
+
+const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
+	.func		= bpf_kallsyms_lookup_name,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_LONG,
+};
+
 static const struct bpf_func_proto *
 syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -4763,6 +4788,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_btf_find_by_name_kind_proto;
 	case BPF_FUNC_sys_close:
 		return &bpf_sys_close_proto;
+	case BPF_FUNC_kallsyms_lookup_name:
+		return &bpf_kallsyms_lookup_name_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..03da5511e3bf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4909,6 +4909,21 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * long bpf_kallsyms_lookup_name(const char *name, int name_sz, int flags, u64 *res)
+ *	Description
+ *		Get the address of a kernel symbol, returned in *res*. *res* is
+ *		set to 0 if the symbol is not found.
+ *	Return
+ *		On success, zero. On error, a negative value.
+ *
+ *		**-EINVAL** if *flags* is not zero.
+ *
+ *		**-EINVAL** if string *name* is not the same size as *name_sz*.
+ *
+ *		**-ENOENT** if symbol is not found.
+ *
+ *		**-EPERM** if caller does not have permission to obtain kernel address.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5104,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.1

