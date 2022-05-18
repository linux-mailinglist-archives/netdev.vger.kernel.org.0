Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36CE52C6D9
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiERW5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiERW4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117D514005
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e202-20020a25e7d3000000b0064dc69dfa9cso2865162ybh.16
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7/rGP9QR7/HGEwHx9YP+8NxN8ERbBSG5QGDqCVLF7+w=;
        b=a54Ay9GhW9OOg62y9fNL6KxBkTLguA+gAjdRSOk9rQWwabNZ7kzICt3IpN8PJ5Slr+
         rMYJwsosZ1aObd7AnESsBfB2J6m2qfjH6DXD5vIUwuf9BiaRwNbng8k4wqwJ/woR8SHV
         W3C/rMENMogKXRINZuXqF+6WPlwQV2o7+Ot3rYRL3VBOcFxmtSBfXsf81Cv0d/IjiJry
         o/s1CEViA9jSBvoEbBlYO+O3jlIR0uI7seDu5vdE6xfMZCb18sWAtNVwCIw4Ovr0PO8a
         LyhnFZVF9LZZCLOTBbQQCwQ/DkVdO4UfKGn42vRPfldXyn8G2pHkbrPvwhYhnTbXYDW0
         NLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7/rGP9QR7/HGEwHx9YP+8NxN8ERbBSG5QGDqCVLF7+w=;
        b=rVLfMX2X9y+Lpu4YpLP8upVAZAGGn+otPBUoeyI1bNJ51WlnBHnV9OwGK9bBdbyOz0
         KscuV+PuYrz5ZafkmNuydge5s/LqVHDPUCySFtaRPvFtg3QSv4lszoiintUMW3c+Fjb9
         wHaKqh1tUI17eR/s9UpOtqPBt/It23HdiElXICfynYaTm1upu4bqJGV47TCt8D2kpQHW
         v6P84SXF8Js/YrBsK8nnMGovHhnqecqIA8x9Jzz05Wn16dLTjGLAZN6DbU5YGEMVX23b
         TaojDQqkpZLKER28yKLHrBwdjYP2aJOURzTLZvZyI01mk8WkDd3FOegpzEQXak/vfxOk
         mkNw==
X-Gm-Message-State: AOAM531Q+owmL2v4ab6ZaaiVo6HUogEDSZuuVvenFwuf05UybSMpQKMv
        H2m5y+Wwwtkxzczfkawe4zN1hEPYejC7uopsyKJ96qgItnJhfl6MuJp58xSkelE4LSR8OmqhNyX
        hwJDRhKKdz1C4EVz/g2iJt0CxicGLfSot8/uFBj+4ecSrV44NdUoWww==
X-Google-Smtp-Source: ABdhPJycPUCRhJ9By4BKdJmdAH4jblYzh6F46E/bAvMtEaMIBY8AE54RbSEsJyHt9qTJ0vXNlhy08ZU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a5b:f83:0:b0:63d:a251:2c51 with SMTP id
 q3-20020a5b0f83000000b0063da2512c51mr1768144ybh.594.1652914542186; Wed, 18
 May 2022 15:55:42 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:24 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-5-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 04/11] bpf: minimize number of allocated lsm slots
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
 include/linux/bpf-cgroup-defs.h |   3 +-
 include/linux/bpf_lsm.h         |   6 --
 kernel/bpf/bpf_lsm.c            |   5 --
 kernel/bpf/cgroup.c             | 135 +++++++++++++++++++++++++++++---
 4 files changed, 125 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index d5a70a35dace..359d3f16abea 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -10,7 +10,8 @@
 
 struct bpf_prog_array;
 
-#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
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
index 654c23577ad3..96503c3e7a71 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -71,11 +71,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
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
index 2c356a38f4cf..a959cdd22870 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -132,15 +132,110 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 }
 
 #ifdef CONFIG_BPF_LSM
+struct list_head unused_bpf_lsm_atypes;
+struct list_head used_bpf_lsm_atypes;
+
+struct bpf_lsm_attach_type {
+	int index;
+	u32 btf_id;
+	int usecnt;
+	struct list_head atypes;
+	struct rcu_head rcu_head;
+};
+
+static int __init bpf_lsm_attach_type_init(void)
+{
+	struct bpf_lsm_attach_type *atype;
+	int i;
+
+	INIT_LIST_HEAD_RCU(&unused_bpf_lsm_atypes);
+	INIT_LIST_HEAD_RCU(&used_bpf_lsm_atypes);
+
+	for (i = 0; i < CGROUP_LSM_NUM; i++) {
+		atype = kzalloc(sizeof(*atype), GFP_KERNEL);
+		if (!atype)
+			continue;
+
+		atype->index = i;
+		list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
+	}
+
+	return 0;
+}
+late_initcall(bpf_lsm_attach_type_init);
+
 static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
 {
-	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
+	struct bpf_lsm_attach_type *atype;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
+		if (atype->btf_id != attach_btf_id)
+			continue;
+
+		atype->usecnt++;
+		return CGROUP_LSM_START + atype->index;
+	}
+
+	atype = list_first_or_null_rcu(&unused_bpf_lsm_atypes, struct bpf_lsm_attach_type, atypes);
+	if (!atype)
+		return -E2BIG;
+
+	list_del_rcu(&atype->atypes);
+	atype->btf_id = attach_btf_id;
+	atype->usecnt = 1;
+	list_add_tail_rcu(&atype->atypes, &used_bpf_lsm_atypes);
+
+	return CGROUP_LSM_START + atype->index;
+}
+
+static void bpf_lsm_attach_type_reclaim(struct rcu_head *head)
+{
+	struct bpf_lsm_attach_type *atype =
+		container_of(head, struct bpf_lsm_attach_type, rcu_head);
+
+	atype->btf_id = 0;
+	atype->usecnt = 0;
+	list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
+}
+
+static void bpf_lsm_attach_type_put(u32 attach_btf_id)
+{
+	struct bpf_lsm_attach_type *atype;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
+		if (atype->btf_id != attach_btf_id)
+			continue;
+
+		if (--atype->usecnt <= 0) {
+			list_del_rcu(&atype->atypes);
+			WARN_ON_ONCE(atype->usecnt < 0);
+
+			/* call_rcu here prevents atype reuse within
+			 * the same rcu grace period.
+			 * shim programs use __bpf_prog_enter_lsm_cgroup
+			 * which starts RCU read section.
+			 */
+			call_rcu(&atype->rcu_head, bpf_lsm_attach_type_reclaim);
+		}
+
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
@@ -224,6 +319,7 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
 static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog)
 {
 	bpf_trampoline_unlink_cgroup_shim(prog);
+	bpf_lsm_attach_type_put(prog->aux->attach_btf_id);
 }
 
 /**
@@ -619,27 +715,37 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
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
@@ -649,7 +755,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto cleanup_attach_type;
 		}
 		if (hlist_empty(progs))
 			hlist_add_head(&pl->node, progs);
@@ -698,6 +805,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		hlist_del(&pl->node);
 		kfree(pl);
 	}
+
+cleanup_attach_type:
+	if (type == BPF_LSM_CGROUP)
+		bpf_lsm_attach_type_put(new_prog->aux->attach_btf_id);
 	return err;
 }
 
-- 
2.36.1.124.g0e6072fb45-goog

