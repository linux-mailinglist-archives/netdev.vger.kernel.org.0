Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE542B92C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhJMHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238458AbhJMHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:35:57 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C225C061570;
        Wed, 13 Oct 2021 00:33:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r201so1505348pgr.4;
        Wed, 13 Oct 2021 00:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4sMaKepunm7D7ExsKhyCEttPrTNDSDXbY1QY2PldzDQ=;
        b=nPy3or4k8hgJEb653PiL6cLTRBJGy03WZ0EamQw4EQ+nvche6cLTXPcQARUQbdDJJ/
         pE8VRVeK/YGsS1ReXliqBS4L0zCA8gGHEcpD7LIH8gDvizdPCPlH9A3qucFuqhfBU5i4
         SEpDLfpseK01u+fyQ/EsYA36CLi2SrIyslpZ7tXQZDQU54frT3A1xHCNj+mTGanQUiQG
         i6djuOrTz1WIzsHqLI767xyYhKN+rWpcW177Nc0Y8ehh6xjcAIYbZiX19edLX5oiNrs7
         tnBVDWcvnDtNlqPDmR1cBXWWEmhkEc5iKi1lFbLFXQyrfo6UFLwktU9Rw9YG47dU/A6o
         cusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4sMaKepunm7D7ExsKhyCEttPrTNDSDXbY1QY2PldzDQ=;
        b=IxFIitw+Pd06YnGi9XOynPPyS2Wql1jLvrfLTuAGe8kC3WGkA0H5qADKmmURsUmg3S
         ofmNalOPCik8YiVprcTK28nPrSoHSQL7Kf4lLETh67CqproR6CqhcCYrAwYryC68HgAX
         F9uEdcNBrK1CDxlrFXlIYR3Y358PZn37tdPcY2ATBuj/MxWJhL1Nz7000PLb+tuz7Kpv
         X2WGr+fbW6/4ztgXO1vl5pTPx+QVHipQrtvTjdxd10rWBJJ0rjKEPv9aQSlyVSj2Ra5+
         PGshLicJ2laXzoqCA4O9/2Il1asOgXtTyjPTIvNtWXq9GodaSgY2kHpi6T6rzrMukPL1
         j5wg==
X-Gm-Message-State: AOAM533nGIYH5f/4PTnVtJtaqZkTwdskdOe3GfAMZ+9jZg1ZyvsQfr1B
        TJ57NT3o0JITYsGS8Vrggv2/rnEL2QQ=
X-Google-Smtp-Source: ABdhPJwVkE9RrV5wXxP0YaJaTg5V26aHStbfXKD7Rs8bymbK0NJX7p0EplGlY9XHOasU2qwnBK8aVA==
X-Received: by 2002:a63:7404:: with SMTP id p4mr26057816pgc.222.1634110434698;
        Wed, 13 Oct 2021 00:33:54 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id d67sm12933918pfd.151.2021.10.13.00.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:33:54 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 1/8] bpf: Add bpf_kallsyms_lookup_name helper
Date:   Wed, 13 Oct 2021 13:03:41 +0530
Message-Id: <20211013073348.1611155-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4658; h=from:subject; bh=BIcEikbAfemgMwuib2UgEFcl8tWdyTD+kT9H5JhMbfQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSwpKy9TFjQr5maQ7oU4TgI8smj9AbJYb3Cf4V 8/+YKwKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8RyqZmD/ 9S2WEt9KofEH36QkRvkqPrOTCLXHRh6MNSkmHfC2G4vMEu91s7k6JhqhkE3QDv+JWDSuNIq31/2e3N 4KZYlSpoqJpKmOi2EPTwcmh1SC+GpE3aoKR0470ZShz3TImIuHFP1K+VtW+Pqb+U/oAz8MDPZk6aML VeoYKKLLa4YQH1k2/4oDwwE5vnmfI6ntfI+t5GGsBo1zbN+1BA3ONgCyBqeREySe8QRbTsO2chUJjF /haTdjoZF9PaH+RgtvYPhFirA8KhyDSHVTbDyvbXjeif72kLQg5RMtifEX/vP5wQiCa+NuCef+rU8o h5WajCi/UETQqItTPKkgMsBpxf3C6jH1haUDDvnWvUEwXuLuHP2GsKix8GEC204xqp5BG5rMWudd9x krTkdaxhOAgV3aQ+OwlbW9dx/cizsCj6fRdg6vray3PXoBzY+L0rz3nKSsVQbhQH9a3tRrKxIaxiH+ X7zDuaejr1a6M9G6+NvSnYPM8fjMa6Dj7lVsm2CTzb8ZuuGuBypFA81BkEcFFwgs/xxFZuaL7VGL62 WhcRz8PLxtcKRr7HCG2bzAN5VAEMDJF2Md91QG3K/aJZTirZCuoZYiBqUWBWWBU1fL6YctDGVZ/aeZ 6MOWaPGGvb3K5X0U1Aer180Xq8RuR0iasfWR8Qu3uC8Sv1CVpKMjH2LDrdTA==
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

