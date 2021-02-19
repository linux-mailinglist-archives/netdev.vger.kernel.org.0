Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3BB320208
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 00:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSX7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 18:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhBSX7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 18:59:22 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710D3C061574;
        Fri, 19 Feb 2021 15:58:42 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id v16so6665053ote.12;
        Fri, 19 Feb 2021 15:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1lr+3i8ZV8Mc+lJGs41q61MJyH7ozLfJ50lFeX8EY14=;
        b=QHXPDYub004f5wvQmLxLytEsKJwCACfJq/0vbv9MiaLjz6nJZO5sKDfUQMHrpDx/9s
         aE7/ov+1+zCAGio4Q5I7qZIu8F9/ZON4cS6oaKAr37+qHCUimkXM5+iehcVy+ythwELf
         XazAfA7SIfxsqYyt6/tSfBpeRF317U7dit2MceV4YqVeEUcLNbUofpVeJxqficsOR2kx
         gRcNKBsGhrVNZjSPIY/HvNpVL2FPReLzFyAaApfFVUB2sdwiPR9x3gDStZMy6Vgoxhmp
         I+CEm7sUGim2naP39EPQ6Z7VzDMc/K49rBbv0XBT4fN3DmThoSiGd9NYsxUr1rKDs3mk
         1Hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1lr+3i8ZV8Mc+lJGs41q61MJyH7ozLfJ50lFeX8EY14=;
        b=UNaJzZBwRE5WD3wd2IvLRkhEhRmzO0stF7vWuKab792JSDZs2u9HEJDJxPbzcMmQ45
         adByKbA0AggbmqahEyZ5tOzd83wyjEPozxmINY/KlRoPkQIFE1FJ2SCviSuYimLQ/AHS
         L4SMX7SwF/TKvMG2ntz6kBNGM3bgx9qdazw7n6nGIFjz3+VDTpw/28WHeJ8Tt9NohLRU
         fFksfaxtC99ol2+5b7LULl5T7AnC5L9D/tyK9JuzJXFKbt/FkbWiKmjAbM8pAVdYbx5K
         RZGw8Hjpok9tqfOsoi7yPcP/t5BPZmiJyRVBgunGJvkvM5TQCmyViG3Th/fMyq95Ce5V
         zRYA==
X-Gm-Message-State: AOAM533KF/JSlX164BheZlxLU/ucwBbCBmTUZ7DPYXKW4B4zM1XUV3ck
        Nue1DhvHSSSzoNJxJHQSsQwqGmesfKKWhQ==
X-Google-Smtp-Source: ABdhPJw2UOUhFDRJEMlHXy+a+7EiYzZuSdKLgnFaDnXWERRkv9RXXbCqs2mpHXuM+7KQ35h81VGRgw==
X-Received: by 2002:a05:6830:314d:: with SMTP id c13mr7368351ots.124.1613779121313;
        Fri, 19 Feb 2021 15:58:41 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:40 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v5 0/8] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Fri, 19 Feb 2021 15:58:28 -0800
Message-Id: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
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
v5: improve CONFIG_BPF_SYSCALL dependency
    add 3 trivial clean up patches.

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

Cong Wang (8):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: move sk_redir from TCP_SKB_CB to skb
  sock_map: rename skb_parser and skb_verdict
  sock_map: make sock_map_prog_update() static
  skmsg: make __sk_psock_purge_ingress_msg() static
  skmsg: get rid of sk_psock_bpf_run()

 include/linux/bpf.h                           |  25 +--
 include/linux/bpf_types.h                     |   2 -
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  82 +++++--
 include/net/tcp.h                             |  41 +---
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   6 +-
 net/core/Makefile                             |   2 +-
 net/core/filter.c                             |  48 ++--
 net/core/skmsg.c                              | 207 ++++++++----------
 net/core/sock_map.c                           |  77 +++----
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 16 files changed, 263 insertions(+), 253 deletions(-)

-- 
2.25.1

