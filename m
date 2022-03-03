Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0544CC4DD
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiCCSRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiCCSRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:17:08 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4E21A3617
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:16:23 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q11so5310569pln.11
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/FGlWEqjy/Hi9ivhFJLpg+HXAOkE3W1UIfCB1vn210=;
        b=omLZ9Pp2u3i96URnFCyJAUn4oOZ0ODav/8rFpuVUChoAmfSfbLIru9PFz/A82FRjB9
         0S+Ue8TZhEyOhxE8Dt3YMAeRYj2WRRtirH1Zm1KRpAx3s4se/Tl98Gfx5kfkebxZiHNq
         gcGpQdBv2bZxTCdrLwTcmWPxuov+907HWSKLp81IU4KR4FF1xE3Ze2TtlwIC4DarBiIF
         CgrcZN7SM1kj/XSVVJ4KypimUWNoHuA9fhmcTJLhAP9LiT8gs+do7b7GzOXbXLOjWIMo
         Bg1acC3eNWg20u4OzrR/2LR68kxZY4M24fzS1h7s39TyJE9N/d3UvLKR/6siLwqZdAO2
         98Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/FGlWEqjy/Hi9ivhFJLpg+HXAOkE3W1UIfCB1vn210=;
        b=lwAht9In+xpbfWJmUofKxPOoidqPflwKfFZSi5KySLRfy2IVNF1STy7cTwHyJcmj3L
         1JDuWLvhF/Uh1IUzMZxgWwL4pgGh6jx4XBWDUbYupyoQZ3sbH8bwXL8a6xX9m0k5Lb6/
         Wkbz+5aaq4w9eSRkLhzZfr3ZGCGSDWcLclFWcTcK5sVV11iv6NECfS71FfE0smLPnN53
         YHfIl4ixYWbd9ZaTQLoRCGCLhGFseBfgB2XF3SuhRt4qGTzj1giSsv2GZNxzMsFYUfrn
         sEjFx3XVm1nLB0239FefW7Rij3+yKv/8t738yPYH+rIOZ76DzmcUhn1elM7LrispzFWc
         foBQ==
X-Gm-Message-State: AOAM533Ib4t/1pHKoClu2FiOxGSUAaDWyLA82UDc6ylCGxGjXwRcWdHP
        32Nb+UbFMjkrQxREFd+poQE=
X-Google-Smtp-Source: ABdhPJy6/l7YrdC++kcsrjmHlGQjjyPIpcbFizSAQsXowfjUpaiHXl+aPUL16q/7V9ScffzI4zJ+cw==
X-Received: by 2002:a17:902:900c:b0:14d:81e9:75d with SMTP id a12-20020a170902900c00b0014d81e9075dmr37383359plp.69.1646331382420;
        Thu, 03 Mar 2022 10:16:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5388:c313:5e37:a261])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7611016pjx.1.2022.03.03.10.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:16:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 00/14] tcp: BIG TCP implementation
Date:   Thu,  3 Mar 2022 10:15:53 -0800
Message-Id: <20220303181607.1094358-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
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

This series implements BIG TCP as presented in netdev 0x15:

https://netdevconf.info/0x15/session.html?BIG-TCP

Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/

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

v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
    Addressed feedback, for Alexander and nvidia folks.

Coco Li (5):
  ipv6: add dev->gso_ipv6_max_size
  ipv6: add GRO_IPV6_MAX_SIZE
  ipv6: Add hop-by-hop header to jumbograms in ip6_output
  ipvlan: enable BIG TCP Packets
  mlx5: support BIG TCP packets

Eric Dumazet (9):
  net: add netdev->tso_ipv6_max_size attribute
  tcp_cubic: make hystart_ack_delay() aware of BIG TCP
  ipv6: add struct hop_jumbo_hdr definition
  ipv6/gso: remove temporary HBH/jumbo header
  ipv6/gro: insert temporary HBH/jumbo header
  net: loopback: enable BIG TCP packets
  bonding: update dev->tso_ipv6_max_size
  macvlan: enable BIG TCP Packets
  mlx4: support BIG TCP packets

 drivers/net/bonding/bond_main.c               |  3 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 82 +++++++++++++++----
 drivers/net/ipvlan/ipvlan_main.c              |  1 +
 drivers/net/loopback.c                        |  2 +
 drivers/net/macvlan.c                         |  1 +
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     | 32 ++++++++
 include/net/ipv6.h                            | 44 ++++++++++
 include/uapi/linux/if_link.h                  |  3 +
 net/core/dev.c                                |  4 +
 net/core/gro.c                                | 20 ++++-
 net/core/rtnetlink.c                          | 33 ++++++++
 net/core/sock.c                               |  6 ++
 net/ipv4/tcp_cubic.c                          |  4 +-
 net/ipv6/ip6_offload.c                        | 56 ++++++++++++-
 net/ipv6/ip6_output.c                         | 22 ++++-
 tools/include/uapi/linux/if_link.h            |  3 +
 20 files changed, 334 insertions(+), 34 deletions(-)

-- 
2.35.1.616.g0bdcbb4464-goog

