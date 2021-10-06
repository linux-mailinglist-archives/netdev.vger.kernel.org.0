Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA224234F0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbhJFAaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbhJFAav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:30:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503CEC061749;
        Tue,  5 Oct 2021 17:29:00 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m14so871799pfc.9;
        Tue, 05 Oct 2021 17:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBSHnmxpgcVzNICL2o7nU9ev7SyKN2x4XxRSRTTs49Y=;
        b=JV5doS18wjAWJHMvK8zcBXAILGVgwJk0PELUUVvg9aJPiCqZLmp8jKAe851KaCW9/B
         pHT5CHR9dP4aYcckMCHQR4js5naQYmdyUVBtB4eXWTLvLiDmtf1yF/c9Q3QItaVkNkAd
         Kxo59bv1WqNykC/3YZRGNq35Khu86dwu6tDMsuC0EZ28ZQhkLjjDE60b0YMT6T7ZO0m3
         t0lDp5rQ6L+QbPhbJg3EYazZl9JGWU9SnH2ifYGXOm93lGvpIMfdYAzHS2yFseoGjgWZ
         qqWrJnSMS9H+5u/b7Uqwle2BDXc2Nr+80iSeTwSm2UMTvis7AIicFZCxnRDAqLucANdo
         D4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBSHnmxpgcVzNICL2o7nU9ev7SyKN2x4XxRSRTTs49Y=;
        b=rBDTDYXIzxIRsajK4jqOUMWTmnhuSnpbDiu+HmaMhi2eL84Vo7XwyIDCE+qXBmI8tS
         we76IJjQK7pv48EBfzT8x9bcKLjBX8N8/6NOyQi0oQ1565eRQPlfdcmibUk66eCe3YlI
         Fsha0tnZk5qpJ/7LYPSoY3tXQzIZg+S7e2OXrKdNLWDwqcd/z1m2BvRIHhzWkM6ynbps
         9aBbgCTFznVFy7qAj4J1U25YCmGvolaiyMSiLBE4mCPepDsVzChNUJLAek+m54jJxVSA
         SJcs5KoyKpfHsfqapGlcWSrcWEdmzC/sqdLJtyMKzGVLgqqHCCDKgOkvhaCL8sSKET22
         dnWw==
X-Gm-Message-State: AOAM5314gSAMnRSZfWG4orBHa63/TCKCa5WctnbfghAw7uo5liibvsGS
        UkRsxD3bmhVs1NsXfhTKJYQ3RxIqSo0=
X-Google-Smtp-Source: ABdhPJxJqDkALKpiDadPHSbFQIxO7mPTdgKqDcpxqbOrAbP75fgGr2Niw2wz2JWWjDSx7E16ZlCWYA==
X-Received: by 2002:a63:f749:: with SMTP id f9mr17811128pgk.77.1633480139666;
        Tue, 05 Oct 2021 17:28:59 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id e6sm3393392pfm.212.2021.10.05.17.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:28:59 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 1/6] bpf: Add bpf_kallsyms_lookup_name helper
Date:   Wed,  6 Oct 2021 05:58:48 +0530
Message-Id: <20211006002853.308945-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4623; h=from:subject; bh=qZbR9WNQ0ZlHNxJ/lEWKq/Wg1g1idI3u1N6c55dzyKI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxPCBzWz8TbxGxoblvl3YLe3HjIklPVIOXl6ZZd /U0fs1CJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsTwAKCRBM4MiGSL8Ryq+REA C6K6f3HZwnmGv4Cp7EpWHh1dZy/M7SdupNOfnZ4zn6vhW085KZaL6sbIv2RLV10V/DQPdM2bg6RthK Dy5nIKg9IY+Zr/qx1spTJ44BTiJ+y4+v5OUSHOevsFf0Q3CKlZFlKeBablFnT0M/NC8zE67AoeB0wy DtYFyjp42xEbjFKgoFz7yuWy5xoo4Wsaze25euz0PzmoHFoFaD2d66Ny7s37SP/k3oobbOz94g36VP gTHkN2K018vfiYCmkDEDOUPOQa9kbl6LlBonxy1hKMjdmigHWLzz7dn2cj1CqHmQoqlM9bLm1G5evW dKTY6NTsa4eMq1of83mS5ChMZ5AQggWfn1aUkKVAXLze/NuyzX7HpY/CdtBGeJ0ZqrtvdQTVbX7l8d bwJ04g/atpSlVBBuaeqpEjzNNYP+GtISGkKt8J7oY398Fch6I3BXlOh2rMz9+6VlLve338kCTjhY1l Dyn5KxSI2B0Y13HBOlYU2S448RzPN03wrpaJ3tqoKKHu2sXowMjW9W4qc5RDaRLkEh99QTnIwDzfU8 /iXr27PH6u9c/hqcdD77BcJtdnlNBep5RI+n2M53LOUjRPnQDWQZVLXbg/TaGdVGlPhAVvSfvLD+o5 u9tjvSDH60D2G7RFSgjaQTbxN3lY9+UJu0PKUP3ee5x9wok2oCNW4g+ozjWQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper allows us to get the address of a kernel symbol from inside
a BPF_PROG_TYPE_SYSCALL prog (used by gen_loader), so that we can
relocate weak and typeless ksym vars.

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

