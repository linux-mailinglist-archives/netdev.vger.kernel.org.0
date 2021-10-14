Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1044642E2EC
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhJNU66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbhJNU65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:58:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AE9C061570;
        Thu, 14 Oct 2021 13:56:52 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m14so6513855pfc.9;
        Thu, 14 Oct 2021 13:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4sMaKepunm7D7ExsKhyCEttPrTNDSDXbY1QY2PldzDQ=;
        b=LqUriUjKcUWQIY3Mk4ramx66Td9Um5v3KJvFyRpqpuGvwxJ6H49L35s9HYTZDBxszE
         idFTHHu1pYdVTM2M3HliCNa3UIiaSiGa0ertJ3AVCQbRFsBPB8ozyv1kifPxb6B8Y3SH
         FnKX4nY+gEqJ9vcphQFjYKCX/ZgKqcOAu8HXtsqRfadFgumr2Y/H5k+0dIEb9iOzbIB5
         7l4V20bYVFujEmx8uxHt7rGiBOTA5dwXySmtcdvSXhf6JA2WDis4nBuyUoBNGcqVVjh8
         cjVWoA9h9T8N2lqO3soYSruyxGpZxPIMEGmhlCqNk323wNfuy/gyNNxFY3O0U7Q5fIED
         x12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4sMaKepunm7D7ExsKhyCEttPrTNDSDXbY1QY2PldzDQ=;
        b=l5GIHdzWR28ZlOb/oNhhbFxXTdnykG9UWC239wWe74fc1MYjdqQs3Y0sG6vkHK8XkV
         4flsrZRfcTT+OgatsNh/zQRdqVuvmA5QKKWINgUwWPVK6i/UFCGJKJxSsznCsurQGa2s
         Jx0WAczI3g7RJhF9LNKCvHRnAqsdcO7qTTcEpluqJJRSGSQYczE1caNHuWTfyXhQNo3e
         4ylpUXUOmWfPdS9U2/phcKhegOs+W017HYOTSqJqTifpmlL4dmgAImCZ/4ZyCKeMa5nW
         A7eikAmcKdIGHkb9t8a/UCUBlUHgRkHurL+EFyifJq6FBBjKFfWU1Vu3g71h3A4SzHMQ
         lCnQ==
X-Gm-Message-State: AOAM5304RP02rsbN83yQBlaAgX77OZbegOfoczYh82UDkZou+8isT0nu
        9c7b6RJ/LBUOZ95fQO8859CxSOPRKc4=
X-Google-Smtp-Source: ABdhPJwX9MXkI0vVX4Qb7/WKwvhY0DzWYOpT4nd7S1ufZHeRLqDd27wMN+WeYa9unsrXUwl06/alZA==
X-Received: by 2002:a05:6a00:48:b0:44c:f5d3:8549 with SMTP id i8-20020a056a00004800b0044cf5d38549mr7730069pfk.5.1634245011094;
        Thu, 14 Oct 2021 13:56:51 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z71sm3544382pfc.19.2021.10.14.13.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:56:50 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 1/8] bpf: Add bpf_kallsyms_lookup_name helper
Date:   Fri, 15 Oct 2021 02:26:37 +0530
Message-Id: <20211014205644.1837280-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014205644.1837280-1-memxor@gmail.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4658; h=from:subject; bh=BIcEikbAfemgMwuib2UgEFcl8tWdyTD+kT9H5JhMbfQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/wpKy9TFjQr5maQ7oU4TgI8smj9AbJYb3Cf4V 8/+YKwKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8Ryg5FD/ 9BPKMdoY6+OaugZiaksGYzPEbI6g34NA8qX6BZ4HnQQaYINU18r0cXOAZLijgQEyXjt2KSRnXWjdAi BFuZSwmm/E7VqkqOJWviwQXpklDOJ0tEs5HOu1kfr5MZBdMkI63YGJ2neP1scrvEiurKMhaQ12+/nG njOXKlJCw6xYhZU1t7FPvLW9Ce0ytTj/H9CBGSXk8tr4jHG5Mm0HMTn2U0tO9FsF+GI8DzV611X4U/ PnmRo/ApNJhnqHIRkaMCXV8Jc037ske+nIgkYA3KpDDF8JL43o7Vu+545292HoLUJxEc+p40c6sWL2 3sfbVN2Z1TXLOOu45Q5+jJDfiUF44hiR0lXV6nUSWpXpiGNU25nMdvyd22F5YJ44KYJ2mMaLOaCKpj bEYECMDsV1lADZYWt4l94XXX5gfjWLZBMOLPgaJq2CrpJ6b/BzybtWOk1hHfv3LIiQo4rP7sAwRvpG Vxc7XI755QHAjAnswLh8TI/uNMb0GIDj53f74eh/lwMnvDs4px31bkVwZk0Hw8VVfDd3wgRzItQKYV AFOm7WKUQ+CWGSaHIUFGheisCW0ReejTZJvy0qseYl2ufT6XzGZ5ekL8bxL4DtukyROc6/hp0bUEFB 5+9cXwQ5jQM94wq3ma/zP0IbrumZqO3AzzkKx57oXjsVrN7Xos3skUA9dueA==
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
 include/uapi/linux/bpf.h       | 14 ++++++++++++++
 kernel/bpf/syscall.c           | 24 ++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
 4 files changed, 53 insertions(+)

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
index 6fc59d61937a..bbd0a3f4e5f6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4909,6 +4909,19 @@ union bpf_attr {
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
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5102,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..073ca9ebe58b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4753,6 +4753,28 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
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
+	*res = kallsyms_lookup_name(name);
+	return *res ? 0 : -ENOENT;
+}
+
+const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
+	.func		= bpf_kallsyms_lookup_name,
+	.gpl_only	= true,
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
@@ -4763,6 +4785,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_btf_find_by_name_kind_proto;
 	case BPF_FUNC_sys_close:
 		return &bpf_sys_close_proto;
+	case BPF_FUNC_kallsyms_lookup_name:
+		return &bpf_kallsyms_lookup_name_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..bbd0a3f4e5f6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4909,6 +4909,19 @@ union bpf_attr {
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
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5102,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.0

