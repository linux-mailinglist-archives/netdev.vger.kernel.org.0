Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA1843678E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhJUQZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhJUQZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDE1C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:22:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i5so776338pla.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LnP2YgAmZzx8+lJMwwyfooBmih5f0pnoCPE8EUcdjyM=;
        b=Yh2EDU/40emBan6MgZhldMSOKUJ7r+6OYdCQNp7qBAALlX6Wm34cSUZrgkAq3WlMN2
         BEGeG8/Cvk2lGHQE4IsJzrkQDVPaJJdqndof8KAryUgqIZ6cqQcBOKAHnpyp08E3E6lK
         DyQ8F9lJ5LSCcWbCyYouTBEjAq3ODBZG+VsK6ACVAXd4TNaDWN7eKqEgDGvFuT4swBTk
         cxEyg2Ngeqwn6WlY7YlorxrUsKk51sixjN8zvqU9ugxilwfwj1ryErt8tnkFpX4UH0nt
         njsnLJZmw7w2qpN1i7kF+vqZNCVqauayAUbI1CLeaSBFkkKUKBIjPvovi+Z1KAwS6e8Y
         jcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LnP2YgAmZzx8+lJMwwyfooBmih5f0pnoCPE8EUcdjyM=;
        b=U+jYQg0pyeouamBqRpV/rTp+aMfloXrAnOqVnt6Bd9vAfWiIOT2UGk8D5Apaj3Kf6L
         oYiXDbwB7Wxs0dhgNDSM+o3ABnsAMeTQ7mxAIWKe7u46Yk9aulmu/luy+GObfXmklp4i
         cw3WCF5CnDNZZSZCk6Zdm1I8eUgmkEvnIdwp7Wtl+wEDRAaVcH/kpKXh8d2irfRGwXlS
         EHuhcgpsgBxUS7inBdO1qYGZWZgqxvaYhz+ZDFGRcO+OmcN+jyau1/ArxzlXADvHDtIc
         9EsbOpn+B0duRQxfPx6usEPzDGcG90/2ls3pzAb1u9VFwDT2M2IxdcRyDLtAxV7VW8Ru
         NjFA==
X-Gm-Message-State: AOAM532t24WqrdCc2GASzpZNCd4oIHmmVaXMKTdWbUNAWsQ/xy5l8IEU
        /ebYQV2YJLSho+HFTpa1u8sZgbyWEx4=
X-Google-Smtp-Source: ABdhPJx/qqiBDjqo2/u3gq9HPmRIytPl+HHTi2N9HEspeaIasuzjwR+lUkxvZsTfh2mq9shlnXlVzw==
X-Received: by 2002:a17:90b:3511:: with SMTP id ls17mr7873053pjb.35.1634833379185;
        Thu, 21 Oct 2021 09:22:59 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:22:58 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 0/9] tcp: receive path optimizations
Date:   Thu, 21 Oct 2021 09:22:42 -0700
Message-Id: <20211021162253.333616-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This series aims to reduce cache line misses in RX path.

I am still working on better cache locality in tcp_sock but
this will wait few more weeks.

Eric Dumazet (9):
  tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
  ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
  net: avoid dirtying sk->sk_napi_id
  net: avoid dirtying sk->sk_rx_queue_mapping
  ipv6: annotate data races around np->min_hopcount
  ipv6: guard IPV6_MINHOPCOUNT with a static key
  ipv4: annotate data races arount inet->min_ttl
  ipv4: guard IP_MINTTL with a static key
  ipv6/tcp: small drop monitor changes

 include/linux/ipv6.h     |  1 -
 include/net/busy_poll.h  |  3 ++-
 include/net/inet_sock.h  |  3 +--
 include/net/ip.h         |  2 ++
 include/net/ipv6.h       |  1 +
 include/net/sock.h       | 11 +++++++----
 net/ipv4/ip_sockglue.c   | 11 ++++++++++-
 net/ipv4/tcp_ipv4.c      | 25 ++++++++++++++++---------
 net/ipv6/ipv6_sockglue.c | 11 ++++++++++-
 net/ipv6/tcp_ipv6.c      | 35 +++++++++++++++++++++--------------
 net/ipv6/udp.c           |  4 ++--
 11 files changed, 72 insertions(+), 35 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

