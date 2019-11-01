Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54693EC351
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfKAM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:57:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35078 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKAM5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:57:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id c8so6463302pgb.2;
        Fri, 01 Nov 2019 05:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ex4r0EQgFTruMHCEbnhTYIFlp2UHJlSLc2Bi2/7aYt4=;
        b=VMbQ6Es+IJT6lkPWwfFVhgHidLZtF1PDPvAfj+VTOnnmei+SGQywgz6qq5xSPRd6bG
         rrQdzktVQghoGokEvhY+1XFEGCwx++xUnwlPL9pR2K5qksKvQtPjYXvQZVF69VXJ+p0V
         BpxkIEymDHtY5zbCSZklyWzc/Pzc22y2sMLKfZv38AHeNm56iMgUG6XcA7pGIXopvUak
         ipOcCt2JMAoVHI74OK2wcxFnQkmY3HIP4aC3BffABwPrx1xj6e7esmxvYm0z9TejJxOS
         +m4ITA2FiUXhXQ8VE+yrCMFwzYydesI2vdt4sDhf+Li9MZUl9geqU1e4TI2f2bmoO4tP
         K3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ex4r0EQgFTruMHCEbnhTYIFlp2UHJlSLc2Bi2/7aYt4=;
        b=LREZuXbsd8NiXmrFo5RC6NlJTf7DID9vLE4YlF5tAWIG6H7Jtd68ShHptVQKJ8ilD+
         5pT1UwrAhMre8loTtNTuRI5fLMku7qwYbKcKUeY8YvANylIwqpCR2/h93aT6OdRJ9+wQ
         5a4fstqz0ZVelc6iDo7LiKmTWUV5C74PpYWNP3+nef1YPy5ohoKiV22aJ2P7/2akqjlD
         DjDLtn4lxyHy/OxThOKi2A2xARWHkUFRWJxFhRq4axS67P7SMy/CnRQqV+T7LyDvC0AB
         6rTW4VkCqib6LSZsnEjBQne+ibHqei5U+ofWCwrHhVW8LXkhPaLOBRwI+mR6uzm0YjYd
         M8og==
X-Gm-Message-State: APjAAAUVq8SCgW9BoeiGa1b02diIa9Gmjcv/3L9Lj3UtUOtHDEsZKyQ5
        O9D8nu8amvb/5aD0jngAJwure01CYv8=
X-Google-Smtp-Source: APXvYqzwjoLTJ4GC/4K7qCbx0Nz2MPkFF9H9zf0dYrmBEuhxIHlOWTkYBDq2s0LK0/GdWjyZ+ayKow==
X-Received: by 2002:a17:90a:35d0:: with SMTP id r74mr15084362pjb.47.1572613044493;
        Fri, 01 Nov 2019 05:57:24 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id m4sm7587000pjs.8.2019.11.01.05.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:57:24 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v5] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Fri,  1 Nov 2019 08:57:07 -0400
Message-Id: <20191101125707.10043-1-ethercflow@gmail.com>
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

v4->v5: addressed Andrii and Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names
- when fdget_raw fails, set ret to -EBADF instead of -EINVAL
- remove fdput from fdget_raw's error path
- use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
into the buffer or an error code if the path was too long
- modify the normal path's return value to return copied string lengh
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
---
 include/uapi/linux/bpf.h       | 15 ++++++++++-
 kernel/trace/bpf_trace.c       | 49 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 15 ++++++++++-
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a6bf19dabaab..d618a914c6fe 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2777,6 +2777,18 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2890,7 +2902,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f50bf19f7a05..fc9f577e65f5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -683,6 +683,53 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
+{
+	struct fd f;
+	char *p;
+	int ret = -EBADF;
+
+	/* Use fdget_raw instead of fdget to support O_PATH, and
+	 * fdget_raw doesn't have any sleepable code, so it's ok
+	 * to be here.
+	 */
+	f = fdget_raw(fd);
+	if (!f.file)
+		goto error;
+
+	/* d_path doesn't have any sleepable code, so it's ok to
+	 * be here. But it uses the current macro to get fs_struct
+	 * (current->fs). So this helper shouldn't be called in
+	 * interrupt context.
+	 */
+	p = d_path(&f.file->f_path, dst, size);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		fdput(f);
+		goto error;
+	}
+
+	ret = strlen(p);
+	memmove(dst, p, ret);
+	dst[ret++] = '\0';
+	fdput(f);
+	goto end;
+
+error:
+	memset(dst, '0', size);
+end:
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
@@ -735,6 +782,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_file_path:
+		return &bpf_get_file_path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a6bf19dabaab..d618a914c6fe 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2777,6 +2777,18 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2890,7 +2902,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

