Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3982A18750B
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgCPVpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:45:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40566 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732652AbgCPVpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:45:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id z12so10596530wmf.5;
        Mon, 16 Mar 2020 14:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gUYCoVIK7PUThY294EuhqAEoLozrAWHRv6lYNhypBQQ=;
        b=dAeG3w3oxBuut2H7TIufA82cgtu3W1EU6e4ZemxMlR+8EmoftRI3wJYfw+tof9aUoZ
         5Ut7/mnOTY0nL5t1ipEuNEe1v6Dj0LXriMgMU3XuFgyyaheZMeFWyz5i/gTG4TL5QYFb
         1vN6TcX9BCqBeGvCsZYE1qzwjnRTw0IBeWaQZpb/FDE85P5bIlVMvw/Gy3qbaP2s72Gw
         iUexmrc8HvAAGfWJUYxxGNsH25JRTV4yEDVCyyZ3Q2pB/aWQKHYnzIO7qm/eGFoiQusl
         56gnqA/cR7qCO4mi4ffA3OD9+UKDXou68hI/d30arK1N7Y18m6mpenHLwX5mXi4Rfnbz
         OtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gUYCoVIK7PUThY294EuhqAEoLozrAWHRv6lYNhypBQQ=;
        b=inK/I0JlaZU1+5x1/wMRAsdwJEyMKLvw1Q1EqFkFlKzgiWgsE5tKAJ4RW0JWhgChUU
         g1cDdZZ9xoKyzG2PayjZK95JEB2slkrHBB3yuXwU2UfKFLWbxwblrelm7t9HzW+oNKvS
         zfjC57LK/Llm9KTT+qKyXxxudvQj2LNlZEtRDbg3RhOnDX7x2JIt95A9F38WhV9+qoQR
         9q5eTzUUtD1mKUFg5A4FVUmLeBt1c9uPAsD8E4/eJstbn+fzlW/hRPOeJtFK5bA3WfZn
         8SYRSBxDU3ZqikvI81aWKL3YM9denGb0FdFMcdm90q4pCjPvG3rW+KYKpVH9vFMPZ/3Y
         mo1w==
X-Gm-Message-State: ANhLgQ10yV92P1fXRrmrU8ag48kYnshoEV7MiWGlYZ7B+KNbSQJenVlW
        IsLKHNhDiHqiElJQoIMNaIc=
X-Google-Smtp-Source: ADFU+vuALlmus4BUW5lH/Cx3UCTXUJJmfDy/g42T98ajHxmY3epNem8Zp0I2Ziz2JWsPHQZVuLgFjw==
X-Received: by 2002:a1c:1f14:: with SMTP id f20mr1145977wmf.61.1584395136813;
        Mon, 16 Mar 2020 14:45:36 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a13sm1625676wrh.80.2020.03.16.14.45.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Mar 2020 14:45:36 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 2/2] net: bcmgenet: keep MAC in reset until PHY is up
Date:   Mon, 16 Mar 2020 14:44:56 -0700
Message-Id: <1584395096-41674-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
References: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in commit 28c2d1a7a0bf ("net: bcmgenet: enable loopback
during UniMAC sw_reset") the UniMAC must be clocked at least 5
cycles while the sw_reset is asserted to ensure a clean reset.

That commit enabled local loopback to provide an Rx clock from the
GENET sourced Tx clk. However, when connected in MII mode the Tx
clk is sourced by the PHY so if an EPHY is not supplying clocks
(e.g. when the link is down) the UniMAC does not receive the
necessary clocks.

This commit extends the sw_reset window until the PHY reports that
the link is up thereby ensuring that the clocks are being provided
to the MAC to produce a clean reset.

One consequence is that if the system attempts to enter a Wake on
LAN suspend state when the PHY link has not been active the MAC
may not have had a chance to initialize cleanly. In this case, we
remove the sw_reset and enable the WoL reception path as normal
with the hope that the PHY will provide the necessary clocks to
drive the WoL blocks if the link becomes active after the system
has entered suspend.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 10 ++++------
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  6 +++++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  6 ++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c8ac2d83208f..ce64b4e47feb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1965,6 +1965,8 @@ static void umac_enable_set(struct bcmgenet_priv *priv, u32 mask, bool enable)
 	u32 reg;
 
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		return;
 	if (enable)
 		reg |= mask;
 	else
@@ -1984,13 +1986,9 @@ static void reset_umac(struct bcmgenet_priv *priv)
 	bcmgenet_rbuf_ctrl_set(priv, 0);
 	udelay(10);
 
-	/* disable MAC while updating its registers */
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
-
-	/* issue soft reset with (rg)mii loopback to ensure a stable rxclk */
-	bcmgenet_umac_writel(priv, CMD_SW_RESET | CMD_LCL_LOOP_EN, UMAC_CMD);
+	/* issue soft reset and disable MAC while updating its registers */
+	bcmgenet_umac_writel(priv, CMD_SW_RESET, UMAC_CMD);
 	udelay(2);
-	bcmgenet_umac_writel(priv, 0, UMAC_CMD);
 }
 
 static void bcmgenet_intr_disable(struct bcmgenet_priv *priv)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index ea20d94bd050..c9a43695b182 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -132,8 +132,12 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 		return -EINVAL;
 	}
 
-	/* disable RX */
+	/* Can't suspend with WoL if MAC is still in reset */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if (reg & CMD_SW_RESET)
+		reg &= ~CMD_SW_RESET;
+
+	/* disable RX */
 	reg &= ~CMD_RX_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	mdelay(10);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 69e80fb6e039..b5930f80039d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -95,6 +95,12 @@ void bcmgenet_mii_setup(struct net_device *dev)
 			       CMD_HD_EN |
 			       CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE);
 		reg |= cmd_bits;
+		if (reg & CMD_SW_RESET) {
+			reg &= ~CMD_SW_RESET;
+			bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+			udelay(2);
+			reg |= CMD_TX_EN | CMD_RX_EN;
+		}
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	} else {
 		/* done if nothing has changed */
-- 
2.7.4

