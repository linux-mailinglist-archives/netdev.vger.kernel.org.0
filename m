Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF61D229E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732278AbgEMXD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:03:58 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA9C061A0C;
        Wed, 13 May 2020 16:03:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so407864plo.7;
        Wed, 13 May 2020 16:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=er1ssAfIglw+q0hDY8np74FfThJJmd84hpOCUTP7dkY=;
        b=osmhLP3cuWZJtXCWtXsCvPrNdLB5y+ADdX1C0BGXcK57LgqSbCl6t+rsu+AdpxI42u
         eYNtTTTDwu8a9iP4BHdUNljcd4g5bNLnXYdJPZZ8YzofNYOMjoYtfuL9yoeNnfIzMa/G
         4qYIGFD0mpqkazY25R8SYW7SWENiWlvjRMMH18ylErq1nbiQeXHluW12NK9yYjCZNW0K
         E98/fLFksS1VGuoWp5kOwa1LlT8VTBGd18LEhfgmtveTGGl/eY77eW3YQu4hlH4fmkIE
         FvbPQzoEoKPJ+F2zvckGNJrXZIjJ01EZ/72MGs0SAmBpizY9E24kiH8P34WGRHKhvyxD
         N86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=er1ssAfIglw+q0hDY8np74FfThJJmd84hpOCUTP7dkY=;
        b=Naz+k2ZY8bMCsJKkEUZYaEilIEnO6c8AXkKD6pUWSMqAFiv7gwVFxeleXBhzhQ0eyM
         ZOvqevqgxa0R08H9gOEh3M3zYvWUspBDmgtYpqqhaye/eNKWDPE/dpFX3OvHrots/N45
         6iY2O8uJ6HhHAS5l0Uf3m+fIXlhjWsrmQosdBrUdAwf9DsHIXjNz5eInhcSdUUsml4/q
         6fI1nQJw0lXlt4AYbMR9/KJ+Ys/j0p3qU+ii6bIRNfBTsyc0G/QtTkIdsTGfnK4ZbFJM
         FaLEIupzk/JqYXu4HsDFxfodfSAak0MJYAkfGQnC4plyUN0/QyhjZw7RDOqjvlSdrEe+
         o6mQ==
X-Gm-Message-State: AOAM533GKFc2epjv8QdVoWKuchVra5JMRv7IKxY5zeDD6C0/yLIWTP0t
        0nXHmSVmQGXd1HRm55qomMRqrRsq
X-Google-Smtp-Source: ABdhPJxhJZqAjGCUiZ1BCBg6z5R7UnF23i0uL4yUqhJbrN/OorhOTeqDT5eXqmJvb0KYZCewEU8FDA==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr1473753plk.64.1589411038068;
        Wed, 13 May 2020 16:03:58 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id t23sm16558706pji.32.2020.05.13.16.03.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 16:03:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v7 bpf-next 0/3] Introduce CAP_BPF
Date:   Wed, 13 May 2020 16:03:52 -0700
Message-Id: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v6->v7:
- permit SK_REUSEPORT program type under CAP_BPF as suggested by Marek Majkowski.
  It's equivalent to SOCKET_FILTER which is unpriv.

v5->v6:
- split allow_ptr_leaks into four flags.
- retain bpf_jit_limit under cap_sys_admin.
- fixed few other issues spotted by Daniel.

v4->v5:

Split BPF operations that are allowed under CAP_SYS_ADMIN into combination of
CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN and keep some of them under CAP_SYS_ADMIN.

The user process has to have
- CAP_BPF to create maps, do other sys_bpf() commands and load SK_REUSEPORT progs.
  Note: dev_map, sock_hash, sock_map map types still require CAP_NET_ADMIN.
  That could be relaxed in the future.
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
 include/uapi/linux/capability.h               | 34 ++++++-
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
 kernel/bpf/syscall.c                          | 89 ++++++++++++++-----
 kernel/bpf/verifier.c                         | 37 ++++----
 kernel/trace/bpf_trace.c                      |  3 +
 net/core/bpf_sk_storage.c                     |  4 +-
 net/core/filter.c                             |  4 +-
 security/selinux/include/classmap.h           |  4 +-
 tools/testing/selftests/bpf/test_verifier.c   | 44 +++++++--
 tools/testing/selftests/bpf/verifier/calls.c  | 16 ++--
 .../selftests/bpf/verifier/dead_code.c        | 10 +--
 25 files changed, 223 insertions(+), 84 deletions(-)

-- 
2.23.0

