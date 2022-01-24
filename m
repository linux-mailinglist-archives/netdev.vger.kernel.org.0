Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD338499D63
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1583514AbiAXWS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:18:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:33274 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581896AbiAXWMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:12:38 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nC7Zk-0000lC-4D; Mon, 24 Jan 2022 23:12:36 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-01-24
Date:   Mon, 24 Jan 2022 23:12:35 +0100
Message-Id: <20220124221235.18993-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26432/Mon Jan 24 10:24:33 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 80 non-merge commits during the last 14 day(s) which contain
a total of 128 files changed, 4990 insertions(+), 895 deletions(-).

There is one minor conflict in include/linux/bpf_verifier.h between net-next
commit be80a1d3f9db ("bpf: Generalize check_ctx_reg for reuse with other types")
and bpf-next commit d583691c47dc ("bpf: Introduce mem, size argument pair support
for kfunc"):

  <<<<<<< HEAD
  int check_ptr_off_reg(struct bpf_verifier_env *env,
                        const struct bpf_reg_state *reg, int regno);
  =======
  int check_ctx_reg(struct bpf_verifier_env *env,
                    const struct bpf_reg_state *reg, int regno);
  int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
                               u32 regno);
  >>>>>>> b4ec6a19231224f6b08dc54ea07da4c4090e8ee3

Fixup is trivial and result should look like:

  int check_ptr_off_reg(struct bpf_verifier_env *env,
                        const struct bpf_reg_state *reg, int regno);
  int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
                               u32 regno);

The main changes are:

1) Add XDP multi-buffer support and implement it for the mvneta driver,
   from Lorenzo Bianconi, Eelco Chaudron and Toke Høiland-Jørgensen.

2) Add unstable conntrack lookup helpers for BPF by using the BPF kfunc
   infra, from Kumar Kartikeya Dwivedi.

3) Extend BPF cgroup programs to export custom ret value to userspace via
   two helpers bpf_get_retval() and bpf_set_retval(), from YiFei Zhu.

4) Add support for AF_UNIX iterator batching, from Kuniyuki Iwashima.

5) Complete missing UAPI BPF helper description and change bpf_doc.py script
   to enforce consistent & complete helper documentation, from Usama Arif.

6) Deprecate libbpf's legacy BPF map definitions and streamline XDP APIs to
   follow tc-based APIs, from Andrii Nakryiko.

7) Support BPF_PROG_QUERY for BPF programs attached to sockmap, from Di Zhu.

8) Deprecate libbpf's bpf_map__def() API and replace users with proper getters
   and setters, from Christy Lee.

9) Extend libbpf's btf__add_btf() with an additional hashmap for strings to
   reduce overhead, from Kui-Feng Lee.

10) Fix bpftool and libbpf error handling related to libbpf's hashmap__new()
    utility function, from Mauricio Vásquez.

11) Add support to BTF program names in bpftool's program dump, from Raman Shukhau.

12) Fix resolve_btfids build to pick up host flags, from Connor O'Brien.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Arnaldo Carvalho de Melo, Eelco 
Chaudron, Jakub Kicinski, Jakub Sitnicki, Jesper Dangaard Brouer, John 
Fastabend, kernel test robot, Maciej Fijalkowski, Quentin Monnet, Song 
Liu, Stanislav Fomichev, Toke Hoiland-Jorgensen, Toke Høiland-Jørgensen, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit fe8152b38d3a994c4c6fdbc0cd6551d569a5715a:

  Merge tag 'devprop-5.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2022-01-10 20:48:19 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 0bfb95f59a6613e30c0672b8ef2c9502302bf6bb:

  selftests, bpf: Do not yet switch to new libbpf XDP APIs (2022-01-24 23:02:29 +0100)

----------------------------------------------------------------
Alexei Starovoitov (6):
      Merge branch 'Introduce unstable CT lookup helpers'
      Merge branch 'bpf: Batching iter for AF_UNIX sockets.'
      Merge branch 'bpf: allow cgroup progs to export custom retval to userspace'
      Merge branch 'libbpf: deprecate legacy BPF map definitions'
      Merge branch 'libbpf: streamline netlink-based XDP APIs'
      Merge branch 'mvneta: introduce XDP multi-buffer support'

Andrii Nakryiko (11):
      Merge branch 'libbpf: rename bpf_prog_attach_xattr to bpf_prog_attach_opts'
      Merge branch 'libbpf 1.0: deprecate bpf_map__def() API'
      Merge branch 'rely on ASSERT marcos in xdp_bpf2bpf.c/xdp_adjust_tail.c'
      selftests/bpf: fail build on compilation warning
      selftests/bpf: convert remaining legacy map definitions
      libbpf: deprecate legacy BPF map definitions
      docs/bpf: update BPF map definition example
      libbpf: streamline low-level XDP APIs
      bpftool: use new API for attaching XDP program
      selftests/bpf: switch to new libbpf XDP APIs
      samples/bpf: adapt samples/bpf to bpf_xdp_xxx() APIs

Christy Lee (7):
      libbpf: Rename bpf_prog_attach_xattr() to bpf_prog_attach_opts()
      selftests/bpf: Change bpf_prog_attach_xattr() to bpf_prog_attach_opts()
      samples/bpf: Stop using bpf_map__def() API
      bpftool: Stop using bpf_map__def() API
      perf: Stop using bpf_map__def() API
      selftests/bpf: Stop using bpf_map__def() API
      libbpf: Deprecate bpf_map__def() API

Connor O'Brien (1):
      tools/resolve_btfids: Build with host flags

Daniel Borkmann (1):
      selftests, bpf: Do not yet switch to new libbpf XDP APIs

Di Zhu (2):
      bpf: support BPF_PROG_QUERY for progs attached to sockmap
      selftests: bpf: test BPF_PROG_QUERY for progs attached to sockmap

Eelco Chaudron (3):
      bpf: add frags support to the bpf_xdp_adjust_tail() API
      bpf: add frags support to xdp copy helpers
      bpf: selftests: update xdp_adjust_tail selftest to include xdp frags

Felix Maurer (1):
      selftests: bpf: Fix bind on used port

Kui-Feng Lee (1):
      libbpf: Improve btf__add_btf() with an additional hashmap for strings.

Kumar Kartikeya Dwivedi (11):
      bpf: Fix UAF due to race between btf_try_get_module and load_module
      bpf: Populate kfunc BTF ID sets in struct btf
      bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
      bpf: Introduce mem, size argument pair support for kfunc
      bpf: Add reference tracking support to kfunc
      net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
      selftests/bpf: Add test for unstable CT lookup API
      selftests/bpf: Add test_verifier support to fixup kfunc call insns
      selftests/bpf: Extend kfunc selftests
      selftests/bpf: Add test for race in btf_try_get_module
      selftests/bpf: Do not fail build if CONFIG_NF_CONNTRACK=m/n

Kuniyuki Iwashima (5):
      af_unix: Refactor unix_next_socket().
      bpf: af_unix: Use batching algorithm in bpf unix iter.
      bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
      selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
      selftest/bpf: Fix a stale comment.

Lorenzo Bianconi (21):
      bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c
      bpf: selftests: Get rid of CHECK macro in xdp_bpf2bpf.c
      net: skbuff: add size metadata to skb_shared_info for xdp
      xdp: introduce flags field in xdp_buff/xdp_frame
      net: mvneta: update frags bit before passing the xdp buffer to eBPF layer
      net: mvneta: simplify mvneta_swbm_add_rx_fragment management
      net: xdp: add xdp_update_skb_shared_info utility routine
      net: marvell: rely on xdp_update_skb_shared_info utility routine
      xdp: add frags support to xdp_return_{buff/frame}
      net: mvneta: add frags support to XDP_TX
      bpf: introduce BPF_F_XDP_HAS_FRAGS flag in prog_flags loading the ebpf program
      net: mvneta: enable jumbo frames if the loaded XDP program support frags
      bpf: introduce bpf_xdp_get_buff_len helper
      bpf: move user_size out of bpf_test_init
      bpf: introduce frags support to bpf_prog_test_run_xdp()
      bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature
      libbpf: Add SEC name for xdp frags programs
      net: xdp: introduce bpf_xdp_pointer utility routine
      bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
      bpf: selftests: add CPUMAP/DEVMAP selftests for xdp frags
      xdp: disable XDP_REDIRECT for xdp frags

Magnus Karlsson (1):
      selftests, xsk: Fix rx_full stats test

Mauricio Vásquez (2):
      libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
      bpftool: Fix error check when calling hashmap__new()

Menglong Dong (1):
      test: selftests: Remove unused various in sockmap_verdict_prog.c

Raman Shukhau (1):
      bpftool: Adding support for BTF program names

Toke Hoiland-Jorgensen (1):
      bpf: generalise tail call map compatibility check

Toke Høiland-Jørgensen (1):
      libbpf: Define BTF_KIND_* constants in btf.h to avoid compilation errors

Usama Arif (4):
      bpf/scripts: Raise an exception if the correct number of helpers are not generated
      uapi/bpf: Add missing description and returns for helper documentation
      bpf/scripts: Make description and returns section for helpers/syscalls mandatory
      bpf/scripts: Raise an exception if the correct number of sycalls are not generated

Wei Fu (1):
      bpftool: Only set obj->skeleton on complete success

Yafang Shao (1):
      libbpf: Fix possible NULL pointer dereference when destroying skeleton

YiFei Zhu (5):
      bpf: Make BPF_PROG_RUN_ARRAY return -err instead of allow boolean
      bpf: Move getsockopt retval to struct bpf_cg_run_ctx
      bpf: Add cgroup helpers bpf_{get,set}_retval to get/set syscall return value
      selftests/bpf: Test bpf_{get,set}_retval behavior with cgroup/sockopt
      selftests/bpf: Update sockopt_sk test to the use bpf_set_retval

kernel test robot (1):
      bpf: Fix flexible_array.cocci warnings

 Documentation/bpf/btf.rst                          |  32 +-
 drivers/net/ethernet/marvell/mvneta.c              | 204 +++++----
 include/linux/bpf.h                                |  82 ++--
 include/linux/bpf_verifier.h                       |   7 +
 include/linux/btf.h                                |  75 ++--
 include/linux/btf_ids.h                            |  13 +-
 include/linux/filter.h                             |   5 +-
 include/linux/skbuff.h                             |   1 +
 include/net/netfilter/nf_conntrack_bpf.h           |  23 +
 include/net/xdp.h                                  | 108 ++++-
 include/uapi/linux/bpf.h                           |  63 +++
 kernel/bpf/arraymap.c                              |   4 +-
 kernel/bpf/btf.c                                   | 368 ++++++++++++++--
 kernel/bpf/cgroup.c                                | 149 ++++---
 kernel/bpf/core.c                                  |  28 +-
 kernel/bpf/cpumap.c                                |   8 +-
 kernel/bpf/devmap.c                                |   3 +-
 kernel/bpf/syscall.c                               |  24 +-
 kernel/bpf/verifier.c                              | 196 ++++++---
 kernel/trace/bpf_trace.c                           |   3 +
 net/bpf/test_run.c                                 | 267 ++++++++++--
 net/core/filter.c                                  | 246 ++++++++++-
 net/core/net_namespace.c                           |   1 +
 net/core/sock_map.c                                |  77 +++-
 net/core/xdp.c                                     |  78 +++-
 net/ipv4/bpf_tcp_ca.c                              |  22 +-
 net/ipv4/tcp_bbr.c                                 |  18 +-
 net/ipv4/tcp_cubic.c                               |  17 +-
 net/ipv4/tcp_dctcp.c                               |  18 +-
 net/netfilter/Makefile                             |   5 +
 net/netfilter/nf_conntrack_bpf.c                   | 257 +++++++++++
 net/netfilter/nf_conntrack_core.c                  |   8 +
 net/unix/af_unix.c                                 | 250 +++++++++--
 samples/bpf/xdp1_user.c                            |   8 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   8 +-
 samples/bpf/xdp_fwd_user.c                         |   4 +-
 samples/bpf/xdp_router_ipv4_user.c                 |  10 +-
 samples/bpf/xdp_rxq_info_user.c                    |  18 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   8 +-
 samples/bpf/xdp_sample_user.c                      |   9 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |  10 +-
 samples/bpf/xdpsock_ctrl_proc.c                    |   2 +-
 samples/bpf/xdpsock_user.c                         |  10 +-
 samples/bpf/xsk_fwd.c                              |   4 +-
 scripts/bpf_doc.py                                 | 124 +++++-
 security/device_cgroup.c                           |   2 +-
 tools/bpf/bpftool/btf.c                            |   2 +-
 tools/bpf/bpftool/cgroup.c                         |   6 +-
 tools/bpf/bpftool/common.c                         |  44 ++
 tools/bpf/bpftool/gen.c                            |  14 +-
 tools/bpf/bpftool/link.c                           |   3 +-
 tools/bpf/bpftool/main.c                           |   9 +-
 tools/bpf/bpftool/main.h                           |   4 +
 tools/bpf/bpftool/map.c                            |   2 +-
 tools/bpf/bpftool/net.c                            |   2 +-
 tools/bpf/bpftool/pids.c                           |   3 +-
 tools/bpf/bpftool/prog.c                           |  30 +-
 tools/bpf/bpftool/struct_ops.c                     |   4 +-
 tools/bpf/resolve_btfids/Makefile                  |   6 +-
 tools/include/uapi/linux/bpf.h                     |  63 +++
 tools/lib/bpf/bpf.c                                |   9 +-
 tools/lib/bpf/bpf.h                                |   4 +
 tools/lib/bpf/bpf_helpers.h                        |   2 +-
 tools/lib/bpf/btf.c                                |  31 +-
 tools/lib/bpf/btf.h                                |  22 +-
 tools/lib/bpf/hashmap.c                            |   3 +-
 tools/lib/bpf/libbpf.c                             |  19 +
 tools/lib/bpf/libbpf.h                             |  32 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_legacy.h                      |   5 +
 tools/lib/bpf/netlink.c                            | 117 +++--
 tools/perf/util/bpf-loader.c                       |  64 ++-
 tools/perf/util/bpf_map.c                          |  28 +-
 tools/testing/selftests/bpf/Makefile               |   4 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  21 +-
 tools/testing/selftests/bpf/config                 |   5 +
 tools/testing/selftests/bpf/prog_tests/bind_perm.c |  20 +-
 .../bpf/prog_tests/bpf_iter_setsockopt_unix.c      | 100 +++++
 .../selftests/bpf/prog_tests/bpf_mod_race.c        | 230 ++++++++++
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  48 ++
 tools/testing/selftests/bpf/prog_tests/btf.c       |   4 +
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |  12 +-
 .../bpf/prog_tests/cgroup_getset_retval.c          | 481 +++++++++++++++++++++
 .../selftests/bpf/prog_tests/flow_dissector.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   2 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |   2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   6 +
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  66 +++
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  12 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |   4 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  36 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    | 104 +++++
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     | 193 +++++++--
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c | 137 +++---
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |  64 ++-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |  55 +++
 .../selftests/bpf/progs/bpf_iter_setsockopt_unix.c |  60 +++
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c  |   2 +-
 tools/testing/selftests/bpf/progs/bpf_mod_race.c   | 100 +++++
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |   2 +
 .../bpf/progs/cgroup_getset_retval_getsockopt.c    |  45 ++
 .../bpf/progs/cgroup_getset_retval_setsockopt.c    |  52 +++
 .../selftests/bpf/progs/freplace_cls_redirect.c    |  12 +-
 .../testing/selftests/bpf/progs/kfunc_call_race.c  |  14 +
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |  52 ++-
 tools/testing/selftests/bpf/progs/ksym_race.c      |  13 +
 .../testing/selftests/bpf/progs/sample_map_ret0.c  |  24 +-
 .../selftests/bpf/progs/sockmap_parse_prog.c       |   2 -
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |  32 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    | 118 +++++
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   3 +
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   3 +
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |  12 +-
 .../selftests/bpf/progs/test_skb_cgroup_id_kern.c  |  12 +-
 .../selftests/bpf/progs/test_sockmap_progs_query.c |  24 +
 tools/testing/selftests/bpf/progs/test_tc_edt.c    |  12 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c      |  12 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |  10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |  32 +-
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   2 +-
 .../selftests/bpf/progs/test_xdp_update_frags.c    |  42 ++
 .../bpf/progs/test_xdp_with_cpumap_frags_helpers.c |  27 ++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |   6 +
 .../bpf/progs/test_xdp_with_devmap_frags_helpers.c |  27 ++
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |   7 +
 tools/testing/selftests/bpf/test_verifier.c        |  28 ++
 tools/testing/selftests/bpf/verifier/calls.c       |  75 ++++
 tools/testing/selftests/bpf/xdpxceiver.c           |   5 +-
 128 files changed, 4990 insertions(+), 895 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bpf.h
 create mode 100644 net/netfilter/nf_conntrack_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_getset_retval.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_getsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/ksym_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_progs_query.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_frags_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_frags_helpers.c
