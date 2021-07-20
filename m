Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DEC3D0266
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhGTTPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:15:02 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37824 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhGTTNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:13:20 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 8C20A200F4B1;
        Tue, 20 Jul 2021 21:43:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 8C20A200F4B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626810205;
        bh=I6IgflmmRTaQWt4yU6RSHdm1rnzyseL8lEZWb8d5ZUc=;
        h=From:To:Cc:Subject:Date:From;
        b=CSq2/39cLYVRj0hgX21cLjZI14z/HHGiskUvtPaolC7cigKtwUALe1vy94Do1HhE0
         3tH9rrHaDEr4zb7MxW9s4oZoPolZQl1uYjf7U8l0qNRQICztMOt4Ts24j637LUF0tO
         1bGywixNXLonbarmXRoWIlr18fQ0cpi3adKxDEEAzw2Ki24wKQuAbslf1a8WkUtGNh
         qgKYW++Z/mNynOND59VHqLE1FVplhIc/kVCcKq/DKMSkCBxeH8yxXre0s1drQQpCy3
         fnLzrPS1r8H+/2uIkoCSdhtjVtRJbgUQiZ5R6WBD2g+WTYcX3Tj6UmYlt0Ep0hdEhd
         dHEP0LuGtIUpQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, justin.iurman@uliege.be
Subject: [PATCH net-next v5 0/6] Support for the IOAM Pre-allocated Trace with IPv6
Date:   Tue, 20 Jul 2021 21:42:55 +0200
Message-Id: <20210720194301.23243-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5:
 - Refine types, min/max and default values for new sysctls
 - Introduce a "_wide" sysctl for each "ioam6_id" sysctl
 - Add more validation on headers before processing data
 - RCU for sc <> ns pointers + appropriate accessors
 - Generic Netlink policies are now per op, not per family anymore
 - Address other comments/remarks from Jakub (thanks again)
 - Revert "__packed" to "__attribute__((packed))" for uapi headers
 - Add tests to cover the functionality added, as requested by David Ahern

v4:
 - Address warnings from checkpatch (ignore errors related to unnamed bitfields
   in the first patch)
 - Use of hweight32 (thanks Jakub)
 - Remove inline keyword from static functions in C files and let the compiler
   decide what to do (thanks Jakub)

v3:
 - Fix warning "unused label 'out_unregister_genl'" by adding conditional macro
 - Fix lwtunnel output redirect bug: dst cache useless in this case, use
   orig_output instead

v2:
 - Fix warning with static for __ioam6_fill_trace_data
 - Fix sparse warning with __force when casting __be64 to __be32
 - Fix unchecked dereference when removing IOAM namespaces or schemas
 - exthdrs.c: Don't drop by default (now: ignore) to match the act bits "00"
 - Add control plane support for the inline insertion (lwtunnel)
 - Provide uapi structures
 - Use __net_timestamp if skb->tstamp is empty
 - Add note about the temporary IANA allocation
 - Remove support for "removable" TLVs
 - Remove support for virtual/anonymous tunnel decapsulation

In-situ Operations, Administration, and Maintenance (IOAM) records
operational and telemetry information in a packet while it traverses
a path between two points in an IOAM domain. It is defined in
draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
into a variety of protocols. The IPv6 encapsulation is defined in
draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
can be used to complement OAM mechanisms based on e.g. ICMP or other
types of probe packets.

This patchset implements support for the Pre-allocated Trace, carried
by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
introduced, see IANA [3]. The three other IOAM options are not included
in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
The main idea behind the IOAM Pre-allocated Trace is that a node
pre-allocates some room in packets for IOAM data. Then, each IOAM node
on the path will insert its data. There exist several interesting use-
cases, e.g. Fast failure detection/isolation or Smart service selection.
Another killer use-case is what we have called Cross-Layer Telemetry,
see the demo video on its repository [4], that aims to make the entire
stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
instead of the current L5 -> L7 limited view. So, basically, this is a
nice feature for the Linux Kernel.

This patchset also provides support for the control plane part, but only for the
inline insertion (host-to-host use case), through lightweight tunnels. Indeed,
for in-transit traffic, the solution is to have an IPv6-in-IPv6 encapsulation,
which brings some difficulties and still requires a little bit of work and
discussion (ie anonymous tunnel decapsulation and multi egress resolution).

- Patch 1: IPv6 IOAM headers definition
- Patch 2: Data plane support for Pre-allocated Trace
- Patch 3: IOAM Generic Netlink API
- Patch 4: Support for IOAM injection with lwtunnels
- Patch 5: Documentation for new IOAM sysctls
- Patch 6: Test for the IOAM insertion with IPv6

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
  [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
  [4] https://github.com/iurmanj/cross-layer-telemetry

Justin Iurman (6):
  uapi: IPv6 IOAM headers definition
  ipv6: ioam: Data plane support for Pre-allocated Trace
  ipv6: ioam: IOAM Generic Netlink API
  ipv6: ioam: Support for IOAM injection with lwtunnels
  ipv6: ioam: Documentation for new IOAM sysctls
  selftests: net: Test for the IOAM insertion with IPv6

 Documentation/networking/ioam6-sysctl.rst  |  26 +
 Documentation/networking/ip-sysctl.rst     |  17 +
 include/linux/ioam6.h                      |  13 +
 include/linux/ioam6_genl.h                 |  13 +
 include/linux/ioam6_iptunnel.h             |  13 +
 include/linux/ipv6.h                       |   3 +
 include/net/ioam6.h                        |  67 ++
 include/net/netns/ipv6.h                   |   3 +
 include/uapi/linux/in6.h                   |   1 +
 include/uapi/linux/ioam6.h                 | 133 +++
 include/uapi/linux/ioam6_genl.h            |  52 ++
 include/uapi/linux/ioam6_iptunnel.h        |  20 +
 include/uapi/linux/ipv6.h                  |   3 +
 include/uapi/linux/lwtunnel.h              |   1 +
 net/core/lwtunnel.c                        |   2 +
 net/ipv6/Kconfig                           |  11 +
 net/ipv6/Makefile                          |   3 +-
 net/ipv6/addrconf.c                        |  37 +
 net/ipv6/af_inet6.c                        |  10 +
 net/ipv6/exthdrs.c                         |  61 ++
 net/ipv6/ioam6.c                           | 910 +++++++++++++++++++++
 net/ipv6/ioam6_iptunnel.c                  | 274 +++++++
 net/ipv6/sysctl_net_ipv6.c                 |  19 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/config         |   1 +
 tools/testing/selftests/net/ioam6.sh       | 298 +++++++
 tools/testing/selftests/net/ioam6_parser.c | 403 +++++++++
 27 files changed, 2395 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/ioam6-sysctl.rst
 create mode 100644 include/linux/ioam6.h
 create mode 100644 include/linux/ioam6_genl.h
 create mode 100644 include/linux/ioam6_iptunnel.h
 create mode 100644 include/net/ioam6.h
 create mode 100644 include/uapi/linux/ioam6.h
 create mode 100644 include/uapi/linux/ioam6_genl.h
 create mode 100644 include/uapi/linux/ioam6_iptunnel.h
 create mode 100644 net/ipv6/ioam6.c
 create mode 100644 net/ipv6/ioam6_iptunnel.c
 create mode 100644 tools/testing/selftests/net/ioam6.sh
 create mode 100644 tools/testing/selftests/net/ioam6_parser.c

-- 
2.25.1

