Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65AA207C3C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406216AbgFXTdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:33:20 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46268 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405573AbgFXTdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:33:17 -0400
Received: from ubuntu18.lan (unknown [109.129.49.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id D52D5200CCE9;
        Wed, 24 Jun 2020 21:24:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be D52D5200CCE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593026658;
        bh=pzaZwYYeIGCkD6rKoc96ax3ynbONk+x7q4BqOuBV2pg=;
        h=From:To:Cc:Subject:Date:From;
        b=oERTpmResKAoIY5oB/wsLSaefObnYHqe9j35Jdgg4SGZwbRCawHjy8hv2+AQxBwsG
         JaUkW/Z4heNBteegxYU29sDw5uc1lj3zJ9WC9QpQ2ZBZIG7n6mNaFm+5aR4FmiTYWg
         2+X1zNwGSQkUqBxc/xE58hUhOruEHqkmDk4YRyDFaiS3rJL9zroE9Df+RR6I/+w4pv
         e4Avz9VNIgnCcHLvBl/gAEcuAt2Zx3Qpo7HWsMw3fAH4HXGLD/h7sdWdppZMtsoYMq
         bKIP3O9wAKcAerQf5ib8ZHpmFD4ppgFxGV4W3fLFw/HCuCPryiY81yLFC2cayCQ7sM
         1dQB/sGiwdF2g==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, justin.iurman@uliege.be
Subject: [PATCH net-next 0/5] Data plane support for IOAM Pre-allocated Trace with IPv6 
Date:   Wed, 24 Jun 2020 21:23:05 +0200
Message-Id: <20200624192310.16923-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In-situ Operations, Administration, and Maintenance (IOAM) records
operational and telemetry information in a packet while it traverses
a path between two points in an IOAM domain. It is defined in
draft-ietf-ippm-ioam-data-09 [1]. IOAM data fields can be encapsulated
into a variety of protocols. The IPv6 encapsulation is defined in
draft-ietf-ippm-ioam-ipv6-options-01 [2], via extension headers. IOAM
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

IOAM options must be 4n-aligned. Here is how a Hop-by-Hop looks like
with IOAM:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Next header  |  Hdr Ext Len  |    Padding    |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Option Type  |  Opt Data Len |    Reserved   |   IOAM Type   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Namespace-ID          | NodeLen | Flags | RemainingLen|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                IOAM-Trace-Type                |    Reserved   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+<-+
|                                                               |  |
|                         node data [0]                         |  |
|                                                               |  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  D
|                                                               |  a
|                         node data [1]                         |  t
|                                                               |  a
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~                             ...                               ~  S
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  p
|                                                               |  a
|                         node data [n-1]                       |  c
|                                                               |  e
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
|                                                               |  |
|                         node data [n]                         |  |
|                                                               |  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+<-+

Namespace-ID represents an IOAM namespace identifier, not to be confused
with Linux namespaces. IOAM namespaces add further context to IOAM
options and associated data, and allow devices which are IOAM capable to
determine whether IOAM needs to be processed, updated or removed. They
can also be used by an operator to distinguish different operational
domains or to identify different sets of devices. Other fields are also
explained in [1] and [2].

This patchset does not provide support for the control plane part, ie
the IOAM encapsulation or inline insertion (ingress node behavior). It
will come as another patch since some design choices still need to be
discussed (talk @ Netdev 0x14). Globally, this patchset contains:

- Patch 1-3: Data plane support for the IOAM Pre-allocated Trace
- Patch 4:   Generic Netlink to configure IOAM from userspace (iproute2)
- Patch 5:   IOAM sysctls documentation

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data-09
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options-01
  [3] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
  [4] https://github.com/iurmanj/cross-layer-telemetry

Justin Iurman (5):
  ipv6: eh: Introduce removable TLVs
  ipv6: IOAM tunnel decapsulation
  ipv6: ioam: Data plane support for Pre-allocated Trace
  ipv6: ioam: Generic Netlink to configure IOAM
  ipv6: ioam: Documentation for new IOAM sysctls

 Documentation/networking/ioam6-sysctl.rst |  20 +
 Documentation/networking/ip-sysctl.rst    |   5 +
 include/linux/ioam6.h                     |   7 +
 include/linux/ipv6.h                      |   3 +
 include/net/ioam6.h                       |  98 +++
 include/net/netns/ipv6.h                  |   2 +
 include/uapi/linux/in6.h                  |   1 +
 include/uapi/linux/ioam6.h                |  43 ++
 include/uapi/linux/ipv6.h                 |   2 +
 net/ipv6/Makefile                         |   2 +-
 net/ipv6/addrconf.c                       |  20 +
 net/ipv6/af_inet6.c                       |   7 +
 net/ipv6/exthdrs.c                        | 201 +++++-
 net/ipv6/ioam6.c                          | 839 ++++++++++++++++++++++
 net/ipv6/ip6_input.c                      |  22 +
 net/ipv6/sysctl_net_ipv6.c                |   7 +
 16 files changed, 1252 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/networking/ioam6-sysctl.rst
 create mode 100644 include/linux/ioam6.h
 create mode 100644 include/net/ioam6.h
 create mode 100644 include/uapi/linux/ioam6.h
 create mode 100644 net/ipv6/ioam6.c

-- 
2.17.1

