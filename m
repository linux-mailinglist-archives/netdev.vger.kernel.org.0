Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09751A24F1
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgDHPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:22:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39104 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729495AbgDHPWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:43 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXI-0001BO-6Z; Wed, 08 Apr 2020 15:22:40 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/8] kernfs: let objects opt-in to propagating from the initial namespace
Date:   Wed,  8 Apr 2020 17:21:48 +0200
Message-Id: <20200408152151.5780-6-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial namespace is special in many ways. One feature it always has
had is that it propagates all its devices into all non-initial
namespaces. This is e.g. true for all device classes under /sys/class/
except the net_class. Even though none of the propagated files can be
used there are still a lot of read-only values that are accessed or read
by tools running in non-initial namespaces. To not regress such
workloads we introduce the ability to tell kernfs to continue
propagating devices from the initial namespace even when the kernfs_node
is tagged with a non-initial namespace. Note that this is a purely
opt-in feature, i.e. if there were a new device class that wanted to
make use of this new infrastructure and did not want to propagate any
devices into non-initial namespaces it could simply not implement the
relevant callback.
When a new directory in sysfs is created sysfs now can simply check
whether the relevant device wants to propagate objects from the initial
namespace or not.

Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/kernfs/dir.c             | 34 +++++++++++++++++++++++++++++-----
 fs/kernfs/kernfs-internal.h | 14 ++++++++++++++
 include/linux/kernfs.h      | 22 ++++++++++++++++++++++
 include/linux/kobject_ns.h  |  3 +++
 lib/kobject.c               |  2 ++
 5 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1f2d894ae454..02796ba6521a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -575,10 +575,15 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 		goto out_bad;
 
 	/* The kernfs node has been moved to a different namespace */
-	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
-	    kernfs_info(dentry->d_sb)->ns[kn->ns_type] != kn->ns)
-		goto out_bad;
+	if (kn->parent && kernfs_ns_enabled(kn->parent)) {
+		if (kernfs_init_ns_propagates(kn->parent) &&
+		    kn->ns == kernfs_init_ns(kn->parent->ns_type))
+			goto out_good;
+		if (kernfs_info(dentry->d_sb)->ns[kn->parent->ns_type] != kn->ns)
+			goto out_bad;
+	}
 
+out_good:
 	mutex_unlock(&kernfs_mutex);
 	return 1;
 out_bad:
@@ -1090,6 +1095,10 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 		ns = kernfs_info(dir->i_sb)->ns[parent->ns_type];
 
 	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
+	if (!kn && kernfs_init_ns_propagates(parent)) {
+		ns = kernfs_init_ns(parent->ns_type);
+		kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
+	}
 
 	/* no such entry */
 	if (!kn || !kernfs_active(kn)) {
@@ -1614,6 +1623,8 @@ static int kernfs_dir_fop_release(struct inode *inode, struct file *filp)
 static struct kernfs_node *kernfs_dir_pos(const void *ns,
 	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
+	const void *init_ns;
+
 	if (pos) {
 		int valid = kernfs_active(pos) &&
 			pos->parent == parent && hash == pos->hash;
@@ -1621,6 +1632,12 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 		if (!valid)
 			pos = NULL;
 	}
+
+	if (kernfs_init_ns_propagates(parent))
+		init_ns = kernfs_init_ns(parent->ns_type);
+	else
+		init_ns = NULL;
+
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
 		struct rb_node *node = parent->dir.children.rb_node;
 		while (node) {
@@ -1635,7 +1652,7 @@ static struct kernfs_node *kernfs_dir_pos(const void *ns,
 		}
 	}
 	/* Skip over entries which are dying/dead or in the wrong namespace */
-	while (pos && (!kernfs_active(pos) || pos->ns != ns)) {
+	while (pos && (!kernfs_active(pos) || (pos->ns != ns && pos->ns != init_ns))) {
 		struct rb_node *node = rb_next(&pos->rb);
 		if (!node)
 			pos = NULL;
@@ -1650,13 +1667,20 @@ static struct kernfs_node *kernfs_dir_next_pos(const void *ns,
 {
 	pos = kernfs_dir_pos(ns, parent, ino, pos);
 	if (pos) {
+		const void *init_ns;
+		if (kernfs_init_ns_propagates(parent))
+			init_ns = kernfs_init_ns(parent->ns_type);
+		else
+			init_ns = NULL;
+
 		do {
 			struct rb_node *node = rb_next(&pos->rb);
 			if (!node)
 				pos = NULL;
 			else
 				pos = rb_to_kn(node);
-		} while (pos && (!kernfs_active(pos) || pos->ns != ns));
+		} while (pos && (!kernfs_active(pos) ||
+				 (pos->ns != ns && pos->ns != init_ns)));
 	}
 	return pos;
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 6c375eb59460..4ba7b36103de 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -78,6 +78,20 @@ static inline struct kernfs_node *kernfs_dentry_node(struct dentry *dentry)
 	return d_inode(dentry)->i_private;
 }
 
+extern struct net init_net;
+
+static inline const void *kernfs_init_ns(enum kobj_ns_type ns_type)
+{
+	switch (ns_type) {
+	case KOBJ_NS_TYPE_NET:
+		return &init_net;
+	default:
+		pr_debug("Unsupported namespace type %d for kernfs\n", ns_type);
+	}
+
+	return NULL;
+}
+
 extern const struct super_operations kernfs_sops;
 extern struct kmem_cache *kernfs_node_cache, *kernfs_iattrs_cache;
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 0e4414bd7007..5e2143e69c1c 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -51,6 +51,7 @@ enum kernfs_node_flag {
 	KERNFS_SUICIDED		= 0x0800,
 	KERNFS_EMPTY_DIR	= 0x1000,
 	KERNFS_HAS_RELEASE	= 0x2000,
+	KERNFS_NS_PROPAGATE	= 0x4000,
 };
 
 /* @flags for kernfs_create_root() */
@@ -330,6 +331,27 @@ static inline void kernfs_enable_ns(struct kernfs_node *kn,
 	kn->ns_type = ns_type;
 }
 
+static inline void kernfs_enable_init_ns_propagates(struct kernfs_node *kn)
+{
+	WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
+	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->dir.children));
+	WARN_ON_ONCE(!(kn->flags & KERNFS_NS));
+	kn->flags |= KERNFS_NS_PROPAGATE;
+}
+
+/**
+ * kernfs_init_ns_propagates - test whether init ns propagates
+ * @kn: the node to test
+ *
+ * Test whether kernfs entries created in the init namespace propagate into
+ * other namespaces.
+ */
+static inline bool kernfs_init_ns_propagates(const struct kernfs_node *kn)
+{
+	return ((kn->flags & (KERNFS_NS | KERNFS_NS_PROPAGATE)) ==
+		(KERNFS_NS | KERNFS_NS_PROPAGATE));
+}
+
 /**
  * kernfs_ns_enabled - test whether namespace is enabled
  * @kn: the node to test
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index 991a9286bcea..216f9112ee1d 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -34,6 +34,8 @@ enum kobj_ns_type {
  *   @grab_current_ns: return a new reference to calling task's namespace
  *   @initial_ns: return the initial namespace (i.e. init_net_ns)
  *   @drop_ns: drops a reference to namespace
+ *   @initial_ns_propagates: whether devices in the initial namespace propagate
+ *			to all other namespaces
  */
 struct kobj_ns_type_operations {
 	enum kobj_ns_type type;
@@ -41,6 +43,7 @@ struct kobj_ns_type_operations {
 	void *(*grab_current_ns)(void);
 	const void *(*initial_ns)(void);
 	void (*drop_ns)(void *);
+	bool (*initial_ns_propagates)(void);
 };
 
 int kobj_ns_type_register(const struct kobj_ns_type_operations *ops);
diff --git a/lib/kobject.c b/lib/kobject.c
index c58c62d49a10..96bb8c732d1c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -121,6 +121,8 @@ static int create_dir(struct kobject *kobj)
 		BUG_ON(!kobj_ns_type_registered(ops->type));
 
 		sysfs_enable_ns(kobj->sd, ops->type);
+		if (ops->initial_ns_propagates && ops->initial_ns_propagates())
+			kernfs_enable_init_ns_propagates(kobj->sd);
 	}
 
 	return 0;
-- 
2.26.0

