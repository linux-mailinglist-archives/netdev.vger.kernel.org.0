Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958BB3DE3DB
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 03:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhHCBLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 21:11:47 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:28564 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhHCBLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 21:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1627953096; x=1659489096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N1isNZVJRBvugRdsDdMgy3ggx2Dx8o/q+iel02p4buQ=;
  b=qSL4+h3RQEKTRgThhRVGEQY2LBJeVSK78O7JGy84e4w+4aL0/ly+tDUW
   9PqJC8ciW3rRpPoH8JLYFYHK54w3ANV8A3q5ueoTAZ4P0UuhCfevWduVR
   Tl6pZw5z9403kj7yv6V4fQjFvh5RArUOucS6Gt3LkebsLHTQKlcO28i6E
   c=;
X-IronPort-AV: E=Sophos;i="5.84,290,1620691200"; 
   d="scan'208";a="947875968"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 03 Aug 2021 01:11:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id D6A0FA1E1D;
        Tue,  3 Aug 2021 01:11:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 3 Aug 2021 01:11:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.186) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 3 Aug 2021 01:11:25 +0000
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
Subject: [PATCH v2 bpf-next 0/2] BPF iterator for UNIX domain socket.
Date:   Tue, 3 Aug 2021 10:11:08 +0900
Message-ID: <20210803011110.21205-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D44UWC001.ant.amazon.com (10.43.162.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it and the second adds a selftest.


Changelog:
  v2:
  - Implement bpf_iter specific seq_ops->stop()
  - Add bpf_iter__unix in bpf_iter.h
  - Move common definitions in selftest to bpf_tracing_net.h
  - Include the code for abstract UNIX domain socket as comment in selftest
  - Use ASSERT_OK_PTR() instead of CHECK()
  - Make ternary operators on single line

  v1:
  https://lore.kernel.org/netdev/20210729233645.4869-1-kuniyu@amazon.co.jp/


Kuniyuki Iwashima (2):
  bpf: af_unix: Implement BPF iterator for UNIX domain socket.
  selftest/bpf: Implement sample UNIX domain socket iterator program.

 include/linux/btf_ids.h                       |  3 +-
 net/unix/af_unix.c                            | 93 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 6 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

