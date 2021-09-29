Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C0E41CB08
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344388AbhI2R05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbhI2R05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:26:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C23C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 83-20020a251956000000b0059948f541cbso4443557ybz.7
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r5x2HlW3pmH1ylQ2GQp1urg0Gz/ol3qArxthtAKmHCk=;
        b=fHNcVXb8Yx4tvI8Fgml6t+4Pw8pR0kPhvt5lDZ+EoOCEo8Aise6BrHk6sfielDz7po
         /TBshbNMIYqAO0puCTBVX79JvyHt3Gjfc+TxSU0dgXAz/EwwhndaKMI4KEKEIr1EL/be
         1q5HN1zTOtMNeaEH6JtMMtb4T3UjPkZ0i1ZYJlSHRzmC0JWX8mFGr0/mqtR+x+z+iA79
         f2dQswyuSV1h5QpthL9J2cbdcNasT7J4Wbe4j0PTvsjXeYwWhr2GgIPHIrDd8Ml3/fny
         4iJ8NE2LmDQ7MxD4MOH+a57ysY1J48vIj+TaMUWt9g732zJ5g1DLXDBp7NaNFz2/IihW
         xwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r5x2HlW3pmH1ylQ2GQp1urg0Gz/ol3qArxthtAKmHCk=;
        b=Knze0gbqI32oqM0K2E5ia0UEADeEIGFrYrRTXjwBmGz/lswNaEeW72q3l+V9OiKR4d
         kJq72DHFd2QxuQEcfMmoA0pVRLCGTC9L8xqgnMC11CKSMo/mZLuzVLjXayyW1cTd8OGR
         qG6le/8/NtvBJJqgikTpfvXVPJFyIDK0/6j5BZRTAPB1xzmMU02CTUWVowruHo0u5fFA
         izJclazONmhizlvYXF+uDXqJmCDYjiGBJeVmJGAHzD1iRzGaPmCR8JOy+H3Ks7gbE2b4
         P+aEFr0mnvh+dYHh5yUFliZv9dm+7Py1TllV1JcFvAoGrJvRa1ImGnqMn8hy3m22j4fI
         F95A==
X-Gm-Message-State: AOAM531/V5cQRUJb/1/EIZzugWjDiaUb3c1zOAmIUHKnczmFbdqh8OvM
        ca4c1Nnoo9m79pQTuldO+HREhorRXCE=
X-Google-Smtp-Source: ABdhPJwWB98jt/v8gML5R2K4DQ/Cpb3SzGiRvtROFd/9JYEf+PTBbafMBuMbrl/roCYUzO0Uwx9v8g4jE7g=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:a9d9:bcda:fa5:99c6])
 (user=weiwan job=sendgmr) by 2002:a25:2c97:: with SMTP id s145mr1205339ybs.463.1632936315061;
 Wed, 29 Sep 2021 10:25:15 -0700 (PDT)
Date:   Wed, 29 Sep 2021 10:25:10 -0700
Message-Id: <20210929172513.3930074-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 net-next 0/3] net: add new socket option SO_RESERVE_MEM
From:   Wei Wang <weiwan@google.com>
To:     "'David S . Miller'" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>
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
With a tcp_stream test with 10 flows running on a simulated 100ms RTT
link, I can see the cycles spent in __sk_mem_raise_allocated() dropping
by ~0.02%. Not a whole lot, since we already have logic in
sk_mem_uncharge() to only reclaim 1MB when sk_forward_alloc has more
than 2MB free space. But on a system suffering memory pressure
constently, the savings should be more.

The first patch is the implementation of this socket option. The
following 2 patches change the tcp stack to make use of this reserved
memory when under memory pressure. This makes the tcp stack behavior
more flexible when under memory pressure, and provides a way for user to
control the distribution of the memory among its sockets.
With a TCP connection on a simulated 100ms RTT link, the default
throughput under memory pressure is ~500Kbps. With SO_RESERVE_MEM set to
100KB, the throughput under memory pressure goes up to ~3.5Mbps.

Change since v2:
- Added description for new field added in struct sock in patch 1
Change since v1:
- Added performance stats in cover letter and rebased

Wei Wang (3):
  net: add new socket option SO_RESERVE_MEM
  tcp: adjust sndbuf according to sk_reserved_mem
  tcp: adjust rcv_ssthresh according to sk_reserved_mem

 include/net/sock.h                | 45 +++++++++++++++++---
 include/net/tcp.h                 | 11 +++++
 include/uapi/asm-generic/socket.h |  2 +
 net/core/sock.c                   | 69 +++++++++++++++++++++++++++++++
 net/core/stream.c                 |  2 +-
 net/ipv4/af_inet.c                |  2 +-
 net/ipv4/tcp_input.c              | 26 ++++++++++--
 net/ipv4/tcp_output.c             |  3 +-
 8 files changed, 147 insertions(+), 13 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

