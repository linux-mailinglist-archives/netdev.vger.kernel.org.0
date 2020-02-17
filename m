Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4548016178A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgBQQOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:14:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49203 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBQQOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:46 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2h-0003Cp-AT; Mon, 17 Feb 2020 16:14:43 +0000
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
Subject: [PATCH net-next v2 03/10] sysfs: add sysfs_group_change_owner()
Date:   Mon, 17 Feb 2020 17:14:29 +0100
Message-Id: <20200217161436.1748598-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a sysfs group.
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
   - Add comment how ownership of sysfs object is changed.
---
 fs/sysfs/group.c      | 93 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  8 ++++
 2 files changed, 101 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c4ab045926b7..7d158d59d097 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -13,6 +13,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 #include "sysfs.h"
 
 
@@ -457,3 +458,95 @@ int __compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
 	return PTR_ERR_OR_ZERO(link);
 }
 EXPORT_SYMBOL_GPL(__compat_only_sysfs_link_entry_to_kobj);
+
+static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
+					  const struct attribute_group *grp,
+					  struct iattr *newattrs)
+{
+	struct kernfs_node *kn;
+	int error;
+
+	if (grp->attrs) {
+		struct attribute *const *attr;
+
+		for (attr = grp->attrs; *attr; attr++) {
+			kn = kernfs_find_and_get(grp_kn, (*attr)->name);
+			if (!kn)
+				return -ENOENT;
+
+			error = kernfs_setattr(kn, newattrs);
+			kernfs_put(kn);
+			if (error)
+				return error;
+		}
+	}
+
+	if (grp->bin_attrs) {
+		struct bin_attribute *const *bin_attr;
+
+		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
+			kn = kernfs_find_and_get(grp_kn, (*bin_attr)->attr.name);
+			if (!kn)
+				return -ENOENT;
+
+			error = kernfs_setattr(kn, newattrs);
+			kernfs_put(kn);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * sysfs_group_change_owner - change owner of an attribute group.
+ * @kobj:	The kobject containing the group.
+ * @grp:	The attribute group.
+ *
+ * To change the ownership of a sysfs object, the caller must first change the
+ * uid/gid of the kobject and then call this function. Usually this will be
+ * taken care of by the relevant subsystem, e.g. moving a network device
+ * between network namespaces owned by different user namespaces will change
+ * the uid/gid of the kobject to the uid/gid of the root user in the user
+ * namespace. Calling this function afterwards will cause the sysfs object to
+ * reflect the new uid/gid.
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_group_change_owner(struct kobject *kobj,
+			     const struct attribute_group *grp)
+{
+	struct kernfs_node *grp_kn;
+	kuid_t uid;
+	kgid_t gid;
+	int error;
+	struct iattr newattrs = {
+		.ia_valid = ATTR_UID | ATTR_GID,
+	};
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	if (grp->name) {
+		grp_kn = kernfs_find_and_get(kobj->sd, grp->name);
+	} else {
+		kernfs_get(kobj->sd);
+		grp_kn = kobj->sd;
+	}
+	if (!grp_kn)
+		return -ENOENT;
+
+	kobject_get_ownership(kobj, &uid, &gid);
+	newattrs.ia_uid = uid;
+	newattrs.ia_gid = gid;
+
+	error = kernfs_setattr(grp_kn, &newattrs);
+	if (!error)
+		error = sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
+
+	kernfs_put(grp_kn);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 238f3d7b1fa0..dd211f0a654b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -314,6 +314,8 @@ int sysfs_file_change_owner(struct kobject *kobj);
 int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
+int sysfs_group_change_owner(struct kobject *kobj,
+			     const struct attribute_group *groups);
 
 #else /* CONFIG_SYSFS */
 
@@ -545,6 +547,12 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_group_change_owner(struct kobject *kobj,
+			 const struct attribute_group **groups)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
-- 
2.25.0

