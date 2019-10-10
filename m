Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E601D1F55
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfJJEPO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728388AbfJJEPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4E6Ts014694
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:12 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsduty5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:12 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:15:09 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4E461760CF9; Wed,  9 Oct 2019 21:15:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 03/12] bpf: process in-kernel BTF
Date:   Wed, 9 Oct 2019 21:14:54 -0700
Message-ID: <20191010041503.2526303-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=3
 clxscore=1034 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If in-kernel BTF exists parse it and prepare 'struct btf *btf_vmlinux'
for further use by the verifier.
In-kernel BTF is trusted just like kallsyms and other build artifacts
embedded into vmlinux.
Yet run this BTF image through BTF verifier to make sure
that it is valid and it wasn't mangled during the build.
If in-kernel BTF is incorrect it means either gcc or pahole or kernel
are buggy. In such case disallow loading BPF programs.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |  4 +-
 include/linux/btf.h          |  1 +
 kernel/bpf/btf.c             | 71 +++++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c        | 20 ++++++++++
 4 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 26a6d58ca78c..713efae62e96 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -330,10 +330,12 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
 #define BPF_LOG_STATS	4
 #define BPF_LOG_LEVEL	(BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
 #define BPF_LOG_MASK	(BPF_LOG_LEVEL | BPF_LOG_STATS)
+#define BPF_LOG_KERNEL	(BPF_LOG_MASK + 1) /* kernel internal flag */
 
 static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
 {
-	return log->level && log->ubuf && !bpf_verifier_log_full(log);
+	return (log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
+		log->level == BPF_LOG_KERNEL;
 }
 
 #define BPF_MAX_SUBPROGS 256
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 64cdf2a23d42..55d43bc856be 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -56,6 +56,7 @@ bool btf_type_is_void(const struct btf_type *t);
 #ifdef CONFIG_BPF_SYSCALL
 const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
+struct btf *btf_parse_vmlinux(void);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 29c7c06c6bd6..ddeab1e8d21e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -698,6 +698,13 @@ __printf(4, 5) static void __btf_verifier_log_type(struct btf_verifier_env *env,
 	if (!bpf_verifier_log_needed(log))
 		return;
 
+	/* btf verifier prints all types it is processing via
+	 * btf_verifier_log_type(..., fmt = NULL).
+	 * Skip those prints for in-kernel BTF verification.
+	 */
+	if (log->level == BPF_LOG_KERNEL && !fmt)
+		return;
+
 	__btf_verifier_log(log, "[%u] %s %s%s",
 			   env->log_type_id,
 			   btf_kind_str[kind],
@@ -735,6 +742,8 @@ static void btf_verifier_log_member(struct btf_verifier_env *env,
 	if (!bpf_verifier_log_needed(log))
 		return;
 
+	if (log->level == BPF_LOG_KERNEL && !fmt)
+		return;
 	/* The CHECK_META phase already did a btf dump.
 	 *
 	 * If member is logged again, it must hit an error in
@@ -777,6 +786,8 @@ static void btf_verifier_log_vsi(struct btf_verifier_env *env,
 
 	if (!bpf_verifier_log_needed(log))
 		return;
+	if (log->level == BPF_LOG_KERNEL && !fmt)
+		return;
 	if (env->phase != CHECK_META)
 		btf_verifier_log_type(env, datasec_type, NULL);
 
@@ -802,6 +813,8 @@ static void btf_verifier_log_hdr(struct btf_verifier_env *env,
 	if (!bpf_verifier_log_needed(log))
 		return;
 
+	if (log->level == BPF_LOG_KERNEL)
+		return;
 	hdr = &btf->hdr;
 	__btf_verifier_log(log, "magic: 0x%x\n", hdr->magic);
 	__btf_verifier_log(log, "version: %u\n", hdr->version);
@@ -2405,7 +2418,8 @@ static s32 btf_enum_check_meta(struct btf_verifier_env *env,
 			return -EINVAL;
 		}
 
-
+		if (env->log.level == BPF_LOG_KERNEL)
+			continue;
 		btf_verifier_log(env, "\t%s val=%d\n",
 				 __btf_name_by_offset(btf, enums[i].name_off),
 				 enums[i].val);
@@ -3367,6 +3381,61 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 	return ERR_PTR(err);
 }
 
+extern char __weak _binary__btf_vmlinux_bin_start[];
+extern char __weak _binary__btf_vmlinux_bin_end[];
+
+struct btf *btf_parse_vmlinux(void)
+{
+	struct btf_verifier_env *env = NULL;
+	struct bpf_verifier_log *log;
+	struct btf *btf = NULL;
+	int err;
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL | __GFP_NOWARN);
+	if (!env)
+		return ERR_PTR(-ENOMEM);
+
+	log = &env->log;
+	log->level = BPF_LOG_KERNEL;
+
+	btf = kzalloc(sizeof(*btf), GFP_KERNEL | __GFP_NOWARN);
+	if (!btf) {
+		err = -ENOMEM;
+		goto errout;
+	}
+	env->btf = btf;
+
+	btf->data = _binary__btf_vmlinux_bin_start;
+	btf->data_size = _binary__btf_vmlinux_bin_end -
+		_binary__btf_vmlinux_bin_start;
+
+	err = btf_parse_hdr(env);
+	if (err)
+		goto errout;
+
+	btf->nohdr_data = btf->data + btf->hdr.hdr_len;
+
+	err = btf_parse_str_sec(env);
+	if (err)
+		goto errout;
+
+	err = btf_check_all_metas(env);
+	if (err)
+		goto errout;
+
+	btf_verifier_env_free(env);
+	refcount_set(&btf->refcnt, 1);
+	return btf;
+
+errout:
+	btf_verifier_env_free(env);
+	if (btf) {
+		kvfree(btf->types);
+		kfree(btf);
+	}
+	return ERR_PTR(err);
+}
+
 void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 		       struct seq_file *m)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ffc3e53f5300..051a355037bf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -207,6 +207,8 @@ struct bpf_call_arg_meta {
 	int func_id;
 };
 
+struct btf *btf_vmlinux;
+
 static DEFINE_MUTEX(bpf_verifier_lock);
 
 static const struct bpf_line_info *
@@ -243,6 +245,10 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
 	n = min(log->len_total - log->len_used - 1, n);
 	log->kbuf[n] = '\0';
 
+	if (log->level == BPF_LOG_KERNEL) {
+		pr_err("BPF:%s\n", log->kbuf);
+		return;
+	}
 	if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
 		log->len_used += n;
 	else
@@ -9241,6 +9247,13 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	env->ops = bpf_verifier_ops[env->prog->type];
 	is_priv = capable(CAP_SYS_ADMIN);
 
+	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+		mutex_lock(&bpf_verifier_lock);
+		if (!btf_vmlinux)
+			btf_vmlinux = btf_parse_vmlinux();
+		mutex_unlock(&bpf_verifier_lock);
+	}
+
 	/* grab the mutex to protect few globals used by verifier */
 	if (!is_priv)
 		mutex_lock(&bpf_verifier_lock);
@@ -9260,6 +9273,13 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 			goto err_unlock;
 	}
 
+	if (IS_ERR(btf_vmlinux)) {
+		/* Either gcc or pahole or kernel are broken. */
+		verbose(env, "in-kernel BTF is malformed\n");
+		ret = PTR_ERR(btf_vmlinux);
+		goto err_unlock;
+	}
+
 	env->strict_alignment = !!(attr->prog_flags & BPF_F_STRICT_ALIGNMENT);
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
-- 
2.23.0

