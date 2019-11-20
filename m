Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5785D103113
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfKTBZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:25:24 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34387 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfKTBZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 20:25:24 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so13353747pff.1;
        Tue, 19 Nov 2019 17:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldarti2Cil2jWS7BGbU10AooRxN+DMj3yEli61ye9Eg=;
        b=t93ZFRP9GLj9YVftWBZdfJypyw06kXZPfvo/rvRybO9zmhH6Q70fVzrxUoSNqP+Tfo
         s9JHJqrVXxK14gHQ1JkImEFe9RhnsDTdkdOFAjhhj6+TT35yyEHnpvgO+ocL5NrYIPdn
         CF+L7MbbcXPpfvxmdYPzYfDcSsUp19KmyWBqP9wL871edNo6P53oyWElyON/PwSTZKxy
         SSx3mVbDiwm0eKqd/6UIL9H1spD9Wt+PO409v6NURuI2fjCY81n96aAucal3l7Vy5Zhx
         L2GzC/oAbsaYZRs0HYlrTzs+DC8u3837hK5aNsiKvEmgkkozfaPLEOvvJE66yGuH92tX
         wWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldarti2Cil2jWS7BGbU10AooRxN+DMj3yEli61ye9Eg=;
        b=MxkxLerf3EB0f7SER9yKIxwn8mIk2Dp0f5uGhafPGRfOpIm6LmV/tHCx875/2q8aw0
         u9Db3e+VyLQGX9GpeLnPpDYKV++3PZLs3K1jhDWlbJkAaTp5MXf/HbeopR20RQM6q72G
         yfxk0cC3kxvKNaaZj7PQhJ7HoiqbFQHi2fCwWOWFJwaPxoMnUNax3UbGTGoD8kzX5FqK
         /HeA+pDKbQWaIfmQftasYfDjaz34v29iM1zV6dQdpGZTbhOQIQ5w47WlFQ6x072D64Hf
         EQ5RuywjxajDo/DT6hSjbcVLlIPYD1ENM/Y6LrYnkDDJhMmaEOoSrUvVFyb2NQX4xpEc
         GDfg==
X-Gm-Message-State: APjAAAXyAdHgoAelEv37KtV2isFz4mu1+xr+Mefcjkev7rijWQZe/pxe
        rf7pyLlJd+U/QBAvHo4zScU=
X-Google-Smtp-Source: APXvYqxc87m0aUMXK0pFGjmTtPGhC6YFyugMuNIMG+6oQIolXsDDDZVVpXlTKl+VTpeNo+sjHBoFDA==
X-Received: by 2002:a63:a502:: with SMTP id n2mr172176pgf.158.1574213123850;
        Tue, 19 Nov 2019 17:25:23 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id o129sm30343553pfg.75.2019.11.19.17.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 17:25:22 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net v4] net: fec: fix clock count mis-match
Date:   Wed, 20 Nov 2019 09:25:13 +0800
Message-Id: <20191120012513.11161-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pm_runtime_put_autosuspend in probe will call runtime suspend to
disable clks automatically if CONFIG_PM is defined. (If CONFIG_PM
is not defined, its implementation will be empty, then runtime
suspend will not be called.)

Therefore, we can call pm_runtime_get_sync to runtime resume it
first to enable clks, which matches the runtime suspend. (Only when
CONFIG_PM is defined, otherwise pm_runtime_get_sync will also be
empty, then runtime resume will not be called.)

Then it is fine to disable clks without causing clock count mis-match.

Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v4:
  - Fix some typos.

 drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a9c386b63581..4bb30761abfc 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3636,6 +3636,11 @@ fec_drv_remove(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
@@ -3643,15 +3648,17 @@ fec_drv_remove(struct platform_device *pdev)
 	fec_enet_mii_remove(fep);
 	if (fep->reg_phy)
 		regulator_disable(fep->reg_phy);
-	pm_runtime_put(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
-	clk_disable_unprepare(fep->clk_ahb);
-	clk_disable_unprepare(fep->clk_ipg);
+
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
 	free_netdev(ndev);
 
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
-- 
2.24.0

