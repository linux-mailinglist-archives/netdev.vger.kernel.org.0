Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B372EBFB8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbhAFOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAFOnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:43:55 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C87CC061359;
        Wed,  6 Jan 2021 06:43:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g3so1655760plp.2;
        Wed, 06 Jan 2021 06:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W6/+FtIew+DXRW3+N/9J9qYZ49HugSJ5H2PNvgyUorQ=;
        b=KjUbm8X+6VcOdIetuU0rQ2YE+NfSHkfxjz5dwEoD2cUl207fgHqKpCeXQYe2TdZdPL
         mUOj/Tthh2YNsxqbeBaPr/TpTnf3oZ54ugcJmiycrcRVxDCGHRTtBiJKxRBlBTq1qxRk
         u+bIsDLWE6zUbWbfsgbEVTEG8jeUb4ALs0rWGW2MyPEtGoj8K4izS+fzto7QkPDBBWXK
         KkR0+R4MtEiJvZkbQxGypfWCKC0WWlEEVuTG0X+QBCLutvXxWOvDPhuefdvLf5w1VRdb
         DdqHANXaupWNqnJ8lHSbpTWSzPUwJShGJBKAdksJ0LAr1gYUaDOzu3JsWuQtvHL1uNeo
         tugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W6/+FtIew+DXRW3+N/9J9qYZ49HugSJ5H2PNvgyUorQ=;
        b=pRsFda9su1cykWBL8epmxQiCdZn0qcP9TD3qdbfA8s80Uzg0Ij2zJ9hfQ0o4+aMS3Z
         u2d27uM/Ih4zRDNXRNphOuMtuIZgJEEZ2pkvNfY4uR+eQTmLkCvgIOM2PdjRrJi/37c2
         OodeZiTXBL88m1qm1oC23z0yqt/ze2QR7JDvHc90lCupX/X8It/f+QOOg/NDMse92od6
         rvTqwOIT+G8/I65lT7ZePXpc2rDwpsKtQUqk3Sbyb2z5wTjuJ+LQBugVCoVqLQTBjHbZ
         4PLp57jVFUK5lNwTKo6Jyy6W3mACwJO9xdENjW5w2Xy3bvr1NXA58wMrwQBRI+eJAGZR
         18DA==
X-Gm-Message-State: AOAM530rRzG5x6K0YydoDm6v+zJ6sCoM6hfnqjMDSRB/HZ2PJBb6dkLn
        G0SqNstt87F0Y5S4rfwlG18=
X-Google-Smtp-Source: ABdhPJwPN0va3Ov9iieIunuBdRIokxU+5WWs72jb0mtHcFaUH0aV4MvRKjItzE4QRCueqmdGBXIyDA==
X-Received: by 2002:a17:902:ed11:b029:da:3137:2695 with SMTP id b17-20020a170902ed11b02900da31372695mr4584837pld.1.1609944194844;
        Wed, 06 Jan 2021 06:43:14 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:14 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/7] bcm63xx_enet: add BQL support
Date:   Wed,  6 Jan 2021 22:42:03 +0800
Message-Id: <20210106144208.1935-3-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
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
index b82b7805c36a..90f8214b4d22 100644
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
@@ -1169,6 +1176,7 @@ static int bcm_enet_stop(struct net_device *dev)
 	kdev = &priv->pdev->dev;
 
 	netif_stop_queue(dev);
+	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	if (priv->has_phy)
 		phy_stop(dev->phydev);
@@ -2338,6 +2346,7 @@ static int bcm_enetsw_stop(struct net_device *dev)
 
 	del_timer_sync(&priv->swphy_poll);
 	netif_stop_queue(dev);
+	netdev_reset_queue(dev);
 	napi_disable(&priv->napi);
 	del_timer_sync(&priv->rx_timeout);
 
-- 
2.17.1

