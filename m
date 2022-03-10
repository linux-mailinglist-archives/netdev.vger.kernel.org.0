Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842B54D3E21
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbiCJA3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiCJA3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:29:50 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68D6E2354
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:28:50 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o8so3327374pgf.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zv7hiMt195dnN+Ve5h3EgHaTwpPmNJu2sShPemBqYMA=;
        b=SlQnL7yKAUTb1NNRpp+P2p/CbZ9A+g+4HNuqCFPzmT06ibnGKiupIN+9zHr61WMCl6
         FZQjDEzA1bbG0LuAtyniVg+L1eqRWJEjF0a362gwA4yaXsSjKnMNqYH/KGz5Ec9vbsJQ
         Cndb2/qc/rQ6uURrUk2982QdqpvhmVYnus+on1IdyNM0N71/rxN7WIfem7mtE7caKpoS
         LPaDrJijIogLuClrD2kPPgGKvum2BXLUco6+v/eA+agSBRAuAQ4AnWHxF0cVZhdycfSU
         XuwyZz2cY4RAOeNHo3vfVa8OXN8mSkFinimsGEwcPAeyBZQ/W3oUq05uQVjR5PoAnIHd
         2OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zv7hiMt195dnN+Ve5h3EgHaTwpPmNJu2sShPemBqYMA=;
        b=MzLy4Vls3N1SeF9diw+VcWQSRnz0J+a9eVI/mgHQ28hAMsAqRBcwrIlekQ7xPneMMG
         IajTkJxfzFUzfHTDuPKKEbh3XzdzMeQMAniEUfHM1oXafV1Oe5GeObKn88vbKHk9NaLB
         lpicOqspgDr6rjtyGGzOeMDdkMcIl1gPGmgJ92HXZ80EzhyV/66rZOgvKpT6SvYEIXeu
         P6dns9BrQSLvgdm46xEL6qjj1rUDTevD4awEMHcK0dvmvU18/eIS4BjSDvvd9fDp9VWs
         QQe/5A3rq7V57JL1x/R2OPCUru1C+IIJc4pbNNMMsVy15d/R7XI5qmAJfwqczeBJWqaH
         5dhQ==
X-Gm-Message-State: AOAM53166b95Sj6ujxqKCRaxUu2EUTpNDuRDU+z9x94o62tKPhxk574+
        T4opoiuLCVtJ0E+m4OdhF8k=
X-Google-Smtp-Source: ABdhPJzSaZzC7Hg1/QRRVbk7lWxabbFQKhqa4dUl4cVsdAVNXa9cewpA7nmmoJ9sCmJczoHyux0VGA==
X-Received: by 2002:a05:6a00:1a42:b0:4c9:f270:1f39 with SMTP id h2-20020a056a001a4200b004c9f2701f39mr2143707pfv.50.1646872130170;
        Wed, 09 Mar 2022 16:28:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:28:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 00/14] tcp: BIG TCP implementation
Date:   Wed,  9 Mar 2022 16:28:32 -0800
Message-Id: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

