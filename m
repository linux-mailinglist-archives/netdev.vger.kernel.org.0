Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6806841B998
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242191AbhI1Vs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbhI1Vs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 17:48:26 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7ACC06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:46 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l18-20020a056214039200b0037e4da8b408so788340qvy.6
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bBWw+SXG7nwVMHWnRxgJ3wIrqdhp+kcQsEQOpR9FVnA=;
        b=lF6U/sr9oWvVGXupJ5/tTnk2v2RqDZhNcFKRAnLprt9TwOiphGWtfqret8YkNXcTrO
         Bdi4UhRdagAeDFMg81U0ITVZhaNqiwxusZL1W75ke9Uxj2dCIMM7SYKpV7nBCE5Kl2Fl
         /nOFTCdIJkA0nx/gyVILq8Lkbb+Uitg5xKQwqWDP9bH7xF0sM9Z8XoPE4v4sqAcgybqv
         a63y+FWPFFlqX3+1RFdfqUkeO/oUzsDgni+26QK/HW+lIVObDLpba2IUQFNpb1cZmg2s
         5RKQMGnJ5syZOUjMzw2HpOLev5AeavHpO5GrzIsFRoFAxDX3t+a9VXVAo23ElgyYvyhP
         pb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bBWw+SXG7nwVMHWnRxgJ3wIrqdhp+kcQsEQOpR9FVnA=;
        b=ptZRO1oSa3Zv01K5jNwpcJvHehWFTUjDXJqKeGCdOC8dspOZkEmjkbVqE/4+HjJHee
         xE4uwzWn/U/NTttr+I3amtCVmEdn2ANc4Beyjcb8WEJnzlJ/J33rnfhKAvgkYzMXjjFU
         Yc22OQg5E6Nl4unY2c8jxgyRmQdjhaNP3PRBrzaGuDGCTZSgzyLi2U1JIBh1Z+OE+l9U
         2fBuLY3Bj3Uybn7UG7RANdM4hseZjaBxTFB1uaJrxDWf8jbkcuHl4HyLtpruSOvftBUA
         htJuBK7ybHDOrLALSdTRxNYCSQguBjALhawCGoAsNpBBJWlhy506QJ1i1Tb/5V7EOb4W
         5wdw==
X-Gm-Message-State: AOAM5305pdbI1FFtMNHXuJGAiLst2ItXVZCU9KPFgIHu5m2DIHCmIwsj
        Eua8HCMxPVAH8EJ6c9PLw+RdokAfYt0=
X-Google-Smtp-Source: ABdhPJyx/Mp4lIHKx7/bCfU3bQl9Qb+P4rTaYjfLO/fAD2D6xsoi2/Z1NSkTiPbGtrBUmEkoPZrOrb2EUto=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:5d42:81b8:4b7f:efe2])
 (user=weiwan job=sendgmr) by 2002:a05:6214:17d1:: with SMTP id
 cu17mr8417273qvb.14.1632865605941; Tue, 28 Sep 2021 14:46:45 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:46:40 -0700
Message-Id: <20210928214643.3300692-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 net-next 0/3] net: add new socket option SO_RESERVE_MEM
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "'David S . Miller'" <davem@davemloft.net>, netdev@vger.kernel.org
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

Change since v1:
- Added performance stats in cover letter and rebased

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

