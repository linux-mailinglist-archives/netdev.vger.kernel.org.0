Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519ED1F8724
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 07:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgFNFiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 01:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgFNFiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 01:38:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD1C03E96F;
        Sat, 13 Jun 2020 22:38:13 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a13so12445035ilh.3;
        Sat, 13 Jun 2020 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=An1NrM9l9BRF7lZMHKxaM4gNbHvvvUs9mHIop6uaTps=;
        b=RYiZOZ3oqzwtrJCzb53MgQ4h62Jltmw9M8bzRdPgFJk8nIxwgUJ7C/E5GV4qyOpDrV
         EgnRY1Y7LALkLN1Mvz51uOltuYHSN5370Zz/EZ+RzWAL4KYm4LWQb3yU2WOxkWyMMUF+
         ENPbT2Ks6bXFVV4RXySDb0HxpRAG/ep2JryQpm30Fb3nSaNVNcROCFoXHnb6xwUf+rqy
         WUq74QiPW0OcQC4AU1SCJFg1FkGj+b0OsV+F/HNVF2PT9lISAY/vL57pFKD1cXjHKA7/
         0XcPEjF3FfwkkuWmYra/Zhx1+pWqU4v718/1XMCh1HcBJiCokBT5kqq1EW907HI9k+x4
         1DUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=An1NrM9l9BRF7lZMHKxaM4gNbHvvvUs9mHIop6uaTps=;
        b=tWwwE6qnD22uC7m/vyo0v+Q0twacZhlUboBP4ZCk3HSFtzsEL9h5Vvrn/hTuySXEwW
         mz0aFJCyS8+arYVnMbyG5yuRsMzvhQK1MO/VKpDFBHr3wcj+2FL/Ngd6u2uRkAZUaA5W
         eO5sOZjzE5L84/TohsfTL8HxRV2ZGEtd4VWVNEMK3hoHLRxhnrhXBPY3ixepSo68KSbY
         3zC1mqLmEPdU/HKlnXqTw4gq/1K6UC3SdYtg8UQ3IohVCcbaqN70P1BbmJ6fvtICVepI
         xK/r0grfQ29zGubPO5kTQnmraoz3dfr2UlZ8YABbPR9dXBmLlEUY/qss6TtK8g7u2qUy
         DisA==
X-Gm-Message-State: AOAM5318cEHeFNZj2kN8SGn8rlcrtl44DLojR6LX5B598UfIL8NoE0um
        dbC4NQRHiwcnfSLlsNnGhBQ=
X-Google-Smtp-Source: ABdhPJzZvahfRrERo/JssCH+Ct+X1GCq1j5nnAgkxcfGNjKYykiNv75U9aE9REy0JBqG7lgPXahIeA==
X-Received: by 2002:a92:5e59:: with SMTP id s86mr21063002ilb.104.1592113092335;
        Sat, 13 Jun 2020 22:38:12 -0700 (PDT)
Received: from cs-u-kase.dtc.umn.edu (cs-u-kase.cs.umn.edu. [160.94.64.2])
        by smtp.googlemail.com with ESMTPSA id b73sm5856805iof.13.2020.06.13.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2020 22:38:11 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, wu000273@umn.edu, kjlu@umn.edu,
        mccamant@cs.umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] net: fec: fix ref count leaking when pm_runtime_get_sync fails
Date:   Sun, 14 Jun 2020 00:38:01 -0500
Message-Id: <20200614053801.94112-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in fec_enet_mdio_read, fec_enet_mdio_write, fec_enet_get_regs,
fec_enet_open and fec_drv_remove, pm_runtime_get_sync is called which
increments the counter even in case of failure, leading to incorrect
ref count. In case of failure, decrement the ref count before returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index dc6f8763a5d4..a33012b89cc9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1827,8 +1827,10 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(dev);
 		return ret;
+	}
 
 	reinit_completion(&fep->mdio_done);
 
@@ -1893,8 +1895,10 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(dev);
 		return ret;
+	}
 	else
 		ret = 0;
 
@@ -2258,7 +2262,7 @@ static void fec_enet_get_regs(struct net_device *ndev,
 
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0)
-		return;
+		goto out;
 
 	regs->version = fec_enet_register_version;
 
@@ -2276,6 +2280,7 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	}
 
 	pm_runtime_mark_last_busy(dev);
+out:
 	pm_runtime_put_autosuspend(dev);
 }
 
@@ -2952,8 +2957,10 @@ fec_enet_open(struct net_device *ndev)
 	bool reset_again;
 
 	ret = pm_runtime_get_sync(&fep->pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(&fep->pdev->dev);
 		return ret;
+	}
 
 	pinctrl_pm_select_default_state(&fep->pdev->dev);
 	ret = fec_enet_clk_enable(ndev, true);
@@ -3741,8 +3748,10 @@ fec_drv_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		return ret;
+	}
 
 	cancel_work_sync(&fep->tx_timeout_work);
 	fec_ptp_stop(pdev);
-- 
2.17.1

