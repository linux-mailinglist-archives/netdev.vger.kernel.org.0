Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402354267BC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbhJHK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbhJHK0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:26:40 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B12C061570;
        Fri,  8 Oct 2021 03:24:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p1so7816511pfh.8;
        Fri, 08 Oct 2021 03:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9+SkQaOPjsBTe9c6aiqQVMNMLolkjNbz68KZM8fxyk=;
        b=DFRXnnToUO5DrTYgeR64i6seqNB2yC38VBpzv1sBYG1oXZCgJ6GOqLUCfsATR2fsoh
         6xQLqTxnWSULuLc9ZeIJUqe16YJgN+3EFgWuMiooxYGKiHeOOd+BlCDcdYp+q27Iqcjl
         oOI6j6juDnrm3hW+0hzZA/nasRCczpIyaCaeRHBxeWMFKBAnBmu2ZLbI0IWCMPGixnwM
         syjyYHgLbbFosb2ysbnGVuh3a8USteuYKMRKWSsDXI2IKrF2OC7PwCnuWvWKQeuOFFGi
         06rXT8H9H4P3VZ9G6dvV6LpKAEu8dUf4/AVD37LXJB3LrwCXidSRzkiFnllONbgrU9Zj
         dCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9+SkQaOPjsBTe9c6aiqQVMNMLolkjNbz68KZM8fxyk=;
        b=iq7ELpSdWng9vMAhIYzK6OL3Wly5T2xVMIhxmptupX2BTsTXpEOwAXbIjU9Xt+C2uB
         5amcNrYvfp+CwB/4MEb/fAOZWRtxtMq6RkivdL6w5hoRM6XSHZsxWcmIrfGvtHHN+u/c
         a8B4gXrzW/pCrH8lrQapfE0eIrN1htzhGfqwcKBgAcaBjtKwkoDMe8cUrPyOi9r3Qr10
         6BBKkER3Pzi/AIpQv6J/a1/lvBPTlutYxYoFlz7DsEdiZW+RyvydCPRICNOgUkjcnFvz
         jTZXUA7870zCe5oVdIDmbNvJoQOFvAN2I5y5r2/6uprGf/Kwh9NbHyDX24kiVqotzt+f
         1JOQ==
X-Gm-Message-State: AOAM5310FGtJ2qSyBv04TEGmLgfmnlKlywUngRICV6nvsS1IDEnk2FNa
        z67LzQ70uKYIDRKB3D6l9ms=
X-Google-Smtp-Source: ABdhPJy77L0NPD0IPs0pHKmluyLSKJzH8GoOC/pXSo2mzaH+7ffl2xTl/0AOMbNsRCF22s0tLg8AUQ==
X-Received: by 2002:a63:8f47:: with SMTP id r7mr1545186pgn.270.1633688684790;
        Fri, 08 Oct 2021 03:24:44 -0700 (PDT)
Received: from jensen.next ([113.109.79.206])
        by smtp.gmail.com with ESMTPSA id s37sm2491835pfg.44.2021.10.08.03.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 03:24:44 -0700 (PDT)
From:   hmz007 <hmz007@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, p.zabel@pengutronix.de,
        lgirdwood@gmail.com, broonie@kernel.org
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hmz007 <hmz007@gmail.com>
Subject: [PATCH] net: stmmac: dwmac-rk: Add runtime PM support
Date:   Fri,  8 Oct 2021 18:24:10 +0800
Message-Id: <20211008102410.6535-1-hmz007@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2d26f6e39afb ("fix unbalanced pm_runtime_enable warnings")
also enables runtime PM, which affects rk3399 with power-domain.

After an off-on switch of power-domain, the GMAC doesn't work properly,
calling rk_gmac_powerup at runtime resume fixes this issue.

Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
Signed-off-by: hmz007 <hmz007@gmail.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index ed817011a94a..a9eb98691a66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/pm_runtime.h>

 #include "stmmac_platform.h"

@@ -1626,7 +1627,8 @@ static int rk_gmac_remove(struct platform_device *pdev)
 	struct rk_priv_data *bsp_priv = get_stmmac_bsp_priv(&pdev->dev);
 	int ret = stmmac_dvr_remove(&pdev->dev);

-	rk_gmac_powerdown(bsp_priv);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		rk_gmac_powerdown(bsp_priv);

 	return ret;
 }
@@ -1638,7 +1640,7 @@ static int rk_gmac_suspend(struct device *dev)
 	int ret = stmmac_suspend(dev);

 	/* Keep the PHY up if we use Wake-on-Lan. */
-	if (!device_may_wakeup(dev)) {
+	if (pm_runtime_active(dev) && !device_may_wakeup(dev)) {
 		rk_gmac_powerdown(bsp_priv);
 		bsp_priv->suspended = true;
 	}
@@ -1660,7 +1662,24 @@ static int rk_gmac_resume(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */

-static SIMPLE_DEV_PM_OPS(rk_gmac_pm_ops, rk_gmac_suspend, rk_gmac_resume);
+#ifdef CONFIG_PM
+static int rk_gmac_runtime_suspend(struct device *dev)
+{
+	rk_gmac_powerdown(get_stmmac_bsp_priv(dev));
+	return 0;
+}
+
+static int rk_gmac_runtime_resume(struct device *dev)
+{
+	rk_gmac_powerup(get_stmmac_bsp_priv(dev));
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops __maybe_unused rk_gmac_pm_ops = {
+    SET_SYSTEM_SLEEP_PM_OPS(rk_gmac_suspend, rk_gmac_resume)
+    SET_RUNTIME_PM_OPS(rk_gmac_runtime_suspend, rk_gmac_runtime_resume, NULL)
+};

 static const struct of_device_id rk_gmac_dwmac_match[] = {
 	{ .compatible = "rockchip,px30-gmac",	.data = &px30_ops   },
--
2.33.0

