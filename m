Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CFF17EFC
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfEHRS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:18:57 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:52035 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbfEHRS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:18:56 -0400
Received: by mail-pg1-f202.google.com with SMTP id 63so13046908pga.18
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 10:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=74cU3TEY3NZS3RPv5+orUOI/SPoOJAznACo1y6F/NDw=;
        b=hwvwjjRPOZrrfGNXRMOer5WLDSi7Y31SUnrZrATb0qUDouxcLan1DCSuDi3qUjUzH6
         3WV0/MMdatcSUiAVrs13UjXPL6+DFPNQ+WcSsDIAdNaCIk46vEcjFGYuVNIj9m2GlJVU
         9CTjMRfAWED5I9vTjp/Nd/1NVzWIuFE1rmr9//6meu+OHNOHjzdyN7B4AfoCgF1BbUOM
         U8U3WN3ORG0Ci2vISxdz0ZftbOBNmjDgwQDmzGosjEcpo5kv1X5qkA04CJ6oC4Cpwpa9
         zsm56D0Ookgf8CwgnnlSz4grIZ3A1ZGJZ4mQcjLjh5/IbyLe5uoRu/vsKLOPK5fQTxkT
         13qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=74cU3TEY3NZS3RPv5+orUOI/SPoOJAznACo1y6F/NDw=;
        b=qqBE4WAglGEF4sAtgPklst5UZyYvXOyP62kQ5JEZkP0BVh5IJkz2UtF6aKxdd02Vp1
         EDMiOGuoVvoff22D5SC0+ztDun5BAg4v+qoSWIzJ68lrYc2S7eqTXd6j7D057nNNNMmB
         3R/BKihxdtW0ziG6uIa4VHoBOumqgRzGu/dbRMLOyiDqLnJ/ifqPBaW+eqFAAIOqWTDs
         b/eTp4FfuSTKZInBj2ZRd7sGJTmfosyLknhopOJsZ+hafYQbJbnRNuLNy/jsDWZOKmVO
         UZowsQTIwD7Pa0+Cwz2KVdvdmoI8lm4gSR3RqcztMpbZme6ZPSTlFPcbDI+j05H3eCwZ
         Vbdg==
X-Gm-Message-State: APjAAAXGbKrwEYFHQZFok8ZmHcmqcP79FIFuK8pGgjdM2yLt6FF2wgpi
        agrIEKR964fRTLv6ruy5T3nJV4xVfR5PtCwOnv2gZqTASsZTp7aRrOpDXCaisU9gyP6VQFk2l4x
        jlUiEDFaUxvihMljQuGkbZxoOwriobjinwqaCiE/ZmYPT69aijvEaKw==
X-Google-Smtp-Source: APXvYqwmRD762PKVo674Po7dw8yw8DkjXrl2ffkrOz3cS/0rd9MGQlICco2ivsWVFmV77sSOay+zvyk=
X-Received: by 2002:a63:931c:: with SMTP id b28mr17083813pge.182.1557335935040;
 Wed, 08 May 2019 10:18:55 -0700 (PDT)
Date:   Wed,  8 May 2019 10:18:44 -0700
In-Reply-To: <20190508171845.201303-1-sdf@google.com>
Message-Id: <20190508171845.201303-4-sdf@google.com>
Mime-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf 3/4] bpf: cgroup: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  2 +-
 kernel/bpf/cgroup.c        | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a4c644c1c091..5e515b72ff55 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -69,7 +69,7 @@ struct cgroup_bpf {
 	u32 flags[MAX_BPF_ATTACH_TYPE];
 
 	/* temp storage for effective prog array used by prog_attach/detach */
-	struct bpf_prog_array __rcu *inactive;
+	struct bpf_prog_array *inactive;
 };
 
 void cgroup_bpf_put(struct cgroup *cgrp);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 4e807973aa80..d59826add5ef 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -19,6 +19,9 @@
 DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
+#define cgroup_dereference(p)						\
+	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex))
+
 /**
  * cgroup_bpf_put() - put references of all bpf programs
  * @cgrp: the cgroup to modify
@@ -26,6 +29,7 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 void cgroup_bpf_put(struct cgroup *cgrp)
 {
 	enum bpf_cgroup_storage_type stype;
+	struct bpf_prog_array *old_array;
 	unsigned int type;
 
 	for (type = 0; type < ARRAY_SIZE(cgrp->bpf.progs); type++) {
@@ -42,7 +46,8 @@ void cgroup_bpf_put(struct cgroup *cgrp)
 			kfree(pl);
 			static_branch_dec(&cgroup_bpf_enabled_key);
 		}
-		bpf_prog_array_free(cgrp->bpf.effective[type]);
+		old_array = cgroup_dereference(cgrp->bpf.effective[type]);
+		bpf_prog_array_free(old_array);
 	}
 }
 
@@ -98,7 +103,7 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
  */
 static int compute_effective_progs(struct cgroup *cgrp,
 				   enum bpf_attach_type type,
-				   struct bpf_prog_array __rcu **array)
+				   struct bpf_prog_array **array)
 {
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *progs;
@@ -136,17 +141,17 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		}
 	} while ((p = cgroup_parent(p)));
 
-	rcu_assign_pointer(*array, progs);
+	*array = progs;
 	return 0;
 }
 
 static void activate_effective_progs(struct cgroup *cgrp,
 				     enum bpf_attach_type type,
-				     struct bpf_prog_array __rcu *array)
+				     struct bpf_prog_array *array)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 
-	old_array = xchg(&cgrp->bpf.effective[type], array);
+	old_array = xchg((__force struct bpf_prog_array **)&cgrp->bpf.effective[type], array);
 	/* free prog array after grace period, since __cgroup_bpf_run_*()
 	 * might be still walking the array
 	 */
@@ -163,7 +168,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  * that array below is variable length
  */
 #define	NR ARRAY_SIZE(cgrp->bpf.effective)
-	struct bpf_prog_array __rcu *arrays[NR] = {};
+	struct bpf_prog_array *arrays[NR] = {};
 	int i;
 
 	for (i = 0; i < NR; i++)
@@ -441,10 +446,13 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	enum bpf_attach_type type = attr->query.attach_type;
 	struct list_head *progs = &cgrp->bpf.progs[type];
 	u32 flags = cgrp->bpf.flags[type];
+	struct bpf_prog_array *effective;
 	int cnt, ret = 0, i;
 
+	effective = cgroup_dereference(cgrp->bpf.effective[type]);
+
 	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
-		cnt = bpf_prog_array_length(cgrp->bpf.effective[type]);
+		cnt = bpf_prog_array_length(effective);
 	else
 		cnt = prog_list_length(progs);
 
@@ -461,8 +469,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
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

