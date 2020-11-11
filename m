Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637D2AE6E2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgKKDMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgKKDMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:12:17 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64D5C0613D1;
        Tue, 10 Nov 2020 19:12:16 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z3so722440pfb.10;
        Tue, 10 Nov 2020 19:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UAmP6NeKMxNMOOpt/70DQziGuaFShkxGokRZFSjxW1I=;
        b=Zr3N+GeN6ldsKvMlP5YdNxK8Qb+lhruX+k0iKlGsHT2qzGUQAmofQH0YAQFTPbYnPU
         C97C4192/7UkOQN2gVl61qbk4w8C0evj1tqF0jtvMD4PlW1eZsPy5Fq8ennHR+WO6um+
         lL4y+3X5qz93Z2n8NZDqc6d2N2EsBn3bl9Lq2aKpQsVEiw5FeyWC+rJf+fZhcF4hfLUq
         J5bd2bSzR0HzoNnwWOkZGRJLz3+No6Xp9Oz+B5njlX0Fjs+lDKWdjDvlsYFwwRznIzbu
         bgxmoWFn+jEoolHgpy4kkGPZhyHCmeVWhwBXMHaz8wBUWFlVsFBO7dB4JwGpj/jVkAMI
         U7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UAmP6NeKMxNMOOpt/70DQziGuaFShkxGokRZFSjxW1I=;
        b=pbqTGhIhOJioQtokL7mkkj0UebYBfJBfRZeG2i7Ghgkl01ihtU1/6uywpQe/UfFL3b
         31sGUIP3T1y/EQBwtxA64H3NMzzXeDy6fUXVkNFokHYftCLOIICTLKvJhlHGxUewQAXG
         +xGrsdJtM4Fl3Jo7eLGL0mrOexHuRbxoP0jFLy1kjNI5Ab513UYouByHyqacmZoY9hWp
         VeXTf6qoCH2LNw85XjBYbvN9Lrrq9IY2hLyLMQBLsJCUA7PRSEuEmjSu1kt3fCCk9D27
         VFxkabGZsIdxrJydSWxK5DKI1j2DVPINqQFrYNEYHHTX7XsarPhE6UqJgub5/RLbIZiG
         iISw==
X-Gm-Message-State: AOAM530FiBI5v6P7yUHlfduqVXp0IDlaQhyPmgg0rTgchTayIVxvQ6n/
        iNk9GejmOQ5d8kY4m4hrbvo=
X-Google-Smtp-Source: ABdhPJygrTCeUJm6xBp2lqEPgeGcBkOdrEFDuIOfhPDPd1stwYvNfdTYL52GydjXilzK9KiZ+xua9Q==
X-Received: by 2002:a17:90a:678a:: with SMTP id o10mr1613393pjj.180.1605064336108;
        Tue, 10 Nov 2020 19:12:16 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o132sm506815pfg.100.2020.11.10.19.12.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 19:12:15 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/3] bpf: Pointers beyond packet end.
Date:   Tue, 10 Nov 2020 19:12:10 -0800
Message-Id: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
- removed set-but-unused variable.
- added Jiri's Tested-by.

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
 kernel/bpf/verifier.c                         | 129 +++++++++++++++---
 .../bpf/prog_tests/test_skb_pkt_end.c         |  41 ++++++
 .../testing/selftests/bpf/progs/skb_pkt_end.c |  54 ++++++++
 .../testing/selftests/bpf/verifier/ctx_skb.c  |  42 ++++++
 5 files changed, 245 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c

-- 
2.24.1

