Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44337405374
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355808AbhIIMw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355101AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2EA461BF5;
        Thu,  9 Sep 2021 11:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188500;
        bh=b8uqT+IdXHTCWdfTeDRGw60YPedOurUWpACJtIdz0jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4pnuuYyWvcvwXDOYHJ/bG4lq+23Uadhtatwnix1+t+R1wEfpZQXZrneizMAm8sGQ
         o3WDVN8xcMzogYEfsaadcdWvNHFf75UK1TciBEw4SepYAskK3lMH4d442DP5GyaEuw
         oPeqEg5TwXILjDpD2I9Wa+Cod3uRkNgETBCl0D6Yi+flwLYDSjmON6ZbBmk94VucoU
         DGWGYS7HnuVD0j4F6e4MSHTOapaLfWPW/jqAKlOc56C+hMjEtSoke8oqqA6L6MaG/0
         CnePoQCXci5IRzFXCdjSl8DS94NqfnZC69kBv5amrV0EYwf49CArodAqaouyEuUt5f
         f4j9LSxn79Wvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 172/176] ath9k: fix sleeping in atomic context
Date:   Thu,  9 Sep 2021 07:51:14 -0400
Message-Id: <20210909115118.146181-172-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index c86faebbc459..6b2668f065d5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1622,7 +1622,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
-		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
@@ -2730,14 +2729,17 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
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

