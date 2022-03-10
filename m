Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226844D40DC
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiCJFsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:08 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32AAF957C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:07 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q13so3914724plk.12
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZCe/6ZClLYInlxTeX10U82kuzpN5xGRzTMfGtSXIzo=;
        b=lqfUBafRW1i7i4xfd/ODCd/l/TeGLRQZpXpQDskafVwKrn3xQ/9wUXS16J3EnN6NwB
         fultZLh013rlIAGZ+yTCoCkQ/f/sG8dtfOG4ix60z1KzFlorxcgt+p2qxthZEZyXOpQR
         hoxzQEBD8v4k2lq2AbHdsxkr7tr+R6tNh9hY6AHqIWsqPFCvC18tBJQTpzf1Y5N3c2t/
         7flQbBB8DHs9p9OgqbS46pFnrFmjtPM3xp6j/Am/MNykEX3kEs2J15u1PLYV8qx0PqKZ
         y0kee+zpUCWrZOkGw7NZZGIYoHcMTrNDvL92zYk0E21Mx0o4Ncou3EQvsoFX8xOAAHsj
         IK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZCe/6ZClLYInlxTeX10U82kuzpN5xGRzTMfGtSXIzo=;
        b=skwskLbl+TLbaFHS7sTkTF5VQeHF2gqSuncQVVNMQuruBEtq33InORJY2nslkCMnaA
         uUjnepNQY0auhqpRw+8/iHX3ADVDq+QK7S3KkArKLD53YRGM/KtTiGxnlztwBUOD3VCi
         /3oE0cp4klLZIobaFIcL3AdMbIzWwY7fv6H8IgYZkq1mMCkhg3U2NVP4akw4aRVxu0Ey
         MZiooRYIBh3SkJlJFU8txAUaMHvsHAiLuoLqNw4/Vb6wS+g8zyCW0JYILUCRifJNsbIY
         iydZiGSjZWoXR/M7+xiFYJGrg8tXoNZ0ol2T4YDf/glSSx1vtA8q2e7WgcRhYbpAfEV7
         2NOQ==
X-Gm-Message-State: AOAM533E4OGkUropIVpmt0eKhGWBAlk4P1Tw9GLxJIalMBoOvreVv99L
        mAQoGUR382R3Npl//GxNsNA=
X-Google-Smtp-Source: ABdhPJwC4s55PA8434WgHMPK2JDYgZOG0g+PgMYZ3K8YuMdNbSpEHuLkTZWWBqk/VC+StgO1vcS2Mg==
X-Received: by 2002:a17:90a:17e6:b0:1be:d65e:82b4 with SMTP id q93-20020a17090a17e600b001bed65e82b4mr3231679pja.166.1646891227453;
        Wed, 09 Mar 2022 21:47:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 00/14] tcp: BIG TCP implementation
Date:   Wed,  9 Mar 2022 21:46:49 -0800
Message-Id: <20220310054703.849899-1-eric.dumazet@gmail.com>
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

While tcpdump recognizes the HBH/Jumbo header, standard pcap filters
are unable to skip over IPv6 extension headers.

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

v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y in mlx5 (Jakub)

v3: Fixed a typo in RFC number (Alexander)
    Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.

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
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
 drivers/net/ipvlan/ipvlan_main.c              |  1 +
 drivers/net/loopback.c                        |  2 +
 drivers/net/macvlan.c                         |  1 +
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     | 32 +++++++
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
 20 files changed, 336 insertions(+), 34 deletions(-)

-- 
2.35.1.616.g0bdcbb4464-goog

