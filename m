Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB623994B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbfFGXGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729655AbfFGXGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 19:06:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5678C206E0;
        Fri,  7 Jun 2019 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559948771;
        bh=ZAoJkbWzWhmpegnrSg6pJuohmxVZ0/ZLx1IUKsZ8l9s=;
        h=From:To:Cc:Subject:Date:From;
        b=s1CLGpVGiMfA0up73vVcSUP6lTIihhUDE54Wwi2FgSBdV7UZJPTX7MieOykg1c/BD
         eGgQW4mnZ9efbhyBgsKMSK6H1XeuobLAtgeynVlPcXr9E6i/2yh8/BycQPGIEm3ITi
         TYwaNG4/uJUpg6wuxLrsyufmsCt69HEkt4fraajM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 00/20] net: Enable nexthop objects with IPv4 and IPv6 routes
Date:   Fri,  7 Jun 2019 16:05:50 -0700
Message-Id: <20190607230610.10349-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This is the final set of the initial nexthop object work. When I
started this idea almost 2 years ago, it took 18 seconds to inject
700k+ IPv4 routes with 1 hop and about 28 seconds for 4-paths. Some
of that time was due to inefficiencies in 'ip', but most of it was
kernel side with excessive synchronize_rcu calls in ipv4, and redundant
processing validating a nexthop spec (device, gateway, encap). Worse,
the time increased dramatically as the number of legs in the routes
increased; for example, taking over 72 seconds for 16-path routes.

After this set, with increased dirty memory limits (fib_sync_mem sysctl),
an improved ip and nexthop objects a full internet fib (743,799 routes
based on a pull in January 2019) can be pushed to the kernel in 4.3
seconds. Even better, the time to insert is "almost" constant with
increasing number of paths. The 'almost constant' time is due to
expanding the nexthop definitions when generating notifications. A
follow on patch will be sent adding a sysctl that allows an admin to
avoid the nexthop expansion and truly get constant route insert time
regardless of the number of paths in a route! (Useful once all programs
used for a deployment that care about routes understand nexthop objects).

To be clear, 'ip' is used for benchmarking for no other reason than
'ip -batch' is a trivial to use for the tests. FRR, for example, better
manages nexthops and route changes and the way those are pushed to the
kernel and thus will have less userspace processing times than 'ip -batch'.

Patches 1-10 iterate over fib6_nh with a nexthop invoke a processing
function per fib6_nh. Prior to nexthop objects, a fib6_info referenced
a single fib6_nh. Multipath routes were added as separate fib6_info for
each leg of the route and linked as siblings:

    f6i -> sibling -> sibling ... -> sibling
     |                                   |
     +--------- multipath route ---------+

With nexthop objects a single fib6_info references an external
nexthop which may have a series of fib6_nh:

     f6i ---> nexthop ---> fib6_nh
                           ...
                           fib6_nh

making IPv6 routes similar to IPv4. The side effect is that a single
fib6_info now indirectly references a series of fib6_nh so the code
needs to walk each entry and call the local, per-fib6_nh processing
function.

Patches 11 and 13 wire up use of nexthops with fib entries for IPv4
and IPv6. With these commits you can actually use nexthops with routes.

Patch 12 is an optimization for IPv4 when using nexthops in the most
predominant use case (no metrics).

Patches 14 handles replace of a nexthop config.

Patches 15-18 add update pmtu and redirect tests to use both old and
new routing.

Patches 19 and 20 add new tests for the nexthop infrastructure. The first
is single nexthop is used by multiple prefixes to communicate with remote
hosts. This is on top of the functional tests already committed. The
second verifies multipath selection.

v3
- removed found arg in patch 7 and changed rt6_nh_remove_exception_rt
  to return 1 when a match is found for an exception

v2
- changed ++i to i++ in patches 1 and 14 as noticed by DaveM
- improved commit message for patch 14 (nexthop replace)
- removed the skip_fib argument to remove_nexthop; vestige of an
  older design


David Ahern (20):
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
  selftests: pmtu: Move running of test into a new function
  selftests: pmtu: Move route installs to a new function
  selftests: pmtu: Add support for routing via nexthop objects
  selftests: icmp_redirect: Add support for routing via nexthop objects
  selftests: Add test with multiple prefixes using single nexthop
  selftests: Add version of router_multipath.sh using nexthop objects

 include/net/ip6_fib.h                              |   1 +
 include/net/ip_fib.h                               |   1 +
 include/net/nexthop.h                              |   4 +
 net/ipv4/fib_frontend.c                            |  19 +
 net/ipv4/fib_semantics.c                           |  86 +++-
 net/ipv4/nexthop.c                                 | 250 ++++++++++-
 net/ipv6/ip6_fib.c                                 |  31 +-
 net/ipv6/route.c                                   | 458 +++++++++++++++++++--
 .../selftests/net/fib_nexthop_multiprefix.sh       | 290 +++++++++++++
 .../selftests/net/forwarding/router_mpath_nh.sh    | 359 ++++++++++++++++
 tools/testing/selftests/net/icmp_redirect.sh       |  49 +++
 tools/testing/selftests/net/pmtu.sh                | 237 ++++++++---
 12 files changed, 1672 insertions(+), 113 deletions(-)
 create mode 100755 tools/testing/selftests/net/fib_nexthop_multiprefix.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh.sh

-- 
2.11.0

