Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4972051E3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbgFWMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732396AbgFWMKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7jqi051976;
        Tue, 23 Jun 2020 12:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=MTrI+iVmFvo3cZvwKsuePw6GQVm8XRiz1/7qTOD9t8c=;
 b=TTlHi/7CvdLjijxnAnnu9u13VHtEsGJVTOXOWpBjLHqSmvLmTRmqUZ5jEtu/N4SvdM0Q
 h5b4CLqeRVOqiU+FBr7xwOfblrnTKU8txZxmUHjuFW3DZPL1sUFfuCK9qxEnVUfCM+Aj
 Kb4+2t6xZNGYAQKVyVOorZfzwZDwSbaF6IKIzojRllm/9zVh2NCsMaCPKtan8lUjpLfO
 MzBcc+BJ7hPfK27BwtZ6r2zJtQteGic0584Q+ZYfbQWYqwip3Bg9Vn76erHj7HDsry4l
 nNfnZCdH8PxR3fhNKdrNZQ1DYurrLK2bzr6+rbq2404fwJc+khRdUJmNZQ5XT6AONgK6 lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31sebbcv8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7h9X185364;
        Tue, 23 Jun 2020 12:09:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31sv1n7gtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NC9469018634;
        Tue, 23 Jun 2020 12:09:04 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:04 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 1/8] bpf: provide function to get vmlinux BTF information
Date:   Tue, 23 Jun 2020 13:07:04 +0100
Message-Id: <1592914031-31049-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will be used later for BTF printk() support

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 include/linux/bpf.h   |  2 ++
 kernel/bpf/verifier.c | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07052d4..a2ecebd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1237,6 +1237,8 @@ int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 
+struct btf *bpf_get_btf_vmlinux(void);
+
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a1857c4..d448aa8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10878,6 +10878,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10911,12 +10922,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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

