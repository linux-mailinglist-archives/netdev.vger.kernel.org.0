Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34125138626
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgALMFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42717 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732811AbgALMFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:14 -0500
Received: by mail-lj1-f193.google.com with SMTP id y4so6920448ljj.9
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m0HGTOkSTI/lvDea6vaViLNDuo5MYsvezzNPWnrOJdM=;
        b=M/3f5uEJt4WmCDWV5+iSwlFjzE4mpu0xGBPoXU43oMPg4DEuK+/y2D/InSQSlVJlAo
         XzDaZ9xE0WeMbrlojIRtpszu2JKu2N+E74xFcvunD5mr4XOcQamCZe/rSZr/0wX6EM1a
         VbL0ospMWybm8EbPrxMBqrYKfHqcwSjeQPbSXXu+90+CsWXPktntQwD6VQM4eyZeJVVH
         8FuglbAVVbZbzA0CKIKjJk79NMN4EmdTLxTt8/nm7AKyyfFt/UMflkf5XKv0rk7I/dW5
         dpHWFfD+5xKPJv7B7sBNvaXyo/2MQdWqUJezijoYGkv8K5NuFz3phGRyU/0OS+uoSY4/
         zjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m0HGTOkSTI/lvDea6vaViLNDuo5MYsvezzNPWnrOJdM=;
        b=iAWmvVXrWP3e/YCS/+JciAWuhYctmurRtxPVy4WRjOtblhjwd2564yz4dn443k0ESx
         5GJSdAnkJ76VpEP+MEfaQoFhB1Kall2+adnnWY9SUPaYux1dkh+ymUfjjD4mjVQtQnHT
         Wm6ha2Vmnx+9rkrko50CRQciadZLZypVgMDB+AjqsiiI9vtOFexu+QHrorh1th3K4qSG
         rFHj+EAptSnvneE55rW3PrskumZ8Rqos8NJwZHn8rTlZt/S7wll8FhvBxfcOOwZKJ9So
         4OfJBfKjEUQ57jtMX1Q6zGU6CaVSc5LeoJYhzdTJPUhydWtjZMlblD4HFw495yspjnzB
         nqKA==
X-Gm-Message-State: APjAAAUmFttN0jGTXqYS3syWtLF3SkfoZDeSeZqrxonVihd5MaNSpP5f
        lCnQEf2EMJwh9RLrof5mvnpbsKuLzHj/Mw==
X-Google-Smtp-Source: APXvYqzzabAyeva5rLjJDAitwMDmRdnO1peqklNw4RcbXaphLyu38MMTaFW933A0BBMvgdfi4jubrw==
X-Received: by 2002:a2e:9d89:: with SMTP id c9mr7933322ljj.129.1578830712176;
        Sun, 12 Jan 2020 04:05:12 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:11 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 9/9 v5] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Sun, 12 Jan 2020 13:04:50 +0100
Message-Id: <20200112120450.11874-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
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
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebase with the rest of the series.
- Tag for stable, this is pretty serious.
- I have no real idea when this stopped working.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ee45215c4ba4..269596c15133 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1086,7 +1086,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.21.0

