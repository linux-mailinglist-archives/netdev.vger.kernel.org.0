Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A66240565C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359590AbhIINT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358780AbhIINJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 513D26329B;
        Thu,  9 Sep 2021 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188873;
        bh=rxqNsyf+5zOsajsG/cLOwTR5w2JzO9s+Wk3tEDzXAFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un1EnWZiRxUdXXTwZLNsxeP/EB/hhH7MMmJfrkxcJ8rEOf/Nixe64P8KUO/BJ9ixX
         yyetH6funQIT02p4wf+PWSm24dWu3nXvOiZ0u2udR21UnbiIOQm1Ci8+1kVPrQLcCt
         u+pI8eZDYBAkLTdT1YmocvXVlGyjvCBACaSgIZsYGvO+Sgl5z3fLA1ds2JZj9QhPw9
         pr2Env5o0Xyqnb72HYDpHzM+0BzIvpqlYDy3LdAUb4gcVGQzLpWYcfUlUn4e2A8MUM
         /O47rdMVPNG1WF0S23MZ+dd53ZcXlKxy9cJX1VhwctZywmhSMDyitlvgH8HmXyhbYO
         wQPMT0RAYPbTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 46/48] ath9k: fix sleeping in atomic context
Date:   Thu,  9 Sep 2021 08:00:13 -0400
Message-Id: <20210909120015.150411-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index 9d664398a41b..b707c14dab6f 100644
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

