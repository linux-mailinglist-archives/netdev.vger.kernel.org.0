Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75B2DC308
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbfJRKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:48:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38469 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfJRKsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 06:48:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so3638330pfe.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 03:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SUb1/qJX0Nfbftj9LdNP3xkePhn8KgjV+wz88z63KEg=;
        b=tYKfSJT4DBFRnHtgTX1+3ETWf6RWVouETAqXMJLxp2M6qxny+VSdUKDXcfRGMrnD6w
         tFPKliPq38w9LmWRCbBjqeYQ/KxtqDEmSH+zAwu6XMWf0SeptkXKgoLKIwxZiKPYHF3+
         P64mvBTU+wPA+p1yWDwSKyALQ9PFc3+oEICrIMwwWg7975ncPHT67+CzUursSEnHP4Rb
         5Ql/WJgbDH0ycK+qCLbjJrrToVkib2NoaYkDQ15R7E6IeyuSijn8BXx833gdBDGX4V7k
         tTu60Zg0U6RE6g88uTvHJiuj3FwVEWfCRy5vj1J6wl82OahdcNUj2XMHHJgY5I7qJiUU
         pLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SUb1/qJX0Nfbftj9LdNP3xkePhn8KgjV+wz88z63KEg=;
        b=HPFFpkyrezHjjsofENcjcmlTXfIhveJHN/zzyb3vP2R8YX+3vNiQ0R3llf33M6730q
         V7QqErJO1/ewLRtdks2ebUFutqSlPo25NTAq7qkr3MCZvxX96NGl620BPl7rq2ryPHBM
         cmCzvc9VK4RMIlll8l8TSI+2gg0gXMus/4GFX/38OelbQtYbrlfV/sv4lzoI+2cRYN8o
         +IhR58Ai+swgqEYaWC0GED320lfohPs0nbquE3B671CVGNPT4Ko4BC5ibM0+0RH8Gc2K
         XgdBNUvmCNq97R8Hy+1SzlC3RIo7upsgWjcW8bfNLQeTr9DHianv8mghHKA52olfG1av
         iu8g==
X-Gm-Message-State: APjAAAVJsb44pgkGIjgi5hMrhVmrbQ1ROT7y/Io29305RYkNviunUedk
        1FZb3ctq0+zsSdl5dB1dzq577MXZ
X-Google-Smtp-Source: APXvYqylv63pt2jiCF3nTk2bS3nE3eaOdrGyfNaro0TQ5Cjw0ZK0GsGhp5B+S3BfsBSPNDZ6oJoxIA==
X-Received: by 2002:aa7:8d95:: with SMTP id i21mr6111817pfr.161.1571395691090;
        Fri, 18 Oct 2019 03:48:11 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id i10sm5040702pgb.79.2019.10.18.03.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 03:48:10 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net,
        Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file descriptor to a pathname
Date:   Fri, 18 Oct 2019 06:47:48 -0400
Message-Id: <20191018104748.25486-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 12 ++++++++++-
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 39 ++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h | 12 ++++++++++-
 6 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2c2c29b49845..d73314a7e674 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1082,6 +1082,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_fd2path_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..fdb37740951f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2773,6 +2773,15 @@ union bpf_attr {
  *
  * 		This helper is similar to **bpf_perf_event_output**\ () but
  * 		restricted to raw_tracepoint bpf programs.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  */
@@ -2888,7 +2897,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(fd2path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 673f5d40a93e..6b44ed804280 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2079,6 +2079,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_fd2path_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..0832536c7ddb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -487,3 +487,42 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
+{
+	struct fd f;
+	int ret;
+	char *p;
+
+	ret = security_locked_down(LOCKDOWN_BPF_READ);
+	if (ret < 0)
+		goto out;
+
+	f = fdget_raw(fd);
+	if (!f.file)
+		goto out;
+
+	p = d_path(&f.file->f_path, dst, size);
+	if (IS_ERR_OR_NULL(p))
+		ret = PTR_ERR(p);
+	else {
+		ret = strlen(p);
+		memmove(dst, p, ret);
+		dst[ret] = 0;
+	}
+
+	if (unlikely(ret < 0))
+out:
+		memset(dst, '0', size);
+
+	return ret;
+}
+
+const struct bpf_func_proto bpf_fd2path_proto = {
+	.func       = bpf_fd2path,
+	.gpl_only   = true,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type  = ARG_CONST_SIZE,
+	.arg3_type  = ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 52f7e9d8c29b..23cc3a955e59 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_fd2path:
+		return &bpf_fd2path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..fdb37740951f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2773,6 +2773,15 @@ union bpf_attr {
  *
  * 		This helper is similar to **bpf_perf_event_output**\ () but
  * 		restricted to raw_tracepoint bpf programs.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  */
@@ -2888,7 +2897,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(fd2path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

