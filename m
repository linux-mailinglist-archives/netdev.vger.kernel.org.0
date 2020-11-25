Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A460F2C3723
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgKYDBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:01:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbgKYDBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:36 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP31KmY026993
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=e2OrovxF/7bQ87e+wXsR+/MWOClvERH9crKfNzs2rNY=;
 b=UKxibZV42VZhQQVowcotnhJ6BKLwzhcFIJyc5pxGWFJMUb982eEAV5VEOYYd2tKhHRO7
 B/9MygmNJVpqEeeep4CnqRpzPdPgVn+8eOV1GGtlk+Nr9P0LC/yI6rvFz+97pIr8foC7
 xIbb/Rr1xjJNGjWWA+P8jVoYQf8F2tSEOME= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34yk9gcp3u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:36 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:29 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 88BE616A18C3; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 33/34] bpf: eliminate rlimit-based memory accounting for bpf progs
Date:   Tue, 24 Nov 2020 19:01:18 -0800
Message-ID: <20201125030119.2864302-34-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=38 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for bpf progs. It has been
replaced with memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h  | 11 -------
 kernel/bpf/core.c    | 12 ++------
 kernel/bpf/syscall.c | 69 +++++++-------------------------------------
 3 files changed, 12 insertions(+), 80 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c9322adedd50..df5d5a8763db 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1201,8 +1201,6 @@ void bpf_prog_sub(struct bpf_prog *prog, int i);
 void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *pr=
og);
 void bpf_prog_put(struct bpf_prog *prog);
-int __bpf_prog_charge(struct user_struct *user, u32 pages);
-void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
 void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 			  struct bpf_map **used_maps, u32 len);
=20
@@ -1504,15 +1502,6 @@ bpf_prog_inc_not_zero(struct bpf_prog *prog)
 	return ERR_PTR(-EOPNOTSUPP);
 }
=20
-static inline int __bpf_prog_charge(struct user_struct *user, u32 pages)
-{
-	return 0;
-}
-
-static inline void __bpf_prog_uncharge(struct user_struct *user, u32 pag=
es)
-{
-}
-
 static inline void bpf_link_init(struct bpf_link *link, enum bpf_link_ty=
pe type,
 				 const struct bpf_link_ops *ops,
 				 struct bpf_prog *prog)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2921f58c03a8..261f8692d0d2 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -221,23 +221,15 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *=
fp_old, unsigned int size,
 {
 	gfp_t gfp_flags =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
-	u32 pages, delta;
-	int ret;
+	u32 pages;
=20
 	size =3D round_up(size, PAGE_SIZE);
 	pages =3D size / PAGE_SIZE;
 	if (pages <=3D fp_old->pages)
 		return fp_old;
=20
-	delta =3D pages - fp_old->pages;
-	ret =3D __bpf_prog_charge(fp_old->aux->user, delta);
-	if (ret)
-		return NULL;
-
 	fp =3D __vmalloc(size, gfp_flags);
-	if (fp =3D=3D NULL) {
-		__bpf_prog_uncharge(fp_old->aux->user, delta);
-	} else {
+	if (fp) {
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
 		fp->pages =3D pages;
 		fp->aux->prog =3D fp;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3dadf34c3dd0..7cd5860098ee 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1641,51 +1641,6 @@ static void bpf_audit_prog(const struct bpf_prog *=
prog, unsigned int op)
 	audit_log_end(ab);
 }
=20
-int __bpf_prog_charge(struct user_struct *user, u32 pages)
-{
-	unsigned long memlock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	unsigned long user_bufs;
-
-	if (user) {
-		user_bufs =3D atomic_long_add_return(pages, &user->locked_vm);
-		if (user_bufs > memlock_limit) {
-			atomic_long_sub(pages, &user->locked_vm);
-			return -EPERM;
-		}
-	}
-
-	return 0;
-}
-
-void __bpf_prog_uncharge(struct user_struct *user, u32 pages)
-{
-	if (user)
-		atomic_long_sub(pages, &user->locked_vm);
-}
-
-static int bpf_prog_charge_memlock(struct bpf_prog *prog)
-{
-	struct user_struct *user =3D get_current_user();
-	int ret;
-
-	ret =3D __bpf_prog_charge(user, prog->pages);
-	if (ret) {
-		free_uid(user);
-		return ret;
-	}
-
-	prog->aux->user =3D user;
-	return 0;
-}
-
-static void bpf_prog_uncharge_memlock(struct bpf_prog *prog)
-{
-	struct user_struct *user =3D prog->aux->user;
-
-	__bpf_prog_uncharge(user, prog->pages);
-	free_uid(user);
-}
-
 static int bpf_prog_alloc_id(struct bpf_prog *prog)
 {
 	int id;
@@ -1735,7 +1690,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu=
)
=20
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
-	bpf_prog_uncharge_memlock(aux->prog);
+	free_uid(aux->user);
 	security_bpf_prog_free(aux);
 	bpf_prog_free(aux->prog);
 }
@@ -2173,7 +2128,7 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
 		dst_prog =3D bpf_prog_get(attr->attach_prog_fd);
 		if (IS_ERR(dst_prog)) {
 			err =3D PTR_ERR(dst_prog);
-			goto free_prog_nouncharge;
+			goto free_prog;
 		}
 		prog->aux->dst_prog =3D dst_prog;
 	}
@@ -2183,18 +2138,15 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
=20
 	err =3D security_bpf_prog_alloc(prog->aux);
 	if (err)
-		goto free_prog_nouncharge;
-
-	err =3D bpf_prog_charge_memlock(prog);
-	if (err)
-		goto free_prog_sec;
+		goto free_prog;
=20
+	prog->aux->user =3D get_current_user();
 	prog->len =3D attr->insn_cnt;
=20
 	err =3D -EFAULT;
 	if (copy_from_user(prog->insns, u64_to_user_ptr(attr->insns),
 			   bpf_prog_insn_size(prog)) !=3D 0)
-		goto free_prog;
+		goto free_prog_sec;
=20
 	prog->orig_prog =3D NULL;
 	prog->jited =3D 0;
@@ -2205,19 +2157,19 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
 	if (bpf_prog_is_dev_bound(prog->aux)) {
 		err =3D bpf_prog_offload_init(prog, attr);
 		if (err)
-			goto free_prog;
+			goto free_prog_sec;
 	}
=20
 	/* find program type: socket_filter vs tracing_filter */
 	err =3D find_prog_type(type, prog);
 	if (err < 0)
-		goto free_prog;
+		goto free_prog_sec;
=20
 	prog->aux->load_time =3D ktime_get_boottime_ns();
 	err =3D bpf_obj_name_cpy(prog->aux->name, attr->prog_name,
 			       sizeof(attr->prog_name));
 	if (err < 0)
-		goto free_prog;
+		goto free_prog_sec;
=20
 	/* run eBPF verifier */
 	err =3D bpf_check(&prog, attr, uattr);
@@ -2262,11 +2214,10 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
 	 */
 	__bpf_prog_put_noref(prog, prog->aux->func_cnt);
 	return err;
-free_prog:
-	bpf_prog_uncharge_memlock(prog);
 free_prog_sec:
+	free_uid(prog->aux->user);
 	security_bpf_prog_free(prog->aux);
-free_prog_nouncharge:
+free_prog:
 	bpf_prog_free(prog);
 	return err;
 }
--=20
2.26.2

