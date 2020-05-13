Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8B1D0563
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgEMDTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:19:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C9FC061A0C;
        Tue, 12 May 2020 20:19:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r22so5555570pga.12;
        Tue, 12 May 2020 20:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cgnn7BGEcuG0spKsjYgMQ/THavfuvltSX7ieTOwC2yo=;
        b=GV7cK/usrddCUvcVGqLj9GNIIzdZnGxXOiRDUPgASBMawqSnNcsaT2QXszxHx4dgJ+
         ijyoEi2VnrlgeXQmbogQDzZhiFBMohhPHwfOYASwaBgPOzva7Og7WIRCbqF2k3LQ9mMc
         sVUhlcV3kc6mokt4vH/rKlRrNQO1OBH9gAGqyxmWPLf4wuGGjD14fFjAf1/ROEhSQ7Fw
         JSJkmr3g+ZOJvKhiapDjs6bkWUUD1swiG4ZbQ6zfIC/0f9aH9bh4yg0905xZr+GzlAUf
         5XgNMSAmzLFH/hJHG6cHgLZdnBR48GlgpRCDq6IqMF/5jUJlS7MY1cr0/W9tR44xs2fv
         ASAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cgnn7BGEcuG0spKsjYgMQ/THavfuvltSX7ieTOwC2yo=;
        b=D/Kj1Hs51iu9VSULafvJJexrOxj7iQ3bSTq1TwJMy1Xx2IwmIBSgc9sDjd7JzEM25g
         CppGW3P0e6WMiz5uM0042E9bf8zS45DK09gbEn3Db5KfWx5v3M2A70ulsdqYoG6IX9dt
         abE6YkHIeDWyWy374K5phBWPmOzpUrFk3EaJJE30jKIclAlZxqu9wXNLd7vuYz4Q3Mar
         l8I/2OgjUh7bkIcNy/cM4/A65IdPdoms58mkQqweELm+ziHchVzWkNnBbH4oLaYj9WxT
         xx5SIzRxf1z4vWwXGTJzk/GkCSlTxYfxgbwZlrxwSF3scmdd0PsQtJk9g6VJ0vr4iuZn
         HA+Q==
X-Gm-Message-State: AOAM532Sa2S58MF/qDQPXCzDFwdaSPz6ER//OElLtB7YOKPnNMYPljaY
        NXenyEueiDyE4g+AvFFnWr4=
X-Google-Smtp-Source: ABdhPJwvEjKC6Qwup/1awvUhKHaFARTRhQ7CYWgQ3fAzzMyWsW3HEmmFHM9ywQuI19r7o42nkZkaRA==
X-Received: by 2002:a63:3546:: with SMTP id c67mr4493734pga.379.1589339973974;
        Tue, 12 May 2020 20:19:33 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.1])
        by smtp.gmail.com with ESMTPSA id f70sm13206415pfa.17.2020.05.12.20.19.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 20:19:32 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v6 bpf-next 0/3] Introduce CAP_BPF
Date:   Tue, 12 May 2020 20:19:27 -0700
Message-Id: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v5->v6:
- split allow_ptr_leaks into four flags.
- retain bpf_jit_limit under cap_sys_admin.
- fixed few other issues spotted by Daniel.

v4->v5:

Split BPF operations that are allowed under CAP_SYS_ADMIN into combination of
CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN and keep some of them under CAP_SYS_ADMIN.

The user process has to have
- CAP_BPF to create maps and do other sys_bpf() commands
- CAP_BPF and CAP_PERFMON to load tracing programs.
- CAP_BPF and CAP_NET_ADMIN to load networking programs.
(or CAP_SYS_ADMIN for backward compatibility).

CAP_BPF solves three main goals:
1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
   More on this below. This is the major difference vs v4 set back from Sep 2019.
2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
   prevents pointer leaks and arbitrary kernel memory access.
3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
   and making BPF infra more secure. Currently fuzzers run in unpriv.
   They will be able to run with CAP_BPF.

The patchset is long overdue follow-up from the last plumbers conference.
Comparing to what was discussed at LPC the CAP* checks at attach time are gone.
For tracing progs the CAP_SYS_ADMIN check was done at load time only. There was
no check at attach time. For networking and cgroup progs CAP_SYS_ADMIN was
required at load time and CAP_NET_ADMIN at attach time, but there are several
ways to bypass CAP_NET_ADMIN:
- if networking prog is using tail_call writing FD into prog_array will
  effectively attach it, but bpf_map_update_elem is an unprivileged operation.
- freplace prog with CAP_SYS_ADMIN can replace networking prog

Consolidating all CAP checks at load time makes security model similar to
open() syscall. Once the user got an FD it can do everything with it.
read/write/poll don't check permissions. The same way when bpf_prog_load
command returns an FD the user can do everything (including attaching,
detaching, and bpf_test_run).

The important design decision is to allow ID->FD transition for
CAP_SYS_ADMIN only. What it means that user processes can run
with CAP_BPF and CAP_NET_ADMIN and they will not be able to affect each
other unless they pass FDs via scm_rights or via pinning in bpffs.
ID->FD is a mechanism for human override and introspection.
An admin can do 'sudo bpftool prog ...'. It's possible to enforce via LSM that
only bpftool binary does bpf syscall with CAP_SYS_ADMIN and the rest of user
space processes do bpf syscall with CAP_BPF isolating bpf objects (progs, maps,
links) that are owned by such processes from each other.

Another significant change from LPC is that the verifier checks are split into
four flags. The allow_ptr_leaks flag allows pointer manipulations. The
bpf_capable flag enables all modern verifier features like bpf-to-bpf calls,
BTF, bounded loops, dead code elimination, etc. All the goodness. The
bypass_spec_v1 flag enables indirect stack access from bpf programs and
disables speculative analysis and bpf array mitigations. The bypass_spec_v4
flag disables store sanitation. That allows networking progs with CAP_BPF +
CAP_NET_ADMIN enjoy modern verifier features while being more secure.

Some networking progs may need CAP_BPF + CAP_NET_ADMIN + CAP_PERFMON,
since subtracting pointers (like skb->data_end - skb->data) is a pointer leak,
but the verifier may get smarter in the future.

Please see patches for more details.

Alexei Starovoitov (3):
  bpf, capability: Introduce CAP_BPF
  bpf: implement CAP_BPF
  selftests/bpf: use CAP_BPF and CAP_PERFMON in tests

 drivers/media/rc/bpf-lirc.c                   |  2 +-
 include/linux/bpf.h                           | 18 +++-
 include/linux/bpf_verifier.h                  |  3 +
 include/linux/capability.h                    |  5 ++
 include/uapi/linux/capability.h               | 34 +++++++-
 kernel/bpf/arraymap.c                         | 10 +--
 kernel/bpf/bpf_struct_ops.c                   |  2 +-
 kernel/bpf/core.c                             |  2 +-
 kernel/bpf/cpumap.c                           |  2 +-
 kernel/bpf/hashtab.c                          |  4 +-
 kernel/bpf/helpers.c                          |  4 +-
 kernel/bpf/lpm_trie.c                         |  2 +-
 kernel/bpf/map_in_map.c                       |  2 +-
 kernel/bpf/queue_stack_maps.c                 |  2 +-
 kernel/bpf/reuseport_array.c                  |  2 +-
 kernel/bpf/stackmap.c                         |  2 +-
 kernel/bpf/syscall.c                          | 87 ++++++++++++++-----
 kernel/bpf/verifier.c                         | 37 ++++----
 kernel/trace/bpf_trace.c                      |  3 +
 net/core/bpf_sk_storage.c                     |  4 +-
 net/core/filter.c                             |  4 +-
 security/selinux/include/classmap.h           |  4 +-
 tools/testing/selftests/bpf/test_verifier.c   | 44 ++++++++--
 tools/testing/selftests/bpf/verifier/calls.c  | 16 ++--
 .../selftests/bpf/verifier/dead_code.c        | 10 +--
 25 files changed, 221 insertions(+), 84 deletions(-)

-- 
2.23.0

