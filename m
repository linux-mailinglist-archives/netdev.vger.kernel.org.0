Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478E1170EEF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgB0DUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgB0DUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:20 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232A824672;
        Thu, 27 Feb 2020 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773620;
        bh=nvN/gTboSmba+YDWHWt0+7LEGG0ee8buzfkkDCTQVlg=;
        h=From:To:Cc:Subject:Date:From;
        b=QAkv1SMHOoMrp9uKJRXHisaNKs7ecyPyM2THZYm2dAXQaSIOQT8wqvplFpNz5hUWM
         clZBk8Sm9b6oszmmWm7H7KDcsBmNLBqjAL575upJ4NC1HLrZGL9FHeg1eXo1oX0ZSc
         Bn3bcKcboDCpfxEjZqw2OgiZMFL99jqMh9BwLu34=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH RFC v4 bpf-next 00/11] Add support for XDP in egress path
Date:   Wed, 26 Feb 2020 20:20:02 -0700
Message-Id: <20200227032013.12385-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This series adds support for XDP in the egress path by introducing
a new XDP attachment type, BPF_XDP_EGRESS, and adding an if_link API
for attaching the program to a netdevice and reporting the program.
The intent is to emulate the current RX path for XDP as much as
possible to maintain consistency and symmetry in the 2 paths with
their APIs and when the programs are run: at first touch in the Rx
path and last touch in the Tx path.

The intent is to be able to run bpf programs on all packets regardless
of how they got to the xmit function of the netdevice - as an skb or a
redirected xdp frame. This is a missing primitive for XDP allowing
solutions to build small, targeted programs properly distributed in the
networking path allowing for example an egress firewall / ACL / traffic
verification or packet manipulation and encapping an entire ethernet
frame whether it is locally generated traffic, forwarded via the slow
path (ie., full stack processing) or xdp redirected frames. 

This set adds initial support for XDP in the egress path to the tun
driver, mostly for XDP_DROP (e.g., ACL on the ingress path to the
VM). XDP_TX on Rx means send the packet out the device it arrived
on; given that, XDP_Tx for the Tx path is treated as equivalent to
XDP_PASS - ie., continue on the Tx path. XDP_REDIRECT in the Tx path
can be handled in a follow set; conceptually it is no different than
the Rx path - the frame is handed off to another device though loops
do need to be detected.

The expectation is that the current mode levels (skb, driver and hardware)
will also apply to the egress path. The current patch set focuses on the
driver mode with tun. Attempting to tag the EGRESS path as yet another
mode is inconsistent on a number of levels - from the current usage of
XDP_FLAGS to options passed to the verifier for restricting xdp_md
accesses. Using the API as listed above maintains consistency with all
existing code.

As for libbpf, we believe that an API that mirrors and is consistent
with the existing xdp functions for the ingress path is the right way
to go for the egress path. Meaning, the libbpf API is replicated with
_egress in the name, but the libbpf implementation shares common code
to the degree possible.

Some of the patches in this set were originally part of Jason
Wang's work "XDP offload with virtio-net" [1]. The work overlaps
work done by me, so we decided to consolidate the work into the
egress path first with the offload option expected to be a follow
on.

At this point we are recognizing enough differences in the use case
that we are diverging again. For instance, there is agreement that
running the offloaded program should be done in vhost process context
making the "cost" attributable to the VM (vhost or qemu), but it is
more important for the host managed programs to be in the primary
packet path. As an example, packets should not be queueud to the vhost
ring buffer until *after* the XDP program for the Tx path has been run
otherwise there is the potential for the ring buffer to fill with
packets that the XDP program intends to drop (e.g., host managed ACL).

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


David Ahern (9):
  net: Add XDP setup and query commands for Tx programs
  xdp: Add xdp_txq_info to xdp_buff
  net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
  net: core: rename netif_receive_generic_xdp to do_generic_xdp_core
  net: core: Rename do_xdp_generic to do_xdp_generic_rx and export
  tun: set egress XDP program
  tun: Support xdp in the Tx path for skb
  tun: Support xdp in the Tx path for xdp_frames
  libbpf: Add egress XDP support

Prashant Bhole (2):
  net: Add BPF_XDP_EGRESS as a bpf_attach_type
  samples/bpf: xdp1, add egress XDP support

 drivers/net/tun.c                  | 156 ++++++++++++++++++++++++++---
 include/linux/netdevice.h          |   8 +-
 include/net/xdp.h                  |   5 +
 include/uapi/linux/bpf.h           |   7 +-
 include/uapi/linux/if_link.h       |   1 +
 net/core/dev.c                     |  59 +++++++----
 net/core/filter.c                  |  34 +++++--
 net/core/rtnetlink.c               | 114 ++++++++++++++++++++-
 samples/bpf/xdp1_user.c            |  30 +++++-
 tools/include/uapi/linux/bpf.h     |   1 +
 tools/include/uapi/linux/if_link.h |   1 +
 tools/lib/bpf/libbpf.c             |   2 +
 tools/lib/bpf/libbpf.h             |   6 ++
 tools/lib/bpf/libbpf.map           |   3 +
 tools/lib/bpf/netlink.c            |  52 ++++++++--
 15 files changed, 418 insertions(+), 61 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

