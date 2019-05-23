Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4505C274C8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfEWD2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfEWD2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:04 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC9342075E;
        Thu, 23 May 2019 03:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582083;
        bh=RI+uux8KFjoGHp4bXu41lgJVRH64aGS4ylDDHrEfLCY=;
        h=From:To:Cc:Subject:Date:From;
        b=sJ+4iaownRya3JEb9C4pi5dcckL48hVzsPXzW0FriqQEzqX1MXZIovubRHgBq13aB
         bYv5ieFhaJX9l5zQwyslbsbAiVtxcqjFYgxXcKsq429ub7Gf7HkYEWefivlb1PYIl6
         XfFtCuyGxZM2ylyPP1TbTAhNb+2cZssouL+epQhc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/7] ipv6: Move exceptions to fib6_nh and make it optional in a fib6_info
Date:   Wed, 22 May 2019 20:27:54 -0700
Message-Id: <20190523032801.11122-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Patches 1 and 4 move pcpu and exception caches from fib6_info to fib6_nh.
With respect to the current FIB entries this is only a movement from one
struct to another contained within the first.

Patch 2 refactors the core logic of fib6_drop_pcpu_from into a helper
that is invoked per fib6_nh.

Patch 3 refactors exception handling in a similar way - creating a bunch
of helpers that can be invoked per fib6_nh with the goal of making patch
4 easier to review as well as creating the code needed for nexthop
objects.

Patch 5 makes a fib6_nh at the end of a fib6_info an array similar to
IPv4 and its fib_info. For the current fib entry model, all fib6_info
will have a fib6_nh allocated for it.

Patch 6 refactors ip6_route_del moving the code for deleting an
exception entry into a new function.

Patch 7 adds tests for redirect route exceptions. The new test was
written against 5.1 (before any of the nexthop refactoring). It and the
pmtu.sh selftest exercise the exception code paths - from creating
exceptions to cleaning them up on device delete. All tests pass without
any rcu locking or memleak warnings.

David Ahern (7):
  ipv6: Move pcpu cached routes to fib6_nh
  ipv6: Refactor fib6_drop_pcpu_from
  ipv6: Refactor exception functions
  ipv6: Move exception bucket to fib6_nh
  ipv6: Make fib6_nh optional at the end of fib6_info
  ipv6: Refactor ip6_route_del for cached routes
  selftests: Add redirect tests

 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  31 +-
 include/net/ip6_fib.h                              |  17 +-
 include/net/ip6_route.h                            |   4 +-
 net/ipv6/addrconf.c                                |  10 +-
 net/ipv6/ip6_fib.c                                 |  87 ++--
 net/ipv6/ndisc.c                                   |   8 +-
 net/ipv6/route.c                                   | 452 ++++++++++++--------
 tools/testing/selftests/net/icmp_redirect.sh       | 455 +++++++++++++++++++++
 8 files changed, 820 insertions(+), 244 deletions(-)
 create mode 100755 tools/testing/selftests/net/icmp_redirect.sh

-- 
2.11.0

