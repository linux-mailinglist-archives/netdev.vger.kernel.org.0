Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEBD27132
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfEVUyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:54:02 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:44825 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730410AbfEVUyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:54:01 -0400
Received: by mail-qk1-f201.google.com with SMTP id v2so2885551qkd.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gsZVfuoX2X6vkK0f8knEjN8r22iclX6zTitF4Gg7914=;
        b=rLnFSOub8FseXXP4FKAuV3xcyqb7T01KY5xSQWRMySc74eMzGpHlLNDNG+ETzW6XHv
         vfncHzJYqzGAEuKrF6fB4A0RFo8PA/UgMHvFmE6CxD+/Evb/1QRDEcd9oGCq7MgEgiz4
         8iH6FbcsZcaF+T7aR2gDy1eINHPazK9ajSVRIRzCw1XcU/UUSc1d5l7NohGCo5sTpBua
         3w0K2IY1PngGEWL0KA0hS6wJMRKE9Al6RTGqZ73v82I+VpuSANCJ5CezflMQE63s4prK
         IeTdY8TKPfne6/8zLIeY3pA8aQopeanhksCix4knC2F7tTHbh+c/16e30vrHaXTbLARs
         37OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gsZVfuoX2X6vkK0f8knEjN8r22iclX6zTitF4Gg7914=;
        b=cT90TqXduyelF60JlUIlD/tXS65jq8mL/7TO2TJaQWwygB8bluop5svShC4hGOKLrY
         QZKLm0d8E0g39hc+InW4MNQCNOoYVeoX1pc4hwac8gSCnZgiK7II4Y0vXLdDKf4346l0
         cO7tYrozi+2BLwmTnwCH+tx++AxZWTNavXmoHySjuf6xc0LIeAFhZC1FJMtEtnsfyITG
         L2Rra8KJF65CFxkgZ5gOCq4HF97jM8c8MNe5rxEOKNW8LeH6b8HCeaBQBocakPBh2BQh
         stvAoDplGbEy5e/Otc+PfsxRspEdc54pn57jPWfeIq4bLYDtd8fcQ+u21HATuMkfK2S+
         j2Ow==
X-Gm-Message-State: APjAAAXals0NMyrSjiFCuv+PPKGFUHx0b/IpWO40NOC49hxJMZ3oHJHN
        GKLsDHQo+EcbinSWiaQuTfevxY3y6mNnjKPCKDM5ueTvj27zfn3pQzTkavj7ME3sC3tA1M6swEH
        HWnDpriPyOwdiuUhe8dkZrhm276US1mC12wknDoSOCihyjDcy+5Otnw==
X-Google-Smtp-Source: APXvYqxBo/hUZg4iTG8z2ER2JUQjeYCduro3bmwMCqELOH4UwCzNqh6ADqBQmk7m8xmKh/yD/c9hUcQ=
X-Received: by 2002:ac8:1671:: with SMTP id x46mr54412495qtk.240.1558558440381;
 Wed, 22 May 2019 13:54:00 -0700 (PDT)
Date:   Wed, 22 May 2019 13:53:52 -0700
In-Reply-To: <20190522205353.140648-1-sdf@google.com>
Message-Id: <20190522205353.140648-3-sdf@google.com>
Mime-Version: 1.0
References: <20190522205353.140648-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf-next v2 3/4] bpf: cgroup: properly use bpf_prog_array api
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

v2:
* replace xchg with rcu_swap_protected

Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  2 +-
 kernel/bpf/cgroup.c        | 30 +++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index cb3c6b3b89c8..94a7bca3a6c4 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -71,7 +71,7 @@ struct cgroup_bpf {
 	u32 flags[MAX_BPF_ATTACH_TYPE];
 
 	/* temp storage for effective prog array used by prog_attach/detach */
-	struct bpf_prog_array __rcu *inactive;
+	struct bpf_prog_array *inactive;
 };
 
 void cgroup_bpf_put(struct cgroup *cgrp);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index fcde0f7b2585..67525683e982 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -22,6 +22,12 @@
 DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
+#define cgroup_rcu_dereference(p)					\
+	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex))
+
+#define cgroup_rcu_swap(rcu_ptr, ptr)					\
+	rcu_swap_protected(rcu_ptr, ptr, lockdep_is_held(&cgroup_mutex))
+
 /**
  * cgroup_bpf_put() - put references of all bpf programs
  * @cgrp: the cgroup to modify
@@ -29,6 +35,7 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 void cgroup_bpf_put(struct cgroup *cgrp)
 {
 	enum bpf_cgroup_storage_type stype;
+	struct bpf_prog_array *old_array;
 	unsigned int type;
 
 	for (type = 0; type < ARRAY_SIZE(cgrp->bpf.progs); type++) {
@@ -45,7 +52,8 @@ void cgroup_bpf_put(struct cgroup *cgrp)
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key);
 		}
-		bpf_prog_array_free(cgrp->bpf.effective[type]);
+		old_array = cgroup_rcu_dereference(cgrp->bpf.effective[type]);
+		bpf_prog_array_free(old_array);
 	}
 }
 
@@ -101,7 +109,7 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
  */
 static int compute_effective_progs(struct cgroup *cgrp,
 				   enum bpf_attach_type type,
-				   struct bpf_prog_array __rcu **array)
+				   struct bpf_prog_array **array)
 {
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *progs;
@@ -139,17 +147,15 @@ static int compute_effective_progs(struct cgroup *cgrp,
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
@@ -166,7 +172,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  * that array below is variable length
  */
 #define	NR ARRAY_SIZE(cgrp->bpf.effective)
-	struct bpf_prog_array __rcu *arrays[NR] = {};
+	struct bpf_prog_array *arrays[NR] = {};
 	int i;
 
 	for (i = 0; i < NR; i++)
@@ -444,10 +450,13 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	enum bpf_attach_type type = attr->query.attach_type;
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	u32 flags = cgrp->bpf.flags[type];
+	struct bpf_prog_array *effective;
 	int cnt, ret = 0, i;
 
+	effective = cgroup_rcu_dereference(cgrp->bpf.effective[type]);
+
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(cgrp->bpf.effective[type]);
+		cnt = bpf_prog_array_length(effective);
 	else
 		cnt = prog_list_length(progs);
 
@@ -464,8 +473,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	}
 
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
-		return bpf_prog_array_copy_to_user(cgrp->bpf.effective[type],
-						   prog_ids, cnt);
+		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
 	} else {
 		struct bpf_prog_list *pl;
 		u32 id;
-- 
2.21.0.1020.gf2820cf01a-goog

