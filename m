Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0E42CEB1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfE1S36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:29:58 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:51315 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbfE1S3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:29:55 -0400
Received: by mail-pl1-f201.google.com with SMTP id d2so6044601pla.18
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0LBl1NqqStdKyDsXqFvntmpytDthHAPtAsVh7FYhF7k=;
        b=vJg7vwfNtdEL3NjsScYt3kfWy4mPlGULcyVuILeDAkqi/fUijLse91AWCP6hYVS7BY
         WPwNRcCO6VLmIwzjcTq9tATHN9RQwPMB67y81c0MEIGy78zQkfFV0DnA+Oz0s036amh8
         1OltKN5fGU0WA0sfXne/l46bj/q8lmSNA/Fcv1B1R6EXWolvDnESPPT6vlKYa562M99u
         fIBBCggSkvZmLsFE+Xpy8jDgyMqg1vil2BdIR1TQCXPFFByqn2kujsTGvuB0PXXldsEl
         j53P0AqUN8RttsOaJHk+y5G/5tU3OdAFhzSaCoZZAqemgiWhPHFQbXo0FrguKJJSVlB9
         SVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0LBl1NqqStdKyDsXqFvntmpytDthHAPtAsVh7FYhF7k=;
        b=SCMFVZ5A+ITDfKrSnJjiFpGafkFJPTNhO/vpM/vUiF0I/XGX9WmXAAKIJpqzi2K0LK
         YA0EkZnUeKJNfR9CBIS36em8FC0cCNQlgY7IHIV1zQG4dzLBCqeUUaXcdNoUBHeQDSue
         Y/23nvXyH98r3MrUhWTPjuHCoTJ39JGooywGVLdNqsGc5eZKhWjsi9oDhxFDaVKDNNqb
         XJo3vw+m8dIG7ZM27esSQ9Y7gaSO/RmpolxqnvEzm+1buePXdqfhc4ohDvO6crngtkLJ
         jrbBJHPHJAG1HD/iMaw9FWWx8a17W/2w55+uBJKQST5ilPDoQ8yZw49SRbVPBG/RN7vb
         2r9A==
X-Gm-Message-State: APjAAAXJaeKABNwXCBembZyh9+aX5BTvZcvQZ2JVX1nqjQjT3B4IggjN
        /nznt2BakPAPO+5LdcNalkOoqc7VksHiL01bmFbnRe6G/KUybnJ77NmL5tkwiic2rCkfE7Eltk8
        BJHwhXbmn/ILTpNx5ibhM0+20cwOeVf7wtk/M1AELe8IUPhBmsUow0w==
X-Google-Smtp-Source: APXvYqzakGOKaM93IsTd8MK3CZpvvqvCaFXLvkeY9DeWnxAtNvGgkyDulx1zMQlT/MPU5tc4te3LSIw=
X-Received: by 2002:a63:31d8:: with SMTP id x207mr7733844pgx.403.1559068194150;
 Tue, 28 May 2019 11:29:54 -0700 (PDT)
Date:   Tue, 28 May 2019 11:29:45 -0700
In-Reply-To: <20190528182946.3633-1-sdf@google.com>
Message-Id: <20190528182946.3633-3-sdf@google.com>
Mime-Version: 1.0
References: <20190528182946.3633-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we don't have __rcu markers on the bpf_prog_array helpers,
let's use proper rcu_dereference_protected to obtain array pointer
under mutex.

We also don't need __rcu annotations on cgroup_bpf.inactive since
it's not read/updated concurrently.

v3:
* amend cgroup_rcu_dereference to include percpu_ref_is_dying;
  cgroup_bpf is now reference counted and we don't hold cgroup_mutex
  anymore in cgroup_bpf_release

v2:
* replace xchg with rcu_swap_protected

Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  2 +-
 kernel/bpf/cgroup.c        | 32 +++++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 9f100fc422c3..b631ee75762d 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -72,7 +72,7 @@ struct cgroup_bpf {
 	u32 flags[MAX_BPF_ATTACH_TYPE];
 
 	/* temp storage for effective prog array used by prog_attach/detach */
-	struct bpf_prog_array __rcu *inactive;
+	struct bpf_prog_array *inactive;
 
 	/* reference counter used to detach bpf programs after cgroup removal */
 	struct percpu_ref refcnt;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index d995edbe816d..118b70175dd9 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -22,6 +22,13 @@
 DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
+#define cgroup_rcu_dereference(cgrp, p)					\
+	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex) ||	\
+				  percpu_ref_is_dying(&cgrp->bpf.refcnt))
+
+#define cgroup_rcu_swap(rcu_ptr, ptr)					\
+	rcu_swap_protected(rcu_ptr, ptr, lockdep_is_held(&cgroup_mutex))
+
 void cgroup_bpf_offline(struct cgroup *cgrp)
 {
 	cgroup_get(cgrp);
@@ -38,6 +45,7 @@ static void cgroup_bpf_release(struct work_struct *work)
 	struct cgroup *cgrp = container_of(work, struct cgroup,
 					   bpf.release_work);
 	enum bpf_cgroup_storage_type stype;
+	struct bpf_prog_array *old_array;
 	unsigned int type;
 
 	for (type = 0; type < ARRAY_SIZE(cgrp->bpf.progs); type++) {
@@ -54,7 +62,9 @@ static void cgroup_bpf_release(struct work_struct *work)
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key);
 		}
-		bpf_prog_array_free(cgrp->bpf.effective[type]);
+		old_array = cgroup_rcu_dereference(cgrp,
+						   cgrp->bpf.effective[type]);
+		bpf_prog_array_free(old_array);
 	}
 
 	percpu_ref_exit(&cgrp->bpf.refcnt);
@@ -126,7 +136,7 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
  */
 static int compute_effective_progs(struct cgroup *cgrp,
 				   enum bpf_attach_type type,
-				   struct bpf_prog_array __rcu **array)
+				   struct bpf_prog_array **array)
 {
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *progs;
@@ -164,17 +174,15 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		}
 	} while ((p = cgroup_parent(p)));
 
-	rcu_assign_pointer(*array, progs);
+	*array = progs;
 	return 0;
 }
 
 static void activate_effective_progs(struct cgroup *cgrp,
 				     enum bpf_attach_type type,
-				     struct bpf_prog_array __rcu *array)
+				     struct bpf_prog_array *old_array)
 {
-	struct bpf_prog_array __rcu *old_array;
-
-	old_array = xchg(&cgrp->bpf.effective[type], array);
+	cgroup_rcu_swap(cgrp->bpf.effective[type], old_array);
 	/* free prog array after grace period, since __cgroup_bpf_run_*()
 	 * might be still walking the array
 	 */
@@ -191,7 +199,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  * that array below is variable length
  */
 #define	NR ARRAY_SIZE(cgrp->bpf.effective)
-	struct bpf_prog_array __rcu *arrays[NR] = {};
+	struct bpf_prog_array *arrays[NR] = {};
 	int ret, i;
 
 	ret = percpu_ref_init(&cgrp->bpf.refcnt, cgroup_bpf_release_fn, 0,
@@ -477,10 +485,13 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	enum bpf_attach_type type = attr->query.attach_type;
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	u32 flags = cgrp->bpf.flags[type];
+	struct bpf_prog_array *effective;
 	int cnt, ret = 0, i;
 
+	effective = cgroup_rcu_dereference(cgrp, cgrp->bpf.effective[type]);
+
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(cgrp->bpf.effective[type]);
+		cnt = bpf_prog_array_length(effective);
 	else
 		cnt = prog_list_length(progs);
 
@@ -497,8 +508,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	}
 
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
-		return bpf_prog_array_copy_to_user(cgrp->bpf.effective[type],
-						   prog_ids, cnt);
+		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
 	} else {
 		struct bpf_prog_list *pl;
 		u32 id;
-- 
2.22.0.rc1.257.g3120a18244-goog

