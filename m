Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D6423B14B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgHCX45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:56:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:49212 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgHCX45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:56:57 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2kJs-0003vy-KD; Tue, 04 Aug 2020 01:56:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-08-04
Date:   Tue,  4 Aug 2020 01:56:40 +0200
Message-Id: <20200803235640.31210-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25893/Mon Aug  3 17:01:47 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 73 non-merge commits during the last 9 day(s) which contain
a total of 135 files changed, 4603 insertions(+), 1013 deletions(-).

The main changes are:

1) Implement bpf_link support for XDP. Also add LINK_DETACH operation for the BPF
   syscall allowing processes with BPF link FD to force-detach, from Andrii Nakryiko.

2) Add BPF iterator for map elements and to iterate all BPF programs for efficient
   in-kernel inspection, from Yonghong Song and Alexei Starovoitov.

3) Separate bpf_get_{stack,stackid}() helpers for perf events in BPF to avoid
   unwinder errors, from Song Liu.

4) Allow cgroup local storage map to be shared between programs on the same
   cgroup. Also extend BPF selftests with coverage, from YiFei Zhu.

5) Add BPF exception tables to ARM64 JIT in order to be able to JIT BPF_PROBE_MEM
   load instructions, from Jean-Philippe Brucker.

6) Follow-up fixes on BPF socket lookup in combination with reuseport group
   handling. Also add related BPF selftests, from Jakub Sitnicki.

7) Allow to use socket storage in BPF_PROG_TYPE_CGROUP_SOCK-typed programs for
   socket create/release as well as bind functions, from Stanislav Fomichev.

8) Fix an info leak in xsk_getsockopt() when retrieving XDP stats via old struct
   xdp_statistics, from Peilin Ye.

9) Fix PT_REGS_RC{,_CORE}() macros in libbpf for MIPS arch, from Jerry Crunchtime.

10) Extend BPF kernel test infra with skb->family and skb->{local,remote}_ip{4,6}
    fields and allow user space to specify skb->dev via ifindex, from Dmitry Yakunin.

11) Fix a bpftool segfault due to missing program type name and make it more robust
    to prevent them in future gaps, from Quentin Monnet.

12) Consolidate cgroup helper functions across selftests and fix a v6 localhost
    resolver issue, from John Fastabend.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Note that this will have a minor merge conflict with net-next between the commit
829eb208e80d ("rtnetlink: add support for protodown reason") from the net-next tree
and commits 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in
net_device") and aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
from the bpf-next tree.

Resolve by keeping both hunks in net/core/dev.c as follows:

[...]
void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
                                  u32 value)
{
        int b;

        if (!mask) {
                dev->proto_down_reason = value;
        } else {
                for_each_set_bit(b, &mask, 32) {
                        if (value & (1 << b))
                                dev->proto_down_reason |= BIT(b);
                        else
                                dev->proto_down_reason &= ~BIT(b);
                }
        }
}
EXPORT_SYMBOL(dev_change_proto_down_reason);

struct bpf_xdp_link {
        struct bpf_link link;
        struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
        int flags;
};

static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
{
        if (flags & XDP_FLAGS_HW_MODE)
                return XDP_MODE_HW;
        if (flags & XDP_FLAGS_DRV_MODE)
                return XDP_MODE_DRV;
        return XDP_MODE_SKB;
}
[...]

Another small one due to commits 4f010246b408 ("net/bpfilter: Initialize pos
in __bpfilter_process_sockopt") from net-next and a4fa458950b4 ("bpfilter:
Initialize pos variable") from bpf-next tree. We keep just the latter, meaning
one small fixup in net/bpfilter/bpfilter_kern.c. Thus, remove the first pos = 0
initialization as follows:

static int bpfilter_send_req(struct mbox_request *req)
{
        struct mbox_reply reply;
        loff_t pos;
        ssize_t n;

        if (!bpfilter_ops.info.tgid)
                return -EFAULT;
        pos = 0;
        n = kernel_write(bpfilter_ops.info.pipe_to_umh, req, sizeof(*req),
                           &pos);
[...]
}

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Arnd Bergmann, Björn Töpel, Daniel 
Borkmann, Jiri Olsa, John Fastabend, kernel test robot, Kuniyuki 
Iwashima, Paul Chaignon, Quentin Monnet, Randy Dunlap, Song Liu, Tobias 
Klauser, William Tu, Yonghong Song

----------------------------------------------------------------

The following changes since commit a57066b1a01977a646145f4ce8dfb4538b08368a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-07-25 17:49:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 21594c44083c375697d418729c4b2e4522cf9f70:

  bpf: Allow to specify ifindex for skb in bpf_prog_test_run_skb (2020-08-03 23:32:23 +0200)

----------------------------------------------------------------
Alexei Starovoitov (6):
      bpf: Add bpf_prog iterator
      Merge branch 'bpf_iter-for-map-elems'
      Merge branch 'fix-bpf_get_stack-with-PEBS'
      Merge branch 'shared-cgroup-storage'
      Merge branch 'bpf_link-XDP'
      Merge branch 'link_detach'

Andrii Nakryiko (25):
      tools/bpftool: Strip BPF .o files before skeleton generation
      bpf: Make bpf_link API available indepently of CONFIG_BPF_SYSCALL
      bpf, xdp: Maintain info on attached XDP BPF programs in net_device
      bpf, xdp: Extract common XDP program attachment logic
      bpf, xdp: Add bpf_link-based XDP attachment API
      bpf, xdp: Implement LINK_UPDATE for BPF XDP link
      bpf: Implement BPF XDP link-specific introspection APIs
      libbpf: Add support for BPF XDP link
      selftests/bpf: Add BPF XDP link selftests
      bpf, xdp: Remove XDP_QUERY_PROG and XDP_QUERY_PROG_HW XDP commands
      bpf: Fix bpf_ringbuf_output() signature to return long
      selftests/bpf: Add new bpf_iter context structs to fix build on old kernels
      bpf: Fix build without CONFIG_NET when using BPF XDP link
      selftests/bpf: Don't destroy failed link
      libbpf: Make destructors more robust by handling ERR_PTR(err) cases
      bpf: Add support for forced LINK_DETACH command
      libbpf: Add bpf_link detach APIs
      selftests/bpf: Add link detach tests for cgroup, netns, and xdp bpf_links
      tools/bpftool: Add `link detach` subcommand
      tools/bpftool: Add documentation and bash-completion for `link detach`
      selftests/bpf: Fix spurious test failures in core_retro selftest
      tools, build: Propagate build failures from tools/build/Makefile.build
      libbpf: Add btf__parse_raw() and generic btf__parse() APIs
      tools/bpftool: Use libbpf's btf__parse() API for parsing BTF from file
      tools/resolve_btfids: Use libbpf's btf__parse() API

Colin Ian King (1):
      bpf: Fix swapped arguments in calls to check_buffer_access

Daniel Borkmann (1):
      Merge branch 'bpf-libbpf-btf-parsing'

Dmitry Yakunin (2):
      bpf: Setup socket family and addresses in bpf_prog_test_run_skb
      bpf: Allow to specify ifindex for skb in bpf_prog_test_run_skb

Hangbin Liu (1):
      selftests/bpf: Add xdpdrv mode for test_xdp_redirect

Jakub Sitnicki (4):
      udp: Don't discard reuseport selection when group has connections
      selftests/bpf: Test BPF socket lookup and reuseport with connections
      selftests/bpf: Omit nodad flag when adding addresses to loopback
      udp, bpf: Ignore connections in reuseport group after BPF sk lookup

Jean-Philippe Brucker (1):
      bpf, arm64: Add BPF exception tables

Jerry Crunchtime (1):
      libbpf: Fix register in PT_REGS MIPS macros

John Fastabend (2):
      bpf, selftests: use :: 1 for localhost in tcp_server.py
      bpf, selftests: Use single cgroup helpers for both test_sockmap/progs

Peilin Ye (1):
      xdp: Prevent kernel-infoleak in xsk_getsockopt()

Quentin Monnet (2):
      tools, bpftool: Skip type probe if name is not found
      tools, bpftool: Add LSM type to array of prog names

Song Liu (6):
      bpf: Separate bpf_get_[stack|stackid] for perf events BPF
      bpf: Fail PERF_EVENT_IOC_SET_BPF when bpf_get_[stack|stackid] cannot work
      libbpf: Print hint when PERF_EVENT_IOC_SET_BPF returns -EPROTO
      selftests/bpf: Add callchain_stackid
      selftests/bpf: Add get_stackid_cannot_attach
      bpf: Fix build on architectures with special bpf_user_pt_regs_t

Stanislav Fomichev (2):
      bpf: Expose socket storage to BPF_PROG_TYPE_CGROUP_SOCK
      selftests/bpf: Verify socket storage in cgroup/sock_{create, release}

Tianjia Zhang (1):
      tools, bpftool: Fix wrong return value in do_dump()

Tiezhu Yang (1):
      Documentation/bpf: Use valid and new links in index.rst

YiFei Zhu (6):
      selftests/bpf: Add test for CGROUP_STORAGE map on multiple attaches
      selftests/bpf: Test CGROUP_STORAGE map can't be used by multiple progs
      bpf: Make cgroup storages shared between programs on the same cgroup
      selftests/bpf: Test CGROUP_STORAGE behavior on shared egress + ingress
      Documentation/bpf: Document CGROUP_STORAGE map type
      bpf/local_storage: Fix build without CONFIG_CGROUP

Yonghong Song (16):
      bpf: Refactor bpf_iter_reg to have separate seq_info member
      bpf: Refactor to provide aux info to bpf_iter_init_seq_priv_t
      bpf: Support readonly/readwrite buffers in verifier
      bpf: Fix pos computation for bpf_iter seq_ops->start()
      bpf: Implement bpf iterator for map elements
      bpf: Implement bpf iterator for hash maps
      bpf: Implement bpf iterator for array maps
      bpf: Implement bpf iterator for sock local storage map
      tools/libbpf: Add support for bpf map element iterator
      tools/bpftool: Add bpftool support for bpf map element iterator
      selftests/bpf: Add test for bpf hash map iterators
      selftests/bpf: Add test for bpf array map iterators
      selftests/bpf: Add a test for bpf sk_storage_map iterator
      selftests/bpf: Add a test for out of bound rdonly buf access
      bpf: Add missing newline characters in verifier error messages
      selftests/bpf: Test bpf_iter buffer access with negative offset

 Documentation/bpf/index.rst                        |  21 +-
 Documentation/bpf/map_cgroup_storage.rst           | 169 +++++++
 Documentation/networking/filter.rst                |   2 +
 arch/arm64/include/asm/extable.h                   |  12 +
 arch/arm64/mm/extable.c                            |  12 +-
 arch/arm64/net/bpf_jit_comp.c                      |  93 +++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   6 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   4 -
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   3 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   5 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   3 -
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   6 -
 drivers/net/ethernet/marvell/mvneta.c              |   5 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   3 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  24 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 -
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   4 -
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   3 -
 drivers/net/ethernet/sfc/efx.c                     |   5 -
 drivers/net/ethernet/socionext/netsec.c            |   3 -
 drivers/net/ethernet/ti/cpsw_priv.c                |   3 -
 drivers/net/hyperv/netvsc_bpf.c                    |  21 +-
 drivers/net/netdevsim/bpf.c                        |   4 -
 drivers/net/netdevsim/netdevsim.h                  |   2 +-
 drivers/net/tun.c                                  |  15 -
 drivers/net/veth.c                                 |  15 -
 drivers/net/virtio_net.c                           |  17 -
 drivers/net/xen-netfront.c                         |  21 -
 fs/proc/proc_net.c                                 |   2 +-
 include/linux/bpf-cgroup.h                         |  12 +-
 include/linux/bpf.h                                | 127 +++--
 include/linux/filter.h                             |   3 +-
 include/linux/netdevice.h                          |  29 +-
 include/linux/proc_fs.h                            |   3 +-
 include/net/xdp.h                                  |   2 -
 include/uapi/linux/bpf.h                           |  24 +-
 kernel/bpf/Makefile                                |   2 +-
 kernel/bpf/arraymap.c                              | 138 ++++++
 kernel/bpf/bpf_iter.c                              |  85 +++-
 kernel/bpf/btf.c                                   |  13 +
 kernel/bpf/cgroup.c                                |  82 ++--
 kernel/bpf/core.c                                  |  12 -
 kernel/bpf/hashtab.c                               | 194 ++++++++
 kernel/bpf/local_storage.c                         | 216 +++++----
 kernel/bpf/map_iter.c                              |  78 ++-
 kernel/bpf/net_namespace.c                         |   8 +
 kernel/bpf/prog_iter.c                             | 107 ++++
 kernel/bpf/stackmap.c                              | 183 ++++++-
 kernel/bpf/syscall.c                               |  52 ++
 kernel/bpf/task_iter.c                             |  24 +-
 kernel/bpf/verifier.c                              |  96 +++-
 kernel/events/core.c                               |  18 +
 kernel/trace/bpf_trace.c                           |   4 +-
 net/bpf/test_run.c                                 |  43 +-
 net/core/bpf_sk_storage.c                          | 216 +++++++++
 net/core/dev.c                                     | 539 ++++++++++++++++-----
 net/core/filter.c                                  |   3 +
 net/core/rtnetlink.c                               |   5 +-
 net/core/xdp.c                                     |   9 -
 net/ipv4/tcp_ipv4.c                                |  12 +-
 net/ipv4/udp.c                                     |  14 +-
 net/ipv6/route.c                                   |   8 +-
 net/ipv6/udp.c                                     |   5 +-
 net/netlink/af_netlink.c                           |   8 +-
 net/xdp/xsk.c                                      |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |  18 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   8 +
 tools/bpf/bpftool/Makefile                         |   3 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  22 +-
 tools/bpf/bpftool/btf.c                            |  56 +--
 tools/bpf/bpftool/feature.c                        |   8 +
 tools/bpf/bpftool/iter.c                           |  33 +-
 tools/bpf/bpftool/link.c                           |  37 +-
 tools/bpf/bpftool/prog.c                           |   1 +
 tools/bpf/resolve_btfids/.gitignore                |   4 +
 tools/bpf/resolve_btfids/main.c                    |  58 +--
 tools/build/Build.include                          |   3 +-
 tools/include/uapi/linux/bpf.h                     |  24 +-
 tools/lib/bpf/bpf.c                                |  11 +
 tools/lib/bpf/bpf.h                                |   5 +-
 tools/lib/bpf/bpf_tracing.h                        |   4 +-
 tools/lib/bpf/btf.c                                | 118 +++--
 tools/lib/bpf/btf.h                                |   5 +-
 tools/lib/bpf/btf_dump.c                           |   2 +-
 tools/lib/bpf/libbpf.c                             |  36 +-
 tools/lib/bpf/libbpf.h                             |   6 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |  23 +
 tools/testing/selftests/bpf/cgroup_helpers.h       |   1 +
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |  14 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 455 +++++++++++++++++
 .../selftests/bpf/prog_tests/cg_storage_multi.c    | 417 ++++++++++++++++
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |  20 +-
 .../testing/selftests/bpf/prog_tests/core_retro.c  |   8 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |  91 ++++
 .../selftests/bpf/prog_tests/perf_event_stackmap.c | 116 +++++
 .../selftests/bpf/prog_tests/section_names.c       |   2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 109 +++--
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   5 +
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  | 151 ++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h       |  18 +
 .../selftests/bpf/progs/bpf_iter_bpf_array_map.c   |  40 ++
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    | 100 ++++
 .../bpf/progs/bpf_iter_bpf_percpu_array_map.c      |  46 ++
 .../bpf/progs/bpf_iter_bpf_percpu_hash_map.c       |  50 ++
 .../bpf/progs/bpf_iter_bpf_sk_storage_map.c        |  34 ++
 .../selftests/bpf/progs/bpf_iter_test_kern5.c      |  35 ++
 .../selftests/bpf/progs/bpf_iter_test_kern6.c      |  21 +
 .../testing/selftests/bpf/progs/cg_storage_multi.h |  13 +
 .../bpf/progs/cg_storage_multi_egress_only.c       |  33 ++
 .../bpf/progs/cg_storage_multi_isolated.c          |  57 +++
 .../selftests/bpf/progs/cg_storage_multi_shared.c  |  57 +++
 .../selftests/bpf/progs/perf_event_stackmap.c      |  59 +++
 .../testing/selftests/bpf/progs/test_core_retro.c  |  13 +
 tools/testing/selftests/bpf/progs/test_xdp_link.c  |  12 +
 tools/testing/selftests/bpf/progs/udp_limit.c      |  19 +
 tools/testing/selftests/bpf/tcp_client.py          |   2 +-
 tools/testing/selftests/bpf/tcp_server.py          |   2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |  17 +-
 tools/testing/selftests/bpf/test_dev_cgroup.c      |  15 +-
 tools/testing/selftests/bpf/test_netcnt.c          |  21 +-
 .../selftests/bpf/test_skb_cgroup_id_user.c        |   8 +-
 tools/testing/selftests/bpf/test_sock.c            |   8 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |   8 +-
 tools/testing/selftests/bpf/test_sock_fields.c     |  14 +-
 tools/testing/selftests/bpf/test_socket_cookie.c   |   8 +-
 tools/testing/selftests/bpf/test_sockmap.c         |  18 +-
 tools/testing/selftests/bpf/test_sysctl.c          |   8 +-
 tools/testing/selftests/bpf/test_tcpbpf_user.c     |   8 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   8 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |  84 ++--
 tools/testing/selftests/bpf/testing_helpers.c      |  14 +
 tools/testing/selftests/bpf/testing_helpers.h      |   3 +
 135 files changed, 4603 insertions(+), 1013 deletions(-)
 create mode 100644 Documentation/bpf/map_cgroup_storage.rst
 create mode 100644 kernel/bpf/prog_iter.c
 create mode 100644 tools/bpf/resolve_btfids/.gitignore
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_event_stackmap.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_array_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu_array_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu_hash_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern5.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern6.c
 create mode 100644 tools/testing/selftests/bpf/progs/cg_storage_multi.h
 create mode 100644 tools/testing/selftests/bpf/progs/cg_storage_multi_egress_only.c
 create mode 100644 tools/testing/selftests/bpf/progs/cg_storage_multi_isolated.c
 create mode 100644 tools/testing/selftests/bpf/progs/cg_storage_multi_shared.c
 create mode 100644 tools/testing/selftests/bpf/progs/perf_event_stackmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_link.c
