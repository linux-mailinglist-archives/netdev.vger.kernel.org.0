Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7582EBFBA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbhAFOoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAFOoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:44:00 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4BC06135A;
        Wed,  6 Jan 2021 06:43:19 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id a188so1808681pfa.11;
        Wed, 06 Jan 2021 06:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z/gY4eGbQAG4g6JUH+BYAEEr7QAfURZLBW/Uf2NFIK0=;
        b=IPSEZARh30rxUqSwqq9rqaIe+PW5H7ek0sb4Cvr2MhQy/Q7VrQiNqNAmwOHN6KE3Ez
         V2qxLWygzb2tkHtBoUgd0C98YF0LP7ZAEp0+0ZKt9e5a72RmfjDIeGj0D61ZLYVrOszO
         hBc1gs3QxNcRtgnIKhZuWAWMZNiBbEDVtfxva7NL5d68NGi/PPXrWLG49Jk69oswLPRW
         2y/n+dYiBIelPuO4ztRcRVqJ3rGM9KMkg/ymbvUaXXdI/gxymspZ2Shgy5jsw2EsahXZ
         8jSugzs94fTkHhvcqd32M/Xw53UZRngMtZxXqx8SryuuYBpwy/GWoQjFLWkawuENpR5R
         K3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z/gY4eGbQAG4g6JUH+BYAEEr7QAfURZLBW/Uf2NFIK0=;
        b=CbZFstZvAFN9HUjyMEsW8CHROc3PBD+rXb9SwH2RNDLJ1sfOPg+VKx//S2ixfsg2Wa
         mtmIdiYjfgsUUocovMtg37cDdPubd0cN6X++pH8ij9dUGbVtfQ8ovrlXjFEPtkYSbB+N
         hMBCfDfD0LJ4iMMM/+4l4PbrcoJiH3ibhaxATZhiMrDRuF0z9YcsC9XLGJf9S/Cn9q+1
         r1Jti+cwZiCHsU3CtTwQifmefWDlyGaVigp0KMVzboBX8yCtvcuPfXv4SG236E0toC4V
         A0dFOHiEtseb6K/Gz9seq0WgIrAb7fqyTbsSV65xijlSt7WtddUlcX0cWY7ctcOUdxYZ
         R26w==
X-Gm-Message-State: AOAM532IqgSSGC0N46U41/JTrxSE9tNswjRcyYQuUTqCZS42vK9jcuuE
        T8JQVheL/7W09/EYACEUSMP1QP2J7js=
X-Google-Smtp-Source: ABdhPJxQ+dFA/PivecFA1EwNbyd2csrbQ97GYfNKqFdTGd4st0fhLl9XtfPRwR9LsgyLitEw4MngwQ==
X-Received: by 2002:aa7:82cc:0:b029:19e:1328:d039 with SMTP id f12-20020aa782cc0000b029019e1328d039mr4283565pfn.70.1609944199597;
        Wed, 06 Jan 2021 06:43:19 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:19 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/7] bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
Date:   Wed,  6 Jan 2021 22:42:05 +0800
Message-Id: <20210106144208.1935-5-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
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
index 21744dae30ce..96d56c3e2cc9 100644
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

