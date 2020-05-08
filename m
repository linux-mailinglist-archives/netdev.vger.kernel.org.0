Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76451CBA31
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgEHVxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:53:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF0C061A0C;
        Fri,  8 May 2020 14:53:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so1315396plo.7;
        Fri, 08 May 2020 14:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0IFR0h7OLcP9nzroEDpbOPCzbh/8YeEpc372ErB+Kpc=;
        b=VilCcbokLSxMEvtENEwNtFe4FAMll9KhKBMn4lFhOMQTO2pg7cXq8XCjX6bRlzOQCu
         wOFStPo+/6Zj94ch9T19DOdn7bh1v24IVtBzFzUPV6NFxTo5PSw1wtdLdPC7MwryOa0/
         sZnjE3261bOHq8Cnj6glt4O+uJO1J0X1g7S9S/erfxqzoBFrpWhRVNLsZyb311Uc6dFd
         YBMcPOF/tzMsLyRIk+7UJ8NUtAFMC4AcOAVOrjfmUYdbkuJgdXy7y2PbzyCaORhFOSi9
         KcAqLOerIl12FfefDLAPT5lSenWeOB+W1hie1nvdBEGMkNqCBcXs4nwr7nThlJTowRmj
         WrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0IFR0h7OLcP9nzroEDpbOPCzbh/8YeEpc372ErB+Kpc=;
        b=UcJSSK3hgS+bs2lbyyuQXnZb8DRYxwvx6txw9BM3heX9U5YD+Rfq73XVi3fUuIhnE/
         eaLQJRt45lv2Hz2513Nvei87PrZWta59NPWqs1uPaNqbBrdaSCFCPLQ8Ep4pjj2JBhOv
         B+H+5xi6hBy32BXePHJ1C6pEUoYdCplCjsleLjwgKbZrJVbu1lHYghO/XDGAE000jvL3
         p7ELbt9lVRbbTIdLEWN7YXMp7g7zmZ0NguxZstpsk4t7N3diub9A7XiKT02gltH3TFM3
         HkEeKSFoca4TY38NUXfktDpeDzCjdLdwLS5T4EolwxUqP5q2heUnTsPQQvnW5WaMc4vV
         G8bQ==
X-Gm-Message-State: AGi0PuYzxVDusiYeUuh+NYBLcyrpLIAB29gPVCCsYoUAPiNGkX8QsUNC
        8IjrV042U7GChXqR9YYTMws=
X-Google-Smtp-Source: APiQypKY1sDaqstTjGiDf1cpTFTjJylPmNPEPJ+1VGhfej+i+0LSFTMyQudGVapapEMnnFc4IfDtqg==
X-Received: by 2002:a17:902:549:: with SMTP id 67mr4336714plf.115.1588974823726;
        Fri, 08 May 2020 14:53:43 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 20sm2720763pfx.116.2020.05.08.14.53.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 May 2020 14:53:42 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v5 bpf-next 0/3] Introduce CAP_BPF
Date:   Fri,  8 May 2020 14:53:37 -0700
Message-Id: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v4->v5:

Split BPF operations that are allowed under CAP_SYS_ADMIN into combination of
CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN and keep some of them under CAP_SYS_ADMIN.

The user process has to have
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
allow_ptr_leaks and bpf_capable flags. The allow_ptr_leaks disables spectre
defense and allows pointer manipulations while bpf_capable enables all modern
verifier features like bpf-to-bpf calls, BTF, bounded loops, indirect stack
access, dead code elimination, etc. All the goodness.
These flags are initialized as:
  env->allow_ptr_leaks = perfmon_capable();
  env->bpf_capable = bpf_capable();
That allows networking progs with CAP_BPF + CAP_NET_ADMIN enjoy modern
verifier features while being more secure.

Some networking progs may need CAP_BPF + CAP_NET_ADMIN + CAP_PERFMON,
since subtracting pointers (like skb->data_end - skb->data) is a pointer leak,
but the verifier may get smarter in the future.

Please see patches for more details.

Alexei Starovoitov (3):
  bpf, capability: Introduce CAP_BPF
  bpf: implement CAP_BPF
  selftests/bpf: use CAP_BPF and CAP_PERFMON in tests

 drivers/media/rc/bpf-lirc.c                   |  2 +-
 include/linux/bpf_verifier.h                  |  1 +
 include/linux/capability.h                    |  5 ++
 include/uapi/linux/capability.h               | 34 +++++++-
 kernel/bpf/arraymap.c                         |  2 +-
 kernel/bpf/bpf_struct_ops.c                   |  2 +-
 kernel/bpf/core.c                             |  4 +-
 kernel/bpf/cpumap.c                           |  2 +-
 kernel/bpf/hashtab.c                          |  4 +-
 kernel/bpf/helpers.c                          |  4 +-
 kernel/bpf/lpm_trie.c                         |  2 +-
 kernel/bpf/queue_stack_maps.c                 |  2 +-
 kernel/bpf/reuseport_array.c                  |  2 +-
 kernel/bpf/stackmap.c                         |  2 +-
 kernel/bpf/syscall.c                          | 87 ++++++++++++++-----
 kernel/bpf/verifier.c                         | 24 ++---
 kernel/trace/bpf_trace.c                      |  3 +
 net/core/bpf_sk_storage.c                     |  4 +-
 net/core/filter.c                             |  4 +-
 security/selinux/include/classmap.h           |  4 +-
 tools/testing/selftests/bpf/test_verifier.c   | 44 ++++++++--
 tools/testing/selftests/bpf/verifier/calls.c  | 16 ++--
 .../selftests/bpf/verifier/dead_code.c        | 10 +--
 23 files changed, 191 insertions(+), 73 deletions(-)

-- 
2.23.0

