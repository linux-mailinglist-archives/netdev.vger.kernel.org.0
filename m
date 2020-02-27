Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E24170F0A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgB0Djy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:39:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40146 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgB0Djy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:39:54 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j7A1g-00030x-5E; Thu, 27 Feb 2020 03:39:52 +0000
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
Subject: [PATCH v7 1/9] sysfs: add sysfs_file_change_owner()
Date:   Thu, 27 Feb 2020 04:37:11 +0100
Message-Id: <20200227033719.1652190-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
References: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to change the owner of a sysfs files.
This function will be used to correctly account for kobject ownership
changes, e.g. when moving network devices between network namespaces.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.

/* v4 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Remove the second helper which changes the ownership of the kobject itself
     and do it in-place instead later on in the series. A separate helper is
     not needed for that.
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Add more documentation.

/* v5 */
unchanged

/* v6 */
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Fix commit message which still referenced the old name of the helper.

/* v7 */
unchanged
---
 fs/sysfs/file.c       | 47 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 10 +++++++++
 2 files changed, 57 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 130fc6fbcc03..4ca936ca3ba4 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -558,3 +558,50 @@ void sysfs_remove_bin_file(struct kobject *kobj,
 	kernfs_remove_by_name(kobj->sd, attr->attr.name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
+
+static int internal_change_owner(struct kernfs_node *kn, kuid_t kuid,
+				 kgid_t kgid)
+{
+	struct iattr newattrs = {
+		.ia_valid = ATTR_UID | ATTR_GID,
+		.ia_uid = kuid,
+		.ia_gid = kgid,
+	};
+	return kernfs_setattr(kn, &newattrs);
+}
+
+/**
+ *	sysfs_file_change_owner - change owner of a sysfs file.
+ *	@kobj:	object.
+ *	@name:	name of the file to change.
+ *	@kuid:	new owner's kuid
+ *	@kgid:	new owner's kgid
+ *
+ * This function looks up the sysfs entry @name under @kobj and changes the
+ * ownership to @kuid/@kgid.
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
+			    kgid_t kgid)
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
+	error = internal_change_owner(kn, kuid, kgid);
+
+	kernfs_put(kn);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index fa7ee503fb76..a7884024a911 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -310,6 +310,9 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 	return kernfs_enable_ns(kn);
 }
 
+int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
+			    kgid_t kgid);
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
@@ -522,6 +525,13 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 {
 }
 
+static inline int sysfs_file_change_owner(struct kobject *kobj,
+					  const char *name, kuid_t kuid,
+					  kgid_t kgid)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
-- 
2.25.1

