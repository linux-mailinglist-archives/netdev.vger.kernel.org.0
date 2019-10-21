Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32027DE168
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfJUAKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44914 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:44 -0400
Received: by mail-lj1-f195.google.com with SMTP id m13so11318407ljj.11
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q+ctxv8RRYH9UHhPygjo4LsS0z8/6tCihoymd1vpL+Y=;
        b=dpl+avsMBk2oF+F75HFzsHb+4ohPfWZKw4xzpnz2r0q+0K87kvkG0vHZ4XO6X118tj
         qsvuUDXzHIW5opt31kjQ0sbujyzdc32SMzjyv8GBHQb6v0eQnKCWlcVefPFUnni/Lf2B
         R6BVKCa/g6OnnZRQU3CSQijSxUMPVe/8Hakc2MiWUBlTeeykEJtlpnzgejSWKh/Mxu/w
         1GtpVHwmTyUi5gM3+XdKwyw6uAbMh5VThtzPVl8BjLrRAFwdngvNzXmMZsNoZCh0Q4BO
         fz018bf+HNQnlUH3pgilKnRAeFWm1xroMGu10FDTvZHcha8QuvcUuQe3XSuBbpmd9iqR
         2YCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q+ctxv8RRYH9UHhPygjo4LsS0z8/6tCihoymd1vpL+Y=;
        b=rrPNvFe5oV+tvwLwCXolp3mEpQ7fF6Ja93arD2+iv92we+U6n9w+hQlDX+NifGJCPG
         vOav51XEwnFGWDh7K/2Y2ER/8w9u3hzJJkjhevqTNcfYc14gaognKzlYZuvkqqb2VtUa
         2A9x8EIp9n44Ndlx8yalPEgQYfw7wGnf9HeAtPnH8VNj//Vd8xurwfoI+lk20x6XNQvV
         R/43gBA3cuPY0YPCQ1EczStSuVegpcOmrGnUk/6DI4zkq6WQAY/Vkj6FNHOjUuLNEUE/
         h4RPUy9VzjvrWP5GvzYCcrTdPzZo49MApHChBFMXDh+P41yCvJ8+4/dfA5kB1iyp98EO
         5jNA==
X-Gm-Message-State: APjAAAVUjYtI4pShRBksq2uN0Fscs48pdkIkNQAmIPaPtW26YkaD5MA4
        Ub4raCDzM2AU8P6NJ4ZwRQLvC8wwRDc=
X-Google-Smtp-Source: APXvYqwVD6zRM0rAL7MXdODR5qsfP8v/hTep/zqXq+CPdSzgZv3Z6AgCnCib45CcSvy86jagofQX8g==
X-Received: by 2002:a2e:2901:: with SMTP id u1mr12964731lje.78.1571616640059;
        Sun, 20 Oct 2019 17:10:40 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:38 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/10] net: ethernet: ixp4xx: Get port ID from base address
Date:   Mon, 21 Oct 2019 02:08:23 +0200
Message-Id: <20191021000824.531-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port->id was picked from the platform device .id field,
but this is not supposed to be used for passing around
random numbers in hardware. Identify the port ID number
from the base address instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 60cff1bce113..0996046bd046 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1385,7 +1385,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
-	port->id = pdev->id;
 
 	/* Get the port resource and remap */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1394,13 +1393,15 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
 
-	switch (port->id) {
-	case IXP4XX_ETH_NPEA:
+	switch (res->start) {
+	case 0xc800c000:
+		port->id = IXP4XX_ETH_NPEA;
 		/* If the MDIO bus is not up yet, defer probe */
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
 		break;
-	case IXP4XX_ETH_NPEB:
+	case 0xc8009000:
+		port->id = IXP4XX_ETH_NPEB;
 		/*
 		 * On all except IXP43x, NPE-B is used for the MDIO bus.
 		 * If there is no NPE-B in the feature set, bail out, else
@@ -1417,7 +1418,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
 		break;
-	case IXP4XX_ETH_NPEC:
+	case 0xc800a000:
+		port->id = IXP4XX_ETH_NPEC;
 		/*
 		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
 		 * of there is no NPE-C, no bus, nothing works, so bail out.
-- 
2.21.0

