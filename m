Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084E9F40A6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfKHGmH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 01:42:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfKHGmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:42:06 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86XbuN023894
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 22:42:05 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1w7s-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 22:42:05 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:41:06 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E5B77760F61; Thu,  7 Nov 2019 22:41:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 13/18] bpf: Fix race in btf_resolve_helper_id()
Date:   Thu, 7 Nov 2019 22:40:34 -0800
Message-ID: <20191108064039.2041889-14-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108064039.2041889-1-ast@kernel.org>
References: <20191108064039.2041889-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1034 mlxscore=0
 suspectscore=1 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_resolve_helper_id() caching logic is a bit racy, since under root the
verifier can verify several programs in parallel. Fix it with READ/WRITE_ONCE.
Fix the type as well, since error is also recorded.

Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h   |  5 +++--
 kernel/bpf/btf.c      | 26 +++++++++++++++++++++++++-
 kernel/bpf/verifier.c |  8 +++-----
 net/core/filter.c     |  2 +-
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9206b7e86dde..e177758ae439 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -247,7 +247,7 @@ struct bpf_func_proto {
 		};
 		enum bpf_arg_type arg_type[5];
 	};
-	u32 *btf_id; /* BTF ids of arguments */
+	int *btf_id; /* BTF ids of arguments */
 };
 
 /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
@@ -874,7 +874,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
 		      u32 *next_btf_id);
-u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
+int btf_resolve_helper_id(struct bpf_verifier_log *log,
+			  const struct bpf_func_proto *fn, int);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9e1164e5b429..033d071eb59c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3721,7 +3721,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	return -EINVAL;
 }
 
-u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
+static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
+				   int arg)
 {
 	char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
 	const struct btf_param *args;
@@ -3789,6 +3790,29 @@ u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn, int arg)
 	return btf_id;
 }
 
+int btf_resolve_helper_id(struct bpf_verifier_log *log,
+			  const struct bpf_func_proto *fn, int arg)
+{
+	int *btf_id = &fn->btf_id[arg];
+	int ret;
+
+	if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
+		return -EINVAL;
+
+	ret = READ_ONCE(*btf_id);
+	if (ret)
+		return ret;
+	/* ok to race the search. The result is the same */
+	ret = __btf_resolve_helper_id(log, fn->func, arg);
+	if (!ret) {
+		/* Function argument cannot be type 'void' */
+		bpf_log(log, "BTF resolution bug\n");
+		return -EFAULT;
+	}
+	WRITE_ONCE(*btf_id, ret);
+	return ret;
+}
+
 static int __get_type_size(struct btf *btf, u32 btf_id,
 			   const struct btf_type **bad_type)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 36542edd4936..90375c26ad45 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4147,11 +4147,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	meta.func_id = func_id;
 	/* check args */
 	for (i = 0; i < 5; i++) {
-		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID) {
-			if (!fn->btf_id[i])
-				fn->btf_id[i] = btf_resolve_helper_id(&env->log, fn->func, i);
-			meta.btf_id = fn->btf_id[i];
-		}
+		err = btf_resolve_helper_id(&env->log, fn, i);
+		if (err > 0)
+			meta.btf_id = err;
 		err = check_func_arg(env, BPF_REG_1 + i, fn->arg_type[i], &meta);
 		if (err)
 			return err;
diff --git a/net/core/filter.c b/net/core/filter.c
index fc303abec8fa..f72face90659 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3816,7 +3816,7 @@ static const struct bpf_func_proto bpf_skb_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-static u32 bpf_skb_output_btf_ids[5];
+static int bpf_skb_output_btf_ids[5];
 const struct bpf_func_proto bpf_skb_output_proto = {
 	.func		= bpf_skb_event_output,
 	.gpl_only	= true,
-- 
2.23.0

