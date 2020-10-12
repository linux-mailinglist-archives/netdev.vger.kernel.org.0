Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975DC28BB5A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbgJLOud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:50:33 -0400
Received: from mail.efficios.com ([167.114.26.124]:60656 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388863AbgJLOub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:50:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id ABF362EA059;
        Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ylX4YACMqMz3; Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4AA842EA307;
        Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4AA842EA307
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1602514230;
        bh=6JJLYbIiDsurP4dRMWEhOsV6YojXCxj+vo9sq1iAj6I=;
        h=From:To:Date:Message-Id;
        b=fUWGyVTxyPs4lbHyk7pjmgzyk2arFqDKtTlB5mTNe1DaYbQLCevUJwdKM5it3u4UI
         JAjfRc9MRtBt69azHzPd18xDSmnSFibSo/KJG+L68AHxJy7LI8jIlJzqXcphe2Ze+i
         GejBW7kvvKK7HES6Qn408kH2eRXwwSo+YaQgGjzRh3FT4QCNMUWLs7SJh4ttLSOv7Z
         3xzSoKvq90KYwYkEanRFzZbsp3uYb4hi7fqHzLs0TG/F7hhy0TyEgAiGCmfZGlArUK
         qI+Slm1vUiQl0ZUDI1I5cZY+7KOXnCczm0+UCo3vIMUiAeFyN3Laq0rjuHDww2CrZI
         Ee4AGl0owmElQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1qmbUD9q-rZs; Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 153142E9FD5;
        Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 0/3] l3mdev icmp error route lookup fixes
Date:   Mon, 12 Oct 2020 10:50:13 -0400
Message-Id: <20201012145016.2023-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is a series of fixes for ipv4 and ipv6 which ensure the route
lookup is performed on the right routing table in VRF configurations
when sending TTL expired icmp errors (useful for traceroute).

It includes tests for both ipv4 and ipv6.

These fixes address specifically address the code paths involved in
sending TTL expired icmp errors. As detailed in the individual commit
messages, those fixes do not address similar icmp errors related to
network namespaces and unreachable / fragmentation needed messages,
which appear to use different code paths.

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

