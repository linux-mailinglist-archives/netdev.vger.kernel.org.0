Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03EF3E56D8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhHJJ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:29:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:51658 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbhHJJ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628587715; x=1660123715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9Bxh8ry/x1tZrHm+L6QtJtWoPAnis2YRJ0zchf9s+fA=;
  b=S5K6eAC1eiUuFUvSSVj6UHDcq8kutwGRuFtuocHxKzX0/a7kgIkhT4WO
   uYf3PVY5HTHz5btKRyLyex77xlFBP59MDxLUdwW9CPRoO72TCocFJBVdd
   DV6xxzvWUUECjcgGyPdbnAfj/aMQ32mYgQDzsCCYosMcLIjHTFiNCCrro
   w=;
X-IronPort-AV: E=Sophos;i="5.84,310,1620691200"; 
   d="scan'208";a="131372390"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 10 Aug 2021 09:28:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 271D2A0507;
        Tue, 10 Aug 2021 09:28:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 10 Aug 2021 09:28:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.189) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 10 Aug 2021 09:28:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 0/3] BPF iterator for UNIX domain socket.
Date:   Tue, 10 Aug 2021 18:28:04 +0900
Message-ID: <20210810092807.13190-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.189]
X-ClientProxiedBy: EX13D08UWC001.ant.amazon.com (10.43.162.110) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it, the second adds "%c" support for BPF_SEQ_PRINTF(), and
the third adds a selftest.


Changelog:
  v4:
  - Check IS_BUILTIN(CONFIG_UNIX)
  - Support "%c" in BPF_SEQ_PRINTF()
  - Uncomment the code to print the name of the abstract socket
  - Mention the LLVM fix in README.rst
  - Remove the 'aligned' attribute in bpf_iter.h
  - Keep the format string on a single line

  v3:
  https://lore.kernel.org/netdev/20210804070851.97834-1-kuniyu@amazon.co.jp/
  - Export some functions for CONFIG_UNIX=m

  v2:
  https://lore.kernel.org/netdev/20210803011110.21205-1-kuniyu@amazon.co.jp/
  - Implement bpf_iter specific seq_ops->stop()
  - Add bpf_iter__unix in bpf_iter.h
  - Move common definitions in selftest to bpf_tracing_net.h
  - Include the code for abstract UNIX domain socket as comment in selftest
  - Use ASSERT_OK_PTR() instead of CHECK()
  - Make ternary operators on single line

  v1:
  https://lore.kernel.org/netdev/20210729233645.4869-1-kuniyu@amazon.co.jp/


Kuniyuki Iwashima (3):
  bpf: af_unix: Implement BPF iterator for UNIX domain socket.
  bpf: Support "%c" in bpf_bprintf_prepare().
  selftest/bpf: Implement sample UNIX domain socket iterator program.

 include/linux/btf_ids.h                       |  3 +-
 kernel/bpf/helpers.c                          | 14 +++
 net/unix/af_unix.c                            | 93 +++++++++++++++++++
 tools/testing/selftests/bpf/README.rst        | 38 ++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 8 files changed, 252 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

