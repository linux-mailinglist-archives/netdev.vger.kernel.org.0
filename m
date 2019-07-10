Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038C164BCD
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfGJSA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:00:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727691AbfGJSA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:00:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AHxnPS000502
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dCDtpmdoOXH4SykdUSimSmMPCLojngDnYnct4jVmayo=;
 b=g2DoiuZ+X1dH5elFfUGqqD7hQQZSdbvbTdmTmcN8B9PVocuBTLhY4mnEtThxT5BrYStC
 AD/qt1SluhDI6FE6q80dkcqx6MeXEfrJQaOkB8eqh2WooaOgUuOrME2tIfcZ0qMuRXGU
 QjQA7JYd1H0688xbQJXEknZpprKI5ZV3k24= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnkgm0x60-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:27 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 11:00:25 -0700
Received: by devvm424.lla2.facebook.com (Postfix, from userid 134475)
        id CE85D11FAA300; Wed, 10 Jul 2019 11:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Javier Honduvilla Coto <javierhonduco@fb.com>
Smtp-Origin-Hostname: devvm424.lla2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <yhs@fb.com>, <kernel-team@fb.com>, <jonhaslam@fb.com>
Smtp-Origin-Cluster: lla2c09
Subject: [PATCH v6 bpf-next 1/3] bpf: add bpf_descendant_of helper
Date:   Wed, 10 Jul 2019 11:00:23 -0700
Message-ID: <20190710180025.94726-2-javierhonduco@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190710180025.94726-1-javierhonduco@fb.com>
References: <20190410203631.1576576-1-javierhonduco@fb.com>
 <20190710180025.94726-1-javierhonduco@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the bpf_descendant_of helper which accepts a PID and
returns 1 if the PID of the process currently being executed is a
descendant of it or if it's itself. Returns 0 otherwise. The passed
PID should be the one as seen from the "global" pid namespace as the
processes' PIDs in the hierarchy are resolved using the context of said
initial namespace.

This is very useful in tracing programs when we want to filter by a
given PID and all the children it might spawn. The current workarounds
most people implement for this purpose have issues:

- Attaching to process spawning syscalls and dynamically add those PIDs
  to some bpf map that would be used to filter is cumbersome and
potentially racy.
- Unrolling some loop to perform what this helper is doing consumes lots
  of instructions. That and the impossibility to jump backwards makes it
really hard to be correct in really large process chains.

Signed-off-by: Javier Honduvilla Coto <javierhonduco@fb.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h | 20 +++++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 27 +++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 18f4cc2c6acd..4e861138887d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1053,6 +1053,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_descendant_of_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5695ab53e354..7e8c2bd654f5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2713,6 +2713,23 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * int bpf_descendant_of(pid_t pid)
+ *     Description
+ *             Determine if the process identified by *pid* is an ancestor
+ *             (or equal) of the user process executed in this tracing
+ *             context. This is useful when filtering events happening
+ *             to a process and all of its descendants.
+ *
+ *             Note that *pid* must be the pid from the global namespace
+ *             as the pids of the process chain will be resolved using the
+ *             initial pid namespace viewer context.
+ *     Return
+ *             * 1 if the process identified by *pid* is an ancestor, or equal,
+ *             of the currently executing process within the global pid
+ *             namespace
+ *
+ *             * 0 otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2824,7 +2841,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(descendant_of),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 16079550db6d..8f7f0ec8cded 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2039,6 +2039,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_descendant_of_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..2214194e5f49 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,7 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/init_task.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +488,29 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_1(bpf_descendant_of, pid_t, pid)
+{
+	int result = 0;
+	struct task_struct *task = current;
+
+	if (pid == 0)
+		return 1;
+
+	while (task != &init_task) {
+		if (task->pid == pid) {
+			result = 1;
+			break;
+		}
+		task = rcu_dereference(task->real_parent);
+	}
+
+	return result;
+}
+
+const struct bpf_func_proto bpf_descendant_of_proto = {
+	.func		= bpf_descendant_of,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..797d7b4a8e9a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -703,6 +703,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_prandom_u32_proto;
 	case BPF_FUNC_probe_read_str:
 		return &bpf_probe_read_str_proto;
+	case BPF_FUNC_descendant_of:
+		return &bpf_descendant_of_proto;
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
-- 
2.17.1

