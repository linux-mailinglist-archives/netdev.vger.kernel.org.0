Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9B3230F3
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBWSu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbhBWSu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:50:26 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12196C061574;
        Tue, 23 Feb 2021 10:49:46 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d9so2500663ote.12;
        Tue, 23 Feb 2021 10:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tJJOVqiH8oFiFcj51eGI+ZGNONfv+VxYW4vpDszjadw=;
        b=tk0bzpqpLHe5JJvuiWiojM6lnnHAPac4cz4yCgCJ6sNj1dua3O/Gu1+GcxVsDYJFAq
         cTwQ+kCmWs9Ng/+pq8GireAWJGdwKMzlmtuILt25NLyVu/neU7x3apB20MdSvuhL/5cv
         EbTOE+ZPhTBkJX+2iuRhVURB8rfOXJ77emtRMiCgiGW/gzJgksmrVBHlduYFTXJWtkie
         /kzUogRRsS3ohJkkNApOCG0OG3+y/0SVYo1nJc0CoAYvefrJoobtekuh6EzqfEUbJpAm
         v4jGNtMquXIRWC8zuL4DFNcB/UpSqgiZXjQlAUapab5NTGWIkqb6jnYxrQyOg7zhJMcO
         oiWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tJJOVqiH8oFiFcj51eGI+ZGNONfv+VxYW4vpDszjadw=;
        b=XZdRA/PertfL5zBv1xAO7IYlnOIehUeXW6mNUKY3yFSgVMjQzLmXR0FeXhSQqMhrGa
         jUpfqg7HqOONM72z/2Dy4dHfFGiXp81/P+IJb3Z2JKOF4r1dpTCG0dueD4llU/B1MBCO
         SST3i0va4zV02bHm4EwYyJY/BX9VDUTy18djfrErajbnYd2S9fvvhIxjhmgblBfeA1Ao
         t0oSUEg/wzBlcWGfnJGydJdnI/BHtVZCRQmB5sQIWYwDcT17b/3EbHsK+I+HG9Q3NPiy
         u+zg0ZH+XA6wHVP6LI6mRZLhyl8ybEhX5nOt49Qiwqo939oDF/AuhjFMLuPJlQ+CWtDg
         hEIQ==
X-Gm-Message-State: AOAM530YdATWTqFuIFHUhGJ8wLddLsVY3GGlSo9rRQryOzwe+y1HV88/
        +mm3DotVFe/GjeS2K86qtNTwF57eWMLPUQ==
X-Google-Smtp-Source: ABdhPJym1xi8lVOGxgkV6rpiayBLmGErMxeS0xppRr9qlklSQBdV4JjyaiXN43kGyWQZ9P9z0lVsHQ==
X-Received: by 2002:a9d:7385:: with SMTP id j5mr10849736otk.148.1614106184846;
        Tue, 23 Feb 2021 10:49:44 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:44 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v7 0/9] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Tue, 23 Feb 2021 10:49:25 -0800
Message-Id: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset is the first series of patches separated out from
the original large patchset, to make reviews easier. This patchset
does not add any new feature or change any functionality but merely
cleans up the existing sockmap and skmsg code and refactors it, to
prepare for the patches followed up. This passed all BPF selftests.

To see the big picture, the original whole patchset is available
on github: https://github.com/congwang/linux/tree/sockmap

and this patchset is also available on github:
https://github.com/congwang/linux/tree/sockmap1

---
v7: add 1 trivial cleanup patch
    define a mask for sk_redir
    fix CONFIG_BPF_SYSCALL in include/net/udp.h
    make sk_psock_done_strp() static
    move skb_bpf_redirect_clear() to sk_psock_backlog()

v6: fix !CONFIG_INET case

v5: improve CONFIG_BPF_SYSCALL dependency
    add 3 trivial cleanup patches

v4: reuse skb dst instead of skb ext
    fix another Kconfig error

v3: fix a few Kconfig compile errors
    remove an unused variable
    add a comment for bpf_convert_data_end_access()

v2: split the original patchset
    compute data_end with bpf_convert_data_end_access()
    get rid of psock->bpf_running
    reduce the scope of CONFIG_BPF_STREAM_PARSER
    do not add CONFIG_BPF_SOCK_MAP

Cong Wang (9):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: move sk_redir from TCP_SKB_CB to skb
  sock_map: rename skb_parser and skb_verdict
  sock_map: make sock_map_prog_update() static
  skmsg: make __sk_psock_purge_ingress_msg() static
  skmsg: get rid of sk_psock_bpf_run()
  skmsg: remove unused sk_psock_stop() declaration

 include/linux/bpf.h                           |  29 +--
 include/linux/bpf_types.h                     |   6 +-
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  82 +++++--
 include/net/tcp.h                             |  41 +---
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   6 +-
 net/core/Makefile                             |   6 +-
 net/core/filter.c                             |  48 ++--
 net/core/skmsg.c                              | 212 +++++++++---------
 net/core/sock_map.c                           |  77 +++----
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 16 files changed, 274 insertions(+), 259 deletions(-)

-- 
2.25.1

