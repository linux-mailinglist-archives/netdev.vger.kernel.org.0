Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31C2D126C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbfJIP0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:26:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39242 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIP0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:26:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so3982796qtb.6;
        Wed, 09 Oct 2019 08:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gLrccfQSPN88or4knKZ/oRltVurvWLGNIQNyDLr0FI8=;
        b=UuQPXmfcvH+zzw+BI1BGgQg5eQ4kugkIN4ete++I1hWLzUur6jRwweIgwDk9COApju
         q3Rny+Kt8rwTyL/oVBjnN3zbhvu2vZelJF+MpLJdXSMltJllg6y2I0YACw4K2z4fiRqu
         W9ZvyjdmW8HnYyYH3xgaDxrg9DpWk+0yYcKgG3XKAzhvVr48yeu37ziN1kVyV4dCXp4d
         ETknAwq7CeSpRZPbgwBd+3nGhoSM0CLj60A+C7kZwhnoBcJjzMaoYZ9iYBVw0DQvD80R
         f0aDYKko0CNzj9LgagmrQJiCg+hPplUn8tIZmYzRybf2I2HVpwTfuli91E8/l69nCLq1
         jkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gLrccfQSPN88or4knKZ/oRltVurvWLGNIQNyDLr0FI8=;
        b=fViTs1sQ8CbDsKypBX+vdvhH8I4LH7GeS12RSWQV7bHC1El4g77Mg5FVE1bTM4cw+S
         GX4rpaT1/zuj7f+hVNvseF1NzOGE5J1K7ysvgDAtYefRF7M+ArAJBiOL8m7PHFGPdIGn
         82pGjXVc4dvIwOdKXU0rTjkBOU5hlWb4wumDidLPoIzsEQeqXra/KPZ24C+nNJunSA1N
         2lVU4MZCato9IYI/1/F4d5qtOrls1oQXxw7L9T1AJIWi1mlrzPCdtIe4MangZ49Yx14A
         WsEF70oLtmby8ZfuAGZFBG6fjd5r5BvyLCFubCGGzkBVUR9AOm58XQDq48+uOyS9aDPC
         sZEA==
X-Gm-Message-State: APjAAAVe53xreeiHXc4i9OoQc9qd2X/bQjmUZCfHyUOUn2GuPwM1r8mj
        5KlbX71SWkpey6H6ehNh9+bjGUExIJE=
X-Google-Smtp-Source: APXvYqyW/c0Jf6ELYYvxJ6woASryeA3+IxoX0qqDSRG7VcW2IKpMy8vgGmmT6FRnjZoEeO1ti/4RnQ==
X-Received: by 2002:a05:6214:3ce:: with SMTP id ce14mr4108090qvb.174.1570634807277;
        Wed, 09 Oct 2019 08:26:47 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id l189sm1049895qke.69.2019.10.09.08.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 08:26:46 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v13 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Wed,  9 Oct 2019 12:26:30 -0300
Message-Id: <20191009152632.14218-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009152632.14218-1-cneirabustos@gmail.com>
References: <20191009152632.14218-1-cneirabustos@gmail.com>
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
 include/uapi/linux/bpf.h | 22 +++++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 43 ++++++++++++++++++++++++++++++++++++++++
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
index 77c6be96d676..6ad3f2abf00d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2750,6 +2750,19 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(struct *bpf_pidns_info, u32 size)
+ *	Return
+ *		0 on success, values for pid and tgid from nsinfo will be as seen
+ *		from the namespace that matches dev and inum from nsinfo.
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
@@ -3613,4 +3627,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u64 dev;
+	__u64 inum;
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
index 5e28718928ca..78a1ce7726aa 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,8 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +489,44 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_2(bpf_get_ns_current_pid_tgid, struct bpf_pidns_info *, nsdata, u32,
+	size)
+{
+	struct task_struct *task = current;
+	struct pid_namespace *pidns;
+	int err = -EINVAL;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		goto clear;
+
+	if ((u64)(dev_t)nsdata->dev != nsdata->dev)
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
+	if (!ns_match(&pidns->ns, (dev_t)nsdata->dev, nsdata->inum))
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
+	.arg1_type      = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type      = ARG_CONST_SIZE,
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

