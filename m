Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53C715A6BB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBLKnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:43:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52521 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgBLKnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:43:40 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1pUX-0005aC-Qo; Wed, 12 Feb 2020 10:43:37 +0000
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
Subject: [PATCH net-next 02/10] sysfs: add sysfs_link_change_owner()
Date:   Wed, 12 Feb 2020 11:43:13 +0100
Message-Id: <20200212104321.43570-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212104321.43570-1-christian.brauner@ubuntu.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
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
 fs/sysfs/file.c       | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |  9 +++++++++
 2 files changed, 47 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 007b97ca8165..6239d9584f0b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -574,6 +574,44 @@ static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj)
 	return kernfs_setattr(kn, &newattrs);
 }
 
+/**
+ *	sysfs_link_change_owner - change owner of a link.
+ *	@kobj:	object of the kernfs_node the symlink is located in.
+ *	@targ:	object of the kernfs_node the symlink points to.
+ *	@name:	name of the link.
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
  *	sysfs_file_change_owner - change owner of a file.
  *	@kobj:	object.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 58fa71d47c7f..4e10085739b7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -311,6 +311,8 @@ static inline void sysfs_enable_ns(struct kernfs_node *kn)
 }
 
 int sysfs_file_change_owner(struct kobject *kobj, const char *name);
+int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
+			    const char *name);
 
 #else /* CONFIG_SYSFS */
 
@@ -529,6 +531,13 @@ static inline int sysfs_file_change_owner(struct kobject *kobj, const char *name
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

