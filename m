Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC3E3689BE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhDWA1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWA1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:24 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B16C061574;
        Thu, 22 Apr 2021 17:26:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j7so24622855pgi.3;
        Thu, 22 Apr 2021 17:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jeEDLg+StEu7eh4HI+ViR1Zz997ewh1U1o6wpHZqTmI=;
        b=ct7pmBZrh9qEm6cX5vKxb/I1qJpOJdz1D/Y7Pj+EaDhF73jr3oE1N3I3xtXvY0ni8Q
         aFPj3VabNDPgpwfTEUXJSizdkm5tKY4GAvN08YNnmihbvJpl5rS/RNTe7O7zDo1eEaUL
         SK9rYq8eMVJu6cCaLSGvGaEwG4hRuSkFyigK6rFbUEEtWncd8/67bwvegkyp58AbDYhy
         eC4CFa6Yz4xyvZw2o91WhMFbn9zyx2FvmSuEz56dU4voQNmF7kELbLuG9qXAQ0CY6gbi
         1yjStUvmk6bJN/Vskq7SxuT0USQ/um71czqVexUm2oksSmWxvw/AYCezJH1u8jYD7E4B
         Z8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jeEDLg+StEu7eh4HI+ViR1Zz997ewh1U1o6wpHZqTmI=;
        b=JzhQpf1RXkYqkB+oLertvCdZcD1lgdJJi+ogJRXss2WXT6y5phnaiDZkjiOG3RBCDJ
         jX0rMOkBelCIRrPCUVGBDKnfqMx9C57qqYtG+PVYSKKLY4ayQcXfmQc64UqgIgevm+S7
         90t7OaVnskWhx+j28Prw0yvlgclNzFvQzmC4AAk6hzL21t6Ue0R8W1GvyiPddIxz9iFT
         C4Fk9EABIrYendH9AEllfCs4sSLKZW97IIwYcxhOapFXagMXuypn90IhCvpQZPxOsmN3
         OE/wh+w4mzvExebWZaAGfiS1Sz8a5ViJ5LIidy9MwgpRT0KXR3kPkVIXkl6mlKVX122m
         D+Tw==
X-Gm-Message-State: AOAM531JdxiX5oZIqMBEGlaRanmCoBn/9lcHhG5crMc3iuOTufqAEz4i
        4n9LPz3tGwUxj6nK7Brd1v36BH9XRnw=
X-Google-Smtp-Source: ABdhPJwH4dVtZtDosaxyk/G1wJrZ83i+I5XFIOGoIX+dFGFS28BYBB/mBLZxMStSgzBPz6l0FtYBsw==
X-Received: by 2002:aa7:9837:0:b029:264:b19e:acce with SMTP id q23-20020aa798370000b0290264b19eaccemr1115112pfl.79.1619137608541;
        Thu, 22 Apr 2021 17:26:48 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.26.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:26:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 00/16] bpf: syscall program, FD array, loader program, light skeleton.
Date:   Thu, 22 Apr 2021 17:26:30 -0700
Message-Id: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2: Addressed comments from Al, Yonghong and Andrii.
- documented sys_close fdget/fdput requirement and non-recursion check.
- reduced internal api leaks between libbpf and bpftool.
  Now bpf_object__gen_loader() is the only new libbf api with minimal fields.
- fixed light skeleton __destroy() method to munmap and close maps and progs.
- refactored bpf_btf_find_by_name_kind to return btf_id | (btf_obj_fd << 32).
- refactored use of bpf_btf_find_by_name_kind from loader prog.
- moved auto-gen like code into skel_internal.h that is used by *.lskel.h
  It has minimal static inline bpf_load_and_run() method used by lskel.
- added lksel.h example in patch 15.
- replaced union bpf_map_prog_desc with struct bpf_map_desc and struct bpf_prog_desc.
- removed mark_feat_supported and added a patch to pass 'obj' into kernel_supports.
- added proper tracking of temporary FDs in loader prog and their cleanup via bpf_sys_close.
- rename gen_trace.c into gen_loader.c to better align the naming throughout.
- expanded number of available helpers in new prog type.
- added support for raw_tp attaching in lskel.
  lskel supports tracing and raw_tp progs now.
  It correctly loads all networking prog types too, but __attach() method is tbd.
- converted progs/test_ksyms_module.c to lskel.
- minor feedback fixes all over.

One thing that was not addressed from feedback is the name of new program type.
Currently it's still:
BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */

The concern raised was that it sounds like a program that should be attached
to a syscall. Like BPF_PROG_TYPE_KPROBE is used to process kprobes.
I've considered and rejected:
BPF_PROG_TYPE_USER - too generic
BPF_PROG_TYPE_USERCTX - ambiguous with uprobes
BPF_PROG_TYPE_LOADER - ok-ish, but imo TYPE_SYSCALL is cleaner.
Other suggestions?

The description of V1 set is still valid:
----
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

Alexei Starovoitov (16):
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
  libbpf: Add bpf_object pointer to kernel_supports().
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
 kernel/bpf/btf.c                              |  76 ++-
 kernel/bpf/syscall.c                          | 195 ++++--
 kernel/bpf/verifier.c                         |  81 ++-
 net/bpf/test_run.c                            |  45 +-
 tools/bpf/bpftool/Makefile                    |   2 +-
 tools/bpf/bpftool/gen.c                       | 313 ++++++++-
 tools/bpf/bpftool/main.c                      |   7 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      |  80 +++
 tools/bpf/bpftool/xlated_dumper.c             |   3 +
 tools/include/uapi/linux/bpf.h                |  39 +-
 tools/lib/bpf/Build                           |   2 +-
 tools/lib/bpf/bpf.c                           |   1 +
 tools/lib/bpf/bpf_gen_internal.h              |  40 ++
 tools/lib/bpf/gen_loader.c                    | 615 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        | 399 +++++++++---
 tools/lib/bpf/libbpf.h                        |  12 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/libbpf_internal.h               |   3 +
 tools/lib/bpf/skel_internal.h                 | 105 +++
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  16 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |   6 +-
 .../selftests/bpf/prog_tests/fentry_test.c    |   4 +-
 .../selftests/bpf/prog_tests/fexit_sleep.c    |   6 +-
 .../selftests/bpf/prog_tests/fexit_test.c     |   4 +-
 .../selftests/bpf/prog_tests/kfunc_call.c     |   6 +-
 .../selftests/bpf/prog_tests/ksyms_module.c   |   2 +-
 .../selftests/bpf/prog_tests/syscall.c        |  53 ++
 tools/testing/selftests/bpf/progs/syscall.c   | 121 ++++
 .../selftests/bpf/progs/test_subprogs.c       |  13 +
 38 files changed, 2198 insertions(+), 211 deletions(-)
 create mode 100644 include/linux/bpfptr.h
 create mode 100644 tools/lib/bpf/bpf_gen_internal.h
 create mode 100644 tools/lib/bpf/gen_loader.c
 create mode 100644 tools/lib/bpf/skel_internal.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
 create mode 100644 tools/testing/selftests/bpf/progs/syscall.c

-- 
2.30.2

