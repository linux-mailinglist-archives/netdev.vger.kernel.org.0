Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A98362D3B
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhDQDdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbhDQDdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896A5C061574;
        Fri, 16 Apr 2021 20:32:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u11so11359115pjr.0;
        Fri, 16 Apr 2021 20:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oLLOhF5h3HEHXDRM46MODiHrnjR4R+ZWCobT5Aaqsx0=;
        b=o1U7zam7K5GKMjGjCSWScJaE3MY4Oztn8eDVTbSRnB3LE7taD7ubF4JwndPJEhl8Cq
         9otJWs+w5VvN4eOEr6InA/4wTlIf19t6LUq1OlyU5dJdbHFhN1WMQKuvKztJ7U6BB8F4
         nSvapJjrmztbwPe2PUcrxKBRrNT7bDBwp5+CkGa4z8HdpkxWGBWlJcyZDRhz/sLO6BFo
         YZuNLI6Opvy0p9pW6R+VeNOuxJuccKAdd49MhRSb5vR6FMYwSdWWniG+bTXhJRIYlBHK
         ykzZ4Z5DsC6/yhRBx9qTltjRm5JtiMO/UowtUC9cQRcE06B4tks++fPS0BpD5HoC7u0S
         yx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oLLOhF5h3HEHXDRM46MODiHrnjR4R+ZWCobT5Aaqsx0=;
        b=htd0H7hS6pMrdUeRiiiNHlEuS2zdoXP8WMFTUKk7ves40hipRkevsLI/nkzPaGQugw
         s4sWshGK4DBHuS0kmRhssTOZE83gsv5IH3VwVaNRVXgrYtYz93bNTq6FPzeriVRN2hVr
         uXQWgSOsP2pwfqggOnPhUNgLKwRjeTpxKhcKSZhwRTRua0F9YL0y/UG7maHY3Oxx6oIv
         9MJmLRoHy5MFrrVCkrKu+OYJawaEm0+LlXMkDGfO2EQLvWY4ulvD9q8V2kwgSTEnoAsg
         kOmQcIZRVWLwhbNyIcDZbgVdxFUSqKZmoAoMxCZq+Gy/lSUKIxw0CUL6Tda1qQZFFiIN
         pHtQ==
X-Gm-Message-State: AOAM533BBof3+oMtsr8YY213sXdx2u4RlSaEk0TA0LP9JJlT3DEfUycr
        DW0dAK6GOQcLtcYhqFHoa/3d/BNr3j4=
X-Google-Smtp-Source: ABdhPJwxh8CJdwj7gWe81twCFPVzHgFdZ44Ya4UBPmFSZTvF9Suy3P5HpglU2oso2mNSRcTPswz9jg==
X-Received: by 2002:a17:90b:14c4:: with SMTP id jz4mr12256917pjb.144.1618630346930;
        Fri, 16 Apr 2021 20:32:26 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:25 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 00/15] bpf: syscall program, FD array, loader program, light skeleton.
Date:   Fri, 16 Apr 2021 20:32:09 -0700
Message-Id: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

This is a first step towards signed bpf programs and the third approach of that kind.
The first approach was to bring libbpf into the kernel as a user-mode-driver.
The second approach was to invent a new file format and let kernel execute
that format as a sequence of syscalls that create maps and load programs.
This third approach is using new type of bpf program instead of inventing file format.
1st and 2nd approaches had too many downsides comparing to this 3rd and were discarded
after months of work.

To make it work the following new concepts are introduced:
1. syscall bpf program type
A kind of bpf program that can do sys_bpf and sys_close syscalls.
It can only execute in user context.

2. FD array or FD index.
Traditionally BPF instructions are patched with FDs.
What it means that maps has to be created first and then instructions modified
which breaks signature verification if the program is signed.
Instead of patching each instruction with FD patch it with an index into array of FDs.
That makes the program signature stable if it uses maps.

3. loader program that is generated as "strace of libbpf".
When libbpf is loading bpf_file.o it does a bunch of sys_bpf() syscalls to
load BTF, create maps, populate maps and finally load programs.
Instead of actually doing the syscalls generate a trace of what libbpf
would have done and represent it as the "loader program".
The "loader program" consists of single map and single bpf program that
does those syscalls.
Executing such "loader program" via bpf_prog_test_run() command will
replay the sequence of syscalls that libbpf would have done which will result
the same maps created and programs loaded as specified in the elf file.
The "loader program" removes libelf and majority of libbpf dependency from
program loading process.

4. light skeleton
Instead of embedding the whole elf file into skeleton and using libbpf
to parse it later generate a loader program and embed it into "light skeleton".
Such skeleton can load the same set of elf files, but it doesn't need
libbpf and libelf to do that. It only needs few sys_bpf wrappers.

Future steps:
- support CO-RE in the kernel. This patch set is already too big,
so that critical feature is left for the next step.
- generate light skeleton in golang to allow such users use BTF and
all other features provided by libbpf
- generate light skeleton for kernel, so that bpf programs can be embeded
in the kernel module. The UMD usage in bpf_preload will be replaced with
such skeleton, so bpf_preload would become a standard kernel module
without user space dependency.
- finally do the signing of the loader program.

The patches are work in progress with few rough edges.

Alexei Starovoitov (15):
  bpf: Introduce bpf_sys_bpf() helper and program type.
  bpf: Introduce bpfptr_t user/kernel pointer.
  bpf: Prepare bpf syscall to be used from kernel and user space.
  libbpf: Support for syscall program type
  selftests/bpf: Test for syscall program type
  bpf: Make btf_load command to be bpfptr_t compatible.
  selftests/bpf: Test for btf_load command.
  bpf: Introduce fd_idx
  libbpf: Support for fd_idx
  bpf: Add bpf_btf_find_by_name_kind() helper.
  bpf: Add bpf_sys_close() helper.
  libbpf: Change the order of data and text relocations.
  libbpf: Generate loader program out of BPF ELF file.
  bpftool: Use syscall/loader program in "prog load" and "gen skeleton"
    command.
  selftests/bpf: Convert few tests to light skeleton.

 include/linux/bpf.h                           |  19 +-
 include/linux/bpf_types.h                     |   2 +
 include/linux/bpf_verifier.h                  |   1 +
 include/linux/bpfptr.h                        |  81 +++
 include/linux/btf.h                           |   2 +-
 include/uapi/linux/bpf.h                      |  39 +-
 kernel/bpf/bpf_iter.c                         |  13 +-
 kernel/bpf/btf.c                              |  59 +-
 kernel/bpf/syscall.c                          | 179 ++++--
 kernel/bpf/verifier.c                         |  81 ++-
 net/bpf/test_run.c                            |  45 +-
 tools/bpf/bpftool/Makefile                    |   2 +-
 tools/bpf/bpftool/gen.c                       | 263 ++++++++-
 tools/bpf/bpftool/main.c                      |   7 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      |  78 +++
 tools/bpf/bpftool/xlated_dumper.c             |   3 +
 tools/include/uapi/linux/bpf.h                |  39 +-
 tools/lib/bpf/Build                           |   2 +-
 tools/lib/bpf/bpf.c                           |  62 ++
 tools/lib/bpf/bpf.h                           |  35 ++
 tools/lib/bpf/bpf_gen_internal.h              |  38 ++
 tools/lib/bpf/gen_trace.c                     | 529 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        | 346 ++++++++++--
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/libbpf_internal.h               |   3 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  16 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |   6 +-
 .../selftests/bpf/prog_tests/fentry_test.c    |   4 +-
 .../selftests/bpf/prog_tests/fexit_sleep.c    |   6 +-
 .../selftests/bpf/prog_tests/fexit_test.c     |   4 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +-
 .../selftests/bpf/prog_tests/syscall.c        |  53 ++
 tools/testing/selftests/bpf/progs/syscall.c   | 121 ++++
 .../selftests/bpf/progs/test_subprogs.c       |  13 +
 36 files changed, 1972 insertions(+), 188 deletions(-)
 create mode 100644 include/linux/bpfptr.h
 create mode 100644 tools/lib/bpf/bpf_gen_internal.h
 create mode 100644 tools/lib/bpf/gen_trace.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
 create mode 100644 tools/testing/selftests/bpf/progs/syscall.c

-- 
2.30.2

