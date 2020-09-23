Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B338275F1E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIWRtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:49:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53342 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIWRts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:49:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHdpIN111886;
        Wed, 23 Sep 2020 17:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Tv++seLIXPtYHbrUHxTbmbA5VHyGPL24xUkLvDKKoRo=;
 b=HGbXsC66/dRt10vDc+0SLq26Cy8yq4xnFuwGnj7L2ObHoOPAzn2taK2dKsf4UlesN/3o
 C3iqJdShOuQ8SC0Fl8bcXPl8fon9jd2tizVoTofoBRIVjr0XCzDAwznc1alPKVjwIEQ+
 9QOSDPCBRw/3IBZHftoavBmpgD9uO5dKebN0PkDeXIvurQsqqVPJtyQmWozZBtrlRd98
 lVFF5qkU9gNDe9YPf4X3W+IMI4321s5clonFQtAWq12+JrGtYBdMObihJ+M40U9MLUke
 HAvYu0en4oFWxXOMuQN2HikVq6xecZaNUnIgOVlkfhD9Dcoil5uKzVD6ybS3lF3wcAy6 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpu0vcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 17:48:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NHfP32039843;
        Wed, 23 Sep 2020 17:46:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nux1ge9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:46:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NHkptW000799;
        Wed, 23 Sep 2020 17:46:51 GMT
Received: from localhost.uk.oracle.com (/10.175.195.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 10:46:51 -0700
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
Subject: [PATCH v6 bpf-next 1/6] bpf: provide function to get vmlinux BTF information
Date:   Wed, 23 Sep 2020 18:46:23 +0100
Message-Id: <1600883188-4831-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230135
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
index fc5c901..049e50f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1340,6 +1340,8 @@ int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 
+struct btf *bpf_get_btf_vmlinux(void);
+
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15ab889b..092ffd6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11488,6 +11488,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -11521,12 +11532,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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

