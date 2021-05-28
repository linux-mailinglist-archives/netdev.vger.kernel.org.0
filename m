Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7B394204
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhE1Lly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 07:41:54 -0400
Received: from foss.arm.com ([217.140.110.172]:39654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhE1Llu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 07:41:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A0241516;
        Fri, 28 May 2021 04:40:16 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA0963F73B;
        Fri, 28 May 2021 04:40:09 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Jia He <justin.he@arm.com>
Subject: [PATCH RFCv2 1/3] fs: introduce helper d_path_fast()
Date:   Fri, 28 May 2021 19:39:49 +0800
Message-Id: <20210528113951.6225-2-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210528113951.6225-1-justin.he@arm.com>
References: <20210528113951.6225-1-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper is similar to d_path except that it doesn't take any
seqlock/spinlock. It is typical for debugging purpose.

Signed-off-by: Jia He <justin.he@arm.com>
---
 fs/d_path.c            | 21 +++++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/fs/d_path.c b/fs/d_path.c
index 23a53f7b5c71..f9df68d62786 100644
--- a/fs/d_path.c
+++ b/fs/d_path.c
@@ -263,6 +263,27 @@ char *d_path(const struct path *path, char *buf, int buflen)
 }
 EXPORT_SYMBOL(d_path);
 
+/**
+ * d_path_fast - fast return the full path of a dentry without taking
+ * any seqlock/spinlock. This helper is typical for debugging purpose
+ */
+char *d_path_fast(const struct path *path, char *buf, int buflen)
+{
+	struct path root;
+	struct mount *mnt = real_mount(path->mnt);
+	DECLARE_BUFFER(b, buf, buflen);
+
+	rcu_read_lock();
+	get_fs_root_rcu(current->fs, &root);
+
+	prepend(&b, "", 1);
+	__prepend_path(path->dentry, mnt, &root, &b);
+	rcu_read_unlock();
+
+	return extract_string(&b);
+}
+EXPORT_SYMBOL(d_path_fast);
+
 /*
  * Helper function for dentry_operations.d_dname() members
  */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 9e23d33bb6f1..c4483fc887a5 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -301,6 +301,7 @@ char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 extern char *__d_path(const struct path *, const struct path *, char *, int);
 extern char *d_absolute_path(const struct path *, char *, int);
 extern char *d_path(const struct path *, char *, int);
+extern char *d_path_fast(const struct path *, char *, int);
 extern char *dentry_path_raw(const struct dentry *, char *, int);
 extern char *dentry_path(const struct dentry *, char *, int);
 
-- 
2.17.1

