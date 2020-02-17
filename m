Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FBC16179A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgBQQOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:14:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49200 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgBQQOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:45 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2g-0003Cp-N3; Mon, 17 Feb 2020 16:14:42 +0000
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
Subject: [PATCH net-next v2 02/10] sysfs: add sysfs_link_change_owner()
Date:   Mon, 17 Feb 2020 17:14:28 +0100
Message-Id: <20200217161436.1748598-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a sysfs link.
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
 fs/sysfs/file.c       | 46 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  9 +++++++++
 2 files changed, 55 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8f2607de2456..8b20245f359c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -574,6 +574,52 @@ static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj)
 	return kernfs_setattr(kn, &newattrs);
 }
 
+/**
+ *	sysfs_link_change_owner - change owner of a link.
+ *	@kobj:	object of the kernfs_node the symlink is located in.
+ *	@targ:	object of the kernfs_node the symlink points to.
+ *	@name:	name of the link.
+ *
+ * To change the ownership of a sysfs object, the caller must first change the
+ * uid/gid of the kobject and then call this function. Usually this will be
+ * taken care of by the relevant subsystem, e.g. moving a network device
+ * between network namespaces owned by different user namespaces will change
+ * the uid/gid of the kobject to the uid/gid of the root user in the user
+ * namespace. Calling this function afterwards will cause the sysfs object to
+ * reflect the new uid/gid.
+ */
+int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
+			    const char *name)
+{
+	struct kernfs_node *parent, *kn = NULL;
+	int error;
+
+	if (!kobj)
+		parent = sysfs_root_kn;
+	else
+		parent = kobj->sd;
+
+	if (!targ->state_in_sysfs)
+		return -EINVAL;
+
+	error = -ENOENT;
+	kn = kernfs_find_and_get_ns(parent, name, targ->sd->ns);
+	if (!kn)
+		goto out;
+
+	error = -EINVAL;
+	if (kernfs_type(kn) != KERNFS_LINK)
+		goto out;
+	if (kn->symlink.target_kn->priv != targ)
+		goto out;
+
+	error = internal_change_owner(kn, targ);
+
+out:
+	kernfs_put(kn);
+	return error;
+}
+
 /**
  *	sysfs_file_change_owner_by_name - change owner of a file.
  *	@kobj:	object.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 4b3c3b76ff80..238f3d7b1fa0 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -312,6 +312,8 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 
 int sysfs_file_change_owner(struct kobject *kobj);
 int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name);
+int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
+			    const char *name);
 
 #else /* CONFIG_SYSFS */
 
@@ -536,6 +538,13 @@ static inline int sysfs_file_change_owner_by_name(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_link_change_owner(struct kobject *kobj,
+					  struct kobject *targ,
+					  const char *name)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 static inline int __must_check sysfs_create_file(struct kobject *kobj,
-- 
2.25.0

