Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FCC5443D4
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiFIGeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiFIGeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6202F65A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so19517372plg.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkfH4EncSeYhKy7wA40UP82ZK5eG6K7ssTY8ilojiRM=;
        b=esJB3CbnMuRoXvwRSOiWI/2IBbTCdpPfbKOid95mhova3NZ8Gyr1ynD37aCcDCSYea
         N5R1p13aK2fWtkzteroYhk/vBqEFgGalB+YdClnXrbtpBtsh9EvzD2VrS/n91t/uOupz
         es12lwRxFoJT+j2+7/1gScpExUZ9St0ez83G5FvdyZudxxiXej9SJjto1uHYdYepXL5Y
         RxoqEenHJTJqdUJExZO+67jhEg5L8UtmVfWHJ8XeiiIr0LzMY2+gqZLC+NOusRKLXGUX
         +geRCOI26htG6mJm7rVpfv3F5h2cO+3fueAQwsUKiLd/Bh2ApzKSrOOr+jmlkkoKXZJW
         LSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkfH4EncSeYhKy7wA40UP82ZK5eG6K7ssTY8ilojiRM=;
        b=J2z2C51o7+AbZesU6QroJtDokXOY9i785UOExL9x46wa4Lw1421m256HG7C+cUQVGN
         xBorjO6dmrRBj3dLhrVfo+pcXMJAxWY3C+R5ANaSEJn97UPzHtopnYzEyZfAo2k1NsqU
         NwcIV/NxyVnzQ5mPJlrfQK8H0zFpaeXR51Pcyp+i8e7iYbuNpvEt+HqRwhqFKOIKzSnc
         ywyWUk6TeT8eFG7XsM59VKiHnnP7OIly3s8WH01Dj74ds1b17zrxDCAhPjIpNlAte3rP
         J7FruMf1Qte1KZpfIM4WvHV60eCG5r1cqgykc4wOQW81pnqS96VkX/13cb4RK6GLdM2K
         AXcg==
X-Gm-Message-State: AOAM5326WnVeifKKI9/+IoAQYVcf4uXoIlVrXhaVYAHRuYRM8fwHZToH
        Awtgve52da8zHVeMIObZRG4=
X-Google-Smtp-Source: ABdhPJywJfLvcJC5GVriVqqFxJePHOQOZhiAO4mh1mW4kETWj4/VtcSHmt5P34P9JoYTrxmjtVsexw==
X-Received: by 2002:a17:90b:38c8:b0:1e8:5202:f6d4 with SMTP id nn8-20020a17090b38c800b001e85202f6d4mr1872721pjb.149.1654756456678;
        Wed, 08 Jun 2022 23:34:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/7] net: reduce tcp_memory_allocated inflation
Date:   Wed,  8 Jun 2022 23:34:05 -0700
Message-Id: <20220609063412.2205738-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Hosts with a lot of sockets tend to hit so called TCP memory pressure,
leading to very bad TCP performance and/or OOM.

The problem is that some TCP sockets can hold up to 2MB of 'forward
allocations' in their per-socket cache (sk->sk_forward_alloc),
and there is no mechanism to make them relinquish their share
under mem pressure.
Only under some potentially rare events their share is reclaimed,
one socket at a time.

In this series, I implemented a per-cpu cache instead of a per-socket one.

Each CPU has a +1/-1 MB (256 pages on x86) forward alloc cache, in order
to not dirty tcp_memory_allocated shared cache line too often.

We keep sk->sk_forward_alloc values as small as possible, to meet
memcg page granularity constraint.

Note that memcg already has a per-cpu cache, although MEMCG_CHARGE_BATCH
is defined to 32 pages, which seems a bit small.

Note that while this cover letter mentions TCP, this work is generic
and supports TCP, UDP, DECNET, SCTP.

Eric Dumazet (7):
  Revert "net: set SK_MEM_QUANTUM to 4096"
  net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
  net: add per_cpu_fw_alloc field to struct proto
  net: implement per-cpu reserves for memory_allocated
  net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
  net: keep sk->sk_forward_alloc as small as possible
  net: unexport __sk_mem_{raise|reduce}_allocated

 include/net/sock.h           | 100 +++++++++++++++--------------------
 include/net/tcp.h            |   2 +
 include/net/udp.h            |   1 +
 net/core/datagram.c          |   3 --
 net/core/sock.c              |  22 ++++----
 net/decnet/af_decnet.c       |   4 ++
 net/ipv4/tcp.c               |  13 ++---
 net/ipv4/tcp_input.c         |   6 +--
 net/ipv4/tcp_ipv4.c          |   3 ++
 net/ipv4/tcp_output.c        |   2 +-
 net/ipv4/tcp_timer.c         |  19 ++-----
 net/ipv4/udp.c               |  14 +++--
 net/ipv4/udplite.c           |   3 ++
 net/ipv6/tcp_ipv6.c          |   3 ++
 net/ipv6/udp.c               |   3 ++
 net/ipv6/udplite.c           |   3 ++
 net/iucv/af_iucv.c           |   2 -
 net/mptcp/protocol.c         |  13 +++--
 net/sctp/protocol.c          |   4 +-
 net/sctp/sm_statefuns.c      |   2 -
 net/sctp/socket.c            |  12 +++--
 net/sctp/stream_interleave.c |   2 -
 net/sctp/ulpqueue.c          |   4 --
 23 files changed, 114 insertions(+), 126 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

