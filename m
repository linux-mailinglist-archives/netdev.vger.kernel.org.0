Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB717450A7E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhKORJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhKORH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:07:59 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65600C061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:05:01 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x64so15614718pfd.6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eD8R9ZDahXj+ONPUyg8ZZVkHqyjr47+1hytqH4aKz6Q=;
        b=V2fC8MpsigL8nyLWhyC9P1opIn5DbpFRcRP0NE0+4TsJB2d/yFwoIQsxh4BEmUpmFr
         XH3A7bhtAzhDx+gzOmDrfbn7QCpyF8U8YoMDafV+PGXj7KeHjw1q4EzZqLG5WG2JSDnX
         0KTHHbaFsioPr8gG07++TuiiQWmj7LeKveqCAECqNXRae2l3fTZTeE+JrdJF4zivSOF3
         pT6vt+8b0aeiLu5qV4hiGwZqnD0b2vVxaJyujTK5NpbpgTC6a3rPxjaAGwgBoypSrRdK
         8l/XrhVfCJ8a4Lm7wOOBcPGJAaGxGnb70zIPNZ2nSIkznmfK/kAC9hcYVBxX7u9JjwKO
         B1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eD8R9ZDahXj+ONPUyg8ZZVkHqyjr47+1hytqH4aKz6Q=;
        b=bYvrNNLegRqH2pYO5LzklbKmEV6RiaJrjKjooVVdb1sX42BV/Y19McGg9eccdUETLv
         PVDtuIDn9xLuvSMA8soO00CIm5RFN0WqmYOiR5/bSJ/A4YJoZlgb8wv9WhAnkXnoVavM
         JkXdfBwuAwSFUUenSn36UrL8LxwpuFNIXayUiWZm2yXkTI/EXT5WdiaUTZIsA/2464r7
         mV30WCUWPr7rgvKwXf3Q6f3amH5H2ius5HWzoxdgJiCA7aLM98dFaC4OEgBcPd/oTc07
         aojw9BQG3K/PcFU6aPz5WeY/SsClrGON7Sylq/HruoXU0zAETyjifdOL0Shjv/aP3fTQ
         1T8A==
X-Gm-Message-State: AOAM5301q4UXH70JLyPMiRaXbYiPrF5QG10nTiI8PaxhgQ3qzd1Eculp
        M7WIyH80+o1KjKFe7ZjP7vA=
X-Google-Smtp-Source: ABdhPJxXyQlQmInC8alvAH9wsqVAjOLsdOFV65Fk7SfSQz3CA6t8rOrwPOcVP3eTCdPuq+BdfrQUPA==
X-Received: by 2002:a63:1862:: with SMTP id 34mr210045pgy.239.1636995900926;
        Mon, 15 Nov 2021 09:05:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id lx12sm21455589pjb.5.2021.11.15.09.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:05:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, x86@kernel.org
Subject: [PATCH net-next 0/4] gro: get out of core files
Date:   Mon, 15 Nov 2021 09:04:53 -0800
Message-Id: <20211115170457.3645273-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Move GRO related content into net/core/gro.c
and include/net/gro.h.

This reduces GRO scope to where it is really needed,
and shrinks too big files (include/linux/netdevice.h
and net/core/dev.c)

Eric Dumazet (4):
  net: move gro definitions to include/net/gro.h
  net: gro: move skb_gro_receive_list to udp_offload.c
  net: gro: move skb_gro_receive into net/core/gro.c
  net: gro: populate net/core/gro.c

 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
 drivers/net/geneve.c                          |   1 +
 drivers/net/vxlan.c                           |   1 +
 include/linux/netdevice.h                     | 351 +-------
 include/net/gro.h                             | 420 +++++++++-
 include/net/ip.h                              |   8 -
 include/net/ip6_checksum.h                    |   8 -
 include/net/udp.h                             |  24 -
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                | 668 +--------------
 net/core/gro.c                                | 766 ++++++++++++++++++
 net/core/skbuff.c                             | 142 ----
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/esp4_offload.c                       |   1 +
 net/ipv4/fou.c                                |   1 +
 net/ipv4/gre_offload.c                        |   1 +
 net/ipv4/tcp_offload.c                        |   1 +
 net/ipv4/udp_offload.c                        |  28 +
 net/ipv6/esp6_offload.c                       |   1 +
 net/ipv6/tcpv6_offload.c                      |   1 +
 net/ipv6/udp_offload.c                        |   1 +
 25 files changed, 1230 insertions(+), 1202 deletions(-)
 create mode 100644 net/core/gro.c

-- 
2.34.0.rc1.387.gb447b232ab-goog

