Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D774185ED
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 05:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhIZDXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 23:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhIZDXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 23:23:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409D9C061570;
        Sat, 25 Sep 2021 20:21:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so12626680pjc.3;
        Sat, 25 Sep 2021 20:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWqCmkgYZbhNc72xE0V2U1y0S+admUaRv//gvOMoO70=;
        b=nuZkSSjtLUTUBtgsEdvK0ekAKgptGy67bzOyptrzG530dvAHeW7aK1Q2sWz69Sgtm8
         8Rn4vW+P5pkUkPDA6C2kXk8oTyO9UQ9Qbn97Neqp4LExl6NfTxZ6Q269gUiT/SShPkjR
         0BFvvO+FRxOsb4f1s+LzD5scJKF0V9bAcOn5rSiqrqHp2P8sBYgW7FIsIbH6XLlKzziE
         pb9jhUsVS2ywOr1slJG/6Vl6UB8I6P+ApvpGKVPgAOeeCXix4S0+gN9akyPH3TTQdWhw
         U+c+GTlVwy4dE/D37bg8uKZvCt6pm7dN+OFTpD8iHv7yNKXqtTza5C3PPN8iVTnjCOsw
         WaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWqCmkgYZbhNc72xE0V2U1y0S+admUaRv//gvOMoO70=;
        b=yxEXT2QFcFfrTbmsROz+jAgdPtCyeZgXy27N2Lnz1tCJ03TM97oeuadhfLFldxqLMD
         fWaXpueiFMi+fLvfsV/YYqHvQdFMDZVsMt3OBcy0KfL6AeD/z6nFRstsqPmC2ceiU22j
         Zgt8Fv6VqxqxBnRlnOd+mYxreDd1ZzUP7LyiVmRNm73lb+X7lenUhZA4lOp4H5jBTOPu
         4OAXpywz08WBUofizspvuQqlPWtv2J2iiKhRxvg/dWJu/d3rPbw9YqR2lYAhlpmCnTd5
         9ognbLqn7xQ+vvwXFemPFLJALK3FQ0qRtAWlP2ejTx97QFMTy7oWLRJg9NpeSAJ13eJD
         OEnA==
X-Gm-Message-State: AOAM532VU4Ww67mjWAEjtKkY/4+ZIwYle8HP67EeFkzljUmwIM7IM96S
        PV4Eq7DpI7E8pfnvRwRSpcbGh0tBlNI=
X-Google-Smtp-Source: ABdhPJyA9ed34tmJ/3Wv9ZcR286RLiHIveHFeKw+4mZKcQ4gHCTM5MrWgZzn5wi/k9wxNfwWdPPNBQ==
X-Received: by 2002:a17:90a:88c:: with SMTP id v12mr9510860pjc.232.1632626492444;
        Sat, 25 Sep 2021 20:21:32 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm14205312pgl.90.2021.09.25.20.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 20:21:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/4] net: bcmgenet: remove old link state values
Date:   Sat, 25 Sep 2021 20:21:12 -0700
Message-Id: <20210926032114.1785872-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210926032114.1785872-1-f.fainelli@gmail.com>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

The PHY state machine has been fixed to only call the adjust_link
callback when the link state has changed. Therefore the old link
state variables are no longer needed to detect a change in link
state.

This commit effectively reverts
commit 5ad6e6c50899 ("net: bcmgenet: improve bcmgenet_mii_setup()")

Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  5 ---
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  4 ---
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 36 -------------------
 3 files changed, 45 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 23c7595d2a1d..3427f9ed7eb9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3408,11 +3408,6 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	 */
 	cancel_work_sync(&priv->bcmgenet_irq_work);
 
-	priv->old_link = -1;
-	priv->old_speed = -1;
-	priv->old_duplex = -1;
-	priv->old_pause = -1;
-
 	/* tx reclaim */
 	bcmgenet_tx_reclaim_all(dev);
 	bcmgenet_fini_dma(priv);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 0a6d91b0f0aa..406249bc9fe5 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -606,10 +606,6 @@ struct bcmgenet_priv {
 	bool clk_eee_enabled;
 
 	/* PHY device variables */
-	int old_link;
-	int old_speed;
-	int old_duplex;
-	int old_pause;
 	phy_interface_t phy_interface;
 	int phy_addr;
 	int ext_phy;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 8a9d8ceaa5bf..8fce5878a7d9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -33,34 +33,8 @@ void bcmgenet_mii_setup(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
 	u32 reg, cmd_bits = 0;
-	bool status_changed = false;
-
-	if (priv->old_link != phydev->link) {
-		status_changed = true;
-		priv->old_link = phydev->link;
-	}
 
 	if (phydev->link) {
-		/* check speed/duplex/pause changes */
-		if (priv->old_speed != phydev->speed) {
-			status_changed = true;
-			priv->old_speed = phydev->speed;
-		}
-
-		if (priv->old_duplex != phydev->duplex) {
-			status_changed = true;
-			priv->old_duplex = phydev->duplex;
-		}
-
-		if (priv->old_pause != phydev->pause) {
-			status_changed = true;
-			priv->old_pause = phydev->pause;
-		}
-
-		/* done if nothing has changed */
-		if (!status_changed)
-			return;
-
 		/* speed */
 		if (phydev->speed == SPEED_1000)
 			cmd_bits = CMD_SPEED_1000;
@@ -102,10 +76,6 @@ void bcmgenet_mii_setup(struct net_device *dev)
 			reg |= CMD_TX_EN | CMD_RX_EN;
 		}
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-	} else {
-		/* done if nothing has changed */
-		if (!status_changed)
-			return;
 	}
 
 	phy_print_status(phydev);
@@ -294,12 +264,6 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	if (priv->internal_phy)
 		phy_flags = priv->gphy_rev;
 
-	/* Initialize link state variables that bcmgenet_mii_setup() uses */
-	priv->old_link = -1;
-	priv->old_speed = -1;
-	priv->old_duplex = -1;
-	priv->old_pause = -1;
-
 	/* This is an ugly quirk but we have not been correctly interpreting
 	 * the phy_interface values and we have done that across different
 	 * drivers, so at least we are consistent in our mistakes.
-- 
2.25.1

