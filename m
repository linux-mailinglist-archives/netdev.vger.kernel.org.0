Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561D8393246
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhE0PTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:19:25 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37530 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbhE0PTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 11:19:24 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id B358C200EED1;
        Thu, 27 May 2021 17:17:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B358C200EED1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622128648;
        bh=IUEG6vTtSXRYnnEZJHe3tdYokiq2jpDRj2RLvE9ZY6g=;
        h=From:To:Cc:Subject:Date:From;
        b=MBbYdYEVu/D0epxWzSOOrvCL8uvIgG3N5tGmoLug70VxVFKzDxxGYF9C/scV+7SZb
         z+mxr9JAKjvhEJxa0F52SOosrt5KoRi2xNe4CpFVtx56kSgdH0s5mm/pKf9R81Qz25
         ihYGQmz25f+J7jCQ/uv1RsHc89rZ2Azrm6/xY+yCJtpitSEx/0k+9GVTdg59BtQCFg
         Yg5wEGRil2F3uCuerrVSEfndqotgWe0wlNu+4sjRIbXESR8Oh9VyihCxfsFdLqiy3P
         g2BhWL7hwjO1S/J8Pnl3+SzcDTeQdJwxmlffmg9zfxGUEYOWzcceylCdo+MhoSUlWc
         OqU9JH6LuuD0A==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated Trace with IPv6
Date:   Thu, 27 May 2021 17:16:47 +0200
Message-Id: <20210527151652.16074-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 include/uapi/linux/ioam6_genl.h           |  51 ++
 include/uapi/linux/ioam6_iptunnel.h       |  20 +
 include/uapi/linux/ipv6.h                 |   2 +
 include/uapi/linux/lwtunnel.h             |   1 +
 net/core/lwtunnel.c                       |   2 +
 net/ipv6/Kconfig                          |  11 +
 net/ipv6/Makefile                         |   3 +-
 net/ipv6/addrconf.c                       |  20 +
 net/ipv6/af_inet6.c                       |   7 +
 net/ipv6/exthdrs.c                        |  51 ++
 net/ipv6/ioam6.c                          | 872 ++++++++++++++++++++++
 net/ipv6/ioam6_iptunnel.c                 | 272 +++++++
 net/ipv6/sysctl_net_ipv6.c                |   7 +
 23 files changed, 1576 insertions(+), 1 deletion(-)
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

