Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D84D3E29
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbiCJAag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiCJAaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:15 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A5812550C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:14 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q19so3334887pgm.6
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=mh5DmYY9HZsZPKbbm2kRTlXrqyzZ38TmnzWnQQpfvKX319QO4WwDWZZJ7Tkwqf6FfA
         ZzTfWdb4cVHySJVx548xYdpDPSeJkCwELNw2U+oiIQ7kQ2e+/NqnH459Yjc0UgbgsNiM
         EYiAX76cxdO1z3371QBas51OJSl1UG5tFucI0mMFClgBT5kkr/pIlCl9eUJqcIikp8CX
         GYe4k3nMa97X5huTEWwNPxibgwcjONQYeLxs1N9mqTB+pQmuQiQ//DIGhi9WwYQlNViR
         JGrmqKSmRXp1OF98Tm4tU8QAZ6bTbQY/M47F8T2jzBzwtK6zXTpBWLd44M5v9X0H06UY
         RMhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34jEWn3KlsSJ9jeDwhLaeV4mw//NGL1b1oh39nIT+68=;
        b=xJB+GczrgoF36hCkTCxlXf0RmM85pMtjxo6OpttAbN76DFs9qm91nvqwuDJ2Adf63n
         aD7u7bm6RP0/pTEKjlN9YJC/zNdtc9KjX8C/e0I03BJqGDSzQPf6+CdMs7WrmqmpUdFM
         akWYk3oQHBnJq3aRqu2fJ52ZKaeCRfaqmauc7sHcS5rcuur/qLnxpgx/4qDQzpd9VyMO
         VcwKp8DPRSVDVXvunia7ULWgynBNM6rNN3OJRKpMEUOY3OY9bFt87AHlK0n7DlQjVgcr
         gvWihIDAC9UIuASiUx2sJ1XtjO3ocEM+e/yBCkmT1huoMHaJdpOO0pe6TuylUVssB/Gi
         WRXQ==
X-Gm-Message-State: AOAM531R9ePNrlSvYET7saWKjP9Rqu3T+C2DaLOoegoZAr+MTwIMG3Sw
        DLocDFbmNzKItY1X14YjcAIYJh4BGGQ=
X-Google-Smtp-Source: ABdhPJypG6OJIXgYy1pLmPxGtYvsBDdJGuGTrBKSBG3SB95LXlN074+PhuYTgJckz8W1BoeuebpqTw==
X-Received: by 2002:a63:4041:0:b0:37f:8077:e0de with SMTP id n62-20020a634041000000b0037f8077e0demr1854922pga.138.1646872154239;
        Wed, 09 Mar 2022 16:29:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v3 net-next 12/14] ipvlan: enable BIG TCP Packets
Date:   Wed,  9 Mar 2022 16:28:44 -0800
Message-Id: <20220310002846.460907-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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
2.35.1.616.g0bdcbb4464-goog

