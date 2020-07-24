Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97A322BDC7
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgGXF66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGXF66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:58:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8B0C0619D3;
        Thu, 23 Jul 2020 22:58:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so4482147pfq.11;
        Thu, 23 Jul 2020 22:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tHJSlrryDhZfzxVQ+HnXZ49XsiGJt/zqq4Bp2OPlHWw=;
        b=hjsZiBz7NZxINWxsf9cQBL6t/ncB4jCjSXw3AnvKn9EtENmn4CFWJeAdUCeqaZt+Bk
         m930hqCkoSAMjG3E+uQMtateKEfRKrI4sQz+tut/WAmgNaLS8HSBitvrnWtWj0JRqWc+
         nOKUlOghhuYwuGGKGnuiUAtScc9HpuF1FC4SuvHZeBKdH8o2dr4njtWOD7lqeCbTaKbN
         ZMVtKdNwLaGdYMqZnEIQik4ax1ZrKh6eVGfxCp5hAthogp1+tL3NOxG8H9eLll7Jmx8Y
         wJIcNp+Zut/o9ELD7mTiRnt9E89o5FYxmSnCwIZ/0L7h/4evfQp+zSMcrd8YW57JkqRc
         7GFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tHJSlrryDhZfzxVQ+HnXZ49XsiGJt/zqq4Bp2OPlHWw=;
        b=YNb8lUJg/C5gUMwOkOJMtW1YFHne9+A56yO2gwkGL4tOUmcao/7Tkxq+UihrUEaCHn
         UpaslhTi6YP9JIOWDgLD+MPhF//WJ+Qwq3ffD4AATY/oK1DH/lig4DbBSiN6k6RV59ek
         D+76dnX4He2YhP4lCL/iTEzP+hAZpYjBEhO4Y9jcOGebRIuJunvGmzhpN1KNHncgfzZD
         NfT7UMJm87KaXn191V0PjzjA+rVshttP93q1kDR0Xtrgpccj4hL+8/7k2edywms1Mstw
         PAC2BZ5F3O8Z6Kr4ZJnJVvBkdlxLpDeOWr6+dO1/9jmW9vvjqRzGCeh0rX3eC3/nwwMK
         kHgw==
X-Gm-Message-State: AOAM532xWjjoAhv++6L8TMInAKVx6Oe5lcJxTbUKMleTlq3efebrFWfr
        VsttYzkYPd52AS16r07sEro=
X-Google-Smtp-Source: ABdhPJxzHWhd5ZuOr1+dnN7zVP4t9hUxpX/mO08MYCkqSlvqYNff/RD2PDfwDoS5kzR2Lr8WnFm+aw==
X-Received: by 2002:a62:7942:: with SMTP id u63mr7293736pfc.54.1595570336759;
        Thu, 23 Jul 2020 22:58:56 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id j10sm4909893pgh.28.2020.07.23.22.58.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jul 2020 22:58:55 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 0/4] bpf: Populate bpffs with map and prog iterators
Date:   Thu, 23 Jul 2020 22:58:50 -0700
Message-Id: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

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
  bpf: Factor out bpf_link_get_by_id() helper.
  bpf: Add BPF program and map iterators as built-in BPF programs.
  bpf: Add kernel module with user mode driver that populates bpffs.
  selftests/bpf: Add bpffs preload test.

 include/linux/bpf.h                           |   1 +
 init/Kconfig                                  |   2 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/inode.c                            | 132 ++++++-
 kernel/bpf/preload/Kconfig                    |  18 +
 kernel/bpf/preload/Makefile                   |  21 +
 kernel/bpf/preload/bpf_preload.h              |  16 +
 kernel/bpf/preload/bpf_preload_kern.c         |  83 ++++
 kernel/bpf/preload/bpf_preload_umd_blob.S     |   7 +
 kernel/bpf/preload/iterators/.gitignore       |   2 +
 kernel/bpf/preload/iterators/Makefile         |  57 +++
 kernel/bpf/preload/iterators/README           |   4 +
 .../preload/iterators/bpf_preload_common.h    |  13 +
 kernel/bpf/preload/iterators/iterators.bpf.c  |  82 ++++
 kernel/bpf/preload/iterators/iterators.c      |  94 +++++
 kernel/bpf/preload/iterators/iterators.skel.h | 360 ++++++++++++++++++
 kernel/bpf/syscall.c                          |  46 ++-
 .../selftests/bpf/prog_tests/test_bpffs.c     |  94 +++++
 18 files changed, 1012 insertions(+), 21 deletions(-)
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

