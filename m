Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBD01152C1
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLFOSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:18:46 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:10744 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfLFOSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:18:45 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47TvpC0WZXzKmMr;
        Fri,  6 Dec 2019 15:18:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id WqfzP5CzPiuv; Fri,  6 Dec 2019 15:18:39 +0100 (CET)
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
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Tycho Andersen <tycho@tycho.ws>,
        David Drysdale <drysdale@google.com>,
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
Subject: [PATCH v18 10/13] namei: LOOKUP_{IN_ROOT,BENEATH}: permit limited ".." resolution
Date:   Sat,  7 Dec 2019 01:13:35 +1100
Message-Id: <20191206141338.23338-11-cyphar@cyphar.com>
In-Reply-To: <20191206141338.23338-1-cyphar@cyphar.com>
References: <20191206141338.23338-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow LOOKUP_BENEATH and LOOKUP_IN_ROOT to safely permit ".." resolution
(in the case of LOOKUP_BENEATH the resolution will still fail if ".."
resolution would resolve a path outside of the root -- while
LOOKUP_IN_ROOT will chroot(2)-style scope it). Magic-link jumps are
still disallowed entirely[*].

As Jann explains[1,2], the need for this patch (and the original no-".."
restriction) is explained by observing there is a fairly easy-to-exploit
race condition with chroot(2) (and thus by extension LOOKUP_IN_ROOT and
LOOKUP_BENEATH if ".." is allowed) where a rename(2) of a path can be
used to "skip over" nd->root and thus escape to the filesystem above
nd->root.

  thread1 [attacker]:
    for (;;)
      renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
  thread2 [victim]:
    for (;;)
      openat2(dirb, "b/c/../../etc/shadow",
              { .flags = O_PATH, .resolve = RESOLVE_IN_ROOT } );

With fairly significant regularity, thread2 will resolve to
"/etc/shadow" rather than "/a/b/etc/shadow". There is also a similar
(though somewhat more privileged) attack using MS_MOVE.

With this patch, such cases will be detected *during* ".." resolution
and will return -EAGAIN for userspace to decide to either retry or abort
the lookup. It should be noted that ".." is the weak point of chroot(2)
-- walking *into* a subdirectory tautologically cannot result in you
walking *outside* nd->root (except through a bind-mount or magic-link).
There is also no other way for a directory's parent to change (which is
the primary worry with ".." resolution here) other than a rename or
MS_MOVE.

The primary reason for deferring to userspace with -EAGAIN is that an
in-kernel retry loop (or doing a path_is_under() check after re-taking
the relevant seqlocks) can become unreasonably expensive on machines
with lots of VFS activity (nfsd can cause lots of rename_lock updates).
Thus it should be up to userspace how many times they wish to retry the
lookup -- the selftests for this attack indicate that there is a ~35%
chance of the lookup succeeding on the first try even with an attacker
thrashing rename_lock.

A variant of the above attack is included in the selftests for
openat2(2) later in this patch series. I've run this test on several
machines for several days and no instances of a breakout were detected.
While this is not concrete proof that this is safe, when combined with
the above argument it should lend some trustworthiness to this
construction.

[*] It may be acceptable in the future to do a path_is_under() check for
    magic-links after they are resolved. However this seems unlikely to
    be a feature that people *really* need -- it can be added later if
    it turns out a lot of people want it.

[1]: https://lore.kernel.org/lkml/CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com/
[2]: https://lore.kernel.org/lkml/CAG48ez30WJhbsro2HOc_DR7V91M+hNFzBP5ogRMZaxbAORvqzg@mail.gmail.com/

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 69cd0b296e8e..9f60c3f49b8b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -491,7 +491,7 @@ struct nameidata {
 	struct path	root;
 	struct inode	*inode; /* path.dentry.d_inode */
 	unsigned int	flags;
-	unsigned	seq, m_seq;
+	unsigned	seq, m_seq, r_seq;
 	int		last_type;
 	unsigned	depth;
 	int		total_link_count;
@@ -1791,22 +1791,31 @@ static inline int handle_dots(struct nameidata *nd, int type)
 	if (type == LAST_DOTDOT) {
 		int error = 0;
 
-		/*
-		 * Scoped-lookup flags resolving ".." is not currently safe --
-		 * races can cause our parent to have moved outside of the root
-		 * and us to skip over it.
-		 */
-		if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
-			return -EXDEV;
 		if (!nd->root.mnt) {
 			error = set_root(nd);
 			if (error)
 				return error;
 		}
-		if (nd->flags & LOOKUP_RCU) {
-			return follow_dotdot_rcu(nd);
-		} else
-			return follow_dotdot(nd);
+		if (nd->flags & LOOKUP_RCU)
+			error = follow_dotdot_rcu(nd);
+		else
+			error = follow_dotdot(nd);
+		if (error)
+			return error;
+
+		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
+			/*
+			 * If there was a racing rename or mount along our
+			 * path, then we can't be sure that ".." hasn't jumped
+			 * above nd->root (and so userspace should retry or use
+			 * some fallback).
+			 */
+			smp_rmb();
+			if (unlikely(__read_seqcount_retry(&mount_lock.seqcount, nd->m_seq)))
+				return -EAGAIN;
+			if (unlikely(__read_seqcount_retry(&rename_lock.seqcount, nd->r_seq)))
+				return -EAGAIN;
+		}
 	}
 	return 0;
 }
@@ -2276,6 +2285,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags | LOOKUP_JUMPED | LOOKUP_PARENT;
 	nd->depth = 0;
+
+	nd->m_seq = __read_seqcount_begin(&mount_lock.seqcount);
+	nd->r_seq = __read_seqcount_begin(&rename_lock.seqcount);
+	smp_rmb();
+
 	if (flags & LOOKUP_ROOT) {
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
@@ -2284,9 +2298,8 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 		nd->path = nd->root;
 		nd->inode = inode;
 		if (flags & LOOKUP_RCU) {
-			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+			nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 			nd->root_seq = nd->seq;
-			nd->m_seq = read_seqbegin(&mount_lock);
 		} else {
 			path_get(&nd->path);
 		}
@@ -2297,8 +2310,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.mnt = NULL;
 	nd->path.dentry = NULL;
 
-	nd->m_seq = read_seqbegin(&mount_lock);
-
 	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
 	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {
 		error = nd_jump_root(nd);
-- 
2.24.0

