Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4B29C0E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390948AbfEXQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:21:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40708 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390308AbfEXQVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:21:01 -0400
Received: by mail-lj1-f195.google.com with SMTP id q62so9168361ljq.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OUow8Idp71iR0dh6G9x5edE4axHg7RMQg95y9XAt+Qw=;
        b=uzUrotqJON7yaFM+63pGhO8BnKVC8rA4dQ1V6qpQcg/RxHN5VuTFGSNNknKMBm+y3N
         TO+f8PuACdU1PfzFIivAbYmEL5ec06Ko+Yf1HLj0GTXdrn+JTML7DTWqKG8cAN8BzKhQ
         PI8Jb9DLj0bmyHTLs48CvjYFeRrqGlGiidGvU8vBdM+qLslXTvqAsypukY/uFR/HX4O0
         6TQXJsO6CbWF8rYtDV71mZYF7UncFr43bDt944mF2qmLPYl23sjBWr2vtWYgt2/IkMoG
         FsdoHKAtURbsf/sz2WqyP+riP+1RMZUUyBUUARRnMQqxMRay6jEF0u4iZwwjoPm/+8Ac
         FHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OUow8Idp71iR0dh6G9x5edE4axHg7RMQg95y9XAt+Qw=;
        b=bNOd0DoGH6pB2zt2YDAcb29n6Ja9E2xdlpQ0YdaMFQ8YTMOPv95e0t217wANSF1+aw
         HEfqhYFlvrVhdsipBTWFuccsKooas1Fv6HQUsSe3av/YcSwpIN2OyInFtLkW2TJLpDlQ
         LdDjtvQat9DJjLUHJF/IuSxL3Y/HiwxsQ2XAujXGjtTMtKI5Oyh7UyE3bnF+JBZabpJU
         0MxXvWHRHV4anICg2u+J3+1mq0kw/a1DR2HixgUhZHPIwKbHF/2Y09qaig2tTRqL5DOW
         Cr0uoU55kuDIvO7C3EapCeBnveRr+xy22tCc3SV+YhISts23lSt8WXeuCxyQ9R/maT/K
         ceDw==
X-Gm-Message-State: APjAAAV/2ZUaQxoTh/B05VPJYy3s9q4yWpeTjP6QnvpPQmR9Rj9wzrwV
        +py3hGgoGM+1J0Z8CJvSnvNPIyR+Ju4=
X-Google-Smtp-Source: APXvYqw70+XYarZcexEHcNX4Fvnh3w9WKcg0w70gu3yFdnYnSyKMl6Dwd76Zy0ze8VpkFiyjYWHhlQ==
X-Received: by 2002:a2e:95d2:: with SMTP id y18mr30639520ljh.167.1558714858626;
        Fri, 24 May 2019 09:20:58 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/8] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Fri, 24 May 2019 18:20:21 +0200
Message-Id: <20190524162023.9115-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
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
index 600f62e95fb0..8b883563a3d3 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1092,7 +1092,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.20.1

