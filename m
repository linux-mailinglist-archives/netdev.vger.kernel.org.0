Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DA81972B4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 05:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgC3DAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 23:00:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29230 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbgC3DAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 23:00:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U2x0DB014764
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=n3mmc3qhj/PxVBHVWuYXIsIrqtfbh12rwLmyhTGKfBg=;
 b=LjbeWFxKyJDBqWuQCWfP+w6z61ZdVrfkgZYhfSqgqrTWy7X3zvmrxAJmWmbIuBhzrqFq
 fOnKuuDtHehbtOnBRRc9jtqWnZSH/9a9cFRqA+K4Nlf6MgPjRKm+ixioiCqpdUFh8VMT
 rgItDot90/Gh8kTFXw+21i1WLGHk44/Aq7U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30243m6kus-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:11 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 29 Mar 2020 20:00:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 17ADA2EC3214; Sun, 29 Mar 2020 20:00:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/4] bpf: implement bpf_link-based cgroup BPF program attachment
Date:   Sun, 29 Mar 2020 19:59:58 -0700
Message-ID: <20200330030001.2312810-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330030001.2312810-1-andriin@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=25 spamscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement new sub-command to attach cgroup BPF programs and return FD-based
bpf_link back on success. bpf_link, once attached to cgroup, cannot be
replaced, except by owner having its FD. Cgroup bpf_link supports only
BPF_F_ALLOW_MULTI semantics. Both link-based and prog-based BPF_F_ALLOW_MULTI
attachments can be freely intermixed.

To prevent bpf_cgroup_link from keeping cgroup alive past the point when no
BPF program can be executed, implement auto-detachment of link. When
cgroup_bpf_release() is called, all attached bpf_links are forced to release
cgroup refcounts, but they leave bpf_link otherwise active and allocated, as
well as still owning underlying bpf_prog. This is because user-space might
still have FDs open and active, so bpf_link as a user-referenced object can't
be freed yet. Once last active FD is closed, bpf_link will be freed and
underlying bpf_prog refcount will be dropped. But cgroup refcount won't be
touched, because cgroup is released already.

The inherent race between bpf_cgroup_link release (from closing last FD) and
cgroup_bpf_release() is resolved by both operations taking cgroup_mutex. So
the only additional check required is when bpf_cgroup_link attempts to detach
itself from cgroup. At that time we need to check whether there is still
cgroup associated with that link. And if not, exit with success, because
bpf_cgroup_link was already successfully detached.

Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf-cgroup.h     |  29 ++-
 include/linux/bpf.h            |  10 +-
 include/uapi/linux/bpf.h       |  10 +-
 kernel/bpf/cgroup.c            | 315 +++++++++++++++++++++++++--------
 kernel/bpf/syscall.c           |  61 ++++++-
 kernel/cgroup/cgroup.c         |  14 +-
 tools/include/uapi/linux/bpf.h |  10 +-
 7 files changed, 351 insertions(+), 98 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a7cd5c7a2509..d2d969669564 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -51,9 +51,18 @@ struct bpf_cgroup_storage {
 	struct rcu_head rcu;
 };
 
+struct bpf_cgroup_link {
+	struct bpf_link link;
+	struct cgroup *cgroup;
+	enum bpf_attach_type type;
+};
+
+extern const struct bpf_link_ops bpf_cgroup_link_lops;
+
 struct bpf_prog_list {
 	struct list_head node;
 	struct bpf_prog *prog;
+	struct bpf_cgroup_link *link;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 };
 
@@ -84,20 +93,23 @@ struct cgroup_bpf {
 int cgroup_bpf_inherit(struct cgroup *cgrp);
 void cgroup_bpf_offline(struct cgroup *cgrp);
 
-int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_prog *replace_prog,
+int __cgroup_bpf_attach(struct cgroup *cgrp,
+			struct bpf_prog *prog, struct bpf_prog *replace_prog,
+			struct bpf_cgroup_link *link,
 			enum bpf_attach_type type, u32 flags);
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
+			struct bpf_cgroup_link *link,
 			enum bpf_attach_type type);
 int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 
 /* Wrapper for __cgroup_bpf_*() protected by cgroup_mutex */
-int cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      struct bpf_prog *replace_prog, enum bpf_attach_type type,
+int cgroup_bpf_attach(struct cgroup *cgrp,
+		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
+		      struct bpf_cgroup_link *link, enum bpf_attach_type type,
 		      u32 flags);
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type, u32 flags);
+		      enum bpf_attach_type type);
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr);
 
@@ -332,6 +344,7 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog);
 int cgroup_bpf_prog_detach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype);
+int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 int cgroup_bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr);
 #else
@@ -354,6 +367,12 @@ static inline int cgroup_bpf_prog_detach(const union bpf_attr *attr,
 	return -EINVAL;
 }
 
+static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
+					 struct bpf_prog *prog)
+{
+	return -EINVAL;
+}
+
 static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 					union bpf_attr __user *uattr)
 {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3bde59a8453b..56254d880293 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1082,15 +1082,23 @@ extern int sysctl_unprivileged_bpf_disabled;
 int bpf_map_new_fd(struct bpf_map *map, int flags);
 int bpf_prog_new_fd(struct bpf_prog *prog);
 
-struct bpf_link;
+struct bpf_link {
+	atomic64_t refcnt;
+	const struct bpf_link_ops *ops;
+	struct bpf_prog *prog;
+	struct work_struct work;
+};
 
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
+
 };
 
 void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
 		   struct bpf_prog *prog);
+void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
+		      int link_fd);
 void bpf_link_inc(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f1fbc36f58d3..8b3f1c098ac0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -111,6 +111,7 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
+	BPF_LINK_CREATE,
 };
 
 enum bpf_map_type {
@@ -541,7 +542,7 @@ union bpf_attr {
 		__u32		prog_cnt;
 	} query;
 
-	struct {
+	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
 		__u64 name;
 		__u32 prog_fd;
 	} raw_tracepoint;
@@ -569,6 +570,13 @@ union bpf_attr {
 		__u64		probe_offset;	/* output: probe_offset */
 		__u64		probe_addr;	/* output: probe_addr */
 	} task_fd_query;
+
+	struct { /* struct used by BPF_LINK_CREATE command */
+		__u32		prog_fd;	/* eBPF program to attach */
+		__u32		target_fd;	/* object to attach to */
+		__u32		attach_type;	/* attach type */
+		__u32		flags;		/* extra flags */
+	} link_create;
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 9c8472823a7f..c24029937431 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -80,6 +80,17 @@ static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
 		bpf_cgroup_storage_unlink(storages[stype]);
 }
 
+/* Called when bpf_cgroup_link is auto-detached from dying cgroup.
+ * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
+ * doesn't free link memory, which will eventually be done by bpf_link's
+ * release() callback, when its last FD is closed.
+ */
+static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
+{
+	cgroup_put(link->cgroup);
+	link->cgroup = NULL;
+}
+
 /**
  * cgroup_bpf_release() - put references of all bpf programs and
  *                        release all cgroup bpf data
@@ -100,7 +111,10 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 		list_for_each_entry_safe(pl, tmp, progs, node) {
 			list_del(&pl->node);
-			bpf_prog_put(pl->prog);
+			if (pl->prog)
+				bpf_prog_put(pl->prog);
+			if (pl->link)
+				bpf_cgroup_link_auto_detach(pl->link);
 			bpf_cgroup_storages_unlink(pl->storage);
 			bpf_cgroup_storages_free(pl->storage);
 			kfree(pl);
@@ -134,6 +148,18 @@ static void cgroup_bpf_release_fn(struct percpu_ref *ref)
 	queue_work(system_wq, &cgrp->bpf.release_work);
 }
 
+/* Get underlying bpf_prog of bpf_prog_list entry, regardless if it's through
+ * link or direct prog.
+ */
+static struct bpf_prog *prog_list_prog(struct bpf_prog_list *pl)
+{
+	if (pl->prog)
+		return pl->prog;
+	if (pl->link)
+		return pl->link->link.prog;
+	return NULL;
+}
+
 /* count number of elements in the list.
  * it's slow but the list cannot be long
  */
@@ -143,7 +169,7 @@ static u32 prog_list_length(struct list_head *head)
 	u32 cnt = 0;
 
 	list_for_each_entry(pl, head, node) {
-		if (!pl->prog)
+		if (!prog_list_prog(pl))
 			continue;
 		cnt++;
 	}
@@ -212,11 +238,11 @@ static int compute_effective_progs(struct cgroup *cgrp,
 			continue;
 
 		list_for_each_entry(pl, &p->bpf.progs[type], node) {
-			if (!pl->prog)
+			if (!prog_list_prog(pl))
 				continue;
 
 			item = &progs->items[cnt];
-			item->prog = pl->prog;
+			item->prog = prog_list_prog(pl);
 			bpf_cgroup_storages_assign(item->cgroup_storage,
 						   pl->storage);
 			cnt++;
@@ -333,19 +359,60 @@ static int update_effective_progs(struct cgroup *cgrp,
 
 #define BPF_CGROUP_MAX_PROGS 64
 
+static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
+					       struct bpf_prog *prog,
+					       struct bpf_cgroup_link *link,
+					       struct bpf_prog *replace_prog,
+					       bool allow_multi)
+{
+	struct bpf_prog_list *pl;
+
+	/* single-attach case */
+	if (!allow_multi) {
+		if (list_empty(progs))
+			return NULL;
+		return list_first_entry(progs, typeof(*pl), node);
+	}
+
+	list_for_each_entry(pl, progs, node) {
+		if (prog && pl->prog == prog)
+			/* disallow attaching the same prog twice */
+			return ERR_PTR(-EINVAL);
+		if (link && pl->link == link)
+			/* disallow attaching the same link twice */
+			return ERR_PTR(-EINVAL);
+	}
+
+	/* direct prog multi-attach w/ replacement case */
+	if (replace_prog) {
+		list_for_each_entry(pl, progs, node) {
+			if (pl->prog == replace_prog)
+				/* a match found */
+				return pl;
+		}
+		/* prog to replace not found for cgroup */
+		return ERR_PTR(-ENOENT);
+	}
+
+	return NULL;
+}
+
 /**
- * __cgroup_bpf_attach() - Attach the program to a cgroup, and
+ * __cgroup_bpf_attach() - Attach the program or the link to a cgroup, and
  *                         propagate the change to descendants
  * @cgrp: The cgroup which descendants to traverse
  * @prog: A program to attach
+ * @link: A link to attach
  * @replace_prog: Previously attached program to replace if BPF_F_REPLACE is set
  * @type: Type of attach operation
  * @flags: Option flags
  *
+ * Exactly one of @prog or @link can be non-null.
  * Must be called with cgroup_mutex held.
  */
-int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_prog *replace_prog,
+int __cgroup_bpf_attach(struct cgroup *cgrp,
+			struct bpf_prog *prog, struct bpf_prog *replace_prog,
+			struct bpf_cgroup_link *link,
 			enum bpf_attach_type type, u32 flags)
 {
 	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
@@ -353,13 +420,19 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
 		*old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
-	struct bpf_prog_list *pl, *replace_pl = NULL;
+	struct bpf_prog_list *pl;
 	int err;
 
 	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
 	    ((flags & BPF_F_REPLACE) && !(flags & BPF_F_ALLOW_MULTI)))
 		/* invalid combination */
 		return -EINVAL;
+	if (link && (prog || replace_prog))
+		/* only either link or prog/replace_prog can be specified */
+		return -EINVAL;
+	if (!!replace_prog != !!(flags & BPF_F_REPLACE))
+		/* replace_prog implies BPF_F_REPLACE, and vice versa */
+		return -EINVAL;
 
 	if (!hierarchy_allows_attach(cgrp, type))
 		return -EPERM;
@@ -374,26 +447,15 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS)
 		return -E2BIG;
 
-	if (flags & BPF_F_ALLOW_MULTI) {
-		list_for_each_entry(pl, progs, node) {
-			if (pl->prog == prog)
-				/* disallow attaching the same prog twice */
-				return -EINVAL;
-			if (pl->prog == replace_prog)
-				replace_pl = pl;
-		}
-		if ((flags & BPF_F_REPLACE) && !replace_pl)
-			/* prog to replace not found for cgroup */
-			return -ENOENT;
-	} else if (!list_empty(progs)) {
-		replace_pl = list_first_entry(progs, typeof(*pl), node);
-	}
+	pl = find_attach_entry(progs, prog, link, replace_prog,
+			       flags & BPF_F_ALLOW_MULTI);
+	if (IS_ERR(pl))
+		return PTR_ERR(pl);
 
-	if (bpf_cgroup_storages_alloc(storage, prog))
+	if (bpf_cgroup_storages_alloc(storage, prog ? : link->link.prog))
 		return -ENOMEM;
 
-	if (replace_pl) {
-		pl = replace_pl;
+	if (pl) {
 		old_prog = pl->prog;
 		bpf_cgroup_storages_unlink(pl->storage);
 		bpf_cgroup_storages_assign(old_storage, pl->storage);
@@ -407,6 +469,7 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 	}
 
 	pl->prog = prog;
+	pl->link = link;
 	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[type] = saved_flags;
 
@@ -414,80 +477,93 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (err)
 		goto cleanup;
 
-	static_branch_inc(&cgroup_bpf_enabled_key);
 	bpf_cgroup_storages_free(old_storage);
-	if (old_prog) {
+	if (old_prog)
 		bpf_prog_put(old_prog);
-		static_branch_dec(&cgroup_bpf_enabled_key);
-	}
-	bpf_cgroup_storages_link(storage, cgrp, type);
+	else
+		static_branch_inc(&cgroup_bpf_enabled_key);
+	bpf_cgroup_storages_link(pl->storage, cgrp, type);
 	return 0;
 
 cleanup:
-	/* and cleanup the prog list */
-	pl->prog = old_prog;
+	if (old_prog) {
+		pl->prog = old_prog;
+		pl->link = NULL;
+	}
 	bpf_cgroup_storages_free(pl->storage);
 	bpf_cgroup_storages_assign(pl->storage, old_storage);
 	bpf_cgroup_storages_link(pl->storage, cgrp, type);
-	if (!replace_pl) {
+	if (!old_prog) {
 		list_del(&pl->node);
 		kfree(pl);
 	}
 	return err;
 }
 
+static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
+					       struct bpf_prog *prog,
+					       struct bpf_cgroup_link *link,
+					       bool allow_multi)
+{
+	struct bpf_prog_list *pl;
+
+	if (!allow_multi) {
+		if (list_empty(progs))
+			/* report error when trying to detach and nothing is attached */
+			return ERR_PTR(-ENOENT);
+
+		/* to maintain backward compatibility NONE and OVERRIDE cgroups
+		 * allow detaching with invalid FD (prog==NULL) in legacy mode
+		 */
+		return list_first_entry(progs, typeof(*pl), node);
+	}
+
+	if (!prog && !link)
+		/* to detach MULTI prog the user has to specify valid FD
+		 * of the program or link to be detached
+		 */
+		return ERR_PTR(-EINVAL);
+
+	/* find the prog or link and detach it */
+	list_for_each_entry(pl, progs, node) {
+		if (pl->prog == prog && pl->link == link)
+			return pl;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 /**
- * __cgroup_bpf_detach() - Detach the program from a cgroup, and
+ * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
  *                         propagate the change to descendants
  * @cgrp: The cgroup which descendants to traverse
  * @prog: A program to detach or NULL
+ * @prog: A link to detach or NULL
  * @type: Type of detach operation
  *
+ * At most one of @prog or @link can be non-NULL.
  * Must be called with cgroup_mutex held.
  */
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-			enum bpf_attach_type type)
+			struct bpf_cgroup_link *link, enum bpf_attach_type type)
 {
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	u32 flags = cgrp->bpf.flags[type];
-	struct bpf_prog *old_prog = NULL;
 	struct bpf_prog_list *pl;
+	struct bpf_prog *old_prog;
 	int err;
 
-	if (flags & BPF_F_ALLOW_MULTI) {
-		if (!prog)
-			/* to detach MULTI prog the user has to specify valid FD
-			 * of the program to be detached
-			 */
-			return -EINVAL;
-	} else {
-		if (list_empty(progs))
-			/* report error when trying to detach and nothing is attached */
-			return -ENOENT;
-	}
+	if (prog && link)
+		/* only one of prog or link can be specified */
+		return -EINVAL;
 
-	if (flags & BPF_F_ALLOW_MULTI) {
-		/* find the prog and detach it */
-		list_for_each_entry(pl, progs, node) {
-			if (pl->prog != prog)
-				continue;
-			old_prog = prog;
-			/* mark it deleted, so it's ignored while
-			 * recomputing effective
-			 */
-			pl->prog = NULL;
-			break;
-		}
-		if (!old_prog)
-			return -ENOENT;
-	} else {
-		/* to maintain backward compatibility NONE and OVERRIDE cgroups
-		 * allow detaching with invalid FD (prog==NULL)
-		 */
-		pl = list_first_entry(progs, typeof(*pl), node);
-		old_prog = pl->prog;
-		pl->prog = NULL;
-	}
+	pl = find_detach_entry(progs, prog, link, flags & BPF_F_ALLOW_MULTI);
+	if (IS_ERR(pl))
+		return PTR_ERR(pl);
+
+	/* mark it deleted, so it's ignored while recomputing effective */
+	old_prog = pl->prog;
+	pl->prog = NULL;
+	pl->link = NULL;
 
 	err = update_effective_progs(cgrp, type);
 	if (err)
@@ -501,14 +577,15 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (list_empty(progs))
 		/* last program was detached, reset flags to zero */
 		cgrp->bpf.flags[type] = 0;
-
-	bpf_prog_put(old_prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key);
 	return 0;
 
 cleanup:
-	/* and restore back old_prog */
+	/* restore back prog or link */
 	pl->prog = old_prog;
+	pl->link = link;
 	return err;
 }
 
@@ -521,6 +598,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	u32 flags = cgrp->bpf.flags[type];
 	struct bpf_prog_array *effective;
+	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
 
 	effective = rcu_dereference_protected(cgrp->bpf.effective[type],
@@ -551,7 +629,8 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 
 		i = 0;
 		list_for_each_entry(pl, progs, node) {
-			id = pl->prog->aux->id;
+			prog = prog_list_prog(pl);
+			id = prog->aux->id;
 			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
 				return -EFAULT;
 			if (++i == cnt)
@@ -581,8 +660,8 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 		}
 	}
 
-	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, attr->attach_type,
-				attr->attach_flags);
+	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL,
+				attr->attach_type, attr->attach_flags);
 
 	if (replace_prog)
 		bpf_prog_put(replace_prog);
@@ -604,7 +683,7 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
 	if (IS_ERR(prog))
 		prog = NULL;
 
-	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, 0);
+	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type);
 	if (prog)
 		bpf_prog_put(prog);
 
@@ -612,6 +691,90 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
 	return ret;
 }
 
+static void bpf_cgroup_link_release(struct bpf_link *link)
+{
+	struct bpf_cgroup_link *cg_link =
+		container_of(link, struct bpf_cgroup_link, link);
+
+	/* link might have been auto-detached by dying cgroup already,
+	 * in that case our work is done here
+	 */
+	if (!cg_link->cgroup)
+		return;
+
+	mutex_lock(&cgroup_mutex);
+
+	/* re-check cgroup under lock again */
+	if (!cg_link->cgroup) {
+		mutex_unlock(&cgroup_mutex);
+		return;
+	}
+
+	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
+				    cg_link->type));
+
+	mutex_unlock(&cgroup_mutex);
+	cgroup_put(cg_link->cgroup);
+}
+
+static void bpf_cgroup_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_cgroup_link *cg_link =
+		container_of(link, struct bpf_cgroup_link, link);
+
+	kfree(cg_link);
+}
+
+const struct bpf_link_ops bpf_cgroup_link_lops = {
+	.release = bpf_cgroup_link_release,
+	.dealloc = bpf_cgroup_link_dealloc,
+};
+
+int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct bpf_cgroup_link *link;
+	struct file *link_file;
+	struct cgroup *cgrp;
+	int err, link_fd;
+
+	if (attr->link_create.flags)
+		return -EINVAL;
+
+	cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err = -ENOMEM;
+		goto out_put_cgroup;
+	}
+	bpf_link_init(&link->link, &bpf_cgroup_link_lops, prog);
+	link->cgroup = cgrp;
+	link->type = attr->link_create.attach_type;
+
+	link_file = bpf_link_new_file(&link->link, &link_fd);
+	if (IS_ERR(link_file)) {
+		kfree(link);
+		err = PTR_ERR(link_file);
+		goto out_put_cgroup;
+	}
+
+	err = cgroup_bpf_attach(cgrp, NULL, NULL, link, link->type,
+				BPF_F_ALLOW_MULTI);
+	if (err) {
+		bpf_link_cleanup(&link->link, link_file, link_fd);
+		goto out_put_cgroup;
+	}
+
+	fd_install(link_fd, link_file);
+	return link_fd;
+
+out_put_cgroup:
+	cgroup_put(cgrp);
+	return err;
+}
+
 int cgroup_bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a616b63f23b4..05412b83ed6c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2175,13 +2175,6 @@ static int bpf_obj_get(const union bpf_attr *attr)
 				attr->file_flags);
 }
 
-struct bpf_link {
-	atomic64_t refcnt;
-	const struct bpf_link_ops *ops;
-	struct bpf_prog *prog;
-	struct work_struct work;
-};
-
 void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
 		   struct bpf_prog *prog)
 {
@@ -2195,8 +2188,8 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
  * anon_inode's release() call. This helper manages marking bpf_link as
  * defunct, releases anon_inode file and puts reserved FD.
  */
-static void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
-			     int link_fd)
+void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
+		      int link_fd)
 {
 	link->prog = NULL;
 	fput(link_file);
@@ -2266,6 +2259,10 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 		link_type = "raw_tracepoint";
 	else if (link->ops == &bpf_tracing_link_lops)
 		link_type = "tracing";
+#ifdef CONFIG_CGROUP_BPF
+	else if (link->ops == &bpf_cgroup_link_lops)
+		link_type = "cgroup";
+#endif
 	else
 		link_type = "unknown";
 
@@ -3553,6 +3550,49 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
 	return err;
 }
 
+#define BPF_LINK_CREATE_LAST_FIELD link_create.flags
+static int link_create(union bpf_attr *attr)
+{
+	enum bpf_prog_type ptype;
+	struct bpf_prog *prog;
+	int ret;
+
+	if (CHECK_ATTR(BPF_LINK_CREATE))
+		return -EINVAL;
+
+	ptype = attach_type_to_prog_type(attr->link_create.attach_type);
+	if (ptype == BPF_PROG_TYPE_UNSPEC)
+		return -EINVAL;
+
+	prog = bpf_prog_get_type(attr->link_create.prog_fd, ptype);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	ret = bpf_prog_attach_check_attach_type(prog,
+						attr->link_create.attach_type);
+	if (ret)
+		goto err_out;
+
+	switch (ptype) {
+	case BPF_PROG_TYPE_CGROUP_SKB:
+	case BPF_PROG_TYPE_CGROUP_SOCK:
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_CGROUP_DEVICE:
+	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+		ret = cgroup_bpf_link_attach(attr, prog);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+err_out:
+	if (ret < 0)
+		bpf_prog_put(prog);
+	return ret;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -3663,6 +3703,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_MAP_DELETE_BATCH:
 		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
 		break;
+	case BPF_LINK_CREATE:
+		err = link_create(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3dead0416b91..219624fba9ba 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6303,27 +6303,31 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
 #endif	/* CONFIG_SOCK_CGROUP_DATA */
 
 #ifdef CONFIG_CGROUP_BPF
-int cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      struct bpf_prog *replace_prog, enum bpf_attach_type type,
+int cgroup_bpf_attach(struct cgroup *cgrp,
+		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
+		      struct bpf_cgroup_link *link,
+		      enum bpf_attach_type type,
 		      u32 flags)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, type, flags);
+	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
+
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type, u32 flags)
+		      enum bpf_attach_type type)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_detach(cgrp, prog, type);
+	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
+
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f1fbc36f58d3..8b3f1c098ac0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -111,6 +111,7 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
+	BPF_LINK_CREATE,
 };
 
 enum bpf_map_type {
@@ -541,7 +542,7 @@ union bpf_attr {
 		__u32		prog_cnt;
 	} query;
 
-	struct {
+	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
 		__u64 name;
 		__u32 prog_fd;
 	} raw_tracepoint;
@@ -569,6 +570,13 @@ union bpf_attr {
 		__u64		probe_offset;	/* output: probe_offset */
 		__u64		probe_addr;	/* output: probe_addr */
 	} task_fd_query;
+
+	struct { /* struct used by BPF_LINK_CREATE command */
+		__u32		prog_fd;	/* eBPF program to attach */
+		__u32		target_fd;	/* object to attach to */
+		__u32		attach_type;	/* attach type */
+		__u32		flags;		/* extra flags */
+	} link_create;
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
-- 
2.17.1

