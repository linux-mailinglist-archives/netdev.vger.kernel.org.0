Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41784A7D92
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348902AbiBCBw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348924AbiBCBwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB80C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:17 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d18so888345plg.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d73mP/tslGUDeg3cwjnVJvew+HRc4poPcwpop76ku2E=;
        b=p2cvVd1Bq8JDzMj7nRK1m8TyTOKk07eHzY0vK2JqaBcQNEwLSCHave8Mp6ULm5/Kfo
         a1sPocW2kXGbKbwFNnBinAkRoOiqF/x+ZC5XWA2QHHq7t/aXdiOun946ZmuhyzxpJeQR
         Ph0D5CnXBQpXarx4lIsgUNL7c+BXvKek+7JIEeBZO6+fM2Bt5XAIXKurpDSgHwuYypB5
         PB3gmgWCTSVTMPqEaANcWieYDf7KomTrWLI3R61TEsFVPSNbl9ip/tGIHlRVbr//wbhd
         4jaArfxFpWp8qWqwwAfB6f3H/qgcy47gif+WQqER6HryZwt97Mf2/wZk0bXZrKApMFKz
         5ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d73mP/tslGUDeg3cwjnVJvew+HRc4poPcwpop76ku2E=;
        b=suzllBrN6IPWL8/1hKjAFxJ8itWzOtplJ64XFrsAy1JX9gp3Wh5Tm1hMn5r78x0p/6
         kGsff/C76q5lBK/88NRZKEjBgsfeMbUCtef4+/rDeBMCC+uUcIMbkNcWyosy3gnhA3ce
         3s8IekpRxutAMCGvSK91ZMfOywEAfYhjh4wkqEZ4wnDWCplMDYfwDY1L7ePbn70zV90Z
         MICV5QJnf4tuywPmrUM69VqtEkd4x2eBeu6xiRDZSqNqX65U2f07bAyxkm0kcbadVZRT
         KfbUreFM6UnB0sqV8m9LPLDuHZu++UXghY5iFhBmJrO2hQugF+VtcBjiRHug23Y5mPeH
         ft+w==
X-Gm-Message-State: AOAM531xfK9TA2LxctzuePe1Zn3xMthUknnnYLy1FuYloMoHOMJ+2V7K
        KjM4909HsYvnwA/Sv+SYm6U=
X-Google-Smtp-Source: ABdhPJxBZGVnFuxHx3JsChhC/FrML55DOgNHubtg2cbwDdilb7VWRiH9nZhTRnm+AApqkYYoOheIpg==
X-Received: by 2002:a17:902:7c02:: with SMTP id x2mr32427558pll.47.1643853137296;
        Wed, 02 Feb 2022 17:52:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 13/15] ipvlan: enable BIG TCP Packets
Date:   Wed,  2 Feb 2022 17:51:38 -0800
Message-Id: <20220203015140.3022854-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

Inherit tso_ipv6_max_size from physical device.

Tested:

eth0 tso_ipv6_max_size is set to 524288

ip link add link eth0 name ipvl1 type ipvlan
ip -d link show ipvl1
10: ipvl1@eth0:...
	ipvlan  mode l3 bridge addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 gro_max_size 65536 gso_ipv6_max_size 65535 tso_ipv6_max_size 524288 gro_ipv6_max_size 65536

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 696e245f6d009d4d5d4a9c3523e4aa1e5d0f8bb6..4de30df25f19b32a78a06d18c99e94662307b7fb 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -141,6 +141,7 @@ static int ipvlan_init(struct net_device *dev)
 	dev->hw_enc_features |= dev->features;
 	netif_set_gso_max_size(dev, phy_dev->gso_max_size);
 	netif_set_gso_max_segs(dev, phy_dev->gso_max_segs);
+	netif_set_tso_ipv6_max_size(dev, phy_dev->tso_ipv6_max_size);
 	dev->hard_header_len = phy_dev->hard_header_len;
 
 	netdev_lockdep_set_classes(dev);
-- 
2.35.0.rc2.247.g8bbb082509-goog

