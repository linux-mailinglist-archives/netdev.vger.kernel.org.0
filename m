Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866F814607B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAWBmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAWBmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:17 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4232E2465B;
        Thu, 23 Jan 2020 01:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743736;
        bh=d0e6O5Xg/3s0br6nQAFX4N4dCoFLVWGP1HxY/g9gWGg=;
        h=From:To:Cc:Subject:Date:From;
        b=a/zW4SNmMZmDTHH7XVgN99v3MWkPWVpYMNauoflKzricnZq4uJ5IXuAHx2Uj5hWaC
         3NKK5K1icnFw2Vmdv7t1yxHi6eRMBUSoBrh0qHyw6t6QUaALXd7WXo68GPb5Atbmbu
         e3rIx8EfwK627u76rkThKL0SoAoLUgoxjHFbPdrk=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 00/12] Add support for XDP in egress path
Date:   Wed, 22 Jan 2020 18:41:58 -0700
Message-Id: <20200123014210.38412-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This series adds support for XDP in the egress path by introducing
a new XDP attachment type, BPF_XDP_EGRESS, and adding an if_link API
for attaching the program to a netdevice and reporting the program.
The intent is to emulate the current RX path for XDP as much as
possible to maintain consistency in the 2 paths.

This set adds initial support for XDP in the egress path to the tun
driver, mostly for XDP_DROP (e.g., ACL on the ingress path to the
VM). XDP_REDIRECT will be handled later because we need to come up
with proper way to handle it in tx path. veth should be an easy
follow on for use with containers once this initial API change is in.

Some of the patches in this set were originally part of Jason
Wang's work "XDP offload with virtio-net" [1]. The work overlaps
work done by me, so we decided to consolidate the work into the
egress path first with the offload option expected to be a follow
on.

With respect to comments on RFC v2:

The kernel side implementation requires 2 UAPI attributes:
1. attach type - BPF_XDP_EGRESS, and
2. attach to a device and report such - IFLA_XDP_EGRESS.

The attach type uapi is needed as a way for the verifier to restrict
access to Rx entries in the xdp context for example and is consistent
with other programs and the concept of attach type. The if_link changes
should mirror the current XDP API for Rx (i.e., IFLA_XDP and its nested
attributes).

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
to the existing xdp to the degree possible.

v3:
- reworked the patches - splitting patch 1 from RFC v2 into 3, combining
  patch 2 from RFC v3 into the first 3, combining patches 6 and 7 from
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

David Ahern (4):
  net: Add new XDP setup and query commands
  net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
  tun: set egress XDP program
  libbpf: Add egress XDP support

Jason Wang (1):
  net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()

Prashant Bhole (7):
  net: Add BPF_XDP_EGRESS as a bpf_attach_type
  tuntap: check tun_msg_ctl type at necessary places
  tun: move shared functions to if_tun.h
  vhost_net: user tap recvmsg api to access ptr ring
  tuntap: remove usage of ptr ring in vhost_net
  tun: run XDP program in tx path
  samples/bpf: xdp1, add egress XDP support

 drivers/net/tap.c                  |  42 +++--
 drivers/net/tun.c                  | 257 ++++++++++++++++++++++-------
 drivers/vhost/net.c                |  77 ++++-----
 include/linux/if_tap.h             |   5 -
 include/linux/if_tun.h             |  57 ++++++-
 include/linux/netdevice.h          |   6 +-
 include/uapi/linux/bpf.h           |   1 +
 include/uapi/linux/if_link.h       |   1 +
 net/core/dev.c                     |  44 +++--
 net/core/filter.c                  |   8 +
 net/core/rtnetlink.c               | 114 ++++++++++++-
 samples/bpf/xdp1_user.c            |  30 +++-
 tools/include/uapi/linux/bpf.h     |   1 +
 tools/include/uapi/linux/if_link.h |   1 +
 tools/lib/bpf/libbpf.c             |   2 +
 tools/lib/bpf/libbpf.h             |   6 +
 tools/lib/bpf/libbpf.map           |   3 +
 tools/lib/bpf/netlink.c            |  52 +++++-
 18 files changed, 555 insertions(+), 152 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

