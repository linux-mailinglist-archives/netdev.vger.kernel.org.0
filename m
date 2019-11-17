Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5207FF70F
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 02:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfKQB3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 20:29:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:46170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725308AbfKQB3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 20:29:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1776CAB89;
        Sun, 17 Nov 2019 01:29:27 +0000 (UTC)
Date:   Sun, 17 Nov 2019 12:28:58 +1100
From:   Aleksa Sarai <asarai@suse.de>
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
Subject: [PATCH v17 13/13] Documentation: path-lookup: include new LOOKUP
 flags
Message-ID: <20191117012858.47t7zd3pbdlqz2mv@yavin.dot.cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117011713.13032-1-cyphar@cyphar.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have new LOOKUP flags, we should document them in the
relevant path-walking documentation. And now that we've settled on a
common name for nd_jump_link() style symlinks ("magic links"), use that
term where magic-link semantics are described.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 Documentation/filesystems/path-lookup.rst | 68 +++++++++++++++++++++--
 1 file changed, 62 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/path-lookup.rst b/Documentation/filesystems/path-lookup.rst
index 434a07b0002b..a3216979298b 100644
--- a/Documentation/filesystems/path-lookup.rst
+++ b/Documentation/filesystems/path-lookup.rst
@@ -13,6 +13,7 @@ It has subsequently been updated to reflect changes in the kernel
 including:
 
 - per-directory parallel name lookup.
+- ``openat2()`` resolution restriction flags.
 
 Introduction to pathname lookup
 ===============================
@@ -235,6 +236,13 @@ renamed.  If ``d_lookup`` finds that a rename happened while it
 unsuccessfully scanned a chain in the hash table, it simply tries
 again.
 
+``rename_lock`` is also used to detect and defend against potential attacks
+against ``LOOKUP_BENEATH`` and ``LOOKUP_IN_ROOT`` when resolving ".." (where
+the parent directory is moved outside the root, bypassing the ``path_equal()``
+check). If ``rename_lock`` is updated during the lookup and the path encounters
+a "..", a potential attack occurred and ``handle_dots()`` will bail out with
+``-EAGAIN``.
+
 inode->i_rwsem
 ~~~~~~~~~~~~~~
 
@@ -348,6 +356,13 @@ any changes to any mount points while stepping up.  This locking is
 needed to stabilize the link to the mounted-on dentry, which the
 refcount on the mount itself doesn't ensure.
 
+``mount_lock`` is also used to detect and defend against potential attacks
+against ``LOOKUP_BENEATH`` and ``LOOKUP_IN_ROOT`` when resolving ".." (where
+the parent directory is moved outside the root, bypassing the ``path_equal()``
+check). If ``mount_lock`` is updated during the lookup and the path encounters
+a "..", a potential attack occurred and ``handle_dots()`` will bail out with
+``-EAGAIN``.
+
 RCU
 ~~~
 
@@ -405,6 +420,10 @@ is requested.  Keeping a reference in the ``nameidata`` ensures that
 only one root is in effect for the entire path walk, even if it races
 with a ``chroot()`` system call.
 
+It should be noted that in the case of ``LOOKUP_IN_ROOT`` or
+``LOOKUP_BENEATH``, the effective root becomes the directory file descriptor
+passed to ``openat2()`` (which exposes these ``LOOKUP_`` flags).
+
 The root is needed when either of two conditions holds: (1) either the
 pathname or a symbolic link starts with a "'/'", or (2) a "``..``"
 component is being handled, since "``..``" from the root must always stay
@@ -1149,7 +1168,7 @@ so ``NULL`` is returned to indicate that the symlink can be released and
 the stack frame discarded.
 
 The other case involves things in ``/proc`` that look like symlinks but
-aren't really::
+aren't really (and are therefore commonly referred to as "magic-links")::
 
      $ ls -l /proc/self/fd/1
      lrwx------ 1 neilb neilb 64 Jun 13 10:19 /proc/self/fd/1 -> /dev/pts/4
@@ -1286,7 +1305,9 @@ A few flags
 A suitable way to wrap up this tour of pathname walking is to list
 the various flags that can be stored in the ``nameidata`` to guide the
 lookup process.  Many of these are only meaningful on the final
-component, others reflect the current state of the pathname lookup.
+component, others reflect the current state of the pathname lookup, and some
+apply restrictions to all path components encountered in the path lookup.
+
 And then there is ``LOOKUP_EMPTY``, which doesn't fit conceptually with
 the others.  If this is not set, an empty pathname causes an error
 very early on.  If it is set, empty pathnames are not considered to be
@@ -1310,13 +1331,48 @@ longer needed.
 ``LOOKUP_JUMPED`` means that the current dentry was chosen not because
 it had the right name but for some other reason.  This happens when
 following "``..``", following a symlink to ``/``, crossing a mount point
-or accessing a "``/proc/$PID/fd/$FD``" symlink.  In this case the
-filesystem has not been asked to revalidate the name (with
-``d_revalidate()``).  In such cases the inode may still need to be
-revalidated, so ``d_op->d_weak_revalidate()`` is called if
+or accessing a "``/proc/$PID/fd/$FD``" symlink (also known as a "magic
+link"). In this case the filesystem has not been asked to revalidate the
+name (with ``d_revalidate()``).  In such cases the inode may still need
+to be revalidated, so ``d_op->d_weak_revalidate()`` is called if
 ``LOOKUP_JUMPED`` is set when the look completes - which may be at the
 final component or, when creating, unlinking, or renaming, at the penultimate component.
 
+Resolution-restriction flags
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+In order to allow userspace to protect itself against certain race conditions
+and attack scenarios involving changing path components, a series of flags are
+available which apply restrictions to all path components encountered during
+path lookup. These flags are exposed through ``openat2()``'s ``resolve`` field.
+
+``LOOKUP_NO_SYMLINKS`` blocks all symlink traversals (including magic-links).
+This is distinctly different from ``LOOKUP_FOLLOW``, because the latter only
+relates to restricting the following of trailing symlinks.
+
+``LOOKUP_NO_MAGICLINKS`` blocks all magic-link traversals. Filesystems must
+ensure that they return errors from ``nd_jump_link()``, because that is how
+``LOOKUP_NO_MAGICLINKS`` and other magic-link restrictions are implemented.
+
+``LOOKUP_NO_XDEV`` blocks all ``vfsmount`` traversals (this includes both
+bind-mounts and ordinary mounts). Note that the ``vfsmount`` which contains the
+lookup is determined by the first mountpoint the path lookup reaches --
+absolute paths start with the ``vfsmount`` of ``/``, and relative paths start
+with the ``dfd``'s ``vfsmount``. Magic-links are only permitted if the
+``vfsmount`` of the path is unchanged.
+
+``LOOKUP_BENEATH`` blocks any path components which resolve outside the
+starting point of the resolution. This is done by blocking ``nd_jump_root()``
+as well as blocking ".." if it would jump outside the starting point.
+``rename_lock`` and ``mount_lock`` are used to detect attacks against the
+resolution of "..". Magic-links are also blocked.
+
+``LOOKUP_IN_ROOT`` resolves all path components as though the starting point
+were the filesystem root. ``nd_jump_root()`` brings the resolution back to to
+the starting point, and ".." at the starting point will act as a no-op. As with
+``LOOKUP_BENEATH``, ``rename_lock`` and ``mount_lock`` are used to detect
+attacks against ".." resolution. Magic-links are also blocked.
+
 Final-component flags
 ~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.24.0

