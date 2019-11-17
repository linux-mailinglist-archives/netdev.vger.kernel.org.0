Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63119FF644
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 02:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfKQBSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 20:18:21 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:32354 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfKQBSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 20:18:21 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47FvNQ63YYzKmTQ;
        Sun, 17 Nov 2019 02:18:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id YNUmLeIS7BG1; Sun, 17 Nov 2019 02:18:09 +0100 (CET)
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
Subject: [PATCH v17 00/13] open: introduce openat2(2) syscall
Date:   Sun, 17 Nov 2019 12:17:00 +1100
Message-Id: <20191117011713.13032-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is being developed here:
  <https://github.com/cyphar/linux/tree/openat2/master>

Patch changelog:
 v17:
  * Add a path_is_under() check for LOOKUP_IS_SCOPED in complete_walk(), as a
    last line of defence to ensure that namei bugs will not break the contract
    of LOOKUP_BENEATH or LOOKUP_IN_ROOT.
  * Update based on feedback by Al Viro:
    * Make nd_jump_link() free the passed path on error, so that callers don't
      need to worry about it in the error path.
    * Remove needless m_retry and r_retry variables in handle_dots().
    * Always return -ECHILD from follow_dotdot_rcu().
 v16: <https://lore.kernel.org/lkml/20191116002802.6663-1-cyphar@cyphar.com/>
 v15: <https://lore.kernel.org/lkml/20191105090553.6350-1-cyphar@cyphar.com/>
 v14: <https://lore.kernel.org/lkml/20191010054140.8483-1-cyphar@cyphar.com/>
      <https://lore.kernel.org/lkml/20191026185700.10708-1-cyphar@cyphar.com>
 v13: <https://lore.kernel.org/lkml/20190930183316.10190-1-cyphar@cyphar.com/>
 v12: <https://lore.kernel.org/lkml/20190904201933.10736-1-cyphar@cyphar.com/>
 v11: <https://lore.kernel.org/lkml/20190820033406.29796-1-cyphar@cyphar.com/>
      <https://lore.kernel.org/lkml/20190728010207.9781-1-cyphar@cyphar.com/>
 v10: <https://lore.kernel.org/lkml/20190719164225.27083-1-cyphar@cyphar.com/>
 v09: <https://lore.kernel.org/lkml/20190706145737.5299-1-cyphar@cyphar.com/>
 v08: <https://lore.kernel.org/lkml/20190520133305.11925-1-cyphar@cyphar.com/>
 v07: <https://lore.kernel.org/lkml/20190507164317.13562-1-cyphar@cyphar.com/>
 v06: <https://lore.kernel.org/lkml/20190506165439.9155-1-cyphar@cyphar.com/>
 v05: <https://lore.kernel.org/lkml/20190320143717.2523-1-cyphar@cyphar.com/>
 v04: <https://lore.kernel.org/lkml/20181112142654.341-1-cyphar@cyphar.com/>
 v03: <https://lore.kernel.org/lkml/20181009070230.12884-1-cyphar@cyphar.com/>
 v02: <https://lore.kernel.org/lkml/20181009065300.11053-1-cyphar@cyphar.com/>
 v01: <https://lore.kernel.org/lkml/20180929103453.12025-1-cyphar@cyphar.com/>

For a very long time, extending openat(2) with new features has been
incredibly frustrating. This stems from the fact that openat(2) is
possibly the most famous counter-example to the mantra "don't silently
accept garbage from userspace" -- it doesn't check whether unknown flags
are present[1].

This means that (generally) the addition of new flags to openat(2) has
been fraught with backwards-compatibility issues (O_TMPFILE has to be
defined as __O_TMPFILE|O_DIRECTORY|[O_RDWR or O_WRONLY] to ensure old
kernels gave errors, since it's insecure to silently ignore the
flag[2]). All new security-related flags therefore have a tough road to
being added to openat(2).

Furthermore, the need for some sort of control over VFS's path resolution (to
avoid malicious paths resulting in inadvertent breakouts) has been a very
long-standing desire of many userspace applications. This patchset is a revival
of Al Viro's old AT_NO_JUMPS[3] patchset (which was a variant of David
Drysdale's O_BENEATH patchset[4] which was a spin-off of the Capsicum
project[5]) with a few additions and changes made based on the previous
discussion within [6] as well as others I felt were useful.

In line with the conclusions of the original discussion of AT_NO_JUMPS, the
flag has been split up into separate flags. However, instead of being an
openat(2) flag it is provided through a new syscall openat2(2) which provides
several other improvements to the openat(2) interface (see the patch
description for more details). The following new LOOKUP_* flags are added:

  * LOOKUP_NO_XDEV blocks all mountpoint crossings (upwards, downwards,
    or through absolute links). Absolute pathnames alone in openat(2) do not
    trigger this. Magic-link traversal which implies a vfsmount jump is also
    blocked (though magic-link jumps on the same vfsmount are permitted).

  * LOOKUP_NO_MAGICLINKS blocks resolution through /proc/$pid/fd-style
    links. This is done by blocking the usage of nd_jump_link() during
    resolution in a filesystem. The term "magic-links" is used to match
    with the only reference to these links in Documentation/, but I'm
    happy to change the name.

    It should be noted that this is different to the scope of
    ~LOOKUP_FOLLOW in that it applies to all path components. However,
    you can do openat2(NO_FOLLOW|NO_MAGICLINKS) on a magic-link and it
    will *not* fail (assuming that no parent component was a
    magic-link), and you will have an fd for the magic-link.

    In order to correctly detect magic-links, the introduction of a new
    LOOKUP_MAGICLINK_JUMPED state flag was required.

  * LOOKUP_BENEATH disallows escapes to outside the starting dirfd's
    tree, using techniques such as ".." or absolute links. Absolute
    paths in openat(2) are also disallowed. Conceptually this flag is to
    ensure you "stay below" a certain point in the filesystem tree --
    but this requires some additional to protect against various races
    that would allow escape using "..".

    Currently LOOKUP_BENEATH implies LOOKUP_NO_MAGICLINKS, because it
    can trivially beam you around the filesystem (breaking the
    protection). In future, there might be similar safety checks done as
    in LOOKUP_IN_ROOT, but that requires more discussion.

In addition, two new flags are added that expand on the above ideas:

  * LOOKUP_NO_SYMLINKS does what it says on the tin. No symlink
    resolution is allowed at all, including magic-links. Just as with
    LOOKUP_NO_MAGICLINKS this can still be used with NOFOLLOW to open an
    fd for the symlink as long as no parent path had a symlink
    component.

  * LOOKUP_IN_ROOT is an extension of LOOKUP_BENEATH that, rather than
    blocking attempts to move past the root, forces all such movements
    to be scoped to the starting point. This provides chroot(2)-like
    protection but without the cost of a chroot(2) for each filesystem
    operation, as well as being safe against race attacks that chroot(2)
    is not.

    If a race is detected (as with LOOKUP_BENEATH) then an error is
    generated, and similar to LOOKUP_BENEATH it is not permitted to cross
    magic-links with LOOKUP_IN_ROOT.

    The primary need for this is from container runtimes, which
    currently need to do symlink scoping in userspace[7] when opening
    paths in a potentially malicious container. There is a long list of
    CVEs that could have bene mitigated by having RESOLVE_THIS_ROOT
    (such as CVE-2017-1002101, CVE-2017-1002102, CVE-2018-15664, and
    CVE-2019-5736, just to name a few).

In order to make all of the above more usable, I'm working on
libpathrs[8] which is a C-friendly library for safe path resolution. It
features a userspace-emulated backend if the kernel doesn't support
openat2(2). Hopefully we can get userspace to switch to using it, and
thus get openat2(2) support for free once it's ready.

Future work would include implementing things like RESOLVE_NO_AUTOMOUNT and
possibly a RESOLVE_NO_REMOTE (to allow programs to be sure they don't hit DoSes
though stale NFS handles).

[1]: https://lwn.net/Articles/588444/
[2]: https://lore.kernel.org/lkml/CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com
[3]: https://lore.kernel.org/lkml/20170429220414.GT29622@ZenIV.linux.org.uk
[4]: https://lore.kernel.org/lkml/1415094884-18349-1-git-send-email-drysdale@google.com
[5]: https://lore.kernel.org/lkml/1404124096-21445-1-git-send-email-drysdale@google.com
[6]: https://lwn.net/Articles/723057/
[7]: https://github.com/cyphar/filepath-securejoin
[8]: https://github.com/openSUSE/libpathrs

The current draft of the openat2(2) man-page is included below.

--8<---------------------------------------------------------------------------
OPENAT2(2)                          Linux Programmer's Manual                          OPENAT2(2)

NAME
       openat2 - open and possibly create a file (extended)

SYNOPSIS
       #include <sys/types.h>
       #include <sys/stat.h>
       #include <fcntl.h>

       int openat2(int dirfd, const char *pathname, struct open_how *how, size_t size);

       Note: There is no glibc wrapper for this system call; see NOTES.

DESCRIPTION
       The  openat2()  system  call  opens the file specified by pathname.  If the specified file
       does not exist, it may optionally (if O_CREAT is specified in  how.flags)  be  created  by
       openat2().

       As  with openat(2), if pathname is relative, then it is interpreted relative to the direc-
       tory referred to by the file descriptor dirfd (or the current  working  directory  of  the
       calling  process,  if dirfd is the special value AT_FDCWD.)  If pathname is absolute, then
       dirfd is ignored (unless how.resolve contains RESOLVE_IN_ROOT, in which case  pathname  is
       resolved relative to dirfd.)

       The  openat2()  system  call  is  an extension of openat(2) and provides a superset of its
       functionality.  Rather than taking a single flag argument, an extensible  structure  (how)
       is  passed  instead  to  allow  for  future extensions.  size must be set to sizeof(struct
       open_how), to facilitate future extensions (see the "Extensibility" section of  the  NOTES
       for more detail on how extensions are handled.)

   The open_how structure
       The following structure indicates how pathname should be opened, and acts as a superset of
       the flag and mode arguments to openat(2).

           struct open_how {
               __aligned_u64 flags;         /* O_* flags. */
               __u16         mode;          /* Mode for O_{CREAT,TMPFILE}. */
               __u16         __padding[3];  /* Must be zeroed. */
               __aligned_u64 resolve;       /* RESOLVE_* flags. */
           };

       Any future extensions to openat2() will be implemented as new fields appended to the above
       structure (or through reuse of pre-existing padding space), with the zero value of the new
       fields acting as though the extension were not present.

       The meaning of each field is as follows:

              flags
                     The file creation and status flags to use for this operation.   All  of  the
                     O_* flags defined for openat(2) are valid openat2() flag values.

                     Unlike openat(2), it is an error to provide openat2() unknown or conflicting
                     flags in flags.

              mode
                     File mode for the new file, with identical semantics to the mode argument to
                     openat(2).   However,  unlike openat(2), it is an error to provide openat2()
                     with a mode which contains bits other than 0777.

                     It is an error to provide openat2() a non-zero mode if flags does  not  con-
                     tain O_CREAT or O_TMPFILE.

              resolve
                     Change  how  the  components  of pathname will be resolved (see path_resolu-
                     tion(7) for background information.)  The primary use case for  these  flags
                     is  to  allow trusted programs to restrict how untrusted paths (or paths in-
                     side untrusted directories) are resolved.  The full list of resolve flags is
                     given below.

                     RESOLVE_NO_XDEV
                            Disallow  traversal of mount points during path resolution (including
                            all bind mounts).

                            Users of this flag are encouraged to make its use  configurable  (un-
                            less  it is used for a specific security purpose), as bind mounts are
                            very widely used by end-users.  Setting this flag indiscrimnately for
                            all  uses  of  openat2() may result in spurious errors on previously-
                            functional systems.

                     RESOLVE_NO_SYMLINKS
                            Disallow resolution of symbolic links during path  resolution.   This
                            option implies RESOLVE_NO_MAGICLINKS.

                            If the trailing component is a symbolic link, and flags contains both
                            O_PATH and O_NOFOLLOW, then an O_PATH file descriptor referencing the
                            symbolic link will be returned.

                            Users  of  this flag are encouraged to make its use configurable (un-
                            less it is used for a specific security purpose), as  symbolic  links
                            are very widely used by end-users.  Setting this flag indiscrimnately
                            for all uses of openat2() may result in  spurious  errors  on  previ-
                            ously-functional systems.

                     RESOLVE_NO_MAGICLINKS
                            Disallow all magic link resolution during path resolution.

                            If  the  trailing  component is a magic link, and flags contains both
                            O_PATH and O_NOFOLLOW, then an O_PATH file descriptor referencing the
                            magic link will be returned.

                            Magic-links  are  symbolic  link-like  objects  that are most notably
                            found   in   proc(5)   (examples    include    /proc/[pid]/exe    and
                            /proc/[pid]/fd/*.)   Due to the potential danger of unknowingly open-
                            ing these magic links, it may be  preferable  for  users  to  disable
                            their resolution entirely (see symboliclink(7) for more details.)

                     RESOLVE_BENEATH
                            Do  not permit the path resolution to succeed if any component of the
                            resolution is not a descendant of the directory indicated  by  dirfd.
                            This results in absolute symbolic links (and absolute values of path-
                            name) to be rejected.

                            Currently, this flag also disables magic link  resolution.   However,
                            this  may change in the future.  The caller should explicitly specify
                            RESOLVE_NO_MAGICLINKS to ensure that magic links are not resolved.

                     RESOLVE_IN_ROOT
                            Treat dirfd as the root directory while resolving pathname (as though
                            the user called chroot(2) with dirfd as the argument.)  Absolute sym-
                            bolic links and ".." path components will be  scoped  to  dirfd.   If
                            pathname is an absolute path, it is also treated relative to dirfd.

                            However,  unlike  chroot(2) (which changes the filesystem root perma-
                            nently for a process), RESOLVE_IN_ROOT  allows  a  program  to  effi-
                            ciently  restrict  path  resolution  for only certain operations.  It
                            also has several hardening features (such detecting  escape  attempts
                            during ..  resolution) which chroot(2) does not.

                            Currently,  this  flag also disables magic link resolution.  However,
                            this may change in the future.  The caller should explicitly  specify
                            RESOLVE_NO_MAGICLINKS to ensure that magic links are not resolved.

                     It is an error to provide openat2() unknown flags in resolve.

RETURN VALUE
       On success, a new file descriptor is returned.  On error, -1 is returned, and errno is set
       appropriately.

ERRORS
       The set of errors returned by openat2() includes all of the errors returned by  openat(2),
       as well as the following additional errors:

       EINVAL An unknown flag or invalid value was specified in how.

       EINVAL mode is non-zero, but flags does not contain O_CREAT or O_TMPFILE.

       EINVAL size was smaller than any known version of struct open_how.

       E2BIG  An  extension  was specified in how, which the current kernel does not support (see
              the "Extensibility" section of the NOTES for more detail on how extensions are han-
              dled.)

       EAGAIN resolve  contains  either  RESOLVE_IN_ROOT or RESOLVE_BENEATH, and the kernel could
              not ensure that a ".." component didn't escape (due to a race condition  or  poten-
              tial attack.)  Callers may choose to retry the openat2() call.

       EXDEV  resolve  contains either RESOLVE_IN_ROOT or RESOLVE_BENEATH, and an escape from the
              root during path resolution was detected.

       EXDEV  resolve contains RESOLVE_NO_XDEV, and a path component attempted to cross  a  mount
              point.

       ELOOP  resolve contains RESOLVE_NO_SYMLINKS, and one of the path components was a symbolic
              link (or magic link).

       ELOOP  resolve contains RESOLVE_NO_MAGICLINKS, and one of the path components was a  magic
              link.

VERSIONS
       openat2() was added to Linux in kernel 5.FOO.

CONFORMING TO
       This system call is Linux-specific.

       The semantics of RESOLVE_BENEATH were modelled after FreeBSD's O_BENEATH.

NOTES
       Glibc does not provide a wrapper for this system call; call it using systemcall(2).

   Extensibility
       In order to allow for struct open_how to be extended in future kernel revisions, openat2()
       requires userspace to specify the size of struct open_how structure they are passing.   By
       providing  this  information,  it  is possible for openat2() to provide both forwards- and
       backwards-compatibility — with size acting as an implicit version number (because new  ex-
       tension  fields will always be appended, the size will always increase.)  This extensibil-
       ity  design  is  very  similar  to   other   system   calls   such   as   perf_setattr(2),
       perf_event_open(2), and clone(3).

       If  we let usize be the size of the structure according to userspace and ksize be the size
       of the structure which the kernel supports, then there are only three cases to consider:

              *  If ksize equals usize, then there is no version mismatch and  how  can  be  used
                 verbatim.

              *  If  ksize  is  larger than usize, then there are some extensions the kernel sup-
                 ports which the userspace program is unaware of.  Because  all  extensions  must
                 have their zero values be a no-op, the kernel treats all of the extension fields
                 not set by userspace to have zero values.  This  provides  backwards-compatibil-
                 ity.

              *  If  ksize  is  smaller  than  usize,  then  there  are some extensions which the
                 userspace program is aware of but the kernel does not support.  Because all  ex-
                 tensions  must  have  their zero values be a no-op, the kernel can safely ignore
                 the unsupported extension fields if they are all-zero.  If any  unsupported  ex-
                 tension  fields  are  non-zero,  then  -1 is returned and errno is set to E2BIG.
                 This provides forwards-compatibility.

       Therefore, most userspace programs will not need to have any special  handling  of  exten-
       sions.   However,  if  a userspace program wishes to determine what extensions the running
       kernel supports, they may conduct a binary search on size (to find the largest value which
       doesn't produce an error of E2BIG.)

SEE ALSO
       openat(2), path_resolution(7), symlink(7)

Linux                                       2019-11-05                                 OPENAT2(2)
--8<---------------------------------------------------------------------------

Aleksa Sarai (13):
  namei: only return -ECHILD from follow_dotdot_rcu()
  nsfs: clean-up ns_get_path() signature to return int
  namei: allow nd_jump_link() to produce errors
  namei: allow set_root() to produce errors
  namei: LOOKUP_NO_SYMLINKS: block symlink resolution
  namei: LOOKUP_NO_MAGICLINKS: block magic-link resolution
  namei: LOOKUP_NO_XDEV: block mountpoint crossing
  namei: LOOKUP_BENEATH: O_BENEATH-like scoped resolution
  namei: LOOKUP_IN_ROOT: chroot-like scoped resolution
  namei: LOOKUP_{IN_ROOT,BENEATH}: permit limited ".." resolution
  open: introduce openat2(2) syscall
  selftests: add openat2(2) selftests
  Documentation: path-lookup: include new LOOKUP flags

 CREDITS                                       |   4 +-
 Documentation/filesystems/path-lookup.rst     |  68 ++-
 arch/alpha/kernel/syscalls/syscall.tbl        |   1 +
 arch/arm/tools/syscall.tbl                    |   1 +
 arch/arm64/include/asm/unistd.h               |   2 +-
 arch/arm64/include/asm/unistd32.h             |   2 +
 arch/ia64/kernel/syscalls/syscall.tbl         |   1 +
 arch/m68k/kernel/syscalls/syscall.tbl         |   1 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |   1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |   1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |   1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |   1 +
 arch/parisc/kernel/syscalls/syscall.tbl       |   1 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |   1 +
 arch/s390/kernel/syscalls/syscall.tbl         |   1 +
 arch/sh/kernel/syscalls/syscall.tbl           |   1 +
 arch/sparc/kernel/syscalls/syscall.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl        |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   1 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |   1 +
 fs/namei.c                                    | 185 +++++--
 fs/nsfs.c                                     |  29 +-
 fs/open.c                                     | 149 +++--
 fs/proc/base.c                                |   3 +-
 fs/proc/namespaces.c                          |  20 +-
 include/linux/fcntl.h                         |  12 +-
 include/linux/namei.h                         |  12 +-
 include/linux/proc_ns.h                       |   4 +-
 include/linux/syscalls.h                      |   3 +
 include/uapi/asm-generic/unistd.h             |   5 +-
 include/uapi/linux/fcntl.h                    |  40 ++
 kernel/bpf/offload.c                          |  12 +-
 kernel/events/core.c                          |   2 +-
 security/apparmor/apparmorfs.c                |   6 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/openat2/.gitignore    |   1 +
 tools/testing/selftests/openat2/Makefile      |   8 +
 tools/testing/selftests/openat2/helpers.c     | 109 ++++
 tools/testing/selftests/openat2/helpers.h     | 107 ++++
 .../testing/selftests/openat2/openat2_test.c  | 316 +++++++++++
 .../selftests/openat2/rename_attack_test.c    | 160 ++++++
 .../testing/selftests/openat2/resolve_test.c  | 523 ++++++++++++++++++
 42 files changed, 1686 insertions(+), 113 deletions(-)
 create mode 100644 tools/testing/selftests/openat2/.gitignore
 create mode 100644 tools/testing/selftests/openat2/Makefile
 create mode 100644 tools/testing/selftests/openat2/helpers.c
 create mode 100644 tools/testing/selftests/openat2/helpers.h
 create mode 100644 tools/testing/selftests/openat2/openat2_test.c
 create mode 100644 tools/testing/selftests/openat2/rename_attack_test.c
 create mode 100644 tools/testing/selftests/openat2/resolve_test.c


base-commit: 31f4f5b495a62c9a8b15b1c3581acd5efeb9af8c
-- 
2.24.0

