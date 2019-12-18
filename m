Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F4C124F84
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLRRip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:38:45 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36257 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLRRio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:38:44 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so1201895pjb.1;
        Wed, 18 Dec 2019 09:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqrUOuKk2JGEFEQuYWcTKickDqlx6bClNhIOxM47HI4=;
        b=DWRc6O50gSs54r2ykKwMMFLq5Kl5SN8IAXH23IMr9Z6kVC714yNXv6+Z64++agh1wX
         4fm1xk1wWNLijm0jOB5LAWC2Lr/4CF5bseTHZk5TkgUSHiKLIrERMGPn20fzTf2cP8GE
         3NU9ExuLmsEz4wtLFpVb51lmh2dLzDS/lGOkR8byylO4T7NEojW9IUEIeSWEh8lxWRnw
         6WWq4H6JGm9/ODPHznq52A4MstFiul0EXm+SYEHOa1WnTPgMXevabG86sKJ9oZKffcnB
         5hmSEQTOEajqBgAiPwLmP1bHo7ygUznz9g8KkTuLHvSIOpQGcoG8JROIGRKkgJjov8Nb
         IWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqrUOuKk2JGEFEQuYWcTKickDqlx6bClNhIOxM47HI4=;
        b=T3RJUiEYoFJkn1YwqO3yqlnBBpqIZX6L5KRdMfONYPt2qdUmgGNs0iCxg22XwvlNU0
         TdOpDRq03FxB3ShihK/d7EkUByeJGmik1xVernlBWKnrlbzOWh4eOClxR1mKjjGtiU+g
         XckJTDItWNngQyHkQ6HrQNZbNHyv8lJu1ERQ9y08t1OHp4rWnp3inFbzNTeWZS09QMPG
         Vm+TABoMV/fNCeNV6gRVxS84/VNvsBdWAeDyh5J+K5bGGOTX+YemA+j3JL2cVApFHW5f
         PIjc6fbcGqCtDT7N1Mb8PA5bjaTgTCg3yWLPXkae4zo/iAiiWPhsfIQSDrIRamfd0/8H
         7iBQ==
X-Gm-Message-State: APjAAAWfd3IH+PsH2NjazQaFpbd30zv73+28Q3IGWl05j1+68fYQITuL
        fCkhpvofMapaBemXa1jKeyiaBjE1qck=
X-Google-Smtp-Source: APXvYqyBrooCAo6sGhgTemUSwTX4QJOojEGnum36ND7Wwt89gYlgnP1niB4Us76893uPQSoQcfgr2g==
X-Received: by 2002:a17:90a:2486:: with SMTP id i6mr4398088pje.9.1576690723800;
        Wed, 18 Dec 2019 09:38:43 -0800 (PST)
Received: from bpf-kern-dev.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id s15sm3991925pgq.4.2019.12.18.09.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:38:43 -0800 (PST)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v16 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Wed, 18 Dec 2019 14:38:24 -0300
Message-Id: <20191218173827.20584-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218173827.20584-1-cneirabustos@gmail.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
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
 include/uapi/linux/bpf.h | 19 ++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 45 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be5..a40b3e13cf98 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1224,6 +1224,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970..75864cd91b50 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2821,6 +2821,18 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
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
@@ -2938,7 +2950,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3689,4 +3702,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49e32acad7d8..59b892ab2acb 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2145,6 +2145,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index cada974c9f4e..4aea086c20e5 100644
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
index e5ef4ae9edb5..8c931cd1a768 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -822,6 +822,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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

