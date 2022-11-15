Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB676293A0
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiKOIyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiKOIyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:54:01 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F36DF1F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p66-20020a257445000000b006ca0ba7608fso12592863ybc.7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HNRxomeT1W8Cj9DASh+smVoqPSurrPjV0UB6vvtRvI0=;
        b=Y/Q+1BgrSb6YbW6wOYAw4xqAReXqCU/RL4eq1bBm2TvOKYKj+A6W/McKaFawp4zSX8
         Zo7jPwCbdjLPCdhdwkZMES/Cr9PBrHbUhA8Sq2Rm3Vej7+CUjQXN7OWgddEc4N5CmFJ7
         71rt0kRiM+lYbc5bAPBNXVtsWPE4ym+iQzRwWA+kca8Bwe1TSS4vZv1tJRWudi3NV9eI
         YSsZq/d1uhl0uTPt7zS0j5F7qqbVi/wzqCjBXaOn4phfn37ikn9KfQA+7kc79GUaUtao
         E+GWYgIIrb22CFa0n83E4SUOUr6NypJ+K7c2IN73b0Gc6tXpe1Tyvr7ZZZv0rgyowAa2
         K/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HNRxomeT1W8Cj9DASh+smVoqPSurrPjV0UB6vvtRvI0=;
        b=zaQ6lfJDwjh85HJDlbtMx6LkdWYlFqBSYcr89Pf86fdbOsI66+BPSBD1H2h+L3ylrr
         WI83juOC/2dWB5z7vM5OJR/1L5gI6+8+olxtfl842Sl1EQ0zg61dU29E4OGkFAr0ZtkU
         WzGwPE6pX+cdFoUGA1eQF1FyMgw+mYor2G548nZAr3LpnI+WT3Zj5e5C+VoUtCoIemOK
         Nd2tXmj26bIlEo2b/kK4D0X7HaH2sxzOeS0F9QyDPuL6a65X7dEfyI48e91yHvNaBS/7
         QDsyWd4QgXCbULI5RH0BQEHx/ENA7Bktmd+AtWRpzvVSSDWpyFvZJY8KGXl0GcBLyjL4
         EErw==
X-Gm-Message-State: ANoB5pmP1vGmUaYXfLmlP81+wGD9i1oEjFqOQpRbGuXAQh6umbe7vN6b
        VF5L1+mtIdkAWOI5KrIemO2X7FyBcRaoTA==
X-Google-Smtp-Source: AA0mqf5JE3nPmuij+t7rPp1rGnJt+UF9UL/Ww1sf9l9nSso52w9fra2/0y7aZVD3C1ktMmFqFGGmzVOKF5ft2g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:db05:0:b0:6d0:5d59:dba1 with SMTP id
 g5-20020a25db05000000b006d05d59dba1mr14898388ybf.68.1668502439890; Tue, 15
 Nov 2022 00:53:59 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:53:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115085358.2230729-1-edumazet@google.com>
Subject: [PATCH net-next 0/4] net: add atomic dev->stats infra
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Long standing KCSAN issues are caused by data-race around
some dev->stats changes.

Most performance critical paths already use per-cpu
variables, or per-queue ones.

It is reasonable (and more correct) to use atomic operations
for the slow paths.

First patch adds the infrastructure, then three patches address
the most common paths that syzbot is playing with.

Eric Dumazet (4):
  net: add atomic_long_t to net_device_stats fields
  ipv6/sit: use DEV_STATS_INC() to avoid data-races
  ipv6: tunnels: use DEV_STATS_INC()
  ipv4: tunnels: use DEV_STATS_INC()

 include/linux/netdevice.h | 58 +++++++++++++++++++++++----------------
 include/net/dst.h         |  5 ++--
 net/core/dev.c            | 14 ++--------
 net/ipv4/ip_gre.c         | 10 +++----
 net/ipv4/ip_tunnel.c      | 32 ++++++++++-----------
 net/ipv4/ip_vti.c         | 20 +++++++-------
 net/ipv4/ipip.c           |  2 +-
 net/ipv4/ipmr.c           | 12 ++++----
 net/ipv6/ip6_gre.c        | 11 +++-----
 net/ipv6/ip6_tunnel.c     | 26 ++++++++----------
 net/ipv6/ip6_vti.c        | 16 +++++------
 net/ipv6/ip6mr.c          | 10 +++----
 net/ipv6/sit.c            | 22 +++++++--------
 13 files changed, 117 insertions(+), 121 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

