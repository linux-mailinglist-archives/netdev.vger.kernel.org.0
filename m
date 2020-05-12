Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4181CECA4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgELF5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:57:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgELF5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:57:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5v2fC113129;
        Tue, 12 May 2020 05:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0Hv2rO7QMmb5xH09Kczwzz1/6YNJzE7kp8cCccFMjs8=;
 b=RerjZJnHavD1H8e6e22vHAbHGQWdXIn9mUZoutgoRHLAAfinoMnkyEcvDbGc6rjOhXqr
 lDqIwlSJuzaTVjRQBdWO8IH3WgHQN/rRz97/nLmI6LZrLsm+SqVLgg7JF9CjODfs6z0A
 /+k8iu7xvbqtr8uLNnyhFAIhp1LI841fR+hxZaSUrsSVXZtQkmLcJyn4q5V7MrQ4hFnA
 qengUeMzGgb26F+4Ns0YB6k8Ktqk64kwmsBI0a1IscpprD93Zo5UQYPA7gBvx2GylrnM
 Sq4NfDyA4Aa0QFcKOUiIgmHZF9v1+JgOOkhLL5E/XUdFB5athhDykksJuCeUHCBoMpAv zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30x3mbrv1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:57:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5sVEW191538;
        Tue, 12 May 2020 05:57:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30xbgh7tdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C5v58W028346;
        Tue, 12 May 2020 05:57:05 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:05 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/7] bpf: provide function to get vmlinux BTF information
Date:   Tue, 12 May 2020 06:56:39 +0100
Message-Id: <1589263005-7887-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
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
index cf4b6e4..de19a35 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1203,6 +1203,8 @@ int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 
+struct btf *bpf_get_btf_vmlinux(void);
+
 /* Map specifics */
 struct xdp_buff;
 struct sk_buff;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2a1826c..c6b1ba0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10728,6 +10728,17 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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
@@ -10761,12 +10772,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	env->ops = bpf_verifier_ops[env->prog->type];
 	is_priv = capable(CAP_SYS_ADMIN);
 
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

