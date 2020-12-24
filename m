Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6FE2E27A1
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgLXO0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLXO0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:20 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8F8C061794;
        Thu, 24 Dec 2020 06:26:05 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e2so1338060plt.12;
        Thu, 24 Dec 2020 06:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k0cWkaPR7sxvjSMJSz2pqKDGwauEeHa3F+oQo0gd5HI=;
        b=ky8KHdOA9V1EmSxBUaZWvi58lfudWqIzG98R94RMPtKRNx3YkouE1oSoXtWJb4vuR6
         usXqkGQStMGpxnqMFlu0YObYmOEOw+9fXreGcOojgCa/wyENEFuI70/lV1dlzCrTjC2t
         nswT1K2C7bf6UYM0cNNGGajKDqVXRsfRym+7zCNJzw0yqSvNlYDrSsGhnBMn0iaY8p4r
         6VlhvhGP87L12WxIBiEFxh/Dvl82q9FE/iuuNwoQbIiU7yZZFXoEup8NRExJDn2YwigE
         GjeEP4cEjuxufyilGDcCELOtdyoJpje1KOFYMJJNYwEUudnEqxB97JfKTj+uykibo70x
         i19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k0cWkaPR7sxvjSMJSz2pqKDGwauEeHa3F+oQo0gd5HI=;
        b=TZ+Rs9Vs7GyhVO1hZ9o5R6CPNWOEIVhlcw/UZRvFaAM0sBdGaDOeZjLowZJQv9eDRl
         /hq4uH9Ngt9y9LMPbVfiQ8Kt23xyf/JrppTRMbhcZcERjL5abvTGuzL4r1VPx/c5b4DB
         1tj9x+gGxZhfsOVRNcfZQ72EJRwNp7zIf6MDhrboaes/ab/XzjAw2k/NtmxW6G4NIQuv
         sgWrQFEkyHcoor3e8uS3VF0kWgjRilzlNylj4W7UyPDqHRa834A9u7okGwbWZYQ/Iz8j
         YLdQXFmmVWGf4s2ryTUFtDYT1APwEmjwN2aC31fk6UUCtF5gelmCmP34LOkIORcLGRpx
         MwTQ==
X-Gm-Message-State: AOAM532m3ia3l6N59oFppeLq/7DCwtBugTmcv1duLJPIONmzExKG5WGZ
        PcXbheJgoWTJBySyIPHSRaY=
X-Google-Smtp-Source: ABdhPJyS8a+H04/RwMNnC+h8OGTnvSOfr6CIYQdcDuqF6PW5bJnaXkxEouIG8Qm7ByD9qN8G8bgBVw==
X-Received: by 2002:a17:90a:9707:: with SMTP id x7mr4706099pjo.72.1608819965332;
        Thu, 24 Dec 2020 06:26:05 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:26:04 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
Date:   Thu, 24 Dec 2020 22:24:19 +0800
Message-Id: <20201224142421.32350-5-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_alloc_skb_ip_align on newer SoCs with integrated switch
(enetsw) when refilling RX. Increases packet processing performance
by 30% (with netif_receive_skb_list).

Non-enetsw SoCs cannot function with the extra pad so continue to use
the regular netdev_alloc_skb.

Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
performance.

Before:
[ ID] Interval Transfer Bandwidth Retr
[ 4] 0.00-30.00 sec 120 MBytes 33.7 Mbits/sec 277 sender
[ 4] 0.00-30.00 sec 120 MBytes 33.5 Mbits/sec receiver

After (+netif_receive_skb_list):
[ 4] 0.00-30.00 sec 155 MBytes 43.3 Mbits/sec 354 sender
[ 4] 0.00-30.00 sec 154 MBytes 43.1 Mbits/sec receiver

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 452968f168ed..51976ed87d2d 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -237,7 +237,10 @@ static int bcm_enet_refill_rx(struct net_device *dev)
 		desc = &priv->rx_desc_cpu[desc_idx];
 
 		if (!priv->rx_skb[desc_idx]) {
-			skb = netdev_alloc_skb(dev, priv->rx_skb_size);
+			if (priv->enet_is_sw)
+				skb = netdev_alloc_skb_ip_align(dev, priv->rx_skb_size);
+			else
+				skb = netdev_alloc_skb(dev, priv->rx_skb_size);
 			if (!skb)
 				break;
 			priv->rx_skb[desc_idx] = skb;
-- 
2.17.1

