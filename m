Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093A7249414
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHSE2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSE2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:28:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E325C061389;
        Tue, 18 Aug 2020 21:28:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e4so536988pjd.0;
        Tue, 18 Aug 2020 21:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MOlq3HnlpNFJH+jG0duapzgkcG8G/1g+Ufd6wun/Lco=;
        b=L2E3Q0i8nKfLgHQkfaBg4BXcrkYmmJdEKf79xTq/7BdsHN5W26D+b20iCNla+Q+pUg
         D4ozMzsreDIrAvjmcMc8ujjh68Kkkhz0QmEsSQ2e6ZfDOJ+dFk8N2gaaZtmrGNko56Dq
         XzmgbHJkkVyNoVIXkCi85hKRwHggt6eLcBzHpxUIhiLzfjbv8EXm8HlpYvay0FalakNh
         TzPN1K9DOHY84/sMpcSDBmsEu68nS9oMvDngO3MUxZ2gBlgzI97Be08q18oYhX45XpG0
         QSFm1dZkcCS81u0ivwpYnfESSX1NmO96TkGSxFSSMt+xA8BcilL/o0VxtYAPzVVAhgxB
         6G4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MOlq3HnlpNFJH+jG0duapzgkcG8G/1g+Ufd6wun/Lco=;
        b=ff6x19CBRn7ztEQnPisCfYfjZXwd6fswWv7BeHZkmtLMwMTmT/tO5aH6mgCbFNv2h/
         mHmk5Q96KurLpq3JXOSa9EYZqkptbOja8t4qrVJw00S6LC+MIMu69mdKsw1tUt67KMGN
         vtP/e+/nXrsI4b5Gt+8lDe1hO2Wneq2rN525b/T6C4NAdkgt+c412KukNCBt2fTdU/vR
         JsJaqwGWYiSMpIxEB6seWfe5M+ie3lCf4Rtv7nLyQJN0bhRrb/rrqSLAghWcNr5dUY/S
         oXYXglSux4arUUmhX++1ewHcePWkZtGrgHJhvO4MGHAXzb6volxz//CRqlEyXY/XsRev
         Y1OA==
X-Gm-Message-State: AOAM531P2U8nUP02W4jVOeUr7HM3sHUoEfJGn6Ny8u9LhO0+MbapZLB1
        7d0R30oB9hz2yMAzlxkUXpU9lZ53TJM=
X-Google-Smtp-Source: ABdhPJy+XC1Q0uR6pnJJ8IUoSKJxWe/GQPDMeSoW10/CC8B5VI2AEG+ny/UG4OuA63iIXcV1VHcTWA==
X-Received: by 2002:a17:90b:18b:: with SMTP id t11mr2614609pjs.105.1597811281785;
        Tue, 18 Aug 2020 21:28:01 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id f6sm24132023pga.9.2020.08.18.21.28.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 21:28:00 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 bpf-next 0/4] bpf: Populate bpffs with map and prog iterators
Date:   Tue, 18 Aug 2020 21:27:55 -0700
Message-Id: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v5->v6:
- refactored Makefiles with Andrii's help
  - switched to explicit $(MAKE) style
  - switched to userldlibs instead of userldflags
  - fixed build issue with libbpf Makefile due to invocation from kbuild
- fixed menuconfig order as spotted by Daniel
- introduced CONFIG_USERMODE_DRIVER bool that is selected by bpfilter and bpf_preload

v4->v5:
- addressed Song and Andrii feedback. s/pages/max_entries/

v3->v4:
- took THIS_MODULE in patch 3 as suggested by Daniel to simplify the code.
- converted BPF iterator to use BTF (when available) to print full BPF program name
instead of 16-byte truncated version.
This is something I've been using drgn scripts for.
Take a look at get_name() in iterators.bpf.c to see how short it is comparing
to what user space bpftool would have to do to print the same full name:
. get prog info via obj_info_by_fd
. do get_fd_by_id from info->btf_id
. fetch potentially large BTF of the program from the kernel
. parse that BTF in user space to figure out all type boundaries and string section
. read info->func_info to get btf_id of func_proto from there
. find that btf_id in the parsed BTF
That's quite a bit work for bpftool comparing to few lines in get_name().
I guess would be good to make bpftool do this info extraction anyway.
While doing this BTF reading in the kernel realized that the verifier is not smart
enough to follow double pointers (added to my todo list), otherwise get_name()
would have been even shorter.

v2->v3:
- fixed module unload race (Daniel)
- added selftest (Daniel)
- fixed build bot warning

v1->v2:
- changed names to 'progs.debug' and 'maps.debug' to hopefully better indicate
  instability of the text output. Having dot in the name also guarantees
  that these special files will not conflict with normal bpf objects pinned
  in bpffs, since dot is disallowed for normal pins.
- instead of hard coding link_name in the core bpf moved into UMD.
- cleanedup error handling.
- addressed review comments from Yonghong and Andrii.

This patch set is the first real user of user moder driver facility. The
general use case for user mode driver is to ship vmlinux with preloaded BPF
programs. In this particular case the user mode driver populates bpffs instance
with two BPF iterators. In several months BPF_LSM project would need to preload
the kernel with its own set of BPF programs and attach to LSM hooks instead of
bpffs. BPF iterators and BPF_LSM are unstable from uapi perspective. They are
tracing based and peek into arbitrary kernel data structures. One can question
why a kernel module cannot embed BPF programs inside. The reason is that libbpf
is necessary to load them. First libbpf loads BPF Type Format, then creates BPF
maps, populates them. Then it relocates code sections inside BPF programs,
loads BPF programs, and finally attaches them to events. Theoretically libbpf
can be rewritten to work in the kernel, but that is massive undertaking. The
maintenance of in-kernel libbpf and user space libbpf would be another
challenge. Another obstacle to embedding BPF programs into kernel module is
sys_bpf api. Loading of programs, BTF, maps goes through the verifier. It
validates and optimizes the code. It's possible to provide in-kernel api to all
of sys_bpf commands (load progs, create maps, update maps, load BTF, etc), but
that is huge amount of work and forever maintenance headache.
Hence the decision is to ship vmlinux with user mode drivers that load
BPF programs. Just like kernel modules extend vmlinux BPF programs
are safe extensions of the kernel and some of them need to ship with vmlinux.

This patch set adds a kernel module with user mode driver that populates bpffs
with two BPF iterators.

$ mount bpffs /my/bpffs/ -t bpf
$ ls -la /my/bpffs/
total 4
drwxrwxrwt  2 root root    0 Jul  2 00:27 .
drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
-rw-------  1 root root    0 Jul  2 00:27 maps.debug
-rw-------  1 root root    0 Jul  2 00:27 progs.debug

The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
maps, load two BPF programs, attach them to BPF iterators, and finally send two
bpf_link IDs back to the kernel.
The kernel will pin two bpf_links into newly mounted bpffs instance under
names "progs.debug" and "maps.debug". These two files become human readable.

$ cat /my/bpffs/progs.debug
  id name            attached
  11 dump_bpf_map    bpf_iter_bpf_map
  12 dump_bpf_prog   bpf_iter_bpf_prog
  27 test_pkt_access 
  32 test_main       test_pkt_access test_pkt_access
  33 test_subprog1   test_pkt_access_subprog1 test_pkt_access
  34 test_subprog2   test_pkt_access_subprog2 test_pkt_access
  35 test_subprog3   test_pkt_access_subprog3 test_pkt_access
  36 new_get_skb_len get_skb_len test_pkt_access
  37 new_get_skb_ifindex get_skb_ifindex test_pkt_access
  38 new_get_constant get_constant test_pkt_access

The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
all BPF programs currently loaded in the system. This information is unstable
and will change from kernel to kernel.

In some sence this output is similar to 'bpftool prog show' that is using
stable api to retreive information about BPF programs. The BPF subsytems grows
quickly and there is always demand to show as much info about BPF things as
possible. But we cannot expose all that info via stable uapi of bpf syscall,
since the details change so much. Right now a BPF program can be attached to
only one other BPF program. Folks are working on patches to enable
multi-attach, but for debugging it's necessary to see the current state. There
is no uapi for that, but above output shows it:
  37 new_get_skb_ifindex  get_skb_ifindex test_pkt_access
  38 new_get_constant     get_constant    test_pkt_access
     [1]                  [2]             [3]
[1] is the full name of BPF prog from BTF.
[2] is the name of function inside target BPF prog.
[3] is the name of target BPF prog.

[2] and [3] are not exposed via uapi, since they will change from single to
multi soon. There are many other cases where bpf internals are useful for
debugging, but shouldn't be exposed via uapi due to high rate of changes.

systemd mounts /sys/fs/bpf at the start, so this kernel module with user mode
driver needs to be available early. BPF_LSM most likely would need to preload
BPF programs even earlier.

Few interesting observations:
- though bpffs comes with two human readble files "progs.debug" and
  "maps.debug" they can be removed. 'rm -f /sys/fs/bpf/progs.debug' will remove
  bpf_link and kernel will automatically unload corresponding BPF progs, maps,
  BTFs. In the future '-o remount' will be able to restore them. This is not
  implemented yet.

- 'ps aux|grep bpf_preload' shows nothing. User mode driver loaded BPF
  iterators and exited. Nothing is lingering in user space at this point.

- We can consider giving 0644 permissions to "progs.debug" and "maps.debug"
  to allow unprivileged users see BPF things loaded in the system.
  We cannot do so with "bpftool prog show", since it's using cap_sys_admin
  parts of bpf syscall.

- The functionality split between core kernel, bpf_preload kernel module and
  user mode driver is very similar to bpfilter style of interaction.

- Similar BPF iterators can be used as unstable extensions to /proc.
  Like mounting /proc can prepopolate some subdirectory in there with
  a BPF iterator that will print QUIC sockets instead of tcp and udp.

Alexei Starovoitov (4):
  bpf: Factor out bpf_link_by_id() helper.
  bpf: Add BPF program and map iterators as built-in BPF programs.
  bpf: Add kernel module with user mode driver that populates bpffs.
  selftests/bpf: Add bpffs preload test.

 include/linux/bpf.h                           |   1 +
 init/Kconfig                                  |   2 +
 kernel/Makefile                               |   2 +-
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/inode.c                            | 116 ++++-
 kernel/bpf/preload/Kconfig                    |  23 +
 kernel/bpf/preload/Makefile                   |  23 +
 kernel/bpf/preload/bpf_preload.h              |  16 +
 kernel/bpf/preload/bpf_preload_kern.c         |  91 ++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 +
 kernel/bpf/preload/iterators/.gitignore       |   2 +
 kernel/bpf/preload/iterators/Makefile         |  57 +++
 kernel/bpf/preload/iterators/README           |   4 +
 .../preload/iterators/bpf_preload_common.h    |  13 +
 kernel/bpf/preload/iterators/iterators.bpf.c  | 114 +++++
 kernel/bpf/preload/iterators/iterators.c      |  94 ++++
 kernel/bpf/preload/iterators/iterators.skel.h | 410 ++++++++++++++++++
 kernel/bpf/syscall.c                          |  46 +-
 net/bpfilter/Kconfig                          |   1 +
 tools/lib/bpf/Makefile                        |   7 +-
 .../selftests/bpf/prog_tests/test_bpffs.c     |  94 ++++
 21 files changed, 1100 insertions(+), 24 deletions(-)
 create mode 100644 kernel/bpf/preload/Kconfig
 create mode 100644 kernel/bpf/preload/Makefile
 create mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
 create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 create mode 100644 kernel/bpf/preload/iterators/.gitignore
 create mode 100644 kernel/bpf/preload/iterators/Makefile
 create mode 100644 kernel/bpf/preload/iterators/README
 create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpffs.c

-- 
2.23.0

