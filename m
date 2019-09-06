Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F54ABBD7
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbfIFPK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:10:26 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:44465 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFPKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:10:25 -0400
Received: by mail-ua1-f65.google.com with SMTP id z8so2139992uaq.11;
        Fri, 06 Sep 2019 08:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n314PeD9rJUUH0ln6INZ73thO3OSZWeNNOdQWNTDRHs=;
        b=oXrqX6diObqthzEuEuVfNSpy9U5FfSqxQ7kCgw5JxpL+Gc19eru92cgdITU1okFMRg
         TCcIi/3fDI9xUzZkYtAUy+R61TlJ1/f9Mbtib1gVdbUVzXrMACPw6Yqg5f6MhUvE7f3y
         bp5xq5iU0w1pvrwPLcJFyurxSVd5KLemYsaCm8gqOwPIwW+HSaXS8sZywX72vwa+6/D2
         f6ApHIoxpVJ22TEsXQHG4asoBLXcLDNihe34mzXBZ/dP5j16tCS8R+HEfy4Eo9kePU9r
         iOL33Uc9hcsk3F4CMCJOrvbOKSKWOrhP+u/JjyyYBe9i08yuK6bA3acPEftlnyDLP/zL
         714A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n314PeD9rJUUH0ln6INZ73thO3OSZWeNNOdQWNTDRHs=;
        b=bFeMjmY9dKe+Kp03T32pIZMijHuYY4zykXO+6OLtmFyVrEKOtNMNY99B8tkr8tXNa2
         fvST1uZ69ZatYx+s0etFErrnZjnRjPEwLVfizMOpOXoEd9rZup8TKqc8MKNNmpRfKXuW
         TDSNJY/cCVfXJ71NIwI7N5EYKURBwMIln/OcjhAYUsQmIEf+iyP8sDQlRRLENgNjnCKS
         D/oMBeIvhQLUeizEoeQt6R4ET65X+6OIrl04ep7pC717URMqc0Zl+Q/GXFyCfSp5IOIm
         7nkBomTHsnwjZAAnwq5/scA07dueDaSBpEGSNGPrdwfoYA5VrsQfVYU0ezJ3Kd+SjCs9
         KooA==
X-Gm-Message-State: APjAAAV/veArt2Zbw5sx0EhJsqv/cZg2CT8BOA+nKiHP2caOcSkJmpZI
        6O1ik9vnohWvXq25h2/0snhgswaHQ1Y=
X-Google-Smtp-Source: APXvYqyMC7LshSz0/GZETxrgMPRhSwcKRup5EIn8NuC4mH5dOMyBla4rKgPOLMxgwFWqhCZneyKAcw==
X-Received: by 2002:ab0:1446:: with SMTP id c6mr4602681uae.120.1567782623802;
        Fri, 06 Sep 2019 08:10:23 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id o15sm4833822vkc.38.2019.09.06.08.10.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:10:23 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data from  current task New bpf helper bpf_get_current_pidns_info.
Date:   Fri,  6 Sep 2019 11:09:50 -0400
Message-Id: <20190906150952.23066-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906150952.23066-1-cneirabustos@gmail.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper(bpf_get_current_pidns_info) obtains the active namespace from
current and returns pid, tgid, device and namespace id as seen from that
namespace, allowing to instrument a process inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h | 35 +++++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..819cb1c84be0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_current_pidns_info_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b5889257cc33..3ec9aa1438b7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2747,6 +2747,32 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Get tgid, pid and namespace id as seen by the current namespace,
+ *		and device major/minor numbers from /proc/self/ns/pid. Such
+ *		information is stored in *pidns* of size *size*.
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper always returns the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
+ *		or tgid of the current task.
+ *
+ *		**-ENOENT** if /proc/self/ns/pid does not exists.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
+ *		**-ENOMEM** if helper internal allocation fails.
+ *
+ *		**-EPERM** if not able to call helper.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2859,7 +2885,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3610,4 +3637,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;	/* dev_t from /proc/self/ns/pid inode */
+	__u32 nsid;
+	__u32 tgid;
+	__u32 pid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8191a7db2777..3159f2a0188c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2038,6 +2038,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_current_pidns_info __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..8dbe6347893c 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,11 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/kdev_t.h>
+#include <linux/stat.h>
+#include <linux/namei.h>
+#include <linux/version.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -312,6 +317,87 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	preempt_enable();
 }
 
+BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
+	 size)
+{
+	const char *pidns_path = "/proc/self/ns/pid";
+	struct pid_namespace *pidns = NULL;
+	struct filename *fname = NULL;
+	struct inode *inode;
+	struct path kp;
+	pid_t tgid = 0;
+	pid_t pid = 0;
+	int ret = -EINVAL;
+	int len;
+
+	if (unlikely(in_interrupt() ||
+			current->flags & (PF_KTHREAD | PF_EXITING)))
+		return -EPERM;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		return -EINVAL;
+
+	pidns = task_active_pid_ns(current);
+	if (unlikely(!pidns))
+		return -ENOENT;
+
+	pidns_info->nsid =  pidns->ns.inum;
+	pid = task_pid_nr_ns(current, pidns);
+	if (unlikely(!pid))
+		goto clear;
+
+	tgid = task_tgid_nr_ns(current, pidns);
+	if (unlikely(!tgid))
+		goto clear;
+
+	pidns_info->tgid = (u32) tgid;
+	pidns_info->pid = (u32) pid;
+
+	fname = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
+	if (unlikely(!fname)) {
+		ret = -ENOMEM;
+		goto clear;
+	}
+	const size_t fnamesize = offsetof(struct filename, iname[1]);
+	struct filename *tmp;
+
+	tmp = kmalloc(fnamesize, GFP_ATOMIC);
+	if (unlikely(!tmp)) {
+		__putname(fname);
+		ret = -ENOMEM;
+		goto clear;
+	}
+
+	tmp->name = (char *)fname;
+	fname = tmp;
+	len = strlen(pidns_path) + 1;
+	memcpy((char *)fname->name, pidns_path, len);
+	fname->uptr = NULL;
+	fname->aname = NULL;
+	fname->refcnt = 1;
+
+	ret = filename_lookup(AT_FDCWD, fname, 0, &kp, NULL);
+	if (ret)
+		goto clear;
+
+	inode = d_backing_inode(kp.dentry);
+	pidns_info->dev = (u32)inode->i_rdev;
+
+	return 0;
+
+clear:
+	memset((void *)pidns_info, 0, (size_t) size);
+	return ret;
+}
+
+const struct bpf_func_proto bpf_get_current_pidns_info_proto = {
+	.func		= bpf_get_current_pidns_info,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+};
+
 #ifdef CONFIG_CGROUPS
 BPF_CALL_0(bpf_get_current_cgroup_id)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..5e1dc22765a5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -709,6 +709,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_current_pidns_info:
+		return &bpf_get_current_pidns_info_proto;
 	default:
 		return NULL;
 	}
-- 
2.11.0

