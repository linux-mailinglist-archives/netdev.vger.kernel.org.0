Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF3FDE47
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKOMtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:49:00 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40159 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKOMs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:48:59 -0500
Received: by mail-pg1-f194.google.com with SMTP id 15so5978328pgt.7;
        Fri, 15 Nov 2019 04:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TzOsJxR95QKsiowT6LAve3c7rMs9qAKf7d9Qz/2SanU=;
        b=QBE8y4rT4sT99Petii9tbyhucA/BkZnUNLmGjOBoXDfS/xbTMmTassYTSiPaTZl7I4
         MkC36B33FLcEA2dM6TOr+jlStlmLwM5DnmZ37E4rssXPtk9GvVkh9G6gy2XgM4ed4zSk
         SiTv0uURAaI7O5aD+sWEIN/reZvr7Haxphwy5tDc5mWpWzdeZtoXDXMFJXPIvD311PXz
         tsaQDXeeqazuhQPbiJNE++lVkF8x/7Jqo4fhiuJfYcYRMxPg/E9PWjmZajApVWXekB8t
         6nVllvkaqffo8Ty3m1L7eJpInvbAvl5p/DS8XlVw8kdU6UECgENmFV2EtNXjDbT5CdKa
         Y+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TzOsJxR95QKsiowT6LAve3c7rMs9qAKf7d9Qz/2SanU=;
        b=Zh/Af9TTTMIaiXQGw6qc4kdwmqc7ZL6F/sG3tjjoOaO1nmhTVINnJbeZCA4OZ/Im8o
         JfsE4tTueKS4OM2DnfHIJXVlf25k32SEq6YXvQNsyRqZ3rKlKq3sOAw0hHHVuGdLZBcp
         bGRLlCnduvtn5gQUur7nqGGh59OVN2Q+ejbQk9duJdyFARUTOwTchcpu9VuUq9H9vE+I
         it6meIUWhoQu9F4AEyLyUBSTK2+5AT2L+giEpeLXdHU3iVt2Q3HptBplen8PD+VDQzip
         PSJxZ6WFSUHO4qWHRLrkfiRY5bSiXU2B9pPG6WSV3IMIGxmJAea674izyhjOj+ZghXE6
         /icA==
X-Gm-Message-State: APjAAAWOvQq41wvK2VIUEnj1TEeTW5axqpdY8OPA5McXC6QRfTD4r9bZ
        rvkZIvN+8bHvCTssqhoIM4pxzD9QxH8=
X-Google-Smtp-Source: APXvYqxAQLi7znmi4csOskyGZRaAaRmowAl9SYhPaleg0M3YIo5/xiZvS/fIU1A9fu8Eq2ovKNGVWA==
X-Received: by 2002:a63:f1c:: with SMTP id e28mr15816160pgl.67.1573822138680;
        Fri, 15 Nov 2019 04:48:58 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id s18sm10954827pfs.20.2019.11.15.04.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:48:58 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v9] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Fri, 15 Nov 2019 07:48:46 -0500
Message-Id: <20191115124846.38766-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

This requirement is mainly discussed here:

  https://github.com/iovisor/bcc/issues/237

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
 tools/include/uapi/linux/bpf.h | 28 ++++++++++++++-
 3 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index df6809a76404..71832cd3729c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2815,6 +2815,32 @@ union bpf_attr {
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
@@ -2932,7 +2958,8 @@ union bpf_attr {
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
index df6809a76404..afe98857fa04 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2815,6 +2815,31 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
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
@@ -2932,7 +2957,8 @@ union bpf_attr {
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

