Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5C259F67
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgIATuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:50:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:35764 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgIATuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:50:04 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDCHv-0005n3-2l; Tue, 01 Sep 2020 21:49:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-09-01
Date:   Tue,  1 Sep 2020 21:49:50 +0200
Message-Id: <20200901194950.13591-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25917/Tue Sep  1 15:24:01 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

There are two small conflicts when pulling, resolve as follows:

1) Merge conflict in tools/lib/bpf/libbpf.c between 88a82120282b ("libbpf: Factor
   out common ELF operations and improve logging") in bpf-next and 1e891e513e16
   ("libbpf: Fix map index used in error message") in net-next. Resolve by taking
   the hunk in bpf-next:

        [...]
        scn = elf_sec_by_idx(obj, obj->efile.btf_maps_shndx);
        data = elf_sec_data(obj, scn);
        if (!scn || !data) {
                pr_warn("elf: failed to get %s map definitions for %s\n",
                        MAPS_ELF_SEC, obj->path);
                return -EINVAL;
        }
        [...]

2) Merge conflict in drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c between
   9647c57b11e5 ("xsk: i40e: ice: ixgbe: mlx5: Test for dma_need_sync earlier for
   better performance") in bpf-next and e20f0dbf204f ("net/mlx5e: RX, Add a prefetch
   command for small L1_CACHE_BYTES") in net-next. Resolve the two locations by retaining
   net_prefetch() and taking xsk_buff_dma_sync_for_cpu() from bpf-next. Should look like:

        [...]
        xdp_set_data_meta_invalid(xdp);
        xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
        net_prefetch(xdp->data);
        [...]

We've added 133 non-merge commits during the last 14 day(s) which contain
a total of 246 files changed, 13832 insertions(+), 3105 deletions(-).

The main changes are:

1) Initial support for sleepable BPF programs along with bpf_copy_from_user() helper
   for tracing to reliably access user memory, from Alexei Starovoitov.

2) Add BPF infra for writing and parsing TCP header options, from Martin KaFai Lau.

3) bpf_d_path() helper for returning full path for given 'struct path', from Jiri Olsa.

4) AF_XDP support for shared umems between devices and queues, from Magnus Karlsson.

5) Initial prep work for full BPF-to-BPF call support in libbpf, from Andrii Nakryiko.

6) Generalize bpf_sk_storage map & add local storage for inodes, from KP Singh.

7) Implement sockmap/hash updates from BPF context, from Lorenz Bauer.

8) BPF xor verification for scalar types & add BPF link iterator, from Yonghong Song.

9) Use target's prog type for BPF_PROG_TYPE_EXT prog verification, from Udip Pant.

10) Rework BPF tracing samples to use libbpf loader, from Daniel T. Lee.

11) Fix xdpsock sample to really cycle through all buffers, from Weqaar Janjua.

12) Improve type safety for tun/veth XDP frame handling, from Maciej Żenczykowski.

13) Various smaller cleanups and improvements all over the place.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Alexei Starovoitov, Andrii Nakryiko, Björn Töpel, Eric 
Dumazet, Jesper Dangaard Brouer, Jiri Olsa, John Fastabend, Josef Bacik, 
kernel test robot, KP Singh, Martin KaFai Lau, Naresh Kamboju, Paul E. 
McKenney, Song Liu, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit e3ec1e8ca02b7e6c935bba3f9b6da86c2e57d2eb:

  net: eliminate meaningless memcpy to data in pskb_carve_inside_nonlinear() (2020-08-18 15:55:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to ebc4ecd48ca6552b223047839f66e9a9c09aea4c:

  bpf: {cpu,dev}map: Change various functions return type from int to void (2020-09-01 15:45:58 +0200)

----------------------------------------------------------------
Alex Gartrell (1):
      libbpf: Fix unintentional success return code in bpf_object__load

Alexei Starovoitov (20):
      Merge branch 'libbpf-probing-improvements'
      Merge branch 'libbpf-minimize-feature-detection'
      Merge branch 'type-and-enum-value-relos'
      bpf: Factor out bpf_link_by_id() helper.
      bpf: Add BPF program and map iterators as built-in BPF programs.
      bpf: Add kernel module with user mode driver that populates bpffs.
      selftests/bpf: Add bpffs preload test.
      Merge branch 'link_query-bpf_iter'
      Merge branch 'update-sockmap-from-prog'
      Merge branch 'bpf-tcp-header-opts'
      bpf: Disallow BPF_PRELOAD in allmodconfig builds
      Merge branch 'resolve_prog_type'
      mm/error_inject: Fix allow_error_inject function signatures.
      bpf: Introduce sleepable BPF programs
      bpf: Add bpf_copy_from_user() helper.
      libbpf: Support sleepable progs
      selftests/bpf: Add sleepable tests
      bpf: Fix build without BPF_SYSCALL, but with BPF_JIT.
      bpf: Fix build without BPF_LSM.
      bpf: Remove bpf_lsm_file_mprotect from sleepable list.

Andrii Nakryiko (33):
      libbpf: Disable -Wswitch-enum compiler warning
      libbpf: Make kernel feature probing lazy
      libbpf: Factor out common logic of testing and closing FD
      libbpf: Sanitize BPF program code for bpf_probe_read_{kernel, user}[_str]
      selftests/bpf: Fix test_vmlinux test to use bpf_probe_read_user()
      libbpf: Switch tracing and CO-RE helper macros to bpf_probe_read_kernel()
      libbpf: Detect minimal BTF support and skip BTF loading, if missing
      libbpf: Improve error logging for mismatched BTF kind cases
      libbpf: Clean up and improve CO-RE reloc logging
      libbpf: Improve relocation ambiguity detection
      selftests/bpf: Add test validating failure on ambiguous relocation value
      libbpf: Remove any use of reallocarray() in libbpf
      tools/bpftool: Remove libbpf_internal.h usage in bpftool
      libbpf: Centralize poisoning and poison reallocarray()
      tools: Remove feature-libelf-mmap feature detection
      libbpf: Implement type-based CO-RE relocations support
      selftests/bpf: Test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
      selftests/bpf: Add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
      libbpf: Implement enum value-based CO-RE relocations
      selftests/bpf: Add tests for ENUMVAL_EXISTS/ENUMVAL_VALUE relocations
      libbpf: Fix detection of BPF helper call instruction
      libbpf: Fix libbpf build on compilers missing __builtin_mul_overflow
      selftests/bpf: Fix two minor compilation warnings reported by GCC 4.9
      selftests/bpf: List newest Clang built-ins needed for some CO-RE selftests
      libbpf: Add perf_buffer APIs for better integration with outside epoll loop
      selftests/bpf: BPF object files should depend only on libbpf headers
      libbpf: Factor out common ELF operations and improve logging
      libbpf: Add __noinline macro to bpf_helpers.h
      libbpf: Skip well-known ELF sections when iterating ELF
      libbpf: Normalize and improve logging across few functions
      libbpf: Avoid false unuinitialized variable warning in bpf_core_apply_relo
      libbpf: Fix type compatibility check copy-paste error
      libbpf: Fix compilation warnings for 64-bit printf args

Björn Töpel (1):
      bpf: {cpu,dev}map: Change various functions return type from int to void

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake "scoket" -> "socket"

Cristian Dumitrescu (1):
      samples/bpf: Add new sample xsk_fwd.c

Daniel Borkmann (2):
      Merge branch 'bpf-umd-debug'
      Merge branch 'bpf-sleepable'

Daniel T. Lee (4):
      samples: bpf: Fix broken bpf programs due to removed symbol
      samples: bpf: Cleanup bpf_load.o from Makefile
      samples: bpf: Refactor kprobe tracing programs with libbpf
      samples: bpf: Refactor tracepoint tracing programs with libbpf

Jakub Sitnicki (1):
      bpf: sk_lookup: Add user documentation

Jesper Dangaard Brouer (1):
      tools, bpf/build: Cleanup feature files on make clean

Jianlin Lv (1):
      docs: Correct subject prefix and update LLVM info

Jiri Olsa (15):
      tools resolve_btfids: Add size check to get_id function
      tools resolve_btfids: Add support for set symbols
      bpf: Move btf_resolve_size into __btf_resolve_size
      bpf: Add elem_id pointer as argument to __btf_resolve_size
      bpf: Add type_id pointer as argument to __btf_resolve_size
      bpf: Remove recursion call in btf_struct_access
      bpf: Factor btf_struct_access function
      bpf: Add btf_struct_ids_match function
      bpf: Add BTF_SET_START/END macros
      bpf: Add d_path helper
      bpf: Update .BTF_ids section in btf.rst with sets info
      selftests/bpf: Add verifier test for d_path helper
      selftests/bpf: Add test for d_path helper
      selftests/bpf: Add set test to resolve_btfids
      selftests/bpf: Fix open call in trigger_fstat_events

KP Singh (7):
      bpf: Renames in preparation for bpf_local_storage
      bpf: Generalize caching for sk_storage.
      bpf: Generalize bpf_sk_storage
      bpf: Split bpf_local_storage to bpf_sk_storage
      bpf: Implement bpf_local_storage for inodes
      bpf: Allow local storage to be used from LSM programs
      bpf: Add selftests for local_storage

Lorenz Bauer (7):
      net: sk_msg: Simplify sk_psock initialization
      bpf: sockmap: Merge sockmap and sockhash update functions
      bpf: sockmap: Call sock_map_update_elem directly
      bpf: Override the meaning of ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
      bpf: sockmap: Allow update from BPF
      selftests: bpf: Test sockmap update from BPF
      selftests: bpf: Fix sockmap update nits

Maciej Żenczykowski (3):
      net-tun: Add type safety to tun_xdp_to_ptr() and tun_ptr_to_xdp()
      net-tun: Eliminate two tun/xdp related function calls from vhost-net
      net-veth: Add type safety to veth_xdp_to_ptr() and veth_ptr_to_xdp()

Magnus Karlsson (15):
      xsk: i40e: ice: ixgbe: mlx5: Pass buffer pool to driver instead of umem
      xsk: i40e: ice: ixgbe: mlx5: Rename xsk zero-copy driver interfaces
      xsk: Create and free buffer pool independently from umem
      xsk: Move fill and completion rings to buffer pool
      xsk: Move queue_id, dev and need_wakeup to buffer pool
      xsk: Move xsk_tx_list and its lock to buffer pool
      xsk: Move addrs from buffer pool to umem
      xsk: Enable sharing of dma mappings
      xsk: Rearrange internal structs for better performance
      xsk: i40e: ice: ixgbe: mlx5: Test for dma_need_sync earlier for better performance
      xsk: Add shared umem support between queue ids
      xsk: Add shared umem support between devices
      libbpf: Support shared umems between queues and devices
      xsk: Documentation for XDP_SHARED_UMEM between queues and netdevs
      samples/bpf: Optimize l2fwd performance in xdpsock

Martin KaFai Lau (15):
      tcp: Use a struct to represent a saved_syn
      tcp: bpf: Add TCP_BPF_DELACK_MAX setsockopt
      tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt
      tcp: Add saw_unknown to struct tcp_options_received
      bpf: tcp: Add bpf_skops_established()
      bpf: tcp: Add bpf_skops_parse_hdr()
      bpf: tcp: Add bpf_skops_hdr_opt_len() and bpf_skops_write_hdr_opt()
      bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
      bpf: tcp: Allow bpf prog to write and parse TCP header option
      bpf: selftests: Add fastopen_connect to network_helpers
      bpf: selftests: Tcp header options
      tcp: bpf: Optionally store mac header in TCP_SAVE_SYN
      bpf: Add map_meta_equal map ops
      bpf: Relax max_entries check for most of the inner map types
      bpf: selftests: Add test for different inner map size

Udip Pant (4):
      bpf: verifier: Use target program's type for access verifications
      selftests/bpf: Add test for freplace program with write access
      selftests/bpf: Test for checking return code for the extended prog
      selftests/bpf: Test for map update access from within EXT programs

Weqaar Janjua (1):
      samples/bpf: Fix to xdpsock to avoid recycling frames

Xu Wang (2):
      libbpf: Convert comma to semicolon
      libbpf: Simplify the return expression of build_map_pin_path()

Yonghong Song (7):
      bpf: Implement link_query for bpf iterators
      bpf: Implement link_query callbacks in map element iterators
      bpftool: Implement link_query for bpf iterators
      selftests/bpf: Enable tc verbose mode for test_sk_assign
      bpf: Fix a verifier failure with xor
      selftests/bpf: Add verifier tests for xor operation
      bpf: Make bpf_link_info.iter similar to bpf_iter_link_info

 Documentation/bpf/bpf_devel_QA.rst                 |   19 +-
 Documentation/bpf/btf.rst                          |   25 +
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/prog_sk_lookup.rst               |   98 ++
 Documentation/networking/af_xdp.rst                |   68 +-
 arch/x86/net/bpf_jit_comp.c                        |   32 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   29 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   81 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |    4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   18 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   16 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  138 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h           |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   34 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   63 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    5 +-
 .../mellanox/mlx5/core/en/xsk/{umem.c => pool.c}   |  110 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.h  |   27 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   29 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   49 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   16 +-
 drivers/net/tun.c                                  |   18 -
 drivers/net/veth.c                                 |    6 +-
 include/linux/bpf-cgroup.h                         |   25 +
 include/linux/bpf.h                                |   52 +
 include/linux/bpf_local_storage.h                  |  163 ++
 include/linux/bpf_lsm.h                            |   29 +
 include/linux/bpf_types.h                          |    3 +
 include/linux/btf.h                                |    3 +-
 include/linux/btf_ids.h                            |   51 +-
 include/linux/filter.h                             |    8 +-
 include/linux/if_tun.h                             |   19 +-
 include/linux/netdevice.h                          |   10 +-
 include/linux/rcupdate_trace.h                     |    9 +-
 include/linux/skmsg.h                              |   17 -
 include/linux/tcp.h                                |   20 +-
 include/net/bpf_sk_storage.h                       |   14 +
 include/net/inet_connection_sock.h                 |    2 +
 include/net/request_sock.h                         |    9 +-
 include/net/sock.h                                 |    4 +-
 include/net/tcp.h                                  |   59 +-
 include/net/xdp_sock.h                             |   30 +-
 include/net/xdp_sock_drv.h                         |  122 +-
 include/net/xsk_buff_pool.h                        |   53 +-
 include/uapi/linux/bpf.h                           |  398 ++++-
 init/Kconfig                                       |    3 +
 kernel/Makefile                                    |    2 +-
 kernel/bpf/Makefile                                |    3 +
 kernel/bpf/arraymap.c                              |   17 +
 kernel/bpf/bpf_inode_storage.c                     |  274 +++
 kernel/bpf/bpf_iter.c                              |   58 +
 kernel/bpf/bpf_local_storage.c                     |  600 +++++++
 kernel/bpf/bpf_lsm.c                               |   21 +-
 kernel/bpf/bpf_struct_ops.c                        |    6 +-
 kernel/bpf/btf.c                                   |  163 +-
 kernel/bpf/cpumap.c                                |   12 +-
 kernel/bpf/devmap.c                                |   17 +-
 kernel/bpf/hashtab.c                               |   16 +-
 kernel/bpf/helpers.c                               |   22 +
 kernel/bpf/inode.c                                 |  116 +-
 kernel/bpf/lpm_trie.c                              |    1 +
 kernel/bpf/map_in_map.c                            |   24 +-
 kernel/bpf/map_in_map.h                            |    2 -
 kernel/bpf/map_iter.c                              |   15 +
 kernel/bpf/preload/Kconfig                         |   26 +
 kernel/bpf/preload/Makefile                        |   23 +
 kernel/bpf/preload/bpf_preload.h                   |   16 +
 kernel/bpf/preload/bpf_preload_kern.c              |   91 +
 kernel/bpf/preload/bpf_preload_umd_blob.S          |    7 +
 kernel/bpf/preload/iterators/.gitignore            |    2 +
 kernel/bpf/preload/iterators/Makefile              |   57 +
 kernel/bpf/preload/iterators/README                |    4 +
 kernel/bpf/preload/iterators/bpf_preload_common.h  |   13 +
 kernel/bpf/preload/iterators/iterators.bpf.c       |  114 ++
 kernel/bpf/preload/iterators/iterators.c           |   94 ++
 kernel/bpf/preload/iterators/iterators.skel.h      |  410 +++++
 kernel/bpf/queue_stack_maps.c                      |    2 +
 kernel/bpf/reuseport_array.c                       |    1 +
 kernel/bpf/ringbuf.c                               |    1 +
 kernel/bpf/stackmap.c                              |    1 +
 kernel/bpf/syscall.c                               |   68 +-
 kernel/bpf/trampoline.c                            |   29 +-
 kernel/bpf/verifier.c                              |  283 +++-
 kernel/trace/bpf_trace.c                           |   50 +
 mm/filemap.c                                       |    8 +-
 mm/page_alloc.c                                    |    2 +-
 net/bpfilter/Kconfig                               |    1 +
 net/core/bpf_sk_storage.c                          |  833 ++-------
 net/core/filter.c                                  |  416 ++++-
 net/core/skmsg.c                                   |   34 +-
 net/core/sock_map.c                                |   91 +-
 net/ethtool/channels.c                             |    2 +-
 net/ethtool/ioctl.c                                |    2 +-
 net/ipv4/tcp.c                                     |   16 +-
 net/ipv4/tcp_bpf.c                                 |   13 +-
 net/ipv4/tcp_fastopen.c                            |    2 +-
 net/ipv4/tcp_input.c                               |  127 +-
 net/ipv4/tcp_ipv4.c                                |    5 +-
 net/ipv4/tcp_minisocks.c                           |    1 +
 net/ipv4/tcp_output.c                              |  193 ++-
 net/ipv4/udp_bpf.c                                 |    9 +-
 net/ipv6/tcp_ipv6.c                                |    5 +-
 net/xdp/xdp_umem.c                                 |  225 +--
 net/xdp/xdp_umem.h                                 |    6 -
 net/xdp/xsk.c                                      |  213 ++-
 net/xdp/xsk.h                                      |   10 +-
 net/xdp/xsk_buff_pool.c                            |  380 ++++-
 net/xdp/xsk_diag.c                                 |   16 +-
 net/xdp/xsk_queue.h                                |   12 +-
 net/xdp/xskmap.c                                   |    8 +
 samples/bpf/Makefile                               |   21 +-
 samples/bpf/cpustat_kern.c                         |   36 +-
 samples/bpf/cpustat_user.c                         |   47 +-
 samples/bpf/lathist_kern.c                         |   24 +-
 samples/bpf/lathist_user.c                         |   42 +-
 samples/bpf/offwaketime_kern.c                     |   52 +-
 samples/bpf/offwaketime_user.c                     |   66 +-
 samples/bpf/spintest_kern.c                        |   36 +-
 samples/bpf/spintest_user.c                        |   68 +-
 samples/bpf/syscall_tp_kern.c                      |   24 +-
 samples/bpf/syscall_tp_user.c                      |   54 +-
 samples/bpf/task_fd_query_kern.c                   |    2 +-
 samples/bpf/task_fd_query_user.c                   |    2 +-
 samples/bpf/test_current_task_under_cgroup_kern.c  |   27 +-
 samples/bpf/test_current_task_under_cgroup_user.c  |   52 +-
 samples/bpf/test_probe_write_user_kern.c           |   12 +-
 samples/bpf/test_probe_write_user_user.c           |   49 +-
 samples/bpf/trace_output_kern.c                    |   15 +-
 samples/bpf/trace_output_user.c                    |   55 +-
 samples/bpf/tracex3_kern.c                         |    2 +-
 samples/bpf/xdpsock_user.c                         |   32 +-
 samples/bpf/xsk_fwd.c                              | 1085 ++++++++++++
 scripts/bpf_helpers_doc.py                         |    2 +
 security/bpf/hooks.c                               |    6 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    2 +-
 tools/bpf/bpftool/Makefile                         |    6 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    3 +-
 tools/bpf/bpftool/gen.c                            |    2 -
 tools/bpf/bpftool/link.c                           |   44 +-
 tools/bpf/bpftool/map.c                            |    3 +-
 tools/bpf/bpftool/net.c                            |  299 +++-
 tools/bpf/resolve_btfids/main.c                    |   29 +-
 tools/build/Makefile                               |    2 +
 tools/build/Makefile.feature                       |    1 -
 tools/build/feature/Makefile                       |    4 -
 tools/build/feature/test-all.c                     |    4 -
 tools/build/feature/test-libelf-mmap.c             |    9 -
 tools/include/linux/btf_ids.h                      |   51 +-
 tools/include/uapi/linux/bpf.h                     |  398 ++++-
 tools/lib/bpf/Makefile                             |   23 +-
 tools/lib/bpf/bpf.c                                |    3 -
 tools/lib/bpf/bpf_core_read.h                      |  120 +-
 tools/lib/bpf/bpf_helpers.h                        |    3 +
 tools/lib/bpf/bpf_prog_linfo.c                     |    3 -
 tools/lib/bpf/bpf_tracing.h                        |    4 +-
 tools/lib/bpf/btf.c                                |   31 +-
 tools/lib/bpf/btf.h                                |   38 -
 tools/lib/bpf/btf_dump.c                           |    9 +-
 tools/lib/bpf/hashmap.c                            |    3 +
 tools/lib/bpf/libbpf.c                             | 1759 ++++++++++++++------
 tools/lib/bpf/libbpf.h                             |    4 +
 tools/lib/bpf/libbpf.map                           |    9 +
 tools/lib/bpf/libbpf_internal.h                    |  138 +-
 tools/lib/bpf/libbpf_probes.c                      |    8 +-
 tools/lib/bpf/netlink.c                            |  128 +-
 tools/lib/bpf/nlattr.c                             |    9 +-
 tools/lib/bpf/ringbuf.c                            |    8 +-
 tools/lib/bpf/xsk.c                                |  379 +++--
 tools/lib/bpf/xsk.h                                |    9 +
 tools/perf/Makefile.config                         |    4 -
 tools/perf/util/symbol.h                           |    2 +-
 tools/testing/selftests/bpf/Makefile               |    2 +-
 tools/testing/selftests/bpf/README.rst             |   21 +
 tools/testing/selftests/bpf/bench.c                |    2 +
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   17 +
 tools/testing/selftests/bpf/network_helpers.c      |   37 +
 tools/testing/selftests/bpf/network_helpers.h      |    2 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |   35 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  350 +++-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |  147 ++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   68 +
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   65 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   39 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |    5 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   76 +
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  622 +++++++
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  |   94 ++
 .../selftests/bpf/prog_tests/test_local_storage.c  |   60 +
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |    9 +
 .../selftests/bpf/progs/btf__core_reloc_enumval.c  |    3 +
 .../bpf/progs/btf__core_reloc_enumval___diff.c     |    3 +
 .../progs/btf__core_reloc_enumval___err_missing.c  |    3 +
 .../progs/btf__core_reloc_enumval___val3_missing.c |    3 +
 .../progs/btf__core_reloc_size___err_ambiguous.c   |    4 +
 .../bpf/progs/btf__core_reloc_type_based.c         |    3 +
 .../btf__core_reloc_type_based___all_missing.c     |    3 +
 .../progs/btf__core_reloc_type_based___diff_sz.c   |    3 +
 .../btf__core_reloc_type_based___fn_wrong_args.c   |    3 +
 .../progs/btf__core_reloc_type_based___incompat.c  |    3 +
 .../selftests/bpf/progs/btf__core_reloc_type_id.c  |    3 +
 .../btf__core_reloc_type_id___missing_targets.c    |    3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  352 +++-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |   27 +
 .../selftests/bpf/progs/freplace_attach_probe.c    |   40 +
 .../selftests/bpf/progs/freplace_cls_redirect.c    |   34 +
 .../selftests/bpf/progs/freplace_connect_v4_prog.c |   19 +
 tools/testing/selftests/bpf/progs/local_storage.c  |  140 ++
 tools/testing/selftests/bpf/progs/lsm.c            |   64 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    6 +-
 .../selftests/bpf/progs/test_btf_map_in_map.c      |   31 +
 .../selftests/bpf/progs/test_core_reloc_enumval.c  |   72 +
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |    2 +
 .../bpf/progs/test_core_reloc_type_based.c         |  110 ++
 .../selftests/bpf/progs/test_core_reloc_type_id.c  |  115 ++
 tools/testing/selftests/bpf/progs/test_d_path.c    |   58 +
 .../bpf/progs/test_misc_tcp_hdr_options.c          |  325 ++++
 .../testing/selftests/bpf/progs/test_pkt_access.c  |   20 +
 .../bpf/progs/test_sockmap_invalid_update.c        |   23 +
 .../selftests/bpf/progs/test_sockmap_update.c      |   48 +
 .../selftests/bpf/progs/test_tcp_hdr_options.c     |  623 +++++++
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |   12 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    7 +
 .../selftests/bpf/test_current_pid_tgid_new_ns.c   |    1 +
 tools/testing/selftests/bpf/test_tcp_hdr_options.h |  151 ++
 tools/testing/selftests/bpf/test_verifier.c        |   19 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |  146 ++
 tools/testing/selftests/bpf/verifier/d_path.c      |   37 +
 246 files changed, 13832 insertions(+), 3105 deletions(-)
 create mode 100644 Documentation/bpf/prog_sk_lookup.rst
 rename drivers/net/ethernet/mellanox/mlx5/core/en/xsk/{umem.c => pool.c} (51%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
 create mode 100644 include/linux/bpf_local_storage.h
 create mode 100644 kernel/bpf/bpf_inode_storage.c
 create mode 100644 kernel/bpf/bpf_local_storage.c
 create mode 100644 kernel/bpf/preload/Kconfig
 create mode 100644 kernel/bpf/preload/Makefile
 create mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
 create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 create mode 100644 kernel/bpf/preload/iterators/.gitignore
 create mode 100644 kernel/bpf/preload/iterators/Makefile
 create mode 100644 kernel/bpf/preload/iterators/README
 create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
 create mode 100644 samples/bpf/xsk_fwd.c
 delete mode 100644 tools/build/feature/test-libelf-mmap.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpffs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumval___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___err_ambiguous.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___all_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___fn_wrong_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___incompat.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___missing_targets.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect_v4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enumval.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_invalid_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h
 create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
