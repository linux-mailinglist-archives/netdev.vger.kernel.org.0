Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755B327ACCC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgI1Ldc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:33:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgI1Ldb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 07:33:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBTxMb110752;
        Mon, 28 Sep 2020 11:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=37Z0JsSoofOsUBt2zOf138my4O9f6xHJT6kyKH4ahLI=;
 b=Gluq6xLY/0zVVeWbK1C8/dLgDZKG0sWrgGkVk53zgZJbQbH2Crq0HD7Fq1SSCKZDr9SJ
 aZrzqkXqXbg9RdG0i76QyqnT+yIEN+RFiyv7J4cohdygN5NPYURcv9dyohihdTySb3ws
 Bw4oeM4bZDjBjNzZg0g//4YSMlAXQ1LbRd9oDq27kbRRBw/FFABATBlVKlWvcEr1W8bY
 Zmun7t+b7EtrK4eQmSkM4/FbULpTj+HdOxhuEz019/C8W/6ZR1uumoAtKkb7A5xTli71
 fi3HZeKj86pKnHmFultJHfncz64rAaOwB/5PW4UeNekqujU6UIbgv/HFleaBCBo8QKwr JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5amhjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:32:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SBUKvv057308;
        Mon, 28 Sep 2020 11:32:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhw57dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 11:32:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SBWZxw012783;
        Mon, 28 Sep 2020 11:32:35 GMT
Received: from localhost.uk.oracle.com (/10.175.167.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 04:32:34 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, acme@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v7 bpf-next 1/8] bpf: provide function to get vmlinux BTF information
Date:   Mon, 28 Sep 2020 12:31:03 +0100
Message-Id: <1601292670-1616-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280093
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
index 7990232..2eae3f3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1355,6 +1355,8 @@ int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 
+struct btf *bpf_get_btf_vmlinux(void);
+
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b25ba98..686f6a9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11517,6 +11517,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11550,12 +11561,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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

