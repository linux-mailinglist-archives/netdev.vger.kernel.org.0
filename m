Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138383140CA
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhBHUpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:45:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16095 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhBHUoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a26a0000>; Mon, 08 Feb 2021 12:43:22 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:22 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:18 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 00/13] nexthop: Resilient next-hop groups
Date:   Mon, 8 Feb 2021 21:42:43 +0100
Message-ID: <cover.1612815057.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817002; bh=Mn2RNxiDbcEtr06giBhtW3ic+X+Mgs0o1ZsXbQXNgkM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=JHrg0tcHz9K1k2L4xiBsD8Tkl9nnC8CrEy2bttP3pe3N34R/Spn53X0eJXXvaZuCR
         4aGmTge1g8/hg+i4nZDsSYrTzDhaxE+ZPmha3Hl7e42Vprbx5Edsp0cr4dLdn74oFN
         k63cKJb6y7DAm5yuuZOyGBzmyshW4K6IkUcWGvB4k3ngSZFnYm5L9I7xtGrwCc5NNH
         DnUu825NpvGi5uHbFpVJKpHm/LiChWBVQJfl6iApNq5b8RyGL9wWK6FHxCZn6Ekkjr
         EHYg+GvZdCnqe4W+ERgUqPG8DaNoTmdLFriTLzcvwhJivKDnpwaTJhLHglgh63CELB
         ai2cXnj/8xFrg==
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
flow suddenly end up arriving at a server that does not expect them, Which
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

This patch set adds the implementation of resilient next hop group.

In a nutshell, the algorithm works as follows. Each next hop has a number
of buckets that it wants to have, according to its weight and the number of
buckets in the hash table. In case of an event that might cause bucket
allocation change, the numbers for individual next hops are updated,
similarly to how ranges are updated for mpath group next hops. Following
that, a new "upkeep" algorithm runs, and for idle buckets that belong to a
next hop that is currently occupying more buckets than it wants (it is
"overweight"), it migrates the buckets to one of the next hops that has
fewer buckets than it wants (it is "underweight"). If, after this, there
are still underweight next hops, another upkeep run is scheduled to a
future time.

Chances are there are not enough "idle" buckets to satisfy the new demands.
The algorithm has knobs to select both what it means for a bucket to be
idle, and for whether and when to forcefully migrate buckets if there keeps
being an insufficient number of idle buckets.

To illustrate the usage, consider the following commands:

 # ip nexthop add id 1 via 192.0.2.2 dev dummy1
 # ip nexthop add id 2 via 192.0.2.3 dev dummy1
 # ip nexthop add id 10 group 1/2 type resilient \
	buckets 8 idle_timer 60 unbalanced_timer 300

The last command creates a resilient next hop group. It will have 8
buckets, each bucket will be considered idle when no traffic hits it for at
least 60 seconds, and if the table remains out of balance for 300 seconds,
it will be forcefully brought into balance. (If not present in netlink
message, the idle timer defaults to 120 seconds, and there is no unbalanced
timer, meaning the group may remain unbalanced indefinitely.)

Unbalanced time, i.e. how long since the last time that all nexthops had as
many buckets as they should according to their weights, is reported when
the group is dumped:

 # ip nexthop show id 10
 id 10 group 1/2 type resilient buckets 8 idle_timer 60 unbalanced_timer 30=
0 unbalanced_time 0

When replacing next hops or changing weights, if one does not specify some
parameters, their value is left as it was:

 # ip nexthop replace id 10 group 1,2/2 type resilient
 # ip nexthop show id 10
 id 10 group 1,2/2 type resilient buckets 8 idle_timer 60 unbalanced_timer =
300 unbalanced_time 0

It is also possible to do a dump of individual buckets (and now you know
why there were only 8 of them in the table):

 # ip nexthop bucket show id 10
 id 10 index 0 idle_time 5.59 nhid 1
 id 10 index 1 idle_time 5.59 nhid 1
 id 10 index 2 idle_time 8.74 nhid 2
 id 10 index 3 idle_time 8.74 nhid 2
 id 10 index 4 idle_time 8.74 nhid 1
 id 10 index 5 idle_time 8.74 nhid 1
 id 10 index 6 idle_time 8.74 nhid 1
 id 10 index 7 idle_time 8.74 nhid 1

Note the two buckets that have a shorter idle time. Those are the ones that
were migrated after the nexthop replace command to satisfy the new demand
that nexthop 1 be given 6 buckets instead of 4.

The patchset proceeds as follows:

- Patches #1 and #2 are small refactoring patches.

- Patch #3 contains defines of new UAPI attributes and the new next-hop
  group type. At this point, the nexthop code is made to bounce the new
  type. Is the resilient hashing code is gradually added in the following
  patch sets, it will remain dead. The last patch will make it accessible.

  This patch also adds a suite of new messages related to next hop buckets.
  This approach was taken instead of overloading the information on the
  existing RTM_{NEW,DEL,GET}NEXTHOP messages for the following reasons.

  First, a next-hop group can contain a large number of next-hop buckets
  (4k is not unheard of). This imposes limits on the amount of information
  that can be encoded for each next-hop bucket given a netlink message is
  limited to 64k bytes.

  Second, while RTM_NEWNEXTHOPBUCKET is only used for notifications at this
  point, in the future it can be extended to provide user space with
  control over next-hop buckets configuration.

- Patch #4 contains the meat of the resilient next hop group support.

- Patches #5 and #6 implement support for notifications towards the
  drivers.

- Patch #7 adds an interface for the drivers to report resilient hash
  table bucket activity. Drivers will be able to report through this
  interface whether traffic is hitting a given bucket.

- Patch #8 adds an interface for the drivers to report whether a given
  hash table bucket is offloaded or trapping traffic.

- In patches #9, #10, #11 and #12, UAPI is implemented. This includes all
  the code necessary for creation of resilient groups, bucket dumping and
  getting, and bucket migration notifications.

- In patch #13 the next hop groups are finally made available.

The overall plan is to contribute approximately the following patchsets:

1) Nexthop policy refactoring (already pushed)
2) Preparations for resilient next hop groups (already pushed)
3) Implementation of resilient next hop group (this patchset)
4) Netdevsim offload plus a suite of selftests
5) Preparations for mlxsw offload of resilient next-hop groups
6) mlxsw offload including selftests

Interested parties can look at the complete code at [2].

[1] https://tools.ietf.org/html/rfc2992
[2] https://github.com/idosch/linux/commits/submit/res_integ_v1

Ido Schimmel (4):
  nexthop: Add netlink defines and enumerators for resilient NH groups
  nexthop: Add data structures for resilient group notifications
  nexthop: Allow setting "offload" and "trap" indication of nexthop
    buckets
  nexthop: Allow reporting activity of nexthop buckets

Petr Machata (9):
  nexthop: Pass nh_config to replace_nexthop()
  nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
  nexthop: Add implementation of resilient next-hop groups
  nexthop: Implement notifiers for resilient nexthop groups
  nexthop: Add netlink handlers for resilient nexthop groups
  nexthop: Add netlink handlers for bucket dump
  nexthop: Add netlink handlers for bucket get
  nexthop: Notify userspace about bucket migrations
  nexthop: Enable resilient next-hop groups

 include/net/nexthop.h          |   71 +-
 include/uapi/linux/nexthop.h   |   43 +
 include/uapi/linux/rtnetlink.h |    7 +
 net/ipv4/nexthop.c             | 1521 ++++++++++++++++++++++++++++++--
 security/selinux/nlmsgtab.c    |    5 +-
 5 files changed, 1593 insertions(+), 54 deletions(-)

--=20
2.26.2

