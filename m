Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155A253AED9
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiFAVBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiFAVAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:00:51 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F2A1E735F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 14:00:50 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so1591165iov.5
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z3XrmrzG1E7CQDQjbRLcTKucAXZgRFFOnuK9Lavovb8=;
        b=fvBwum9p0arUYomlScnWBNVHt3UxgVkXaL71BzZltne3RU86IkVsVcLl0Gd8j7O0ol
         SWb/Kn0IHafLup50hZkQfw6PjrMeVvYd/PN1OYjDwcb4dgjiaPMxMe18JP67fDCIbEKE
         VqYG2MeOBE15M5PgGPkLYKH15Mny/SAzetOXWlmkEjEaivmldWT8KygiP6BQMdA1v9Wo
         KWh+lO8WkCXW210gN+4PTjmuuS/+TN44MxzqCCNi2JE+HNUw0iqW2MjBDnyVuStAt/c5
         4Y+upMptOgkmdYMffa2eSQxPL/xmS+7DUp8CAaFI+byom2XXNJP0vPIu9up2E+/gKsW9
         Tqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z3XrmrzG1E7CQDQjbRLcTKucAXZgRFFOnuK9Lavovb8=;
        b=mWrzGxp7DR6CL9VAlzljVDRkvEvw0tfg4kQPDaFmyANBtbEu6OVWWO8zhAYw/HQ1L1
         Ceqgk6yOk0CVlD+2JHBQ5UAanlmVQM7wwxR1i04klKLKJqTj4H9El5mn1M0uHKQVBpIB
         HRq9fzsKinDHfRWscVNp96OAeFckK1840A/eJ2ZS0pTu1FP+4nTH+hOy5en9gJAimkb2
         CJ4zU87Wi/s259iKK/wikHW9wbgbUmDX/iIXZA/2q9m+VXKWGc9C2QPNCkIelWfUqhCS
         OTO/S6e1NucrI7rj807F+hfIlOjjMUSO4ivUmmdmxBFOIoVF84d+lkY408u7mH01v0z9
         DHyQ==
X-Gm-Message-State: AOAM532JN99vIA2Lr9V4ehJ+fwlgyQXLA6/zRftu3vEoVKa+SeqPw+1E
        FDY+cShNqciy49FGf8v823MeIywO2kwftJc3zZdWW3sB7CPwaWUJNQLHWN7VUboy03lpHWGHvZR
        gDKDei0pn2dcOF6jBSV0Tfyvi8r9BQxhG7LhzJNstnN13HO9dUhH14g==
X-Google-Smtp-Source: ABdhPJzpcccWKy/kWMc0Rr6d+Xasm+0rNCdub25bODIfr5daASxYMyMKpczpA58a6i2pPdSQB8oaJN0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a65:6a47:0:b0:3f5:d7a8:44ee with SMTP id
 o7-20020a656a47000000b003f5d7a844eemr732103pgu.330.1654110146989; Wed, 01 Jun
 2022 12:02:26 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:11 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-5-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 04/11] bpf: minimize number of allocated lsm slots
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

Move 'ifdef CONFIG_CGROUP_BPF' to expose CGROUP_BPF_ATTACH_TYPE_INVALID
to non-cgroup (core) parts.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup-defs.h |  3 ++-
 include/linux/bpf.h             |  2 ++
 include/linux/bpf_lsm.h         |  6 -----
 kernel/bpf/bpf_lsm.c            |  5 ----
 kernel/bpf/cgroup.c             | 45 ++++++++++++++++++++++++++++++++-
 kernel/bpf/core.c               |  7 +++++
 6 files changed, 55 insertions(+), 13 deletions(-)

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
index 210c4203db78..1a547fd6443c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2446,4 +2446,6 @@ void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
 void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
 int bpf_dynptr_check_size(u32 size);
 
+void bpf_cgroup_atype_free(int cgroup_atype);
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
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 66b644a76a69..a27a6a7bd852 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -129,12 +129,46 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 }
 
 #ifdef CONFIG_BPF_LSM
+u32 cgroup_lsm_atype_btf_id[CGROUP_LSM_NUM];
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
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
+		if (cgroup_lsm_atype_btf_id[i] == attach_btf_id)
+			return CGROUP_LSM_START + i;
+
+	for (i = 0; i < ARRAY_SIZE(cgroup_lsm_atype_btf_id); i++)
+		if (cgroup_lsm_atype_btf_id[i] == 0)
+			return CGROUP_LSM_START + i;
+
+	return -E2BIG;
+
+}
+
+static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
+{
+	int i = cgroup_atype - CGROUP_LSM_START;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	cgroup_lsm_atype_btf_id[i] = attach_btf_id;
+}
+
+void bpf_cgroup_atype_free(int cgroup_atype)
+{
+	int i = cgroup_atype - CGROUP_LSM_START;
+
+	mutex_lock(&cgroup_mutex);
+	cgroup_lsm_atype_btf_id[i] = 0;
+	mutex_unlock(&cgroup_mutex);
 }
 #else
 static enum cgroup_bpf_attach_type
@@ -144,6 +178,14 @@ bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
 		return to_cgroup_bpf_attach_type(attach_type);
 	return -EOPNOTSUPP;
 }
+
+static void bpf_cgroup_atype_alloc(u32 attach_btf_id, int cgroup_atype)
+{
+}
+
+void bpf_cgroup_atype_free(int cgroup_atype)
+{
+}
 #endif /* CONFIG_BPF_LSM */
 
 void cgroup_bpf_offline(struct cgroup *cgrp)
@@ -659,6 +701,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 		err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
 		if (err)
 			goto cleanup;
+		bpf_cgroup_atype_alloc(new_prog->aux->attach_btf_id, atype);
 	}
 
 	err = update_effective_progs(cgrp, atype);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 091ee210842f..224bb4d4fe4e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -107,6 +107,9 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
 	fp->blinding_requested = bpf_jit_blinding_enabled(fp);
+#ifdef CONFIG_BPF_LSM
+	aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID;
+#endif
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
@@ -2558,6 +2561,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	aux = container_of(work, struct bpf_prog_aux, work);
 #ifdef CONFIG_BPF_SYSCALL
 	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
+#endif
+#ifdef CONFIG_BPF_LSM
+	if (aux->cgroup_atype != CGROUP_BPF_ATTACH_TYPE_INVALID)
+		bpf_cgroup_atype_free(aux->cgroup_atype);
 #endif
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
-- 
2.36.1.255.ge46751e96f-goog

