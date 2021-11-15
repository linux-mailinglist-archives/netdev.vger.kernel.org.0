Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9A450A7C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKORJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhKORI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:08:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC1CC061570
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:05:59 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id b4so15076619pgh.10
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eD8R9ZDahXj+ONPUyg8ZZVkHqyjr47+1hytqH4aKz6Q=;
        b=Q/6Xc+tB5r/W1sFcU1J9Bsj57kkwUNNIN7WYIjrGx4/TM+cLp2ssoRV0F2+glTIyH/
         LJzWiAPANZlaAzT4e6UuoojahjTAQEAwb2Wnb8rasf5zn5jQR533SKOa9KQnom+hIGw2
         XJZhzRe3hZjf5BnbkAk+KnfZ3dyYndCKWCdyXyV9rCYE88gu/yxch7apwZAmau5JV+Xr
         a7cTjGXV47kP/VwNKNGjnFUxs+r5tIv/LZXE2cMOgDKNA+tQW3JaA2L5AwkczK8Fmg/4
         AwSNhDx7ch8BAt9WwpOg8p6GX+iv+SDExapUxrtfOAPlu4tWnwzcgA/o9jvAuGT89Yya
         8v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eD8R9ZDahXj+ONPUyg8ZZVkHqyjr47+1hytqH4aKz6Q=;
        b=L3wdiGa6YKYtPvKo4kJ2Bgf0y4Xgcxi4MnZdbSbUflQ+eVWf99rxPWRpV3TYANl+IT
         COIcpdwGDzKt4hIXTtAikqM3nP20JUc8uYCVAElOqXJAUJMrqZKNBXjQQCw1nMeRRGwN
         Ke9ATWqhub8sbU4dXFsPiTV9lKLDn2wWn3bPRI/tPifO26H3tuolhyEla9eiY34h1mok
         IZFnB89gAcVsxCTI3TUyEv+3X4rXlSuhhlz8FAOIfwKRkhl2Sdd4E9FbocfF7dyvvAns
         gZBuLbJozQcRsioaqq36BJtt+s92MtUE8BL1mrJd9ponqwBvBkQEVI9m/LEBc5O3hjuR
         NoFQ==
X-Gm-Message-State: AOAM5304hAwe7ImQiyx+LIP3Hob4SiPuCqtJPTeWar73XApZZflJWsk5
        LAXl3yOjsQBeC9vIIJjj2pE=
X-Google-Smtp-Source: ABdhPJxE87cIlYvNMQswZUChUkAn9eoFXV8HWWZKNQb/XhS8kkun1FS1OgqJ8Dbwb2UHwq3DOVt6DQ==
X-Received: by 2002:a05:6a00:24cd:b0:49f:bf3f:c42c with SMTP id d13-20020a056a0024cd00b0049fbf3fc42cmr34453760pfv.54.1636995958580;
        Mon, 15 Nov 2021 09:05:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id y28sm15971845pfa.208.2021.11.15.09.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:05:56 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] gro: get out of core files
Date:   Mon, 15 Nov 2021 09:05:50 -0800
Message-Id: <20211115170554.3645322-1-eric.dumazet@gmail.com>
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

