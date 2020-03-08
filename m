Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8302F17D56D
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 19:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCHSQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 14:16:49 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6495 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgCHSQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 14:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583691408; x=1615227408;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Nglh4/2ggGVmJfU8RTqy7V/eyOKS/m46jNEmBQZZp3o=;
  b=RHOewjaOQNi5cJ5o8smwgIvIW+xn5nfoxMlWoW/NWoDNeFCyIum1z2fo
   TWorT/29an7cunXUsxaht1HsC5oI/2o6bR6k87ljmUVKdiz3UO/InX0QK
   dq1L6nB8pYhgrCCUr+o0ecX1wA5aQoqmOjoI76mrHRyJ6+iDMP8XxUg/R
   M=;
IronPort-SDR: oYWJbWknjmZZ8cI3BbadVUW5a7nHfRcOwciS7+rBN6iiDitlyZZnIMStMgmrxchoeykU513+Sn
 hPpJW8n4Hylg==
X-IronPort-AV: E=Sophos;i="5.70,530,1574121600"; 
   d="scan'208";a="20275339"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Mar 2020 18:16:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 257B9A24D9;
        Sun,  8 Mar 2020 18:16:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Mar 2020 18:16:29 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.100) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 8 Mar 2020 18:16:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v4 net-next 0/5] Improve bind(addr, 0) behaviour.
Date:   Mon, 9 Mar 2020 03:16:10 +0900
Message-ID: <20200308181615.90135-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we fail to bind sockets to ephemeral ports when all of the ports
are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
we still have a chance to connect to the different remote hosts.

These patches add net.ipv4.ip_autobind_reuse option and fix the behaviour
to fully utilize all space of the local (addr, port) tuples.

---
Changes in v4:
  - Add net.ipv4.ip_autobind_reuse option to not change the current behaviour.
  - Modify .gitignore for test.

Changes in v3:
  - Change the title and write more specific description of the 3rd patch.
  - Add a test in tools/testing/selftests/net/ as the 4th patch.
  https://lore.kernel.org/netdev/20200229113554.78338-1-kuniyu@amazon.co.jp/

Changes in v2:
  - Change the description of the 2nd patch ('localhost' -> 'address').
  - Correct the description and the if statement of the 3rd patch.
  https://lore.kernel.org/netdev/20200226074631.67688-1-kuniyu@amazon.co.jp/

v1 with tests:
  https://lore.kernel.org/netdev/20200220152020.13056-1-kuniyu@amazon.co.jp/
---

Kuniyuki Iwashima (5):
  tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
  tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports
    are exhausted.
  tcp: Forbid to bind more than one sockets haveing SO_REUSEADDR and
    SO_REUSEPORT per EUID.
  net: Add net.ipv4.ip_autobind_reuse option.
  selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully
    utilized.

 Documentation/networking/ip-sysctl.txt        |   7 +
 include/net/netns/ipv4.h                      |   1 +
 net/ipv4/inet_connection_sock.c               |  36 ++--
 net/ipv4/sysctl_net_ipv4.c                    |   7 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/reuseaddr_ports_exhausted.c | 162 ++++++++++++++++++
 .../net/reuseaddr_ports_exhausted.sh          |  35 ++++
 8 files changed, 239 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/net/reuseaddr_ports_exhausted.c
 create mode 100755 tools/testing/selftests/net/reuseaddr_ports_exhausted.sh

-- 
2.17.2 (Apple Git-113)

