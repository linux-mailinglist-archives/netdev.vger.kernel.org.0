Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B890D3343D7
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhCJQyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:54:52 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:39642 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbhCJQyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:54:24 -0500
Received: from localhost.localdomain (142.6-244-81.adsl-dyn.isp.belgacom.be [81.244.6.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 23D9F200F4B6;
        Wed, 10 Mar 2021 17:45:25 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 23D9F200F4B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1615394725;
        bh=SnMovqgMyPXebWRcmTp0cNhTpIgbP0zt2ma/YdqPElI=;
        h=From:To:Cc:Subject:Date:From;
        b=tSDzZSBuDvCOttTkHrFI3Nlhncmbm0vFdyifwfOsmpi+SYFPZ7HedWwftYgKCPUvK
         6acUBDegIlKIGJiJAD6+N1SjZlz8mzxC8wxUGF77YIQI5EQ/VPh+vx5uqvJqxCymhi
         sOQW1z1pz44TJ2Kd7wTZJcYe6IH6TyfdNtKhGISmWy2td+xfCgLMZnGt37iLpmYp1v
         o4vyM6VHTcntvbKqTLj6Nitz3pxeMSbLRJ6pj/HaxfWLmwZ8ZUEZiDwdWzk/vFQkp1
         jI+qTN4g6QhM32xYeocYEhJcbciMVYGMdyeNz5SiVPinBUCt+AEpgH60oqS2TXrBe7
         8Yb2+1V2AAkIA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [PATCH net-next 0/5] Support for the IOAM Pre-allocated Trace with IPv6
Date:   Wed, 10 Mar 2021 17:44:34 +0100
Message-Id: <20210310164439.24933-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
  [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
  [4] https://github.com/iurmanj/cross-layer-telemetry


Justin Iurman (5):
  uapi: IPv6 IOAM headers definition
  ipv6: ioam: Data plane support for Pre-allocated Trace
  ipv6: ioam: IOAM Generic Netlink API
  ipv6: ioam: Support for IOAM injection with lwtunnels
  ipv6: ioam: Documentation for new IOAM sysctls

 Documentation/networking/ioam6-sysctl.rst |  20 +
 Documentation/networking/ip-sysctl.rst    |   5 +
 include/linux/ioam6.h                     |  13 +
 include/linux/ioam6_genl.h                |  13 +
 include/linux/ioam6_iptunnel.h            |  13 +
 include/linux/ipv6.h                      |   2 +
 include/net/ioam6.h                       |  65 ++
 include/net/netns/ipv6.h                  |   2 +
 include/uapi/linux/in6.h                  |   1 +
 include/uapi/linux/ioam6.h                | 124 +++
 include/uapi/linux/ioam6_genl.h           |  49 ++
 include/uapi/linux/ioam6_iptunnel.h       |  19 +
 include/uapi/linux/ipv6.h                 |   2 +
 include/uapi/linux/lwtunnel.h             |   1 +
 net/core/lwtunnel.c                       |   2 +
 net/ipv6/Kconfig                          |  11 +
 net/ipv6/Makefile                         |   3 +-
 net/ipv6/addrconf.c                       |  20 +
 net/ipv6/af_inet6.c                       |   7 +
 net/ipv6/exthdrs.c                        |  51 ++
 net/ipv6/ioam6.c                          | 870 ++++++++++++++++++++++
 net/ipv6/ioam6_iptunnel.c                 | 261 +++++++
 net/ipv6/sysctl_net_ipv6.c                |   7 +
 23 files changed, 1560 insertions(+), 1 deletion(-)
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

-- 
2.17.1

