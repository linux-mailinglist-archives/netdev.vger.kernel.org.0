Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2B17F16A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgCJIFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:05:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:58753 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgCJIFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 04:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583827542; x=1615363542;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ytHGqiibIS7fWIevAbDphFoAyu3lEuW4JF4/3ENjfxU=;
  b=jfoWgsHA4rolPIwagb4XT6aLtuw7etbAk9rYSkIwRfJxLQXLG8r2nsGs
   jBXuYIg0ZbjVMNabcQmWYobFh530jnV09fUIRE8vTY/jl+CncElGLXNKV
   mrs1JpcI+dnFv4l6YliZ4JWcTdOg3a3RzzSKC1l0mA+jHM1hkjMsrv5b3
   g=;
IronPort-SDR: SO/pCaoVa9j92EXsvFdD8EZxkEUt07Hiwwc20iJVxVT9SdCm5A0Xadg+8iyfQqjS26qcJl5+9M
 PBrPa1G8WH6w==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="21907546"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Mar 2020 08:05:41 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 96565A2942;
        Tue, 10 Mar 2020 08:05:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 08:05:38 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.16) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 08:05:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v5 net-next 0/4] Improve bind(addr, 0) behaviour.
Date:   Tue, 10 Mar 2020 17:05:23 +0900
Message-ID: <20200310080527.70180-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.16]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
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
Changes in v5:
  - Add more description to documents.
  - Fix sysctl option to use proc_dointvec_minmax.
  - Remove the Fixes: tag and squash two commits.

Changes in v4:
  - Add net.ipv4.ip_autobind_reuse option to not change the current behaviour.
  - Modify .gitignore for test.
  https://lore.kernel.org/netdev/20200308181615.90135-1-kuniyu@amazon.co.jp/

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

Kuniyuki Iwashima (4):
  tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
  tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports
    are exhausted.
  tcp: Forbid to bind more than one sockets haveing SO_REUSEADDR and
    SO_REUSEPORT per EUID.
  selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully
    utilized.

 Documentation/networking/ip-sysctl.txt        |   9 +
 include/net/netns/ipv4.h                      |   1 +
 net/ipv4/inet_connection_sock.c               |  36 ++--
 net/ipv4/sysctl_net_ipv4.c                    |   9 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/reuseaddr_ports_exhausted.c | 162 ++++++++++++++++++
 .../net/reuseaddr_ports_exhausted.sh          |  35 ++++
 8 files changed, 243 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/net/reuseaddr_ports_exhausted.c
 create mode 100755 tools/testing/selftests/net/reuseaddr_ports_exhausted.sh

-- 
2.17.2 (Apple Git-113)

