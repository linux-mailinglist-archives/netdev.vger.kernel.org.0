Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82894102566
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKSN2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:28:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43957 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfKSN1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:27:54 -0500
Received: by mail-pl1-f193.google.com with SMTP id a18so11766362plm.10;
        Tue, 19 Nov 2019 05:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Q8mvfB32bgpLAowD/QjT9mhQHmZ53A0Crul9TxiFP+s=;
        b=IrmrH0jZrMRZcPR/AWn/ozFtqexIpA7lRjw/isiCnzl5enXiCGGa3pjRcV0UFb5DtP
         +AjhxOXUGlVHdVLvYPn0M4dFdX/jPZfRidvcChopH/fn70Fyar5Sd3A7YOPSoymtTlAb
         AGcKADcv4BKdyVyw6ywBNNRpsRZ23SoV3hSQUWiKVdc+OSeHppEvn1TiJ5v87u1E73T0
         IcJBpGDYSkFiHJqbY6br22GfT4AZCETBqwagTaWyB8ne/NCDYmtyrBVBYGuUWE2I58se
         K/LSnIdTwHL6xVidCFlT6EGLZZafUZApUujOKqdE2mvgCntzbB6vc5eCIBwnd0lgUtyM
         DhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Q8mvfB32bgpLAowD/QjT9mhQHmZ53A0Crul9TxiFP+s=;
        b=KWl2Zr0gH4N8L6hSv6hscYRlyguUHsFOu3SY3U/yahTvQwJ4lTLDdBes6QQx/VasY2
         gLbzLT83W0Q6dvFeP4ruDvGkPFC1fIYmfErVEDUZlnqjjIB9SSMh24vJAtnoRo8bGy2J
         URCkoEQr4j2PFpsbWSK3PiVBHl4kBuWvwYv0b8RHx6G2K2YdanTdShPrrNbnrQ0aHzTf
         AdiI/8yRhenBpDpQOw05IoUxD8ZAHmX+OWZWLm8Z3iPHS6qtlxpL5NkwzSfIzbJpSSXC
         dlh+O9Xl/UWRykmF5kELv8Gwa+o4hw1AqZe+SrPBHdKYBUtBJqPVBtgW94+zbhiEXXXN
         Kq1A==
X-Gm-Message-State: APjAAAXjTBsgfHPBupMouNDsL0DwOtBqxJXHyUl2A1ChsYt2IDm0xata
        OLAQUs2SG5TlaiC/rVrse2esuxIBqRM=
X-Google-Smtp-Source: APXvYqwougi+RQrlnepkVPYBzUsVNFzuWQcxKHPaZLTdoF7bh2BZvz+oJCEomVtPzK9G+ci2aImQyA==
X-Received: by 2002:a17:902:b789:: with SMTP id e9mr4194903pls.4.1574170072939;
        Tue, 19 Nov 2019 05:27:52 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id v189sm25990458pfv.133.2019.11.19.05.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:27:52 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Tue, 19 Nov 2019 08:27:37 -0500
Message-Id: <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1574162990.git.ethercflow@gmail.com>
References: <cover.1574162990.git.ethercflow@gmail.com>
In-Reply-To: <cover.1574162990.git.ethercflow@gmail.com>
References: <cover.1574162990.git.ethercflow@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

This requirement is mainly discussed here:

  https://github.com/iovisor/bcc/issues/237

v9->v10: addressed Andrii's feedback
- send this patch together with the patch selftests as one patch series

v8->v9:
- format helper description

v7->v8: addressed Alexei's feedback
- use fget_raw instead of fdget_raw, as fdget_raw is only used inside fs/
- ensure we're in user context which is safe fot the help to run
- filter unmountable pseudo filesystem, because they don't have real path
- supplement the description of this helper function

v6->v7:
- fix missing signed-off-by line

v5->v6: addressed Andrii's feedback
- avoid unnecessary goto end by having two explicit returns

v4->v5: addressed Andrii and Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names
- when fdget_raw fails, set ret to -EBADF instead of -EINVAL
- remove fdput from fdget_raw's error path
- use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
into the buffer or an error code if the path was too long
- modify the normal path's return value to return copied string length
including NUL
- update this helper description's Return bits.

v3->v4: addressed Daniel's feedback
- fix missing fdput()
- move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
- move fd2path's test code to another patch
- add comment to explain why use fdget_raw instead of fdget

v2->v3: addressed Yonghong's feedback
- remove unnecessary LOCKDOWN_BPF_READ
- refactor error handling section for enhanced readability
- provide a test case in tools/testing/selftests/bpf

v1->v2: addressed Daniel's feedback
- fix backward compatibility
- add this helper description
- fix signed-off name

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 include/uapi/linux/bpf.h       | 29 +++++++++++++++-
 kernel/trace/bpf_trace.c       | 63 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 29 +++++++++++++++-
 3 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970..71d9705df120 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2821,6 +2821,32 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. Notice the **path** don't support unmountable
+ *		pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
+ *		The *size* must be strictly positive. On success, the helper
+ *		makes sure that the *path* is NUL-terminated, and the buffer
+ *		could be:
+ *		- a regular full path (include mountable fs eg: /proc, /sys)
+ *		- a regular full path with "(deleted)" at the end.
+ *		On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EPERM** if no permission to get the path (eg: in irq ctx).
+ *
+ *		**-EBADF** if *fd* is invalid.
+ *
+ *		**-EINVAL** if *fd* corresponds to a unmountable pseudo fs
+ *
+ *		**-ENAMETOOLONG** if full path is longer than *size*
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2964,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ffc91d4935ac..c77e55418f1e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -762,6 +762,67 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
+{
+	struct file *f;
+	char *p;
+	int ret = -EBADF;
+
+	/* Ensure we're in user context which is safe for the helper to
+	 * run. This helper has no business in a kthread.
+	 */
+	if (unlikely(in_interrupt() ||
+		     current->flags & (PF_KTHREAD | PF_EXITING)))
+		return -EPERM;
+
+	/* Use fget_raw instead of fget to support O_PATH, and it doesn't
+	 * have any sleepable code, so it's ok to be here.
+	 */
+	f = fget_raw(fd);
+	if (!f)
+		goto error;
+
+	/* For unmountable pseudo filesystem, it seems to have no meaning
+	 * to get their fake paths as they don't have path, and to be no
+	 * way to validate this function pointer can be always safe to call
+	 * in the current context.
+	 */
+	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
+		return -EINVAL;
+
+	/* After filter unmountable pseudo filesytem, d_path won't call
+	 * dentry->d_op->d_name(), the normally path doesn't have any
+	 * sleepable code, and despite it uses the current macro to get
+	 * fs_struct (current->fs), we've already ensured we're in user
+	 * context, so it's ok to be here.
+	 */
+	p = d_path(&f->f_path, dst, size);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		fput(f);
+		goto error;
+	}
+
+	ret = strlen(p);
+	memmove(dst, p, ret);
+	dst[ret++] = '\0';
+	fput(f);
+	return ret;
+
+error:
+	memset(dst, '0', size);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_get_file_path_proto = {
+	.func       = bpf_get_file_path,
+	.gpl_only   = true,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type  = ARG_CONST_SIZE,
+	.arg3_type  = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -822,6 +883,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_file_path:
+		return &bpf_get_file_path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..71d9705df120 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2821,6 +2821,32 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. Notice the **path** don't support unmountable
+ *		pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
+ *		The *size* must be strictly positive. On success, the helper
+ *		makes sure that the *path* is NUL-terminated, and the buffer
+ *		could be:
+ *		- a regular full path (include mountable fs eg: /proc, /sys)
+ *		- a regular full path with "(deleted)" at the end.
+ *		On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EPERM** if no permission to get the path (eg: in irq ctx).
+ *
+ *		**-EBADF** if *fd* is invalid.
+ *
+ *		**-EINVAL** if *fd* corresponds to a unmountable pseudo fs
+ *
+ *		**-ENAMETOOLONG** if full path is longer than *size*
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2964,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

