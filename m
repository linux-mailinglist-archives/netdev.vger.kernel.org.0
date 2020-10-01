Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F18E28030E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgJAPmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:42:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:46410 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731885AbgJAPmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:42:11 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kO0iY-0000Oa-Qk; Thu, 01 Oct 2020 17:42:02 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-10-01
Date:   Thu,  1 Oct 2020 17:42:02 +0200
Message-Id: <20201001154202.17785-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25944/Thu Oct  1 15:55:30 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 90 non-merge commits during the last 8 day(s) which contain
a total of 103 files changed, 7662 insertions(+), 1894 deletions(-).

Note that once bpf(/net) tree gets merged into net-next, there will be a small
merge conflict in tools/lib/bpf/btf.c between commit 1245008122d7 ("libbpf: Fix
native endian assumption when parsing BTF") from the bpf tree and the commit
3289959b97ca ("libbpf: Support BTF loading and raw data output in both endianness")
from the bpf-next tree. Correct resolution would be to stick with bpf-next, it
should look like:

  [...]
        /* check BTF magic */
        if (fread(&magic, 1, sizeof(magic), f) < sizeof(magic)) {
                err = -EIO;
                goto err_out;
        }
        if (magic != BTF_MAGIC && magic != bswap_16(BTF_MAGIC)) {
                /* definitely not a raw BTF */
                err = -EPROTO;
                goto err_out;
        }

        /* get file size */
  [...]

The main changes are:

1) Add bpf_snprintf_btf() and bpf_seq_printf_btf() helpers to support displaying
   BTF-based kernel data structures out of BPF programs, from Alan Maguire.

2) Speed up RCU tasks trace grace periods by a factor of 50 & fix a few race
   conditions exposed by it. It was discussed to take these via BPF and
   networking tree to get better testing exposure, from Paul E. McKenney.

3) Support multi-attach for freplace programs, needed for incremental attachment
   of multiple XDP progs using libxdp dispatcher model, from Toke Høiland-Jørgensen.

4) libbpf support for appending new BTF types at the end of BTF object, allowing
   intrusive changes of prog's BTF (useful for future linking), from Andrii Nakryiko.

5) Several BPF helper improvements e.g. avoid atomic op in cookie generator and add
   a redirect helper into neighboring subsys, from Daniel Borkmann.

6) Allow map updates on sockmaps from bpf_iter context in order to migrate sockmaps
   from one to another, from Lorenz Bauer.

7) Fix 32 bit to 64 bit assignment from latest alu32 bounds tracking which caused
   a verifier issue due to type downgrade to scalar, from John Fastabend.

8) Follow-up on tail-call support in BPF subprogs which optimizes x64 JIT prologue
   and epilogue sections, from Maciej Fijalkowski.

9) Add an option to perf RB map to improve sharing of event entries by avoiding remove-
   on-close behavior. Also, add BPF_PROG_TEST_RUN for raw_tracepoint, from Song Liu.

10) Fix a crash in AF_XDP's socket_release when memory allocation for UMEMs fails,
    from Magnus Karlsson.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Alexei Starovoitov, Andrii Nakryiko, Daniel Borkmann, 
David Ahern, Eelco Chaudron, Eric Dumazet, Jiri Olsa, John Fastabend, 
Lorenz Bauer, Magnus Karlsson, Martin KaFai Lau, Yonghong Song

----------------------------------------------------------------

The following changes since commit 3fc826f121d89c5aa4afd7b3408b07e0ff59466b:

  Merge branch 'net-dsa-bcm_sf2-Additional-DT-changes' (2020-09-23 17:51:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 6208689fb3e623d3576dd61866cb99b40f75dc53:

  Merge branch 'introduce BPF_F_PRESERVE_ELEMS' (2020-09-30 23:21:17 -0700)

----------------------------------------------------------------
Alan Maguire (10):
      bpf: Provide function to get vmlinux BTF information
      bpf: Move to generic BTF show support, apply it to seq files/strings
      bpf: Add bpf_snprintf_btf helper
      selftests/bpf: Add bpf_snprintf_btf helper tests
      bpf: Bump iter seq size to support BTF representation of large data structures
      selftests/bpf: Fix overflow tests to reflect iter size increase
      bpf: Add bpf_seq_printf_btf helper
      selftests/bpf: Add test for bpf_seq_printf_btf helper
      selftests/bpf: Fix unused-result warning in snprintf_btf.c
      selftests/bpf: Ensure snprintf_btf/bpf_iter tests compatibility with old vmlinux.h

Alexei Starovoitov (12):
      Revert "bpf: Fix potential call bpf_link_free() in atomic context"
      Merge branch 'rtt-speedup.2020.09.16a' of git://git.kernel.org/.../paulmck/linux-rcu into bpf-next
      Merge branch 'enable-bpf_skc-cast-for-networking-progs'
      Merge branch 'Sockmap copying'
      Merge branch 'bpf: add helpers to support BTF-based kernel'
      Merge branch 'libbpf: BTF writer APIs'
      Merge branch 'selftests/bpf: BTF-based kernel data display'
      Merge branch 'libbpf: support loading/storing any BTF'
      Merge branch 'bpf: Support multi-attach for freplace'
      Merge branch 'bpf, x64: optimize JIT's pro/epilogue'
      Merge branch 'Various BPF helper improvements'
      Merge branch 'introduce BPF_F_PRESERVE_ELEMS'

Andrii Nakryiko (17):
      libbpf: Refactor internals of BTF type index
      libbpf: Remove assumption of single contiguous memory for BTF data
      libbpf: Generalize common logic for managing dynamically-sized arrays
      libbpf: Extract generic string hashing function for reuse
      libbpf: Allow modification of BTF and add btf__add_str API
      libbpf: Add btf__new_empty() to create an empty BTF object
      libbpf: Add BTF writing APIs
      libbpf: Add btf__str_by_offset() as a more generic variant of name_by_offset
      selftests/bpf: Test BTF writing APIs
      selftests/bpf: Move and extend ASSERT_xxx() testing macros
      libbpf: Support BTF loading and raw data output in both endianness
      selftests/bpf: Test BTF's handling of endianness
      libbpf: Fix uninitialized variable in btf_parse_type_sec
      libbpf: Compile libbpf under -O2 level by default and catch extra warnings
      libbpf: Compile in PIC mode only for shared library case
      libbpf: Make btf_dump work with modifiable BTF
      selftests/bpf: Test "incremental" btf_dump in C format

Ciara Loftus (1):
      xsk: Fix a documentation mistake in xsk_queue.h

Daniel Borkmann (6):
      bpf: Add classid helper only based on skb->sk
      bpf, net: Rework cookie generator as per-cpu one
      bpf: Add redirect_neigh helper as redirect drop-in
      bpf, libbpf: Add bpf_tail_call_static helper for bpf programs
      bpf, selftests: Use bpf_tail_call_static where appropriate
      bpf, selftests: Add redirect_neigh selftest

Ilya Leoshkevich (1):
      selftests/bpf: Fix endianness issues in sk_lookup/ctx_narrow_access

Jean-Philippe Brucker (1):
      selftests/bpf: Fix alignment of .BTF_ids

Jiri Olsa (1):
      selftests/bpf: Adding test for arg dereference in extension trace

John Fastabend (5):
      bpf, verifier: Remove redundant var_off.value ops in scalar known reg cases
      bpf: Add AND verifier test case where 32bit and 64bit bounds differ
      bpf: Add comment to document BTF type PTR_TO_BTF_ID_OR_NULL
      bpf, selftests: Fix cast to smaller integer type 'int' warning in raw_tp
      bpf, selftests: Fix warning in snprintf_btf where system() call unchecked

Lorenz Bauer (4):
      bpf: sockmap: Enable map_update_elem from bpf_iter
      selftests: bpf: Add helper to compare socket cookies
      selftests: bpf: Remove shared header from sockmap iter test
      selftest: bpf: Test copying a sockmap and sockhash

Lorenzo Bianconi (1):
      bpf, cpumap: Remove rcpu pointer from cpu_map_build_skb signature

Maciej Fijalkowski (2):
      bpf, x64: Drop "pop %rcx" instruction on BPF JIT epilogue
      bpf: x64: Do not emit sub/add 0, %rsp when !stack_depth

Magnus Karlsson (1):
      xsk: Fix possible crash in socket_release when out-of-memory

Martin KaFai Lau (13):
      bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
      bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
      bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: Change bpf_sk_storage_*() to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: Change bpf_tcp_*_syncookie to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: selftest: Add ref_tracking verifier test for bpf_skc casting
      bpf: selftest: Move sock_fields test into test_progs
      bpf: selftest: Adapt sock_fields test to use skel and global variables
      bpf: selftest: Use network_helpers in the sock_fields test
      bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test
      bpf: selftest: Remove enum tcp_ca_state from bpf_tcp_helpers.h
      bpf: selftest: Add test_btf_skc_cls_ingress

Paul E. McKenney (7):
      rcu-tasks: Mark variables static
      rcu-tasks: Use more aggressive polling for RCU Tasks Trace
      rcu-tasks: Selectively enable more RCU Tasks Trace IPIs
      rcu-tasks: Shorten per-grace-period sleep for RCU Tasks Trace
      rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace
      rcu-tasks: Fix low-probability task_struct leak
      rcu-tasks: Enclose task-list scan in rcu_read_lock()

Song Liu (6):
      bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint
      libbpf: Support test run of raw tracepoint programs
      selftests/bpf: Add raw_tp_test_run
      bpf: fix raw_tp test run in preempt kernel
      bpf: Introduce BPF_F_PRESERVE_ELEMS for perf event array
      selftests/bpf: Add tests for BPF_F_PRESERVE_ELEMS

Toke Høiland-Jørgensen (13):
      bpf: disallow attaching modify_return tracing functions to other BPF programs
      bpf: change logging calls from verbose() to bpf_log() and use log pointer
      bpf: verifier: refactor check_attach_btf_id()
      selftests: Remove fmod_ret from test_overhead
      bpf/preload: Make sure Makefile cleans up after itself, and add .gitignore
      selftests/bpf_iter: Don't fail test due to missing __builtin_btf_type_id
      selftests: Make sure all 'skel' variables are declared static
      bpf: Move prog->aux->linked_prog and trampoline into bpf_link on attach
      bpf: Support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: Add support for freplace attachment in bpf_link_create
      selftests: Add test for multiple attachments of freplace program
      selftests: Add selftest for disallowing modify_return attachment to freplace

 arch/x86/net/bpf_jit_comp.c                        |   35 +-
 include/linux/bpf.h                                |   61 +-
 include/linux/bpf_verifier.h                       |   18 +-
 include/linux/btf.h                                |   39 +
 include/linux/cookie.h                             |   51 +
 include/linux/rcupdate_trace.h                     |    4 +
 include/linux/skbuff.h                             |    5 +
 include/linux/sock_diag.h                          |   14 +-
 include/net/bpf_sk_storage.h                       |    2 -
 include/net/net_namespace.h                        |    2 +-
 include/uapi/linux/bpf.h                           |  134 +-
 kernel/bpf/arraymap.c                              |   19 +-
 kernel/bpf/bpf_iter.c                              |    4 +-
 kernel/bpf/bpf_lsm.c                               |    4 +-
 kernel/bpf/btf.c                                   | 1028 +++++++++--
 kernel/bpf/core.c                                  |   11 +-
 kernel/bpf/cpumap.c                                |    5 +-
 kernel/bpf/helpers.c                               |    4 +
 kernel/bpf/preload/.gitignore                      |    4 +
 kernel/bpf/preload/Makefile                        |    2 +
 kernel/bpf/preload/iterators/iterators.bpf.c       |    4 +-
 kernel/bpf/preload/iterators/iterators.skel.h      |  444 ++---
 kernel/bpf/reuseport_array.c                       |    2 +-
 kernel/bpf/syscall.c                               |  190 +-
 kernel/bpf/trampoline.c                            |   34 +-
 kernel/bpf/verifier.c                              |  357 ++--
 kernel/rcu/tasks.h                                 |   53 +-
 kernel/trace/bpf_trace.c                           |   99 ++
 net/bpf/test_run.c                                 |   88 +
 net/core/bpf_sk_storage.c                          |   29 +-
 net/core/filter.c                                  |  418 ++++-
 net/core/net_namespace.c                           |   12 +-
 net/core/sock_diag.c                               |    9 +-
 net/core/sock_map.c                                |    7 +-
 net/ipv4/bpf_tcp_ca.c                              |   23 +-
 net/xdp/xsk.c                                      |    1 +
 net/xdp/xsk_queue.h                                |    2 +-
 samples/bpf/sockex3_kern.c                         |   20 +-
 scripts/bpf_helpers_doc.py                         |    2 +
 tools/include/uapi/linux/bpf.h                     |  134 +-
 tools/lib/bpf/Makefile                             |    5 +-
 tools/lib/bpf/bpf.c                                |   51 +-
 tools/lib/bpf/bpf.h                                |   31 +-
 tools/lib/bpf/bpf_helpers.h                        |   46 +
 tools/lib/bpf/btf.c                                | 1868 +++++++++++++++++---
 tools/lib/bpf/btf.h                                |   51 +
 tools/lib/bpf/btf_dump.c                           |   78 +-
 tools/lib/bpf/hashmap.h                            |   12 +
 tools/lib/bpf/libbpf.c                             |   44 +-
 tools/lib/bpf/libbpf.h                             |    3 +
 tools/lib/bpf/libbpf.map                           |   27 +
 tools/lib/bpf/libbpf_internal.h                    |    9 +
 tools/testing/selftests/bpf/.gitignore             |    1 -
 tools/testing/selftests/bpf/Makefile               |    2 +-
 tools/testing/selftests/bpf/bench.c                |    3 -
 tools/testing/selftests/bpf/benchs/bench_rename.c  |   17 -
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   13 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   94 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  105 ++
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |  101 ++
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  234 +++
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  244 +++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  212 ++-
 .../selftests/bpf/prog_tests/pe_preserve_elems.c   |   66 +
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |   96 +
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    6 +
 .../selftests/bpf/prog_tests/snprintf_btf.c        |   62 +
 .../testing/selftests/bpf/prog_tests/sock_fields.c |  382 ++++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  100 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |   14 +-
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |  111 ++
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |    2 +
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |    2 +
 tools/testing/selftests/bpf/progs/bpf_flow.c       |   12 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   23 +
 .../testing/selftests/bpf/progs/bpf_iter_sockmap.c |   32 +-
 .../testing/selftests/bpf/progs/bpf_iter_sockmap.h |    3 -
 .../selftests/bpf/progs/bpf_iter_task_btf.c        |   50 +
 tools/testing/selftests/bpf/progs/btf_ptr.h        |   27 +
 .../selftests/bpf/progs/fmod_ret_freplace.c        |   14 +
 .../selftests/bpf/progs/freplace_get_constant.c    |   15 +
 .../selftests/bpf/progs/netif_receive_skb.c        |  249 +++
 tools/testing/selftests/bpf/progs/tailcall1.c      |   28 +-
 tools/testing/selftests/bpf/progs/tailcall2.c      |   14 +-
 tools/testing/selftests/bpf/progs/tailcall3.c      |    4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c        |    4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |    6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |    6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |    6 +-
 .../selftests/bpf/progs/test_btf_skc_cls_ingress.c |  174 ++
 tools/testing/selftests/bpf/progs/test_overhead.c  |    6 -
 .../selftests/bpf/progs/test_pe_preserve_elems.c   |   38 +
 .../selftests/bpf/progs/test_raw_tp_test_run.c     |   24 +
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  216 ++-
 ...{test_sock_fields_kern.c => test_sock_fields.c} |  176 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |  144 ++
 tools/testing/selftests/bpf/progs/test_trace_ext.c |   18 +
 .../selftests/bpf/progs/test_trace_ext_tracing.c   |   25 +
 tools/testing/selftests/bpf/test_progs.h           |   63 +
 tools/testing/selftests/bpf/test_sock_fields.c     |  482 -----
 tools/testing/selftests/bpf/test_tc_neigh.sh       |  168 ++
 tools/testing/selftests/bpf/verifier/and.c         |   16 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   47 +
 103 files changed, 7662 insertions(+), 1894 deletions(-)
 create mode 100644 include/linux/cookie.h
 create mode 100644 kernel/bpf/preload/.gitignore
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_endian.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_elems.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sock_fields.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 delete mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_ptr.h
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
 rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c => test_sock_fields.c} (61%)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
 delete mode 100644 tools/testing/selftests/bpf/test_sock_fields.c
 create mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh
