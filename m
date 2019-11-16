Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092EEFE9D3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 01:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfKPAky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 19:40:54 -0500
Received: from mout-p-202.mailbox.org ([80.241.56.172]:29578 "EHLO
        mout-p-202.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfKPAky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 19:40:54 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 47FGMx63LyzQlBT;
        Sat, 16 Nov 2019 01:30:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id OCALM-48ZDSp; Sat, 16 Nov 2019 01:30:34 +0100 (CET)
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
        Andrii Nakryiko <andriin@fb.com>
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
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, sparclinux@vger.kernel.org
Subject: [PATCH v16 05/12] namei: LOOKUP_NO_MAGICLINKS: block magic-link resolution
Date:   Sat, 16 Nov 2019 11:27:55 +1100
Message-Id: <20191116002802.6663-6-cyphar@cyphar.com>
In-Reply-To: <20191116002802.6663-1-cyphar@cyphar.com>
References: <20191116002802.6663-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/* Background. */
There has always been a special class of symlink-like objects in procfs
(and a few other pseudo-filesystems) which allow for non-lexical
resolution of paths using nd_jump_link(). These "magic-links" do not
follow traditional mount namespace boundaries, and have been used
consistently in container escape attacks because they can be used to
trick unsuspecting privileged processes into resolving unexpected paths.

It is also non-trivial for userspace to unambiguously avoid resolving
magic-links, because they do not have a reliable indication that they
are a magic-link (in order to verify them you'd have to manually open
the path given by readlink(2) and then verify that the two file
descriptors reference the same underlying file, which is plagued with
possible race conditions or supplementary attack scenarios).

It would therefore be very helpful for userspace to be able to avoid
these symlinks easily, thus hopefully removing a tool from attackers'
toolboxes.

This is part of a refresh of Al's AT_NO_JUMPS patchset[1] (which was a
variation on David Drysdale's O_BENEATH patchset[2], which in turn was
based on the Capsicum project[3]).

/* Userspace API. */
LOOKUP_NO_MAGICLINKS will be exposed to userspace through openat2(2).

/* Semantics. */
Unlike most other LOOKUP flags (most notably LOOKUP_FOLLOW),
LOOKUP_NO_MAGICLINKS applies to all components of the path.

With LOOKUP_NO_MAGICLINKS, any magic-link path component encountered
during path resolution will yield -ELOOP. The handling of ~LOOKUP_FOLLOW
for a trailing magic-link is identical to LOOKUP_NO_SYMLINKS.

LOOKUP_NO_SYMLINKS implies LOOKUP_NO_MAGICLINKS.

/* Testing. */
LOOKUP_NO_MAGICLINKS is tested as part of the openat2(2) selftests.

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
 fs/namei.c            | 5 ++++-
 include/linux/namei.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 14d6d3afb9d3..a97facc232af 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -868,8 +868,11 @@ static int nd_jump_root(struct nameidata *nd)
 int nd_jump_link(struct path *path)
 {
 	struct nameidata *nd = current->nameidata;
-	path_put(&nd->path);
 
+	if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
+		return -ELOOP;
+
+	path_put(&nd->path);
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 0d86e75c04a7..1573b8493d98 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -41,6 +41,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
 /* Scoping flags for lookup. */
 #define LOOKUP_NO_SYMLINKS	0x010000 /* No symlink crossing. */
+#define LOOKUP_NO_MAGICLINKS	0x020000 /* No nd_jump_link() crossing. */
 
 extern int path_pts(struct path *path);
 
-- 
2.24.0

