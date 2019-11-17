Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD46FF66E
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 02:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfKQBT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 20:19:29 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:21088 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfKQBT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 20:19:29 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 47FvPp6Z8yzQl9V;
        Sun, 17 Nov 2019 02:19:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 6iL4vYCY4kFH; Sun, 17 Nov 2019 02:19:23 +0100 (CET)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>,
        David Drysdale <drysdale@google.com>,
        Chanho Min <chanho.min@lge.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Aleksa Sarai <asarai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dev@opencontainers.org, containers@lists.linux-foundation.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, sparclinux@vger.kernel.org
Subject: [PATCH v17 03/13] namei: allow nd_jump_link() to produce errors
Date:   Sun, 17 Nov 2019 12:17:03 +1100
Message-Id: <20191117011713.13032-4-cyphar@cyphar.com>
In-Reply-To: <20191117011713.13032-1-cyphar@cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for LOOKUP_NO_MAGICLINKS, it's necessary to add the
ability for nd_jump_link() to return an error which the corresponding
get_link() caller must propogate back up to the VFS.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c                     |  3 ++-
 fs/proc/base.c                 |  3 +--
 fs/proc/namespaces.c           | 14 +++++++++-----
 include/linux/namei.h          |  2 +-
 security/apparmor/apparmorfs.c |  6 ++++--
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5a47d9c09581..1024a641f075 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -859,7 +859,7 @@ static int nd_jump_root(struct nameidata *nd)
  * Helper to directly jump to a known parsed path from ->get_link,
  * caller must have taken a reference to path beforehand.
  */
-void nd_jump_link(struct path *path)
+int nd_jump_link(struct path *path)
 {
 	struct nameidata *nd = current->nameidata;
 	path_put(&nd->path);
@@ -867,6 +867,7 @@ void nd_jump_link(struct path *path)
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }
 
 static inline void put_link(struct nameidata *nd)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb8..ee97dd322f3e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1626,8 +1626,7 @@ static const char *proc_pid_get_link(struct dentry *dentry,
 	if (error)
 		goto out;
 
-	nd_jump_link(&path);
-	return NULL;
+	error = nd_jump_link(&path);
 out:
 	return ERR_PTR(error);
 }
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 08dd94df1a66..a8cca516f1a9 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -51,11 +51,15 @@ static const char *proc_ns_get_link(struct dentry *dentry,
 	if (!task)
 		return ERR_PTR(-EACCES);
 
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
-		error = ns_get_path(&ns_path, task, ns_ops);
-		if (!error)
-			nd_jump_link(&ns_path);
-	}
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		goto out;
+
+	error = ns_get_path(&ns_path, task, ns_ops);
+	if (error)
+		goto out;
+
+	error = nd_jump_link(&ns_path);
+out:
 	put_task_struct(task);
 	return ERR_PTR(error);
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 397a08ade6a2..758e9b47db6f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -68,7 +68,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
-extern void nd_jump_link(struct path *path);
+extern int __must_check nd_jump_link(struct path *path);
 
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 45d13b6462aa..0b7d6dce6291 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2455,16 +2455,18 @@ static const char *policy_get_link(struct dentry *dentry,
 {
 	struct aa_ns *ns;
 	struct path path;
+	int error;
 
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
+
 	ns = aa_get_current_ns();
 	path.mnt = mntget(aafs_mnt);
 	path.dentry = dget(ns_dir(ns));
-	nd_jump_link(&path);
+	error = nd_jump_link(&path);
 	aa_put_ns(ns);
 
-	return NULL;
+	return ERR_PTR(error);
 }
 
 static int policy_readlink(struct dentry *dentry, char __user *buffer,
-- 
2.24.0

