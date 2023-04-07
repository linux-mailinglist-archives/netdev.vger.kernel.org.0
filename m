Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA866DB15C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjDGRRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDGRQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:16:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C06CAD13;
        Fri,  7 Apr 2023 10:16:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 60-20020a17090a09c200b0023fcc8ce113so1840904pjo.4;
        Fri, 07 Apr 2023 10:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680887817; x=1683479817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2uav/8fUjiEktJuxAKdhW70aVgQxmc3Ia+wShASZnUc=;
        b=CqfwqIvKGABnBhl7j3El7J+FPuRsAEuVLbuDQmZuKvSSFhgWw6Yl29gsDzZRNHzAS0
         njKcW0Tee+wfoZpFniDRqFP/qd9wctlWgauHWNOEm52Xud1ypfcksCTNfofP+rgiPKxM
         P+nTgn0HlTXO9aLl35vE3UfbHpfOo/khGE+yGvqf4OkgmKdZSWTgt1zrVQvwpuqrGG7x
         lqFVeVPxC0qodj+k7Q/tgoPG3r+5HOe3mJFilperCfAaq3+IAVzK31nVv6H1KBMMFlPF
         8u0gAVBxff5v+uLJPIxDoMtoBxj9hObfgUrz4S93JdGj+h+m8o3nK7bMMfsWCUF2XRuL
         H4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887817; x=1683479817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2uav/8fUjiEktJuxAKdhW70aVgQxmc3Ia+wShASZnUc=;
        b=z4HB932EObfSg77U172uRWI6/nWz4/v/Hj45cWpUeLIwiEHyT2TVrdU193DDXMnMuE
         Rx6Z9oqwAZAGPFnpQ1ckO+EwKQdJWo9xVFfuC5X6gcX9USr10qvu6U81o8YBaEZE3Bl6
         VQgnCcpAdbU28szb5GISXfvKvjEPKwLWpuLuO8OE2mjKnFexX5J802S9q5gScwf7MLml
         FhA/Mj0WI7fuYwHjrXP3SmAAKVHNpO6aTk6RgOvZ0WJBtBF2llrzTRpgsZJlMVy/5g6U
         OqyfYSeSbb6wlqkp+/vz124w6Cl9BH9K6rmgu46TQRBZNxoF39RAP3RzvoqQAnO46GVK
         rKTA==
X-Gm-Message-State: AAQBX9cAvV4zIpxR4wFJa7IhyG4XUc7uK3IF4LRcTGW0ksu4WkKxxlRc
        imIAlkrSXEK87c4DxkupBTM=
X-Google-Smtp-Source: AKy350YnuvpVZMDtZOBUncAFfl/ydTgLHpxqjXyyaK1ZA/BJ4z5G8c10Gw05sfITx+A07tQ8vy2z6A==
X-Received: by 2002:a17:902:e752:b0:1a5:15bb:e3af with SMTP id p18-20020a170902e75200b001a515bbe3afmr2499250plf.8.1680887817399;
        Fri, 07 Apr 2023 10:16:57 -0700 (PDT)
Received: from john.lan ([98.97.116.126])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709028a8100b0019b0937003esm3185425plo.150.2023.04.07.10.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:16:56 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, cong.wang@bytedance.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v6 00/12] bpf sockmap fixes
Date:   Fri,  7 Apr 2023 10:16:42 -0700
Message-Id: <20230407171654.107311-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for sockmap running against NGINX TCP tests and also on an
underprovisioned VM so that we hit error (ENOMEM) cases regularly.

The first 3 patches fix cases related to ENOMEM that were either
causing splats or data hangs.

Then 4-7 resolved cases found when running NGINX with its sockets
assigned to sockmap. These mostly have to do with handling fin/shutdown
incorrectly and ensuring epoll_wait works as expected.

Patches 8 and 9 extract some of the logic used for sockmap_listen tests
so that we can use it in other tests because it didn't make much
sense to me to add tests to the sockmap_listen cases when here we
are testing send/recv *basic* cases.

Finally patches 10, 11 and 12 add the new tests to ensure we handle
ioctl(FIONREAD) and shutdown correctly.

To test the series I ran the NGINX compliance tests and the sockmap
selftests. For now our compliance test just runs with SK_PASS.

There are some more things to be done here, but these 11 patches
stand on their own in my opionion and fix issues we are having in
CI now. For bpf-next we can fixup/improve selftests to use the
ASSERT_* in sockmap_helpers, streamline some of the testing, and
add more tests. We also still are debugging a few additional flakes
patches coming soon.

v2: use skb_queue_empty instead of *_empty_lockless (Eric)
    oops incorrectly updated copied_seq on DROP case (Eric)
    added test for drop case copied_seq update

v3: Fix up comment to use /**/ formatting and update commit
    message to capture discussion about previous fix attempt
    for hanging backlog being imcomplete.

v4: build error sockmap things are behind NET_SKMSG not in
    BPF_SYSCALL otherwise you can build the .c file but not
    have correct headers.

v5: typo with mispelled SOCKMAP_HELPERS

v6: fix to build without INET enabled for the other sockmap
    types e.g. af_unix.

John Fastabend (11):
  bpf: sockmap, pass skb ownership through read_skb
  bpf: sockmap, convert schedule_work into delayed_work
  bpf: sockmap, improved check for empty queue
  bpf: sockmap, handle fin correctly
  bpf: sockmap, TCP data stall on recv before accept
  bpf: sockmap, wake up polling after data copy
  bpf: sockmap incorrectly handling copied_seq
  bpf: sockmap, pull socket helpers out of listen test for general use
  bpf: sockmap, build helper to create connected socket pair
  bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
  bpf: sockmap, test FIONREAD returns correct bytes in rx buffer

 include/linux/skmsg.h                         |   2 +-
 include/net/tcp.h                             |   1 +
 net/core/skmsg.c                              |  58 ++-
 net/core/sock_map.c                           |   3 +-
 net/ipv4/tcp.c                                |   9 -
 net/ipv4/tcp_bpf.c                            |  81 +++-
 net/ipv4/udp.c                                |   5 +-
 net/unix/af_unix.c                            |   5 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 119 +++++-
 .../bpf/prog_tests/sockmap_helpers.h          | 374 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 352 +----------------
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 12 files changed, 659 insertions(+), 382 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0

