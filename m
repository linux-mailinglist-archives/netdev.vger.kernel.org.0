Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4973BCB0C
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfIXPUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:20:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44093 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732277AbfIXPUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:20:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so2574125qth.11;
        Tue, 24 Sep 2019 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4FCdKcUe9HTHpEsqAWhKQaxQOBpuFRezzfrMNuqYlEg=;
        b=kL3hAbl/bPbOgf+icxwlQSOvIguHi1EvAzVjZg8l1zETfYHfajUex/KcObvsc2rAWP
         AbAOlJEvyeQPm/AAXS5Yi4ymViY9CgYHKbN6okQfORfmzAvVL3l4XzEQ7/kBGleeDA3s
         M6LGZR8jdYdVGCtUtGNPPi7Na4TnRFXHgW9Mw/SXAi/p/C8wOn8HMtQIT6rK8u6OQ4cj
         XqNy2f6AuHmsfBM1AEXQ4g5KcGpopmkBSXAVLHZGFW93cSx97bPOTdzSpC9PqwVa4zjm
         dD8FMl/dohuuieikBbcx7sV4TnC972vRaTTs+s51kecNqZayzYHqorOWi61C5eR6AN8U
         i38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4FCdKcUe9HTHpEsqAWhKQaxQOBpuFRezzfrMNuqYlEg=;
        b=i9V9PXMxDS2s/l8nfRAD6ZknW/zTkq6Dgt6rJSki4a6AMXoJyTYyRn0IkVriSKJecb
         bedTfQXYntrM+ntz7/QJYftRJcTCTGbQf91tSKl5AUfeovK2LOn694IZSLXw4LEJ5lm2
         6sY/V6BvRdGiG9KWAayrIzpOR2LJiCncHojgza0St6VDrUP/sg/sYN9f232YfNrfK4wa
         B6grf2TxuDw3gT5+ZWbp+7YOq7lBt7j3P3nCxjerzNmPdzFxoUfyaD3SU4GF/0aH2PK+
         UUwxClFsE0c2kw6v9U8ezp6ONl4hQswVBAXmTA7RMK/STfjhab1EJlcFHAS3YNch0MvQ
         LnOg==
X-Gm-Message-State: APjAAAVSuILLIaPVq5RkcVwthV8Lkx9/VCy+CiEFAfgr0lV4HAESJCg1
        NT/UBfgjEOY8fHeL/gUFPpuxkQ2YTQM=
X-Google-Smtp-Source: APXvYqwfRayK2HPCUlm9vFFc9YxYZlrKUX7b+pUogfY0bo4/+pOt9EWeUnbeh6DyHTA/5HioWo3HCQ==
X-Received: by 2002:ac8:71cb:: with SMTP id i11mr3415297qtp.208.1569338427711;
        Tue, 24 Sep 2019 08:20:27 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id h68sm1073533qkd.35.2019.09.24.08.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:20:27 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH bpf-next v11 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Tue, 24 Sep 2019 12:20:03 -0300
Message-Id: <20190924152005.4659-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
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
 include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 32 ++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 53 insertions(+), 1 deletion(-)

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
index 77c6be96d676..9272dc8fb08c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2750,6 +2750,21 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_get_ns_current_pid_tgid(u32 dev, u64 inum)
+ *	Return
+ *		A 64-bit integer containing the current tgid and pid from current task
+ *              which namespace inode and dev_t matches , and is create as such:
+ *		*current_task*\ **->tgid << 32 \|**
+ *		*current_task*\ **->pid**.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2877,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),          \
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
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
index 5e28718928ca..81a716eae7ed 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,8 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +489,33 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_2(bpf_get_ns_current_pid_tgid, u32, dev, u64, inum)
+{
+	struct task_struct *task = current;
+	struct pid_namespace *pidns;
+	pid_t pid, tgid;
+
+	if (unlikely(!task))
+		return -EINVAL;
+
+	pidns = task_active_pid_ns(task);
+	if (unlikely(!pidns))
+		return -ENOENT;
+
+	if (!ns_match(&pidns->ns, (dev_t)dev, inum))
+		return -EINVAL;
+
+	pid = task_pid_nr_ns(task, pidns);
+	tgid = task_tgid_nr_ns(task, pidns);
+
+	return (u64) tgid << 32 | pid;
+}
+
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
+	.func		= bpf_get_ns_current_pid_tgid,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..1d34f1013e78 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -709,6 +709,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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

