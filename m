Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692D0419E26
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhI0S1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbhI0S1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:27:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B589CC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o1-20020a056902110100b005b69483a0b4so4119773ybu.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CKXecO0x8lMTxk9Ibs90hqIlhsrT5Ovvd8UKp3MR+YM=;
        b=RwCYcsCmTI6SZuJlU9x4gVY+8ostUfTvplqcAa2IYpneyW8CACuQ8sQWJVXWIgpKjg
         Ry3MThE+a51lxedtDK9kLfciaJ2l/XMgF6pY8qh0/j24jOssdI6/s0N+9csLQ+Jo/7NR
         7FecdHtvpY8XlB36a6aFMo0f3GOXC8ylPPXXyQEbNvn/h/Br2iKEyufk8kg/WlNkxxqx
         sCKd2J7ygSogH6Vsjv1G3pyMs6XTs03jd8DzC2iUsopJe2BHjUHZOzDSbCFltoLGn5WL
         zp34Jhih/FnM14WlKV5qNtKPoWdl0GRYpMXful9o7x3XHvdlFQTBBIB2lk22jnm1RFsZ
         WXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CKXecO0x8lMTxk9Ibs90hqIlhsrT5Ovvd8UKp3MR+YM=;
        b=YmygyMLQwVELQC6dW0qVoVrYIt9hvzp40QOulAOM6+eV+p2qkL/VdQVgNDbgwRu1n4
         8CX0Xoyyv+5svyHEMVdWZ/jpn2a93UPbBhgmLIqB8am7ypAimmJnQVc7BiOTNVcgLxgO
         I/6NIyxuxV3cEmT4ZVTLaxPKWBxY+/UkyEmdMoNtIH+xNTQH1u0d3WtShxYCJk7JrIsw
         43zSV3icnlmdFeCQKGawY0xcpQ+reut1/ToPywWChQiM6YNuV+k/BKUyJgGYFk0mmrGE
         HeiJ2nzcplh6+ZIC7HT2awJDoG4gZ4aulSqc8hnI0d3E+U6vIDZ/YiokUcKy8fuR5C81
         chlg==
X-Gm-Message-State: AOAM532nJ1xN5LKiY1hQQNyuqyovd45stzxbQQm6PM8Rfn+ATWPoWM/B
        Pq5Ikla+NYUqd/xe/T2cQPoemQ3XCbY=
X-Google-Smtp-Source: ABdhPJySRM+4VwNYg6EiliJFlET4jdd6y1EUkZe3EdDNIZ+/eFitLfCYQ1fjfayYC6G2D1KdZ3Ztg1oBHXE=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:889:3fd7:84f6:f39c])
 (user=weiwan job=sendgmr) by 2002:a25:213:: with SMTP id 19mr1538283ybc.224.1632767125915;
 Mon, 27 Sep 2021 11:25:25 -0700 (PDT)
Date:   Mon, 27 Sep 2021 11:25:20 -0700
Message-Id: <20210927182523.2704818-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH net-next 0/3] net: add new socket option SO_RESERVE_MEM
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces a new socket option SO_RESERVE_MEM. 
This socket option provides a mechanism for users to reserve a certain
amount of memory for the socket to use. When this option is set, kernel
charges the user specified amount of memory to memcg, as well as
sk_forward_alloc. This amount of memory is not reclaimable and is
available in sk_forward_alloc for this socket.
With this socket option set, the networking stack spends less cycles
doing forward alloc and reclaim, which should lead to better system
performance, with the cost of an amount of pre-allocated and
unreclaimable memory, even under memory pressure.

The first patch is the implementation of this socket option. The
following 2 patches change the tcp stack to make use of this reserved
memory when under memory pressure. This makes the tcp stack behavior
more flexible when under memory pressure, and provides a way for user to
control the distribution of the memory among its sockets.

Wei Wang (3):
  net: add new socket option SO_RESERVE_MEM
  tcp: adjust sndbuf according to sk_reserved_mem
  tcp: adjust rcv_ssthresh according to sk_reserved_mem

 include/net/sock.h                | 44 +++++++++++++++++---
 include/net/tcp.h                 | 11 +++++
 include/uapi/asm-generic/socket.h |  2 +
 net/core/sock.c                   | 69 +++++++++++++++++++++++++++++++
 net/core/stream.c                 |  2 +-
 net/ipv4/af_inet.c                |  2 +-
 net/ipv4/tcp_input.c              | 26 ++++++++++--
 net/ipv4/tcp_output.c             |  3 +-
 8 files changed, 146 insertions(+), 13 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

