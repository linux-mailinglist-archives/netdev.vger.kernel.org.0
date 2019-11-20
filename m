Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE6103328
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 06:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfKTFKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 00:10:38 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:63836 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKTFKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 00:10:37 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47HrP64TqHzQlBC;
        Wed, 20 Nov 2019 06:10:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id oHTyYA8fVfQC; Wed, 20 Nov 2019 06:10:31 +0100 (CET)
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
Subject: [PATCH RESEND v17 07/13] namei: LOOKUP_NO_XDEV: block mountpoint crossing
Date:   Wed, 20 Nov 2019 16:06:25 +1100
Message-Id: <20191120050631.12816-8-cyphar@cyphar.com>
In-Reply-To: <20191120050631.12816-1-cyphar@cyphar.com>
References: <20191120050631.12816-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/* Background. */
The need to contain path operations within a mountpoint has been a
long-standing usecase that userspace has historically implemented
manually with liberal usage of stat(). find, rsync, tar and
many other programs implement these semantics -- but it'd be much
simpler to have a fool-proof way of refusing to open a path if it
crosses a mountpoint.

This is part of a refresh of Al's AT_NO_JUMPS patchset[1] (which was a
variation on David Drysdale's O_BENEATH patchset[2], which in turn was
based on the Capsicum project[3]).

/* Userspace API. */
LOOKUP_NO_XDEV will be exposed to userspace through openat2(2).

/* Semantics. */
Unlike most other LOOKUP flags (most notably LOOKUP_FOLLOW),
LOOKUP_NO_XDEV applies to all components of the path.

With LOOKUP_NO_XDEV, any path component which crosses a mount-point
during path resolution (including "..") will yield an -EXDEV. Absolute
paths, absolute symlinks, and magic-links will only yield an -EXDEV if
the jump involved changing mount-points.

/* Testing. */
LOOKUP_NO_XDEV is tested as part of the openat2(2) selftests.

[1]: https://lore.kernel.org/lkml/20170429220414.GT29622@ZenIV.linux.org.uk/
[2]: https://lore.kernel.org/lkml/1415094884-18349-1-git-send-email-drysdale@google.com/
[3]: https://lore.kernel.org/lkml/1404124096-21445-1-git-send-email-drysdale@google.com/

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: David Drysdale <drysdale@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c            | 31 +++++++++++++++++++++++++++----
 include/linux/namei.h |  1 +
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 415a897729c8..321c8ad5d6b3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -838,6 +838,11 @@ static inline void path_to_nameidata(const struct path *path,
 
 static int nd_jump_root(struct nameidata *nd)
 {
+	if (unlikely(nd->flags & LOOKUP_NO_XDEV)) {
+		/* Absolute path arguments to path_init() are allowed. */
+		if (nd->path.mnt != NULL && nd->path.mnt != nd->root.mnt)
+			return -EXDEV;
+	}
 	if (!nd->root.mnt) {
 		int error = set_root(nd);
 		if (error)
@@ -873,6 +878,12 @@ int nd_jump_link(struct path *path)
 	if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
 		goto err;
 
+	error = -EXDEV;
+	if (unlikely(nd->flags & LOOKUP_NO_XDEV)) {
+		if (nd->path.mnt != path->mnt)
+			goto err;
+	}
+
 	path_put(&nd->path);
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
@@ -1280,12 +1291,16 @@ static int follow_managed(struct path *path, struct nameidata *nd)
 		break;
 	}
 
-	if (need_mntput && path->mnt == mnt)
-		mntput(path->mnt);
+	if (need_mntput) {
+		if (path->mnt == mnt)
+			mntput(path->mnt);
+		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
+			ret = -EXDEV;
+		else
+			nd->flags |= LOOKUP_JUMPED;
+	}
 	if (ret == -EISDIR || !ret)
 		ret = 1;
-	if (need_mntput)
-		nd->flags |= LOOKUP_JUMPED;
 	if (unlikely(ret < 0))
 		path_put_conditional(path, nd);
 	return ret;
@@ -1342,6 +1357,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
+			return false;
 		path->mnt = &mounted->mnt;
 		path->dentry = mounted->mnt.mnt_root;
 		nd->flags |= LOOKUP_JUMPED;
@@ -1388,6 +1405,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 				return -ECHILD;
 			if (&mparent->mnt == nd->path.mnt)
 				break;
+			if (unlikely(nd->flags & LOOKUP_NO_XDEV))
+				return -ECHILD;
 			/* we know that mountpoint was pinned */
 			nd->path.dentry = mountpoint;
 			nd->path.mnt = &mparent->mnt;
@@ -1402,6 +1421,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			return -ECHILD;
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
+			return -ECHILD;
 		nd->path.mnt = &mounted->mnt;
 		nd->path.dentry = mounted->mnt.mnt_root;
 		inode = nd->path.dentry->d_inode;
@@ -1500,6 +1521,8 @@ static int follow_dotdot(struct nameidata *nd)
 		}
 		if (!follow_up(&nd->path))
 			break;
+		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
+			return -EXDEV;
 	}
 	follow_mount(&nd->path);
 	nd->inode = nd->path.dentry->d_inode;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 1573b8493d98..25ee88c4acb1 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -42,6 +42,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 /* Scoping flags for lookup. */
 #define LOOKUP_NO_SYMLINKS	0x010000 /* No symlink crossing. */
 #define LOOKUP_NO_MAGICLINKS	0x020000 /* No nd_jump_link() crossing. */
+#define LOOKUP_NO_XDEV		0x040000 /* No mountpoint crossing. */
 
 extern int path_pts(struct path *path);
 
-- 
2.24.0

