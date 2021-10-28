Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB543DB3A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJ1Ghg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhJ1Ghe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:37:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2BCC061570;
        Wed, 27 Oct 2021 23:35:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h193so5465974pgc.1;
        Wed, 27 Oct 2021 23:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RdTRywDT/KGW4z9SKT4eBMXzCHQqTGMxBHoDkwyw1mQ=;
        b=KLgxcfHqDBx6fB2lOBT9Gpoxjj4fxzXUAij5cBcSljDZB1vkuKENXI8ivSmxpizmp4
         sBMzCRh4PKI89ph7rniKloZdy917mmtOnOosLKClBFJjcA1+k5lSmCPCCvZBSqIvxeyi
         Y3d6tNEkU2Dl4q3ot1nv1Ui6+1lfS16WVLi3ojPPe8m+GNtfctLtvDhxydAD9F+U7mHf
         tivON3It4lIR5fBpywKGhHLwetXfI3XAY4Ii+7LN4D0mXRDSUzYfuoTqY5MWddmBGBKP
         jwAxVMGQCAgtO8QGBHz7WkTtjYUGz8aixnCzJkJOIkEPPnZo4y/P5rK1V8Z5yL+SfLPK
         PCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RdTRywDT/KGW4z9SKT4eBMXzCHQqTGMxBHoDkwyw1mQ=;
        b=iZxpCd8q6AuIw1XPSWEVSzEg7SEyLeYKxwx8K7rgNmmYYr86O0gMiZy9oF6ukjH9EA
         yj83EqVjDrEeKSYufotm5S8IyQs5MrXl7wjMG5KHOvqt4qUf6xblb/vMXfCOHQTr9zVs
         VplBOuRn/h2E1HHdDBg1RtWUWwbOvPXOSgbnUAhi715m6soz/UN2u5ZdRzx4Ir6lO2jC
         MSkEEqKoyf9eqoBmHc0OACvn3DBTvKP1dh+vUsWW8lEdNs4GSqI9HPP1LDm3jcpzsSnd
         JANFxVFtLkA41+R/JEs+wvuXuEVcG9tzDw+076rZw/68ERDDCegTKyY7ajPkjVVD72ej
         7yUw==
X-Gm-Message-State: AOAM532UoDBWI8FwwIVXm7e5apRslBzjvQDSUI31ufo4j1Xe7E2yRaYo
        /QCTaUyh4RXyQWywmkbw5jLPmk3l6jYwrw==
X-Google-Smtp-Source: ABdhPJxi1VJStoUruYe5ehw7xsb1tpZW1wRC1NXF421vZun7DGFjdi5VfAnRroFYKFgqE36b+e11KQ==
X-Received: by 2002:a63:7e04:: with SMTP id z4mr1846602pgc.221.1635402906968;
        Wed, 27 Oct 2021 23:35:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id x5sm2144971pfh.153.2021.10.27.23.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 23:35:06 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 1/8] bpf: Add bpf_kallsyms_lookup_name helper
Date:   Thu, 28 Oct 2021 12:04:54 +0530
Message-Id: <20211028063501.2239335-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211028063501.2239335-1-memxor@gmail.com>
References: <20211028063501.2239335-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4951; h=from:subject; bh=Hp5FNkxm1ROEI9dKPNHhRRvN6+yGWRmw3utEYlyTHsc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhekR+k1M2x0iox58c9pshA+wqnka8Gi1yjVvGljxK gOIKOmSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXpEfgAKCRBM4MiGSL8RymkgD/ 9ehkEGm/wzyaPpXtC8XwGMxyLfP32k3xWKm9nLZm3trol+gRNYmwv864znlvc+oPTZPV8tVuzCvFCn ryeJOlKXnAcgu4GwCc+QVjtbkYOn2eS14HI9XIAqzou7DIr63Q2KoNM6cwUZ6MaG4d3Ai/SB0m4SUf eM/RP2RLbEESP3cTnm0+XxsYOwE/pXvPvqLk3keHCWEkUWYN/u15wECQD46bwwiUIvms+6Ty1AUCVg RJaC+EbNlNHVsvyQKSrm/FsbCcPovR5kFutXN6X5fj3sqCz2zoxQi6hKh3vjd9aCj16ttM883ydzNx +QINDxYF/T8BNyBfC8VyTheS037VyQemfwNBX0LnGCSa/TaBL1LxBrvq3qXjH0IW7YBds4BozhWgbU HD45RtuN9cb/U5+7s36PhBCWL+bZfhKgqFOmp0/8Lym+03v5XcRvvFqf3OKRnROhy7Ln3K2uXV7spz KlGS4Fjwa2xZrwsmfyQWppKBeIF45jLDBufktlk5zK78+SnUBWuULuZVXXg1/hDF38W8BUnEJwXo5T uJG6stnSNNPj9DTlyBaJaMoGRTTyuSIYExtyRLLea1N4Abi9zJ3qJTLXpKy4zWLskrvZPMIYGaH7D0 Cs4i7aI5JcJLd3ufLxwZe9jWJJ8VX9tADNoljoItBWGl46W4nIGHH4S+4cHg==
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
index 31421c74ba08..05889394fe77 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2109,6 +2109,7 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
+extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c10820037883..9aaa2d6a3db6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4915,6 +4915,21 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or **NULL** otherwise.
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
@@ -5096,6 +5111,7 @@ union bpf_attr {
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3e1c024ce3ed..c0f2dadd67c4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4763,6 +4763,31 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
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
@@ -4773,6 +4798,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_btf_find_by_name_kind_proto;
 	case BPF_FUNC_sys_close:
 		return &bpf_sys_close_proto;
+	case BPF_FUNC_kallsyms_lookup_name:
+		return &bpf_kallsyms_lookup_name_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c10820037883..9aaa2d6a3db6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4915,6 +4915,21 @@ union bpf_attr {
  *		Dynamically cast a *sk* pointer to a *unix_sock* pointer.
  *	Return
  *		*sk* if casting is valid, or **NULL** otherwise.
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
@@ -5096,6 +5111,7 @@ union bpf_attr {
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
+	FN(kallsyms_lookup_name),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.1

