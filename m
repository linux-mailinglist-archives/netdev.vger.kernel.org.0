Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466ADEDABB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKDIpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:45:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39656 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfKDIpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 03:45:45 -0500
Received: by mail-pg1-f193.google.com with SMTP id p12so10819481pgn.6;
        Mon, 04 Nov 2019 00:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Syph87H+PWR18QYjllmdxGhZuk8s0DtHjperla50PXo=;
        b=hro9ymQE+781KFysTfrK7uAaugf0CRUXCbjhZ6kOVCCI1t8RJ2kd16cLofrbmUQRiH
         OG9PEzG1rVhss7LkrtV8RF1FttqA9vV2D5NbtP4U2DnKowz9HUznHdNZ6AHn+BNhb33s
         1nm5n17UrYuLMflxIwjMgUAMd2wI7tPG/6rlG7upozPjQ27DpziiUt4ykZqWB2ODOE3T
         StVr/zXP1xNTZ9nWZBWTQwAoWG2zxZGm4ge8HpDoqDpdqBWvjmGCo+mc9FDNY2YOJz0Z
         C0JE+hA1YaTJp/Re2WTwN0LMVMY7MXGcgsuJ5bGC7EvccS66beFfjZXrBRJB2ozBgMMC
         TIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Syph87H+PWR18QYjllmdxGhZuk8s0DtHjperla50PXo=;
        b=gAHJ8p7itLoFFaEnDA1kOEzfJ7qVGVbEbtiR13T5+T9Lpbs1DWP6/V7nw+WbVeiHlG
         X1JGmmdVbQNuH4mVMrIznR6xuq/4sJi9IrbQDBXqRVYGLkTKmbvvlPTpSF/AuwM2uW+f
         X/rH4/wW74cOZAKEkqeY9Uu8jylhqUxCl/OQpFo1FOGbEW5ynrBxb1Bwg4e0TlOw/OHd
         FpmBbPb1FA2qkkfUvIklmM1Yz4DQk7Kg2hGr6ffGhaft8b+gVeeCxqG/DvbKM/2uSUpo
         yfgvoY2H40uWb8eybqGZiQXCfNVssAjqqQONZ4ATNMjhNZtebiFzT7pZqQeyPX5CzXcP
         hdIg==
X-Gm-Message-State: APjAAAVvpYPGGsC5JM/y5p2253OEzUr3KV6XUIiWA1U96XH7n3ah+KSE
        vI92D6ayFHwN6EeVO4OYS34=
X-Google-Smtp-Source: APXvYqyNsV1FXbgXfpfA9cGfySs4wPL0F0cMfN3V/f04b3npnDTbXwv8gxcn/u+sIkKOyeT+GXYFfw==
X-Received: by 2002:a62:305:: with SMTP id 5mr28634070pfd.67.1572857143863;
        Mon, 04 Nov 2019 00:45:43 -0800 (PST)
Received: from gaurie.seo.corp.google.com ([2401:fa00:d:0:1034:ec6b:8056:9e93])
        by smtp.gmail.com with ESMTPSA id z16sm17010221pge.55.2019.11.04.00.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 00:45:43 -0800 (PST)
From:   Namhyung Kim <namhyung@kernel.org>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Li Zefan <lizefan@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Song Liu <liu.song.a23@gmail.com>, cgroups@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] cgroup: Use 64bit id from kernfs
Date:   Mon,  4 Nov 2019 17:45:20 +0900
Message-Id: <20191104084520.398584-3-namhyung@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191104084520.398584-1-namhyung@kernel.org>
References: <20191104084520.398584-1-namhyung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

Use 64 bit id allocated by kernfs instead of using its own idr since
it seems not used for saving any information no more.  So let's get
rid of the cgroup_idr from cgroup_root.

The index of netprio_map is also changed to u64.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
[namhyung: split cgroup changes and fix netprio_map access]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/cgroup-defs.h  | 18 +++--------
 include/net/netprio_cgroup.h |  8 ++---
 kernel/cgroup/cgroup.c       | 63 +++++++++++-------------------------
 net/core/netprio_cgroup.c    |  4 +--
 4 files changed, 29 insertions(+), 64 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 430e219e3aba..3811b3405ddc 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -354,15 +354,8 @@ struct cgroup {
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	/*
-	 * idr allocated in-hierarchy ID.
-	 *
-	 * ID 0 is not used, the ID of the root cgroup is always 1, and a
-	 * new cgroup will be assigned with a smallest available ID.
-	 *
-	 * Allocating/Removing ID must be protected by cgroup_mutex.
-	 */
-	int id;
+	/* in-hierarchy ID allocated from kernfs */
+	u64 id;
 
 	/*
 	 * The depth this cgroup is at.  The root is at depth zero and each
@@ -488,7 +481,7 @@ struct cgroup {
 	struct cgroup_freezer_state freezer;
 
 	/* ids of the ancestors at each level including self */
-	int ancestor_ids[];
+	u64 ancestor_ids[];
 };
 
 /*
@@ -509,7 +502,7 @@ struct cgroup_root {
 	struct cgroup cgrp;
 
 	/* for cgrp->ancestor_ids[0] */
-	int cgrp_ancestor_id_storage;
+	u64 cgrp_ancestor_id_storage;
 
 	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
 	atomic_t nr_cgrps;
@@ -520,9 +513,6 @@ struct cgroup_root {
 	/* Hierarchy-specific flags */
 	unsigned int flags;
 
-	/* IDs for cgroups in this hierarchy */
-	struct idr cgroup_idr;
-
 	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
 
diff --git a/include/net/netprio_cgroup.h b/include/net/netprio_cgroup.h
index cfc9441ef074..cd7c17cf73c7 100644
--- a/include/net/netprio_cgroup.h
+++ b/include/net/netprio_cgroup.h
@@ -15,14 +15,14 @@
 #if IS_ENABLED(CONFIG_CGROUP_NET_PRIO)
 struct netprio_map {
 	struct rcu_head rcu;
-	u32 priomap_len;
+	u64 priomap_len;
 	u32 priomap[];
 };
 
-static inline u32 task_netprioidx(struct task_struct *p)
+static inline u64 task_netprioidx(struct task_struct *p)
 {
 	struct cgroup_subsys_state *css;
-	u32 idx;
+	u64 idx;
 
 	rcu_read_lock();
 	css = task_css(p, net_prio_cgrp_id);
@@ -41,7 +41,7 @@ static inline void sock_update_netprioidx(struct sock_cgroup_data *skcd)
 
 #else /* !CONFIG_CGROUP_NET_PRIO */
 
-static inline u32 task_netprioidx(struct task_struct *p)
+static inline u64 task_netprioidx(struct task_struct *p)
 {
 	return 0;
 }
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b5dcbee5aa6c..4dc0f86bb4c5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1308,10 +1308,7 @@ static void cgroup_exit_root_id(struct cgroup_root *root)
 
 void cgroup_free_root(struct cgroup_root *root)
 {
-	if (root) {
-		idr_destroy(&root->cgroup_idr);
-		kfree(root);
-	}
+	kfree(root);
 }
 
 static void cgroup_destroy_root(struct cgroup_root *root)
@@ -1917,7 +1914,6 @@ void init_cgroup_root(struct cgroup_fs_context *ctx)
 	atomic_set(&root->nr_cgrps, 1);
 	cgrp->root = root;
 	init_cgroup_housekeeping(cgrp);
-	idr_init(&root->cgroup_idr);
 
 	root->flags = ctx->flags;
 	if (ctx->release_agent)
@@ -1938,12 +1934,6 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_KERNEL);
-	if (ret < 0)
-		goto out;
-	root_cgrp->id = ret;
-	root_cgrp->ancestor_ids[0] = ret;
-
 	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release,
 			      0, GFP_KERNEL);
 	if (ret)
@@ -1976,6 +1966,8 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 		goto exit_root_id;
 	}
 	root_cgrp->kn = root->kf_root->kn;
+	root_cgrp->id = root_cgrp->kn->id;
+	root_cgrp->ancestor_ids[0] = root_cgrp->id;
 
 	ret = css_populate_dir(&root_cgrp->self);
 	if (ret)
@@ -4987,9 +4979,6 @@ static void css_release_work_fn(struct work_struct *work)
 			tcgrp->nr_dying_descendants--;
 		spin_unlock_irq(&css_set_lock);
 
-		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
-		cgrp->id = -1;
-
 		/*
 		 * There are two control paths which try to determine
 		 * cgroup from dentry without going through kernfs -
@@ -5154,10 +5143,12 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
  * it isn't associated with its kernfs_node and doesn't have the control
  * mask applied.
  */
-static struct cgroup *cgroup_create(struct cgroup *parent)
+static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
+				    umode_t mode)
 {
 	struct cgroup_root *root = parent->root;
 	struct cgroup *cgrp, *tcgrp;
+	struct kernfs_node *kn;
 	int level = parent->level + 1;
 	int ret;
 
@@ -5177,15 +5168,14 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 			goto out_cancel_ref;
 	}
 
-	/*
-	 * Temporarily set the pointer to NULL, so idr_find() won't return
-	 * a half-baked cgroup.
-	 */
-	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
-	if (cgrp->id < 0) {
-		ret = -ENOMEM;
+	/* create the directory */
+	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
+	if (IS_ERR(kn)) {
+		ret = PTR_ERR(kn);
 		goto out_stat_exit;
 	}
+	cgrp->kn = kn;
+	cgrp->id = kn->id;
 
 	init_cgroup_housekeeping(cgrp);
 
@@ -5195,7 +5185,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 
 	ret = psi_cgroup_alloc(cgrp);
 	if (ret)
-		goto out_idr_free;
+		goto out_kernfs_remove;
 
 	ret = cgroup_bpf_inherit(cgrp);
 	if (ret)
@@ -5248,12 +5238,6 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	atomic_inc(&root->nr_cgrps);
 	cgroup_get_live(parent);
 
-	/*
-	 * @cgrp is now fully operational.  If something fails after this
-	 * point, it'll be released via the normal destruction path.
-	 */
-	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
-
 	/*
 	 * On the default hierarchy, a child doesn't automatically inherit
 	 * subtree_control from the parent.  Each is configured manually.
@@ -5267,8 +5251,8 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 
 out_psi_free:
 	psi_cgroup_free(cgrp);
-out_idr_free:
-	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
+out_kernfs_remove:
+	kernfs_remove(cgrp->kn);
 out_stat_exit:
 	if (cgroup_on_dfl(parent))
 		cgroup_rstat_exit(cgrp);
@@ -5305,7 +5289,6 @@ static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
 int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 {
 	struct cgroup *parent, *cgrp;
-	struct kernfs_node *kn;
 	int ret;
 
 	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
@@ -5321,27 +5304,19 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 		goto out_unlock;
 	}
 
-	cgrp = cgroup_create(parent);
+	cgrp = cgroup_create(parent, name, mode);
 	if (IS_ERR(cgrp)) {
 		ret = PTR_ERR(cgrp);
 		goto out_unlock;
 	}
 
-	/* create the directory */
-	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
-	if (IS_ERR(kn)) {
-		ret = PTR_ERR(kn);
-		goto out_destroy;
-	}
-	cgrp->kn = kn;
-
 	/*
 	 * This extra ref will be put in cgroup_free_fn() and guarantees
 	 * that @cgrp->kn is always accessible.
 	 */
-	kernfs_get(kn);
+	kernfs_get(cgrp->kn);
 
-	ret = cgroup_kn_set_ugid(kn);
+	ret = cgroup_kn_set_ugid(cgrp->kn);
 	if (ret)
 		goto out_destroy;
 
@@ -5356,7 +5331,7 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 	TRACE_CGROUP_PATH(mkdir, cgrp);
 
 	/* let's create and online css's */
-	kernfs_activate(kn);
+	kernfs_activate(cgrp->kn);
 
 	ret = 0;
 	goto out_unlock;
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 256b7954b720..326d2d6b86e0 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -93,7 +93,7 @@ static int extend_netdev_table(struct net_device *dev, u32 target_idx)
 static u32 netprio_prio(struct cgroup_subsys_state *css, struct net_device *dev)
 {
 	struct netprio_map *map = rcu_dereference_rtnl(dev->priomap);
-	int id = css->cgroup->id;
+	u64 id = css->cgroup->id;
 
 	if (map && id < map->priomap_len)
 		return map->priomap[id];
@@ -113,7 +113,7 @@ static int netprio_set_prio(struct cgroup_subsys_state *css,
 			    struct net_device *dev, u32 prio)
 {
 	struct netprio_map *map;
-	int id = css->cgroup->id;
+	u64 id = css->cgroup->id;
 	int ret;
 
 	/* avoid extending priomap for zero writes */
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

