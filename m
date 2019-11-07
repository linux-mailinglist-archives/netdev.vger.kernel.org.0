Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78AF2754
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfKGFrS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfKGFrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:17 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75hGlL016600
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:16 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxuh9v-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:16 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:09 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id BB699760BC0; Wed,  6 Nov 2019 21:47:08 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 12/17] bpf: Fix race in btf_resolve_helper_id()
Date:   Wed, 6 Nov 2019 21:46:39 -0800
Message-ID: <20191107054644.1285697-13-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1034 mlxscore=0
 suspectscore=1 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_resolve_helper_id() caching logic is racy, since under root the verifier
can verify several programs in parallel. Fix it with extra spin_lock.

Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h   |  3 ++-
 kernel/bpf/btf.c      | 34 +++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c |  6 +-----
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9206b7e86dde..c287dfce2a17 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -874,7 +874,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
-u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
+u32 btf_resolve_helper_id(struct bpf_verifier_log *log,
+			  const struct bpf_func_proto *fn, int);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 78d9ceaabc00..7155787a0b13 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3584,7 +3584,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
-u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
+static u32 __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
+				   int arg)
 {
 	char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
 	const struct btf_param *args;
@@ -3652,6 +3653,37 @@ u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
 	return btf_id;
 }
 
+static DEFINE_SPINLOCK(btf_resolve_lock);
+
+u32 btf_resolve_helper_id(struct bpf_verifier_log *log,
+			  const struct bpf_func_proto *fn, int arg)
+{
+	u32 *btf_id = &fn->btf_id[arg];
+	u32 ret;
+
+	if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
+		return -EINVAL;
+
+	if (*btf_id)
+		/* ok to do without lock. It only set once */
+		return *btf_id;
+	/* ok to race the search. The result is the same */
+	ret = __btf_resolve_helper_id(log, fn->func, arg);
+	if (!ret) {
+		bpf_log(log, "BTF resolution bug\n");
+		return -EFAULT;
+	}
+	spin_lock(&btf_resolve_lock);
+	if (*btf_id) {
+		ret = *btf_id;
+		goto out;
+	}
+	*btf_id = ret;
+out:
+	spin_unlock(&btf_resolve_lock);
+	return ret;
+}
+
 static int __get_type_size(struct btf *btf, u32 btf_id,
 			   const struct btf_type **bad_type)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 36542edd4936..c4fd11a27d81 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4147,11 +4147,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	meta.func_id = func_id;
 	/* check args */
 	for (i = 0; i < 5; i++) {
-		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID) {
-			if (!fn->btf_id[i])
-				fn->btf_id[i] = btf_resolve_helper_id(&env->log, fn->func, i);
-			meta.btf_id = fn->btf_id[i];
-		}
+		meta.btf_id = btf_resolve_helper_id(&env->log, fn, i);
 		err = check_func_arg(env, BPF_REG_1 + i, fn->arg_type[i], &meta);
 		if (err)
 			return err;
-- 
2.23.0

