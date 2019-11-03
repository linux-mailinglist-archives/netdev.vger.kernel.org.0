Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17876ED26E
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 08:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKCHv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 02:51:56 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42631 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfKCHvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 02:51:55 -0500
Received: by mail-pg1-f196.google.com with SMTP id s23so5846474pgo.9;
        Sun, 03 Nov 2019 00:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SkmcapJ73QXS68Jfsbns/p+eFkvGR8O0O/11EiX1vMY=;
        b=pVa/Kpg2odmwVemqtGbiBfpfCrI2GLcO52TsYV4Bm0SV37P9vFb7/tJ6DNLLKD1zom
         huD2CL0RYIz8yHkzvYyV+3YLDGxTRm9juDx67kUBFsiK0dRnCaPpjP808Ix67UpFh8oa
         lziUBAsQsj2I3x5SUvygqPxLwc3tEpAgTc7zbW7NFAfB5fFWRuyM/+G0iRDEgU8UV7Id
         rZtFpMZNNvvQqrqg3rS6yb33TxVYj5Qe+DzmdOuzVU/gnLazwUJKyBpfNGWIficBpqpp
         3P+9vPE4zrDCWkfvYUdU/fnGIkp7RW8kpiEBoRxidmMRpUH616c4tlzxQwEEvBNAjvCd
         pFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SkmcapJ73QXS68Jfsbns/p+eFkvGR8O0O/11EiX1vMY=;
        b=fMP4znLbrB5zHf5iRvQbHgdeeh6/Jtfen/uuF5cW9pze0IzU22Od/Sj7uXolH4y3kF
         gMGlh/UTD1/+kXa/C9q/om0Lpy0JxA/lSON1fq9nbW6pdJXyMrUhdBDHvXmDVhHcJjgI
         9992Hv1zvgi8Jo8n/qZxQpKFBiBSvndQrTD90H8YXzk7zU6EAs/crUzBewe7sRNEdsBk
         +9QkTVj54+EJsO5FFtXkNIwvXy8gh7haKrKejcDcz+F2c6c5Pg/w4IQ6aC96ZJjOvQum
         TwNWlr1OfHAppCGnYvTTgWEI1BfSCXW69n2OspRi77qWuQinSjzrSCDwMvf0xFy2X5//
         Y20g==
X-Gm-Message-State: APjAAAUUdVZvv4AamcIaedNLJ7Tlub9d4OBEi6dWy/T7iuyJEuqpEpVL
        XeQ6KFIpGid8PKQUpYGJsG8YMH7V
X-Google-Smtp-Source: APXvYqzVs0W4XbAtD3TVQbhDqkQ7s7usTMyXkSR3qQMNjuJZVV05Yhp+uVR2tBEsFrKRQL0Xqnqv1Q==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr27482371pji.126.1572767513190;
        Sun, 03 Nov 2019 00:51:53 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id b200sm6531697pfb.86.2019.11.03.00.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 00:51:52 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v7] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Sun,  3 Nov 2019 02:51:40 -0500
Message-Id: <20191103075140.34039-1-ethercflow@gmail.com>
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

