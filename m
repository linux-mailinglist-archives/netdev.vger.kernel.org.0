Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B21A362D4B
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhDQDeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49017C06138E;
        Fri, 16 Apr 2021 20:32:41 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t22so20482656pgu.0;
        Fri, 16 Apr 2021 20:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tULXt/PlhKWG7/PXfrb2yC891hlZXI2JGQegWX23UB4=;
        b=KLOp357lxSvyMUa6wv1cgQTVqpgoRDExnSyId8rg7ZTxM613AyqqqTnPnKPpwqhvaW
         ldnkPODfGJM10tN9SI253g/XRcBjsX+z4nAqbOtmevPbWMd1smAFFVYbvlIrQ0VMvIA3
         2Ccrcq76p8U3DJJ8rzX4s8RTZXHynXCP5QKq9qoXZ7P0gwRRBdA3HFJVNUVBo1y3Bkek
         jP9BsVxvyKRmUxPkIIq8pw9pCYfJj+44/1uwfrqOUAVn5YOZm2bhUKvzCMjEjj0LV9J6
         oj19YnkQojWnR8+H9cUyng41BM9g+X5h+4ht3ZkMYpCCVTXMlRcNNldhpfWGFggYbQNS
         7dtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tULXt/PlhKWG7/PXfrb2yC891hlZXI2JGQegWX23UB4=;
        b=fDOtMiHvhJNq+0MEn05SM+laOCZdt/TdMeJNLFrTHbQ3Wdz/s/l4dZJF2XtbSMV3F3
         g6bO5ClJ2RUOPcIgtN52FsACXyXyZe8D+WQ6s13gdVlBGQDyg5TkQ+d8vG6ihj8OIvXb
         VCvzcuOvmcH3bkvvqlSsJ4okTF5wmXf0jLeQhOix6PkdcsH/DBHQRcCOF9Ae9LM1DOQ0
         QtHrBTUW+ZmHUIm8iruFQ3aIs5d+neizMslGMelpX9y96xMwYGlrD9ti+xeaYcxstlMX
         Ww9MaTLAcDp5v1kkXXUV2m3+dxX5DUWxUxOeDAP0/cUx1p7HGhWqetX8rB4ry++55uXh
         jGrg==
X-Gm-Message-State: AOAM5312nIxEZXe9mVObygDilTm//aUUFVzahpUQquWO2ADPrJUvRVF3
        yrETIc9Ng/exirSIYjUtPjI=
X-Google-Smtp-Source: ABdhPJxAdaYpGXILet7izbf50WFg+7X4Atixz058rgxUs6jc5Bm4GmtV2FQbN/hBUH1euwyDq5dUKw==
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr1890757pgu.18.1618630360818;
        Fri, 16 Apr 2021 20:32:40 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:40 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 10/15] bpf: Add bpf_btf_find_by_name_kind() helper.
Date:   Fri, 16 Apr 2021 20:32:19 -0700
Message-Id: <20210417033224.8063-11-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add bpf_btf_find_by_name_kind() helper.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  8 ++++++
 kernel/bpf/btf.c               | 51 ++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  2 ++
 tools/include/uapi/linux/bpf.h |  8 ++++++
 5 files changed, 70 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1aede7ceea5e..fe28ccb57f83 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1970,6 +1970,7 @@ extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
 extern const struct bpf_func_proto bpf_task_storage_get_proto;
 extern const struct bpf_func_proto bpf_task_storage_delete_proto;
 extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
+extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 068c23f278bc..47c4b21a51b6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4721,6 +4721,13 @@ union bpf_attr {
  * 		Execute bpf syscall with given arguments.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, u32 *attach_btf_obj_fd, int flags)
+ * 	Description
+ * 		Find given name with given type in BTF pointed to by btf_fd.
+ * 		If btf_fd is zero look for the name in vmlinux BTF and kernel module BTFs.
+ * 	Return
+ * 		Return btf_id and store module's BTF FD into attach_btf_obj_fd.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4889,6 +4896,7 @@ union bpf_attr {
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
 	FN(sys_bpf),			\
+	FN(btf_find_by_name_kind),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fbf6c06a9d62..2f474739d9d3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6085,3 +6085,54 @@ struct module *btf_try_get_module(const struct btf *btf)
 
 	return res;
 }
+
+BPF_CALL_5(bpf_btf_find_by_name_kind, int, btf_fd, char *, name, u32, kind, int *, attach_btf_obj_fd, int, flags)
+{
+	struct btf *btf;
+	int ret;
+
+	if (flags)
+		return -EINVAL;
+
+	if (btf_fd)
+		btf = btf_get_by_fd(btf_fd);
+	else
+		btf = bpf_get_btf_vmlinux();
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);
+
+	*attach_btf_obj_fd = 0;
+	ret = btf_find_by_name_kind(btf, name, kind);
+	if (!btf_fd && ret < 0) {
+		struct btf *mod_btf;
+		int id = btf->id;
+
+		spin_lock_bh(&btf_idr_lock);
+		idr_for_each_entry_continue(&btf_idr, mod_btf, id) {
+			if (!btf_is_kernel(btf))
+				continue;
+			ret = btf_find_by_name_kind(mod_btf, name, kind);
+			if (ret > 0)
+				break;
+		}
+		if (mod_btf)
+			btf_get(mod_btf);
+		spin_unlock_bh(&btf_idr_lock);
+		if (mod_btf)
+			*attach_btf_obj_fd = __btf_new_fd(mod_btf);
+	}
+	if (btf_fd)
+		btf_put(btf);
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
+	.arg4_type	= ARG_PTR_TO_INT,
+	.arg5_type	= ARG_ANYTHING,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7b51d56e420b..6d4d9925c0ec 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4563,6 +4563,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_sys_bpf:
 		return &bpf_sys_bpf_proto;
+	case BPF_FUNC_btf_find_by_name_kind:
+		return &bpf_btf_find_by_name_kind_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 068c23f278bc..47c4b21a51b6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4721,6 +4721,13 @@ union bpf_attr {
  * 		Execute bpf syscall with given arguments.
  * 	Return
  * 		A syscall result.
+ *
+ * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, u32 *attach_btf_obj_fd, int flags)
+ * 	Description
+ * 		Find given name with given type in BTF pointed to by btf_fd.
+ * 		If btf_fd is zero look for the name in vmlinux BTF and kernel module BTFs.
+ * 	Return
+ * 		Return btf_id and store module's BTF FD into attach_btf_obj_fd.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4889,6 +4896,7 @@ union bpf_attr {
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
 	FN(sys_bpf),			\
+	FN(btf_find_by_name_kind),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

