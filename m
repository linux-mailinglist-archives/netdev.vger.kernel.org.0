Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7A851DC29
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443131AbiEFPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443069AbiEFPfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64CE6EB19
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:30:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d25so6532646pfo.10
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IhFpce06SSbFqSJ34tlsllWCBtPtDlgDYDnmYP23xwo=;
        b=IIgG8r23zPZZkvPLwjxQ7TrOsph0ON+wkx3PmWRHypC9qLuCRO0cr0kZrMx/TjxB3u
         QJZDE0nYhkM6q7WoDw1/Ov5WZbnPOAf9zvurH0ImTYAaN2ufRT2togpr3CwxMe0V8yQZ
         IRjsTMlk7S//uf5+ERNRfHFVg7XzCov6PLW36iO8Asev1uOhsFzoVdU1nzkrl/vIiTXo
         eT4H8m1K4hphiMFbWhjwXcjvibenvHRvMgg3JdRkEUynaaNJ/eS2oYwGFnQ+dugxDCoV
         TQk6N3OP3kcj8utpGS8HEYmbvJCEIb38Yg/Cv5/zA9kWSqhEYdnyYqcPfZweScLFOZiY
         +guA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IhFpce06SSbFqSJ34tlsllWCBtPtDlgDYDnmYP23xwo=;
        b=iEH90jhrzyuBclB5Vxh79voxviGuAD+KIHwu9PCzkSq/aCBs0br/lhgSSRFDq+c5Qv
         mEJo8B8CEzAXIe8uQh9KLdxg52atRKkC3zGKjJk+T4gpveZdOQK2hr25kmZB5wMRSjES
         qrwUOzIITO1Z+CfifnP1g0cgugsaOrzWFSNphL4ZTfI/Yb6qG+QniWA7+0CxLfy/K+Iw
         LTCTlUc/zaNwZpf8X2/jG8try44WhuIq7AoxAZlWjwOnJzmhpaFMfVCCj+7kk4U1ppMB
         gg2DrweL6m2bchHndm3awEmi9+quQud3SS0UJMGZGlS5xvktAeurTwiCPhsFT/7BuLOc
         96wA==
X-Gm-Message-State: AOAM530eHqz7JqgCHNU+PZNDc1jb68K/MgQfLPgCM0ve1IdJSZ/Eq3UC
        Aan3mzq65zIfUDePhdthG4IXh2Ydg2Y=
X-Google-Smtp-Source: ABdhPJwYv6FqI1HPGBhsTGO/nrFbUARrfl293/EeWc+vtiiPnXKMFpTEOMg+dYxqA4UAHKU8npYukw==
X-Received: by 2002:a63:4903:0:b0:3c3:daa:c417 with SMTP id w3-20020a634903000000b003c30daac417mr3188788pga.543.1651851058003;
        Fri, 06 May 2022 08:30:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:30:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 00/12] tcp: BIG TCP implementation
Date:   Fri,  6 May 2022 08:30:36 -0700
Message-Id: <20220506153048.3695721-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
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

v4: Rebased on top of Jakub series (Merge branch 'tso-gso-limit-split')
    max_tso_size is now family independent.

v3: Fixed a typo in RFC number (Alexander)
    Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.

v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
    Addressed feedback, for Alexander and nvidia folks.


Coco Li (4):
  ipv6: add IFLA_GSO_IPV6_MAX_SIZE
  ipv6: add IFLA_GRO_IPV6_MAX_SIZE
  ipv6: Add hop-by-hop header to jumbograms in ip6_output
  mlx5: support BIG TCP packets

Eric Dumazet (8):
  net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
  tcp_cubic: make hystart_ack_delay() aware of BIG TCP
  ipv6: add struct hop_jumbo_hdr definition
  ipv6/gso: remove temporary HBH/jumbo header
  ipv6/gro: insert temporary HBH/jumbo header
  net: loopback: enable BIG TCP packets
  veth: enable BIG TCP packets
  mlx4: support BIG TCP packets

 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
 drivers/net/loopback.c                        |  2 +
 drivers/net/veth.c                            |  1 +
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     |  5 ++
 include/net/ipv6.h                            | 44 ++++++++++
 include/uapi/linux/if_link.h                  |  4 +
 net/core/dev.c                                |  3 +
 net/core/gro.c                                | 20 ++++-
 net/core/rtnetlink.c                          | 51 +++++++++++
 net/core/sock.c                               |  8 ++
 net/ipv4/tcp_cubic.c                          |  4 +-
 net/ipv6/ip6_offload.c                        | 56 ++++++++++++-
 net/ipv6/ip6_output.c                         | 22 ++++-
 tools/include/uapi/linux/if_link.h            |  4 +
 18 files changed, 326 insertions(+), 34 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

