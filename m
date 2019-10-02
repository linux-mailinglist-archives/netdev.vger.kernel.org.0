Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8FC49BF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfJBIlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40287 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 286292071B;
        Wed,  2 Oct 2019 04:41:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JFX3qP3WCHNnv5TYn
        fMD8/Nqvo1PgjNPC/2RODXI+34=; b=lLIQeFv6P1x5WlRjoFHiRTmyN/0c8rRE7
        5/dsnymPZyZ5Ob/MexN5crqOg33AFLBpzBGUuBSsTVx80e7GqdgVU3kiMW0t5arG
        sxDnlwZi1Cmbt/IQ4YVNxKabmfB2FC66OvKy3wjRL7LErmn3GBsAD2gT+5huFF8k
        N08KU2BdQbU3+w1eLk6EmOpGnKVJcQt8YZ/Ufc+t/L2QEcrS8qe0kEP9z1Dhjq2G
        0qJJy3QjiparRC9H92vPLONa8eXA6pNMVJuSBaHKrfp5WxT6OmTfl26gGbrAFYCr
        siCTWts0C+RkJRpUbbrZuysHA3PMNUT04dGLMgbXfWz4qQfUQqW9Q==
X-ME-Sender: <xms:uWKUXRSEU4K3YzWz1e3axxnUbfFUE2P_eV7HVo3AA2qWZcDxY3p9nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucffohhmrghinhepsggvrhhnrghtrdgthhdpghhithhhuhgsrdgtohhmpd
    hoiihlrggsshdrohhrghenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:uWKUXaeiYUKXIMfq_K7f5K-FIfrGGwaJtjOb-KqiiTb_xnBZY0bk4A>
    <xmx:uWKUXcz9Ra6Ir-i7xn2vIDNEKjrqtxSLYM7tuynKb3Gp1IuH_7_dvg>
    <xmx:uWKUXTQUii3WLpr69-sAyBGIt9jeJVGGA8xIoxilMGgqd5h3vVXF_g>
    <xmx:umKUXf94qOSrmXDirQ5n3Owop0nLl4U8dVMAluOOC2J7AFFmLxwT4A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E64DD60057;
        Wed,  2 Oct 2019 04:41:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 00/15] Simplify IPv4 route offload API
Date:   Wed,  2 Oct 2019 11:40:48 +0300
Message-Id: <20191002084103.12138-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Today, whenever an IPv4 route is added or deleted a notification is sent
in the FIB notification chain and it is up to offload drivers to decide
if the route should be programmed to the hardware or not. This is not an
easy task as in hardware routes are keyed by {prefix, prefix length,
table id}, whereas the kernel can store multiple such routes that only
differ in metric / TOS / nexthop info.

This series makes sure that only routes that are actually used in the
data path are notified to offload drivers. This greatly simplifies the
work these drivers need to do, as they are now only concerned with
programming the hardware and do not need to replicate the IPv4 route
insertion logic and store multiple identical routes.

The route that is notified is the first FIB alias in the FIB node with
the given {prefix, prefix length, table ID}. In case the route is
deleted and there is another route with the same key, a replace
notification is emitted. Otherwise, a delete notification is emitted.

The above means that in the case of multiple routes with the same key,
but different TOS, only the route with the highest TOS is notified.
While the kernel can route a packet based on its TOS, this is not
supported by any hardware devices I'm familiar with. Moreover, this is
not supported by IPv6 nor by BIRD/FRR from what I could see. Offload
drivers should therefore use the presence of a non-zero TOS as an
indication to trap packets matching the route and let the kernel route
them instead. mlxsw has been doing it for the past two years.

The series also adds an "in hardware" indication to routes, in addition
to the offload indication we already have on nexthops today. Besides
being long overdue, the reason this is done in this series is that it
makes it possible to easily test the new FIB notification API over
netdevsim.

To ensure there is no degradation in route insertion rates, I used
Vincent Bernat's script [1][2] from [3] to inject 500,000 routes from an
MRT dump from a router with a full view. On a system with Intel(R)
Xeon(R) CPU D-1527 @ 2.20GHz I measured 8.184 seconds, averaged over 10
runs and saw no degradation compared to net-next from today.

Patchset overview:
Patches #1-#7 introduce the new FIB notifications
Patches #8-#9 convert listeners to make use of the new notifications
Patches #10-#14 add "in hardware" indication for IPv4 routes, including
a dummy FIB offload implementation in netdevsim
Patch #15 adds a selftest for the new FIB notifications API over
netdevsim

The series is based on Jiri's "devlink: allow devlink instances to
change network namespace" series [4]. The patches can be found here [5]
and patched iproute2 with the "in hardware" indication can be found here
[6].

IPv6 is next on my TODO list.

[1] https://github.com/vincentbernat/network-lab/blob/master/common/helpers/lab-routes-ipvX/insert-from-bgp
[2] https://gist.github.com/idosch/2eb96efe50eb5234d205e964f0814859
[3] https://vincent.bernat.ch/en/blog/2017-ipv4-route-lookup-linux
[4] https://patchwork.ozlabs.org/cover/1162295/
[5] https://github.com/idosch/linux/tree/fib-notifier
[6] https://github.com/idosch/iproute2/tree/fib-notifier

Ido Schimmel (15):
  ipv4: Add temporary events to the FIB notification chain
  ipv4: Notify route after insertion to the routing table
  ipv4: Notify route if replacing currently offloaded one
  ipv4: Notify newly added route if should be offloaded
  ipv4: Handle route deletion notification
  ipv4: Handle route deletion notification during flush
  ipv4: Only Replay routes of interest to new listeners
  mlxsw: spectrum_router: Start using new IPv4 route notifications
  ipv4: Remove old route notifications and convert listeners
  ipv4: Replace route in list before notifying
  ipv4: Encapsulate function arguments in a struct
  ipv4: Add "in hardware" indication to routes
  mlxsw: spectrum_router: Mark routes as "in hardware"
  netdevsim: fib: Mark routes as "in hardware"
  selftests: netdevsim: Add test for route offload API

 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   4 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 152 ++-----
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 drivers/net/netdevsim/fib.c                   | 263 ++++++++++-
 include/net/ip_fib.h                          |   5 +
 include/uapi/linux/rtnetlink.h                |   1 +
 net/ipv4/fib_lookup.h                         |  18 +-
 net/ipv4/fib_semantics.c                      |  30 +-
 net/ipv4/fib_trie.c                           | 223 ++++++++--
 net/ipv4/route.c                              |  12 +-
 .../drivers/net/netdevsim/fib_notifier.sh     | 411 ++++++++++++++++++
 11 files changed, 938 insertions(+), 185 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh

-- 
2.21.0

