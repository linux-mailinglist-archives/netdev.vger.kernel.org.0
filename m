Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A8D2E27A5
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgLXO0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgLXO0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB923C0617A6;
        Thu, 24 Dec 2020 06:25:56 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g3so1369797plp.2;
        Thu, 24 Dec 2020 06:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=B1ac8RYcfR0HVkbb2jS+BocnJrDLlducbmElKAAV48TAnyaiN6fYRRAEK4ZhLWYXev
         rjX6vkQ6KuViscu5QkeAZApPOuTyv+VLlaww0nndzoG4z9HbKE0bF/oXN92uZWNLIETe
         3vggtJ/MoEdvdQeJ5xoEO0AgTWe4cUNyU1aPzfM0b2xdBMS3jWZ/p1S5oqBD+DpYzOcm
         MMlJdxqHONk6IHZYLNnc49bTgaKcQjwkTeL1vlBMVJiKnG4iwJLpohRCEUQd0AyVexpA
         Zxldb6prPm/rR9RR8oKTcsxWJGx+dNAPuV7wl0MNjz8qj8yeBEJ60MgEn31F2fh/1rKj
         TTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=Tem2OJhdrNEGt3/i5iyMLYIxBU1YCciv3wjkHfDEYvjAcbJDN/8i+5pTvJrY1oDUUT
         cYb9mPD/BHnJTRrlOtvsZUXANGwA9N0syjXv4KI2ciGccvs/J7hCw6WAuCdNNAs/C/fp
         0GY+l6kmRGdqcImlzzd5uNjejswZr0cvyxbcg7N6w9xd7B3AFBZFY/Qa19qhmLIqFHSX
         SQzf2De24dYVKF9REfav6UbpuGTeGgZDkYqCTkQOaFM5aVlYqbX82PSnU+AmpjawR2rD
         nn0UkXMNuEx2ivB1oBzkaXI5+NUfhE07DgrrtuJr01Wtys9o+xLVL2PjnrlqaGtsTRZa
         hf+g==
X-Gm-Message-State: AOAM532nat40axrkP+kMP2JjTXoWH0tPh+x/ZhPwNm4G5ebgL1Oc+VRZ
        uUJ78mJuKX9MRNrtI1rfCdYUC17mWEM=
X-Google-Smtp-Source: ABdhPJxzyet+DtM30DbI22ABXk9AOvvdUz4j1jffPaDFAWabwG7TS2+/RF74L2MMl0a3HVXwisvOBA==
X-Received: by 2002:a17:902:c113:b029:da:9461:10da with SMTP id 19-20020a170902c113b02900da946110damr24880988pli.42.1608819956471;
        Thu, 24 Dec 2020 06:25:56 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:25:56 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/6] bcm63xx_enet: batch process rx path
Date:   Thu, 24 Dec 2020 22:24:16 +0800
Message-Id: <20201224142421.32350-2-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_receive_skb_list to batch process rx skb.
Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
by 12.5%.

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   120 MBytes  33.7 Mbits/sec  277         sender
[  4]   0.00-30.00  sec   120 MBytes  33.5 Mbits/sec            receiver

After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   136 MBytes  37.9 Mbits/sec  203         sender
[  4]   0.00-30.00  sec   135 MBytes  37.7 Mbits/sec            receiver

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 916824cca3fd..b82b7805c36a 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -297,10 +297,12 @@ static void bcm_enet_refill_rx_timer(struct timer_list *t)
 static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 {
 	struct bcm_enet_priv *priv;
+	struct list_head rx_list;
 	struct device *kdev;
 	int processed;
 
 	priv = netdev_priv(dev);
+	INIT_LIST_HEAD(&rx_list);
 	kdev = &priv->pdev->dev;
 	processed = 0;
 
@@ -391,10 +393,12 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		skb->protocol = eth_type_trans(skb, dev);
 		dev->stats.rx_packets++;
 		dev->stats.rx_bytes += len;
-		netif_receive_skb(skb);
+		list_add_tail(&skb->list, &rx_list);
 
 	} while (--budget > 0);
 
+	netif_receive_skb_list(&rx_list);
+
 	if (processed || !priv->rx_desc_count) {
 		bcm_enet_refill_rx(dev);
 
-- 
2.17.1

