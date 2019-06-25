Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB555AAB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFYWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:12:25 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:37446 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:12:25 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLr7Ee019685
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:07 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLr2Vm038187;
        Tue, 25 Jun 2019 23:53:02 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v9 00/10] Landlock LSM: Toward unprivileged sandboxing
Date:   Tue, 25 Jun 2019 23:52:29 +0200
Message-Id: <20190625215239.11136-1-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This ninth series upgrade Landlock as a stackable LSM [4] and elide the
file system path evaluation from the previous series [1] to make this
review process easier.  This patch series is almost half the size of the
previous one.

Landlock is a low-level framework to build custom access-control systems
or safe endpoint security agents.  There is two types of Landlock hooks:
FS_WALK and FS_PICK.  Each of them accepts a dedicated eBPF program,
called a Landlock program.  The set of actions on a file is well defined
(e.g.  read, write, ioctl, append, lock, mount...) taking inspiration
from the major Linux LSMs and some other access-controls like Capsicum.

The example patch show how a file system access control can be built
based on a list of denied files and directories.  From a security point
of view, it may be preferable to use a whitelist instead of a blacklist,
but this series only enable to match a specific list of files.  Bringing
back a way to evaluate a path is planned for a future dedicated series,
once this base Landlock framework is merged.  I may take inspiration
from the LOOKUP_BENEATH approach [5], but from an eBPF point of view.

The documentation patch contains some kernel documentation and
explanations on how to use Landlock.  The compiled documentation and
some talks can be found here: https://landlock.io
This patch series can be found in a Git repository here:
https://github.com/landlock-lsm/linux/commits/landlock-v9

There is still some minor issues with this patch series but it is enough
to get a deep review.

This is the first step of the roadmap discussed at LPC [2].  While the
intended final goal is to allow unprivileged users to use Landlock, this
series allows only a process with global CAP_SYS_ADMIN to load and
enforce a rule.  This may help to get feedback and avoid unexpected
behaviors.

This series can be applied on top of bpf-next, commit 88091ff56b71
("selftests, bpf: Add test for veth native XDP").  This can be tested
with CONFIG_SECCOMP_FILTER and CONFIG_SECURITY_LANDLOCK.  I would really
appreciate constructive comments on the design and the code.


# Landlock LSM

The goal of this new Linux Security Module (LSM) called Landlock is to
allow any process, including unprivileged ones, to create powerful
security sandboxes comparable to XNU Sandbox or OpenBSD Pledge (which
could be implemented with Landlock).  This kind of sandbox is expected
to help mitigate the security impact of bugs or unexpected/malicious
behaviors in user-space applications.

The approach taken is to add the minimum amount of code while still
allowing the user-space application to create quite complex access
rules.  A dedicated security policy language such as the one used by
SELinux, AppArmor and other major LSMs involves a lot of code and is
usually permitted to only a trusted user (i.e. root).  On the contrary,
eBPF programs already exist and are designed to be safely loaded by
unprivileged user-space.

This design does not seem too intrusive but is flexible enough to allow
a powerful sandbox mechanism accessible by any process on Linux. The use
of seccomp and Landlock is more suitable with the help of a user-space
library (e.g.  libseccomp) that could help to specify a high-level
language to express a security policy instead of raw eBPF programs.
Moreover, thanks to the LLVM front-end, it is quite easy to write an
eBPF program with a subset of the C language.


# Frequently asked questions

## Why is seccomp-bpf not enough?

A seccomp filter can access only raw syscall arguments (i.e. the
register values) which means that it is not possible to filter according
to the value pointed to by an argument, such as a file pathname. As an
embryonic Landlock version demonstrated, filtering at the syscall level
is complicated (e.g. need to take care of race conditions). This is
mainly because the access control checkpoints of the kernel are not at
this high-level but more underneath, at the LSM-hook level. The LSM
hooks are designed to handle this kind of checks.  Landlock abstracts
this approach to leverage the ability of unprivileged users to limit
themselves.

Cf. section "What it isn't?" in Documentation/prctl/seccomp_filter.txt


## Why use the seccomp(2) syscall?

Landlock use the same semantic as seccomp to apply access rule
restrictions. It add a new layer of security for the current process
which is inherited by its children. It makes sense to use an unique
access-restricting syscall (that should be allowed by seccomp filters)
which can only drop privileges. Moreover, a Landlock rule could come
from outside a process (e.g.  passed through a UNIX socket). It is then
useful to differentiate the creation/load of Landlock eBPF programs via
bpf(2), from rule enforcement via seccomp(2).


## Why a new LSM? Are SELinux, AppArmor, Smack and Tomoyo not good
   enough?

The current access control LSMs are fine for their purpose which is to
give the *root* the ability to enforce a security policy for the
*system*. What is missing is a way to enforce a security policy for any
application by its developer and *unprivileged user* as seccomp can do
for raw syscall filtering.

Differences from other (access control) LSMs:
* not only dedicated to administrators (i.e. no_new_priv);
* limited kernel attack surface (e.g. policy parsing);
* constrained policy rules (no DoS: deterministic execution time);
* do not leak more information than the loader process can legitimately
  have access to (minimize metadata inference).


# Changes since v8

* fit with the new LSM stacking framework (security blobs were tested
  but are not use in this series because of the code reduction)
* remove the Landlock program chaining and the file path evaluation
  feature to get a minimum viable product and ease the review
* replace the example with a simple blacklist policy
* rebase on bpf-next


# Changes since v7

* major revamp of the file system enforcement:
  * new eBPF map dedicated to tie an inode with an arbitrary 64-bits
    value, which can be used to tag files
  * three new Landlock hooks: FS_WALK, FS_PICK and FS_GET
  * add the ability to chain Landlock programs
  * add a new eBPF map type to compare inodes
  * don't use macros anymore
* replace subtype fields:
  * triggers: fine-grained bitfiel of actions on which a Landlock
    program may be called (if it comes from a sandbox process)
  * previous: a parent chained program
* upstreamed patches:
  * commit 369130b63178 ("selftests: Enhance kselftest_harness.h to
    print which assert failed")


# Changes since v6

* upstreamed patches:
  * commit 752ba56fb130 ("bpf: Extend check_uarg_tail_zero() checks")
  * commit 0b40808a1084 ("selftests: Make test_harness.h more generally
    available") and related ones
  * commit 3bb857e47e49 ("LSM: Enable multiple calls to
    security_add_hooks() for the same LSM")
* simplify the landlock_context (remove syscall_* fields) and add three
  FS sub-events: IOCTL, LOCK, FCNTL
* minimize the number of callable BPF functions from a Landlock rule
* do not split put_seccomp_filter() with put_seccomp()
* rename Landlock version to Landlock ABI
* miscellaneous fixes
* rebase on net-next


# Changes since v5

* eBPF program subtype:
  * use a prog_subtype pointer instead of inlining it into bpf_attr
  * enable a future-proof behavior (reject unhandled data/size)
  * add tests
* use a simple rule hierarchy (similar to seccomp-bpf)
* add a ptrace scope protection
* add more tests
* add more documentation
* rename some files
* miscellaneous fixes
* rebase on net-next


# Changes since v4

* upstreamed patches:
  * commit d498f8719a09 ("bpf: Rebuild bpf.o for any dependency update")
  * commit a734fb5d6006 ("samples/bpf: Reset global variables") and
    related ones
  * commit f4874d01beba ("bpf: Use bpf_create_map() from the library")
    and related ones
  * commit d02d8986a768 ("bpf: Always test unprivileged programs")
  * commit 640eb7e7b524 ("fs: Constify path_is_under()'s arguments")
  * commit 535e7b4b5ef2 ("bpf: Use u64_to_user_ptr()")
* revamp Landlock to not expose an LSM hook interface but wrap and
  abstract them with Landlock events (currently one for all filesystem
  related operations: LANDLOCK_SUBTYPE_EVENT_FS)
* wrap all filesystem kernel objects through the same FS handle (struct
  landlock_handle_fs): struct file, struct inode, struct path and struct
  dentry
* a rule don't return an errno code but only a boolean to allow or deny
  an access request
* handle all filesystem related LSM hooks
* add some tests and a sample:
  * BPF context tests
  * Landlock sandboxing tests and sample
  * write Landlock rules in C and compile them with LLVM
* change field names of eBPF program subtype
* remove arraymap of handles for now (will be replaced with a revamped
  map)
* remove cgroup handling for now
* add user and kernel documentation
* rebase on net-next


# Changes since v3

* upstreamed patch:
  * commit 1955351da41c ("bpf: Set register type according to
    is_valid_access()")
* use abstract LSM hook arguments with custom types (e.g.
  *_LANDLOCK_ARG_FS for struct file, struct inode and struct path)
* add more LSM hooks to support full filesystem access control
* improve the sandbox example
* fix races and RCU issues:
  * eBPF program execution and eBPF helpers
  * revamp the arraymap of handles to cleanly deal with update/delete
* eBPF program subtype for Landlock:
  * remove the "origin" field
  * add an "option" field
* rebase onto Daniel Mack's patches v7 [3]
* remove merged commit 1955351da41c ("bpf: Set register type according
  to is_valid_access()")
* fix spelling mistakes
* cleanup some type and variable names
* split patches
* for now, remove cgroup delegation handling for unprivileged user
* remove extra access check for cgroup_get_from_fd()
* remove unused example code dealing with skb
* remove seccomp-bpf link:
  * no more seccomp cookie
  * for now, it is no more possible to check the current syscall
    properties


# Changes since v2

* revamp cgroup handling:
  * use Daniel Mack's patches "Add eBPF hooks for cgroups" v5
  * remove bpf_landlock_cmp_cgroup_beneath()
  * make BPF_PROG_ATTACH usable with delegated cgroups
  * add a new CGRP_NO_NEW_PRIVS flag for safe cgroups
  * handle Landlock sandboxing for cgroups hierarchy
  * allow unprivileged processes to attach Landlock eBPF program to
    cgroups
* add subtype to eBPF programs:
  * replace Landlock hook identification by custom eBPF program types
    with a dedicated subtype field
  * manage fine-grained privileged Landlock programs
  * register Landlock programs for dedicated trigger origins (e.g.
    syscall, return from seccomp filter and/or interruption)
* performance and memory optimizations: use an array to access Landlock
  hooks directly but do not duplicated it for each thread
  (seccomp-based)
* allow running Landlock programs without seccomp filter
* fix seccomp-related issues
* remove extra errno bounding check for Landlock programs
* add some examples for optional eBPF functions or context access
  (network related) according to security checks to allow more features
  for privileged programs (e.g. Checmate)


# Changes since v1

* focus on the LSM hooks, not the syscalls:
  * much more simple implementation
  * does not need audit cache tricks to avoid race conditions
  * more simple to use and more generic because using the LSM hook
    abstraction directly
  * more efficient because only checking in LSM hooks
  * architecture agnostic
* switch from cBPF to eBPF:
  * new eBPF program types dedicated to Landlock
  * custom functions used by the eBPF program
  * gain some new features (e.g. 10 registers, can load values of
    different size, LLVM translator) but only a few functions allowed
    and a dedicated map type
  * new context: LSM hook ID, cookie and LSM hook arguments
  * need to set the sysctl kernel.unprivileged_bpf_disable to 0 (default
    value) to be able to load hook filters as unprivileged users
* smaller and simpler:
  * no more checker groups but dedicated arraymap of handles
  * simpler userland structs thanks to eBPF functions
* distinctive name: Landlock


[1] https://lore.kernel.org/lkml/20180227004121.3633-1-mic@digikod.net/
[2] https://lore.kernel.org/lkml/5828776A.1010104@digikod.net/
[3] https://lore.kernel.org/netdev/1477390454-12553-1-git-send-email-daniel@zonque.org/
[4] https://lore.kernel.org/lkml/50db058a-7dde-441b-a7f9-f6837fe8b69f@schaufler-ca.com/
[5] https://lore.kernel.org/lkml/20190520133305.11925-1-cyphar@cyphar.com/

Regards,

Mickaël Salaün (10):
  fs,security: Add a new file access type: MAY_CHROOT
  bpf: Add eBPF program subtype and is_valid_subtype() verifier
  bpf,landlock: Define an eBPF program type for Landlock hooks
  seccomp,landlock: Enforce Landlock programs per process hierarchy
  bpf,landlock: Add a new map type: inode
  landlock: Handle filesystem access control
  landlock: Add ptrace restrictions
  bpf: Add a Landlock sandbox example
  bpf,landlock: Add tests for Landlock
  landlock: Add user and kernel documentation for Landlock

 Documentation/security/index.rst              |   1 +
 Documentation/security/landlock/index.rst     |  20 +
 Documentation/security/landlock/kernel.rst    |  99 +++
 Documentation/security/landlock/user.rst      | 148 +++++
 MAINTAINERS                                   |  13 +
 fs/open.c                                     |   3 +-
 include/linux/bpf.h                           |  17 +
 include/linux/bpf_types.h                     |   6 +
 include/linux/fs.h                            |   1 +
 include/linux/landlock.h                      |  34 ++
 include/linux/lsm_hooks.h                     |   1 +
 include/linux/seccomp.h                       |   5 +
 include/uapi/linux/bpf.h                      |  22 +-
 include/uapi/linux/landlock.h                 | 109 ++++
 include/uapi/linux/seccomp.h                  |   1 +
 kernel/bpf/Makefile                           |   3 +
 kernel/bpf/core.c                             |   3 +
 kernel/bpf/inodemap.c                         | 315 ++++++++++
 kernel/bpf/syscall.c                          |  59 +-
 kernel/bpf/verifier.c                         |  25 +
 kernel/fork.c                                 |   8 +-
 kernel/seccomp.c                              |   4 +
 net/core/filter.c                             |  25 +-
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   3 +
 samples/bpf/bpf_load.c                        |  76 ++-
 samples/bpf/bpf_load.h                        |   7 +
 samples/bpf/landlock1.h                       |   8 +
 samples/bpf/landlock1_kern.c                  | 104 ++++
 samples/bpf/landlock1_user.c                  | 157 +++++
 security/Kconfig                              |   1 +
 security/Makefile                             |   2 +
 security/landlock/Kconfig                     |  18 +
 security/landlock/Makefile                    |   5 +
 security/landlock/common.h                    |  81 +++
 security/landlock/enforce.c                   | 272 +++++++++
 security/landlock/enforce.h                   |  18 +
 security/landlock/enforce_seccomp.c           |  92 +++
 security/landlock/hooks.c                     |  95 +++
 security/landlock/hooks.h                     |  31 +
 security/landlock/hooks_fs.c                  | 568 ++++++++++++++++++
 security/landlock/hooks_fs.h                  |  31 +
 security/landlock/hooks_ptrace.c              | 121 ++++
 security/landlock/hooks_ptrace.h              |   8 +
 security/landlock/init.c                      | 159 +++++
 security/security.c                           |  15 +
 tools/include/uapi/linux/bpf.h                |  22 +-
 tools/include/uapi/linux/landlock.h           | 109 ++++
 tools/lib/bpf/bpf.c                           |  10 +-
 tools/lib/bpf/bpf.h                           |   2 +
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/libbpf_probes.c                 |   2 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h     |   2 +
 tools/testing/selftests/bpf/test_verifier.c   |  27 +-
 .../testing/selftests/bpf/verifier/landlock.c |  35 ++
 .../testing/selftests/bpf/verifier/subtype.c  |  20 +
 tools/testing/selftests/landlock/.gitignore   |   4 +
 tools/testing/selftests/landlock/Makefile     |  39 ++
 tools/testing/selftests/landlock/test.h       |  48 ++
 tools/testing/selftests/landlock/test_base.c  |  24 +
 tools/testing/selftests/landlock/test_fs.c    | 257 ++++++++
 .../testing/selftests/landlock/test_ptrace.c  | 154 +++++
 64 files changed, 3528 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/security/landlock/index.rst
 create mode 100644 Documentation/security/landlock/kernel.rst
 create mode 100644 Documentation/security/landlock/user.rst
 create mode 100644 include/linux/landlock.h
 create mode 100644 include/uapi/linux/landlock.h
 create mode 100644 kernel/bpf/inodemap.c
 create mode 100644 samples/bpf/landlock1.h
 create mode 100644 samples/bpf/landlock1_kern.c
 create mode 100644 samples/bpf/landlock1_user.c
 create mode 100644 security/landlock/Kconfig
 create mode 100644 security/landlock/Makefile
 create mode 100644 security/landlock/common.h
 create mode 100644 security/landlock/enforce.c
 create mode 100644 security/landlock/enforce.h
 create mode 100644 security/landlock/enforce_seccomp.c
 create mode 100644 security/landlock/hooks.c
 create mode 100644 security/landlock/hooks.h
 create mode 100644 security/landlock/hooks_fs.c
 create mode 100644 security/landlock/hooks_fs.h
 create mode 100644 security/landlock/hooks_ptrace.c
 create mode 100644 security/landlock/hooks_ptrace.h
 create mode 100644 security/landlock/init.c
 create mode 100644 tools/include/uapi/linux/landlock.h
 create mode 100644 tools/testing/selftests/bpf/verifier/landlock.c
 create mode 100644 tools/testing/selftests/bpf/verifier/subtype.c
 create mode 100644 tools/testing/selftests/landlock/.gitignore
 create mode 100644 tools/testing/selftests/landlock/Makefile
 create mode 100644 tools/testing/selftests/landlock/test.h
 create mode 100644 tools/testing/selftests/landlock/test_base.c
 create mode 100644 tools/testing/selftests/landlock/test_fs.c
 create mode 100644 tools/testing/selftests/landlock/test_ptrace.c

-- 
2.20.1

