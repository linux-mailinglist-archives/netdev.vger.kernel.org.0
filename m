Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4752416C161
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgBYMvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:51:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60250 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbgBYMuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:50:05 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6Zf0-0005kT-T1; Tue, 25 Feb 2020 12:50:03 +0000
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
Subject: [PATCH v5 3/9] sysfs: add sysfs_group{s}_change_owner()
Date:   Tue, 25 Feb 2020 13:49:42 +0100
Message-Id: <20200225124948.80682-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225124948.80682-1-christian.brauner@ubuntu.com>
References: <20200225124948.80682-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to change the owner of sysfs groups.
This function will be used to correctly account for kobject ownership
changes, e.g. when moving network devices between network namespaces.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add comment how ownership of sysfs object is changed.

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Collapse groups ownership helper patches into a single patch.

/* v4 */
unchanged

/* v5 */
unchanged
---
 fs/sysfs/group.c      | 117 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  20 ++++++++
 2 files changed, 137 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c4ab045926b7..7436f729dd07 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -13,6 +13,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 #include "sysfs.h"
 
 
@@ -457,3 +458,119 @@ int __compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
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
+ * @kuid:	new owner's kuid
+ * @kgid:	new owner's kgid
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_group_change_owner(struct kobject *kobj,
+			     const struct attribute_group *grp, kuid_t kuid,
+			     kgid_t kgid)
+{
+	struct kernfs_node *grp_kn;
+	kuid_t uid;
+	kgid_t gid;
+	int error;
+	struct iattr newattrs = {
+		.ia_valid = ATTR_UID | ATTR_GID,
+		.ia_uid = kuid,
+		.ia_gid = kgid,
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
+	error = kernfs_setattr(grp_kn, &newattrs);
+	if (!error)
+		error = sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
+
+	kernfs_put(grp_kn);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
+
+/**
+ * sysfs_groups_change_owner - change owner of a set of attribute groups.
+ * @kobj:	The kobject containing the groups.
+ * @groups:	The attribute groups.
+ * @kuid:	new owner's kuid
+ * @kgid:	new owner's kgid
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_groups_change_owner(struct kobject *kobj,
+			      const struct attribute_group **groups,
+			      kuid_t kuid, kgid_t kgid)
+{
+	int error = 0, i;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	if (!groups)
+		return 0;
+
+	for (i = 0; groups[i]; i++) {
+		error = sysfs_group_change_owner(kobj, groups[i], kuid, kgid);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_groups_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 7e15ebfd750e..3fcaabdb05ef 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -314,6 +314,12 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
 			    kgid_t kgid);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name, kuid_t kuid, kgid_t kgid);
+int sysfs_groups_change_owner(struct kobject *kobj,
+			      const struct attribute_group **groups,
+			      kuid_t kuid, kgid_t kgid);
+int sysfs_group_change_owner(struct kobject *kobj,
+			     const struct attribute_group *groups, kuid_t kuid,
+			     kgid_t kgid);
 
 #else /* CONFIG_SYSFS */
 
@@ -542,6 +548,20 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_groups_change_owner(struct kobject *kobj,
+			  const struct attribute_group **groups,
+			  kuid_t kuid, kgid_t kgid)
+{
+	return 0;
+}
+
+static inline int sysfs_group_change_owner(struct kobject *kobj,
+			 const struct attribute_group **groups,
+			 kuid_t kuid, kgid_t kgid)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
-- 
2.25.1

