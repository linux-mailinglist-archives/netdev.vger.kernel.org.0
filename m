Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5B16C224
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgBYNWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:22:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33138 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729518AbgBYNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:22:13 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6aA5-0008Ie-Mk; Tue, 25 Feb 2020 13:22:09 +0000
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
Subject: [PATCH v6 2/9] sysfs: add sysfs_link_change_owner()
Date:   Tue, 25 Feb 2020 14:19:31 +0100
Message-Id: <20200225131938.120447-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225131938.120447-1-christian.brauner@ubuntu.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a sysfs link.
This function will be used to correctly account for kobject ownership
changes, e.g. when moving network devices between network namespaces.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add comment how ownership of sysfs object is changed.

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.

/* v4 */
- Christian Brauner <christian.brauner@ubuntu.com>:
  - Add more documentation.

/* v5 */
unchanged

/* v6 */
unchanged
---
 fs/sysfs/file.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h | 10 ++++++++++
 2 files changed, 51 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4ca936ca3ba4..332cd69b378c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -570,6 +570,47 @@ static int internal_change_owner(struct kernfs_node *kn, kuid_t kuid,
 	return kernfs_setattr(kn, &newattrs);
 }
 
+/**
+ *	sysfs_link_change_owner - change owner of a sysfs file.
+ *	@kobj:	object of the kernfs_node the symlink is located in.
+ *	@targ:	object of the kernfs_node the symlink points to.
+ *	@name:	name of the link.
+ *	@kuid:	new owner's kuid
+ *	@kgid:	new owner's kgid
+ *
+ * This function looks up the sysfs symlink entry @name under @kobj and changes
+ * the ownership to @kuid/@kgid. The symlink is looked up in the namespace of
+ * @targ.
+ *
+ * Returns 0 on success or error code on failure.
+ */
+int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
+			    const char *name, kuid_t kuid, kgid_t kgid)
+{
+	struct kernfs_node *kn = NULL;
+	int error;
+
+	if (!name || !kobj->state_in_sysfs || !targ->state_in_sysfs)
+		return -EINVAL;
+
+	error = -ENOENT;
+	kn = kernfs_find_and_get_ns(kobj->sd, name, targ->sd->ns);
+	if (!kn)
+		goto out;
+
+	error = -EINVAL;
+	if (kernfs_type(kn) != KERNFS_LINK)
+		goto out;
+	if (kn->symlink.target_kn->priv != targ)
+		goto out;
+
+	error = internal_change_owner(kn, kuid, kgid);
+
+out:
+	kernfs_put(kn);
+	return error;
+}
+
 /**
  *	sysfs_file_change_owner - change owner of a sysfs file.
  *	@kobj:	object.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index a7884024a911..7e15ebfd750e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -312,6 +312,8 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 
 int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
 			    kgid_t kgid);
+int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
+			    const char *name, kuid_t kuid, kgid_t kgid);
 
 #else /* CONFIG_SYSFS */
 
@@ -532,6 +534,14 @@ static inline int sysfs_file_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_link_change_owner(struct kobject *kobj,
+					  struct kobject *targ,
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

