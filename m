Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D387439C03
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhJYQuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbhJYQuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B6C061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y7so11287519pfg.8
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL1W+Uq6+cZzPslzhLOGMV669Afck3zb6thM2YOgIg8=;
        b=iwE06jPczehcwZguaSgBv4xAHdhr3A73yYJUdg7LS279kSfGbzyHJhZ36CIhA0UHsr
         MwJfZ2/lycTtqmTX/kooWK0EVLQqLMrBhlI4/Jdhg+yXH0mm4G6QHef+57w4e/+PFKoA
         afam8zsHyc0BOdQjM6nhKlcqNngnyfN5InK4zFbilKaC96AHR7/ZtSGAkP+A+Tr/iuQg
         r071jOnoMwmHQwAutx+F8UAc6T0liMFS49n7/xaDspgpaOKQKI0KeTp7ksvgRCtGckDp
         NMwc87bgcYfTilH39/qKRVqW7t9DgSd0RDczhH0Sxr1DdE+CWp4IjpgjpUOgmv7uj3S5
         Yqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL1W+Uq6+cZzPslzhLOGMV669Afck3zb6thM2YOgIg8=;
        b=Tq1Z6UsTHXvFRrdZR1oDAZ+EE3JtlLPUQ7y7XyzlZEXnP2MHlJVreKJag+e7g9kfEi
         qSuspNKS6EwmdFDx4svigBocBR3VSzJx8XPPY2Id18rxhTiqMHCUOgy/SlZpLjQD7+dc
         6tF9J1WIeyGDuNFFzbIvEg4ShBwjHQ6uJ7tLSMjFrrDQzqKTQSAksHa3pmg4KutoSbKf
         M/0xofVkjMjCkKHShlDkiBn+NFe7+5jtorOuEmYOwtxgJoNGdMsQr3xuqZQeyTzKZ9Vx
         iONG1opljye1YttfPqQXQcJ3SN8UB0mcqRPrOseN1bQHf2SjgWlpoRALlESPmieBf0tI
         6RNQ==
X-Gm-Message-State: AOAM533tkZJ03XrcwzXrsOHiz94nErfJTqn7FzQDQAOCJHb3jTZh9yRI
        83jEWrOm99VgyiAYgs00A74=
X-Google-Smtp-Source: ABdhPJw8qJdXrdzlFKUOA6Ken76X+wtUO7pn7xyDKh6mKZOMnn1bISj1hosDPP2M9mp3o3sE9ei5yg==
X-Received: by 2002:a63:a119:: with SMTP id b25mr14492905pgf.358.1635180508746;
        Mon, 25 Oct 2021 09:48:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 00/10] tcp: receive path optimizations
Date:   Mon, 25 Oct 2021 09:48:15 -0700
Message-Id: <20211025164825.259415-1-eric.dumazet@gmail.com>
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

v2: Resent because v1 seems to have been lost.
    Added Soheil Acked-by, and added "net: annotate accesses to sk->sk_rx_queue_mapping"

Eric Dumazet (10):
  tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
  ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
  net: avoid dirtying sk->sk_napi_id
  net: avoid dirtying sk->sk_rx_queue_mapping
  net: annotate accesses to sk->sk_rx_queue_mapping
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
 include/net/sock.h       | 21 ++++++++++++++-------
 net/ipv4/ip_sockglue.c   | 11 ++++++++++-
 net/ipv4/tcp_ipv4.c      | 25 ++++++++++++++++---------
 net/ipv6/ipv6_sockglue.c | 11 ++++++++++-
 net/ipv6/tcp_ipv6.c      | 35 +++++++++++++++++++++--------------
 net/ipv6/udp.c           |  4 ++--
 11 files changed, 79 insertions(+), 38 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

