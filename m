Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD7174684
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 12:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgB2LgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 06:36:10 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:31616 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2LgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 06:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582976169; x=1614512169;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=T8j3ByA2QmjSIujsgJLntP0SvfcC7xZNgCsUSXItJpg=;
  b=ninsaUK0tPkrgnGX8dV+w0Cp8ro+nRDTe1lbaYm8w7OBJvsQX2TXom9D
   PLhMirYp4o0L4mX27TCSmMu0t9qVRSpS9vgltA8n+kve5DOl3y/mxrCcq
   +iBA4o/aKpGBmxAn+4DFn1L8rByNAUa+VJLf1azGlfxZusyP0jR/ecdDA
   E=;
IronPort-SDR: JLsE6Q96/9GIVGXAYCdS5BH6AQxhnIbUKzlATcVVLwEHsdhnycG7j2BcGYnWgn+G5q/fFCuNr1
 qpgKV2t8oDlw==
X-IronPort-AV: E=Sophos;i="5.70,499,1574121600"; 
   d="scan'208";a="19148045"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 29 Feb 2020 11:36:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id A47A8A249F;
        Sat, 29 Feb 2020 11:36:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 11:36:06 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.171) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 29 Feb 2020 11:36:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v3 net-next 0/4] Improve bind(addr, 0) behaviour.
Date:   Sat, 29 Feb 2020 20:35:50 +0900
Message-ID: <20200229113554.78338-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.171]
X-ClientProxiedBy: EX13D23UWA003.ant.amazon.com (10.43.160.194) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we fail to bind sockets to ephemeral ports when all of the ports
are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
we still have a chance to connect to the different remote hosts.

The second and third patches fix the behaviour to fully utilize all space
of the local (addr, port) tuples.

---
Changes in v3:
  - Change the title and write more specific description of the 3rd patch.
  - Add a test in tools/testing/selftests/net/ as the 4th patch.

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

 net/ipv4/inet_connection_sock.c               |  36 ++--
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/reuseaddr_ports_exhausted.c | 162 ++++++++++++++++++
 .../net/reuseaddr_ports_exhausted.sh          |  33 ++++
 4 files changed, 221 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/net/reuseaddr_ports_exhausted.c
 create mode 100755 tools/testing/selftests/net/reuseaddr_ports_exhausted.sh

-- 
2.17.2 (Apple Git-113)

