Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E84D2EBFC5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbhAFOny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAFOnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:43:53 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75BCC061358;
        Wed,  6 Jan 2021 06:43:12 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lj6so1655293pjb.0;
        Wed, 06 Jan 2021 06:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=etftZ6kOn5Ec3/YvWRT/0S0dVxzc8TqdLkBXJCyGh9hlG/yi8IYlOkjSskH8BKEDz2
         7rRmZClbEx36W9sDTajXoYQqsxDmhSlLVyHJW+pdAqZWpBgujtPZXPDX90JELHIYM3vW
         BeOuWiIVQnTXqnzgcn/KvrndrQ0pVVghzXTq+R9SL3jsNJXLHEO9pUapZnTOEyh2hQw2
         jydNNlCT3zLIfIhhCxofcMTrHWWvRObtUQcrLREOYdJTTbu6FN/iOcxauwWN7eyYcVLz
         /Z7MjLg/IIpZ0WMKlPfCVztBkpibXxfVlBWmx2x/UTbV4h5sq1HEDufTSO6KFPCjVQdg
         NLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=rOAtYKBpw4HN/EVDHWxNiz2BmGmLcKGYiVaYg2fXL3vVGSeS6r7dcsYuoXzPpvnCiH
         lHpL9B99jw3VMOvgZ0en07CGWYXgs1D7NWMAmFELmfNisZOeuYokihC3udnpAsyTNLnn
         5a7mwoFMYsc8gmZuuDZ+Qw+3Zj6J8Cij0PNo+wHlOgOiqqv+S5/oxYr7KVqQdqO93MgF
         xArtVWoyTLbO7sQDJxhN2enO7hEKzY7QIdTw+cNPSDy8dh+cgU62Kik8Vedtcd7QB2Oj
         +55vr5Pz9Y/qdr7P3MoTmbxHN7mDHGO/klIXKXzby7oE97m43T+d8KN93BiOXW/d7wGT
         HZyA==
X-Gm-Message-State: AOAM5316v2k/opxIrQ3Q4qL2/zC7YFucU85pfF/ePhwsBTbfrFnDPWYF
        eDATilWDDA6ph4/V33ftq3nOGjqz3AM=
X-Google-Smtp-Source: ABdhPJwBkD64n6wJ4zsenbZnKQOtt9mVoT9cbikyC3Zc9lxS+Nbe8MXUSHR7tOpBXvVM0AVTAAIqAA==
X-Received: by 2002:a17:902:8643:b029:da:d5f9:28f6 with SMTP id y3-20020a1709028643b02900dad5f928f6mr4627912plt.8.1609944192439;
        Wed, 06 Jan 2021 06:43:12 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:12 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/7] bcm63xx_enet: batch process rx path
Date:   Wed,  6 Jan 2021 22:42:02 +0800
Message-Id: <20210106144208.1935-2-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
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

