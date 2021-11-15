Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69087451D95
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351102AbhKPAbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbhKOT3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:14 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB272C0BC98A
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:02:55 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b11so15205412pld.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Hh1Fj6NmKa86g/VwgYKPBmZHa3Ic5aiiB06yaJczm4=;
        b=dIyNOOLP6ahslkWRf5+RPbOefDQ1DYwzXQTNDc+P/do9wg6LWJ16rgVWNsvmgNVUF2
         ElM4R2Cdp5AqxMHtMbY+A13AqQLvriVfmDcwy314PBksnB7Wb2ZdTSLN90F2Pf6UWSV0
         DwfbXFeKgBc8xgU8NQDCt707ea4uzSTfTt6Y6ucYZk3lNr57HLobV5e9MY/tfssGoYcy
         7J8XVHl6GlJxdBr6t2D4YfnLEq/I7I+Q0NU/BfIdNTPS6ZX3vzHQU5JSn2sdwqKL558+
         XYZ2BI/qJyjabnXMfh3+aRlcCIzKIYtLscUtRcUa+/i2uGnur9ueSBw06mnsKT9ELoDL
         cf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Hh1Fj6NmKa86g/VwgYKPBmZHa3Ic5aiiB06yaJczm4=;
        b=qb0pfv/W27jZFoVKQ/jgYP4o9QOHOc9oYSKbMIwLea4lA0RUz3Trwh+osR7ekCnAp4
         zYmSZSjueTSVM9rIr7yJQCMy2cJMR3TQ2SHDspJ23tj9Bk35DC8u1B2zxT7RJZmljcua
         jp2hIFBusklF8YXSadeBXxwRlbfMUvAtvVbBnjwWFdvKg2S9Erw+erMrBEWifuR4L9Ft
         98y4L+lrweo7XC7MfB7gZ6ljyq1Vy+jQJKKT5RYz4oHOJTn00VLC/4XNbv4imh64XpzL
         aClIQEIhD+Z4dFxR1ziX3SaVU3Qts4z+n6miQdZ44Qsd/aOSC+9DToa5ZE5Dntk8jB9t
         82NQ==
X-Gm-Message-State: AOAM531xynQ3FNvjYSZdknpgSDaTXL74U/asrZX4OhYiFtnl0IvC39lB
        rw0laNZCfnY0TNvOJrlSWuY=
X-Google-Smtp-Source: ABdhPJzqnl3jhjSJOH0XiIZS2lo4d8W83Xt9hmBj1UQUxeY094qQMkGyQwPn2xX23zkOO900hlkwjg==
X-Received: by 2002:a17:90a:fe87:: with SMTP id co7mr67262415pjb.21.1637002973962;
        Mon, 15 Nov 2021 11:02:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:02:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
Date:   Mon, 15 Nov 2021 11:02:29 -0800
Message-Id: <20211115190249.3936899-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Mostly small improvements in this series.

The notable change is in "defer skb freeing after
socket lock is released" in recvmsg() (and RX zerocopy)

The idea is to try to let skb freeing to BH handler,
whenever possible, or at least perform the freeing
outside of the socket lock section, for much improved
performance. This idea can probably be extended
to other protocols.

 Tests on a 100Gbit NIC
 Max throughput for one TCP_STREAM flow, over 10 runs.

 MTU : 1500  (1428 bytes of TCP payload per MSS)
 Before: 55 Gbit
 After:  66 Gbit

 MTU : 4096+ (4096 bytes of TCP payload, plus TCP/IPv6 headers)
 Before: 82 Gbit
 After:  95 Gbit

Eric Dumazet (20):
  tcp: minor optimization in tcp_add_backlog()
  tcp: remove dead code in __tcp_v6_send_check()
  tcp: small optimization in tcp_v6_send_check()
  net: use sk_is_tcp() in more places
  net: remove sk_route_forced_caps
  net: remove sk_route_nocaps
  ipv6: shrink struct ipcm6_cookie
  net: shrink struct sock by 8 bytes
  net: forward_alloc_get depends on CONFIG_MPTCP
  net: cache align tcp_memory_allocated, tcp_sockets_allocated
  tcp: small optimization in tcp recvmsg()
  tcp: add RETPOLINE mitigation to sk_backlog_rcv
  tcp: annotate data-races on tp->segs_in and tp->data_segs_in
  tcp: annotate races around tp->urg_data
  tcp: tp->urg_data is unlikely to be set
  tcp: avoid indirect calls to sock_rfree
  tcp: defer skb freeing after socket lock is released
  tcp: check local var (timeo) before socket fields in one test
  tcp: do not call tcp_cleanup_rbuf() if we have a backlog
  net: move early demux fields close to sk_refcnt

 include/linux/skbuff.h     |  2 +
 include/linux/skmsg.h      |  6 ---
 include/net/ip6_checksum.h | 12 ++---
 include/net/ipv6.h         |  4 +-
 include/net/sock.h         | 51 +++++++++++++--------
 include/net/tcp.h          | 18 +++++++-
 net/core/skbuff.c          |  6 +--
 net/core/sock.c            | 18 +++++---
 net/ipv4/tcp.c             | 91 ++++++++++++++++++++++++++------------
 net/ipv4/tcp_input.c       |  8 ++--
 net/ipv4/tcp_ipv4.c        | 10 ++---
 net/ipv4/tcp_output.c      |  2 +-
 net/ipv4/udp.c             |  2 +-
 net/ipv6/ip6_output.c      |  2 +-
 net/ipv6/tcp_ipv6.c        | 10 ++---
 net/mptcp/protocol.c       |  2 +-
 16 files changed, 149 insertions(+), 95 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

