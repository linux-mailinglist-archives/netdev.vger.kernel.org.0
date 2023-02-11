Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830C4692BE2
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBKAUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBKAUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:20:45 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F48575F62;
        Fri, 10 Feb 2023 16:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=KvUJHgbRsb6y62LNBg5n+6c0uFkw3UNQLA8n6wPEjw4=; b=kGns/kjPKCVPoGvDt44GcEwq9W
        1MJtOqqkTnOKzwhFNqIZ+yndq//WQ+hPAIaTdFoy7gx+F067N59H2qRVuMLbGKQCZtFhamIyaAo9+
        hHWCmJh3TlLLI+6iFMBsi5Ct49MKOjoVmh7WzLnYiDKA4JOc2drMbR/kwIIz3Ev18o7CbiYdBqVhu
        7vvHzP7kLan2kNtezXhMjvoIrtOBb5/paKYZDbtWR4rqHkuNKICSm8UlcbjUELcXSqBp4Q5/aEPBt
        9P1lddXAIVJudBZRfwtWmf/DDLRHvHqS0+ljGA4ByefJQkBhnTAOYbXKAk9gvYZMUe4GENKkSR311
        Zn3HQjRw==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pQdd8-0007mY-CV; Sat, 11 Feb 2023 01:20:38 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-02-11
Date:   Sat, 11 Feb 2023 01:20:37 +0100
Message-Id: <20230211002037.8489-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26808/Fri Feb 10 09:58:43 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 96 non-merge commits during the last 14 day(s) which contain
a total of 152 files changed, 4884 insertions(+), 962 deletions(-).

There is a minor conflict in drivers/net/ethernet/intel/ice/ice_main.c
between commit 5b246e533d01 ("ice: split probe into smaller functions")
from the net-next tree and commit 66c0e13ad236 ("drivers: net: turn on
XDP features") from the bpf-next tree. Remove the hunk given ice_cfg_netdev()
is otherwise there a 2nd time, and add XDP features to the existing
ice_cfg_netdev() one:

        [...]
        ice_set_netdev_features(netdev);
        netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
                               NETDEV_XDP_ACT_XSK_ZEROCOPY;
        ice_set_ops(netdev);
        [...]

Stephen's merge conflict mail:
https://lore.kernel.org/bpf/20230207101951.21a114fa@canb.auug.org.au/

The main changes are:

1) Add support for BPF trampoline on s390x which finally allows to remove many
   test cases from the BPF CI's DENYLIST.s390x, from Ilya Leoshkevich.

2) Add multi-buffer XDP support to ice driver, from Maciej Fijalkowski.

3) Add capability to export the XDP features supported by the NIC. Along with
   that, add a XDP compliance test tool, from Lorenzo Bianconi & Marek Majtyka.

4) Add __bpf_kfunc tag for marking kernel functions as kfuncs, from David Vernet.

5) Add a deep dive documentation about the verifier's register liveness tracking
   algorithm, from Eduard Zingerman.

6) Fix and follow-up cleanups for resolve_btfids to be compiled as a host program
   to avoid cross compile issues, from Jiri Olsa & Ian Rogers.

7) Batch of fixes to the BPF selftest for xdp_hw_metadata which resulted when testing
   on different NICs, from Jesper Dangaard Brouer.

8) Fix libbpf to better detect kernel version code on Debian, from Hao Xiang.

9) Extend libbpf to add an option for when the perf buffer should
   wake up, from Jon Doron.

10) Follow-up fix on xdp_metadata selftest to just consume on TX
    completion, from Stanislav Fomichev.

11) Extend the kfuncs.rst document with description on kfunc lifecycle & stability
    expectations, from David Vernet.

12) Fix bpftool prog profile to skip attaching to offline CPUs, from Tonghao Zhang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Lobakin, Alexei Starovoitov, Bagas Sanjaya, Cong Wang, David 
Vernet, Edward Cree, Gerhard Engleder, Ian Rogers, Jakub Kicinski, 
Jesper Dangaard Brouer, Jiri Olsa, Joanne Koong, John Fastabend, Martin 
KaFai Lau, Michael S. Tsirkin, Nathan Chancellor, Simon Horman, 
Stanislav Fomichev, Thorsten Leemhuis

----------------------------------------------------------------

The following changes since commit 70eb3911d80f548a76fb9a40c8a3fd93ac061a42:

  net: netlink: recommend policy range validation (2023-01-28 00:33:51 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 17bcd27a08a21397698edf143084d7c87ce17946:

  libbpf: Fix alen calculation in libbpf_nla_dump_errormsg() (2023-02-10 15:27:22 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'Support bpf trampoline for s390x'
      Merge branch ' docs/bpf: Add description of register liveness tracking algorithm'
      Merge branch 'xdp: introduce xdp-feature support'

Colin Ian King (1):
      selftests/bpf: Fix spelling mistake "detecion" -> "detection"

Daniel Borkmann (2):
      Merge branch 'xdp-ice-mbuf'
      Merge branch 'kfunc-annotation'

Dave Thaler (2):
      bpf, docs: Use consistent names for the same field
      bpf, docs: Add note about type convention

David Vernet (6):
      bpf: Build-time assert that cpumask offset is zero
      bpf: Add __bpf_kfunc tag for marking kernel functions as kfuncs
      bpf: Document usage of the new __bpf_kfunc macro
      bpf: Add __bpf_kfunc tag to all kfuncs
      selftests/bpf: Add testcase for static kfunc with unused arg
      bpf/docs: Document kfunc lifecycle / stability expectations

Eduard Zingerman (1):
      docs/bpf: Add description of register liveness tracking algorithm

Florian Lehner (1):
      bpf: fix typo in header for bpf_perf_prog_read_value

Hao Xiang (1):
      libbpf: Correctly set the kernel code version in Debian kernel.

Ian Rogers (1):
      tools/resolve_btfids: Tidy HOST_OVERRIDES

Ilya Leoshkevich (41):
      bpf: Use ARG_CONST_SIZE_OR_ZERO for 3rd argument of bpf_tcp_raw_gen_syncookie_ipv{4,6}()
      bpf: Change BPF_MAX_TRAMP_LINKS to enum
      selftests/bpf: Query BPF_MAX_TRAMP_LINKS using BTF
      selftests/bpf: Fix liburandom_read.so linker error
      selftests/bpf: Fix symlink creation error
      selftests/bpf: Fix kfree_skb on s390x
      selftests/bpf: Set errno when urand_spawn() fails
      selftests/bpf: Fix decap_sanity_ns cleanup
      selftests/bpf: Fix verify_pkcs7_sig on s390x
      selftests/bpf: Fix xdp_do_redirect on s390x
      selftests/bpf: Fix cgrp_local_storage on s390x
      selftests/bpf: Check stack_mprotect() return value
      selftests/bpf: Increase SIZEOF_BPF_LOCAL_STORAGE_ELEM on s390x
      selftests/bpf: Add a sign-extension test for kfuncs
      selftests/bpf: Fix test_lsm on s390x
      selftests/bpf: Fix test_xdp_adjust_tail_grow2 on s390x
      selftests/bpf: Fix vmlinux test on s390x
      selftests/bpf: Fix xdp_synproxy/tc on s390x
      selftests/bpf: Fix profiler on s390x
      libbpf: Simplify barrier_var()
      libbpf: Fix unbounded memory access in bpf_usdt_arg()
      libbpf: Fix BPF_PROBE_READ{_STR}_INTO() on s390x
      bpf: iterators: Split iterators.lskel.h into little- and big- endian versions
      bpf: btf: Add BTF_FMODEL_SIGNED_ARG flag
      s390/bpf: Fix a typo in a comment
      selftests/bpf: Fix sk_assign on s390x
      s390/bpf: Add expoline to tail calls
      s390/bpf: Implement bpf_arch_text_poke()
      s390/bpf: Implement arch_prepare_bpf_trampoline()
      s390/bpf: Implement bpf_jit_supports_subprog_tailcalls()
      s390/bpf: Implement bpf_jit_supports_kfunc_call()
      selftests/bpf: Fix s390x vmlinux path
      selftests/bpf: Trim DENYLIST.s390x
      selftests/bpf: Initialize tc in xdp_synproxy
      selftests/bpf: Quote host tools
      tools: runqslower: Add EXTRA_CFLAGS and EXTRA_LDFLAGS support
      selftests/bpf: Split SAN_CFLAGS and SAN_LDFLAGS
      selftests/bpf: Forward SAN_CFLAGS and SAN_LDFLAGS to runqslower and libbpf
      selftests/bpf: Attach to fopen()/fclose() in uprobe_autoattach
      selftests/bpf: Attach to fopen()/fclose() in attach_probe
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()

Jakub Kicinski (1):
      netdev-genl: create a simple family for netdev stuff

Jesper Dangaard Brouer (5):
      selftests/bpf: Fix unmap bug in prog_tests/xdp_metadata.c
      selftests/bpf: xdp_hw_metadata clear metadata when -EOPNOTSUPP
      selftests/bpf: xdp_hw_metadata cleanup cause segfault
      selftests/bpf: xdp_hw_metadata correct status value in error(3)
      selftests/bpf: xdp_hw_metadata use strncpy for ifname

Jiri Olsa (2):
      tools/resolve_btfids: Compile resolve_btfids as host program
      tools/resolve_btfids: Pass HOSTCFLAGS as EXTRA_CFLAGS to prepare targets

Jon Doron (1):
      libbpf: Add sample_period to creation options

Lorenzo Bianconi (9):
      libbpf: add the capability to specify netlink proto in libbpf_netlink_send_recv
      libbpf: add API to get XDP/XSK supported features
      bpf: devmap: check XDP features in __xdp_enqueue routine
      selftests/bpf: add test for bpf_xdp_query xdp-features support
      selftests/bpf: introduce XDP compliance test tool
      libbpf: Always use libbpf_err to return an error in bpf_xdp_query()
      virtio_net: Update xdp_features with xdp multi-buff
      net, xdp: Add missing xdp_features description
      sfc: move xdp_features configuration in efx_pci_probe_post_io()

Maciej Fijalkowski (13):
      ice: Prepare legacy-rx for upcoming XDP multi-buffer support
      ice: Add xdp_buff to ice_rx_ring struct
      ice: Store page count inside ice_rx_buf
      ice: Pull out next_to_clean bump out of ice_put_rx_buf()
      ice: Inline eop check
      ice: Centrallize Rx buffer recycling
      ice: Use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
      ice: Do not call ice_finalize_xdp_rx() unnecessarily
      ice: Use xdp->frame_sz instead of recalculating truesize
      ice: Add support for XDP multi-buffer on Rx side
      ice: Add support for XDP multi-buffer on Tx side
      ice: Remove next_{dd,rs} fields from ice_tx_ring
      ice: xsk: Do not convert to buff to frame for XDP_TX

Marek Majtyka (2):
      drivers: net: turn on XDP features
      xsk: add usage of XDP features flags

Randy Dunlap (1):
      Documentation: bpf: correct spelling

Rong Tao (1):
      samples/bpf: Add openat2() enter/exit tracepoint to syscall_tp sample

Stanislav Fomichev (1):
      selftests/bpf: Don't refill on completion in xdp_metadata

Tiezhu Yang (2):
      tools/bpf: Use tab instead of white spaces to sync bpf.h
      selftests/bpf: Use semicolon instead of comma in test_verifier.c

Tobias Klauser (1):
      bpf: Drop always true do_idr_lock parameter to bpf_map_free_id

Toke Høiland-Jørgensen (1):
      bpf/docs: Update design QA to be consistent with kfunc lifecycle docs

Tonghao Zhang (1):
      bpftool: profile online CPUs instead of possible

Ye Xingchen (1):
      selftests/bpf: Remove duplicate include header in xdp_hw_metadata

 Documentation/bpf/bpf_design_QA.rst                |  25 +-
 Documentation/bpf/instruction-set.rst              | 120 ++--
 Documentation/bpf/kfuncs.rst                       | 145 ++++-
 .../bpf/libbpf/libbpf_naming_convention.rst        |   6 +-
 Documentation/bpf/map_xskmap.rst                   |   2 +-
 Documentation/bpf/ringbuf.rst                      |   4 +-
 Documentation/bpf/verifier.rst                     | 297 ++++++++-
 Documentation/conf.py                              |   3 +
 Documentation/netlink/specs/netdev.yaml            | 100 +++
 arch/s390/net/bpf_jit_comp.c                       | 715 +++++++++++++++++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   4 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   2 +
 drivers/net/ethernet/engleder/tsnep_main.c         |   4 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   4 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   3 +
 drivers/net/ethernet/fungible/funeth/funeth_main.c |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  21 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  52 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          | 408 ++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  54 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      | 236 ++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |  75 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 192 +++---
 drivers/net/ethernet/intel/igb/igb_main.c          |   9 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/igc/igc_xdp.c           |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   1 +
 drivers/net/ethernet/marvell/mvneta.c              |   3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   4 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   6 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  11 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   2 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   5 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   3 +
 drivers/net/ethernet/sfc/efx.c                     |   4 +
 drivers/net/ethernet/sfc/siena/efx.c               |   4 +
 drivers/net/ethernet/socionext/netsec.c            |   3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/ethernet/ti/cpsw.c                     |   4 +
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +
 drivers/net/hyperv/netvsc_drv.c                    |   2 +
 drivers/net/netdevsim/netdev.c                     |   1 +
 drivers/net/tun.c                                  |   5 +
 drivers/net/veth.c                                 |   4 +
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/xen-netfront.c                         |   2 +
 include/linux/bpf.h                                |  14 +-
 include/linux/btf.h                                |  23 +-
 include/linux/netdevice.h                          |   4 +
 include/net/xdp.h                                  |  15 +
 include/uapi/linux/bpf.h                           |   2 +-
 include/uapi/linux/netdev.h                        |  59 ++
 kernel/bpf/btf.c                                   |  16 +-
 kernel/bpf/cpumask.c                               |  63 +-
 kernel/bpf/devmap.c                                |  16 +-
 kernel/bpf/helpers.c                               |  38 +-
 kernel/bpf/offload.c                               |   2 +-
 kernel/bpf/preload/bpf_preload_kern.c              |   6 +-
 kernel/bpf/preload/iterators/Makefile              |  12 +-
 kernel/bpf/preload/iterators/README                |   5 +-
 .../preload/iterators/iterators.lskel-big-endian.h | 419 ++++++++++++
 ...ors.lskel.h => iterators.lskel-little-endian.h} |   0
 kernel/bpf/syscall.c                               |  23 +-
 kernel/cgroup/rstat.c                              |   4 +-
 kernel/kexec_core.c                                |   3 +-
 kernel/trace/bpf_trace.c                           |   8 +-
 net/bpf/test_run.c                                 |  70 +-
 net/core/Makefile                                  |   3 +-
 net/core/dev.c                                     |   1 +
 net/core/filter.c                                  |  17 +-
 net/core/netdev-genl-gen.c                         |  48 ++
 net/core/netdev-genl-gen.h                         |  23 +
 net/core/netdev-genl.c                             | 179 ++++++
 net/core/xdp.c                                     |  23 +-
 net/ipv4/tcp_bbr.c                                 |  16 +-
 net/ipv4/tcp_cong.c                                |  10 +-
 net/ipv4/tcp_cubic.c                               |  12 +-
 net/ipv4/tcp_dctcp.c                               |  12 +-
 net/netfilter/nf_conntrack_bpf.c                   |  20 +-
 net/netfilter/nf_nat_bpf.c                         |   6 +-
 net/xdp/xsk_buff_pool.c                            |   7 +-
 net/xfrm/xfrm_interface_bpf.c                      |   7 +-
 samples/bpf/syscall_tp_kern.c                      |  14 +
 tools/bpf/bpftool/prog.c                           |  38 +-
 tools/bpf/resolve_btfids/Build                     |   4 +-
 tools/bpf/resolve_btfids/Makefile                  |  13 +-
 tools/bpf/runqslower/Makefile                      |   2 +
 tools/include/uapi/linux/bpf.h                     |   6 +-
 tools/include/uapi/linux/netdev.h                  |  59 ++
 tools/lib/bpf/bpf_core_read.h                      |   4 +-
 tools/lib/bpf/bpf_helpers.h                        |   2 +-
 tools/lib/bpf/libbpf.c                             |  46 +-
 tools/lib/bpf/libbpf.h                             |   7 +-
 tools/lib/bpf/libbpf_probes.c                      |  83 +++
 tools/lib/bpf/netlink.c                            | 118 +++-
 tools/lib/bpf/nlattr.c                             |   2 +-
 tools/lib/bpf/nlattr.h                             |  12 +
 tools/lib/bpf/usdt.bpf.h                           |   5 +-
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |  69 --
 tools/testing/selftests/bpf/Makefile               |  33 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   2 +-
 tools/testing/selftests/bpf/netcnt_common.h        |   6 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  10 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |   6 +-
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |   2 +-
 .../selftests/bpf/prog_tests/decap_sanity.c        |   2 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |  22 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   2 +
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |  25 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |   3 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |  16 +-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |  14 +-
 tools/testing/selftests/bpf/prog_tests/usdt.c      |   1 +
 .../selftests/bpf/prog_tests/verify_pkcs7_sig.c    |   3 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   7 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |  31 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   8 +
 .../selftests/bpf/prog_tests/xdp_metadata.c        |   7 +-
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |  29 +
 tools/testing/selftests/bpf/progs/lsm.c            |   7 +-
 tools/testing/selftests/bpf/progs/profiler.inc.h   |  62 +-
 .../selftests/bpf/progs/test_attach_probe.c        |  11 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |  11 +
 .../selftests/bpf/progs/test_sk_assign_libbpf.c    |   3 +
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |  16 +-
 .../selftests/bpf/progs/test_verify_pkcs7_sig.c    |  12 +-
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |   4 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |   8 +-
 tools/testing/selftests/bpf/progs/xdp_features.c   | 269 ++++++++
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   6 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c        |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |  38 ++
 tools/testing/selftests/bpf/test_progs.h           |   2 +
 tools/testing/selftests/bpf/test_verifier.c        |   4 +-
 tools/testing/selftests/bpf/test_xdp_features.sh   | 107 +++
 tools/testing/selftests/bpf/vmtest.sh              |   2 +-
 tools/testing/selftests/bpf/xdp_features.c         | 699 ++++++++++++++++++++
 tools/testing/selftests/bpf/xdp_features.h         |  20 +
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |  35 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |   1 +
 152 files changed, 4884 insertions(+), 962 deletions(-)
 create mode 100644 Documentation/netlink/specs/netdev.yaml
 create mode 100644 include/uapi/linux/netdev.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.lskel-big-endian.h
 rename kernel/bpf/preload/iterators/{iterators.lskel.h => iterators.lskel-little-endian.h} (100%)
 create mode 100644 net/core/netdev-genl-gen.c
 create mode 100644 net/core/netdev-genl-gen.h
 create mode 100644 net/core/netdev-genl.c
 create mode 100644 tools/include/uapi/linux/netdev.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_features.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c
 create mode 100644 tools/testing/selftests/bpf/xdp_features.h
