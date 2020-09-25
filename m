Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C862792D1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYVAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:00:09 -0400
Received: from mail.efficios.com ([167.114.26.124]:36156 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIYVAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:00:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8152F2D1D09;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id TpEM4a2ixKLX; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 3F6D32D1B9B;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 3F6D32D1B9B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1601064299;
        bh=ApSaXuZ31WLTM3Nl5CnN+zoa8b7EFqkF2a+Vibv2MG0=;
        h=From:To:Date:Message-Id;
        b=R8F73Up216h4fK7+NUL/avNxkzShQSSET+3g+H7MiC2avodkdt+ds9XWyXIVOaLWN
         mr6O1KRnSYL6oARSv5fVORoD6yN0AAV7zmt6R9yT9Gizx+pZ8bfAK6V+OESf+/ITcD
         Hla39ZafaSYe0cnbZ0VT+kGt22UAR+rdnbypg7Rx1kFt1x63qhVdWhVTONvraCJWiR
         QByg0AyWXp1v9ysMrKH5A+EpAUN/54GXPQbBaNIkLqqtBanGHIv5VxHtViUPBHMruU
         fQjuZLSSRm6Pe05zfXXEUwKwlDYQJF0GNcUK1+Awmrxqgp84oTZJ8D8iJTwW8oufhQ
         RbcbtX1USPDfw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hCEWx-wjMsc2; Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 106DD2D195F;
        Fri, 25 Sep 2020 16:04:59 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
Date:   Fri, 25 Sep 2020 16:04:49 -0400
Message-Id: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is an updated series of fixes for ipv4 and ipv6 which which ensure
the route lookup is performed on the right routing table in VRF
configurations when sending TTL expired icmp errors (useful for
traceroute).

It includes tests for both ipv4 and ipv6.

These fixes address specifically address the code paths involved in
sending TTL expired icmp errors. As detailed in the individual commit
messages, those fixes do not address similar icmp errors related to
network namespaces and unreachable / fragmentation needed messages,
which appear to use different code paths.

The main changes since the last round are updates to the selftests.

Thanks,

Mathieu


Mathieu Desnoyers (2):
  ipv4/icmp: l3mdev: Perform icmp error route lookup on source device
    routing table (v2)
  ipv6/icmp: l3mdev: Perform icmp error route lookup on source device
    routing table (v2)

Michael Jeanson (1):
  selftests: Add VRF route leaking tests

 net/ipv4/icmp.c                               |  23 +-
 net/ipv6/icmp.c                               |   7 +-
 net/ipv6/ip6_output.c                         |   2 -
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/vrf_route_leaking.sh        | 626 ++++++++++++++++++
 5 files changed, 653 insertions(+), 6 deletions(-)
 create mode 100755 tools/testing/selftests/net/vrf_route_leaking.sh

-- 
2.17.1

