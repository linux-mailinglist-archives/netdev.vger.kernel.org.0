Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DAA26FEB3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgIRNgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:36:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRNgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:36:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDZ646150561;
        Fri, 18 Sep 2020 13:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=VdeIIb6+r5dYvzRqaqo955U9WnA2C9KjSUXChz7K0ZU=;
 b=wdE+PRqniNbVNOFGpfUgFS6iohlhE0o7llN0g4Bv0yIBo3wxaDQpFGt22zYboJ0C8/57
 SRI5rxC0rO9TAr2uc3tp8Fj8GfXjfean/EgVpwZWQuBhpL4tPc4ovVD58P0DlagiDyIB
 5yxopuBi786SQl0uHGwDFOkV+hEAVtBNIKq6UAHST5mDjH4xZIF1tERDIpNCciXUSyeP
 9R80mRLitq7qaR5HQLyhgzRpQXp+FInSiUYPlCJ63YzP40K4lJMeSvDIsT4vdm0Uzu+q
 P750Ic6Zi80k4wbZRS33md0oqdjB7t6FCJAxzmrLggPIJyyYMWYcrZyFEwFMNOJesKe7 NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9mq5qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 13:35:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IDU80x142528;
        Fri, 18 Sep 2020 13:35:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khppqeu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 13:35:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08IDZe84020800;
        Fri, 18 Sep 2020 13:35:40 GMT
Received: from localhost.uk.oracle.com (/10.175.217.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 13:35:40 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 1/6] bpf: provide function to get vmlinux BTF information
Date:   Fri, 18 Sep 2020 14:34:30 +0100
Message-Id: <1600436075-2961-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
References: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will be used later for BPF structure display support

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/verifier.c | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c..c0ad5d8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1330,6 +1330,8 @@ int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 
+struct btf *bpf_get_btf_vmlinux(void);
+
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 814bc6c..11d7985 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11311,6 +11311,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	}
 }
 
+struct btf *bpf_get_btf_vmlinux(void)
+{
+	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+		mutex_lock(&bpf_verifier_lock);
+		if (!btf_vmlinux)
+			btf_vmlinux = btf_parse_vmlinux();
+		mutex_unlock(&bpf_verifier_lock);
+	}
+	return btf_vmlinux;
+}
+
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	      union bpf_attr __user *uattr)
 {
@@ -11344,12 +11355,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	env->ops = bpf_verifier_ops[env->prog->type];
 	is_priv = bpf_capable();
 
-	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
-		mutex_lock(&bpf_verifier_lock);
-		if (!btf_vmlinux)
-			btf_vmlinux = btf_parse_vmlinux();
-		mutex_unlock(&bpf_verifier_lock);
-	}
+	bpf_get_btf_vmlinux();
 
 	/* grab the mutex to protect few globals used by verifier */
 	if (!is_priv)
-- 
1.8.3.1

