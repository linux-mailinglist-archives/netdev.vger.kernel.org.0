Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069512B9997
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgKSRiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:38:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729619AbgKSRis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:48 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AJHbCQg030284
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=k21bL6NDAciBHcRsxaO56xd9cKE/s9olUgX4v8anCnY=;
 b=cXXzIsJryMJ/weaDUvMAVEyMfWZQ1XvCx6tbhGa512e/AKHZo+oLU6xqFJ4CfoRWLeNb
 Qhnd/CQ8LQ8EwBTc/Q2RaUGq5KHgaNqhfWY5jKXUIQDNL4gcHluC48dyfOG1wt/3sDxA
 D5vGY3yA3ksCZLSzcRhiP/30/7ptYGRjCgo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34whfknkfk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:46 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:07 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 1E755145BD19; Thu, 19 Nov 2020 09:37:57 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 33/34] bpf: eliminate rlimit-based memory accounting for bpf progs
Date:   Thu, 19 Nov 2020 09:37:53 -0800
Message-ID: <20201119173754.4125257-34-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=38 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for bpf progs. It has been
replaced with memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h  | 11 ------
 kernel/bpf/core.c    | 12 ++-----
 kernel/bpf/syscall.c | 86 ++++++--------------------------------------
 3 files changed, 12 insertions(+), 97 deletions(-)

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
index f065121d6ffa..2f0597978389 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -343,23 +343,6 @@ void bpf_map_init_from_attr(struct bpf_map *map, uni=
on bpf_attr *attr)
 	map->numa_node =3D bpf_map_attr_numa_node(attr);
 }
=20
-static int bpf_charge_memlock(struct user_struct *user, u32 pages)
-{
-	unsigned long memlock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	if (atomic_long_add_return(pages, &user->locked_vm) > memlock_limit) {
-		atomic_long_sub(pages, &user->locked_vm);
-		return -EPERM;
-	}
-	return 0;
-}
-
-static void bpf_uncharge_memlock(struct user_struct *user, u32 pages)
-{
-	if (user)
-		atomic_long_sub(pages, &user->locked_vm);
-}
-
 static int bpf_map_alloc_id(struct bpf_map *map)
 {
 	int id;
@@ -1645,51 +1628,6 @@ static void bpf_audit_prog(const struct bpf_prog *=
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
@@ -1739,7 +1677,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu=
)
=20
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
-	bpf_prog_uncharge_memlock(aux->prog);
+	free_uid(aux->user);
 	security_bpf_prog_free(aux);
 	bpf_prog_free(aux->prog);
 }
@@ -2177,7 +2115,7 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
 		dst_prog =3D bpf_prog_get(attr->attach_prog_fd);
 		if (IS_ERR(dst_prog)) {
 			err =3D PTR_ERR(dst_prog);
-			goto free_prog_nouncharge;
+			goto free_prog;
 		}
 		prog->aux->dst_prog =3D dst_prog;
 	}
@@ -2187,18 +2125,15 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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
@@ -2209,19 +2144,19 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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
@@ -2266,11 +2201,10 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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

