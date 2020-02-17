Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1EB161796
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgBQQPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:15:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49206 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgBQQOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:14:46 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3j2h-0003Cp-Tm; Mon, 17 Feb 2020 16:14:44 +0000
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
Subject: [PATCH net-next v2 04/10] sysfs: add sysfs_groups_change_owner()
Date:   Mon, 17 Feb 2020 17:14:30 +0100
Message-Id: <20200217161436.1748598-5-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of a set of sysfs groups file.
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
 fs/sysfs/group.c      | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  8 ++++++++
 2 files changed, 44 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 7d158d59d097..0fc7b119a5dd 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -550,3 +550,39 @@ int sysfs_group_change_owner(struct kobject *kobj,
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
+
+/**
+ * sysfs_groups_change_owner - change owner of a set of attribute groups.
+ * @kobj:	The kobject containing the groups.
+ * @groups:	The attribute groups.
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
+int sysfs_groups_change_owner(struct kobject *kobj,
+			      const struct attribute_group **groups)
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
+		error = sysfs_group_change_owner(kobj, groups[i]);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_groups_change_owner);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index dd211f0a654b..d13c6cc8e487 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -314,6 +314,8 @@ int sysfs_file_change_owner(struct kobject *kobj);
 int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
+int sysfs_groups_change_owner(struct kobject *kobj,
+			      const struct attribute_group **groups);
 int sysfs_group_change_owner(struct kobject *kobj,
 			     const struct attribute_group *groups);
 
@@ -547,6 +549,12 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_groups_change_owner(struct kobject *kobj,
+			  const struct attribute_group **groups)
+{
+	return 0;
+}
+
 static inline int sysfs_group_change_owner(struct kobject *kobj,
 			 const struct attribute_group **groups)
 {
-- 
2.25.0

