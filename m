Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A98100573
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRMSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:18:37 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40233 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRMSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 07:18:37 -0500
Received: by mail-pl1-f193.google.com with SMTP id e3so9715238plt.7;
        Mon, 18 Nov 2019 04:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQqjGoXTfZR1JdEd7frIlLbAs9ReexofvLueKLqlVq0=;
        b=tvosgQaOVccJ9RwFjanBszZ08wmytTTOb+PpQNDCnUpEk8Ai4Lgy0i+jFTZZSoZduO
         MDufK2zZMsmseJkDTWp+bHs/H7Q49c7i8fsP61KhX7dW1zpgbuOIGM+ol3UP6UFneV3y
         YpMkedziQuRn5BvjZ2zfJjEKHwpDECYoIXsjmNqUIoG/F1VmVV+XhAew2nnoO9VnwkOk
         mFAw4CcROxwhI1wqoeXiAfWOxo2xrON1UnuAB4Ta/7dAoo6J98ry5myeYAOYWYmnm62j
         AaR/Yp/FrZ9po+bnKzCQOmmvHLpiZlCNPllK6txNZCUbkDjof4Za4c262gukNMRepquU
         ergQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQqjGoXTfZR1JdEd7frIlLbAs9ReexofvLueKLqlVq0=;
        b=I+mU+QXb5Q1LjFwXsn0+FL+7HVycr0MdKce2VHbUHtX7KFS9IXEeO/Kxv73T8ypnws
         7l5BVUhsg+z5UXw+vUcsyKHx4SV2tYzFqJ2Z4holppA4GRzvJESJDCntauQGWWrh1V4q
         bw374C8AUHCcL3A0Vol2EitFMFGOkAJWfrdqunFAFb5oTPBt8cKIbHRDPxJtEn876N8Z
         RucKUJBgSVraDCWMO8IwgcO2Z81j7yRDc+M0LyI5uA3iIvsW1sZwtCd8h+1HcY1uf82t
         QZc3Iln5k1s6xIvCGfKsCZU0NKv9EbJUJ8OpiJMr00dk7XUoRsPw4N7mKWkFQuVvq95V
         aCJw==
X-Gm-Message-State: APjAAAUGi0sjYRz68y8dQH4Y3teEQEkYBw6+jegY+uMzLpJxX+5vOFA9
        71XkL195RQGWL++Jnqc/S5A=
X-Google-Smtp-Source: APXvYqxk2G6oTTKeLj1iGpqhA+EA3a7JneBJiwp0mvUUw1Cesa97rPZrZ8b9WiCOyj+fGOWVY5T3Tg==
X-Received: by 2002:a17:90a:a416:: with SMTP id y22mr39978002pjp.91.1574079516546;
        Mon, 18 Nov 2019 04:18:36 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id k66sm16514221pgk.16.2019.11.18.04.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 04:18:35 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net v3] net: fec: fix clock count mis-match
Date:   Mon, 18 Nov 2019 20:18:26 +0800
Message-Id: <20191118121826.26353-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pm_runtime_put_autosuspend in probe will call suspend to disable clks
automatically if CONFIG_PM is defined. (If CONFIG_PM is not defined,
its implementation will be empty, then suspend will not be called.)

Therefore, we can call pm_runtime_get_sync to resume it first to enable
clks, which matches the suspend. (Only when CONFIG_PM is defined, otherwise
pm_runtime_get_sync will also be empty, then resume will not be called.)

Then it is fine to disable clks without causing clock count mis-match.

Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
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

