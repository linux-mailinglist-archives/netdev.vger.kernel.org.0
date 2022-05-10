Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82A520C12
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiEJDgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiEJDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:22 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D58B179096
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id a191so13614668pge.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sx5yHr0RtNdGn0iaLqmYAdJ01EHOBH32C4JbsGDQkmI=;
        b=JZJvVfIGUUVfiKCkzcRUBwCkM9A1A2BGGE2p6N2HbPpE5Yx4dXP6cT1xdSWGbhrRmh
         uoynuRJ0E5fRe0hknXieaTHpoej0slQlsX7h70YHFVy4KoB7bTGAc3lm263gLq8eTz9a
         oZinstoX+PT86OPw9WrcYzD9ls71jBBdYSce364TcgQwHW3MJxXeBJSSSAcgYgEn1sAV
         h28necwt0XoV6fguhfqKcA3nI4o+iL7bNCbhTC9XmCkiUO8uoMcuRHWNuM2X+BlXgTSV
         85m+PAN0g0ZVBETts1NC6iREvqBvosU8ol/6F7i6jYqZTZAgYmR89GfktG8PljHQkgRv
         nX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sx5yHr0RtNdGn0iaLqmYAdJ01EHOBH32C4JbsGDQkmI=;
        b=ecWa/lQ83y8B84ZOFXHtoCOACw423PZVJOn5Mq2/kEhVkL4EJIi+8Ul5SfRCz72wWT
         cClCVGJtqSd0QI0t5eMtzfszpyzoPSwHfkHscQZPSYBoHR+yUNzWrXTybg4paP2MHV7A
         O8IGLix1i9pIex6Jhb1AzecHyVLH2sGWPy7hERiY2iYxQuXY+OHhO0JNJ1GVZAtRSMx5
         2lzgGdnaAijihzeaccpTthcPT8Q8+HJqHW7aeu+hs7NSu3BM2uxqa7f/jprkYCZOBCY6
         NLUgzhdulCpEgz5d0pgTGWkfbEHjmwf9KtrTHifqTkzscTqatGU0dmSlmakE/k83/wlw
         wW2g==
X-Gm-Message-State: AOAM532Bbvp9JWdNeucD406Tz/+ZydejCtk8nvZ/hEkIROZSrtmUbXzU
        5NMJu4lEM1imiMCd21cfcKw=
X-Google-Smtp-Source: ABdhPJw0NvJxIGN2VXuM6S5YtRi3PgeXEtnvz0Bps0Uy3sFMWPke/VTZNi0f35fadM2yAysO60yXCg==
X-Received: by 2002:a63:e218:0:b0:3c6:7449:15a2 with SMTP id q24-20020a63e218000000b003c6744915a2mr11718195pgh.515.1652153542902;
        Mon, 09 May 2022 20:32:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 00/13] tcp: BIG TCP implementation
Date:   Mon,  9 May 2022 20:32:06 -0700
Message-Id: <20220510033219.2639364-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

ip link set dev eth0 gro_max_size 185000 gso_max_size 185000
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

v6: fix a compilation error for CONFIG_IPV6=n in
    "net: allow gso_max_size to exceed 65536", reported by kernel bots.

v5: Replaced two patches (that were adding new attributes) with patches
    from Alexander Duyck. Idea is to reuse existing gso_max_size/gro_max_size

v4: Rebased on top of Jakub series (Merge branch 'tso-gso-limit-split')
    max_tso_size is now family independent.

v3: Fixed a typo in RFC number (Alexander)
    Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.

v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
    Addressed feedback, for Alexander and nvidia folks.


Alexander Duyck (2):
  net: allow gso_max_size to exceed 65536
  net: allow gro_max_size to exceed 65536

Coco Li (2):
  ipv6: Add hop-by-hop header to jumbograms in ip6_output
  mlx5: support BIG TCP packets

Eric Dumazet (9):
  net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
  net: limit GSO_MAX_SIZE to 524280 bytes
  tcp_cubic: make hystart_ack_delay() aware of BIG TCP
  ipv6: add struct hop_jumbo_hdr definition
  ipv6/gso: remove temporary HBH/jumbo header
  ipv6/gro: insert temporary HBH/jumbo header
  net: loopback: enable BIG TCP packets
  veth: enable BIG TCP packets
  mlx4: support BIG TCP packets

 drivers/net/ethernet/amd/xgbe/xgbe.h          |  3 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
 drivers/net/ethernet/sfc/ef100_nic.c          |  3 +-
 drivers/net/ethernet/sfc/falcon/tx.c          |  3 +-
 drivers/net/ethernet/sfc/tx_common.c          |  3 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |  3 +-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/loopback.c                        |  2 +
 drivers/net/veth.c                            |  1 +
 drivers/scsi/fcoe/fcoe.c                      |  2 +-
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     | 15 +++-
 include/net/ipv6.h                            | 44 ++++++++++
 include/uapi/linux/if_link.h                  |  2 +
 net/bpf/test_run.c                            |  2 +-
 net/core/dev.c                                |  9 +-
 net/core/gro.c                                |  8 ++
 net/core/rtnetlink.c                          | 16 ++--
 net/core/sock.c                               | 14 ++++
 net/ipv4/tcp_bbr.c                            |  2 +-
 net/ipv4/tcp_cubic.c                          |  4 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/ipv6/ip6_offload.c                        | 56 ++++++++++++-
 net/ipv6/ip6_output.c                         | 22 ++++-
 net/sctp/output.c                             |  3 +-
 tools/include/uapi/linux/if_link.h            |  2 +
 30 files changed, 301 insertions(+), 60 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

