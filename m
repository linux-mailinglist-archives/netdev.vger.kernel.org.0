Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A504A7D87
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348883AbiBCBvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348855AbiBCBvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:51:47 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58641C06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:51:47 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so8567486pjt.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wZ0jJq/qW6xOSmxoi48zDtvv2oEZ0Y8uAIYLzs8b8zI=;
        b=fabcG2HBlzAlpAqxZUiDYXcGz8eHJy+1VDE+/bzvRl/PABMjx2ydZi2nGYtcv0+2eH
         LoLIYLbZgPu9VkJB3IaU4NQptiv3WLXmrYmb9qZXjg0bEHHnW/5gndN6sz6hk5GB4OOq
         Jpia1b9EPceeA04rU6VVrx5No0JGIkwkXd38pJG2xsLUm+SmiBM4VTn04j/dunKoRPJS
         62B8k/avs0kc7is9/eUPCILxg8DwpkANOv1/ZfsLgcOEo2wTVxq6Q2pdNQYrdPbzahUc
         WOPSnfr4pW/aF5yrgI+Qto6DFGU72HWsCsb/4pD342DhIteHv5DGmSq4MiKzMgtnXYnH
         OYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wZ0jJq/qW6xOSmxoi48zDtvv2oEZ0Y8uAIYLzs8b8zI=;
        b=Lc8T6kr9VADIkyK6jfsuC/nRY7SEOEUbG49f3TJ0qhpl7U3Riwj15vWZP4zPeDdT0w
         YR/OUnvaMUqnSU1bZfTP6c3zSKQBOnvA2SpjhWhME80TjkpuOcreY4QIK9KdoMIkgBCE
         9g4cxg+YZq9qUzh/PqfmJHvuvo3SA9D0Hb1oApOoS60/1bVOeePB4N20Q6qXBIQoX828
         Z4nfoUAic86p6Qqxy2GE9ela81aZnXFCpZF6cc62J360RkNrymHn/sN+AsEK0NEbRLW7
         eUHrF8xRSlCRAiW1ZFLFOjz0LBekiDiNFPCeRXfAklijxCIJSXzjeirJuGVlRJnIZFDU
         W+ig==
X-Gm-Message-State: AOAM532QW+lGrSx/zhms+KJYQVOOfArvnjAXJOwO0duhWweCZbud/HlG
        dRiTo0HovWJfNCEQqFOyGXTXfwrJu6s=
X-Google-Smtp-Source: ABdhPJwdtDaHtqUWE8yUee5w+8IGX1k/EdO9nl58C0HgqE0fV3BGu6wdWhIHWvAA+pWhS9DQiUSqlw==
X-Received: by 2002:a17:902:7c02:: with SMTP id x2mr32426193pll.47.1643853106836;
        Wed, 02 Feb 2022 17:51:46 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:51:46 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/15] tcp: BIG TCP implementation
Date:   Wed,  2 Feb 2022 17:51:25 -0800
Message-Id: <20220203015140.3022854-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This series implements BIG TCP as presented in netdev 0x15:

https://netdevconf.info/0x15/session.html?BIG-TCP

Standard TSO/GRO packet limit is 64KB

With BIG TCP, we allow bigger TSO/GRO packet sizes for IPv6 traffic.

Note that this feature is by default not enabled, because it might
break some eBPF programs assuming TCP header immediately follows IPv6 header.

Reducing number of packets traversing networking stack usually improves
performance, as shown on this experiment using a 100Gbit NIC, and 4K MTU.

'Standard' performance with current (74KB) limits.
for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
77           138          183          8542.19    
79           143          178          8215.28    
70           117          164          9543.39    
80           144          176          8183.71    
78           126          155          9108.47    
80           146          184          8115.19    
71           113          165          9510.96    
74           113          164          9518.74    
79           137          178          8575.04    
73           111          171          9561.73    

Now enable BIG TCP on both hosts.

ip link set dev eth0 gro_ipv6_max_size 185000 gso_ipv6_max_size 185000
for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
57           83           117          13871.38   
64           118          155          11432.94   
65           116          148          11507.62   
60           105          136          12645.15   
60           103          135          12760.34   
60           102          134          12832.64   
62           109          132          10877.68   
58           82           115          14052.93   
57           83           124          14212.58   
57           82           119          14196.01   

We see an increase of transactions per second, and lower latencies as well.

Coco Li (3):
  ipv6: Add hop-by-hop header to jumbograms in ip6_output
  ipvlan: enable BIG TCP Packets
  mlx5: support BIG TCP packets

Eric Dumazet (11):
  net: add netdev->tso_ipv6_max_size attribute
  ipv6: add dev->gso_ipv6_max_size
  tcp_cubic: make hystart_ack_delay() aware of BIG TCP
  ipv6: add struct hop_jumbo_hdr definition
  ipv6/gso: remove temporary HBH/jumbo header
  ipv6/gro: insert temporary HBH/jumbo header
  net: increase MAX_SKB_FRAGS
  net: loopback: enable BIG TCP packets
  bonding: update dev->tso_ipv6_max_size
  macvlan: enable BIG TCP Packets
  mlx4: support BIG TCP packets

Signed-off-by: Coco Li (1):
  ipv6: add GRO_IPV6_MAX_SIZE

 drivers/net/bonding/bond_main.c               |  3 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 81 +++++++++++++++----
 drivers/net/ipvlan/ipvlan_main.c              |  1 +
 drivers/net/loopback.c                        |  2 +
 drivers/net/macvlan.c                         |  1 +
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     | 32 ++++++++
 include/linux/skbuff.h                        | 14 +---
 include/net/ipv6.h                            | 42 ++++++++++
 include/uapi/linux/if_link.h                  |  3 +
 net/core/dev.c                                |  4 +
 net/core/gro.c                                | 20 ++++-
 net/core/rtnetlink.c                          | 33 ++++++++
 net/core/skbuff.c                             | 21 ++++-
 net/core/sock.c                               |  6 ++
 net/ipv4/tcp_cubic.c                          |  4 +-
 net/ipv6/ip6_offload.c                        | 32 +++++++-
 net/ipv6/ip6_output.c                         | 22 ++++-
 tools/include/uapi/linux/if_link.h            |  3 +
 22 files changed, 329 insertions(+), 47 deletions(-)

-- 
2.35.0.rc2.247.g8bbb082509-goog

