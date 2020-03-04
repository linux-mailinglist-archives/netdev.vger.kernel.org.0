Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF0179A55
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388295AbgCDUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:42:52 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32781 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388230AbgCDUmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:42:52 -0500
Received: by mail-qk1-f194.google.com with SMTP id p62so3087974qkb.0;
        Wed, 04 Mar 2020 12:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e/XdTuBcTBU3OvToQ1oQMV0HPKeoQN+MyXw643ySz0k=;
        b=FiZibzMfIRDuqgCQakpTGLqbBB/RQUgEqftKDmi+bcDocykrJM5nt6zSVD6Eqay0Fm
         DtKZBQRFkzbW+qPaFgKMvdYZJV5i+8ytUr+J4Itd689y6BFrR1pzNZarrujIGy1SxZp9
         Su5yKP/7wnrszG3rWWgKHvQphaRCCggTLFsAr3NTxm+DgGjCi+xdeFOX+QIIOCNj8qDJ
         4Tw+C5UaPnyoCxAakNdrL3D5CL58hi6nk/sE04nDfd8b58mUsMFM2hGxxfYFcySwC949
         6jL3eBMN/LCFKGk4qCSF9PPUoggLCX+RTeSOL+eRqcyzNWDPQygdMoFXNAcQizwMJKow
         VZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e/XdTuBcTBU3OvToQ1oQMV0HPKeoQN+MyXw643ySz0k=;
        b=lg9uBGGdfwxjYKSRNllrkZ4TyURhUfxDvB9zaP2QYwK6dZ0yEf1QBhRI+zX0LHlaKv
         QF0uh9XEN4NW3r5OY2DiAMyEqUnzB+e5A9qB5XX91yBOoLqgZDi586yS53W+rULHfbEe
         SAk3wLacJxAPWJvGtZFVKjbEb91pfn630Mky27hg69ZChmRrxr4QXmmC/WQZ0om02pvT
         9JOYrRN6naNDwHykfvHQNS8j/xKH7kWwuUzUrpMFON2d71d2LBmpzFM8hm53qWtsAkJr
         LOf3cnyQRhbVJJxlSvuiXYat3bwkV2vfRp78Dscrg4lotwQfX1HgppaJwAxeRlfXOa+U
         mZzw==
X-Gm-Message-State: ANhLgQ0FosHLvbDHWWWM01bGScTzawTbt3LrY24WFKsy7+DvcPla0Q9F
        ei9Mcb8oba5xpyPuMjWjyEHci2/8Knc=
X-Google-Smtp-Source: ADFU+vuKJEhGVBIbrJpnm87uxdEcoKf2bAgUVqk9ljM6gNr7F44CUEKvn9YotQEyvV8vGC8fy6NBIA==
X-Received: by 2002:ae9:efc8:: with SMTP id d191mr1632872qkg.1.1583354570629;
        Wed, 04 Mar 2020 12:42:50 -0800 (PST)
Received: from localhost.localdomain (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id 82sm1750232qko.91.2020.03.04.12.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 12:42:50 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v17 2/3] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Wed,  4 Mar 2020 17:41:56 -0300
Message-Id: <20200304204157.58695-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304204157.58695-1-cneirabustos@gmail.com>
References: <20200304204157.58695-1-cneirabustos@gmail.com>
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

Acked-by: Yonghong Song <yhs@fb.com>

---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 20 ++++++++++++++-
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 45 ++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 scripts/bpf_helpers_doc.py     |  1 +
 tools/include/uapi/linux/bpf.h | 20 ++++++++++++++-
 7 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f13c78c6f29d..8d6380394388 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1472,6 +1472,7 @@ extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_jiffies64_proto;
+extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d6b33ea27bcc..f3ad826fa3bd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2913,6 +2913,19 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if pidns does not exists for the current task.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3034,7 +3047,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3828,4 +3842,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 973a20d49749..0f9ca46e1978 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2149,6 +2149,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d8b7b110a1c5..01878db15eaf 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -12,6 +12,8 @@
 #include <linux/filter.h>
 #include <linux/ctype.h>
 #include <linux/jiffies.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -499,3 +501,46 @@ const struct bpf_func_proto bpf_strtoul_proto = {
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
index 07764c761073..d7985629a3b1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -843,6 +843,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_send_signal_thread_proto;
 	case BPF_FUNC_perf_event_read_value:
 		return &bpf_perf_event_read_value_proto;
+	case BPF_FUNC_get_ns_current_pid_tgid:
+		return &bpf_get_ns_current_pid_tgid_proto;
 	default:
 		return NULL;
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index cebed6fb5bbb..c1e2b5410faa 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -435,6 +435,7 @@ class PrinterHelpers(Printer):
             'struct bpf_fib_lookup',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
+            'struct bpf_pidns_info',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d6b33ea27bcc..f3ad826fa3bd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2913,6 +2913,19 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if pidns does not exists for the current task.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3034,7 +3047,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3828,4 +3842,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.20.1

