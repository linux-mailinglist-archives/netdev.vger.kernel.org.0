Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FE6DE169
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfJUAKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44920 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id m13so11318480ljj.11
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w29PBjLwWeAIRWp3fgOMUnbQQY3WjjWLD5FB+tSHMf0=;
        b=GvcMVtUcZdvDkFibuxGMO+5YFlu5kmAb7d85Q15wzNDdhVu020W5tdZnndUsBeC7MV
         4bF7C3ndevxvEOFzZ1K/SwB8Vr+XBtoibBlNK3aj10dDZG27XRz1BF+WUqdVIAJNxioq
         7LeQeDpVcyqGWxggLxkVSEarsLduUPsXX2ENWdiq//5GLc4D4BIHACyPK0OorjRIIUjj
         XmBMq7ez9230Q2jWieWcv0eF4j8EDE9TIKM5CE0MmtQyTJJA1CxtxYoEJEoXprKQLkLd
         rYxgSZ9RF48D3iS5PA7H8pQeDiUiIGlShikQtJAYO5MNUM7lJ01T5HXy2khyIChy0fsL
         EuCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w29PBjLwWeAIRWp3fgOMUnbQQY3WjjWLD5FB+tSHMf0=;
        b=JLY883T0Jd4jro993zjxXjyjK1EWhlyh+Eav5SE1RFksVb2rH9Yt33pHH9FX/xP/jC
         dx0hMuKmfo9L4jJvjx89nfHc8xWeIhCLk83n8mpnTy25HWTzYsWw7SG26gZX8Vb9+x+t
         /UrUXfGtIvwq0uw3D41aaMGC6kv/JFj0/9p00vgDR0Hy8b5O91A8E4gD3832Flwn/ZzS
         zrAw1LBsR71TXnkOvlVXRcpDdrox8Hr9H7MqWLizUGIswaiEYHQ5fFpr4ahpCiPQlZGe
         tJAF/w5NqlKcmUP5HAhfS13t90Jt6cNsaDeQDzKVfoB1NMyYHvcLg2Aq6+KRpzYA0rny
         GFsQ==
X-Gm-Message-State: APjAAAUBvPczGy6FPQIBdSBWVhol2FoB+eX6twiujItvG+fdr8mooFAt
        PZTjK2NNhUD3JBr/YjqEzx3xypdtX3A=
X-Google-Smtp-Source: APXvYqxIwjYhiXAitD5MnjQeNvofwyXkHpd+micFYjAIbwH9VBEgHB3Alh6Dg2nG2FoNo8geIPegMg==
X-Received: by 2002:a2e:8694:: with SMTP id l20mr12693736lji.64.1571616643771;
        Sun, 20 Oct 2019 17:10:43 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:42 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/10] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Mon, 21 Oct 2019 02:08:24 +0200
Message-Id: <20191021000824.531-11-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the netdevice struct device .parent field when calling
dma_pool_create(): the .dma_coherent_mask and .dma_mask
pertains to the bus device on the hardware (platform)
bus in this case, not the struct device inside the network
device. This makes the pool allocation work.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 0996046bd046..3ee6d7232eb9 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1090,7 +1090,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.21.0

