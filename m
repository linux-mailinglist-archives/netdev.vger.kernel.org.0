Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF266FCA25
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKNPnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:43:37 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36324 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfKNPnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:43:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so4025600pgh.3;
        Thu, 14 Nov 2019 07:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yx3YxeiV+a26/TH8QS+ES6W62V7GY14E2eR90w0YcZ0=;
        b=jnwwS7+4JrOGGnf8bTfGaHwRTTSrAZ7kU3SeupptuIAgWigbC5kxYWV6dJaxtrR6X5
         sjtb8RPnKVxhWQ5vPQgc93lCWWDyTJcX2RnsHvYVJIIavkVsi8J4EmQTLTR5Xt3Dgi4T
         f7Dl/+yutbGSBKgplb48lUiyCf0yTGbv+kz9mWSl2e1ZrqcVgMKQ9OitY9r/m8harSE2
         6Ywb1aaH7aAvvO+qd/3zdpY9xrwEWdht+fN+p/bS3nLC9JdOgpUvJKGAXYOgCrJ8YGGo
         bCEW53PJ0dZ8Sxt0tqqk2+TPtNt0jmAof6OtJHEFrxpc+qyMJTzT0rUyFlrSwJr6VMib
         OPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yx3YxeiV+a26/TH8QS+ES6W62V7GY14E2eR90w0YcZ0=;
        b=Z70pkhKO7BUhj6CU/pZ1zwhvgKlRXpRD4ZpyiqS9QC4RS5EmW9IX3tlOIV3ZMMH7EY
         idiufwUzT7D68ErsK30Bo9tz7cEYPTN83YhzMEmmycdZv0TWvpAMs5QTNsW9WV2o4s/f
         TKNXmb5uz5g6hKKsaGr+4TIVxht9CpH/yWVjdZgHcyqrlYJXK5vo23Y4kp7tDWsTZbrt
         g5N/cZXW1jzWIrLIj6qMqAlWMFF3Vh+bHKxoPVuHh6xtQV/dgbFU78yM4ygcLDxrCnTy
         Ly54MGj8eLYEOa/2lUBv8AgJI/6dEDwkeK2wzQtutlbBRPhaC0MvIm/AdBASZjrzGARB
         WvjQ==
X-Gm-Message-State: APjAAAVd2yWByZypN3w4hcTMv0HkEQLVULpAjLRhD2CUG8i4fbr1N7GT
        L962zt5TS/NfCxihWhBSkV0oXXIrbg8=
X-Google-Smtp-Source: APXvYqxD4aykLbpPswKRsl16izoV9NsJtLXjD71LmRZuDUA2gVUo37RsibZlIt9J9NPN2CEkUUPKCg==
X-Received: by 2002:aa7:9f86:: with SMTP id z6mr11796271pfr.102.1573746216595;
        Thu, 14 Nov 2019 07:43:36 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id a21sm6554066pjv.20.2019.11.14.07.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:43:35 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Hartley Sweeten <hsweeten@visionengravers.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: ep93xx_eth: fix mismatch of request_mem_region in remove
Date:   Thu, 14 Nov 2019 23:43:24 +0800
Message-Id: <20191114154324.31990-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver calls release_resource in remove to match request_mem_region
in probe, which is incorrect.
Fix it by using the right one, release_mem_region.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/cirrus/ep93xx_eth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index f1a0c4dceda0..f37c9a08c4cf 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -763,6 +763,7 @@ static int ep93xx_eth_remove(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct ep93xx_priv *ep;
+	struct resource *mem;
 
 	dev = platform_get_drvdata(pdev);
 	if (dev == NULL)
@@ -778,8 +779,8 @@ static int ep93xx_eth_remove(struct platform_device *pdev)
 		iounmap(ep->base_addr);
 
 	if (ep->res != NULL) {
-		release_resource(ep->res);
-		kfree(ep->res);
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		release_mem_region(mem->start, resource_size(mem));
 	}
 
 	free_netdev(dev);
-- 
2.23.0

