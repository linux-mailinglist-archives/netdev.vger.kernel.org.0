Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1365EEE56
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiI2HEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiI2HEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:37 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87806A98DC;
        Thu, 29 Sep 2022 00:04:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JFdunjvLsFhOdctZk0L2M1ZTEvP3hRf2QZ8TjxsFZJc=;
        b=pPdvdLJHXSOORExVWP6Mxpv2k3VmGElV9TlGZWN6ssMstGLjnDZeAqIIN6eglfSFIF3hi8
        DY57OvjWXh/VOM3M00Zs9ibSEWe52eUi+BfRNOKUgqGoFhda88b0YpUEgsMB8hLBxPV0gl
        BfKOVklNcuNQF4yeg0qI8Ss+xLDSPNU=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 0/5] bpf: Remove recursion check for struct_ops prog
Date:   Thu, 29 Sep 2022 00:04:02 -0700
Message-Id: <20220929070407.965581-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The struct_ops is sharing the tracing-trampoline's enter/exit
function which tracks prog->active to avoid recursion.  It turns
out the struct_ops bpf prog will hit this prog->active and
unnecessarily skipped running the struct_ops prog.  eg.  The
'.ssthresh' may run in_task() and then interrupted by softirq
that runs the same '.ssthresh'.

The kernel does not call the tcp-cc's ops in a recursive way,
so this set is to remove the recursion check for struct_ops prog.

v3:
- Clear the bpf_chg_cc_inprogress from the newly cloned tcp_sock
  in tcp_create_openreq_child() because the listen sk can
  be cloned without lock being held. (Eric Dumazet)

v2:
- v1 [0] turned into a long discussion on a few cases and also
  whether it needs to follow the bpf_run_ctx chain if there is
  tracing bpf_run_ctx (kprobe/trace/trampoline) running in between.

  It is a good signal that it is not obvious enough to reason
  about it and needs a tradeoff for a more straight forward approach.

  This revision uses one bit out of an existing 1 byte hole
  in the tcp_sock.  It is in Patch 4.

  [0]: https://lore.kernel.org/bpf/20220922225616.3054840-1-kafai@fb.com/T/#md98d40ac5ec295fdadef476c227a3401b2b6b911

Martin KaFai Lau (5):
  bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
  bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
  bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another
    function
  bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur
    itself
  selftests/bpf: Check -EBUSY for the recurred
    bpf_setsockopt(TCP_CONGESTION)

 arch/x86/net/bpf_jit_comp.c                   |  3 +
 include/linux/bpf.h                           |  4 ++
 include/linux/tcp.h                           |  6 ++
 kernel/bpf/trampoline.c                       | 23 ++++++
 net/core/filter.c                             | 70 ++++++++++++++-----
 net/ipv4/tcp_minisocks.c                      |  1 +
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  4 ++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 25 ++++---
 8 files changed, 112 insertions(+), 24 deletions(-)

-- 
2.30.2

