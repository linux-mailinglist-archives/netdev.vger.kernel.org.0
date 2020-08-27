Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ADC2550DC
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgH0WB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0WBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:01:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC7CC061264;
        Thu, 27 Aug 2020 15:01:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n3so3224657pjq.1;
        Thu, 27 Aug 2020 15:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q3wgxXnU1au9HZnhgkJ5nCi/11y3TK2OPLwZ+ooOQ+k=;
        b=SltKYxv/SuDE/ugsjc4YDGKkRksLe/2INjs2Iy/MYL7YFAWcmbGMkfc3FZNIwiS6s/
         0jdB410+lswQVuEBNOebTladiM1FsOI4TcNqVZ2yHZHcIMyBKvZPcLbRQ2Rd3J55LJNg
         vUEK5zvAbbOflV6DyCclIw93hMhnExIpMGeQISP5UPu9JrSrYLNWR7Au2caMFSLM7ExE
         g4xpOYymt+VOaMxrd6T/Q5spGa0eB4nUr9pjYBfazLOLtOduk9NmkJ4sMxDPkuv4gt0P
         MtYAMuU3tetGzxCKsfp4bBKUVmB/D8OzVlQmGPQLpvTbSykx9wo7pbGqFVSiUvDAuRvW
         mNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q3wgxXnU1au9HZnhgkJ5nCi/11y3TK2OPLwZ+ooOQ+k=;
        b=Buu8vXF8FhGfndiKUj19USwhtFmA8ZOONGuX7zBylHDCwXK9ZNFDERKCq1E11E0u8D
         Oag3Wh09uJTMb2oDPRZU+8Up1CcWeZECeJKiOZldoeLV/O3v/P0b2sV/SJtzdfOwv5+i
         vgLVODBbAfV3b6bQ3fI8+WaT4FnOu46Qm+LJFdiTuo7vPMLmb8t9Zgz5/1M9cGFwLyOb
         TVsLpwtA7yve368sb1Jt4niylhIk5DnifROuPexe1VLIYjh+TpHW9r/OcB4OIBHaozPn
         EZK7aD+mmDfohHgoqDvhdv8L62XC+6H7zmrMNRnjvvrIQ7srREWE9WBpVO7aVatQQNVN
         yZqg==
X-Gm-Message-State: AOAM5308Nm4XSF+yLM+QMfDoG54KH7x+2ga53rXxx0+1vTToPxd88gVu
        6w/FJkeyfM4qYMClBvxxGSs=
X-Google-Smtp-Source: ABdhPJyBDXpdFMUEIfxyIkCpRQ3l3GNVMApL9GBMh6BFJxpQpWXGkQhth7Goi4eNYLbTI6sU2D6DLQ==
X-Received: by 2002:a17:90a:4ec6:: with SMTP id v6mr769299pjl.12.1598565684188;
        Thu, 27 Aug 2020 15:01:24 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x28sm3997564pfq.62.2020.08.27.15.01.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:01:23 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, bpoirier@suse.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 3/5] bpf: Add bpf_copy_from_user() helper.
Date:   Thu, 27 Aug 2020 15:01:12 -0700
Message-Id: <20200827220114.69225-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Sleepable BPF programs can now use copy_from_user() to access user memory.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/helpers.c           | 22 ++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 5 files changed, 41 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1485f22b9e9b..346328133a59 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1768,6 +1768,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
+extern const struct bpf_func_proto bpf_copy_from_user_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index aec01dee6aed..481d87e6b394 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3569,6 +3569,13 @@ union bpf_attr {
  *		On success, the strictly positive length of the string,
  *		including the trailing NUL character. On error, a negative
  *		value.
+ *
+ * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3719,6 +3726,7 @@ union bpf_attr {
 	FN(inode_storage_get),		\
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
+	FN(copy_from_user),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be43ab3e619f..5cc7425ee476 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -601,6 +601,28 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_3(bpf_copy_from_user, void *, dst, u32, size,
+	   const void __user *, user_ptr)
+{
+	int ret = copy_from_user(dst, user_ptr, size);
+
+	if (unlikely(ret)) {
+		memset(dst, 0, size);
+		ret = -EFAULT;
+	}
+
+	return ret;
+}
+
+const struct bpf_func_proto bpf_copy_from_user_proto = {
+	.func		= bpf_copy_from_user,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d973d891f2e2..b2a5380eb187 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1228,6 +1228,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_get_task_stack:
 		return &bpf_get_task_stack_proto;
+	case BPF_FUNC_copy_from_user:
+		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index aec01dee6aed..481d87e6b394 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3569,6 +3569,13 @@ union bpf_attr {
  *		On success, the strictly positive length of the string,
  *		including the trailing NUL character. On error, a negative
  *		value.
+ *
+ * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
+ * 	Description
+ * 		Read *size* bytes from user space address *user_ptr* and store
+ * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3719,6 +3726,7 @@ union bpf_attr {
 	FN(inode_storage_get),		\
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
+	FN(copy_from_user),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.23.0

