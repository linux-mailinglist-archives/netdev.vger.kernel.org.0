Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E80EDAB9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKDIpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:45:42 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46248 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfKDIpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 03:45:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so10799641pgn.13;
        Mon, 04 Nov 2019 00:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/VyC0WX4EQRrqY3rs1bxUzrBqAg0fFyscTDNZ4bTdM=;
        b=GSr40XtrCs+NEMRILN+QoqvmsBm/m94WRGgAh2zyDplzvgHT9W8Jwdwp/GJQwuDFqj
         hVHkYByfdgVMMj52J/Cy3+x3YSAYRyyV8z9rsYV0YB0eIohpQVQm8PVL6fNq0v/jU9FK
         FJrZDyfn94t/Rf0an4J2qH+pm32DG32WwSYg+Yg3zUjQ/4CZOP1L0UKYTNq9eQsd/mp0
         0ilg9T6ZU4zPlbyAD7y+lEFZqfjKJM1vgJOt7U0/jcO+t7OkkzsFatPX9SregRypgdma
         7Xy8I+vPkZGoYEm5p0xYq1PmV82lusbjm292Gxp78tBmM9TgYRc2Y161xKLFOBPRDe8x
         XkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Z/VyC0WX4EQRrqY3rs1bxUzrBqAg0fFyscTDNZ4bTdM=;
        b=hkQ8xLNsF05Lq3IpaCQDAdRr6v4DBviawqkiNUB1vbfJkbQzRSVxHWawQRNB8SCSP1
         uJIy4sdMsbXDbS44zcV1jvNh+3R45M4S1G4GexnRcDHEs8vCD7sTpSrBstDaD8OJ1R8g
         DEeOVJ49seUHOZbCkHwvJnP4XeSSRjL5xeG58wtTpy8T0zqBYsnVDabY9fgByUnLwEM3
         YVkuzKoURE85O5MT5eiBX9dvPeolIKBqJaJGoUCClNchrqUFQqDaS4PXXtm+tbwJ693y
         uBhpss3SBqL+uKj26r9HLbU94O1Pf8iJJQHpR3NureGZJbr91aeqRWzZPgfG8CF6PEG2
         /W2w==
X-Gm-Message-State: APjAAAXF5dRQluzZdi4UPkz6aBC8whbzJaOoMKm3MunGdumX4bZQTats
        OHIcv8CtmmQV2GFaylp5+ks=
X-Google-Smtp-Source: APXvYqw5TYy4C5MUVgssQDzn0iM2Gpvn/YBMPoKpypI2yTWmHJiymH2ontFr0BcELyrKVH8mh1S2Hw==
X-Received: by 2002:aa7:9533:: with SMTP id c19mr28662369pfp.77.1572857140395;
        Mon, 04 Nov 2019 00:45:40 -0800 (PST)
Received: from gaurie.seo.corp.google.com ([2401:fa00:d:0:1034:ec6b:8056:9e93])
        by smtp.gmail.com with ESMTPSA id z16sm17010221pge.55.2019.11.04.00.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 00:45:39 -0800 (PST)
From:   Namhyung Kim <namhyung@kernel.org>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Li Zefan <lizefan@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Song Liu <liu.song.a23@gmail.com>, cgroups@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-block@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] kernfs: Convert to u64 id
Date:   Mon,  4 Nov 2019 17:45:19 +0900
Message-Id: <20191104084520.398584-2-namhyung@kernel.org>
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

The kernfs_id was an union type sharing a 64bit id with 32bit ino +
gen.  But it resulted in using 32bit inode even on 64bit systems.
Also dealing with an union is annoying especially if you just want to
use a single id.

Thus let's get rid of the kernfs_node_id type and use u64 directly.
The upper 32bit is used for gen and lower is for ino on 32bit systems.
The kernfs_id_ino() and kernfs_id_gen() helpers will take care of the
bit handling depends on the system word size.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-block@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
[namhyung: fix build error in bpf_get_current_cgroup_id()]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/kernfs/dir.c                  | 36 ++++++++-----
 fs/kernfs/file.c                 |  4 +-
 fs/kernfs/inode.c                |  4 +-
 fs/kernfs/kernfs-internal.h      |  2 -
 fs/kernfs/mount.c                | 92 +++++++++++++++++++-------------
 include/linux/cgroup.h           | 17 +++---
 include/linux/exportfs.h         |  5 ++
 include/linux/kernfs.h           | 47 +++++++++-------
 include/trace/events/writeback.h | 92 ++++++++++++++++----------------
 kernel/bpf/helpers.c             |  2 +-
 kernel/cgroup/cgroup.c           |  5 +-
 kernel/trace/blktrace.c          | 66 +++++++++++------------
 net/core/filter.c                |  4 +-
 13 files changed, 207 insertions(+), 169 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6ebae6bbe6a5..2beec2af809b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -509,7 +509,7 @@ void kernfs_put(struct kernfs_node *kn)
 	struct kernfs_root *root;
 
 	/*
-	 * kernfs_node is freed with ->count 0, kernfs_find_and_get_node_by_ino
+	 * kernfs_node is freed with ->count 0, kernfs_find_and_get_node_by_id
 	 * depends on this to filter reused stale node
 	 */
 	if (!kn || !atomic_dec_and_test(&kn->count))
@@ -536,7 +536,7 @@ void kernfs_put(struct kernfs_node *kn)
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
 	}
 	spin_lock(&kernfs_idr_lock);
-	idr_remove(&root->ino_idr, kn->id.ino);
+	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
 	spin_unlock(&kernfs_idr_lock);
 	kmem_cache_free(kernfs_node_cache, kn);
 
@@ -644,12 +644,12 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	idr_preload_end();
 	if (ret < 0)
 		goto err_out2;
-	kn->id.ino = ret;
-	kn->id.generation = gen;
+
+	kn->id = (u64)gen << 32 | ret;
 
 	/*
 	 * set ino first. This RELEASE is paired with atomic_inc_not_zero in
-	 * kernfs_find_and_get_node_by_ino
+	 * kernfs_find_and_get_node_by_id
 	 */
 	atomic_set_release(&kn->count, 1);
 	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
@@ -680,7 +680,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	return kn;
 
  err_out3:
-	idr_remove(&root->ino_idr, kn->id.ino);
+	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
@@ -705,20 +705,25 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 }
 
 /*
- * kernfs_find_and_get_node_by_ino - get kernfs_node from inode number
+ * kernfs_find_and_get_node_by_id - get kernfs_node from node id
  * @root: the kernfs root
- * @ino: inode number
+ * @id: the target node id
+ *
+ * @id's lower 32bits encode ino and upper gen.  If the gen portion is
+ * zero, all generations are matched.
  *
  * RETURNS:
  * NULL on failure. Return a kernfs node with reference counter incremented
  */
-struct kernfs_node *kernfs_find_and_get_node_by_ino(struct kernfs_root *root,
-						    unsigned int ino)
+struct kernfs_node *kernfs_find_and_get_node_by_id(struct kernfs_root *root,
+						   u64 id)
 {
 	struct kernfs_node *kn;
+	ino_t ino = kernfs_id_ino(id);
+	u32 gen = kernfs_id_gen(id);
 
 	rcu_read_lock();
-	kn = idr_find(&root->ino_idr, ino);
+	kn = idr_find(&root->ino_idr, (u32)ino);
 	if (!kn)
 		goto out;
 
@@ -741,8 +746,13 @@ struct kernfs_node *kernfs_find_and_get_node_by_ino(struct kernfs_root *root,
 	 * before 'count'. So if 'count' is uptodate, 'ino' should be uptodate,
 	 * hence we can use 'ino' to filter stale node.
 	 */
-	if (kn->id.ino != ino)
+	if (kernfs_ino(kn) != ino)
 		goto out;
+
+	/* if upper 32bit of @id was zero, ignore gen */
+	if (gen && kernfs_gen(kn) != gen)
+		goto out;
+
 	rcu_read_unlock();
 
 	return kn;
@@ -1678,7 +1688,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 		const char *name = pos->name;
 		unsigned int type = dt_type(pos);
 		int len = strlen(name);
-		ino_t ino = pos->id.ino;
+		ino_t ino = kernfs_ino(pos);
 
 		ctx->pos = pos->hash;
 		file->private_data = pos;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index e8c792b49616..34366db3620d 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -892,7 +892,7 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		 * have the matching @file available.  Look up the inodes
 		 * and generate the events manually.
 		 */
-		inode = ilookup(info->sb, kn->id.ino);
+		inode = ilookup(info->sb, kernfs_ino(kn));
 		if (!inode)
 			continue;
 
@@ -901,7 +901,7 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		if (parent) {
 			struct inode *p_inode;
 
-			p_inode = ilookup(info->sb, parent->id.ino);
+			p_inode = ilookup(info->sb, kernfs_ino(parent));
 			if (p_inode) {
 				fsnotify(p_inode, FS_MODIFY | FS_EVENT_ON_CHILD,
 					 inode, FSNOTIFY_EVENT_INODE, &name, 0);
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index f3eaa8869f42..eac277c63d42 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -201,7 +201,7 @@ static void kernfs_init_inode(struct kernfs_node *kn, struct inode *inode)
 	inode->i_private = kn;
 	inode->i_mapping->a_ops = &kernfs_aops;
 	inode->i_op = &kernfs_iops;
-	inode->i_generation = kn->id.generation;
+	inode->i_generation = kernfs_gen(kn);
 
 	set_default_inode_attr(inode, kn->mode);
 	kernfs_refresh_inode(kn, inode);
@@ -247,7 +247,7 @@ struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sb, kn->id.ino);
+	inode = iget_locked(sb, kernfs_ino(kn));
 	if (inode && (inode->i_state & I_NEW))
 		kernfs_init_inode(kn, inode);
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 02ce570a9a3c..2f3c51d55261 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -109,8 +109,6 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 				    const char *name, umode_t mode,
 				    kuid_t uid, kgid_t gid,
 				    unsigned flags);
-struct kernfs_node *kernfs_find_and_get_node_by_ino(struct kernfs_root *root,
-						    unsigned int ino);
 
 /*
  * file.c
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 6c12fac2c287..1ac4f723c51d 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -53,63 +53,82 @@ const struct super_operations kernfs_sops = {
 	.show_path	= kernfs_sop_show_path,
 };
 
-/*
- * Similar to kernfs_fh_get_inode, this one gets kernfs node from inode
- * number and generation
- */
-struct kernfs_node *kernfs_get_node_by_id(struct kernfs_root *root,
-	const union kernfs_node_id *id)
+static int kernfs_encode_fh(struct inode *inode, __u32 *fh, int *max_len,
+			    struct inode *parent)
 {
-	struct kernfs_node *kn;
+	struct kernfs_node *kn = inode->i_private;
 
-	kn = kernfs_find_and_get_node_by_ino(root, id->ino);
-	if (!kn)
-		return NULL;
-	if (kn->id.generation != id->generation) {
-		kernfs_put(kn);
-		return NULL;
+	if (*max_len < 2) {
+		*max_len = 2;
+		return FILEID_INVALID;
 	}
-	return kn;
+
+	*max_len = 2;
+	*(u64 *)fh = kn->id;
+	return FILEID_KERNFS;
 }
 
-static struct inode *kernfs_fh_get_inode(struct super_block *sb,
-		u64 ino, u32 generation)
+static struct dentry *__kernfs_fh_to_dentry(struct super_block *sb,
+					    struct fid *fid, int fh_len,
+					    int fh_type, bool get_parent)
 {
 	struct kernfs_super_info *info = kernfs_info(sb);
-	struct inode *inode;
 	struct kernfs_node *kn;
+	struct inode *inode;
+	u64 id;
 
-	if (ino == 0)
-		return ERR_PTR(-ESTALE);
+	if (fh_len < 2)
+		return NULL;
 
-	kn = kernfs_find_and_get_node_by_ino(info->root, ino);
+	/*
+	 * We used to use the generic types and blktrace exposes the
+	 * numbers without specifying the type.  Accept the generic types
+	 * for compatibility.
+	 */
+	switch (fh_type) {
+	case FILEID_KERNFS:
+		id = *(u64 *)fid;
+		break;
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		id = ((u64)fid->i32.gen << 32) | fid->i32.ino;
+		break;
+	default:
+		return NULL;
+	}
+
+	kn = kernfs_find_and_get_node_by_id(info->root, id);
 	if (!kn)
 		return ERR_PTR(-ESTALE);
+
+	if (get_parent) {
+		struct kernfs_node *parent;
+
+		parent = kernfs_get_parent(kn);
+		kernfs_put(kn);
+		kn = parent;
+	}
+
 	inode = kernfs_get_inode(sb, kn);
 	kernfs_put(kn);
 	if (!inode)
 		return ERR_PTR(-ESTALE);
 
-	if (generation && inode->i_generation != generation) {
-		/* we didn't find the right inode.. */
-		iput(inode);
-		return ERR_PTR(-ESTALE);
-	}
-	return inode;
+	return d_obtain_alias(inode);
 }
 
-static struct dentry *kernfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+static struct dentry *kernfs_fh_to_dentry(struct super_block *sb,
+					  struct fid *fid, int fh_len,
+					  int fh_type)
 {
-	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
-				    kernfs_fh_get_inode);
+	return __kernfs_fh_to_dentry(sb, fid, fh_len, fh_type, false);
 }
 
-static struct dentry *kernfs_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+static struct dentry *kernfs_fh_to_parent(struct super_block *sb,
+					  struct fid *fid, int fh_len,
+					  int fh_type)
 {
-	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
-				    kernfs_fh_get_inode);
+	return __kernfs_fh_to_dentry(sb, fid, fh_len, fh_type, true);
 }
 
 static struct dentry *kernfs_get_parent_dentry(struct dentry *child)
@@ -120,6 +139,7 @@ static struct dentry *kernfs_get_parent_dentry(struct dentry *child)
 }
 
 static const struct export_operations kernfs_export_ops = {
+	.encode_fh	= kernfs_encode_fh,
 	.fh_to_dentry	= kernfs_fh_to_dentry,
 	.fh_to_parent	= kernfs_fh_to_parent,
 	.get_parent	= kernfs_get_parent_dentry,
@@ -365,9 +385,9 @@ void __init kernfs_init(void)
 {
 
 	/*
-	 * the slab is freed in RCU context, so kernfs_find_and_get_node_by_ino
+	 * the slab is freed in RCU context, so kernfs_find_and_get_node_by_id
 	 * can access the slab lock free. This could introduce stale nodes,
-	 * please see how kernfs_find_and_get_node_by_ino filters out stale
+	 * please see how kernfs_find_and_get_node_by_id filters out stale
 	 * nodes.
 	 */
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f6b048902d6c..4b08a354039c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -616,7 +616,7 @@ static inline bool cgroup_is_populated(struct cgroup *cgrp)
 /* returns ino associated with a cgroup */
 static inline ino_t cgroup_ino(struct cgroup *cgrp)
 {
-	return cgrp->kn->id.ino;
+	return kernfs_ino(cgrp->kn);
 }
 
 /* cft/css accessors for cftype->write() operation */
@@ -687,13 +687,12 @@ static inline void cgroup_kthread_ready(void)
 	current->no_cgroup_migration = 0;
 }
 
-static inline union kernfs_node_id *cgroup_get_kernfs_id(struct cgroup *cgrp)
+static inline u64 cgroup_get_kernfs_id(struct cgroup *cgrp)
 {
-	return &cgrp->kn->id;
+	return cgrp->kn->id;
 }
 
-void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
-					char *buf, size_t buflen);
+void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
@@ -718,9 +717,9 @@ static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_init_kthreadd(void) {}
 static inline void cgroup_kthread_ready(void) {}
-static inline union kernfs_node_id *cgroup_get_kernfs_id(struct cgroup *cgrp)
+static inline u64 cgroup_get_kernfs_id(struct cgroup *cgrp)
 {
-	return NULL;
+	return 0;
 }
 
 static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
@@ -739,8 +738,8 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 	return true;
 }
 
-static inline void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
-	char *buf, size_t buflen) {}
+static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
+{}
 #endif /* !CONFIG_CGROUPS */
 
 #ifdef CONFIG_CGROUPS
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index cf6571fc9c01..d896b8657085 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -104,6 +104,11 @@ enum fid_type {
 	 */
 	FILEID_LUSTRE = 0x97,
 
+	/*
+	 * 64 bit unique kernfs id
+	 */
+	FILEID_KERNFS = 0xfe,
+
 	/*
 	 * Filesystems must not use 0xff file ID.
 	 */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 936b61bd504e..0edbc2b8865c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -104,21 +104,6 @@ struct kernfs_elem_attr {
 	struct kernfs_node	*notify_next;	/* for kernfs_notify() */
 };
 
-/* represent a kernfs node */
-union kernfs_node_id {
-	struct {
-		/*
-		 * blktrace will export this struct as a simplified 'struct
-		 * fid' (which is a big data struction), so userspace can use
-		 * it to find kernfs node. The layout must match the first two
-		 * fields of 'struct fid' exactly.
-		 */
-		u32		ino;
-		u32		generation;
-	};
-	u64			id;
-};
-
 /*
  * kernfs_node - the building block of kernfs hierarchy.  Each and every
  * kernfs node is represented by single kernfs_node.  Most fields are
@@ -155,7 +140,7 @@ struct kernfs_node {
 
 	void			*priv;
 
-	union kernfs_node_id	id;
+	u64			id;
 	unsigned short		flags;
 	umode_t			mode;
 	struct kernfs_iattrs	*iattr;
@@ -291,6 +276,32 @@ static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
 	return kn->flags & KERNFS_TYPE_MASK;
 }
 
+static inline ino_t kernfs_id_ino(u64 id)
+{
+	if (sizeof(ino_t) >= sizeof(u64))
+		return id;
+	else
+		return (u32)id;
+}
+
+static inline u32 kernfs_id_gen(u64 id)
+{
+	if (sizeof(ino_t) >= sizeof(u64))
+		return 0;
+	else
+		return id >> 32;
+}
+
+static inline ino_t kernfs_ino(struct kernfs_node *kn)
+{
+	return kernfs_id_ino(kn->id);
+}
+
+static inline ino_t kernfs_gen(struct kernfs_node *kn)
+{
+	return kernfs_id_gen(kn->id);
+}
+
 /**
  * kernfs_enable_ns - enable namespace under a directory
  * @kn: directory of interest, should be empty
@@ -382,8 +393,8 @@ void kernfs_kill_sb(struct super_block *sb);
 
 void kernfs_init(void);
 
-struct kernfs_node *kernfs_get_node_by_id(struct kernfs_root *root,
-	const union kernfs_node_id *id);
+struct kernfs_node *kernfs_find_and_get_node_by_id(struct kernfs_root *root,
+						   u64 id);
 #else	/* CONFIG_KERNFS */
 
 static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c2ce6480b4b1..3eef363932c9 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -61,7 +61,7 @@ DECLARE_EVENT_CLASS(writeback_page_template,
 
 	TP_STRUCT__entry (
 		__array(char, name, 32)
-		__field(unsigned long, ino)
+		__field(ino_t, ino)
 		__field(pgoff_t, index)
 	),
 
@@ -102,7 +102,7 @@ DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
 
 	TP_STRUCT__entry (
 		__array(char, name, 32)
-		__field(unsigned long, ino)
+		__field(ino_t, ino)
 		__field(unsigned long, state)
 		__field(unsigned long, flags)
 	),
@@ -150,28 +150,28 @@ DEFINE_EVENT(writeback_dirty_inode_template, writeback_dirty_inode,
 #ifdef CREATE_TRACE_POINTS
 #ifdef CONFIG_CGROUP_WRITEBACK
 
-static inline unsigned int __trace_wb_assign_cgroup(struct bdi_writeback *wb)
+static inline ino_t __trace_wb_assign_cgroup(struct bdi_writeback *wb)
 {
-	return wb->memcg_css->cgroup->kn->id.ino;
+	return cgroup_ino(wb->memcg_css->cgroup);
 }
 
-static inline unsigned int __trace_wbc_assign_cgroup(struct writeback_control *wbc)
+static inline ino_t __trace_wbc_assign_cgroup(struct writeback_control *wbc)
 {
 	if (wbc->wb)
 		return __trace_wb_assign_cgroup(wbc->wb);
 	else
-		return -1U;
+		return 0;
 }
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
-static inline unsigned int __trace_wb_assign_cgroup(struct bdi_writeback *wb)
+static inline ino_t __trace_wb_assign_cgroup(struct bdi_writeback *wb)
 {
-	return -1U;
+	return 0;
 }
 
-static inline unsigned int __trace_wbc_assign_cgroup(struct writeback_control *wbc)
+static inline ino_t __trace_wbc_assign_cgroup(struct writeback_control *wbc)
 {
-	return -1U;
+	return 0;
 }
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
@@ -187,8 +187,8 @@ TRACE_EVENT(inode_foreign_history,
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
-		__field(unsigned long,	ino)
-		__field(unsigned int,	cgroup_ino)
+		__field(ino_t,		ino)
+		__field(ino_t,		cgroup_ino)
 		__field(unsigned int,	history)
 	),
 
@@ -199,7 +199,7 @@ TRACE_EVENT(inode_foreign_history,
 		__entry->history	= history;
 	),
 
-	TP_printk("bdi %s: ino=%lu cgroup_ino=%u history=0x%x",
+	TP_printk("bdi %s: ino=%lu cgroup_ino=%lu history=0x%x",
 		__entry->name,
 		__entry->ino,
 		__entry->cgroup_ino,
@@ -216,9 +216,9 @@ TRACE_EVENT(inode_switch_wbs,
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
-		__field(unsigned long,	ino)
-		__field(unsigned int,	old_cgroup_ino)
-		__field(unsigned int,	new_cgroup_ino)
+		__field(ino_t,		ino)
+		__field(ino_t,		old_cgroup_ino)
+		__field(ino_t,		new_cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -228,7 +228,7 @@ TRACE_EVENT(inode_switch_wbs,
 		__entry->new_cgroup_ino	= __trace_wb_assign_cgroup(new_wb);
 	),
 
-	TP_printk("bdi %s: ino=%lu old_cgroup_ino=%u new_cgroup_ino=%u",
+	TP_printk("bdi %s: ino=%lu old_cgroup_ino=%lu new_cgroup_ino=%lu",
 		__entry->name,
 		__entry->ino,
 		__entry->old_cgroup_ino,
@@ -245,10 +245,10 @@ TRACE_EVENT(track_foreign_dirty,
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
 		__field(u64,		bdi_id)
-		__field(unsigned long,	ino)
+		__field(ino_t,		ino)
 		__field(unsigned int,	memcg_id)
-		__field(unsigned int,	cgroup_ino)
-		__field(unsigned int,	page_cgroup_ino)
+		__field(ino_t,		cgroup_ino)
+		__field(ino_t,		page_cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -260,10 +260,10 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
-		__entry->page_cgroup_ino = page->mem_cgroup->css.cgroup->kn->id.ino;
+		__entry->page_cgroup_ino = cgroup_ino(page->mem_cgroup->css.cgroup);
 	),
 
-	TP_printk("bdi %s[%llu]: ino=%lu memcg_id=%u cgroup_ino=%u page_cgroup_ino=%u",
+	TP_printk("bdi %s[%llu]: ino=%lu memcg_id=%u cgroup_ino=%lu page_cgroup_ino=%lu",
 		__entry->name,
 		__entry->bdi_id,
 		__entry->ino,
@@ -282,7 +282,7 @@ TRACE_EVENT(flush_foreign,
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
-		__field(unsigned int,	cgroup_ino)
+		__field(ino_t,		cgroup_ino)
 		__field(unsigned int,	frn_bdi_id)
 		__field(unsigned int,	frn_memcg_id)
 	),
@@ -294,7 +294,7 @@ TRACE_EVENT(flush_foreign,
 		__entry->frn_memcg_id	= frn_memcg_id;
 	),
 
-	TP_printk("bdi %s: cgroup_ino=%u frn_bdi_id=%u frn_memcg_id=%u",
+	TP_printk("bdi %s: cgroup_ino=%lu frn_bdi_id=%u frn_memcg_id=%u",
 		__entry->name,
 		__entry->cgroup_ino,
 		__entry->frn_bdi_id,
@@ -311,9 +311,9 @@ DECLARE_EVENT_CLASS(writeback_write_inode_template,
 
 	TP_STRUCT__entry (
 		__array(char, name, 32)
-		__field(unsigned long, ino)
+		__field(ino_t, ino)
 		__field(int, sync_mode)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -324,7 +324,7 @@ DECLARE_EVENT_CLASS(writeback_write_inode_template,
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
 	),
 
-	TP_printk("bdi %s: ino=%lu sync_mode=%d cgroup_ino=%u",
+	TP_printk("bdi %s: ino=%lu sync_mode=%d cgroup_ino=%lu",
 		__entry->name,
 		__entry->ino,
 		__entry->sync_mode,
@@ -358,7 +358,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__field(int, range_cyclic)
 		__field(int, for_background)
 		__field(int, reason)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 	TP_fast_assign(
 		strscpy_pad(__entry->name,
@@ -374,7 +374,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 		__entry->cgroup_ino = __trace_wb_assign_cgroup(wb);
 	),
 	TP_printk("bdi %s: sb_dev %d:%d nr_pages=%ld sync_mode=%d "
-		  "kupdate=%d range_cyclic=%d background=%d reason=%s cgroup_ino=%u",
+		  "kupdate=%d range_cyclic=%d background=%d reason=%s cgroup_ino=%lu",
 		  __entry->name,
 		  MAJOR(__entry->sb_dev), MINOR(__entry->sb_dev),
 		  __entry->nr_pages,
@@ -413,13 +413,13 @@ DECLARE_EVENT_CLASS(writeback_class,
 	TP_ARGS(wb),
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 	TP_fast_assign(
 		strscpy_pad(__entry->name, dev_name(wb->bdi->dev), 32);
 		__entry->cgroup_ino = __trace_wb_assign_cgroup(wb);
 	),
-	TP_printk("bdi %s: cgroup_ino=%u",
+	TP_printk("bdi %s: cgroup_ino=%lu",
 		  __entry->name,
 		  __entry->cgroup_ino
 	)
@@ -459,7 +459,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, range_cyclic)
 		__field(long, range_start)
 		__field(long, range_end)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -478,7 +478,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 
 	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
 		"bgrd=%d reclm=%d cyclic=%d "
-		"start=0x%lx end=0x%lx cgroup_ino=%u",
+		"start=0x%lx end=0x%lx cgroup_ino=%lu",
 		__entry->name,
 		__entry->nr_to_write,
 		__entry->pages_skipped,
@@ -510,7 +510,7 @@ TRACE_EVENT(writeback_queue_io,
 		__field(long,		age)
 		__field(int,		moved)
 		__field(int,		reason)
-		__field(unsigned int,	cgroup_ino)
+		__field(ino_t,		cgroup_ino)
 	),
 	TP_fast_assign(
 		unsigned long *older_than_this = work->older_than_this;
@@ -522,7 +522,7 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->reason	= work->reason;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 	),
-	TP_printk("bdi %s: older=%lu age=%ld enqueue=%d reason=%s cgroup_ino=%u",
+	TP_printk("bdi %s: older=%lu age=%ld enqueue=%d reason=%s cgroup_ino=%lu",
 		__entry->name,
 		__entry->older,	/* older_than_this in jiffies */
 		__entry->age,	/* older_than_this in relative milliseconds */
@@ -596,7 +596,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 		__field(unsigned long,	dirty_ratelimit)
 		__field(unsigned long,	task_ratelimit)
 		__field(unsigned long,	balanced_dirty_ratelimit)
-		__field(unsigned int,	cgroup_ino)
+		__field(ino_t,		cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -614,7 +614,7 @@ TRACE_EVENT(bdi_dirty_ratelimit,
 	TP_printk("bdi %s: "
 		  "write_bw=%lu awrite_bw=%lu dirty_rate=%lu "
 		  "dirty_ratelimit=%lu task_ratelimit=%lu "
-		  "balanced_dirty_ratelimit=%lu cgroup_ino=%u",
+		  "balanced_dirty_ratelimit=%lu cgroup_ino=%lu",
 		  __entry->bdi,
 		  __entry->write_bw,		/* write bandwidth */
 		  __entry->avg_write_bw,	/* avg write bandwidth */
@@ -660,7 +660,7 @@ TRACE_EVENT(balance_dirty_pages,
 		__field(	 long,	pause)
 		__field(unsigned long,	period)
 		__field(	 long,	think)
-		__field(unsigned int,	cgroup_ino)
+		__field(ino_t,		cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -692,7 +692,7 @@ TRACE_EVENT(balance_dirty_pages,
 		  "bdi_setpoint=%lu bdi_dirty=%lu "
 		  "dirty_ratelimit=%lu task_ratelimit=%lu "
 		  "dirtied=%u dirtied_pause=%u "
-		  "paused=%lu pause=%ld period=%lu think=%ld cgroup_ino=%u",
+		  "paused=%lu pause=%ld period=%lu think=%ld cgroup_ino=%lu",
 		  __entry->bdi,
 		  __entry->limit,
 		  __entry->setpoint,
@@ -718,10 +718,10 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(unsigned long, ino)
+		__field(ino_t, ino)
 		__field(unsigned long, state)
 		__field(unsigned long, dirtied_when)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -733,7 +733,7 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(inode_to_wb(inode));
 	),
 
-	TP_printk("bdi %s: ino=%lu state=%s dirtied_when=%lu age=%lu cgroup_ino=%u",
+	TP_printk("bdi %s: ino=%lu state=%s dirtied_when=%lu age=%lu cgroup_ino=%lu",
 		  __entry->name,
 		  __entry->ino,
 		  show_inode_state(__entry->state),
@@ -789,13 +789,13 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(unsigned long, ino)
+		__field(ino_t, ino)
 		__field(unsigned long, state)
 		__field(unsigned long, dirtied_when)
 		__field(unsigned long, writeback_index)
 		__field(long, nr_to_write)
 		__field(unsigned long, wrote)
-		__field(unsigned int, cgroup_ino)
+		__field(ino_t, cgroup_ino)
 	),
 
 	TP_fast_assign(
@@ -811,7 +811,7 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	),
 
 	TP_printk("bdi %s: ino=%lu state=%s dirtied_when=%lu age=%lu "
-		  "index=%lu to_write=%ld wrote=%lu cgroup_ino=%u",
+		  "index=%lu to_write=%ld wrote=%lu cgroup_ino=%lu",
 		  __entry->name,
 		  __entry->ino,
 		  show_inode_state(__entry->state),
@@ -845,7 +845,7 @@ DECLARE_EVENT_CLASS(writeback_inode_template,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(unsigned long,	ino			)
+		__field(	ino_t,	ino			)
 		__field(unsigned long,	state			)
 		__field(	__u16, mode			)
 		__field(unsigned long, dirtied_when		)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..912e761cd17a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -317,7 +317,7 @@ BPF_CALL_0(bpf_get_current_cgroup_id)
 {
 	struct cgroup *cgrp = task_dfl_cgroup(current);
 
-	return cgrp->kn->id.id;
+	return cgrp->kn->id;
 }
 
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto = {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cf32c0c7a45d..b5dcbee5aa6c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5786,12 +5786,11 @@ static int __init cgroup_wq_init(void)
 }
 core_initcall(cgroup_wq_init);
 
-void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
-					char *buf, size_t buflen)
+void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 {
 	struct kernfs_node *kn;
 
-	kn = kernfs_get_node_by_id(cgrp_dfl_root.kf_root, id);
+	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
 		return;
 	kernfs_path(kn, buf, buflen);
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2d6e93ab0478..53d259578175 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -64,8 +64,7 @@ static void blk_unregister_tracepoints(void);
  * Send out a notify message.
  */
 static void trace_note(struct blk_trace *bt, pid_t pid, int action,
-		       const void *data, size_t len,
-		       union kernfs_node_id *cgid)
+		       const void *data, size_t len, u64 cgid)
 {
 	struct blk_io_trace *t;
 	struct ring_buffer_event *event = NULL;
@@ -73,7 +72,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 	int pc = 0;
 	int cpu = smp_processor_id();
 	bool blk_tracer = blk_tracer_enabled;
-	ssize_t cgid_len = cgid ? sizeof(*cgid) : 0;
+	ssize_t cgid_len = cgid ? sizeof(cgid) : 0;
 
 	if (blk_tracer) {
 		buffer = blk_tr->trace_buffer.buffer;
@@ -100,9 +99,9 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 		t->pid = pid;
 		t->cpu = cpu;
 		t->pdu_len = len + cgid_len;
-		if (cgid)
-			memcpy((void *)t + sizeof(*t), cgid, cgid_len);
-		memcpy((void *) t + sizeof(*t) + cgid_len, data, len);
+		if (cgid_len)
+			*(u64 *)(t + 1) = cgid;
+		memcpy((void *)( t + sizeof(*t)) + cgid_len, data, len);
 
 		if (blk_tracer)
 			trace_buffer_unlock_commit(blk_tr, buffer, event, 0, pc);
@@ -122,7 +121,7 @@ static void trace_note_tsk(struct task_struct *tsk)
 	spin_lock_irqsave(&running_trace_lock, flags);
 	list_for_each_entry(bt, &running_trace_list, running_list) {
 		trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm,
-			   sizeof(tsk->comm), NULL);
+			   sizeof(tsk->comm), 0);
 	}
 	spin_unlock_irqrestore(&running_trace_lock, flags);
 }
@@ -139,7 +138,7 @@ static void trace_note_time(struct blk_trace *bt)
 	words[1] = now.tv_nsec;
 
 	local_irq_save(flags);
-	trace_note(bt, 0, BLK_TN_TIMESTAMP, words, sizeof(words), NULL);
+	trace_note(bt, 0, BLK_TN_TIMESTAMP, words, sizeof(words), 0);
 	local_irq_restore(flags);
 }
 
@@ -172,9 +171,9 @@ void __trace_note_message(struct blk_trace *bt, struct blkcg *blkcg,
 		blkcg = NULL;
 #ifdef CONFIG_BLK_CGROUP
 	trace_note(bt, 0, BLK_TN_MESSAGE, buf, n,
-		blkcg ? cgroup_get_kernfs_id(blkcg->css.cgroup) : NULL);
+		blkcg ? cgroup_get_kernfs_id(blkcg->css.cgroup) : 0);
 #else
-	trace_note(bt, 0, BLK_TN_MESSAGE, buf, n, NULL);
+	trace_note(bt, 0, BLK_TN_MESSAGE, buf, n, 0);
 #endif
 	local_irq_restore(flags);
 }
@@ -212,7 +211,7 @@ static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
  */
 static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		     int op, int op_flags, u32 what, int error, int pdu_len,
-		     void *pdu_data, union kernfs_node_id *cgid)
+		     void *pdu_data, u64 cgid)
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
@@ -223,7 +222,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	pid_t pid;
 	int cpu, pc = 0;
 	bool blk_tracer = blk_tracer_enabled;
-	ssize_t cgid_len = cgid ? sizeof(*cgid) : 0;
+	ssize_t cgid_len = cgid ? sizeof(cgid) : 0;
 
 	if (unlikely(bt->trace_state != Blktrace_running && !blk_tracer))
 		return;
@@ -294,7 +293,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		t->pdu_len = pdu_len + cgid_len;
 
 		if (cgid_len)
-			memcpy((void *)t + sizeof(*t), cgid, cgid_len);
+			*(u64 *)(t + 1) = cgid;
 		if (pdu_len)
 			memcpy((void *)t + sizeof(*t) + cgid_len, pdu_data, pdu_len);
 
@@ -751,31 +750,29 @@ void blk_trace_shutdown(struct request_queue *q)
 }
 
 #ifdef CONFIG_BLK_CGROUP
-static union kernfs_node_id *
-blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
+static u64 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 {
 	struct blk_trace *bt = q->blk_trace;
 
 	if (!bt || !(blk_tracer_flags.val & TRACE_BLK_OPT_CGROUP))
-		return NULL;
+		return 0;
 
 	if (!bio->bi_blkg)
-		return NULL;
+		return 0;
 	return cgroup_get_kernfs_id(bio_blkcg(bio)->css.cgroup);
 }
 #else
-static union kernfs_node_id *
-blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
+u64 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 {
-	return NULL;
+	return 0;
 }
 #endif
 
-static union kernfs_node_id *
+static u64
 blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)
 {
 	if (!rq->bio)
-		return NULL;
+		return 0;
 	/* Use the first bio */
 	return blk_trace_bio_get_cgid(q, rq->bio);
 }
@@ -797,8 +794,7 @@ blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)
  *
  **/
 static void blk_add_trace_rq(struct request *rq, int error,
-			     unsigned int nr_bytes, u32 what,
-			     union kernfs_node_id *cgid)
+			     unsigned int nr_bytes, u32 what, u64 cgid)
 {
 	struct blk_trace *bt = rq->q->blk_trace;
 
@@ -913,7 +909,7 @@ static void blk_add_trace_getrq(void *ignore,
 
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
-					NULL, NULL);
+					NULL, 0);
 	}
 }
 
@@ -929,7 +925,7 @@ static void blk_add_trace_sleeprq(void *ignore,
 
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
-					0, 0, NULL, NULL);
+					0, 0, NULL, 0);
 	}
 }
 
@@ -938,7 +934,7 @@ static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 	struct blk_trace *bt = q->blk_trace;
 
 	if (bt)
-		__blk_add_trace(bt, 0, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL, NULL);
+		__blk_add_trace(bt, 0, 0, 0, 0, BLK_TA_PLUG, 0, 0, NULL, 0);
 }
 
 static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
@@ -955,7 +951,7 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 		else
 			what = BLK_TA_UNPLUG_TIMER;
 
-		__blk_add_trace(bt, 0, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu, NULL);
+		__blk_add_trace(bt, 0, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu, 0);
 	}
 }
 
@@ -1173,18 +1169,18 @@ const struct blk_io_trace *te_blk_io_trace(const struct trace_entry *ent)
 static inline const void *pdu_start(const struct trace_entry *ent, bool has_cg)
 {
 	return (void *)(te_blk_io_trace(ent) + 1) +
-		(has_cg ? sizeof(union kernfs_node_id) : 0);
+		(has_cg ? sizeof(u64) : 0);
 }
 
-static inline const void *cgid_start(const struct trace_entry *ent)
+static inline u64 t_cgid(const struct trace_entry *ent)
 {
-	return (void *)(te_blk_io_trace(ent) + 1);
+	return *(u64 *)(te_blk_io_trace(ent) + 1);
 }
 
 static inline int pdu_real_len(const struct trace_entry *ent, bool has_cg)
 {
 	return te_blk_io_trace(ent)->pdu_len -
-			(has_cg ? sizeof(union kernfs_node_id) : 0);
+			(has_cg ? sizeof(u64) : 0);
 }
 
 static inline u32 t_action(const struct trace_entry *ent)
@@ -1257,7 +1253,7 @@ static void blk_log_action(struct trace_iterator *iter, const char *act,
 
 	fill_rwbs(rwbs, t);
 	if (has_cg) {
-		const union kernfs_node_id *id = cgid_start(iter->ent);
+		u64 id = t_cgid(iter->ent);
 
 		if (blk_tracer_flags.val & TRACE_BLK_OPT_CGNAME) {
 			char blkcg_name_buf[NAME_MAX + 1] = "<...>";
@@ -1269,9 +1265,9 @@ static void blk_log_action(struct trace_iterator *iter, const char *act,
 				 blkcg_name_buf, act, rwbs);
 		} else
 			trace_seq_printf(&iter->seq,
-				 "%3d,%-3d %x,%-x %2s %3s ",
+				 "%3d,%-3d %llx,%-llx %2s %3s ",
 				 MAJOR(t->device), MINOR(t->device),
-				 id->ino, id->generation, act, rwbs);
+				 id & U32_MAX, id >> 32, act, rwbs);
 	} else
 		trace_seq_printf(&iter->seq, "%3d,%-3d %2s %3s ",
 				 MAJOR(t->device), MINOR(t->device), act, rwbs);
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..b360a7beb6fc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4089,7 +4089,7 @@ BPF_CALL_1(bpf_skb_cgroup_id, const struct sk_buff *, skb)
 		return 0;
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	return cgrp->kn->id.id;
+	return cgrp->kn->id;
 }
 
 static const struct bpf_func_proto bpf_skb_cgroup_id_proto = {
@@ -4114,7 +4114,7 @@ BPF_CALL_2(bpf_skb_ancestor_cgroup_id, const struct sk_buff *, skb, int,
 	if (!ancestor)
 		return 0;
 
-	return ancestor->kn->id.id;
+	return ancestor->kn->id;
 }
 
 static const struct bpf_func_proto bpf_skb_ancestor_cgroup_id_proto = {
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

