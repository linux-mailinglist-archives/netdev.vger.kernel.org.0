Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653CE48CFAC
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiAMA3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:29:15 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:22447 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiAMA3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033753; x=1673569753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yBgJisB5ZpwsLQcplBqeaT07X7dTYfj0nOWDCQ2/9Q0=;
  b=G22mj0NjVPZ997Owsb9hIt/gir+sdW4uHXlh5vJRovK4mbmAfZhrr6G0
   5LWGHNxSNJ3r1V0oj+laVhVFhmNNj/fiDJfrDhAmdTP2GLlIDF917RC6O
   Vy9OJXgIEeJ9q9ncx/cXB/WDNbiqRs14psSwd93dtvdYUPSnrYsMNuGGG
   o=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="984423913"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 13 Jan 2022 00:29:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 4384A80418;
        Thu, 13 Jan 2022 00:29:09 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:29:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:29:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 0/5] bpf: Batching iter for AF_UNIX sockets.
Date:   Thu, 13 Jan 2022 09:28:44 +0900
Message-ID: <20220113002849.4384-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last year the commit afd20b9290e1 ("af_unix: Replace the big lock with
small locks.") landed on bpf-next.  Now we can use a batching algorithm
for AF_UNIX bpf iter as TCP bpf iter.


Changelog:
- Add the 1st patch.
- Call unix_get_first() in .start()/.next() to always acquire a lock in
  each iteration in the 2nd patch.


Kuniyuki Iwashima (5):
  af_unix: Refactor unix_next_socket().
  bpf: af_unix: Use batching algorithm in bpf unix iter.
  bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
  selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
  selftest/bpf: Fix a stale comment.

 net/unix/af_unix.c                            | 250 ++++++++++++++++--
 .../bpf/prog_tests/bpf_iter_setsockopt_unix.c | 100 +++++++
 .../bpf/progs/bpf_iter_setsockopt_unix.c      |  60 +++++
 .../selftests/bpf/progs/bpf_iter_unix.c       |   2 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   2 +
 5 files changed, 385 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c

-- 
2.30.2

