Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07B6103336
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 06:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfKTFLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 00:11:01 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:55274 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfKTFLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 00:11:01 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47HrPY61XvzKmbn;
        Wed, 20 Nov 2019 06:10:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id LPobd3j_w9W1; Wed, 20 Nov 2019 06:10:53 +0100 (CET)
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
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Drysdale <drysdale@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>,
        Chanho Min <chanho.min@lge.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Aleksa Sarai <asarai@suse.de>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-api@vger.kernel.org, libc-alpha@sourceware.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        sparclinux@vger.kernel.org
Subject: [PATCH RESEND v17 08/13] namei: LOOKUP_BENEATH: O_BENEATH-like scoped resolution
Date:   Wed, 20 Nov 2019 16:06:26 +1100
Message-Id: <20191120050631.12816-9-cyphar@cyphar.com>
In-Reply-To: <20191120050631.12816-1-cyphar@cyphar.com>
References: <20191120050631.12816-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/* Background. */
There are many circumstances when userspace wants to resolve a path and
ensure that it doesn't go outside of a particular root directory during
resolution. Obvious examples include archive extraction tools, as well as
other security-conscious userspace programs. FreeBSD spun out O_BENEATH
from their Capsicum project[1,2], so it also seems reasonable to
implement similar functionality for Linux.

This is part of a refresh of Al's AT_NO_JUMPS patchset[3] (which was a
variation on David Drysdale's O_BENEATH patchset[4], which in turn was
based on the Capsicum project[5]).

/* Userspace API. */
LOOKUP_BENEATH will be exposed to userspace through openat2(2).

/* Semantics. */
Unlike most other LOOKUP flags (most notably LOOKUP_FOLLOW),
LOOKUP_BENEATH applies to all components of the path.

With LOOKUP_BENEATH, any path component which attempts to "escape" the
starting point of the filesystem lookup (the dirfd passed to openat)
will yield -EXDEV. Thus, all absolute paths and symlinks are disallowed.

Due to a security concern brought up by Jann[6], any ".." path
components are also blocked. This restriction will be lifted in a future
patch, but requires more work to ensure that permitting ".." is done
safely.

Magic-link jumps are also blocked, because they can beam the path lookup
across the starting point. It would be possible to detect and block
only the "bad" crossings with path_is_under() checks, but it's unclear
whether it makes sense to permit magic-links at all. However, userspace
is recommended to pass LOOKUP_NO_MAGICLINKS if they want to ensure that
magic-link crossing is entirely disabled.

/* Testing. */
LOOKUP_BENEATH is tested as part of the openat2(2) selftests.

[1]: https://reviews.freebsd.org/D2808
[2]: https://reviews.freebsd.org/D17547
[3]: https://lore.kernel.org/lkml/20170429220414.GT29622@ZenIV.linux.org.uk/
[4]: https://lore.kernel.org/lkml/1415094884-18349-1-git-send-email-drysdale@google.com/
[5]: https://lore.kernel.org/lkml/1404124096-21445-1-git-send-email-drysdale@google.com/
[6]: https://lore.kernel.org/lkml/CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com/

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: David Drysdale <drysdale@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c            | 70 +++++++++++++++++++++++++++++++++++++++----
 include/linux/namei.h |  4 +++
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 321c8ad5d6b3..3f7bb22c375d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -641,6 +641,14 @@ static bool legitimize_links(struct nameidata *nd)
 
 static bool legitimize_root(struct nameidata *nd)
 {
+	/*
+	 * For scoped-lookups (where nd->root has been zeroed), we need to
+	 * restart the whole lookup from scratch -- because set_root() is wrong
+	 * for these lookups (nd->dfd is the root, not the filesystem root).
+	 */
+	if (!nd->root.mnt && (nd->flags & LOOKUP_IS_SCOPED))
+		return false;
+	/* Nothing to do if nd->root is zero or is managed by the VFS user. */
 	if (!nd->root.mnt || (nd->flags & LOOKUP_ROOT))
 		return true;
 	nd->flags |= LOOKUP_ROOT_GRABBED;
@@ -776,12 +784,27 @@ static int complete_walk(struct nameidata *nd)
 	int status;
 
 	if (nd->flags & LOOKUP_RCU) {
-		if (!(nd->flags & LOOKUP_ROOT))
+		/*
+		 * We don't want to zero nd->root for scoped-lookups or
+		 * externally-managed nd->root.
+		 */
+		if (!(nd->flags & (LOOKUP_ROOT | LOOKUP_IS_SCOPED)))
 			nd->root.mnt = NULL;
 		if (unlikely(unlazy_walk(nd)))
 			return -ECHILD;
 	}
 
+	if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
+		/*
+		 * Do a final check to ensure that the path didn't escape. Note
+		 * that this should already be guaranteed by all of the other
+		 * LOOKUP_IS_SCOPED checks (and delaying this check this late
+		 * does open the door to some possible timing-based attacks).
+		 */
+		if (WARN_ON(!path_is_under(&nd->path, &nd->root)))
+			return -EXDEV;
+	}
+
 	if (likely(!(nd->flags & LOOKUP_JUMPED)))
 		return 0;
 
@@ -802,6 +825,14 @@ static int set_root(struct nameidata *nd)
 {
 	struct fs_struct *fs = current->fs;
 
+	/*
+	 * Jumping to the real root in a scoped-lookup is a BUG in namei, but we
+	 * still have to ensure it doesn't happen because it will cause a breakout
+	 * from the dirfd.
+	 */
+	if (WARN_ON(nd->flags & LOOKUP_IS_SCOPED))
+		return -ENOTRECOVERABLE;
+
 	if (nd->flags & LOOKUP_RCU) {
 		unsigned seq;
 
@@ -838,6 +869,8 @@ static inline void path_to_nameidata(const struct path *path,
 
 static int nd_jump_root(struct nameidata *nd)
 {
+	if (unlikely(nd->flags & LOOKUP_BENEATH))
+		return -EXDEV;
 	if (unlikely(nd->flags & LOOKUP_NO_XDEV)) {
 		/* Absolute path arguments to path_init() are allowed. */
 		if (nd->path.mnt != NULL && nd->path.mnt != nd->root.mnt)
@@ -883,6 +916,9 @@ int nd_jump_link(struct path *path)
 		if (nd->path.mnt != path->mnt)
 			goto err;
 	}
+	/* Not currently safe for scoped-lookups. */
+	if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
+		goto err;
 
 	path_put(&nd->path);
 	nd->path = *path;
@@ -1379,8 +1415,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 	struct inode *inode = nd->inode;
 
 	while (1) {
-		if (path_equal(&nd->path, &nd->root))
+		if (path_equal(&nd->path, &nd->root)) {
+			if (unlikely(nd->flags & LOOKUP_BENEATH))
+				return -ECHILD;
 			break;
+		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			struct dentry *old = nd->path.dentry;
 			struct dentry *parent = old->d_parent;
@@ -1510,9 +1549,12 @@ static int path_parent_directory(struct path *path)
 
 static int follow_dotdot(struct nameidata *nd)
 {
-	while(1) {
-		if (path_equal(&nd->path, &nd->root))
+	while (1) {
+		if (path_equal(&nd->path, &nd->root)) {
+			if (unlikely(nd->flags & LOOKUP_BENEATH))
+				return -EXDEV;
 			break;
+		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			int ret = path_parent_directory(&nd->path);
 			if (ret)
@@ -1739,6 +1781,13 @@ static inline int handle_dots(struct nameidata *nd, int type)
 	if (type == LAST_DOTDOT) {
 		int error = 0;
 
+		/*
+		 * Scoped-lookup flags resolving ".." is not currently safe --
+		 * races can cause our parent to have moved outside of the root
+		 * and us to skip over it.
+		 */
+		if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
+			return -EXDEV;
 		if (!nd->root.mnt) {
 			error = set_root(nd);
 			if (error)
@@ -2261,7 +2310,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			get_fs_pwd(current->fs, &nd->path);
 			nd->inode = nd->path.dentry->d_inode;
 		}
-		return s;
 	} else {
 		/* Caller must check execute permissions on the starting path component */
 		struct fd f = fdget_raw(nd->dfd);
@@ -2286,8 +2334,18 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			nd->inode = nd->path.dentry->d_inode;
 		}
 		fdput(f);
-		return s;
 	}
+	/* For scoped-lookups we need to set the root to the dirfd as well. */
+	if (flags & LOOKUP_IS_SCOPED) {
+		nd->root = nd->path;
+		if (flags & LOOKUP_RCU) {
+			nd->root_seq = nd->seq;
+		} else {
+			path_get(&nd->root);
+			nd->flags |= LOOKUP_ROOT_GRABBED;
+		}
+	}
+	return s;
 }
 
 static const char *trailing_symlink(struct nameidata *nd)
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 25ee88c4acb1..93dad378f1e8 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_NAMEI_H
 #define _LINUX_NAMEI_H
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/path.h>
 #include <linux/fcntl.h>
@@ -43,6 +44,9 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_NO_SYMLINKS	0x010000 /* No symlink crossing. */
 #define LOOKUP_NO_MAGICLINKS	0x020000 /* No nd_jump_link() crossing. */
 #define LOOKUP_NO_XDEV		0x040000 /* No mountpoint crossing. */
+#define LOOKUP_BENEATH		0x080000 /* No escaping from starting point. */
+/* LOOKUP_* flags which do scope-related checks based on the dirfd. */
+#define LOOKUP_IS_SCOPED LOOKUP_BENEATH
 
 extern int path_pts(struct path *path);
 
-- 
2.24.0

