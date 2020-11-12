Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EA02B03A8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgKLLPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:15:45 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57150 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLLPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:15:45 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ACBFcaI009766;
        Thu, 12 Nov 2020 05:15:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605179738;
        bh=2qkNvREGB6upemw2NWJh9LDH9SjawC+AaQHptIVURaU=;
        h=From:To:CC:Subject:Date;
        b=TrlhxvlbWT8h7c0pu9qlVVOLBhWz2v7FMK/szdxGG0DMuOK7dvUv8JriCbkY2mAuh
         XwQIHgQOOS8Qu5Zk+klOXE7Cd3U1zkUh+wtum2P3S9EekipxkJLRH0OYAj0sxhb9MO
         UavJ+Jd7bdNrBBadPoFamgfGOaaMYUJr0ylAvn9E=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ACBFc6a058380
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 05:15:38 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 12
 Nov 2020 05:15:37 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 12 Nov 2020 05:15:37 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ACBFaoE099039;
        Thu, 12 Nov 2020 05:15:37 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: cpsw: fix cpts irq after suspend
Date:   Thu, 12 Nov 2020 13:15:46 +0200
Message-ID: <20201112111546.20343-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the SoC/platform the CPSW can completely lose context after a
suspend/resume cycle, including CPSW wrapper (WR) which will cause reset of
WR_C0_MISC_EN register, so CPTS IRQ will became disabled.

Fix it by moving CPTS IRQ enabling in cpsw_ndo_open() where CPTS is
actually started.

Fixes: 84ea9c0a95d7 ("net: ethernet: ti: cpsw: enable cpts irq")
Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c     | 10 ++++++----
 drivers/net/ethernet/ti/cpsw_new.c |  9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77190ad..fa2d1025cbb2 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -838,9 +838,12 @@ static int cpsw_ndo_open(struct net_device *ndev)
 		if (ret < 0)
 			goto err_cleanup;
 
-		if (cpts_register(cpsw->cpts))
-			dev_err(priv->dev, "error registering cpts device\n");
-
+		if (cpsw->cpts) {
+			if (cpts_register(cpsw->cpts))
+				dev_err(priv->dev, "error registering cpts device\n");
+			else
+				writel(0x10, &cpsw->wr_regs->misc_en);
+		}
 	}
 
 	cpsw_restore(priv);
@@ -1716,7 +1719,6 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	/* Enable misc CPTS evnt_pend IRQ */
 	cpts_set_irqpoll(cpsw->cpts, false);
-	writel(0x10, &cpsw->wr_regs->misc_en);
 
 skip_cpts:
 	cpsw_notice(priv, probe,
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f779d2e1b5c5..2f5e0ad23ad7 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -873,8 +873,12 @@ static int cpsw_ndo_open(struct net_device *ndev)
 		if (ret < 0)
 			goto err_cleanup;
 
-		if (cpts_register(cpsw->cpts))
-			dev_err(priv->dev, "error registering cpts device\n");
+		if (cpsw->cpts) {
+			if (cpts_register(cpsw->cpts))
+				dev_err(priv->dev, "error registering cpts device\n");
+			else
+				writel(0x10, &cpsw->wr_regs->misc_en);
+		}
 
 		napi_enable(&cpsw->napi_rx);
 		napi_enable(&cpsw->napi_tx);
@@ -2006,7 +2010,6 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	/* Enable misc CPTS evnt_pend IRQ */
 	cpts_set_irqpoll(cpsw->cpts, false);
-	writel(0x10, &cpsw->wr_regs->misc_en);
 
 skip_cpts:
 	ret = cpsw_register_notifiers(cpsw);
-- 
2.17.1

