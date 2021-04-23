Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E2E3689D6
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbhDWA1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbhDWA1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F38C061574;
        Thu, 22 Apr 2021 17:27:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so307263pjb.4;
        Thu, 22 Apr 2021 17:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lsg3ACU+mbb8IfMTZqR/n7feK/iVGwkC9cFdG9K7vRo=;
        b=TnK/bXj/f9yjFWZRCqnRecy063JXpeavMeZUv7iShYAclzw3Bd+06LbhNXs12Gd2mG
         +A0aeMOgE1tnX+BAs7//YrMK+kFHerbmgVxAx0W9oCxtDvyg9oCqmcN0JVCEqhHtI3m4
         awClnFYTmhWxvXkOTL6hcdGYfNsPRVhz73cf04IMrKrgrRgUsnOR+Lm3FZQbcCVloXQZ
         iw9OJRcLAClcIG6C7gWx5CBqZui5wTA2DWGU5pflwmxMWQuo9X7wvz5cFFIzlrZgW6Rq
         CrOTrMjrDKsmldK7a0gBG5zgH5d36deswZbR02LBVkx2afmhqY5KYcaEsZoADbNbQzIW
         ymhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lsg3ACU+mbb8IfMTZqR/n7feK/iVGwkC9cFdG9K7vRo=;
        b=pKodJBLJadk1DMK0AuODpoYkwGzfFHSHL2PLVL8OAy6t+yRuK7TnY1d8p1CEzsHQ9m
         t7twYe6KjozKnL5uV/vIUnTaeYFgVhJJZy9Wp4ZGnf2a1ouRvBbeP7brSbgF6itDIOBn
         AoNB/YjGjQjJGQTzG8lm79kA6tWvjlyDcah+pItHb8F+9T1aKWQoQt61BT2R2g9PGbYX
         vGuppx1OW/t2YsDWiWIjpPz/zjJghCHlobAOqDxZVhDt4mgYWXQicuJUj5asRCiexMmv
         TTo/gChnpVcoXLaUurwDzCBpNn0aVMDcXL9+ynA4hPKja5qzgRlZwLcyz8UlUboimAWP
         sq/w==
X-Gm-Message-State: AOAM532eOqB28FYYqMkZCvtbjpO+z2hYkfggWOfM6ubDKXhZe+roX+35
        VOSpcYTH2PFDC1KgAxme6hM=
X-Google-Smtp-Source: ABdhPJw92EKwBA+sTrN5mhybeLMvXwSP55QuN8+iG0My2UjL++PSiqEuw0c7tlw4qSSkZWphmJG4Og==
X-Received: by 2002:a17:902:8d83:b029:e6:508a:7b8d with SMTP id v3-20020a1709028d83b02900e6508a7b8dmr1492282plo.18.1619137623658;
        Thu, 22 Apr 2021 17:27:03 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:03 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 11/16] bpf: Add bpf_sys_close() helper.
Date:   Thu, 22 Apr 2021 17:26:41 -0700
Message-Id: <20210423002646.35043-12-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add bpf_sys_close() helper to be used by the syscall/loader program to close
intermediate FDs and other cleanup.
Note this helper must never be allowed inside fdget/fdput bracketing.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/syscall.c           | 19 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 33 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 253f5f031f08..45e55ad3c617 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4755,6 +4755,12 @@ union bpf_attr {
  * 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
  * 	Return
  * 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
+ *
+ * long bpf_sys_close(u32 fd)
+ * 	Description
+ * 		Execute close syscall for given FD.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4925,6 +4931,7 @@ union bpf_attr {
 	FN(snprintf),			\
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
+	FN(sys_close),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 638c7acad925..f5519e84b097 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4568,6 +4568,23 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	return bpf_base_func_proto(func_id);
 }
 
+BPF_CALL_1(bpf_sys_close, u32, fd)
+{
+	/* When bpf program calls this helper there should not be
+	 * an fdget() without matching completed fdput().
+	 * This helper is allowed in the following callchain only:
+	 * sys_bpf->prog_test_run->bpf_prog->bpf_sys_close
+	 */
+	return close_fd(fd);
+}
+
+const struct bpf_func_proto bpf_sys_close_proto = {
+	.func		= bpf_sys_close,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -4576,6 +4593,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sys_bpf_proto;
 	case BPF_FUNC_btf_find_by_name_kind:
 		return &bpf_btf_find_by_name_kind_proto;
+	case BPF_FUNC_sys_close:
+		return &bpf_sys_close_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5841adb44de6..8dd27faa30ee 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4755,6 +4755,12 @@ union bpf_attr {
  * 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
  * 	Return
  * 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
+ *
+ * long bpf_sys_close(u32 fd)
+ * 	Description
+ * 		Execute close syscall for given FD.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4925,6 +4931,7 @@ union bpf_attr {
 	FN(snprintf),			\
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
+	FN(sys_close),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

