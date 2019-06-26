Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDCA5669A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfFZKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:23:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8602 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZKXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:23:46 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1347b0001f>; Wed, 26 Jun 2019 03:23:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 26 Jun 2019 03:23:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 26 Jun 2019 03:23:45 -0700
Received: from HQMAIL104.nvidia.com (172.18.146.11) by HQMAIL106.nvidia.com
 (172.18.146.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Jun
 2019 10:23:44 +0000
Received: from hqnvemgw02.nvidia.com (172.16.227.111) by HQMAIL104.nvidia.com
 (172.18.146.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Jun 2019 10:23:44 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.148]) by hqnvemgw02.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d1347af0002>; Wed, 26 Jun 2019 03:23:44 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 2/2] net: stmmac: Fix crash observed if PHY does not support EEE
Date:   Wed, 26 Jun 2019 11:23:22 +0100
Message-ID: <20190626102322.18821-2-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626102322.18821-1-jonathanh@nvidia.com>
References: <20190626102322.18821-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561544624; bh=vGXcotllBTcL1C9r+R4poHo5wzdresdlxX353o8wzg0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Type;
        b=T0erUwKXAj4a/4jVBIK09tWghNGcEPTi5q6y0XcR3VA3Fx5TeKNTL5e7qys3Q4YC1
         ttNUp1JBs2wGzNQT+exsFZ8UKpmYqq9bOXg6T/FiYD4MzKJIxxKceg/J97adAHjHqT
         dQEZYOwTSgrV31wM/U1fAxZnd0JBqzYC2C0YNQN2owsfkm7eV2aTmwcCX7i+9Bck5C
         Ye7lLPYdLz0zYnNqZBerY8JOSBHh+kAsW9CdAPOrew14YVBCgWUoHb6Ex4bW0Nabeb
         XEZgnnjFfxuaE1NGd78cNanX4j0Sd4aJp61mbmJ0Y/MzZojPCRicmXH5B0wfzSA1e4
         0YRODa5wvo8KA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the PHY does not support EEE mode, then a crash is observed when the
ethernet interface is enabled. The crash occurs, because if the PHY does
not support EEE, then although the EEE timer is never configured, it is
still marked as enabled and so the stmmac ethernet driver is still
trying to update the timer by calling mod_timer(). This triggers a BUG()
in the mod_timer() because we are trying to update a timer when there is
no callback function set because timer_setup() was never called for this
timer.

The problem is caused because we return true from the function
stmmac_eee_init(), marking the EEE timer as enabled, even when we have
not configured the EEE timer. Fix this by ensuring that we return false
if the PHY does not support EEE and hence, 'eee_active' is not set.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6c6c6ec3c781..8f5ebd51859e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -398,10 +398,12 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	mutex_lock(&priv->lock);
 
 	/* Check if it needs to be deactivated */
-	if (!priv->eee_active && priv->eee_enabled) {
-		netdev_dbg(priv->dev, "disable EEE\n");
-		del_timer_sync(&priv->eee_ctrl_timer);
-		stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+	if (!priv->eee_active) {
+		if (priv->eee_enabled) {
+			netdev_dbg(priv->dev, "disable EEE\n");
+			del_timer_sync(&priv->eee_ctrl_timer);
+			stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+		}
 		mutex_unlock(&priv->lock);
 		return false;
 	}
-- 
1.9.1

