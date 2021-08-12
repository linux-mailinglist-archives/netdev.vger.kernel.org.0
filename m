Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321893EA8AF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhHLQqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:46:44 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10384 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhHLQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628786778; x=1660322778;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ycxoFeaBELcdmGM0X/rv4plXoec2fOvTxJKPjKags8k=;
  b=VW1r0fz0BEwJCgwJlT4Mm9CvEZ1GZu7UEsz+YJX/3G6U10jkbriVEia5
   DpQjqPPQspNy2uY4Bic71rFJ4bGCtqeDw+VPL3d/MXeRiRzggSwIQf+/N
   UiG55RzYNdMggWInRasVrjWnrclx7XjtGGGrBo56DX99YHmLmTDM4MKpo
   s=;
X-IronPort-AV: E=Sophos;i="5.84,316,1620691200"; 
   d="scan'208";a="133517682"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 Aug 2021 16:46:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 283C8A07B2;
        Thu, 12 Aug 2021 16:46:15 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:09 +0000
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
Subject: [PATCH v5 bpf-next 0/4] BPF iterator for UNIX domain socket.
Date:   Fri, 13 Aug 2021 01:45:53 +0900
Message-ID: <20210812164557.79046-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it, and the second adds "%c" support for BPF_SEQ_PRINTF().


Changelog:
  v5:
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
 tools/testing/selftests/bpf/README.rst        | 38 ++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 .../selftests/bpf/prog_tests/snprintf.c       |  4 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 .../selftests/bpf/progs/test_snprintf.c       |  7 +-
 10 files changed, 259 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

