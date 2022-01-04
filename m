Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D824839D7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiADBdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:33:13 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5711 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641259992; x=1672795992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KT94uZx6V4TDwxt9vnlF8ncToXDb8fgnqdULqlhRSBY=;
  b=YTawa2bFyNvoaiJ19YDwzg6QJi8gwlktaLU/bz7vUjUnkuTb2mleR1hq
   IwtFC73AkO8acZichcsGXvn43o4UUTM0dlMwqBCF/YXx64bJwcgGEuAhF
   Oz9I18rUzwhhTTFRjG3lVyuxJjVm6u+Ft7D0KGyQdaEI71nY/Z8aOtoU4
   A=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="162910724"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-9ec26c6c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Jan 2022 01:33:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-9ec26c6c.us-west-2.amazon.com (Postfix) with ESMTPS id E110242EB7;
        Tue,  4 Jan 2022 01:33:10 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/6] bpf: Batching iter for AF_UNIX sockets.
Date:   Tue, 4 Jan 2022 10:31:47 +0900
Message-ID: <20220104013153.97906-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Happy new year!

Last year the commit afd20b9290e1 ("af_unix: Replace the big lock with
small locks.") landed on bpf-next.  Now we can use a batching algorithm
for bpf unix iter as bpf tcp iter.

Note that the first patch only can be a candidate for the bpf tree.


Kuniyuki Iwashima (6):
  bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
  bpf: Add SO_RCVBUF/SO_SNDBUF in _bpf_getsockopt().
  bpf: af_unix: Use batching algorithm in bpf unix iter.
  bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
  selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
  selftest/bpf: Fix a stale comment.

 net/core/filter.c                             |   8 +
 net/unix/af_unix.c                            | 197 +++++++++++++++++-
 .../bpf/prog_tests/bpf_iter_setsockopt_unix.c | 100 +++++++++
 .../bpf/progs/bpf_iter_setsockopt_unix.c      |  60 ++++++
 .../selftests/bpf/progs/bpf_iter_unix.c       |   2 +-
 .../selftests/bpf/progs/bpf_tracing_net.h     |   2 +
 6 files changed, 361 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c

-- 
2.30.2

