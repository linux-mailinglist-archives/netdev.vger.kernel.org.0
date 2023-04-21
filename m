Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567586EB3AD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjDUVcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjDUVcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:32:16 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B031BDA;
        Fri, 21 Apr 2023 14:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=+bstGHXSIVcHJvqo9FWb0DBk7O9MD4b69EQR+D41mvM=; b=a+jvbLUaRIVQcXSbYaBKTHGyY2
        u0X1xVIUxaJ9vuQkCitoXvslJQEtDpMMqvemI7eIsK7JohssP6LJDzl4hDZmHO+WM7Q1rJ6aCffYb
        PqR9iWMJZ8t/k3PWgczOF+6f1y10G7yGtqqvo5YGepxAAZePIBF9KXSGzHxvaLF2tbq5PJn5PmqGu
        zifEzki+GkgR3X44zqeOcHGA3uCOrxz/MqzEsZlG4dTi2SqHbuTl5hxQVXe2IhzmLF01N2i46QihM
        DTGyHBcZl6szF8UClj03OoMAuBJrXbhWhYusrjD0NhfPGOoNaG+oON9N2uPlZ7zzBBK/a9w4IDfXu
        8mC+QHSw==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ppy1b-000Ic0-U7; Fri, 21 Apr 2023 23:10:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-04-21
Date:   Fri, 21 Apr 2023 23:10:35 +0200
Message-Id: <20230421211035.9111-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26883/Fri Apr 21 09:25:39 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 71 non-merge commits during the last 8 day(s) which contain
a total of 116 files changed, 13397 insertions(+), 8896 deletions(-).

The main changes are:

1) Add a new BPF netfilter program type and minimal support to hook BPF programs to
   netfilter hooks such as prerouting or forward, from Florian Westphal.

2) Fix race between btf_put and btf_idr walk which caused a deadlock, from Alexei Starovoitov.

3) Second big batch to migrate test_verifier unit tests into test_progs for ease of
   readability and debugging, from Eduard Zingerman.

4) Add support for refcounted local kptrs to the verifier for allowing shared ownership,
   useful for adding a node to both the BPF list and rbtree, from Dave Marchevsky.

5) Migrate bpf_for(), bpf_for_each() and bpf_repeat() macros from BPF selftests into
   libbpf-provided bpf_helpers.h header and improve kfunc handling, from Andrii Nakryiko.

6) Support 64-bit pointers to kfuncs needed for archs like s390x, from Ilya Leoshkevich.

7) Support BPF progs under getsockopt with a NULL optval, from Stanislav Fomichev.

8) Improve verifier u32 scalar equality checking in order to enable LLVM transformations
   which earlier had to be disabled specifically for BPF backend, from Yonghong Song.

9) Extend bpftool's struct_ops object loading to support links, from Kui-Feng Lee.

10) Add xsk selftest follow-up fixes for hugepage allocated umem, from Magnus Karlsson.

11) Support BPF redirects from tc BPF to ifb devices, from Daniel Borkmann.

12) Add BPF support for integer type when accessing variable length arrays, from Feng Zhou.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Eduard Zingerman, Florian Westphal, Hao Luo, Jiri Olsa, Kal Cutter 
Conley, Martin KaFai Lau, Quentin Monnet, Sven Schnelle, Thomas Richter, 
Toke Høiland-Jørgensen, Tonghao Zhang, Yafang Shao

----------------------------------------------------------------

The following changes since commit c2865b1122595e69e7df52d01f7f02338b8babca:

  Daniel Borkmann says: (2023-04-13 16:43:38 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 4db10a8243df665ced10b027c2d4862173a7a3ec:

  selftests/bpf: verifier/value_ptr_arith converted to inline assembly (2023-04-21 12:27:19 -0700)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (9):
      selftests/bpf: Fix merge conflict due to SYS() macro change.
      selftests/bpf: Workaround for older vm_sockets.h.
      Merge branch 'Shared ownership for local kptrs'
      Merge branch 'Remove KF_KPTR_GET kfunc flag'
      Merge branch 'Provide bpf_for() and bpf_for_each() by libbpf'
      Merge branch 'Access variable length array relaxed for integer type'
      Merge branch 'fix __retval() being always ignored'
      bpf: Fix race between btf_put and btf_idr walk.
      Merge branch 'bpf: add netfilter program type'

Andrii Nakryiko (6):
      libbpf: misc internal libbpf clean ups around log fixup
      libbpf: report vmlinux vs module name when dealing with ksyms
      libbpf: improve handling of unresolved kfuncs
      selftests/bpf: add missing __weak kfunc log fixup test
      libbpf: move bpf_for(), bpf_for_each(), and bpf_repeat() into bpf_helpers.h
      libbpf: mark bpf_iter_num_{new,next,destroy} as __weak

Daniel Borkmann (1):
      bpf: Set skb redirect and from_ingress info in __bpf_tx_skb

Dave Marchevsky (10):
      bpf: Remove btf_field_offs, use btf_record's fields instead
      bpf: Introduce opaque bpf_refcount struct and add btf_record plumbing
      bpf: Support refcounted local kptrs in existing semantics
      bpf: Add bpf_refcount_acquire kfunc
      bpf: Migrate bpf_rbtree_add and bpf_list_push_{front,back} to possibly fail
      selftests/bpf: Modify linked_list tests to work with macro-ified inserts
      bpf: Migrate bpf_rbtree_remove to possibly fail
      bpf: Centralize btf_field-specific initialization logic
      selftests/bpf: Add refcounted_kptr tests
      bpf: Fix bpf_refcount_acquire's refcount_t address calculation

David Vernet (3):
      bpf: Remove bpf_kfunc_call_test_kptr_get() test kfunc
      bpf: Remove KF_KPTR_GET kfunc flag
      bpf,docs: Remove KF_KPTR_GET from documentation

Eduard Zingerman (26):
      selftests/bpf: disable program test run for progs/refcounted_kptr.c
      selftests/bpf: fix __retval() being always ignored
      selftests/bpf: add pre bpf_prog_test_run_opts() callback for test_loader
      selftests/bpf: populate map_array_ro map for verifier_array_access test
      selftests/bpf: Add notion of auxiliary programs for test_loader
      selftests/bpf: verifier/bounds converted to inline assembly
      selftests/bpf: verifier/bpf_get_stack converted to inline assembly
      selftests/bpf: verifier/btf_ctx_access converted to inline assembly
      selftests/bpf: verifier/ctx converted to inline assembly
      selftests/bpf: verifier/d_path converted to inline assembly
      selftests/bpf: verifier/direct_packet_access converted to inline assembly
      selftests/bpf: verifier/jeq_infer_not_null converted to inline assembly
      selftests/bpf: verifier/loops1 converted to inline assembly
      selftests/bpf: verifier/lwt converted to inline assembly
      selftests/bpf: verifier/map_in_map converted to inline assembly
      selftests/bpf: verifier/map_ptr_mixing converted to inline assembly
      selftests/bpf: verifier/ref_tracking converted to inline assembly
      selftests/bpf: verifier/regalloc converted to inline assembly
      selftests/bpf: verifier/runtime_jit converted to inline assembly
      selftests/bpf: verifier/search_pruning converted to inline assembly
      selftests/bpf: verifier/sock converted to inline assembly
      selftests/bpf: verifier/spin_lock converted to inline assembly
      selftests/bpf: verifier/subreg converted to inline assembly
      selftests/bpf: verifier/unpriv converted to inline assembly
      selftests/bpf: verifier/value_illegal_alu converted to inline assembly
      selftests/bpf: verifier/value_ptr_arith converted to inline assembly

Feng Zhou (2):
      bpf: support access variable length array of integer type
      selftests/bpf: Add test to access integer type of variable array

Florian Westphal (7):
      bpf: add bpf_link support for BPF_NETFILTER programs
      bpf: minimal support for programs hooked into netfilter framework
      netfilter: nfnetlink hook: dump bpf prog id
      netfilter: disallow bpf hook attachment at same priority
      tools: bpftool: print netfilter link info
      bpf: add test_run support for netfilter program type
      selftests/bpf: add missing netfilter return value and ctx access tests

Ilya Leoshkevich (1):
      bpf: Support 64-bit pointers to kfuncs

Kui-Feng Lee (2):
      bpftool: Register struct_ops with a link.
      bpftool: Update doc to explain struct_ops register subcommand.

Magnus Karlsson (2):
      selftests/xsk: Fix munmap for hugepage allocated umem
      selftests/xsk: Put MAP_HUGE_2MB in correct argument

Quentin Monnet (1):
      bpftool: Replace "__fallthrough" by a comment to address merge conflict

Rong Tao (1):
      samples/bpf: sampleip: Replace PAGE_OFFSET with _text address

Sean Young (1):
      bpf: lirc program type should not require SYS_CAP_ADMIN

Stanislav Fomichev (2):
      bpf: Don't EFAULT for getsockopt with optval=NULL
      selftests/bpf: Verify optval=NULL case

Yafang (1):
      bpf: Add preempt_count_{sub,add} into btf id deny list

Yonghong Song (2):
      bpf: Improve verifier u32 scalar equality checking
      selftests/bpf: Add a selftest for checking subreg equality

 Documentation/bpf/kfuncs.rst                       |   21 +-
 arch/s390/net/bpf_jit_comp.c                       |    5 +
 include/linux/bpf.h                                |   93 +-
 include/linux/bpf_types.h                          |    4 +
 include/linux/bpf_verifier.h                       |    7 +-
 include/linux/btf.h                                |    3 -
 include/linux/filter.h                             |    1 +
 include/linux/netfilter.h                          |    1 +
 include/linux/skbuff.h                             |    9 +
 include/net/netfilter/nf_bpf_link.h                |   15 +
 include/uapi/linux/bpf.h                           |   18 +
 include/uapi/linux/netfilter/nfnetlink_hook.h      |   24 +-
 kernel/bpf/btf.c                                   |  148 +-
 kernel/bpf/cgroup.c                                |    9 +-
 kernel/bpf/core.c                                  |   11 +
 kernel/bpf/helpers.c                               |  113 +-
 kernel/bpf/map_in_map.c                            |   15 -
 kernel/bpf/syscall.c                               |   30 +-
 kernel/bpf/verifier.c                              |  355 +++--
 net/bpf/test_run.c                                 |  170 ++-
 net/core/filter.c                                  |    2 +
 net/netfilter/Kconfig                              |    3 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/core.c                               |   12 +
 net/netfilter/nf_bpf_link.c                        |  228 +++
 net/netfilter/nfnetlink_hook.c                     |   81 +-
 samples/bpf/sampleip_user.c                        |   11 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |   12 +-
 tools/bpf/bpftool/btf_dumper.c                     |    2 +-
 tools/bpf/bpftool/common.c                         |   14 +
 tools/bpf/bpftool/link.c                           |   83 ++
 tools/bpf/bpftool/main.h                           |    6 +
 tools/bpf/bpftool/net.c                            |  106 ++
 tools/bpf/bpftool/prog.c                           |   13 -
 tools/bpf/bpftool/struct_ops.c                     |   70 +-
 tools/include/uapi/linux/bpf.h                     |   18 +
 tools/lib/bpf/bpf_helpers.h                        |  103 ++
 tools/lib/bpf/libbpf.c                             |  110 +-
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/testing/selftests/bpf/bpf_experimental.h     |   60 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   20 +
 .../bpf/prog_tests/access_variable_array.c         |   16 +
 .../testing/selftests/bpf/prog_tests/linked_list.c |   96 +-
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |   31 +
 tools/testing/selftests/bpf/prog_tests/rbtree.c    |   25 +
 .../selftests/bpf/prog_tests/refcounted_kptr.c     |   18 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |    5 +
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |   28 +
 .../selftests/bpf/prog_tests/tracing_struct.c      |    2 +
 tools/testing/selftests/bpf/prog_tests/verifier.c  |  112 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    4 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  109 +-
 tools/testing/selftests/bpf/progs/linked_list.c    |   34 +-
 tools/testing/selftests/bpf/progs/linked_list.h    |    4 +-
 .../testing/selftests/bpf/progs/linked_list_fail.c |   96 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |   40 +-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |   78 -
 tools/testing/selftests/bpf/progs/rbtree.c         |   74 +-
 tools/testing/selftests/bpf/progs/rbtree_fail.c    |   77 +-
 .../testing/selftests/bpf/progs/refcounted_kptr.c  |  406 ++++++
 .../selftests/bpf/progs/refcounted_kptr_fail.c     |   72 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   12 +
 .../bpf/progs/test_access_variable_array.c         |   19 +
 tools/testing/selftests/bpf/progs/test_log_fixup.c |   10 +
 tools/testing/selftests/bpf/progs/tracing_struct.c |   13 +
 .../testing/selftests/bpf/progs/verifier_bounds.c  | 1076 ++++++++++++++
 .../selftests/bpf/progs/verifier_bpf_get_stack.c   |  124 ++
 .../selftests/bpf/progs/verifier_btf_ctx_access.c  |   32 +
 tools/testing/selftests/bpf/progs/verifier_ctx.c   |  221 +++
 .../testing/selftests/bpf/progs/verifier_d_path.c  |   48 +
 .../bpf/progs/verifier_direct_packet_access.c      |  803 +++++++++++
 .../bpf/progs/verifier_jeq_infer_not_null.c        |  213 +++
 .../testing/selftests/bpf/progs/verifier_loops1.c  |  259 ++++
 tools/testing/selftests/bpf/progs/verifier_lwt.c   |  234 +++
 .../selftests/bpf/progs/verifier_map_in_map.c      |  142 ++
 .../selftests/bpf/progs/verifier_map_ptr_mixing.c  |  265 ++++
 .../selftests/bpf/progs/verifier_netfilter_ctx.c   |  121 ++
 .../bpf/progs/verifier_netfilter_retcode.c         |   49 +
 .../selftests/bpf/progs/verifier_ref_tracking.c    | 1495 ++++++++++++++++++++
 .../selftests/bpf/progs/verifier_reg_equal.c       |   58 +
 .../selftests/bpf/progs/verifier_regalloc.c        |  364 +++++
 .../selftests/bpf/progs/verifier_runtime_jit.c     |  360 +++++
 .../selftests/bpf/progs/verifier_search_pruning.c  |  339 +++++
 tools/testing/selftests/bpf/progs/verifier_sock.c  |  980 +++++++++++++
 .../selftests/bpf/progs/verifier_spin_lock.c       |  533 +++++++
 .../testing/selftests/bpf/progs/verifier_subreg.c  |  673 +++++++++
 .../testing/selftests/bpf/progs/verifier_unpriv.c  |  726 ++++++++++
 .../selftests/bpf/progs/verifier_unpriv_perf.c     |   34 +
 .../bpf/progs/verifier_value_illegal_alu.c         |  149 ++
 .../selftests/bpf/progs/verifier_value_ptr_arith.c | 1423 +++++++++++++++++++
 tools/testing/selftests/bpf/test_loader.c          |   99 +-
 tools/testing/selftests/bpf/test_progs.h           |    9 +
 tools/testing/selftests/bpf/verifier/bounds.c      |  884 ------------
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |   87 --
 .../selftests/bpf/verifier/btf_ctx_access.c        |   25 -
 tools/testing/selftests/bpf/verifier/ctx.c         |  186 ---
 tools/testing/selftests/bpf/verifier/d_path.c      |   37 -
 .../selftests/bpf/verifier/direct_packet_access.c  |  710 ----------
 .../selftests/bpf/verifier/jeq_infer_not_null.c    |  174 ---
 tools/testing/selftests/bpf/verifier/loops1.c      |  206 ---
 tools/testing/selftests/bpf/verifier/lwt.c         |  189 ---
 tools/testing/selftests/bpf/verifier/map_in_map.c  |   96 --
 tools/testing/selftests/bpf/verifier/map_kptr.c    |   27 -
 .../selftests/bpf/verifier/map_ptr_mixing.c        |  100 --
 .../testing/selftests/bpf/verifier/ref_tracking.c  | 1082 --------------
 tools/testing/selftests/bpf/verifier/regalloc.c    |  277 ----
 tools/testing/selftests/bpf/verifier/runtime_jit.c |  231 ---
 .../selftests/bpf/verifier/search_pruning.c        |  266 ----
 tools/testing/selftests/bpf/verifier/sock.c        |  706 ---------
 tools/testing/selftests/bpf/verifier/spin_lock.c   |  447 ------
 tools/testing/selftests/bpf/verifier/subreg.c      |  533 -------
 tools/testing/selftests/bpf/verifier/unpriv.c      |  562 --------
 .../selftests/bpf/verifier/value_illegal_alu.c     |   95 --
 .../selftests/bpf/verifier/value_ptr_arith.c       | 1140 ---------------
 tools/testing/selftests/bpf/xskxceiver.c           |   14 +-
 tools/testing/selftests/bpf/xskxceiver.h           |    1 +
 116 files changed, 13397 insertions(+), 8896 deletions(-)
 create mode 100644 include/net/netfilter/nf_bpf_link.h
 create mode 100644 net/netfilter/nf_bpf_link.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/access_variable_array.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/refcounted_kptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/refcounted_kptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/refcounted_kptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_access_variable_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bpf_get_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ctx.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_direct_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_jeq_infer_not_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_loops1.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_lwt.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_in_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ptr_mixing.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ref_tracking.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_reg_equal.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_regalloc.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_runtime_jit.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_search_pruning.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_spin_lock.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_subreg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_unpriv.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_unpriv_perf.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_illegal_alu.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_ptr_arith.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bpf_get_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/btf_ctx_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ctx.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/direct_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/jeq_infer_not_null.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/loops1.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/lwt.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_in_map.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ptr_mixing.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ref_tracking.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/runtime_jit.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/search_pruning.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/sock.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/spin_lock.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/subreg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/unpriv.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_illegal_alu.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_ptr_arith.c
