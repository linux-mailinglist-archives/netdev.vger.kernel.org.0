Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72F161798
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgBQQOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:14:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49196 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgBQQOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:45 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2g-0003Cp-3h; Mon, 17 Feb 2020 16:14:42 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net-next v2 01/10] sysfs: add sysfs_file_change_owner{_by_name}()
Date:   Mon, 17 Feb 2020 17:14:27 +0100
Message-Id: <20200217161436.1748598-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to change owner of a sysfs files.
The ownership of a sysfs object is determined based on the ownership of
the corresponding kobject, i.e. only if the ownership of a kobject is
changed will this function change the ownership of the corresponding
sysfs entry.
This function will be used to correctly account for kobject ownership
changes, e.g. when moving network devices between network namespaces.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Better naming for sysfs_file_change_owner() to reflect the fact that it
     can be used to change the owner of the kobject itself by passing NULL as
     argument.
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Split sysfs_file_change_owner() into two helpers sysfs_change_owner() and
    sysfs_change_owner_by_name(). The former changes the owner of the kobject
    itself, the latter the owner of the kobject looked up via the name
    argument.
---
 fs/sysfs/file.c       | 82 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 14 ++++++++
 2 files changed, 96 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 130fc6fbcc03..8f2607de2456 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -558,3 +558,85 @@ void sysfs_remove_bin_file(struct kobject *kobj,
 	kernfs_remove_by_name(kobj->sd, attr->attr.name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
+
+static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj)
+{
+	kuid_t uid;
+	kgid_t gid;
+	struct iattr newattrs = {
+		.ia_valid = ATTR_UID | ATTR_GID,
+	};
+
+	kobject_get_ownership(kobj, &uid, &gid);
+	newattrs.ia_uid = uid;
+	newattrs.ia_gid = gid;
+
+	return kernfs_setattr(kn, &newattrs);
+}
+
+/**
+ *	sysfs_file_change_owner_by_name - change owner of a file.
+ *	@kobj:	object.
+ *	@name:	name of the file to change.
+ *
+ * To change the ownership of a sysfs object, the caller must first change the
+ * uid/gid of the kobject and then call this function. Usually this will be
+ * taken care of by the relevant subsystem, e.g. moving a network device
+ * between network namespaces owned by different user namespaces will change
+ * the uid/gid of the kobject to the uid/gid of the root user in the user
+ * namespace. Calling this function afterwards will cause the sysfs object to
+ * reflect the new uid/gid.
+ */
+int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name)
+{
+	struct kernfs_node *kn;
+	int error;
+
+	if (!name)
+		return -EINVAL;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	kn = kernfs_find_and_get(kobj->sd, name);
+	if (!kn)
+		return -ENOENT;
+
+	error = internal_change_owner(kn, kobj);
+
+	kernfs_put(kn);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_file_change_owner_by_name);
+
+/**
+ *	sysfs_file_change_owner - change owner of a file.
+ *	@kobj:	object.
+ *
+ * To change the ownership of a sysfs object, the caller must first change the
+ * uid/gid of the kobject and then call this function. Usually this will be
+ * taken care of by the relevant subsystem, e.g. moving a network device
+ * between network namespaces owned by different user namespaces will change
+ * the uid/gid of the kobject to the uid/gid of the root user in the user
+ * namespace. Calling this function afterwards will cause the sysfs object to
+ * reflect the new uid/gid.
+ */
+int sysfs_file_change_owner(struct kobject *kobj)
+{
+	struct kernfs_node *kn;
+	int error;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	kernfs_get(kobj->sd);
+
+	kn = kobj->sd;
+	error = internal_change_owner(kn, kobj);
+
+	kernfs_put(kn);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index fa7ee503fb76..4b3c3b76ff80 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -310,6 +310,9 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 	return kernfs_enable_ns(kn);
 }
 
+int sysfs_file_change_owner(struct kobject *kobj);
+int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name);
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
@@ -522,6 +525,17 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 {
 }
 
+static inline int int sysfs_file_change_owner(struct kobject *kobj)
+{
+	return 0;
+}
+
+static inline int sysfs_file_change_owner_by_name(struct kobject *kobj,
+						  const char *name)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
-- 
2.25.0

