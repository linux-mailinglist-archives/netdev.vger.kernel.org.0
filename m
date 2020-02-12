Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FE715A6CC
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBLKnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:43:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52527 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgBLKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:40 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1pUZ-0005aC-0p; Wed, 12 Feb 2020 10:43:39 +0000
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
Subject: [PATCH net-next 04/10] sysfs: add sysfs_groups_change_owner()
Date:   Wed, 12 Feb 2020 11:43:15 +0100
Message-Id: <20200212104321.43570-5-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212104321.43570-1-christian.brauner@ubuntu.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
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
 fs/sysfs/group.c      | 28 ++++++++++++++++++++++++++++
 include/linux/sysfs.h |  8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 34b702ec9782..4c9de5d972bd 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -542,3 +542,31 @@ int sysfs_group_change_owner(struct kobject *kobj,
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_group_change_owner);
+
+/**
+ * sysfs_groups_change_owner - change owner of a set of attribute groups.
+ * @kobj:	The kobject containing the groups.
+ * @groups:	The attribute groups.
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
index 9363c61b9349..3b9770c5ecb7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -313,6 +313,8 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 int sysfs_file_change_owner(struct kobject *kobj, const char *name);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
+int sysfs_groups_change_owner(struct kobject *kobj,
+			      const struct attribute_group **groups);
 int sysfs_group_change_owner(struct kobject *kobj,
 			     const struct attribute_group *groups);
 
@@ -540,6 +542,12 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
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

