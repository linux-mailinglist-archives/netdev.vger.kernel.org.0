Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB05AD722
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiIEQLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIEQLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:11:41 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF9753036;
        Mon,  5 Sep 2022 09:11:39 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oVEhE-000432-JT; Mon, 05 Sep 2022 18:11:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-09-05
Date:   Mon,  5 Sep 2022 18:11:36 +0200
Message-Id: <20220905161136.9150-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26649/Mon Sep  5 09:56:18 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 106 non-merge commits during the last 18 day(s) which contain
a total of 159 files changed, 5225 insertions(+), 1358 deletions(-).

There are two small merge conflicts, resolve them as follows:

1) tools/testing/selftests/bpf/DENYLIST.s390x

  Commit 27e23836ce22 ("selftests/bpf: Add lru_bug to s390x deny list") in
  bpf tree was needed to get BPF CI green on s390x, but it conflicted with
  newly added tests on bpf-next. Resolve by adding both hunks, result:

  [...]
  lru_bug                                  # prog 'printk': failed to auto-attach: -524
  setget_sockopt                           # attach unexpected error: -524                                               (trampoline)
  cb_refs                                  # expected error message unexpected error: -524                               (trampoline)
  cgroup_hierarchical_stats                # JIT does not support calling kernel function                                (kfunc)
  htab_update                              # failed to attach: ERROR: strerror_r(-524)=22                                (trampoline)
  [...]

2) net/core/filter.c

  Commit 1227c1771dd2 ("net: Fix data-races around sysctl_[rw]mem_(max|default).")
  from net tree conflicts with commit 29003875bd5b ("bpf: Change bpf_setsockopt(SOL_SOCKET)
  to reuse sk_setsockopt()") from bpf-next tree. Take the code as it is from
  bpf-next tree, result:

  [...]
	if (getopt) {
		if (optname == SO_BINDTODEVICE)
			return -EINVAL;
		return sk_getsockopt(sk, SOL_SOCKET, optname,
				     KERNEL_SOCKPTR(optval),
				     KERNEL_SOCKPTR(optlen));
	}

	return sk_setsockopt(sk, SOL_SOCKET, optname,
			     KERNEL_SOCKPTR(optval), *optlen);
  [...]

The main changes are:

1) Add any-context BPF specific memory allocator which is useful in particular for BPF
   tracing with bonus of performance equal to full prealloc, from Alexei Starovoitov.

2) Big batch to remove duplicated code from bpf_{get,set}sockopt() helpers as an effort
   to reuse the existing core socket code as much as possible, from Martin KaFai Lau.

3) Extend BPF flow dissector for BPF programs to just augment the in-kernel dissector
   with custom logic. In other words, allow for partial replacement, from Shmulik Ladkani.

4) Add a new cgroup iterator to BPF with different traversal options, from Hao Luo.

5) Support for BPF to collect hierarchical cgroup statistics efficiently through BPF
   integration with the rstat framework, from Yosry Ahmed.

6) Support bpf_{g,s}et_retval() under more BPF cgroup hooks, from Stanislav Fomichev.

7) BPF hash table and local storages fixes under fully preemptible kernel, from Hou Tao.

8) Add various improvements to BPF selftests and libbpf for compilation with gcc BPF
   backend, from James Hilliard.

9) Fix verifier helper permissions and reference state management for synchronous
   callbacks, from Kumar Kartikeya Dwivedi.

10) Add support for BPF selftest's xskxceiver to also be used against real devices that
    support MAC loopback, from Maciej Fijalkowski.

11) Various fixes to the bpf-helpers(7) man page generation script, from Quentin Monnet.

12) Document BPF verifier's tnum_in(tnum_range(), ...) gotchas, from Shung-Hsi Yu.

13) Various minor misc improvements all over the place.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Alejandro Colomar, Alexei Starovoitov, Andrii Nakryiko, Hao 
Luo, Hao Sun, Jakub Wilk, John Fastabend, Kumar Kartikeya Dwivedi, 
Magnus Karlsson, Martin KaFai Lau, Mykola Lysenko, Quentin Monnet, Song 
Liu, Stanislav Fomichev, Tejun Heo, Yonghong Song

----------------------------------------------------------------

The following changes since commit fb8d784b531e363171c7e22f4f0980b4b128a607:

  net: ethernet: altera: Add use of ethtool_op_get_ts_info (2022-08-18 10:25:39 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 274052a2b0ab9f380ce22b19ff80a99b99ecb198:

  Merge branch 'bpf-allocator' (2022-09-05 15:33:11 +0200)

----------------------------------------------------------------
Alexei Starovoitov (21):
      Merge branch 'bpf: net: Remove duplicated code from bpf_setsockopt()'
      Merge branch 'bpf: expose bpf_{g,s}et_retval to more cgroup hooks'
      Merge branch 'Fix reference state management for synchronous callbacks'
      Merge branch 'bpf: rstat: cgroup hierarchical'
      Merge branch 'bpf: net: Remove duplicated code from bpf_getsockopt()'
      bpf: Introduce any context BPF specific memory allocator.
      bpf: Convert hash map to bpf_mem_alloc.
      selftests/bpf: Improve test coverage of test_maps
      samples/bpf: Reduce syscall overhead in map_perf_test.
      bpf: Relax the requirement to use preallocated hash maps in tracing progs.
      bpf: Optimize element count in non-preallocated hash map.
      bpf: Optimize call_rcu in non-preallocated hash map.
      bpf: Adjust low/high watermarks in bpf_mem_cache
      bpf: Batch call_rcu callbacks instead of SLAB_TYPESAFE_BY_RCU.
      bpf: Add percpu allocation support to bpf_mem_alloc.
      bpf: Convert percpu hash map to per-cpu bpf_mem_alloc.
      bpf: Remove tracing program restriction on map types
      bpf: Prepare bpf_mem_alloc to be used by sleepable bpf programs.
      bpf: Remove prealloc-only restriction for sleepable bpf programs.
      bpf: Remove usage of kmem_cache from bpf_mem_cache.
      bpf: Optimize rcu_barrier usage between hash map and bpf_mem_alloc.

Benjamin Tissoires (2):
      bpf: prepare for more bpf syscall to be used from kernel and user space.
      libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake.

Daniel Borkmann (1):
      Merge branch 'bpf-allocator'

Daniel Müller (2):
      selftests/bpf: Add cb_refs test to s390x deny list
      selftests/bpf: Store BPF object files with .bpf.o extension

Eyal Birger (1):
      bpf/scripts: Assert helper enum value is aligned with comment order

Hao Luo (4):
      bpf: Introduce cgroup iter
      selftests/bpf: Test cgroup_iter.
      bpf: Add CGROUP prefix to cgroup_iter_order
      bpftool: Add support for querying cgroup_iter link

Hou Tao (8):
      bpf: Disable preemption when increasing per-cpu map_locked
      bpf: Propagate error from htab_lock_bucket() to userspace
      selftests/bpf: Add test cases for htab update
      bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy
      bpf: Use this_cpu_{inc_return|dec} for prog->active
      selftests/bpf: Move sys_pidfd_open() into task_local_storage_helpers.h
      selftests/bpf: Test concurrent updates on bpf_task_storage_busy
      bpf: Only add BTF IDs for socket security hooks when CONFIG_SECURITY_NETWORK is on

Ian Rogers (1):
      selftests/xsk: Avoid use-after-free on ctx

James Hilliard (5):
      selftests/bpf: fix type conflict in test_tc_dtime
      selftests/bpf: Declare subprog_noise as static in tailcall_bpf2bpf4
      selftests/bpf: Fix bind{4,6} tcp/socket header type conflict
      selftests/bpf: Fix connect4_prog tcp/socket header type conflict
      libbpf: Add GCC support for bpf_tail_call_static

Jiapeng Chong (1):
      bpf: Remove useless else if

Kumar Kartikeya Dwivedi (3):
      bpf: Move bpf_loop and bpf_for_each_map_elem under CAP_BPF
      bpf: Fix reference state management for synchronous callbacks
      selftests/bpf: Add tests for reference state fixes for callbacks

Lam Thai (1):
      bpftool: Fix a wrong type cast in btf_dumper_int

Maciej Fijalkowski (6):
      selftests/xsk: Query for native XDP support
      selftests/xsk: Introduce default Rx pkt stream
      selftests/xsk: Increase chars for interface name to 16
      selftests/xsk: Add support for executing tests on physical device
      selftests/xsk: Make sure single threaded test terminates
      selftests/xsk: Add support for zero copy testing

Martin KaFai Lau (37):
      net: Add sk_setsockopt() to take the sk ptr instead of the sock ptr
      bpf: net: Avoid sk_setsockopt() taking sk lock when called from bpf
      bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()
      bpf: net: Change do_tcp_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: net: Change do_ip_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: net: Change do_ipv6_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: Initialize the bpf_run_ctx in bpf_iter_run_prog()
      bpf: Embed kernel CONFIG check into the if statement in bpf_setsockopt
      bpf: Change bpf_setsockopt(SOL_SOCKET) to reuse sk_setsockopt()
      bpf: Refactor bpf specific tcp optnames to a new function
      bpf: Change bpf_setsockopt(SOL_TCP) to reuse do_tcp_setsockopt()
      bpf: Change bpf_setsockopt(SOL_IP) to reuse do_ip_setsockopt()
      bpf: Change bpf_setsockopt(SOL_IPV6) to reuse do_ipv6_setsockopt()
      bpf: Add a few optnames to bpf_setsockopt
      selftests/bpf: bpf_setsockopt tests
      selftest/bpf: Add setget_sockopt to DENYLIST.s390x
      bpf, net: Avoid loading module when calling bpf_setsockopt(TCP_CONGESTION)
      selftest/bpf: Ensure no module loading in bpf_setsockopt(TCP_CONGESTION)
      Merge branch 'fixes for concurrent htab updates'
      Merge branch 'Use this_cpu_xxx for preemption-safety'
      net: Change sock_getsockopt() to take the sk ptr instead of the sock ptr
      bpf: net: Change sk_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid sk_getsockopt() taking sk lock when called from bpf
      bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_tcp_getsockopt() taking sk lock when called from bpf
      bpf: net: Change do_ip_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_ip_getsockopt() taking sk lock when called from bpf
      net: Remove unused flags argument from do_ipv6_getsockopt
      net: Add a len argument to compat_ipv6_get_msfilter()
      bpf: net: Change do_ipv6_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_ipv6_getsockopt() taking sk lock when called from bpf
      bpf: Embed kernel CONFIG check into the if statement in bpf_getsockopt
      bpf: Change bpf_getsockopt(SOL_SOCKET) to reuse sk_getsockopt()
      bpf: Change bpf_getsockopt(SOL_TCP) to reuse do_tcp_getsockopt()
      bpf: Change bpf_getsockopt(SOL_IP) to reuse do_ip_getsockopt()
      bpf: Change bpf_getsockopt(SOL_IPV6) to reuse do_ipv6_getsockopt()
      selftest/bpf: Add test for bpf_getsockopt()

Quentin Monnet (3):
      scripts/bpf: Set version attribute for bpf-helpers(7) man page
      scripts/bpf: Set date attribute for bpf-helpers(7) man page
      bpf: Fix a few typos in BPF helpers documentation

Shmulik Ladkani (6):
      flow_dissector: Make 'bpf_flow_dissect' return the bpf program retcode
      bpf, flow_dissector: Introduce BPF_FLOW_DISSECTOR_CONTINUE retcode for bpf progs
      bpf, test_run: Propagate bpf_flow_dissect's retval to user's bpf_attr.test.retval
      bpf, selftests: Test BPF_FLOW_DISSECTOR_CONTINUE
      bpf: Support getting tunnel flags
      selftests/bpf: Amend test_tunnel to exercise BPF_F_TUNINFO_FLAGS

Shung-Hsi Yu (1):
      bpf, tnums: Warn against the usage of tnum_in(tnum_range(), ...)

Stanislav Fomichev (5):
      bpf: Introduce cgroup_{common,current}_func_proto
      bpf: Use cgroup_{common,current}_func_proto in more hooks
      bpf: expose bpf_strtol and bpf_strtoul to all program types
      bpf: update bpf_{g,s}et_retval documentation
      selftests/bpf: Make sure bpf_{g,s}et_retval is exposed everywhere

Tiezhu Yang (1):
      bpf, mips: No need to use min() to get MAX_TAIL_CALL_CNT

Yang Yingliang (1):
      selftests/bpf: Fix wrong size passed to bpf_setsockopt()

Yosry Ahmed (3):
      cgroup: bpf: enable bpf programs to integrate with rstat
      selftests/bpf: extend cgroup helpers
      selftests/bpf: add a selftest for cgroup hierarchical stats collection

 arch/mips/net/bpf_jit_comp32.c                     |  10 +-
 arch/mips/net/bpf_jit_comp64.c                     |  10 +-
 include/linux/bpf-cgroup.h                         |  17 +
 include/linux/bpf.h                                |  22 +
 include/linux/bpf_mem_alloc.h                      |  28 +
 include/linux/bpf_verifier.h                       |  11 +
 include/linux/filter.h                             |   3 +-
 include/linux/igmp.h                               |   4 +-
 include/linux/mroute.h                             |   6 +-
 include/linux/mroute6.h                            |   4 +-
 include/linux/skbuff.h                             |   4 +-
 include/linux/sockptr.h                            |   5 +
 include/linux/tnum.h                               |  20 +-
 include/net/ip.h                                   |   4 +
 include/net/ipv6.h                                 |   6 +-
 include/net/ipv6_stubs.h                           |   4 +
 include/net/sock.h                                 |   9 +
 include/net/tcp.h                                  |   4 +
 include/uapi/linux/bpf.h                           |  83 ++-
 kernel/bpf/Makefile                                |   5 +-
 kernel/bpf/bpf_iter.c                              |   5 +
 kernel/bpf/bpf_local_storage.c                     |   4 +-
 kernel/bpf/bpf_lsm.c                               |  23 +-
 kernel/bpf/bpf_task_storage.c                      |   8 +-
 kernel/bpf/cgroup.c                                | 157 ++++-
 kernel/bpf/cgroup_iter.c                           | 282 +++++++++
 kernel/bpf/hashtab.c                               | 168 ++++--
 kernel/bpf/helpers.c                               |  48 +-
 kernel/bpf/memalloc.c                              | 634 ++++++++++++++++++++
 kernel/bpf/syscall.c                               |  15 +-
 kernel/bpf/trampoline.c                            |   8 +-
 kernel/bpf/verifier.c                              |  94 ++-
 kernel/cgroup/rstat.c                              |  48 ++
 net/core/filter.c                                  | 635 +++++++++------------
 net/core/flow_dissector.c                          |  16 +-
 net/core/sock.c                                    | 134 +++--
 net/ipv4/igmp.c                                    |  22 +-
 net/ipv4/ip_sockglue.c                             | 114 ++--
 net/ipv4/ipmr.c                                    |   9 +-
 net/ipv4/tcp.c                                     | 116 ++--
 net/ipv6/af_inet6.c                                |   2 +
 net/ipv6/ip6mr.c                                   |  10 +-
 net/ipv6/ipv6_sockglue.c                           | 113 ++--
 net/ipv6/mcast.c                                   |   8 +-
 samples/bpf/map_perf_test_kern.c                   |  44 +-
 samples/bpf/map_perf_test_user.c                   |   2 +-
 scripts/bpf_doc.py                                 |  78 ++-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/link.c                           |  35 ++
 tools/include/uapi/linux/bpf.h                     |  83 ++-
 tools/lib/bpf/bpf_helpers.h                        |  19 +-
 tools/lib/bpf/skel_internal.h                      |  23 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   4 +
 tools/testing/selftests/bpf/Makefile               |  37 +-
 tools/testing/selftests/bpf/README.rst             |   8 +-
 .../selftests/bpf/cgroup_getset_retval_hooks.h     |  25 +
 tools/testing/selftests/bpf/cgroup_helpers.c       | 202 +++++--
 tools/testing/selftests/bpf/cgroup_helpers.h       |  19 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |   2 +-
 .../selftests/bpf/map_tests/task_storage_map.c     | 122 ++++
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |   2 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |  54 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   4 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  10 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/cb_refs.c   |  48 ++
 .../bpf/prog_tests/cgroup_getset_retval.c          |  48 ++
 .../bpf/prog_tests/cgroup_hierarchical_stats.c     | 357 ++++++++++++
 .../testing/selftests/bpf/prog_tests/cgroup_iter.c | 224 ++++++++
 .../selftests/bpf/prog_tests/connect_force_port.c  |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  74 +--
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  44 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |  44 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |   2 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   4 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   2 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |   2 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |   2 +-
 .../testing/selftests/bpf/prog_tests/htab_update.c | 126 ++++
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   4 +-
 .../selftests/bpf/prog_tests/load_bytes_relative.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |   4 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |   2 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |   2 +-
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   4 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |   2 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |   2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   2 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |   4 +-
 .../selftests/bpf/prog_tests/setget_sockopt.c      | 125 ++++
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   2 +-
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   2 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |   2 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |   2 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |   2 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |   2 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  36 +-
 .../selftests/bpf/prog_tests/task_fd_query_rawtp.c |   2 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |   2 +-
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |   2 +-
 .../selftests/bpf/prog_tests/test_bprm_opts.c      |  10 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |  34 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |  10 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |   2 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |   2 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |  10 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |   2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |   2 +-
 tools/testing/selftests/bpf/progs/bind4_prog.c     |   2 -
 tools/testing/selftests/bpf/progs/bind6_prog.c     |   2 -
 tools/testing/selftests/bpf/progs/bpf_flow.c       |  15 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   7 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |  32 +-
 tools/testing/selftests/bpf/progs/cb_refs.c        | 116 ++++
 .../bpf/progs/cgroup_getset_retval_hooks.c         |  16 +
 .../bpf/progs/cgroup_hierarchical_stats.c          | 226 ++++++++
 tools/testing/selftests/bpf/progs/cgroup_iter.c    |  39 ++
 tools/testing/selftests/bpf/progs/connect4_prog.c  |   5 +-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |   8 +-
 tools/testing/selftests/bpf/progs/htab_update.c    |  29 +
 .../bpf/progs/read_bpf_task_storage_busy.c         |  39 ++
 tools/testing/selftests/bpf/progs/setget_sockopt.c | 395 +++++++++++++
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   2 +-
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |   1 -
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  24 +-
 tools/testing/selftests/bpf/progs/timer.c          |  11 -
 .../selftests/bpf/task_local_storage_helpers.h     |  18 +
 tools/testing/selftests/bpf/test_dev_cgroup.c      |   2 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |   8 +
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |  48 +-
 tools/testing/selftests/bpf/test_offload.py        |  22 +-
 tools/testing/selftests/bpf/test_skb_cgroup_id.sh  |   2 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |  16 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   4 +-
 tools/testing/selftests/bpf/test_sysctl.c          |   6 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |   2 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   2 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |   8 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |   2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |   8 +-
 tools/testing/selftests/bpf/test_xsk.sh            |  52 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   2 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |   2 +-
 tools/testing/selftests/bpf/xdping.c               |   2 +-
 tools/testing/selftests/bpf/xsk.c                  |   6 +-
 tools/testing/selftests/bpf/xskxceiver.c           | 398 +++++++++----
 tools/testing/selftests/bpf/xskxceiver.h           |  11 +-
 159 files changed, 5225 insertions(+), 1358 deletions(-)
 create mode 100644 include/linux/bpf_mem_alloc.h
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 kernel/bpf/memalloc.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_getset_retval_hooks.h
 create mode 100644 tools/testing/selftests/bpf/map_tests/task_storage_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cb_refs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/htab_update.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/cb_refs.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_hooks.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/htab_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/read_bpf_task_storage_busy.c
 create mode 100644 tools/testing/selftests/bpf/progs/setget_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/task_local_storage_helpers.h
