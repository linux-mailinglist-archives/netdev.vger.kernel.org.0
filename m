Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C3560349A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiJRVGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRVGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:06:36 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1B29AC31;
        Tue, 18 Oct 2022 14:06:34 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oktnD-000FZO-Qh; Tue, 18 Oct 2022 23:06:31 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-10-18
Date:   Tue, 18 Oct 2022 23:06:31 +0200
Message-Id: <20221018210631.11211-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26693/Tue Oct 18 10:02:42 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 33 non-merge commits during the last 14 day(s) which contain
a total of 31 files changed, 874 insertions(+), 538 deletions(-).

The main changes are:

1) Add RCU grace period chaining to BPF to wait for the completion of access from
   both sleepable and non-sleepable BPF programs, from Hou Tao & Paul E. McKenney.

2) Improve helper UAPI by explicitly defining BPF_FUNC_xxx integer values. In
   the wild we have seen OS vendors doing buggy backports where helper call numbers
   mismatched. This is an attempt to make backports more foolproof, from Andrii Nakryiko.

3) Add libbpf *_opts API-variants for bpf_*_get_fd_by_id() functions, from Roberto Sassu.

4) Fix libbpf's BTF dumper for structs with padding-only fields, from Eduard Zingerman.

5) Fix various libbpf bugs which have been found from fuzzing with malformed BPF
   object files, from Shung-Hsi Yu.

6) Clean up an unneeded check on existence of SSE2 in BPF x86-64 JIT, from Jie Meng.

7) Fix various ASAN bugs in both libbpf and selftests when running the BPF selftest
   suite on arm64, from Xu Kuohai.

8) Fix missing bpf_iter_vma_offset__destroy() call in BPF iter selftest and use
   in-skeleton link pointer to remove an explicit bpf_link__destroy(), from Jiri Olsa.

9) Fix BPF CI breakage by pointing to iptables-legacy instead of relying on
   symlinked iptables which got upgraded to iptables-nft, from Martin KaFai Lau.

10) Minor BPF selftest improvements all over the place, from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrea Terzolo, Daniel Müller, David Vernet, Hou 
Tao, Jiri Olsa, KP Singh, Martin KaFai Lau, Quentin Monnet, Toke 
Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit 0326074ff4652329f2a1a9c8685104576bd8d131:

  Merge tag 'net-next-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-10-04 13:38:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 6c4e777fbba6e7dd6a0757c0e7bba66cdbe611cd:

  bpf/docs: Update README for most recent vmtest.sh (2022-10-18 21:54:05 +0200)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Remove unnecessary RCU grace period chaining'

Andrii Nakryiko (8):
      selftests/bpf: allow requesting log level 2 in test_verifier
      selftests/bpf: avoid reporting +100% difference in veristat for actual 0%
      selftests/bpf: add BPF object fixup step to veristat
      bpf: explicitly define BPF_FUNC_xxx integer values
      scripts/bpf_doc.py: update logic to not assume sequential enum values
      Merge branch 'Add _opts variant for bpf_*_get_fd_by_id()'
      Merge branch 'Fix bugs found by ASAN when running selftests'
      Merge branch 'libbpf: fix fuzzer-reported issues'

Daniel Müller (1):
      bpf/docs: Update README for most recent vmtest.sh

David Vernet (1):
      selftests/bpf: Alphabetize DENYLISTs

Eduard Zingerman (2):
      bpftool: Print newline before '}' for struct with padding only fields
      selftests/bpf: Test btf dump for struct with padding only fields

Hou Tao (4):
      selftests/bpf: Use sys_pidfd_open() helper when possible
      bpf: Use rcu_trace_implies_rcu_gp() in bpf memory allocator
      bpf: Use rcu_trace_implies_rcu_gp() in local storage map
      bpf: Use rcu_trace_implies_rcu_gp() for program array freeing

Jie Meng (1):
      bpf, x64: Remove unnecessary check on existence of SSE2

Jiri Olsa (1):
      selftests/bpf: Add missing bpf_iter_vma_offset__destroy call

Martin KaFai Lau (1):
      selftests/bpf: S/iptables/iptables-legacy/ in the bpf_nf and xdp_synproxy test

Paul E. McKenney (1):
      rcu-tasks: Provide rcu_trace_implies_rcu_gp()

Roberto Sassu (6):
      libbpf: Fix LIBBPF_1.0.0 declaration in libbpf.map
      libbpf: Introduce bpf_get_fd_by_id_opts and bpf_map_get_fd_by_id_opts()
      libbpf: Introduce bpf_prog_get_fd_by_id_opts()
      libbpf: Introduce bpf_btf_get_fd_by_id_opts()
      libbpf: Introduce bpf_link_get_fd_by_id_opts()
      selftests/bpf: Add tests for _opts variants of bpf_*_get_fd_by_id()

Shung-Hsi Yu (3):
      libbpf: Use elf_getshdrnum() instead of e_shnum
      libbpf: Deal with section with no data gracefully
      libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Xu Kuohai (6):
      libbpf: Fix use-after-free in btf_dump_name_dups
      libbpf: Fix memory leak in parse_usdt_arg()
      selftests/bpf: Fix memory leak caused by not destroying skeleton
      selftest/bpf: Fix memory leak in kprobe_multi_test
      selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
      selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c

Yonghong Song (1):
      selftests/bpf: Add selftest deny_namespace to s390x deny list

 arch/x86/net/bpf_jit_comp.c                        |   3 +-
 include/linux/rcupdate.h                           |  12 +
 include/uapi/linux/bpf.h                           | 432 +++++++++++----------
 kernel/bpf/bpf_local_storage.c                     |  13 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/bpf/memalloc.c                              |  15 +-
 kernel/rcu/tasks.h                                 |   2 +
 scripts/bpf_doc.py                                 |  46 ++-
 tools/include/uapi/linux/bpf.h                     | 432 +++++++++++----------
 tools/lib/bpf/bpf.c                                |  48 ++-
 tools/lib/bpf/bpf.h                                |  16 +
 tools/lib/bpf/btf_dump.c                           |  35 +-
 tools/lib/bpf/libbpf.c                             |  22 +-
 tools/lib/bpf/libbpf.map                           |   6 +-
 tools/lib/bpf/usdt.c                               |  11 +-
 tools/testing/selftests/bpf/DENYLIST               |   3 +-
 tools/testing/selftests/bpf/DENYLIST.s390x         |  39 +-
 tools/testing/selftests/bpf/README.rst             |  11 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  21 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   6 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  26 +-
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c      |  87 +++++
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |   3 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |   3 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   7 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |   6 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |   9 +
 .../bpf/progs/test_libbpf_get_fd_by_id_opts.c      |  36 ++
 .../selftests/bpf/task_local_storage_helpers.h     |   4 +
 tools/testing/selftests/bpf/test_verifier.c        |  13 +-
 tools/testing/selftests/bpf/veristat.c             |  37 +-
 31 files changed, 874 insertions(+), 538 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
