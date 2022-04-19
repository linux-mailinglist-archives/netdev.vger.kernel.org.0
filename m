Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B053F5079BB
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357470AbiDSTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355593AbiDSTEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:04:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316143F892
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a18-20020a25bad2000000b0063360821ea7so15607108ybk.15
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FGNyyo4PBQdGplikOnlsFkyzMvGAhg560CsuSjZw+nU=;
        b=miiPj3CuwZr2ucKj47Nhb1lYrXW63Qn2jhWGcGBpUCHSNHafqxB1NoIWOH9Ud6KoAF
         g9/Jt8lJKsYd5Vi0rxfcUzgaDxn7inP9Ci/J70XvJOu+RAX/zBy1QKSTAV+fnwel0rz6
         KNKVh4oxlZnqJjolKiu3zQxxPd8gav0sm2w0vJAPBDHexyeDAfs+w86xpKORu/zXuFp+
         JUd9/g+0OcC5JXSHMV2hl4xqHAgtOvxtUJRancElzFM2++MWpTmfvz38iu2dAa3JsnNO
         DjH7CvoFeHX9p0O69yxDXyYwnVxE0Y9jMw8E82+ToL7Pa4SZTDFwRRu28OyVs9UkDDuy
         OB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FGNyyo4PBQdGplikOnlsFkyzMvGAhg560CsuSjZw+nU=;
        b=UnnTYqVElxkVG2A6Zl3kNugibcmsR2j0Pzn1iXNpkG2hig3UpK4PuL9+Mu53pCWRRN
         jl3KTHp1pexjXCxGk63ZbY+7AQyMTJpt4Pdpahd0ULBKpsM/T9J7TPRDLgWv6CCwnsZ0
         EvjdALxUWGV6QJunsguyIMLGoHsAMfl5sAEGpK2K91Kba7VQRbevYvrz7SO+Cur74SFb
         UcjCm5ANzY/PsUw2lnj0xvYy7cz/YWH97a9imSew5rfOrtoYHSRaM8z+Gek8WEbO3w05
         zrmoCSNLmW7WOe+++cDQnPtCnSrAB/UpLyrr1+EeVt3tT0bEqMFUsoNyOtIg7r2GEdUx
         m4qw==
X-Gm-Message-State: AOAM530pHxMdjG9geOmgkFzLhuz6bTWEqzOsV+v92Rq0N7DCcaHthExK
        o7vsoKt0Hmu0yZOafkiTX8EvqjmLBJZIBood2gJZvhfhcbQ1PHMpb/gtZc2JGrj31d3vyYQbHxV
        1dL7LE8zWcsdxmd9Cpcv2K1lBQ1RBlNb2yMwvjBen+i8WgbFMylFNWg==
X-Google-Smtp-Source: ABdhPJwPpo3hiHxvNCvBxOitCVt47TEQQGZyaikedlWYad3HN3gTE9mrpbicLdTVx4Hks/ZjF3gXTQo=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a5b:402:0:b0:63d:4a05:29b with SMTP id
 m2-20020a5b0402000000b0063d4a05029bmr16198263ybp.619.1650394867265; Tue, 19
 Apr 2022 12:01:07 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:00:49 -0700
In-Reply-To: <20220419190053.3395240-1-sdf@google.com>
Message-Id: <20220419190053.3395240-5-sdf@google.com>
Mime-Version: 1.0
References: <20220419190053.3395240-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next v5 4/8] bpf: minimize number of allocated lsm slots
 per program
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patch adds 1:1 mapping between all 211 LSM hooks
and bpf_cgroup program array. Instead of reserving a slot per
possible hook, reserve 10 slots per cgroup for lsm programs.
Those slots are dynamically allocated on demand and reclaimed.

It should be possible to eventually extend this idea to all hooks if
the memory consumption is unacceptable and shrink overall effective
programs array.

struct cgroup_bpf {
	struct bpf_prog_array *    effective[33];        /*     0   264 */
	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
	struct hlist_head          progs[33];            /*   264   264 */
	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
	u8                         flags[33];            /*   528    33 */

	/* XXX 7 bytes hole, try to pack */

	struct list_head           storages;             /*   568    16 */
	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
	struct bpf_prog_array *    inactive;             /*   584     8 */
	struct percpu_ref          refcnt;               /*   592    16 */
	struct work_struct         release_work;         /*   608    72 */

	/* size: 680, cachelines: 11, members: 7 */
	/* sum members: 673, holes: 1, sum holes: 7 */
	/* last cacheline: 40 bytes */
};

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |   4 +-
 include/linux/bpf_lsm.h         |   6 --
 kernel/bpf/bpf_lsm.c            |   5 --
 kernel/bpf/cgroup.c             | 108 +++++++++++++++++++++++++++-----
 4 files changed, 96 insertions(+), 27 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index d5a70a35dace..603f0a51eb3f 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,7 +10,9 @@
 
 struct bpf_prog_array;
 
-#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+/* Maximum number of concurrently attachable per-cgroup LSM hooks.
+ */
+#define CGROUP_LSM_NUM 10
 
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 7f0e59f5f9be..613de44aa429 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
 int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
-int bpf_lsm_hook_idx(u32 btf_id);
 
 #else /* !CONFIG_BPF_LSM */
 
@@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 	return -ENOENT;
 }
 
-static inline int bpf_lsm_hook_idx(u32 btf_id)
-{
-	return -EINVAL;
-}
-
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 2161cba1fe0c..7f8a631da90f 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -93,11 +93,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 	return 0;
 }
 
-int bpf_lsm_hook_idx(u32 btf_id)
-{
-	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
-}
-
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
 {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ba0e0c7a661d..539d17f7c9b2 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -106,10 +106,13 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
 	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	if (likely(cgrp))
+	if (likely(cgrp)) {
+		rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
 		ret = bpf_prog_run_array_cg(&cgrp->bpf,
 					    shim_prog->aux->cgroup_atype,
 					    ctx, bpf_prog_run, 0);
+		rcu_read_unlock();
+	}
 	return ret;
 }
 
@@ -128,10 +131,13 @@ unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
 	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
 
 	cgrp = sock_cgroup_ptr(&sock->sk->sk_cgrp_data);
-	if (likely(cgrp))
+	if (likely(cgrp)) {
+		rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
 		ret = bpf_prog_run_array_cg(&cgrp->bpf,
 					    shim_prog->aux->cgroup_atype,
 					    ctx, bpf_prog_run, 0);
+		rcu_read_unlock();
+	}
 	return ret;
 }
 
@@ -148,7 +154,7 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 	/*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
 	shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
 
-	rcu_read_lock();
+	rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
 	cgrp = task_dfl_cgroup(current);
 	if (likely(cgrp))
 		ret = bpf_prog_run_array_cg(&cgrp->bpf,
@@ -159,15 +165,68 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 }
 
 #ifdef CONFIG_BPF_LSM
+/* Readers are protected by rcu+synchronize_rcu.
+ * Writers are protected by cgroup_mutex.
+ */
+int cgroup_lsm_atype_usecnt[CGROUP_LSM_NUM];
+u32 cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
+
 static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
 {
-	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
+	int i;
+
+	WARN_ON_ONCE(!mutex_is_locked(&cgroup_mutex));
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++) {
+		if (cgroup_lsm_atype_btf_id[i] != attach_btf_id)
+			continue;
+
+		cgroup_lsm_atype_usecnt[i]++;
+		return CGROUP_LSM_START + i;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_usecnt); i++) {
+		if (cgroup_lsm_atype_usecnt[i] != 0)
+			continue;
+
+		cgroup_lsm_atype_btf_id[i] = attach_btf_id;
+		cgroup_lsm_atype_usecnt[i] = 1;
+		return CGROUP_LSM_START + i;
+	}
+
+	return -E2BIG;
+}
+
+static void bpf_lsm_attach_type_put(u32 attach_btf_id)
+{
+	int i;
+
+	WARN_ON_ONCE(!mutex_is_locked(&cgroup_mutex));
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++) {
+		if (cgroup_lsm_atype_btf_id[i] != attach_btf_id)
+			continue;
+
+		if (--cgroup_lsm_atype_usecnt[i] <= 0) {
+			/* Wait for any existing users to finish.
+			 */
+			synchronize_rcu();
+			WARN_ON_ONCE(cgroup_lsm_atype_usecnt[i] < 0);
+		}
+		return;
+	}
+
+	WARN_ON_ONCE(1);
 }
 #else
 static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
 {
 	return -EOPNOTSUPP;
 }
+
+static void bpf_lsm_attach_type_put(u32 attach_btf_id)
+{
+}
 #endif /* CONFIG_BPF_LSM */
 
 void cgroup_bpf_offline(struct cgroup *cgrp)
@@ -264,6 +323,7 @@ static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
 		return;
 
 	bpf_trampoline_unlink_cgroup_shim(prog);
+	bpf_lsm_attach_type_put(prog->aux->attach_btf_id);
 }
 
 /**
@@ -663,27 +723,37 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	progs = &cgrp->bpf.progs[atype];
 
-	if (!hierarchy_allows_attach(cgrp, atype))
-		return -EPERM;
+	if (!hierarchy_allows_attach(cgrp, atype)) {
+		err = -EPERM;
+		goto cleanup_attach_type;
+	}
 
-	if (!hlist_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
+	if (!hlist_empty(progs) && cgrp->bpf.flags[atype] != saved_flags) {
 		/* Disallow attaching non-overridable on top
 		 * of existing overridable in this cgroup.
 		 * Disallow attaching multi-prog if overridable or none
 		 */
-		return -EPERM;
+		err = -EPERM;
+		goto cleanup_attach_type;
+	}
 
-	if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS)
-		return -E2BIG;
+	if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS) {
+		err = -E2BIG;
+		goto cleanup_attach_type;
+	}
 
 	pl = find_attach_entry(progs, prog, link, replace_prog,
 			       flags & BPF_F_ALLOW_MULTI);
-	if (IS_ERR(pl))
-		return PTR_ERR(pl);
+	if (IS_ERR(pl)) {
+		err = PTR_ERR(pl);
+		goto cleanup_attach_type;
+	}
 
 	if (bpf_cgroup_storages_alloc(storage, new_storage, type,
-				      prog ? : link->link.prog, cgrp))
-		return -ENOMEM;
+				      prog ? : link->link.prog, cgrp)) {
+		err = -ENOMEM;
+		goto cleanup_attach_type;
+	}
 
 	if (pl) {
 		old_prog = pl->prog;
@@ -693,7 +763,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto cleanup_attach_type;
 		}
 		if (hlist_empty(progs))
 			hlist_add_head(&pl->node, progs);
@@ -745,6 +816,13 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		hlist_del(&pl->node);
 		kfree(pl);
 	}
+
+cleanup_attach_type:
+	if (type == BPF_LSM_CGROUP) {
+		struct bpf_prog *p = prog ? : link->link.prog;
+
+		bpf_lsm_attach_type_put(p->aux->attach_btf_id);
+	}
 	return err;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

