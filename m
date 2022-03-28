Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663694E9EC8
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245160AbiC1SSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245156AbiC1SSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:18:37 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D862C96
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2ea6741dc72so28246207b3.12
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=37pQv6HGCrpkpTiwzqXFeHBxxBEqM0bliSyRTX6B8Q4=;
        b=thK9TsmHfosNjM53uV2v9eQqbW/Gd/i5Sy3AKSvWAwkWubD7EZzQDBwD4EceHxJi8g
         an43F37tVugySjiKDgRGb1Rwy2TqVMxp9x5CQOo1PD6fEP7Am9OT1trXJHdKkn1YMvFQ
         bU6PsvkGW+h7liDjxMLjJuN6lAYyjaTUMGOCfvMVfKdLQqYoXgdWJwJ0Vh5d4krov83w
         kMeTqHwnE2YvmzgIAXNt+b/32219N6poNF1xkObI8XXGSm0HP5SHeBabyqGnCxF06bQi
         waDvnDEArWYlppahEILu4wFdrhMrV4bVt77jVm9GF7qJbqT/7eSsbnR4oJs43oxK11Bq
         ou5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=37pQv6HGCrpkpTiwzqXFeHBxxBEqM0bliSyRTX6B8Q4=;
        b=Sf7A/sr7p+NSIwJliHl6QkJ/FKei4OuXgWUaNY7SAQUVesRZ5M33yFQnnPryIxfS2D
         IfdT30+zRb2RUpl2+xAFoMCxAF5uZXnj+9j7oLYnzdlKqLq5u1+z3BrH6yg85FaECKDW
         5KSv/XVLSoqIUrcxKKEpx8GU37xF0dmcckXfGcI4h5Nz1fZS+TBqVwIrGYJYqU3atv0n
         G96yIhj9N1+V+ehdU1w1v6Hf8djpzL4TAsCLc9Qo7vAt+DfOph78EK08tfSlV5nIRFXN
         vicChJ4mMawlcOMyCTOgZFZpmKrl+jNZzHFuC5k9tZsnlId/3+DUPXzxYP8Ya2Vfrfjm
         GdKg==
X-Gm-Message-State: AOAM533DP71toVxFwwTlnHSt5nuNLRK6k52GxSsjc+b8QLjuwe75ogRA
        dZig0HLqkM9VHOa2CAs0TWVFBACQd8uPUvksFn899OvCLzjE2uOfl6is9o7eQpzEIGTfnK//eus
        +L1DfBAv0ww6R0FsJWetPl1RYWEK/0XxqEO3YlUHucJtN3Ug4R0qFxQ==
X-Google-Smtp-Source: ABdhPJyx0SiC5bceUDafZI1Jx6ls/zfMUEHe3JhcLZLZEHM5npOFvt99fZeeeDGbzs9ruvjtCFeqE/A=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a900:e0f6:cf98:d8c8])
 (user=sdf job=sendgmr) by 2002:a81:6606:0:b0:2e5:7ede:abad with SMTP id
 a6-20020a816606000000b002e57edeabadmr26451265ywc.405.1648491413921; Mon, 28
 Mar 2022 11:16:53 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:16:40 -0700
In-Reply-To: <20220328181644.1748789-1-sdf@google.com>
Message-Id: <20220328181644.1748789-4-sdf@google.com>
Mime-Version: 1.0
References: <20220328181644.1748789-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH bpf-next 3/7] bpf: minimize number of allocated lsm slots per program
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/bpf_lsm.h         |  6 --
 kernel/bpf/bpf_lsm.c            |  9 +--
 kernel/bpf/cgroup.c             | 98 +++++++++++++++++++++++++++++----
 4 files changed, 92 insertions(+), 25 deletions(-)

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
index 7e4c2a4999de..9cc2f0bf78f1 100644
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
index 8fa70bc2aaf7..5ecc680eeff3 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -25,6 +25,59 @@
 DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_CGROUP_BPF_ATTACH_TYPE);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
+/* Readers are protected by rcu+synchronize_rcu.
+ * Writers are protected by cgroup_mutex.
+ */
+refcount_t cgroup_lsm_atype_usecnt[CGROUP_LSM_NUM];
+int cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
+
+static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
+{
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
+}
+
 void cgroup_bpf_offline(struct cgroup *cgrp)
 {
 	cgroup_get(cgrp);
@@ -118,6 +171,7 @@ static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
 		return;
 
 	bpf_trampoline_unlink_cgroup_shim(prog);
+	bpf_lsm_attach_type_put(prog->aux->attach_btf_id);
 }
 
 /**
@@ -496,7 +550,9 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 			if (err)
 				return -EINVAL;
 
-			atype = CGROUP_LSM_START + bpf_lsm_hook_idx(p->aux->attach_btf_id);
+			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
+			if (atype < 0)
+				return atype;
 		}
 
 		p->aux->cgroup_atype = atype;
@@ -508,27 +564,37 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
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
@@ -536,7 +602,8 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
 		if (!pl) {
 			bpf_cgroup_storages_free(new_storage);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto cleanup_attach_type;
 		}
 		list_add_tail(&pl->node, progs);
 	}
@@ -581,6 +648,13 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
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
2.35.1.1021.g381101b075-goog

