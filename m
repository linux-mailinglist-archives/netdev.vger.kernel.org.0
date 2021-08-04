Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21E3DFBCD
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhHDHJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:09:43 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:36963 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbhHDHJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 03:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628060971; x=1659596971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vf6Rg7oLPv3qq9V1+kVcgExSPcT2S4l7Ka57kMZ46xg=;
  b=aKgcYEN3L+9OW7hWVOjtRTs2VHz8sRWsnKHeMYu1c6ofFvm/Joxn1hlX
   V9MUW0gT0wkPnTEkWy20g3Q24VsSFP4sBF6T4UgZbM89t5pahrpm5kZml
   RMvX7DvmFcLJncffC4SasAeiqDAbOJoji44Hn2Ut012Qg6fVRKSkWjSGK
   k=;
X-IronPort-AV: E=Sophos;i="5.84,293,1620691200"; 
   d="scan'208";a="150194884"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 04 Aug 2021 07:09:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 801C8A1D4C;
        Wed,  4 Aug 2021 07:09:27 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 4 Aug 2021 07:09:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.175) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 4 Aug 2021 07:09:20 +0000
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
Subject: [PATCH v3 bpf-next 0/2] BPF iterator for UNIX domain socket.
Date:   Wed, 4 Aug 2021 16:08:49 +0900
Message-ID: <20210804070851.97834-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D17UWB001.ant.amazon.com (10.43.161.252) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BPF iterator support for UNIX domain socket.  The first
patch implements it and the second adds a selftest.


Changelog:
  v3:
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


Kuniyuki Iwashima (2):
  bpf: af_unix: Implement BPF iterator for UNIX domain socket.
  selftest/bpf: Implement sample UNIX domain socket iterator program.

 fs/proc/proc_net.c                            |  2 +
 include/linux/btf_ids.h                       |  3 +-
 kernel/bpf/bpf_iter.c                         |  3 +
 net/core/filter.c                             |  1 +
 net/unix/af_unix.c                            | 93 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
 .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
 9 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c

-- 
2.30.2

