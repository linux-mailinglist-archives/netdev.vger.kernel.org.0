Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970B524D7DF
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHUPCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:02:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728037AbgHUPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:01:47 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LExm3s019716
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:01:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0ZedqTqGMLhs2uHGhYW2j2zHH98meWGrVxntIVY/meE=;
 b=GvmwI3r6bcRX0tbC05rCRI2rMOHlJmxrayODNjGRROm8FhmgbVBZR0nSHapO6O5RtAF2
 aLxeMrrcY09DGHDnKl3cSoYdheGTVvSlBSYHFeQDNqGhV0bciiQ06iD7k/XiY+XVRsR8
 Y3y7ZPRvu131gFIVyqL6Qegz9AM3MwSJzCw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m3da81-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:01:46 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 08:01:41 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 25EDB3441047; Fri, 21 Aug 2020 08:01:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v4 01/30] mm: support nesting memalloc_use_memcg()
Date:   Fri, 21 Aug 2020 08:01:05 -0700
Message-ID: <20200821150134.2581465-2-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200821150134.2581465-1-guro@fb.com>
References: <20200821150134.2581465-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Support nesting of memalloc_use_memcg() to be able to use
from an interrupt context.

Make memalloc_use_memcg() return the old memcg and convert existing
users to a stacking model. Delete the unused memalloc_unuse_memcg().

Roman: I've rephrased the original commit log, because it was
focused on the accounting problem related to loop devices. I made
it less specific, so it can work for bpf too. Also rebased to the
current state of the mm tree.

The original patch can be found here:
https://lkml.org/lkml/2020/5/28/806

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Roman Gushchin <guro@fb.com>
---
 fs/buffer.c                          |  6 +++---
 fs/notify/fanotify/fanotify.c        |  5 +++--
 fs/notify/inotify/inotify_fsnotify.c |  5 +++--
 include/linux/sched/mm.h             | 28 +++++++++-------------------
 mm/memcontrol.c                      |  6 +++---
 5 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 061dd202979d..97ef480db0da 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -842,13 +842,13 @@ struct buffer_head *alloc_page_buffers(struct page =
*page, unsigned long size,
 	struct buffer_head *bh, *head;
 	gfp_t gfp =3D GFP_NOFS | __GFP_ACCOUNT;
 	long offset;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
=20
 	if (retry)
 		gfp |=3D __GFP_NOFAIL;
=20
 	memcg =3D get_mem_cgroup_from_page(page);
-	memalloc_use_memcg(memcg);
+	old_memcg =3D memalloc_use_memcg(memcg);
=20
 	head =3D NULL;
 	offset =3D PAGE_SIZE;
@@ -867,7 +867,7 @@ struct buffer_head *alloc_page_buffers(struct page *p=
age, unsigned long size,
 		set_bh_page(bh, page, offset);
 	}
 out:
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 	return head;
 /*
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.=
c
index c942910a8649..0e59fa57f6d7 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -531,6 +531,7 @@ static struct fanotify_event *fanotify_alloc_event(st=
ruct fsnotify_group *group,
 	struct inode *dirid =3D fanotify_dfid_inode(mask, data, data_type, dir)=
;
 	const struct path *path =3D fsnotify_data_path(data, data_type);
 	unsigned int fid_mode =3D FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
+	struct mem_cgroup *old_memcg;
 	struct inode *child =3D NULL;
 	bool name_event =3D false;
=20
@@ -580,7 +581,7 @@ static struct fanotify_event *fanotify_alloc_event(st=
ruct fsnotify_group *group,
 		gfp |=3D __GFP_RETRY_MAYFAIL;
=20
 	/* Whoever is interested in the event, pays for the allocation. */
-	memalloc_use_memcg(group->memcg);
+	old_memcg =3D memalloc_use_memcg(group->memcg);
=20
 	if (fanotify_is_perm_event(mask)) {
 		event =3D fanotify_alloc_perm_event(path, gfp);
@@ -608,7 +609,7 @@ static struct fanotify_event *fanotify_alloc_event(st=
ruct fsnotify_group *group,
 		event->pid =3D get_pid(task_tgid(current));
=20
 out:
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	return event;
 }
=20
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/ino=
tify_fsnotify.c
index a65cf8c9f600..8017a51561c4 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -66,6 +66,7 @@ static int inotify_one_event(struct fsnotify_group *gro=
up, u32 mask,
 	int ret;
 	int len =3D 0;
 	int alloc_len =3D sizeof(struct inotify_event_info);
+	struct mem_cgroup *old_memcg;
=20
 	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
 	    path && d_unlinked(path->dentry))
@@ -87,9 +88,9 @@ static int inotify_one_event(struct fsnotify_group *gro=
up, u32 mask,
 	 * trigger OOM killer in the target monitoring memcg as it may have
 	 * security repercussion.
 	 */
-	memalloc_use_memcg(group->memcg);
+	old_memcg =3D memalloc_use_memcg(group->memcg);
 	event =3D kmalloc(alloc_len, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
=20
 	if (unlikely(!event)) {
 		/*
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index f889e332912f..b8fde48d44a9 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -312,31 +312,21 @@ static inline void memalloc_nocma_restore(unsigned =
int flags)
  * __GFP_ACCOUNT allocations till the end of the scope will be charged t=
o the
  * given memcg.
  *
- * NOTE: This function is not nesting safe.
+ * NOTE: This function can nest. Users must save the return value and
+ * reset the previous value after their own charging scope is over
  */
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *
+memalloc_use_memcg(struct mem_cgroup *memcg)
 {
-	WARN_ON_ONCE(current->active_memcg);
+	struct mem_cgroup *old =3D current->active_memcg;
 	current->active_memcg =3D memcg;
-}
-
-/**
- * memalloc_unuse_memcg - Ends the remote memcg charging scope.
- *
- * This function marks the end of the remote memcg charging scope starte=
d by
- * memalloc_use_memcg().
- */
-static inline void memalloc_unuse_memcg(void)
-{
-	current->active_memcg =3D NULL;
+	return old;
 }
 #else
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
-{
-}
-
-static inline void memalloc_unuse_memcg(void)
+static inline struct mem_cgroup *
+memalloc_use_memcg(struct mem_cgroup *memcg)
 {
+	return NULL;
 }
 #endif
=20
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b807952b4d43..b2468c80085d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5271,12 +5271,12 @@ static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct mem_cgroup *parent =3D mem_cgroup_from_css(parent_css);
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
 	long error =3D -ENOMEM;
=20
-	memalloc_use_memcg(parent);
+	old_memcg =3D memalloc_use_memcg(parent);
 	memcg =3D mem_cgroup_alloc();
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
=20
--=20
2.26.2

