Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B711749FE
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 00:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgB2XLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 18:11:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgB2XL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 18:11:29 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01TN5ajd028246
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TZ2UbvLuaaYn6hIASuhTINHqHt5PxMgDWpx9MVufKBo=;
 b=jlOEVrvjbrwsZS8Nq0Tu6NQbYRQd/ikpn3AcNYx/wJcmKzDhrQe6yM529XFWyl/2N7s7
 XCRsj2bYwJKxoovDa7gpJ+J1vMrspNwI0g/r0NzPWwwAvcdWLdETJdXdznERl8g+d3Nf
 GLKZZc5J3jgr10oNzMsUB+7He4vCApU4s+w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfnxq9x42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:29 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 15:11:28 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3F3F72EC2C66; Sat, 29 Feb 2020 15:11:21 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/4] selftests/bpf: fix BPF_KRETPROBE macro and use it in attach_probe test
Date:   Sat, 29 Feb 2020 15:11:11 -0800
Message-ID: <20200229231112.1240137-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229231112.1240137-1-andriin@fb.com>
References: <20200229231112.1240137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 suspectscore=8 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For kretprobes, there is no point in capturing input arguments from pt_regs,
as they are going to be, most probably, clobbered by the time probed kernel
function returns. So switch BPF_KRETPROBE to accept zero or one argument
(optional return result).

Fixes: ac065870d928 ("selftests/bpf: Add BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE macros")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_trace_helpers.h     | 13 +++++++------
 .../testing/selftests/bpf/progs/test_attach_probe.c |  3 ++-
 tools/testing/selftests/bpf/progs/test_overhead.c   |  6 ++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_trace_helpers.h b/tools/testing/selftests/bpf/bpf_trace_helpers.h
index c6f1354d93fb..83b8e02f5ee9 100644
--- a/tools/testing/selftests/bpf/bpf_trace_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_trace_helpers.h
@@ -96,15 +96,16 @@ typeof(name(0)) name(struct pt_regs *ctx)				    \
 static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
 
 #define ___bpf_kretprobe_args0() ctx
-#define ___bpf_kretprobe_argsN(x, args...) \
-	___bpf_kprobe_args(args), (void *)PT_REGS_RET(ctx)
+#define ___bpf_kretprobe_args1(x) \
+	___bpf_kretprobe_args0(), (void *)PT_REGS_RET(ctx)
 #define ___bpf_kretprobe_args(args...) \
-	___bpf_apply(___bpf_kretprobe_args, ___bpf_empty(args))(args)
+	___bpf_apply(___bpf_kretprobe_args, ___bpf_narg(args))(args)
 
 /*
- * BPF_KRETPROBE is similar to BPF_KPROBE, except, in addition to listing all
- * input kprobe arguments, one last extra argument has to be specified, which
- * captures kprobe return value.
+ * BPF_KRETPROBE is similar to BPF_KPROBE, except, it only provides optional
+ * return value (in addition to `struct pt_regs *ctx`), but no input
+ * arguments, because they will be clobbered by the time probed function
+ * returns.
  */
 #define BPF_KRETPROBE(name, args...)					    \
 name(struct pt_regs *ctx);						    \
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index dd8fae6660ab..38ed8c3bf922 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -4,6 +4,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include "bpf_trace_helpers.h"
 
 int kprobe_res = 0;
 int kretprobe_res = 0;
@@ -18,7 +19,7 @@ int handle_kprobe(struct pt_regs *ctx)
 }
 
 SEC("kretprobe/sys_nanosleep")
-int handle_kretprobe(struct pt_regs *ctx)
+int BPF_KRETPROBE(handle_kretprobe)
 {
 	kretprobe_res = 2;
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index bfe9fbcb9684..f43714c69cc8 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -17,11 +17,9 @@ int BPF_KPROBE(prog1, struct task_struct *tsk, const char *buf, bool exec)
 }
 
 SEC("kretprobe/__set_task_comm")
-int BPF_KRETPROBE(prog2,
-		  struct task_struct *tsk, const char *buf, bool exec,
-		  int ret)
+int BPF_KRETPROBE(prog2, int ret)
 {
-	return !PT_REGS_PARM1(ctx) && ret;
+	return ret;
 }
 
 SEC("raw_tp/task_rename")
-- 
2.17.1

