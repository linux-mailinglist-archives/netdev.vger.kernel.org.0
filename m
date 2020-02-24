Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9494916AD1D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgBXRWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:22:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57098 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgBXRVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:21:25 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6HQ3-0004D9-C9; Mon, 24 Feb 2020 17:21:23 +0000
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
Subject: [PATCH v4 4/9] sysfs: add sysfs_change_owner()
Date:   Mon, 24 Feb 2020 18:21:05 +0100
Message-Id: <20200224172110.4121492-5-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224172110.4121492-1-christian.brauner@ubuntu.com>
References: <20200224172110.4121492-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of sysfs objects.
This function will be used to correctly account for kobject ownership
changes, e.g. when moving network devices between network namespaces.

This mirrors how a kobject is added through driver core which in its guts is
done via kobject_add_internal() which in summary creates the main directory via
create_dir(), populates that directory with the groups associated with the
ktype of the kobject (if any) and populates the directory with the basic
attributes associated with the ktype of the kobject (if any). These are the
basic steps that are associated with adding a kobject in sysfs.
Any additional properties are added by the specific subsystem itself (not by
driver core) after it has registered the device. So for the example of network
devices, a network device will e.g. register a queue subdirectory under the
basic sysfs directory for the network device and than further subdirectories
within that queues subdirectory.  But that is all specific to network devices
and they call the corresponding sysfs functions to do that directly when they
create those queue objects. So anything that a subsystem adds outside of what
driver core does must also be changed by it (That's already true for removal of
files it created outside of driver core.) and it's the same for ownership
changes.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add comment how ownership of sysfs object is changed.

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.

/* v4 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Change the ownership of the kobject itself directly in
     sysfs_change_owner() and do not rely on separate function to do that.
   - Add more documentation.
---
 fs/sysfs/file.c       | 60 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  6 +++++
 2 files changed, 66 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 332cd69b378c..26bbf960e2a2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -646,3 +646,63 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
+
+/**
+ *	sysfs_change_owner - change owner of the given object.
+ *	@kobj:	object.
+ *	@kuid:	new owner's kuid
+ *	@kgid:	new owner's kgid
+ *
+ * Change the owner of the default directory, files, groups, and attributes of
+ * @kobj to @kuid/@kgid. Note that sysfs_change_owner mirrors how the sysfs
+ * entries for a kobject are added by driver core. In summary,
+ * sysfs_change_owner() takes care of the default directory entry for @kobj,
+ * the default attributes associated with the ktype of @kobj and the default
+ * attributes associated with the ktype of @kobj.
+ * Additional properties not added by driver core have to be changed by the
+ * driver or subsystem which created them. This is similar to how
+ * driver/subsystem specific entries are removed.
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
+{
+	int error;
+	const struct kobj_type *ktype;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	/* Change the owner of the kobject itself. */
+	error = internal_change_owner(kobj->sd, kuid, kgid);
+	if (error)
+		return error;
+
+	ktype = get_ktype(kobj);
+	if (ktype) {
+		struct attribute **kattr;
+
+		/*
+		 * Change owner of the default attributes associated with the
+		 * ktype of @kobj.
+		 */
+		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
+			error = sysfs_file_change_owner(kobj, (*kattr)->name,
+							kuid, kgid);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Change owner of the default groups associated with the
+		 * ktype of @kobj.
+		 */
+		error = sysfs_groups_change_owner(kobj, ktype->default_groups,
+						  kuid, kgid);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 3fcaabdb05ef..9e531ec76274 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -312,6 +312,7 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 
 int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
 			    kgid_t kgid);
+int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name, kuid_t kuid, kgid_t kgid);
 int sysfs_groups_change_owner(struct kobject *kobj,
@@ -548,6 +549,11 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
+{
+	return 0;
+}
+
 static inline int sysfs_groups_change_owner(struct kobject *kobj,
 			  const struct attribute_group **groups,
 			  kuid_t kuid, kgid_t kgid)
-- 
2.25.1

