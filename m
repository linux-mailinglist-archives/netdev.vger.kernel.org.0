Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03BCDB09A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406631AbfJQPAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:00:48 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39352 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731768AbfJQPAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:00:48 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so2147032qki.6;
        Thu, 17 Oct 2019 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ibxCrQjjLmKEnH9cIzGG1Bmbb2ACnvCT12kEmqAt8LQ=;
        b=pwiGsGl7rIUv0+b/wMlbeIx7nGZqr9y+KNFDNvnNl8gN9uKPegFMd94qBF/8qxDjSj
         5L87rUzEKh0Eoecb7Mw4POA1LZpVkiQzGYJ9+I/oDUaZeaw5sZpWRfISs2+91BEINibk
         jMNPuGSzW3rSexTWSeb/Vza7chrclc38Gjs62cmnvSYTXKZhq1Dl7evy40+rJ8W8qTHH
         ZHsfO3FAdfJE705IWXI4UI5gyOhVf8WlzxGS7+GPWGfriQwfegb+T+v2fboVDUhpNcft
         V4ZPBF70O2PtXOB0cPGShA+PRiINRWsvU0nwfJInj8FzO7URF+Wrt3zSzcF9jupphJZU
         3mPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibxCrQjjLmKEnH9cIzGG1Bmbb2ACnvCT12kEmqAt8LQ=;
        b=fqTVu3QJNUitkS2g8I5bWTh/ScY+/hlgW2VyUp5YDmx00wzC8GL+tYGtOTc59cmQd4
         wg8ZW/UYB5PXR8C/3s2+Lx27ZxHi342KQBnqcrtb84sFUJSO7S3rof705PnVV3IOMniY
         DPN1omfM5DdIMSUKEibfRdmQWMOPHAwreqL1qRBJWxtAyqdN183bXjflM7NYc2zQJnF4
         MZ1i6JxPSbkkHvcf/2GnqfeiOjaTH+R3E4+qUuNM5NEK9G8xwDHU9PfOmhE4FxoxocCy
         FnQZp602RbxJvGpK/QVHqZvUYTX9XnF29lnWnorFzoFTJcItvTeVVQyyg7A6UXgRqhAl
         apmA==
X-Gm-Message-State: APjAAAWLGsrpvKEgujgooPfN0hes6Vx1PfLS07J1617YMshrWH49tYMu
        qszbKl9vXoeHI9ZIrduIPo4AQv9Qk9s=
X-Google-Smtp-Source: APXvYqwzm90/7C8i0s2JD/pE/RYoPHXCf8Stn+ZQd663SOYVMcOPfdPQRt2gMAEPnMJI+Gz7q7ycUQ==
X-Received: by 2002:a37:ac1a:: with SMTP id e26mr3705701qkm.20.1571324446373;
        Thu, 17 Oct 2019 08:00:46 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id z20sm1550859qtu.91.2019.10.17.08.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:00:45 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v14 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Thu, 17 Oct 2019 12:00:29 -0300
Message-Id: <20191017150032.14359-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017150032.14359-1-cneirabustos@gmail.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New bpf helper bpf_get_ns_current_pid_tgid,
This helper will return pid and tgid from current task
which namespace matches dev_t and inode number provided,
this will allows us to instrument a process inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h | 20 +++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 45 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..231001475504 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a65c3b0c6935..a17583ae9aa3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2750,6 +2750,19 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2875,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),          \
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3613,4 +3627,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..b2fd5358f472 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..5477ad984d7c 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,8 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +489,46 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_4(bpf_get_ns_current_pid_tgid, u64, dev, u64, ino,
+	   struct bpf_pidns_info *, nsdata, u32, size)
+{
+	struct task_struct *task = current;
+	struct pid_namespace *pidns;
+	int err = -EINVAL;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		goto clear;
+
+	if (unlikely((u64)(dev_t)dev != dev))
+		goto clear;
+
+	if (unlikely(!task))
+		goto clear;
+
+	pidns = task_active_pid_ns(task);
+	if (unlikely(!pidns)) {
+		err = -ENOENT;
+		goto clear;
+	}
+
+	if (!ns_match(&pidns->ns, (dev_t)dev, ino))
+		goto clear;
+
+	nsdata->pid = task_pid_nr_ns(task, pidns);
+	nsdata->tgid = task_tgid_nr_ns(task, pidns);
+	return 0;
+clear:
+	memset((void *)nsdata, 0, (size_t) size);
+	return err;
+}
+
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
+	.func		= bpf_get_ns_current_pid_tgid,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type      = ARG_CONST_SIZE,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 44bd08f2443b..32331a1dcb6d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_ns_current_pid_tgid:
+		return &bpf_get_ns_current_pid_tgid_proto;
 	default:
 		return NULL;
 	}
-- 
2.20.1

