Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A633689D3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhDWA1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240078AbhDWA1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4130C06138E;
        Thu, 22 Apr 2021 17:27:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u15so15836600plf.10;
        Thu, 22 Apr 2021 17:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AzzvOUyd8TsZNiC1m9Nop4BPUbcupIF2MZCJ1uFtDTE=;
        b=S3jn+t6zhpcpMRjKBPzfFbe/RYV569zKjq7Oi4pSF6R+1tV/JVlWN1q/ZFvsnDJhn0
         WTs8elmZqEcPIDZXXmK4T/BNhcB5O10pDlrEUHNg2IXXgNOuPKGb6NMmDXIU4nsx1B0+
         9zCasOuBRdtJv1JWyGhGnDQsCqfFsrGM/evwWZO/gWytui5pJWMTYTLOtfprqGQ0sP6k
         MNHt4yPqst1I0/RY2qEb5Wq0qivHTxfpjc/MebXEAEPqSV0JseKhkQthtQ6s87PvuuK2
         Ip2q8xwQHYqbN+a7hCiz9qh8Qgk5KZnM9mZ46pzUU+cnzO6+cVzqnK441SR2C09+rMxT
         TB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AzzvOUyd8TsZNiC1m9Nop4BPUbcupIF2MZCJ1uFtDTE=;
        b=piTasgump7BLJQPkEibeN5DjJcXQRb1oY87L0KnWHnw/+r070VVDuWRm7f1/GWBCND
         0RpTf/GqGQgMreTAMyQn3T+Yg15iQo50/SzypExXmkzwjYob3W/89hkSoD2gVYAVsitN
         FeUX0pDrZGdnVydn33zjVxHsN3yAo0rVqF5c0pFOU9Oqf7DThsOXiPZYq50UmYvNCTEp
         LtwboJdwHTTI6U14mZUfm/eN8bO7XEVFfYP4F4vsy6JqfsB4sJ+nPkl6CWmD/PAnpYo3
         Ak/J7O9JunixgNY8TbggYZ/y45rYhFipdhiLc5CV0Rj08d9Ug0Ze4wjOiWYG93V0gv/P
         TR+w==
X-Gm-Message-State: AOAM533JimxQ8YP2mMM6eA4e1mu9fnyEgCp7pGN10m7JrjjsXzJkIuG1
        20nJgy0k5CVVcvRk9iYhfvQ=
X-Google-Smtp-Source: ABdhPJzicS2HSCLgjNvL1swHFT623s5vjayH/fWuSsRLry7T7t8BLeLRVVRLS7cKiYwwZX4sc191jw==
X-Received: by 2002:a17:90b:314:: with SMTP id ay20mr2779816pjb.186.1619137622312;
        Thu, 22 Apr 2021 17:27:02 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind() helper.
Date:   Thu, 22 Apr 2021 17:26:40 -0700
Message-Id: <20210423002646.35043-11-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add new helper:

long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
	Description
		Find given name with given type in BTF pointed to by btf_fd.
		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
	Return
		Returns btf_id and btf_obj_fd in lower and upper 32 bits.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  8 ++++
 kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  2 +
 tools/include/uapi/linux/bpf.h |  8 ++++
 5 files changed, 87 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0f841bd0cb85..4cf361eb6a80 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1972,6 +1972,7 @@ extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
 extern const struct bpf_func_proto bpf_task_storage_get_proto;
 extern const struct bpf_func_proto bpf_task_storage_delete_proto;
 extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
+extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index de58a714ed36..253f5f031f08 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4748,6 +4748,13 @@ union bpf_attr {
  * 		Execute bpf syscall with given arguments.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
+ * 	Description
+ * 		Find given name with given type in BTF pointed to by btf_fd.
+ * 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
+ * 	Return
+ * 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4917,6 +4924,7 @@ union bpf_attr {
 	FN(for_each_map_elem),		\
 	FN(snprintf),			\
 	FN(sys_bpf),			\
+	FN(btf_find_by_name_kind),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fbf6c06a9d62..446c64171464 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6085,3 +6085,71 @@ struct module *btf_try_get_module(const struct btf *btf)
 
 	return res;
 }
+
+BPF_CALL_4(bpf_btf_find_by_name_kind, int, btf_fd, char *, name, u32, kind, int, flags)
+{
+	char kname[KSYM_NAME_LEN];
+	struct btf *btf;
+	long ret;
+
+	if (flags)
+		return -EINVAL;
+
+	ret = strncpy_from_kernel_nofault(kname, name, sizeof(kname));
+	if (ret < 0)
+		return ret;
+	if (btf_fd)
+		btf = btf_get_by_fd(btf_fd);
+	else
+		btf = bpf_get_btf_vmlinux();
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);
+
+	ret = btf_find_by_name_kind(btf, kname, kind);
+	/* ret is never zero, since btf_find_by_name_kind returns
+	 * positive btf_id or negative error.
+	 */
+	if (btf_fd)
+		btf_put(btf);
+	else if (ret < 0) {
+		struct btf *mod_btf;
+		int id;
+
+		/* If name is not found in vmlinux's BTF then search in module's BTFs */
+		spin_lock_bh(&btf_idr_lock);
+		idr_for_each_entry(&btf_idr, mod_btf, id) {
+			if (!btf_is_module(mod_btf))
+				continue;
+			/* linear search could be slow hence unlock/lock
+			 * the IDR to avoiding holding it for too long
+			 */
+			btf_get(mod_btf);
+			spin_unlock_bh(&btf_idr_lock);
+			ret = btf_find_by_name_kind(mod_btf, kname, kind);
+			if (ret > 0) {
+				int btf_obj_fd;
+
+				btf_obj_fd = __btf_new_fd(mod_btf);
+				if (btf_obj_fd < 0) {
+					btf_put(mod_btf);
+					return btf_obj_fd;
+				}
+				return ret | (((u64)btf_obj_fd) << 32);
+			}
+			spin_lock_bh(&btf_idr_lock);
+			btf_put(mod_btf);
+		}
+		spin_unlock_bh(&btf_idr_lock);
+	}
+	return ret;
+}
+
+const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
+	.func		= bpf_btf_find_by_name_kind,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_ANYTHING,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a81496c5d09f..638c7acad925 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4574,6 +4574,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_sys_bpf:
 		return &bpf_sys_bpf_proto;
+	case BPF_FUNC_btf_find_by_name_kind:
+		return &bpf_btf_find_by_name_kind_proto;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6c8e178d8ffa..5841adb44de6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4748,6 +4748,13 @@ union bpf_attr {
  * 		Execute bpf syscall with given arguments.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
+ * 	Description
+ * 		Find given name with given type in BTF pointed to by btf_fd.
+ * 		If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
+ * 	Return
+ * 		Returns btf_id and btf_obj_fd in lower and upper 32 bits.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4917,6 +4924,7 @@ union bpf_attr {
 	FN(for_each_map_elem),		\
 	FN(snprintf),			\
 	FN(sys_bpf),			\
+	FN(btf_find_by_name_kind),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

