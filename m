Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC0D55EE51
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiF1TvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiF1Tuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D570523BD9;
        Tue, 28 Jun 2022 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445757; x=1687981757;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xomyw9XXjXPC+yIudFgA3BYxFaSNAAIjzdcntCkl8mQ=;
  b=LgX8BzhHMafidNw8qU9f5A9LAJ7o7J2yAsIN+Od8aezUFqUBE74Ow6Bg
   FvQQyWwVufigfQEw4ZxNKlxsVK4vPSl+Thd1E4EUSTI0EyYLPPdS0ON/B
   OQTcY65zMalamCAbnAu8tezvHcFsvKGn2S5C+3cETPM+ZitEanUL0YYKe
   n8DkZtCgiPhJHjpFvWBxAaIuIjDjlV6BBmFIAxHyl6hUCfcNMIixt4GeD
   8tGS/BHRYUcvsqC7pNAFewe4/6ZhiPagVItsNScwI1WE1IfKEORf/v9He
   TvH3Sd3Hf4+n9hSN9TfQ/8SiG/ji8JnCtNPAqCewu+93mgnwSpHbunmKY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523113"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523113"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767287992"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:48:55 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr90022013;
        Tue, 28 Jun 2022 20:48:53 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce and use Generic Hints/metadata
Date:   Tue, 28 Jun 2022 21:47:20 +0200
Message-Id: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC is to give the whole picture. It will most likely be split
onto several series, maybe even merge cycles. See the "table of
contents" below.

The series adds ability to pass different frame
details/parameters/parameters used by most of NICs and the kernel
stack (in skbs), not essential, but highly wanted, such as:

* checksum value, status (Rx) or command (Tx);
* hash value and type/level (Rx);
* queue number (Rx);
* timestamps;
* and so on.

As XDP structures used to represent frames are as small as possible
and must stay like that, it is done by using the already existing
concept of metadata, i.e. some space right before a frame where BPF
programs can put arbitrary data.

Now, a NIC driver, or even a SmartNIC itself, can put those params
there in a well-defined format. The format is fixed, but can be of
several different types represented by structures, which definitions
are available to the kernel, BPF programs and the userland.
It is fixed due to it being almost a UAPI, and the exact format can
be determined by reading the last 10 bytes of metadata. They contain
a 2-byte magic ID to not confuse it with a non-compatible meta and
a 8-byte combined BTF ID + type ID: the ID of the BTF where this
structure is defined and the ID of that definition inside that BTF.
Users can obtain BTF IDs by structure types using helpers available
in the kernel, BPF (written by the CO-RE/verifier) and the userland
(libbpf -> kernel call) and then rely on those ID when reading data
to make sure whether they support it and what to do with it.
Why separate magic and ID? The idea is to make different formats
always contain the basic/"generic" structure embedded at the end.
This way we can still benefit in purely generic consumers (like
cpumap) while providing some "extra" data to those who support it.

The enablement of this feature is controlled on attaching/replacing
XDP program on an interface with two new parameters: that combined
BTF+type ID and metadata threshold.
The threshold specifies the minimum frame size which a driver (or
NIC) should start composing metadata from. It is introduced instead
of just false/true flag due to that often it's not worth it to spend
cycles to fetch all that data for such small frames: let's say, it
can be even faster to just calculate checksums for them on CPU
rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
15 Mpps on 64 byte frames with enabled metadata, threshold can help
mitigate that.

The RFC can be divided into 8 parts:

01-04: BTF ID hacking: here Larysa provides BPF programs with not
       only type ID, but the ID of the BTF as well by using the
       unused upper 32 bits.
05-10: this provides in-kernel mechanisms for taking ID and
       threshold from the userspace and passing it to the drivers.
11-18: provides libbpf API to be able to specify those params from
       the userspace, plus some small selftest to verify that both
       the kernel and the userspace parts work.
19-29: here the actual structure is defined, then the in-kernel
       helpers and finally here comes the first consumer: function
       used to convert &xdp_frame to &sk_buff now will be trying
       to parse metadata. The affected users are cpumap and veth.
30-36: here I try to benefit from the metadata in cpumap even more
       by switching it to GRO. Now that we have checksums from NIC
       available... but even with no meta it gives some fair
       improvements.
37-43: enabling building generic metadata on Generic/skb path. Since
       skbs already have all those fields, it's not a problem to do
       this in here, plus allows to benefit from it on interfaces
       not supporting meta yet.
44-47: ice driver part, including enabling prog hot-swap;
48-52: adds a complex selftest to verify everything works. Can be
       used as a sample as well, showing how to work with metadata
       in BPF programs and how to configure it from the userspace.

Please refer to the actual commit messages where some precise
implementation details might be explained.
Nearly 20 of 52 are various cleanups and prereqs, as usually.

Perf figures were taken on cpumap redirect from the ice interface
(driver-side XDP), redirecting the traffic within the same node.

Frame size /   64/42  128/20  256/8  512/4  1024/2  1532/1
thread num

meta off       30022  31350   21993  12144  6374    3610
meta on        33059  28502   21503  12146  6380    3610
GRO meta off   30020  31822   21970  12145  6384    3610
GRO meta on    34736  28848   21566  12144  6381    3610

Yes, redirect between the nodes plays awfully with the metadata
composed by the driver:

meta off       21449  18078   16897  11820  6383    3610
meta on        16956  19004   14337  8228   5683    2822
GRO meta off   22539  19129   16304  11659  6381    3592
GRO meta on    17047  20366   15435  8878   5600    2753

Questions still open:

* the actual generic structure: it must have all the fields used
  oftenly and by the majority of NICs. It can always be expanded
  later on (note that the structure grows to the left), but the
  less often UAPI is modified, the better (less compat pain);
* ability to specify the exact fields to fill by the driver, e.g.
  flags bitmap passed from the userspace. In theory it can be more
  optimal to not spend cycles on data we don't need, but at the
  same time increases the complexity of the whole concept (e.g. it
  will be more problematic to unify drivers' routines for collecting
  data from descriptors to metadata and to skbs);
* there was an idea to be able to specify from the userspace the
  desired cacheline offset, so that [the wanted fields of] metadata
  and the packet headers would lay in the same CL. Can't be
  implemented in Generic/skb XDP and ice has some troubles with it
  too;
* lacks AF_XDP/XSk perf numbers and different other scenarios in
  general, is the current implementation optimal for them?
* metadata threshold and everything else present in this
  implementation.

The RFC is also available on my open GitHub[0].

Merry and long review and discussion, enjoy!

[0] https://github.com/alobakin/linux/tree/xdp_hints

Alexander Lobakin (46):
  libbpf: add function to get the pair BTF ID + type ID for a given type
  net, xdp: decouple XDP code from the core networking code
  bpf: pass a pointer to union bpf_attr to bpf_link_ops::update_prog()
  net, xdp: remove redundant arguments from dev_xdp_{at,de}tach_link()
  net, xdp: factor out XDP install arguments to a separate structure
  net, xdp: add ability to specify BTF ID for XDP metadata
  net, xdp: add ability to specify frame size threshold for XDP metadata
  libbpf: factor out __bpf_set_link_xdp_fd_replace() args into a struct
  libbpf: add ability to set the BTF/type ID on setting XDP prog
  libbpf: add ability to set the meta threshold on setting XDP prog
  libbpf: pass &bpf_link_create_opts directly to
    bpf_program__attach_fd()
  libbpf: add bpf_program__attach_xdp_opts()
  selftests/bpf: expand xdp_link to check that setting meta opts works
  samples/bpf: pass a struct to sample_install_xdp()
  samples/bpf: add ability to specify metadata threshold
  stddef: make __struct_group() UAPI C++-friendly
  net, xdp: move XDP metadata helpers into new xdp_meta.h
  net, xdp: allow metadata > 32
  net, skbuff: add ability to skip skb metadata comparison
  net, skbuff: constify the @skb argument of skb_hwtstamps()
  net, xdp: add basic generic metadata accessors
  bpf, btf: add a pair of function to work with the BTF ID + type ID
    pair
  net, xdp: add &sk_buff <-> &xdp_meta_generic converters
  net, xdp: prefetch data a bit when building an skb from an &xdp_frame
  net, xdp: try to fill skb fields when converting from an &xdp_frame
  net, gro: decouple GRO from the NAPI layer
  net, gro: expose some GRO API to use outside of NAPI
  bpf, cpumap: switch to GRO from netif_receive_skb_list()
  bpf, cpumap: add option to set a timeout for deferred flush
  samples/bpf: add 'timeout' option to xdp_redirect_cpu
  net, skbuff: introduce napi_skb_cache_get_bulk()
  bpf, cpumap: switch to napi_skb_cache_get_bulk()
  rcupdate: fix access helpers for incomplete struct pointers on GCC <
    10
  net, xdp: remove unused xdp_attachment_info::flags
  net, xdp: make &xdp_attachment_info a bit more useful in drivers
  net, xdp: add an RCU version of xdp_attachment_setup()
  net, xdp: replace net_device::xdp_prog pointer with
    &xdp_attachment_info
  net, xdp: shortcut skb->dev in bpf_prog_run_generic_xdp()
  net, xdp: build XDP generic metadata on Generic (skb) XDP path
  net, ice: allow XDP prog hot-swapping
  net, ice: consolidate all skb fields processing
  net, ice: use an onstack &xdp_meta_generic_rx to store HW frame info
  net, ice: build XDP generic metadata
  libbpf: compress Endianness ops with a macro
  selftests/bpf: fix using test_xdp_meta BPF prog via skeleton infra
  selftests/bpf: add XDP Generic Hints selftest

Larysa Zaremba (5):
  libbpf: factor out BTF loading from load_module_btfs()
  libbpf: try to load vmlinux BTF from the kernel first
  libbpf: patch module BTF ID into BPF insns
  libbpf: add LE <--> CPU conversion helpers
  libbpf: introduce a couple memory access helpers

Michal Swiatkowski (1):
  bpf, xdp: declare generic XDP metadata structure

 MAINTAINERS                                   |   5 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |   1 +
 drivers/net/ethernet/cortina/gemini.c         |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  16 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  79 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  19 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  17 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  51 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 154 +--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  88 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  26 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |   1 +
 drivers/net/tun.c                             |   2 +-
 include/linux/bpf.h                           |   3 +-
 include/linux/btf.h                           |  13 +
 include/linux/filter.h                        |   2 +
 include/linux/netdevice.h                     |  41 +-
 include/linux/rcupdate.h                      |  37 +-
 include/linux/skbuff.h                        |  35 +-
 include/net/gro.h                             |  53 +-
 include/net/xdp.h                             |  34 +-
 include/net/xdp_meta.h                        | 398 ++++++++
 include/uapi/linux/bpf.h                      | 194 ++++
 include/uapi/linux/if_link.h                  |   2 +
 include/uapi/linux/stddef.h                   |  12 +-
 kernel/bpf/bpf_iter.c                         |   1 +
 kernel/bpf/btf.c                              | 133 ++-
 kernel/bpf/cgroup.c                           |   4 +-
 kernel/bpf/cpumap.c                           |  80 +-
 kernel/bpf/net_namespace.c                    |   1 +
 kernel/bpf/syscall.c                          |   4 +-
 net/bpf/Makefile                              |   5 +-
 net/{core/xdp.c => bpf/core.c}                | 214 +++-
 net/bpf/dev.c                                 | 871 +++++++++++++++++
 net/bpf/prog_ops.c                            | 912 ++++++++++++++++++
 net/bpf/test_run.c                            |   2 +-
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                | 869 +----------------
 net/core/dev.h                                |   4 -
 net/core/filter.c                             | 883 +----------------
 net/core/gro.c                                | 120 ++-
 net/core/rtnetlink.c                          |  24 +-
 net/core/skbuff.c                             |  44 +
 net/packet/af_packet.c                        |   8 +-
 net/xdp/xsk.c                                 |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c           |  44 +-
 samples/bpf/xdp_redirect_map_multi_user.c     |  26 +-
 samples/bpf/xdp_redirect_map_user.c           |  22 +-
 samples/bpf/xdp_redirect_user.c               |  21 +-
 samples/bpf/xdp_router_ipv4_user.c            |  20 +-
 samples/bpf/xdp_sample_user.c                 |  38 +-
 samples/bpf/xdp_sample_user.h                 |  11 +-
 tools/include/uapi/linux/bpf.h                | 194 ++++
 tools/include/uapi/linux/if_link.h            |   2 +
 tools/include/uapi/linux/stddef.h             |  50 +
 tools/lib/bpf/bpf.c                           |  22 +
 tools/lib/bpf/bpf.h                           |  22 +-
 tools/lib/bpf/bpf_core_read.h                 |   3 +-
 tools/lib/bpf/bpf_endian.h                    |  56 +-
 tools/lib/bpf/bpf_helpers.h                   |  64 ++
 tools/lib/bpf/btf.c                           | 142 ++-
 tools/lib/bpf/libbpf.c                        | 201 +++-
 tools/lib/bpf/libbpf.h                        |  30 +-
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/libbpf_internal.h               |   7 +-
 tools/lib/bpf/netlink.c                       |  81 +-
 tools/lib/bpf/relo_core.c                     |   8 +-
 tools/lib/bpf/relo_core.h                     |   1 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/prog_tests/xdp_link.c       |  30 +-
 .../selftests/bpf/progs/test_xdp_meta.c       |  40 +-
 tools/testing/selftests/bpf/test_xdp_meta.c   | 294 ++++++
 tools/testing/selftests/bpf/test_xdp_meta.sh  |  59 +-
 77 files changed, 4758 insertions(+), 2212 deletions(-)
 create mode 100644 include/net/xdp_meta.h
 rename net/{core/xdp.c => bpf/core.c} (73%)
 create mode 100644 net/bpf/dev.c
 create mode 100644 net/bpf/prog_ops.c
 create mode 100644 tools/include/uapi/linux/stddef.h
 create mode 100644 tools/testing/selftests/bpf/test_xdp_meta.c

--
2.36.1
