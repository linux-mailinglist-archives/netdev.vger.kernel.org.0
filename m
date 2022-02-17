Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6F64BAD99
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 00:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiBQX4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 18:56:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiBQX4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 18:56:13 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112BD50B08;
        Thu, 17 Feb 2022 15:55:50 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nKq4Z-000GSN-LA; Fri, 18 Feb 2022 00:20:27 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-02-17
Date:   Fri, 18 Feb 2022 00:20:27 +0100
Message-Id: <20220217232027.29831-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26456/Thu Feb 17 10:25:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 29 non-merge commits during the last 8 day(s) which contain
a total of 34 files changed, 1502 insertions(+), 524 deletions(-).

The main changes are:

1) Add BTFGen support to bpftool which allows to use CO-RE in kernels without
   BTF info, from Mauricio Vásquez, Rafael David Tinoco, Lorenzo Fontana and
   Leonardo Di Donato. (Details: https://lpc.events/event/11/contributions/948/)

2) Prepare light skeleton to be used in both kernel module and user space
   and convert bpf_preload.ko to use light skeleton, from Alexei Starovoitov.

3) Rework bpftool's versioning scheme and align with libbpf's version number;
   also add linked libbpf version info to "bpftool version", from Quentin Monnet.

4) Add minimal C++ specific additions to bpftool's skeleton codegen to
   facilitate use of C skeletons in C++ applications, from Andrii Nakryiko.

5) Add BPF verifier sanity check whether relative offset on kfunc calls overflows
   desc->imm and reject the BPF program if the case, from Hou Tao.

6) Fix libbpf to use a dynamically allocated buffer for netlink messages to
   avoid receiving truncated messages on some archs, from Toke Høiland-Jørgensen.

7) Various follow-up fixes to the JIT bpf_prog_pack allocator, from Song Liu.

8) Various BPF selftest and vmtest.sh fixes, from Yucong Sun.

9) Fix bpftool pretty print handling on dumping map keys/values when no BTF
   is available, from Jiri Olsa and Yinjun Zhang.

10) Extend XDP frags selftest to check for invalid length, from Lorenzo Bianconi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Jiri Olsa, Kumar Kartikeya Dwivedi, 
Niklas Söderlund, Stephen Rothwell, Toke Høiland-Jørgensen, Yonghong 
Song, Zhiqian Guan

----------------------------------------------------------------

The following changes since commit 4f5e483b8c7a644733db941a1ae00173baa7b463:

  net: dsa: qca8k: fix noderef.cocci warnings (2022-02-10 10:56:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to d24d2a2b0a81dd5e9bb99aeb4559ec9734e1416f:

  bpf: bpf_prog_pack: Set proper size before freeing ro_header (2022-02-17 13:15:36 -0800)

----------------------------------------------------------------
Alexei Starovoitov (6):
      bpf: Extend sys_bpf commands for bpf_syscall programs.
      libbpf: Prepare light skeleton for the kernel.
      bpftool: Generalize light skeleton generation.
      bpf: Update iterators.lskel.h.
      bpf: Convert bpf_preload.ko to use light skeleton.
      Merge branch 'Make BPF skeleton easier to use from C++ code'

Andrii Nakryiko (8):
      Merge branch 'bpftool: Switch to new versioning scheme (align on libbpf's)'
      libbpf: Fix libbpf.map inheritance chain for LIBBPF_0.7.0
      selftests/bpf: Fix GCC11 compiler warnings in -O2 mode
      bpftool: Add C++-specific open/load/etc skeleton wrappers
      selftests/bpf: Add Skeleton templated wrapper as an example
      Merge branch 'libbpf: Implement BTFGen'
      bpftool: Fix C++ additions to skeleton
      libbpf: Fix memleak in libbpf_netlink_recv()

Daniel Borkmann (1):
      Merge branch 'bpf-light-skel'

Hou Tao (1):
      bpf: Reject kfunc calls that overflow insn->imm

Jiri Olsa (1):
      bpftool: Fix pretty print dump for maps without BTF loaded

Lorenzo Bianconi (1):
      selftest/bpf: Check invalid length in test_xdp_update_frags

Mauricio Vásquez (6):
      libbpf: Split bpf_core_apply_relo()
      libbpf: Expose bpf_core_{add,free}_cands() to bpftool
      bpftool: Add gen min_core_btf command
      bpftool: Implement "gen min_core_btf" logic
      bpftool: Implement btfgen_get_btf()
      selftests/bpf: Test "bpftool gen min_core_btf"

Quentin Monnet (2):
      bpftool: Add libbpf's version number to "bpftool version" output
      bpftool: Update versioning scheme, align on libbpf's version number

Rafael David Tinoco (1):
      bpftool: Gen min_core_btf explanation and examples

Song Liu (2):
      bpf: Fix bpf_prog_pack build for ppc64_defconfig
      bpf: bpf_prog_pack: Set proper size before freeing ro_header

Toke Høiland-Jørgensen (1):
      libbpf: Use dynamically allocated buffer when receiving netlink messages

Yinjun Zhang (1):
      bpftool: Fix the error when lookup in no-btf maps

Yucong Sun (2):
      selftests/bpf: Fix vmtest.sh to launch smp vm.
      selftests/bpf: Fix crash in core_reloc when bpftool btfgen fails

 kernel/bpf/btf.c                                   |  13 +-
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/inode.c                                 |  39 +-
 kernel/bpf/preload/Kconfig                         |   7 +-
 kernel/bpf/preload/Makefile                        |  14 +-
 kernel/bpf/preload/bpf_preload.h                   |   8 +-
 kernel/bpf/preload/bpf_preload_kern.c              | 119 ++--
 kernel/bpf/preload/bpf_preload_umd_blob.S          |   7 -
 kernel/bpf/preload/iterators/bpf_preload_common.h  |  13 -
 kernel/bpf/preload/iterators/iterators.c           | 108 ----
 kernel/bpf/preload/iterators/iterators.lskel.h     | 141 +++--
 kernel/bpf/syscall.c                               |  40 +-
 kernel/bpf/verifier.c                              |  11 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |  90 +++
 tools/bpf/bpftool/Documentation/common_options.rst |  13 +-
 tools/bpf/bpftool/Makefile                         |  14 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   6 +-
 tools/bpf/bpftool/gen.c                            | 654 ++++++++++++++++++++-
 tools/bpf/bpftool/main.c                           |  25 +
 tools/bpf/bpftool/map.c                            |  33 +-
 tools/lib/bpf/gen_loader.c                         |  15 +-
 tools/lib/bpf/libbpf.c                             |  88 +--
 tools/lib/bpf/libbpf.map                           |   2 +-
 tools/lib/bpf/libbpf_internal.h                    |   9 +
 tools/lib/bpf/netlink.c                            |  63 +-
 tools/lib/bpf/relo_core.c                          |  79 +--
 tools/lib/bpf/relo_core.h                          |  42 +-
 tools/lib/bpf/skel_internal.h                      | 185 +++++-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  52 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    |  38 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |  87 ++-
 tools/testing/selftests/bpf/vmtest.sh              |   2 +-
 34 files changed, 1502 insertions(+), 524 deletions(-)
 delete mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 delete mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 delete mode 100644 kernel/bpf/preload/iterators/iterators.c
