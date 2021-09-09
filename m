Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B840553E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354151AbhIINJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357893AbhIINFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D32563299;
        Thu,  9 Sep 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188812;
        bh=Yo1xx5wu/2PwqdkQajsx15DqBkqVN1/9NdGm4l+7Mrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS4YhgvSJ+F58M1dOrnQ0LAn0OnRAOUh4hFnpRn7Jw8R/WkSbSaqzMthfu7TJhmVc
         9trWKB3p232MZgiw0E9pFvG2CgK4USwfARecss+bsDi26yQ2THqFNe8ckaI7PRPALs
         IhErPkdgsGx5pdMZ/t1E++ysKCMmjCJ442fqObxn+lAJwwIqfyqMKfHOhQ9IPTgxL2
         hgnXm7M/iSIFibSAoA9uPkkX6Vlhsmrw9RGkCDbOPxk9S9+hM8PqmQZ7o3kMpDeOqf
         G1eOQCm1AoU6HzHUgfyNOZbDZ22kTT/P6qX6lOANuLJkzgxDx+PQ6VGIqobD3pInQI
         UrlLV/XmxCInA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 57/59] ath9k: fix sleeping in atomic context
Date:   Thu,  9 Sep 2021 07:58:58 -0400
Message-Id: <20210909115900.149795-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 7c48662b9d56666219f526a71ace8c15e6e12f1f ]

The problem is that gpio_free() can sleep and the cfg_soc() can be
called with spinlocks held. One problematic call tree is:

--> ath_reset_internal() takes &sc->sc_pcu_lock spin lock
   --> ath9k_hw_reset()
      --> ath9k_hw_gpio_request_in()
         --> ath9k_hw_gpio_request()
            --> ath9k_hw_gpio_cfg_soc()

Remove gpio_free(), use error message instead, so we should make sure
there is no GPIO conflict.

Also remove ath9k_hw_gpio_free() from ath9k_hw_apply_gpio_override(),
as gpio_mask will never be set for SOC chips.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1628481916-15030-1-git-send-email-miaoqing@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 933d4f49d6b0..9e3db55a8684 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1595,7 +1595,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
-		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
@@ -2702,14 +2701,17 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
 static void ath9k_hw_gpio_cfg_soc(struct ath_hw *ah, u32 gpio, bool out,
 				  const char *label)
 {
+	int err;
+
 	if (ah->caps.gpio_requested & BIT(gpio))
 		return;
 
-	/* may be requested by BSP, free anyway */
-	gpio_free(gpio);
-
-	if (gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label))
+	err = gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label);
+	if (err) {
+		ath_err(ath9k_hw_common(ah), "request GPIO%d failed:%d\n",
+			gpio, err);
 		return;
+	}
 
 	ah->caps.gpio_requested |= BIT(gpio);
 }
-- 
2.30.2

