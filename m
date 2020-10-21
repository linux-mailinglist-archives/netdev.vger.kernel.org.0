Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F14295218
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504006AbgJUSUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503991AbgJUSUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:20:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F4AC0613CE;
        Wed, 21 Oct 2020 11:20:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so1962932pgt.8;
        Wed, 21 Oct 2020 11:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=B9MhHCAAHPcD+y4BjpxYMfmOMONf3nd959tG9AXqEms=;
        b=uja448HnGbNV/EVsA7qHZu7ZN5QdXgfMz9r3XizHyjIe0cQdCvO520aIzP7vNdtgpn
         T3BP+sCr+Vxaa/o1aDJckcsEqKZ1+1pV7WUismWH2sBhb/BKH2Y5/CvzceHV1BzOD3er
         I4bweGLIO/hvqvematbcKIjDgJgqMKVvyuG9jlAKXtg1G7uihmM025mwolVr4w8+JNS/
         /xhampPxqH2y7LxOVIB73ZhM9mkZdzH0BEHGs7anDFZiRI17v8V6je2bg023YgEg30NB
         NIGtt4bwQzizpdJAclLbbj0eDKKAeDdBgJKjJxguqktNoPW/ZQ+b5lGA2KFKuFJjWDo8
         xcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B9MhHCAAHPcD+y4BjpxYMfmOMONf3nd959tG9AXqEms=;
        b=cJ53Z/PpAF/b6VaOmD30L5SDoZGdWuNrHNJ5qztIBPEDSfLPK4GYbgJAsvz289tN3s
         JodpIYxRXkb9CbXavV0LPW+eZW0aUyG9fducNOgoo7AeBLr2x5EJ7qEMqgpWJ48mLf3c
         oOtuG198ht/QbsgIfXDNUJPBtJ6CpoY8x6CvzJ3dfZPceqlv9ohk05GKmZ97exXIHVni
         ovX39j7iiY0vpIMDiQU7Iu8V2GoeFJzqiBvjjsDIe4CYg3U6oYJluQTY+pIWSWN8O9v0
         5UE5SEtcVbQflWvZbkfiVdV0XUXuLOn8/Bn/spTLevZD+IOOsiEkWmwb6ePuredEO1Hx
         hw+g==
X-Gm-Message-State: AOAM530r1WrHr32VS8fZOQr0oJmFbRwOFh7q7vjiN3EiX7HCu/qHfbwS
        eOPCBBl6KLKLJ37gr53+t+zcRB0i8mAQ1w==
X-Google-Smtp-Source: ABdhPJyYxdYelacXXBFrseO0Bjw2KVstHbUFRGjzL5JDKI4PatKA+On2s71F5GjKvFQnqUgd9R3Y/A==
X-Received: by 2002:a62:e81a:0:b029:152:97f9:9775 with SMTP id c26-20020a62e81a0000b029015297f99775mr4706999pfi.29.1603304418284;
        Wed, 21 Oct 2020 11:20:18 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id v3sm2618672pfu.165.2020.10.21.11.20.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2020 11:20:17 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 0/3] bpf: Pointers beyond packet end.
Date:   Wed, 21 Oct 2020 11:20:12 -0700
Message-Id: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In some cases LLVM uses the knowledge that branch is taken to optimze the code
which causes the verifier to reject valid programs.
Teach the verifier to recognize that
r1 = skb->data;
r1 += 10;
r2 = skb->data_end;
if (r1 > r2) {
  here r1 points beyond packet_end and subsequent
  if (r1 > r2) // always evaluates to "true".
}

Alexei Starovoitov (3):
  bpf: Support for pointers beyond pkt_end.
  selftests/bpf: Add skb_pkt_end test
  selftests/bpf: Add asm tests for pkt vs pkt_end comparison.

 include/linux/bpf_verifier.h                  |   2 +-
 kernel/bpf/verifier.c                         | 131 +++++++++++++++---
 .../bpf/prog_tests/test_skb_pkt_end.c         |  41 ++++++
 .../testing/selftests/bpf/progs/skb_pkt_end.c |  54 ++++++++
 .../testing/selftests/bpf/verifier/ctx_skb.c  |  42 ++++++
 5 files changed, 247 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c

-- 
2.23.0

