Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32FB223275
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgGQEkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgGQEkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:40:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7A8C061755;
        Thu, 16 Jul 2020 21:40:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o22so5796551pjw.2;
        Thu, 16 Jul 2020 21:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=08YuC2rDifkzxvQ6XnG/qWwr4Re412OmRsIG36S8m64=;
        b=YNzJIzHqrjHB1zA8h+e4M2X7qChJbzJTSaw2wBtQwkB7BUrJOQGonaAqvMZ5IJOw0d
         /Fsf9Gq58L7uJB25vNP/phaQcFrLnvgfly3ofzVbBV6PdfXICyhhrJ12xGr+5xCYCDm8
         OEdLQeO0FFFAgaEPb78LApocXh9j43Ofw4EXM4NHoQZdO48q4OOwcLRJ8oG71wfh8l5r
         70t29m82Cj/WU/PNLdkfsQz++VdjWhG6tzlLmZOxtlfH6Uppf9of2JmAVYTp+ATPmkW4
         ujP3Idr+NZNIZE+s2rvj12SSLBmrATgnFYf7Hz2N27e9F60hNqXvw8/CxxaWUVCoTnju
         XXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=08YuC2rDifkzxvQ6XnG/qWwr4Re412OmRsIG36S8m64=;
        b=Xl2sGZ10iAXT8YS23WOvqT7Ck3ayRPBZVbPW2DsMsfKtLgz5KqE7PTjSQe+6WWvN25
         fz9fmwIMp+m3mrwXSnq9LJR9Y16MYRgpgRLuv4A5Oh6dlxv8W6czTABg5FvGytcRqQLH
         Yg9KudjA6+HEMDJGa94OILxO1vLw4HohRsDurJY5zm0cjQ9hOOWmoB8Hw2soFxga/BDB
         M+xX38KXj+6Li00w4dguuN47CN5rPOehXtjdbPXTML5wyOip1Xu6IFwFphoS4BOfQMRJ
         osb251Vi/RMnBqyk9JM+rkdLKUA+J5Y0XqVxm2KSlThnCWRsFes2njhe87mxQuDRVVJb
         a09A==
X-Gm-Message-State: AOAM533ss7mZ8BWTfB4+W9i8pLId2KekxEG+dD9pXhodKLmf2Twer5X1
        lbbuEySFMOIb7rRCIAptd6BZDtbv
X-Google-Smtp-Source: ABdhPJw5XaOeA6/z17TqtyKCzOLbsPqsqs95pZtQK5AGTIDq4+BY11hVKfVLNlmTyKlwINAwimfi9w==
X-Received: by 2002:a17:902:6941:: with SMTP id k1mr6278130plt.270.1594960834220;
        Thu, 16 Jul 2020 21:40:34 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id e5sm1335389pjy.26.2020.07.16.21.40.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 21:40:33 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Populate bpffs with map and prog iterators
Date:   Thu, 16 Jul 2020 21:40:27 -0700
Message-Id: <20200717044031.56412-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

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
  id name            pages attached
  11 dump_bpf_map        1 bpf_iter_bpf_map
  12 dump_bpf_prog       1 bpf_iter_bpf_prog
  27 test_pkt_access     1
  32 test_main           1 test_pkt_access test_pkt_access
  33 test_subprog1       1 test_pkt_access_subprog1 test_pkt_access
  34 test_subprog2       1 test_pkt_access_subprog2 test_pkt_access
  35 test_subprog3       1 test_pkt_access_subprog3 test_pkt_access
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
  bpf: Add bpf_prog iterator
  bpf: Factor out bpf_link_get_by_id() helper.
  bpf: Add BPF program and map iterators as built-in BPF programs.
  bpf: Add kernel module with user mode driver that populates bpffs.

 include/linux/bpf.h                           |   2 +
 init/Kconfig                                  |   2 +
 kernel/bpf/Makefile                           |   3 +-
 kernel/bpf/inode.c                            |  86 ++++-
 kernel/bpf/map_iter.c                         |  13 +-
 kernel/bpf/preload/Kconfig                    |  18 +
 kernel/bpf/preload/Makefile                   |  21 +
 kernel/bpf/preload/bpf_preload.h              |  16 +
 kernel/bpf/preload/bpf_preload_kern.c         |  85 +++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 +
 kernel/bpf/preload/iterators/.gitignore       |   2 +
 kernel/bpf/preload/iterators/Makefile         |  57 +++
 kernel/bpf/preload/iterators/README           |   4 +
 .../preload/iterators/bpf_preload_common.h    |  13 +
 kernel/bpf/preload/iterators/iterators.bpf.c  |  82 ++++
 kernel/bpf/preload/iterators/iterators.c      |  93 +++++
 kernel/bpf/preload/iterators/iterators.skel.h | 360 ++++++++++++++++++
 kernel/bpf/prog_iter.c                        |  97 +++++
 kernel/bpf/syscall.c                          |  65 +++-
 19 files changed, 995 insertions(+), 31 deletions(-)
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
 create mode 100644 kernel/bpf/prog_iter.c

-- 
2.23.0

