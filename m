Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F532B5860
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgKQDnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:43:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13926 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgKQDlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:16 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3duTZ004371
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JGw6o7TBx+ILLo4YTt2neoho4rwlX//7V56cYtCLLz8=;
 b=DngU8zL8pEV45+wNJzOEfwFLqrK8W3ckt34O8hgD+qpVNo5nkyeMYVpLdo5OheJJnvzg
 JKtq+tbRj+o/PgwAdS8SSuJOPGS6aB6v+iy0SL7zpugtbHxLnBSJh/9Lv4YzGUDFipAp
 X9MUxiRndP67s4eyoB5MrTWrvRA+hCxAwKM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34tdmruh5j-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:15 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:11 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 1A80CC63A5A; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 02/34] mm: memcontrol/slab: use helpers to access slab page's memcg_data
Date:   Mon, 16 Nov 2020 19:40:36 -0800
Message-ID: <20201117034108.1186569-3-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 suspectscore=3 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To gather all direct accesses to struct page's memcg_data field in one
place, let's introduce 3 new helpers to use in the slab accounting code:

  struct obj_cgroup **page_objcgs(struct page *page);
  struct obj_cgroup **page_objcgs_check(struct page *page);
  bool set_page_objcgs(struct page *page, struct obj_cgroup **objcgs);

They are similar to the corresponding API for generic pages, except that
the setter can return false, indicating that the value has been already
set from a different thread.

Link: https://lkml.kernel.org/r/20201027001657.3398190-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h | 64 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  6 ++--
 mm/slab.h                  | 35 +++++----------------
 3 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f95c1433461c..c7ac0a5b8989 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -416,6 +416,70 @@ static inline struct mem_cgroup *page_memcg_check(stru=
ct page *page)
 	return (struct mem_cgroup *)memcg_data;
 }
=20
+#ifdef CONFIG_MEMCG_KMEM
+/*
+ * page_objcgs - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function assumes that the page is known to have an
+ * associated object cgroups vector. It's not safe to call this function
+ * against pages, which might have an associated memory cgroup: e.g.
+ * kernel stack pages.
+ */
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+}
+
+/*
+ * page_objcgs_check - get the object cgroups vector associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroups vector associated with the page,
+ * or NULL. This function is safe to use if the page can be directly assoc=
iated
+ * with a memory cgroup.
+ */
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
+
+	if (memcg_data && (memcg_data & 0x1UL))
+		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+
+	return NULL;
+}
+
+/*
+ * set_page_objcgs - associate a page with a object cgroups vector
+ * @page: a pointer to the page struct
+ * @objcgs: a pointer to the object cgroups vector
+ *
+ * Atomically associates a page with a vector of object cgroups.
+ */
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+}
+#else
+static inline struct obj_cgroup **page_objcgs(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct obj_cgroup **page_objcgs_check(struct page *page)
+{
+	return NULL;
+}
+
+static inline bool set_page_objcgs(struct page *page,
+					struct obj_cgroup **objcgs)
+{
+	return true;
+}
+#endif
+
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
 	if (idx =3D=3D MEMCG_PERCPU_B)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3968d68503cb..0054b4846770 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2899,7 +2899,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, s=
truct kmem_cache *s,
 	if (!vec)
 		return -ENOMEM;
=20
-	if (cmpxchg(&page->memcg_data, 0, (unsigned long)vec | 0x1UL))
+	if (!set_page_objcgs(page, vec))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
@@ -2933,12 +2933,12 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 	 * Memcg membership data for each individual object is saved in
 	 * the page->obj_cgroups.
 	 */
-	if (page_has_obj_cgroups(page)) {
+	if (page_objcgs_check(page)) {
 		struct obj_cgroup *objcg;
 		unsigned int off;
=20
 		off =3D obj_to_index(page->slab_cache, page, p);
-		objcg =3D page_obj_cgroups(page)[off];
+		objcg =3D page_objcgs(page)[off];
 		if (objcg)
 			return obj_cgroup_memcg(objcg);
=20
diff --git a/mm/slab.h b/mm/slab.h
index e2535cee0d33..9a54a0cb5cca 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -239,28 +239,12 @@ static inline bool kmem_cache_debug_flags(struct kmem=
_cache *s, slab_flags_t fla
 }
=20
 #ifdef CONFIG_MEMCG_KMEM
-static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
-{
-	/*
-	 * Page's memory cgroup and obj_cgroups vector are sharing the same
-	 * space. To distinguish between them in case we don't know for sure
-	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
-	 * always set the lowest bit of obj_cgroups.
-	 */
-	return (struct obj_cgroup **)(page->memcg_data & ~0x1UL);
-}
-
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return page->memcg_data & 0x1UL;
-}
-
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp);
=20
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
-	kfree(page_obj_cgroups(page));
+	kfree(page_objcgs(page));
 	page->memcg_data =3D 0;
 }
=20
@@ -322,7 +306,7 @@ static inline void memcg_slab_post_alloc_hook(struct km=
em_cache *s,
 		if (likely(p[i])) {
 			page =3D virt_to_head_page(p[i]);
=20
-			if (!page_has_obj_cgroups(page) &&
+			if (!page_objcgs(page) &&
 			    memcg_alloc_page_obj_cgroups(page, s, flags)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
@@ -330,7 +314,7 @@ static inline void memcg_slab_post_alloc_hook(struct km=
em_cache *s,
=20
 			off =3D obj_to_index(s, page, p[i]);
 			obj_cgroup_get(objcg);
-			page_obj_cgroups(page)[off] =3D objcg;
+			page_objcgs(page)[off] =3D objcg;
 			mod_objcg_state(objcg, page_pgdat(page),
 					cache_vmstat_idx(s), obj_full_size(s));
 		} else {
@@ -344,6 +328,7 @@ static inline void memcg_slab_free_hook(struct kmem_cac=
he *s_orig,
 					void **p, int objects)
 {
 	struct kmem_cache *s;
+	struct obj_cgroup **objcgs;
 	struct obj_cgroup *objcg;
 	struct page *page;
 	unsigned int off;
@@ -357,7 +342,8 @@ static inline void memcg_slab_free_hook(struct kmem_cac=
he *s_orig,
 			continue;
=20
 		page =3D virt_to_head_page(p[i]);
-		if (!page_has_obj_cgroups(page))
+		objcgs =3D page_objcgs(page);
+		if (!objcgs)
 			continue;
=20
 		if (!s_orig)
@@ -366,11 +352,11 @@ static inline void memcg_slab_free_hook(struct kmem_c=
ache *s_orig,
 			s =3D s_orig;
=20
 		off =3D obj_to_index(s, page, p[i]);
-		objcg =3D page_obj_cgroups(page)[off];
+		objcg =3D objcgs[off];
 		if (!objcg)
 			continue;
=20
-		page_obj_cgroups(page)[off] =3D NULL;
+		objcgs[off] =3D NULL;
 		obj_cgroup_uncharge(objcg, obj_full_size(s));
 		mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
 				-obj_full_size(s));
@@ -379,11 +365,6 @@ static inline void memcg_slab_free_hook(struct kmem_ca=
che *s_orig,
 }
=20
 #else /* CONFIG_MEMCG_KMEM */
-static inline bool page_has_obj_cgroups(struct page *page)
-{
-	return false;
-}
-
 static inline struct mem_cgroup *memcg_from_slab_obj(void *ptr)
 {
 	return NULL;
--=20
2.26.2

