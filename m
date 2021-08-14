Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC503EBF75
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhHNB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:58:14 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:33696 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhHNB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628906267; x=1660442267;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rWGa6VoVBJO0Tg7YabuMr7xq7VCnbE6WY5UBCs1lIDQ=;
  b=AHir3tAvFGRZ6Yhw9COTsoqZTl3XMkHs3ZhgKjsRWyI2Wc1ZDuimlWUG
   2WY/VIgXWI4AfA1EDlORdQ3BDRjpIn0hWUi6le96jd5/Wyn8rXl0+cdNu
   89Qi2HLcHL1tnUZ9u++A16afxEgwMZZpGSsa073FYJfGsqmah6kEH962o
   c=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="19215681"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 14 Aug 2021 01:57:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 6D8032407BE;
        Sat, 14 Aug 2021 01:57:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:57:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:57:35 +0000
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
Subject: [PATCH v6 bpf-next 0/4] BPF iterator for UNIX domain socket.
Date:   Sat, 14 Aug 2021 10:57:14 +0900
Message-ID: <20210814015718.42704-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it, and the second adds "%c" support for BPF_SEQ_PRINTF().

Thanks to Yonghong Song for the fix [0] for the LLVM code gen.  The fix
prevents the LLVM compiler from transforming the loop exit condition '<' to
'!=', where the upper bound is not a constant.  The transformation leads
the verifier to interpret it as an infinite loop.

And thanks to Andrii Nakryiko for its workaround [1].

[0] https://reviews.llvm.org/D107483
[1] https://lore.kernel.org/netdev/CAEf4BzZ3sVx1m1mOCcPcuVPiY6cWEAO=6VGHDiXEs9ZVD-RoLg@mail.gmail.com/


Changelog:
  v6:
  - Align the header "Inde" column
  - Change int vars to __u64 not to break test_progs-no_alu32
  - Move the if statement into the for loop not to depend on the fix [0]
  - Drop the README change
  - Modify "%c" positive test patterns

  v5:
  https://lore.kernel.org/netdev/20210812164557.79046-1-kuniyu@amazon.co.jp/
  - Align header line of bpf_iter_unix.c
  - Add test for "%c"

  v4:
  https://lore.kernel.org/netdev/20210810092807.13190-1-kuniyu@amazon.co.jp/
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


Kuniyuki Iwashima (4):
  bpf: af_unix: Implement BPF iterator for UNIX domain socket.
  bpf: Support "%c" in bpf_bprintf_prepare().
  selftest/bpf: Implement sample UNIX domain socket iterator program.
  selftest/bpf: Extend the bpf_snprintf() test for "%c".

 include/linux/btf_ids.h                       |  3 +-
 kernel/bpf/helpers.c                          | 14 +++
 net/unix/af_unix.c                            | 93 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 .../selftests/bpf/prog_tests/snprintf.c       |  4 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 80 ++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 .../selftests/bpf/progs/test_snprintf.c       |  6 +-
 9 files changed, 223 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

