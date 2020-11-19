Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6802A2B97EB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgKSQ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgKSQ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:27:34 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF45C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:27:34 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c9so7761597wml.5
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LJ5w1Vm2fOQoGe4AXB6MlgyVSNcAAyyh/BtZV/T1bVw=;
        b=MhBFhMPuplgXvXL8UeQnB2kwL2CIQzlplPxykO2DMN511aL8mCGLeL4736LwoRsVaN
         o8KF/zccNgZmk3/N7qeW+uE6VBsJ8/yxiISWSgjl3OrRf4OfDebaEO3E7TiW6sa8hN0q
         ObbI5EjlMQcLp/k4CL8YU4g+8fDDROk2SYaj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LJ5w1Vm2fOQoGe4AXB6MlgyVSNcAAyyh/BtZV/T1bVw=;
        b=Pd4CEd2JciZAFhbUKcrLLbtpv5U6NDKrJz8+V9tDEhgSwKuycgQSn4u2m6ebMVvhUC
         Fa/B2NDBWLV35uM7tWeA89C9CJBEZ+5Y5DwleONzQA0gBzPqTJjfDLhinQaryjABYnZH
         eYkkIdHAks3a1kk7/bUY31LQcXtVyoGW6RtsogHg88VMdjkHCOzbtbV4q0v8g/VRuIz3
         PuRE+k1rBnHJvogHvYVeq57pK/UHXwEKipgdmtmWvBB5GT5JJ8EhK6YEKvpHibPQhY91
         9Q99EotnVUWIgqUFe7IKpTjDFkcev3xYxXWr4smpnKRv1TljjAWO78CFYMIEg0XeFNjn
         aWAw==
X-Gm-Message-State: AOAM532pgZtBbI83Rt5iKRO+HyniFSjTHZ4lKc7TvFrcndJsApsUiOAY
        9kOGomdDEYDGslyKBFrYok5RaQ==
X-Google-Smtp-Source: ABdhPJyNyQuqHUq3rxhKcDmCkFUo31tIBP13bp1m6OUKnrlC8+DFrspWSXC+Y2g26q8Ue8mvHj5dOg==
X-Received: by 2002:a05:600c:2048:: with SMTP id p8mr5570835wmg.165.1605803252994;
        Thu, 19 Nov 2020 08:27:32 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id i5sm380061wrw.45.2020.11.19.08.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 08:27:32 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/5] bpf: Add a bpf_sock_from_file helper
Date:   Thu, 19 Nov 2020 17:26:51 +0100
Message-Id: <20201119162654.2410685-2-revest@chromium.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201119162654.2410685-1-revest@chromium.org>
References: <20201119162654.2410685-1-revest@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Revest <revest@google.com>

While eBPF programs can check whether a file is a socket by file->f_op
== &socket_file_ops, they cannot convert the void private_data pointer
to a struct socket BTF pointer. In order to do this a new helper
wrapping sock_from_file is added.

This is useful to tracing programs but also other program types
inheriting this set of helpers such as iterators or LSM programs.

Signed-off-by: Florent Revest <revest@google.com>
---
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/trace/bpf_trace.c       | 20 ++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  4 ++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 4 files changed, 38 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 162999b12790..7d598f161dc0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3787,6 +3787,12 @@ union bpf_attr {
  *		*ARG_PTR_TO_BTF_ID* of type *task_struct*.
  *	Return
  *		Pointer to the current task.
+ *
+ * struct socket *bpf_sock_from_file(struct file *file)
+ *	Description
+ *		If the given file contains a socket, returns the associated socket.
+ *	Return
+ *		A pointer to a struct socket on success or NULL on failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3948,6 +3954,7 @@ union bpf_attr {
 	FN(task_storage_get),		\
 	FN(task_storage_delete),	\
 	FN(get_current_task_btf),	\
+	FN(sock_from_file),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 02986c7b90eb..d87ca6f93c58 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1260,6 +1260,24 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_sock_from_file, struct file *, file)
+{
+	return (unsigned long) sock_from_file(file);
+}
+
+BTF_ID_LIST(bpf_sock_from_file_btf_ids)
+BTF_ID(struct, socket)
+BTF_ID(struct, file)
+
+static const struct bpf_func_proto bpf_sock_from_file_proto = {
+	.func		= bpf_sock_from_file,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
+	.ret_btf_id	= &bpf_sock_from_file_btf_ids[0],
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_sock_from_file_btf_ids[1],
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1354,6 +1372,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_per_cpu_ptr_proto;
 	case BPF_FUNC_bpf_this_cpu_ptr:
 		return &bpf_this_cpu_ptr_proto;
+	case BPF_FUNC_sock_from_file:
+		return &bpf_sock_from_file_proto;
 	default:
 		return NULL;
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 31484377b8b1..d609f20e8360 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -435,6 +435,8 @@ class PrinterHelpers(Printer):
             'struct xdp_md',
             'struct path',
             'struct btf_ptr',
+            'struct socket',
+            'struct file',
     ]
     known_types = {
             '...',
@@ -478,6 +480,8 @@ class PrinterHelpers(Printer):
             'struct task_struct',
             'struct path',
             'struct btf_ptr',
+            'struct socket',
+            'struct file',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 162999b12790..7d598f161dc0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3787,6 +3787,12 @@ union bpf_attr {
  *		*ARG_PTR_TO_BTF_ID* of type *task_struct*.
  *	Return
  *		Pointer to the current task.
+ *
+ * struct socket *bpf_sock_from_file(struct file *file)
+ *	Description
+ *		If the given file contains a socket, returns the associated socket.
+ *	Return
+ *		A pointer to a struct socket on success or NULL on failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3948,6 +3954,7 @@ union bpf_attr {
 	FN(task_storage_get),		\
 	FN(task_storage_delete),	\
 	FN(get_current_task_btf),	\
+	FN(sock_from_file),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.29.2.299.gdc1121823c-goog

