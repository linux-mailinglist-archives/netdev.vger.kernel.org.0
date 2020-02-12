Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB6C15A6C8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBLKo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:44:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52532 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgBLKnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:42 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1pUZ-0005aC-Je; Wed, 12 Feb 2020 10:43:39 +0000
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
Subject: [PATCH net-next 05/10] sysfs: add sysfs_change_owner()
Date:   Wed, 12 Feb 2020 11:43:16 +0100
Message-Id: <20200212104321.43570-6-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212104321.43570-1-christian.brauner@ubuntu.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
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
 fs/sysfs/file.c       | 35 +++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 6239d9584f0b..6a0fe88061fd 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -642,3 +642,38 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name)
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
+
+/**
+ *	sysfs_change_owner - change owner of the given object.
+ *	@kobj:	object.
+ */
+int sysfs_change_owner(struct kobject *kobj)
+{
+	int error;
+	const struct kobj_type *ktype;
+
+	if (!kobj->state_in_sysfs)
+		return -EINVAL;
+
+	error = sysfs_file_change_owner(kobj, NULL);
+	if (error)
+		return error;
+
+	ktype = get_ktype(kobj);
+	if (ktype) {
+		struct attribute **kattr;
+
+		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
+			error = sysfs_file_change_owner(kobj, (*kattr)->name);
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
index 3b9770c5ecb7..b9ce60261e38 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -310,6 +310,7 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 	return kernfs_enable_ns(kn);
 }
 
+int sysfs_change_owner(struct kobject *kobj);
 int sysfs_file_change_owner(struct kobject *kobj, const char *name);
 int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
 			    const char *name);
@@ -542,6 +543,11 @@ static inline int sysfs_link_change_owner(struct kobject *kobj,
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

