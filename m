Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39CCEED19D
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 04:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfKCDyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 23:54:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35758 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbfKCDyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 23:54:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id q22so1435190pgk.2;
        Sat, 02 Nov 2019 20:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G5U2w3baiqk6WKudPml7vNTIN2O0WRpcHkS282aF5DE=;
        b=Djz53fcqXRk3pxz7Xv4NXX8uhUfPWE+QnhB3PtV5knJgOTo5hMjFntZWM4GIoDHawe
         3r64p0IZcCVcFwU4SfNVRHkcCnq746yTLjn9H12v0QpqHo+GAEEnKvUcXBYJ5TDjgoH+
         nGyZgHIYXP9BdPMypWJIsk2TwvbXK81nK2d4h9KjppPCuEGwKl2NqBbjWVO8YAA3UYIX
         bi0N5e/P/qRm8Zlv4WSsxeu2IoBlAfzaynHKYIq6uWIWc9uRFomKBNSWetBA+kpWZlCu
         z29iH3wVQHbkE96G5gizjx/TZs8X3wGBvkaPnQ42lBq0wjNq5XINwQih5X8JWKM9sgq+
         VDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G5U2w3baiqk6WKudPml7vNTIN2O0WRpcHkS282aF5DE=;
        b=KSEVPlpm9+pPGwl3+wO/yR09F3TnNrSRx71Y5IQhkmyXF/Ebo1bTmANB/vjRksGv6a
         syR7JbhMo5Epe2yjh/pHJCj/oTSoVBTnHIml0pzFRtXq9Xvp6kZqSQXtHEG/8yBI6oc8
         +G/bYFX3PhH3M+L2tgE4dVcScLNtkrDM382wHc+nQGq5vrDMRRTdu+ceS4IOWufsh3hw
         fiJ2esVLwjN0ZTW6eTYKG/MlhbFgCmk+dWVeLKpt/IXgIRHEXaxnByXlrUcFLWt9RCPe
         oU8iarw76nPEdApecl0/obCN8OZ5YbvpRHG7uQV8HvZ3nzkm4EydT7OTRfeXatN3WXh9
         21IQ==
X-Gm-Message-State: APjAAAUP2D0MuClN+/sAqIvQ00BdDLBobnkgZMny6KpnjKHkLFCJ57dj
        6MgWZ47iOEL+uchWwAy289c29cxT
X-Google-Smtp-Source: APXvYqz9+/AiyFvZddt+OMlRtLOn9my8FPBeflz3/p6/fyrXZYYLDtb/+0lLPMHD4V2PAfY1z/0tHQ==
X-Received: by 2002:a17:90a:2470:: with SMTP id h103mr27668759pje.12.1572753258174;
        Sat, 02 Nov 2019 20:54:18 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id w2sm13264190pgm.18.2019.11.02.20.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 20:54:17 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v6] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Sat,  2 Nov 2019 23:54:06 -0400
Message-Id: <20191103035406.5369-1-ethercflow@gmail.com>
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

v5->v6: addressed Andrii's feedback
- avoid unnecessary goto end by having two explicit returns

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
 kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 15 ++++++++++-
 3 files changed, 76 insertions(+), 2 deletions(-)

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
index f50bf19f7a05..41be1c5989af 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -683,6 +683,52 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
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
@@ -735,6 +781,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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

