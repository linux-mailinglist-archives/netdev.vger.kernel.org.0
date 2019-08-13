Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E628C4B1
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHMXQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:16:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:42510 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfHMXQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:16:51 -0400
Received: from 231.45.193.178.dynamic.wline.res.cust.swisscom.ch ([178.193.45.231] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxg1v-0007sL-QJ; Wed, 14 Aug 2019 01:16:39 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     daniel@iogearbox.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-08-14
Date:   Wed, 14 Aug 2019 01:16:39 +0200
Message-Id: <20190813231639.29891-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

There is a small merge conflict in libbpf (Cc Andrii so he's in the loop
as well):

        for (i = 1; i <= btf__get_nr_types(btf); i++) {
                t = (struct btf_type *)btf__type_by_id(btf, i);

                if (!has_datasec && btf_is_var(t)) {
                        /* replace VAR with INT */
                        t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
  <<<<<<< HEAD
                        /*
                         * using size = 1 is the safest choice, 4 will be too
                         * big and cause kernel BTF validation failure if
                         * original variable took less than 4 bytes
                         */
                        t->size = 1;
                        *(int *)(t+1) = BTF_INT_ENC(0, 0, 8);
                } else if (!has_datasec && kind == BTF_KIND_DATASEC) {
  =======
                        t->size = sizeof(int);
                        *(int *)(t + 1) = BTF_INT_ENC(0, 0, 32);
                } else if (!has_datasec && btf_is_datasec(t)) {
  >>>>>>> 72ef80b5ee131e96172f19e74b4f98fa3404efe8
                        /* replace DATASEC with STRUCT */

Conflict is between the two commits 1d4126c4e119 ("libbpf: sanitize VAR to
conservative 1-byte INT") and b03bc6853c0e ("libbpf: convert libbpf code to
use new btf helpers"), so we need to pick the sanitation fixup as well as
use the new btf_is_datasec() helper and the whitespace cleanup. Looks like
the following:

  [...]
                if (!has_datasec && btf_is_var(t)) {
                        /* replace VAR with INT */
                        t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
                        /*
                         * using size = 1 is the safest choice, 4 will be too
                         * big and cause kernel BTF validation failure if
                         * original variable took less than 4 bytes
                         */
                        t->size = 1;
                        *(int *)(t + 1) = BTF_INT_ENC(0, 0, 8);
                } else if (!has_datasec && btf_is_datasec(t)) {
                        /* replace DATASEC with STRUCT */
  [...]

The main changes are:

1) Addition of core parts of compile once - run everywhere (co-re) effort,
   that is, relocation of fields offsets in libbpf as well as exposure of
   kernel's own BTF via sysfs and loading through libbpf, from Andrii.

   More info on co-re: http://vger.kernel.org/bpfconf2019.html#session-2
   and http://vger.kernel.org/lpc-bpf2018.html#session-2

2) Enable passing input flags to the BPF flow dissector to customize parsing
   and allowing it to stop early similar to the C based one, from Stanislav.

3) Add a BPF helper function that allows generating SYN cookies from XDP and
   tc BPF, from Petar.

4) Add devmap hash-based map type for more flexibility in device lookup for
   redirects, from Toke.

5) Improvements to XDP forwarding sample code now utilizing recently enabled
   devmap lookups, from Jesper.

6) Add support for reporting the effective cgroup progs in bpftool, from Jakub
   and Takshak.

7) Fix reading kernel config from bpftool via /proc/config.gz, from Peter.

8) Fix AF_XDP umem pages mapping for 32 bit architectures, from Ivan.

9) Follow-up to add two more BPF loop tests for the selftest suite, from Alexei.

10) Add perf event output helper also for other skb-based program types, from Allan.

11) Fix a co-re related compilation error in selftests, from Yonghong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 3e3bb69589e482e0783f28d4cd1d8e56fda0bcbb:

  tc-testing: added tdc tests for [b|p]fifo qdisc (2019-07-23 14:08:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 72ef80b5ee131e96172f19e74b4f98fa3404efe8:

  Merge branch 'bpf-libbpf-read-sysfs-btf' (2019-08-13 23:19:42 +0200)

----------------------------------------------------------------
Alexei Starovoitov (10):
      Merge branch 'convert-tests-to-libbpf'
      Merge branch 'flow_dissector-input-flags'
      Merge branch 'revamp-test_progs'
      Merge branch 'devmap_hash'
      Merge branch 'gen-syn-cookie'
      Merge branch 'setsockopt-extra-mem'
      selftests/bpf: add loop test 4
      selftests/bpf: add loop test 5
      Merge branch 'test_progs-stdio'
      Merge branch 'compile-once-run-everywhere'

Allan Zhang (2):
      bpf: Allow bpf_skb_event_output for a few prog types
      selftests/bpf: Add selftests for bpf_perf_event_output

Andrii Nakryiko (33):
      libbpf: provide more helpful message on uninitialized global var
      selftests/bpf: convert test_get_stack_raw_tp to perf_buffer API
      selftests/bpf: switch test_tcpnotify to perf_buffer API
      samples/bpf: convert xdp_sample_pkts_user to perf_buffer API
      samples/bpf: switch trace_output sample to perf_buffer API
      selftests/bpf: remove perf buffer helpers
      selftests/bpf: prevent headers to be compiled as C code
      selftests/bpf: revamp test_progs to allow more control
      selftests/bpf: add test selectors by number and name to test_progs
      libbpf: return previous print callback from libbpf_set_print
      selftest/bpf: centralize libbpf logging management for test_progs
      selftests/bpf: abstract away test log output
      selftests/bpf: add sub-tests support for test_progs
      selftests/bpf: convert bpf_verif_scale.c to sub-tests API
      selftests/bpf: convert send_signal.c to use subtests
      selftests/bpf: fix clearing buffered output between tests/subtests
      libbpf: add helpers for working with BTF types
      libbpf: convert libbpf code to use new btf helpers
      libbpf: add .BTF.ext offset relocation section loading
      libbpf: implement BPF CO-RE offset relocation algorithm
      selftests/bpf: add BPF_CORE_READ relocatable read macro
      selftests/bpf: add CO-RE relocs testing setup
      selftests/bpf: add CO-RE relocs struct flavors tests
      selftests/bpf: add CO-RE relocs nesting tests
      selftests/bpf: add CO-RE relocs array tests
      selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
      selftests/bpf: add CO-RE relocs modifiers/typedef tests
      selftests/bpf: add CO-RE relocs ptr-as-array tests
      selftests/bpf: add CO-RE relocs ints tests
      selftests/bpf: add CO-RE relocs misc tests
      btf: expose BTF info through sysfs
      btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux
      libbpf: attempt to load kernel BTF from sysfs first

Daniel Borkmann (2):
      Merge branch 'bpf-xdp-fwd-sample-improvements'
      Merge branch 'bpf-libbpf-read-sysfs-btf'

Ivan Khoronzhuk (1):
      xdp: xdp_umem: fix umem pages mapping for 32bits systems

Jakub Kicinski (1):
      tools: bpftool: add support for reporting the effective cgroup progs

Jesper Dangaard Brouer (3):
      samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
      samples/bpf: make xdp_fwd more practically usable via devmap lookup
      samples/bpf: xdp_fwd explain bpf_fib_lookup return codes

Petar Penkov (7):
      tcp: tcp_syn_flood_action read port from socket
      tcp: add skb-less helpers to retrieve SYN cookie
      bpf: add bpf_tcp_gen_syncookie helper
      bpf: sync bpf.h to tools/
      selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
      selftests/bpf: add test for bpf_tcp_gen_syncookie
      selftests/bpf: fix race in flow dissector tests

Peter Wu (2):
      tools: bpftool: fix reading from /proc/config.gz
      tools: bpftool: add feature check for zlib

Stanislav Fomichev (12):
      bpf/flow_dissector: pass input flags to BPF flow dissector program
      bpf/flow_dissector: document flags
      bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
      tools/bpf: sync bpf_flow_keys flags
      selftests/bpf: support BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG
      bpf/flow_dissector: support ipv6 flow_label and BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
      selftests/bpf: support BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP
      bpf: always allocate at least 16 bytes for setsockopt hook
      selftests/bpf: extend sockopt_sk selftest with TCP_CONGESTION use case
      selftests/bpf: test_progs: switch to open_memstream
      selftests/bpf: test_progs: test__printf -> printf
      selftests/bpf: test_progs: drop extra trailing tab

Toke Høiland-Jørgensen (6):
      include/bpf.h: Remove map_insert_ctx() stubs
      xdp: Refactor devmap allocation code for reuse
      xdp: Add devmap_hash map type for looking up devices by hashed index
      tools/include/uapi: Add devmap_hash BPF map type
      tools/libbpf_probes: Add new devmap_hash type
      tools: Add definitions for devmap_hash map type

Yonghong Song (1):
      tools/bpf: fix core_reloc.c compilation error

 Documentation/ABI/testing/sysfs-kernel-btf         |   17 +
 Documentation/bpf/prog_flow_dissector.rst          |   18 +
 include/linux/bpf.h                                |   11 +-
 include/linux/bpf_types.h                          |    1 +
 include/linux/skbuff.h                             |    2 +-
 include/net/tcp.h                                  |   10 +
 include/trace/events/xdp.h                         |    3 +-
 include/uapi/linux/bpf.h                           |   37 +-
 kernel/bpf/Makefile                                |    3 +
 kernel/bpf/cgroup.c                                |   17 +-
 kernel/bpf/devmap.c                                |  332 ++++++-
 kernel/bpf/sysfs_btf.c                             |   51 +
 kernel/bpf/verifier.c                              |    2 +
 net/bpf/test_run.c                                 |   39 +-
 net/core/filter.c                                  |   88 +-
 net/core/flow_dissector.c                          |   21 +-
 net/ipv4/tcp_input.c                               |   81 +-
 net/ipv4/tcp_ipv4.c                                |   15 +
 net/ipv6/tcp_ipv6.c                                |   15 +
 net/xdp/xdp_umem.c                                 |   12 +-
 samples/bpf/trace_output_user.c                    |   43 +-
 samples/bpf/xdp_fwd_kern.c                         |   39 +-
 samples/bpf/xdp_fwd_user.c                         |   35 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   61 +-
 scripts/link-vmlinux.sh                            |   52 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   16 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    2 +-
 tools/bpf/bpftool/Makefile                         |   13 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   19 +-
 tools/bpf/bpftool/cgroup.c                         |   83 +-
 tools/bpf/bpftool/feature.c                        |  105 +-
 tools/bpf/bpftool/map.c                            |    3 +-
 tools/include/uapi/linux/bpf.h                     |   44 +-
 tools/lib/bpf/btf.c                                |  250 +++--
 tools/lib/bpf/btf.h                                |  182 ++++
 tools/lib/bpf/btf_dump.c                           |  138 +--
 tools/lib/bpf/libbpf.c                             | 1009 +++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |    3 +-
 tools/lib/bpf/libbpf_internal.h                    |  105 ++
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/testing/selftests/bpf/Makefile               |   14 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   23 +
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |    6 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   92 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  385 ++++++++
 .../selftests/bpf/prog_tests/flow_dissector.c      |  265 ++++-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   82 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |   15 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   15 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c        |    3 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |   60 +-
 .../selftests/bpf/progs/btf__core_reloc_arrays.c   |    3 +
 .../progs/btf__core_reloc_arrays___diff_arr_dim.c  |    3 +
 .../btf__core_reloc_arrays___diff_arr_val_sz.c     |    3 +
 .../progs/btf__core_reloc_arrays___err_non_array.c |    3 +
 .../btf__core_reloc_arrays___err_too_shallow.c     |    3 +
 .../progs/btf__core_reloc_arrays___err_too_small.c |    3 +
 .../btf__core_reloc_arrays___err_wrong_val_type1.c |    3 +
 .../btf__core_reloc_arrays___err_wrong_val_type2.c |    3 +
 .../selftests/bpf/progs/btf__core_reloc_flavors.c  |    3 +
 .../btf__core_reloc_flavors__err_wrong_name.c      |    3 +
 .../selftests/bpf/progs/btf__core_reloc_ints.c     |    3 +
 .../bpf/progs/btf__core_reloc_ints___bool.c        |    3 +
 .../progs/btf__core_reloc_ints___err_bitfield.c    |    3 +
 .../progs/btf__core_reloc_ints___err_wrong_sz_16.c |    3 +
 .../progs/btf__core_reloc_ints___err_wrong_sz_32.c |    3 +
 .../progs/btf__core_reloc_ints___err_wrong_sz_64.c |    3 +
 .../progs/btf__core_reloc_ints___err_wrong_sz_8.c  |    3 +
 .../progs/btf__core_reloc_ints___reverse_sign.c    |    3 +
 .../selftests/bpf/progs/btf__core_reloc_misc.c     |    5 +
 .../selftests/bpf/progs/btf__core_reloc_mods.c     |    3 +
 .../bpf/progs/btf__core_reloc_mods___mod_swap.c    |    3 +
 .../bpf/progs/btf__core_reloc_mods___typedefs.c    |    3 +
 .../selftests/bpf/progs/btf__core_reloc_nesting.c  |    3 +
 .../progs/btf__core_reloc_nesting___anon_embed.c   |    3 +
 .../btf__core_reloc_nesting___dup_compat_types.c   |    5 +
 ...btf__core_reloc_nesting___err_array_container.c |    3 +
 .../btf__core_reloc_nesting___err_array_field.c    |    3 +
 ...__core_reloc_nesting___err_dup_incompat_types.c |    4 +
 ...f__core_reloc_nesting___err_missing_container.c |    3 +
 .../btf__core_reloc_nesting___err_missing_field.c  |    3 +
 ..._core_reloc_nesting___err_nonstruct_container.c |    3 +
 ...__core_reloc_nesting___err_partial_match_dups.c |    4 +
 .../progs/btf__core_reloc_nesting___err_too_deep.c |    3 +
 .../btf__core_reloc_nesting___extra_nesting.c      |    3 +
 .../btf__core_reloc_nesting___struct_union_mixup.c |    3 +
 .../bpf/progs/btf__core_reloc_primitives.c         |    3 +
 .../btf__core_reloc_primitives___diff_enum_def.c   |    3 +
 .../btf__core_reloc_primitives___diff_func_proto.c |    3 +
 .../btf__core_reloc_primitives___diff_ptr_type.c   |    3 +
 .../btf__core_reloc_primitives___err_non_enum.c    |    3 +
 .../btf__core_reloc_primitives___err_non_int.c     |    3 +
 .../btf__core_reloc_primitives___err_non_ptr.c     |    3 +
 .../bpf/progs/btf__core_reloc_ptr_as_arr.c         |    3 +
 .../progs/btf__core_reloc_ptr_as_arr___diff_sz.c   |    3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  667 +++++++++++++
 tools/testing/selftests/bpf/progs/loop4.c          |   18 +
 tools/testing/selftests/bpf/progs/loop5.c          |   32 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   22 +
 .../selftests/bpf/progs/test_core_reloc_arrays.c   |   55 ++
 .../selftests/bpf/progs/test_core_reloc_flavors.c  |   62 ++
 .../selftests/bpf/progs/test_core_reloc_ints.c     |   44 +
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |   36 +
 .../selftests/bpf/progs/test_core_reloc_misc.c     |   57 ++
 .../selftests/bpf/progs/test_core_reloc_mods.c     |   62 ++
 .../selftests/bpf/progs/test_core_reloc_nesting.c  |   46 +
 .../bpf/progs/test_core_reloc_primitives.c         |   43 +
 .../bpf/progs/test_core_reloc_ptr_as_arr.c         |   30 +
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |    2 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c      |   48 +-
 tools/testing/selftests/bpf/test_maps.c            |   16 +
 tools/testing/selftests/bpf/test_progs.c           |  374 +++++++-
 tools/testing/selftests/bpf/test_progs.h           |   40 +-
 tools/testing/selftests/bpf/test_sockopt_sk.c      |   25 +
 .../selftests/bpf/test_tcp_check_syncookie.sh      |    3 +
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |   61 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   90 +-
 tools/testing/selftests/bpf/test_verifier.c        |   12 +-
 tools/testing/selftests/bpf/trace_helpers.c        |  125 ---
 tools/testing/selftests/bpf/trace_helpers.h        |    9 -
 .../testing/selftests/bpf/verifier/event_output.c  |   94 ++
 121 files changed, 5229 insertions(+), 920 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-btf
 create mode 100644 kernel/bpf/sysfs_btf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_reloc.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors__err_wrong_name.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___mod_swap.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___typedefs.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_reloc_types.h
 create mode 100644 tools/testing/selftests/bpf/progs/loop4.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop5.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
