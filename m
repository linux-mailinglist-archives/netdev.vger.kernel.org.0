Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5534744F5E2
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhKNB1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:27:40 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:25455 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNB1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853085; x=1668389085;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nyzm3+5vT7P0eb0IfnU1i68s/FVCXfDHplQTC1uuPWs=;
  b=cnBCuTK7cY5rwHfIR3L3LX2o+DXuhtAYAuBYRpVyKOc5z+OctD051XfX
   hDAe6kPruepfyo4sHPzmpoqGF+EHxv3JuN/2gH13ii6hiM3klhLDV+eNW
   K+49uSoqchFNDthpgdfAi7ijrmxIMAvB8igkGl+TQEbeKn9TtqH+Q7Nhw
   s=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="41264170"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-cb1ffea5.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Nov 2021 01:24:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-cb1ffea5.us-west-2.amazon.com (Postfix) with ESMTPS id 46B7C60E5B;
        Sun, 14 Nov 2021 01:24:46 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:24:45 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:24:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 00/13] af_unix: Replace unix_table_lock with per-hash locks.
Date:   Sun, 14 Nov 2021 10:24:15 +0900
Message-ID: <20211114012428.81743-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.241]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hash table of AF_UNIX sockets is protected by a single big lock,
unix_table_lock.  This series replaces it with small per-hash locks.

1st -  2nd : Misc refactoring
3rd -  8th : Separate BSD/abstract address logics
9th - 11th : Prep to save a hash in each socket
12th       : Replace the big lock
13th       : Speed up autobind()

After this series land in bpf-next, I will post another series to support
bpf batching iteration and bpf_(get|set)sockopt for AF_UNIX sockets.


Changelog:
  v2:
    12th: Use spin_lock_nested() (kernel test robot)
    13th: Avoid infinite loop (Eric Dumazet)
    13th: s/initnum/lastnum/

  v1:
  https://lore.kernel.org/netdev/20211106091712.15206-1-kuniyu@amazon.co.jp/


Kuniyuki Iwashima (13):
  af_unix: Use offsetof() instead of sizeof().
  af_unix: Pass struct sock to unix_autobind().
  af_unix: Factorise unix_find_other() based on address types.
  af_unix: Return an error as a pointer in unix_find_other().
  af_unix: Cut unix_validate_addr() out of unix_mkname().
  af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
  af_unix: Remove unix_mkname().
  af_unix: Allocate unix_address in unix_bind_(bsd|abstract)().
  af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
  af_unix: Add helpers to calculate hashes.
  af_unix: Save hash in sk_hash.
  af_unix: Replace the big lock with small locks.
  af_unix: Relax race in unix_autobind().

 include/net/af_unix.h                         |   3 +-
 net/unix/af_unix.c                            | 555 ++++++++++--------
 net/unix/diag.c                               |  23 +-
 .../selftests/bpf/progs/bpf_iter_unix.c       |   2 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   2 -
 .../bpf/progs/test_skc_to_unix_sock.c         |   2 +-
 6 files changed, 333 insertions(+), 254 deletions(-)

-- 
2.30.2

