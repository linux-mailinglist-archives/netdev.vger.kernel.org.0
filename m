Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A37C253454
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHZQFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgHZQEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:04:41 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076DEC061574;
        Wed, 26 Aug 2020 09:04:41 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cs12so952959qvb.2;
        Wed, 26 Aug 2020 09:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwtkn8jfzOHS+ZPoSHaK83LPofDShb0WhWs6tgkIXkU=;
        b=O5dj9JkY1YXBIN8K5SpppN8mS39zd2PcE9OzQUFV1jKTZ4xkyQGBjo/Ao9IhZiSlDj
         Gca6DwCkWPhK3X0J4bbHy/oCCPZGnFCa5hTSGiOn9YKt2/F/njm7p3DKR3UBk70oOeyE
         pBTUUK16lwUoj7XuoENk9XUrZzumR53ZWbH5t41npvvQTcyZYKe0DrpgS4rZJd/D5GqI
         RQmyWfYK2FmFNeNRtBG65fwDR9oSDSnnbpHwCCg2o05dDfIF206BVhXgG2xAIPi/4vr4
         2FmVOv7uSpsgkmw35Z9BURl6dunAFCudwKaKdfVpL4VH8g7Oex84i4lZSKZlSb8Rn315
         XDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nwtkn8jfzOHS+ZPoSHaK83LPofDShb0WhWs6tgkIXkU=;
        b=AhmwJaRBSJ90cVpZh7ysEs347NL/G64W3brwPY5cYvYO2AP18QPPmRaaecnKkI3NHx
         jzSMXOLe1EMtIphNV2/LbFKGTM3rdL8DeNA1kmkt/+tY5lKAgT1IbIomAgBspCJY31nU
         /q2pwD+tdos4hNUR7ISddN0PZKzVXrvp5GhplxgCcELq/IozrwXU4Uh6sHaJci2vsFCS
         LASluwT808UrI/RDyQdDRyUit2SLRu0O6UukKpzusJkQOBhO0L7Dh9hjE8REPuGjpb+S
         1LciQwI9nYAzF8fj6xxKzX8skEHR/j8JYN8AjIhlJ6Ebu/M4nL5RwLgvOMkf1XDaQZqr
         2yeg==
X-Gm-Message-State: AOAM532tHq/1sxtNc8sbWbuM6MkiwZvWWBDttrzRy/oC+/KI+4iSrFy2
        Z4yqaBOd4tfEKIjOKc+z4cihbx7rJAOx22ntPxI=
X-Google-Smtp-Source: ABdhPJwxwFI+OKdQAG6XWCYQ2n/mIi0NbL7zxxQ+XNbpSllaBQUPCtpHXmUwZteDyE58LemfNS+GAQ==
X-Received: by 2002:a0c:a224:: with SMTP id f33mr14519847qva.93.1598457879750;
        Wed, 26 Aug 2020 09:04:39 -0700 (PDT)
Received: from localhost.localdomain (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.googlemail.com with ESMTPSA id n142sm1032547qke.60.2020.08.26.09.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 09:04:39 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, andriin@fb.com, cneirabustos@gmail.com
Subject: [PATCH v1 bpf-next] bpf: new helper bpf_get_current_pcomm
Date:   Wed, 26 Aug 2020 12:04:24 -0400
Message-Id: <20200826160424.14131-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In multi-threaded applications bpf_get_current_comm is returning per-thread 
names, this helper will return comm from real_parent.
This makes a difference for some Java applications, where get_current_comm is 
returning per-thread names, but get_current_pcomm will return "java".

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 15 ++++-
 kernel/bpf/core.c                             |  1 +
 kernel/bpf/helpers.c                          | 28 +++++++++
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 15 ++++-
 .../selftests/bpf/prog_tests/current_pcomm.c  | 57 +++++++++++++++++++
 .../selftests/bpf/progs/test_current_pcomm.c  | 17 ++++++
 8 files changed, 134 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/current_pcomm.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_current_pcomm.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 81f38e2fda78..93b0c197fd75 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1754,6 +1754,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
+extern const struct bpf_func_proto bpf_get_current_pcomm_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 544b89a64918..200a2309e5e1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3509,6 +3509,18 @@ union bpf_attr {
  *
  *		**-EPERM** This helper cannot be used under the
  *			   current sock_ops->op.
+ *
+ * long bpf_get_current_pcomm(void *buf, u32 size_of_buf)
+ *	Description
+ *		Copy the **comm** attribute of the real_parent current task
+ *		into *buf* of *size_of_buf*. The **comm** attribute contains
+ *		the name of the executable (excluding the path) for real_parent
+ *		of current task.
+ *		The *size_of_buf* must be strictly positive. On success, the
+ *		helper makes sure that the *buf* is NUL-terminated. On failure,
+ *		it is filled with zeroes.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3655,7 +3667,8 @@ union bpf_attr {
 	FN(get_task_stack),		\
 	FN(load_hdr_opt),		\
 	FN(store_hdr_opt),		\
-	FN(reserve_hdr_opt),
+	FN(reserve_hdr_opt),		\
+	FN(get_current_pcomm),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..fd346c2ff6f6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2208,6 +2208,7 @@ const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_current_ancestor_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
 const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
+const struct bpf_func_proto bpf_get_current_pcomm_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be43ab3e619f..9fb663945e0b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -575,6 +575,34 @@ const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
 	.arg4_type      = ARG_CONST_SIZE,
 };
 
+BPF_CALL_2(bpf_get_current_pcomm, char *, buf, u32, size)
+{
+	struct task_struct *task = current;
+
+	if (unlikely(!task))
+		goto err_clear;
+
+	strncpy(buf, task->real_parent->comm, size);
+
+	/* Verifier guarantees that size > 0. For task->comm exceeding
+	 * size, guarantee that buf is %NUL-terminated. Unconditionally
+	 * done here to save the size test.
+	 */
+	buf[size - 1] = 0;
+	return 0;
+err_clear:
+	memset(buf, 0, size);
+	return -EINVAL;
+}
+
+const struct bpf_func_proto bpf_get_current_pcomm_proto = {
+	.func		= bpf_get_current_pcomm,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+};
+
 static const struct bpf_func_proto bpf_get_raw_smp_processor_id_proto = {
 	.func		= bpf_get_raw_cpu_id,
 	.gpl_only	= false,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a8d4f253ed77..7cfeb58c729a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1182,6 +1182,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_get_task_stack:
 		return &bpf_get_task_stack_proto;
+	case BPF_FUNC_get_current_pcomm:
+		return &bpf_get_current_pcomm_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 544b89a64918..200a2309e5e1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3509,6 +3509,18 @@ union bpf_attr {
  *
  *		**-EPERM** This helper cannot be used under the
  *			   current sock_ops->op.
+ *
+ * long bpf_get_current_pcomm(void *buf, u32 size_of_buf)
+ *	Description
+ *		Copy the **comm** attribute of the real_parent current task
+ *		into *buf* of *size_of_buf*. The **comm** attribute contains
+ *		the name of the executable (excluding the path) for real_parent
+ *		of current task.
+ *		The *size_of_buf* must be strictly positive. On success, the
+ *		helper makes sure that the *buf* is NUL-terminated. On failure,
+ *		it is filled with zeroes.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3655,7 +3667,8 @@ union bpf_attr {
 	FN(get_task_stack),		\
 	FN(load_hdr_opt),		\
 	FN(store_hdr_opt),		\
-	FN(reserve_hdr_opt),
+	FN(reserve_hdr_opt),		\
+	FN(get_current_pcomm),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/tools/testing/selftests/bpf/prog_tests/current_pcomm.c b/tools/testing/selftests/bpf/prog_tests/current_pcomm.c
new file mode 100644
index 000000000000..23b708e1c417
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/current_pcomm.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_current_pcomm.skel.h"
+#include <sys/types.h>
+#include <unistd.h>
+#include <string.h>
+#include <pthread.h>
+
+void *current_pcomm(void *args)
+{
+	struct test_current_pcomm__bss  *bss;
+	struct test_current_pcomm *skel;
+	int err, duration = 0;
+
+	skel = test_current_pcomm__open_and_load();
+	if (CHECK(!skel, "skel_open_load", "failed to load skeleton"))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = test_current_pcomm__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed %d", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(10);
+	err = memcmp(bss->comm, "current_pcomm2", 14);
+	if (CHECK(!err, "pcomm ", "bss->comm: %s\n", bss->comm))
+		goto cleanup;
+cleanup:
+	test_current_pcomm__destroy(skel);
+	return NULL;
+}
+
+int test_current_pcomm(void)
+{
+	int err = 0, duration = 0;
+	pthread_t tid;
+
+	err = pthread_create(&tid, NULL, &current_pcomm, NULL);
+	if (CHECK(err, "thread", "thread creation failed %d", err))
+		return EXIT_FAILURE;
+	err = pthread_setname_np(tid, "current_pcomm2");
+	if (CHECK(err, "thread naming", "thread naming failed %d", err))
+		return EXIT_FAILURE;
+
+	usleep(5);
+
+	err = pthread_join(tid, NULL);
+	if (CHECK(err, "thread join", "thread join failed %d", err))
+		return EXIT_FAILURE;
+
+	return EXIT_SUCCESS;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_current_pcomm.c b/tools/testing/selftests/bpf/progs/test_current_pcomm.c
new file mode 100644
index 000000000000..27dab17ccdd4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_current_pcomm.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+char comm[16] = {0};
+
+SEC("raw_tracepoint/sys_enter")
+int current_pcomm(const void *ctx)
+{
+	bpf_get_current_pcomm(comm, sizeof(comm));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

