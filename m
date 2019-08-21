Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA1197D70
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfHUOox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:44:53 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:57355 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfHUOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:44:53 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0CBD61BF20F;
        Wed, 21 Aug 2019 14:44:50 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, grygorii.strashko@ti.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: [PATCH net] net: cpsw: fix NULL pointer exception in the probe error path
Date:   Wed, 21 Aug 2019 16:41:23 +0200
Message-Id: <20190821144123.22248-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain cases when the probe function fails the error path calls
cpsw_remove_dt() before calling platform_set_drvdata(). This is an
issue as cpsw_remove_dt() uses platform_get_drvdata() to retrieve the
cpsw_common data and leds to a NULL pointer exception. This patches
fixes it by calling platform_set_drvdata() earlier in the probe.

Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
Reported-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/ti/cpsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 32a89744972d..a46b8b2e44e1 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2775,6 +2775,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	if (!cpsw)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, cpsw);
 	cpsw->dev = dev;
 
 	mode = devm_gpiod_get_array_optional(dev, "mode", GPIOD_OUT_LOW);
@@ -2879,7 +2880,6 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_cpts;
 	}
 
-	platform_set_drvdata(pdev, cpsw);
 	priv = netdev_priv(ndev);
 	priv->cpsw = cpsw;
 	priv->ndev = ndev;
-- 
2.21.0

