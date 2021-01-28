Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEE3307667
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhA1MvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:51:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15846 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhA1Mux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:50:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3050000>; Thu, 28 Jan 2021 04:50:13 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:10 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 00/12] nexthop: Preparations for resilient next-hop groups
Date:   Thu, 28 Jan 2021 13:49:12 +0100
Message-ID: <cover.1611836479.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL111.nvidia.com (172.20.187.18)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611838213; bh=iy35xPey3C8Pb0Pzlrrw/0tb5LL5vDhoP5dUN78M4qg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=XnYpPlHrcD0btmpKHvrE1EqYpMHb0cLh8F1HFMmrwpJMUaB820zg3U+axVZ5R2PJw
         X3fNnTb77ezKEowwIw8vSdOrMo2jqaWA4O/edH9lkKITpjaL3so37bPB36IkS0MNYb
         7Ge71aMMPuuAcg5L2GnmFiy/a3HnuYHs6vsoGlfEnMjcklaq7Xs57y7H1u/Kcz+bwB
         g8TEJaVsYeXpRrAL/j6ZBbSEZ3o7BCZlUTZh2XQ/4AGeoXuW1Cv+GiCnsgVjuVAFsa
         SZ1cXRm2iQ0VCDTj7vKieKw4gAYlk2KIIzF+5C7oLcPQqQIRV1BjE61Uy7CH6MeX7O
         /UV/xTh6TdwhQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this moment, there is only one type of next-hop group: an mpath group.
Mpath groups implement the hash-threshold algorithm, described in RFC
2992[1].

To select a next hop, hash-threshold algorithm first assigns a range of
hashes to each next hop in the group, and then selects the next hop by
comparing the SKB hash with the individual ranges. When a next hop is
removed from the group, the ranges are recomputed, which leads to
reassignment of parts of hash space from one next hop to another. RFC 2992
illustrates it thus:

             +-------+-------+-------+-------+-------+
             |   1   |   2   |   3   |   4   |   5   |
             +-------+-+-----+---+---+-----+-+-------+
             |    1    |    2    |    4    |    5    |
             +---------+---------+---------+---------+

              Before and after deletion of next hop 3
	      under the hash-threshold algorithm.

Note how next hop 2 gave up part of the hash space in favor of next hop 1,
and 4 in favor of 5. While there will usually be some overlap between the
previous and the new distribution, some traffic flows change the next hop
that they resolve to.

If a multipath group is used for load-balancing between multiple servers,
this hash space reassignment causes an issue that packets from a single
flow suddenly end up arriving at a server that does not expect them, which
may lead to TCP reset.

If a multipath group is used for load-balancing among available paths to
the same server, the issue is that different latencies and reordering along
the way causes the packets to arrive in wrong order.

Resilient hashing is a technique to address the above problem. Resilient
next-hop group has another layer of indirection between the group itself
and its constituent next hops: a hash table. The selection algorithm uses a
straightforward modulo operation to choose a hash bucket, and then reads
the next hop that this bucket contains, and forwards traffic there.

This indirection brings an important feature. In the hash-threshold
algorithm, the range of hashes associated with a next hop must be
continuous. With a hash table, mapping between the hash table buckets and
the individual next hops is arbitrary. Therefore when a next hop is deleted
the buckets that held it are simply reassigned to other next hops:

             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
             |1|1|1|1|2|2|2|2|3|3|3|3|4|4|4|4|5|5|5|5|
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	                      v v v v
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
             |1|1|1|1|2|2|2|2|1|2|4|5|4|4|4|4|5|5|5|5|
             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

              Before and after deletion of next hop 3
	      under the resilient hashing algorithm.

When weights of next hops in a group are altered, it may be possible to
choose a subset of buckets that are currently not used for forwarding
traffic, and use those to satisfy the new next-hop distribution demands,
keeping the "busy" buckets intact. This way, established flows are ideally
kept being forwarded to the same endpoints through the same paths as before
the next-hop group change.

This patchset prepares the next-hop code for eventual introduction of
resilient hashing groups.

- Patches #1-#4 carry otherwise disjoint changes that just remove certain
  assumptions in the next-hop code.

- Patches #5-#6 extend the in-kernel next-hop notifiers to support more
  next-hop group types.

- Patches #7-#12 refactor RTNL message handlers. Resilient next-hop groups
  will introduce a new logical object, a hash table bucket. It turns out
  that handling bucket-related messages is similar to how next-hop messages
  are handled. These patches extract the commonalities into reusable
  components.

The plan is to contribute approximately the following patchsets:

1) Nexthop policy refactoring (already pushed)
2) Preparations for resilient next hop groups (this patchset)
3) Implementation of resilient next hop group
4) Netdevsim offload plus a suite of selftests
5) Preparations for mlxsw offload of resilient next-hop groups
6) mlxsw offload including selftests

Interested parties can look at the current state of the code at [2] and
[3].

[1] https://tools.ietf.org/html/rfc2992
[2] https://github.com/idosch/linux/commits/submit/res_integ_v1
[3] https://github.com/idosch/iproute2/commits/submit/res_v1

David Ahern (1):
  nexthop: Rename nexthop_free_mpath

Ido Schimmel (1):
  nexthop: Use enum to encode notification type

Petr Machata (10):
  nexthop: Dispatch nexthop_select_path() by group type
  nexthop: Introduce to struct nh_grp_entry a per-type union
  nexthop: Assert the invariant that a NH group is of only one type
  nexthop: Dispatch notifier init()/fini() by group type
  nexthop: Extract dump filtering parameters into a single structure
  nexthop: Extract a common helper for parsing dump attributes
  nexthop: Strongly-type context of rtm_dump_nexthop()
  nexthop: Extract a helper for walking the next-hop tree
  nexthop: Add a callback parameter to rtm_dump_walk_nexthops()
  nexthop: Extract a helper for validation of get/del RTNL requests

 .../ethernet/mellanox/mlxsw/spectrum_router.c |  54 +++-
 drivers/net/netdevsim/fib.c                   |  23 +-
 include/net/nexthop.h                         |  14 +-
 net/ipv4/nexthop.c                            | 270 ++++++++++++------
 4 files changed, 245 insertions(+), 116 deletions(-)

--=20
2.26.2

