Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1118D1A6B35
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbgDMRS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732592AbgDMRSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:21 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A606C2072D;
        Mon, 13 Apr 2020 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798300;
        bh=6b8LxZUeZhTlC2hf/t5RdISJX9e2rU+A6aRilPcSXpA=;
        h=From:To:Cc:Subject:Date:From;
        b=W7/x8Ol2zcWIbqZA5XeWh02K8TOjE6hYjihfAdjzA0KNqmRDnopqW8/+L4djtHkWp
         omuI3aY1YBm3UTA9s6gf1XgtX1czLR+jvCq7U+bVFzdYIvf+1/zmQbXe0hNS2zcQlo
         +nzYS3xK4EnYIbUiBgekrHXi4xEqq/T+cjMCsEX0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH RFC-v5 bpf-next 00/12] Add support for XDP in egress path
Date:   Mon, 13 Apr 2020 11:17:49 -0600
Message-Id: <20200413171801.54406-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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

Automated tests will be added to tools/testing/selftests/bpf in the
next revision.

v5:
- updated cover letter
- moved running of ebpf program from ndo_{start,xdp}_xmit to core
  code. Accordingly, dropped all tun and vhost related changes.
- added egress support to bpftool

v4:
- updated cover letter
- patches related to code movement between tuntap, headers and vhost
  are dropped; previous RFC ran the XDP program in vhost context vs
  this set which runs them before queueing to vhost. As a part of this
  moved invocation of egress program to tun_net_xmit and tun_xdp_xmit.
- renamed do_xdp_generic to do_xdp_generic_rx to emphasize is called
  in the Rx path; added rx argument to do_xdp_generic_core since it
  is used for both directions and needs to know which queue values to
  set in xdp_buff

v3:
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

v2:
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

[1]: https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net

David Ahern (12):
  net: Add XDP setup and query commands for Tx programs
  net: Add BPF_XDP_EGRESS as a bpf_attach_type
  xdp: Add xdp_txq_info to xdp_buff
  net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
  net: core: rename netif_receive_generic_xdp to do_generic_xdp_core
  net: core: Rename do_xdp_generic to do_xdp_generic_rx
  dev: set egress XDP program
  dev: Support xdp in the Tx path for packets as an skb
  dev: Support xdp in the Tx path for xdp_frames
  libbpf: Add egress XDP support
  bpftool: Add support for XDP egress
  samples/bpf: add XDP egress support to xdp1

 drivers/net/tun.c                  |   4 +-
 include/linux/netdevice.h          |  23 ++-
 include/net/xdp.h                  |   5 +
 include/uapi/linux/bpf.h           |   3 +
 include/uapi/linux/if_link.h       |   3 +
 kernel/bpf/devmap.c                |  19 ++-
 net/core/dev.c                     | 258 +++++++++++++++++++++++------
 net/core/filter.c                  |  23 +++
 net/core/rtnetlink.c               |  96 ++++++++++-
 samples/bpf/xdp1_user.c            |  38 ++++-
 tools/bpf/bpftool/main.h           |   2 +-
 tools/bpf/bpftool/net.c            |  49 +++++-
 tools/bpf/bpftool/netlink_dumper.c |  12 +-
 tools/include/uapi/linux/bpf.h     |   3 +
 tools/include/uapi/linux/if_link.h |   3 +
 tools/lib/bpf/libbpf.c             |   2 +
 tools/lib/bpf/libbpf.h             |   9 +-
 tools/lib/bpf/libbpf.map           |   2 +
 tools/lib/bpf/netlink.c            |  63 ++++++-
 19 files changed, 528 insertions(+), 89 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

