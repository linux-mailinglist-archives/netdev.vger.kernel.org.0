Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F72116441
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 01:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfLIABX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Dec 2019 19:01:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfLIABX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 19:01:23 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB8NwgNd008127
        for <netdev@vger.kernel.org>; Sun, 8 Dec 2019 16:01:21 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvp0jfvm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 16:01:21 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Dec 2019 16:01:20 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9498B760CCB; Sun,  8 Dec 2019 16:01:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <rostedt@goodmis.org>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/3] bpf: Make BPF trampoline use register_ftrace_direct() API
Date:   Sun, 8 Dec 2019 16:01:13 -0800
Message-ID: <20191209000114.1876138-3-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209000114.1876138-1-ast@kernel.org>
References: <20191209000114.1876138-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-08_07:2019-12-05,2019-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=363 clxscore=1034
 lowpriorityscore=0 suspectscore=1 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912080207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make BPF trampoline attach its generated assembly code to kernel functions via
register_ftrace_direct() API. It helps ftrace-based tracers co-exist with BPF
trampoline on the same kernel function. It also switches attaching logic from
arch specific text_poke to generic ftrace that is available on many
architectures. text_poke is still necessary for bpf-to-bpf attach and for
bpf_tail_call optimization.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h     |  1 +
 kernel/bpf/trampoline.c | 64 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be5..ac7de5291509 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -461,6 +461,7 @@ struct bpf_trampoline {
 	struct {
 		struct btf_func_model model;
 		void *addr;
+		bool ftrace_managed;
 	} func;
 	/* list of BPF programs using this trampoline */
 	struct hlist_head progs_hlist[BPF_TRAMP_MAX];
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7e89f1f49d77..23b0d5cfd47e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -3,6 +3,7 @@
 #include <linux/hash.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/ftrace.h>
 
 /* btf_vmlinux has ~22k attachable functions. 1k htab is enough. */
 #define TRAMPOLINE_HASH_BITS 10
@@ -59,6 +60,60 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	return tr;
 }
 
+static int is_ftrace_location(void *ip)
+{
+	long addr;
+
+	addr = ftrace_location((long)ip);
+	if (!addr)
+		return 0;
+	if (WARN_ON_ONCE(addr != (long)ip))
+		return -EFAULT;
+	return 1;
+}
+
+static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
+{
+	void *ip = tr->func.addr;
+	int ret;
+
+	if (tr->func.ftrace_managed)
+		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
+	else
+		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
+	return ret;
+}
+
+static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr)
+{
+	void *ip = tr->func.addr;
+	int ret;
+
+	if (tr->func.ftrace_managed)
+		ret = modify_ftrace_direct((long)ip, (long)old_addr, (long)new_addr);
+	else
+		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, new_addr);
+	return ret;
+}
+
+/* first time registering */
+static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
+{
+	void *ip = tr->func.addr;
+	int ret;
+
+	ret = is_ftrace_location(ip);
+	if (ret < 0)
+		return ret;
+	tr->func.ftrace_managed = ret;
+
+	if (tr->func.ftrace_managed)
+		ret = register_ftrace_direct((long)ip, (long)new_addr);
+	else
+		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
+	return ret;
+}
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.  Pick a number to fit into PAGE_SIZE / 2
  */
@@ -77,8 +132,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	int err;
 
 	if (fentry_cnt + fexit_cnt == 0) {
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL,
-					 old_image, NULL);
+		err = unregister_fentry(tr, old_image);
 		tr->selector = 0;
 		goto out;
 	}
@@ -105,12 +159,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 
 	if (tr->selector)
 		/* progs already running at this address */
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL,
-					 old_image, new_image);
+		err = modify_fentry(tr, old_image, new_image);
 	else
 		/* first time registering */
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_CALL, NULL,
-					 new_image);
+		err = register_fentry(tr, new_image);
 	if (err)
 		goto out;
 	tr->selector++;
-- 
2.23.0

