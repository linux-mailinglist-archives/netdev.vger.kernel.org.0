Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A7546B30
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350020AbiFJQ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349796AbiFJQ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769CA31DC6
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:13 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 18-20020a621512000000b0051b90b3a793so14201981pfv.8
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l76jjsqHLqMHwFkkjZUjgjlqBE6c07IG7AJ2eWumuxw=;
        b=p3CZ/WNjxK9K95SVnx+woF8pNngYWKNBrk9yITb+hLsUCyDkH5Eki7CeyfgKKR0dPK
         BUuvpXnunk+TpdlJTyrRljZ6zMINxn7h4wA3a3AsECvYWCy9P1Gvdoir+1DTFGxf+i1Y
         Vm9P/1zbezCzAgymUPaC/hhLtNwOhfP6U+kvHzYxebmbECuSmaRg9RSbAqhkUHIKCqkx
         7x8h5u+bjlc/bIdyA3UmZfIGU9xRFKCM1quC/DViWM63C/QCEjwcgsEjhjFbSEFkPnCA
         Hs/VhHMcxEMtpCWvAfhcR23qgXN2k0gnlLXApKl3L3CJsNagQ4BqEWkryX0VIgwAs5dm
         O0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l76jjsqHLqMHwFkkjZUjgjlqBE6c07IG7AJ2eWumuxw=;
        b=gZzmlKN681KojtEFmMz/tY/9p0EHjwbGwQdOIRe5DxIQYUuRSoTNubvvOj44Kq6wgJ
         Le5jwhxNiC7HsTEQlgrfZfUAiFN6xZHbZh+ZYDwTJWlfUZS556ylLph3Q5a63z7ZniU3
         EwsTC94Sr7gOCwLHUaecXjppF9bUyxyRr6zZKvzj+PTycgXpJHljeM5Azx/L9YOZTXXH
         sI7CXQWRyH/APYX82zNsavm+Tld93qht10yu+JJrWnkfXQtU9NGAVbe5S8eFWJ9J+PYq
         nwFttVJ3edIooTmeM0c/GLaEA03skYviMNMhMREffrVpysXqV4AENgX+8amYkH88N2I9
         Dr9A==
X-Gm-Message-State: AOAM5312LwyOjiaIKWqqu4CiQ9hZPEdQwutEM4pT0k5/btzEybnbg0Ok
        TBr72ekoVS52FPWpX+w7hD8wQd5lS6Wsc0cff/RfXLeWd4xiZLXz4XR2oPxQCeaBGsoft1anCyC
        4MAsbgnJYkcuSTKZu3t8yG3OqTZKvmwwXm+KhPTBXoamvTRazJ+SIuA==
X-Google-Smtp-Source: ABdhPJzxacifrmKiOZxykmFz6W2AsG0K2mKJX84WlmE99V2xIh6PVtGCntiu7u72czDVLoFIh35JKmQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:d48e:b0:167:5752:3b43 with SMTP id
 c14-20020a170902d48e00b0016757523b43mr35576031plg.52.1654880292875; Fri, 10
 Jun 2022 09:58:12 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:57:57 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-5-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 04/10] bpf: minimize number of allocated lsm slots
 per program
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

Move 'ifdef CONFIG_CGROUP_BPF' to expose CGROUP_BPF_ATTACH_TYPE_INVALID
to non-cgroup (core) parts.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |  3 +-
 include/linux/bpf.h             |  4 ++-
 include/linux/bpf_lsm.h         |  6 ----
 kernel/bpf/bpf_lsm.c            |  5 ---
 kernel/bpf/btf.c                | 10 ------
 kernel/bpf/cgroup.c             | 54 ++++++++++++++++++++++++++++++++-
 kernel/bpf/core.c               |  7 +++++
 kernel/bpf/trampoline.c         |  1 +
 8 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index b99f8c3e37ea..7b121bd780eb 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -11,7 +11,8 @@
 struct bpf_prog_array;
 
 #ifdef CONFIG_BPF_LSM
-#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
+/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
+#define CGROUP_LSM_NUM 10
 #else
 #define CGROUP_LSM_NUM 0
 #endif
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4dceb86229f6..503f28fa66d2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2407,7 +2407,6 @@ int bpf_arch_text_invalidate(void *dst, size_t len);
 
 struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
-int btf_id_set_index(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
 
@@ -2444,4 +2443,7 @@ void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
 void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
 int bpf_dynptr_check_size(u32 size);
 
+void bpf_cgroup_atype_put(int cgroup_atype);
+void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 61787a5f6af9..4bcf76a9bb06 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -42,7 +42,6 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
-int bpf_lsm_hook_idx(u32 btf_id);
 void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
 
 #else /* !CONFIG_BPF_LSM */
@@ -73,11 +72,6 @@ static inline void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 {
 }
 
-static inline int bpf_lsm_hook_idx(u32 btf_id)
-{
-	return -EINVAL;
-}
-
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 0f72020bfdcf..83aa431dd52e 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -69,11 +69,6 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 		*bpf_func = __cgroup_bpf_run_lsm_current;
 }
 
-int bpf_lsm_hook_idx(u32 btf_id)
-{
-	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
-}
-
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
 {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ec070d7f2f7a..ed8099e7550a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6842,16 +6842,6 @@ static int btf_id_cmp_func(const void *a, const void *b)
 	return *pa - *pb;
 }
 
-int btf_id_set_index(const struct btf_id_set *set, u32 id)
-{
-	const u32 *p;
-
-	p = bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func);
-	if (!p)
-		return -1;
-	return p - set->ids;
-}
-
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 {
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index b0314889a409..ba402d50e130 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -128,12 +128,56 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 }
 
 #ifdef CONFIG_BPF_LSM
+struct cgroup_lsm_atype {
+	u32 attach_btf_id;
+	int refcnt;
+};
+
+static struct cgroup_lsm_atype cgroup_lsm_atype[CGROUP_LSM_NUM];
+
 static enum cgroup_bpf_attach_type
 bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
 {
+	int i;
+
+	lockdep_assert_held(&cgroup_mutex);
+
 	if (attach_type != BPF_LSM_CGROUP)
 		return to_cgroup_bpf_attach_type(attach_type);
-	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
+		if (cgroup_lsm_atype[i].attach_btf_id == attach_btf_id)
+			return CGROUP_LSM_START + i;
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype); i++)
+		if (cgroup_lsm_atype[i].attach_btf_id == 0)
+			return CGROUP_LSM_START + i;
+
+	return -E2BIG;
+
+}
+
+void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
+{
+	int i = cgroup_atype - CGROUP_LSM_START;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	WARN_ON_ONCE(cgroup_lsm_atype[i].attach_btf_id &&
+		     cgroup_lsm_atype[i].attach_btf_id != attach_btf_id);
+
+	cgroup_lsm_atype[i].attach_btf_id = attach_btf_id;
+	cgroup_lsm_atype[i].refcnt++;
+}
+
+void bpf_cgroup_atype_put(int cgroup_atype)
+{
+	int i = cgroup_atype - CGROUP_LSM_START;
+
+	mutex_lock(&cgroup_mutex);
+	if (--cgroup_lsm_atype[i].refcnt <= 0)
+		cgroup_lsm_atype[i].attach_btf_id = 0;
+	mutex_unlock(&cgroup_mutex);
 }
 #else
 static enum cgroup_bpf_attach_type
@@ -143,6 +187,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
 		return to_cgroup_bpf_attach_type(attach_type);
 	return -EOPNOTSUPP;
 }
+
+void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
+{
+}
+
+void bpf_cgroup_atype_put(int cgroup_atype)
+{
+}
 #endif /* CONFIG_BPF_LSM */
 
 void cgroup_bpf_offline(struct cgroup *cgrp)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8d171eb0ed0d..0699098dc6bc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
 	fp->blinding_requested = bpf_jit_blinding_enabled(fp);
+#ifdef CONFIG_CGROUP_BPF
+	aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID;
+#endif
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
@@ -2554,6 +2557,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	aux = container_of(work, struct bpf_prog_aux, work);
 #ifdef CONFIG_BPF_SYSCALL
 	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
+#endif
+#ifdef CONFIG_CGROUP_BPF
+	if (aux->cgroup_atype != CGROUP_BPF_ATTACH_TYPE_INVALID)
+		bpf_cgroup_atype_put(aux->cgroup_atype);
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 023239a10e7c..e849dd243624 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -555,6 +555,7 @@ static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog
 	bpf_prog_inc(p);
 	bpf_link_init(&shim_link->link.link, BPF_LINK_TYPE_UNSPEC,
 		      &bpf_shim_tramp_link_lops, p);
+	bpf_cgroup_atype_get(p->aux->attach_btf_id, cgroup_atype);
 
 	return shim_link;
 }
-- 
2.36.1.476.g0c4daa206d-goog

