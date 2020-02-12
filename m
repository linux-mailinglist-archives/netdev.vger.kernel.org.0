Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A1215A6D1
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgBLKov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:44:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52524 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgBLKnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:41 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1pUY-0005aC-EF; Wed, 12 Feb 2020 10:43:38 +0000
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
Subject: [PATCH net-next 03/10] sysfs: add sysfs_group_change_owner()
Date:   Wed, 12 Feb 2020 11:43:14 +0100
Message-Id: <20200212104321.43570-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212104321.43570-1-christian.brauner@ubuntu.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
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
 fs/sysfs/group.c      | 85 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  8 ++++
 2 files changed, 93 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index c4ab045926b7..34b702ec9782 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -13,6 +13,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 #include "sysfs.h"
 
 
@@ -457,3 +458,87 @@ int __compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
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
index 4e10085739b7..9363c61b9349 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -313,6 +313,8 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 int sysfs_file_change_owner(struct kobject *kobj, const char *name);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
+int sysfs_group_change_owner(struct kobject *kobj,
+			     const struct attribute_group *groups);
 
 #else /* CONFIG_SYSFS */
 
@@ -538,6 +540,12 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
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

