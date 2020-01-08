Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D3E13385A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 02:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgAHBTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 20:19:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:16780 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgAHBTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 20:19:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 17:19:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,408,1571727600"; 
   d="scan'208";a="422760146"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.8.166])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 17:19:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v6 00/11] Multipath TCP: Prerequisites
Date:   Tue,  7 Jan 2020 17:19:10 -0800
Message-Id: <20200108011921.28942-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5 -> v6: Fix BPF accessors for sk_type and sk_protocol (patch 2), fix
the width of an __unused bitfield (patch 6), and add some commit message
and comment text (patches 5 & 7).

v4 -> v5: Cover letter subject fix. No changes to commits.

v3 -> v4: Update coalesce/collapse of incoming MPTCP skbs (patch 7)

v2 -> v3: Ensure sk_type alignment in struct sock (patch 2)

v1 -> v2: sk_pacing_shift left as a regular struct member (patch 2), and
modified SACK space check based on recent -net fix (patch 9).


The MPTCP upstreaming community has been collaborating on an
upstreamable MPTCP implementation that complies with RFC 8684. A minimal
set of features to comply with the specification involves a sizeable set
of code changes, so David requested that we split this work in to
multiple, smaller patch sets to build up MPTCP infrastructure.

The minimal MPTCP feature set we are proposing for review in the v5.6
timeframe begins with these three parts:

Part 1 (this patch set): MPTCP prerequisites. Introduce some MPTCP
definitions, additional ULP and skb extension features, TCP option space
checking, and a few exported symbols.

Part 2: Single subflow implementation and self tests.

Part 3: Switch from MPTCP v0 (RFC 6824) to MPTCP v1 (new RFC 8684,
publication expected in the next few days).

Additional patches for multiple subflow support, path management, active
backup, and other features are in the pipeline for submission after
making progress with the above reviews.

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-v6-part1)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-v6-part1

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Mat Martineau (9):
  net: Make sock protocol value checks more specific
  sock: Make sk_protocol a 16-bit value
  tcp: Define IPPROTO_MPTCP
  tcp: Add MPTCP option number
  tcp, ulp: Add clone operation to tcp_ulp_ops
  mptcp: Add MPTCP to skb extensions
  tcp: coalesce/collapse must respect MPTCP extensions
  tcp: Export TCP functions and ops struct
  tcp: Check for filled TCP option space before SACK

Paolo Abeni (2):
  tcp: clean ext on tx recycle
  skb: add helpers to allocate ext independently from sk_buff

 MAINTAINERS                     | 10 ++++
 include/linux/skbuff.h          |  6 +++
 include/net/mptcp.h             | 85 +++++++++++++++++++++++++++++++++
 include/net/sock.h              | 27 +++--------
 include/net/tcp.h               | 22 +++++++++
 include/trace/events/sock.h     |  5 +-
 include/uapi/linux/in.h         |  2 +
 net/ax25/af_ax25.c              |  2 +-
 net/core/filter.c               | 60 +++++++++--------------
 net/core/skbuff.c               | 42 +++++++++++++++-
 net/decnet/af_decnet.c          |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +
 net/ipv4/tcp.c                  |  6 +--
 net/ipv4/tcp_input.c            | 11 +++--
 net/ipv4/tcp_ipv4.c             |  2 +-
 net/ipv4/tcp_output.c           | 12 +++--
 net/ipv4/tcp_ulp.c              | 12 +++++
 net/ipv6/tcp_ipv6.c             |  6 +--
 tools/include/uapi/linux/in.h   |  2 +
 19 files changed, 237 insertions(+), 79 deletions(-)
 create mode 100644 include/net/mptcp.h

-- 
2.24.1

