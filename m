Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53CD161780
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgBQQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:14:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49212 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgBQQOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:47 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2i-0003Cp-Fz; Mon, 17 Feb 2020 16:14:44 +0000
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
Subject: [PATCH net-next v2 05/10] sysfs: add sysfs_change_owner()
Date:   Mon, 17 Feb 2020 17:14:31 +0100
Message-Id: <20200217161436.1748598-6-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of sysfs objects.
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
 fs/sysfs/file.c       | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  6 ++++++
 2 files changed, 49 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8b20245f359c..f88b8bf2fcc3 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -686,3 +686,46 @@ int sysfs_file_change_owner(struct kobject *kobj)
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
+
+/**
+ *	sysfs_change_owner - change owner of the given object.
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
+int sysfs_change_owner(struct kobject *kobj)
+{
+	int error;
+	const struct kobj_type *ktype;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	error = sysfs_file_change_owner(kobj);
+	if (error)
+		return error;
+
+	ktype = get_ktype(kobj);
+	if (ktype) {
+		struct attribute **kattr;
+
+		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
+			error = sysfs_file_change_owner_by_name(kobj, (*kattr)->name);
+			if (error)
+				return error;
+		}
+
+		error = sysfs_groups_change_owner(kobj, ktype->default_groups);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index d13c6cc8e487..ce5165a111bc 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -312,6 +312,7 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 
 int sysfs_file_change_owner(struct kobject *kobj);
 int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name);
+int sysfs_change_owner(struct kobject *kobj);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
 int sysfs_groups_change_owner(struct kobject *kobj,
@@ -549,6 +550,11 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_change_owner(struct kobject *kobj)
+{
+	return 0;
+}
+
 static inline int sysfs_groups_change_owner(struct kobject *kobj,
 			  const struct attribute_group **groups)
 {
-- 
2.25.0

