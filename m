Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C31D0476
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731939AbgEMBqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbgEMBqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:46:11 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E487206F5;
        Wed, 13 May 2020 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589334370;
        bh=h9xMXeKOCvbXF+E2yXgIisMKJqJUqQEw2W/MF9GKqUc=;
        h=From:To:Cc:Subject:Date:From;
        b=bcccIBz1fsl8qvE43cZT+B6S8oqmOnvklagUff0OvilhLXE6BDslTcSST1defeJCg
         hB8DqE/5OTcKzYqqgB1IbuXbuJgojbqo9363IBImx050dpQgAMuXvD/S1tfPf3YeOg
         IA2ZoI0TufJUAavD1NL/dliHTj207veJeZQUTvg4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
Date:   Tue, 12 May 2020 19:45:56 -0600
Message-Id: <20200513014607.40418-1-dsahern@kernel.org>
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
the program. This allows bpf programs to be run on redirected xdp
frames with the context showing the Tx device.

This is a missing primitive for XDP allowing solutions to build small,
targeted programs properly distributed in the networking path allowing,
for example, an egress firewall/ACL/traffic verification or packet
manipulation based on data specific to the egress device.

Nothing about running a program in the Tx path requires driver specific
resources like the Rx path has. Thus, programs can be run in core
code and attached to the net_device struct similar to skb mode. The
egress attach is done using the new XDP_FLAGS_EGRESS_MODE flag, and
is reported by the kernel using the XDP_ATTACHED_EGRESS_CORE attach
flag with IFLA_XDP_EGRESS_PROG_ID making the api similar to existing
APIs for XDP.

The egress program is run in bq_xmit_all before invoking ndo_xdp_xmit.
This is similar to cls_bpf programs which run before the call to
ndo_dev_xmit. Together the 2 locations cover all packets about to be
sent to a device for Tx.

xdp egress programs are not run on skbs, so a cls-bpf counterpart
should also be attached to the device to cover all packets -
xdp_frames and skbs.

v5:
- rebased to top of bpf-next
- dropped skb path; cls-bpf provides an option for the same functionality
  without having to take a performance hit (e.g., disabling GSO).
- updated fall through notation to 'fallthrough;' statement per
  checkpatch warning

v4:
- added space in bpftool help in partch 12 - Toke
- updated to top of bpf-next

v3:
- removed IFLA_XDP_EGRESS and dropped back to XDP_FLAGS_EGRESS_MODE
  as the uapi to specify the attach. This caused the ordering of the
  patches to change with the uapi now introduced in the second patch
  and 2 refactoring patches are dropped. Samples and test programs
  updated to use the new API.

v2:
- changed rx checks in xdp_is_valid_access to any expected_attach_type
- add xdp_egress argument to bpftool prog rst document
- do not allow IFLA_XDP and IFLA_XDP_EGRESS in the same config. There
  is no way to rollback IFLA_XDP if IFLA_XDP_EGRESS fails.
- comments from Andrii on libbpf

v1:
- add selftests
- flip the order of xdp generic patches as requested by Toke
- fixed the count arg to do_xdp_egress_frame - Toke
- remove meta data invalidate in __xdp_egress_frame - Toke
- fixed data_hard_start in __xdp_egress_frame - Jesper
- refactored convert_to_xdp_frame to reuse buf to frame code - Jesper
- added missed refactoring patch when generating patch set

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


David Ahern (11):
  net: Refactor convert_to_xdp_frame
  net: uapi for XDP programs in the egress path
  net: Add XDP setup and query commands for Tx programs
  net: Add BPF_XDP_EGRESS as a bpf_attach_type
  xdp: Add xdp_txq_info to xdp_buff
  net: set XDP egress program on netdevice
  net: Support xdp in the Tx path for xdp_frames
  libbpf: Add egress XDP support
  bpftool: Add support for XDP egress
  selftest: Add xdp_egress attach tests
  samples/bpf: add XDP egress support to xdp1

 include/linux/netdevice.h                     |   7 +
 include/net/xdp.h                             |  35 +++--
 include/uapi/linux/bpf.h                      |   3 +
 include/uapi/linux/if_link.h                  |   6 +-
 kernel/bpf/devmap.c                           |  19 ++-
 net/core/dev.c                                | 147 ++++++++++++++++--
 net/core/filter.c                             |  26 ++++
 net/core/rtnetlink.c                          |  23 ++-
 samples/bpf/xdp1_user.c                       |  11 +-
 .../bpf/bpftool/Documentation/bpftool-net.rst |   4 +-
 .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   4 +-
 tools/bpf/bpftool/net.c                       |   6 +-
 tools/bpf/bpftool/netlink_dumper.c            |   5 +
 tools/bpf/bpftool/prog.c                      |   2 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/include/uapi/linux/if_link.h            |   6 +-
 tools/lib/bpf/libbpf.c                        |   2 +
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/netlink.c                       |   6 +
 .../bpf/prog_tests/xdp_egress_attach.c        |  56 +++++++
 .../selftests/bpf/progs/test_xdp_egress.c     |  12 ++
 .../bpf/progs/test_xdp_egress_fail.c          |  16 ++
 23 files changed, 358 insertions(+), 44 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c

-- 
2.21.1 (Apple Git-122.3)

