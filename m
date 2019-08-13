Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F58C105
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfHMSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:48:08 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:43257 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMSsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:48:08 -0400
Received: by mail-ua1-f66.google.com with SMTP id o2so41915746uae.10;
        Tue, 13 Aug 2019 11:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bz98vP4baWUrQuOYyoM2pIfDbyFEJEZfdggGEakenFo=;
        b=De5NI0n3M19SP+QZ2Qnj1+MeE9+s8lENsIw07CfnL7maNnP/x+N8HkA34cZgUP8kbw
         3tvMR/VkGtNT+CcegmCqV9l4hecAtgYcnl7W+6wqHBOElKX014mjQaoJMe8Zf1QHFNQr
         yKRinnzrMtPXhMgfVCFlVn3egqCqxfz7NAr4PWu3OEEDFWgaBvOpDQ0BHBi70difuxUs
         GHtkkediPUfO6N2naWS0ECY96LiuAqtgmUo0f9ZV37fKK8Ly0jsmob3FMwdonA6LdwhB
         HMwlgCuzadfPxWdFlk3EWVFhcNbfteO7uFBAt/RRL7FUK4G9P2oGAL2i4rsRZGeWGNq3
         bWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bz98vP4baWUrQuOYyoM2pIfDbyFEJEZfdggGEakenFo=;
        b=SB9HU5pvRjGpY92IzOmcakS6L902JpEsx3lUW1RoK0vHm/ANm2Mg1M17whCP3hYFQn
         YB8/cZnTI9J/7il+xeC0hQpbszNBIIx0Qdg0UF0QF5Eik+LGBKeIw8Ed9iNkgDaPLx7Y
         QM0wWYWY52aUijmr38KGEFIyFv/Ek4HRDYXHR/SjgcaUbEpvDKvWLmOzTny3/jBERskY
         JhVvGW4xza7U9I/GErkvCwjUMLVPzrkA7FMZ4yXiHbAgrYAAt05fzPAHmaT83lzKCkMT
         MNrvBOqAHRU1mgMe2NG0mrOy1/ez0CLUNXyZ2k2isLzIHYwkMA9THh36QYDUUXUk73JA
         oR3w==
X-Gm-Message-State: APjAAAVxHJVtsTjbSv+X7Pv82ATWHdA+X+Oc+Q8p7YdSw8BFn0rsNC7H
        OsFcHvPvw3vYkyeUZnfFQnbuScS34vWV6A==
X-Google-Smtp-Source: APXvYqw2uZ1dgDLLHd+911tydTg9d2I1STJR15pQd3EFvjU1Gax+yYF8h27pSj3w1bAUPiRBwZgOYQ==
X-Received: by 2002:ab0:1ec6:: with SMTP id p6mr2832231uak.116.1565722086102;
        Tue, 13 Aug 2019 11:48:06 -0700 (PDT)
Received: from localhost.localdomain ([190.162.109.53])
        by smtp.googlemail.com with ESMTPSA id o9sm71767069vkd.27.2019.08.13.11.48.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 11:48:05 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        cneirabustos@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data from current task
Date:   Tue, 13 Aug 2019 11:47:45 -0700
Message-Id: <20190813184747.12225-2-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813184747.12225-1-cneirabustos@gmail.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carlos <cneirabustos@gmail.com>

New bpf helper bpf_get_current_pidns_info.
This helper obtains the active namespace from current and returns
pid, tgid, device and namespace id as seen from that namespace,
allowing to instrument a process inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 fs/internal.h            |  2 --
 fs/namei.c               |  1 -
 include/linux/bpf.h      |  1 +
 include/linux/namei.h    |  4 +++
 include/uapi/linux/bpf.h | 31 ++++++++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 8 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 315fcd8d237c..6647e15dd419 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -59,8 +59,6 @@ extern int finish_clean_context(struct fs_context *fc);
 /*
  * namei.c
  */
-extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
-			   struct path *path, struct path *root);
 extern int user_path_mountpoint_at(int, const char __user *, unsigned int, struct path *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
diff --git a/fs/namei.c b/fs/namei.c
index 209c51a5226c..a89fc72a4a10 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -19,7 +19,6 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/fsnotify.h>
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9a506147c8a..e4adf5e05afd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1050,6 +1050,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_current_pidns_info_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 9138b4471dbf..b45c8b6f7cb4 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/fcntl.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 
 enum { MAX_NESTED_LINKS = 8 };
 
@@ -97,6 +98,9 @@ extern void unlock_rename(struct dentry *, struct dentry *);
 
 extern void nd_jump_link(struct path *path);
 
+extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
+			   struct path *path, struct path *root);
+
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
 	((char *) name)[min(len, maxlen)] = '\0';
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4393bd4b2419..db241857ec15 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2741,6 +2741,28 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
+ *	Description
+ *		Copies into *pidns* pid, namespace id and tgid as seen by the
+ *		current namespace and also device from /proc/self/ns/pid.
+ *		*size_of_pidns* must be the size of *pidns*
+ *
+ *		This helper is used when pid filtering is needed inside a
+ *		container as bpf_get_current_tgid() helper returns always the
+ *		pid id as seen by the root namespace.
+ *	Return
+ *		0 on success
+ *
+ *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
+ *		or tgid of the current task.
+ *
+ *		**-ECHILD** if /proc/self/ns/pid does not exists.
+ *
+ *		**-ENOTDIR** if /proc/self/ns does not exists.
+ *
+ *		**-ENOMEM**  if allocation fails.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2853,7 +2875,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(get_current_pidns_info),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3604,4 +3627,10 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 dev;
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
index 5e28718928ca..41fbf1f28a48 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,12 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/major.h>
+#include <linux/stat.h>
+#include <linux/namei.h>
+#include <linux/version.h>
+
 
 #include "../../lib/kstrtox.h"
 
@@ -312,6 +318,64 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 	preempt_enable();
 }
 
+BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
+	 size)
+{
+	const char *pidns_path = "/proc/self/ns/pid";
+	struct pid_namespace *pidns = NULL;
+	struct filename *tmp = NULL;
+	struct inode *inode;
+	struct path kp;
+	pid_t tgid = 0;
+	pid_t pid = 0;
+	int ret;
+	int len;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		return -EINVAL;
+	pidns = task_active_pid_ns(current);
+	if (unlikely(!pidns))
+		goto clear;
+	pidns_info->nsid =  pidns->ns.inum;
+	pid = task_pid_nr_ns(current, pidns);
+	if (unlikely(!pid))
+		goto clear;
+	tgid = task_tgid_nr_ns(current, pidns);
+	if (unlikely(!tgid))
+		goto clear;
+	pidns_info->tgid = (u32) tgid;
+	pidns_info->pid = (u32) pid;
+	tmp = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
+	if (unlikely(!tmp)) {
+		memset((void *)pidns_info, 0, (size_t) size);
+		return -ENOMEM;
+	}
+	len = strlen(pidns_path) + 1;
+	memcpy((char *)tmp->name, pidns_path, len);
+	tmp->uptr = NULL;
+	tmp->aname = NULL;
+	tmp->refcnt = 1;
+	ret = filename_lookup(AT_FDCWD, tmp, 0, &kp, NULL);
+	if (ret) {
+		memset((void *)pidns_info, 0, (size_t) size);
+		return ret;
+	}
+	inode = d_backing_inode(kp.dentry);
+	pidns_info->dev = inode->i_sb->s_dev;
+	return 0;
+clear:
+	memset((void *)pidns_info, 0, (size_t) size);
+	return -EINVAL;
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

