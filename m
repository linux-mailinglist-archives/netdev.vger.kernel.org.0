Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C86212D8A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgGBUDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBUDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:03:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0AC08C5C1;
        Thu,  2 Jul 2020 13:03:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 72so1141665ple.0;
        Thu, 02 Jul 2020 13:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m49GZd9vGCMIbgaGoc+X9lUDDZf2+mWCUdWgeilHSUo=;
        b=EenawjSv9YFyQwciTJ2HWe8WnMMXhTCGC0IZgHW8VivUi41M5jH2BVA2qTpG5rITmT
         Dkj90XhatKgOCscXGPWVa0iESHRe1JDlzwmnpa+qsmLAn2ciuZe1JoxL6NL6/QXGyP2H
         fRZZrGc4NZls7AiRzVOPtITrg20HdInbSkiS5RVeM+dblSU3/HCgBhaQ4cF4GEDM4TFT
         bw2DWnbDRxqZdoPbOzaCs98zLlNyXwRAZxIzj3CxfjMr3mUwzFj57tStGcz/IqCtmZir
         v095B+dFCRMRBLO6qnWNbyZiPjqWgHQ6bJhvMW9UaLD86LCNK4cSndQmUGOzB58ldpk6
         uXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m49GZd9vGCMIbgaGoc+X9lUDDZf2+mWCUdWgeilHSUo=;
        b=GTcjoHqGjyRdFRFbk0D1EC1bViQX6HE88EF7DnyMRde8gktXlhrhs7SR2evtnJmiI8
         mFbj7rrNU4W5HrjixH18BPDKPkFU8Rsl+aQ7QzNBzcM87gMF34ubt122i1k6og8HaOsq
         5i7Hov/2cgVN98bXNLYOe2YcSCpuykjpddOKVJTYvc8lat3eTjwBg3jF6DbFIizYdGyd
         Sq4mhuskTUyAB8LkjBg/xczUmqX1ZimT9Bw2E46HWS/382JP9welh7bA4vbaMT31ivVc
         v8Co0CeN43/v2JgjL1nSsWrfuS8taVGnB/2mzpymHkNNDqc8EB8JWCNDFYzQ161rloGm
         iIuA==
X-Gm-Message-State: AOAM531ucwkX+fSg6oDc79twWGwsyc0muQatC/IFuL0MN8w/2/PsoHvv
        5VlkiZtxvZiypz2U4Gjp25NbSLtr
X-Google-Smtp-Source: ABdhPJzAU0JEuCf7DTGYrbSX4x+vCLGpVXML79D2jRAt01a9JPhkODtGE1G7ZCtE1pGhFA/C/fDH7Q==
X-Received: by 2002:a17:902:507:: with SMTP id 7mr27220765plf.186.1593720212962;
        Thu, 02 Jul 2020 13:03:32 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 83sm9663466pfu.60.2020.07.02.13.03.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 13:03:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 0/3] bpf: Populate bpffs with map and prog iterators
Date:   Thu,  2 Jul 2020 13:03:26 -0700
Message-Id: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Hi Linus,

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
with two BPF iterators. The patches are based on Eric's v3 set.

$ mount bpffs /sys/fs/bpf/ -t bpf
$ ls -la /sys/fs/bpf/
total 4
drwxrwxrwt  2 root root    0 Jul  2 00:27 .
drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
-rw-------  1 root root    0 Jul  2 00:27 maps
-rw-------  1 root root    0 Jul  2 00:27 progs

The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
maps, load two BPF programs, attach them to BPF iterators, and finally send two
bpf_link IDs back to the kernel.
The kernel will pin two bpf_links into newly mounted bpffs instance under
names "progs" and "maps". These two files become human readable.

$ cat /sys/fs/bpf/progs
  id name            pages attached
  11    dump_bpf_map     1 bpf_iter_bpf_map
  12   dump_bpf_prog     1 bpf_iter_bpf_prog
  27 test_pkt_access     1
  32       test_main     1 test_pkt_access test_pkt_access
  33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
  34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
  35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
  36 new_get_skb_len     1 get_skb_len test_pkt_access
  37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
  38 new_get_constan     1 get_constant test_pkt_access

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
  37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
  38 new_get_constan     1 get_constant test_pkt_access
     [1]                   [2]          [3]
[1] is the name of BPF prog.
[2] is the name of function inside target BPF prog.
[3] is the name of target BPF prog.

[2] and [3] are not exposed via uapi, since they will change from single to
multi soon. There are many other cases where bpf internals are useful for
debugging, but shouldn't be exposed via uapi due to high rate of changes.

systemd mounts /sys/fs/bpf at the start, so this kernel module with user mode
driver needs to be available early. BPF_LSM most likely would need to preload
BPF programs even earlier.

Few interesting observations:
- though bpffs comes with two human readble files "progs" and "maps" they
  can be removed. 'rm -f /sys/fs/bpf/progs' will remove bpf_link and kernel
  will automatically unload corresponding BPF progs, maps, BTFs.

- 'ps aux|grep bpf_preload' shows nothing. User mode driver loaded BPF
  iterators and exited. Nothing is lingering in user space at this point.

- We can consider giving 0644 permissions to "progs" and "maps" to allow
  unprivileged users see BPF things loaded in the system.
  We cannot do so with "bpftool prog show", since it's using cap_sys_admin
  parts of bpf syscall.

- The functionality split between core kernel, bpf_preload kernel module and
  user mode driver is very similar to bpfilter style of interaction. Once
  this patch set lands the bpfilter can be removed, since user mode driver
  facility will have a real user. Do you still insist on removing bpfilter?

- Similar BPF iterators can be used as unstable extensions to /proc.
  Like mounting /proc can prepopolate some subdirectory in there with
  a BPF iterator that will print QUIC sockets instead of tcp and udp.

TODO:
- The patches are rough in error handling.
- my Makefile skills are rusty. I would need to clean that up.
- CONFIG_BPF_PRELOAD_UMD=m|y are tested, but -static doesn't work yet.
  User mode driver depends on libelf because libbpf is using it.
  That can be fixed up later.
- I've decided to avoid clang 10 dependency and instead check-in
  generated bpf skeleton into git. I think it's reasonable compromise.
  See patch 2.

Thoughts? Comments?

Alexei Starovoitov (3):
  bpf: Factor out bpf_link_get_by_id() helper.
  bpf: Add BPF program and map iterators as built-in BPF programs.
  bpf: Add kernel module with user mode driver that populates bpffs.

 include/linux/bpf.h                           |   1 +
 init/Kconfig                                  |   2 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/inode.c                            |  75 ++++
 kernel/bpf/preload/Kconfig                    |  15 +
 kernel/bpf/preload/Makefile                   |  21 +
 kernel/bpf/preload/bpf_preload.h              |  15 +
 kernel/bpf/preload/bpf_preload_kern.c         |  87 +++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 +
 kernel/bpf/preload/iterators/.gitignore       |   2 +
 kernel/bpf/preload/iterators/Makefile         |  57 +++
 kernel/bpf/preload/iterators/README           |   4 +
 .../preload/iterators/bpf_preload_common.h    |   8 +
 kernel/bpf/preload/iterators/iterators.bpf.c  |  81 ++++
 kernel/bpf/preload/iterators/iterators.c      |  81 ++++
 kernel/bpf/preload/iterators/iterators.skel.h | 359 ++++++++++++++++++
 kernel/bpf/syscall.c                          |  46 ++-
 17 files changed, 844 insertions(+), 18 deletions(-)
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

-- 
2.23.0

