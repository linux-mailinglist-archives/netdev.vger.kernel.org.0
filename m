Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2043162A9A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBRQal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:30:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57207 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgBRQaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:30:10 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j45l9-0003h0-4i; Tue, 18 Feb 2020 16:30:07 +0000
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
Subject: [PATCH net-next v3 4/9] sysfs: add sysfs_change_owner()
Date:   Tue, 18 Feb 2020 17:29:38 +0100
Message-Id: <20200218162943.2488012-5-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to change the owner of sysfs objects.
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
---
 fs/sysfs/file.c       | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index df5107d7b3fd..02f7e852aad4 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -665,3 +665,42 @@ int sysfs_file_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
+
+/**
+ *	sysfs_change_owner - change owner of the given object.
+ *	@kobj:	object.
+ *	@kuid:	new owner's kuid
+ *	@kgid:	new owner's kgid
+ */
+int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
+{
+	int error;
+	const struct kobj_type *ktype;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	error = sysfs_file_change_owner(kobj, kuid, kgid);
+	if (error)
+		return error;
+
+	ktype = get_ktype(kobj);
+	if (ktype) {
+		struct attribute **kattr;
+
+		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
+			error = sysfs_file_change_owner_by_name(
+				kobj, (*kattr)->name, kuid, kgid);
+			if (error)
+				return error;
+		}
+
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
index 564a2e57b90a..fa1a37dd0f2b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -313,6 +313,7 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 int sysfs_file_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid);
 int sysfs_file_change_owner_by_name(struct kobject *kobj, const char *name,
 				    kuid_t kuid, kgid_t kgid);
+int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name, kuid_t kuid, kgid_t kgid);
 int sysfs_groups_change_owner(struct kobject *kobj,
@@ -555,6 +556,11 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
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
2.25.0

