Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06F2B5759
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgKQCzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:55:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726886AbgKQCzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:42 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH2nP0k026472
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9cSgxl1oXQb2FeFbutr/1U3wU15tYQZ7nIi1qnwGPjE=;
 b=cuPHkz225l6VUtk5sb6MvZ/IdNOTWcuklyZAxA7qp40oTMlNItGp45/TaHCu6IEkJhat
 GIrom19YNV/EScdq9cXEF2r1AqYsah5vkl8883RZ14PFEG5Pz2S4RGP6gBaTolJNQmfJ
 g9fxwFWNR4AaB7fqW62/84NtpRCPjzCWugc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 34tbm4unad-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:40 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:40 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 57A49C5F802; Mon, 16 Nov 2020 18:55:34 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 33/34] bpf: eliminate rlimit-based memory accounting for bpf progs
Date:   Mon, 16 Nov 2020 18:55:28 -0800
Message-ID: <20201117025529.1034387-34-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=38 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170022
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
index 6f1ef8a1e25f..73f6503d9170 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1200,8 +1200,6 @@ void bpf_prog_sub(struct bpf_prog *prog, int i);
 void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *pr=
og);
 void bpf_prog_put(struct bpf_prog *prog);
-int __bpf_prog_charge(struct user_struct *user, u32 pages);
-void __bpf_prog_uncharge(struct user_struct *user, u32 pages);
 void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 			  struct bpf_map **used_maps, u32 len);
=20
@@ -1482,15 +1480,6 @@ bpf_prog_inc_not_zero(struct bpf_prog *prog)
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
index fd83e5c65d15..7b983cb55df3 100644
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
index 9f41edbae3f8..2ab14fe1af14 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -342,23 +342,6 @@ void bpf_map_init_from_attr(struct bpf_map *map, uni=
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
@@ -1594,51 +1577,6 @@ static void bpf_audit_prog(const struct bpf_prog *=
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
@@ -1688,7 +1626,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu=
)
=20
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
-	bpf_prog_uncharge_memlock(aux->prog);
+	free_uid(aux->user);
 	security_bpf_prog_free(aux);
 	bpf_prog_free(aux->prog);
 }
@@ -2126,7 +2064,7 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
 		dst_prog =3D bpf_prog_get(attr->attach_prog_fd);
 		if (IS_ERR(dst_prog)) {
 			err =3D PTR_ERR(dst_prog);
-			goto free_prog_nouncharge;
+			goto free_prog;
 		}
 		prog->aux->dst_prog =3D dst_prog;
 	}
@@ -2136,18 +2074,15 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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
@@ -2158,19 +2093,19 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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
@@ -2215,11 +2150,10 @@ static int bpf_prog_load(union bpf_attr *attr, un=
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

