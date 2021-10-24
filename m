Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C1438B18
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhJXRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhJXRwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 13:52:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A14C061745;
        Sun, 24 Oct 2021 10:50:11 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c28so8290736qtv.11;
        Sun, 24 Oct 2021 10:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jl13HdyL7EYvNKB/qp3Rbfr+ATdErdZL265BgLiXYwE=;
        b=Ip5yqZJ4Y24kUoTO74/nN6kuoFiidtJzEfjORZYPxZ40jxmUd7wzQNY81JeJdwUbxD
         tH+4pX73zKP9H9ft/dc/rstETsHkzaA56pKvqQBNrgfY8u2Xcv8FAnoIiEl6jokoAh6v
         H7x9wqDNYPe2Ofd+pTzvGeKNgbTFa0/YPppni+AaLZ0NVoa3opBzIlNgduKEvWUTPQIj
         DJeil5TfisJ/YjWohROiQYdowTOdyWWBdaYXjQoq/N/FEuln7jbkHADYtiUIHgi3r8Ob
         Yq0DKJIw4l5gqF8JjI3BIKXmlwwARO6fCmFOPoJWIQa+nGuGqOTwUvoDREqgF6jw11C6
         b5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jl13HdyL7EYvNKB/qp3Rbfr+ATdErdZL265BgLiXYwE=;
        b=mhKa/Y/NLDvBeDI4AEx3xhxEHEEFtCR1AiZxXBYpc0vC1eFFUdYwC4XJntblBk3XiE
         cPG0sdJtz0eZxX2O44XY/gTeBQ/KQGx8pdGOAumzUa28YJuIrG1pXeo5XRA4jShuvfe3
         4v9MPi7t/DR0r+uBxwoAT3h2sTzNJRUhM3qMV65wMuEKYuuwDhMjm77yV3igRnJf95md
         aoTvmCzxWxAsJT0gZiDh2BS6op90Ku4CmX3ua/dXSC6Mpkf3OUdkhqBDgSZRsro/C59T
         j9P6VHtxXBhgJFZ95ZGWWWpunour8c/8G0Qi1mh31/2Kt38//KwSkmGtUpkqoysukSUm
         0Shw==
X-Gm-Message-State: AOAM530FAkW/9cL6xkXiLkbnSpYk1++aNV606d/DchhjcxnVKNHWaEqr
        BLWyMECHgpAyKKP55CBDvTiij4xHgQI=
X-Google-Smtp-Source: ABdhPJyTHlgcHa+z6WWlTNRFVRHcREu5A8m9m6+OJFNVkh0Hwqduk/5TXL4uIeUIeQnXek/ymbzZmQ==
X-Received: by 2002:ac8:58cf:: with SMTP id u15mr13034190qta.334.1635097809891;
        Sun, 24 Oct 2021 10:50:09 -0700 (PDT)
Received: from localhost.localdomain (pppoe-209-91-167-254.vianet.ca. [209.91.167.254])
        by smtp.gmail.com with ESMTPSA id e13sm7327335qka.117.2021.10.24.10.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 10:50:08 -0700 (PDT)
From:   Trevor Woerner <twoerner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/LPC32XX SOC
        SUPPORT), netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH] net: nxp: lpc_eth.c: avoid hang when bringing interface down
Date:   Sun, 24 Oct 2021 13:50:02 -0400
Message-Id: <20211024175003.7879-1-twoerner@gmail.com>
X-Mailer: git-send-email 2.30.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A hard hang is observed whenever the ethernet interface is brought
down. If the PHY is stopped before the LPC core block is reset,
the SoC will hang. Comparing lpc_eth_close() and lpc_eth_open() I
re-arranged the ordering of the functions calls in lpc_eth_close() to
reset the hardware before stopping the PHY.

Signed-off-by: Trevor Woerner <twoerner@gmail.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d29fe562b3de..c910fa2f40a4 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1015,9 +1015,6 @@ static int lpc_eth_close(struct net_device *ndev)
 	napi_disable(&pldat->napi);
 	netif_stop_queue(ndev);
 
-	if (ndev->phydev)
-		phy_stop(ndev->phydev);
-
 	spin_lock_irqsave(&pldat->lock, flags);
 	__lpc_eth_reset(pldat);
 	netif_carrier_off(ndev);
@@ -1025,6 +1022,8 @@ static int lpc_eth_close(struct net_device *ndev)
 	writel(0, LPC_ENET_MAC2(pldat->net_base));
 	spin_unlock_irqrestore(&pldat->lock, flags);
 
+	if (ndev->phydev)
+		phy_stop(ndev->phydev);
 	clk_disable_unprepare(pldat->clk);
 
 	return 0;
-- 
2.30.0.rc0

