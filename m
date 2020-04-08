Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125B21A24F3
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgDHPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:23:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39116 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgDHPWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:45 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXJ-0001BO-Q6; Wed, 08 Apr 2020 15:22:41 +0000
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
Subject: [PATCH 6/8] genhd: add minimal namespace infrastructure
Date:   Wed,  8 Apr 2020 17:21:49 +0200
Message-Id: <20200408152151.5780-7-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lets the block_class properly support loopfs device by introducing
the minimal infrastructure needed to support different sysfs views for
devices belonging to the block_class. This is similar to how network
devices work. Note, that nothing changes with this patch since
all block_class devices are tagged explicitly with init_user_ns whereas
they were tagged implicitly with init_user_ns before. No code is added
if CONFIG_BLK_DEV_LOOPFS is not set.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 block/genhd.c               | 79 +++++++++++++++++++++++++++++++++++++
 fs/kernfs/kernfs-internal.h |  3 ++
 fs/sysfs/mount.c            |  4 ++
 include/linux/genhd.h       |  3 ++
 include/linux/kobject_ns.h  |  1 +
 5 files changed, 90 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 9c2e13ce0d19..a6d51d9a94f6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1127,11 +1127,81 @@ static struct kobject *base_probe(dev_t devt, int *partno, void *data)
 	return NULL;
 }
 
+#ifdef CONFIG_BLK_DEV_LOOPFS
+static void *user_grab_current_ns(void)
+{
+	struct user_namespace *ns = current_user_ns();
+	return get_user_ns(ns);
+}
+
+static const void *user_initial_ns(void)
+{
+	return &init_user_ns;
+}
+
+static void user_put_ns(void *p)
+{
+	struct user_namespace *ns = p;
+	put_user_ns(ns);
+}
+
+static bool user_current_may_mount(void)
+{
+	return ns_capable(current_user_ns(), CAP_SYS_ADMIN);
+}
+
+const struct kobj_ns_type_operations user_ns_type_operations = {
+	.type			= KOBJ_NS_TYPE_USER,
+	.current_may_mount	= user_current_may_mount,
+	.grab_current_ns	= user_grab_current_ns,
+	.initial_ns		= user_initial_ns,
+	.drop_ns		= user_put_ns,
+};
+
+static const void *block_class_user_namespace(struct device *dev)
+{
+	struct gendisk *disk;
+
+	if (dev->type == &part_type)
+		disk = part_to_disk(dev_to_part(dev));
+	else
+		disk = dev_to_disk(dev);
+
+	return disk->user_ns;
+}
+
+static void block_class_get_ownership(struct device *dev, kuid_t *uid, kgid_t *gid)
+{
+	struct gendisk *disk;
+	struct user_namespace *ns;
+
+	if (dev->type == &part_type)
+		disk = part_to_disk(dev_to_part(dev));
+	else
+		disk = dev_to_disk(dev);
+
+	ns = disk->user_ns;
+	if (ns && ns != &init_user_ns) {
+		kuid_t ns_root_uid = make_kuid(ns, 0);
+		kgid_t ns_root_gid = make_kgid(ns, 0);
+
+		if (uid_valid(ns_root_uid))
+			*uid = ns_root_uid;
+
+		if (gid_valid(ns_root_gid))
+			*gid = ns_root_gid;
+	}
+}
+#endif /* CONFIG_BLK_DEV_LOOPFS */
+
 static int __init genhd_device_init(void)
 {
 	int error;
 
 	block_class.dev_kobj = sysfs_dev_block_kobj;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	kobj_ns_type_register(&user_ns_type_operations);
+#endif
 	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
@@ -1369,8 +1439,14 @@ static void disk_release(struct device *dev)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
+
 struct class block_class = {
 	.name		= "block",
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	.ns_type	= &user_ns_type_operations,
+	.namespace	= block_class_user_namespace,
+	.get_ownership	= block_class_get_ownership,
+#endif
 };
 
 static char *block_devnode(struct device *dev, umode_t *mode,
@@ -1550,6 +1626,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 		disk_to_dev(disk)->class = &block_class;
 		disk_to_dev(disk)->type = &disk_type;
 		device_initialize(disk_to_dev(disk));
+#ifdef CONFIG_BLK_DEV_LOOPFS
+		disk->user_ns = &init_user_ns;
+#endif
 	}
 	return disk;
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 4ba7b36103de..699b7b67f9e0 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -79,12 +79,15 @@ static inline struct kernfs_node *kernfs_dentry_node(struct dentry *dentry)
 }
 
 extern struct net init_net;
+extern struct user_namespace init_user_ns;
 
 static inline const void *kernfs_init_ns(enum kobj_ns_type ns_type)
 {
 	switch (ns_type) {
 	case KOBJ_NS_TYPE_NET:
 		return &init_net;
+	case KOBJ_NS_TYPE_USER:
+		return &init_user_ns;
 	default:
 		pr_debug("Unsupported namespace type %d for kernfs\n", ns_type);
 	}
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 5e2ec88a709e..99b82a0ae7ea 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -43,6 +43,8 @@ static void sysfs_fs_context_free(struct fs_context *fc)
 
 	if (kfc->ns_tag[KOBJ_NS_TYPE_NET])
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, kfc->ns_tag[KOBJ_NS_TYPE_NET]);
+	if (kfc->ns_tag[KOBJ_NS_TYPE_USER])
+		kobj_ns_drop(KOBJ_NS_TYPE_USER, kfc->ns_tag[KOBJ_NS_TYPE_USER]);
 	kernfs_free_fs_context(fc);
 	kfree(kfc);
 }
@@ -67,6 +69,7 @@ static int sysfs_init_fs_context(struct fs_context *fc)
 		return -ENOMEM;
 
 	kfc->ns_tag[KOBJ_NS_TYPE_NET] = netns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
+	kfc->ns_tag[KOBJ_NS_TYPE_USER] = kobj_ns_grab_current(KOBJ_NS_TYPE_USER);
 	kfc->root = sysfs_root;
 	kfc->magic = SYSFS_MAGIC;
 	fc->fs_private = kfc;
@@ -85,6 +88,7 @@ static void sysfs_kill_sb(struct super_block *sb)
 
 	kernfs_kill_sb(sb);
 	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns[KOBJ_NS_TYPE_NET]);
+	kobj_ns_drop(KOBJ_NS_TYPE_USER, ns[KOBJ_NS_TYPE_USER]);
 }
 
 static struct file_system_type sysfs_fs_type = {
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 07dc91835b98..e5cf5caea345 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,6 +219,9 @@ struct gendisk {
 	int node_id;
 	struct badblocks *bb;
 	struct lockdep_map lockdep_map;
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	struct user_namespace *user_ns;
+#endif
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index 216f9112ee1d..a9c45bcce235 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -26,6 +26,7 @@ struct kobject;
 enum kobj_ns_type {
 	KOBJ_NS_TYPE_NONE = 0,
 	KOBJ_NS_TYPE_NET,
+	KOBJ_NS_TYPE_USER,
 	KOBJ_NS_TYPES
 };
 
-- 
2.26.0

