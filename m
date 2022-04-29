Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A485D515697
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiD2VTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbiD2VTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF9A75601
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f825f8c944so85344367b3.15
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aV6zMjhI+NxDSKgLlq8Whr5WKUE+VVKbKnZCprfjQv0=;
        b=ql68dPfzQjTAhvEDq1SzQih4dEvJ9HA061FvpoGYjv8XE5D4aCRHJEDePwMfLQZ4cS
         a7zPAqE/DkoRl3K9nu377wZ6Nk1tBkevXbfVdWSm+2cKrVfZkDfrCXTussM9OFYe43Ox
         +NKQY3uSU6hz3cAZuXrDAjkKynDwPQLFaC3PAK8oNiQJfwU1teWk74l6ZfOqIHWbpz4w
         rdf0g3xrktI1u266WyJZyJeQBDWwZZHi8Q7LxVnj5roEs+stwICpVCLXl+ccdSC24SCM
         Rj9WIfxv0FEC/rhKadTyqtKUjvKYQd8JitWP4ktXDa7Pfs2Xl4mfh0RmNpLQDfeZALcl
         /sNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aV6zMjhI+NxDSKgLlq8Whr5WKUE+VVKbKnZCprfjQv0=;
        b=zM8OyInBvBO+GV2/b+j3BBOCJ7P9/YPE1RwknKzUtyXf7y4npcjL8DoTKtvt9ppzfD
         HWtDFQoVFvj/pYjmabfceBsmmJzLgGaTcpmbwR8ovIq667ErgY+LuYO61iVf10YeyONM
         rmVOJAwhuYukhZfRZ5gfkDo2/cmSat5VGyp9Xd6FGP3/4YxRUNoAYqDSvS9/PINiijMf
         dEBuNxpYGr44tjF4k22jIUlesLzubh5LF2Vbk20VVo0vZlRT75HT0QPlux4jZ8DBzgK0
         bwbhjOXuak5vdGchxumQ2BaP9O0AdVxd+GmLXgitWFxxG4qTlwyf8NCBfNSTNhtaIhIO
         4T/A==
X-Gm-Message-State: AOAM533lzQdy/1Y3VVNgApLKwtL3q3bUT+dMRCEa+QWL5FUIFKySPtEp
        5VmWCFv8FA2Ofj5lT5JR36OVE1WYDeR5cktVQVF3jllvK/hPa9lsk7HvzdBwlk1LH+sTyxm6P2S
        uUQ4msxF80FVk/CtJiEXnUMhQOk9OvD61Aj1fLCREcgTJtY2BJPiIbQ==
X-Google-Smtp-Source: ABdhPJyYd5j51PewB/MsctHB+6B7pDpg++6ajnhn6GG0yr/TXLGJ21sUC0qRyPlLdnZdcKAIhPZ82n4=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a05:690c:3:b0:2e0:a28a:f0eb with SMTP id
 bc3-20020a05690c000300b002e0a28af0ebmr1389548ywb.179.1651266947686; Fri, 29
 Apr 2022 14:15:47 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:32 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-3-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 02/10] bpf: convert cgroup_bpf.progs to hlist
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lets us reclaim some space to be used by new cgroup lsm slots.

Before:
struct cgroup_bpf {
	struct bpf_prog_array *    effective[23];        /*     0   184 */
	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
	struct list_head           progs[23];            /*   184   368 */
	/* --- cacheline 8 boundary (512 bytes) was 40 bytes ago --- */
	u32                        flags[23];            /*   552    92 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 10 boundary (640 bytes) was 8 bytes ago --- */
	struct list_head           storages;             /*   648    16 */
	struct bpf_prog_array *    inactive;             /*   664     8 */
	struct percpu_ref          refcnt;               /*   672    16 */
	struct work_struct         release_work;         /*   688    32 */

	/* size: 720, cachelines: 12, members: 7 */
	/* sum members: 716, holes: 1, sum holes: 4 */
	/* last cacheline: 16 bytes */
};

After:
struct cgroup_bpf {
	struct bpf_prog_array *    effective[23];        /*     0   184 */
	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
	struct hlist_head          progs[23];            /*   184   184 */
	/* --- cacheline 5 boundary (320 bytes) was 48 bytes ago --- */
	u8                         flags[23];            /*   368    23 */

	/* XXX 1 byte hole, try to pack */

	/* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
	struct list_head           storages;             /*   392    16 */
	struct bpf_prog_array *    inactive;             /*   408     8 */
	struct percpu_ref          refcnt;               /*   416    16 */
	struct work_struct         release_work;         /*   432    72 */

	/* size: 504, cachelines: 8, members: 7 */
	/* sum members: 503, holes: 1, sum holes: 1 */
	/* last cacheline: 56 bytes */
};

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |  4 +-
 include/linux/bpf-cgroup.h      |  2 +-
 kernel/bpf/cgroup.c             | 72 +++++++++++++++++++--------------
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 695d1224a71b..5d268e76d8e6 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -47,8 +47,8 @@ struct cgroup_bpf {
 	 * have either zero or one element
 	 * when BPF_F_ALLOW_MULTI the list can have up to BPF_CGROUP_MAX_PROGS
 	 */
-	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
-	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
+	struct hlist_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
+	u8 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
 
 	/* list of cgroup shared storages */
 	struct list_head storages;
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 669d96d074ad..6673acfbf2ef 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -95,7 +95,7 @@ struct bpf_cgroup_link {
 };
 
 struct bpf_prog_list {
-	struct list_head node;
+	struct hlist_node node;
 	struct bpf_prog *prog;
 	struct bpf_cgroup_link *link;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index afb414b26d01..134785ab487c 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -157,11 +157,12 @@ static void cgroup_bpf_release(struct work_struct *work)
 	mutex_lock(&cgroup_mutex);
 
 	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
-		struct list_head *progs = &cgrp->bpf.progs[atype];
-		struct bpf_prog_list *pl, *pltmp;
+		struct hlist_head *progs = &cgrp->bpf.progs[atype];
+		struct bpf_prog_list *pl;
+		struct hlist_node *pltmp;
 
-		list_for_each_entry_safe(pl, pltmp, progs, node) {
-			list_del(&pl->node);
+		hlist_for_each_entry_safe(pl, pltmp, progs, node) {
+			hlist_del(&pl->node);
 			if (pl->prog)
 				bpf_prog_put(pl->prog);
 			if (pl->link)
@@ -217,12 +218,12 @@ static struct bpf_prog *prog_list_prog(struct bpf_prog_list *pl)
 /* count number of elements in the list.
  * it's slow but the list cannot be long
  */
-static u32 prog_list_length(struct list_head *head)
+static u32 prog_list_length(struct hlist_head *head)
 {
 	struct bpf_prog_list *pl;
 	u32 cnt = 0;
 
-	list_for_each_entry(pl, head, node) {
+	hlist_for_each_entry(pl, head, node) {
 		if (!prog_list_prog(pl))
 			continue;
 		cnt++;
@@ -291,7 +292,7 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		if (cnt > 0 && !(p->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
 			continue;
 
-		list_for_each_entry(pl, &p->bpf.progs[atype], node) {
+		hlist_for_each_entry(pl, &p->bpf.progs[atype], node) {
 			if (!prog_list_prog(pl))
 				continue;
 
@@ -342,7 +343,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 		cgroup_bpf_get(p);
 
 	for (i = 0; i < NR; i++)
-		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
+		INIT_HLIST_HEAD(&cgrp->bpf.progs[i]);
 
 	INIT_LIST_HEAD(&cgrp->bpf.storages);
 
@@ -418,7 +419,7 @@ static int update_effective_progs(struct cgroup *cgrp,
 
 #define BPF_CGROUP_MAX_PROGS 64
 
-static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
+static struct bpf_prog_list *find_attach_entry(struct hlist_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
 					       struct bpf_prog *replace_prog,
@@ -428,12 +429,12 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
 
 	/* single-attach case */
 	if (!allow_multi) {
-		if (list_empty(progs))
+		if (hlist_empty(progs))
 			return NULL;
-		return list_first_entry(progs, typeof(*pl), node);
+		return hlist_entry(progs->first, typeof(*pl), node);
 	}
 
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (prog && pl->prog == prog && prog != replace_prog)
 			/* disallow attaching the same prog twice */
 			return ERR_PTR(-EINVAL);
@@ -444,7 +445,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
 
 	/* direct prog multi-attach w/ replacement case */
 	if (replace_prog) {
-		list_for_each_entry(pl, progs, node) {
+		hlist_for_each_entry(pl, progs, node) {
 			if (pl->prog == replace_prog)
 				/* a match found */
 				return pl;
@@ -480,7 +481,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	int err;
 
 	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
@@ -503,7 +504,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (!hierarchy_allows_attach(cgrp, atype))
 		return -EPERM;
 
-	if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
+	if (!hlist_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
 		/* Disallow attaching non-overridable on top
 		 * of existing overridable in this cgroup.
 		 * Disallow attaching multi-prog if overridable or none
@@ -525,12 +526,22 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (pl) {
 		old_prog = pl->prog;
 	} else {
+		struct hlist_node *last = NULL;
+
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
 			return -ENOMEM;
 		}
-		list_add_tail(&pl->node, progs);
+		if (hlist_empty(progs))
+			hlist_add_head(&pl->node, progs);
+		else
+			hlist_for_each(last, progs) {
+				if (last->next)
+					continue;
+				hlist_add_behind(&pl->node, last);
+				break;
+			}
 	}
 
 	pl->prog = prog;
@@ -556,7 +567,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	}
 	bpf_cgroup_storages_free(new_storage);
 	if (!old_prog) {
-		list_del(&pl->node);
+		hlist_del(&pl->node);
 		kfree(pl);
 	}
 	return err;
@@ -587,7 +598,7 @@ static void replace_effective_prog(struct cgroup *cgrp,
 	struct cgroup_subsys_state *css;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
-	struct list_head *head;
+	struct hlist_head *head;
 	struct cgroup *cg;
 	int pos;
 
@@ -603,7 +614,7 @@ static void replace_effective_prog(struct cgroup *cgrp,
 				continue;
 
 			head = &cg->bpf.progs[atype];
-			list_for_each_entry(pl, head, node) {
+			hlist_for_each_entry(pl, head, node) {
 				if (!prog_list_prog(pl))
 					continue;
 				if (pl->link == link)
@@ -637,7 +648,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	bool found = false;
 
 	atype = to_cgroup_bpf_attach_type(link->type);
@@ -649,7 +660,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (link->link.prog->type != new_prog->type)
 		return -EINVAL;
 
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (pl->link == link) {
 			found = true;
 			break;
@@ -688,7 +699,7 @@ static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
 	return ret;
 }
 
-static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
+static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
 					       bool allow_multi)
@@ -696,14 +707,14 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 	struct bpf_prog_list *pl;
 
 	if (!allow_multi) {
-		if (list_empty(progs))
+		if (hlist_empty(progs))
 			/* report error when trying to detach and nothing is attached */
 			return ERR_PTR(-ENOENT);
 
 		/* to maintain backward compatibility NONE and OVERRIDE cgroups
 		 * allow detaching with invalid FD (prog==NULL) in legacy mode
 		 */
-		return list_first_entry(progs, typeof(*pl), node);
+		return hlist_entry(progs->first, typeof(*pl), node);
 	}
 
 	if (!prog && !link)
@@ -713,7 +724,7 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 		return ERR_PTR(-EINVAL);
 
 	/* find the prog or link and detach it */
-	list_for_each_entry(pl, progs, node) {
+	hlist_for_each_entry(pl, progs, node) {
 		if (pl->prog == prog && pl->link == link)
 			return pl;
 	}
@@ -737,7 +748,7 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	u32 flags;
 	int err;
 
@@ -766,9 +777,10 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		goto cleanup;
 
 	/* now can actually delete it from this cgroup list */
-	list_del(&pl->node);
+	hlist_del(&pl->node);
+
 	kfree(pl);
-	if (list_empty(progs))
+	if (hlist_empty(progs))
 		/* last program was detached, reset flags to zero */
 		cgrp->bpf.flags[atype] = 0;
 	if (old_prog)
@@ -802,7 +814,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	enum bpf_attach_type type = attr->query.attach_type;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_array *effective;
-	struct list_head *progs;
+	struct hlist_head *progs;
 	struct bpf_prog *prog;
 	int cnt, ret = 0, i;
 	u32 flags;
@@ -841,7 +853,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		u32 id;
 
 		i = 0;
-		list_for_each_entry(pl, progs, node) {
+		hlist_for_each_entry(pl, progs, node) {
 			prog = prog_list_prog(pl);
 			id = prog->aux->id;
 			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
-- 
2.36.0.464.gb9c8b46e94-goog

