Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0206231965
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfFADgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfFADgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:20 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63AF7270D6;
        Sat,  1 Jun 2019 03:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360179;
        bh=qfthsqpWJkItdgh5CTBOiiDxinU+zbID0Ol8B9QLEyU=;
        h=From:To:Cc:Subject:Date:From;
        b=d0VyaSKUEayn0XhCVGKhebxaxmjDYwLxolihY50Nz2O7ubUqEVoAuFlsEm/aS6ghA
         a+lpwjxoiur3QiSqcZrTnIKD0f1K1Vnh8Y+lvoQk6KZhUZoE9rv7UrbXxKkdxZb0wE
         odmC7NkcNKTE02j19VbqxAPzJ7P7LagXkgUuYStM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 00/27] nexthops: Final patches
Date:   Fri, 31 May 2019 20:35:51 -0700
Message-Id: <20190601033618.27702-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This is an RFC for no other reason than it exceeds the 20'ish patch
limit. As with the development of this entire feature I have attempted
to send these in sets and an order that is both reviewable and kinder
to the reviewees.

Patches 1-7 have been posted already. This is a re-send.

Patches 8-17 iterate over each fib6_nh in a nexthop and run existing
functions. These are needed since IPv6 fib entries in the past have
only handled a single fib6_nh per entry while nexthops allow multipath
similar to what IPv4 has - one fib6_info with multiple fib6_nh.

Patches 18 and 20 wire up nexthops with fib entries. With these commits
you can actually use nexthops with routes.

Patch 19 is an optimization for IPv4 when using nexthops in the most
predominant use case.

Patches 21 handles replace of a nexthop config.

Patches 22-27 add new tests for the nexthop infrastructure and update
existing tests to use both old and new routing.

David Ahern (27):
  ipv4: Use accessors for fib_info nexthop data
  ipv4: Prepare for fib6_nh from a nexthop object
  ipv4: Plumb support for nexthop object in a fib_info
  ipv6: Plumb support for nexthop object in a fib6_info
  mlxsw: Fail attempts to use routes with nexthop objects
  mlx5: Fail attempts to use routes with nexthop objects
  rocker: Fail attempts to use routes with nexthop objects
  nexthops: Add ipv6 helper to walk all fib6_nh in a nexthop struct
  ipv6: Handle all fib6_nh in a nexthop in fib6_drop_pcpu_from
  ipv6: Handle all fib6_nh in a nexthop in rt6_device_match
  ipv6: Handle all fib6_nh in a nexthop in __find_rr_leaf
  ipv6: Handle all fib6_nh in a nexthop in rt6_nlmsg_size
  ipv6: Handle all fib6_nh in a nexthop in fib6_info_uses_dev
  ipv6: Handle all fib6_nh in a nexthop in exception handling
  ipv6: Handle all fib6_nh in a nexthop in __ip6_route_redirect
  ipv6: Handle all fib6_nh in a nexthop in rt6_do_redirect
  ipv6: Handle all fib6_nh in a nexthop in mtu updates
  ipv4: Allow routes to use nexthop objects
  ipv4: Optimization for fib_info lookup with nexthops
  ipv6: Allow routes to use nexthop objects
  nexthops: add support for replace
  selftests: Add test cases for nexthop objects
  selftests: pmtu: Move running of test into a new function
  selftests: pmtu: Move route installs to a new function
  selftests: pmtu: Add support for routing via nexthop objects
  selftests: icmp_redirect: Add support for routing via nexthop objects
  selftests: Add version of router_multipath.sh using nexthop objects

 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   33 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   33 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    4 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   25 +-
 include/net/ip6_fib.h                              |   12 +-
 include/net/ip6_route.h                            |   13 +-
 include/net/ip_fib.h                               |   26 +-
 include/net/nexthop.h                              |  117 +++
 net/core/filter.c                                  |    3 +-
 net/ipv4/fib_frontend.c                            |   34 +-
 net/ipv4/fib_lookup.h                              |    1 +
 net/ipv4/fib_rules.c                               |    8 +-
 net/ipv4/fib_semantics.c                           |  343 +++++--
 net/ipv4/fib_trie.c                                |   38 +-
 net/ipv4/nexthop.c                                 |  378 +++++++-
 net/ipv4/route.c                                   |    5 +-
 net/ipv6/addrconf.c                                |    5 +
 net/ipv6/ip6_fib.c                                 |   53 +-
 net/ipv6/ndisc.c                                   |    3 +-
 net/ipv6/route.c                                   |  608 +++++++++++-
 tools/testing/selftests/net/fib_nexthops.sh        | 1026 ++++++++++++++++++++
 .../selftests/net/forwarding/router_mpath_nh.sh    |  370 +++++++
 tools/testing/selftests/net/icmp_redirect.sh       |   60 ++
 tools/testing/selftests/net/pmtu.sh                |  237 +++--
 24 files changed, 3141 insertions(+), 294 deletions(-)
 create mode 100755 tools/testing/selftests/net/fib_nexthops.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh.sh

-- 
2.11.0

