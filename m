Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244774F53B5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiDFEVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577668AbiDEXMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:12:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D8DF954A
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 14:44:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d2d45c0df7so4951757b3.1
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 14:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Bhxt+cb8+2AIQe/0sz8QNRlr2WEW8h/QbpgIgMwxHs0=;
        b=CAx1RxRj3zVuuVgU5zOA4NzyuP4FMnYKc4SwtS8lkWBHAm9JamvMY6j1ruYUbtafws
         IjLxpiZyuI+emJmFa9W0ZsBFuwQDkLO1ZEpoRqkrHAfo+wkB4Y2ekdw9DXyl9GYE4RWX
         9nJxE7WNp8TqIZWlAsfvz4xbKrpMbtFScQhW+weXV9h33l7OvZlmpnM3KmGaQIOwjwBq
         4wIiOhdlKNiLzTgzLYiCytxdvqO6JrntlJJw4VbU7LAUXsqbeieVCqZ1N5Fc5tzgvgH2
         muy1kFbN+F3qP+SUTSmzry1pS5d1XlFdkpm3/fVCKPgnmoE136qsaUdmdU8kYGc5fGOC
         Xo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Bhxt+cb8+2AIQe/0sz8QNRlr2WEW8h/QbpgIgMwxHs0=;
        b=JgnbFWTsXoXa31ToTIsp08/UzDG1+FHOxhWowAQKlzPJkmWLIYvMzINj67tYSRNE3A
         5/hlh9Tv1OANtFqkGJZFvFNN2ef0u4oQCIUS53SXzUYdUdYrQKIKeEDXflXk2wi6eZLu
         fF4apJ52Zq6y21eGw76vjxG5uIIKmG22NKvEnOpUIoluER02wMnrUEZAfADYKhnKucIj
         NaP+OItuvus3MhDSfH+cXBqaei84qOprjz+vZyhjzpIZucj7ZCG0XFHjhQQOP5m9Ki4/
         99D0apl9gEpK1CA8b8xp1K88bhfQt1VukmP4niKwgt9xoMdAtREukQMCPDD4HmwlFAU7
         Q4CA==
X-Gm-Message-State: AOAM533f7vCyWNsMPvcYlR956m63dZkukHvIL5nfZ8ACn3GNn084XU4V
        lUMdS0t2SKoYgProQ5lVpivgTf280M//gYMCHoY3hg8qXKOvd+/2L9ROG1znDHMwiMyaeYWJDxt
        Cu4nwNxF3z3pPI/2lAUVE6y53pCPI2gJTMfNaEABIVzTG2+6A6Y+GjQ==
X-Google-Smtp-Source: ABdhPJxPVkCwCJ8PRBZzAWK6HIv4euPgTVQAIWR95UbHBLCuxlQ5XKQ9vPeBZWVM3RTNLSZrippkY3I=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:73b5:ffab:2024:2901])
 (user=sdf job=sendgmr) by 2002:a25:c08f:0:b0:633:910d:498b with SMTP id
 c137-20020a25c08f000000b00633910d498bmr4065433ybf.531.1649195032550; Tue, 05
 Apr 2022 14:43:52 -0700 (PDT)
Date:   Tue,  5 Apr 2022 14:43:38 -0700
In-Reply-To: <20220405214342.1968262-1-sdf@google.com>
Message-Id: <20220405214342.1968262-4-sdf@google.com>
Mime-Version: 1.0
References: <20220405214342.1968262-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH bpf-next v2 3/7] bpf: minimize number of allocated lsm slots
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
This still adds some bloat to the cgroup and brings us back to
roughly pre-cgroup_bpf_attach_type times.

It should be possible to eventually extend this idea to all hooks if
the memory consumption is unacceptable and shrink overall effective
programs array.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |  4 +-
 include/linux/bpf_lsm.h         |  6 ---
 kernel/bpf/bpf_lsm.c            |  9 ++--
 kernel/bpf/cgroup.c             | 95 ++++++++++++++++++++++++++++-----
 4 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 6c661b4df9fa..d42516e86b3a 100644
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
index eca258ba71d8..8b948ec9ab73 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
 	if (unlikely(!sk))
 		return 0;
 
+	rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 	if (likely(cgrp))
 		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
 					    ctx, bpf_prog_run, 0);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 	/*prog = container_of(insn, struct bpf_prog, insnsi);*/
 	prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
 
-	rcu_read_lock();
+	rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
 	cgrp = task_dfl_cgroup(current);
 	if (likely(cgrp))
 		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
@@ -122,11 +124,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
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
index 8c77703954f7..bb76a2a7b587 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -26,15 +26,67 @@ DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_CGROUP_BPF_ATTACH_TYPE
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
 #ifdef CONFIG_BPF_LSM
+/* Readers are protected by rcu+synchronize_rcu.
+ * Writers are protected by cgroup_mutex.
+ */
+refcount_t cgroup_lsm_atype_usecnt[CGROUP_LSM_NUM];
+int cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
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
+		refcount_inc(&cgroup_lsm_atype_usecnt[i]);
+		return CGROUP_LSM_START + i;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_usecnt); i++) {
+		if (refcount_read(&cgroup_lsm_atype_usecnt[i]) != 0)
+			continue;
+
+		cgroup_lsm_atype_btf_id[i] = attach_btf_id;
+		refcount_set(&cgroup_lsm_atype_usecnt[i], 1);
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
+		if (refcount_dec_and_test(&cgroup_lsm_atype_usecnt[i])) {
+			/* Wait for any existing users to finish.
+			 */
+			synchronize_rcu();
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
 #endif
 
 void cgroup_bpf_offline(struct cgroup *cgrp)
@@ -130,6 +182,7 @@ static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
 		return;
 
 	bpf_trampoline_unlink_cgroup_shim(prog);
+	bpf_lsm_attach_type_put(prog->aux->attach_btf_id);
 }
 
 /**
@@ -522,27 +575,37 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	progs = &cgrp->bpf.progs[atype];
 
-	if (!hierarchy_allows_attach(cgrp, atype))
-		return -EPERM;
+	if (!hierarchy_allows_attach(cgrp, atype)) {
+		err = -EPERM;
+		goto cleanup_attach_type;
+	}
 
-	if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
+	if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags) {
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
@@ -550,7 +613,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto cleanup_attach_type;
 		}
 		list_add_tail(&pl->node, progs);
 	}
@@ -595,6 +659,13 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		list_del(&pl->node);
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
2.35.1.1094.g7c7d902a7c-goog

