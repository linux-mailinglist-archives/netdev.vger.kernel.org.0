Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E411B1678
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDTUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTUA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:00:59 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ABED20736;
        Mon, 20 Apr 2020 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587412858;
        bh=VwtiyJ0zNCBWzf7cHA4N+etHUpzKgU8t5aHVS5mYWsY=;
        h=From:To:Cc:Subject:Date:From;
        b=UvN2hFPqWYbyi9k4lqk0FMvIs70ERQ5dQqB6jLd8qWBobdBurnQzmmdjGFbpdEimx
         Se7V/axh2HtOUzMIfBvm9+IrLzUw2AMygUZPtgyiYjaOIFQhahaLKHgZJQogD5HPKN
         Qr+XLdh1qsR6dwOTXE26GPIW38EpxvFAjAfvl0WE=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 00/16] net: Add support for XDP in egress path
Date:   Mon, 20 Apr 2020 14:00:39 -0600
Message-Id: <20200420200055.49033-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This series adds support for XDP in the egress path by introducing
a new XDP attachment type, BPF_XDP_EGRESS, and adding a UAPI to
if_link.h for attaching the program to a netdevice and reporting
the program. bpf programs can be run on all packets in the Tx path -
skbs or redirected xdp frames. The intent is to emulate the current
RX path for XDP as much as possible to maintain consistency and
symmetry in the 2 paths with their APIs.

This is a missing primitive for XDP allowing solutions to build small,
targeted programs properly distributed in the networking path allowing,
for example, an egress firewall/ACL/traffic verification or packet
manipulation and encapping an entire ethernet frame whether it is
locally generated traffic, forwarded via the slow path (ie., full
stack processing) or xdp redirected frames.

Nothing about running a program in the Tx path requires driver specific
resources like the Rx path has. Thus, programs can be run in core
code and attached to the net_device struct similar to skb mode. The
existing XDP_FLAGS_*_MODE are not relevant at the moment, so none can
be set in the attach. XDP_FLAGS_HW_MODE can be used in the future
(e.g., the work on offloading programs from a VM).

The locations chosen to run the egress program - __netdev_start_xmit
before the call to ndo_start_xmit and bq_xmit_all before invoking
ndo_xdp_xmit - allow follow on patch sets to handle tx queueing and
setting the queue index if multi-queue with consistency in handling
both packet formats.

A few of the patches trace back to work done on offloading programs
from a VM by Jason Wang and Prashant Bole.

v1:
- add selftests
- flip the order of xdp generic patches as requested by Toke
- fixed the count arg to do_xdp_egress_frame - Toke
- remove meta data invalidate in __xdp_egress_frame - Toke
- fixed data_hard_start in __xdp_egress_frame - Jesper
- refactored convert_to_xdp_frame to reuse buf to frame code - Jesper
- added missed refactoring patch when generating patch set
- updates to sample program

RFC v5:
- updated cover letter
- moved running of ebpf program to from ndo_{start,xdp}_xmit to core
  code. Dropped all tun and vhost related changes.
- added egress support to bpftool

RFC v4:
- updated cover letter
- patches related to code movement between tuntap, headers and vhost
  are dropped; previous RFC ran the XDP program in vhost context vs
  this set which runs them before queueing to vhost. As a part of this
  moved invocation of egress program to tun_net_xmit and tun_xdp_xmit.
- renamed do_xdp_generic to do_xdp_generic_rx to emphasize is called
  in the Rx path; added rx argument to do_xdp_generic_core since it
  is used for both directions and needs to know which queue values to
  set in xdp_buff

RFC v3:
- reworked the patches - splitting patch 1 from RFC v2 into 3, combining
  patch 2 from RFC v2 into the first 3, combining patches 6 and 7 from
  RFC v2 into 1 since both did a trivial rename and export. Reordered
  the patches such that kernel changes are first followed by libbpf and
  an enhancement to a sample.

- moved small xdp related helper functions from tun.c to tun.h to make
  tun_ptr_free usable from the tap code. This is needed to handle the
  case of tap builtin and tun built as a module.

- pkt_ptrs added to `struct tun_file` and passed to tun_consume_packets
  rather than declaring pkts as an array on the stack.

RFC v2:
- New XDP attachment type: Jesper, Toke and Alexei discussed whether
  to introduce a new program type. Since this set adds a way to attach
  regular XDP program to the tx path, as per Alexei's suggestion, a
  new attachment type BPF_XDP_EGRESS is introduced.

- libbpf API changes:
  Alexei had suggested _opts() style of API extension. Considering it
  two new libbpf APIs are introduced which are equivalent to existing
  APIs. New ones can be extended easily. Please see individual patches
  for details. xdp1 sample program is modified to use new APIs.

- tun: Some patches from previous set are removed as they are
  irrelevant in this series. They will in introduced later.


David Ahern (16):
  net: Refactor convert_to_xdp_frame
  net: Move handling of IFLA_XDP attribute out of do_setlink
  net: Add XDP setup and query commands for Tx programs
  net: Add BPF_XDP_EGRESS as a bpf_attach_type
  xdp: Add xdp_txq_info to xdp_buff
  net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
  net: Rename do_xdp_generic to do_xdp_generic_rx
  net: rename netif_receive_generic_xdp to do_generic_xdp_core
  net: set XDP egress program on netdevice
  net: Support xdp in the Tx path for packets as an skb
  net: Support xdp in the Tx path for xdp_frames
  libbpf: Add egress XDP support
  bpftool: Add support for XDP egress
  selftest: Add test for xdp_egress
  selftest: Add xdp_egress attach tests
  samples/bpf: add XDP egress support to xdp1

 drivers/net/tun.c                             |   4 +-
 include/linux/netdevice.h                     |  23 +-
 include/net/xdp.h                             |  35 ++-
 include/uapi/linux/bpf.h                      |   3 +
 include/uapi/linux/if_link.h                  |   3 +
 kernel/bpf/devmap.c                           |  19 +-
 net/core/dev.c                                | 251 ++++++++++++++----
 net/core/filter.c                             |  23 ++
 net/core/rtnetlink.c                          | 180 ++++++++++---
 samples/bpf/xdp1_user.c                       |  39 ++-
 tools/bpf/bpftool/main.h                      |   2 +-
 tools/bpf/bpftool/net.c                       |  48 +++-
 tools/bpf/bpftool/netlink_dumper.c            |  12 +-
 tools/bpf/bpftool/prog.c                      |   2 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/include/uapi/linux/if_link.h            |   3 +
 tools/lib/bpf/libbpf.c                        |   2 +
 tools/lib/bpf/libbpf.h                        |   9 +-
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/netlink.c                       |  63 ++++-
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../bpf/prog_tests/xdp_egress_attach.c        |  62 +++++
 .../selftests/bpf/progs/test_xdp_egress.c     |  12 +
 .../bpf/progs/test_xdp_egress_fail.c          |  16 ++
 tools/testing/selftests/bpf/progs/xdp_drop.c  |  25 ++
 .../testing/selftests/bpf/test_xdp_egress.sh  | 159 +++++++++++
 26 files changed, 861 insertions(+), 140 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_drop.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_egress.sh

-- 
2.21.1 (Apple Git-122.3)

