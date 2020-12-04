Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37C92CE7CD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgLDFtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgLDFtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:49:01 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA1C061A53
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 21:48:21 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 131so2936405pfb.9
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 21:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=of/Rhc+0bi+IvNoMbGKE4kiHJpQlcGGA3pBmGFfzz6o=;
        b=EEVNq6GCW/NAGR38vXWuZd9WuVaPpUS/QRqE2Ae9dXuhD/L+YVKJycxAPHcXzon8Z5
         v0jHE8B+wHClsbFZJUJgWBy9xviIZTGK2TBBgxD2Cv1Oj92tkfw3GFhksJ5wk9+JZ5VM
         +LApSGNhDBgSdTn4ElSyjaf/6ubziPVSFUvK63XljXIekAEIzHUlvA7J8dTB4OKVhSd+
         m1it50ul/Vdnf/y/t8RQ7iuS3QrmDCfWpWmjuO7jSnrMqmBRtHs5qiRls6PQmZ8NGwwG
         Z910RHG+9D6QI9KD/FWsFGfalhX/YQhqrpmP3d4VTFQjUb/tYXMYTefpPMzn33tNzKWT
         ZVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=of/Rhc+0bi+IvNoMbGKE4kiHJpQlcGGA3pBmGFfzz6o=;
        b=iqN9RDt5G659t5gO5eXzqt0lpRcZM/mVfk5Rg0h+3nCBbF8+QTwKW0I+kwOLDoujdB
         NuSaCQSJT3kdcLv+CqWA8g8u7pYYQX5FqZTsoW09tvWak0Up1Rw3jNRCxpurr2Ch7yL6
         os7Z0h8wRU5DmqzJv4hfdRBQDTgBDJ+CH4JRn6QVCYZoJaHQX0KCU/5ElWAm+QPdOu3C
         qxLpSUoPjoeb4qFcm2ySrQ/HXyGWg3rq3aGRB6yzg02j9jTzzELvwEY48o4d2XbOmDFW
         YBee1sLScbKsw9RW7NKKcKzCT9f4veL8ccUirG3SS4vQZJ9cbD0RXcLWvpww2p09DRkG
         dPWA==
X-Gm-Message-State: AOAM531ALBzboJWohkX0YIfM/G1JOujzg9tUxwvohsN15ggfSK7L03Ra
        yPaMBjYwXsbgr9hpB0Pulz4=
X-Google-Smtp-Source: ABdhPJyTlBlGHeXizgaGQJ4ViRhehGhJNQePGaOSqY1kh8yeGjkjxJ2cylkZd2HHdCpLn1I3okNWyw==
X-Received: by 2002:a62:ed01:0:b029:19a:a667:9925 with SMTP id u1-20020a62ed010000b029019aa6679925mr2248582pfh.35.1607060901166;
        Thu, 03 Dec 2020 21:48:21 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id u205sm3542134pfc.146.2020.12.03.21.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 21:48:20 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bcm63xx_enet: add BQL support
Date:   Fri,  4 Dec 2020 13:46:14 +0800
Message-Id: <20201204054616.26876-2-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204054616.26876-1-liew.s.piaw@gmail.com>
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Byte Queue Limits support to reduce/remove bufferbloat in
bcm63xx_enet.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index b82b7805c36a..c1eba5fa3258 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -417,9 +417,11 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 {
 	struct bcm_enet_priv *priv;
+	unsigned int bytes;
 	int released;
 
 	priv = netdev_priv(dev);
+	bytes = 0;
 	released = 0;
 
 	while (priv->tx_desc_count < priv->tx_ring_size) {
@@ -456,10 +458,13 @@ static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 		if (desc->len_stat & DMADESC_UNDER_MASK)
 			dev->stats.tx_errors++;
 
+		bytes += skb->len;
 		dev_kfree_skb(skb);
 		released++;
 	}
 
+	netdev_completed_queue(dev, released, bytes);
+
 	if (netif_queue_stopped(dev) && released)
 		netif_wake_queue(dev);
 
@@ -626,6 +631,8 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	desc->len_stat = len_stat;
 	wmb();
 
+	netdev_sent_queue(dev, skb->len);
+
 	/* kick tx dma */
 	enet_dmac_writel(priv, priv->dma_chan_en_mask,
 				 ENETDMAC_CHANCFG, priv->tx_chan);
@@ -1069,6 +1076,7 @@ static int bcm_enet_open(struct net_device *dev)
 	else
 		bcm_enet_adjust_link(dev);
 
+	netdev_reset_queue(dev);
 	netif_start_queue(dev);
 	return 0;
 
@@ -2246,6 +2254,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 			 ENETDMAC_IRMASK, priv->tx_chan);
 
 	netif_carrier_on(dev);
+	netdev_reset_queue(dev);
 	netif_start_queue(dev);
 
 	/* apply override config for bypass_link ports here. */
-- 
2.17.1

