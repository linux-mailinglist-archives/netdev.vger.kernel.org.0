Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE0A33D74
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFDDT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFDDT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:19:57 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0B9324457;
        Tue,  4 Jun 2019 03:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559618396;
        bh=w46K7tJ/K6aD7qFG+m4dQXWq8+QaLazUjAjVvznlm2U=;
        h=From:To:Cc:Subject:Date:From;
        b=fyDx6EskAS+R1M9i+pVcXpSoYacJrG7SUDhOUGAANLhfiM18jx9WVodTnIWWNNOxh
         w4pyCcxxCOXRpZCKZYHNNDz32O2zLCvFP1gdPNCBj91/BExK3WO+O6KDPtG0W7Zcgp
         QHO02lsCkacO01QzSWvFHi/B4TmakcuuI+1OoEe4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 0/7] net: add struct nexthop to fib{6}_info
Date:   Mon,  3 Jun 2019 20:19:48 -0700
Message-Id: <20190604031955.26949-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Set 10 of 11 to improve route scalability via support for nexthops as
standalone objects for fib entries.
    https://lwn.net/Articles/763950/

This sets adds 'struct nexthop' to fib_info and fib6_info. IPv4
already handles multiple fib_nh entries in a single fib_info, so
the conversion to use a nexthop struct is fairly mechanical. IPv6
using a nexthop struct with a fib6_info impacts a lot of core logic
which is built around the assumption of a single, builtin fib6_nh
per fib6_info. To make this easier to review, this set adds
nexthop to fib6_info and adds checks in most places fib6_info is
used. The next set finishes the IPv6 conversion, walking through
the places that need to consider all fib6_nh within a nexthop struct.

Offload drivers - mlx5, mlxsw and rocker - are changed to fail FIB
entries using nexthop objects. That limitation can be removed once
the drivers are updated to properly support separate nexthops.

This set starts by adding accessors for fib_nh and fib_nhs in a
fib_info. This makes it easier to extract the number of nexthops
in the fib entry and a specific fib_nh once the entry references
a struct nexthop. Patch 2 converts more of IPv4 code to use
fib_nh_common allowing a struct nexthop to use a fib6_nh with an
IPv4 entry.

Patches 3 and 4 add 'struct nexthop' to fib{6}_info and update
references to both take a different path when it is set. New
exported functions are added to the nexthop code to validate a
nexthop struct when configured for use with a fib entry. IPv4
is allowed to use a nexthop with either v4 or v6 entries. IPv6
is limited to v6 entries only. In both cases list_heads track
the fib entries using a nexthop struct for fast correlation on
events (e.g., device events or nexthop events like delete or
replace).

The last 3 patches add hooks to drivers listening for FIB
notificationas. All 3 of them reject the routes as unsupported,
returning an error message to the user via extack. For mlxsw
at least this is a stop gap measure until the driver is updated for
proper support.

Functional tests for nexthops have already been committed. Those tests
will be active after the next patch set which makes the code paths
created by this set and the next one live.

Existing code paths moved to the else branch of 'if (f{6}i->nh)' checks
are covered by existing tests under selftests/net.

v3
- remove ip6_create_rt_rcu from ip6_pol_route in patch 4 and use pcpu
  routes for REJECT routes with the blackhole nexthop (request from Wei)

v2
- no code changes from v1
- commit messages for first 4 patches updated


David Ahern (7):
  ipv4: Use accessors for fib_info nexthop data
  ipv4: Prepare for fib6_nh from a nexthop object
  ipv4: Plumb support for nexthop object in a fib_info
  ipv6: Plumb support for nexthop object in a fib6_info
  mlxsw: Fail attempts to use routes with nexthop objects
  mlx5: Fail attempts to use routes with nexthop objects
  rocker: Fail attempts to use routes with nexthop objects

 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  33 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  33 ++-
 drivers/net/ethernet/rocker/rocker_main.c          |   4 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |  25 +-
 include/net/ip6_fib.h                              |  11 +-
 include/net/ip6_route.h                            |  13 +-
 include/net/ip_fib.h                               |  25 +-
 include/net/nexthop.h                              | 113 +++++++++
 net/core/filter.c                                  |   3 +-
 net/ipv4/fib_frontend.c                            |  15 +-
 net/ipv4/fib_lookup.h                              |   1 +
 net/ipv4/fib_rules.c                               |   8 +-
 net/ipv4/fib_semantics.c                           | 257 ++++++++++++++-------
 net/ipv4/fib_trie.c                                |  38 ++-
 net/ipv4/nexthop.c                                 | 111 ++++++++-
 net/ipv4/route.c                                   |   5 +-
 net/ipv6/addrconf.c                                |   5 +
 net/ipv6/ip6_fib.c                                 |  22 +-
 net/ipv6/ndisc.c                                   |   3 +-
 net/ipv6/route.c                                   | 148 ++++++++++--
 20 files changed, 698 insertions(+), 175 deletions(-)

-- 
2.11.0

