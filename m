Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8219E320F2F
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 02:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhBVBg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 20:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhBVBg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 20:36:26 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020E0C061786;
        Sun, 21 Feb 2021 17:35:46 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kr16so7434158pjb.2;
        Sun, 21 Feb 2021 17:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qybJx7OQtUA+va9ad1ujiUGkl1rkwozY3pUZwjr/v7Y=;
        b=Sjqj6nTqms7lXnfx6l3En4TOUffwRiRoSrJCdch/tvaxIP7e3yGlx8TMuBamWNor+E
         yDzC4VvCMGOMe6m9aBvfSQJVUwRiA9PF57e0LpQrSJ1jnvasDv7iFb2JMqWEP15aqHdN
         6fXyqXzkcWTPaL4z99jB2DHhAs+d0DwPuj93XDW2y8gPNyKg6LbA8ahpe0wF3B0MS+IE
         nkqkd4yVLFjhyyNfw+KzugjgsqYPMzj8nX8fUECz0DLSTNtY9riTEYxYmT6rQIMzKi7C
         LDTJBTE6hU2Clnmbze3jPCeVJEsJeojTIIBGAIm0xFqDMu7F1RCMMJ12lUvO6x4FzKif
         wSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qybJx7OQtUA+va9ad1ujiUGkl1rkwozY3pUZwjr/v7Y=;
        b=KsAds7TO6GqquqfvJfTo8uKeC0u7FY9+7CcGkfuLTyi1OUm7siMJtFALMLuHShSZrR
         57A3fsyaBNTDmOWDx0yqyXSkwPL7qV1CM2k8t9cXXsYBjbhrzlghjzap9nfhd+eOcrgb
         DjW6DZ2br3qXgb60Znk4ZPt086yZT6zOcO3VviXH1CPVuq8oVHnhotJdV6FgitlBz/zo
         IYudfhKzj341R8Wc0tovqyqDoc++N6sYWeiBrOQVfMRYS2RhQoIaFBmZ4yf4C/67e0xF
         +MBtM0a8Kf8gwprlmK9YUb2hRjfXoOiec4PARPFdNHAO51IwSQoiS6K2cwLWWXrSgZkv
         PQ3g==
X-Gm-Message-State: AOAM531FyUcaPS6jEhSTu0aee5YjoqeADsaxAQWSJ2ynJHMULpja1LzF
        JzxtqRpuoU19X7AjfFS+1QrWL4e1az8=
X-Google-Smtp-Source: ABdhPJy6X3PZ66NbVzloW52Kh4EuWjMyI5A8xpDX593ZdKEf5YhMZw9+9oEvGpdC+fTzV+4s0WgmEg==
X-Received: by 2002:a17:90a:9484:: with SMTP id s4mr13999097pjo.170.1613957745546;
        Sun, 21 Feb 2021 17:35:45 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id t189sm13570196pgt.39.2021.02.21.17.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 17:35:45 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH net] bcm63xx_enet: fix sporadic kernel panic
Date:   Mon, 22 Feb 2021 09:35:30 +0800
Message-Id: <20210222013530.1356-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ndo_stop functions, netdev_completed_queue() is called during forced
tx reclaim, after netdev_reset_queue(). This may trigger kernel panic if
there is any tx skb left.

This patch moves netdev_reset_queue() to after tx reclaim, so BQL can
complete successfully then reset.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index fd8767213165..977f097fc7bf 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1192,7 +1192,6 @@ static int bcm_enet_stop(struct net_device *dev)
 	kdev = &priv->pdev->dev;
 
 	netif_stop_queue(dev);
-	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	if (priv->has_phy)
 		phy_stop(dev->phydev);
@@ -1231,6 +1230,9 @@ static int bcm_enet_stop(struct net_device *dev)
 	if (priv->has_phy)
 		phy_disconnect(dev->phydev);
 
+	/* reset BQL after forced tx reclaim to prevent kernel panic */
+	netdev_reset_queue(dev);
+
 	return 0;
 }
 
@@ -2343,7 +2345,6 @@ static int bcm_enetsw_stop(struct net_device *dev)
 
 	del_timer_sync(&priv->swphy_poll);
 	netif_stop_queue(dev);
-	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	del_timer_sync(&priv->rx_timeout);
 
@@ -2371,6 +2372,9 @@ static int bcm_enetsw_stop(struct net_device *dev)
 		free_irq(priv->irq_tx, dev);
 	free_irq(priv->irq_rx, dev);
 
+	/* reset BQL after forced tx reclaim to prevent kernel panic */
+	netdev_reset_queue(dev);
+
 	return 0;
 }
 
-- 
2.17.1

