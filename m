Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1CEE736F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 15:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389775AbfJ1OLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 10:11:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33435 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbfJ1OLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 10:11:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id y8so5650358plk.0;
        Mon, 28 Oct 2019 07:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wr2qSyKGZ5IFDokw96ZYkbcrvyw06+H0FC+Bn5dRPyo=;
        b=e6slJevoqQo/YVUh8Xnkc+rmtrZ19Jfw4qAIzn3tx/aoR18jKNZ2RWjMZtr6UnBIn4
         ahqcsijX/DfE4GJ6miHo/D3a+49jUmz6NKP84n7W7X4Ak+s+18Pz5hyngNb3qvSXNsLU
         5N0svGRhafuwDhPbDBFApjgerE6qkjMXUMxmA+QbGO0goIKG3Rg1TwIMSX8jARhFXTr3
         JT7O52ag5m1tgkcgudzyyeU48v91jV11m0muPjRmI81XW0D3aV0gNsDKF+E+wFTWBYCC
         oIYckdKaTahVaiVPvl4LUQTZZpsUrz8F28nQT5qxROw/0Q7uR62SA7VWPoeXeWEq6ZaP
         9hqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wr2qSyKGZ5IFDokw96ZYkbcrvyw06+H0FC+Bn5dRPyo=;
        b=CjhBigvY2rwqs4uIx/o49dF8ldDTxdLzBjKThTUBvXNsty8B2F5knV/AQCzJ7efHEu
         DG50DD2pMUcsjAbtkv8lZF2mdbxBFgVpumIE0ySUdsj4QD2o8IlNppELg8q+a5Xz5q8Q
         WqU27taD9Cm6JyDQ3GaHT3csUD43uToTd5LIg/befkqJQkbt6zfky3xf8Q/QGDSwP+9Q
         RyrwFo/DncTrMoFULRboY36ED8y16TGJQQ5OtVmGD903eyWvY/cDQ4G3MjghqxukBWH7
         e6LLkfyUFRkeL36+EYJYtkihxJt2uXnpF8qN2ssztyFAPjzauEiIOgnjR5MBPdT0AXD7
         cO0Q==
X-Gm-Message-State: APjAAAXztbXOfFMZV8srZfNoo5IqbwUoNClo/K0XpKQPrZMoc5REaDFm
        asDB39NGMCTVgeM3zOjpGUkUbKeMMXo=
X-Google-Smtp-Source: APXvYqxBY5ok3G+PuasR6A0BTc8qsqOZ+7HIbeyw3CsDHVDTrB+P06rbxpdYq98lDdiAApXjsBaIsA==
X-Received: by 2002:a17:902:6a81:: with SMTP id n1mr19182160plk.173.1572271867602;
        Mon, 28 Oct 2019 07:11:07 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id a5sm2579125pfk.172.2019.10.28.07.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 07:11:07 -0700 (PDT)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     yhs@fb.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        Wenbo Zhang <ethercflow@gmail.com>
Subject: [PATCH bpf-next v4] bpf: add new helper fd2path for mapping a file descriptor to a pathname
Date:   Mon, 28 Oct 2019 10:10:53 -0400
Message-Id: <20191028141053.12267-1-ethercflow@gmail.com>
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

v3->v4:
- fix missing fdput()
- move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
- move fd2path's test code to another patch

v2->v3:
- remove unnecessary LOCKDOWN_BPF_READ
- refactor error handling section for enhanced readability
- provide a test case in tools/testing/selftests/bpf

v1->v2:
- fix backward compatibility
- add this helper description
- fix signed-off name

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 include/uapi/linux/bpf.h       | 14 +++++++++++-
 kernel/trace/bpf_trace.c       | 40 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 +++++++++++-
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..124632b2a697 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2775,6 +2775,17 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2899,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(fd2path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 571c25d60710..dd7b070df3d6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -683,6 +683,44 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
+{
+	struct fd f;
+	char *p;
+	int ret = -EINVAL;
+
+	/* Use fdget_raw instead of fdget to support O_PATH */
+	f = fdget_raw(fd);
+	if (!f.file)
+		goto error;
+
+	p = d_path(&f.file->f_path, dst, size);
+	if (IS_ERR_OR_NULL(p)) {
+		ret = PTR_ERR(p);
+		goto error;
+	}
+
+	ret = strlen(p);
+	memmove(dst, p, ret);
+	dst[ret] = '\0';
+	goto end;
+
+error:
+	memset(dst, '0', size);
+end:
+	fdput(f);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_fd2path_proto = {
+	.func       = bpf_fd2path,
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
@@ -735,6 +773,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_fd2path:
+		return &bpf_fd2path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..124632b2a697 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2775,6 +2775,17 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_fd2path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. The **path** also support pseudo filesystems
+ *		(whether or not it can be mounted). The *size* must be strictly
+ *		positive. On success, the helper makes sure that the *path* is
+ *		NUL-terminated. On failure, it is filled with zeroes.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2899,8 @@ union bpf_attr {
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

